Return-Path: <io-uring+bounces-4540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DA89C0C7D
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02E49284583
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A9C217318;
	Thu,  7 Nov 2024 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="h1MPCi1Q"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752B5216E1B;
	Thu,  7 Nov 2024 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999081; cv=fail; b=lL3dO/V5nnqOKkZf7RlCUi2va76IcVYTPsFvNpg8gIiZI7pCYfo+SA48nRDmlHSLBPRubUe5PkFE1a9fm4stup8F/NCV5GfX+bjuW22OfDhLBeEZGR+yiVNk97z1Q9bs6QCLxTmocN6y9bhi4CPo+c/IVlzUEb+mIeB1gVbWSok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999081; c=relaxed/simple;
	bh=EbjIGepigT5QCMxXGcpYwuBnrc7SObzF0pQ7empHlzU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iNZZ+nz2DnKq3MPFAHGxdwxPy6UfcLxfpsnbzEKn8TxblW6GhLEFXytAe9euOr5N9KUW9f3N3Sn1TuBBDYS3C0bx96KUgR3xxnZ11iIn3EJq0kUTJZhBBC/yPX5XnJeJSacVxJsdS5b4ecLEgCcv6NjdxRKHrpP1EoIjtc9kzE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=h1MPCi1Q; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168]) by mx-outbound20-186.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tAJE9ULU7rzl1W5YEyxd6aNYfVBoCmArLDBiVM7iiEML34+u6OfKDZk5z0ftVvqxGZf3aQGg4Ml1DI7sBpSfIDaoEdODwNllPj3G3yY3fmgzW347OndjWzm+7oKnJ8mSPytAKYJRxBBmH6E/HhBlRnZmeSkQOOaAgd2+DhgmxtHI+/couFWrMmZarVuFeElmv2omrNYbt1Fo3K/cVs/NjeVBHpi5vbpWaWUgLQ7XtIWroeXrK+x1r+3vEwjpLzi3ojuygUIbPYoRxZXRBmG5vYlRZ4/Va9ky439dW1wQ7Br344vijPUTotB28z4ITTBS5Mn94tdB2cNa8ydGmZFvUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivKnwXxuApD7RWUAxskmptPBZzPl9aMB2LmxnzK2RAc=;
 b=mKiHc3LVMCFBIF1jOwmTR6MoktL8Km8M7yKNiQTYqOq3ehv6MyVg0OrimCTuVXTgWgG0A6yGqxZp13Xo9WVB2hinr2KKoVo8ZYEWwo8MUlPJB9Uz4yuFarsOYRK9KzJLLJCPXVYVmZfBvxo1o9JfgZGBxhyhShOMM/rq/irP/7k+LxScPlYEat8Ee0Bng9BdkrvBAcHOIW0atQr8gh80NeB1DvfUXB3rJigHR3tjFFg0V8iCX3VUn1k3sYNE0pyq+xh6va1O29ZNXNN/zdvR/EdY5PgYHOGP0tiwhEakz5+1dv5R883maj2BVQ8gjuedOOziexl3bOxdl+lKjEfLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivKnwXxuApD7RWUAxskmptPBZzPl9aMB2LmxnzK2RAc=;
 b=h1MPCi1QdBsSfmiTEVKQ7ybIO8mAR4lZ6zUKMA9L++DMXAt02AciqycxELBNv/V1JG+sFl0XcI90qYszZVoUKKrf9sxySBqPGijRSudZeTVtIagzhojJjQY2HPXfC9uQrEbjd21NaGa79cag7tUHD0WL3/0g+094Mq39HL9zYgc=
