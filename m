Return-Path: <io-uring+bounces-4539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CE59C0C78
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 573821F21493
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2546B2170D1;
	Thu,  7 Nov 2024 17:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Z3Nu8LJj"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0D72170AF;
	Thu,  7 Nov 2024 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999080; cv=fail; b=okZuI7yHf9IgAYvCokT5th574UA+w8VtCacmG3iv/NsCLWJbhG+3W1vpa8b9arTcwRRLmYNsAwbUrpyiOdok6QfC8cuSMn8peMZxbnM02Nj6EHgYoNLaIwbIGfPzp57+GtG3z7l1rK9ujYMVw+42e+TmSYwmrPsoEey3IgSxbZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999080; c=relaxed/simple;
	bh=hj7RRgikG7hzVLz5Xt3Qr5QdpFRTN5r8a2u+RPCOzOs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aqRNV071cXzcSsKOxOL96aDCin3T94X/0hR4L/r4+SEEncjC9jNwQscLDKn1LQPSpykiuaiW/Y0V2DMyPzvZnMMTjKnhT10VlyN6nCmXeXvLV7BJ26Z9u3Jx8nDckoIsfHYmPlnXRjWOJD06bkc9x6pMHDVBMoRqgzdPpFCDklY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Z3Nu8LJj; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175]) by mx-outbound41-169.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yfYjl616YbWRgw/WWzUR7PFjHsj2tJ9ZlsasjJrg1IroSEPp4P3RYropI1+FWyhO1pVZSlRPCUkqyWzbIC+umK6BsPlohcRmWD3bjOr3OINcC211RMK4G+g/jjCDWCANh/J4Yw35d6Wfmyur7BTFrogwgyefguzUHfWT6xCRbFozDHmhChN6h6bn8diplLhTyFX0mxUQF9pmpztEtN2lnlF3ASH17PJb84ZnFLr/+Q14oQ9aDQrLLxgQUK35Jkcc4yt0dqlHSXGswdpaghTtFNWr9zwYWI1ZFVF77gAtvnhAJMnG58qHePDzcZ6EXISAGxXZ+KYx3LxkgavoHOatKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4meqAlc/o5Ix2xRPpcPz5BQ/KNWYkQ94OlVvmKV+V8=;
 b=UU+BJzKW7U6+nYLzkZ2g1sADnczMOqaRGbOW0dBbs5qyOUoRtlGPyhoj7zk0vG0P7xthpx/qiH6iWZP9J1EmSVPmJ681hjkZAUpFTRqWR5xJ/QdLIplqK0rA+whWWltuxF2W6TYMoesgrmKfDajZ+Tcq3AJYC4sJMVwWvTCL4Nlsx7NBn/Jj/m/rIASxL7wLE1L0hdZy8Ju4vAmCtP28iR1OTVJydVbtYMP5l6y06m4rbGEkdGDTJmcz/O+HqY4rAx5COqSYxmUaB7kzSPnvMZsUxQkrx6qofFP8y2jqOIkczk/9EUSRm3FcXjvGQjv0531XLUHMvt/yLMQ+nzYS2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4meqAlc/o5Ix2xRPpcPz5BQ/KNWYkQ94OlVvmKV+V8=;
 b=Z3Nu8LJjRyeKBkaGsS7p13gilHkfzvaO9oockfXDOWpk0nKUDL4MjBRw4xgNKYnN6331qIFcPkm9VfDEvGA692a8Blju/s24xZ/GeYr6qbHWXnaz9ralByDhAOvkr1tzU0LfndKsi7HtrX6aouSQaORzWbrgd8WdT5AhQ6pktEA=
