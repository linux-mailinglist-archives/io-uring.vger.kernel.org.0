Return-Path: <io-uring+bounces-5341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 000F19E9BB1
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E40D1887F04
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE54B14A084;
	Mon,  9 Dec 2024 16:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1+uMXEtu"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DF914A60F;
	Mon,  9 Dec 2024 16:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733761810; cv=fail; b=mwydej+AcMKItub81dUXta4FQAprasvxRQACDPu4Zk60fnR/VxI0paNs2ImGz33Kfwg8QsJiM2Krm7AQJKCwh+7IECPDT9XdWvMK2+2O7TW81ZBMo2mRt0JQ27YSifEeeOb7IHYucKLejtebcIBOUDWXUSMq5rWZjla/MDSmT6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733761810; c=relaxed/simple;
	bh=wxYO2fuIGkvqmeC9PNGhH5rOX2Wls8HlW08RzezL2Zw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YY6omuL2B+XxsFG6zpRSndhtYD63+7RM1yWIZ4OU+JCYi5r9rtCpoloX2zPOVZ4z57QaT7kHx/ilkf5ZzpX1sAYJkpfO/m6FSri1/4I/icZuf3Std1tzoX+mcbJ64llCLqyWRTaSJ+VXO697vWZjYONXrTWeLuDdyUoPTDebWuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1+uMXEtu; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171]) by mx-outbound44-160.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 16:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+mfuPLhiJXyzfTKPegl5biTc8ilnvu5evVqdwltY5SpWw1GOPqq9TdDoIJQ67TMx3Ir0fXdUShbRIPxGEPkQUkSs5K5ROI2gK9CErRaih1a0LJ/ipumu3RRvITPg/4pPWwrYrh3laDbUGxdCv1MVqIVmXPS6U120J4jYHCQcsNWW5kjbaELxd2+xwZNwROLzkKfeltXY3Pjwvh4gjWzoNFHweowrs5VLd4Na7Kt79ucZAzHDiJ4SEdcyLB2AEOWwNXUlH1oDYh6cm6Cr3gG67/esuWcHijXi31YFoCfT9TNzmDaUa7RxtdoyqlpIuC2c55gyG+JPhCLDUPwD5fJSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAgBjLWkV7oHdA35f4ET93Ocl3k2rLGZEn+8xfR4iOY=;
 b=AAS5I29pmtmLd0KhqXHg6SBq2ULu8j0VWPzblKRlhdESHMVoa/hAEQwQ/px6VLrJHFr+NW700UVsHasdXg9IheKzi9pH+SH+/+HLK/Tan4NSXcleytJkwk6zPs2G0oU/54iM6gePVL5Ob4YZw5ub5gGtv6itHm0fOfIKzUvXKI3lJQ9MV1JUCR/uMuMlQ+lzjXV+jRXsd1YTT7AuCNcYujDMRs8pu9jPYOu/i1T7QhWWyqwKNjU7NMwd1kMIea1zd4TsAccz7KlXd47D9TXtQfJFZxsXf9Ka/W7GM9pBliNUFvlWPYHc5XvAv/Ud7M/BV3q4cM+spCF5zhZ/sNefsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAgBjLWkV7oHdA35f4ET93Ocl3k2rLGZEn+8xfR4iOY=;
 b=1+uMXEtuZVVdcogFl200bBWsqjVGbDUwVYCFIEAsBv/RNGY9JKGt+kEqb6Ai3YYwjyWv3cKdWp3/UqOtmQDdIC9RT9y1jikCbu3EDc504QIIrm7HS7951fpyP8eUZf/G1BQsscuelm/mLOEmtjnTBFXeK/fNOF0Y3wVGl6XLXcg=
