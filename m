Return-Path: <io-uring+bounces-5075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E44389DA8BD
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A35CB2377C
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05C61FDE1B;
	Wed, 27 Nov 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="jYpGBC2h"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE48F1FCF7D;
	Wed, 27 Nov 2024 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714864; cv=fail; b=i9oTj3WgA/gmvDAQ4xpx76tFDnqjwlXpOC1Ttnnhi+Zk81DcdYoH/GXW5Pn3BZpUIy+3ENp3rjHr4Y3vHqbMNtJaAVioCJtJd8C4QOZrqWHpnJDjZLbKwXapLl4gpHj2JiyvIXfQzLSj6eR2xK20cYfm+3IEhbQoox7wdCzQjsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714864; c=relaxed/simple;
	bh=3Ia8xa5+ywUtWGfJ9AvgzAZm2DIv2wptA9eSVkWhG3Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qLnvm3i8zB937MhfM6LHVsdbaaROnU5+6g5Hia9ZTZG8NufnD9aGMLIPlJpDA5polfFMoXJZrIyk7ICzCW/QYYTipMMbS6SGghKEHwlwDFivQ3pTPgPRN9k+kJ0xaPIzV7alQqg92+UMc+xjc3aDPnUwC/b0ZlUfyZBFdfGwuSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=jYpGBC2h; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172]) by mx-outbound45-240.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWsg/qocMbjmCdex3TzayiLXvVbwgksWx0u6rG1/Df4o65HUZG/qMEOPZfidKUQ6rAGGpMGEn04abnZGCNYlG0yCeKve1T7gprb4T2tMDRDkGkKQtS4U9DsReaMjkQfZqKCKHhzl8RWMVJIutWCXuEUVZ4XEJuJ0DECTI9opR3sFk+9MyiHNT8L3LTih6FPcyXia+1Itb8X6LtOR41iWsP7m5jj3gm5mvBr6QivTlR6LkaTCLvDhkuRNqXk3z0DAZfiihWYoz+Y9a+8HkPrs2h4hHcSErBb4/tLZp1LAIyX7DWNsgZuf+vtjzrE6kvepv8IkBHspxGbEaFlzwUvCZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PjqHMWBVy9lkVcUFq6CqXAMFXmbXRRATa7kT67dvY00=;
 b=o3UJxnPVPfQyp5H36MdIkuH6ykEBT8p0800tn3zr7bESqpbh4b2BsOo2T1iJGiDHtTkXr+T/BbdTkx+R/eryATmGJ6WTo5xHzNGH9CtmSQNNWYSHxBuJj0BeuU0Sm4AH0/BHqwVfj/K2wp5yZja43nkgc7HOHfSyAU7BpwBlemq/1RuqIUH4Sc5ziBgkp1zF1627lMew8TwgQM2sqsphM8w2nUPLJ4+a9HVNliQ9etycjRGQhdt7dS9H24aHHBkV+u5rh6qgAbSRdaASJipxQoYDrHGY+yC++59MCgULC8bMmiEQTABWcWUu6Ds74zth1kh8yhnlIrbo15xfzBkdwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjqHMWBVy9lkVcUFq6CqXAMFXmbXRRATa7kT67dvY00=;
 b=jYpGBC2h2Ybv87MgQA0Fq3t/igYycl1gR+Lj12C3oH4u6IceiRLsuBpCIO4RVoZtcXZv1Xd0TnylO+ByXsXXb+0dCENVaDQUZELwe7uxXMclig6EHlo/YFu4nZW38V5ER+RBIvdQmn7xE1svLCqY+0SeQQnpfeJuoRccB9HQ/fI=
