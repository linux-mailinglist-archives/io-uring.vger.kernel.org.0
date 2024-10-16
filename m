Return-Path: <io-uring+bounces-3701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B65499FD38
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E626028151E
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B1010A0E;
	Wed, 16 Oct 2024 00:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="JECCgha8"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980810A19
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039060; cv=fail; b=NlpTzz2cT+M9fmpUHadBPjpsdUjIhmfGGWROxWDWDFM4MFJ9oqyXn7u/dFiGRyodLshaQdniwRObnrLPSQqVCyp3QxeMNrimFurNdtQpQj0Fjh8QDytGiZGsEVxbvoiJYt41L0Q4b8moAJ8YjFKnWaEDgftnUSI0S2IHn5m5GZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039060; c=relaxed/simple;
	bh=JWQE/T8olYYyXZ/ARWzno7FNBWNmjoHiOSb+sjvaFL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D8NpagpsyZau9jT1WFAAFy8n54Sg+z3KHJPrBNbK3XPjOjE2No331JCEUYVt+uwp1Ipb//y2EacFgOWOoc9NNUru9Pc6rdJ71xTU36/eHkOdC5yOPydvFsHYEtyLJEgSYY4+PHVwAVicT58RrSHuO/iw4NwaUpvLE0oDR9ehutc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=JECCgha8; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169]) by mx-outbound40-93.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8+klRN34Lt5CTtmOgrzsQnilbFi8ZzyBNuQiV2x2OEkJiXvXbK9iFgysatq5fIR648zuWi9toEbl17ZQsmBU7NbssCLD7l6HHkG9A/hk0L8n0dff7DlRfj3Z60YRUrKdgPeBAHS08ugXwIesWE6xbp5bvWVXgX5VAq5CK/wCjY/LCZPoeEZ/NoyD5TNlLOt4vnYsxiiVH6IimXXeeoGADQGPIAhVqDcOLhsRYqo3JqBXcbBcFghNNVWbC8sOcpyGCjiXO4R7WfYLRbaMWjR2bFEdrO+4jv9KQ9fFFqNF5+mv2sS0VBtMXAHNe6DHCUPawnYiXMHd/4xDyilmSLkdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXJtTIFM67HNQ88b7dVqM0hO+Yu4etm+gVXpgiFJxF0=;
 b=bTXQN8zd325bm67Z/jv1pQD/WRZmhvwB82qwQD2IqNBH10eI4UYEetMlDSiIA+KP6k+AwxD7u35CwkT7H6ek/nvGQ6ywSSTVsaSjxceh4oZar/6WKW/cf1MKCf2d/lOMu4aSAuxEJneoGS+PvKv7C31WiwXNhSk60TT3Is/tDsaEojP5PYLVpVR7peyyueuuDiIMBJQbu8TaZPqbNCi2h3DDECl+oIQNt89TJhy+wxkmkNZze9Q20bSyzMrlhlzXriwmGfBe5g0ACrDMqf2pqAoixznhyy4Eq0Mdec6Ezmq7D8YKDmet+U25c9KG7Quk7qQWUQm4wk7d4ic8RZS0Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXJtTIFM67HNQ88b7dVqM0hO+Yu4etm+gVXpgiFJxF0=;
 b=JECCgha8vmrk/xfZR0yfdcNzAvzxhFO99L/3rgEfI0h6bS52U3fyaldTQjeU1on8sNHu2VxOl9Z9RDQcURwiq/AZxTli+w+onKCo+5BS4nCb9l2w8YVi93m5pDMR1GeG8tYmbLDkOOh9plJUz4aqtyjGTvV9gm+QRb32ZzyAmBQ=