Received: from CH0PR03CA0111.namprd03.prod.outlook.com (2603:10b6:610:cd::26)
 by CY5PR19MB6494.namprd19.prod.outlook.com (2603:10b6:930:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 17:04:16 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::43) by CH0PR03CA0111.outlook.office365.com
 (2603:10b6:610:cd::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:15 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 3400FC6;
	Thu,  7 Nov 2024 17:04:15 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:49 +0100
Subject: [PATCH RFC v5 05/16] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=8693;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=hj7RRgikG7hzVLz5Xt3Qr5QdpFRTN5r8a2u+RPCOzOs=;
 b=avcXF+nQsyLMClrbxovLU8coYJDoiCDGyjD6abWA9+RinrqfDyC409m4OboGtqlMKLxef+UsU
 CUenKG1S3wXAdyOS2pgRB3z8FWYtg2/OcfdQumI9gFePHhx/7XFc0ta
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|CY5PR19MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b7d280b-8d66-4122-e636-08dcff4e3611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmVxMm1OQXVHZ0pHNEtCQnV0dGhHUG85blhhQnhzUTJqb3gyOEZBMURwZmZq?=
 =?utf-8?B?ckxsRHJuaXdQTDBBaFlNKzdwNDJXRDRVUDYrUEJtMWFUVXl5T0pnd3o4RDVL?=
 =?utf-8?B?YUdOcFFSZENHMEU1VjZVSGRRYUNLTUFZRnlhUGM3QVVHZ2RZbzRvMDREcHZ0?=
 =?utf-8?B?WlZUczg5enhIT1dQZWw2U0V0YVpSaURaL3VYWlNDNTkxdWpZVUMwOEduTWcr?=
 =?utf-8?B?QWxnOERrWVJ4MThCTWJyZUNQb1lsTENOeENPQXU3em4xL3RFUHZVK0pwVUUx?=
 =?utf-8?B?LytxKzFUclB0andhTzlHM1E0ZW80SXZ4dU1Kd1Y4b2FXdTJWNVZhaS9sTHZr?=
 =?utf-8?B?UEtLVktzLzM2RzlsNXBlYkI4V1IvU0pWa3ZJSEJsRGVPbjJSdmFUWkI1eXpu?=
 =?utf-8?B?aGZncVV5SWwvSWExc0tFdERjVlRpcHFGMVVyRUYzTnZjSGtwMjh0WjVHdENh?=
 =?utf-8?B?QTZORU5CNDE2MTVnZmZYM3RxdkpJeERJdnlKK24xOTE2QkFMWFRMcDl0cEJE?=
 =?utf-8?B?VnlYNTFFcEVMenpQRjZVc1FIbWpveURlZlp1b2pTaytBYTMyQVlQT2pTSndj?=
 =?utf-8?B?aHJxSXQ5clFtc1RGd3ZKaEluRG5YWmpkZW5vNzhPdVFuSlhBMmRIbk1MdkQ4?=
 =?utf-8?B?VGxXUDFwOHVSMVRaR203cmlVQmRkSzFIekJ3bm94MlVOQlNqS2VKZTUrLzBP?=
 =?utf-8?B?cThRVDZDL1VyaTZBOHZwNDRXaGo3YUsrQzV5YzA3MTVreUtBaTk5Q1B4aDB5?=
 =?utf-8?B?TFBZaE9vdk1OQTdmOVVxYS9ud0lFZDFpSHRKQmVCSkpWZmszTGlDcFpPWG5R?=
 =?utf-8?B?bVhPcm45am5PUnU4c2M2WWF4UXpuZDBuWW5XS1dUdmlpSG5MMGlvVDd0aWFz?=
 =?utf-8?B?QWtFalRQbHh0NkVJcVF4T0hpR0tUZytWYTk2SEcyMmdtL1FoMzU4cnFtajdQ?=
 =?utf-8?B?cXQ1bVI2bXc3VHFVRHBVZXZRRG5yNDZrQk0vcWhmWjZyQjdKclFHN05TVnVC?=
 =?utf-8?B?TFI1ZktuclA2Z1ExdDF5aTY2ZXNxYU9TMUVRTlIzVDQ2UktaMEJ3cG9uR3px?=
 =?utf-8?B?c2gvODJuUjQ3SVo3OUt0YUxldU42VWVOckpGNVd6cFFKSDdyRVY1Y1NoSUty?=
 =?utf-8?B?Um5JbHcrWmJWMkRlRHA5NWFQd1lxWFhwalJTOTNQb3pOZytBQUprcEtCeHJJ?=
 =?utf-8?B?YksxNGtpclpudjZabkdhK1liYnNIWjVlZzMxbE5YWE9tQzg4V0JsQVltQTM4?=
 =?utf-8?B?bWZjSFFEeDJCaTkyUklab3VOOGJEWEFxVGpHRlVmRnpuM1VOWjJUOGt1KzBl?=
 =?utf-8?B?VTdLTUpCWDVhRmErZWgvL1prV2p4a0xQN1UwYVFtWHNmWGF0SnZHRGpFRWVl?=
 =?utf-8?B?aHA0N2J3czd1VzQyUG12akYyNHE3SW96VXo0NWhpVUFrM2pGZzc0UmxhWGJZ?=
 =?utf-8?B?UGZnZGtlNDlUMlN2d1lWT25vQnFxM1Y5UzJ2YnVnWGhWcndvcmZRdGpOTmdt?=
 =?utf-8?B?WEsyM05mZTQ2UzNKU3MvMWN6a2p6Z0U2MzE4L2YydmV4RW5lR1BPdUhqMG9u?=
 =?utf-8?B?ZFMzVmJzemlBWXdNN2hISW94OWYwQ0hZMEFzaXdVMnpJNkptYnIvaVhHeEw5?=
 =?utf-8?B?K0hlNnJqTGhnU1A0aUFMNUN0Q3Q2YkVrNEVINmJhM0lPNWlvWHpFSnhHNVph?=
 =?utf-8?B?dHJzTUJCeDhCK1R5TzdQUUp3Y0c0WC9zbWxTdWo4RGNDZmNLU1RiUFAzRHlo?=
 =?utf-8?B?a2dhdThpYllCUWhNTzBOSE5wSWZ0Wi9mdk9nZFRxRmZVNHNhVmVuSElMTWx3?=
 =?utf-8?B?S3JFRlZXeGRZclBHcW5icGxYYzA5d0lJeFJtY2QyYVNkWHV6NGptVFJrM0Qr?=
 =?utf-8?B?OG9GZWVwY1cwVncrTytNTmtFdjVwQ2NmNEU5ZXc1dHVSN2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xiZogyISOQvwiLPi1pyBOJIpXCEfgk+lTikiPBXhFa4ZRKwEoP2s+I+Eepi7xhjq5gBs96lIekVxxL+YKIVLn2FL32c+zLxbi1vG1Two5s9lbkOIxy/DnYR6Bt7vlu+DD3R3F24BRIceg/4DX8S1PBDUsujb4NMes38+RcNxsNSJMqjTd5yJb+xMnjMXgsCIprG6/reaXsDFLYXkKnoAchkdOYi+1Xi6mCEe5nCJ7XagvblYsVy6vs3hFOQE0ZSsnDFNbZ2TK5gjDkOt75eFb4y+906z6Kp/UPZostRpcxfjxAWrp3KAXy1AyjZTHI1xhZY7/VuIb2tTD0zQCguyXATfBOb3IKkM854gnH3DoD+FX85W1ObPN2yjAMbNgSr1pCOoTPAKMhMUQ+rgr8CNHykEJw3M2A2AufRDWea2AeMrRYgdsaaTE6RXc/AtQdDTgz+QTpjj2kFpdQyIZw75Fk1EbAIxMyk+ivg7IrVNK7bAWOSg3CedrGprKcitZalCh/9KhT89iRoG/KNQE+aqDs7D3IL6AG3kRdsdejTQhoGeDpeytQiCKjgCH1d36/g1VV8jPbRFUvwko4yko3CFIU9jLgEUR4lFEv3J0fVgN/AXvmbkVq/XcNlhQrL6BOluSI7weVvyvESwEs5ech11qQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:15.8504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7d280b-8d66-4122-e636-08dcff4e3611
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR19MB6494
X-BESS-ID: 1730999063-110665-12655-28789-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.59.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhYmpgZAVgZQ0NTCItXIICU5OS
	3N3Dgp1czIwjgxzcLQ0MgkzczILNVAqTYWAEq3/DlBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan23-103.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This change sets up FUSE operations to have headers in args.in_args[0],
even for opcodes without an actual header. We do this to prepare for
cleanly separating payload from headers in the future.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dax.c    | 13 ++++++++-----
 fs/fuse/dev.c    | 24 ++++++++++++++++++++----
 fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
 fs/fuse/fuse_i.h |  7 +++++++
 fs/fuse/xattr.c  |  9 ++++++---
 5 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8da1f7fc5199c1271 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *inode,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
+	struct fuse_zero_in zero_arg;
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..6effef4073da3dad2f6140761eca98147a41d88d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1007,6 +1007,19 @@ static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
 
 	for (i = 0; !err && i < numargs; i++)  {
 		struct fuse_arg *arg = &args[i];
+
+		/* zero headers */
+		if (arg->size == 0) {
+			if (WARN_ON_ONCE(i != 0)) {
+				if (cs->req)
+					pr_err_once(
+						"fuse: zero size header in opcode %d\n",
+						cs->req->in.h.opcode);
+				return -EINVAL;
+			}
+			continue;
+		}
+
 		if (i == numargs - 1 && argpages)
 			err = fuse_copy_pages(cs, arg->size, zeroing);
 		else
@@ -1662,6 +1675,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	size_t args_size = sizeof(*ra);
 	struct fuse_args_pages *ap;
 	struct fuse_args *args;
+	struct fuse_zero_in zero_arg;
 
 	offset = outarg->offset & ~PAGE_MASK;
 	file_size = i_size_read(inode);
@@ -1688,7 +1702,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1715,9 +1729,11 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	args->in_args[0].size = sizeof(zero_arg);
+	args->in_args[0].value = &zero_arg;
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 2b0d4781f39484d50d1fd7f4f673d8b08c5fd7cf..6d67d7f8e6b4460c759df3fb293e169bcc78a897 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -172,12 +172,16 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 			     u64 nodeid, const struct qstr *name,
 			     struct fuse_entry_out *outarg)
 {
+	struct fuse_zero_in zero_arg;
+
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	args->in_args[0].size = sizeof(zero_arg);
+	args->in_args[0].value = &zero_arg;
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -915,16 +919,19 @@ static int fuse_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *entry, const char *link)
 {
+	struct fuse_zero_in zero_arg;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	unsigned len = strlen(link) + 1;
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -975,6 +982,7 @@ static void fuse_entry_unlinked(struct dentry *entry)
 
 static int fuse_unlink(struct inode *dir, struct dentry *entry)
 {
+	struct fuse_zero_in inarg;
 	int err;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
@@ -984,9 +992,11 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	args.in_args[0].size = sizeof(inarg);
+	args.in_args[0].value = &inarg;
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -998,6 +1008,7 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 {
+	struct fuse_zero_in zero_arg;
 	int err;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
@@ -1007,9 +1018,11 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f2391961031374d8d55916c326c6472f0c03aae6..e2d1d90dfdb13b2c3e7de4789501ee45d3bf7794 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -941,6 +941,13 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_in {};
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 5b423fdbb13f8f17c3982e96dd0de836662092b0..2df1efd2e9bdb46571148f484d7927044f31c184 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -158,15 +158,18 @@ int fuse_removexattr(struct inode *inode, const char *name)
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	int err;
+	struct fuse_zero_in zero_arg;
 
 	if (fm->fc->no_removexattr)
 		return -EOPNOTSUPP;
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


