Return-Path: <io-uring+bounces-6069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C36A1A623
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:51:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E1C91888047
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16E3211A2F;
	Thu, 23 Jan 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="w9Gy6Gz6"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66C20F971;
	Thu, 23 Jan 2025 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643899; cv=fail; b=NZbT3iRGC53N2h2JfOHGKq4QK1E0tDtqoYhaXZ0HFwtzfLdolgwybff3gbgh5vMARuF3DxlmXuPfJ2XlkmNjgpjVh1KfHozWaXl0UZIYF2Sf5WMXUA0S9fpn0XCIM37G3nx8bcSwUMU82e1VflrlzWCxZz/tuvT9w3Xjisy4DlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643899; c=relaxed/simple;
	bh=QEaZV+eBHnnF2f6i8r0SZXk2gH5YESwBQ3rr/AP2eoU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=St0d/xLNkPWM4SVL8NlP3n4kGcI2b4Y11IliNoZbZHPt9tzj8i65sz1SuNHcWE2C5/U6ltDUxh7Xlop7UqV4tXeKd9g5ZqWTw3e7mZ/fCWUKxjsKMGikRoU7x+1NwLMAcTA81iRAAIhgcRYlHUXqQ7qujFiUFgD0EJQSonzCgLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=w9Gy6Gz6; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound46-227.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1Kjv9FiFqWNJgRtSnxNLlCu3ym9RXdAw1ZjSI/yofAjTy7pOpVAn2TA1oDUBZXXXTzn0KTSCxdHXOyLnGpZXhktOREfONcZlQL3MRz7Tylx2UCwj7yQKMO+jkKJnvR9iho3HrkvnB3ZQeU/+UI5Y7IngcP9t3zwI3yq9JYaZDExdAGcBgxYi0oI1vBhB18p63NJkO80OHF/SlIM34pM8mfDf8H2jTsAYUhpx1amy2v1Tkl1vuLFuOYyJmm4tQy5RyUrzb+eYQVZ00NC3S3kH3fHzIt8DaANjt5Tf51jPnS7zNkthxWStLnx3lC9mc+x1uThkJS+d3Udgm/1p5iIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9Fhhg3KjX3KQ7/tQ1UUr2qA7J9WYDfKZqDSxfipFwI=;
 b=kS6gFMebrscGPOW8/4ajwbFe3XFJmgmLwXNFdqfwsv3ZFUnwZpJIiwpG9V186MD3kulP05K5vdJhniRTRuMOC5jF4ZdF+6dwp3RkNOOQUEJeiRqLkv+0gcIkdDQyW3cZFV+aACRClmjCluC1Up6nEXR9FF7hE5uXoyY3B6kMOxwJPOwFEmdXEirDd6e6KQgWmxj3W/x7veXB+7V+RM5m5GWgLHm4LmDmHZnofYudjNghZicvljsvwTPlVhKaHpHHKkP16hygTbHBB3fZC1LAi6nK5xW2V/L0GEK8cva5npnnPy/Ob2k5J9zHzAVC0FIQFoeudsGfHUj3d0mRiAWqAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9Fhhg3KjX3KQ7/tQ1UUr2qA7J9WYDfKZqDSxfipFwI=;
 b=w9Gy6Gz6IM+Q1fQ7eDRV9NvSmRVh7NknL2Yrquk467WsQm64hL1iFlh42SwZ1ohadvuMXOy0Sd3Se/0BeDRnxjF5i+aeYZD4F9HOo/xIB2WTZBJ2MHvxTmb/h9SPpNL4Jazxw+xyNbgPcbkp0bRUo298jEI85GWnUYvkg11NfGo=
