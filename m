Return-Path: <io-uring+bounces-5069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 005289DA8AF
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D0A016241A
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1DB1FCFDE;
	Wed, 27 Nov 2024 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="wLEJCtod"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60391FCF57;
	Wed, 27 Nov 2024 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714862; cv=fail; b=FWQpZVjf3nVUQ1frHfUbfeQLNty2+Y4FhMxWbwMdBDEl+QLurwxYs9Bm6T7+lmtwLYudajnguUGfYJjCtKiwJAaEkPPQ9jdmGbIU1xZn5JwEBumy1Alyb551etyQDWKMaMLTpMOnx75zrRFcQ5UmewyNKFvRWNtt+48S9DsvF0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714862; c=relaxed/simple;
	bh=Hvdj48XTvHWAGv3oZzMk2KNxy+ZAm2o2i30g94rND2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pun9z2fb9I9Md1FxESaW/F2DkDNwPBBJxdCsU6ouAVc2AAbuG1OKgBTW4XaOo/DwD9Ij/LsjdoNxjtub0JjYlTG8k5xhNPOXrjwmBzfxa7uquo0B+4LAvG0WH4klsOSgq2rLsLLMN7zfhZGfyacOMzIW3oMDLJPDMebzlc+LplQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=wLEJCtod; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44]) by mx-outbound46-88.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpWGyfJ1b28iZehMMg5OP8pVN4A9Y1Cg1rIDwNdTFrp4Jiomh5DaE3KIkXNK0PN/JSSxUrU8VMsPCcM/Vs4QtJFOfPpmWHAkPusGJqmKHNPcol2xSWVR2j7cadkTvXkLZhpd9v3pFTsxN2P/+Slu94LRCKTogfqlrAhdxKoSi/VhAkTEsWjWntZzCFdGk5JIiGcAkLu1SsxdeNRMFXxtttWQrhA7g+Fqk88ywhco3bfQP/COwZAxGeD4724XkLYIP7uy0gtHLoGO2IO/LEC2hdl61ZsmFvuJETzLp/pbSg9wX0SdG3AFtFb46Rg+4tZDACozszHFHsyXJ/v8XRwm4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVkUI1NJhiwly1p7uHhgjY960IAxKet8B5FS6iQXEYk=;
 b=r2EaEsek67xg5OLElQj1CtiFj7vNO1MhhZzextU8r6TFR/Mwkg2HYJy29cBt2Wwhxyp0smdKDjZmtQ+leOQpOfAo8UwAiBXXDrT+XVA3pLUL5uf9cJLjuZw3o3Ket0BJbpzd5VgJNzIYbTz6LEthr9NdbwogLk52pxxDTjIhqp/mFbr/E8XJSQ1LVtuM/L/CUjKz0fs4A9V/DfF9Viu+/loqCSkJFxYsvFcvrPRWvZppy1h8FwDNDI/W/WfDc6R4cgJ9WL8qnhCfLgo1FYI90KitmJDUqVk/Rp90WFJwJClIFVHFHXrITr7B8UCiNtsJgWl3bW1n93aR1+7fWRhnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVkUI1NJhiwly1p7uHhgjY960IAxKet8B5FS6iQXEYk=;
 b=wLEJCtodc5tS+vxPUm2Rb2NgmOZH+JCDBZS5xp3Nv2loammrjop0r3zvTw6J343R4tLMYyr3m0DyZruxj0BcjpILYI4JD/kv3fM7Us5KNvNARsouZUPE5s+JjCjaWbcgkir1+8wqccvErg3mhqlr886SIOMRgQG7BhI/zo1Oj0s=
