Return-Path: <io-uring+bounces-4962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF7B9D56A8
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 604D31F21E88
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E91F15A8;
	Fri, 22 Nov 2024 00:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="mSg+RKim"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E1010F1
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234693; cv=fail; b=mAchUrG+zvJN8Gbud6cILlfIFnla8+bGP1UAowaYkVDZBSbKt3u9c3rnVv6YqjLYI/4lNz3zCMeSMdz+X5jV7dklxNcB2bDSW5k4OVZtCSgiBG8NvJBvrtuKQqOaOG4hA28t4TwICG31GZMe7JtjVvdpzqHTNPUSuae0KlvCtq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234693; c=relaxed/simple;
	bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fXH7Io8XML7uwvo1GyOtsMN7ZG5o/SaTJCl6T/b1NLLSh3D8EzhtnDyr/62emRcNw5K/PyAbSiDRZv+w1wJM12wqbJoDEZ72BqlGarUdufQjr055j3Qd02ct8QSg4LSsuGLj4bmuN5vsoAzO5Eg2xgDVUrrfKQXLQpQcxEawbw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=mSg+RKim; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40]) by mx-outbound16-66.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZqegilG728F8BXJdVpftIBaMOSySjlZrulBziwodEIIBwea0ak6NsLnMqR5606PQ1XFic/iNhtRFiLN9WuVcbfktv4cOXLclQ1LFi3uLCFaECeedwDel7xjD0paGHct01rlKMyZkO6oGmH8ZRdZU8YFDElDzwQsaNWqVBI1lFFwBZpe6MTg/6L3afWbQXUD56S1bD5cT6lDVPgkfD/2vZ0f5XmutUlF+thEGOhAlZRkbKQs5oRbInHtG9Wk0o/CSne5Hv6lxQkAuWm9gX5E0Z8PMcK3wd2M/vHFS//nX29fpMD7toeKHfoy6tEQWk0r6Q3RGXSsWq9J2jOIoquF2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=zBhcEOsLsHcYkChJl5esjtXBxYvp2FbSWyqA2e4gVIzXBVYZuccLvKMXDOplYVIlYbwdj+Esy32ocIXnDnNIQef6rRFluIWbtK52eaHTMzA9evE9wf0stmFwJdLIxDvgYeSAuqANlL0KX6ghPkfGr7E4knxauh+Jbys/oK959lHGT7yUlQ2ndcv3Znjpzr9U23b5SmQFsCzzEekqF5aelVzcqFceZXyOEiDk7v7w9h4XdMQrRHsKk09zi66kAj+WRe1HAPV5uxI47okahzaLssI80r6KQ11ypqoYR+ZfzaGzMYlk+If9YFHzfU1Jj4MixdLEFUvI6iNXA5MzqE+0YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=mSg+RKimF3SYVcdQHxwtP4Wftm2NRSnWafpEvZfc8eR4Wls2jzKwyQq+cKMcEqWxt5u1iNbrobIw/uxg8IOvHQw77TiDqZpE4Tq2a1/hvtqs7H4bLLO8M1ipiQrmVWls8Ipwczs7c8S4fYHm6MoAlIIWhv2R5RgzHKjI7348erY=
