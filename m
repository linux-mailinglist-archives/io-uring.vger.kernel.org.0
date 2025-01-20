Return-Path: <io-uring+bounces-6006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D34A164E4
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60B6216554F
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB4E8BEC;
	Mon, 20 Jan 2025 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="FFKGaz53"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB35E17C68;
	Mon, 20 Jan 2025 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336570; cv=fail; b=MluuZbOQmoIWzMSadag8e9RhC4/tpwXN8HpswN8OXMTLFoKNjgahTEq7UhrrSJQSvXmzc8RcwwRpRRwWVIHXo1Jh0R4juC9bcmDfTOA6K3p1YUok3OhwHGsCz04ENW4Quvtg9rLWPbggSLMTqD+nXT493G2I6ke+Z4ATnwmgXb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336570; c=relaxed/simple;
	bh=M3GcQWwOaa8BbwZh7SUIGaTx+lkvQ0F1YCuEjX2dKV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CO8PfX+yvBNBV2ItUF2bCw5m2Pl46JflZwecOe36R8dcaDWNrVSNtzb2vcDwAG/i14yP8mJykdwKYAwb8EK7NYdgalJi2FXKtWFOY4+ZnrBFwhIuGcrJ37/zUPPtuF0C38yBKdVFCG7wjH4OtPjX0dJ6SAZz1ZNfImRI/r21pyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=FFKGaz53; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42]) by mx-outbound-ea46-177.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bvxdSwrWbddF9lZriDt7yULaxXaRxSJWa+mjW8kcdE/GBzgkVqFKgaGBDBilQ3fY07HwUTw5JmEVlknWS4oIhuHuO9qZ6/FNi+wwXrUI8s4gWbs3Sxr3aUjVRC7geyMKBGTgqsibdgM0nln/VHIH/80qBC4RpeIGS09C+CvXEXnekneV4GJ+ue3lbTnGJuZWuwhNq3wJ1LJQp/Z76qaxlnM05KPtAcJ0JK3jdAIbE7DH71IZCpW4+WYYDGxWCC3KBo4+ZOA7UBxr+8WccEisri+wdwuQ84Lsuo7rygXCyWvV4qKin/QUJekoT6SH4ecTQLAme0WtX6xjL127LjVqlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHfDcEdVZVOJHvupseE7n5zjDtvZEF9X34YNo8Rsf3U=;
 b=PHFibcW1MdN5f8O++LW0dloYLr+atPnC5GOQaoKrpsbDlgObgeVv8uw69K6aJyH0OUrekdr5nXYHaeGSgOC36O6z9XAEbLdRlk01NCsRqcZl9el6Kpx4sHDwfXFRlHNgcR0L4ptkrmlrn0IfaMjAUE9zJDQcSQmyIncZcZNjs+AZ2quc7cjaYErY9jCDvTJ2cAWeFX0hxVh5FHi0Aihax9z7QazlIBPmzzVXNj7QnXlJasRYt7UUQKN2CJ4vnwwEYO/YBblyzUqZYyPP5Z6nKLMRQEMaeRVdHocafHSxZpgJcUd0N0CFe2f/564PeEEYkutushWRDsRA5hPbYYPHfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHfDcEdVZVOJHvupseE7n5zjDtvZEF9X34YNo8Rsf3U=;
 b=FFKGaz53bfde8I5rkFWK+SkcgLvaLS9iXI56GytIMh9em5CEqL0Jn2VLHCpuCn4C+zVT68KR98G1wrNPuk0q0iR6mabTfVbr8+RvwSX5KzNug3+N19EFr1jaLV8U4uf9brlISiQ85E1caWKelzujsF4ZnEcUjJGbUalurn1MY9k=
