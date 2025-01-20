Return-Path: <io-uring+bounces-6018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE89A16521
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EC923A04E5
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1BDD517;
	Mon, 20 Jan 2025 01:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="bei9kF7T"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C135B28373;
	Mon, 20 Jan 2025 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336577; cv=fail; b=kszvhQcjdEOzOT1HhPfTJyy8d7mYaFKE2dCffyf71D0WG3focoNCQbOKEDeEjGBJzKjhhNDhovudLpj2cPWDtkTStFA8MDOjfpQqS5LumI9wJWG/pDbt1drerrZ9W0+eSjSIk/rMI0XRdyGmmF/m2N+Za6LPMAVPp9Wj6PInhp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336577; c=relaxed/simple;
	bh=3i8xm5Y1fqUWaEUFdAiYLVi+P0PPRqb1MIt8B8j7Nfo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZqOd+i6VOgdawwgeJ9vG8djYoKar6P1Gy8oB/kTNkpfPZw4hXQPTAqYLE3RjySwuhW0peJuDqfBhgo4vEptG39FmJWcsEAdbiE+IsooqmejmE4utCGRL0OHsazGQ8Wgf4/ZWYuze8ByHsgDYjx5Bb15bgHb/9DouR5Q47vjOruk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=bei9kF7T; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound23-227.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hl1L/nJ8yd4hVntdmikrzXwqig9CcbAuLMahxocr7IIElG1DEhPuB30T9SHuUK1W9J7eY4VaYoopMGSbXvmZfleWpYvNAfdSBFoCLx9xEo7j4xbesLot8SeKLNkX6WspGNBSPpdgk3JXrn6d+52r7noX0wFes65GODzQmuKrYPlkuek11CxbUFQbV++Y/SWR0dd3SGOOJZfuWFKnPh7Wcx1bq2JgsCjK+ebnCkLD4izPSo9q/fTdl78VdbYFkiMokdP9zmIumzjBBexIX79Hp5CXlxv2vFCRkmiEdyL9zi/2rNklCglw20+zDlA+uI9MI3li/INWZVoWbS0D4rB28g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFYAXuUB0Ed7tRwQ8bNK4SgdfVSspLgCn1I1pYG92o4=;
 b=QGFnh0RNTQYk+kG4QNC65jVYqSqDxckBAYRBKG57KYr0AolMUZQq88KjN39Z3vPq+yorXWjDTmsNN/ocWb2kavPaL9lrT/OsI9XZrx0pUvmZPOak0uWPTS6rqMiPCERo0gx2LjXp147HBuqLWCSqZ0HEcoMjv27OwyPbwEr0VbvOZJ+tXDNRTsF4MyUCxPF9rgJ0Zkw4EQihLtZ1mds1xLcR3QtPbi8EPPiaBTMI4QUZzx9CRPksLdt8smK6G9t5/nCDfc4EZ4OnbS85Z2QUmT4oYyBTk69QGr1QmTMZsGqS0GAWGhFFtZ+671f2DXLpr5hltLvtIN1OSU5i3C852Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFYAXuUB0Ed7tRwQ8bNK4SgdfVSspLgCn1I1pYG92o4=;
 b=bei9kF7T2mqY/a7qPYYPIrq9a4ypdsNtFqrWf6ERKfAAphbwO7gNK/+JS46URyM0A9p3qNb3QW1lTUmUe+HAdqa8z+YMGLcq/zLkfnAqNnU9XBrDnc/oa5F/tBbkZzsKFK+VQl85CnkukcNexkycMjrXwwxizZ3Nd9rQ7cjaDiA=
