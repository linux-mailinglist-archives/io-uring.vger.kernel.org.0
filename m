Return-Path: <io-uring+bounces-751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D29F867F2F
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84157B2F2CE
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C9E132C10;
	Mon, 26 Feb 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JOdXcQBA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E5cMCfwS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF24132494;
	Mon, 26 Feb 2024 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969065; cv=fail; b=seDcERFckVD3UfwlF/x+pp7CFw6h7ILxqXu0D26aAt2XsQfZHEN0tmOcql5EOTZ1MSyO6T2LMmgQIMABa7hpPiI5XrApI0JOlwyc4hE6B7oRQQLxc93nkh9sfFi0LsjaNpejLIz640APcIm7upEdAyJNMoKHezCB6VTey6UaN40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969065; c=relaxed/simple;
	bh=T4vTffpf1rDy6pFEykqhB+LYYvr8FjI4OMHj/cynNyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T1U3aB+O128rwrqN3o2YrgTahZa51PfGd4u3FigAlo1aYZDx9nd/yC2NuAgM3GtF8hCrpCuSG7EgkFOdRKhAWtv5U4aqqqzG++zsDjKGX5dA7wCo52W+MkM27k7Yiv9+9+U/YEnOUe1IWTY2OuvoVe3+/+8q+iAJogdUcnKwHjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JOdXcQBA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E5cMCfwS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGn7JA003771;
	Mon, 26 Feb 2024 17:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=H49hyexlIrSIzWqVIejInFGx1vUNRq0ttgLyNxUOkKc=;
 b=JOdXcQBAwQalBJxBgMmBjuHIRLl4Knd5ikPCSnX9kAWHGRDCmCLojMyYyzdBy5CBFB5u
 n2gA5m/hBxMfVEvSduhqr27U9Sa6AC/36QS4mLp+gmd+WjFivc+bFHU7a5pA23TOasuU
 6FYBn9FBKb8O6XQlNhGyDKukoHFS+KR6WAaJYY3ddtxGeXMNVRx8TzxK2tnp9rgvwzgA
 D+Qztmmhm063LVlVuMwkxgfuMu6Wmg0ESc+xMcCGmO4vtwD06qSg4IqC4yWs6i1Q/a9S
 RYLx7DJbRcU4Fbll/8WEH4cWitI/cqScHA6P6gsvWctqnW9o34Gx4uQ0n8lyLUuH/n32 UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccd5tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGxj3l022406;
	Mon, 26 Feb 2024 17:36:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w61tbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atB3SaDz1I6lLtD0Nj8wYYykFlFdfKoixFBRiFUf2O7gfgZbMKCsjgGWb1PajPJSsONmZOPImG+KpPkoi5+WsN8CwPnHWSQ5HIXIKZxApBuXyQXUySKte6ugWv0MaeSL5KDE9qDABNiy8UWXXC8EiiGzoBJQqqmSMGKvmpTfm9m5oSqOZUBHHfxZ8EB1SYPrgMCDE1OR18PZMFjMNd8sGCcuYaJ9pwGPO+J0K7iKc786m6r6Ny2fWYZFG4VaxkRBYvMtQGO8TLa1rztcPdDt4/JRTGzbRh2rnC1/Ywo2TVzpWgC5pb+XTfvycMlM0WvMfcqwHcq/9Dz/Ko/D+EsxMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H49hyexlIrSIzWqVIejInFGx1vUNRq0ttgLyNxUOkKc=;
 b=hdKAnKrSKnv5SWr/jjaTWbyRqDHwvqYk7eMJ9HfEHhYv+rY+mnxEPhOB/hNUKBwzrp93K89RomkblSb7ndRyeiQeceEORzVL4qG19rrmj25K9CKnuQ93+eTRDsLR5r48FmjIBMDLKn7jDAoT9c8XvkBqEY3HSd6/WmcCkM1ItBVTIabOnSkDHymymhLSqnOHt/e/Q4s4xwU/kMmJCCKGYJFEroTwrhkGb4VEQVZCxvUYbKgW0YW5r4JX1ZusN0kfcyFc0poHQtWTvfIYGPejFZqx3M7Ral/aIIzo24zjQ5fmosad824ZFdOvrkQEjddJokT19/2GoJcEh1IRQBiyug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H49hyexlIrSIzWqVIejInFGx1vUNRq0ttgLyNxUOkKc=;
 b=E5cMCfwSgopf2WCFr9nPTJCvjCcv0zxG7dI+1pBZQu3cB1Hqdh+r3a7geJVcNNcGjfFXhHvNsFhhHqhrAphtUzPoNRLRwaFvEJyKm4401GueeT9OWqtlASb/wbPId6vRpOPjSCv7D3jPeAOgCiolpSAsAnJXECs2EDfM3b/L14w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 03/10] fs: Initial atomic write support
