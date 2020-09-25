		DECLARE  @DtINICIO DATE 
		SET @DtINICIO =  FORMAT (DATEADD (MONTH, -1, CONVERT(date,GETDATE(),112)), 'yyyy-MM-01')
		

		-- lista de lojas
		SELECT 
				
/*1*/	 dt.Dt_Mes						as [Dt_Mes]							
/*2*/	,COUNT(F.CODIGO)				as [Nr_Registros]					
/*3*/	,COUNT (DISTINCT (F.CODIGO))	as [Nr_Qtd_Funcionarios]			
/*4*/	,f.NOME							as [Nm_Funcionario]					
/*5*/	,C.NOME							as [Nm_Cargo]						
/*6*/	,u.CODIGO						as [Cd_Corretor]					
/*7*/	,F.SETOR						as [Cd_CentroCusto]					
/*8*/	,S.NOME							as [Nm_CentroCusto]											
/*9*/	,J.NOME							as [St_Atividade]					

				
		FROM vw_calendario dt
		LEFT JOIN Facta_01_BaseDados.dbo.FL_FUNCIONARIO		F ON DT.Dt_Mes BETWEEN FORMAT (F.DATAADMISSAO, 'yyyy-MM-01') AND ISNULL(FORMAT (F.DATADEMISSAO, 'yyyy-MM-01'),'2020-09-25')
		LEFT JOIN Facta_01_BaseDados.dbo.FL_SETOR			S ON S.CODIGO = F.SETOR
		LEFT JOIN Facta_01_BaseDados.dbo.CORRETOR			U ON U.CENTRODECUSTO = S.Centrodecusto
															
		LEFT JOIN Facta_01_BaseDados.dbo.FL_CARGO			C ON C.CODIGO = F.CARGO
		LEFT JOIN Facta_01_BaseDados.dbo.FL_TIPOFUNCIONARIO T ON T.CODIGO = F.TIPOFUNCIONARIO
		LEFT JOIN Facta_01_BaseDados.dbo.FL_SITUACAO		J ON J.CODIGO = F.SITUACAO
		
		
		WHERE 1=1
		--AND F.DATADEMISSAO IS NULL
		--and F.DATAADMISSAO is not null
		AND dt.Dt_Mes >= @DtINICIO
		--AND dt.Dt_Mes <= @Dt_Final
		--AND U.ELOJA = 'S'
		AND U.CLASSIFICACAO = 2
		--AND U.CODIGO = 1405
		AND F.SITUACAO IN  (1,2,3)
	
		
		GROUP BY 
		dt.Dt_Mes
		,u.CODIGO
		,F.SETOR
		,S.NOME
		,U.STATUS
		,f.NOME
		,F.DATADEMISSAO
		,F.SITUACAO
		,J.NOME
		,C.NOME
		
		ORDER BY 
		dt.Dt_Mes
		,u.CODIGO
		,S.NOME

		UNION ALL

		-- lista de comercial
		SELECT 
				
/*1*/	 dt.Dt_Mes						as [Dt_Mes]
/*2*/	,COUNT(F.CODIGO)				as [Nr_Registros]
/*3*/	,COUNT (DISTINCT (F.CODIGO))	as [Nr_Qtd_Funcionarios]
/*4*/	,f.NOME							as [Nm_Funcionario]
/*5*/	,C.NOME							as [Nm_Cargo]
/*6*/	,''								as [Cd_Corretor]
/*7*/	,F.SETOR						as [Cd_CentroCusto]
/*8*/	,S.NOME							as [Nm_CentroCusto]											
/*9*/	,J.NOME							as [St_Atividade]
						
		FROM vw_calendario dt
		LEFT JOIN Facta_01_BaseDados.dbo.FL_FUNCIONARIO		F ON DT.Dt_Mes BETWEEN FORMAT (F.DATAADMISSAO, 'yyyy-MM-01') AND ISNULL(FORMAT (F.DATADEMISSAO, 'yyyy-MM-01'),'2020-09-24')
		LEFT JOIN Facta_01_BaseDados.dbo.FL_SETOR			S ON S.CODIGO = F.SETOR
		LEFT JOIN Facta_01_BaseDados.dbo.CORRETOR			U ON U.CENTRODECUSTO = S.Centrodecusto
															
		LEFT JOIN Facta_01_BaseDados.dbo.FL_CARGO			C ON C.CODIGO = F.CARGO
		LEFT JOIN Facta_01_BaseDados.dbo.FL_TIPOFUNCIONARIO T ON T.CODIGO = F.TIPOFUNCIONARIO
		LEFT JOIN Facta_01_BaseDados.dbo.FL_SITUACAO		J ON J.CODIGO = F.SITUACAO
		
		
		WHERE 1=1
		--AND F.DATADEMISSAO IS NULL
		--and F.DATAADMISSAO is not null
		AND dt.Dt_Mes >= @DtINICIO
		--AND dt.Dt_Mes <= @Dt_Final
		--AND U.ELOJA = 'S'
		--AND U.CLASSIFICACAO = 1
		--AND U.CODIGO = 1405
		AND F.SITUACAO IN  (1,2,3)
		AND S.NOME LIKE 'COMERCIAL%'
		
		GROUP BY 
		dt.Dt_Mes
		,F.SETOR
		,S.NOME
		,U.STATUS
		,f.NOME
		,F.DATADEMISSAO
		,F.SITUACAO
		,J.NOME
		,C.NOME
		
		ORDER BY 
		dt.Dt_Mes
		,S.NOME
