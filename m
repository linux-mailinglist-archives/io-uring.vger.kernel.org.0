Return-Path: <io-uring+bounces-5326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C519E99B4
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66EA1167C10
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30691C5CAC;
	Mon,  9 Dec 2024 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="jHLAs7r9"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF701F0E47;
	Mon,  9 Dec 2024 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756226; cv=fail; b=Q4h06SnkbWJFSji+dXcU684v6y3sxfg50pxx7zln7rO4vicbtu6D9YFEDHvWBX1YqpGBs50WAtUjAjLWZhOW8uQzyVnyYG2OQGIchN1+WpkcGPQrRdXBZQfsvsme0fOyitkQQWu2rSfy60CmEn1FMF5x3Wh2bmpzs8UuNJOCVU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756226; c=relaxed/simple;
	bh=bpz9jYdZQEOQdBfiKXiZwRgnp9oHesOsIHgalszfXPs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FRI/TUTpAmZ8CBkci/pAJ/Y98RVDwDKftx2D8wfxJ2jKKPxU/8M2TGaiaIc0YbRgYET7zx0V3AF6B2jguJocDrIg7Qr1dkdrwYe3Qjz3qA7FW+O2YE5pW3fCkUCE40y+ChL8D71YirlN6F/2IRwHFkCBtQoWOBmwJhrzq3RKhJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=jHLAs7r9; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176]) by mx-outbound43-237.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vBNcUefdp+/cTqR3xpbnPfHP3emyQEuM8qB2wwv0Ev85laBQhzPzFFJuubvlS93rYj40S62vTTLHZ5gc1fw+g2UCBwVKQqUx4yfpGRq3fjt4jgA2DEHk/a+yALSUCCxsAgY12rakunG3t4U/dz29KhWCGne3nrKRwiQ/HJSJ2W63Hc06cD8LQojlpTOefnxtuTQPYFDQ5AoAQKyZZzPveCC69unkXWkX4wWFlqvTy5jHlAPHbcq9h8zi3PGgT8gHwH4+NWNa6RxFjRONs2yitc7AAHFWasDqQCELJe6ukJQaRi4LeNz/ZmIn5uUSBu4Cfc4utpr9z/ijqA5CWdhJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzB207LVFcHhSySR/O8OdAO8erEuw9C7AZx6YrWeNEk=;
 b=Vux7IOZDID0qEs4nTXfL2aYSENpqyA8+e1BBkcyoQc4AlyJXgdkyRWwEbu9Q0DzmKg5eOd8ZY1p+3HTydI8LwPMD9Q9b2VLIXLy+aOH8QsDM+4xmyWRM5S9+zYHdQoyUR4z/8nZb0QwZI1QgwnrsqjuhT1X57hlRUJQ9QKGYfTelDOWlSVJhI+bTRYP11RtDZC0EU1wnkmS39YmtW5PM0yDqBeFs8y+0zlvEf8pM/ycv0I8fXK6+kudF/UUViF2p/FFfvfW39MQLdjqP1CTqV4f8qlzBb3F2Kv+CgR8zE+clBWiaRCUrjyHGwTUvJhJMaFe7KwsIq8N5wYbMavd6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzB207LVFcHhSySR/O8OdAO8erEuw9C7AZx6YrWeNEk=;
 b=jHLAs7r9ZMLlH5szqAnOlZLp0DOBxFVgvgB4rXpWE15k9EaZ/NG1TGtN4J5umZhGvO1zfYNx+codxPAKJnch80QLvKDaZjlrQbWhoiRxphgUrYRR7cWEq4im7hhHwUPHqWbSxoCOthNynLWGsWsniLbHYH6hdHg6p0mE2pwtPrs=
