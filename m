Return-Path: <io-uring+bounces-5711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C733A034C2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30BD716424E
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B801C481A3;
	Tue,  7 Jan 2025 01:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="wA/vXoX0"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B32C6A33B
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215163; cv=fail; b=ZucEZgOOJmEsDXONVB4FULMPArGtNDoE1DN696rGVfwv6/s2avuKzyYdlx72JzB/nRjUPPmKSfC8ZcXgdiZ2RHVttVuvkCnrSr8zlH/pAJ1rBh2eN+g/O9KtQOGxfoIUWYpdMIlJfcYrzE4t6OONhbQ8Feq13Btogq/5os4D/aE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215163; c=relaxed/simple;
	bh=bH7AXbAgM9O8WxYv19f8qiXoKWtYqGZmQxByq03RmGI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e0ZcHkQyLzSj82P2hcwhHIeKUT9xtnx/lG9bMoSsrGSMuxubv5SVbIBo2Fw4mzZZJAFuJsKzLyO9M50s5RTJ3+l4vFjztuTQABV+GFFStvOup0bK2QvXkuRXU3yQv/5qg9FW7ngh0mrbOLseIxUA6oPPwlSAsVoh+SnBK8uiwQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=wA/vXoX0; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176]) by mx-outbound18-108.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PkU59i9LlJT7Pmqvn5+qutW8lPFBd87m+t95cnKtXAPqYovF99ZKSrWLg2gG+J8v+XQAA7Ki/3o+5ImI7VmWpwgxdvP3Oc3eQoiGl935K5Hzs/4FJRo8V/U03+SfN/ta9guxAOpMbrlOofWFrIYkEsZCfM92MBVpM+ivq1nog+xH+yt/xmj0pDpmRNXkvTxlUQJUhYbik81o7kh1k85F6n6xMz52O/fKWbY/q7NtpTzgEg02dOcxAgXbA2ILeTT1wn0jmGKE67/qN3OHy8R90pqCneLz7d8k9b3ftg1L8BZYfuBVHivKmsn5QwlBA0r2YKolqqiy4PgMEMha2bla1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJz3+THbXTIKY43167MS2efTc2Qn1MdwFPpXT/QQ29o=;
 b=aCYfAxbSXSFaFHs3djuNjXco8rluC9zfxdshlYvhVD+hR3NpoI4qcryRojuRWCyqHwOOVFfgz76NjObfvf7YTfCNMdxWTBFihRg4OCqubIcFz8Wy9o5iiSKGxulwf8DzxuC2eyQQQU7R0NsZvHtt7aZjrBnPR9Wb1P3BDt9a1PR9YlLnkp4vWdR1hfIYLvJoiop8aeQ7+J3EUggGxWBygeIMkvbU0PBHmn1JLvuiwMH8vtjWGix5QPNU5O2VYGDyoGT9usHMMLjKtGUXMhOy+Rjjn4cGZO4zKaGWsd3yvzvdPu4cdrjKhhynsKsx7IZLfVnCOW9yzXTDpYFJfQvD+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJz3+THbXTIKY43167MS2efTc2Qn1MdwFPpXT/QQ29o=;
 b=wA/vXoX0c2j52qWTrUJAXTUSYzFU0JbOWyCnzQ57yOlYLZgCHnu+ABb1z2uvy4Z8yO1UUWXcf9WcTExmBe/D615qQYy9NhlEQajh58HFmyJkwrQ0fV2kuDBD0NLOqdp4hfc4vivM/Tqibaaqse6auQR7u1VauaYfAjuXRSj8edQ=
