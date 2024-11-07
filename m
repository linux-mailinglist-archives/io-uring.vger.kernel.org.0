Return-Path: <io-uring+bounces-4555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B199C0D18
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 664FB1C20A7B
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043352161E6;
	Thu,  7 Nov 2024 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="GTd7cY4d"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059BE191F6A
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001169; cv=fail; b=heqNy/MA7g4kpPCWJZISzIvblXAMdZp6Tc8ciee+d39a3eB3zDs8GY0con+Zol7SVo3hKj1THxFPxFgTM9mTo6HAzsPWXLP3mxpvDN0MnWiylc57BeI9YFycr7D7AvYJTogHAVlU34p+s2y7/8Se4XIHkMpQvZz8tr94tSWWdCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001169; c=relaxed/simple;
	bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RAyCULS2p85/tomiXR9JoSjrERKijuzdhhepaezFJYpbPwOKHsbFB2BYUjs61WY60phM2m0fof1I6cVQRWlX02FaZrKfEfuzF+ASylurGPGjVhMHPojqedZ6VuCZgFzjZJ07oVZJM6sVmS36Wlgw+q5T5ZWa5TJHQAmziKuZzLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=GTd7cY4d; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45]) by mx-outbound41-91.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:39:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YmZGvVNXC7qoUMM7O6FYAAf+/f9TC85gr2Cu/aVCeEXAuuUXf6G6CBb9UooHV45/IUxdv+xf3yrVzEI0jui36A/aDEK9/qoLu7jzU1MK9wG1oJkTaSVTDsykpsG1I7AIHe9Ef1ez93VFLFxw2uBa/hvocHrHZVKOBrlkRJRJC91yUxLAc7yJypBK6oJeK5QzYPFyItV6N3ly/wwei/i/2Ha8SNOpaPcnu2Qj6Sq3PteLBKjYYvbECggqg85DWIypDZxpsH+LSgLyXZNbMMWTDOSf+aEG8h1qH57RVIOKtcIB78mjqnLnoc4g6GH+xy7Vv6OLZhByhAZncvekE/oAgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=o4z34C7xdcWJYn05q5seYYfHlD0lH41XENugTUq0BRjtm8y7yu/c2FuiRXcIqTrMHoae5P83Uz3l9e2fTd6XEhfxCWCKi0oQol4Lee2VD+97jnMbqT4X1k+iz9y6QIxFEggq/HYczO1B5Vlo/th5NiH4IKUyg2eZkPomJPBqdU07udyRPmnE4+K85i5jfrEaAVjXk0B5z0vxLMwqtFUMJaf3R4QnazIazSGQuUnddpDs40vsYVwO5BKJ5M8STa++epgk6srbEk73H6tLHUuef7M3ImZz4hjVjBUdsw7KbIv8jh/QCtKWLn6/9Bv6Jy5zJg4pV9s6RPEJ/RT56qG7sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=GTd7cY4dndIy21eUwB7WUfRo/Oi4rcr8QS6AfB6n0JSgK6t3ySOZm79yXYkbMAMjPRSmlKoMsKa7+QEJlmEcBIm/iZq9mV36493RsDt+F3xmRoxgiv6rARfF4auTAgUOAIQzn3ArAKTDlHcDQ5L3F1ZX1v/dkTdLG8pTNvXS+To=
