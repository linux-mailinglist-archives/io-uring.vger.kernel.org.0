Return-Path: <io-uring+bounces-3007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C40AB967729
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 17:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E1F5B212BB
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9D2156F33;
	Sun,  1 Sep 2024 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="kTzLJIMX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91793CF7E
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725203355; cv=fail; b=G9vC37Moe5/8puHra/8k+p5NSXS6m2AkWgd+jp10kYxCVYqX8UjjHUlg1av5VaHCA1ywhzH4ClGd8ToAoVwhCdhtthxHOFxdpGz4OHxBuScoZ4pvNpjDjTN627Tzc4krZGYXIkNjtdrWlYCOyUBkpienU3N/0PRASFwVt8kXeL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725203355; c=relaxed/simple;
	bh=8dhkqhFwHO1uc2gQUMpZEDKo8OQGVPegTAACyzpk3Xc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eIr5gkxF1pvT87WLyBcCWATJTF81lSajCIzlGQh3HFDsSCC22m4hYzB7rAiVH5zpqRqV1IhFMqX6jLHm3m4xID40DPToCOuxFweETp68PHUhLsvTWevLU3Y7yILrFccMdXoufvvZbWxLQRnIFXYh4c7iR4XygnRFmE7Te8uiKdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=kTzLJIMX; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45]) by mx-outbound46-229.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 15:09:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ef7oE2nGH4RBI1GtaRyKm+1FXEiW6xBt70BkkCqRK4XQpBnHEQ9YYX0maH7tEVQr4CALgztmHbwly03fH+lqWMt0d+kGObaN6GaWNZAImNcDb3h1cMa89IgYcHyrOdAXwEFr8N6202ryAWHmLw+0R+Gk1PP59Ntra2jrqnfpk75t/4IqhYSjN94FqD4r4xOaGYjyhLTca2gqyFdM6MgoU5vIptDfkhYxn3/FDVJ6KKc8yeWIo3FFXChZrxFcuJyIMgSQ6LVTmTBFZcJLPcgN09N21MAsWCvIGTDQ2oy5HXnsdzRxHJ6Ym7OlGWwMh/+qUT2z3FmpUW71wzssfeaZuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgMtCDsoXOyo/QPcdUDSpQJhzlP9ifRQC1shbPtI6Bo=;
 b=J9N33ICax4UZ7MEG7UZK5Qz1P28/fUeZT7waDv4mbON1p67qzgeqjIKiG2p54YKRVyRnrhdDFHTv59TNSPCpkk1Cxjk8sm6tS/PUuff+QGCf66JYccMXJokMROkTPQi+ShH/nvxduRu0oYXvfa8+BxIbQJDguYYJ/hcjjbEm+EaQamAMRIr+cZJIpntjULlDqr798qra6MHJdeGpcWQGe61ReHfl8iLV+tTR9hWfNTH8yfpibtU2uqyasmwlKg0iThXx6s73+nQOkVqu5I5XwFAS9sbMT9LhvH+QSIL4MJYCSNaivKu9aaYJRWw3IofBw7Yq/4GpK+ZRsFxk7RJtfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgMtCDsoXOyo/QPcdUDSpQJhzlP9ifRQC1shbPtI6Bo=;
 b=kTzLJIMXC2rUOq7z5gV9BecSC7g2iI64/yBWn0z7hCfsJ9iZDe7Zy6Cd5PKnH6RG5mXYCDmm9BdwPy/4WHqfaVrzqrsSCbs+Z1PNCZF34PRsmFccj7em6Hw1aMpU2fmejUcFydFWsm9xy0KpMpaV2xjXjyBG8KZosgkw+42nEA8=
