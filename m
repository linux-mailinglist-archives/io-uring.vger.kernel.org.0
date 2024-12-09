Return-Path: <io-uring+bounces-5329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9149E99BB
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E875918894BD
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5E01F0E4C;
	Mon,  9 Dec 2024 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HAnDkeqe"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3591E9B3D;
	Mon,  9 Dec 2024 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756228; cv=fail; b=MMRjCecB5bC39jAHCWVw6W1/VIJAH8zB9hOUY8V0vtreuYSnOq0H/4SOkyCWhBGXMP9rTynivSjIF5A5CrQHz7XmB4wrSW9g7l9K1A6RHm089JS1/CnG867nfGzaUgQjUOIL0aCwLhD9N6nlocDExJ4qTTlKVJWbEJKgA8zlgfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756228; c=relaxed/simple;
	bh=MxfJjh+KWyLM/pBEqZ+TVduRkvAsbRDO2XTjnbrCNS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MX2TPr/ue7/lOa0Chxa9/daQj2x0WqRwt6LTbZ9XuYGvHBMjzhD0s54JVnn9zlEkQMUvMNUwm0cQhMjKfnoHFAu+5vII9/x8ah1hLRwTPCC8smNrEfE/wJSSnLvIzFYPHvHxyyy1E6btXA7T/4anGMywYMd9Kn5DPnIZ2hGVjxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HAnDkeqe; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound20-215.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VreWllskI9zQcMoTtUgYj3u3cGiQC/Ue1wzWhOzB+80MeSFFDYi3pMFdW+A4K551pqeG9lez5+YPfLVzl+pj0dscBJKH30PBEUAp2xwH9I426/EFFsUOhOphn6N9tNCQcPkRdHJ+XaznJA0XK6YqFt8H9PhGvthpXQFF+U8KolVKm2DeXeeIflUhwr7pwxSKmiGgQB7yFHqnYN4s3JtUq0APOwIyvk1BRBadtqbs5O1oOlMXt26YSmKFmApo2aIJ8wfb2Ltd9tLQh1Ntq+lm1V3yGrM9+a3ez9Cc+6NsbSyHqijqy/EkX9L7eh99YhZotUUl9+bjoDKiALlU66dhtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROJ/GyNgfYoF7z0FAlOmFhvKYoHCgYvO1Q08mJI7h60=;
 b=iZggkk+P/sS70iUXpk3uXg6xHWZEaWeFYx+UECZzRxemhvYj//q8R2wSZEMvMjuf/HZi02hFo2/HC33WVPcAGN401lHtiU3KYb1t1B+IuJNrMTcmUnmMuDQqE7SSdqrutb7OMa9PmpycH1N9sOZ5y8DuH9d/y1YmTMfGHaPa7QR4GVHlLQXhFx0TZhI/T2ptv2BaRoQFZLqHflbvXBdHDmycHTIsXeulsNZIRp5KjedCYnhZJ+bwnOxzBawOdtYQicTweWKIT955Uhn17CpAoe36xPECOPNchtBO7BKtlbXF2CBezPINEA3WMVw9mM3tnM2+kxJKyEuvKBjGSRrk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROJ/GyNgfYoF7z0FAlOmFhvKYoHCgYvO1Q08mJI7h60=;
 b=HAnDkeqe+WMxv4eDWAnzmTwg85Y2fFl7KSuKjzaqW1U/S6xkTcduUBFGscl+uKSV2dEgHfTQtA9sPtvToEuiH9y+1ycnoqVNRM8snEhDuIA7WpEaj85qlKvJUEEE3x1SokBL5gbSVxIOFrjwIf2C0yJe1Q8Mkj89K9APWE22o6Q=
