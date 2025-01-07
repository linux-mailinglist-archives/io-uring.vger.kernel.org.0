Return-Path: <io-uring+bounces-5713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 660C7A034C7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4478E16416B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6742586349;
	Tue,  7 Jan 2025 01:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="MNWAwmHG"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9926A33B;
	Tue,  7 Jan 2025 01:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215176; cv=fail; b=hXbJ/cuR/vzWEP+WXRiGc4Vqag6BAOwIQpdApxEDPrB/3CbugC1TPc/o0NmzPXfuhOr2sBtp7xudlmKM5MF1wxOLyHOPdEJWbAcauHvR9YT0EZFv1+HmZGjukS/+qoQJmUtxVLiwwxWnGxIFlF2t4zCAXDE/AyaL+nUogDMQGrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215176; c=relaxed/simple;
	bh=/n0orAFJWYNWXnGFjoIDCECjocyPkeP3dloIDg3Ba2E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=id0UFmsgb294EuArx+osox95Bq1m0V9BtW9rMar4oZgfAdDWwNV0Jsy9kYiTKsCwRlT/9/cW+YNcMKX3wfdi/iStDy+WJw/ELawk5Zfw7vD7ZhARR8DbheEBeuCtzLEA74lbfY2snyYwBdQUH7hg+FJ1ep+E2tFfBvol2pcXDHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=MNWAwmHG; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177]) by mx-outbound46-163.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a10gko5aMSPCkPCFEb/CbfJBoHbjVVBWGUkqmZY+yWzli7mVfJeAxgUoTm14cA8JlQH8G8dHSEg+986Yva8/rALVn/WGD+m2eZZzILPrfPs4AfKJfNDSNqGqMSFEZE6nXfPGOtB5kJcGaBNh8yPlEnMelChR9ltzdIYNvfOnz1eflaySCZHWVZbp4QggRECm2TW/rA35sUV46O0hFprFnW2sa6+Z6zBzot0BtgsVqY5TNWn5xgkIYzc4U0OgjQvK8nhjPFRrjCK/q1kd/TlX8eletoLYPc69yAzkIGm6Dg1aeIeM5mf0i1eWqJNl3yH8MF36ni6uicmNOeWXJWvoZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37v6F51AKJv6PuVx+uDKyOz5jwsA98RjICcfcJAtH4A=;
 b=uQ7p2efRyxVQGvUAX91Yv9vBjyCqiMLDQfEM7EaCw4pj2T5xgDqZ+uI+RVuL9YoWVUN1LEGUy0lg5IOOYMwkySMZuNtJOLecVrhnbuipsN2Sv7Chsxu/VSE+HABi7V88ZydcSEAkq56NKzxvHUkXXM6sutf/Zw9T+KPEvnpLedyyCrerANFIceWorhWts04KyH+CMP4O4ol8amvXFAfUcJNznGnfTihIKBiu6rtUF6XO7murULsIuHLEO/LV3IIoT8o+EtUGd7jnB+ZOU/vaZq+hXzt2zGuZ426b8KPuuNdmsO+qebb/GprcJ4TDZd6+pzjffUSRg98U1xhY4grg9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37v6F51AKJv6PuVx+uDKyOz5jwsA98RjICcfcJAtH4A=;
 b=MNWAwmHGzKAkO/RlTfANCLW8WL4gDCHx6AmBuRki1sDkko0KuJynEiA2aPQU7m7x6TfWhoDOH7ZGBJS3w9WwhiuaS9RJLj5p5GwTa3w+SPYEEzoS5RV3WOY8dRulYFU37tO6EJLBhljkvjEt8aA83J2vCysIq3z7ToaZsTE4ZF4=
