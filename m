Return-Path: <io-uring+bounces-5067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFEA9DA8AC
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF33C281AE4
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D046C1FCFD0;
	Wed, 27 Nov 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="gfhZNxce"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26891FCD18;
	Wed, 27 Nov 2024 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714861; cv=fail; b=b76qz5SrK4TwaRynqa5IwD5trx5VjmdI/6H5BGl5T241IBFGUyR/kYONcQKKOJ1T6mP6VPee4YHAsKBWwAlob6kK/DxjGThqCWLBVAjssaAC5p15yISlacPaxA+cEdEfaIBuAWsedsQjgUmpq7hbITJeR8aF7vAaGOD7q2K9WZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714861; c=relaxed/simple;
	bh=szaN+y2fLmTNfOBhEI2vFya7Z4dRZQ4sSBKyIgYSltM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kTwl4ulrmfttI5yxRMdK84uf43D9dgfW3+9vgpixk4DRt9GqtC9WrrZz72Y8hhlHTEg9U9PU5kfKc8mUgj++xT7gkGa/Slm4oN6MagtHC178Hb0aCrPYX2QN/K0jOZqLKe31TW4BGGpMXYanQWiUGjmZzoZAcN2BN9DYxt4LZlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=gfhZNxce; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174]) by mx-outbound9-173.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AJs82i0wiYt3GAI8iMN6Xo0OVA2NAWYVqAvnEqn6jClDrknA1+KC3dxfczA3ju5T2X2lVaAPcZXhEgtwj6jse31tWxqp3i3e/GjA5Yg5Z+WOnYJtSCONNKcFDLk7KgFD3vh3Qyj5U8FkhBtvUCWi7QfSrxoinSpJRq2rx0lKodwx0wMGpgiD9hw9GHRXw1TShY9HCqd827dr6IXZd9dq8JeLdpp79znVs8fWFolqsgvB9ALTXbN+dWdRAW52HOtzQYaKjgSSMXjo9BwVI2LIpdkKSzotjw+7xTtmuYM6Znc7DCaAPa4WtNjQe5f/vuHYXH5TWnwSM1xFswxM6/XUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3DvuxZt7uWbRE9rJ9xj17h4w0W6zV9i/nhMklV+GAU=;
 b=RtI3mZpfn3m84K3vMgrNOee2TdsZ8decEno9MNqQJeeRXoyCWZXDjlJNzbJbCPlu9+SR1L689RDFq3EQvtRnvHaAwHWTcfTQA498kjw5Db/soE53juoZqUfLOTTOqTjL4wUf+XlUR4vEu4E9ZURh+QWegojpJ/v7QCQ4aUkwQlSS3OeX/WfWMAnAsQewaH4rhd2IAMaLTattjq9LfGEsxJlWfE42ZpZtj6x8eIA5w/DOoUs325uH+FJza29EdB3XwRmeWvynJgAoCCpiY4h3ZPCzfNf2IqCnC/DdAeSgZiwollos9kneVNurFP/YsVPl8bTTlbsqQkcpJseSbII2lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3DvuxZt7uWbRE9rJ9xj17h4w0W6zV9i/nhMklV+GAU=;
 b=gfhZNxce6jYBeCiPbGO021sFK+z0wrQ12KmAfPdMLHgQcKN8nnAXHiRoUQaC9JZHz1Faj+n6wjhXOaL5bpANCSRBNdpfPmmkX5v0RHv0BDGpGydjvPZnZjzqWo7CgshFkZIkMKpTscvDbswlPoNMHASKL1ERjyk+anQGJp7KU08=
