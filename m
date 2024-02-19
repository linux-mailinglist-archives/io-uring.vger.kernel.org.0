Return-Path: <io-uring+bounces-635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC7885A453
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 013CB283333
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D55374D2;
	Mon, 19 Feb 2024 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OaOWHfNW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L5onVEEP"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0C37163;
	Mon, 19 Feb 2024 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708348004; cv=fail; b=F5gkVqYinMpfGLr/D/BTgPMtV+KYF2Vx1megr65HhkeyLgBVpAq8uHo+fQOl8BoYGK3vgiMcXdw94fJ7EfhI1E8ipGSTQJ2MA1cf2NA58Xk8M747xSDt8PI9ZNbu4AY61cpNIr9svL27Ab6aVWSQ70F41gh8C2a9zctSb3RaecI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708348004; c=relaxed/simple;
	bh=Ap6kxnJVleyqHaUtrgZ8FBhB+YrlLJsVhkD1VpnfSFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BuUDNVnX4uby82QGFHr3LMxPGwGvxbWBKibFVcgrv3FdssRRn/spiFPMffI4EPWziP0ZXA4npuaoxoMa6YMgdfDYSqHVj3RVHYYvToAyArTS+3FCfCFKYgslmrxkA8xg/1GQTXnkmoHUJqk4KnscWV/dSM1oHNeCjPIEbalqmdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OaOWHfNW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L5onVEEP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8O8nV029258;
	Mon, 19 Feb 2024 13:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=6szqaEIEmwFBMpZA3kaTugHSi1deW2zdChdJOwXXCfs=;
 b=OaOWHfNWsToaSLrrjbwokcr26FUtAjYoJ5LtFvfSFYDJkFbmFuGnm1/ROiujMrtcu5Y+
 iaVYJBfQPrlSSlHy2aTWfyxEmJFn66nE3BI2XDki4oqwUZU55u6LpZpFoQgf5LvKmXl+
 cQa19icTzMYnAr79e96JZy/WTA7tASvvMl//Inmq64pokZy2JWjW17+4E48Pv5Iy/xZ9
 EqAX15RW3EBJNTMhOHKa8tD2aKeK4iJgwWRKg6dSfTPL+8vnw1xCSOYResT8ieNDl/lM
 0p11wfil9hSJHhej5OCP2aE/PLyWJbklmlw8IFZ4BagDpisutMFSH5KHKyA0ypfI+Zj1 cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakd244ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCP7mg039737;
	Mon, 19 Feb 2024 13:01:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak85w5kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vx/+E5tiSZcbZG7rYkK+ss7HDztCqPFucNlrc7fjriXxbG3xktitoJQ3b73CZJYkapxLRSOXJH2b/gaA27w6LFbaGzzghospV/CnwJP7+7yRuHgTW8FhE/8J3aYCxjUTWmXJmgBdo1DI5FIltluhA2dkt2L+eMz8NqDPk4z8PaUMzEf6DMvk99aPAJk1Dr2TEnp+ToQCcN26zVFLQc44NZ3pF/HaaRKlCyLIqvAKnOJNGFtKA1PNaPfetrlxHSFnR4tOCAdy/Bx9cZu6r5wM1ZKXw5yW6kxBXOOcyycg51Hyu2K0y97Kz+REsQHkrZjXnxvMbUvUcQcgcVmez0pwFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6szqaEIEmwFBMpZA3kaTugHSi1deW2zdChdJOwXXCfs=;
 b=YpWVxYC1tyKBqEWNV1Mq70FtoBp7SbMonvt9ZV944n2tqi2a6nJpnN7QoU28pQ/wuVPuXIwyWnn9oCjeb3NBRUXitm7nKBDPWHgwxhmq8FYkkEI3WPQTSVBTp9KGkKif8sRsmoe2+i55gHoRJ77ClXjv6g7JrW8ek+yGpMa9v2eJXAcvnd67A8y1MbLOByuhezM51QzLNqDt+5B99ZaZbseRke8YzQrNBsVpTLp0J836auNGI+FSdDuuvhxSNRLazubMiytVOxtrd6CEqvdwQsITeW6/sZQ7cXbNgQxgywF4A1rLDl0yNk/jCL5rnGZUKYA/PctJxXP0P9ODscB7zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6szqaEIEmwFBMpZA3kaTugHSi1deW2zdChdJOwXXCfs=;
 b=L5onVEEP7tL5nHEdVQZ2eLl6dPFHH2uKM7BIL66IWyurEaWrM3/0+H8cm+pc5TcuTMqWSPHP59K161Z9kEkrR1c4SmcFH8+tAufKNQfglLhWqfbS+iDBi/onOF2cb9yxNUydistz4rWWq4CzUOej5hki8lAS8D+97zKymVsx4Rs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:48 +0000
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
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 08/11] scsi: sd: Atomic write support
Date: Mon, 19 Feb 2024 13:01:06 +0000
Message-Id: <20240219130109.341523-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0286.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d0d9e4-961c-492f-e1e7-08dc314aef09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iYO1CSlwYuJD4SXRYljqkBfOUq1ss9YNzhAqpL1VtfYVIrbGkarwvJbJ32j6FUuybYQViwUltC54NbuoIqaXjhTgaPfDreeZktFhkUguxhhd/c1hun2SCgABSrbXDkdEZQccZnWheXROYD28im+2N9xIilojeMpwoG8aADoNSuXBULX5htwTw/IP+5haKf9YSCgzDD1IfOARA99RM/w3s6XFE3davYlTHhNwvzeH3+cUF1MYJs0zrke26oJIzXvWbhu93sC2q90YmQ3RmxNnzl8oY1e8HeOIZam7VXPJq4hPcD7/qO/hV6qPPjJTURabMsf7XxeXn/8abjMXu1PLDscsBqM0nSLE1JxpGF6eCsoMamNTx70jPPU215Ioejekn2nxVi1kiRPvPrexKLZLFaydLzvKE5wElG6yJDn2UgtBMhrCzx60qMBvT12H18fguPkKV9K98l17NSOIvWCGHft71cK6f2JN1w9+y2K0UhzrTzHDlseZ3ZgeLQs7sAMYajMqyUnwaOGbioUG3rSzdqFmQGNeTT7nWUyYw1gCIvFiSZ0yRPUuCyE/7Q6XHbj67Y6cz27+Lqj/tuEmhaqt2IH4496wsngwKK8gJOKMSGE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SKNes1eMcKY6H2o9OAXwxMbKyUsguut4XbRaRNiOac3EG8g1+ssCpvOoT4LA?=
 =?us-ascii?Q?1N/EQIXgx7CKcXU7/D9hkJSIJQS070I2xv49+BUb2BzfJpNS3tZf4mv8A0Vk?=
 =?us-ascii?Q?5e9jL4n4W7e4K710kMLu9l8UY68ujF8w1sU9g4uood4Bu4biCtdB5vm4jYXR?=
 =?us-ascii?Q?61kuAV30QuI1+3AB9+UOJAqvKaBuHzi0Q76Afm/f0K301BfB2NglQ/7mMQl0?=
 =?us-ascii?Q?1JYlQQ6jYHy/npbKxfkmzwNMWfIxuv8YlYA6RSWu1RNDG0xxZ3SSQU6w98VC?=
 =?us-ascii?Q?J2BXiLYh17jRUlPyebJGpUfMfPAciAgJuo1kQz8WiwLHTiazMcMszECl06s6?=
 =?us-ascii?Q?ItaQMGeR59GW9k/zd6hFe4snbD1UuxY94nhcNHCXLeDCHN+7Z5Df6ARkXezn?=
 =?us-ascii?Q?DuLto6zFyTDubr42/VobWPdjb/keos4peOAVs3zUSO/RG3vB6ljXKXiEDq0k?=
 =?us-ascii?Q?46D85Kegc2bnBHJZkGjyBwjZdAdU6riAr+Jjl94xCZtpzeu0bgWYkafV5bX+?=
 =?us-ascii?Q?gfvyyiwsEyuIbLzFhyYqhmXQLE3TJPOc926Rbb52nmF+GoORfkKMssBb1Jur?=
 =?us-ascii?Q?gNmsZmCRUJWS7djx7Y0OvLaZCLAfc5x4KJQCXdTSzfLruIlit1tU5y0CJuqO?=
 =?us-ascii?Q?wkNoF8Dpnujdv0bU4neQoX2RCTEqOCSDOZ78oHf/y+IpGRBH5M6CpDdZd5cd?=
 =?us-ascii?Q?byBKFj2zSxxdnfljlS7gvhjpR7YMlqp2LW3zSx6Ehxk0z2K0MP7JqJc69FWQ?=
 =?us-ascii?Q?8JG6HS01z45UN+TLvoae6hIJdLb4eCwhX5GVCR3t9I6NwluOkvGHisGVBuwI?=
 =?us-ascii?Q?PuoO5K3d4ayKDR2YLvvFkaqCD7IA+xUHLYE1rZMCHl08HXtRmIJicF7Ip8QB?=
 =?us-ascii?Q?h5CgwIqdh5uYcr31SSv2xng9LKcGczl+KysBIOAF7UD3HGlRBOZK+/knhAH6?=
 =?us-ascii?Q?38VyHGAu5fzgwvlcZ4FLP9HCXbZepyc9qZmYIa9PMvlflUR/5L6fiei0Nd5f?=
 =?us-ascii?Q?os5iOzHFsNBN3a8r2HOq7V9XKNUqrCfXNFexAnChy6tJnlXs6C8VL26X4v2q?=
 =?us-ascii?Q?jfSJyT+DOY+cwRNEQSfAzUmRxxaBmEc51i0WpDs286mLSA/MHigxcYH7BM8T?=
 =?us-ascii?Q?mKWRyHyUWtn36mYBJRX0Kjhl02ZfiUQubkX5YKvDQDwESo5+LdBYVa6etST6?=
 =?us-ascii?Q?gBUdAloeFMyISje8dlIR7TVVHDcxCSRqP6z0oW8Kc0PVVMcDYAySVyH567yv?=
 =?us-ascii?Q?jbR0E2MZ+PLjqu3YwIsu599UMnHKBSEr84nLRFzCttErn3gBr3dNA10+Oh1K?=
 =?us-ascii?Q?KDIb26UhFFxbLb2Xy8sSlZ9FWO+JktzW7NHVLFtpOCkxEVSRvkIB93q3mo96?=
 =?us-ascii?Q?ZxhI6DblfSzpoOyDLmVq70aEmhVJMggkwDKUVxiBG8gsCcr3IRTqgs7SpZiT?=
 =?us-ascii?Q?VKlnRDtaEswR8CBfllJboWfkUDVsesOMbP/0bfs3Ik9x9Drii/Grntczw8FT?=
 =?us-ascii?Q?MmYfOf1e/CllkOGwn13AUBG3G5x4hl5SYUcKEz6z2Zcv7qdfgMmn213NvYPD?=
 =?us-ascii?Q?kFffpupPHUB38+2hK7Q1ZP9+F9MgOftirXCGTsnyh9bz9kNnSWwp78MXOFWZ?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+1Ky+2BZoMerAJIeXd5onRBRDYn0WnOe0OuRH9nhQn55h9UePomRh+7cu8OpZaKCOxdsHlhzKUYR/NIhZv8idhq0MzlcqJofbh3q9H9XLkx6L4QbaJ97hgX6mT6HZz2xpWv1LXsw55opNPucZUUBItFdDWd29hEWWTW7r/J1iqnoS/oCJjXWjmlJqkP1wqiuSyKBsnB0sghP0CUIlZtFWv1pDA1VF4eOXUZOzQ0QTAnq6+cYQ560+rc0GgJtqT6255Ty+Fq9P7s8JWfgc+uWCXdMrywv5JIrEcA0uUwMfkvf6x0bykp55IJ9NqqKJVfIh4X5H4Y6DLyAxkEsWqqs6L9Roj46mlfj4YI/bXjtQV+aR7ByFA5RwKjQXSP7HRI+IInpzLIj7HG/QK9Wqgq/Q6RkEVQUtKjOGhci5XvkeL//AJG+twZDlGiYW8FA8EbUf2VhYcO7HG92s0jb55kWN61Flx339AmvLl2CL3dVIQVWMR/TpYf15nBXHu02ovTlUnWIR2Etlf1A7JCqv+s+7YJPlLiJThDWn+8M6FBO7j/+1h8+ZQhQ2OW5cjah/DRZ3DQtLPu7kstcbZK+ccgDcfUQBW1P3MT36KuXXcS6V7U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d0d9e4-961c-492f-e1e7-08dc314aef09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:48.9039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1XZAr2C2lhP08AY4Annj5JgqAoeMFo2FtPpfHH4y3DC2pjYHmtaVKb1WshEU2XByxfWZwERR7ohuiDT0RA1YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: o7JfbHSXQQY2gjJ-Kku1Jo61dq0-57Ds
