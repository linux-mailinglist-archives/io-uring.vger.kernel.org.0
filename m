Return-Path: <io-uring+bounces-5327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CA99E99B5
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD0CC1888D6C
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C716A2206A5;
	Mon,  9 Dec 2024 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="FAGXxxWN"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7371F0E46;
	Mon,  9 Dec 2024 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756226; cv=fail; b=EGn0yoNyh+pOq+45u4SB5Gh0/PQCBZqYLPY8gTfCLdAHC6tNbOfsB3ZSz+AKqFuQu4s3jfV+XUpp1js7D3jUrP4k1+nWsBCfhS3VAwn0tCkZY8WcWx9mz+rLBe3aKnRq8ZbJdzovgKALr6Xq2/pHah6eqpiMD3DaOyj4zO+Rh5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756226; c=relaxed/simple;
	bh=pXmaGi493Z+xJwImaaI6EqAMWloNhxVZrnpvS83JwYQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n8TMShpkI7C+srDQ5qThlTwYvrp3e9oXoookh33tu6cyB2GyJ/ZaT0Jsh8I63JJ9zxbHnPkNFJCN8eajsldHZexXzidxfgrKwmprw+Qta6Hb42bgLgaHx9NXI2SQvmr4KoeJ0KHMjchHPVbmBvzuyXI6lLCw0iUTfmA2Gjm2O8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=FAGXxxWN; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40]) by mx-outbound22-162.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROuAz+D8op03/z3mOhrhRxsGeXXcONiDz90EY2Qcamg7Ow+h1BvYJGsgj+041j994RHJcbTYi4mVbRNzhIAEvrCxBlOus9tg6FWNFQab56DIzsZ8ACvVc6xpYIfh+GQcN14AGTjxf2pVsa8VIkKA6nXBE6Yt+19PikoXufnzHDAFuKnd2YuSCiQYF+pJvC5pfhg15jQ+aZ8vA2RH4FItVpGCoA+a/GcwDidsYfZEq1VPxQausxnLEH2aqtvYKwSt9tbqb3idhLF7H1S83Caqv+2FeH4C5rz4E0LSUnrM84ry2Y5hjt6z7X2Ngk3OMZtaHgcM2aQM90g0ywXYdsiFYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCKxJbX20aB+p+oZM8AKuQV84gHXK3+Z63HtwgJhJ7M=;
 b=MHeFNpRzcLS7KSkF0tJ36AAYK2WEQxJcYwdc6EXwlVdH18eCI0GevCJ1cSumRZc4gXnXrZ27iIeqIhr+n4YCM0w4H8Ij52s0u206XaRIRA6SM0c4xGdTSETJirKGwivvyzuXTaG82B7uL6Kz/oMMPhb3udvyyaABk9zOndWKEGwp6fZusOAPQB6FypP4Pgx9Zecwu8bre1KDjttTid2bYx4WASl6OhguvvTU/Fx9FTTbn5+x9MLSvgtZIFY+iV1oMW7dqknW1cWH2N1vb7jyS2BFnf0Q/4z3lTGzHnmWUCPYPtfWfEqymMSUvEGnQ7EhKrDqhADrP8MEoI5RNmGS1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCKxJbX20aB+p+oZM8AKuQV84gHXK3+Z63HtwgJhJ7M=;
 b=FAGXxxWNkin0xmLqhd+W8eDgIoVLUuAJ1kF461pXSA2bjByw0cN2R+aPicetBMejJpSdKet9sm47foo8+CVQgFllVtOC/nDz9FJKBsLnSRfontN7J5o8pCOdbLyr7hKgk9yfzcH842arrr745Y2LnoSoZE17hiCGJZWBrqk1JLY=
