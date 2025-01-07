Return-Path: <io-uring+bounces-5708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5C9A034C4
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73BD93A50F6
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18193FB1B;
	Tue,  7 Jan 2025 01:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="pdAjUUqT"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805D88634E
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215143; cv=fail; b=H7g/CsP/EyPLTRFlhaF4tvDEfdA8FLGqHKnNoRXKrpNJZ58/Z7fVje83iWp/KXW5kjtthvINMeSkz0+V85TyECCpoiXxu5S8TZovlbJ8dSTR4R9Yy4NRInRe2je7dbi3Z7w893HSFkKTwJGD8pCsHdvmrF9thR6E2KZi7q64rwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215143; c=relaxed/simple;
	bh=fNUg9cOsdJKnBFTm77Hiz1GjeOlvcY8Sl85YUhusxww=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DXttK/fP67EoVHTstDV/DermNAR01aTfxw218tpzFlSr8FSAw6up5viYmdAv9Q6IhXQqIFKAyc/9iwbI4rEZJNhFnRd8LtEwmzct4qjijTJFRdfy1Kyh2Jto6dV6P1m+BFThprFsS4vvjCvDwkosxiGjT78UKX4rLz/xJ1EIEeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=pdAjUUqT; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47]) by mx-outbound40-113.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:58:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wFYKGEjscjQEeuxLidMxxPOQCg78yER7FOl/6GTBJ/d+jfiloDF+upySL3PXwBTgEjPwT1Z0OXimHHIsmm38yMJMkC8BYwj0CljzIWtc71+BBlX8Y8W1H/zYxeOlZDNiuWqVlRh9qG9+4/9m0r9AeAQzXGXdDrrVogLHyG8DKh6g5QaIdoGMIta+79Ako1YSmxwXKimPOW+tVWbSx4kZASB4PJBigszi/4OtHgKV0iCoYBJHc6SNfIDpDgr46hj7ESEPrEjXBaFMmAfiPi28Y2U00MPEdh7uTixBWUSffAc7A/QFiycsitEdj4fYptN/f7gXlxPPMgeN7ka0HCpmVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RnVUc/3CuQct4SpjwW7lsWhltUe1uCWqWgoWz/N8Bg=;
 b=mkpAWaazW1aiG+TH3tFamZgStG3qpankMI5FGwfaImCZTd3MlahCU3eKp6rPMywQJGvp86kLkB26cFF7h57AsWxDsD5jPIMBOobzXp9E7ccKIJz9FTyHjhtmVh0PoHLnW4+FticPwuNUYeYguJG3LwWE5hoifx1WCq1HfXRnjJC30B96+dkatW5ZUc5o1cKPBx63JaCF3OShTgL+/yl4pDAFFHWRckNkF385+ufffJVkYY4fT1+4BF5bGXqoQOZjgReoIo9/WtvSi6uo9QrtGvbLTkbEhBL/nvTRkdP4AMSuL3Gb6sRgjyWaAFmJULidhRAsZF0lpLxfO69D0yXU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RnVUc/3CuQct4SpjwW7lsWhltUe1uCWqWgoWz/N8Bg=;
 b=pdAjUUqTcR7/pEXuEB6txqPglcHghjGr8oOosAwHSjmXzaVtJC4dSh1mQatF0rP1Lbwe9gVzgsO4AV4l2BC9v6ZBOn1allODGWIjPnK9bCc/K7VBGzxASUgPeXQHqU3cEGrG0i6zJ7y7LWlKeV9gfIRWNxePHxicw8ftyGDyg6w=