Received: from DM6PR21CA0023.namprd21.prod.outlook.com (2603:10b6:5:174::33)
 by MN2PR19MB4063.namprd19.prod.outlook.com (2603:10b6:208:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:52 +0000
Received: from DS3PEPF000099DB.namprd04.prod.outlook.com
 (2603:10b6:5:174:cafe::31) by DM6PR21CA0023.outlook.office365.com
 (2603:10b6:5:174::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.2 via Frontend Transport; Wed,
 27 Nov 2024 13:40:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099DB.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:51 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id F1DE832;
	Wed, 27 Nov 2024 13:40:50 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:29 +0100
Subject: [PATCH RFC v7 12/16] fuse: {uring} Allow to queue bg requests
 through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-12-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=7176;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=3Ia8xa5+ywUtWGfJ9AvgzAZm2DIv2wptA9eSVkWhG3Y=;
 b=QoFrxUzH/+0CTxXK8i1gHFNB/lqLLckITw2NyaTc1sSde3M8h/mBQYqiqRa8j7AQXag4afS5C
 R5F8Z1DuE+yB5oMGJosITuSzZRTjrj+keoIhqAlJF7TfBqXUfQGF67k
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DB:EE_|MN2PR19MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c4faf5-cb1b-4af9-dc53-08dd0ee91c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVY3RHlEMG1rZ3o0aUZFSjlmMFJRTU1zOHFUQXdtOTNBMHJvZ3B0aEd2Vm9q?=
 =?utf-8?B?MXl6TTBmdm1WRFluK29wU1V1aWd6dEVOVm42bW8zS2E0ZGUyUEFycjhnMlZS?=
 =?utf-8?B?dVE5a3ZpUWVXUXVWaWNqditEcHozdEJOQU50QnVDanNiN2hidkQxbnRobElX?=
 =?utf-8?B?V1pqcnJZUTVUNWNFNTFHMGczNGdvVFBwRUlyZjlHRHNiRSs1akxvaVdlRmUy?=
 =?utf-8?B?aDYycERvNlh2SGUwZFYwaVNYRGJZejFvTkNESmZhTHNTRHYwUjNBUDZkaXR3?=
 =?utf-8?B?WXlramFXOTdrSmFMZlV6K3JnQ3R4YlpoUWwyOHA2cmxaSjRvT1REdVA2SjBt?=
 =?utf-8?B?N3ZRTk8zYkg2alVsaGVKSlY2N2JPT3hWeGVrNjN5aGFPTVBBajc2SWRlTEM5?=
 =?utf-8?B?Nk5aZ1p6WWhrMVhWRk5GS2JzUjJ4ZnFiQ2hDaFlPNHdVekVQSzUxRmFUVWgr?=
 =?utf-8?B?MzJxS1gvbVYrbkhDWVNWTUl0ZHZTME9sRDJGQ25HbWpEbWdWUFdxekYvamRC?=
 =?utf-8?B?ZGNWSm9WU05BaWdoKzJRZjZsNGJHbm16SzVZekZmV2NsdUpWUnV4b1NSKzgr?=
 =?utf-8?B?MkVZZ0hISGV1WC94S1hsU3pyWW9JZHVESWQxWHlsaU1Ha3hDOFpjMko2RkxE?=
 =?utf-8?B?aE5KMnRSQmJSb1pxV2dhM1Y3anBiNy83SUV2c3JYcUJzM2NCMzdRSDBxQnZT?=
 =?utf-8?B?UnpyVjE3YUh3bEVZWnhDWkR3bldoRk1RcnJQVG9Eanp5UUtEMmxSVHJDeWRw?=
 =?utf-8?B?dmZ3NEhzeUUreDVKemlWa3p2Vk5OMFJyb3ZpU2pQcFY3UnRrQnpUcDcvRCtp?=
 =?utf-8?B?RUtoODczOE9qdkhHY29VWlkvWEcxT1RCd1YvT1lHcXVadThWWW5aSWNkU2Zr?=
 =?utf-8?B?N3VwY2plZkU0ZDZkdHlIVEg5SzhrYmkxd1pVeFRGK05FN29jRjZlT01xLzhN?=
 =?utf-8?B?YVZlSVcrU3dtMUZYUGxrSUxoem9rVzVkejdTOXFBSlVreG41aVJqaVFrY3NG?=
 =?utf-8?B?WlJpWDNvaHhLY0lIQkFhakVFaWlVbzVhVnQ0Q1UweHdQbU5QWFRjRDlUWmZa?=
 =?utf-8?B?Y0RPNk9SQTNQajUrYm5nanpYZTFSa1NxaS8vRmhVeVMxL0xLbmZENFlGbUlq?=
 =?utf-8?B?MEZkSWxVUldGNFJxcDVOVTBsZ2pVdENlM0szQy9NdEQwU0EvUjE0RkJGeTRq?=
 =?utf-8?B?QThKU28xZXdSYTk4NkZRSEM2S1Fqd1JnajlWbFV3UXNvR05uN25ZcDV0QzRQ?=
 =?utf-8?B?ak0weW9lSnJ2dU8xVnhKaFA1WjEzbWUwYUo5RmFBRE5FR2xQRnB5MWV5MG52?=
 =?utf-8?B?YUZ4VFJJN3FxdTZDNzF2ZGpXZUlJVGJidDNGQ3l2MHU0STdEOHRQdnh6NkVp?=
 =?utf-8?B?c1JFSm5GblNYWDhTYmYrSy9EOHBEVk1XM3dZZ1ZHNG5CQVArMFF6MDBkVFQ1?=
 =?utf-8?B?ZTJrWlNacFpUOHMzbkRDYUE3ak5sRXFXcVhyTWJ5ZFlyZG1TQ0NoQmxqOFdv?=
 =?utf-8?B?V2pkOGhYVFZWVXlnUXJhaTJxVG9zM3QvMG9DK1J0WUE0K1JtUnpiWHpTblVP?=
 =?utf-8?B?bjRGVi81b2N5czlhMGo1a3htdkE3UUxOTkFIU0V0UlhNUmVXRjRYSTZURnVm?=
 =?utf-8?B?ZEdsaHNkdDZpOGQ4aFNyRUd3NVllandwazhzL01PemxVSWhGQ0tSUXlrQTJm?=
 =?utf-8?B?UmY3WnE2ZGVzdWUxYTdHYi9rN2JqSVp2bG12UThYTVB4VVI3RjZObllTWlFy?=
 =?utf-8?B?WTVvdi9KbERjejZ4SDh4N2w4NHZlTVJpdjJ0VkpCV0RnWmxtNEJ1MDFmY0ht?=
 =?utf-8?B?dlRUZXBZY2JFRkNlY0F6VlJZTGhad2JoMklYNkszdjY0THV3Z0FkRVlMcnFm?=
 =?utf-8?B?d0VvOVM4dURMRFEvQUQ2dnJEbDN3dmc2YkpCbzhWVTJYYndjMExNb3d0VlNT?=
 =?utf-8?Q?A+wRGkATL/sJgK+9/W1d9ZlP2XUV2hR+?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PhmGyNo4jLKglFw7HwpkSpza4O1Z4wii9CF+dVi24ZIkSTdmoHaNKArBk1ebjdsAg7qr4RjBrr11Stj5rGjqTN3CaY23blmeCgIUI61UVyAE7Y3K24luImOrqDGtGq58/FwrBmQ4DE/Nafb2219v/BxLKHhDhr/NH7bm9krlf9OfVzDglgweLhvUytJx/1clw7YD4tLn8Ge/gzp5cZ/ur+9DBci9n5UjgiV4NpfCTTLsGRlIVXm857zfDgKc9HLQskTjek0wkltotsVtgnbbcryz7Uvn5MNghjbxiC4OFRh8IlK+0pIkpsagVgAFPleL2FhSdeVB/pn4EakIFD69QN7PcEgvqUphNq2KPIZTEGWind30p/b81ZZhUH3QXxm2Nrmb60HDH753wnWBqQLcNBLRFXHfvl7porVE65KZONllXAA89Y6ez1BSwnesCnR2EO7tYkSE0Tbh7vkhYgbYANnLu+w1ge1FM0GFCLsc8coI+YNITkK/Hgc3D58ggOmQgfUD1P3UP0/lWe+6TnE6+peOXzDumUD1SDoG1HIdHxHMviLqIqE0doequ7GauW31oTHjy/Wjnl9njcny7LsIzwY84Q5HiRQeF3oiVgvSh2tKaiAa72UAnrE4tB8s92+SQOUF98WjTUGAvzGvI2XB7w==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:51.7378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c4faf5-cb1b-4af9-dc53-08dd0ee91c21
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB4063
X-BESS-ID: 1732714855-111760-13393-2161-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.56.172
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmaWJhZAVgZQ0MwgxSjRIMXCxC
	DJONk80dgkKTHN0tjIJNXIxCTFwDhJqTYWANPsxStBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan8-83.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending background requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |  26 ++++++++++++-
 fs/fuse/dev_uring.c   | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   6 +++
 3 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c53deb690cc9c7958741cd144fcad166b5721e11..5134bd158ce0d24f77a4b622b87ccb83b8c92f3f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -568,7 +568,25 @@ ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+#ifdef CONFIG_FUSE_IO_URING
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	return fuse_uring_queue_bq_req(req);
+}
+#endif
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
@@ -580,6 +598,12 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		atomic_inc(&fc->num_waiting);
 	}
 	__set_bit(FR_ISREPLY, &req->flags);
