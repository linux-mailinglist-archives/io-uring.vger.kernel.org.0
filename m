Return-Path: <io-uring+bounces-2993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD71C9676A7
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 954DD281BA7
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E656E17F4E5;
	Sun,  1 Sep 2024 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="gKqcM3Cr"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4474A14F9F1;
	Sun,  1 Sep 2024 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197839; cv=fail; b=GpoCAKabNk2ht85hgt9jGk60WLQs4DJzuMxE67NcLWpOzGhqYBtLTTKbbnhZDgn5AksHqvHJDj7ckrDYfFu7cfYiaR3uoiioursOSzfJU/2VV8HGdv1R5lFUDy3hrsmsf/7FNOV+rOBiWWYfe4l64HDiIPSWqlUUz2THSCwNTew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197839; c=relaxed/simple;
	bh=uLVuRbDRdNskIgEn+OHh8ksb7ZOBJ99vCuhAK7xxins=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s7x0X6d4xqUdcbU82qayxJlnobCD0cZ2gsNK1XcLtz0wQhzuL6jWZUCZF66tDbMo8qaZ1UQY5J5uVePsJ/diOyzvFUPTdBJZcSrZvXEEKnITYvRN3Ah4PaIQHeN4Aq3GdUjyHuFbAvOfJFcSGNj/XzBhRVvPVfx7w9krtETb9EM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=gKqcM3Cr; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171]) by mx-outbound46-102.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BQiy/MiO2xn+kHLULsbE3OIq9Rp5V8PFusgpxZ9QUlMEhEMqxScgutPsShz4D9BXejdLNYyc6uqMv835qd5EksFnOFdIfEEP3fpphHzPv58gK2orw0vQh3gow4V1HGyo7oxBcPAGgiJsu3/u1xzub+7HnFeYNcY9haVuOYHcXv8rO6o5K9HPUHvBn9BuevzFHF/KLb4g3SVWSdbq9Km78WdCBf6qJI/Z7kxm8l2+FyP/nlzloxeQh8/YqjB64aqKQboETbi1xxzq35HZ4UvmBnuh5FFtF2PwSKcO9FMY9jgcttXtfRJN02EodXlU0LivF5AkJiaYMvSHsOiaGgECDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkCkFVmj73WwUKv/B6JEhehEIp/wAG43uxDCFspdcvE=;
 b=UFMRAoa6Djh8eey2Lj00Vo9CZ1qY40iD8wZWJuWmEKPoZW5X2gKx88OYk549tz1jVPHPL3SizxszQgjbSUWsXyEmgiEZpUUAklITCv3x/x0dP2vFE1wrLtY/GCiWhVtYDRl6cUOFOIUTF5SDkQNnAN2yKdL7qEunB5bE0A/5PVGmlgD6rdzB0aj3oVzdQ5Cyif+OwCo6dFBhLD17vR/gsJ0XoMyxtMZIy1abrJ/V/Syl4LSczmdasMvPRMe9q07jpwWGCSoBfrz4BBwS5YF5nTbT3t1Ql2R3OzL9Aas9JxUTi/BWwyEiDsxtZk9fJ3U0xRMTAz/J+a4XT9+Ukbbw3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkCkFVmj73WwUKv/B6JEhehEIp/wAG43uxDCFspdcvE=;
 b=gKqcM3CrkYXkYZKj48EInK7nbKyaLvIW81+nnuxUbHTc+v2m1BKAU9jU1/RXuqFSQVgLw6RLgZA8ilddYmB4e8tAOdSDg34CEHBX1lKqOSA2+x4+tS0KzeyytrCzlUc6bc+O/hWntKsW2S1VxjqDK63FH+fqWzYcFEe8hCL6zpo=
