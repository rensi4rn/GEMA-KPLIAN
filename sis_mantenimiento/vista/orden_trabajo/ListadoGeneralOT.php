<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ListadoGeneralOT = {
	require:'../../../sis_mantenimiento/vista/orden_trabajo/OrdenTrabajo.php',
	requireclase:'Phx.vista.OrdenTrabajo',
	title:'Lista General de Ordenes de Trabajo',
	nombreVista: 'revisarOT',
	bdel: false,
	bedit: true,
	bnew: false,
	constructor: function(config) {
		Phx.vista.ListadoGeneralOT.superclass.constructor.call(this,config);
		this.init();
		this.readOnlyGroup(0, true);
		this.readOnlyGroup(1, true);
		this.load({params:{start:0, limit:50}});
	}
};
</script>