Received: from BN0PR03CA0019.namprd03.prod.outlook.com (2603:10b6:408:e6::24)
 by LV8PR19MB8517.namprd19.prod.outlook.com (2603:10b6:408:1f0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:26 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::8a) by BN0PR03CA0019.outlook.office365.com
 (2603:10b6:408:e6::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:24 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id F33B24D;
	Tue,  7 Jan 2025 00:25:23 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:18 +0100
Subject: [PATCH v9 13/17] fuse: Allow to queue fg requests through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=8153;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=fNUg9cOsdJKnBFTm77Hiz1GjeOlvcY8Sl85YUhusxww=;
 b=4a2z1AfKwTgm3rE0gvTza0ZS1U+Bw+41ScNwg+8MpN/d7UCxh6jsKj4n6mQ/PsanE3s4B+qIj
 1ikOqwYfbZzAKQ1NLfgHvfFDsUepvy9IpfhtTYLar2Qa8FITcxRmtPZ
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|LV8PR19MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 9217b921-9223-43bd-96cd-08dd2eb1c7a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3JubkFpYi9xdWZrRlRqdTl3VWNJRnFLaXNtVjQ3L0xNMFQ1d3hERlFyL2RZ?=
 =?utf-8?B?YitrRWx5SUxrdlllcWdXVXRSYURCVnRUZTJrak8yamFGOUM3SlNiakl0WmR0?=
 =?utf-8?B?UkdaeEdJeHBDZ3JRM0tadXFIcGp5azh3UzhHeENUb3Y4Q2ROaVFmbENyZEpo?=
 =?utf-8?B?ZHlkUDdWMmZqSjNIaDE2MFRRNGdtUmt3US9uTWJwL2pRMzZlcllROTMvcS9I?=
 =?utf-8?B?cGg5L1JWRkhTeDk0bHhvUGs1d05uRnFMT081b1hUbEFhLytkMmtweStXY29C?=
 =?utf-8?B?NWdoNUliWVB3RFU3OGNOdklXZDRoaHl0VzJsbXdCbzdjYVQ2VWxLUTZPR2xP?=
 =?utf-8?B?YU55ZHNvdGFURDFIdEU4b0g2UGhFUUE1eWhUeDU2ZFBzeVc4ZzlORlA4NkV5?=
 =?utf-8?B?OVZpcVdmSENYYXJrS1JJc3FQZDNRa2ZTOGxYYUpoa2VlUHlMckR1bDY4V1E2?=
 =?utf-8?B?ZW0rVzMvakNoRlBBeDQzVmoxYzU0cGNiN3NIRExDYmI3Witsc3hLQ0tBSzY4?=
 =?utf-8?B?dCtHNXhHRTh5L3BUeHhqektrWjhYa2hza2tQcDBiVWdIQlVaMzdmbS9WeFhw?=
 =?utf-8?B?bjZXUkVhS0FLbTFZdXh6T2NEME96SVVnNlVXL1cyZjNRMlQwZ3FYdEM2VVY4?=
 =?utf-8?B?R0NseEthaGtXTGp2RDdrMDVIUW1oK0F4d1ZvMmFtUG1KYTM5UjJ0WXg4NVV1?=
 =?utf-8?B?cSs2Qzk5U0ZQMS9qakRxZ0k0cWc1cFdoYnJ2SENkMzNwc096b3BOVWVGR3E4?=
 =?utf-8?B?UUtqVkZYZU15Wml0SE94YXlnbnZyQ25Ib3NZRUZRK2ZZYnFmNVBiVTBGWHlB?=
 =?utf-8?B?Nkh5ZU5tczRNd2krQXViakFrZ1NGWGs4elhFbDdTZ1U3Skg3RTRDWW50VDAx?=
 =?utf-8?B?Tm1kazRGUWxGK0pXV2xtVGg4cWFzV0tJVVI1MjE4Zmt2UjJZVVY0M3EyUXh5?=
 =?utf-8?B?cERzSTNFVFdsUU5lSHpFNFJwYlpMSEhid09Zdktob3ZiOGF0b2kvTVBJdGg2?=
 =?utf-8?B?NFRveDdUcTd0bGY4a3ovQSt4aUNIR2FERHRIcHJFTHVTZm56VGt6R1d1OXpP?=
 =?utf-8?B?UFFxcVowMnNZZjBVU0orSDMyOFNhNmRoTkhpeEpqdkNmRmQwa1VaSFErYXp6?=
 =?utf-8?B?MVZCdVgvTTZFVm5ob0tQZEc0d3NwQXE1ejZOSStmcXlvUUJzZ2lMOWhyWENq?=
 =?utf-8?B?Kzh2bXdzdU82bnk2TVJXU2RmNmMxTGV0TEpkUEU1SVFMVFhvQnZJTko2ZTVy?=
 =?utf-8?B?c21uQWcwZHBjbkwrQzhwZlVBRXhVcU1FY3dLcjArZmF0N1FwTFVZRm5VSkFK?=
 =?utf-8?B?ajdkNU5NMjZ4aUxyR0cveG5uRzljQlg0eERtVEZwUjk4WGE1NnV3bnFreFV5?=
 =?utf-8?B?NTNzQkFyTFBIN0hPdjFJRHMyU0U2MTJYcjdrbEpFcXY3bnRtK3FDaFNnTkRK?=
 =?utf-8?B?NkFLbjN5QTloaU0rMU9RdnZvdmpCbjhhMnZpUWdGRDlxYkxqamNqOWs4Vk9a?=
 =?utf-8?B?WHFoV3JwakFQUCtLVFZFSkkrVGFLNmU0dy9oYnVhQVFLdXZZangyM0EzR1dm?=
 =?utf-8?B?bE42T0dYSWs5aXJZYWVkeXErcEJiRzZOZXYyZkR4RmlhRGJaZ0NCbDVEeldw?=
 =?utf-8?B?SmRhbkMvZFVGZ0J0N0Y3ZjFEQ1VpK3ZDeERDVWlWYlkzS3c5R2k2Z2ZlWHhi?=
 =?utf-8?B?WFpPRjltUU02aWpsTkdMUU5KVk94YW9tdEFOc2k5OFR4eklIRmlkc21idWcz?=
 =?utf-8?B?eWdkcE9aYklsdmxNNXZBYWw4ZDdQT00rN3hEczRocmdYOGN0T3V6YU1GVTBV?=
 =?utf-8?B?dUN5a2RBaHEyQnpUK3QzRGt4RVdVMEZHcUhlOGl1N3krU1N5ZEtBMng0VTJQ?=
 =?utf-8?B?VVNtYmlXaGc2RC9SSTJubmZFMDZBdzJSemVNbkdJZU02aHRWTnpDTHJkeEFK?=
 =?utf-8?B?clFsWGw2OE1tUnYzSmh2cFZLYko5SUxiMXk1VzNqY1FqV0JkNUNBaFBRZjVD?=
 =?utf-8?Q?Fz8teVAGOznUA8IFWrk65BSK5mWD4Y=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2JJvqUnB5t5TzyFfeuoyg+M/iRVqwKJwNgjx1/xLxeI+alE7YWpDCHvz2zj8PLdlHrAbftM07yWFIeyfrNKmluoivLvkjCMspKcD3xeiwWmTMXXeKfb3tPEiAITKGNr5Gk2YN8r0ss3QXkYZVgdgxpq6qfWXx3f6xwZhnsCO1UB7fbS+yaZceTsHiKV5AeAOPQPEl8Yv1DOw0rpe1AvrPldrGTraT2F/+LD8Uv1SdV/FRw31KmTYvM924MIVAvbFGHENW5EobWGNd+eMY3lmhZ1xj82B37G7RoXKjxHaapLhA1yqsWqwjz7GF37rxXnPl/qnKi5w2uJmxNRZskmDGcisCMqkD9Dsz15yzE0w1rpLPaQNuyOkCKUXYH5Hj4HFHv4cyrR0DY9IawjjdxVHmV97No2UBoiHDzxDuUQ6uiHrGNlFM1uFngfuAiUcEAN681IPlqNBZ6yeoyApJ2rUpYKNf8lytRiQOPHojew0BOFbHr8r3zlm8SAv+rlqhiir+NwhRh1FsuwNhoUW6Tq9dzYbw9T0tTHKra7uZkA4zFyqiN+SfJTA9zwwvidMlhYr9YQ/t3p3qTlRKTqGgqmYHtA3uo/kruaFoQhrH0cTPvDgPQqi9hJdFgdYR+plWPuTcjaU22Ph23gFH+ZO6/kXbA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:24.7988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9217b921-9223-43bd-96cd-08dd2eb1c7a4
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR19MB8517
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215138-110353-15623-8456-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.55.47
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuYWppZAVgZQ0DzVxCjVJNEo1T
	AtNdEkOTE1zTwtxdIo1cAoGci0NFCqjQUAWojgr0EAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan16-182.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

This prepares queueing and sending foreground requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 185 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/dev_uring_i.h |  11 ++-
 2 files changed, 187 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 01a908b2ef9ada14b759ca047eab40b4c4431d89..89a22a4eee23cbba49bac7a2d2126bb51193326f 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -26,6 +26,29 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+struct fuse_uring_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
+static const struct fuse_iqueue_ops fuse_io_uring_ops;
+
+static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
+				   struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_uring_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
+
+	pdu->ring_ent = ring_ent;
+}
+
+static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
+{
+	struct fuse_uring_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
+
+	return pdu->ring_ent;
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 			       int error)
 {
@@ -441,7 +464,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	struct iov_iter iter;
 	struct fuse_uring_ent_in_out ent_in_out = {
 		.flags = 0,
-		.commit_id = ent->commit_id,
+		.commit_id = req->in.h.unique,
 	};
 
 	if (WARN_ON(ent_in_out.commit_id == 0))
@@ -460,7 +483,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	if (num_args > 0) {
 		/*
 		 * Expectation is that the first argument is the per op header.
-		 * Some op code have that as zero.
+		 * Some op code have that as zero size.
 		 */
 		if (args->in_args[0].size > 0) {
 			res = copy_to_user(&ent->headers->op_in, in_args->value,
@@ -578,11 +601,8 @@ static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
 	struct fuse_pqueue *fpq = &queue->fpq;
 	unsigned int hash;
 
-	/* commit_id is the unique id of the request */
-	ring_ent->commit_id = req->in.h.unique;
-
 	req->ring_entry = ring_ent;
-	hash = fuse_req_hash(ring_ent->commit_id);
+	hash = fuse_req_hash(req->in.h.unique);
 	list_move_tail(&req->list, &fpq->processing[hash]);
 }
 
@@ -777,6 +797,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	return 0;
 }
 
+static bool is_ring_ready(struct fuse_ring *ring, int current_qid)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+	bool ready = true;
+
+	for (qid = 0; qid < ring->nr_queues && ready; qid++) {
+		if (current_qid == qid)
+			continue;
+
+		queue = ring->queues[qid];
+		if (!queue) {
+			ready = false;
+			break;
+		}
+
+		spin_lock(&queue->lock);
+		if (list_empty(&queue->ent_avail_queue))
+			ready = false;
+		spin_unlock(&queue->lock);
+	}
+
+	return ready;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -785,10 +830,22 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ring_ent,
 				   unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready) {
+			WRITE_ONCE(ring->ready, true);
+			fiq->ops = &fuse_io_uring_ops;
+		}
+	}
 }
 
 /*
@@ -979,3 +1036,119 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 
 	return -EIOCBQUEUED;
 }
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ */
+static void
+fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
+			    unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue = ent->queue;
+	int err;
+
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = -ECANCELED;
+		goto terminating;
+	}
+
+	err = fuse_uring_prepare_send(ent);
+	if (err)
+		goto err;
+
+terminating:
+	spin_lock(&queue->lock);
+	ent->state = FRRS_USERSPACE;
+	list_move(&ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+	io_uring_cmd_done(cmd, err, 0, issue_flags);
+	ent->cmd = NULL;
+	return;
+err:
+	fuse_uring_next_fuse_req(ent, queue, issue_flags);
+}
+
+static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
+{
+	unsigned int qid;
+	struct fuse_ring_queue *queue;
+
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr ueues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	if (WARN_ONCE(!queue, "Missing queue for qid %d\n", qid))
+		return NULL;
+
+	return queue;
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ent = NULL;
+	int err;
+
+	err = -EINVAL;
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		goto err;
+
+	if (req->in.h.opcode != FUSE_NOTIFY_REPLY)
+		req->in.h.unique = fuse_get_unique(fiq);
+
+	spin_lock(&queue->lock);
+	err = -ENOTCONN;
+	if (unlikely(queue->stopped))
+		goto err_unlock;
+
+	ent = list_first_entry_or_null(&queue->ent_avail_queue,
+				       struct fuse_ring_ent, list);
+	if (ent)
+		fuse_uring_add_req_to_ring_ent(ent, req);
+	else
+		list_add_tail(&req->list, &queue->fuse_req_queue);
+	spin_unlock(&queue->lock);
+
+	if (ent) {
+		struct io_uring_cmd *cmd = ent->cmd;
+
+		err = -EIO;
+		if (WARN_ON_ONCE(ent->state != FRRS_FUSE_REQ))
+			goto err;
+
+		uring_cmd_set_ring_ent(cmd, ent);
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+
+	return;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+err:
+	req->out.h.error = err;
+	clear_bit(FR_PENDING, &req->flags);
+	fuse_request_end(req);
+}
+
+static const struct fuse_iqueue_ops fuse_io_uring_ops = {
+	/* should be send over io-uring as enhancement */
+	.send_forget = fuse_dev_queue_forget,
+
+	/*
+	 * could be send over io-uring, but interrupts should be rare,
+	 * no need to make the code complex
+	 */
+	.send_interrupt = fuse_dev_queue_interrupt,
+	.send_req = fuse_uring_queue_fuse_req,
+};
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index ee5aeccae66caaf9a4dccbbbc785820836182668..cda330978faa019ceedf161f50d86db976b072e2 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -48,9 +48,6 @@ struct fuse_ring_ent {
 	enum fuse_ring_req_state state;
 
 	struct fuse_req *fuse_req;
-
-	/* commit id to identify the server reply */
-	uint64_t commit_id;
 };
 
 struct fuse_ring_queue {
@@ -120,6 +117,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 bool fuse_uring_enabled(void);
@@ -127,6 +126,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -150,6 +150,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;

-- 
2.43.0


