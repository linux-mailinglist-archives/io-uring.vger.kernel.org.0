Return-Path: <io-uring+bounces-3706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF33E99FD3E
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 614001F2579A
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E9AE574;
	Wed, 16 Oct 2024 00:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Dwe2CFHi"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1EB11711
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039112; cv=fail; b=ZYYKSm+IGcbl0pxfx8V1qRfJzSYvvqmWzrAX2ajVkIC2ZFwto0Ac61OA3tDLRIW5QU/2tteXtK7iVsMu2fEQl10oOD2b9e6RzQd1Gdq2GnCyf6j6iC+mO17U2ydWRSG/2ORfVP6/WljVso9Y/QsjHfrsKFRFt8Ed2KEKFLjpssA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039112; c=relaxed/simple;
	bh=J9SSQv17ODP07Ds5z6GaMJIQhHLKhHt6Q3b1Pb5OBXI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H6ro5I2e5QGKysLSSYPGx11w6qvTpgxm0VeFdYrLKSJ5a2c9507TLZmtuoQv88xKyPUb0FmfdxuP6nl1ZIg0xvzGHZbXfNhOQZ8RY1qLkdMtFfRpWL6qYTps0JaYdISsXh0ObbFcMCNfNN3L6h4622xlK5hTQlOFMzAbRbhEwB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Dwe2CFHi; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174]) by mx-outbound46-22.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:38:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EsnLzhzwcalCMt48ChYXNeJJ6zlrHOHcuSmOWrqjoEg6xRYuXfJioe7BU73vTSAoQHabZXzBTVafU/hlsQSpmjUB5AfpFkrG7x5iRIxMsoK2QaE2+6kJtxWwOVekXjdAVQLGcQHjnKwIOXiVo4suxuhqi8FRkuWd3Ah1HcyB5RQBBica+v7W8wEPHhT3ehHA1zJQDEiAOrktqhvfrC4wLtPR0anHfkx9U1CMejwyt2zk33686tIGUrXWOyZQWIOms9BphKWg140EHmz4aFiKKuiFiwXDwV29zHIVY7KCyoNPutvBvzCSuetvJpvS4gNcgu9mFuTdJ97Wmc7yJhv7qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5nOAIXqSlgSEtNSF2O2ZJWiV84h2viHI4IXNhXz20o=;
 b=aHIGkzf0qhNN3xyGgzFpWNkOhdEJ1VNZuRAiuRabVqm1UV5Y9kSrOichGBOwH/ahzxE+Q+yVpCS+jAWU7lz1v3nuBooQ/T0RKnTdWYqsiAmGTIbbx0T8ePx7CUxlR2gG3GpwdfIusKl1HxLMeTx5aGj3Rt86y3vun8bQ7d9qR+9QVKpLwI2B35HJFmLBK64Esc4/pUacTn8k/qipAUXg+yVc/OmqYaQDD83WFxZZWrSnIUgHjXRHyOLel8fh7wYFE4Y1hKo5DhIt/7fbQtiwsTy7DqdJMWfrS+rHnM+boOmSVSx8kgxAuGhPVLhmuMfC9/LG+K/oj4SNIWLoxgXumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5nOAIXqSlgSEtNSF2O2ZJWiV84h2viHI4IXNhXz20o=;
 b=Dwe2CFHiCOQmeMwSmtOxC7mAfeToUKUc7UGWcIe0csDWI88aPZu8iVtqdltNXGHsl0JHwAsAgfc1PtXUbatCapKXgBXsW6epWgLn0K9dyxIuVTn4PGNdPg3rbqYqlmjbwTInUDISWQJ47iU8yCqsnRTHGDOfvs0cMVy8GAaI5dE=