Received: from PH8PR15CA0011.namprd15.prod.outlook.com (2603:10b6:510:2d2::28)
 by MW5PR19MB5508.namprd19.prod.outlook.com (2603:10b6:303:193::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Mon, 9 Dec
 2024 14:56:47 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:510:2d2:cafe::fa) by PH8PR15CA0011.outlook.office365.com
 (2603:10b6:510:2d2::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 14:56:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:44 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A6F5A4A;
	Mon,  9 Dec 2024 14:56:43 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:26 +0100
Subject: [PATCH v8 04/16] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-4-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=4852;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=bpz9jYdZQEOQdBfiKXiZwRgnp9oHesOsIHgalszfXPs=;
 b=5TAyoxfz8+V6xh8X6UmTT3fdCOSin+QVp+quAVmkD3RukDpCl37ghjbH94qbOJw1M/ngDkQFH
 BoNHCghsWqJCMBCrEhSyRDZsI4hk8GaTla5WUnSE/YkL+X4e3gAReUu
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|MW5PR19MB5508:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f52959-5030-4e88-d36b-08dd1861b2af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alU0WXZzOVA2dm9DMzZyWitLL0RZY2xueWhoN1BSd3RzWkp4SWZTdlhOeDlV?=
 =?utf-8?B?NTNodEVxZFpTd01rSWtmL1Y4QmtWbHd1eUxTbnczSFZsQXdaUkJEbW5tS2RP?=
 =?utf-8?B?NWQzK2Zoam85RFlZWXlScjN0OHFiQ3dYUVlwWjV3cWYwNUZJZ0M4ZnVpT1Js?=
 =?utf-8?B?VWVvUXpQcmNZWWsrNm44b05DK1pzQWg5VzlhOWh6cC8zTlZiOEJtUHRsOTI2?=
 =?utf-8?B?M2V4TnJkWmlRbG1qaE1KNEduTW5Ld0hhaTZ3bFUxM090VjRNa3pFTXVnVmVE?=
 =?utf-8?B?WGtoWlk4dzBrV0lDUEswUU1NU1V1Z3ZBYXhrZ1d2VjhQaVdLN3FKeEVMUTdU?=
 =?utf-8?B?eGlrNHpDSldia2JZV3ZtQTNRQ2xSUlJ3d0pHdGRSUGFuM3lBck42OGROdUZZ?=
 =?utf-8?B?blVMYTlBR2EvZkV1Wk05NkZtMEQ4eFhnenloYzg1c2N2dFBHdTBoQi9DNGlp?=
 =?utf-8?B?RUd0Z0x4T0txUzcxYXJpQ3RUaTZJM0cwV25rWTFTT1hWQ25YV21YbDlnY0M3?=
 =?utf-8?B?RW9TdGhrVDhGMzVTa3ZwOGlHSGVLMnQ0ZUFIREY5cGNWQis0NW5RYy9odGZu?=
 =?utf-8?B?VVEzNG16YklpZUZBU0twaFRXdHp5TDhQemNVVEtOa1VPMzJRVjZacWovei95?=
 =?utf-8?B?eUJ6bzZ4TEljWldzUTlYWitiWWhyMUpOaEF5Mk5VdDZ4TEViUDZrajk1ajQv?=
 =?utf-8?B?dTg0MEhnelFkVnA5bGJCaDMwb09pNDZFdnFPUkhpUTdrSWNncE5WSnRsU3dn?=
 =?utf-8?B?VGlVamxrVXB5UE9FbG9weVcxYzhHcnZmZHY3VHM4ZS9oMysvR0hGK2V3Y0la?=
 =?utf-8?B?ZTRGbUhTSTlDUitLSHljd29lZm9BbVRINzI3WmFUQ2FEYmk0NGRmM056OFlu?=
 =?utf-8?B?VCs0bnVrQWNKc3Q1TStKbGNBWWFzUTB0T1AxZmdxSVhRVElOWkJsT1g0aFF4?=
 =?utf-8?B?OGFRaWM4a0x1bmV3UWt4dGF3UXFtSmtlZzFlTXBaTGQ4cFNmcm1HTmtsRSsv?=
 =?utf-8?B?TGdjbG5QZnJlNEVMNnh5Y3NMWjRZUnhOcGlRSGJSMHNreU5WNGN0ZURjYmd6?=
 =?utf-8?B?TjZrQ0xUeU93OGhKcXc1VXIzd1MyK3pvMWJMSFcyTDhFQU1IQmIwV2cxYkMx?=
 =?utf-8?B?TElTYTU0enlyYmFsVm91RDB3VE1rWDZsSnkxeXVjS2F2bTlHUHp2enJTamk2?=
 =?utf-8?B?R3p0N0t6NVQ5TTk1Vkw2TWl2QnlxUitiY3p5L0VhTWVXTVBxREJsWXJUb0kx?=
 =?utf-8?B?Y0ZlZFJwQXRSOTlZV2JleFEzSTZDYnI1MldYOEtYYUFsQnA5QW5kd0FLVkVH?=
 =?utf-8?B?Z29pZy9wdTJMSkl6WldqWUUxNVprUkNVTyttWC9LUTI1ekFYbHBIeUw5cHVD?=
 =?utf-8?B?Wk5HNFlkMU9wbFN0ZW5ENXIzbGpBM1F4L1NPZGx4bCs0M1hwc0pPV0lhNGV5?=
 =?utf-8?B?S1RkVkR0bWNlS29sbU9tV0JNVXdMZ1U4SUt1L1lVY0s2SHVKNEJZb3pVZU5T?=
 =?utf-8?B?NS9RLzFha215MDNJZ0c3ejBpc0ZUT3lRSnhtRC9TRDlIclZ3UVZvcU5KL2Nh?=
 =?utf-8?B?VUdudGNkTTJ6RVRjN3hYcW1FT3V2VTR0ZGNlaGR4OWQwSnNHVXNjZEQzMzlW?=
 =?utf-8?B?eGtlZFp6czZwSzllWmlPcDBRY2RFQWFjTlZwOTdleTJoN1RFT1hyUURmKzl4?=
 =?utf-8?B?WTJDK0U1eC9ZZ3YzcklPLzRhNzgvU3Z1bEZadmpaZEJWV0R6SUc2emhmcGxR?=
 =?utf-8?B?bXRyczQxZGJCTmUzRkFxNzZmRURJRjVRYlFOUk4yaDFjM005NFVrTkp0TC96?=
 =?utf-8?B?RjZ1TmdzZUNCbDIycHpjeDlISlI1eTZuSWxtMzIxdS8yMjBQYVgxNzBQZkdB?=
 =?utf-8?B?VVlNNUQ0elhUcGVreU1uNUZSVWcrUXgzaDdaWjdsZU5VcDY3cHRES1hYNVY0?=
 =?utf-8?Q?0hml/z4j/VEyxp2/Kd5mIO+vyrGEGecA?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CSiKTqIIK27vzc2PtmdJaLavnDy3jUD2vbeUhT9uARb6IO9dg0ZWx7WxGQw75Vrj2E5eax/DLeHs/BpfmpGcxb1Ee3ltkjDua9Ttfn0ErUASky9su9A2Y5jBCQOJg+NuIRRXkOPAIyYhPBLNROrxU7/b7S5Au7l5BglZPejZR69tGljgpr9HWFB2NvCg2Dn+zHqIRsCpM0oOhVYidnTQcmArOCBjTzk61qXsj1JkXTultSB5+SzN6xws7ik76GZl3LBG2IFfxZX/3bAF5nOcKB8TeNS7hqr4tkTsaiiRrjThixv+NFCCzjw0H2peX2Fzpqx0EQhzf7G15CcONHtxvyg4omlBl4396lgcwIJsFraXHanv9hqZVCFdWlP+1UDC4ReX6EZ3mHiPaUIFXKFp1pcrW1XVhYj6sgggi13N0uEWLyO4aa8VuiAfWYNAl9HEztQW1Q1SZ1cFdT6ZqD/FlQDiv58fCepqGaTqL+rw0ORLQ2M193fEeul9FZO/BvrggWq48vsU34OenezBFIjUo2BK/I5O32BW/9AKHIV89HzQdkBs0H3Jeffx2kIuCDwz27mc7soRSQgtZCwbwxO4wIC46MBrFQGjj7+mZhXbfI2w4x27ZsM7J5HBg3D1MAstRSUdlcFObi7vcqYDaDyj3g==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:44.4146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f52959-5030-4e88-d36b-08dd1861b2af
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR19MB5508
X-BESS-ID: 1733756211-111245-13395-4910-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVibmxhZAVgZQ0CDJIs0oOS05Kc
	0kydAszTzRyCgx0dAiLTHZzNgkydhYqTYWAHzkAYFBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan19-154.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 101 ++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 0000000000000000000000000000000000000000..6299b65072a8468f08cc4f6978c386546bb9559a
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,101 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
+FUSE-over-io-uring design documentation
+=======================================
+
+This documentation covers basic details how the fuse
+kernel/userspace communication through io-uring is configured
+and works. For generic details about FUSE see fuse.rst.
+
+This document also covers the current interface, which is
+still in development and might change.
+
+Limitations
+===========
+As of now not all requests types are supported through io-uring, userspace
+is required to also handle requests through /dev/fuse after io-uring setup
+is complete.  Specifically notifications (initiated from the daemon side)
+ and interrupts.
+
+Fuse io-uring configuration
+===========================
+
+Fuse kernel requests are queued through the classical /dev/fuse
+read/write interface - until io-uring setup is complete.
+
+In order to set up fuse-over-io-uring fuse-server (user-space)
+needs to submit SQEs (opcode = IORING_OP_URING_CMD) to the /dev/fuse
+connection file descriptor. Initial submit is with the sub command
+FUSE_URING_REQ_REGISTER, which will just register entries to be
+available in the kernel.
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


