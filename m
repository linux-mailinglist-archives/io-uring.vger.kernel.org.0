Return-Path: <io-uring+bounces-2992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E1A9676A4
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 216261C20C7A
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF8E117E016;
	Sun,  1 Sep 2024 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="fHUHhr7H"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029203A29F;
	Sun,  1 Sep 2024 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197838; cv=fail; b=bG/bUbXUwxhRtNAEbl5vHSiKRoPp+44DJoSWFaDjnojWUbYdCbFVEYQgLXCFKO1z6DaGMWojUP79eciGIZKGIyqmGatFVI0q+FErZ5PZM64Ph0kr615cuZ+mMir+eKLwOlL/5pkUHZbklpb7KlRUEhLWJAaadm3r9O2P6zdEhv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197838; c=relaxed/simple;
	bh=+r7EhP+63h6FqApIsmR73SFRzWpagGrXais2MsTBRxU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Si8IDAoqazuD5zaPU/idKizYoGQlCEcpsbZiNILbheA3wn80Yh+fDkFe0Xhl86NYGiNRM6p8nRDWK6yLLwr070uHD418dMSxZHatbvPEdq6pLibobfrrGnEqCIDMGCvu0E5z9OBOuyJvfYp0aQ3vbn3wyU7Qht2mbtgCisUb3qA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=fHUHhr7H; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101]) by mx-outbound10-30.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XfG8a0N7tBuive/n3gbKUVr3eu5hA72sv/D5k2+WXoYMvcw9G9etqPMGRB0mWWlKYRwkxpAMYdRCyLIf6fMuZoT5yW8vakolD9jtzi1KxcZhKZhS8dDQJQE1sZgL6l7XuKV1kQX/3wq5vhQE/KKOLVB9dqtXySLUuS0TwpAuYtIt2aGyyM1Rek0hlxzilM9P33D++zjjS1DHdtbb5PD4e1OzpEpYePy29k+scgb/7zXmefZAAg0pZHef3l8+kqecJ/OBy/EQO5xT9qrpIExms73C4L8WaEKq2mS6nJKl3CRq+uaslh5X1Pnb9LqZKiN/ulrI62Nx2HzEHrUwW2wO7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBsvOGbik58g3TROcZTG127F6qGJ+oALHjFIO1xoQdI=;
 b=qYrIu95Ep+B+LBnUvsG2x102PfhuxgCl9bE+q4+QY3RkvsCmu4qAirU97GTh3x8QNF6RgNcNQ+cvq+qO6UnJAC8k8tjJjtgtaApbLHDtvFs1Mkzt3NLCdVwgIA6m/RVaW7f8I2a6DsZT4G/8q+DdWdjDxlHrO9TuVvu/N0HjKI8jpVmVf1oiC8NUsrWt/1auWMs3Vab4/At3RYsGU15qMIo21raLA73IlXOKRV2RduQCiI746RzLGI33qL714/kBBaXSXINxPb6ALSaYjuKd4KuI0+h8z0BRj03oYz+GinKTEpLNRo0QsjL+Bq0yTiRBCWHN0L0ZL8atvX/C0t1jfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBsvOGbik58g3TROcZTG127F6qGJ+oALHjFIO1xoQdI=;
 b=fHUHhr7H4/FMeS2ghxPWX7A4THsm0wNccRHpOHpHipnJOAOpOcj/OeQhO4HA58mx+KrSxzoaEauMmDxxMib/YF1qS4ov3DiB7Le9oYIwYSpswTx4T+aRn/zPBsoO3o36WwT34EBb5KbIezf72iQuNMYYIEpXlwzgFr4+KxXots0=