Received: from CH2PR18CA0036.namprd18.prod.outlook.com (2603:10b6:610:55::16)
 by PH0PR19MB5195.namprd19.prod.outlook.com (2603:10b6:510:94::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 17:04:23 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::4b) by CH2PR18CA0036.outlook.office365.com
 (2603:10b6:610:55::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:22 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id EED337D;
	Thu,  7 Nov 2024 17:04:21 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:56 +0100
Subject: [PATCH RFC v5 12/16] fuse: {uring} Allow to queue to the ring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-12-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=8020;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=EbjIGepigT5QCMxXGcpYwuBnrc7SObzF0pQ7empHlzU=;
 b=qkiGAPv3znPA1C1JFZ19v7m0B4pDuQnGOBZpkyT1MlOsOjqWdtIPh/5LWHo3eoW4LsA+NcaQ3
 WBK31lEyBaCDOQ0w92d8FjXkRbAFJzz0PXHlNfFN3d9mEtYrHfkrMMi
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|PH0PR19MB5195:EE_
X-MS-Office365-Filtering-Correlation-Id: 3267725d-0a7f-47b4-d6de-08dcff4e3a2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHJWMmRtZ3BQRXZSc1AzKzUxOWNKMmlKaWp3RVZzZWVjRVNscnBPbHI1eElv?=
 =?utf-8?B?MVBkZjdBMkhxVkg2djBVdHR4ZWNkdUVjZ2xhektUK2pOcHVXZFNUektTdjZU?=
 =?utf-8?B?Vzl3bG85YWVHTG5xeXhyYkVKLzRYclFOWkU5WjVOcmVENWtocXNYU1MvKy90?=
 =?utf-8?B?ekRqdXZxWE4wR0pCemlkd3J5RmJPSy9LWGpKT0I1R3pza3YzNDk3aEFkV0xj?=
 =?utf-8?B?SU9lRVZTa2JhOW8ySk43dEd5Y1kzT0xsZmpIMC9tMFFZSDE3UXBtTFVxMWI3?=
 =?utf-8?B?T0FQdjNNblBsN09jV3ZrL1M2NDBaZ0l1QXJFOUFzYUQ2VnNqZWlSelR5K2p3?=
 =?utf-8?B?N0ZVeTlQQjZxZm1OMC9UVENOT2tnYlVodVRydjlDaEVnTGVnMnQ5YzZ5WENp?=
 =?utf-8?B?dE5oSVNPRU03YmVlVjQrVEt0c0ZjV2pWS1RLNTAxL1pobndCT0ZsQXBOZm55?=
 =?utf-8?B?R3dxaEFBM2p0Q0dSb2xWS0FPVkpFZnFReVp4WGZTR0dPWHVzWlovVlFUcmNG?=
 =?utf-8?B?Nlo0SHNiMkxTVFZseEZOT1BYQTZHRzVaN0dpZUt2bU9zenVjTENBVUt6MDgr?=
 =?utf-8?B?N0FUeDZCY3hGUWYyNUJTaGFMRUZMbi82VE0wSlQyaGFZaGVDSTVkNzhrMjZ4?=
 =?utf-8?B?R0c2em1PNzZzYmlZTlhnTHRiaXNWaStrWkxON1p5SnRRdVZVQm1rbEU3ZVpI?=
 =?utf-8?B?cmJXVzg2emFlNkVHaW95OHRxdlZicWtYRUw0cXJSMkIzN3B5T1kwQkt4bE9l?=
 =?utf-8?B?NEpZZFVWY293UTdFSVZXeVloN2dLSlFxcVVueTRiOVlBM1Q1enM1OEFZSmJH?=
 =?utf-8?B?OUlEcDFQdmhBdE1ha1M0UTJWWWNrWkhCUG9ZQThCUTRxeWNUK1FqVmhJOHpP?=
 =?utf-8?B?Q1QxQUxqalFjWWduNzZkeXJIc2dNNWZzYytJQ081RXZ0VjlRb0JYcTBQbWI4?=
 =?utf-8?B?T2ZuR0VIUWduR2dJWXlhQSt4bXFjaHhha0ZOQm1RVzdyaEcyUUR3RmJaVWZN?=
 =?utf-8?B?SnBlZXhHbGVxV0c1cVBxSEE2SWgzZ3dPMHY2blFTK3QvbDByNmxSaVZDUWo5?=
 =?utf-8?B?MFA4Z1pFYzhjMkpQMjhvK2pLcUdHeGtkcjY1Z2UvUXRxZzNkTjdVcDRxaVpR?=
 =?utf-8?B?RnRvQlhTNGZtOEFFR21PaDUrd3o5Q1Rvd0RiTmtQYnRRcHQ2MXJoNzZLdTZD?=
 =?utf-8?B?TXRTRWZpOTRJNW84TVNZMWRhSmd1b3M4VXBITWV1WkJVV1dSTTBDbTRIak5o?=
 =?utf-8?B?dGNtZ2EwYXFDMXZxVysreFhTWURnMUtCN2JCZHNTQkIvN1l0cEpwejJyR2ts?=
 =?utf-8?B?NU1uY1lrODdIWE9CaU5MTjVaM0EvTmFCdVZuY2lVN3RLeUdaNkpSeGU0QU5v?=
 =?utf-8?B?amVIUTYyRTM4OHZ5TmFBOUZDZlFLQVB6ZDRwdUF4bURNemxidHdvM2xUVHJm?=
 =?utf-8?B?dVgxdlhlOHdna0Jad014anJ6UmpzWTExY2pDTWNRMEZMUmJtUUt1NFBxc3hu?=
 =?utf-8?B?cjBqWGZRNlhTNWRLdCtLV0F2V0VyY1NnQmxJMHZxSm5lWkpVVktNcFNoSUJI?=
 =?utf-8?B?VTRsV0Y0ajBsMU1WN1ExeUhDb3JBZEVsS284UURPSWdmenM2SEVDdGc2aHkr?=
 =?utf-8?B?bkhnSjBpeDRKV2FSa3lXTGZmZzJLZHI5WmhXdE1XNXB4RWdBdURvTHFKVGdt?=
 =?utf-8?B?VElGSml2dDV6SUdNdkJoNndxOEk2a0JSMi9KR3dnc3NNaFhQbkYvcmRQZFBQ?=
 =?utf-8?B?eWhlcTNkbnZZV09DY1ZwVHIyWVNrdk12NUVsR2d5aXRZMXFDa0hUcHU2Ulp6?=
 =?utf-8?B?Rk5RK20wWEtXNEN2VzZpaDFRNVExMFFmQVg5bWNkNStGUXJjMk1ZSGtFRjVE?=
 =?utf-8?B?VzNhSDB6Tm90WVhuQjFxRWlCNWl1Y21JMEZPbk9DbG9vUEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nJoXq4ZxsmOsOI+ar7HkUzuwYZCSaFy7USSB6h0kN1fZWrYnfA2T9TYllhliJ4JWI755qJQj7eh+QP8DgXvRRJAnOenR0LYsqQVqw55xuoSH3I6qJGAniSAD95lYYSII0xOnSfX/3FcZRu++BTO/LNO/9ya2kFExAYEPG0QYFWtk6MwDExjNRRG4JELTWsjiE8z9O1yQ/SEa6H/P6Jrhe6Y7rvhMidg2mzzy3+AV3iYD7bz0em5/7LI43S+ZOJS6o3caoOLyfkMT1e4eLUbuPhxt5gCu4aBb8KenT8qRHQy9pYyO4IA/CPuYDZAZm59wZuPMXoTQl0M2On2IPHCNtiy5CgymwEJeWPCQQta7oUFrMVKJf9az+IS3b+vsPhaGmxnRu6dC4Bzrt48jqr6nJDRz/2/DMwirnaZlVoQHbY3WlwuRXR4yaCPloFP4TuA5zKu5Rr4gl8VjV3okfaQM9oVCvvPdrYZXZ3tg0JZphs23XU/90eqJRdBIlv312bnnkBmDL2tnAq3LayoCNM5v3j/rk4l0MiEnQTsxkYQqerzi/oc5rvCg3/2tDhhAA0xpmnYJxol8dBnMK5HNogiUxoRWw9q4KFZzv+eCK7WBkfq/XAmAXV4SPxqUi7xtWmj9txPK/ixv6zdmalQaXc1SAA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:22.7107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3267725d-0a7f-47b4-d6de-08dcff4e3a2f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5195
X-BESS-ID: 1730999071-105306-8318-4413-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.73.168
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVubmJuZAVgZQ0Ng4MdnCwtzANN
	Us2cLSwiLVxDwlKdUsNTUxKc3MxChJqTYWANzn7Q9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan18-80.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This enables enqueuing requests through fuse uring queues.

For initial simplicity requests are always allocated the normal way
then added to ring queues lists and only then copied to ring queue
entries. Later on the allocation and adding the requests to a list
can be avoided, by directly using a ring entry. This introduces
some code complexity and is therefore not done for now.

FIXME: Needs update with new function pointers in fuse-next.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 70 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/fuse/dev_uring.c   | 33 ++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h | 14 +++++++++++
 3 files changed, 110 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index d0321619c3bdcb2ee592b9f83dbee192a3ff734a..c31bccc667dfafbbb09ef04ababd401558a9c321 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -211,13 +211,23 @@ const struct fuse_iqueue_ops fuse_dev_fiq_ops = {
 };
 EXPORT_SYMBOL_GPL(fuse_dev_fiq_ops);
 
-static void queue_request_and_unlock(struct fuse_iqueue *fiq,
+static void queue_request_and_unlock(struct fuse_conn *fc,
 				     struct fuse_req *req)
 __releases(fiq->lock)
 {
+	struct fuse_iqueue *fiq = &fc->iq;
+
 	req->in.h.len = sizeof(struct fuse_in_header) +
 		fuse_len_args(req->args->in_numargs,
 			      (struct fuse_arg *) req->args->in_args);
+
+	if (fuse_uring_ready(fc)) {
+		/* this lock is not needed at all for ring req handling */
+		spin_unlock(&fiq->lock);
+		fuse_uring_queue_fuse_req(fc, req);
+		return;
+	}
+
 	list_add_tail(&req->list, &fiq->pending);
 	fiq->ops->wake_pending_and_unlock(fiq);
 }
@@ -254,7 +264,7 @@ static void flush_bg_queue(struct fuse_conn *fc)
 		fc->active_background++;
 		spin_lock(&fiq->lock);
 		req->in.h.unique = fuse_get_unique(fiq);
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req);
 	}
 }
 
