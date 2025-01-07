Return-Path: <io-uring+bounces-5700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6370A033F4
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D0EA1884DD0
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 00:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758181BC5C;
	Tue,  7 Jan 2025 00:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="XmJF+6jI"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA3C208D0;
	Tue,  7 Jan 2025 00:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736209537; cv=fail; b=gD02Ib9xwJy5rth5c/lP0F26my8R6FPnQLyssGOoIAGuMor0FystXo/3Zmw80obb3eIHkaOTHrEvf6hvurXDVap2Uu+cpmIMRha/PdHtkK5b6zuMGsMnSOa86HVtt+DYpJQI96V3TCY8o4qgvGiwtZYwWh6Xtdf3CI4X4JkWKR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736209537; c=relaxed/simple;
	bh=Ya1E+Ku/QRkwCEaIbyaS0TPDqDs2gP54NDs4ZV63gYQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gexK33vulGg7eR7/Js211e5PxuQHqNRvi4LDZuzYI4Xb5RRuM5OT0+Va5pe1/7YJzi29CULUpuXgTs5LNGAkN20pjH6eSBIKHpCgobZ7QZFGBWN0khRD0K7PJJ1OIQvYVpmvazonDxtkvhVTJhWe6V2xRA0zdP+0GoRDTmuO8ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=XmJF+6jI; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175]) by mx-outbound47-153.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 00:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hF43LKbcUKxQN3AsjfTlKsGD3952dOrB0xiZLg1VPoS6n2otY/b06KTTsSCngJ2ri6VNSNJnDS16QNJKJvW8nRVu65z5ginczwdL8WwFY3bAg+CDVEXU3mh7mArDB2LXAqdqJwuwjXSASOu/ehlr817uwruaIT9LSeY1poqZNWwTsYIC3PcAGPkz96gvw8htO3J3/oruMzKPmVfKnpFU1JXW3hexvqqJixpLQ1aYQae1hzQ+fDKxGfuUEKx5w8UP3Rb11ifzpgCQSMMPXB1B6ha4o2Ax1PSAZ7inW2H4B2pzglV8m8wTiVsEgF8pBacYGXs65h0ZNXy1AKpkFWpHeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6RfwqruhsUJ24uvHOhy9dXWf83Pkk0jDujN/3YHBFg=;
 b=raF7Ayppe1VGvh1D6Th8pz8s2mf854a04wnBXoJdus2GRRaNtASpEwGxOGA4Cuf8v0WrhvLX29WgYYofzSvvZr9lk9Rg9kkjU6zuk51ocOrITpcbVHrmTsgKnVgq9sK9GsKIPC8QoGjS4kgrWHsr2nSwE7c4AZUb/wO3HJ8vuq3jhAaVlvAjtbxnuZFQ+YQYvpYDQGreX3VO2a2s14uqxij5ugqfk/wqE89TwM8/n+PfPlG++qCuI/4c9wBz11pbf2bFSwI/22tm9UMA+2pUCDfHdkDoggUqre7mtODjPjEjbfnfWToexMK+taQTWaD0kQU8XxuJcfDRhUDH0m2Ocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6RfwqruhsUJ24uvHOhy9dXWf83Pkk0jDujN/3YHBFg=;
 b=XmJF+6jIxGuULICNLDMJGxRRIyiMcxK3iJIYOzfgoZBnhPVSwRJMDEJcxTbepsHzw2Fw5I0o9EqGFTBG52zxLHn5b5xjc7EQN2ohpJiHIjZTofMY6uIkSbLxM0eChoZFW++bVz2yIHIUO6g9K1KkGzENkGDh3vpvMakoS926MTw=
