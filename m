Return-Path: <io-uring+bounces-3708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D63399FD41
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30B2F1C216C4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F3111711;
	Wed, 16 Oct 2024 00:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="CZJj8ZQc"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C6A1097B
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039135; cv=fail; b=ZbrsqpVRynv1NIN7QurU+IYPFp6Za/CuGotHhw0KuIYAY5NNmW4nx+PjoYilC6CeFiT0jQzjTsD9fWlm2F7QEZ/gB5ZiHLva5Gf6yBJIQz5+ZZD9OS1cT87gMe3Jb5f4RV+lceDqwxt0DjnIPoomeatJIXaM4DBIrIuXPCsOyUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039135; c=relaxed/simple;
	bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hJ1v2KuaZa5Qd0mnTCNsl83K2qOMMj/SZOPrknAV4/etrrUSYgDFhJFpBfJT+h39/JLR04zzTt7bM3yU/sC51D7Ekp9/esrSLwnUUem35pPQAGn1psHxEad961CmI1HRqB+HkKWYY2K/VuRQ9NBtrvGiLxqyugPXZzzInrsuzdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=CZJj8ZQc; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound10-224.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:38:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GD72BO5u/GJvkakEmxXC2zqhrR9eWdozbZkTyU+yVWGJK/drRmSy8bS+y4TGVwGMMaudOC5E8uZ4sS+5xu5l/fB5vx9gpa7prCeZZLaxX6drTlYg53XZWPn4Ue/m55HiPG2w0uSHymgUPwWDMGm9sZ+rxjo0BTbeZjG9ZVHOCXFy2A3uqj41CMCNgQOCfRezosZXlv7fTj9aFi8+s+hPFXehg+F9id0c8hbERUI4tjz1mqmEhnJKVS06h1qKy4LeHIu32oPAybY7bLwpOqU1DdXJC5AdOQnSuDln48EUZN0Bc0gArr3cf/2MuBhe1Xw0XXxGVZ4wMctyyCSevn3LqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=sOTDsJOyqGzsXjvr6//DDAPDMkp7qS7gf1Y0HE3zpjYXkurB2cX8vhuAFWu0LFOfAH3VUoPLmkVfh1SznYNBaLJoKMsBTV7KMI0pQATvHLHlb9NkVGVuqtNMqqmFqL/UwTcWAREG2mpZc7lHLl74OyK6dMg9eYiq2ibq8l4XxcOJ0qxqBZmRILUwO+dc2HUJpdBJmD1yrEQnkTni4z/Qkt33btK8oQ00Uk6HHZMxPApNYNiRZMXlhHQuRxYQON9ObuynG2lLNI3N6lTkEoqi7vrghDS9LvT9M0GxB8kXfri8pRxJy5cE63+LLQtFTyTasHHTSwki9O5DXHOULHYb2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=CZJj8ZQc+8kHPWT1hwK6n2A+i/USG4fYAjCilrpVF6l6jkgi75ItvQna2Zh/Bj1HjlGwvFdlgb/4NwC00YBWFGOOTTcgWov3mOL82Wc1ti36CVY+SAob3eCxNnd4+wprrVSJy0o6vaeU6Y7KJucW4CxrZI5hr2lFpEmEjeNZZQg=
