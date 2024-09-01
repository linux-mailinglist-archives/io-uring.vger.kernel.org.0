Return-Path: <io-uring+bounces-2994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E92AC9676A8
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BED71F21389
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584A817F505;
	Sun,  1 Sep 2024 13:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1PKpnwST"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4470B143C6C;
	Sun,  1 Sep 2024 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197840; cv=fail; b=sMvjtN5+145gOUITIpODfcjORkhgYvaxqMBf/tPTV9V9b2trLaDXmB1dl/JYVEMDioHwpihRHV3P4FRTT7hEUt6BXnuIC3wGT/Ps+dMyj+T9d0yOXapVgjHt19DEZfIzFwxthBSnnKtLNyaXZwFQzad02Z1fARkqEd6DKawbYJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197840; c=relaxed/simple;
	bh=XKaocKew3lcYQPHAH8W6P7pyorB0iIVLO/jnXgQCYQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MutYQlycVidzOzbxek2t7GDmMub/yb88K7+KaNOZGlO33m8tSjJk67oNva8rmKuruMPIeyY4gcj5lQoqKOPe9a8b4XWvIrbHDkg/28YLfvU4OYcQSDo7EdM3ZkWmMqZLwAldBJ5SRMyGD0CYi8r9CDh3TnsaZHKgA18DhVR4rIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1PKpnwST; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kCX7ByqWB03kmPevpLTmKdt4rlqVTBwDxd2uG1/j1msje/o0zHDCb55stZ6e1xkjonE32SdCtqRV8xfAQSPRUc+VD4AmgaPtUNBDc7j/A9CS0uKWFhpeRJ5iAEHLOaI/lhkNS2uKd5+BivyYhaM+gjcrQ6M4lTfSLWk5/3POu1v3eQKTmN9OwvhoqdcScACgU2KTRH+pZs/uLtngLmWnbO0avp+rquUFyNoB2CizMeX/DilYETEGLImIaTnbEUBvRnIpZvBJMWHUuz0CUe3YGcF6mPiCSYQpn6p/9VPr7TWWuZON6/07A8RgGpZtaRtLQ3Ae4yNeJ4iorzUw/+HDEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmPiQBUvsMtW8+yplJP+3lFYxN3/0veiUZKKkafplYA=;
 b=WB5ic5qsSDeQNBQuRFUxI5ZZCeepoid4KfJNKFuBi9nQVGx/NcSJuLAp8EDT0BWgcD502R5pEEjx8fRGSavUSsBa7xD1BDdzWNzQb0yjQYHXQvptQvtOz2+OAV0wcgo9QG5d2FpAkYsRyNaxyghrWwUszooOMKZa3z/ExUZduEhJcVfPBM3tyGnC1bh1YnGpFmGBifZo8fjT8n//+mSSOavPZHQC2ekvNWNGLoQWElrrFGmqenyTj6+u4DRrAXJaO3mi7AMgtRIhB7Itr45vfnVk9ePmxfP6ogd4pr3mRshkW+W88aE4xK3XFDamy1g3/CcDsCtsRcVjns+VILEeiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmPiQBUvsMtW8+yplJP+3lFYxN3/0veiUZKKkafplYA=;
 b=1PKpnwSTKvWSo2HDflVE4NkD2y/pXp/PbWIOZhJENhCs4rpXlct6pbp3BQDhUOmxZ5Gb1VQxuOWNQIBcMWcXILF5UkeLGjE90NRGda6YXLe3ZIhrZxpilD3+X9RzuOzNzG4/AyAp6KeQDaBeiyhOZ1hpWXxb6B6Fx4lytPnan4E=