Received: from SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::6)
 by SA1PR19MB7016.namprd19.prod.outlook.com (2603:10b6:806:2bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:19 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:41b:cafe::4a) by SJ0P220CA0030.outlook.office365.com
 (2603:10b6:a03:41b::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:19 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 744194D;
	Mon, 20 Jan 2025 01:29:18 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:10 +0100
Subject: [PATCH v10 17/17] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-17-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=1431;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=3i8xm5Y1fqUWaEUFdAiYLVi+P0PPRqb1MIt8B8j7Nfo=;
 b=gHAv4MjTHqnhDovphFybSS2DIk+wpRCpWGUTqJvWdg+Z0k5N6U7st1qrAD4CUd6/IF1Iml3UB
 bH8TOJvq0HIBOiIFGBkL5NQ1YR3JPSqdcogjtCwcx6/f4/DPMySADvV
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|SA1PR19MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: 106a37e5-22dd-4179-cde7-08dd38f1dc5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVI0OGIyZGx0TlIxdUhZQ094c0NKc0ZLc0FsZWx5TGdhMmltZnZuY0tQWlI5?=
 =?utf-8?B?ZVFmeFNCVGlGZHIxNzhkQlJvdVRKTDUwcnY3YXBITSs1TlBpb2h1bjR3MnB4?=
 =?utf-8?B?c25QZXJGbVdudnpvcU9EaHZjRGVFOWtJYU9MYzJxcllVTnNYMHg2dyt6QlBK?=
 =?utf-8?B?ZGlvOXpiKzEraDM0Q0xaNnhKMWhScGt5a2tEQWhrRzJCV2R3TWIxL2U4RFFk?=
 =?utf-8?B?OEY2TWNWb1RiWXRwaFV4UW1yNU9sRGJidjNBMEQrbE1vR2xWS1pDUVU0WEVk?=
 =?utf-8?B?eW9ya2tZRUhzR09ZcFMvUDJjcjNOYzY4WDFVdldocU9SSTFNcjVDaDZHRHMw?=
 =?utf-8?B?UG1uaFhyeXhpQ0tnWllWVHByRDNKbWh1TjVQQXRseks3REZnUzMwaDd6QjUz?=
 =?utf-8?B?bkxpcXNJdW9pNisxVTRmdDdzM05RNWJ3VHhrdGxxVG4rZERYeXNLTUlKdENv?=
 =?utf-8?B?YlRabzZyVnd2RVhYREFIazdJMER6MkZmME1LWnJIdVVWYXJyWlVKeTJHcUVG?=
 =?utf-8?B?U08vekc0eVcyUUtyUU80UDl1YmYyQWRrRkgwSkpmMWFnUi9vdWVOQWxaOTVH?=
 =?utf-8?B?YVdsMHlZU3p0SFdodkFsNm1CQTZ5amZxUHljZnFEWDNGNzA1VkhERzV1b1FD?=
 =?utf-8?B?NjRqbDNuS1pTcmR2NVJvS3EzbURnZGhoWmI3YlJyMzAzMzJiYXFNR0dxZFpY?=
 =?utf-8?B?R3RjblA1cGJnYUpoM0VBZ1dOb3pWNVMwTEJuMEc2UHUxSFBGdmU0akxIZTFs?=
 =?utf-8?B?cFl1bzQyU0lMZTBDM0ozNkpZOW83cmQrVStUY05NZnQyV1RaY1dUUHppSTN3?=
 =?utf-8?B?c1Vpd2Q3TTVOTVVxazB3YjRaZWhWa3g2Qjlnd0xuOHNvdVVuRWxVdmdadWJP?=
 =?utf-8?B?TmFCTndzemZJSzNDbEhSS1JrOXRweWRMWDY5U0NtYThxdDV4TkQ0MExyWm5j?=
 =?utf-8?B?d1FzR1B4UzN4Q3FEZkxJV0dxNFdsOGJyblNoWEVFTzdVeUU3RldOa3NqeTNy?=
 =?utf-8?B?U0paaEl4TGxMWHBpTUhJSjZUVTNQV2dYZ3FzdHY3eEpkMXlCSmkyN1ZQY2Zr?=
 =?utf-8?B?VUFoaXlhbmpVYU9Cc0NKdC82SWZDOHhaUzIvVGlieFBWNTBMNGNVRFdvNS94?=
 =?utf-8?B?Sjd3R3M0djM0S3AyeEIzVk80Vkl0bjhkdHZVRFcwYXpvUVlEeWExVSs4aFJF?=
 =?utf-8?B?bisvSFdaeThpdFVud3FnbFE5Z3NUY2tRYlJFUm1Rd2U0ZUNvcytCR3F0UXMx?=
 =?utf-8?B?U2EyNjk5eTJVUk5pT1JmbWkwSTVHcjVlWmdjOUsreG5sbStmZEhOak9QQmpI?=
 =?utf-8?B?UlpiRnF0ekk2TUQramV0RW0yMEZIZW5mZkFkTVh6bmNmNlVWVHliKzEwL0Ja?=
 =?utf-8?B?YVhkVjBNUFFRb1VmSU1jb2NTUFNXaTZQTXk2M0Ftc1ZkTUZmb1I4Y3dhU29K?=
 =?utf-8?B?bXg0dk1tNmk3Q2lJdHF2bFlJdTdBK2xNdjNWc3Fhc0RWTlNUYksxZHdYOFdh?=
 =?utf-8?B?aDZiNVNBdGRrdkRNdk83U1RyZzRHUWpOd3R2aU1FT2luTFM5OXE3cU5jNjhX?=
 =?utf-8?B?OURkc0k3b054SCtMN0ZDVk44Vnp0REx6OVVQY1RmRUlsVjZyUkd6RWFEMExj?=
 =?utf-8?B?RWczSC9US3ljbzhiTU5RcktQd0NUZk9lOW5JQ1YvUzJ0ajV2OEhES0VTbXFZ?=
 =?utf-8?B?cGx4R2dvM3VaV3I0YVh3NjI5Q3FiUHZMSUs1NlBxdTA4cExiNWU4N1RuL01T?=
 =?utf-8?B?WTdQZW9tRml6NWJpcWxlT0JOc0Z0UHVORy9JY1V1aXNWZXgxejZQaU43ZE1k?=
 =?utf-8?B?RXUycWVlQkxhYmE1VFY0Q2NCSTE2L0NnZXpkbjIwMTRJSGJyMTdBS0ltaTdz?=
 =?utf-8?B?bjBKblJtYm5TcEdLOXluaU5JbFV1QzRlR21BVWtpZUpyMU5WanJWSmR3V1J1?=
 =?utf-8?B?OVNoL2krSjFHYVFYL0g4NTZCdm5yWlptQ1dpaUNBd3hMVHRnMEd6YkJybSs2?=
 =?utf-8?Q?qxDFfv/VQuwAio6bWbCkR/os5T1S74=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0kPftMEWdgXbKgOSZjrrWe0RY7PaevnWONivFXYcCIFEe8QLHH8wMExPq0AdDZqBtEdvLETqvwdAz+UMC2P6YrglhUVffqTwSkboqxoRQ2yEcj/axIqJUxW/FX9Sq/vIZ9HqzvIbUeoUCAt9c1q1Sqn1W0ZO72+KOEAhpXwOQnr/oyR3BBUdUEaReM41UWtUo4ptcQ2mUAGEcXdRF57JHZHmXm0ropdgp4NMZvnJIzhrk60/Kn4YJicIjaJcSm66PqNVbqhg/dVv3qqDl3e2clCWGAXbl2x10cE3rutscT2F3Av7Jm44ubQRebEAnSzPJAu5oKRHFAfvYLBJLkDk6E/ZtHUlkDb4MvGeV2k+pBFScVcHicc8DRVby5LVPBDlvmNuzhJEXYO5pHgBs8HJG0erQs132MTYmrT0Db9cBSzJKFNETyKxfj//vkN7smQlNofLyvp4yvto/EpbZnITVn9PL85jQ5cLQukN1WI2y4Nm3pxQLq+TzVqKcOcqLZmHHPYNdeKYtxJeXVEv1tvA4JuAMUBijdoo6IUD9hNPNY+aUJ73q8QtJduLcCFAfvNCDF0JPWD0FNAcXwBLPYp3qvOv3WmCcLeREZQ++GmAHeN7jRTJuSe3PPBsIxDkmosE4uqtMDcdnrqvItDqY7+zWw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:19.0728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 106a37e5-22dd-4179-cde7-08dd38f1dc5c
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB7016
X-BESS-ID: 1737336561-106115-13451-11026-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGloZAVgZQ0MjM1NzQxMIgxS
	TR0NTC2NwozSLRMMXcNMksMTXZ3NxYqTYWAO6m12JBAAAA
X-BESS-Outbound-Spam-Score: 0.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan13-194.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.20 BSF_SC7_SA298e         META: Custom Rule SA298e 
X-BESS-Outbound-Spam-Status: SCORE=0.20 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC7_SA298e
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
---
 fs/fuse/dev.c       | 3 +++
 fs/fuse/dev_uring.c | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f002e8a096f97ba8b6e039309292942995c901c5..5b5f789b37eb68811832d905ca05b59a0d5a2b2a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2493,6 +2493,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 1249c7fd4d63692413d103e72eaa5e502188d3bc..5f10f3880d5a4869d8a040567025c60e75d962c6 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1084,8 +1084,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
  * Entry function from io_uring to handle the given passthrough command
  * (op code IORING_OP_URING_CMD)
  */
-int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
-				  unsigned int issue_flags)
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct fuse_dev *fud;
 	struct fuse_conn *fc;

-- 
2.43.0


