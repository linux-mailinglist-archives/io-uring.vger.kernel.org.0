Return-Path: <io-uring+bounces-6008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BB6A164E7
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A65CD18869EE
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD2B10957;
	Mon, 20 Jan 2025 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="WLARAkL4"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA411182BC;
	Mon, 20 Jan 2025 01:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336572; cv=fail; b=WkrE8zDryEyIoWOYbqCWToUv1iYRPRIySRsBg6d5O/o66KKKd+poX+W3CR4I6YG+Wn2bahPAtr/3a9G+URTqgzY+bg6Wk61ong64DtgG7kbryoZixNoUT3UMMCimAYNSg7G9x8fVtPnuP9k7bD04//qscCPIcSpNy15iebsZK/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336572; c=relaxed/simple;
	bh=bH7AXbAgM9O8WxYv19f8qiXoKWtYqGZmQxByq03RmGI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qGnU/rYJ0A1Ob+T5uiIuvSrcQ3P8smI8FPxoezRWw0pWu7815cexl1hw7On67rtRlnTs22hHXY7m6tU4dYXveQZkRgpvd7DcrwSzfo+gTNexW5hRv1rgrIZ3C5XSeZyY9HJ0X+Q1WvDPYY0QbLzfadd78aUaMtzAR21uZUS60Ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=WLARAkL4; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43]) by mx-outbound44-119.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRPdkQXLnJjR6gatVDKpGHH3Lfokd/L1FRjvvy0dbHYU5ZaTL9lK8sPV6og+gk17u213q3FdNwRu4BcaAocXG9y4yPjx9/4nQAhgAqm9eL2G7RByayjYpr1Yuv04gtOZCeXKMWyZSXrPzhgOIe3gUD8xNBdTuV/hRD3pVXa6kJFUN3rLVG0NnDPWNCZ+v9UNyStGD+RphYugVTpDA8kDtqXuzpGaE1E5LY2DIW1aJRWWnTBVgTeW4sOz53jyTUWIqvowwRO0H8B0fnAKGJpp04B8a9nd1qH87MHK72qGxwfXQQpI2vnxix0AW4icdM0an0KcdIrBINMaqfY/xgI5gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJz3+THbXTIKY43167MS2efTc2Qn1MdwFPpXT/QQ29o=;
 b=cwJ+kj4mbFGTddtYIiQhtO3ZfRcjdKzYL+/O7sc9iAXSyCmh3iXB7tiQWL4SukqrxpCvUkMr9k+oS2emjvjjamc2pBtPELp6Ab+gIMMj4GIBMTrfTKudnghO6LvzpZjZx7k2IGpayfatu+1nYREpIYO2qe5NIkigOZjRh4Zs89Mz7fMQ6904ZvOTbKPzH0G4KGGx6Wf64Bf7bBJujm5A5/tVGFALJxuLbTg9/CHz3xWA9m/jslxiOgq6cMkj8bbkvgh6hv0Z6gP4yiDOP1HGV6zVqwWVZX1VwV/g4zv1P+ZuZ2/kktRqArIFg+reEmaMk5aaYp+7qx0J5g0q54K8TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJz3+THbXTIKY43167MS2efTc2Qn1MdwFPpXT/QQ29o=;
 b=WLARAkL4Ea0xd28s23uxl4t5IEZ2NO6s7QkEAMb4S5j809GqAmqB2r3uYXDzy0Yx7ch55m8PD9jSv9Cx7OWxILxXQBcQMsJA9a0R52rkjIdFclabUTWeUZHjTKBqnMmCKrdarLxTw8PrWie9i6sT5U/Z6qSdoZ7TEo721R+mzBs=
