Return-Path: <io-uring+bounces-4546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A969C0C92
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4EE21C213B0
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F41921315B;
	Thu,  7 Nov 2024 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Jf9kihgk"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C128B2170C0;
	Thu,  7 Nov 2024 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999102; cv=fail; b=dw2IpPltYa3YXd6UP0J1e7oMAqFSIPlO3pSHg/FRUGO5YjjhlQ0AnX4aZBvI8IjYjqidSIeBa/NL9Yk4a0vNn6Zit7cMfeQ8zfFILv04pAfy0k+1txuy9Cj+hJAm+4dGz882roaobo5zi/7euc1DH+dt0LkFym/j+qhgcOeNxms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999102; c=relaxed/simple;
	bh=jPWR3XcsZ1Cmw5po+zK7lJlD+oF6fDj04DmSWzK5sFY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j2z8oTGLwCLGumAs7aDEXLNAQyDZsJtrhmDbv//46kFnRy3OdAwLqKLXVejJ8nlgCGoIC7uIiSxPYvbcZmJwKah6u6Tlh95SlpD3/dRGdIdFx+26NuRBQ44irZu7JFS9LB4YNXVlvBvNvh934SUPsL5jG8/PK+aX3Y4f0V0Bw60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Jf9kihgk; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47]) by mx-outbound46-164.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxg/nqDXK/ihNfyli83DjU5GXxe7o/vlurhcRx8Uu8yXVsb0VXUxsywJr42sOHqG4MfZlaf0d8t0VZuIdjQH79bEErViQoGScPy48VTguSR7zjvWXgIjhOhwkXJjqlKfay4+tkD1Tj4UAHfGEQ4Xygt80h4wfDBBDzLlYq7EpEa8H973KLwYXBu9k3hci9NFOtzw5FonpAmFhn6VL2JQ8D+hl3PEbfdiS4gvAcPh1TljOL7cFvZ9cFICxq3ktLZ0Y9G9iCNx0jYuFFBsEuVax9gdVgO9a56GM/miDBLV6rJVuHlqYxKCEQVGwtDNII+wjxSbfJJAIssMqQ/7MEey6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI1apY/HHnxAvwZA3PFvZapzOk6WLqDpAOZN9ms8KgY=;
 b=g52LIJfDthAQY3ocTp826ZmP0ylnHtLO6KX/EOHg59z5+ROM5gS7oHQPiPMyKcoDYeXHrm+hi6aS/NQ9HTG+UnhDNRiXvyhcJZ3Y5RVxnQgrhs2zNXrXXvAbXRpRAqINkEVVNEoCNDUiHa3rH8weuYtM/4cmrtKAfAC6NOsBp58xwFGYjhGtroYUW3FPU5HGVH/x66SqaG0o6+UEl8Liq87jX4gCcGiVFKaK54iYKBeulfRmeo9+ImVPQkiZjy86QVTH5DvRmmrLwt9ZiZiGitYb2Yk0C86td3hQwVxaecZoyUxHyu61+ShSy0gVfDvIqcI4waO9Dt6861qA2POOew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI1apY/HHnxAvwZA3PFvZapzOk6WLqDpAOZN9ms8KgY=;
 b=Jf9kihgklLYf/BkfNmWir1WLueCJTSn4h+3AFlZA4jmWade7l8BZYNXU5xnsgtxApX6ymlm819goqRwT6171iAgExBmSIK45Iq22G4rD5r94Nf8g10c0vY8jepk24mBusr0ZVI0u/Uwg1UuGqVO4zltHH5y70C7ayHBHzIPaZGU=
