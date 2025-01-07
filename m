Return-Path: <io-uring+bounces-5699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CD2A033EE
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EA23163A8C
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 00:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED923595F;
	Tue,  7 Jan 2025 00:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="iB7fMF/S"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30341F94D;
	Tue,  7 Jan 2025 00:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736209535; cv=fail; b=suLpsJDzgj46KkUl5MwcLRMBBZbUCf/Ii8SseXHFHNbP2x7G3PrliEvwVYKQhBuPrOBODo9KbjnfLFb4WVVpimwEgov6NRvz8UhvR49jLjESsK9icCFw7o4fr/z1U3BR1YSx/iZxE64zMI8/gZfqKo53KhcJZ8+hpC8L44cjvho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736209535; c=relaxed/simple;
	bh=XaOAR0F2EgLfvpkxN5z224zB/8pEgoSlzo5zWOXVVjk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rSaih0moZPxvwQlPAB3nKIGJuOa8Adiu34ZViddbcrLr9mDcq3OkKBNXOuL6RHYU6ZcVQ0SLVRnJhlIEsXNPMr2qio+PWZ+1jseghKS95iVCX6APj6SeCnyW3BKBXRZEvjZeQ8NswAVuUcJ+QPK/9vXySYslmDZ0hLJOUtcjlHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=iB7fMF/S; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170]) by mx-outbound47-153.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 00:25:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLc7v4ZpajeFYe8RrwD685fMNbfhTfWlRhGii0wZBIHcH+nY2OsSG3Yuf+6HUh3fmzn82xhe7Uo9lch9QhkRqeh3P4IcBDkP/ZAdx8Amv3q4iUE9uoY5f3n7dDCTbZP0+PXnWM0vZWswke9J/pQVO0dOrsrQ4A3hdEEMKu+CvZecHoDJZzdeZjxA4XMzdsq1rJEbsGRZvJXM71t6m27efxZRKMzwB75KeExtMulif2QFC881VAiC5y14Q7y+uetqyGd3tkNRmz2G1BQhpFZY9iGA+fnkgkhZwLeBCdqwD0nYhXfg81VK2weC9GAJ3UXgDtQb/FhY+78K3hAoXqDmpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlSVBDFakK5n6WKcIUNkf7zDr/gts/fhzdsUjhAC3Ls=;
 b=XTG21X5c9Hn7hfXf6YWtbaLgu6eJTxvRj7dfwRrC80z3DEVC7fER5wPyk73JKdZEV3Zu9TvJykt5j8RW5fVHs3zHg2Tt4KKX4nyfW3B1FK2G3OZghRN5nqZl8C8SXutpWvQ6sRyRnoYux6nC+lDouaN5c+yu3/BiYfex/Tvi4VjU2o9pluKYTM6z1hA14gpIfcRQBko+EMfmvYyGLYd09/C3NCMl0XNRl92soEYcD758RLFHDYFT1tk0mr+zpAHOadIGaB64fUO2qf3H6P3sfdW0fbiXxhQcp7TC5PkZIXLqilRKf8BHkWYEoq/S7KpiAkp1NeNOGoJiqLHW2wYtSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlSVBDFakK5n6WKcIUNkf7zDr/gts/fhzdsUjhAC3Ls=;
 b=iB7fMF/SOXhVrau8as6GhCTySNz6bXN57NfX1n7E0Y43/QHdXjNTCA/B3MvxruDOLKT3fNiHZkAoynBnG8/qi9CC0CDIVmqWIJrauFj6UWACcqHMCPDMbrB3PIRgUcOlWTO6xnFpZiPCvaBCSi73ZzX5qIvWbsBMdIZVWBwGmoY=