Received: from BN9PR03CA0320.namprd03.prod.outlook.com (2603:10b6:408:112::25)
 by DM4PR19MB6343.namprd19.prod.outlook.com (2603:10b6:8:a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:43 +0000
Received: from BL6PEPF00022575.namprd02.prod.outlook.com
 (2603:10b6:408:112:cafe::a4) by BN9PR03CA0320.outlook.office365.com
 (2603:10b6:408:112::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF00022575.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:43 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 44BFC2D;
	Wed, 27 Nov 2024 13:40:42 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:20 +0100
Subject: [PATCH RFC v7 03/16] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-3-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=1326;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Hvdj48XTvHWAGv3oZzMk2KNxy+ZAm2o2i30g94rND2U=;
 b=fhe5hehX/gIaRZW9B0rl7PvfNEGr0iinu7ktxWAbqX6XKtQjl8SvJoD6WpJAh8RRMJphL2AJU
 OYIfzyyJv6LBi76H0qGSNfw78RZV5QRHc2pZa3i5kNUP2Wnm7QGT3Nx
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022575:EE_|DM4PR19MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: 40dc1c8f-135c-4847-5b21-08dd0ee9170e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmxFUHNjR1ppQXZPMVJKbnQrbWVTYk9Gb0RKMXNmSWg4cDN3ZFFWYmMrRits?=
 =?utf-8?B?cllNc0ttSkxLdC9VM3ZXL2J5S25pK1hqVFRNVll0QkJSVmIzNFVZdU9nY2Mx?=
 =?utf-8?B?c1ZCL1lFK2RERHJxdWNnOURYeXJGdjBSSDF1MFFiS1JjVy9HS0sraVhoNG5r?=
 =?utf-8?B?SlRKL2ZnajAyM3RMTHFmRXJBMHkrUEwzWktuSHJ4bCtNNUhkSXBDYW0zVDcv?=
 =?utf-8?B?MlhzYUJjSkdrNFVkaDBaQW5nOUpZSFM4V1E2NElWOWVQczdwRy9QeVliYTV2?=
 =?utf-8?B?dDZTT25qVjZON0ZvaUxhcmw2M1pJT3NqblBwVVZRTnF6MHhvaExFRE0xd3p5?=
 =?utf-8?B?K1hDaHE1NDJja1k3elFIaWlPWFNoMEp4MlU1Q3FuNWphS25KVDlWZk40RCtN?=
 =?utf-8?B?dVBOcTFzbnF0TzFvKzdnMHMzdEpCUDNtdVZncEU5azhEdG9kTGlFMmJrY2Rk?=
 =?utf-8?B?ZnJJZUhBSis3ZWNZZjArOGs3UlhDRnlXWnNxVU8wK3A5a05YMGl4WWpwRHdr?=
 =?utf-8?B?NmF0aHQrQU00N3Q4a0dUdEViRkQxRmlzd2dXRWVEaVkwVXoxNjM3RTZIOG00?=
 =?utf-8?B?Wk1pT2lZUHZFT1NEYlJxWlhUNVA2azROZ29Cem5nZFBNTXRoQzBiQWQrRERn?=
 =?utf-8?B?bEJOc0Nza3RPdFFCOXJTTisybWNDck1qcnZtMGNORmhXYzB4Z3hzNkpUa3JW?=
 =?utf-8?B?ODZwN1ZWSnl0SVA1YWxaRmd5YlRTYllKLzQxZWR6cHQzdG1zOVFlMG5XRW9m?=
 =?utf-8?B?OGNRU3haZElIMUtHS1BpeEZCNDhBUDNISUwyWEk5OXNkbisyclRobGx5VHJM?=
 =?utf-8?B?bVRScndaK0hsZjRSSTFvVjQzODdMOGFXM01mQzR5NERWQ2xKTGtBT1dlRC9G?=
 =?utf-8?B?cW1zTmNmazZZd2FzLzJTUlJGR1ViMWhneWZEL2NMU0J3OGFyemRPQ0FTWi9y?=
 =?utf-8?B?eXVjZ1BUUTg2bWJ5bldWeG1BZmg4THNoeUluRWxzbUpYNXgyTlFZNXRpV3Ry?=
 =?utf-8?B?V2hIWnRiU0Z0SHUrQUlQTlhYVHBWZ0N0elo3eFQ0MGxjNC91bDhFaXRvYVMw?=
 =?utf-8?B?ZC9WK2tnKzlTRVVrOVhjajY0YXVzdERydmpLaS9Iam9wSm1hcFlWbEExaWhj?=
 =?utf-8?B?a3ZPRVVvMmFwOWJGV3gxVWx0dFdQQzJJM1V3YUNTNU5nWklWMG5yQmlJaWw5?=
 =?utf-8?B?eEFQSytoY3pPQ0RVaFFQMVFhbndCajljdXZBcEgvV21PT1QvQW5wUEltOUMw?=
 =?utf-8?B?d1BJTU5hWTA2bmhzMkYxazl1Vi9CcW5rSDRVam9NMUZHaG5waW9qRFVPeGlV?=
 =?utf-8?B?cWM2WktWZEc2bjBzc2t3ajYxb3JCOWpta1k1V2J0eDYzL1N5ZGpqcXI2WnpL?=
 =?utf-8?B?c1ZtRjRkSnV2Z05JYlRYQnlnTkFzWjNTN0I0dWhEWjQ0MHVNQWdUTVNDYU5w?=
 =?utf-8?B?aFJmYm5UNm5zSzcya2svZHk1QU5RVjBScUNwUkVERzE0aHkvZmZJRERWV2RB?=
 =?utf-8?B?cmlUMWtVQkVkcVpxSE1tWjMyOFBySnNYU05XNUxpdmc0Y2p6VDMyZG90YUlP?=
 =?utf-8?B?MGlieWxXY0trMThlREhNMjJXYU1ISm1qOFZyOFRSRWtZaCtzUWptRnV6dUdT?=
 =?utf-8?B?STU1UzBWWkZtSVkxS0MveFB4SmpzRHdZSEoxelM5OWozRGxWeGovc0Qybm11?=
 =?utf-8?B?N0JYM0tsTWV4UjAyYmhCR1B6WnUrYVVqeXJoTXA0TFprN2UzRUF3N01BWmlG?=
 =?utf-8?B?cS9QUkNvQWV2TkRTcGoyZnpaT3FaaWZYTUJtQUFlUTFPUDFiY2JRTzVBTTlW?=
 =?utf-8?B?Qy9FK3hIVkY5WmUzT2xsMGdNMSs3bDlqd3dXQnltYUhwc3MxTmZ0OWp5Q2pt?=
 =?utf-8?B?aFJPRzFOZ1NMWDVCYkIzem81dnhwcW5LUE5QWU5aclBqdzIrRVZCRWgrRzY5?=
 =?utf-8?Q?7F1FKwHXRYH/MaF6s/oZktqT4vzngaWK?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5R1pYaZ7oU63Cd0AIouo+Ar02bv8pUzMVfTNZWNwP4UjBri9OmfHKRp2UnrkgpbPpv2Y5Y3YBE2kOhfMV6qY+0tcugE3H4ODARhW1Je+Iont/6N+SgWtfJvsgWM1K+pTILevBFwT/Xin0YzIYwW5W7DcSdUx9Ae84wAhih0UYgvXz35nk6afw4RYBCOLdw5VgNL9yRtFosCGJ1oqiaCJmjX7HlfdbkBnyahocZbhUTfUK9DNpZkRqaK77cydj6fhwH6L3fG/7SL8Xxh0j7dXtK2HZwxDseFwAlzFpgzZDdjpi0CdtCFm40gWBdR28SygxTSIPQ1uKF+fEy0Qb+6yLHsTHolmNmRsMrRPML/0m7lpsAEo/7D/RvBF3TbuM9oqlUjPbELXS8xrK4b3obmyQLTJhEbnGFSx/C9pi1rT3mPpK1Y7yS5ALoJGQb29aV8KyVMIT0VKjRfhDMo5rEC42gukYhEDVuKPYPyitAAj4rAR5l7kleyB2FUhgCD0axKhCs5LkPn3DK5SWvUSWL386sBKQmhx0EZ5Tfm1+D5u1i8DQcX3enNEBzX+pOXmuF4CuJwxOGoOzxCqUHN+LqpuvTXvTREOaG815TOnNIh1CpH6XrkaoTznMT3kmkTEcnPPWKKiLL+4M/0tNrBBoYCFgw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:43.2057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40dc1c8f-135c-4847-5b21-08dd0ee9170e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022575.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB6343
X-BESS-ID: 1732714847-111864-13565-2153-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.66.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGFqZAVgZQ0Mg0ydgo2cjCKN
	Xc3ABIJ6daWhgkmiYbmSUapBkkmSrVxgIAF/PC+UEAAAA=
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan19-156.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These are needed by dev_uring functions as well

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 649513b55906d2aef99f79a942c2c63113796b5a..fd8898b0c1cca4d117982d5208d78078472b0dfb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -29,10 +29,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e7ea1b21c18204335c52406de5291f0c47d654f5..08a7e88e002773fcd18c25a229c7aa6450831401 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