+
+#ifdef CONFIG_FUSE_IO_URING
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+#endif
+
 	spin_lock(&fc->bg_lock);
 	if (likely(fc->connected)) {
 		fc->num_background++;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b1c56ccf828ec2d4cd921906fb42901fefcc6cc5..66addb5d00c36d84a0d8d1f470f5ae10d8ee3f6f 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -30,10 +30,52 @@ struct fuse_uring_cmd_pdu {
 
 const struct fuse_iqueue_ops fuse_io_uring_ops;
 
+static void fuse_uring_flush_bg(struct fuse_ring_queue *queue)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_held(&queue->lock);
+	lockdep_assert_held(&fc->bg_lock);
+
+	/*
+	 * Allow one bg request per queue, ignoring global fc limits.
+	 * This prevents a single queue from consuming all resources and
+	 * eliminates the need for remote queue wake-ups when global
+	 * limits are met but this queue has no more waiting requests.
+	 */
+	while ((fc->active_background < fc->max_background ||
+		!queue->active_background) &&
+	       (!list_empty(&queue->fuse_req_bg_queue))) {
+		struct fuse_req *req;
+
+		req = list_first_entry(&queue->fuse_req_bg_queue,
+				       struct fuse_req, list);
+		fc->active_background++;
+		queue->active_background++;
+
+		list_move_tail(&req->list, &queue->fuse_req_queue);
+	}
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 			       int error)
 {
+	struct fuse_ring_queue *queue = ring_ent->queue;
 	struct fuse_req *req = ring_ent->fuse_req;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_not_held(&queue->lock);
+	spin_lock(&queue->lock);
+	if (test_bit(FR_BACKGROUND, &req->flags)) {
+		queue->active_background--;
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+	}
+
+	spin_unlock(&queue->lock);
 
 	if (set_err)
 		req->out.h.error = error;
@@ -78,6 +120,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 {
 	int qid;
 	struct fuse_ring_queue *queue;
+	struct fuse_conn *fc = ring->fc;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		queue = READ_ONCE(ring->queues[qid]);
@@ -85,6 +128,13 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 			continue;
 
 		queue->stopped = true;
+
+		WARN_ON_ONCE(ring->fc->max_background != UINT_MAX);
+		spin_lock(&queue->lock);
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+		spin_unlock(&queue->lock);
 		fuse_uring_abort_end_queue_requests(queue);
 	}
 }
@@ -198,6 +248,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_w_req_queue);
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
+	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -1093,6 +1144,58 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	fuse_request_end(req);
 }
 