@@ -398,7 +408,8 @@ static void request_wait_answer(struct fuse_req *req)
 
 static void __fuse_request_send(struct fuse_req *req)
 {
-	struct fuse_iqueue *fiq = &req->fm->fc->iq;
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
 	spin_lock(&fiq->lock);
@@ -410,7 +421,7 @@ static void __fuse_request_send(struct fuse_req *req)
 		/* acquire extra reference, since request is still needed
 		   after fuse_request_end() */
 		__fuse_get_request(req);
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req);
 
 		request_wait_answer(req);
 		/* Pairs with smp_wmb() in fuse_request_end() */
@@ -480,6 +491,10 @@ ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 	if (args->force) {
 		atomic_inc(&fc->num_waiting);
 		req = fuse_request_alloc(fm, GFP_KERNEL | __GFP_NOFAIL);
+		if (unlikely(!req)) {
+			ret = -ENOTCONN;
+			goto err;
+		}
 
 		if (!args->nocreds)
 			fuse_force_creds(req);
@@ -507,16 +522,55 @@ ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 	}
 	fuse_put_request(req);
 
+err:
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+	int err;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	err = fuse_uring_queue_fuse_req(fc, req);
+	if (!err) {
+		/* XXX remove and lets the users of that use per queue values -
+		 * avoid the shared spin lock...
+		 * Is this needed at all?
+		 */
+		spin_lock(&fc->bg_lock);
+		fc->num_background++;
+		fc->active_background++;
+
+
+		/* XXX block when per ring queues get occupied */
+		if (fc->num_background == fc->max_background)
+			fc->blocked = 1;
+		spin_unlock(&fc->bg_lock);
+	}
+
+	return err ? false : true;
+}
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
 	bool queued = false;
 
 	WARN_ON(!test_bit(FR_BACKGROUND, &req->flags));