Received: from BN1PR10CA0008.namprd10.prod.outlook.com (2603:10b6:408:e0::13)
 by SA1PR19MB4927.namprd19.prod.outlook.com (2603:10b6:806:1aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:20 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:e0:cafe::f6) by BN1PR10CA0008.outlook.office365.com
 (2603:10b6:408:e0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Tue,
 7 Jan 2025 00:25:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:19 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 22DEF1DA;
	Tue,  7 Jan 2025 00:25:19 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:13 +0100
Subject: [PATCH v9 08/17] fuse: Add fuse-io-uring handling into fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-8-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=1729;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=XaOAR0F2EgLfvpkxN5z224zB/8pEgoSlzo5zWOXVVjk=;
 b=UlEHVwUWysx1p4xIuHTTzm4dHhAgj2/P0DpMXdXtxX4KaWNtwIOpB2PmZhtKDJr7+940qYrkW
 i2RoCz6+u78BxcQLysVbAyE+Gcr463/Y8PL5FhILLHtNBY79sthKulc
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|SA1PR19MB4927:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e9b36f-aae6-4bc5-188f-08dd2eb1c4bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHRNOEJqZkxqY1h1QWxndEJGQlNkK3J2Zk1mSWpKU21PaFM4bDEzRFk3UnE3?=
 =?utf-8?B?VGhxcE00a05PUVAxbk1LMlA5YWVNc1hlUTdKNTVCb296Z1lwSkhwMkU4dVNt?=
 =?utf-8?B?c2syV25hcStINVRtalYrOTd2cWxrL0htbWxjM0E4WlI1VU4yeUN0aXJNeWRW?=
 =?utf-8?B?Vi9CRzVFSmZlQUN2NzIxK0F5cG8vWjJGM1lIYXVqcThMOWJ4U1hqblphblRF?=
 =?utf-8?B?NnMrMFBmWk5lTStXL3I1dG1RNnMxckN6U3AzUHJPYkNjdzYxZlllQmlYcTk4?=
 =?utf-8?B?WVQ5dDR0RXZQMVpSVDBvdFlTZ0lQbVhHYlIyelRlUExvNzJaTXBYelc5VlFK?=
 =?utf-8?B?aGw5UWJwVlRDWHRIcDJrNUxWOHNpaWx4S2VOTHlrOENSWCtBOVlvTXpVSHcy?=
 =?utf-8?B?L1RXMnZVYTFWTFdaS1pNSThNWTF4cDQ1VVpUSVM2RHErTlJ0WUhzUFFRVkpO?=
 =?utf-8?B?cEZOM1J4WVM1UHpPZi9OSWthTU1XdXJnNnVMTGRKcm85K3Fjem5nbGN3R2N3?=
 =?utf-8?B?TVI4ZDFTd2pzTENDS0U4MENsdSs4S2JWM2hvNHEzL1EweFRGc29wY3BjWkk0?=
 =?utf-8?B?ZC9uUE1Gb0QzbDRWS2pLUm83K25rR3FRamIvcE51K0VEWTJzQy9SUEtBYkov?=
 =?utf-8?B?eEdtaEE2R3hVeVFUQVlnYnVnbTNtenQyTWZLR0g2cjJ2U1d1ZWozbkJYOVlG?=
 =?utf-8?B?angxaXh4ZGdnUEpQT1E3YjlrOWFxSG5HOHRpYzIxNjkvUy90QzhzVkJGNHR4?=
 =?utf-8?B?OEVSb01jc0xpV2Y1cHNZdzIzeXo4TURvQWd4b3JMaHBrdC9vb1ZPUm9aYTZJ?=
 =?utf-8?B?UGttdWFkNE9iVmRwRklNakNCNHJWWU51ZGh2a2ppbEMxcmNwbVpyVDhHdzhC?=
 =?utf-8?B?dGhVbFFER1ZGUmhtVXo1aHpXSmFqK3BlaEQwSXRoeGs5RXJCTndnUkNXVldv?=
 =?utf-8?B?dXN0cjdWa1RIckZIQk10TThmT0psYXlSb1BNNVJiV2JtZ3pzMTN6NllJT0lx?=
 =?utf-8?B?TWxJcnpmYzh2Q1laTXQya1pjNjFVclFMZ2NFT1dBcDNsRnMwUUswbndSZlZK?=
 =?utf-8?B?ZndlTnVzelZNdnplTnVneFZZQ2krcEJ5V0VQaUtlbVpJelo3eGNpNmE4M2Fj?=
 =?utf-8?B?VzkyODlYK0QvbURwUGtCaDlsM1FQWkxBMHk4SFFGRWVRK1lwbkJiN2dnSXNx?=
 =?utf-8?B?ZWdUM0Z1a2FiaFQ3RGxqdDZDdjc3ajBocGJ2RWY4RUJQemI1MTdzc0hiTHpZ?=
 =?utf-8?B?Q2dYSm9KdnowbWRZRlVYM2phbEF5SDhHejFOVlcvL2FEOTY3R3BwTzd5amRs?=
 =?utf-8?B?eWdmTytVbnNQZWxiTW9UQUEvVDBtQ0VSeXBnTU9tRXBwY3lmMHBOTWwxV3hl?=
 =?utf-8?B?d09VWFJBbHE3L3d6L2k1MkNERlJXMHVsNlAzendtKy8vTGFCN25wRm43eDZq?=
 =?utf-8?B?YUR6bFZDeWorT0tjUUUrUDE0VXJlNjBEenNIODBteWVxSUlFYnJ4S2hqQnhk?=
 =?utf-8?B?U0RsbXVZZTBOa2dUc29renJTaDRUK3hML1BEVVVxSEEzY1Q3WGp3aGZJTTE3?=
 =?utf-8?B?SU03bWl0OTkxejdYM3ZlanVEaFYxQStGZmczd05YUzBPeTBjNklJTkRtZHdr?=
 =?utf-8?B?V0V2NjU5dHZWdXB0aVpiM3AvU0d2WjJlYkRXenEvdmZhSzJXZ3MxOGtpVEhL?=
 =?utf-8?B?VFF4ZW9nSERzVFNJQVAxd2NKa2V2MVhQRlhubmx0ZU9YNm8yN0NZWjh5QjAw?=
 =?utf-8?B?bk9RRXhkS1AvM01FREF2VWVXcnVWdnJTcHlBdTRzRlVQVnlRTzJoNXIrMUZV?=
 =?utf-8?B?ZGZCdlBuNFZjbDZBMnZyZWV3cnJ5Q2dHSktnamJLQXh3YWQzNW5TNk1zNTND?=
 =?utf-8?B?ZlBGOG9uQ2RPZFJlMUQ1TkZPTmdLTHplSTdEdS85UkF6YUN5MkZYamJTbWwx?=
 =?utf-8?B?WFZHZE5rN2IxQXIrTWFBSHFrZlRkQndVMGh5RVJHQjFkcmIyb0VUWEd3WHkw?=
 =?utf-8?Q?jqCDyA1DEjPvLzG9KAI8clPXI00JOQ=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kIA8qPMYhJBHF31zJzMmb8W+wQfz9fd5YhDcUCoQRRyp83FW69zcaItBypm0JcoEsW+Im+HXDLZgKz0Wo2ZZ7WTRINxycLpxiudnLpakzY8996Wr2irTa/8aZ3xpNtKilm7QYekeR8nNbx/Pk1G+zEWl9LasDuWO2zPR/ds7z2IDuCslSwNco5svrsuji818ih7p+x0asy4xVbMFlcjLZxvEBl4ZVNJ3t6INvwGtpsr81/HZ4FhoSFmk+tQ60U49s8bNAdtiEr0SeG2GkA+mZdrtrd+H2SyDDqQlrsu0jl5clII1IYkxJVqrloQKGhvNWjPad5U1kCSrsqD5oRSPRtuhKto8eHHT1/NDUeje2fDtWcreHgQ59TeVTGZVYPWuyKorqZtWUnFG9pl7JyFBg7Q4uSNKxLCL9Nxxz8TUdJI64zZ4GLkP8JNsOrkjKmYWtURs4YHSLJqG8ZatNfr1YkF+GyOvwTN1fW3Bo+ZQn6qCogPQ7jBb2beyeIK98I4rfXMXRUfBOccVlzKSHa+CmxkHmzsjr57ISMca4lHlKyDNdkQ4S1SCT8fm9+McwjdKA0c7MQgqUqmOYzD/W6HsXjNlbUgMHPZdTAeICk+tOGRWaUfrf3uPdFKRR0/jq+5k+OIfIPM7GbPWT6pBtz/4AA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:19.9132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e9b36f-aae6-4bc5-188f-08dd2eb1c4bb
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB4927
X-BESS-ID: 1736209526-112185-13543-25353-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.56.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZm5sZAVgZQ0Nzc0MIgzdIkyc
	DAIsU4LSXVwMTY1DI1ydDE2NAozdBIqTYWAJ8J/ORBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261635 [from 
	cloudscan15-3.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Add special fuse-io-uring into the fuse argument
copy handler.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 12 +++++++++++-
 fs/fuse/fuse_dev_i.h |  4 ++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6ee7e28a84c80a3e7c8dc933986c0388371ff6cd..8b03a540e151daa1f62986aa79030e9e7a456059 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -786,6 +786,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.copied_sz += ncpy;
+
 	return ncpy;
 }
 
@@ -1922,7 +1925,14 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned nbytes)
 {
-	unsigned reqsize = sizeof(struct fuse_out_header);
+
+	unsigned int reqsize = 0;
+
+	/*
+	 * Uring has all headers separated from args - args is payload only
+	 */
+	if (!cs->is_uring)
+		reqsize = sizeof(struct fuse_out_header);
 
 	reqsize += fuse_len_args(args->out_numargs, args->out_args);
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 21eb1bdb492d04f0a406d25bb8d300b34244dce2..4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -27,6 +27,10 @@ struct fuse_copy_state {
 	unsigned int len;
 	unsigned int offset;
 	unsigned int move_pages:1;
+	unsigned int is_uring:1;
+	struct {
+		unsigned int copied_sz; /* copied size into the user buffer */
+	} ring;
 };
 
 static inline struct fuse_dev *fuse_get_dev(struct file *file)

-- 
2.43.0