Received: from DM5PR08CA0057.namprd08.prod.outlook.com (2603:10b6:4:60::46) by
 DM4PR19MB6271.namprd19.prod.outlook.com (2603:10b6:8:a7::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.18; Tue, 7 Jan 2025 00:25:27 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::f) by DM5PR08CA0057.outlook.office365.com
 (2603:10b6:4:60::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.13 via Frontend Transport; Tue,
 7 Jan 2025 00:25:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:26 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E54F01DA;
	Tue,  7 Jan 2025 00:25:25 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:20 +0100
Subject: [PATCH v9 15/17] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-15-9c786f9a7a9d@ddn.com>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=7033;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=/n0orAFJWYNWXnGFjoIDCECjocyPkeP3dloIDg3Ba2E=;
 b=PWryG5vHhDud2kHYhD7xVrqK3SGBMa1T97CJ9yB0N4vCUD+1KiHilN/GhsJRSWAG8sx44Pifv
 oTRf3RA8nSpCMWa9ZTEWPERcKQ7NTz0y1UoBxO7tfjjV9+Hw1PeYIOi
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|DM4PR19MB6271:EE_
X-MS-Office365-Filtering-Correlation-Id: a5aded1a-c614-4dc5-f5d7-08dd2eb1c8a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emQxdGdZQ2czdXJ1czRLSkNnSERtNHdhRjJVTjU1SndhU1UvMXdEWGdHN2tK?=
 =?utf-8?B?SkdxUnlQS0dsOU1CTHdNbWNtTVF5ZTVKS0YwUXd2dERQM2ozYlNycFlDZ2d3?=
 =?utf-8?B?WTJVS2o3VUJhMGI0QWJ3b01KcldvVHNFN0dsempIem1aeWtFUVBqYXZNVUF6?=
 =?utf-8?B?YVlXM0ZZWFppVUIzSWFlWkJiNVkzL2FjZGxqVkxUcnVERmpySzFVUm9YUXRC?=
 =?utf-8?B?SmtOSngvbEIvaW53Y0ZZOEJnd0hKeVpRVTVmbkNZVlBIZWlaRVhNdDd6MG1S?=
 =?utf-8?B?RnRzbGxxVk9LbXRCRjFTMlMxOTRhWnoxb3E2UCtEY2U3SzZSeFFTS2RVMEJO?=
 =?utf-8?B?TXRQR2dLSll3Y2djeGo1NURQbmFGYnRqR0kzYjJ5WWhlTEtXZm54bTRtNUpE?=
 =?utf-8?B?U21Rc3d3ZEw0U0hISTNObGZMZElONUl1R2p4a0llUGZGMXN3RDJEMTN6eFQz?=
 =?utf-8?B?TTJEU2VBOUY1azlXVHFWNWZjSXYyUDVJZ1h6dFFwYktlZzlBdlBXcGE3YkhT?=
 =?utf-8?B?S1BXbWtxRGxndnI1NE9TYkZmNG5iYllva2RSWVdTZlJURzJZdk5SWS9xMWF4?=
 =?utf-8?B?ZUtuNDJ2d2J1c0RLak5YZGVQNDJveVdpRGlHY3pranVpblBGS1VidG5HS1lx?=
 =?utf-8?B?QXdJa1RoRzk3QUdJMnY1cXNENDVyMllJVk10SjFhVGZaWmovaCtZVTNuVkxk?=
 =?utf-8?B?YmxzUnlRV3c0L1BZTFRsYmsrd3ZkenRwWlR1ZldqeUEwaExvVktlNXc4bmtm?=
 =?utf-8?B?TEZsTjVrQlhNN2toa1lSejRCMU1ISzBrODdoU1JkNnFjVjA2L1hLcUJMcC9S?=
 =?utf-8?B?RENMcTg4VkZ1K1FHRE1BQWVsT1F2SitSTWlNSVpwMDZoUUZlcEVRMDBCa3Zs?=
 =?utf-8?B?aitpVWFkMnFJWmVtSjJwTXY4bGRhV1N5OVBpNk5Nem13VGhmS2UyTTFBdm5i?=
 =?utf-8?B?UlNwb21QVTlMWElRQ0JGZ1d6N2dxcEg2NDE4c0w2a2NTd3Z5bkt4MmNBdVJ2?=
 =?utf-8?B?VnB2ZDcvSFBLelM5ZXhucEh4Q2JIbzB2a2c4cmkraTZldlBleWs2QlNwWVA2?=
 =?utf-8?B?aFF0eHpXMmZvdTVyQ1AvSGZkOVhCckVCMFpCZlhCUG9la0s2Q0Nkd3Y0a3FV?=
 =?utf-8?B?S092ODJhQ0hxSzV2VkFBSjVId0k3dlRvcEFUdUdsZXZtd3NLZUZVeE11VEE3?=
 =?utf-8?B?a1ZPRzM4aFVzL3dWTzFabGJTZHo2QVdsMVovZnB5SENIYlZEYml5QU91cFNS?=
 =?utf-8?B?cUhiTTJnTXdGN1R2c1BOTlJZT2FYMDhVN3lDczdaZ3kyZ2UvK0VGUEI3T1k5?=
 =?utf-8?B?ZmNkTDhjUkpZUGJGLytmTCttWm5yQ0tkcjNCY1VzbjRMRkJ0ZlpZMS90bFZL?=
 =?utf-8?B?cmlKeG4wQUN3YTY3TmVvWjBYdjhRYi9nSW55WmNSb3JNWGFsbE9ycGo2ZWpx?=
 =?utf-8?B?Y01JblMxVlZkeEdOb0dYa2kxVjNzUGc5d0s1VldXV1JjUURSU1ZHekk2aU5S?=
 =?utf-8?B?UjNRUERPczhVT0lpVFVxU1d2QitaLzdSWnVUd284bmNPTkRPNDVYeEtHNUN2?=
 =?utf-8?B?TlN2dGQyc1kvVU9kLzZCSWJRaWhaclJBVWlxKytrWnhTY2liWVlqR3hKaXZy?=
 =?utf-8?B?eC9oekNsQnJmVFZCUGpvRmZnU2VFd2NTNGt2akFGdXpRVlVSbnI4OE5ZcXdj?=
 =?utf-8?B?TzlpQ2U0c2FsU0czTnBGdnczbDNYT1RYRlE3WnNTRjVLbXQxSU1DT1h4MFBS?=
 =?utf-8?B?R084ODlPMWJZcyt4N1JhWWU0dEtxMkVBMzhQWUpOeXBUWnJ3VWRhajYreU1w?=
 =?utf-8?B?YnVnUXQ0dUlOY1BBWFYxTG9JR1pzbEFGMVBDaXM3Ukp1RFZlL0prdjNMWXpT?=
 =?utf-8?B?WmFSeHd6QjJSUkh0M0RJZk51ZkM4YW0xdVhFcmhMVFpMN0QvZWp3REJOT1hM?=
 =?utf-8?B?bkFOSkJBTFVQTmdiZXFJSm1DeHZya0RWeUJQSUZkQ2xheVBncVF1bjl5TjVK?=
 =?utf-8?Q?K82hNX5a/2O06VT7kcwrSx5GfI9B1o=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l6exJyPWjNvJiAKk9jW20w8pxVLSCGsdu/aa9hYliRJI0qtIetJqtOCU/XBElBwgtMqcpQ81K0K4heSzDoerIO3QfKuiV39wdzwyPSHkn90ntpaDqKcHaV7y0jvph7MxMHjQhvEjd+ueTfKdGZhTAk7udB2MxgMFRsSf1Hcw+Xm2ux25icoODlMhcz0b5cwMJFDv2sp9/hcZ06VG743kLvjcjXcaNNACvfhttQrbDJVxxG9k7P5e3PGOBXLQsKqAtamxSlTUAsSqc/H2yOnDKGvLxkm72RANddY6rCcm6WB2u2e/umwiFKeN6zxD12yGKP0YFtNxOnlBALxhme4TBx60e5f8aLjq4dg7TavR9YpQBfVj2PE8xWWg9GhfmdcnLaTkVqV53z25EnPwm5oukaF4eQZe7LrpQTu2S7872KS4StpO1TOB13ffiTxGYimV6WkygEjHRhvYsgtyF2sVWPgNGw/YJvQXOg90QTnGB64v7EFe/p6hnaWDT5VHMzwBfUlObL8qduNJophV8li6PgWjrPPb6syzFJfXPdP2e3IlH/vlFy49RNirkYnmXhvnWI8w+nqS1QFwDpRJA0bICW3Mm8CgUyX7shiL8Lpo1TOU9SH4I1h5PVlF2dUIKIKL5lz9QlSCA78TtYjFN2N7Mg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:26.5455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5aded1a-c614-4dc5-f5d7-08dd2eb1c8a7
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB6271
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215163-111939-13335-9904-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.177
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmYWRgZAVgZQMNnIItkgLcnA0t
	A8JTUtJdXCwijZJBUIzcxSLU0tE5VqYwFJfpTmQQAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan23-178.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

When the fuse-server terminates while the fuse-client or kernel
still has queued URING_CMDs, these commands retain references
to the struct file used by the fuse connection. This prevents
fuse_dev_release() from being invoked, resulting in a hung mount
point.

This patch addresses the issue by making queued URING_CMDs
cancelable, allowing fuse_dev_release() to proceed as expected
and preventing the mount point from hanging.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |  2 ++
 fs/fuse/dev_uring.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/fuse/dev_uring_i.h |  9 +++++++
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index afafa960d4725d9b64b22f17bf09c846219396d6..1b593b23f7b8c319ec38c7e726dabf516965500e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -599,8 +599,10 @@ static int fuse_request_queue_background(struct fuse_req *req)
 	}
 	__set_bit(FR_ISREPLY, &req->flags);
 