Received: from SA9PR13CA0012.namprd13.prod.outlook.com (2603:10b6:806:21::17)
 by PH0PR19MB7426.namprd19.prod.outlook.com (2603:10b6:510:28a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:02 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:21:cafe::51) by SA9PR13CA0012.outlook.office365.com
 (2603:10b6:806:21::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:02 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8E43C72;
	Sun,  1 Sep 2024 13:37:01 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:36:58 +0200
Subject: [PATCH RFC v3 04/17] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-4-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=5011;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=uLVuRbDRdNskIgEn+OHh8ksb7ZOBJ99vCuhAK7xxins=;
 b=MHP0dubGPSk/WDuH10OFmqwWHyPFvR7vxYkfnOzhHjQy38Xe7ivqY+5ysYgyg7HytV3xdFVJG
 P6r8A/fG7HbDNKYUR0IUyD3pUMMqJPOGj37c9oBxOURIfIDFnQ7HzIY
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|PH0PR19MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 456ce1a7-a28a-4e86-b56b-08dcca8b2950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEtKTnZLc2g3VWVianFIdExGTTBuNGxFYlZ4WGtlSG81bW1DM2N6R2RFdE45?=
 =?utf-8?B?VVBqN3pjRjlYeWhzNWd4SEZFLzlkM3hmaiszbmYxaUt6bUQ4RTA3bW03aUNp?=
 =?utf-8?B?ZlY4aXpmVjkyMmdmUm91cmxDTG5LTjlmcjRmOXZFc1FJZy9NeHVEcitUdGRJ?=
 =?utf-8?B?T0pORG9PenFKMGYwUjB2RVNPem9nM1B0Z2JDVENYd3RLajdPQmZKVDE5WGtT?=
 =?utf-8?B?bWxuZ3ZKR2FuV0hLdGc4MUdyWmE3NDNGUGRBbXQwLzFJVHpYWElCdDBiT3JP?=
 =?utf-8?B?djkxODFFcVhEeHJGTGNkU1l5ZER0eFh5cStYMk52TTZ0ZG9CNkU2ZUFBUlpY?=
 =?utf-8?B?RUZudmNaU0kvSzdDN1RkZkxaUDgrOTQ3RFlWdFhTcFFVR3RLYy8wV3ZMYWdm?=
 =?utf-8?B?ZW9LTVI1QlZWR21acDdvTmc4NlBWdHhKdHNPRVMweGQ3Q3ZUQVBoNkV4Mkp5?=
 =?utf-8?B?enlIcWtOaGZRa2R2M2FkVm12OHkwb2ttUFlHMW1CemtFTlI0aS90dmNvcXVm?=
 =?utf-8?B?SFNXSkZhc1pOT1FLZjQwL3V2d2M5UGJxcW9INGhZSkZuQVhmNk9nK3U1SzhV?=
 =?utf-8?B?VlpzQVpPbGhscE1GWm01Y3BKSHAraTc2YzZueWluenJDaVN6VEpkNFhrOUZY?=
 =?utf-8?B?dVFqOFp3QTJaNmY3YkZsRnJJQWdBSkdDdk9FU3VwVlRpSXN3SGFFa1ZOaVJs?=
 =?utf-8?B?TWJHSFVoWWI4aVVrd0tKREFBV2UzajVUb3BmQnVhc3grVUtLR3B5RHJtQWJG?=
 =?utf-8?B?ZW4zVWpjYmJ6djRucTdMNldKZjYvMHd1Ty9vb3FHS2w2VHBtdFk1SWpORzVj?=
 =?utf-8?B?YTRhTFVSVzZ6SHpaSWNZYWpORkZTZm91dGRINWFyb3ZlRGhrbGtLSEFxM3o5?=
 =?utf-8?B?d1ZaMUdndWpKYVAxdjJITUorcVhhRzJoNkxJZG1ya0wrOVh3Z3BBdm5KSEhT?=
 =?utf-8?B?SnZhUzlFYUk1MHJOdlRVdy9HdnR3cExQTURXNzkyZDZ6c3RaREd6MUZTY2VL?=
 =?utf-8?B?QTBFNGI5Znc4K1JLVjNiU1dVQmlFWVdnZ2pmTUw2QWNjUjRRcTdnMzRnRHhH?=
 =?utf-8?B?cFpRc3VOT0tNeEZ5SW8zb1Y2K2hSTnlZbDNUNVV4ZkdocVk1aXBhUTBocFJh?=
 =?utf-8?B?QW9KUUU5Mk1KakxSdVdHaFQ1a1NVc1A2Y1N2cFNtSjZ5WXNtL0NZNE9zT21R?=
 =?utf-8?B?NHRrTWVwVjFOWDFvWnU1SkZPNno4b0plUkFzZUpMTSthamJRZnNoWjcyNGV4?=
 =?utf-8?B?TXdhaGM0aVZ0cUZoVVRoWG1pcUVpdjkrNWE2ZUV5dkhxajJkWEJ0elBnMXlM?=
 =?utf-8?B?aFlVQnJsZENJbTRSVk5Td3ZBZzgyOWRWSG9Ldjk2S0ZNd1RrRXUzV0VoRm5a?=
 =?utf-8?B?cDMxYzd2WU1MU3JhaThFKzEzdnpxbXo3ZXBZRnI2NWNUT2tXcFZINE1TQUw4?=
 =?utf-8?B?UmJORktOc2MyTE03Y2VVZHcyZ3MvUHh0ZWRDakhZKzREWGpQc1lmNFVLZEdy?=
 =?utf-8?B?MStIeHJIb0kvaStpZU1JakVBMFRzVzdWMXh0SEthTWpRQVM0REtZUFE3OHpp?=
 =?utf-8?B?T1ZBcHZURVd1RlNZWkxLNms2YXJBQTdwdnhmRkNDdzhqRnJYWjRIS3J0MnRy?=
 =?utf-8?B?RDI5YWdlTHgrdkZjcHpVSVRvb1lvWk1hQVo0RThXeFpWSUxPWUM3OG1OWkxm?=
 =?utf-8?B?NHg5ZnBmcnZzazFzYmVqZEw4ZmdkUTJTTDUvT0l0TFdHWHk1OEM0MU9KYWd4?=
 =?utf-8?B?V3pFOEQzWHdwd2JGaVo0MVQxRU5kRkwxMmxWVnZhbkVuME1JajdWQlVvaWZu?=
 =?utf-8?B?c2lXY1pmcDZDMWdpRWQxU0hMQ3dZRDdsZy9lM2tYam1MVENZbWl3d0FzSHlI?=
 =?utf-8?B?SFFtU0hPTXdMUkE5cHg1Qnd4TW5iZUE3d2NMSDlmWU1RK2R4a2pPUkxKMzQ0?=
 =?utf-8?Q?H8TO2K5rdxJoPq5d/jkpWHfWaYWsDyeT?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	69oQE6ibkMf4ZE/B/maCfgRnmZtCTTvdlvIHr+LFiobNhSVPuBE2ofk1CTsL71gnGllG2ppl0oPWEApn+ntm68USYHb4atE9JpMLvBq/LL5CuCG0inaxRrPkZl4IiRsM7g4DFQAwtI3pFxdqftV6HonMLwUSDkAo/45RobH2ldVNBP20IYhjcnwFezv+cgXff1YjFUjIyLqBo4aLQ7TMltk69jeiJ4ZXglWjN/nl4HIqoQ4N9B/xz5vg+dC1h0GYmh1DG5PkdiWS0BfRNH1r0YBIJxf1ZDusIeW/9JrO4ZZBaYCsO3RlpaHETS948jMX1UDFTq1NVCd5Z04ZCnH/Z3iTbnST3lMqHh3XmopdC+V8dw6OXcLO38W2ULbUtWJcoczEhl4ZYHPrSkYGKIdK36i1EWbBVcUYf3pXx7IZIxCfnV8Wjo+2Vv+p09DneDIWhULu2LnuwtfQDvhBfzjHZGR7zuymeZb1UNpTjeskRZcMoRTKzPtISRFIUDEtgGk9+LBsbeIjvYcqNn1amoWhryWmN4Mk7kT5tXGzlwWGBRe7B097EbE4/GecO5qbjsAWbesXkWta3dNr0s9qnLz/dXDxNVzPVtWxTDmsZrOfR1/HsJnawwGQ1nJip9XtcFFNvR55VwrwlgOlGBb6Q5ibPw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:02.1250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 456ce1a7-a28a-4e86-b56b-08dcca8b2950
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB7426
X-BESS-ID: 1725197825-111878-25435-67287-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.57.171
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViYWlgZAVgZQMNHEwNIyMdXIzN
	g8xdQ00SLFODnJ0ijJ3CItOTHFIslAqTYWAEqm3Q9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan11-219.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 108 ++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 000000000000..0f1e8bb7eca6
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,108 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+FUSE Uring design documentation
+==============================
+
+This documentation covers basic details how the fuse
+kernel/userspace communication through uring is configured
+and works. For generic details about FUSE see fuse.rst.
+
+This document also covers the current interface, which is
+still in development and might change.
+
+Limitations
+===========
+As of now not all requests types are supported through uring, userspace
+is required to also handle requests through /dev/fuse after
+uring setup is complete.  Specifically notifications (initiated from
+the daemon side) and interrupts.
+
+Fuse uring configuration
+========================
+
+Fuse kernel requests are queued through the classical /dev/fuse
+read/write interface - until uring setup is complete.
+
+In order to set up fuse-over-io-uring userspace has to send a ring initiation
+and configuration ioctl(FUSE_DEV_IOC_URING_CFG) and then per queue
+the FUSE_DEV_IOC_URING_QUEUE_CFG. The latter will is mostly indentical
+with FUSE_DEV_IOC_CLONE, but also contains the qid.
+
+Kernel - userspace interface using uring
+========================================
+
+After queue ioctl setup userspace submits
+SQEs (opcode = IORING_OP_URING_CMD) in order to fetch
+fuse requests. Initial submit is with the sub command
+FUSE_URING_REQ_FETCH, which will just register entries
+to be available in the kernel.
+
+Once all entries for all queues are submitted, kernel starts
+to enqueue to ring queues.
+Userspace handles the CQE/fuse-request and submits the result as
+subcommand FUSE_URING_REQ_COMMIT_AND_FETCH - kernel completes
+the requests and also marks the entry available again. If there are
+pending requests waiting the request will be immediately submitted
+to the daemon again.
+
+Initial SQE
+-----------
+
+ |                                    |  FUSE filesystem daemon
+ |                                    |
+ |                                    |  >io_uring_submit()
+ |                                    |   IORING_OP_URING_CMD /
+ |                                    |   FUSE_URING_REQ_FETCH
+ |                                    |  [wait cqe]
+ |                                    |   >io_uring_wait_cqe() or
+ |                                    |   >io_uring_submit_and_wait()
+ |                                    |
+ |  >fuse_uring_cmd()                 |
+ |   >fuse_uring_fetch()              |
+ |    >fuse_uring_ent_release()       |
+
+
+Sending requests with CQEs
+--------------------------
+
+ |                                         |  FUSE filesystem daemon
+ |                                         |  [waiting for CQEs]
+ |  "rm /mnt/fuse/file"                    |
+ |                                         |
+ |  >sys_unlink()                          |
+ |    >fuse_unlink()                       |
+ |      [allocate request]                 |
+ |      >__fuse_request_send()             |
+ |        ...                              |
+ |       >fuse_uring_queue_fuse_req        |
+ |        [queue request on fg or          |
+ |          bg queue]                      |
+ |         >fuse_uring_assign_ring_entry() |
+ |         >fuse_uring_send_to_ring()      |
+ |          >fuse_uring_copy_to_ring()     |
+ |          >io_uring_cmd_done()           |
+ |          >request_wait_answer()         |
+ |           [sleep on req->waitq]         |
+ |                                         |  [receives and handles CQE]
+ |                                         |  [submit result and fetch next]
+ |                                         |  >io_uring_submit()
+ |                                         |   IORING_OP_URING_CMD/
+ |                                         |   FUSE_URING_REQ_COMMIT_AND_FETCH
+ |  >fuse_uring_cmd()                      |
+ |   >fuse_uring_commit_and_release()      |
+ |    >fuse_uring_copy_from_ring()         |
+ |     [ copy the result to the fuse req]  |
+ |     >fuse_uring_req_end_and_get_next()  |
+ |      >fuse_request_end()                |
+ |       [wake up req->waitq]              |
+ |      >fuse_uring_ent_release_and_fetch()|
+ |       [wait or handle next req]         |
+ |                                         |
+ |                                         |
+ |       [req->waitq woken up]             |
+ |    <fuse_unlink()                       |
+ |  <sys_unlink()                          |
+
+
+

-- 
2.43.0


