CREATE OR REPLACE FUNCTION pre.ft_partida_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de presupuesto
 FUNCION: 		pre.ft_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pre.tpartida'
 AUTOR: 		 (admin)
 FECHA:	        23-11-2012 20:06:53
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_partida	integer;
			    
BEGIN

    v_nombre_funcion = 'pre.ft_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRE_PAR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-11-2012 20:06:53
	***********************************/

	if(p_transaccion='PRE_PAR_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pre.tpartida(
			estado_reg,
			id_partida_fk,
			tipo,
			descripcion,
			codigo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_partida_fk,
			v_parametros.tipo,
			v_parametros.descripcion,
			v_parametros.codigo,
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_partida into v_id_partida;
               
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida almacenado(a) con exito (id_partida'||v_id_partida||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_id_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PAR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-11-2012 20:06:53
	***********************************/

	elsif(p_transaccion='PRE_PAR_MOD')then

		begin
			--Sentencia de la modificacion
			update pre.tpartida set
			id_partida_fk = v_parametros.id_partida_fk,
			tipo = v_parametros.tipo,
			descripcion = v_parametros.descripcion,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_partida=v_parametros.id_partida;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_parametros.id_partida::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRE_PAR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		23-11-2012 20:06:53
	***********************************/

	elsif(p_transaccion='PRE_PAR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pre.tpartida
            where id_partida=v_parametros.id_partida;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partida eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_partida',v_parametros.id_partida::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;