Received: from MW4PR04CA0363.namprd04.prod.outlook.com (2603:10b6:303:81::8)
 by SA1PR19MB8114.namprd19.prod.outlook.com (2603:10b6:806:373::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Wed, 16 Oct
 2024 00:05:28 +0000
Received: from CO1PEPF000066ED.namprd05.prod.outlook.com (2603:10b6:303:81::4)
 by MW4PR04CA0363.outlook.office365.com (2603:10b6:303:81::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Wed, 16 Oct 2024 00:05:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000066ED.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:28 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 5348B29;
	Wed, 16 Oct 2024 00:05:27 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:16 +0200
Subject: [PATCH RFC v4 04/15] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-4-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=4808;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
 b=jBkO9pkHA+ceIRZ8CiLX7qpJTm4Xckber3dNxpSB1xX3G2+udu8FlBR2e6cZXSePFMhNdLZZG
 zScSIh8dunnAmYHDhYgSAYPfLBML44i5LRR8OC1LY+nsY7nmMaoA78A
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066ED:EE_|SA1PR19MB8114:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe4e6c9-3392-4775-fda9-08dced763e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVBYSTUwUFkrUTVkQndHc2taTHJoNXZHdjVYT25VWm9TOTI3cmRoM1g5TWM3?=
 =?utf-8?B?YnRteEwzSHNmaWcxblI2NUlmMDNRcnQ1RnZwK0p4TUNhakVpSDJwSTRGYkRN?=
 =?utf-8?B?eDVlU2dLdE8zeTZYaUlTeGIrcGJqOVdlamFIUFNOanZBa0pzRU9ycUZnSzNs?=
 =?utf-8?B?b0Q5WXlnVzJWU2dxSFQrc21NMFUzb3hYbmNOSGY5ZzM2aVJBa0JQZFQ3UitB?=
 =?utf-8?B?L2R5dm1wZWZ4eUZQYVVnRjZJWk4veWh5TGYrR0c2alk5d1JWbW9ZSDc2NWV5?=
 =?utf-8?B?bXlOeG1ITlpXM3c1NUVrZEh6Ty9ORCtMYng1THpiNWZ4cDRoeVNUMzZxRkRm?=
 =?utf-8?B?Z1J6VERKUFJKb1RBVDN1cmNGeVJ0UFkrT2hEQjBjbk9TZzgxY0h4MjdqVkpn?=
 =?utf-8?B?b3lGRFRKU0x4MWFVY1QwcmNyTGxIOHlPWjJyczJsR2pITHNCU0xjUUdGaDc3?=
 =?utf-8?B?NFZaZTdqUG1wY2pKcG5wNUpRVVNTRTY4VGlaVm1MU3pmTlpKME80dW9OOEVv?=
 =?utf-8?B?d0JQcWJoN0YweHRWa1VYTFB3Ny9uTk1nZTQ0WmpLQnhTOGVOeGpGczdjMWtJ?=
 =?utf-8?B?SWw0WkZWeFRiTkhha01VeGtpVTViMTBRVXJTTWNVbEg4Q2hIdHp5eXI4bS9E?=
 =?utf-8?B?a2g3S3VveHM4cGx0WXo0UDJ6eGlYdC96dWkvd2kreE9peE9xTVdnVHRZMHNu?=
 =?utf-8?B?VmpEQVd5ci9Dc0gzZTd3L3dHSktIMjlLTkR4ZG9XYXE3aUJHUFNHb0lqUHBy?=
 =?utf-8?B?OU9UOUF4emFzeUQ2WjJTcXNRMzhUMlZDTlpDKzRWWGo1S3FmTUdzeHlRWmJM?=
 =?utf-8?B?NWpQcVJhbkxlVWVyMEtGenVPTlhBbi85UlRiVlpRR2FZWjQrWnFpTDF2YmFn?=
 =?utf-8?B?dTNBNU1GcEQ1RFFkalpuUjRFcVJGRlZ1alJzejZqSHQ3MnZ5eUlybFdxNE5W?=
 =?utf-8?B?aWxkT3pLUXgzSkxXaDZjZnpsKzNPUG94MHBDdGxhVENVQ2lad0lOS2JTQnJt?=
 =?utf-8?B?RzJHMlFZQ29LN1JSK0dCVEIybTZzZ1NYdE90L2NtYmVldDU1dnBhUEl5WE13?=
 =?utf-8?B?bENvaFMxWXUxQTl5K2txbFMvVWdRaHo5ME0zWmdvUGdQNWFONHMra1NJbE80?=
 =?utf-8?B?UFNQVS9sN3dEVldGN3Z6VmlpVzlHSk96RjlNdGJ6a3VsYVhCNVpQa2hyQWdh?=
 =?utf-8?B?Vkl4Sm9YTytXQmJLMHRNaEhIRXFnVXRhQzVHeFRPZnhkZ3V4bWlEUUUvb0li?=
 =?utf-8?B?ck44dDFRR1pNR0JCaXVpellINDZ3aGdMSWxyZFFhOTVKaEJoMDV5U3ZjUXo0?=
 =?utf-8?B?L1U3MG1IVytIV1N1SXpvVlNsU2hBUzBKSUEwMWRab0FoRkdaOTBELzZWWCtU?=
 =?utf-8?B?N0dpSDVaNXo5bFpEL2hwbzZQQ2F6Y3hQTFJteDlPSmRZM3BycXFlN3lYbTZR?=
 =?utf-8?B?dGYyVjVUY2lac1NJd2JQbzRHMVBNVWZtZDRyNXY5S2ZXWTYwdHJWRk1sL1do?=
 =?utf-8?B?OExneC9mM2xEWlFGTE1DWk1SN3ZVbno5MVJzRFBFcFRPTktEOHBPRWc1RGZ1?=
 =?utf-8?B?N1FweU9GbXA5TXVwZjhQWUxMaUFkR0g5RjZWNWp6T1UxUkNOVG5uNXF1allr?=
 =?utf-8?B?eGtMcUNLOExWakpTRGsyVEErd0E5bkZVdG94bkI5aFJDUmlIaU90cWU3K0RB?=
 =?utf-8?B?KzRJY2xHN1FZeWpxbHJyL1g3WVJoMDU2TjhlR00xWTVJdWl2dWJDaTEzT0xN?=
 =?utf-8?B?TlVJb2VrTzZLdUNsdXg5Tkk5MjlSWmpOOWYwd2RTL0ZVcUlyclZydDMrbXZu?=
 =?utf-8?B?UTVQV1dESUsrd2pWeGRxbUNXa1oxT0gzMk14VklaRnVYS1RacXIwcVFoVFFL?=
 =?utf-8?Q?SUEcpO5f47PSn?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6CXVHz3TxtAA+OtD8wSgG+9aD8s1PBpUQV39e5ptzDJFFqsBKvBigVXDeeyHqcSbyhGRsR64yNFw0P60Lv0C6pZ457cM5bRtFm7MnoNBkmqw8v0tUb8kd9mWHGuyc2baLixfZ1DwPHeoOwfpW4+ECetLBZXZOfF6xnMMmwQgd/yzIcgJg+r1MmCcmgiYnMkIl0tcZp9hvNkLI37GXsx2u59BBM7OKBKNLq4wXrKUqC4DW2rUt6bokyz/DU3boazxHGhsrcQKttGTgfO5LjylLfO1pVHarjybWR/qydAiZLyd7X5DOQdG+gxQvH041uIQupZd9PLjmzoq9T07aZT3scYW+aBmiJ64GjCPdUzGT3CNFNm7pm/vsHHzmEOYbH2yXFl/qANO0eHOqVDvDH5N3kJazovAWiMkN7yFdrqispu4h9QsNJ1iPW4/niiB8AgkGw1FjPZIJqZ/MT6usHb7bw1mt/6aSDpJLds15TFAiwgtrtIc1DuFZ3X2mcbHKa8HBOPGfparPukmhjAUs4ljuKnuHsIazFJvWaVPRWgyIlg3OaTwXzMja8nouMNwnpuMaEtxerK3/q7OGm7RhYunvhVYjx7TSqej9goNMAfjSk0MHMy7cN82de9E3/1tCbdI1++A5lvPyGQFR2YxA/maOw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:28.3063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe4e6c9-3392-4775-fda9-08dced763e1d
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB8114
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039131-102784-12841-4646-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViZmliZAVgZQ0MLE0ijFNMU8Nd
	HA0sjQ2MjcPM042STZzMTIIi3FKNlcqTYWAKwEH+ZBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan8-219.us-east-2a.ess.aws.cudaops.com]
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