X-Proofpoint-ORIG-GUID: o7JfbHSXQQY2gjJ-Kku1Jo61dq0-57Ds

Support is divided into two main areas:
- reading VPD pages and setting sdev request_queue limits
- support WRITE ATOMIC (16) command and tracing

The relevant block limits VPD page need to be read to allow the block layer
request_queue atomic write limits to be set. These VPD page limits are
described in sbc4r22 section 6.6.4 - Block limits VPD page.

There are five limits of interest:
- MAXIMUM ATOMIC TRANSFER LENGTH
- ATOMIC ALIGNMENT
- ATOMIC TRANSFER LENGTH GRANULARITY
- MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY
- MAXIMUM ATOMIC BOUNDARY SIZE

MAXIMUM ATOMIC TRANSFER LENGTH is the maximum length for a WRITE ATOMIC
(16) command. It will not be greater than the device MAXIMUM TRANSFER
LENGTH.

ATOMIC ALIGNMENT and ATOMIC TRANSFER LENGTH GRANULARITY are the minimum
alignment and length values for an atomic write in terms of logical blocks.

Unlike NVMe, SCSI does not specify an LBA space boundary, but does specify
a per-IO boundary granularity. The maximum boundary size is specified in
MAXIMUM ATOMIC BOUNDARY SIZE. When used, this boundary value is set in the
WRITE ATOMIC (16) ATOMIC BOUNDARY field - layout for the WRITE_ATOMIC_16
command can be found in sbc4r22 section 5.48. This boundary value is the
granularity size at which the device may atomically write the data. A value
of zero in WRITE ATOMIC (16) ATOMIC BOUNDARY field means that all data must
be atomically written together.

MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY is the maximum atomic write
length if a non-zero boundary value is set.

For atomic write support, the WRITE ATOMIC (16) boundary is not of much
interest, as the block layer expects each request submitted to be executed
atomically. However, the SCSI spec does leave itself open to a quirky
scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero, yet MAXIMUM ATOMIC
TRANSFER LENGTH WITH BOUNDARY and MAXIMUM ATOMIC BOUNDARY SIZE are both
non-zero. This case will be supported.

To set the block layer request_queue atomic write capabilities, sanitize
the VPD page limits and set limits as follows:
- atomic_write_unit_min is derived from granularity and alignment values.
  If no granularity value is not set, use physical block size
- atomic_write_unit_max is derived from MAXIMUM ATOMIC TRANSFER LENGTH. In
  the scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero and boundary
  limits are non-zero, use MAXIMUM ATOMIC BOUNDARY SIZE for
  atomic_write_unit_max. New flag scsi_disk.use_atomic_write_boundary is
  set for this scenario.
- atomic_write_boundary_bytes is set to zero always

SCSI also supports a WRITE ATOMIC (32) command, which is for type 2
protection enabled. This is not going to be supported now, so check for
T10_PI_TYPE2_PROTECTION when setting any request_queue limits.

To handle an atomic write request, add support for WRITE ATOMIC (16)
command in handler sd_setup_atomic_cmnd(). Flag use_atomic_write_boundary
is checked here for encoding ATOMIC BOUNDARY field.