Received: from BN9PR03CA0325.namprd03.prod.outlook.com (2603:10b6:408:112::30)
 by DM4PR19MB6121.namprd19.prod.outlook.com (2603:10b6:8:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Wed, 27 Nov
 2024 13:40:42 +0000
Received: from BL6PEPF00022575.namprd02.prod.outlook.com
 (2603:10b6:408:112:cafe::51) by BN9PR03CA0325.outlook.office365.com
 (2603:10b6:408:112::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF00022575.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:42 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 4BB3E55;
	Wed, 27 Nov 2024 13:40:41 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:19 +0100
Subject: [PATCH RFC v7 02/16] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-2-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=1579;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=szaN+y2fLmTNfOBhEI2vFya7Z4dRZQ4sSBKyIgYSltM=;
 b=PH/3Ae/a/hCwO53XsFHSET/EYOfdAJFI6Z0gwScCIySeLk0jzuGe0JNcim9aKcrPZ2usxONBT
 fmsHedvEECQBO4H8dEQCc6fDDxRmpa8erg3Y5p591QcyXmHzDUy7YKE
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022575:EE_|DM4PR19MB6121:EE_
X-MS-Office365-Filtering-Correlation-Id: 2efd1cb0-4088-4081-1286-08dd0ee91684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGpMb3NJa0d0V2RnY0ZyOFRIbEF3UklCd1ozbEc1M0pDZ1p6WkZ4aTdxTW9r?=
 =?utf-8?B?RDZ6TWlYeUl2STBzNlJoekEzN0tDOHg0VTVzYkM0bVh0ZXpGeTlhaDBtclBv?=
 =?utf-8?B?WENxNDErbU9SUjlzRUtsVDVKZVpvVWc3ZVNudlJVd3BVRVhpK1k1Qys3WHpJ?=
 =?utf-8?B?Ym1EWkNnSnd4ZzhDRG9oMGc0WWZWM1BZbisyZkhKRE5TSWRFMmNTY0tLSzJm?=
 =?utf-8?B?L3lGNHptdUdadGpRblF1MEtPZ0F4Qm5tOFo3K3c1YmVGcDNRSm4za1RXa0Rn?=
 =?utf-8?B?U3hFTDE0aVg2MUQybmVHMXplWUhDTmlyVjNrV1NTMEpBOUVwa0dRblBqVU1J?=
 =?utf-8?B?UjgrODY4VjU0amRJRHcwRUdkcGlpckJWOHVFbkl6aU5iWjBOWCtjUjFScWlt?=
 =?utf-8?B?ZFRRTEJiNU9oZGIycVVvczBGTEI2ZmJDbVo2eE40Z2ZJVXFDOFpnL1JmbmdP?=
 =?utf-8?B?aHVmNzRNU2x3WFoydmxvK0ZXbHdnT0lKSUxmdSt4L2JMV09OTTdwOUducVpR?=
 =?utf-8?B?ZnhPWE91eUhLb0liSlE3YkxoOFVNcWt6RVpSazgxU1QwRlZZWnVMQjd5aE5G?=
 =?utf-8?B?OXNiNkZlS1QvY3o4ZDdyekVVTE5zWmFQUUJzNEVtTVdqellLdkd1Y2lGOXUy?=
 =?utf-8?B?UmV6bml5MGJLemIrNFErWkNGQ2xIKzM5Q0luekY1MmNSV3lIQzh3Y0hHRDRR?=
 =?utf-8?B?UDYxcFRFa0piTk9ZZjc2ajZ0cC9oUlpaSlhGQXh0dXZBakNGeXE4cTBLZmFk?=
 =?utf-8?B?cHFtcHNIdU0xUzlXbDdDdFhaekZ1bGhFYWd3aTJkVHdZNTNyRllFMjFSc2NG?=
 =?utf-8?B?dU8wcHB1eHNoK3N2bnBRbnBOb3pxdjJ5RHNPMjRxVTlXbk4zdWpBeXM5VDl6?=
 =?utf-8?B?eEdoUXVZa3g3ZjFCR09rZWk2L1lOVnc0NWZQQ2lEQmxLSHFRUlhaQksvV0Fl?=
 =?utf-8?B?QW95Q2NkOVNCNW43S3RJME1hTU8zbVFNUFpTUzQxeDlWNE9zaDdQZEMvaytG?=
 =?utf-8?B?bGM3c3kzQmhMdGRucFB6UEZwYVd5TDdQZ05uM2o2OWN5ckJGMHdOSVZzRlhq?=
 =?utf-8?B?bXh6cFVuSGJ1RFNZL3Y5Tk5qaDhWTjFLUnZXRGVjWGVMS2EyRDBjVFpoM3dm?=
 =?utf-8?B?UEdMNEcwdFpocUhPVSsyNFhtbnMreVcxMnVPd0MwS1Y3d0tWTStGWmtUT2Fs?=
 =?utf-8?B?TXdnZ29ZQlhpMFJOM1ZHQUtXUEhXQUtaVW53dXVmcDUwU1dReVNLK3ltWFBY?=
 =?utf-8?B?anpEYkdjeHI2OXpCTC9yNWtDcEpTRGpDQzFEQ2kwOW45cndCMkdyU3ZWYnlq?=
 =?utf-8?B?Ujl3Y3NuWis2Z2lES0Nwb1o4dkp5b0tQVUVYblJLTklnQzNpc1VjRDAzRFBL?=
 =?utf-8?B?ZStWdllhOGVRM0xIdFdXUDZZTlBmOTFSRDI0S0tqT0lWSG9ORE9JalA2bDVk?=
 =?utf-8?B?VlhxTXFPaXN1YzhXZDQrbTlFSXZMcmovbkpjVmRIeXcyYmVTVmVwVGRnN1BG?=
 =?utf-8?B?QXV4QjdBTmRVQnh3aGdBL0Y4WHhJeWlmS2syT0sxREtpVnVzZG54NWVmWXQ1?=
 =?utf-8?B?WThXUWNtcVpSTTVYZmRPU2hkcFE5ZG9nT3FvRTA5YldlR2ZkM0R2ZlBYTmZE?=
 =?utf-8?B?RUdsMTlRd0NPVytGejMzaXhIbWR2bkF2aEpZbDUzcjNHUGY3ZUZ4VVRQbkJQ?=
 =?utf-8?B?ZkJYNEVHVEc5c3FmMUpHSnhWUVZoVmNHMVNicDEvMVRaM1dtWkxyNDJqUTAw?=
 =?utf-8?B?MmJuczIvbHE1K0liWXhHMkxPQmhZclBFSEtGNitIbGdBMk9GeFlkam5FcGpK?=
 =?utf-8?B?QmMxWm93RVF4TTNnRHNPSlBkUXhsaVNPbzdRdkxnZk01Nm51REdzUFNHVHpB?=
 =?utf-8?B?MmFTVGhsNjNFK0ZvenFoam1XK3YxcUs0TnhWM1loRFkyWTJISVpzSFpqREQ0?=
 =?utf-8?Q?rzMD73vLdpQkmN3JVAC+JkgfMlP85T7O?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pqZbPPBmI1x3P8oYTWHJn4+z6wQlq5mQTEHGDcgXnGUQpvdEJoju+Fw+haYrz2AoeOYzAdqFm98qW8CLysyY46IeA0xRqpojfqongfzlcrfpLqTRzyJwXWow6SOYROiHRizOIOAq9LwCKY0EyoG5O2oCvKd/3tnLS1kjDRzCr0vvsNpvzElvSilbRVwxcPLv9juvgYNSScbD7pXfuR2bWfjb6Zwpv+WuoUt0DUNPvbgNy9o5BDnFqMLE8/FF2XRqZCA8Yco496RRhX7JhN5wmh4XgdTBKcv5fqagTkaa3D0lyogbwa/M6wuBQ5jE0VBLRPILAOHpIl/Oz8j7P0bEwHpEfXrkjHXfHAeEgct6jEj1hFJUVjAFWXQ3YTP4KVcW5hCCms0vQHUr4l4gP2iPr2lQ05XAq3KMy+CbB5SGc+2yzq+D+Ri5KtP9ZDQeJHt8a7CQHmPKGButSmumpAMiSTazzRf9RZsvr+/2qCjXKW+gpS+sreAwByGMswth0OYhCHiL23fP8YG7sbNJnSgiPZpQ1FxP35pEMux8Izp329Tu0rMI/zhmDFejs0lsbiEy293pdQmy0vsMhrYr7J2mGjMkmj+SNkOXukoqtLzQXsaQ2ZsrNzluO8svf5G3Lgfw5UpalDAUcBxTWrzJho1nxw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:42.2839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2efd1cb0-4088-4081-1286-08dd0ee91684
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022575.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB6121
X-BESS-ID: 1732714846-102477-13344-4638-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.57.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamRuZAVgZQ0DzVLNHQ1DzV3M
	LA0iIp1TTFKNkkOTU1Oc0o0SA12ShRqTYWAH3DWvNBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan23-134.us-east-2b.ess.aws.cudaops.com]
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
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 09b73044a9b6748767d2479dda0a09a97b8b4c0f..649513b55906d2aef99f79a942c2c63113796b5a 100644
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


