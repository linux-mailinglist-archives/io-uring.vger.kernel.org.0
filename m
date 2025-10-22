Return-Path: <io-uring+bounces-10102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FADCBFC55B
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 15:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EA016607ED
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3397A3491DA;
	Wed, 22 Oct 2025 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cuElKqF0"
X-Original-To: io-uring@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011047.outbound.protection.outlook.com [40.107.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5D034889D;
	Wed, 22 Oct 2025 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140681; cv=fail; b=WpkiT5JkbQmmpSHzfxiRr7ErPic07O+tSyGcb2/CB2gEa2d0spYHZDHJgDkVN8fO1bBJZ21gIAWCUO8jW4OBEKZ08sR90iTxBhKWnBsmWDaSP+VxDicwml1d9jOibgySWMVH36fkYOc3nfrcgVxJVsRqEkGVGu11aANKFtOWh0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140681; c=relaxed/simple;
	bh=zF4AdzbptOj3pY49uwmBzQGvnedbSbL3tCSsPr3ekZY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BfiWcaDiTcp+rV7s1v3j9IEKkd5MXMYIViUf2k8rp5eB5AKB7m82B3hrxm3/OBINtCzj6bVDEgZwJzVBZaaVYePhpYRr/ez9ZeAvN4aNpSru4/Ljh5P0FF7cAjYW9z6w5vBtBcLNCE6yUB9gBjeOv0kJhbBb6MR88gt/VfFa84Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cuElKqF0; arc=fail smtp.client-ip=40.107.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpnbVNcqEAH9pizq7FG4C9n2HP7HpHf0oSjcqGk9mzjIPuc5oRmzZNpGrnw5u1IJvF9GBZRCEYCIhJ9OCcXmskAO2Z6E2ImFJQfTCbvlxm0x73ZqxvSdu7dUnKlYjKyypn/bLpO7FQVy+Cg4ci55pZTIYzx2nfQeZtKhlI8WjFDht62rjMvxGJOMeb3deOuqFWZS8U9H8YSQO6pXZMGmhDbz6EDfhigekOvUmZ9ZucQLMe1X2RFnmAs9DziBMO2+Udjw5oloMMHRHzCGaZGx/zGguDz8kVQFCrKM5yNZPGi22CDYDTJkb7KdqgOzFsqsOZqppmT+IVP9lT+uDKySzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICQAm5/dlAVwJonttUgCMP/heKugQLmurFxbFSmslXg=;
 b=WQWcG8Hlc/Z1cCxxGuEdd2Gc8TZkM0CzdTaHMXEbbQ0ry6pQme5pRx0PWIIfcHmsAyedta0aIYgsthlnZgtdXsrhm+CnLmHzFvYbUKy3B7bd5M55TTUQo5rMfXgeM2esv5uoXKvblFK3+Qde/kkyzMlQL1WapPbMHhrm8e9bj7n8sbekpJnH2U3tmfXxYBinbO3/XkNtQSdE8sEggxYaZ1zVH3hBHr+b+Zn8WglW0t9qTsLsjVszvT9OQjkqnzSNcSg15AaADHwKtnU/qxHN9ZD/eWg4dEm6Aq1v96p+wQ0+DYh+Hr9DFX8vNvSHuMSJ2S6y8hUo+IG0zjFzNYxdQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICQAm5/dlAVwJonttUgCMP/heKugQLmurFxbFSmslXg=;
 b=cuElKqF0Yy7kAktTpQQEeliwF2wmyHiI1bddCT8Yn0yD/9rzwNIDgr98gtD6f41X5+0A8fdT3KBLIpJCc0koHAOqj1k280rSwT4pxJGgqt63BWSVcD+jfoswo3sbPpBMIU0zOpNXrnP+E0FcugGrfkfpe0qLnL3l2H0MEq2on+ARHi64/K6vwbiou+fEpH2kZ9gJBUNUZP5nswRg5t1QApTjNA3pQWIv9yQZcEL07P/Um/cASbhFPmtWxo8Qk16746ZEtZ21MU0Aw6O86ExinTvUCBd8/DK1NHU1+VSXHrhWXpwHSoxSfPWFMuTiAQthiUmSPQ+1v+ATeq8Zfn5P3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB8294.namprd12.prod.outlook.com (2603:10b6:8:f4::16) by
 PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:44:35 +0000
Received: from DS0PR12MB8294.namprd12.prod.outlook.com
 ([fe80::d6a9:5e83:27dc:a968]) by DS0PR12MB8294.namprd12.prod.outlook.com
 ([fe80::d6a9:5e83:27dc:a968%7]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:44:35 +0000
From: Colin Ian King <coking@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	io-uring@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: Fix incorrect ordering of assinments of sqe and opcode
Date: Wed, 22 Oct 2025 14:44:31 +0100
Message-ID: <20251022134431.8220-1-coking@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0371.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::23) To DS0PR12MB8294.namprd12.prod.outlook.com
 (2603:10b6:8:f4::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8294:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a929ac-2522-4fd8-0b2b-08de1171231a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V8/gP/yZ1wWoDpqG8dboludUWhKFOKxiCVjpY+Djlb32tkNPvxQxFafiEzl4?=
 =?us-ascii?Q?ZARBRRh6z2BykPoCQ5I+EHHq2XCFyXOpViElA+hZKom6phZOc3tUdDpq+LlB?=
 =?us-ascii?Q?nscLW+CEfoWiW3bRMF/CZdSk60+mYvrvlSR63KjAzC6z7N0zP7Wz3xyL55rq?=
 =?us-ascii?Q?kkY+PfVBjg97+4Q56HjM3cMmkpOGqxUWcS00mEbt6CA+X6Lisl5eYJ+m4xRT?=
 =?us-ascii?Q?5TZpsDxOXgCjtKuV+UFIaskINSTkcMW4syjcO1xYGFqNHZAjXat3epOMkQk7?=
 =?us-ascii?Q?mANNm7m/uYaIYiPsQezP6ulGV5SPMZK5mpNHYLA77RYIhk3CHDwAvmBarxXU?=
 =?us-ascii?Q?LzZymIb6kRhIbt7PYHvwdn2yR4PZLeTjAgpYLo9THlWI5SD2MTO4PPssHVit?=
 =?us-ascii?Q?YZcyJBu+iVeYbgnLGV0eFmuq9FWWd+eLIZBshYh37k3qHOODg9c49LKW8R0X?=
 =?us-ascii?Q?GCTziK4MQMSBK6zaRGzu6rLY1tA9zDS5/mOHTgV22o4ushHLzdkXt37yGaRr?=
 =?us-ascii?Q?zixIuzlXJHaDmNdoCnAq1wc6varkpUEXPWuoFJly3U301D4rqGm299ntQIJB?=
 =?us-ascii?Q?jHVzgHo6JKwuYs2P9NuFP+DUQKzar6efMge3zo7xwy3MGfhumgPcNeHako1n?=
 =?us-ascii?Q?1zNOEWpb5pbU4oLFeFLfEF+YQB07kNiFeD4VRG8Y7sLjkIO1Es25zIo+ejuJ?=
 =?us-ascii?Q?8XFXFZqgT9h1scdClCAMfpCBDnLW4cwkMGvJBeAdPtSCvcfmiYIJQM7e1Per?=
 =?us-ascii?Q?mpHmUa2bSkRCIRSiuYm5dxGKYSVf1iSayMx0f8TfiRmr/WVgms+AWRqSthyN?=
 =?us-ascii?Q?3ACCXFiyofjrcd/I4eEEb3sSM59FLUM9No40URwOb83LlK2Iy9YhcAKtKCzy?=
 =?us-ascii?Q?37KgGBbdl0SyNuLeA3Pv/RtI9u4xxRmwvLzd2s5VVgrWkChS0B1kkTsSUlR9?=
 =?us-ascii?Q?i4qJY3xqOYLnE/n2+DQX3XdZob5C2p3Xzn/lcNqWBaTUtjuEWAC2bb54Ndze?=
 =?us-ascii?Q?y6fxr3pS6PXgmCqlh2AXYUpJBdNMxO+f4ZqiP+zf97UegWIkwzO1K8hFPDIT?=
 =?us-ascii?Q?Ghi8NVuXHyMCOWLPUiz2Ybq/z7bDi/ul7yFL7RFvQQ3KT4i6kixfzeuK/Ytj?=
 =?us-ascii?Q?HPrzXDZX1ysjgG8z9B/VSNWBq7O+QtQpBNCMxdgvHkum956NQDJb5CTib0GA?=
 =?us-ascii?Q?Zcb7xoxbakdA4kWoxVcgRgex66ej6ptlC/IF9mY9lsnO88or4H1vyAGJ+625?=
 =?us-ascii?Q?3ROaW3LDs3Pk5DNenw9Wp+IXrSd0//KVna1TFMLYVuR6zNwwa6UQ3Z01UlVI?=
 =?us-ascii?Q?rCBUSw1XxluVwPXyQv6NU/nwPM9Ngb2omQadc2QeYRPQGW53hSw2TFi3O2Yt?=
 =?us-ascii?Q?gwFrkI4pMFxeIcMnHil52f8lrsRNsrfFm6TMVs4bI0nW53Bn04Clo21lnbnv?=
 =?us-ascii?Q?zg7NiQuSeJToCl7C+KpLzfYDWp8Bpsey?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8294.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q3Y5DMYCAHMNeQnEHfrz/xemXkd+gx1z5lE4qZdD1wsMc7zFA7yDK+kIjRIo?=
 =?us-ascii?Q?ibuI+RNnWrk2p4oAp+HZ86D5UeIs6aj+3gYVe/yHLFUvMOZA2mNC3mpPnugX?=
 =?us-ascii?Q?vM0EZgZWTgObPAEZHXMj/6WEkOmfJgcxMJ1Xjexk8c8EeEch0gwhnr9/HjUw?=
 =?us-ascii?Q?yCCTRp3pSAFTkuLg5idSDHa2nZUqzV8uwblu9BMteqOwqbIu9qylJahWCPne?=
 =?us-ascii?Q?Q4B6+NXikY7pfcDHa2mbEd2+4BykWpNJY3VgoIzkEJWZnLrWMkMdpRxgZk5b?=
 =?us-ascii?Q?/ebIZIih2Kxtdc4pokxLERj9k1DqsFPdQUYrrxNg7/4E5bTJJz588eiGPuB3?=
 =?us-ascii?Q?+4IoM+GvRSti+3sjubGkFDaZeQZ5RQWrf0BhdtL1RN3q85gAi7NfGwa4MXQL?=
 =?us-ascii?Q?jDOyyRdT2poksScsZrmDfYDv7dQBrh9xH9wJZrpUfD3P2U6CsFP8sFfY7MsA?=
 =?us-ascii?Q?iGnvgbSLoVFPkhHHn9ccUrjv2FIuNuxa5hVOMQTg8Jr5yO8o78jCjFjPfLwC?=
 =?us-ascii?Q?AFkf8gcnkQaYOt1dZfYbGIGTaBrzNXSGphrVElfUZzlXaRSjhiisU87mOD3k?=
 =?us-ascii?Q?3Vvx/okXTNhbkyRnwwMXmk7P+ErLhi6j76O+SicI9j3U/b6rH/S/24KWYXGd?=
 =?us-ascii?Q?rh0UqhpxP8nn5K1xwDa4wLvEfkQgCsXwzEDsy97wBgaqOm6z2dS+fpWf/M1U?=
 =?us-ascii?Q?dvDQ+IJJ7U35UUYJNZHU+UD6esyBky8FwAlQZyyQ6mo4wTWyfXBvswxjah9r?=
 =?us-ascii?Q?yC95jiKvXHYoxMuGb2UeYtM4rNGaZS3tFXg4wdsECDWjiiGngXsb4048ROo3?=
 =?us-ascii?Q?dJy8H+LAhX5RlwCMaG0/IPC7mD6jh38aEkl2+USPpxYGZ6kU5P+ffcSKFYix?=
 =?us-ascii?Q?/R3M/ZUpixDMD87Cj/XWNWJjAHe3HEJSauXe/8bhy1C82gZpZFCqepDEcqC1?=
 =?us-ascii?Q?zzH9I7qa1hy2ox/intUSreHQ4y/nJmyHbqMnUb6+Q+hsYs5t4Sq8npim0YV8?=
 =?us-ascii?Q?RnqmoPDe9ui1IRuJ7tvvAaQIxVKppe9+ui0DmdpC1cY3WlSRbFsIg+Wvo3T+?=
 =?us-ascii?Q?g9yeOk+6tFef0T3rh3o3ET0gT5FdtSW/Q4w8PULkC6ke4lqwBK67YR7yVFD7?=
 =?us-ascii?Q?fMOWbimjnx9FjdzGwCOTAHoU2DdnZAsPD8PZOAMDi1L1qJi7Relol8MyxzrW?=
 =?us-ascii?Q?c0M6XCyxfEXruRoDTZhR8iicj0bxosZiQdrLWE5ubBi5T5GHLR5qBognc1WG?=
 =?us-ascii?Q?3BcbAjwpG1ix8R7fHF5kUYhctHoBbJCa6ixtgnH0v+b28UYaWG5JK2kqoSi6?=
 =?us-ascii?Q?Rjlter2LkRxjB9DisnEkFrIN8zXF0ItQ6V6K+LVUd98wGAduLzDNwyKMBeZx?=
 =?us-ascii?Q?ATbunEJs5TSrPyl7tZ1vecAWUv3kT2K3QGRZfEcd09GInG59wKpnpb1RxvY/?=
 =?us-ascii?Q?Z2KH+lhIImtQUbS2IcfDBPs5opi4lSDcWQegnepx5Lf+EoDvmsBkurn7K650?=
 =?us-ascii?Q?w+77cCMmY+/4y5fM5H+zt3ztbf3/GeBKwft5nFBFF7xIrQXHjtYCLCzePSc/?=
 =?us-ascii?Q?JDDv+2v87UeZ+bQi1DtUbAel2gfKuH2q/kNP0ERx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a929ac-2522-4fd8-0b2b-08de1171231a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB8294.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:44:35.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIFRfLYGVoVpfhI4OGilX6YxISOLgFtKLhaEwFf0h6NBhw0uLgj94t8dmvNliadLX4QN+8RTY+iH6ZP9yG18Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

Currently opcode is being assigned to a dereferenced pointer sqe before
sqe is being assigned. It appears the order of these two assignments cs
the wrong way around. Fix this by swapping the order of the assignments.

Fixes: 31dc41afdef2 ("io_uring: add support for IORING_SETUP_SQE_MIXED")

Signed-off-by: Colin Ian King <coking@nvidia.com>
---
 io_uring/fdinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index d5aa64203de5..5b26b2a97e1b 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -100,8 +100,8 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		if (sq_idx > sq_mask)
 			continue;
 
-		opcode = READ_ONCE(sqe->opcode);
 		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
+		opcode = READ_ONCE(sqe->opcode);
 		if (sq_shift) {
 			sqe128 = true;
 		} else if (io_issue_defs[opcode].is_128) {
-- 
2.51.0


