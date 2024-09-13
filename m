Return-Path: <io-uring+bounces-3185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 632969776BA
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 04:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D49B91F2673A
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 02:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90F21D12EA;
	Fri, 13 Sep 2024 02:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eaAQKcmV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YduR7ENS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A583EAEB;
	Fri, 13 Sep 2024 02:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726193220; cv=fail; b=h+kYkRq4qEyC4+tqWwfYdeHOv0VvupNQ0AWxstmZozD5hL8yi7Ud+5frH/tcIh0pPnY+cardOH4ukTU9sfCf/xyKJK0a+HzUNwL6Ohc9ryMHY9c7McjCBFfx/8PUWlt9Un4DYQWi9Bl2dRca0RiLvnvY1L1UM4GPg6yM5r7WC2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726193220; c=relaxed/simple;
	bh=0u0Jl1gEMVLLvvPzZ1XB/OYar9O6StoHCz1OEPWnykM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=h/XLj0lO/HkAJX7x2/cFOabrkXHnlnUaEdQt44YfgqPmpt+IUpScXxre6Snr7hWxwCh7XhAOMNE5MEjX7ZwHrBSx90dxGrORSD/OJ0/Fv7qTPq8m8qSdJPnNDOCfVJek6aJ1dLPfSMU9zWYBuRqQsthATigERi9KNYLgnbh5bzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eaAQKcmV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YduR7ENS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYY5021202;
	Fri, 13 Sep 2024 02:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=q/pCpoXTNIgP4J
	l7uTCtJJrCzwd5MQuq6qw1bTcSSzM=; b=eaAQKcmV88EiaO2FSxa/Daavi8C6VD
	eWSGpDAZ+rrQQuAIGHcngSWSgck5pXLP4Ps7Khy0vgCYL1o4DzHAQvAV55z5gh0+
	X5TALgUQpnxh/Dp8joHN4WGCIPOWd230DO5nVHZx2q4r1wClxxN/0IrlG+W/Z157
	fv/3E+nKV3IweC7JSALlAOYqSo3GdsLj2MtERky4YxcU4IwwyrtCYCk95DkPiG26
	r0pvmqCVqXlC0LwvCcJ/wwK9mHekiQpHNqvSp0gjspHBjg8O3cUW1NVdAaFmBEQ7
	4KLOUMF8sSPTz8EQr4wbZ5TP6W+abotgU8Wkfci1t4z6R2OWSIgJDfTg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctmbbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 02:06:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D1QA8t034134;
	Fri, 13 Sep 2024 02:06:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9chsdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 02:06:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sa9mVFv0NoKQYfkEvNUS+ETirkX5hW/oMPEXW4L4jO8C1Hud+xW+LXp1ahQw4fZfgSyjKIqW5v4p3GZDK1gDdqjVBc6GJNmXt7O3ZrtgLFN85sYwASQXXS/B6eUkzXTslIDNSWKWx3ENX0NE3E06885V0e7Cwb54V0ag4u0mGIIod28nCEyrXrw4tiNJJejOTyAa7p6UBTgf7uMx3kwOogxA+ylnPJ/w0+inKQPDaA/GA9je4esYoY3l93m+DryPMRuq3bLgT6LnAm3u0jGHfsvEPwri87PSbY0QjI/WS0/ti3+wm2Jh+ESQ3dEE4hTrIcpXRg6BbSqS+Uzx1223vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/pCpoXTNIgP4Jl7uTCtJJrCzwd5MQuq6qw1bTcSSzM=;
 b=ENtL/C2FMj+sDpVvekwGkWcjBpavOqGRsndc4Fc9O58DMdmWgg+aR2LYEaYLxj5PobDF/yagGWp9b7uoed1ibKoSmX68BbOdS4UKb6ijnggMnm6OJhUSUGxQqDof+9hbCXhooxQOgoU0On9PHeVLwCq5a1NELMi6nFGzQiLGuNTqyFquTOqivrFFoPywyaLVmzaLHjFs4QrjoDQ5NhPs+pOFsM8aWfoj/2m6aE6BBmzpuF0fGgmyJdGXpu5qeV8Jv+9YDM7XR67AaS4KytCgMhnq1DMSr71WA4RdXFoS6BIHkaUCSgKKGuOVtfNxKAbHTCtExQfk29M/C1l3j7Ubeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/pCpoXTNIgP4Jl7uTCtJJrCzwd5MQuq6qw1bTcSSzM=;
 b=YduR7ENSAcspp+R+ROqBYOvzpWW7mmVTgNA1CK6WFVf0Kt6G394jt5YiG5GTYZEXDFT2blnx21mkaQgaEVNEyvS+rXEpz3q0mnkHfOXH00qdWEZCT94PV4auGe+s50MMHoqaeaSeE8gCePsLpstaCnsfh+ig3WOlVJI0mtUnCKw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6146.namprd10.prod.outlook.com (2603:10b6:208:3aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Fri, 13 Sep
 2024 02:06:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 02:06:40 +0000
To: Anuj gupta <anuj1072538@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kanchan Joshi
 <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
        Anuj Gupta
 <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
        asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CACzX3AuX9FkxPoBRLmy_HEmu6Ex63jHLyz9Z8fhUd_Y5_MdJyw@mail.gmail.com>
	(Anuj gupta's message of "Thu, 29 Aug 2024 18:59:05 +0530")
Organization: Oracle Corporation
Message-ID: <yq14j6ktij8.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com>
	<20240823103811.2421-8-anuj20.g@samsung.com>
	<20240824083553.GF8805@lst.de>
	<fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com>
	<yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
	<CACzX3AuX9FkxPoBRLmy_HEmu6Ex63jHLyz9Z8fhUd_Y5_MdJyw@mail.gmail.com>
Date: Thu, 12 Sep 2024 22:06:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN8PR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:408:60::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a4cc75-4fa3-48ce-92d6-08dcd398b52f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aoob32uYvtNLasc5sj0bsIGsExBvsoqBXlZBKF9NhvHcVYeCe9UwkrM4HVQM?=
 =?us-ascii?Q?RKfDZ/Wfbtp2Bqpf1Hnr/zJOg5ybQy36cDt+lIWGLBpMyLg9jOFHjx8XFQIm?=
 =?us-ascii?Q?E2E9pB9jxCcQIqXzsD1tgEH3KAFVXzCrifK30P10h4Cn87ZE6KutxXKpBitu?=
 =?us-ascii?Q?beIlWAfgeXbTdfc/xeb/NsDlvBXMbOgq1Mq/qGnhwjpMooZh7v7vOlOqWOG9?=
 =?us-ascii?Q?GNQG9OInr7XOIZ92CkY/H08nP63CxYG11B11peUT+KTmMFjeW5pW9sWMdoe2?=
 =?us-ascii?Q?frv69PFFHmX1FvxiA7Vq55pRWdBMxZrqpU3nXfL6+LGReC2FJLDisisIXHcj?=
 =?us-ascii?Q?I6sOQ0JS5ki70DAy9oDKlpVNfrQPNBCuSsroVyEe0ebO5aYW10IP2/5cioui?=
 =?us-ascii?Q?9XBrotb9JKtgt4gbuoWZy2bOlgmK/BOvvLPkx/rRVX4M5zUhRRDfjIjhLOIt?=
 =?us-ascii?Q?N4kxnwHZpgVE23CeOfgIpDpBdVktwFMJbLbF6Xqsqt0dS0/fe0ot+/ZSAQHr?=
 =?us-ascii?Q?HTa6gcI5OWMlkdu9UzQx4WIXlPHMIb6YFiMBFm63bIUiqgaYGcyOljajnCl5?=
 =?us-ascii?Q?aXIiuKvmIfkV8ZqDh8xtU7I7No853hejMTBhSRT111iD1BeYP7bWU/32LXVq?=
 =?us-ascii?Q?jJdF1xj67mmLQpBwk/rw7Tm6dr+YUTcscbBPxZBUzyaGfSx3XROdKjpyBX10?=
 =?us-ascii?Q?nPLbZ/3g0HTB4YCLdhRkeZlo25T8qZfA+b7uf6ikBAqApVzgNcYiOK0LymDw?=
 =?us-ascii?Q?3Y46xILb5aDiLAMQMpm4YFvUyU32PebMelDh2GzNqGgkx/BvaiQuA6hT+Fje?=
 =?us-ascii?Q?SBS/f8CvVkMddPp9S5wTiZzdQ3XO0vbM49vSXO4FklRtkpdURabS5wzK5MZk?=
 =?us-ascii?Q?YKn4dBZlX+buIxWQrA6u7kOnT31135pBrXzKgBrhOJTZqs9yzWuGJA0fthlB?=
 =?us-ascii?Q?lzN8Nd8fJJkGtblVWrIL5bJgQkSJqh4W+KKP3iTjNUCWxRzrGdE3P7wfud+C?=
 =?us-ascii?Q?CAglx9DEWqZbC6a8tXVBol13+AQfObEY6XjvCgYUJ60pGlyUp3xdhuGJUp9r?=
 =?us-ascii?Q?iI1lnf9o8H3XyYU1qQrGWKH48I/NK4oZxj9pGl+zk3PckBCGJVs2Kr4udulm?=
 =?us-ascii?Q?r+otvcl6adye2D9etF8yv2OHhmxtTQlYmh7N35hosBTlTmrA7tdv9zlUBX/P?=
 =?us-ascii?Q?mttOj7UzXTnOIIrpdBbcr0BTpYzBMJSshZO2fk976J9TKgQJhKzvlCBGH8Xc?=
 =?us-ascii?Q?B5YXZ+DncbwVBocRMukJajPQeLXwD+ck9/dY6kssfm7YA6QaBDO840l/xtgN?=
 =?us-ascii?Q?wSgRiA/4CM66gHxDTtL42FHCilofza+dkaJxJnyMGSej4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OIX5AXJSMpApaHgy3bKopssAM7VexuG7DY88tpPHT7X/DgFiIKrRWTeLf2KD?=
 =?us-ascii?Q?wNAbNLrhxnmFfe3l3ZoVziA0w1hla5GL57KhycpNMZOcbJl074joKm1Q/fzJ?=
 =?us-ascii?Q?T8xRscQ73rEgqiDpfkRP4ldgUoRV5ORcFYeN5GV9QOMZ5b9D86RHMu3LtTtF?=
 =?us-ascii?Q?6kNAslgF3vtbikOL3SPvFDWh6xDDZfNlf9oH9FMULjd0l9GyaKePOAZvdRKl?=
 =?us-ascii?Q?PYL8hYEyHaZ98b+pRh0a0OFd9Lp4ay44bhSuua0WEp+4mzTYoWDt3TchkZXV?=
 =?us-ascii?Q?+I/EvVHVToIROYgzE4gD/NIX+Q0Gp850TSMfNmSgc06bQn8pHObuZ7Ysx460?=
 =?us-ascii?Q?OfzY1gVDRric9+H+FolZHm2x6iDoH+el8XPSCFrjQHCI/R+xCxeU4SroFdFI?=
 =?us-ascii?Q?34QneZO3TkfOAd/coIZh1oyy0eWfNzmqcQGDcWh3PZSBCs8qwNy2dprEVjsm?=
 =?us-ascii?Q?FUL1CJi65b4XGNlwh7dqFSX8ve+AAGZfCSyiVDiAyLMoFM0UyLw7ecabiZAc?=
 =?us-ascii?Q?GGagAUQMUkxcVegEJGTFAs14dyL6zjDql1XPC+RUdV/eEhlgbU75GwmHW0G7?=
 =?us-ascii?Q?wp3oQg+zolzMbdxcV+FpOH9O9pZpivZ0IdMOR89Z5jPFs87pJJmw/t9A+yee?=
 =?us-ascii?Q?u1iNt6eZliRCHym1qf8qkU7ZVpth2gq/tKI9d/dXqgVXJre0wYiCS/HtCLuI?=
 =?us-ascii?Q?7ZQqKa3lHZBNCKjafusBpOnRi0MlrhRGiMKnJDlePcwmVAvxvlkiY28WBumU?=
 =?us-ascii?Q?ezF6+qDu2rqeBv+34w1pO7YEFtpFjps4wsyC3Gt7okfrozUoMe/A+RsfYxNg?=
 =?us-ascii?Q?6xvYOexT1pH00gn24irAXoKiO1iU15FOPIm97pxyEKPkiHHxHVFLuLI2M+Jd?=
 =?us-ascii?Q?utM2Bmu7gFcD6I/xtPjEKd5bbzx7mB8kZMRnL2kdcNIvf3J3MxlzD8/V0aMX?=
 =?us-ascii?Q?AqSWBQhrMAOJ4cPwQCtXniS8hsXYnQjIdSRK2CBNPYf4CUx/F3bM+LYj3kdS?=
 =?us-ascii?Q?5GcPOHxA6UVn8y+78ExjYuEPKX3Vn9tBejEmUN7aedLzgw2X7VDKnpchNxPA?=
 =?us-ascii?Q?ut5mE5+QM5YwICdWP1nIgIonxz/Q5FzFtfPTB4soSzmFtzcKzTl2YKzFpba5?=
 =?us-ascii?Q?2XWTo4cU5HWkSlvya3KvuiL7Kly2zlgQ3+Y084u9cLx80ZUvnvPF8zOSOaNK?=
 =?us-ascii?Q?Q64tgkk6odW1J7qYsJKcBikXDy3nc9gb9czi54mbsimRNM1oYo6LT0iFlYip?=
 =?us-ascii?Q?G9W+WhvRpdf/zcGi4hYOokFPslhOG0yoL0JSpn1MppKYSFjOxiIzaer5+TRa?=
 =?us-ascii?Q?LzydLRz0TOihsFrCUMyIfq8P9J2epCBGy5dEaxGPXFd+hNmBkmjq9wj2Hvwx?=
 =?us-ascii?Q?QcGh3wQ7CQn7kjNplm1hAuReFDvKJSa0TezrMfuYJ9mvrnXH1mOPLMVI3LHJ?=
 =?us-ascii?Q?hvds8rPYKCq56exz+oVbqVp+0WbxxzEH8RvibT+DdOUxQrRSNG5DxuiSMcFT?=
 =?us-ascii?Q?NVf00cj619jgY0BCLm3oxAyOt3uTN2/jLTFpmh6l57qP9Uwo2pXo/euIvI5n?=
 =?us-ascii?Q?t90AE5iG9ce0K4NDrvUAXoNVbURUv65TDODwUnkt1J0Uryw3XiF2y27twE2t?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WbGXItyO3Ru2EpcBmkCSKM+Hvw92nnEBLGRielrK2+Rh4GlzhyN6XhTAaKCzKS9VLx/GfgANAxzZFtkZgSprJxtwI/l95NmdKCS9V0DnQduDaxaf7MptoXKVVcNirJ1Xh7OMd5TQxb7NOeA/pKTFkIvQJle8rL5gXdD1JAolq3LEbFbHTtyaex5C9hwocoyLOkknWMHExViaIlhtl7+mbK3eBUcCuRW1wfwLoeWihNl2TxDfosWV4lwUyMagu6Kn/VgDN1IlloLO8bfV60RyUPYyNRU2hYCj0jaldBbltgYBrCvl2ON+4u/HOZav/z2wZMaJlfHi+/Ut2cBauRffe+xNsTb0CmsnY462J6+7IK61vi1dso5biHuB6kA53jxfliZe2W3jbeZnFAgcji1ka2pf45wQlske/MPIOtyNVxJq9BUGW1B6kpsMldNVFwb21LiX7gn8xyx2WWXftJg1SAMgHUyAVRE8cwcdo83PRjpY8XluvCAJ7cUU5wB2ykQ+dBPy+CHLzXlE7uJyKVJY1//t9Y5Bm6PTWyMaj9G9oZPNHiH5zUnFn+4KU6CAd+npQ7soBYOXuYpVOXTk5FILZgAZwy6nO6gmKmiLCS42aZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a4cc75-4fa3-48ce-92d6-08dcd398b52f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 02:06:40.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKOrKSM7sysjVTI47QchSqcEz9reiQVOZJyxDFdUxdmKcTmwx9O9LGjFYtkvKRq4krh5TH25fInmw00KLoXP5slhFYM9ehv1LJiK+7vQ0FU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=796 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130014
X-Proofpoint-GUID: L9zUlaTRNVTm21u7cG3tiyBEvUekZ72C
X-Proofpoint-ORIG-GUID: L9zUlaTRNVTm21u7cG3tiyBEvUekZ72C


Anuj,

> Do you see that this patch (and this set of flags) are fine?
> If not, which specific flags do you suggest should be introduced?

The three exposed BIP flags are fine. We'll deal with the target flag
peculiarities in the SCSI disk driver.

-- 
Martin K. Petersen	Oracle Linux Engineering