Received: from BY3PR05CA0047.namprd05.prod.outlook.com (2603:10b6:a03:39b::22)
 by SN7PR19MB7089.namprd19.prod.outlook.com (2603:10b6:806:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Sun, 1 Sep
 2024 13:37:01 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:39b:cafe::52) by BY3PR05CA0047.outlook.office365.com
 (2603:10b6:a03:39b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:00 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 9D20372;
	Sun,  1 Sep 2024 13:36:59 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:36:56 +0200
Subject: [PATCH RFC v3 02/17] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-2-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=1467;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=+r7EhP+63h6FqApIsmR73SFRzWpagGrXais2MsTBRxU=;
 b=Om6SklbavqnyRJbYNJen+joXJ2iqN2sa1zxov9lPdO6iy7BbZchkojkghVBvnzq5539i2qXzi
 Ns+JnK+j3FiBcZmHgt9NbpCQakXKwPtUqb6rV5x3KrnFd0mx8rRtznM
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SN7PR19MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce755ce-4b76-4cc1-a6ec-08dcca8b283e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHd4N2FVNWVSY1k5cjdaZi8vOHpteFczaTRyUHNzWWJqamRqRUk5ZERzbE1B?=
 =?utf-8?B?QmhlVHhlZ1lleGdNVUZweVdvdHJkQ0pBcnRiR0xOaTdVajZ0RWxPbXNRQis5?=
 =?utf-8?B?T1FmZ2M3WUdqUk5yZEY2eGFxbzByaThIWkdmTkt6TGttY2o0T3RITlY4bkNQ?=
 =?utf-8?B?bHBWSFd5dG9HWG0wVjlkQzRIUDRtR09ndDlYM3BPczd0S3VlV1pXK3BRbWth?=
 =?utf-8?B?TlJwTmxTb1pKc2o2OFluZnJCM2RBRlFZbU1GMTRJTFQwV1lXajNhZmVEdHJF?=
 =?utf-8?B?U1hyVGhYUXlHSzhkbHRVSkRUNEFBL0tDNDZnM0VrWXdyQUJvQ09FNUZkWlFq?=
 =?utf-8?B?UHgwTlprQksvUVZXNy9DN2dTbGF6d3RNZ3NDMndJQkVPQTZWL1Z4TmlQOWRO?=
 =?utf-8?B?K0FmVlJUZnhZcjhsZUgvY1lKbmpJYmkxaUk3VzY4eWxWQmZRaW9PT3o0REFU?=
 =?utf-8?B?NFpiRnpDUnVVMkZ4eTZDOXNkN1BTN3ZHSG8zUUlnRXhJcW5qQWtjMDJZNENv?=
 =?utf-8?B?Qnovc0FWM0dsTVNvU2RFVXFWVGN2dm9oYWFKRFNEZ2hmdXRSTWpyczhwTDdl?=
 =?utf-8?B?YWZsdzhVYytmWTNtb2pxMVpld0IwU0x5cm5sZlRPYlUydEUrcVdlVWxKRHZP?=
 =?utf-8?B?TzlIYnV5Wm1mbzdKL2h6alVyUjNUZ3NPOXJldnpVeG0wVzc4Y3N1VlRvRk9P?=
 =?utf-8?B?YXE2RGlGMUx3RnlVWG9LUFJHUHp4TlFUWjRRVzFmZFB4NksxcmFyZnNWa3Zn?=
 =?utf-8?B?TnByS1k4TTJSUitiSlV1UWEvcHFMbWpFclUyamxsbGlqOWlZbXdlMnBwbmJL?=
 =?utf-8?B?VWsyVmZVQTdaZDdVaGsrWk5BcDU3V3hJVnBvUWI5RUFuOW5mc0hBNUZnVnlv?=
 =?utf-8?B?a2VFSzh6aHlOUEZWa3d0cHp1eE1vb2c3V0JFNFVja0ZZYnBIRFE1SXNSVUg0?=
 =?utf-8?B?ejMvSElKdjgreGoybmpTcHdzUC8vSUpadSsvUmQzR3JoaTFhQ3EwWUNNZzBV?=
 =?utf-8?B?N2lZVXU1RXQrb0sxUU1VTm9OeTJsaTlralRNVS9hMUZGTE5xMU1TNkZnT2NN?=
 =?utf-8?B?a2t3elJyRGp3b1FmM2E4L3ZEL1h6c0UvbFdQRFlUNndrTy9RSERiNXpQUVkr?=
 =?utf-8?B?czVYT0NTYXZtOGVEbmFnTjQ3Y3hyeDdFdWVXSytVbzZLak9GMyt1YU9UV2F3?=
 =?utf-8?B?ZjFnQ3dqOVFleGRyZlowbGZERkJGN3RjNW83anJYc3dSMlB6UVZYN3hHUkVF?=
 =?utf-8?B?M2kzRFpGa1k2UVJZc3RYTVBlR2RudVBnb2UyYWxkYmhlZFZIbE5BTDhaUEVI?=
 =?utf-8?B?TStpelpHdnQ1bXoyRjRLRmx1WTJGSjBHS3ZqRHZSM2ZZUld4K2daY2lyWk4v?=
 =?utf-8?B?Sy9xTktFekNWLzYzRkNvRUpqMHpTakxZdk42RW5xT1R0VmxRSmIxMzlzMmJ1?=
 =?utf-8?B?UENZVjZveGkxQ09NcXBITEtUYnN0RlNsd0dNamhlcWJDRndFZk8rbks5bVNh?=
 =?utf-8?B?QjQ3eVdDYmpxd2d0dXUzRGozSjB1WHduMGt4dHdkUjAvSnpJVGlxbHVDaURH?=
 =?utf-8?B?T0dEZ2EvcWN3TlViWEtZaEl0VHZ2ZlFXVkZZcTJBR3dDbzVYYVVWdFA4U3Jx?=
 =?utf-8?B?NWZva3VBZU9lOEVzOGh2cWoxV3dBN1BzS1h3Rnp6aEtITW41T0tVUnh4N2w3?=
 =?utf-8?B?YlN6cXBhaDhsYmx2MEFENFUyaHhoV1YzQ0MvMURRZlhhNnlJT2d6YUcwdjFQ?=
 =?utf-8?B?SytWSDErK3k5endIN1kyamVJWkEydTFBM1czRVR4c0RvKytYM2Mxbi9ocVQ0?=
 =?utf-8?B?M0NpZnUrNHlrUzB1TzNMWGRCWFVBMHJPNzFZSEJwczh2UzhhcFBZUnNYdkI4?=
 =?utf-8?B?blFscFJyTFBYMjVNWkFrWDJSZEdTR3JXQzQ1N1NETmtBcmZqQmM3YmFuMEZi?=
 =?utf-8?Q?Zb5UuLs090Q=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ov0OHFvKuB3ULeCivMcyBKyuW1Nog1gh3wmbJyOi2A12ofUfl3CBztJLKVYkhllnaSeWh9w58ePkgyc1FTMOqLRWKoycsl7RQlmP76alRA3pXyZQhPGB4x+Dbds2dg7W7DGIOlnOMolC8+mJUrZRRbHN/gWo9f5qC9ZhebN2KFVLTopEHYvsScHjz86HjS4SqLLB8cNGdyJkmdvroO0kxUnrWcSSIpyIpuur4RfOxvSMDbhurKkMz3TR9pcDIZro0/Wpto33zO8WmgOiurKpmCCeMF2nMIUoEY8kltH6qt+FJGcczGBpj2G+racfc+QqczFcLktx2rxBMcc2wNvScCSvc2DJkpw2GMmhMGJzsQrobZoGBldeMpPxs51pj7t/zTgMqGPFCYfHA8i59mIVg1shWX8aRbZ/NlxaEtxYADyWNxobyuw/vV5SlQyEuDMWLQd9mqTYortGo1YdRzKM3PbwMy7AOtKuRLypw6W9wF2fgPFB7T9VEDjywKQG+arG9mnx9oiZj8hPgvPys8Y8HYu/IzERYZUKfhBDjTc3jpaFajvDktgruEqZ8+PNrx6EbnbLv7eeS3XinLR2FfqWLd5uWgpdeefcEY3pgofGCHsYsxCvEDcSYmw3OF+l0Q7rNuf4+RelSAgIUbVPsr1xEQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:00.2821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce755ce-4b76-4cc1-a6ec-08dcca8b283e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7089
X-BESS-ID: 1725197823-102590-12635-7738-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.58.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmhqZAVgZQ0CDFwCzZODHRMj
	kxJdUyxcDYPM0oydDc1DA1LdXI1CxFqTYWADykb05BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan19-197.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Another preparation patch, as this function will be needed by
fuse/dev.c and fuse/dev_uring.c.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 74cb9ae90052..9ac69fd2cead 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -32,15 +32,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static struct fuse_dev *fuse_get_dev(struct file *file)
-{
-	/*
-	 * Lockless access is OK, because file->private data is set
-	 * once during mount and is valid until the file is released.
-	 */
-	return READ_ONCE(file->private_data);
-}
-
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 5a1b8a2775d8..b38e67b3f889 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,15 @@
 
 #include <linux/types.h>
 
+static inline struct fuse_dev *fuse_get_dev(struct file *file)
+{
+	/*
+	 * Lockless access is OK, because file->private data is set
+	 * once during mount and is valid until the file is released.
+	 */
+	return READ_ONCE(file->private_data);
+}
+
 void fuse_dev_end_requests(struct list_head *head);
 
 #endif

-- 
2.43.0