Received: from PH7PR02CA0026.namprd02.prod.outlook.com (2603:10b6:510:33d::35)
 by MN0PR19MB6240.namprd19.prod.outlook.com (2603:10b6:208:3c4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.24; Mon, 9 Dec
 2024 14:56:46 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:510:33d:cafe::b2) by PH7PR02CA0026.outlook.office365.com
 (2603:10b6:510:33d::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.13 via Frontend Transport; Mon,
 9 Dec 2024 14:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:45 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A061B18B;
	Mon,  9 Dec 2024 14:56:44 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:27 +0100
Subject: [PATCH v8 05/16] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-5-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=6974;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=MxfJjh+KWyLM/pBEqZ+TVduRkvAsbRDO2XTjnbrCNS8=;
 b=7fWLyN6l2MTxNDNYXoY9+Qt1ao76sGHBRJgxOzipQ4Tjrqu1aF1Sai+NiTE8igWSzMa0ic5pl
 qgx4Cz2xA2TBdIrA4PDhhHODkjdCzaODt1j0696lbJehi9QyeVGu1sn
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|MN0PR19MB6240:EE_
X-MS-Office365-Filtering-Correlation-Id: d18e5cef-1589-4a06-a786-08dd1861b341
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjVMOGtjRkRQTFZHb2Y2RWRRZVNaQysyTm1zMnYxeGYvb0RsTUpodmc3Uzlv?=
 =?utf-8?B?ckFlWk53NlU1Ly9WTkpiR0ptcmFDcFRyelQ1V0V6VEUxblFUU1h1Qk1XRkMw?=
 =?utf-8?B?bG5wcHNkOXVOTGh4aEJNYlJGS2JCTjE0S3FzWXpxY2t4QmQ1N0NGSGphcTll?=
 =?utf-8?B?cmVyMGg1Z1AvZGpVUDlRMGRnVVJyUFlXakpGUU9iQndLQy9STGxXOVQzSmo1?=
 =?utf-8?B?Y3Fzd3hRRksrbld1MWZEUmZJbG1wT3hDYm03L3laUGdqR3lkeWFJS3haeTEx?=
 =?utf-8?B?VVVIQmh4SHc1MHJDQ1RtMmxXaWRiajJZbE1JVkYrdk5yQVVPMTVkMDdwUUhv?=
 =?utf-8?B?NFdkUVpIMzd1ZEVhSEdEUXg3Sml5bHlFcVFOY3UvNk9ITUxzRGwrckcrMFhr?=
 =?utf-8?B?Q1Zhb1ZDUHY4Qmw0eFVnZWdHK09tcFBKa0dCTUdjRVJjZVp6NC9aNmwxNkJF?=
 =?utf-8?B?TmFCVHNjOTNvQkk4MXZwN0FMQVBiNVFrQXZBTXd3QVA2VTBvVVVpSlBzYU1Y?=
 =?utf-8?B?cmxFWjRUYXJaR3dEL1YrYTZ5cDlxYWZqd3FtZ0hqQlVSazlrSEliWVNSaG40?=
 =?utf-8?B?L210UVpBMmJ5dHJpY1Bkd3FuaVdMNmRkQ2Q3YnVnV3JOeVJteFk2clZwUitC?=
 =?utf-8?B?SW9DbGtuYm14QjVGNTU0RmRJeUdlVjUzL3hvU24xZVFhalI5cmJ6VnFkbisz?=
 =?utf-8?B?RzBqRWJBQXRTMFdJZnZSYVRLOWtMd01PVzc0VEhULyt3MzBrOThpR2Q0MjIz?=
 =?utf-8?B?aTE3WGQ3UnUxZ3lHamRFZkMvSG4vc1VwbHhGUlBzODJKOHBXc3FuRmR6VUlq?=
 =?utf-8?B?aEhLZllyZXpqeDF2QWhqQTcwWU9tSUN2Z3B4UENyT0JOVFN1cFFLV3VMZ0hz?=
 =?utf-8?B?UXBmSVlKM3RaYXV1UWdPa2lKemZSMXlvWHJRVEdqOVZyblBrUW5JOVVEM2Fh?=
 =?utf-8?B?dVZwWG9pSURvK1crT1h1ak4xRUREMXNSUmR6SlZpRW9TOGp3SlF5eWNLWnVC?=
 =?utf-8?B?WUN2UWhtZDhHd05VZDg3N2tYaVN5YmRFRDZJVXlNM1VtaWhlOWdsUGk5QnUr?=
 =?utf-8?B?RkFUM09VSlVkUURKb3BKUW14aE9WK0hJUm1mMmxjazNIUFJJeEZMTUZzY2Vh?=
 =?utf-8?B?ZE1jc25udEpPMkZGZDlTU0tFc0RWeUF0eGV0RXE1aXhVeG0rdEhwZVhWc0Ja?=
 =?utf-8?B?eEpVVlhBYXYxQUs5SkFFOFFjQ0lpRUxYQVVMN080dHVra3ZaOHhPQm80YlpT?=
 =?utf-8?B?cUlWUXEyallXQzhqMnJpTnZ5Rk5wNCtGZTAzbi92V1M2L3AwdytoNXI2Wm0z?=
 =?utf-8?B?cmx4Q1pQVzBMRThLSndENW45TnhYWGhncThvZFVxV3o2Z21HTUVrWWsvVzVs?=
 =?utf-8?B?a2hPa1JlWE9SQjUrbWNHdVNsQVUveVRUYmNVWDVPYkIyanJHbjZ3bWlXL1dF?=
 =?utf-8?B?OE9ialBrUnRITGxWZ2d2b3pxU2NXR1QvcFhMZHUwSEwyUTlXT0NsRWYyNmhW?=
 =?utf-8?B?M2pnYURONzRGMGFFdmw4S21hQVNrUDdJT0NPMy9YSUhHMFk1UHZWa1UrRGFu?=
 =?utf-8?B?TGdkV1pBejlXUUVjNnIvVFJyMlNXMm9peTZvNHhsY3p3R1BoV00rOFFNcE0w?=
 =?utf-8?B?dElwbldVNW9RZnA2RU53dkdJREgwTXdXM1padVpRZG1MbjllWVowVjVqVWJ0?=
 =?utf-8?B?NHZ2R1lRa2hQc0dGRVVIRDdidU5YbzkrRmQ0ak0zUHB1THU5UjZjSDl1TVIw?=
 =?utf-8?B?ZmFUTndEYlNuY0JnT1NsV21yM0FMUFF4SkJrMTgycWpoc2FTUm9WTlVwQjQr?=
 =?utf-8?B?SlNEWDJwRnZPQ1pYQ1p6WHlzUXBrcHJ1eVAvVUNqUHFaZHhKNGMxOG91Sm9s?=
 =?utf-8?B?Wkl6YTA1eUNpN2FRVkMvV2p3cUNYSHBnNkNtM3dad1lsM1hFVXZ4dzUrSDhq?=
 =?utf-8?Q?vgPAhyNXwY67tgaoNpSGf67AHGREGH/E?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oHWc5z7yEkWIj9eCYOPsdlKJlSKRT5Sv8do5abmaFA+9I2cwAR3+V5YUUQ0LqKae59K0f2wgvFK7tb9CgLZqEvbIUoTihg2l67L5xbakYTBskCV2gf5BBvynzUwzXIekaZSV6Z1r4Y8dp0D9hpN+tEdmVGi8iHxBCOEGdVPRqsQOgFABn3wHyn28M4WxgdwHNSNPMpof4UPnuHPZcNavyGfNpnp+smMfra5DGp4ntwn2hvZyguWE9A36fl2QGZzFvR/nOwLwGe016bRiAf8PTJDjVKsUf/iS165fokqOcMSe0ELwtVjhhkSPofLpBLh/IL1DQcXJWespqEtZTYLjfhyfFxTGfjTFY0sWxjzVxNOvavUs0rls0zKuNNkHKA5iCmVHHDPHwDeAzrUN+G/CHBIpG1IBwQG2uXRmC0VdKexJsAWdEDrTXMFt/ZzjuuxCM/WGxCMf0saCalwqoQYtxf7J8qtQ4vfTjBp1O22g+9SVNlsjZMyZFezieBgGbprwvzpk9AXWp589St4dWwlPxWSbZsEmG4Ylu2tA2pSO+567G+i0P5Uao3cX42W/ppZ93qz1AO8SdYjgNBIDl+SeUnpb2vf/AAY9C8yNlhRjhqnsaNU7AJ73m/57Me2kwN/tOS1ctzJ1MaeroFOn6YHSrQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:45.3859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d18e5cef-1589-4a06-a786-08dd1861b341
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB6240
X-BESS-ID: 1733756213-105335-13467-4253-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmbmFuZAVgZQ0NAo2dDA0NTUJN
	UyzSA5ydTE3NQwMcnSICXJ0CTFKNlEqTYWAKK1z+hBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan12-98.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This change sets up FUSE operations to always have headers in
args.in_args[0], even for opcodes without an actual header.
This step prepares for a clean separation of payload from headers,
initially it is used by fuse-over-io-uring.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Op codes that already have an op code specific header do not
need modification.
Op codes that have neither payload nor op code headers
are not modified either (FUSE_READLINK and FUSE_DESTROY).
FUSE_BATCH_FORGET already has the header in the right place,
but is not using fuse_copy_args - as -over-uring is currently
not handling forgets it does not matter for now, but header
separation will later need special attention for that op code.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dax.c    | 11 ++++++-----
 fs/fuse/dev.c    |  9 +++++----
 fs/fuse/dir.c    | 32 ++++++++++++++++++--------------
 fs/fuse/fuse_i.h | 13 +++++++++++++
 fs/fuse/xattr.c  |  7 ++++---
 5 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 9abbc2f2894f905099b48862d776083e6075fbba..0b6ee6dd1fd6569a12f1a44c24ca178163b0da81 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -240,11 +240,12 @@ static int fuse_send_removemapping(struct inode *inode,
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4f8825de9e05b9ffd291ac5bff747a10a70df0b4..623c5a067c1841e8210b5b4e063e7b6690f1825a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1746,7 +1746,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1774,9 +1774,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 494ac372ace07ab4ea06c13a404ecc1d2ccb4f23..1c6126069ee7fcce522fbb7bcec21c9392982413 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -175,9 +175,10 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -928,11 +929,12 @@ static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -992,9 +994,10 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -1015,9 +1018,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 74744c6f286003251564d1235f4d2ca8654d661b..babddd05303796d689a64f0f5a890066b43170ac 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -947,6 +947,19 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_header {};
+
+static inline void fuse_set_zero_arg0(struct fuse_args *args)
+{
+	args->in_args[0].size = sizeof(struct fuse_zero_header);
+	args->in_args[0].value = NULL;
+}
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 9f568d345c51236ddd421b162820a4ea9b0734f4..93dfb06b6cea045d6df90c61c900680968bda39f 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -164,9 +164,10 @@ int fuse_removexattr(struct inode *inode, const char *name)
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