+bool fuse_uring_queue_bq_req(struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent = NULL;
+
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		return false;
+
+	spin_lock(&queue->lock);
+	if (unlikely(queue->stopped)) {
+		spin_unlock(&queue->lock);
+		return false;
+	}
+
+	list_add_tail(&req->list, &queue->fuse_req_bg_queue);
+
+	if (!list_empty(&queue->ent_avail_queue))
+		ring_ent = list_first_entry(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+
+	spin_lock(&fc->bg_lock);
+	fc->num_background++;
+	if (fc->num_background == fc->max_background)
+		fc->blocked = 1;
+	fuse_uring_flush_bg(queue);
+	spin_unlock(&fc->bg_lock);
+
+	/*
+	 * Due to bg_queue flush limits there might be other bg requests
+	 * in the queue that need to be handled first. Or no further req
+	 * might be available.
+	 */
+	req = list_first_entry_or_null(&queue->fuse_req_queue, struct fuse_req,
+				       list);
+	if (ring_ent && req) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+
+		pdu->ring_ent = ring_ent;
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+	spin_unlock(&queue->lock);
+
+	return true;
+}
+
 const struct fuse_iqueue_ops fuse_io_uring_ops = {
 	/* should be send over io-uring as enhancement */
 	.send_forget = fuse_dev_queue_forget,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 19867d27894f9d985e224111ea586c82b4b4cfe8..0826fb1c03e2e38dedad56552ea09461965e248f 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -87,8 +87,13 @@ struct fuse_ring_queue {
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 
+	/* background fuse requests */
+	struct list_head fuse_req_bg_queue;
+
 	struct fuse_pqueue fpq;
 
+	unsigned int active_background;
+
 	bool stopped;
 };
 
@@ -129,6 +134,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
+bool fuse_uring_queue_bq_req(struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {

-- 
2.43.0


