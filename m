Return-Path: <io-uring+bounces-1243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A55988E70C
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 15:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24A82E5F48
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 14:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910BC12FF93;
	Wed, 27 Mar 2024 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E0wxYaPi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s/W0wo4U"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C29912CDBF;
	Wed, 27 Mar 2024 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546718; cv=fail; b=qzalFh9xUI1o2Zad6YxfP/WdP+BM4zLh34Lgihr5iHric+GNLlRwIF6cj815xputLUhBJFlFfPkeFHUYevduv7XLcT1s+F2L7VFm8hrrRJO+iY5ybQjq2FivWZ2j3R8gV8CKZNKMAbsR43Uppa3Hq/QgJdeNlBaQwd8Qkm7Cv7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546718; c=relaxed/simple;
	bh=WW5oqa5HILUtqZjpp1IWEHLa3MFVSorm5gh04dLU+hI=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TTBB7vInvg2Ji1dLOiqwt28TcudaSok6nQwGK3izZdv0ILfC9x7x02M/utUXj1wj0IQhm0V1eBgNOxFCJHuHJ3H+uUsBtcvgZJ9AVf28wFG6fcZ4CwLKALA6qi4IO5uqsEGTwy7gsijoTg6/xHc3wTvVSevtoeqVaBeMCT7wzVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E0wxYaPi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s/W0wo4U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42R87UtE019724;
	Wed, 27 Mar 2024 13:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=+R41x3eQNwL55LS4rakPFi+Sk3DyUU33TMg0ekD9quc=;
 b=E0wxYaPirrY7HAxfxSiDktmdiN+RVNks9qQ2BUpB+x2Vm9EZqucJXAzE1+F7sOiyRuY8
 w2Dc2Q+qpCZ5pDIPEjrliaI0R9VXcys4GCmCZ9WHSqV+4+0CuSMQrltq4fIgaciZWnlQ
 jPJYZjobcntiol7Hbyi+ESTGIeQE6+jkoWl+EfKIEs/Vx/s6LaLtQ/f0NYeWrJxJ+3wl
 FNd6BlBSvyiHbox5ltu/yKXOwjdsy/Io/GCvb95Iaz3VSS3zQ7gla4TAvZlK9zecwq83
 JWhJ3zRxyEah74g5SGz556Bq1ZadCPiXc8JfgPbxS9wEUVqPZgTzcYhjppHNY5rsP2F1 7g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gww2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 13:38:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42RCPWe5012873;
	Wed, 27 Mar 2024 13:38:02 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh8fv60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 13:38:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQoVJEsWDAg0knH4in+w4ECOiIZA0wxBPVzL3F1Ajj49LQAiyxio823DZxX6CEUGXIJVcDW9VHSoXxlQn1PvdYj3cw5MtvaNuiZrolVf5ZR8opYpS4/YmICPLtWOyv7Gt6U570TitazoVrwm8zdmlR4CeRu72jzr8cR54ChHBTuSe1GmQyIR5PsdgDW/1kJrJTG/GzzgNViFUX1EBskLKhbUEN21oydpKw+fuGF1t+J+Am0vaHxW7v4Xq9MXpcznwbpvGW6gLHEudkVu3ydIchKotWKUJSToUnQ7hARexVNNNzLaJ/yIdCBrP1To6bmjIZVayRrKCw+x4xcfRt7G4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+R41x3eQNwL55LS4rakPFi+Sk3DyUU33TMg0ekD9quc=;
 b=NQzwm4aTkYOYWpreuKdlPjQan9BE68K2nmcPZdVkp6eU9pTG7wVnquH8Tb7+D+QcS7XXAAwg0o2aiHjCx7IZol+IX9EGYAer+FMhljjEtVh8ctx58t9E6f4CcP7Gf4a6zNp6baXEJ9G9ZmFEuCNqP0nuersq1pKGzCqimGpVmZUHz7InXZauIMW2PqJ2i8GL5JzN652UPxQptFQ1UZTWt2s6QeikJO0jiFMrdpVp1M3iVOAV3E3zzOGe29F0mK+Fpl6rdL/T73Om1nCp7aJXdVfy/4Jf7m40lJX4icW93+ce4NYKE3UxWWNUwQR01cej48m9GSCerHowDB2y3QeCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+R41x3eQNwL55LS4rakPFi+Sk3DyUU33TMg0ekD9quc=;
 b=s/W0wo4UX/H8QLgnEPkAbo6rh3Nq+O3/Zdqff/UGxAHlHcrlPkFCK+gOG3asnaNsRtFKHmAXPDIGVH7Pv4O4Q56/+fiJ9DQwrEjAIDOIXWmoOKGH2Xvg6YUYquuGbX2xrRG9tuQ82ZOKYOqs6+GSuU8WvKKA3PD7p3rBAhSxBDc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7800.namprd10.prod.outlook.com (2603:10b6:408:1f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 27 Mar
 2024 13:37:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 13:37:59 +0000
Message-ID: <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
Date: Wed, 27 Mar 2024 13:37:41 +0000
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v6 00/10] block atomic writes
To: Matthew Wilcox <willy@infradead.org>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <ZgOXb_oZjsUU12YL@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0192.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7800:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c9f5d6-5431-412a-9f54-08dc4e631e10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Pip7R6IXbNjvxCWuRNrPCuTPhEfDfAdctcig4gZknIq4KRmeQ5wNDKlS8+/SzfQntx0wsKLvBINtINti8x5to0g50CxDc2Qwrr5OzVaq06CbbGiA/HEdATBCw6MyxBz/K+u/uhT5c4XFrCox9lL/tjfpuKrOX1MuAFNR1qXpwSXO89QZVvdiFhmALZFnIZe7RCoe+Skk4ApLoJBl/t4TbRw4N/R1+yEYVEj/ToRiQdChNyaYO2JYK5YL7BuIP9AMf0LJ9Z/hwpXg+oyl9eKsoJQMYfMGHUrd1gj14n9ouJ+TBv5P/yG53zTT0QvqSNN9EvuSVxEhngklLQEHuZBkYIvpuhd48DmKHxyvJnVZma6R1d56Lm4InntSKHvWxaG/dsrR8EVhjlfDV5doELQZzCHBZNmoqiEGuXQtJYpMmM3V1xQJOJ8yS6prDq/XApK/5vaYJ5l03VzKYaFwa44uCvZUvXUqM8EhDmFMCrCvkrRfN2t1WoZbr5ch3B/O2GJz+hugDT6WI2MQSt2thfV5hOPTIEmrJ8A4KVqDIaes37rHD+oL7Zst7bZ8l2p4zD+zmDhjxyfoUVmK3IY+jYzvWPfgvjyLELrCXcqp9Ld6YlQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bVVNQjcwK0FJZ2EvSUlBeFNBdzViWmJ3SXlwYXJDdVV3Z01EakliRW1BSTZ3?=
 =?utf-8?B?SlR5U0kzbVdTSnpnTXpwYkdxMWtvTnl3TTVkWndqUGZ2NExRZWZ0NjlhZWpq?=
 =?utf-8?B?c1hHVlJ2M0VDY0hDNnU5cE4vY3o5TSs1ZnNvQm1SWnFwV2ZBMWJ3QlBCUEpw?=
 =?utf-8?B?WFFaRE9IQkNhaitZZ3ZHbExEaWtjUjRBWnVxU0ZvdjVkVCtnSmUzQ05LanBZ?=
 =?utf-8?B?Vi8xbkh5cFdwYkR4Q2hGdld0bG5Hblo5TWVhN0xldVhtRDdHSndJanA3a2Zy?=
 =?utf-8?B?MVp2M08xd05iSURYNHlWWFhGSjl2WW5CelE5dGI0MFNPbWZicWdCZ0g2UWVq?=
 =?utf-8?B?aWxlVDQ5RXpJc3dPNEpYMno3RmZmcEtoZ2ZhMGZidmhhWk1CM29PaVIxQkcr?=
 =?utf-8?B?U3YvcDB5ZkhRaEdFTy9FZEZ6dXNMV2MwUC9Sa1p5TnFvbTh5UExYVFhwWmFX?=
 =?utf-8?B?c2pGU2N0RlhCQ2xPVVlOcHY2ZE9FMHkwK2VBUk9LNm9ObWZTN09Ycm1VeHVm?=
 =?utf-8?B?a0h5dkQ0aEd6SlFGMWRTTUpNNDhVaWFTeWZCTHZXM0N3SEZ0ZWk5dkN3NUxv?=
 =?utf-8?B?Zy9RQTdLVDhuWHFudnlaU0I0L0FGNm9rZDNGV2VhSXJzM0w3a05sRDZTZGgy?=
 =?utf-8?B?OE5nbzhvOFpOY1doRUZTQnE4cTcxUnMxdDh1bzhSZ3BEUk9XbzNGUlM2NUwv?=
 =?utf-8?B?SSsrcXhxN01RT01kci92SjJhTjFZTDE5ZVo0MXA1a1RVd2l4amxIZWpybDhr?=
 =?utf-8?B?Y0FwQjlSemhUdFc0WnNtc0x5ekwyd3Y1a1hWSVp4aTdubVdXQVNjaVlhRXdl?=
 =?utf-8?B?RURvbDNNend3US9XUnBmUXY0R3c0eExGMXBuK2NFUHdZTVd2QjkzVzg2bXFt?=
 =?utf-8?B?Q0dDWFlReGZYY25oYjBEc3RGMkJ1NnZJcWZScXpubzNzZDJXRGpUc0dWT0pY?=
 =?utf-8?B?NmR2b0tHdFJkNC9zYlZSVGZrU0FyQzU2NDRadXh0T2c2UEpiRGtOQU0zS3pm?=
 =?utf-8?B?VTlXSkVnUzFoeThrNFNMNzdlalNPK2dsZVRJOWdvQTA3RzIxM1lZQXZ2a3F0?=
 =?utf-8?B?TzZHVDJ5UDhzQXQ2YmNDRS9FbTFUMG8rNFRvZEQrU0dlZklYSEY1YlF5QkQx?=
 =?utf-8?B?WWRIODlZaTNnalFJM1VvTlc3ZGpScWRHeHphaTFSLzZTS2s4aWtiY1RNc2sz?=
 =?utf-8?B?YStzRE1ERUY0dCtNdWFnRGxqcnU5Skh0elI1Y2RLWHQ4R2FJb1dHV1VwZUZZ?=
 =?utf-8?B?V3Jid0ExSDFKNlJVSjdPYzNZOGNjYUhlcWFqYU5yWFROcStjS0IxRHdtYmc4?=
 =?utf-8?B?SWRycDlsU0NjZG0yaTkra2paQnJJSmZ6OHVjK1pGVHMvcWI2bmVkWG9DRllv?=
 =?utf-8?B?eUlaaXEwN2VQYWZiRnF5cXhzaXdRbXhJVUtKTGhsWWFIaVRCdlo3bzJoRE8v?=
 =?utf-8?B?UjFyUmlyei81Ly8yR25IRmJXeHFEckRXL0hxeGwvNmNZR2FNZmhhWXJaaEcw?=
 =?utf-8?B?NXJQTEhBWHVKa01tdGdGcEMrSUNPVkg1aDFWbGRkU3kweWNEL2pZbTZlZjRR?=
 =?utf-8?B?ZllwTWtEWm4zOWtwTzdDM0FVcWMxSkZUQlJuSTJYL2lOOFYySXFGNXVicTBJ?=
 =?utf-8?B?MHRrZmJZYU5HVVdRSVJReURiQzdzcFlKT20zYi92bG1EYzZHTTBkZ0J0eElS?=
 =?utf-8?B?VHY2czRBaU40K0VrWWFiRHljczBRSnBzK3dlcU1WUjNFZE5DMTJRRjgrWDV2?=
 =?utf-8?B?WUtOa2NVNWVsNVIvVXc0QTdVRWsvQS9EeTNDMDJiYlZXVXAzNzF1WDRiVHNJ?=
 =?utf-8?B?MmtESHhZeUgrV2JqZkVPTGxjUXlFNVFtckthbE93TmZDVWEyS1EvMEJUOEc2?=
 =?utf-8?B?ZDRMa1FPbWtKeU5TREh6eURER0xYcUhYbFlvbUlzc25MYlN2RDh6ZS9jS1FG?=
 =?utf-8?B?RERqNFBmWEtXK0FUTlo0Q1ZMcCtxTTFpdHIzaVVoOTV0azJoeDdGU1p4KzRo?=
 =?utf-8?B?aXd5OEdLQWRjMHk0MmhlZDQvSHBFOWpZZ0FKamJqY3U3eUg1ckNRUTQ3YWo0?=
 =?utf-8?B?NHoyNkF2SXpjOXFjTkVOdFhJbU9ZNkd1SkJSR0oxZlNkMGE5VlhxTSsvMjR5?=
 =?utf-8?Q?H13biPNiUB/JUvmG4CDfOqa2/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	adTmNkHVpaTjAO44HJ6W/yCSKfF4+N9fbZmpXXBfPaXtcbcPI+culcdZzfEML68EXbDVKCcAW7zeF242xhrxVtr3W9ZE4NFFYlS3UR57N+i0zfr9MLoamGV62+ITwiUSnK7eeKBeQsP1HHN7WqzDGHIFw26xy8WNnGqZmWuGVNs6mkZNRWhf9YqGB88R8lC9M/aSUUlh8ETL3oLWemsH9eyret9jAbg/sxosUJVdK747bUar5zxsO0lcn9lIgy8ldtuRq2Y5TNvm0t9eseDI2moIRfiMhS2UyFglDnRMsVitcXkswqMrFZywgOrgre3mLFDTrIaETBCq5qru1WDNXioZbj9nTfXWJNsXSBILTMJYNMjY8kadDlk8Bc3RdCrNJkMZmFg+9iOwwi/6JH8eU/IKba6zW2FOEKrzo02Qnb/eBJlGoiQttFQDgpm1c3hCWwav0/btsxYHxXWl8vRIM28WoUw5ecaHi5CChF64oqqQ7RyBGNLw7WulbxbSJ7PgtxypHdj71x0vyTUFIwpGekyc1F41ce3Re0B2Uyo54qIRzdMJQJXSAPQj3JgpYaYmHznVDglpqboI5wPnbasGdET0v4vRdDWx7mtz2ZVBIvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c9f5d6-5431-412a-9f54-08dc4e631e10
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:37:59.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gN5fyjQrNl/hjQhTrNHFphfdw57XEhr5nmKgebvrQYZertXjSf2g/zz6K6XpHDB3FESaR22kEsSad0ylzaL3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_08,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270092
X-Proofpoint-GUID: Y5DHeqOIUvzwdcDn5DinBb4ekGs5LkrR
X-Proofpoint-ORIG-GUID: Y5DHeqOIUvzwdcDn5DinBb4ekGs5LkrR