Received: from BN8PR12CA0005.namprd12.prod.outlook.com (2603:10b6:408:60::18)
 by SN7PR19MB7066.namprd19.prod.outlook.com (2603:10b6:806:2ad::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:05:31 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::52) by BN8PR12CA0005.outlook.office365.com
 (2603:10b6:408:60::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:30 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8759D29;
	Wed, 16 Oct 2024 00:05:29 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:18 +0200
Subject: [PATCH RFC v4 06/15] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-6-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=3663;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=J9SSQv17ODP07Ds5z6GaMJIQhHLKhHt6Q3b1Pb5OBXI=;
 b=SqFTSOURt04x6PkDH1bgA5Sxz+T3eb65J7ftw6cMXfVSS5PPnL2XoEhWpA6H48lta6QLEBGyd
 wOubv6V0Km6CmYGMWLgEjsmqbL/jlbSvG0ItSM91Zl3fhoC7iBD+LSg
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|SN7PR19MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 88a2d3fe-c972-4969-1b5d-08dced763f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFpZZVpYS2l4alVtM2lRUTR3UlBOSkM0Wk1iUzFLTG0vMDVLcmM1SFI2dEJN?=
 =?utf-8?B?ZSt2eXFFbzRMMXAyUC9lMDVQZmZXWExQUEcvNG9Pb245MXZsQmlhdUdoQnZo?=
 =?utf-8?B?dEtYbS9NbEpSZ0EveWRIYVJEanI4QkFSVnVYeVdxL1kwWHAyeFlieWlrVENI?=
 =?utf-8?B?RW4xSUZYZE15UUg5b3dzcDA3YzBXZ3E4Mk1FZXprdWhwNnBTYWxFOUVBMlBP?=
 =?utf-8?B?T0JnbFNxdHQyNzJpU2dCcGk1NXI0RkNNL1JBTFVXVE11dEFjcXhIT01jK1NN?=
 =?utf-8?B?ODYwR0RkN2xMemM4SlpUbzl4Mjg3d0NqcW1YOGV3dEl1L2lGeXJiTndLOWJR?=
 =?utf-8?B?RkhkYW1xNFZ5R3NKazFlTmpreE5EMCszelhLa1dwYVM1NzE0WXBQbHMwdjJP?=
 =?utf-8?B?L1BHS2lnUDVPWTg5MTVzM0JyWEwzcjB4NGJoUkpjNmZzVWxHRjdvSWxFMXZE?=
 =?utf-8?B?ekFYZ2t4OWZySDNObHRSa0VKSzFSb1pLZThaa3d2MmFBZWtGZUpxRXVhSnlL?=
 =?utf-8?B?SnF5R3FFY1gwU280djNZZ2JqdGovVmo0Z0JnZyt1dnNTU3Yyd05RdG90VzBK?=
 =?utf-8?B?MVdJU0JDdGRrQ3VJZ2Y1cXNCdUk5N2YrU3ljR2F6Z09UWExhNC9FRkJHYklp?=
 =?utf-8?B?SVVkckNoQVpnVW40TkxmVTUzZC9FekEzcWZpOWVObVh3Yk5NSDFrWHdGS0Yv?=
 =?utf-8?B?WXA2ZExWenVMdEdmcktJbWpDT0FLZjhVRy9sdkh1Y3BQODk4S3NTWnhyMi9z?=
 =?utf-8?B?b3JGVCthNFdFbGlRSXJELzJtY0g0cnh1eXlNdkpCM0o4c3p5V2FacFVNQVA4?=
 =?utf-8?B?dHVHeHhDT0FIeVRjd1RhRHlnaGtwOVE2aXlHNXdib0xSMlk4R3B3dW1VaEo2?=
 =?utf-8?B?dHg1cVpQVy9VMnJlekVWK1h2NE1MNTU3R0xFcnlrVFNoMjEzcFRKdCtzSHJD?=
 =?utf-8?B?R0pXM25ETkE3enBzSW5ncEpha0ZFbTF2OUNGbEU2SjQwei9Rd3BvY3RTQ3pm?=
 =?utf-8?B?cXBhakNLVHBteDQrY3Y5NVBwSXdYQlJUdStyWUNsZHllTW0rRDF5NzZQQ1la?=
 =?utf-8?B?VEpudW9NZGFmZVhlMEVuTDRzOXk4K3luay84bUlNRVFnSXRQQzQxRGZLS3NY?=
 =?utf-8?B?YUZNVjdRY0hrUnlVcU5rQmNqV0JkclhTaDZFclV5T1VUNHJQSXpkaTZuR3o4?=
 =?utf-8?B?RVYrTklxV2d6TUdBMm1zTS9CZUZDZDhnVzRaa0RzQ2JpaVYxTWRPbTVjbmNI?=
 =?utf-8?B?bUZEUTFJNWtGTzQ0Z1ZlMFIrV2FGVTRseThGTkNzTnNkaFR3MDBDc2hZUVFP?=
 =?utf-8?B?ejdWZmk4SVU5SitqeHhmZEIrdkxFRzdPV2UvNlJEUHA1NTVGeWt3U2NVM0FR?=
 =?utf-8?B?aUlWQ1A4Q2RqdWlJWkU5WmRjL0M1T3k5d2c1SzY3QzBNaHhSaVMyNHFyYUcz?=
 =?utf-8?B?ckVmTTl2RnBvbUZ1aEVKKzM2c0FtU0VpNXNBdEpQTVd6NHFvU2hxYkRQeVYv?=
 =?utf-8?B?T2htcGtMSFdyS3Fzckl4ZW1JZXR2aW5sRDkwWlZDWkJOVi9tK2lIQ1BSWENy?=
 =?utf-8?B?bDg0bXFqSHNoaVpJdG81ZE15ajg3R1VYYmdjVGZmUFZCWkY1blhIYk1nNkpM?=
 =?utf-8?B?bFEyNm40ckE2NlVqYUlTY2tGa2dGcXdVcXdhUUFMNU16bm1JWlN3Y0RCb2Vk?=
 =?utf-8?B?SGF4SUNvTVdnQVdhbFRkWVB4WlVUSlkzQ08xS2RIbGRlY3BPZW9HTnI1WlhD?=
 =?utf-8?B?NW1KdzljKzJ3VE92VGxzb0YrcS92VVgwZXdjRSsxdTNKcG1OV2lJSEhHOXQ1?=
 =?utf-8?B?N1V2bzlrM1plVDdzL0xNNGVRUVJpODFYTnhrTnBBY0pWcWV5SUVXd0FMdlJm?=
 =?utf-8?Q?95qXjYC15JGHj?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YTLB1j9FqQ0mLCDEGdf9zxho6Y99qEjX81iUGyLeAQJfHsNRKOOI7xUSK4zO/qtI3fm5SR1SKmATcrUT1EM3ZWj3iTd9UAw1AWcM1JcLBWa0DUFpRD/TRDGb34+HII1r7Ee4JnIRAU+FXgenFB+ckO/yefzF4IGmBND/cw/xSQMkMTPqQWaswOYnKqJbcWreOQttZK9m2EPHxT/sGBlt299lBYLIKPk5q2cywY2zk4Ba9WSe8FU+ivod+qB6caUCwRH+jEsFN/7tvoddsSMQqsBLwxMOQZxy3NUsbH1Hzb41G9WYOnhB+IownnNVOmd91D+qH3OWmcMhvoD+Pxi4GzJi+I0q9cqGIToJA5ubbd748n4oVgZJ1wyXZ7GKiSxeHIfATRotBSxq/COhFHkBdbr2HFHvk3pttUdUHPohRpVLq05sbj54luVPY5a6jun3eML2QPnNwMhj0rwbkPt/HLEDo0yGRyIIhDjXSz/X5iXyuVlImW7pzS8gL/HnEXlmR1sp61VrsM7W4dpq6gfvFBwVREhpIzTKB3Liz5pywLH4brqPQepaAeUkYbR5n4W5xhqpcNT3Sp+P1Zn/aveZ2laCRftuv3yYXDEK6fCiLDhs3Rpd8mUBt4vxrd798mWH3rzpfATQZnNwpZ0zFtUcGw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:30.6563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a2d3fe-c972-4969-1b5d-08dced763f8e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7066
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039109-111798-10774-62304-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.58.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsamJmZAVgZQ0MDc0DzZMtHMwt
	DUKM0k0cDQKM3c1DDZ1MQ8ySAtxdJcqTYWAGuER25BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan12-160.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8e8d887bb3dfacec074753ebba7bd504335b5a18..dc4e0f787159a0ce28d29d410f23120aa55cad53 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -630,22 +630,8 @@ static int unlock_request(struct fuse_req *req)
 	return err;
 }
 