+
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+
 	if (!test_bit(FR_WAITING, &req->flags)) {
 		__set_bit(FR_WAITING, &req->flags);
 		atomic_inc(&fc->num_waiting);
@@ -569,7 +623,8 @@ static int fuse_simple_notify_reply(struct fuse_mount *fm,
 				    struct fuse_args *args, u64 unique)
 {
 	struct fuse_req *req;
-	struct fuse_iqueue *fiq = &fm->fc->iq;
+	struct fuse_conn *fc = fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 	int err = 0;
 
 	req = fuse_get_req(fm, false);
@@ -583,7 +638,7 @@ static int fuse_simple_notify_reply(struct fuse_mount *fm,
 
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req);
 	} else {
 		err = -ENODEV;
 		spin_unlock(&fiq->lock);
@@ -2199,6 +2254,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->bg_lock);
 
 		fuse_set_initialized(fc);
+
 		list_for_each_entry(fud, &fc->devices, entry) {
 			struct fuse_pqueue *fpq = &fud->pq;
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 84f5c330bac296c65ff676d454065963082fa116..5cd80988ee592679d9791a6528805f7dc8d58709 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -817,6 +817,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	return 0;
 }
 
+static bool is_ring_ready(struct fuse_ring *ring, int current_qid)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+	bool ready = true;
+
+	for (qid = 0; qid < ring->nr_queues && ready; qid++) {
+		if (current_qid == qid)
+			continue;
+
+		queue = ring->queues[qid];
+		if (!queue) {
+			ready = false;
+			break;
+		}
+
+		spin_lock(&queue->lock);
+		if (list_empty(&queue->ent_avail_queue))
+			ready = false;
+		spin_unlock(&queue->lock);
+	}
+
+	return ready;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -825,11 +850,19 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 			      unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
 
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ring_ent, queue);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready)
+			WRITE_ONCE(ring->ready, true);
+	}
 }
 
 /*
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index c442e53cefe5fea998a04bb060861569bece0459..7951a8a96702190beba0596212c90b60da659aca 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -117,6 +117,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 void fuse_uring_destruct(struct fuse_conn *fc);
@@ -132,6 +134,8 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 	if (ring == NULL)
 		return;
 
+	WRITE_ONCE(ring->ready, false);
+
 	if (atomic_read(&ring->queue_refs) > 0) {
 		fuse_uring_abort_end_requests(ring);
 		fuse_uring_stop_queues(ring);
@@ -147,6 +151,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -167,6 +176,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return false;
+}
+
 static inline int
 fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
 {

-- 
2.43.0


