Return-Path: <io-uring+bounces-5702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96548A03443
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1189E3A4B8B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F50D28691;
	Tue,  7 Jan 2025 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="AHLy027o"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B3770803
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736211612; cv=fail; b=n4X5SxUisenpfZz+AthTz4v/W+3iirkYaAOFTgQWfFUg3/4cuAIe4oPa++GGQ9eSMCx6AWCexu1wXWWOXduRW3kig5Ns8BIJKHmbumCx90MS0UuodQ7Jvb363s96omlzFuARY5ZD/B9i83+0x5BT4tv/4yJDzM7aMenb3TeAUA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736211612; c=relaxed/simple;
	bh=455vpR6hkQ2u3HTcvd4tTICV/lcjLmUkyQgxI7osccQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DX2NSs5FxuqQNLF2UNAWQiqAvZ2AfVF/M8KLLO3yY8h2rGFf0uCxVuLHdlYFlJ1czPG0G0Ydl93vnrnxTFvMBz5WGJZaPLS9Lk+U6s4hDq1I8KQFFOuGQRL6SMzCz96rkMjeyyfVkCtNFrRWW+DIoSi2/iJI0jP9hsBjz0I0Cr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=AHLy027o; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:00:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDhUE0dC6ndckVWVPjzGhz4hHMb9WVYxr2ncyn2GDZqUlLNO+rx2JjZFSLXsS21KKxzcYzQWSZ6Koxj5HhCApdJCW4/QDVMZPm74gRepr+wHuTBlPZa6K9LTRxCm/8ZXfkIkatKHKK3XQ+9DCYH7eDFZCKBMyA0JP+GEtejVNZxWphf+EBR99+7xi0sBYMACbPgre1vIp3WJ803M5u3/CZ1zd/Zha8+tdgSf/odmbPE6Yo8xcpODDs2RzemM5EQ7deydHZNtoT/onrLGbBH/xu7dExOLkSu03roQABkzDkGIwXkNskmNN0Cib9jxQA4mEetuzvphwA0MeyYjOjW+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuXSOUK7SIRmeDldD+kaeaGEIQyBJaCc0JTjXP0ob2Y=;
 b=Ik806x+IeFWkuAkIHx4XkSek4SR51WzTHi0uBw9sjqYobbyahlga6hpfIYsrLN3/6N37UODrAyWDK/2i+WMAO2RcJiwK4UnYqJVWaEo76sHvU1JWmjCP4ZkpItexS4jaKikl1Ll4BqcVVRsdQ/MMcS9+ogJ9B2pSyYv1rReoEYwnZArUGFTkv3fUeyZ9OKLMeVprO8BrUAPZL//VkSVOLclTxVWitrrYYLczXqII5+C/uDjJnFt24spoJTm8Tg8pxZsyYaZgtNlkhz0HOVAA6yosrmQOJwdmsGJZ3XQthQOEgC25Xsq6Xb6gDCSgKzFwcKH9BIbnGTUdxlKTN0xFww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuXSOUK7SIRmeDldD+kaeaGEIQyBJaCc0JTjXP0ob2Y=;
 b=AHLy027oKzeIUKkCUgsiOn4ALiELsNvISCPbStysP5dTTNhlpZhDmJALupf3Y+CYJ2i4slD3W+NTu5jvXzN+rNvYJCpreChElITBVSLKEtSakJC1Pb7cnIWWj4FYKRgnucgZVmHZ8TiJkRu/QKkyam/nb6jNaibJoEnbY8Ja9y0=
