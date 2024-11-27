Return-Path: <io-uring+bounces-5077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F84E9DA8C0
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4205281EA1
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14BCC1FDE34;
	Wed, 27 Nov 2024 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1p5uREsv"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807021FCFCC;
	Wed, 27 Nov 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714865; cv=fail; b=gK6dhKiA1NO+fE+bt5644Cp/xJnVlMPG89sVFLCS7E2NiyGJ1CydyA2oHOoX2Uopp/tCUDg0rYFqmgw9+VXnJh9IhNNZlEHXpePbKhxQBJPhQZCLuruc7DK+0elOHCWnaQ8QcntPjWySCnTUxePBJVMxmDnZJFD+BYUnbNFmnhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714865; c=relaxed/simple;
	bh=0lzjX4/7JNaE+LdkRqg0ZnQVuZyH8t1LjuQhvpCVxF4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tKlF8aOEAOrVtoHb8vgkCndkxpFXD449M/LACfLcv/7bhCpGSk5j/ooH26b6/3yuVfj83t26t98T3tfjAYfneZTgfNnkg3jIfd5OoRyoVj2N8Phpa4WUJ9AIGVQlVGVrJMlAviUPq9Qlg563hErOcsfiYAf54cCyHZQCZjiJ3FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1p5uREsv; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170]) by mx-outbound14-13.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOLNIwyaocoC53j1/PsAu7k+eMx77Hhk+cRnTZrzTq0mXHWK8HqOSRHK9syQ30F767wGOO/mG7231bYgwtvGy2agu43KoiS7Z8nBFvHNb4xfVbR/XjA7ZWNNd1BYrROtK9wQSDK8fvzvM4ymNEos1dK9bWQiC6IO+5erwik+M3m4iJu0duBWuy5conXWOKde1cxwKLXJHjb/b/67hzO1iT42RqlgX9diCJFK4qDB22WeM5lut05kdiCCcWYT3pYH061oawB3DWPCCD4a8XA7/nSrCW6szg0Xpv9ZTmpgH0FuOkPClLVl4pZvE7xNz7qnPkuUJVR3ZHt/3fzWoviIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09hcynU61oTWlT8A9fGNN0G6i5QxrdJeCbrCrG4GLKk=;
 b=w/5Crs9vSLBw0d/zqGQtD8OFCcI5s9BBQn56lqHrz7sCyfvd+BFZbBVnhcR1j/CHOgHm2dTLGMUJ8bKwYyNTLL58msTqGSOfIkRvbcf9tJXZ2DXqPzMMT98tZ543jatybZhCWbhBmZgdANVVJv0Mc2gugiaLnlFKEjD9Cbylub00LciDB6t4SuE5fbm4V8N8WvaGT/aRq0ImfDHA0AoeaEWO/lAfDZzFnGrQPLMTUr1rYKa5BBYtTRPLJY4dX4wyrmTTws7smXASWw2E1b575xzYDc+s7JUiIZ3btmX2cpug672q63eZWYLFTb57bL8qsY8R2L2zWs0E8gQPAvakbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09hcynU61oTWlT8A9fGNN0G6i5QxrdJeCbrCrG4GLKk=;
 b=1p5uREsvrgTmt6O45YtzoBGZ+F+7YX/ebqgUEAdlHAjxfJzumWPt4+1/pXAN7ACNAEq0PKTZOWc+WdvzJFVog1F3hMfkhcCm4DqeDOuiAr2i8EhuLbN/Z+Bfr8Xx78pGTv9f9cKTb42+MXWg5v6LpbPymCIYUtqDX7BE2M7Qhbk=