Date: Mon, 26 Feb 2024 17:36:05 +0000
Message-Id: <20240226173612.1478858-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:510:323::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b821c2-4578-4d4c-5def-08dc36f18023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QWPslNKHjAipYkpItrXWv5B2TCbFwYJlCL9U1EMTl+aecKYVlQaQz7RudInz2QK3MdEBu4LvWZk6TkYB2SA9/rEDapBU0qkUIwACOcui8H77Cwh2lHc35NRkLWjCD6Wr7uDKU53SNlEII74JLNCx/mFOAML14jt9tyL9/yvtHJQRiIAqPyMFkDEbE4uQPlH7LVqzL1fqh3PbURTUqMUuSBPWsIaSMOtRXeiBVdmEXjqoNxTaVjoFjLpjptxpIGrFpwLjv7DftcJ6sJvneSWM5S30v2rurqLgdWfWnjTya3y3mbGi5cSFKKrufM/8MiTuXzKV8UUAYzMK2cJ4Uvol5lwZcHQi8S6NESfoMW8I8PwNyN8+mSYZc5WDcWYFI2JdILzir8qQ+e7tX0GsqLW9shslUGvZLtIh1UTOezghAiWyRcrky8LKMrCs8o5r/4zct6jzxdUSFFGb92XhANyR/jyRPxuE6ACh1Tg76u+BpwB/o9mpkQbmmeXTB9Wp30ODW63KzqOOJ6AZnYzjetjl2Ot51BGwnFiqMMO89vHgIJPQtCVs6L9ZQLDXIYfcembUUIkpzueAY/NuTPACIFRNRUc2/rPAMg+fpMdBTVWXpgRmBfCSM4OploltxJND2MEHShNcJkz6vl2QLRewCQ4jOH7mZkXCKJ5mmx9NX4UcSJ0xbJbb+lhUmIqBqKW/U4vama8xGktneWFShrzwL4pz2A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UWDDYaukj/qbMgoFwCZLm+j5cuFjObHNK0F/jseJ2UDmSqJtKTBH1J/6dynC?=
 =?us-ascii?Q?UT64jQU+6Cbc246jvbQ0buW+h4cKaQt3M7aUskxBAH6BR34dxNhEMf8/6Gfl?=
 =?us-ascii?Q?YPA22mILH/Sh1j/NvkjZ7hTFHMII3dgo4A9xbvqHP/Yav+MYmQbL8hwtBqxA?=
 =?us-ascii?Q?+ieTBWdR2DvY2UMrqYve0An4suNHJNOShxIlnj9iujBDWkKTdyO+rho1/Gya?=
 =?us-ascii?Q?QoBnGjyOev3Et3x50NDzdcv++uhqcP/q2wNWgIpzp1GhWEVoJ+SB1WyTsagH?=
 =?us-ascii?Q?LEoUcwXBjlfLVcQoc01QpdwpxqpOl/jmFRbl+JcFnHkx0iHHnMqZxTpvvzVt?=
 =?us-ascii?Q?cCJhMfbY1YsTITqnNHP4jVc5/gyXZWvZRj8A88I40pjPFP+uV587Ig8ePb+u?=
 =?us-ascii?Q?HCDoAyDW0+PgBBLvWZyxxOmedCwauWh0DqyaFp/S//qODfd41G3L/eZ+jGbC?=
 =?us-ascii?Q?RbKXd92sqVDu9T29YRQEfrXpvLjS1ufxjwK2zJ7iO4Rwvze3fgAGjTdOvw8J?=
 =?us-ascii?Q?5Jcjdyj0fsa0sVGRWALPOt6dooKKo6QcMH2Uhg372DzjILuDIyRajTx71jmw?=
 =?us-ascii?Q?Q7cDSFa4AlynfWvk7VhlgqiO+GotDHu62kZFQVLlYbcIbGsPqWqagQIqW5Dl?=
 =?us-ascii?Q?vDTgSCBIUtIDU+FpgwZcELvMcjKqlJSihEdgi2T0Ec+LHNUqry87GqMYhCU1?=
 =?us-ascii?Q?LD1y/D2mv9MaWMNWI7vopu5cH8Qfrji5v1qMumlxv/l+OdyOaQ2/8u93S0dy?=
 =?us-ascii?Q?sG0L+Wp90Qkj4j7Lwjru4hiwMLPLb7t7iM/FKv81/vZ+SL/cqIPPkpbnwbcv?=
 =?us-ascii?Q?0/NRN8xmcxdBqiA0e0e0KipFNCkwWE7FMgUHXBatrafeVBcnpi0cHKNTNn5b?=
 =?us-ascii?Q?54JmHmYsgrFeC1AKX5+hJL+p3nrsPDM9/IQy+jVZ64/AY8eHr4wdUhd8L+Tl?=
 =?us-ascii?Q?QaejDZ1bjloXXFgDknI6ktGe580jiaC7WDirkN3OnqolcCMgQw4wLDnW2rvo?=
 =?us-ascii?Q?U/yjtab5sXsgkywC39/Gz3b7wsuxVfIu0IYmYmxeWM3gGPdyDygHkkcEb+kL?=
 =?us-ascii?Q?E1obMbzbRIxNBOa3l2T4oHoo1X0SHdChzYPmoLY3urXVA7q76oVMiJdj1Q1b?=
 =?us-ascii?Q?doAOCaNOz+KcYucuINum+ILJ3Jy9lxUtcCro7qVAErTQGZqW7ym77JAAg4ug?=
 =?us-ascii?Q?fVSWfTFbqPXzwpDAqeUneq5fxMnrjCEVnGMe9yYx/4Pz3WExMjY4w9Fot+PK?=
 =?us-ascii?Q?M8Uof6SCLx1Hc6K4DBpVCqoLSa8t/7VnNNc02sg2650jgWcXA1HFe+TnZDOQ?=
 =?us-ascii?Q?PJIGsCDwxv6VgKPoyqvv+jkpDXZm1A/yJowH3Qx2iTJoJkme/dDvEEQ1reRl?=
 =?us-ascii?Q?Kw0RYVHl3YjPw5KB0KCOW+B2XH641PWo3BGICJ3yY7zlLDRdgoBZfHZChCaD?=
 =?us-ascii?Q?Uf1PRZ8LcEs93BJLzTRFY7zeXRqOJrVAmLkZdn8C67Cobm27XbaF0ynQCQlk?=
 =?us-ascii?Q?x4FckzZVrWU3VfF8eAjcFYo9U5KmtK73R55LUlPk4SqEAfGkQTAY+fhMKfZ3?=
 =?us-ascii?Q?/ljB/KBrknX3WQrP0ko+txyUH9j1suRS6TK04Z7IFGrPjDxrgUVV28WyxmS+?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	oiXN7tD3DJzQboB6OtajKWCSD7pUPZ5YAbk4L2lGwzBTQbqBdZYGJNXZ7/VwXQg6h0u7dB8Ue3X7/VXF8IIDTxiHWJhXxlLUx9fuuzyKnMfmGNDglog0iamIyCQdYB/pp9ShuEOLSujHU61abOfK7iEUmkmFJVPjz8sPZVihIayasHo9rVGstUpc3vsOIw2dvUbdBn/+ae2aUgrPvfdxBjjnReLKhK9m4jcRCP/ghJkGzUUgp1vahaFY7Cq+dlV7aZk3aH+6yfgAbzQPmUCYpXKgOb2uAvV+lT4hsUnX1X3nUCwX7Rlgg+Cn9v3dpQr5h17gxCs9nkX+MBOBAASYhXPNp6Nx1C1x0WImibC+p14whxgBNT51+FoZZnKfHOYRtfqXlPDj/60q8SFtcUQiThFcJeOk3sJs36gb9t4OYCUGdZFJe+D/mOnSxig36FxfpKz2law9MEuo25U1F832wF9OEe3Yq+8ovbuD3NNNvD3J0hKOswJs7mhjaGKtmdfGxW48qDNiFUzs9odbi/+vyg+Ur29FN3oav0PI8b7k24IyxXRbR4qbEYZbLumufenshjeuCI7ohUtblfKiKDaITNz/f+kcSg5Tk6H2hewjRVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b821c2-4578-4d4c-5def-08dc36f18023
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:44.5990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNQONJuh2lVcZGZ4Nd3cvfhKuRKc4Widv+/ZAJioAA/wQYMFdJlbSNBru7VwbJoKxfFZbaXmE0iyv18k5Kh5Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-ORIG-GUID: FKEnblygdTB8qwnfZpf0aA685eT-S2kW
X-Proofpoint-GUID: FKEnblygdTB8qwnfZpf0aA685eT-S2kW

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