+#ifdef CONFIG_FUSE_IO_URING
 	if (fuse_uring_ready(fc))
 		return fuse_request_queue_background_uring(fc, req);
+#endif
 
 	spin_lock(&fc->bg_lock);
 	if (likely(fc->connected)) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 4e4385dff9315d25aa8c37a37f1e902aec3fcd20..cdd3917b365f4040c0f147648b09af9a41e2f49e 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -153,6 +153,7 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_ent *ent, *next;
 
 		if (!queue)
 			continue;
@@ -162,6 +163,12 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
 		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		list_for_each_entry_safe(ent, next, &queue->ent_released,
+					 list) {
+			list_del_init(&ent->list);
+			kfree(ent);
+		}
+
 		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
@@ -245,6 +252,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
 	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
+	INIT_LIST_HEAD(&queue->ent_released);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -283,6 +291,7 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
  */
 static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 {
+	struct fuse_ring_queue *queue = ent->queue;
 	if (ent->cmd) {
 		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
 		ent->cmd = NULL;
@@ -291,8 +300,16 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 	if (ent->fuse_req)
 		fuse_uring_stop_fuse_req_end(ent);
 
-	list_del_init(&ent->list);
-	kfree(ent);
+	/*
+	 * The entry must not be freed immediately, due to access of direct
+	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
+	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
+	 * and accesses entries without checking the list state first
+	 */
+	spin_lock(&queue->lock);
+	list_move(&ent->list, &queue->ent_released);
+	ent->state = FRRS_RELEASED;
+	spin_unlock(&queue->lock);
 }
 
 static void fuse_uring_stop_list_entries(struct list_head *head,
@@ -312,6 +329,7 @@ static void fuse_uring_stop_list_entries(struct list_head *head,
 			continue;
 		}
 
+		ent->state = FRRS_TEARDOWN;
 		list_move(&ent->list, &to_teardown);
 	}
 	spin_unlock(&queue->lock);
@@ -426,6 +444,46 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on daemon termination.
+ *
+ * Releasing the last entry should trigger fuse_dev_release() if
+ * the daemon was terminated
+ */
+static void fuse_uring_cancel(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue;
+	bool need_cmd_done = false;
+
+	/*
+	 * direct access on ent - it must not be destructed as long as
+	 * IO_URING_F_CANCEL might come up
+	 */
+	queue = ent->queue;
+	spin_lock(&queue->lock);
+	if (ent->state == FRRS_AVAILABLE) {
+		ent->state = FRRS_USERSPACE;
+		list_move(&ent->list, &queue->ent_in_userspace);
+		need_cmd_done = true;
+		ent->cmd = NULL;
+	}
+	spin_unlock(&queue->lock);
+
+	if (need_cmd_done) {
+		/* no queue lock to avoid lock order issues */
+		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
+	}
+}
+
+static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
+				      struct fuse_ring_ent *ring_ent)
+{
+	uring_cmd_set_ring_ent(cmd, ring_ent);
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -836,6 +894,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	spin_unlock(&queue->lock);
 
 	/* without the queue lock, as other locks are taken */
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
 	fuse_uring_commit(ring_ent, issue_flags);
 
 	/*
@@ -885,6 +944,8 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ring_ent,
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
+
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	spin_unlock(&queue->lock);
@@ -1041,6 +1102,11 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 		return -EOPNOTSUPP;
 	}
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags);
+		return 0;
+	}
+
 	/* This extra SQE size holds struct fuse_uring_cmd_req */
 	if (!(issue_flags & IO_URING_F_SQE128))
 		return -EINVAL;
@@ -1173,7 +1239,6 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 
 	if (ent) {
 		struct io_uring_cmd *cmd = ent->cmd;
-
 		err = -EIO;
 		if (WARN_ON_ONCE(ent->state != FRRS_FUSE_REQ))
 			goto err;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index a4271f4e55aa9d2d9b42f3d2c4095887f9563351..af2b3de829949a778d60493f36588fea67a4ba85 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -28,6 +28,12 @@ enum fuse_ring_req_state {
 
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
+
+	/* The ring entry is in teardown */
+	FRRS_TEARDOWN,
+
+	/* The ring entry is released, but not freed yet */
+	FRRS_RELEASED,
 };
 
 /** A fuse ring entry, part of the ring queue */
@@ -79,6 +85,9 @@ struct fuse_ring_queue {
 	/* entries in userspace */
 	struct list_head ent_in_userspace;
 
+	/* entries that are released */
+	struct list_head ent_released;
+
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 

-- 
2.43.0


