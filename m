Return-Path: <io-uring+bounces-6075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A41A1A62B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6F916681B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF790212F8A;
	Thu, 23 Jan 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ygj0BT77"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9572116EC;
	Thu, 23 Jan 2025 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643903; cv=fail; b=OGkvqpRf+nf7uWBcnPT9lUB6Cv3wZ+hO3Bt53kv79GaQ1bE2/PeaktUzM2huG3oMSD3879Z/GBV35UMg/IV1tqZvYvtZ34a5q3iYyLeUeUfTo/wfxqJCeQxa7xAo8xwWNfJ6sfKbzht8ZrSxK282Xi12DAgunmEJOxMRjUdJnu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643903; c=relaxed/simple;
	bh=5GU3BBcwr2OClsLlBZ4tVpT8lSnpUAsGue4W6Fc6+uE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W/cksYAHl10hb+LNWF1ylOXwO4aiCXABExIa63+GYxiNG4136p83eWWkXkgAYJD/ddI1x24GNP+tISNuCdvt8kYzJmeO5VqpJw/3hNaCzZQC5aAQxuk4Rp/sbgz7Nol7NWNTJd26bzbb/tLj7ZKc6st9+hJAGYLEWkrjxpqAbTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ygj0BT77; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49]) by mx-outbound18-177.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kg5NKmJDC2OI+f0czWujpb8p4gzrokDRyXDPxD7ddZNLmbptgDyJ/Eer+64JYtzDKqJVF1hQpMAXMLqTGdpQE8i7+mCBMf/+vkBo/6WzArhVBOrzuSg59pTfm9jmpCt8QPMBFWJZhepFWcisLW+I14lcbIa0K1ku9kzBuTfmX25EDdAt1KZ0/Jq2RjXfbMmmz14DvcRjUb2W4gYPZrs3wOopleHdwZLig9IZXhCwa1dbLSQ85BUgXZ6bAXOWMgVYLu3OvDklx3G1AmaA8Pf00nuRUHSF41EVioXc4RG2ZHh6O8yTj/YoyJlnrrDF3UpyDpYr6ipLtDKBqikisbxhXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iopsajk01ARwYXqhrljLx8LMNoSe1e9hRvrbn3Dg0c=;
 b=WMmN8F6v2JkHFkVs6UVAK0SQw7PoqHz4aDF4YSwSGI3XCUaOChrhYIBcaNqS/Jj7xxH6vBc47LG1hrPjx5t5WIr3hLDXX9Dpt8/uaVsv11Ra+0IyAkeWc+quT4jR+C+XcBZfOeGqW7cfXW2QQ4lBhzPEW8wnZX0/hp085I7kBbb1nnVLLYAoqu5gse+9U+RQdYbDMDgamHDUc4sRdye6TP5xjS2s3LTpgSbwd7065ZWEQj6vQI6+3F63nypjnh7zMlQ9uWwWOLKoik31yK1PKssPoPWTudD5VDIRif5Zt0jQjgKASaugqCn/01OW3y+ZFKOlCnb5PYZx6Hxm1lvsog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iopsajk01ARwYXqhrljLx8LMNoSe1e9hRvrbn3Dg0c=;
 b=ygj0BT77Qm6D5FBil452F3k6WKVoNvUnU4RCH6lOAbJXC5arQGMnVDESzMSX21ca4K03gqlzdJaYRzYXYNfVP0ByJ8D7+QLP+ar9Ms+H5loQxWfu5lrVC2At/TqAhjyj+i+dYTK4/RRs6U2l0QEjtuOXmiylL0hqRvnhCO58HY8=