Received: from BYAPR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:40::32)
 by MW4PR19MB7053.namprd19.prod.outlook.com (2603:10b6:303:22a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Thu, 21 Nov
 2024 23:43:55 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::6e) by BYAPR04CA0019.outlook.office365.com
 (2603:10b6:a03:40::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:54 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D60FB2D;
	Thu, 21 Nov 2024 23:43:53 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:20 +0100
Subject: [PATCH RFC v6 04/16] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-4-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=4808;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
 b=ImjyiZYMgxNFgKAHWb+Hgf03yFzCrR6vM4RZCbRix6+4ARSQ+QDqWRTHhtn3kCvBxibSrmzHn
 gIoYh7d0byLD1fPE1gxUUIW8KasMeC0cKdSLlkKp2KSuJWScOpHu3md
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|MW4PR19MB7053:EE_
X-MS-Office365-Filtering-Correlation-Id: 155f6767-647e-48b3-2026-08dd0a865c6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?SmU2azhoSE9UeXkycTdBZVVmTkhkU20reUFqUVAzVWxTK0wzNmJXdytvS0ZJ?=
 =?utf-8?B?TEZ1SHhiUGU3RlBaejZHRkc1V3VkWDlDTE9NOUZlK1kxdFRiUWxNQkU3U1VB?=
 =?utf-8?B?VmRBaTlMV1ZCenNLSnN5clo5aDV0WnB0SmJFcjJXTVQzdU9VM1dCVmloZHdx?=
 =?utf-8?B?V0JmbFAzczNQc1pLMHZsM3FwaU9WaVdWRjdnbWJBVm1UZ1FNUlNLemFFeTF1?=
 =?utf-8?B?OWw0dGpWUmJwUlQ5eG9oMDU3N2FtblpSWThBU0VXdDZWYnE1aC9mT2dtVkxY?=
 =?utf-8?B?U3JtZUcrbGJEK3o5S3phR0xYWWdCKzZTZFlsM3k3a0tZQmlrT25idG5VNFQw?=
 =?utf-8?B?K0ZmMHhDOVl4R0RjODRabTBGSnVBNTZYWWphRVlCRUFJMkpSbCtYL1VCczdI?=
 =?utf-8?B?MllKS3VsZUdLTGFIdEtRS0ZRczBmOWdEcDV2U1pLek9oN1NIc2prOTJsQXRv?=
 =?utf-8?B?L25CWVFPdmg0eVgwbXczb2ZEbDlXYk83aW5jMW9PQjcwSEF6WEFiMktENDJq?=
 =?utf-8?B?L1hxNFdaQStZdTU0c2drYXVtMXhSNnpZMUZaRWNQY3NnSStZTFJoLzkyMGZp?=
 =?utf-8?B?clByM1FWTGViTzdQZjd2SkRNeVlJRVg5Y0IzQWN3T2JwcUllc0tJNXFzeS92?=
 =?utf-8?B?akJqdERlVkR2OWNObEkzUmNxL21tM2ZLcWh0VnNkOEM1Y0xnbldjekJVc1dD?=
 =?utf-8?B?U3J3Tkg1ZFM0U1plTmRVRFBDUHVHTFBsaXFLVm5raDBkSVlJcUJxcUhiQmx1?=
 =?utf-8?B?c0xUUCtTQUxKOG1WY1ZCWmlIM0oyYUJha1l6SFdwZ1hvdkEzS0FhV1JoRmJw?=
 =?utf-8?B?OXFLYmtMZHZaYVNPRzRKWWdBS2k0MGhReklrL3NrRVhRV0M3V1EvWHFjYU9H?=
 =?utf-8?B?SXNCVjIwTHdCL1lIbjVhWEMxMUY3VVhaWUJINThVVHpnYnZZMmNkRkhvOTdR?=
 =?utf-8?B?UC9vNnovMXoyemlHQUVUZGkzMmZtSkhKdncvOUIxTEx2MlRKUmpFa2dKcjlp?=
 =?utf-8?B?UXJNanFlU1RhbmVmc2N6dVh6VUFsZXNCR2ZuSWhnY0U0NXpkQUVQSCsvTncw?=
 =?utf-8?B?MlN3RmpGTlJYTzBWTjFlRGtVejhiRG5iZ2ZYS2haNk5NbXNWVUU5N2UxRTE1?=
 =?utf-8?B?MjBiQmlzWTFtdUJqOGc2WURHQmp3TXM0cEIxTHNNZ3lKNUNFcWdLRXV2Z3Q5?=
 =?utf-8?B?eWUzWE5uem96KzE3VllmbldDejk4UXZvTllFT29LTlhCekViZDdONGo5dGto?=
 =?utf-8?B?bHJkMWhseFJITlBnVC9aaEVWcHJZZ0E1TU1Ua0YwaG1uV2djWmpWTTFIcy9U?=
 =?utf-8?B?K1RvTTNIOXdyU2RFN2pMVnpnTlNuMFhyVDVMMU9zWUtidlM2Z0tnQnQwRklN?=
 =?utf-8?B?eUdyUkJyN3MyZ1k4S1kxek94YkZkN1RaM0JWdzBRYzRoampnQkFqams4WTVF?=
 =?utf-8?B?QzhjMVpiczl3ZEhyNTJzM20reGlTU2tadXpYUGVURE1IalRVQ1M0emJYTjJ5?=
 =?utf-8?B?OThvQnFYMkppZ3RuZHM1QUlsM3V3Z3JWdzdDaVp3OEdhV0hGUkcxMmxPcktr?=
 =?utf-8?B?dk5PUng4UmFuekRxWFV3M2RpcG1iV0I1ei9LdWFKVnZlQVlvWVFTSDVLalFv?=
 =?utf-8?B?SlpzMUpIbzVEL0RSdG5ZWjVyNTUxRWMyak0xMEFVdHYwSXpkdzFjU2ZKTnd1?=
 =?utf-8?B?RmtQV0J3dXVidDRxTHBhOXp5ek1Uby9pT1JXc1Jac28wY3VZUzJGMW1aMG4v?=
 =?utf-8?B?T0lhb1JiUVpYR0VuNCsydVJWSVNRaGRSbTE1cUR5aVJGaGZnRFBuZklLbkY0?=
 =?utf-8?B?U1hEeis4cEt4SkpIek5kV2p0NFNzWFIvVW1XaHd4SUU2L3I3YmtEZ09xd1ph?=
 =?utf-8?B?U0JUdzZtelBHQTJTNndxSUQ3YVBMeXJvSkx2RFM4T3JDWmc9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 IsXBo779Zz1F0gVLq7yd7+3GsHCsGEXK0NsL/AxK55l5fdlTuHT5xyaIF2qgrhtDDPyqDJIqyloUVSrjU3QdhxbBWoqGV5WOoBIe4CHjNsFtrUYYl4QeaWZuVqceQwmKqSt1Pi6cOu2hZPVxlpFUk1RSYmAWQsTbHc3NABWucMLl9vXUorjaDE73ip9KE08l1xwJGoEI8CXtt3Wa+uBx6LutDNyJDxvk3pWkpvvobQi3VK1TCGOiglg3XMXwZdhjwnLFl7KcLkUUXXBqWHlUDkg8DvA4+hTgOLYZ65KVO61czsdVgU8K5/X+YivbALv7nEYj7e7MRy4/BMz3xrwet1+D4ttyv4M7Vh50SU5sa7pMTtfg4oNcpWRhBsrHRcZGGialqK/owKQcmpYGMxpc++TvwwJQeHPR0A8HuDWdEkBdUWvIuScODd2I+n8C7v83a5nGcexjexDrsLG/nt7woobEU6Y3vAo+cLgwgnyQUldbVWbbK5Fu+oOyaNu0B2Iw5RZ5tH2xBQ8rym2KENAlstR05rNuK3bnrHE3S5eA5088uiBkxJi8x7d6FFbRW5fGFFMzfch7Qy3VGQwDAb6eMpulP84FWQG9ZQ+/8GZ7IoC+Wo3pHp3aV34IGks/m6DOMyGmyenlXxnyn8HBV9D1pA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:54.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 155f6767-647e-48b3-2026-08dd0a865c6a
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB7053
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234690-104162-13519-24019-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.51.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViZmliZAVgZQ0MLE0ijFNMU8Nd
	HA0sjQ2MjcPM042STZzMTIIi3FKNlcqTYWAKwEH+ZBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan17-123.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
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