Received: from CH2PR17CA0018.namprd17.prod.outlook.com (2603:10b6:610:53::28)
 by CY5PR19MB6217.namprd19.prod.outlook.com (2603:10b6:930:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 00:25:19 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::4) by CH2PR17CA0018.outlook.office365.com
 (2603:10b6:610:53::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Tue,
 7 Jan 2025 00:25:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:18 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 29D1855;
	Tue,  7 Jan 2025 00:25:18 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:12 +0100
Subject: [PATCH v9 07/17] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-7-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=3717;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=455vpR6hkQ2u3HTcvd4tTICV/lcjLmUkyQgxI7osccQ=;
 b=TCWwmXzKTF8KHT7JdLy4Ewdm/RfRjcPH+Umz3B8+QwTnsmERDLvFE4ngYin9Fobh1Iu3UlXV3
 MbL/KOLy2zKDfXr4labY/xqe2ylCW/lv0GJjzgghX8Q8P8h5eAJAYZY
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|CY5PR19MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: 7df00a6e-9851-40f8-d65e-08dd2eb1c411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkF2U2N0aVFDVEFxMnp4dmRYWWZaQllsQkd5VHFrbUl5QisrSDdzdFdlZ0Rj?=
 =?utf-8?B?VllUYlpQK296QkkwMHRORU1Pb0JGZC93UThmcER4SkwyWk9GTDRwZHUwN3hO?=
 =?utf-8?B?bDkvL0xnQVVmSjRtaUJ1R01BZGl3U1FoYWhleUh3K3RZTldQcjRrempXSnpO?=
 =?utf-8?B?cjBxQ2NBeEJpbytmdUtCaVNqeHZnR1ZKSVZtOXVFSjNKcWxiZCtiejZlTmpT?=
 =?utf-8?B?MW1WT243ZDdVeDczOCtieWQwNVkrWjRYQzIzdXlWZFNRNVNLaUNDa01nYUFU?=
 =?utf-8?B?VDhBZjErMm1rTU5YYzloTHhLNjM5RUl2cGN0ZUZNbFE4cmp4Yk9MeS96UXFo?=
 =?utf-8?B?dFhiNUx3Wk1Zd1ZuOHIwN3c2eWRvSlNlc1pwVkNJRzEzY3JrWkpWam1icTkx?=
 =?utf-8?B?VFRmTWtRYTBlN2xQSnI3OURBU25YVExmMGNDNnBzNUQ1c0tsUTNSSkRTVGly?=
 =?utf-8?B?SHBTOHBqc2lGeU9SL2h4NlJPdWllTGhZZ0lBWEhjQzh3Y0dxU00xdk9qblRx?=
 =?utf-8?B?M08xZkUyY252c2lUaE1ENkVlVnBTTngvSnF1YXVFdENWa1dwT2E5c0hCNlgv?=
 =?utf-8?B?bXRuMUtLREJvQjlmcjVqVzFHZitXNDRFTWVNa2IvNFFKSmZyTmMrN2tCOWxM?=
 =?utf-8?B?VlF3aFlXbmJ0UU9tZFNJcjlpQWdsYkFZRWlidDBCVnVjbkFRRmFEL0dENkFt?=
 =?utf-8?B?dVJFQi9ZZzNZc25CUHNKYndINk5FeGJyZ1BocDR3SS9LM0k0ZzdoMUsxYndh?=
 =?utf-8?B?TGk2QVJwWEtqWFYvRC9xRHpjMmtaSUJTK2djOFpIbGtCT0p6c0tsTi9DclJC?=
 =?utf-8?B?aUw4RUNBZllUV295RjRJcWFicklqYXRIendqU1BwZGY5RERNeXBydEdEQkph?=
 =?utf-8?B?d3RGUWpQTmtHei9nNk16VzhlZ3NvSmlmcnplcUluSmxJeUdrM0xDNEVTU0lR?=
 =?utf-8?B?QmtZTDNXeEY3Y216S3NTMmNsN004M2dwNlIyS0xHZFdZa1dwbDR4aHo0OTls?=
 =?utf-8?B?NU1HVTh3SDFLREtVVEttcTFzVVBObDR0UHkwdUcrZ21BUkQvdkt4U3QxaDlQ?=
 =?utf-8?B?V2cxSHF6cWM3dWc3b1FTbVAvTnJuMVZFbjJHQlg4N3dqL01DZjZ6M1M3aXpV?=
 =?utf-8?B?SHRWTkJ0TUMvbjZZYkNJY0FGVE5LTE15QkZpcFFRcktVWHUwdVFKRTRRWldD?=
 =?utf-8?B?b05PRklkNDlqSHlYZ1NKdjI5bkVXQ2p2YVZrZEdBejkzZkN3QjlZb3VPdjF5?=
 =?utf-8?B?eXhkUDQ0MXg3dHFwME5NSjlPdFMyQ1l1bEQxVFNtZXFyYTV1OUl1M21XVG9H?=
 =?utf-8?B?eXdubXZQMUVIcldHbWRYVnJobEUrY1d0VERIekwvUlhIS3Z0RDVzcTVQaW9y?=
 =?utf-8?B?MlpGaW9QeThjM2hLY1lPSnVtaUdJbHB6VzduN3Vydmo4d1J1M0gvZFVhNG4y?=
 =?utf-8?B?MUtLcnNEU09uT09SbDU4Z3NBOW8rSThjVHNOdjQ0Wk9rT01Xa1F2YnpJZ2tE?=
 =?utf-8?B?RUFvVHpyeE5vZ3FxNXk5b0dDdlV2YjB3bDBlN0dPQmtuaXFMZGxLd2lZYXlz?=
 =?utf-8?B?NXg3b1Z5bG83eTJ6akV3WnFYa1NVQzJQQWV6NEg2SVlrZFBKR2lweEtPSC8w?=
 =?utf-8?B?My9MeFN6VFNXKy9jY1VZcUFTMTRsK0VYRm5jRjZEZEZUOFg2di9mbG15UzdE?=
 =?utf-8?B?T21PUDZmNlRWbTI5dGVldVRoRk1iL2dNbWQyVGUrZjJoVUVMLzJXWExOSzFk?=
 =?utf-8?B?Y09QSXBRWThBSENBWXEvVmtoaWx6RzFCNlNHZGRvS21hQm95blZzd0Jwd3Fm?=
 =?utf-8?B?eWRmRHJXeVdneE12TVFDT2E1VzZsejIyVFBzQk9yV2lkMkhZeVBZSDMxekZU?=
 =?utf-8?B?Uzl3Zkl3Uzk5UGNVQTFMenRXcy9HcDNWV1hVbWNwQXZ6amJvRWFpT2JzdDZw?=
 =?utf-8?B?L01POXluZHhPdEtLenUwRFFUd1hyclZhbFRTR2YzZ1hKelcvcEdqSndVWFNI?=
 =?utf-8?Q?I92ZFk2YAnb5qYe2ftXRnurf+k2HkU=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hMK+iKxQJI96Jla1EYXDtk5/CVVDbWx3Y6W6fZo7D3S2Pz7D20AQLDt2Rvo9mHNQ6b2Rb2yrnHgUQGJBTvwu/4eauh8jEANhu/c+E3Sw+lvsMD9e4tETJufSz1AiB+ldFcc/fR7zPd+s2iw7ouudN1b3cbXzTZDkKNlV6Ung2SYUhVGr+ifzjhtZrXAOR9jfAMk8V4XSnm4t+RKYrJHYkGYRvhj6H+5BQ+UmmlOQ9NM9+ccMNv44H6mvqzdTy+ce0GXaYMjFqiyNtpNi1jatGYUOaj781MlyfuJF5mHitWUSMK+kM8ZUtbAabasoPDM5YQ15dC7pevabEpTTyIE4TzKlmwzXMwkdPMuYY1EfLi8IihcFxnoDvBGrAAsyFWSpRTmi80SGkqF8SaA4V7wbybCdf6MFWNimdOzX0kQt4jAc+PRv3pBfKtsyEMnQU9hdOP/18ymyeEhdD2jgS5aGVVzgWQyPFkjpt8wYEnaa7xPhFPGmWkQhYOADhcumUuAIgLOgfLCezBsdPUYygwflV6hWebBmCmZiCny52qpifN6xl3scx6p2iRVc6uAiTPzMDnHRqDHNgHAPTnxNMEUb2Th3OjY+cVKijYb5iiF/B6uscqsU7WJK3TDtBUmZZ/FiMA5aY+26wwZCwgsMY5Cz7A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:18.8820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df00a6e-9851-40f8-d65e-08dd2eb1c411
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR19MB6217
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736211604-104050-8173-52804-1
X-BESS-VER: 2019.3_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.59.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsZmBgZAVgZQ0NTMxMAsydQ8OT
	k1ySwxLdXAOMXANDHV1Nwi2dQgzcJQqTYWALZTIqNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261636 [from 
	cloudscan23-78.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-io-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 623c5a067c1841e8210b5b4e063e7b6690f1825a..6ee7e28a84c80a3e7c8dc933986c0388371ff6cd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -678,22 +678,8 @@ static int unlock_request(struct fuse_req *req)
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
@@ -1054,9 +1040,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
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
@@ -1933,8 +1919,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -2036,7 +2022,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 08a7e88e002773fcd18c25a229c7aa6450831401..21eb1bdb492d04f0a406d25bb8d300b34244dce2 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -12,6 +12,23 @@
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
@@ -23,5 +40,13 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
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