Received: from PH0PR07CA0030.namprd07.prod.outlook.com (2603:10b6:510:5::35)
 by SA3PR19MB7542.namprd19.prod.outlook.com (2603:10b6:806:320::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 14:56:47 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:510:5:cafe::3a) by PH0PR07CA0030.outlook.office365.com
 (2603:10b6:510:5::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 14:56:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:47 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 939DC18B;
	Mon,  9 Dec 2024 14:56:46 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:29 +0100
Subject: [PATCH v8 07/16] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-7-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=3665;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=pXmaGi493Z+xJwImaaI6EqAMWloNhxVZrnpvS83JwYQ=;
 b=4q2QZNg2ovgZn6fZYHRlTjVsN9fR2XT8EWPnjH4hPKuu+nSeRfXgDa5qBU8eETLUNOQx5cNuM
 f1UueApjhCBCVK1WtjVyPavwCaVg9NAjot2FnxEckv8TTR6G1VduPvr
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SA3PR19MB7542:EE_
X-MS-Office365-Filtering-Correlation-Id: 79df540a-d8b2-49bc-c755-08dd1861b471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlJ1TEE3eEFmc0xFSUo0N2NSaU96SjUyNHV3VUFSS2FCcmVWVEpScWRLdkRC?=
 =?utf-8?B?VzRxenc2STNBM0ZGZHFSQkg4b2h0ZEdQMWJGN2VkN3Z4cFdDeWx1V1RkSlRL?=
 =?utf-8?B?MkxQMkdWUGYxdGlOS2djZnhhVGQrc2FyWXNXcE10VFR2ZHNBRFViV2xZQUs1?=
 =?utf-8?B?S0d2NWlCdWRBVG1mMW1ZNEFkcHpCUitmTGNUNitvVW9VbUZoWWwrWlR1QzVU?=
 =?utf-8?B?dEJ3ZzBRa3J0SVMrc2p6SHphR0Mzek5OVWlnbGVKcDNJWlFrYnFvL1VtWGtu?=
 =?utf-8?B?azVmelVPbm04OU51V2M3TFFrOXdYczlEbGRucEtaOE0zSyt4Sk9JK2NrcGR0?=
 =?utf-8?B?WUw3WkN4NzhBQ1JuS3BqbkVJSlU0UUZWcWxOVklCWXpvTkc0WFUrYUh1VitU?=
 =?utf-8?B?amRCbnpjaGRoNzFIYklRVVhVNnd3WjBla0Qzb1NoVnlYb0l2VVJ2azRwaEtp?=
 =?utf-8?B?U1BzVVNxbVBxQTNWckNqc3A5bWRNU1JyRmJRd3Vid0hNdzZlSy9iTVdpWmd2?=
 =?utf-8?B?QjFEVEY0RFNBTzlsOXpyS1cvdkFMenAyeUZKRlpFVHh1cmlQbWdjazR3djI4?=
 =?utf-8?B?WUtkeUsrUWZ6bk1NcHp6QUd4MEp5dFRZcjBQaGp4UUYwVklZclQyMlpLTlpj?=
 =?utf-8?B?cFJmclZEOUtzV2FwYy9Nc1JmQ1JGVEdwc2JZRkNvTlhxRnFzc1YrTWRXeGR0?=
 =?utf-8?B?Z0hEL1lsekF4R0RQd1RKTjgxQ2xUUDJZNDhtQnFMYkR6M2kyUkFwUllDUU82?=
 =?utf-8?B?OG9XYmVETlFENmFTbHZLZjQycERuVGYxdXBVREE2RXk0ZjRoUzB5T3U1R0Nt?=
 =?utf-8?B?YXZobmJOMG8zRVQ5SHJaZnBFUHlGdi9NL0Y5QXZzbjlWNjFMaXJ1bFg0cFRk?=
 =?utf-8?B?aDBPcW5aNGtDWlBRb0w0SjUyZFY2MVJKSlRGbWozWDVGOTI0b3M0UzVEdkFp?=
 =?utf-8?B?WnQyTWpPQ3ErMnUvK1k4aXJlYlVRMFJ1Mmx2QnJ3azB2b1UrU2QwSHZnd0RY?=
 =?utf-8?B?L2tCeHdQcEZ4NjhBbTFCS3FvSnZQNFByazJ1MjMzY2pQNVNJTWVGdVAzUllw?=
 =?utf-8?B?L2sraW5BNjdubCt6SmpVNGNvdEI0b3RvV1NCN05BaU1UbnJNWDVxb2hiUEdQ?=
 =?utf-8?B?OXBpM0oyNmpPVlRxOEZ0Q21DSkQwd1pLaDd6RWZGMjkrVGJRQnZLUmY0MUdF?=
 =?utf-8?B?T0xYZnRzS3I0aWNnTFhRZGtqR042MzFFTnJVT3Z6NUtQRk02NE11ZmkvWEdT?=
 =?utf-8?B?Ny9XT0xlaXJrZjV3aWY1TjFDR2VXd0ZTcWVJMk11UW1uUkhzT3YwdHorOHpJ?=
 =?utf-8?B?WGg1Zld1bmQ1VHZUWFhBL290ZTlpY282V20rd3lpSVNxSURINjJmMDZTNC8w?=
 =?utf-8?B?VHZUaXpES3JNM1BheE1SbHRGamh4bjBVRzVLM3hBU3VoNm43UGJtSlhvOXl6?=
 =?utf-8?B?VFJURzdxUFV3OGJxQjE5OEFjN2dsdVNTZ0VYTDZhWkZDb08xRUQvOGpzb0F6?=
 =?utf-8?B?NlB4MEsvMXpnQmxWc1NJcE1EbTJlZFQ1ajlwSi92Z0UyNjdoenBNQzlkdUxI?=
 =?utf-8?B?d3ZNK3B1VHNJL251YW0wa1V2a243VkNTenRGVnVGc2J3NW8vYnoxQmxzTkYz?=
 =?utf-8?B?dENnb3A4S0UzY0RLRjFJSjRVck5KRmk2MlpWbVBKa0E5UnhBVWgrQ0hlRlJH?=
 =?utf-8?B?NEJqL2tjbmhNRHFibHhjOGcxM2NndkVTN1ArTExkOXhyTXZ0NW9oU0JhZm5O?=
 =?utf-8?B?QnpZMjFTRFZjdit1N0dpcFhWRHZnb1VmOUlpODVtbytJaTJrYnBrTWVNcUU2?=
 =?utf-8?B?cndWTkxoa2NpZWF6U08rSVlpV2F2bXVObE5VSytZaFlTQzVVYXIvajNaL1dM?=
 =?utf-8?B?Z1kwWHdqaTJobHNnUUlUMFBuUitNcTlrRlRFa05yMXgvRk4zbkVUYVZGRG9a?=
 =?utf-8?Q?hG1MyTNbmbRhXrFnqRfPAkiMdZRqUfO4?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	24RAVpduUnXtmYOyTKjve3jSX06Ql8m49wELVBJdHSQzLczI8z1NbD8rbhCCINR9rx6W4IscXNBGCuWdnFbbm75ajBwnljYb81yT419ixCFzp2OJre4v1VdIATlyhV1Q/r0VX+N6sV1sSPgonr7Eeys0zhKKdiUhJt5V4eBzmBIIENEJyR+3OPEtOtmOfaHidhpp8w0DJfVcXa5Mehv2ZamLVxbZIK4dTwLxNLBFX/mU9ECgKEGjxsh+n7byUKWE6awdClb1CNrT1jYqG4IaabgAXcN2kI7QkuW3Sf3sJzzweKz4MfwK4q/ABvf70njh85F3ixam0jiywEIi8FPw9e+dWLf9jIcIxGqziXukOS7A3o2qHWz9p65/3eQdKVssWzpMxlkI7PsHUXG1D8Kkl0bcM+ah1bYeKDrR7HX1tv5qi7NCQrwBp7p2v9XNG6nzMzK2FRpyAbut1HFF1ImVf86F59k+ZeJof/8RReUPkYEDQwoeCHYcySmgDT2lUnni/hSrGdPR/x6MrEzHYo8j/Re/eafUHS4pIjdBQt6ptLHke1XsV5UGIMxzONcOYbY+sOXcUMFVNI5yvupmcUEuZy8d7n+xhE/TADd8/WwYh/uxbNimnDa7L4G/iVu2uwpoisREReSV8zduYpfuZPFg5w==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:47.3790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79df540a-d8b2-49bc-c755-08dd1861b471
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB7542
X-BESS-ID: 1733756211-105794-13371-6924-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.74.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsamJpZAVgZQ0NLUwsQwxTAtKd
	XE3NjEJDHZwMwyMSkxKcnQwtLCwDhVqTYWALR8J2JBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan8-129.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-io-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 623c5a067c1841e8210b5b4e063e7b6690f1825a..6ee7e28a84c80a3e7c8dc933986c0388371ff6cd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -678,22 +678,8 @@ static int unlock_request(struct fuse_req *req)
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
@@ -1054,9 +1040,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
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
@@ -1933,8 +1919,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -2036,7 +2022,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 08a7e88e002773fcd18c25a229c7aa6450831401..21eb1bdb492d04f0a406d25bb8d300b34244dce2 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -12,6 +12,23 @@
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
@@ -23,5 +40,13 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
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