Received: from MN2PR10CA0006.namprd10.prod.outlook.com (2603:10b6:208:120::19)
 by PH0PR19MB5599.namprd19.prod.outlook.com (2603:10b6:510:143::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 17:04:18 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::6d) by MN2PR10CA0006.outlook.office365.com
 (2603:10b6:208:120::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:18 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 238AAC6;
	Thu,  7 Nov 2024 17:04:17 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:51 +0100
Subject: [PATCH RFC v5 07/16] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-7-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=3663;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=jPWR3XcsZ1Cmw5po+zK7lJlD+oF6fDj04DmSWzK5sFY=;
 b=TAY1KPQOgHbn28sUU8Pt9gtC/U+IHoaD5fYYYMKYr9xdhxKubagE6SnE09tV5V0C0asIO4rxu
 CUfBAtVjHrzCn0RhCEpExUKUHlLDl0qWkOPLQe3kVjC5Yyj1z1kRYoX
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|PH0PR19MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a5609c9-0813-4087-98ae-08dcff4e377e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnB2c1NCTjRka2dWcU1icE1XQ20wUytjL3ZFZnpzUitXVGo0V0VTcVRkOTRP?=
 =?utf-8?B?UzdjWEhBZ3ZSbGpBN2dIVk9hWXFjR1F5cUg2K1BzZGJUZEtBYjg5bGlveG50?=
 =?utf-8?B?VWtqeVJCMHp5NTJja3NjMVhpZEZ5VVVubGRHQXR0Q2V0bU12R1MweWNsSVc4?=
 =?utf-8?B?NGEyWE5oVHJnbWdwMDFhdEtLZnArRDFQaTg1Z1N3eG9sTmdjTWsyTXZPWlU0?=
 =?utf-8?B?RkdBeENQc3JSRjBWMG9vbVRrVVd0aTc1YXdvK1JpT0JMT0JmTkxUWmIva2pY?=
 =?utf-8?B?WlcyN2lCTmFuNE5PcURTcVNyYUlSaUxoVTV2YWpNMWpia0tUNUNOOVlVVUtY?=
 =?utf-8?B?OVlzUjNXK1g5Tjc2c3hYTnFKS05jOWtrTmdPZ0lWd0lQays0RWFuRUVZU3pM?=
 =?utf-8?B?eG5xcXIweW8zNUh6N0grdXVjSWVzVVRveDVUdEVqVlRGUklGTnVVbDl5UXdJ?=
 =?utf-8?B?V0I3bGNDRzJzeGFpd0htVXFSM3FEY1AyWWJVRUJ4MFI4b0t2MDR1V1cyN1ZX?=
 =?utf-8?B?Y2o5L0pZWXBvRFcwVXY0UVU3dWxVOUtZMDZNZERSZUMrMXRkOTVLWk5JZFpP?=
 =?utf-8?B?bzVyUENSVDJodDZJd3p0Wmp5RGZMWjJZZTFId0gzYlk1MUhwSW1sWmpDWnk3?=
 =?utf-8?B?MStHZWV5SHFMZW1mUk80VzJOOE9WQlIxUWJIN1ZvZlFCaEhucmV3OFZBcGs0?=
 =?utf-8?B?NlNJTXo1cHFBV1RuS1ZtMEwrTFg5QkxQMWNaOVNmQ3B4ZFNMNEY4aUw5N0RW?=
 =?utf-8?B?K3luZlNMR1k5NW5kM0UxcDF5R1FaYzhRUGNpRVhWRnZCbExvVUxRbEdxMFJj?=
 =?utf-8?B?OERuZmlnS04xWnkxd0tYaVhMakIyZzJvZDRlK1Y4Y2dLYm5HeXM2YlVwQ0x5?=
 =?utf-8?B?emE5ellYaE1EUmt1dGw5WUhnTEttdDYrVGdXcHBwL2NxNHJ0MDVCS1ZXNlpM?=
 =?utf-8?B?cjNQZzIrVCtGcElnUFZqTURpSWNrRml5UjJTUjFKMXJFb3ZjQkFoWWFoQUNZ?=
 =?utf-8?B?RVJTVjlJaS9ibHZ0K1dPSW1Dbk9EVDZVcVRNWXkyUlRkVmhvRC9lRWNJM3ZR?=
 =?utf-8?B?L3RTamVmc013OHg1cTd1MjZyRUFtRGF3eEo1TkZqV2pmdEoyOFFMa3FaVno1?=
 =?utf-8?B?M04rd2piQlNtdUZva0tBRWZ0VGNTWFFqY0Y1ZTMwSFZ4dWR0NEpRM0tlc09G?=
 =?utf-8?B?NDFmWldrNUErNnlvdXlMWEtKeWpNaE5HdGFld3R2MkF0OHNBRm8xYURkdEo1?=
 =?utf-8?B?VUpjVnJiWGJjSXRVREFRNENFUTAxaCs2K0tXRUQ2UG5mODZpUnB5SkdhZHFs?=
 =?utf-8?B?UTV4VnBZanQ0K2hVNnlVZWx6Q0xyNWZDdVQybkJVQmdweTVJUE1rbTZhUFBC?=
 =?utf-8?B?c2tFWXFCVHU2ZEdvWDVNcGpPcFMwQ0ZyTTB1enFocmhtVXZzNUdWZU5BT3hJ?=
 =?utf-8?B?MmhWN3Q0ZTdpVW80M0V1Zkh4U0dnMUY3UDg3U0U0WVVIcFZUMDJES0M3Q3ZX?=
 =?utf-8?B?aGpRVnVWL29SS2c5NklkOE5vZHpQZ0E0bXhjNithbTQwL1podkg2UytXZHVQ?=
 =?utf-8?B?STRBT0U1RHMzYk5MK3Z5OHJOaS8waHRrZjJtdytLazJYczc5SUh3SVZQV3k1?=
 =?utf-8?B?MU5BenZ4ZGV6bUdmM2ZkUmFPRklSTk9uOC92ZjE3M2g1cTV4ZWJBS2JUQ1Y2?=
 =?utf-8?B?bnFpMXM3YTFMMzQyQkNHNzRvdzlZdjFXcXg2UUZYaU5qd0NmNjJOTnRFL1Qy?=
 =?utf-8?B?Y1ZLaWpiNkF4THl0UkpaTnAvd1dSRmJVc3ZhM3prOW45NkYyVWljZWRjakZE?=
 =?utf-8?B?cjF2Q09zOVlvWTEzdmtaQzY2QmJzMlBDVk80WU9vWm5ITThJbDhNdGUyZHF5?=
 =?utf-8?B?bUd5VUNmRU0vMWZLV2xETkg0U0RmOVVpRHc0bk4vZWEwYlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W/l6+3p0xfcHxOepG9jCSZtcKLgZjCCCtI5yGf504DaxcbAom3oNtnAurnT8hSIDShHbQ46XZBMuvIYc94vSRPOK8Yh/qp5xYz1lr1+a4cmalENMov23hGGDA4tkpK/Cb+v+8MI+kZrkSLMo2p55fWxqp+e2qLZURX99vdQt2YrR7LTu138Xr/c8soU1uLcNZCyVAlfo3ggxPx3uQjciZewUeC/f43+JhxhWdI95KbhC+GD1vikk1Oe9pQlvz/2k9q9GV/aic+Hk/wMyyNS8RiGzM1OIDqhXrCzCG0sKdxNdNaeuRWlJS4fk7lyz2ktN122SGMzx74V70qTeR8QcwHuqfjJmOPBV3es5b3zAMgSzXxpslslb+X+erxmy89Xh2cIQBkv6+DJRaL7nBf+a7nG5qSVBTs+pN0oG0ljB3C/gxA7W7I16n7SGE2mDjT93ZKEJZXAQO2Fot8ez/qo6Hvb3Djc6ggaBVJqjkDm7TqMJ9C19rhnk84c4ebOcG7DRVTT0r0j+B/HvsZQQOASM6W5LLGv9gnMa4Ac2EEYdnlA5mcIVQmu63Ivf7aaG12R0LU6uFDXLUa+LyeaDIFEg5H3fqx8pWDWny2eukMrWBBC+Ywa29XcQ8kK4RkenVqeHGzCsqGsBUlRYQ7y5k4gveg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:18.1937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5609c9-0813-4087-98ae-08dcff4e377e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5599
X-BESS-ID: 1730999066-111940-12772-9953-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.74.47
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsamJmZAVgZQMM0gOSnVMinNLM
	UsyTQ10TDNzDjNxMzYzMjYMjXVxMJQqTYWALAhJhBBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan10-145.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
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
index d4e7d69f79cec192cb456aedfb7d4a2a274fea80..f210f91a937b24e75a467e943cdec4581900e061 100644
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
@@ -1883,8 +1869,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -1986,7 +1972,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
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