Received: from SA1P222CA0122.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::17)
 by CY5PR19MB6315.namprd19.prod.outlook.com (2603:10b6:930:21::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 14:56:42 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::b8) by SA1P222CA0122.outlook.office365.com
 (2603:10b6:806:3c5::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 14:56:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:42 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id B3A614A;
	Mon,  9 Dec 2024 14:56:41 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:24 +0100
Subject: [PATCH v8 02/16] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-2-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=1631;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=wxYO2fuIGkvqmeC9PNGhH5rOX2Wls8HlW08RzezL2Zw=;
 b=9uW6gXbFsrlSgqIdVdK482oscWmymG61cmXoOKElukWYJvuRPLegJItWjP0yTIyn/Q1kvIGOi
 saavk6itiChDSVlyJInU+XRF3IFyxMI+XLrdgHT2egnclCReyKhct6j
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|CY5PR19MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 71ee50db-0222-41ff-9eb8-08dd1861b178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjdrbTBQQmxDQlVTVDEzdkJVOTlucXFrOVc2TnA5eXhDL3haTUNUS3AwUzYx?=
 =?utf-8?B?RTNOelNVWXRTUitJV3JOMElWMkp4NVJZWUdQUDRwZGh2TTBXMHFjbktLWm5C?=
 =?utf-8?B?QUtKWCtxRENXaXJ2Sys1ZTd1L2ptdlBSWUpMdHA4dTFRblBxVUtnMDV4Y2lH?=
 =?utf-8?B?aUxYRlcwcHVIYjFaQnNSUkZHOVNpaVgwRjRXVmJkWVp0NVFmbXlsUkg3M3Jp?=
 =?utf-8?B?d3RMNVBFcTlHVzZiRkNhNUpCYkdKanpxRjFGVU9FQzRseXhFeEFaUFJsWXh2?=
 =?utf-8?B?VXZpa1BTU3ZLdzJOdExNUVVSUnF1TE9WOVczc2M4SmYrWUxUZ1VzdUhLQnQv?=
 =?utf-8?B?NEg1TFBFVUQwblhtWmdjYUdlNGZVZnFXelJiNWR4T0pqRnlhZzJBWEFqZTZo?=
 =?utf-8?B?N1craXdLeE1vZGlMaklYanFQc25PUGNsbk9VaXNoTUlIZG1qWUg1bE84eWc3?=
 =?utf-8?B?MjBrQ09wRnprbzVKQWQvYk53MzNvTUJsNCtFL3ROejE0STNWRWlKNUF4ZXE2?=
 =?utf-8?B?Wm1GMmVlaUxmL3NodFRTTkwzaUNPaEUzQmE5ZVdkMnE5WEUzTVBWMVA0eDhq?=
 =?utf-8?B?UXl2Y1BCUG1qeFV1Y2hBM2RmelpPamZKclErbUtmR3dZRGE2dlhGdW80a280?=
 =?utf-8?B?RTl2RFVYbE1xaHlSWlZYeWVEUmtCc2JDS3MvcUZNa1FiUGRHYk0xSUp4Tkdx?=
 =?utf-8?B?dW5TNzBRQlk0bG94WDJhcHcwU2N2RFJzaVFXM3dpZEVKR3lTa01ZWmpkZytr?=
 =?utf-8?B?T2hGTmluK0Y4WUtyOXA4WWhwZUZwaVdTR0kxbjIrMnBBK2JVWlNNcExXNjl3?=
 =?utf-8?B?TmlNcit3V1JsZEtjZEZCMWx3emQzeGE3Z0lkd29LSlljT3Qxd3lxaW9hZ0JP?=
 =?utf-8?B?NU84Y20vc0FtZWRsMGtXa01wamFLYlMzQ1VjaSsvdFVVN3pmR05OOGtyRjJm?=
 =?utf-8?B?RlQ0VGRsS3AxTDFCbGFGRWFXQXhyQzBJdFpHeHFnbkEyTCtCNmRHMzI3S2h3?=
 =?utf-8?B?Z3Vpc0lHSXZWeUcxQ3ZkVkNkMGZmc1ZQUk45Y3gyVTBUWFBSYmlwckwydFFt?=
 =?utf-8?B?SmwxeEtSa0F5c1dmZ1VycEJmbysrL3hQbHVoeVNnU1J4cGl5VXR5dzhKdzg1?=
 =?utf-8?B?MGtKOWY5REhzTGJKNHlyNzluWVpoRTBwOTVvTmZCa1ludEVDa2dacXhpS0tS?=
 =?utf-8?B?Um9VT3BiZHlJNFBJWS9Ya0g2bDN6cU5tK1JTS040ajVXK0dKZmRLNitGVDZ3?=
 =?utf-8?B?SmtXSVJCM1lmY1BMazJkTHFMTFFodEFIc212dG1UeXdvRUU3QlYzRXhhOUFB?=
 =?utf-8?B?b2xOY21nWFk4U3g4cmx6TDdaUGZNRENiNkt0T0lWWWhUTGtLUGRiZDRKaStV?=
 =?utf-8?B?NXczcndsL3NuUmpyNDB4Q1FPZzQxM2dLczlYbWE0UGZkL3hKQU9rVUljNGR2?=
 =?utf-8?B?aERmL2ZCeEZaUmM0Zm41QlBZeDZmaDR0WlBYTmpUL0R2UXY0NDVZMUVhbHU3?=
 =?utf-8?B?aERQWHhkbXpsb1VBSjhsa0pkMXlOQW83TFcxN2JPRjdkbllqWlIrWlZRck9x?=
 =?utf-8?B?RUVxVzZPSkMwNDR0Z21Jc2JiMVNFMnlRYVBEWklPUURINVhFUDJSMGdxUDFt?=
 =?utf-8?B?VVdWbUR4Y2w3elNOWnNCUitwbmN2NUNFZXdJZEoxWXJLRHVlQ2UyWE5uYVg2?=
 =?utf-8?B?RjB6VHJqT2hHVnFaM1o2NjZoNGEzdWplZGlQTnZLajlydG94SE9neE95R0xw?=
 =?utf-8?B?d3BGZi9tNlFweFhaN3YvaFY0ZjNPeTFoUGZyNWh4WTFHSlBsSjM1VnhvdFpx?=
 =?utf-8?B?cXFpREF6U3JSWWY4SDl5bXNOVVZDYzRQY29kU3FXVWc5ZW0wYmlRdmpUVlgr?=
 =?utf-8?B?Y2hBa1BuVlliRXhpbnRWcmdrOGJ0NHQ1MitwV21ha3VBaTZOalBlTW9LUUxV?=
 =?utf-8?Q?TJhmQndMb8C02W3RmmGGOx18DQh5I6iX?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H0AqP/MXvArzOI104W/dzLpHBycurJkrykePxBDQ/gKXwbkT2ORc9Ey/7m0/zPlcVxL+v8EMBHpDzY56keT8LgpjTGSKlM8yUrtWpnpw3Bxoz+l63nwi4BmeNvL/tQqTWXhE+ztv9kKjTwUU39p4yTSSKKwiEV6YN4aPDpSPPDzSNFMqHR/Xg70rJ0/SOGdn7kBfkqFPuh2MT/Gj+rkA85/FmWl+U1fa4RUHmOxiQgkklHXpXaqDbwLkBC49M7NDThPl/EGwsbpVJDL9EtZRo2hDoiPOHTeVIz27Ls64o3yFv/u3C0WVCIiGZHuKsbKRLgfje5fEPKUt2+52DANOgHmAweHa3NYRq+JnusH62VK5Zkq2DN50QmahiMpEPnFPuy8KRkWCVp2gJJmqPHC3cT9DNiAWIGd4cRXyuc3cwoZi9N3e51GpT01kn4NzuF3ts2y80L2502YS7vU/ZhLCGpuO1Zfdr/OrLoZsP9YDB/gBw6oJJbOzLRr+9XhNi6kvXa/Ud1WadglUYy5zz/damu6zCcUqkGKVrpna9LQUKXtc20OiFy9IXast+Espww5hZMKhbX0kcmrgOXmydRN35oJi/vV1pct+WdWoJkCU0rTa7pZYc8xzrueakWn+340w8ZtGGRKHY7SzZVUylYkx8A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:42.3907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ee50db-0222-41ff-9eb8-08dd1861b178
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR19MB6315
X-OriginatorOrg: ddn.com
X-BESS-ID: 1733761799-111424-13386-7866-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.171
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoam5hZAVgZQMDXNwsDEwMg0KT
	k5zcw81dDQxNgi2SLZ3CjVwsQw0chAqTYWAMycoyBBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260998 [from 
	cloudscan8-210.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Another preparation patch, as this function will be needed by
fuse/dev.c and fuse/dev_uring.c.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 757f2c797d68aa217c0e120f6f16e4a24808ecae..3db3282bdac4613788ec8d6d29bfc56241086609 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -35,15 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static struct fuse_dev *fuse_get_dev(struct file *file)
-{
-	/*
-	 * Lockless access is OK, because file->private data is set
-	 * once during mount and is valid until the file is released.
-	 */
-	return READ_ONCE(file->private_data);
-}
-
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 4fcff2223fa60fbfb844a3f8e1252a523c4c01af..e7ea1b21c18204335c52406de5291f0c47d654f5 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,15 @@
 
 #include <linux/types.h>
 
+static inline struct fuse_dev *fuse_get_dev(struct file *file)
+{
+	/*
+	 * Lockless access is OK, because file->private data is set
+	 * once during mount and is valid until the file is released.
+	 */
+	return READ_ONCE(file->private_data);
+}
+
 void fuse_dev_end_requests(struct list_head *head);
 
 #endif

-- 
2.43.0


