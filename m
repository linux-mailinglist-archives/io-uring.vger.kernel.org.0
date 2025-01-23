Return-Path: <io-uring+bounces-6077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04836A1A63A
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F9B23ACA83
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB0021325C;
	Thu, 23 Jan 2025 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="fa7u1K3a"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF221147C;
	Thu, 23 Jan 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643905; cv=fail; b=B3EHeh63e4XY7uMOfOm2sB12XJQdGSTypL3nkF5O/dHAatbxk9KsCVFr6xWYjSYahsbelH+XU4C/n2qfglXcXOTEcyyfXY3O0umZq+EhiLGGxHWpWAHt8YtSjnzRso+Y/S0co+xqYgxntm2KjDTpHTn+xint0N0dDQvlQHLyzQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643905; c=relaxed/simple;
	bh=o47avlAjcLFEraiBtbxk5Pj+81vDZgL7QsPtvUc470c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KwoSRjkiaoj+bx3rX6aM7vxG2Gfxf+zWE8hM/kK2aBq0OonUPNms1ZpXeCyuDfwleVUPkfyAnvdGe8BWiO7g9YpZC4iTi19zi4GP7LG5HJ/yL7BuFNmya0Y+bX+el3u2WA/NTObBuiT+/DWFjsbi1+6Dfo0YB9jpbEXfyJnvqLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=fa7u1K3a; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40]) by mx-outbound13-143.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ijYB1pWy6RLAWuLygDZasJTAEcHpF1LSIJLgIeLjzLPiy4eSqGo73jXsgOWr5ZHxR1YkqdofeUcT9wkP3Mnwgyi5NxwUxszP1+k7LgbcN6LZeAdbk2weH1stjEbDW4tmX+aOeGqL911oNn5N6wiQpvHum5JtVl+XycOLHlBmOWBtLD6XuYAAMWedg6izjD6c3ef9A6mjhCYpZ+8+U+YoOZ/w0fhTwPSQxdIrJ3ovvlBwHkGlAgluKZIGFJrzk73monehxfC4oBv5aglOncWS/A5dS8BbLm8Rb+i6qc3BB22V5M1Q8exV+RqrmVSUDWqkFP/+9dtblGt1ZkfhOJOhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4BlwnM3EWc8JXjolWsAkbngWC0xDsVeOhknh8cszNw=;
 b=drTYqEq1zQufsKE9afIi4WrDwutb+JxeygZxpQh2Ywtb5LkxzHBIu3gQczFj438DR2YuYFrSp/1KvHWzIfI94bE+d91NoWGvF0KicjbunWeIfSIC48t4oErevPhxTTuT7vcSqcFtAtXsMffjq1LqOGCWXv7z2v4fYMKLgMYnX70TtgrZzq8rPYWN7UduOplumYnSPXTJpuzXtYW6gEUVxofGQILPtKV4F0vbNd5On0JiWHBi8pdPBG/KP1aZBarDfMyuPr0vg4YIto3LW637DP8SxdzVFIBjCXXrtfer7QRro82Rs6/LPR2CIWX+l5uFFQQ/X4AOQxGXW99Hwpw8gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4BlwnM3EWc8JXjolWsAkbngWC0xDsVeOhknh8cszNw=;
 b=fa7u1K3aXa2tpurgg2q5ZtcGvpnBJ63ZAAWYTH3W4C2G8qBAh9FjNmOmDsNFbAo2SJ7FlVnVeeKm3lCGAtPytHzyE6tAhteD9h6AbrqOMZ//rSBrNHRYrsLPeCbiUn46ra26kyPjAt+HoVbGm5O4bDX9IgtJHn6kB/WegyF7Hl0=