Received: from SA9PR13CA0169.namprd13.prod.outlook.com (2603:10b6:806:28::24)
 by DS7PR19MB8857.namprd19.prod.outlook.com (2603:10b6:8:253::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:05:41 +0000
Received: from SA2PEPF000015CB.namprd03.prod.outlook.com
 (2603:10b6:806:28:cafe::36) by SA9PR13CA0169.outlook.office365.com
 (2603:10b6:806:28::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF000015CB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:40 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 807F529;
	Wed, 16 Oct 2024 00:05:39 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:27 +0200
Subject: [PATCH RFC v4 15/15] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-15-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=826;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=JWQE/T8olYYyXZ/ARWzno7FNBWNmjoHiOSb+sjvaFL0=;
 b=kRtVuh7K3BCqPfXQV2fVr4VUpHkv5f4VJKJQT1YOUDHprBIKGgdP8moo++gW+Cyo/7A/ik/+m
 tx4YESiecXZB2GLiwJPmg+ZFNjGAu4ftx/XS9K6sa+DnJC92Kytn0LX
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CB:EE_|DS7PR19MB8857:EE_
X-MS-Office365-Filtering-Correlation-Id: e0875fe6-61bb-4805-38ac-08dced764552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0puVWVQbEZZTWRNNzJsNTlDYU9odjdzcFM3NkRHNHJ4cWhSaTl4NUlnZjI1?=
 =?utf-8?B?NllLTWhac01CRzlPa3VYMDVHSGFOekZCNjd2N3MrYXpTck9MakFWN0ZXV3RK?=
 =?utf-8?B?YjF5QU1reDFZNEkyblZrenI5ckcyZCt5UTQ4U1FMRFhkdFBFdjBHOXl6aFFW?=
 =?utf-8?B?YlJ6VXpoUWs1Y3I1TzlVMXpGYU1SZWF5cVNrem5EYnBnU0E3U3lGOFN3dlZJ?=
 =?utf-8?B?VXg4MnptYWVDQWRjS2o0Y05ZTis0SVFjVWVRQzRyT0ZwcmNqOEpWcURvNVFI?=
 =?utf-8?B?YnpNYXF0aitKZGVUZHFQM2VDWXVDelNNUkd5d2ZBSVljQ09lS1VNV0FnaFlo?=
 =?utf-8?B?QWpIZ3VYMWpWMGJFVU85SzdHZXh1bWhDdmY2L0g3eHBIaXlEVURua1prVmZk?=
 =?utf-8?B?Y0J0WWp0UWFEaS84WUp2eFJxN2tsMDNlYTF4d2RaUGpBbWY0YThaallFaW1n?=
 =?utf-8?B?MkxqemVkQWVia2pCckpoT3JDaFFMZG9NZ0lQWnpCWis1N3hCQUxucFVIb05s?=
 =?utf-8?B?cjNxNVNOWEtkdExkQ0t2bEMxZmMvRUN4bU5jTUg1L2pUVnkrN1lPZlc4bnVX?=
 =?utf-8?B?bC80WEhrMzM1dlBSdVhGZkhKMmVZVDZwcEtOdS9XVTdqSStQakpnK2lBWmJm?=
 =?utf-8?B?UGF5bjRQN01HdDh6TWFzRm5Oa0JFL2dYRnYrVWNPNnhlM2FNNXA1Z2ZDV0Jl?=
 =?utf-8?B?TGpORVZHbytHMXdFajVrZWpXNmV2R01UWXRyc0Y0NTlLNGNodjVOR0plMFdI?=
 =?utf-8?B?MEhUSWhtSitGS0paa2JDMjNwd3ZlVkt5cmlXUHM2Lzk1NUErQ0xmTWlOVlor?=
 =?utf-8?B?Vk9peWR0NXd6TmZSOE51RmVFNWlYeU4zNU94amxXQzRxQkU3aktLM3RjMURK?=
 =?utf-8?B?SGtmeVcvQUo1RFExMEhMNFVBaEZKYTU4SjZtSlhwT2x0UEpUZ3ROYWl4NFZn?=
 =?utf-8?B?aUN0ZFpqK3dKWTVBeSs5R0YvSlRDMmdwS1dLTG10TFFXWGxyeWYzRE43dWM1?=
 =?utf-8?B?MGk1N2lsZFZOZkl6L2ZCRmlhVVpCMHJFcTVFWHhpUjFJdUFHM3d4OVNIMWt1?=
 =?utf-8?B?ZURkU28zaDZOZklEMFR3cE40SDNWeUJxSGtPM0ZhRDJLcnVZUmdUc0VaMU1D?=
 =?utf-8?B?YlpYWEt4RzZpSzVkWjVweVc0eWg0TXBsS29mcm9uK1ZMOUppYmJTQVZIS2tP?=
 =?utf-8?B?UDlWN2V0cVBmRGM2eDJ2SG41dEdaRHByMkNKbG1vc1dYNHIyeE1DNWxabXVN?=
 =?utf-8?B?UUY2QkI1VURhUGExRWZRYnBCWFhKOTFrZzdHdG5ndzNKWTBhaXlnd0lsbFNR?=
 =?utf-8?B?UTk5cUNGTFNRaHE1dHRpVzB6bmdHVjJjejdiMXBidkIwbGt4WTc5OXduNHZ5?=
 =?utf-8?B?aFRVWFlmWE5YMVpnK3JJTi9PclpPQUdhWEs0cUZGRUJwK1MwNmd2ZUZZUUpj?=
 =?utf-8?B?by9aSVBQSmZxcjROdW1zYVNoY3hyQ3kzNDk4LzFnSU45VmRYNFZROE0zeU01?=
 =?utf-8?B?QUtMZnFWZXpJcC9SL0k3b2hweWlVNDBkTitma283V1VnUFdSL3dhNXVuZm5r?=
 =?utf-8?B?L3FGREFwSStJUG1IaHRTM21iNmVSc0ZlbmNQRU1zcFcvU1pwdXVOVVoxWVl3?=
 =?utf-8?B?dzFiOVF2dHVOQnpuTHpPejl5Rnp0QVVDU0RNU1ZZcnFEUzhvbk1qNnUzRGlx?=
 =?utf-8?B?TVBMNkU3U1FaWDdkQUtjWUhXUDFDT1EvSlg0LzRaTU5STTh1dWozYkFRUHJs?=
 =?utf-8?B?eWJySHhXaXV0aFhDeXpLdWZDamdHQzNTSXRmY0RTN1NlTjB0M0U4cVAyaTJB?=
 =?utf-8?B?blQrUjRDWktDTFcwUW50enBNN2ozc0ZBQ1lORHJIYVZnbVNnMTZZOTd1c0xv?=
 =?utf-8?Q?GL5zQkBo52BSz?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CURe6KrqnilNHvfzYcjDyhS2t/9ffZtJOMyFXrkCLGHEhHC9ww72ZHTpISBRuq+Q8ZcafZdNqE8BsJcWiuv9lUGqTT0a/F1mCEs0bTtWFvvkeSaHbI3RDnb6iNgw0zfL7LAlce87OumwVR90ai2xJyX3zWGBkMgu9Djw7qVdurWpO/zML2qYG26pO0dMpnvlrlUw7QiZcvK8EpkZLejD5+pe4zIBmNjoRxPVnBgFbpeO3PjnnuESAJvvodoSaMB4oVHSFIKV3jNzRLIIIoCpjcNAcBasbGEBGMzBtulTX7yZbLABqdigiamNeprUgWLJ5ZcP6DN2C+Amfzl94Yq11Ai+Q0kAy/NU43CIxWZSF8hxf0od2Q3koru09ldY1jScUx01jv0bYwCJqP0U8Esak6nR0aHBuxunx5IdKEmiC6hQRZJzPGP18hDYSDu+up32kHFqgE6rQHVCtUR9W3Z0IolqnihArshveijkJ6JsRMK2fyRREMsi9FmXzWztKuv+hHEOJhFnHEhAvkvg7UknqT8SkT05ONwVg0UDUy33F5O5chjytPi2tuMXXagnJWk68me5XpYmWOZxJwXf4SOKIUlyl8WMuRn5UGVOMPhEe+aMuekrfFX20vFemHy02hIGbaFwJPNe04mjW8mYLkhHJw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:40.3770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0875fe6-61bb-4805-38ac-08dced764552
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB8857
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039057-110333-12863-22921-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.59.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhYGBkBGBlDM0CDFMNXY1NA0JS
	3V2MzM1MzAyCw12SQp1dLQ1MQy2UCpNhYArSrDJEAAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan14-124.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5603831d490c64045ff402140c317019e69f8987..e518d4379aa1e239612d0776fc5a734dbc20ce90 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -980,11 +980,6 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	u32 cmd_op = cmd->cmd_op;
 	int err = 0;
 
-	/* Disabled for now, especially as teardown is not implemented yet */
-	err = -EOPNOTSUPP;
-	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
-	goto out;
-
 	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
 
 	err = -EOPNOTSUPP;

-- 
2.43.0