Received: from BY5PR20CA0003.namprd20.prod.outlook.com (2603:10b6:a03:1f4::16)
 by CH2PR19MB4085.namprd19.prod.outlook.com (2603:10b6:610:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 14:51:15 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::16) by BY5PR20CA0003.outlook.office365.com
 (2603:10b6:a03:1f4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:14 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 23FC334;
	Thu, 23 Jan 2025 14:51:14 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:01 +0100
Subject: [PATCH v11 02/18] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-2-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=1684;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=QEaZV+eBHnnF2f6i8r0SZXk2gH5YESwBQ3rr/AP2eoU=;
 b=ra+ywbmHSXpKCZ5v+K+DRqOJ2PGbuBmSQ//Q2veMaT4z8lIXxOzVATYpjXK3JpL9tgauGf9Iq
 zw+AYwHOwLxBJGatqdW3/OE6doRoMSkpzmem4I4RWnoOe9Ey2L3SmXD
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|CH2PR19MB4085:EE_
X-MS-Office365-Filtering-Correlation-Id: b8b2e787-7530-48ad-e515-08dd3bbd62bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajNvQkEyejZCaHFMMmhQaTJHeUVXQVBBTDl6SXhBQ3VOYU5GS2tscHM2OE02?=
 =?utf-8?B?WktjeFFoY0FPeDJoQTVST1BtRVJWL0h1SElTRWt4MDVLWmlrS3ZoRm1LWVJO?=
 =?utf-8?B?WVJUL21CTlJTRTJQaVZjV0h5N0NtQWtxMHBvSjkxM2tNdWtaeStTMloyd09s?=
 =?utf-8?B?VjNtYVlZcHd2MFM2MGpBWitRbUF4K3o5MzV4d2VqNmREVnhOSzkrUFNXc0xw?=
 =?utf-8?B?bDBXdVpIR3VJTUFDaTdtR2p0Q3l2T3o1OGxlYU1ZbHZOU0MxYWxuRDA3Mlo1?=
 =?utf-8?B?OEhkbjJsemlvZVdTR1VQKzZYMFE1N3VwVk5YODhEcVpXY0dzOUFHR1ZLVWFt?=
 =?utf-8?B?akJocHJMWWJ4d3Y5ZjRQVEs4ZEJvVHFoWjI4eis0dERmTFRVeWl0VlZxbTNG?=
 =?utf-8?B?VmdJS0xjMmNaVU9hc0drUEFYRnVKVWNyL3NBb1luamdqOEFpTysrcnF6RkNo?=
 =?utf-8?B?TGY2eXlkYSs5YVhzcTRjVi9ERDNOUzVNOXhoUThQZUc2cWYycHY0Q2g0Yito?=
 =?utf-8?B?aUdDMFJ6VWdyclBxdjJhUHllWlllb3NMS3VUV2RZbG80SVZ5OEE3ZDRVS2Jq?=
 =?utf-8?B?Y0hnT0ZLK2NKclhnMkR5Wkg0Nk1pSnZWVUZpeUhtVVpJT0lDNnFSdHl1dlNr?=
 =?utf-8?B?RmM0N3E4VmU5TTdVUEZiWFpndGV5bGtnYVRRaTVwallkQnN3VHVVWGduRGVR?=
 =?utf-8?B?NGw1endaSUZ1UnZWMXNpcFVTSUg4VnkxM1BxY1Q5MWlBdVdoTUg2Q1VQRHRt?=
 =?utf-8?B?MEVjTkp6WjVseTV3NHFKYkJmVXRaek4vZUtYeHJMbm1odmdJaElnMjBsYXIv?=
 =?utf-8?B?Vm1lS0lHRGRVZTg4VHhpalpNRVNZVWFzUkl6TTJCREJIUnFuMWs3V0pWYStS?=
 =?utf-8?B?Q2NnVWtYWWh4U3J6RE9yT1dpd0tZc0JUU1pXWWEvMU5NRGJsWWd5OXBkMEo0?=
 =?utf-8?B?NWZGazdxOFVhQ0s1NXQxWm5HVVpJWWJNbFdiek1DU2JxWkJtQ1lpaWFGT3Ji?=
 =?utf-8?B?T3R2YThPaVN3cldyWVViSXZkb0ExNDdyenNnVXV3UnN4cVdKU1BSRWc4VVUw?=
 =?utf-8?B?T21vdUpmNG5jb29GdFEybzl6ZWtpMzd4aW5yRWxmRVQrd3F0RE1wdHlJYnZm?=
 =?utf-8?B?bE1JSFdMU004MzA5aHY3aVNXRjNTNURROGxzbmpHQjNMWVZjdjQ2Q2Z1clNI?=
 =?utf-8?B?alJxTG1yaG50L2RNYkNtYlY2WE4wL0x2MVNTZUp2b3JDNXhnNlA1L2liT3JQ?=
 =?utf-8?B?VWg1dlgrK0l3WmxOcUlVc2ROTGRGUnVXQzFicWxnMFEzRGFSajdHWHl4Szho?=
 =?utf-8?B?S0FzV2Yvc00weHF5Ry9FUlh2M0J0d2hXcjloNVljc2hlQWN2SlpvWWxBdWln?=
 =?utf-8?B?dWs4KzJsNU16SWcraXp6Zmt6TGNPV2dwT1c1NFZEakZJMEhlT25SMzZZRXVq?=
 =?utf-8?B?YkIyTHg4TmZ1OEFuNytiNC84bldUKzZFTjBtM1hvVklTS25VNjgyZ1RuSTdD?=
 =?utf-8?B?bHVtUDNuMFU2SzkyaHBZMWUvMHVQc3Z4aXEvcC96MHJyWi9pNEtENGxFZUlP?=
 =?utf-8?B?WmRmZ2o3SVRRUG5xQVVhZDI3TnB3aTFZcWkvcFZncHZISldyQUVoNHVVYmJE?=
 =?utf-8?B?Q2dCTjM0eHR1MmtQQklaS29lUnhodytkQnBPYW5GUlN5eldrbjN6QVNESmMz?=
 =?utf-8?B?dHViQWY4Vmo3b2lLOHdsd2hSNGFtTm5tVWw5cjNaQmVEY2s2TkpVc1c3OUFJ?=
 =?utf-8?B?QThNd3I1ZlFQaTBtTXFpRTJ2YjQyb091MHFsMFpNUkpVWVErNDlVYzV4TEs1?=
 =?utf-8?B?WkxFN2w5aXBucHNma1NieTZPcTdnd3Q5ai9MUDdTZGx3SkIrLzVQL2J3Q2Mz?=
 =?utf-8?B?YlRPZENnRjlMT2VWaUxjT0E0QmNwWE9LV0lTR0lLOGRDT1JLK2h2SUNSZmhO?=
 =?utf-8?B?bldMcTAxMFo5NC9UT241eEsyb2Z6SWZObTNwVVo3MVI2VFQ2eDhpRjA5SzB6?=
 =?utf-8?Q?RR+8fKu6IPoNpmHRoi3yTp+hXCybTY=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JeCKUVJFjp4vgsOFL5GNgN52n4zlE+rK0IIMpnALMPyXVttz8dyN+aIf9M+s9xH0XJdfUIv/QyAlacWctn4iG/OqMS+6DkJNAgjLLqcxuhjg5QSeM3LArG1If1lfXyXUNW2/iJfyZl24OUZusrfAS2fOKByMhZHNyyAvVjXYOhNuKdkx16kbYVNZv7mJa92JGMuZZHB+USmYq4tDKCgWWz0SfvX33zO85wpH/dCijcQxRFX7KHGVXYSsHusuCEYG7OHceEKGgTqKAXP/uHz0JxnLrafXHLIrwDHjDd1qhzb6pe/6XLvbuGpAl0gxwBVxxmCrOS1ghR0OdDmPQoQh7OlrnxlmeneMBAZOdmHFq1iO6lG6kIPI8iOZ1k3LNgMm4WQg/q2V1xv1pS9GmxlGwsfac4PiVLlfXk7lGdrziBzhurOYLgs4QgI/8FKlGi+QNs7VbEy7vniUlubESwQShzRjkFE7aQBqh2xbcHSyS7/d2mPfQGPNLHbrtv/CRvtfEYQifoezntFNPmWGzk9e7pp8o0X2frQTw5/50tgy1NN7mDlQGG+4m1Y4MD4RAV8WqkusLZxu9xG/ZJ5Sp5bSMvm0M8vAhfCh6s/D6cXq6oGB+ZmxfEPaZ2xvwTCZD/9PEuSz+J7udfMmROiIJ1Zddw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:14.7298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b2e787-7530-48ad-e515-08dd3bbd62bf
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR19MB4085
X-BESS-ID: 1737643879-112003-13396-6293-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmxgZAVgZQ0CAx2cjMOMUkzT
	LRMsnEwtIo0TTRPNnY1DAlJTUpxdxYqTYWAAIpvRZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262003 [from 
	cloudscan18-30.us-east-2b.ess.aws.cudaops.com]
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
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
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