Received: from MN2PR04CA0036.namprd04.prod.outlook.com (2603:10b6:208:d4::49)
 by SJ0PR19MB4543.namprd19.prod.outlook.com (2603:10b6:a03:284::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 17:04:15 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:208:d4:cafe::8d) by MN2PR04CA0036.outlook.office365.com
 (2603:10b6:208:d4::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:15 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 3C1917D;
	Thu,  7 Nov 2024 17:04:14 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:48 +0100
Subject: [PATCH RFC v5 04/16] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-4-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=4808;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
 b=ndCnzBsNqxSOfcjS2r2PJQegPhOOKVt41UpjSkL8R9QouUPVbEzVP2Hov5gT1X8PddicqIsys
 iuJJfL5kDm1DC8tG4xsaeuk2jN9iBBrQ9vbd7OBUfEiuTQ1z3xx+Q+F
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|SJ0PR19MB4543:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e0d213-08ec-4454-ce42-08dcff4e35bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?TThUdGRJRUxUQ0x0NVBsaVpMaFN0MTRKeDBDVmNyMFFZQ1pqZzYrKzA2MGtn?=
 =?utf-8?B?NHhxcFJKMFg0ZU5nWDBsVlNmczkxaGpGeDdRemRnb1JDN3ROVmFWcVJKTW5M?=
 =?utf-8?B?dkp3SG9DK2IxQTliSWRGWFZsRXg4SVA2Z2NsUWlFKzhuRFVVU05nZFpCVjFD?=
 =?utf-8?B?WE84c2hzaC9wRVBDNXJWTnFkNCtEUm13REZXY2JIYS9VdWtqS28rNUVwUG1I?=
 =?utf-8?B?SHFFUjJ6T24zeHNTVUNUU1NDam5PWldpQWJWeG9SRDk3cEZmNzIzNGdWTFdY?=
 =?utf-8?B?eXhvZndPMGNPOHp6bi9YbnNhVjBFc0NzWGpOeHl0cmRkYjJUWC81Vnl5VnF5?=
 =?utf-8?B?R3hCY2hUNFViNjVjWk5RQmloeTdlZ2FSUVN3R2F0ZzQxM0pUOFhWTXYyZjkr?=
 =?utf-8?B?ek1SNWdmSm5wY2crOHM3U0IrcEY5NnhqZks3VkJDc0xQZjY4S3kwbXZvUHl0?=
 =?utf-8?B?UE1YMkVEdDEzN25EUkQ1RkdqNURKZU16aUZzOEVYWm50cElmL2NNc2cwa055?=
 =?utf-8?B?RXhsT0tSbEtVY2RCSks0TFFNanlRVk9QNFZhWTZYY1hRTzJlWXJzZ3doc3I3?=
 =?utf-8?B?ZHorQ0ZnMmpZUkNJeUhVTm8wZXNxSXg0Sm43S1VVZlA2VkVWcGI1OEU3bXNX?=
 =?utf-8?B?ejlkcFhndnM0ZGpxZFFXcHBscERjVnJEdXZKdTV1SkZreTdsaUt2MHZVYWhj?=
 =?utf-8?B?TkxCWi9sQzMycElpd2JSbUhuU0pKSmxxTDE3MmpQL3JYb2xVR0JXT3R6L1BZ?=
 =?utf-8?B?SVpCNGxkTnRIV25nUFFza1d1WXExUkxETmU5aHNFUklIbUFUdDZjMXpqWGdD?=
 =?utf-8?B?czExY2xIN3Y4UDdJaEVZTDRGcm1UcHFueFd0dytYZ3JxMmQvMHRZUnJrSm9M?=
 =?utf-8?B?Wmk0UHZRMGFkcmpqaFBsRExQREIweGptZXN2Q2p0UnRzd1dla3BPaWRKS1h6?=
 =?utf-8?B?d0MwWUd4dkpxKzk3ZVVzNW81V0JQWUZyZjBMbkcwY3hsZWs5L2dIcXM1RmFt?=
 =?utf-8?B?L0N1L2gwSXljUWkxeUtYRjVDUi96TC8zL2l1cDdRR2dBb0p0QVdvVnJYdERV?=
 =?utf-8?B?dEI0ckpkaTh4bFRjUlBkSGN4bVlialZOejByZDdqem5YNG5jaXRxQVF5VGd4?=
 =?utf-8?B?N0tkeHNwTElkNUp4NFM5eEl5NDR2eEJxMENXVGlPdEZ1RVJNQ1pkTk9LVlE4?=
 =?utf-8?B?bmI3eTV2N2w1M1pOaHI5ZGorc2dtWWJGZWNBLzhNTFBZUVFJb0FBcHhSYWgy?=
 =?utf-8?B?WWwrUGppMTFMSDAwcWJSUXM5UWN3bGpuSEFPVTlFVmJhMjFYRkFNOXpZNDNF?=
 =?utf-8?B?ZXJzNlRCRFVrRHFCZmhkNWpYU3pYUjJqVXZrY0N2NmVFYVB2WG1SV2VUdTBW?=
 =?utf-8?B?aS9wekovejVBdFF0Y3RGcWIzcjJIUG1UeVpaQllJQTVDSzBWWE1hcm9pL0Iy?=
 =?utf-8?B?WGZROUl4N3ZzdGZzbENsTURIQXNDR1RUN2FmNWszTEJaZENreHRzSGNDSC9C?=
 =?utf-8?B?cXF5c0ZuWTZJUUlFVXlVdlpGbi9DRzdEQS9seEZXOTkraDNmMm9FNG9kWmlo?=
 =?utf-8?B?aG5GUEVFVXpPaEhYUytDd21PY296STIrcVFoanJVb1FYS0tUSHgwcVY4cVUy?=
 =?utf-8?B?UnpJNGtwQ3VsTk40U20vdG10bDFTb1hOSGdETTYzdWNqTXFKMW5qRWJ5ajhQ?=
 =?utf-8?B?T0pUYjVrK2NHdWN5RkJ1SjVodm1MOVVuenRkTnMyY3RLdGgwVmFyMVZhNkk3?=
 =?utf-8?B?MjRENlcrL09GRjVlUGRTY21QTURUOXhLREVzbUJHMnd4c0VxbTBHQXRsWHdj?=
 =?utf-8?B?bG0wdEQ5LzJ3WDZwZ3JJdVdLcG9zQms4YnFqS24rK3ZRRm10bmZnb3RWWHhK?=
 =?utf-8?B?cXhPL0hZcHdWS3VGUUl5SEorK0xrRnB1dlpIczJBYkN5TkE9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 mZaRPXNQQtChHi4GDVJhWh+jcYqi/cwKhKgNgjkWveJMG79PmZs9YogUxlwkl+YGewJejdUr/VrJQWm7gxmwv4cO6La7gJbGYnyWRQQxweUdhfsXdE0bgcLT+iSTOdmdxDNWXLzTVvUnbhO8E7QNLAXogMk7yXf/ik/avNDViNvAc8UR8/FTzfE3xHJbcEWyB85ERLi6uxdq+tAz6+HEr/p9YqEhwYEuFdaWPLrvgWO9UuGCA37nfAzbuVC73JjvBN53RnTNMDrO+kh1aDl+nz5oXYrO07goWeZ4wJGi6a1QHXQZol3Sb1IV/VC/jFgsxyOOvhWHSrTMJnoXWa+oxbjoEsWJAZh8Gy+Oq+67LBantnxQRi8j9bkYz6EQ7FA+KwqtvY0+Ypb10HY0doKbFvDpFjAqlO/cyjDDrhI9cwc3Lo6KTZAfp+WWlQk+/PFMRUoEmFfJX+JI6I2jDITph8WxfOl+2XXD8U9JdgGkRTWKiLeknVhyRUqGC8XLDfk98mf8opZYnZP7BcpQDql9fkLsi6EV2jep6E3Ov53oPnMA1uXG5O014kHZvI2C+A6cmUpcrK5CpI7JzHvhAy7Keb21/76adlChVZRdlP/qU4gFEkvti5T5aOaEVXfVmWuzRBJPqsGIPVEJrUmWfdZdGQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:15.2459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e0d213-08ec-4454-ce42-08dcff4e35bc
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4543
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001164-110587-12633-9644-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.58.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViZmliZAVgZQ0MLE0ijFNMU8Nd
	HA0sjQ2MjcPM042STZzMTIIi3FKNlcqTYWAKwEH+ZBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan9-69.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 101 ++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 0000000000000000000000000000000000000000..50fdba1ea566588be3663e29b04bb9bbb6c9e4fb
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,101 @@
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
+Fuse io-uring configuration
+========================
+
+Fuse kernel requests are queued through the classical /dev/fuse
+read/write interface - until uring setup is complete.
+
+In order to set up fuse-over-io-uring fuse-server (user-space)
+needs to submit SQEs (opcode = IORING_OP_URING_CMD) to the
+/dev/fuse connection file descriptor. Initial submit is with
+the sub command FUSE_URING_REQ_FETCH, which will just register
+entries to be available in the kernel.
+
+Once at least one entry per queue is submitted, kernel starts
+to enqueue to ring queues.
+Note, every CPU core has its own fuse-io-uring queue.
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