On 27/03/2024 03:50, Matthew Wilcox wrote:
> On Tue, Mar 26, 2024 at 01:38:03PM +0000, John Garry wrote:
>> The goal here is to provide an interface that allows applications use
>> application-specific block sizes larger than logical block size
>> reported by the storage device or larger than filesystem block size as
>> reported by stat().
>>
>> With this new interface, application blocks will never be torn or
>> fractured when written. For a power fail, for each individual application
>> block, all or none of the data to be written. A racing atomic write and
>> read will mean that the read sees all the old data or all the new data,
>> but never a mix of old and new.
>>
>> Three new fields are added to struct statx - atomic_write_unit_min,
>> atomic_write_unit_max, and atomic_write_segments_max. For each atomic
>> individual write, the total length of a write must be a between
>> atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
>> power-of-2. The write must also be at a natural offset in the file
>> wrt the write length. For pwritev2, iovcnt is limited by
>> atomic_write_segments_max.
>>
>> There has been some discussion on supporting buffered IO and whether the
>> API is suitable, like:
>> https://lore.kernel.org/linux-nvme/ZeembVG-ygFal6Eb@casper.infradead.org/
>>
>> Specifically the concern is that supporting a range of sizes of atomic IO
>> in the pagecache is complex to support. For this, my idea is that FSes can
>> fix atomic_write_unit_min and atomic_write_unit_max at the same size, the
>> extent alignment size, which should be easier to support. We may need to
>> implement O_ATOMIC to avoid mixing atomic and non-atomic IOs for this. I
>> have no proposed solution for atomic write buffered IO for bdev file
>> operations, but I know of no requirement for this.
> 
> The thing is that there's no requirement for an interface as complex as
> the one you're proposing here.  I've talked to a few database people
> and all they want is to increase the untorn write boundary from "one
> disc block" to one database block, typically 8kB or 16kB.
> 
> So they would be quite happy with a much simpler interface where they
> set the inode block size at inode creation time,

We want to support untorn writes for bdev file operations - how can we 
set the inode block size there? Currently it is based on logical block size.

> and then all writes to
> that inode were guaranteed to be untorn.  This would also be simpler to
> implement for buffered writes.

We did consider that. Won't that lead to the possibility of breaking 
existing applications which want to do regular unaligned writes to these 
files? We do know that mysql/innodb does have some "compressed" mode of 
operation, which involves regular writes to the same file which wants 
untorn writes.

Furthermore, untorn writes in HW are expensive - for SCSI anyway. Do we 
always want these for such a file?

We saw untorn writes as not being a property of the file or even the 
inode itself, but rather an attribute of the specific IO being issued 
from the userspace application.

> 
> Who's asking for this more complex interface?

It's not a case of someone specifically asking for this interface. This 
is just a proposal to satisfy userspace requirement to do untorn writes 
in a generic way.

 From a user point-of-view, untorn writes for a regular file can be 
enabled for up to a specific size* with FS_IOC_SETFLAGS API. Then they 
need to follow alignment and size rules for issuing untorn writes, but 
they would always need to do this. In addition, the user may still issue 
regular (tearable) writes to the file.

* I think that we could change this to only allow writes for that 
specific size, which was my proposal for buffered IO.

Thanks,
John