An atomic write is a write issued with torn-write protection, meaning
that for a power failure or any other hardware failure, all or none of the
data from the write will be stored, but never a mix of old and new data.

Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
write is to be issued with torn-write prevention, according to special
alignment and length rules.

For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
iocb->ki_flags field to indicate the same.

A call to statx will give the relevant atomic write info for a file:
- atomic_write_unit_min
- atomic_write_unit_max
- atomic_write_segments_max

Both min and max values must be a power-of-2.

Applications can avail of atomic write feature by ensuring that the total
length of a write is a power-of-2 in size and also sized between
atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
must ensure that the write is at a naturally-aligned offset in the file
wrt the total write length. The value in atomic_write_segments_max
indicates the upper limit for IOV_ITER iovcnt.

Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
flag set will have RWF_ATOMIC rejected and not just ignored.

Add a type argument to kiocb_set_rw_flags() to allows reads which have
RWF_ATOMIC set to be rejected.

Helper function generic_atomic_write_valid() can be used by FSes to verify
compliant writes. There we check for iov_iter type is for ubuf, which
implies iovcnt==1 for pwritev2(), which is an initial restriction for
atomic_write_segments_max.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: merge into single patch and much rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/aio.c                |  8 ++++----
 fs/btrfs/ioctl.c        |  2 +-
 fs/read_write.c         |  2 +-
 include/linux/fs.h      | 37 ++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/fs.h |  5 ++++-
 io_uring/rw.c           |  4 ++--
 6 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index da18dbcfcb22..ba420faed82e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1509,7 +1509,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
 	iocb_put(iocb);
 }
 