Received: from PH0PR07CA0014.namprd07.prod.outlook.com (2603:10b6:510:5::19)
 by PH7PR19MB7310.namprd19.prod.outlook.com (2603:10b6:510:272::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:08 +0000
Received: from CO1PEPF000075F3.namprd03.prod.outlook.com
 (2603:10b6:510:5:cafe::13) by PH0PR07CA0014.outlook.office365.com
 (2603:10b6:510:5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.21 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000075F3.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:08 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 68A5BD0;
	Sun,  1 Sep 2024 13:37:06 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:03 +0200
Subject: [PATCH RFC v3 09/17] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-9-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=3552;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=XKaocKew3lcYQPHAH8W6P7pyorB0iIVLO/jnXgQCYQo=;
 b=rJl1Jo9v7DfM8AkAuAI3AOmnpMN13ARZGgJIYcM9k0d50f8IQJ8tOZnIGS2TAahVN60wNtus1
 Sv1qZ0i8/CJAdwoPMHI+wQge2iJFG3TJWDT+d5uHKMUKvJB6x+gnJgb
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F3:EE_|PH7PR19MB7310:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3696a3-b853-4aa8-3478-08dcca8b2ce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnpNZSsyZDZOZVlOQnh6QlpJSXNHR1NlWE5sTVFrMFprdzNaU0R5Szg0WGZl?=
 =?utf-8?B?dUhnVis4M0lWWTNBSzBPUHIvTG80Snk1WG1IdDR4dGU3RWhaMnFLaDFlMFhY?=
 =?utf-8?B?M1hsYmw0UkRoTkZIalZLWlVFSCtnTDVVQ0JQTjhaK0VKK3hNSFZwalhPYk90?=
 =?utf-8?B?VFUwaDhid21lbFdGbFJPZWZvcW5XOTlhY3BDTGJ2blVKenZaaTlNMDV6a2xk?=
 =?utf-8?B?U3NLZnNML3p3WG50SURtV0RWcXRIMWJLdVFRN05UcjNxaWRncG1sbTAyMWE0?=
 =?utf-8?B?ZU9oZDJYcC8xOTk4bjZ6LzJOYjVIQmlHbU5xbHQ2azR6c21VRkJ5SEdDc3Zz?=
 =?utf-8?B?dW11UTc2VGtLcWR3ak8xTGpSMVhBNld3SnR0aGQ5UVZZY0hteldxRWMwVlRl?=
 =?utf-8?B?T0RvcUd5U0xEVzc0L0wwSE8xeTZhOWJhT2ZVYzVFNGV3ekFESU81MU5FbG1r?=
 =?utf-8?B?eGZydW0yaENvL0x3Z1pWQVpRNDlxcitDaGc0VTRKcWxUZkxDQUZ0eDVmbnBI?=
 =?utf-8?B?bTl1NnV6dHdaSGgwRGNmNG9MWWZUU2pDZzZ3cmhKYnVZMXZVeHlsWFZkK21r?=
 =?utf-8?B?cjJwVDJoUlkvZXV5V3NhZkdiT3lWVHcrVC8yU294aWc5VmZ6dVljMzRoRVIv?=
 =?utf-8?B?TXlKU0tZM2dKaXRmQ3RNbzVuSkJRV29yMWpKN2tLaWE4WkNmQXhSRjlZdldu?=
 =?utf-8?B?TE9IbDBvVFo0Q3U2MkNackMzdVY0c04wejZpaVBjQnB2dHo1Rk5TMDZ0Sk9a?=
 =?utf-8?B?aFA1c2pMNGtmWDhmQUIxTHBvRVRDbDRCdHU3RklYUm9jOThuR3BxVVJpUE1T?=
 =?utf-8?B?cXg3bjRVS05TempFelVqNEcvalJ1eW5Eam82RjlldzhqbUhXdU5JVUt5bXhH?=
 =?utf-8?B?eCtNUThoY21kQXlYZjhRQmloTVFNV1FlWWJKN0VQYWV1YkJScGZscUQyZlRV?=
 =?utf-8?B?bmI4amVJNmJjVmFoZHRpK2E1dy9tNHJOYlZPbTVTcXFXdXQvUGZOVHYwSnRD?=
 =?utf-8?B?WVl4YklsK2dtSnl4eXc5a2M1amZza0Qyb1hhSkk5YUEzc2N2Y3FrMjJ2NTdn?=
 =?utf-8?B?bjhxb2ZNL1JTNVpHeWNCMTdoS0xQVGE2MVdXQ3BGYlJaaks4Y2puTW5BNHNZ?=
 =?utf-8?B?VTVpL2R1NlBQVDg2aktydkJ4bFQrNEtPai8zL290NjFlbnoreGFadHljRTN0?=
 =?utf-8?B?cm43UnB5RTg0TTlIbjVjOVNpWEEzUk1TRUlPV3M2WXIyNU1vaVU2TUc4NXJR?=
 =?utf-8?B?SkJrOEZrMVliSnZwbzN4L0YzSUtFaVJqOGFRc1BQYkwzSDRFWnZTaHo3OWpF?=
 =?utf-8?B?OW1GeSsvNDdvKzVmdEgxQXRlaFBsdE9MMXJ0UmNQN09HQUJ5SHpLT0t3Wkc0?=
 =?utf-8?B?dTM4Z2w2VFI0SXhhWWJhaDd1NU5pTVVDcytzM2ZNTEFta3pGbFJUQ0Z4dTJS?=
 =?utf-8?B?czRNYW14TjRjZnNFQnZqZ1FGS3FtU3laK0xlb2JCdG5Ld2JvaVZKWHJvcWhs?=
 =?utf-8?B?TlFoY1V0NEhGbWE2NkRDbFlWaGF6ZkNTZjdYZ0d6QWQ5Z2F1R0Z4ME9BYUpR?=
 =?utf-8?B?MEZzYUxkY1lmZWU4WkxHa3NXUzhCUklsaTlhbUdQTTNLVkRxODdmYTB0NWZh?=
 =?utf-8?B?QlBrZ0VpT3ZUVjFqSWtlSUJoeFpPZVVxOGhqVVVUeG1MMEh0SUtwNXB6eE5R?=
 =?utf-8?B?MW1JUHhOeWx6QXJIcFF4MHU2RGVmZEJjcWxIaGYzemlSU1ZxT2xHL0Q1dldT?=
 =?utf-8?B?RHAvTW9tVmdYT0dNd055cUhqV2RWZDZWeFUxWFFQc0JBQTNnOFEva3lHWjk4?=
 =?utf-8?B?SUxzTXE1WEt5NWJuWDVObGtTcjNkQUc1R2hsTVBZb0MxT0lEcHdUaEdyekht?=
 =?utf-8?B?Z05pcFpzbXQwL1NCNzZrSjFDbmtlMTlDTGFwZUZHbjlpTDkrZUFtdE13QmdY?=
 =?utf-8?Q?MpQjZ6iq3tmjllcSMa4WF3sK1jcuco8T?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	euwJ9ved8mXt9VcAImGHr9Uq+PtIUndxMvtC3k4xdV6sBBTAFsNO3XP+kMXefAGdPcpOJZA2J+PuHdkdZOGlFc22ALRLnqm2INtSx5+xZT6DZ0zMJ8AoTOUpTIHPFxvxvroYJRJlRFMtesm5D0KoUscUBYj+ivGfsR8Af36s+EJqrxYcIoY4dslX15ZQ2691pni3NonU7RRHBB/4AmiXT8ee0cLWGBKy2rVuWDMwfIgLZVtQTwMROuVUlREGWbA1YtFijL12Ye4/nGbQc6M49I5VK/9Orfj4IjfwI29w/FW0K9ANT6CBeQAQJlcpmWOlulCSKELTxYEznVAvzm/lsaoOc74EbBtOtisrZQ48c/bt4ckrnhnynkbiZ1OrL8IjsHAdqRxTPg9+6g2S8C5CvHk6MOBaqjbY+7fb3CfCNSt8CSamIYfU+TP52ZqZhCf5Guam/i7btQqbgiBgRnW/IuySymHKI/Nh0NoaY8pH1odZZYGe6NXeEpWnln0RFtLojuOlVPrDhjgRGLn3l9ASKfzjyh7j8nHssNZW9MQ8kJQ+H+aiWqVq+TF/xdHt7opPduzYNr+Qw+dwM5TQK9m6xVOaq4O14akxrwWaXgMFxYfYouog7fsI9xmVXdzWJZjy9MLSAdoX1pP8ZIFhJY8e9A==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:08.0714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3696a3-b853-4aa8-3478-08dcca8b2ce3
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7310
X-BESS-ID: 1725197831-104050-6777-5849-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.58.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsYmxqZAVgZQ0NLQNMkoLSUl2T
	TV2MgkMS0pyTTJ1DTN3MLEItE0OclUqTYWAJClDLtBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan23-79.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE_7582B         META: Custom Rule 7582B 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE_7582B, BSF_BESS_OUTBOUND
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
index 998027825481..9e012c902df2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -637,22 +637,8 @@ static int unlock_request(struct fuse_req *req)
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
@@ -1006,9 +992,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
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
@@ -1874,8 +1860,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -1977,7 +1963,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e6289bafb788..0fc7a0ff7b1c 100644
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