Received: from CH0PR03CA0251.namprd03.prod.outlook.com (2603:10b6:610:e5::16)
 by CY8PR19MB6987.namprd19.prod.outlook.com (2603:10b6:930:5c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:54 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:e5:cafe::ae) by CH0PR03CA0251.outlook.office365.com
 (2603:10b6:610:e5::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.21 via Frontend Transport; Wed,
 27 Nov 2024 13:40:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.0
 via Frontend Transport; Wed, 27 Nov 2024 13:40:53 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E131D32;
	Wed, 27 Nov 2024 13:40:52 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:31 +0100
Subject: [PATCH RFC v7 14/16] fuse: {uring} Handle IO_URING_F_TASK_DEAD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-14-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=1124;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=0lzjX4/7JNaE+LdkRqg0ZnQVuZyH8t1LjuQhvpCVxF4=;
 b=p8UC7auYob1Zdxd+w41lDdIpSKMOHpDDn2MT7N633Of4s14XOiPUGNJXw8qWc/1Mcirk6Xp8f
 fMP3w0SgueDD6BzeGVnU9DF70funlQUGbmg9ESpuUw1TWbP3g2dnDZY
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|CY8PR19MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: a4685903-1e51-46c7-f72c-08dd0ee91d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0p5aEZUajNJMDNNN3kyT2JRdnZFZTFuNmljUTRJczRuUFFmMzY3d0Zscm1k?=
 =?utf-8?B?eXg0dTkweHhVeHBTYnNQdnZKQy9mdmEzV21RRVl5ZlhNbmJ2TnZoMkUvNU8v?=
 =?utf-8?B?Q3lxU2dYYTlOSzJ4cFZ5UEl6aW1VSjlnVk5sNUNFRGt2V0daaHJBOVhMTW8v?=
 =?utf-8?B?QWZPWTB0djN6dmlPWHNuelA0WWFlc2NCRW9KNkVDa3FCSmVtcEk3TmRNZUZp?=
 =?utf-8?B?WHJCZmdxTUl0OTVLK0RiRVUwM2tsWndGQ0lYNDRkSjBraUJZaWZTZmVUcVFC?=
 =?utf-8?B?WldvR2hha3RaUWJqc3RJWHo0RXJDWGdyNTE0QzY2aHhtNjFFMk1reGdmaDV0?=
 =?utf-8?B?N0U5c3FuMkgyamZCa0NTTWY1akdGdnNESmVlMVVWMHVwbFFGNkhucmpaK3FW?=
 =?utf-8?B?RWg0SkJvWHA3ZlFXU0l1USttZUlxSStLSlNBSlE4NXRaZjVyOFUwdCtDSFIy?=
 =?utf-8?B?K285c0dqSFFkc2tEdE04RVpNeEVKSU84RHU0MzBOWlV4UTFPM3ZyVkVtbVNo?=
 =?utf-8?B?MVN2T08vb0xaMEtqVVlKME9ZTmZ3d1gyODRIaVEzQm1SY3l6Ny8zWktkdEVV?=
 =?utf-8?B?M2VvVG5ITXh5RUNvS1pIS3ovcVRLMGpJQnFZSlZ0OUVzWmdxODg3Vy9RVndM?=
 =?utf-8?B?Z0l1dW9tVForeGV4MVRselJ4czc5eWJKaE9yeXQ4T3pCWWZZY1RSNEI4c1di?=
 =?utf-8?B?THlvNnR1ZWFyZmlHYWVYbnJZdlNMMDg3SGJrWDVTQ2JYN2FNdnZPVmRtODVp?=
 =?utf-8?B?Q3p4bHJRUFdSS2NJRjZXbWg4elNVTmlRN1RkOHptbjEweVg1RWJzbVQyYkNS?=
 =?utf-8?B?alFFV0ZmU3lHZk10eERJYitFblV6MTU1MExzUkRKUHpwZ0RqaldESk0zZERV?=
 =?utf-8?B?Z0NRUW4vWFkwZ3BKWlNJWnNhQVEvb2sxWUpGeUxNTVhDK0ZNNFAzZ1dkdStX?=
 =?utf-8?B?MldlSnlrb21rRjdMcmFJb2FjZFpZdWc3TjVsSUhoNUNRV3QzK09EbzNkR1Vk?=
 =?utf-8?B?eTFCWkVtMHFJQlJGbkFiWHZMejRPVTZCVXdsL2xQMnJyenNXd0Vhcmd3bXE4?=
 =?utf-8?B?WWR0dUlMaG5WenBjNW9KWWhZczRVZ2FkTmZzdnJDL1dyaUQwSEU5QmhGenll?=
 =?utf-8?B?Z0tVeDh6b003bFQwRDE5N2FFbW1XZ2V0N0dSSks5MFkrQnd1ajVIU2JEcUpC?=
 =?utf-8?B?YnJ5S09OSDdhQi9lRG42RWxNRHlvVlhZT0tqUE1qaU9EblRoUWF4U0xFMldz?=
 =?utf-8?B?aFpvN2RkUFJwYTdzdXJoL2lrRTRuT1dhdE1oZDFsTlQxRkJ0MVU4RW9maHF5?=
 =?utf-8?B?eGl4Z3VGUmhpUTFKNGV4YmpucENzVnFxcTlZWVVBUVZnaUgyTzB2UmppTGYw?=
 =?utf-8?B?ZjJnZ0doQzdCMWtNMFJ5ZE9BYUJaUC9xSnJtNWQ5V3l2ZmVOc0VEd0tkbFk3?=
 =?utf-8?B?U3QyYTVFM29oa1VGUlMraVN4Y1RRUnJYVzdoOXdyK3h6YlBmZXVJTTZhWHlX?=
 =?utf-8?B?ODR0SEpFdnFGVnNVaVNlQ3YyQVgzdmVWU2YvbnNGOVV5M1VXOFcxakRpOXlR?=
 =?utf-8?B?eU5WWFNJVnk5clE4d1h1UzNiQjFxd2xvcHhkM3EwZXlwd29iVWhMSE5uQ21k?=
 =?utf-8?B?NVdvdnJZZnkwWVBQU3AzV3BJcERQVmwyM3ZtVGxMUUcrMmFuSWFnZ3h2bW9a?=
 =?utf-8?B?QmdxNzRodWN0cm1lWm5RNDNCcVl6aVZ0ZGN0c1BMUlljb1JGdmF6SGM3amtS?=
 =?utf-8?B?OEdiVmh5WVhZWXVLOGJRaFNqQmt3NWJMVTJwYnhpWkZqQ2NOck5jTy9SZGNH?=
 =?utf-8?B?STkwSW5ncWY2YzVSRytIWC9rdG5SaFMzZWY3dUNEV0ltR2ZmcUNZR1Vad1lY?=
 =?utf-8?B?SnhWTGhjRGxvRGh5eWIzYmpHOWFqNTFDM2M4bWdaL0pLY3lrNTZpUk9JWGZo?=
 =?utf-8?Q?T3GC8dcnySKgKawSt6oVoIjGzc7rEyZ2?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XwrpNgSwfPSYv1EpgxmiFbVkgRnFe17a1FuTscUf1xIhx914ows2kIzn8HwBVJ5yfv3icxwH0bimH4PoTaIY7GYyLp8pxh5Ejxe+nyo33eqtdqSbAaZcyxjanDBe5xW4CObiHfgzlnQf9QZYOYE+Aw4y0PCjl0EhhrvOwQYFEcRrfzVqt0ita+BNFbX30GFtYznnPHNPxtZcCZCtw9PLK1BRx2RwL3LgQ2QJBL9+pgfFXFekG4cbWvSTazuFCVxmQt2gQ1bfJ+3rYomNuevKboOlttWa9fQ285YAn/WB2zHML6yqN87IiuCixBaXB/TG+GMZnfks7wfs7OwC+NgCFhdRiTYqXA07Emi0zSX2VmBC6ImROe4gwND3O/puXqmVqFs+wJAAQiOeTf36UvodVCCLceI1ZD3S4Pgx0zvU6AV3UTLVV4uzdnDWecvDFveIEHvdvC+hdB5u6AySoGnbpawekJngMBNwGIySgKfv7kv/ylJ5S/ljGTNmfozQwIv3RaiCnvL4AmQ13aPVPCMZ3bnFYcoCVtTKe81iSnAngLE9SHVYueaAGvhx48baW+PJXbSwPyrmvjpID9pV2KGj3FSOLwJRthlR3thOfuaFlgbevbZQu3WI5Q7JpgnyAW+2qAVbfEFtBRxspLkcMX0ycQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:53.6834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4685903-1e51-46c7-f72c-08dd0ee91d45
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR19MB6987
X-BESS-ID: 1732714856-103597-13475-2202-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.59.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGFqZAVgZQ0CzFPCUxNckgJc
	3SMM080dTAONHU2DLV0NjY1MLcNNlIqTYWANaAcZhBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan14-190.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

The ring task is terminating, it not safe to still access
its resources. Also no need for further actions.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 66addb5d00c36d84a0d8d1f470f5ae10d8ee3f6f..94dc3f56d4ab604eb4b87d3b9731567e3a214b0a 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1056,16 +1056,22 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
 
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = -ECANCELED;
+		goto terminating;
+	}
+
 	err = fuse_uring_prepare_send(ring_ent);
 	if (err)
 		goto err;
 
-	io_uring_cmd_done(cmd, 0, 0, issue_flags);
-
+terminating:
 	spin_lock(&queue->lock);
 	ring_ent->state = FRRS_USERSPACE;
 	list_move(&ring_ent->list, &queue->ent_in_userspace);
 	spin_unlock(&queue->lock);
+	io_uring_cmd_done(cmd, err, 0, issue_flags);
+
 	return;
 err:
 	fuse_uring_next_fuse_req(ring_ent, queue);

-- 
2.43.0