-static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
+static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
 {
 	int ret;
 
@@ -1535,7 +1535,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	} else
 		req->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
+	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 
@@ -1587,7 +1587,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, READ);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1614,7 +1614,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, WRITE);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac3316e0d11c..455f06d94b11 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4555,7 +4555,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 		goto out_iov;
 
 	init_sync_kiocb(&kiocb, file);
-	ret = kiocb_set_rw_flags(&kiocb, 0);
+	ret = kiocb_set_rw_flags(&kiocb, 0, WRITE);
 	if (ret)
 		goto out_iov;
 	kiocb.ki_pos = pos;
diff --git a/fs/read_write.c b/fs/read_write.c
index d4c036e82b6c..a7dc1819192d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -730,7 +730,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	ssize_t ret;
 
 	init_sync_kiocb(&kiocb, filp);
-	ret = kiocb_set_rw_flags(&kiocb, flags);
+	ret = kiocb_set_rw_flags(&kiocb, flags, type);
 	if (ret)
 		return ret;
 	kiocb.ki_pos = (ppos ? *ppos : 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1fbc72c5f112..95946a706f23 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -43,6 +43,7 @@
 #include <linux/cred.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -119,6 +120,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_PWRITE		((__force fmode_t)0x10)
 /* File is opened for execution with sys_execve / sys_uselib */
 #define FMODE_EXEC		((__force fmode_t)0x20)
+
+/* File supports atomic writes */
+#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)0x40)
+
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)0x200)
 /* 64bit hashes as llseek() offset (for directories) */
@@ -328,6 +333,7 @@ enum rw_hint {
 #define IOCB_SYNC		(__force int) RWF_SYNC
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
+#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -362,6 +368,7 @@ enum rw_hint {
 	{ IOCB_SYNC,		"SYNC" }, \
 	{ IOCB_NOWAIT,		"NOWAIT" }, \
 	{ IOCB_APPEND,		"APPEND" }, \
+	{ IOCB_ATOMIC,		"ATOMIC"}, \
 	{ IOCB_EVENTFD,		"EVENTFD"}, \
 	{ IOCB_DIRECT,		"DIRECT" }, \
 	{ IOCB_WRITE,		"WRITE" }, \
@@ -3323,7 +3330,8 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
+				     int rw_type)
 {
 	int kiocb_flags = 0;
 
@@ -3340,6 +3348,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 			return -EOPNOTSUPP;
 		kiocb_flags |= IOCB_NOIO;
 	}
+	if (flags & RWF_ATOMIC) {
+		if (rw_type != WRITE)
+			return -EOPNOTSUPP;
+		if (!(ki->ki_filp->f_mode & FMODE_CAN_ATOMIC_WRITE))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
@@ -3525,4 +3539,25 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+static inline
+bool generic_atomic_write_valid(loff_t pos, struct iov_iter *iter,
+			unsigned int unit_min, unsigned int unit_max)
+{
+	size_t len = iov_iter_count(iter);
+
+	if (!iter_is_ubuf(iter))
+		return false;
+
+	if (len < unit_min || len > unit_max)
+		return false;
+
+	if (!is_power_of_2(len))
+		return false;
+
+	if (!IS_ALIGNED(pos, len))
+		return false;
+
+	return true;
+}
+
 #endif /* _LINUX_FS_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 48ad69f7722e..a0975ae81e64 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -301,9 +301,12 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO O_APPEND */
 #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
 
+/* Atomic Write */
+#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND)
+			 RWF_APPEND | RWF_ATOMIC)
 
 /* Pagemap ioctl */
 #define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..099dda3ff151 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -719,7 +719,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	struct kiocb *kiocb = &rw->kiocb;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file = req->file;
-	int ret;
+	int ret, rw_type = (mode == FMODE_WRITE) ? WRITE : READ;
 
 	if (unlikely(!file || !(file->f_mode & mode)))
 		return -EBADF;
@@ -728,7 +728,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file);
 
 	kiocb->ki_flags = file->f_iocb_flags;
-	ret = kiocb_set_rw_flags(kiocb, rw->flags);
+	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
-- 
2.31.1