Received: from DS7PR03CA0153.namprd03.prod.outlook.com (2603:10b6:5:3b2::8) by
 PH7PR19MB7052.namprd19.prod.outlook.com (2603:10b6:510:207::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.20; Mon, 20 Jan 2025 01:29:05 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:5:3b2:cafe::30) by DS7PR03CA0153.outlook.office365.com
 (2603:10b6:5:3b2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.20 via Frontend Transport; Mon,
 20 Jan 2025 01:29:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:05 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id BD0534D;
	Mon, 20 Jan 2025 01:29:04 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:28:56 +0100
Subject: [PATCH v10 03/17] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-3-ca7c5d1007c0@ddn.com>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=1370;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=bH7AXbAgM9O8WxYv19f8qiXoKWtYqGZmQxByq03RmGI=;
 b=OTc5oGqGHD0gEZTakjGBJDWxeQhoFBRM9CEzKSxoupDHnvnqbLR1Sl+om/GroxVeG3TAis3vn
 IzQHgp/twWfDtB66Qv/SgSjmwdy+wUPZ7U8WXCAuDaQSXhul9iCQZvk
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|PH7PR19MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa8b180-8128-43fd-7c32-08dd38f1d439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjBqRW1QV2tKdHVUbE1WeUNuRHFrdHFwRlVjTTRkUG80Z0d3anVsZ3JmS0Fi?=
 =?utf-8?B?aXdrMEN1ZXhWaitVRmVQT0VNSHFNVkhVUzl0T1lmRlRvNnlBSjJHYWl2SmNM?=
 =?utf-8?B?OUtvRU13cDEzYTAvSGpkKzZWb2l2cDI4MUFsYndmRXY3SjlKK1I1SXYrTElw?=
 =?utf-8?B?RVorTThZZUs4dExYRWhJajVtV0x0QXcwMnJZUmdOMWpMcU93ZG12YWtFWDhS?=
 =?utf-8?B?R3NudFN2bW9uaFR3YWJuMXpGMWNzY3JVRXMwbDRZTE1ld01mTmdsbVhZK3RP?=
 =?utf-8?B?NE5xa3ZPV1AxemNkQU0reWliWCtDM2tWVXA2NGlvc2VyYnB2ZVl1OUtKbkdE?=
 =?utf-8?B?elA3YzBCSTl6eGFsV2d3WHZ3azZTaTdtM3hRZFowcDZodGxNQ0t4RlgyK2Rs?=
 =?utf-8?B?QUJiSUVFRmRKcmg3VlYva01aWmwrRlhiZ3piNFFHV3BxSi9iR0NRL09oRXJI?=
 =?utf-8?B?ZFZVSWNZMWVPL0I3WVZZNm52ZE1aM2JIb3ppNlRsQzk1L0UvdkdqMjc1WUMr?=
 =?utf-8?B?VnJsU2tNaFhlU2JySnVFb1hTdDRQbEUwQkptaDc1K1BaN1l0OFh6cVRKTExu?=
 =?utf-8?B?cEk5amFkNGtybU9uSlpZK21WMlJ0SU8vaTJQcGZKMnRMbXZtdThvMSsrTG96?=
 =?utf-8?B?SGVvNEZRNm42UXBxcGh6WVA5ejBqTDRuejZHeDVHYk5UUERqd20zWURNN3Zx?=
 =?utf-8?B?TWRpOTJDV0hLTmFiMGJGVjRHMHNINkZ6MHFpUzBnbzhMekZqMmt3ZC9pQVVK?=
 =?utf-8?B?NnhzM1hUNHN0ZVJrOXRsWDF4VUYvY0R1N2N2VG1GNFhab1cyRVl4ekJMenBN?=
 =?utf-8?B?WVBiOVZoZVZZa0FheHFHa2puVG40U0xVOWFOUkx0ellYYVlVcHdpcElUTU5t?=
 =?utf-8?B?ektsd0pmZzluQStqWW5kdVlvUVZDYmJRTk5qYVcyYUZXMXN0T3h3YVUzclla?=
 =?utf-8?B?WXZBSE9qd0s5blFlSnZKNWdtME9jSlRva0U4WGlRY3B5T1cxNjhRbWM4cGk3?=
 =?utf-8?B?UUI3UmpJYkVRYTkzWWZQRGRnbDFKdm1YWE9Mc0NyRnpvT3Myc3pzV0h2OG9I?=
 =?utf-8?B?YTNqMURVY0pUSkc2TmNYQTBONGNrNVpEWTBzWFNMbEZkWkR4a0JpMEtlYjJM?=
 =?utf-8?B?a1hVNGVkOFFqVHJLd0RNNmwxVEtkcUk3a0JTc1ZPT3BQemxsaHBLZFJva0pC?=
 =?utf-8?B?dU4vbUNOYUpmY0Zqb05ZWXJOUFNoT1hod3AyVDZYRjFHeE9MM1psb1MrMHIr?=
 =?utf-8?B?ZnhKYWFoZmV3S1AxWWZGdEFJa0V6N0IzTGZpQlNTMmlMK0ZMS1hTVlE4b1Rl?=
 =?utf-8?B?U3haUFhDU2hVSjBHSEh6cmdHSEkzSXdFUzVRRUpzQy9rYTRVdlpOamRGK0lR?=
 =?utf-8?B?MDFqa0VHdVBQME5hZ2UrUGVXQjE1bUs1V3VJQVBYRUJLQXBOSVVpb1N2TlM4?=
 =?utf-8?B?Mk1GczNxWk1wUXRPTFRFck1hRVgzL0w5cUxuNFdhVWF3ZHR3bkMxUFBKQ3h2?=
 =?utf-8?B?YkFXeVIwRk0vUkNnLzlZekZpTUg3UXVEUXl5ckFKTTdwS05NUUQ2bDUvUEZP?=
 =?utf-8?B?S2Z4ZnNuczZ1WFZhY21oYjFrbk9jM3JROVlZMGFmamFlc2hCMGRwRXZ2WURs?=
 =?utf-8?B?aW92YnNBRDd1enBtWUd2WWNmVzkvc2lDOGZoamJCVlVweElwRHVvNjVYaXpD?=
 =?utf-8?B?VlRaVVF5WEhZck9EaXBvUkRTUjFIN21uVURIM2VyYkoxWWZIMTgvMkU4cGw4?=
 =?utf-8?B?RndudHVlb2ljOVFzcWxhSzI1dVlSbFFCY0FrNm5KSXBSODBZYUhGOUIwb1dl?=
 =?utf-8?B?STVxeGIwblZRUmxocS9zc0x0ZS9wMGFpT2QzcGdldTY5bVBUM0xFYmFzR2dl?=
 =?utf-8?B?Tko4eGxKYmtFN2UvSmcvRFZDUFY0aGVyRy9GU1cweWNaYk02anFDWExCTkNt?=
 =?utf-8?B?VHN0WmlFOGU3YjBYNVo0TGpXQlpxRGwrSFNuUndkdi9ocFZOS2dmSFNYTHVF?=
 =?utf-8?Q?Zx/jJ2vqkS9ifxYJ8BJCx1i+oKWCxo=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4ASi1gdd4oE5xPBwh1Q0RY3PtgAsSWp8wVhm6bZsKoY3vnDc7RgzhOm9hLktQhwCk+YxEzpyjnzkkJdFvPOckmxloEWz66LYFSY5E8JyqNE0+WyyUi3TL6bljdcO7JtOb8o2QDVLupM64eK1XrK2OjJeeKp1hLd0XRAeE6e1Su0LoN4TBdtITDhxWPwKqKXLxmnWWnGLWr/RAsZKHh4WH79HJz+gRRf+47Ejqg5mRz2XrbfzgRJiZaOwdY3moA+dbhVx0m0iWQJvWKNp1RwKBdWg+RPBNQvVfsjZHJlpRMJ02Y6PIVWnagwknPYhkOkeDDMP32qK/gG1GMLR/61QC3TEppQtptdocQQ6cOThSRl88hJqGytg3Swrl7Ejr5YJL2xkO7+Hk8LNbEFWT/7YglFG1jfNKtP3uEtP2x8nOQJwSlLSYhqwEp4gAYqrIXYROuXh9jgwuP18y/15SqrdE+VbM137MqTa0lp8exBKkybCeDqral7BsCooMw3/lLL2rRwoasL1vjLbf4JoYfGWXxPRwbrLA8IfVdJKzGQr5Lh+jv8zOqFBo3CKr9w9AmGPj9XSwY0ngImLOe2PjxIp6hZ4VMR5N77YUSqStU2rzsOg4asz7/aRbl1cqJTDBm31cHa9OHWI72LMl1Km2D0VxA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:05.3570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa8b180-8128-43fd-7c32-08dd38f1d439
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7052
X-BESS-ID: 1737336549-111383-17567-36664-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.55.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGRhZAVgZQ0DLFOMnAwiQ5Mc
	XMyNjIMsnEwjA5MTE1ydIgycLEKC1JqTYWAJk6n8ZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan12-184.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These are needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3db3282bdac4613788ec8d6d29bfc56241086609..4f8825de9e05b9ffd291ac5bff747a10a70df0b4 100644
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