Trace info is also added for WRITE_ATOMIC_16 command.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_trace.c   | 22 +++++++++
 drivers/scsi/sd.c           | 93 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h           |  8 ++++
 include/scsi/scsi_proto.h   |  1 +
 include/trace/events/scsi.h |  1 +
 5 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..3e47c4472a80 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -325,6 +325,26 @@ scsi_trace_zbc_out(struct trace_seq *p, unsigned char *cdb, int len)
 	return ret;
 }
 
+static const char *
+scsi_trace_atomic_write16_out(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	unsigned int boundary_size;
+	unsigned int nr_blocks;
+	sector_t lba;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	boundary_size = get_unaligned_be16(&cdb[10]);
+	nr_blocks = get_unaligned_be16(&cdb[12]);
+
+	trace_seq_printf(p, "lba=%llu txlen=%u boundary_size=%u",
+			  lba, nr_blocks, boundary_size);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
@@ -385,6 +405,8 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_zbc_in(p, cdb, len);
 	case ZBC_OUT:
 		return scsi_trace_zbc_out(p, cdb, len);
+	case WRITE_ATOMIC_16:
+		return scsi_trace_atomic_write16_out(p, cdb, len);
 	default:
 		return scsi_trace_misc(p, cdb, len);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0833b3e6aa6e..7df05d796387 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -916,6 +916,65 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	return scsi_alloc_sgtables(cmd);
 }
 