Received: from BN8PR15CA0043.namprd15.prod.outlook.com (2603:10b6:408:80::20)
 by BLAPR19MB4244.namprd19.prod.outlook.com (2603:10b6:208:276::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Sun, 1 Sep
 2024 13:37:14 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:408:80:cafe::63) by BN8PR15CA0043.outlook.office365.com
 (2603:10b6:408:80::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:14 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 34174D0;
	Sun,  1 Sep 2024 13:37:13 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:10 +0200
Subject: [PATCH RFC v3 16/17] fuse: {uring} Handle IO_URING_F_TASK_DEAD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-16-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=1048;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=8dhkqhFwHO1uc2gQUMpZEDKo8OQGVPegTAACyzpk3Xc=;
 b=eyrkXfca8xjIyuTMNoR2ImJakYrTiEZVmR0snVkBZJcHwDUfU1JDpD2sC4dEjPAEgSZ/5S0Pb
 iDnX/5kB43NByHkzoRjZ6kLrYvMtLCQwKg3/0KJcddn7FU24ID0uw8m
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|BLAPR19MB4244:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8d3189-d8ef-49ab-b5e9-08dcca8b3086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2gzZ2N2SWNJdzJ2UTJ1bWJ1emJDcThWQ21BeURWZEtUTDdJdDZrSU9SK041?=
 =?utf-8?B?WGVTZUZOMVZXdWxnV05mWk9tVkFYYjFKRmZ2eWRSL2ZkNytha1RnOHpraEYr?=
 =?utf-8?B?cFF3ZG1Ed2tRNWxRNEhmd3FmRkFuWjJaTEdQTTZORWtqb0FaZm1OM1ZLa1ZR?=
 =?utf-8?B?MTVQTjE2QWNsak1SWUFFeVN0VFMvV1dzWnZrQnlSTC9nMGVFak1EOU9HTlB2?=
 =?utf-8?B?aEdQazBJSlQrRmhjOGRnS2dQbkJET0dMRUlGUE9yWUZQbWF6MmhCbFJwWEJL?=
 =?utf-8?B?eU51YVF5MTBtMURNcmtISG1oRUdRZThneWJ3UVBCYUI5a3Boc3NJM0ttSmJB?=
 =?utf-8?B?OUw1QXg2QUY2RytweW1iZVdWay9icGhsOTVIblljaS9tM3ZmTEpsNnlubHRi?=
 =?utf-8?B?bGpiOW1vdG5HZ0tMcG5RamdoVjVTK1lMWUh5dFZGeXF1NVJxNVUvOGNlWGxt?=
 =?utf-8?B?UjVQbkFPQjZiZlppNHl5VHhBeUc0amdWVm5GODdUWTdrZFFMdnNscStiUkIw?=
 =?utf-8?B?SUJjNy9ndzhuRzNiSUV6VXdQYU5TcDJPNWxoU1Q0OEE0OS85YW00OGMvQVI1?=
 =?utf-8?B?NXVReWYxNVdsOE9zTFBSeGgvbkJ2L1FlbEdzcGdZQnhGUmgwY3lFaXNHSWdW?=
 =?utf-8?B?T2hpTmtXclNHaUNjdlVxM0QyejZCUEl4ZjBjdG1NOFFJSUlETjhtR28xOEtT?=
 =?utf-8?B?SS9YdkQvQVJ0SzRuQ1A4NjVHYS9ta3U4dFBoOVkyYkxHUWlZM0ZqV2U3a0tQ?=
 =?utf-8?B?UVozV2JPNE14aVRBR2hFNk5hNjc3cTlqVmx1bytDSWtIVmFFcjhsVDNHb3Nu?=
 =?utf-8?B?VWpITGYzMUQvM3lyMCtvZUhyT0pGeVlWVGdsbklQK1lFZUNDT0lyQWtKZGVJ?=
 =?utf-8?B?K25maU5XMUkrNEppVlhJMVlSQitTVk44TEhITmhJVjQ0bmlBWFowUkphQlh2?=
 =?utf-8?B?WFRMS0tKdXFJZ3BVeklMRW9QcjE1SzlxZGc2ZDcrM2lLakJkNHVRVnRqS1h1?=
 =?utf-8?B?UUZWZ0RXdFhTVjY2aG1yRzdZVnZ5R08weVZyNmJlc3NCdW1vOEZ2QmZZWnBJ?=
 =?utf-8?B?WVNUMHFaTVNjSG94MkFGL0YvUG5vNjVISnJYQVZmWjdwa1FTbDFVdHN2aWJV?=
 =?utf-8?B?VkF6dkZEM0tTZ1Rzb3NhSGhxTWRlMUJ2WTdINWIyTlZ0WklBeWpaMGFjL0ZR?=
 =?utf-8?B?MDlLY25reWRlSzIwWVRVQ0pESU5RYU5OT00zRFJhVURZVGNhKzRpanRGbm42?=
 =?utf-8?B?OUlXbjdqTEJQZUkwYitnNmFrSk9ZemY0dFN6UWFxZEZEMkdGWHFnbWhaTWJU?=
 =?utf-8?B?dCtGaGhZYTFYditUOHhJNUdSVUQyRzdPd2IvakE1Y1UrR245d3poK3c2U3Er?=
 =?utf-8?B?NGppYWhGRlY5N2Vud0pXQ0dBelZYbFNMNE5iSDNIZm9ocHZCOXFkL1JSaDVB?=
 =?utf-8?B?OWNSd2ZURW45S2ZYYkoydXVBMWh0QlcrdDJtN3JTcllSMEk4S2pMUjhnZ0pL?=
 =?utf-8?B?YVRLdlZoM0VRUnlYblVpeTJac1l2b0YzRGhXeUpGVDEyd0ZNOE92T0E0YzNI?=
 =?utf-8?B?VytITWJ2WlRwdVZSc1NIVmdVRVI2cS9SZ0lSd1h1azhzVjg5clNRM3RYR0Fv?=
 =?utf-8?B?YTA0aFl1dmF1cTU4SjF5dDVFVnFtYzUyMDh2MWVvbEhvN3VzTU9sNGsyUDE0?=
 =?utf-8?B?WmIvT1NvQTdrV0ZjSyt5NjdZNEtLcjBrWVcyNTlGcFh6RTFrUG9jclArUlc1?=
 =?utf-8?B?SFozZkJyUGFTNzlTL3p0NmdMNVpxNCsyNTVZY1MxRmlVR3JGSkhlYTFzQlQz?=
 =?utf-8?B?UnhZSG4rdUltaSs2eHVlVkZSZDNVS1g5ekxjSjVaTUZRZWF4YjF5YVNjT0Jx?=
 =?utf-8?B?S2ZnNkJReWozZnNaUUNIamlTcTRQTE5sOXE4dUpQOHM2Ymp0VHU5a3VPNXND?=
 =?utf-8?Q?+At5B4LuiaLyfBMwXVgTE2OvrWsH0L78?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kcYNadwZd6OcT7bg24HnbP2JQK/SXrf51IW34HuOZGwn4IBeoUgrLj5O5CQSiLfzV48JrsjgwKxJ4vsLPcIyh9i50w1hkaQJ+17JpnFBXpI5OVsD14pwFksnYtDXOqjfU2e8QqUjngmXF5XViFovWqlEO1xRM5T6MFCKzwaWZTDOPydP9HlOp37SFoY0xSoAwCLIyWsu4YOBAtvu8qyMCk7H5GLmPHjnlp3wRQKYlRjlkLyJzIJkdjK/2obOdqhMkUeMoQzkzQBlzGce7YjY9/5icbzSVG6iYp8lTtdt3/U5WnVgkSussznC5jW8i4CDF88V4JKk8Uel7W8RtIobyUulnmKYPmuY692VyVAzQG3fJYvzHSofSjojGgrV9/pzrHgbc3FTfM7Kw5s2UTfXxuS5uv0dxJKUy+1XpAf2JsM1kxSb+JVCUx/Muo08t2c6Qzf9Y3MR4dUJmi8Khaaj81dDCARhqSC5fMsm2H3h2IDy4cd1DPqJRtrylNwwKyZJyP95yW0WbH9/NGnJrn8BqB+zEGS1tjnNuE0AE98PQMlBq2mNJohCNwvdvevZ211gS7Rnbvrxg2Eoa3lRAZJggxB59GNq+BuLFKVeBlpHPoZ9O0Qxd2XLCG7RZKF+g2AhPsLUFWGw6xcD0Opb8nBF+g==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:14.1761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8d3189-d8ef-49ab-b5e9-08dcca8b3086
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR19MB4244
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725203351-112005-12689-916-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.55.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGhsZAVgZQMC3RMNHYyDwp1d
	gyydjYNNUkLdE41dIs2SjJ0jTFyMRMqTYWABcshV9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258745 [from 
	cloudscan12-95.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

The ring task is terminating, it not safe to still access
its resources. Also no need for further actions.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 43e7486d9f93..a65c5d08fce1 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -993,6 +993,9 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
 
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD))
+		goto terminating;
+
 	err = fuse_uring_prepare_send(ring_ent);
 	if (err)
 		goto err;
@@ -1007,6 +1010,10 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 	return;
 err:
 	fuse_uring_next_fuse_req(ring_ent, queue);
+
+terminating:
+	/* Avoid all actions as the task that issues the ring is terminating */
+	io_uring_cmd_done(cmd, -ECANCELED, 0, issue_flags);
 }
 
 /* queue a fuse request and send it if a ring entry is available */

-- 
2.43.0