Received: from CH0PR03CA0338.namprd03.prod.outlook.com (2603:10b6:610:11a::10)
 by PH8PR19MB7167.namprd19.prod.outlook.com (2603:10b6:510:215::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:04 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::5c) by CH0PR03CA0338.outlook.office365.com
 (2603:10b6:610:11a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8 via
 Frontend Transport; Mon, 20 Jan 2025 01:29:03 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id C9B114D;
	Mon, 20 Jan 2025 01:29:02 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:28:54 +0100
Subject: [PATCH v10 01/17] fuse: rename to fuse_dev_end_requests and make
 non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-1-ca7c5d1007c0@ddn.com>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=2781;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=M3GcQWwOaa8BbwZh7SUIGaTx+lkvQ0F1YCuEjX2dKV0=;
 b=FRL4YYzsraxMHAFWeKKqcHvRdbRVTPTkKM3xK6nAsHMkO83hTd5WzKF98qMiJI45youDKJWem
 v+Y9xvLIWYkA4Go7YFYTvpjhbv8yYzz2GFY8wkUhrz1ET9nK9Gg/eD0
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|PH8PR19MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 238af49f-e6f4-4ffc-5f9f-08dd38f1d2ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2l1b0ZHVWR6NWlZc3NYTVQ3UUlFZ2tLQ1o4ckxQeVYraEVNRFJxNjNCeVVF?=
 =?utf-8?B?ejNCZ3I2NDdRUE85MURUaFVWdTRTK21VSy9JelErOTNXWm42QW84TXR2UWtJ?=
 =?utf-8?B?MEJNYmdsaVA2RjFkUXQ4UlZmN254Ni9XTkxBYlpOM1BrUUZkR2pUbURldnJv?=
 =?utf-8?B?b2xveEFURHhBZktzQ0kzMHNqRmtEbWZPdG5HMzVLYStCRnhoaXd5cjlubGp3?=
 =?utf-8?B?ZlpSYVhUTk1jYlNwVWhGeWo5d3dudzVsalFheDQ2U0tLU3BEZTFwSklGVyt4?=
 =?utf-8?B?RGFxYWRkd04ycHFCYzJSeDBHNFRYYXZnak1sa1hZRDJrMDRNWSs5ZWorVm5l?=
 =?utf-8?B?MFpxcVEyWHBsRTllVnlHbXpUbEJVT0paNVBZZDMyNk9KVUFjcVU5dXdrSkk1?=
 =?utf-8?B?c0pnQkJCVis0UDBCK1psQlFKQzdTLzBTMEpnYy9YTzhxN3AvdVR2cEQrakt4?=
 =?utf-8?B?NVVuR2tzTnNzMStWcXRkdU5FZlB3VDYrS05BcGtQSytDN3NNUy9LWlJ2RGlY?=
 =?utf-8?B?akRJdld3WVNVYlRIclVGeGd5bmJEeW5HMFJidFlsbDlzRk8vYWNCdEkvdnF4?=
 =?utf-8?B?S1BsZVNNQy9KYkZXdXhDVUh3OUs2aWVvbVBLbUVNcWtrOUgwbG40eFJnbVFs?=
 =?utf-8?B?UWdydnN0dnAydVNHZ0RuRW05VHg3b3N3bUVMTkpFUnQ0ZWFqY0xVeWc3TVdX?=
 =?utf-8?B?d3BvcUJ3US8xd0tGYk9CT3duUDZwZFltUytRV3NtalJVdTlOTG5WYmtMMFRP?=
 =?utf-8?B?bkxUSEZPcXBZTGE0ZkZ5Y05PWDNYbWh1bzlSMk0wVks5MFpQOXJBKzU2SFQ1?=
 =?utf-8?B?Ti9iSTlvRC9tOC9yQzR1VWg1WGplY0VkQktxOElTWnlHaitJeXlGZEt5T1Bk?=
 =?utf-8?B?eGpXV0Mzc2tLeFNPY3hadnJOSkpGNURlSUZ4VlNxWkdRb2d0eW9pSTdzSUpx?=
 =?utf-8?B?Vzk4NGF2VzB0QTNBc0dUeUtwS05sZ0RrVEhCWEwrQVczY1RRV1lYL3Z1RTZh?=
 =?utf-8?B?Q1Q0ZUt2QzV1ZU41SGhLL1ZJdGgyZ3N5b0lqZi9zYlErNENtb1hpdkd1VHl3?=
 =?utf-8?B?djJIcWVxTVk5L25MRytKMDBlZThaUEhFdEtramJ4NlhqR25iaWdrOEtjc2lv?=
 =?utf-8?B?WjNYWTFUYXVHa1dvbUxTRm9TV1B1LzlEU1NjT0FiMnRmWVNqaExlRHBUNi9M?=
 =?utf-8?B?dFM0blZOSWIzME96UHcvS21NL0NGUk9tMmFBVmFMekZzNHZjUjE3NGFWSHNP?=
 =?utf-8?B?MEU0eXIxdGZBMUw0SlV0eUNJVG1FNlBoTUF1eW0xYlBTOVRBdFg3TmM3ZG8x?=
 =?utf-8?B?T1MzTjFTYTNBNlN4NktmQjJNbERlVnJJU1A4aFpjWHd5OUxFSGIxK1FYRlhs?=
 =?utf-8?B?L05sck5hOGFjZDRlSE1YYlJsMWFlNkpTVW5kRi93Vkp6blk1d0hrSjM0RGFQ?=
 =?utf-8?B?T2FPY0szZjcrQTFOZ3E0cE9zYnovc0FmWkNyYmVmRFBkWjduSHZaalZJZ2dE?=
 =?utf-8?B?aWxhSmZNOCtzTDloY0kvelZVbWVkcFZPeWhBMHJJZDBBZTFXdUJxdUdTKzAv?=
 =?utf-8?B?eVROZ25PaGM0Z2J5bDVaV0dRRUJSVy8yUGhDZWxoNlZ0Q3FYMUFLenlBQmVr?=
 =?utf-8?B?dXpONExYa0VnS0NWY09SSDcvL3J2U09JdnIzR3IwY001blZlYjVaYTNlWGZM?=
 =?utf-8?B?QTRpTUUrUDBzSTF3QVVGNkJFejNzOTdSdDVqTDQ2WnpxSGlZU3V1Y3d5YTB6?=
 =?utf-8?B?UGJKQlNMQjYxVER2VU01ZXpST3ZuMEdScmJ2dGkyQVZwbk1iVW44V1RGUnJX?=
 =?utf-8?B?dUd3eEdIWDdEUk4velhxN2t4d0JCcldwSDRxWkowVUhDeWQ5UnNDWlh1WGs2?=
 =?utf-8?B?ck10cWw0OERGM1I5VlBMZDNkd0NQWmpZcy9zUE44NnNSWDFxVjd5akgybVpO?=
 =?utf-8?B?WmpHZnBoc3hIQkZ4MU1TRFRlNUwrTUlzYStaU0VVMDN1cmZJamJYU1poUW1t?=
 =?utf-8?B?TStKeXE3b2hnPT0=?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XP9cqDSJzX9GM9GYCAPGRYzdvu0pJcYcOMdl3TA6QVdDmDr/EUP2AgoWYHp3epMxTOFk4n/+FrdCAEb1ycT6qxfo8Xj9WtAkI61KSBHDrUwhTeZcEnP7nBLQcS4iwgifDs4Bef7zgy3SnC/ony6kkYwfjixf7VnRyFD0a7SYPiC4nf2tl7uidEz/iM895w+OQ197Mnu+8+InlZHWijJLZJlA8BStS9JMQvIvdvSP2LRUfD6dQEBgrKmkLHmEqSIz+fttWisi0aZ1rScWBIgZ5M6NxXOpDfi++ll/9+ylRLAzJs72gbbMeAoWFv1AJ2l5l2yjCfCAxAN7yVoipOZYbMWtYK2Nkc+F2KTRCJQDjKCtyQyEJp7wxCfxzOO/aAMU5pU18pe9uEkJdHn52HnBg7jXm9YMwu6xTnbMQijIhBxl7JQZN4Ioplc7W6c7BxIt01z/wwORFoecw7ugSyWwgqDAnf8TkYhb8UiaWaEgOCh9s7qkj+D60KuUHB+rUIbVaxghiHeWUxBLIZwqjrjFO0B7zIMjSV7O+VYhIWaYgKFJ8qDTPLp1JcZQ5iq6yvJ0CShgIJOeCTdmup+S/RfBBkKn0UhbSwsO4BlZutXOUCCHUYy05ANmiRkIyVRmg+5YISJA/gukk8UmrSeqQ6C0Zg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:03.3610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 238af49f-e6f4-4ffc-5f9f-08dd38f1d2ff
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB7167
X-BESS-ID: 1737336547-111953-13367-191410-1
X-BESS-VER: 2019.3_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.57.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmlgZAVgZQ0CjJLNncItHAwC
	Q5ydLcNM0wzczYJMXIOCUxKck42SBJqTYWANiVMFtBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan20-58.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This function is needed by fuse_uring.c to clean ring queues,
so make it non static. Especially in non-static mode the function
name 'end_requests' should be prefixed with fuse_

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 11 +++++------
 fs/fuse/fuse_dev_i.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 27ccae63495d14ea339aa6c8da63d0ac44fc8885..757f2c797d68aa217c0e120f6f16e4a24808ecae 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -34,8 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static void end_requests(struct list_head *head);
-
 static struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -1885,7 +1884,7 @@ static void fuse_resend(struct fuse_conn *fc)
 		spin_unlock(&fiq->lock);
 		list_for_each_entry(req, &to_queue, list)
 			clear_bit(FR_PENDING, &req->flags);
-		end_requests(&to_queue);
+		fuse_dev_end_requests(&to_queue);
 		return;
 	}
 	/* iq and pq requests are both oldest to newest */
@@ -2204,7 +2203,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2307,7 +2306,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2337,7 +2336,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..4fcff2223fa60fbfb844a3f8e1252a523c4c01af
--- /dev/null
+++ b/fs/fuse/fuse_dev_i.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2001-2008  Miklos Szeredi <miklos@szeredi.hu>
+ */
+#ifndef _FS_FUSE_DEV_I_H
+#define _FS_FUSE_DEV_I_H
+
+#include <linux/types.h>
+
+void fuse_dev_end_requests(struct list_head *head);
+
+#endif
+

-- 
2.43.0