+static void sd_config_atomic(struct scsi_disk *sdkp)
+{
+	unsigned int logical_block_size = sdkp->device->sector_size,
+		physical_block_size_sectors, max_atomic, unit_min, unit_max;
+	struct request_queue *q = sdkp->disk->queue;
+
+	if ((!sdkp->max_atomic && !sdkp->max_atomic_with_boundary) ||
+	    sdkp->protection_type == T10_PI_TYPE2_PROTECTION)
+		return;
+
+	physical_block_size_sectors = sdkp->physical_block_size /
+					sdkp->device->sector_size;
+
+	unit_min = rounddown_pow_of_two(sdkp->atomic_granularity ?
+					sdkp->atomic_granularity :
+					physical_block_size_sectors);
+
+	/*
+	 * Only use atomic boundary when we have the odd scenario of
+	 * sdkp->max_atomic == 0, which the spec does permit.
+	 */
+	if (sdkp->max_atomic) {
+		max_atomic = sdkp->max_atomic;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic);
+		sdkp->use_atomic_write_boundary = 0;
+	} else {
+		max_atomic = sdkp->max_atomic_with_boundary;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic_boundary);
+		sdkp->use_atomic_write_boundary = 1;
+	}
+
+	/*
+	 * Ensure compliance with granularity and alignment. For now, keep it
+	 * simple and just don't support atomic writes for values mismatched
+	 * with max_{boundary}atomic, physical block size, and
+	 * atomic_granularity itself.
+	 *
+	 * We're really being distrustful by checking unit_max also...
+	 */
+	if (sdkp->atomic_granularity > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_granularity)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_granularity)
+			return;
+	}
+
+	if (sdkp->atomic_alignment > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_alignment)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_alignment)
+			return;
+	}
+
+	blk_queue_atomic_write_max_bytes(q, max_atomic * logical_block_size);
+	blk_queue_atomic_write_unit_min_sectors(q, unit_min);
+	blk_queue_atomic_write_unit_max_sectors(q, unit_max);
+	blk_queue_atomic_write_boundary_bytes(q, 0);
+}
+
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
@@ -1181,6 +1240,26 @@ static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
 	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
 }
 
+static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
+					sector_t lba, unsigned int nr_blocks,
+					bool boundary, unsigned char flags)
+{
+	cmd->cmd_len  = 16;
+	cmd->cmnd[0]  = WRITE_ATOMIC_16;
+	cmd->cmnd[1]  = flags;
+	put_unaligned_be64(lba, &cmd->cmnd[2]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	if (boundary)
+		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
+	else
+		put_unaligned_be16(0, &cmd->cmnd[10]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	cmd->cmnd[14] = 0;
+	cmd->cmnd[15] = 0;
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1252,6 +1331,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
+	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
+				sdkp->use_atomic_write_boundary,
+				protect | fua);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
@@ -3071,7 +3154,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
-			goto out;
+			goto read_atomics;
 
 		lba_count = get_unaligned_be32(&vpd->data[20]);
 		desc_count = get_unaligned_be32(&vpd->data[24]);
@@ -3102,6 +3185,14 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			else
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 		}
+read_atomics:
+		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
+		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
+		sdkp->atomic_granularity = get_unaligned_be32(&vpd->data[52]);
+		sdkp->max_atomic_with_boundary = get_unaligned_be32(&vpd->data[56]);
+		sdkp->max_atomic_boundary = get_unaligned_be32(&vpd->data[60]);
+
+		sd_config_atomic(sdkp);
 	}
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 409dda5350d1..990188a56b51 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -121,6 +121,13 @@ struct scsi_disk {
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
+
+	u32		max_atomic;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		max_atomic_with_boundary;
+	u32		max_atomic_boundary;
+
 	u32		index;
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
@@ -151,6 +158,7 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+	unsigned	use_atomic_write_boundary : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 07d65c1f59db..833de67305b5 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -119,6 +119,7 @@
 #define WRITE_SAME_16	      0x93
 #define ZBC_OUT		      0x94
 #define ZBC_IN		      0x95
+#define WRITE_ATOMIC_16	0x9c
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..05f1945ed204 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -102,6 +102,7 @@
 		scsi_opcode_name(WRITE_32),			\
 		scsi_opcode_name(WRITE_SAME_32),		\
 		scsi_opcode_name(ATA_16),			\
+		scsi_opcode_name(WRITE_ATOMIC_16),		\
 		scsi_opcode_name(ATA_12))
 
 #define scsi_hostbyte_name(result)	{ result, #result }
-- 
2.31.1