-struct fuse_copy_state {
-	int write;
-	struct fuse_req *req;
-	struct iov_iter *iter;
-	struct pipe_buffer *pipebufs;
-	struct pipe_buffer *currbuf;
-	struct pipe_inode_info *pipe;
-	unsigned long nr_segs;
-	struct page *pg;
-	unsigned len;
-	unsigned offset;
-	unsigned move_pages:1;
-};
-
-static void fuse_copy_init(struct fuse_copy_state *cs, int write,
-			   struct iov_iter *iter)
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+		    struct iov_iter *iter)
 {
 	memset(cs, 0, sizeof(*cs));
 	cs->write = write;
@@ -999,9 +985,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
 }
 
 /* Copy request arguments to/from userspace buffer */
-static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
-			  unsigned argpages, struct fuse_arg *args,
-			  int zeroing)
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
+		   unsigned argpages, struct fuse_arg *args,
+		   int zeroing)
 {
 	int err = 0;
 	unsigned i;
@@ -1867,8 +1853,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -1970,7 +1956,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e82cbf9c569af4f271ba0456cb49e0a5116bf36b..f36e304cd62c8302aed95de89926fc894f602cfd 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -13,6 +13,23 @@
 #define FUSE_INT_REQ_BIT (1ULL << 0)
 #define FUSE_REQ_ID_STEP (1ULL << 1)
 
+struct fuse_arg;
+struct fuse_args;
+
+struct fuse_copy_state {
+	int write;
+	struct fuse_req *req;
+	struct iov_iter *iter;
+	struct pipe_buffer *pipebufs;
+	struct pipe_buffer *currbuf;
+	struct pipe_inode_info *pipe;
+	unsigned long nr_segs;
+	struct page *pg;
+	unsigned int len;
+	unsigned int offset;
+	unsigned int move_pages:1;
+};
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -24,6 +41,14 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
 void fuse_dev_end_requests(struct list_head *head);
 
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+			   struct iov_iter *iter);
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
+		   unsigned int argpages, struct fuse_arg *args,
+		   int zeroing);
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned int nbytes);
+
 #endif
 
 

-- 
2.43.0