Received: from BYAPR04CA0014.namprd04.prod.outlook.com (2603:10b6:a03:40::27)
 by SJ0PR19MB5464.namprd19.prod.outlook.com (2603:10b6:a03:3d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 14:51:19 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::13) by BYAPR04CA0014.outlook.office365.com
 (2603:10b6:a03:40::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:18 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 081D480;
	Thu, 23 Jan 2025 14:51:17 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:05 +0100
Subject: [PATCH v11 06/18] fuse: {io-uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-6-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=17157;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=o47avlAjcLFEraiBtbxk5Pj+81vDZgL7QsPtvUc470c=;
 b=0sP2Ba8yUmSm5BBmAOuUIJHBFHP39BDs/dG8lzhy9xFkRJ4qsISyqE1bBIMAg8CiahVuADZy6
 p2B2beYXoDqDQHbkz/GqhWEEj/uBGXqn+A1R8k1/SKR7zONxUK5DxYL
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|SJ0PR19MB5464:EE_
X-MS-Office365-Filtering-Correlation-Id: 94a47c11-9262-4e50-47e2-08dd3bbd650e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amdBSkZYVElRNWVpMjNMcllqTTZNMnR2U2dtSUFVcTIzaXZLYVZhU1UzSUpl?=
 =?utf-8?B?RCtFWm81NUlaRHlBV011VTk4SVlLUm1qeXh0OTkwSjMzcEs3MDFSMy9YeDFa?=
 =?utf-8?B?aDdSbFZrYzBYSnZiQ1JrTCt1MzNSNzZLN05sanpqOFljSzdkRjVBb21nNDNj?=
 =?utf-8?B?TWcrVWVtYzFRNmFrNGpZNFdNTVJLZVpOdzVaMDJrK2xDc3Q3b2NvMEtMTWRJ?=
 =?utf-8?B?L2Z4S3JzcUhWZkhhaE1YYWdyc3lYdFJBQkQ1VXhvRGVzQWxYZk4yOVI3QVY3?=
 =?utf-8?B?V2p5ckxwWWpRNUJleHV6dGo5c3RSOVI4WGRNdkFrcU9tZ3EwWWgydnRlcnhh?=
 =?utf-8?B?T1gzRURpY2V0K1ljV2pRc083WE9DYlpRY1Q4cXkwdG1CU1NaMUwzZk9URElM?=
 =?utf-8?B?L0RDRlNOcElndWIyd1dyVTNZSDB6OGdScjM4aUdkL1I4QWFaU2FmSUNwRzR1?=
 =?utf-8?B?Mk5hQW9CNGxPQTB0UHZyMkZXUWowdXNlS1dCdmtZQ0NaTS9iVmdTc2J4R0lW?=
 =?utf-8?B?eUlWcWtMbjZnN05QU0dPdXhTY2V0WTFFVTd0b3paajlUKzFwd0VLZGFsQ2ll?=
 =?utf-8?B?THlndERSV1NwZWdTaXpzK2FPQ1BzU3BJUUwwQ1NOV2F0enl3aGRsclBRaDRX?=
 =?utf-8?B?a1lKYk96dTZUcmpoZUVNaG9tWEFqNWlUU3MvMm5JV0xLTDcyOGJvdFc2UVFV?=
 =?utf-8?B?ck5VUjZ2NUNxTGxyY3hyTDBIT1VpUUgrZW8zQVhJVGxSbGNrSVJOMDE0WkZB?=
 =?utf-8?B?T0J4Mjdwd0hIeEJkRUNuL096SFBJVWVJam5XYlQ4ejhQSVM5YU81Y1QzWWk4?=
 =?utf-8?B?OEhIaTFnQXlRcHZpWXczVXovMUtVVHFRT0FLS25XWGFRS1p5eGJha2VTTlVQ?=
 =?utf-8?B?QytzUUtGdk5YemozTWxSNHFVNVE4L2c3dnNkSW9Pb1FFYzE5a2gvNjFheisy?=
 =?utf-8?B?UVhORFpmWkRsN2c3WHZ6TkJlMnFEdGk2Skt3N1k0NGMydnhnUlNBd0xJTGU4?=
 =?utf-8?B?MGhqaGp5em11eU5ybzBQSHBBYWVESFFDNmtGU2p3bTI1MnFnZFEwcGZTb1NV?=
 =?utf-8?B?YVlPU0NJZTdSNGJVYUc4VFpJY2Y5a3lOU3pLV3VQcFlOQ1NLVVVsTjNEd2xH?=
 =?utf-8?B?MUpycldlTTZSaWs4WHZhUGdkTTBVYnFMbkttekFZZytNVlZYYVBEOEV5Mmsw?=
 =?utf-8?B?U3lwd1JEY1NQVjBNVXR1RFB6Z2Q2alZHKzhHaEF2Y2FRc3F3YjFwcjNKalJm?=
 =?utf-8?B?QkdZdHhzblAvbDVnWkt5dmltUmhhNW5KUXQ3cm9GZWpXMkU4OVJpbG40MkNm?=
 =?utf-8?B?RkIvTnlQbm9saDBsaGtSaWdLRy9zMTZBT0VuYTh1RHBCek5lTU9HdjE4UHNY?=
 =?utf-8?B?ZXlZQUIyaW50c29adVRXaTh6TDRlQndmcFozTklSSFdiS0o5aUFrczBOd0gv?=
 =?utf-8?B?YzB1TzdiZjVmMVNQaWtkYlIxSVI3M0JuRGc3eGZoR0NQa0hNT2xva1FyanZZ?=
 =?utf-8?B?Q1A1TC81TjU5VDlXUnlVblBoK3E2ODhVV1RCZUR6VlVXUDE3MTR4eFR0aTJ5?=
 =?utf-8?B?bjh2TGF6ajJZU0tMUzhrSmsrSWNBdy8weUE2bFZwZW53YnJmS0J6U1NFV200?=
 =?utf-8?B?YmNiWTlnWVBablJUZWtFVy80Z29HOEpmQi9vRnFONnVGbWtwWHJCOUJwOTZy?=
 =?utf-8?B?bUZUY1JJeXMwaXgxcXA5NGF1eHRkUnNQUHhDeG5BYVZUUmc3ekx1dGoxeVNs?=
 =?utf-8?B?SmJXb1paOHVRU0NOdTBad1RWb1krVHJURnptWk9acitQTVVTM3IxVVZrNlpx?=
 =?utf-8?B?aG9uK1UvZFpOU1dkTnVvb2hMSVdTZ05XdjVPL1ZqOTd1T3BNdXVOcjRONzhU?=
 =?utf-8?B?RENBSFREKzBJa1BXa1RWNkhiWHVvdGxGVDROeG5reDFjNDM4OFdSWWpaa1pB?=
 =?utf-8?B?ZTA4NzVJV3owSmczQ295M2JWRWkvamgyYU1uMHptUVQyWHYrSlJQVGx6SDg1?=
 =?utf-8?Q?HRRC0SrZd57LWVHECp2NruKca9jl2U=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XEUWoRvT2b5rrK3p4ed+GDd6DqhsAtPl/H96+MY1+ZZ1LOeGNEdneEsMJ2zUoAFKB7WbbcrNSuIBIJz4iBKRtcsDVNGHvg41P8H1AKVGtUtzhy52QT3107X1oqJK7cK50/8NXRlZnRl7boKwK5nAOe4o7gfMHAHTeAA8HVBIc1qaKj1XMP9DAuX2e/6XYufvsVvJHf9nLl8xYg7/puaNwRxuUCp23XqWIreLTiaR949W7UzcPhAGTaFAc8QVbkqXrShb26vecavr3Ec+F9NrEkKPQeqGNr5h3Ssh6gqbvMhsAUUsQ6pCqBznTvP4acNU/i2Ws1E1SovHE8mk+gr3Qi0nfXN5lFlD98u1MqdSYin8Ty2hlfKc/75llTyfq4akllfj3wVOYxc9SqUiLWdE7kZN9R82JuGADNFtqgcjywFinCHQvywYuRM7O7APxA+YcmH+x4zO27AzyXTVrXHk+6nsuiQpsymP4YCCxXsMbgOXsj2HwLUAQwFYi6PbkWswfgTEhKAYArpHRqbO7TfxL2W61Vy8hCrSskOYSDNhoIbjo2UbQIqNptV0fVArkSWegkWqkDS+EukYZOesE2zntz8Ez/kU3dSzmyk4hP8S6jdoTlVenjreI5GJc+EEUEott0g+wHt5qgpeZTqhb1W49g==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:18.5677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a47c11-9262-4e50-47e2-08dd3bbd650e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB5464
X-BESS-ID: 1737643883-103471-13466-436-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.73.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmJpZGQGYGUNQyOdXSKCnF2C
	QlxcwiMcUkJTkt0TzROMnS1Ngo1SQpRak2FgBIU6NAQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan19-154.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
entries.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/Kconfig           |  12 ++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev_uring.c       | 326 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 113 ++++++++++++++++
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |  10 ++
 include/uapi/linux/fuse.h |  76 ++++++++++-
 7 files changed, 542 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..ca215a3cba3e310d1359d069202193acdcdb172b 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
 	  to be performed directly on a backing file.
 
 	  If you want to allow passthrough operations, answer Y.
+
+config FUSE_IO_URING
+	bool "FUSE communication over io-uring"
+	default y
+	depends on FUSE_FS
+	depends on IO_URING
+	help
+	  This allows sending FUSE requests over the io-uring interface and
+          also adds request core affinity.
+
+	  If you want to allow fuse server/client communication through io-uring,
+	  answer Y
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 2c372180d631eb340eca36f19ee2c2686de9714d..3f0f312a31c1cc200c0c91a086b30a8318e39d94 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -15,5 +15,6 @@ fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
 fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
 fuse-$(CONFIG_SYSCTL) += sysctl.o
+fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
new file mode 100644
index 0000000000000000000000000000000000000000..42092a234570efce46b42c56b75767ce487aee24
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#include "fuse_i.h"
+#include "dev_uring_i.h"
+#include "fuse_dev_i.h"
+
+#include <linux/fs.h>
+#include <linux/io_uring/cmd.h>
+
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable userspace communication through io-uring");
+
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+
+bool fuse_uring_enabled(void)
+{
+	return enable_uring;
+}
+
+void fuse_uring_destruct(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+	int qid;
+
+	if (!ring)
+		return;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_commit_queue));
+
+		kfree(queue);
+		ring->queues[qid] = NULL;
+	}
+
+	kfree(ring->queues);
+	kfree(ring);
+	fc->ring = NULL;
+}
+
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring;
+	size_t nr_queues = num_possible_cpus();
+	struct fuse_ring *res = NULL;
+	size_t max_payload_size;
+
+	ring = kzalloc(sizeof(*fc->ring), GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return NULL;
+
+	ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
+			       GFP_KERNEL_ACCOUNT);
+	if (!ring->queues)
+		goto out_err;
+
+	max_payload_size = max(FUSE_MIN_READ_BUFFER, fc->max_write);
+	max_payload_size = max(max_payload_size, fc->max_pages * PAGE_SIZE);
+
+	spin_lock(&fc->lock);
+	if (fc->ring) {
+		/* race, another thread created the ring in the meantime */
+		spin_unlock(&fc->lock);
+		res = fc->ring;
+		goto out_err;
+	}
+
+	fc->ring = ring;
+	ring->nr_queues = nr_queues;
+	ring->fc = fc;
+	ring->max_payload_sz = max_payload_size;
+
+	spin_unlock(&fc->lock);
+	return ring;
+
+out_err:
+	kfree(ring->queues);
+	kfree(ring);
+	return res;
+}
+
+static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
+						       int qid)
+{
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_ring_queue *queue;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
+	if (!queue)
+		return NULL;
+	queue->qid = qid;
+	queue->ring = ring;
+	spin_lock_init(&queue->lock);
+
+	INIT_LIST_HEAD(&queue->ent_avail_queue);
+	INIT_LIST_HEAD(&queue->ent_commit_queue);
+
+	spin_lock(&fc->lock);
+	if (ring->queues[qid]) {
+		spin_unlock(&fc->lock);
+		kfree(queue);
+		return ring->queues[qid];
+	}
+
+	/*
+	 * write_once and lock as the caller mostly doesn't take the lock at all
+	 */
+	WRITE_ONCE(ring->queues[qid], queue);
+	spin_unlock(&fc->lock);
+
+	return queue;
+}
+
+/*
+ * Make a ring entry available for fuse_req assignment
+ */
+static void fuse_uring_ent_avail(struct fuse_ring_ent *ent,
+				 struct fuse_ring_queue *queue)
+{
+	WARN_ON_ONCE(!ent->cmd);
+	list_move(&ent->list, &queue->ent_avail_queue);
+	ent->state = FRRS_AVAILABLE;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static void fuse_uring_do_register(struct fuse_ring_ent *ent,
+				   struct io_uring_cmd *cmd,
+				   unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	spin_lock(&queue->lock);
+	ent->cmd = cmd;
+	fuse_uring_ent_avail(ent, queue);
+	spin_unlock(&queue->lock);
+}
+
+/*
+ * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
+ * the payload
+ */
+static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
+					 struct iovec iov[FUSE_URING_IOV_SEGS])
+{
+	struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	struct iov_iter iter;
+	ssize_t ret;
+
+	if (sqe->len != FUSE_URING_IOV_SEGS)
+		return -EINVAL;
+
+	/*
+	 * Direction for buffer access will actually be READ and WRITE,
+	 * using write for the import should include READ access as well.
+	 */
+	ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
+			   FUSE_URING_IOV_SEGS, &iov, &iter);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct fuse_ring_ent *
+fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
+			   struct fuse_ring_queue *queue)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent;
+	size_t payload_size;
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+	int err;
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return ERR_PTR(err);
+	}
+
+	err = -EINVAL;
+	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+		return ERR_PTR(err);
+	}
+
+	payload_size = iov[1].iov_len;
+	if (payload_size < ring->max_payload_sz) {
+		pr_info_ratelimited("Invalid req payload len %zu\n",
+				    payload_size);
+		return ERR_PTR(err);
+	}
+
+	err = -ENOMEM;
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
+	if (!ent)
+		return ERR_PTR(err);
+
+	INIT_LIST_HEAD(&ent->list);
+
+	ent->queue = queue;
+	ent->headers = iov[0].iov_base;
+	ent->payload = iov[1].iov_base;
+
+	return ent;
+}
+
+/*
+ * Register header and payload buffer with the kernel and puts the
+ * entry as "ready to get fuse requests" on the queue
+ */
+static int fuse_uring_register(struct io_uring_cmd *cmd,
+			       unsigned int issue_flags, struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ent;
+	int err;
+	unsigned int qid = READ_ONCE(cmd_req->qid);
+
+	err = -ENOMEM;
+	if (!ring) {
+		ring = fuse_uring_create(fc);
+		if (!ring)
+			return err;
+	}
+
+	if (qid >= ring->nr_queues) {
+		pr_info_ratelimited("fuse: Invalid ring qid %u\n", qid);
+		return -EINVAL;
+	}
+
+	queue = ring->queues[qid];
+	if (!queue) {
+		queue = fuse_uring_create_queue(ring, qid);
+		if (!queue)
+			return err;
+	}
+
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
+
+	ent = fuse_uring_create_ring_ent(cmd, queue);
+	if (IS_ERR(ent))
+		return PTR_ERR(ent);
+
+	fuse_uring_do_register(ent, cmd, issue_flags);
+
+	return 0;
+}
+
+/*
+ * Entry function from io_uring to handle the given passthrough command
+ * (op code IORING_OP_URING_CMD)
+ */
+int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
+				  unsigned int issue_flags)
+{
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	u32 cmd_op = cmd->cmd_op;
+	int err;
+
+	if (!enable_uring) {
+		pr_info_ratelimited("fuse-io-uring is disabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* This extra SQE size holds struct fuse_uring_cmd_req */
+	if (!(issue_flags & IO_URING_F_SQE128))
+		return -EINVAL;
+
+	fud = fuse_get_dev(cmd->file);
+	if (!fud) {
+		pr_info_ratelimited("No fuse device found\n");
+		return -ENOTCONN;
+	}
+	fc = fud->fc;
+
+	if (fc->aborted)
+		return -ECONNABORTED;
+	if (!fc->connected)
+		return -ENOTCONN;
+
+	/*
+	 * fuse_uring_register() needs the ring to be initialized,
+	 * we need to know the max payload size
+	 */
+	if (!fc->initialized)
+		return -EAGAIN;
+
+	switch (cmd_op) {
+	case FUSE_IO_URING_CMD_REGISTER:
+		err = fuse_uring_register(cmd, issue_flags, fc);
+		if (err) {
+			pr_info_once("FUSE_IO_URING_CMD_REGISTER failed err=%d\n",
+				     err);
+			return err;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return -EIOCBQUEUED;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..ae1536355b368583132d2ab6878b5490510b28e8
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#ifndef _FS_FUSE_DEV_URING_I_H
+#define _FS_FUSE_DEV_URING_I_H
+
+#include "fuse_i.h"
+
+#ifdef CONFIG_FUSE_IO_URING
+
+enum fuse_ring_req_state {
+	FRRS_INVALID = 0,
+
+	/* The ring entry received from userspace and it is being processed */
+	FRRS_COMMIT,
+
+	/* The ring entry is waiting for new fuse requests */
+	FRRS_AVAILABLE,
+
+	/* The ring entry is in or on the way to user space */
+	FRRS_USERSPACE,
+};
+
+/** A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* userspace buffer */
+	struct fuse_uring_req_header __user *headers;
+	void __user *payload;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	/* fields below are protected by queue->lock */
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	enum fuse_ring_req_state state;
+
+	struct fuse_req *fuse_req;
+};
+
+struct fuse_ring_queue {
+	/*
+	 * back pointer to the main fuse uring structure that holds this
+	 * queue
+	 */
+	struct fuse_ring *ring;
+
+	/* queue id, corresponds to the cpu core */
+	unsigned int qid;
+
+	/*
+	 * queue lock, taken when any value in the queue changes _and_ also
+	 * a ring entry state changes.
+	 */
+	spinlock_t lock;
+
+	/* available ring entries (struct fuse_ring_ent) */
+	struct list_head ent_avail_queue;
+
+	/*
+	 * entries in the process of being committed or in the process
+	 * to be sent to userspace
+	 */
+	struct list_head ent_commit_queue;
+};
+
+/**
+ * Describes if uring is for communication and holds alls the data needed
+ * for uring communication
+ */
+struct fuse_ring {
+	/* back pointer */
+	struct fuse_conn *fc;
+
+	/* number of ring queues */
+	size_t nr_queues;
+
+	/* maximum payload/arg size */
+	size_t max_payload_sz;
+
+	struct fuse_ring_queue **queues;
+};
+
+bool fuse_uring_enabled(void);
+void fuse_uring_destruct(struct fuse_conn *fc);
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+
+#else /* CONFIG_FUSE_IO_URING */
+
+struct fuse_ring;
+
+static inline void fuse_uring_create(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_destruct(struct fuse_conn *fc)
+{
+}
+
+static inline bool fuse_uring_enabled(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_FUSE_IO_URING */
+
+#endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 5666900bee5e28cacfb03728f84571f5c0c94784..bce8cc482d6425a64c930c9b646d2f74e81323c8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -923,6 +923,11 @@ struct fuse_conn {
 	/** IDR for backing files ids */
 	struct idr backing_files_map;
 #endif
+
+#ifdef CONFIG_FUSE_IO_URING
+	/**  uring connection information*/
+	struct fuse_ring *ring;
+#endif
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3ce4f4e81d09e867c3a7db7b1dbb819f88ed34ef..e4f9bbacfc1bc6f51d5d01b4c47b42cc159ed783 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -992,6 +993,8 @@ static void delayed_release(struct rcu_head *p)
 {
 	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
 
+	fuse_uring_destruct(fc);
+
 	put_user_ns(fc->user_ns);
 	fc->release(fc);
 }
@@ -1446,6 +1449,13 @@ void fuse_send_init(struct fuse_mount *fm)
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
 
+	/*
+	 * This is just an information flag for fuse server. No need to check
+	 * the reply - server is either sending IORING_OP_URING_CMD or not.
+	 */
+	if (fuse_uring_enabled())
+		flags |= FUSE_OVER_IO_URING;
+
 	ia->in.flags = flags;
 	ia->in.flags2 = flags >> 32;
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index f1e99458e29e4fdce5273bc3def242342f207ebd..5e0eb41d967e9de5951673de4405a3ed22cdd8e2 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -220,6 +220,15 @@
  *
  *  7.41
  *  - add FUSE_ALLOW_IDMAP
+ *  7.42
+ *  - Add FUSE_OVER_IO_URING and all other io-uring related flags and data
+ *    structures:
+ *    - struct fuse_uring_ent_in_out
+ *    - struct fuse_uring_req_header
+ *    - struct fuse_uring_cmd_req
+ *    - FUSE_URING_IN_OUT_HEADER_SZ
+ *    - FUSE_URING_OP_IN_OUT_SZ
+ *    - enum fuse_uring_cmd
  */
 
 #ifndef _LINUX_FUSE_H
@@ -255,7 +264,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 41
+#define FUSE_KERNEL_MINOR_VERSION 42
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -425,6 +434,7 @@ struct fuse_file_lock {
  * FUSE_HAS_RESEND: kernel supports resending pending requests, and the high bit
  *		    of the request ID indicates resend requests
  * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
+ * FUSE_OVER_IO_URING: Indicate that client supports io-uring
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -471,6 +481,7 @@ struct fuse_file_lock {
 /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
+#define FUSE_OVER_IO_URING	(1ULL << 41)
 
 /**
  * CUSE INIT request/reply flags
@@ -1206,4 +1217,67 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_URING_IN_OUT_HEADER_SZ 128
+#define FUSE_URING_OP_IN_OUT_SZ 128
+
+/* Used as part of the fuse_uring_req_header */
+struct fuse_uring_ent_in_out {
+	uint64_t flags;
+
+	/*
+	 * commit ID to be used in a reply to a ring request (see also
+	 * struct fuse_uring_cmd_req)
+	 */
+	uint64_t commit_id;
+
+	/* size of user payload buffer */
+	uint32_t payload_sz;
+	uint32_t padding;
+
+	uint64_t reserved;
+};
+
+/**
+ * Header for all fuse-io-uring requests
+ */
+struct fuse_uring_req_header {
+	/* struct fuse_in_header / struct fuse_out_header */
+	char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
+
+	/* per op code header */
+	char op_in[FUSE_URING_OP_IN_OUT_SZ];
+
+	struct fuse_uring_ent_in_out ring_ent_in_out;
+};
+
+/**
+ * sqe commands to the kernel
+ */
+enum fuse_uring_cmd {
+	FUSE_IO_URING_CMD_INVALID = 0,
+
+	/* register the request buffer and fetch a fuse request */
+	FUSE_IO_URING_CMD_REGISTER = 1,
+
+	/* commit fuse request result and fetch next request */
+	FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
+};
+
+/**
+ * In the 80B command area of the SQE.
+ */
+struct fuse_uring_cmd_req {
+	uint64_t flags;
+
+	/* entry identifier for commits */
+	uint64_t commit_id;
+
+	/* queue the command is for (queue index) */
+	uint16_t qid;
+	uint8_t padding[6];
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