Received: from SA9PR10CA0028.namprd10.prod.outlook.com (2603:10b6:806:a7::33)
 by DM4PR19MB6073.namprd19.prod.outlook.com (2603:10b6:8:6c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.21; Thu, 23 Jan 2025 14:51:17 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:a7:cafe::8) by SA9PR10CA0028.outlook.office365.com
 (2603:10b6:806:a7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:16 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 175D834;
	Thu, 23 Jan 2025 14:51:15 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:03 +0100
Subject: [PATCH v11 04/18] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-4-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=5480;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=5GU3BBcwr2OClsLlBZ4tVpT8lSnpUAsGue4W6Fc6+uE=;
 b=P5/9YSIaUEhxaernV08Roy0O1HiG/Og7NP5+6DxWh1KQxMDpnGdvq5qHdpdkyYOWTXYgZ4mQ8
 OFMdsL4IEdiDlBnB6fWUpctOQMlImJ7Iy4z6oGyOGHrn7RKyEyGyWaf
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|DM4PR19MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b4504d-bdc5-48af-c0f9-08dd3bbd640b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXA0TERxdndpK0xNY1ptM1ZPOTV3N2hJeEh2OS92ckZYdi9rRncyNnVxV0VZ?=
 =?utf-8?B?TjRHcnlZbDkvekMvWWVqTmV0SHZhWFpZb2dVTUp5SGlUKy9sYndlUFE5SXlQ?=
 =?utf-8?B?VlFrOXFqWm1WOGhMaGkzU2lxQ0FSNUo0aEtRdXN6a1pSR05RNEtMT0VaeVc0?=
 =?utf-8?B?RTFBYzlwV3JDeUIxbHhQVjBUMHRNVzR6NVFqWTk3alJqYXdlR0daT3dWemhK?=
 =?utf-8?B?Tkl5d2ozd1FLQ0pIWHB4MzBSZEh5amtvcHJ5VUZqRkFiS0JqRURpQmovdlRU?=
 =?utf-8?B?NUJIUUs1NWxXazJVNGlwMGd2am80dldUV0dzTDl4RkxDMncrazgrZHVIU01x?=
 =?utf-8?B?TDlHWFFFTDh1bktoMXg4ZUk2VXE4ZnhiZkpOR3JsS1B5dzYxTUR2S2d2UHRZ?=
 =?utf-8?B?cWZWT3pEMGNMN0FnMXFkbEJNMGpHZmVwZzZOV1BpSXhuUTdQSTJRa052VXg0?=
 =?utf-8?B?REwzelFITHpEblliZ0FxN2dGcjlFVkN0QktaK0EyWi9FUG10OTZ0S3p1NmQw?=
 =?utf-8?B?Tm44M2tVdTBrQUYvZDFFTjRMVUwwNDRCSWwvN2wvUWpWWmgzb2pKdExPcnhj?=
 =?utf-8?B?WTJwNlUzakE0aHNzM0w0akdPeFErOEVhQUJDd0RPUEEyUkQ4ZGJ5Z1RzRERM?=
 =?utf-8?B?a0trYW1BK0lwejlIaENnQXpZK3NzdlRET1EzNnNDK0I1K0VLY1FaaFJSNnkx?=
 =?utf-8?B?c3RPY0gzRi9DV0pXQWJCYXJjWkt3OU11d2hkc2ROZzd1UFpQZlN6Lys0TFZp?=
 =?utf-8?B?RUY3ZmV2QWRFT3o4WDM4dkp1bVlwdktGQlFhK1ZwZys5UkxXamtEdzlvYklG?=
 =?utf-8?B?WStSbU5TV1BFdXZIZ2M1OXkxelZkRG5lYlNDcGlRNld5TngxdXYzZmRjcHBX?=
 =?utf-8?B?RWpqb2VZODl5Um8rNVJ6MmVwNEtjMDBFUWh2R0JLRVBLY1ZQS0g0WGlTcjZp?=
 =?utf-8?B?aE1XWVduWmdEZFljdXI2UkpXb0J0WVZWak9ETXFtSW5UNHVsT05GUGV3TzBI?=
 =?utf-8?B?L01QdktoNEc4Tk1SN2ZnZ25aTDdTYnZBOWorVDIzVC9nVUVEMFNXU2E3Q1l2?=
 =?utf-8?B?YlRNaG02elZEMitiTVRyMExCandUN0Q0NU11eUJOenUvSi9IVGZjRG9Bb3RR?=
 =?utf-8?B?N1lOUjNMWEpJZzBJWnBSNCtPZzZ5L0FNa05ja3VTUkJXYkxRRjVGNE9YRG1P?=
 =?utf-8?B?MzdYMDI2cCtYZUlhTXJrM1BvTjV3RHlkbERZanc3WEtoVTN6ZmhaN3c3MTRI?=
 =?utf-8?B?UFhzVUJuT2swdkFDTy90S29aUHRtbG9XUmV0eDhMR21hdkxrejBXc01CRkNH?=
 =?utf-8?B?RENxV1p5d3BrcDNhaTRWdHZvUHdBNFhoYXF3OW9mRitvaWZwTnBFOG9mVGhs?=
 =?utf-8?B?eGRKSmZzTEpZYUZzUkdMdytlMHl2RGRUbUZNZ0JJakttYTlSQlRDN2J1eDkz?=
 =?utf-8?B?SURjcjBNcTNGRS9jQjl6bnFpcjlldVdTeFI5M3BJV2dMVUp1anE4RHhaelpo?=
 =?utf-8?B?WUVidUhBNkpXVWlNUEhtcWJzUDRrZyt5UmpCWm1ENFdQQmdSUXFyM0RteW1J?=
 =?utf-8?B?TEh4RUo5QU44Qmt5dnRISERUNW4rclZTUkJxaWN1am5mdVE4UzZuRjd4d3Yx?=
 =?utf-8?B?UGh3WHl2WG5wNS81VmpqdVJ2a05uS2FSM2d2T1NZVHBkdy9vckdqOExQUmlF?=
 =?utf-8?B?MWZDWHMrRUJaVTUrOTdwSHVkYlM1UC94RDBWWXRlYUVIS0dSS2NkMUI2OER1?=
 =?utf-8?B?N0VCaXV4N3p3eVlLbG5ncG1tK0JXM0NMZzZRYnp4YTZ6aXY3Smo4SWdTb1ll?=
 =?utf-8?B?aUxXWFVRNkgvR1EyRDRUSU83N2ltaFc2QjVhSGFXNFJKSjJIQmxkOG1VMzNm?=
 =?utf-8?B?akhnWjZ6OXdZajN3UnBDZ3NFcUFYdzFyOE9GNEhOcy9JQlRycnF4V1ZDNVZZ?=
 =?utf-8?B?TU0xNXc1THFzWWx4MEx1Vll5aE9HUkF1RHBXdTFSNllkMjNUSVdReFRuMzhh?=
 =?utf-8?Q?foxnnEqZNW7rnurg3XkMPT0qgkwwmU=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K2nFvNrUQmyQeELrY4LyaV6e2czcn9akQhIuzA1nAWFMEp5drpgRxHu+4JwnYB6HmBoqxbxY2t2NkT9nN+PPdz3WVUGfQcbb+gB+Bv7OaM0v0/vmRh3EmnujcQQRCm9U0+XDgdr034M9qB95BBTsXh4KTrKEb166taWtsGOO9hNY35nv++l5rBVJL81X5vTvQiUukvNHFOcr5aR+CFisI9GbRGD4lu3v6JXyKqQ8oUs9w8I1qvzaHCyZ5gPSG6qOHRVv91f+6wN8IW+rA3uhdkUODOKcPrck2Ojnvswn+ggH2FgELQdiCNHb9FUvEgjLOiOcakYfKyysrYBkMbheMQS7vNOxAz735F6bxw4qpyRh5K+dkYe+3o/3AcCihHZcOHnk1gwNm/yBq3Dd13WxYEdCNCpImL3tfBskJA0rdna2MR8GYDp21goBKo/bukbIzJReGOlTUSomoa64GJL7H/JdIb4bqB9ZpFJOBhVLBiv35AzL6pADQIz1qMnH1LzSLUxAukn0aMov0KQU4kqeFP/KTChIR5Rab4D3IpRL7LWUMwJmiPgDTTBYVeaJLxvMsJ6ZW0Q8iNHyfpACrtkJNC+W62ljywnNQIlFEi1VtyWA5TCCgw10YeT9SQV+Z7EyHiqPPLVHnL2buo4duY1ElA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:16.8265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b4504d-bdc5-48af-c0f9-08dd3bbd640b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB6073
X-BESS-ID: 1737643881-104785-13353-21061-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.51.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqbGpoZAVgZQ0NLCzDA51SAx2d
	DC0MTUxMzQNM3YIi3FODHJwsTA3MRCqTYWADXva8tBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262003 [from 
	cloudscan17-192.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

[Add several documentation updates I had missed after
renaming functions and also fixes 'make htmldocs'.]

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 99 +++++++++++++++++++++++++++++
 Documentation/filesystems/index.rst         |  1 +
 2 files changed, 100 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 0000000000000000000000000000000000000000..d73dd0dbd2381639320f5bb59a2fec95e06928b8
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,99 @@
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
+is complete. Specifically notifications (initiated from the daemon side)
+and interrupts.
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
+-----------::
+
+ |                                    |  FUSE filesystem daemon
+ |                                    |
+ |                                    |  >io_uring_submit()
+ |                                    |   IORING_OP_URING_CMD /
+ |                                    |   FUSE_URING_CMD_REGISTER
+ |                                    |  [wait cqe]
+ |                                    |   >io_uring_wait_cqe() or
+ |                                    |   >io_uring_submit_and_wait()
+ |                                    |
+ |  >fuse_uring_cmd()                 |
+ |   >fuse_uring_register()           |
+
+
+Sending requests with CQEs
+--------------------------::
+
+ |                                           |  FUSE filesystem daemon
+ |                                           |  [waiting for CQEs]
+ |  "rm /mnt/fuse/file"                      |
+ |                                           |
+ |  >sys_unlink()                            |
+ |    >fuse_unlink()                         |
+ |      [allocate request]                   |
+ |      >fuse_send_one()                     |
+ |        ...                                |
+ |       >fuse_uring_queue_fuse_req          |
+ |        [queue request on fg queue]        |
+ |         >fuse_uring_add_req_to_ring_ent() |
+ |         ...                               |
+ |          >fuse_uring_copy_to_ring()       |
+ |          >io_uring_cmd_done()             |
+ |       >request_wait_answer()              |
+ |         [sleep on req->waitq]             |
+ |                                           |  [receives and handles CQE]
+ |                                           |  [submit result and fetch next]
+ |                                           |  >io_uring_submit()
+ |                                           |   IORING_OP_URING_CMD/
+ |                                           |   FUSE_URING_CMD_COMMIT_AND_FETCH
+ |  >fuse_uring_cmd()                        |
+ |   >fuse_uring_commit_fetch()              |
+ |    >fuse_uring_commit()                   |
+ |     >fuse_uring_copy_from_ring()          |
+ |      [ copy the result to the fuse req]   |
+ |     >fuse_uring_req_end()                 |
+ |      >fuse_request_end()                  |
+ |       [wake up req->waitq]                |
+ |    >fuse_uring_next_fuse_req              |
+ |       [wait or handle next req]           |
+ |                                           |
+ |       [req->waitq woken up]               |
+ |    <fuse_unlink()                         |
+ |  <sys_unlink()                            |
+
+
+
diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 44e9e77ffe0d4b9c85f9921190d33dfd21acff8f..2636f2a41bd3d38eef7fef74f46dade8c2beaeac 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -98,6 +98,7 @@ Documentation for filesystem implementations.
    hpfs
    fuse
    fuse-io
+   fuse-io-uring
    inotify
    isofs
    nilfs2

-- 
2.43.0