Received: from CH2PR17CA0001.namprd17.prod.outlook.com (2603:10b6:610:53::11)
 by PH8PR19MB7782.namprd19.prod.outlook.com (2603:10b6:510:23a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:21 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::d6) by CH2PR17CA0001.outlook.office365.com
 (2603:10b6:610:53::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:20 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 1B6F44D;
	Tue,  7 Jan 2025 00:25:19 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:14 +0100
Subject: [PATCH v9 09/17] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-9-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=3448;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Ya1E+Ku/QRkwCEaIbyaS0TPDqDs2gP54NDs4ZV63gYQ=;
 b=BjDYJjaZ9JsrfKqh0x07R+WHqUT6iISdsNpjfJvCiyFWXc0XuBDt1xeW+IDzmkmBYvTJBhiS/
 G9TtwXdyDXPAdTC2Iio+N6VC5mQEm7EM6qQoZQj/hwwI4CYHtBXHKuD
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|PH8PR19MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: fa32dd1d-7b48-4b0c-7b5b-08dd2eb1c51a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnIvQUVNOVJJYzVGS0R1TDZGYlF4RnQ4T0Q3NnBPeUpJOUxOTVpJNXpzVW5y?=
 =?utf-8?B?SGNndElYdisxV281RjMyMytaSHpWY2F1TEJaMk1rMHVsWjlRNWtUdWNKNEhL?=
 =?utf-8?B?eGRlV1ljWDJhMTdCTzRJUWlkd2J5bGo2amIyZ2xrOTk4M0xOc2pqUEpNQ1dF?=
 =?utf-8?B?MmNMakZoNkJURUJvWjk1ZjU5cDY2RmRHVjU0Uzk4WG5GeVpJK05jOFh5dVRv?=
 =?utf-8?B?TnRKL2hPY1NIUnNYZVRXOUVRL2FCNUtVcmR0d1dMTjAzNFE4N3F5QkxaZVcr?=
 =?utf-8?B?YWx0eENHanIyd25YSnNmT3l5Rno2WE40M0h2NU1oUHFzZlA4UlI3dGY5YnNn?=
 =?utf-8?B?a21XMGdIVFNZZFo2cnNKNDVMM3Qzd2tOb3lnTExvalo2TGNCTkxxcG1BR29T?=
 =?utf-8?B?anU4MExoQWpuaGNMekxQZE1vWmlzS0ZqOGdXZDEvZEtZRFA4UUV1aXJCZlkr?=
 =?utf-8?B?aEMzV2lLR1R5NXh5dW5QSkVuLzlLZ0ZMRzVnM2dmQVJiZFl1MVB0YnRobzJp?=
 =?utf-8?B?Z1hqa01kb0RPUDYrQWhoNyt5QnJOenZmSktLOUhHSkNzVU15VzdqSEIwVm11?=
 =?utf-8?B?RFF1WHp0UEVwNERYb1dYRXA0dmpGQi9xTEF2SlJiNEpvN1d6K203M1NnRXkr?=
 =?utf-8?B?aENkQnFNM3lHdnlKcm1kdC83akZtQ2pReTBwNld6bUtvYmdPeXJuVGpTaEEr?=
 =?utf-8?B?OXZwOTBYT3JlaGY5Nmh4emJDb0w2VXJSMDhwM1E2VGxVYXZidFQ2OExYeVkx?=
 =?utf-8?B?bGxrc3E5QjlEWUxnak40TDAzV3FDRlZ5OStZSWM4ek9Kc0YxM0RoSWVpbXhS?=
 =?utf-8?B?ZmxaQnBBQXdEUzJ4ZnQyekswZU1tY3FHRlQxWkhqeEhXVERKSFBoeFhZd1dq?=
 =?utf-8?B?Z2pzWUEwbWl2VEpTRk1MalB0OFdZS0lLOW0xTFEwcmpTL205anZpZk1RQWli?=
 =?utf-8?B?MDVLZXZQN3RNSkM5NVFmOGNFb0huamFINFh5U1kzZzNMUitjVnE2a1gydDQ4?=
 =?utf-8?B?MGo4Unc4cjJwZGVPbWZVWHRXVTAxaWowK29hUXRvbC9Nb2lXaUZRVGtmL1Z0?=
 =?utf-8?B?UHFSUUFHeUdjd2thRkd3Z2lnWmFBc3czcUVVVlBET25xMXhGK2Fwdk9WVi9k?=
 =?utf-8?B?U0FjamswSWV1QkFKdjM5ck52UEhrK2tiRndrc3VJY2pNeVVNeHZIU0w4b0I4?=
 =?utf-8?B?ODF4b0hXVTI2bVAzZVBDY3oxUmlFbVBrT1NQWVUxSFJYOVkxWGczdDdxWVVk?=
 =?utf-8?B?WFBVYVJkb1RZYXpGQjVzbklKckhScDgvMTQ3TE1YTktEaytNMG10c3Q1NW5H?=
 =?utf-8?B?cnlNNVpWZTBldnp6TlR0VU95aFZGS0owRXBjZHNYaDhyNjlBeWxQVnZZb2JP?=
 =?utf-8?B?Y2ZvZCtTaGozS0tkdyttZEs0cEFTMFRabkZPYjMwdVVDOHhZR0lLcjhWR3Vz?=
 =?utf-8?B?TDVSSnNPWGVwTE1VdTlrWUJqS1d0eVR3UEZoOVlaT0VBdmhMRHlkQU1oMysy?=
 =?utf-8?B?emc0NXZveXdPcldUTmZDWjV6NmI3UE5BcG9EdEZOZzBMaEhGa3ZGZnhZZjZC?=
 =?utf-8?B?TEl0QXJDYUxPbWFmSEdrZDY2NWdpaDI3SUF4dkl5MG9CVE5obDdQd2poL0RZ?=
 =?utf-8?B?K2d0K1ZKVWZBbmhYcTI2dTVJSUdjcEt4M2t1TVBodTRrY0VxL2hSdTNTUGlN?=
 =?utf-8?B?RzdVT0pIa3hiMnZqcDU5dkd4Wk5hT3gyanF2S2xCQjRQeFBSNHliYlE3VDdo?=
 =?utf-8?B?L3paczlobDJrQUlFeGtYeWt1V1hvL1M3bnNYNGgyRHFBd2FXWHZVZ05pVktq?=
 =?utf-8?B?MnJMZi8wQ0dBYW54REZjMnF0QXNuVE5QS3lNaGpUSGRaSUh3SFFaY2duWWht?=
 =?utf-8?B?VFl2Ly84aExrWVJVUGpmWjlKRTdEbE96TDRzdEcyYlQwdnAyWTA3OUJYckJ6?=
 =?utf-8?B?YkFkOWsrM2dsd1ZzSkpEMmcxMzVSSS80K091Z2EwSVlJN0pzMGxiWTREMmlE?=
 =?utf-8?Q?98ErNGSG3KiDC6Vxu7bG3ZrYw6gEHw=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yxZ1wME/xdFWAbb1/cEyMVHtTf0vRAVvrprtJKF91d5MIoRPIABN4y3ZYZNR+/OVBC7hVqzRbjoWDeEIgk7heZRokyQh+Hl7EtvV2moRCgUWwSGHshfg7eJj3r4FkClHQyO/8Vqsr/LMjXsOvTwINj17jqcg6hnGiiMjS+eDTz2VCh1oFoeBEMWHVKbfBGSVV4D+CfkUFkCssHXxQJot5R9FAE5/YGosHVWgpxSlaJLDZ/8Sg3OGDqLblVhH8TtozJJzlgfvyh+7Uv7YID7zfhThraTT60EcBrw1XuYqui4CEdP8AnfdispY8nCxYAmvME27URrNIX/h6s3H2XkTaBAeW8d6jQrEDNnceCyLid8mmU1IRWMmWdwqsXQ0PKrwvyALWhjT2E6AM6bzyACFliC4rZn1vVvZbdtHcRLGwCH2yi8eo/yTAkxX45y7rf1Ws0LJEtLGgF9QjcQpJkHJYI3d1xi5vpu98FHOCpDv9K/rBaq9clZ/UE7d3/Mqhg9NFsXz1E3Im4sjy/K7/l5qbwb0r8cT6GRI9BZLlyq3WGiLBtX35xHGIOTKIsFPr660+RhyIv+xTWj/9ekQYxMLydO3Snu9lPJrFCRZaJcipysHgwWv64/+NfEVmW3Cu+Pwj2V4t4DH/Et/dTyM9eqsHA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:20.6477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa32dd1d-7b48-4b0c-7b5b-08dd2eb1c51a
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB7782
X-BESS-ID: 1736209527-112185-13553-25355-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.73.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsbGJsZAVgZQ0MAyzSLFwsTIyN
	zEMi3V0CjVzNzSPNHcPNXSwtDczCRVqTYWAL2zPpRBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261635 [from 
	cloudscan10-24.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

fuse-over-io-uring uses existing functions to find requests based
on their unique id - make these functions non-static.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 6 +++---
 fs/fuse/fuse_dev_i.h | 6 ++++++
 fs/fuse/fuse_i.h     | 5 +++++
 fs/fuse/inode.c      | 2 +-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8b03a540e151daa1f62986aa79030e9e7a456059..aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -220,7 +220,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1910,7 +1910,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1994,7 +1994,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615..599a61536f8c85b3631b8584247a917bda92e719 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -7,6 +7,7 @@
 #define _FS_FUSE_DEV_I_H
 
 #include <linux/types.h>
+#include <linux/fs.h>
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
@@ -14,6 +15,8 @@
 
 struct fuse_arg;
 struct fuse_args;
+struct fuse_pqueue;
+struct fuse_req;
 
 struct fuse_copy_state {
 	int write;
@@ -42,6 +45,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d75dd9b59a5c35b76919db760645464f604517f5..e545b0864dd51e82df61cc39bdf65d3d36a418dc 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1237,6 +1237,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
  */
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 
+/**
+ * Initialize the fuse processing queue
+ */
+void fuse_pqueue_init(struct fuse_pqueue *fpq);
+
 /**
  * Initialize fuse_conn
  */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index e4f9bbacfc1bc6f51d5d01b4c47b42cc159ed783..328797b9aac9a816a4ad2c69b6880dc6ef6222b0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -938,7 +938,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