Received: from SJ0PR03CA0167.namprd03.prod.outlook.com (2603:10b6:a03:338::22)
 by IA0PR19MB7728.namprd19.prod.outlook.com (2603:10b6:208:40c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:14 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:338:cafe::1d) by SJ0PR03CA0167.outlook.office365.com
 (2603:10b6:a03:338::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.16 via Frontend Transport; Tue,
 7 Jan 2025 00:25:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:13 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 47F4F4D;
	Tue,  7 Jan 2025 00:25:13 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:08 +0100
Subject: [PATCH v9 03/17] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-3-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=1370;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=bH7AXbAgM9O8WxYv19f8qiXoKWtYqGZmQxByq03RmGI=;
 b=1ZARQPuG3fSArHLuWXpb84n4hu0HBRmK/YZFjXtXdinpmZtdhrfFJzyaDiaO8GaWCbHiCCq/S
 CpUVDFB1XXyD0FbMM1K+Q7ky6oVi1/arbhEN2nqS3lNbcIHh04MW/58
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|IA0PR19MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: ac105c4d-4df6-40fb-9d49-08dd2eb1c116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDRiWW5ZbXpnUUtQYVNkb3NhYmNyeGdwcVF0SzhSSlZFbURJa3dYYzgrWFh3?=
 =?utf-8?B?S28xQldpN1lMS055Q1dOMGZCZnVDalQ3RW0va1ZCRzVXMFVEaUFxb3JQcnVE?=
 =?utf-8?B?VnRTSUJhcXZHL3hEbWllM2hJZjNtbWluVWhKSHVmaXZTK2hQN2xFbEpub3pV?=
 =?utf-8?B?NnlSbzljYXdNN0pkTnRkdWp0bkxZNi9xTGRheWxCVG9XdDR3a2REQXkwRHpS?=
 =?utf-8?B?ajJzTU53VTg4TjFGQjMwdnNiYnd2SUNOT1l1NG9Oc3k3N3JSTDd5NXZSWGNH?=
 =?utf-8?B?ZEg0TTY4c21wT09WLytFK3RqVVBsNVBOSkpYWVFLQ25ia2FYcjdCaHNoTmFl?=
 =?utf-8?B?MU1ybXg5cUVmUFlEanZBbk1BbUNXVjlOYXNMVk1hdTJPaVhXUG5tWUxlSlRI?=
 =?utf-8?B?TEU2YVJEdTRxSm5TSGxCdS9iTlpjTlZ1N0R3KzhXMUxmanc2alRWYkI2SlpF?=
 =?utf-8?B?T2VYdG1zWWdmSWRSVURkUm5HRGlPaWpIVFdEQzBiSlFMTmR6NXBsZ00xdE5n?=
 =?utf-8?B?WEx1aDcvTnJIcGZZVVFzS05oK01GSU9XTS90YXdnSmN6alZVbm9MRUNmVkw0?=
 =?utf-8?B?SElaZHFjMmsrWWQvSlNqS2xucTAxS1JZUWszN1pmWDhqOWgwSlEwN08wakd5?=
 =?utf-8?B?NHRGbVNUNStQMzUzTlNYUSt2d3hNRG9QNWk2YzJ2TWpOcTV3VzMrUU15Rkp2?=
 =?utf-8?B?WVVYZmgwbHJwaXJscGF0WE9LcDYrMzdiS2w5WnFlYVBPQ3UwWjFjUkJUUVNX?=
 =?utf-8?B?c2xiaERtbjNhTU13cExnTTFaTGxQOURXTExHODBxRXVZZ3hQNVY3aGFyc2R4?=
 =?utf-8?B?RWU0d1BnNC9vcnpOcmZkSFF4VjJhNEcxbG9ualk3VDZXdTBWZC9ISjdXVDd6?=
 =?utf-8?B?VjVTMVFsc1Z1WGUxRkNiL0o0MzN6cUJMRFRhcldNcmE4Z20wTzUyd2Q2ay9T?=
 =?utf-8?B?dytkWGgxcHBXQXl2NnhzdWhiZDV3bFlxbGgxYy8rS2c4eWpHMUJqaG9qZ2V0?=
 =?utf-8?B?OStsZDRsVlZNV1Y0TlV0QzVSRS91QnI4Yk53dEp5c3NWYWxWVHNWZm1iWE1i?=
 =?utf-8?B?dFpQNE1VNFhjZkZ4aGxvcnZnM1MzZXlyWlQyNHJLWnBYVC9SdGRwQ0VKenQ1?=
 =?utf-8?B?UUFubmg5TnFMcC9McFlRcnllNVVja3JGZ3I3cEJiUXh3c0wwUXcxcjVGaFNp?=
 =?utf-8?B?ZzhzM3VnNXhUYTFLRGg0N3FuYklWTmVwZjB2Q3RuNXRuVXBOMTVaczNQYkx5?=
 =?utf-8?B?OFJPa3JpWFRBbzRQdVBCWDNCL1M3NFdnR2J2ZmR2ODVON3IwTElkYWtuRFB1?=
 =?utf-8?B?SHh5MzJWYWNQQUxselJKSFNGeHVKSHFpUkV3ZlN2YmZWYmZZUHFYc0NXd3VO?=
 =?utf-8?B?eFdOU2htN0xrc1Irdytnc05QVEhQVGRaVlduTUxvaFRRSDRRbmpPZmV1K3Fp?=
 =?utf-8?B?b1dnWmIzc2RSTGo3c3pUOEJXRE9qUUE2djA1YVR5Ri92YmxQT0FtOUJNd3B3?=
 =?utf-8?B?NW9rYlNqeE5CVVI2aFRSclJySzdTMUkzSUtVTHNicmE1MGJTOTdrTnFEUith?=
 =?utf-8?B?OEdZd0w2TXFWWGo3UFE1aUI5eWpPeXp2MXVuWS84WEhNMEVWYWRLSWhNSzY2?=
 =?utf-8?B?Vno3UDVBcVVvUjhwbE1FTDVMbGxPekFyMmMveXRiT1ltZDJFMThOZHdsQ1Q5?=
 =?utf-8?B?M3puRCt3WXVvNWNpU2RFSzEyMVkzemlSWkFmNS9BeDk2QWlrem5GVXFjTjh6?=
 =?utf-8?B?M1RYNStBREp0SkZnRHdwUEtRY1pyTkZwdk1zL2lqRVk4THpmUUZ1b2lVS242?=
 =?utf-8?B?dk11NUhTN251Zm56WlljV0VpR3lWUWhRRXpFbkpsek1jZm55WkJobW54RHdu?=
 =?utf-8?B?VUdMU1c0QmVjK3M0ZXZER1BQRW55dXJHRWZMWG9zU0w3Qk51bE5GZGJiTWUy?=
 =?utf-8?B?VkJud3BBQWk4NnA2TjRkV1FyZzdDUnVkODI4QzJtZCt6NU16dTg5L1lYQ0JQ?=
 =?utf-8?Q?PM+vKDsha3B56bndp5ZURT94SOZHec=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uMDz1xTKZwe1aScBy7TnX6CZ1WVmFuyATpLCOG8Mh91k9Ooc1k4tlIjqCHpA3NjABps3gzHJ6qhNuDMga6q7vcjbJdUx+B8bp6mEnAcDE6HGFOskv0ZZDDD/0ay6x9zRmYMnAMxSMxDe4d0FSu6VE+pWa9ZbAYbsIKoE+7G2qs9/ikLN5YOUQsjmMBZZi1Tdo8oEIwceKhz59GdhNFdtTQK9YR9UEYRuDYzhRAz05Sx1yKrJeHm83PWum6vwyt0Ouj8EbZvW5OGuSKQzTyOSDnnfuEUj+HRIk96XuENUsqqrAWSbcQkbTMFKDTwHDekonzmcCIErIIGCB0CvSaa5yMBZmdjAcpjdZ/+tEuTlC5O3JbkfbIRDlXHT2PRvVOHSsGRwcx5NtnK0aXEpqyXVgQFTeZv7wyDdHyQVYz7hqRYiMyHekdqTrh6h4YOUc4TTvMpekDNZp3dAzTixY5I2/l7Mmgvw1tQ1SzpfUdDH2kXb8GzBelv9XRt0QpUSFHq0X6DxSRTxxloITGcyNjjZr1HTVe1PrP+PrDjF4IiyVbfzdmZlg25pnKKjehRJMbsqcqisPaJrve5bSHHPBYbITH42KWoerGmlUeFnPOrVxFhfnhCVLbESWrMpS7FZn0L3eKS9Cx4TxAFDiKN44Q5ImA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:13.9114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac105c4d-4df6-40fb-9d49-08dd2eb1c116
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR19MB7728
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215159-104716-2774-3306-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGRhZAVgZQ0DLFOMnAwiQ5Mc
	XMyNjIMsnEwjA5MTE1ydIgycLEKC1JqTYWAJk6n8ZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan15-9.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

These are needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3db3282bdac4613788ec8d6d29bfc56241086609..4f8825de9e05b9ffd291ac5bff747a10a70df0b4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -29,10 +29,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e7ea1b21c18204335c52406de5291f0c47d654f5..08a7e88e002773fcd18c25a229c7aa6450831401 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


