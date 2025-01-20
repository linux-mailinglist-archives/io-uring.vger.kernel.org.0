Return-Path: <io-uring+bounces-6022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABCBBA16543
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 03:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30F841881468
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE880199BC;
	Mon, 20 Jan 2025 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="wUBuml5Q"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE67182D9;
	Mon, 20 Jan 2025 02:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737338531; cv=fail; b=MO5AamB2s3ww1l9vZ/lkoAm1mpip+xFekhfOE09Sxi2o/YrugqyFBMFAaCcdWmyWOMtYwbwMuN+rd65MDrGNw8lwgW25F8hGfzo6rTu0CcvnuFkUMW0vQZbDzHi3XNXLfEsZLQV0XfbsuA0o9lwSz2+frUdxF45SJYvAHW5RCVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737338531; c=relaxed/simple;
	bh=XaOAR0F2EgLfvpkxN5z224zB/8pEgoSlzo5zWOXVVjk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pyX9vKTplBAdjZJpvPbro6TW/4+W2P6Ny8fKWRqGBrzMMIJ8Wp4hn/W64QA9HqB+Gyhauxk9Apsrz/8nlUtJk53GfsrGFPELaPoaEPxoItaj9dCdHmW/XTsoB96f7POlGx6BlSFCtAqb0I++W3L4/y55gIyRi5VIN3C64/Xjzgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=wUBuml5Q; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42]) by mx-outbound23-227.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 02:01:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9kXTDVKxEXyby/fDV7DBD570Dk9S00plREmfwlbB7u0vpub49Gm+ihBSAm4RYUZ+BWmChi2yhjHtI89lBC6kQo5zSloEszEv/9vsPI4g3be5Beyz6PWBfSMwFgbSG9p1KUxKOnCJTuU12yqYz1Bbcmt6XkpcFrW/rk8AxdvWpsSq+5XwyColXgSSoDV4ESq8IRek89Lx6XFYom6kfAv8hTI1aaRN8L4JheL4cHbrnVQbh83cKohMWneaoMbh0pMeMkXzhE/ZMAeAx/z4xpuDgcMy+oMRr0g7TDNmNZh4alJRarAEeCgrsxinym6Mm6W1NHir3r0qVqzH3yQ9UgiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlSVBDFakK5n6WKcIUNkf7zDr/gts/fhzdsUjhAC3Ls=;
 b=Rd7Hya2zFLG0hfyvlt2c1RihIhUNxVenm9I3zD6w2Trcebq+4i6lKAG8lWFwxs/F7fei41G5HzbCBya4iXyiPOZmccTZWKG+P/d5NbaRBhrlNv8CMyapw9HcFa416Z+OGwTndOV349YW7QRRAFsx/+DBnKJ5sF/8m+POXuaVZ+cQGLlaUztFXMHpcRKSELks0Zojpl7TPbiuKJc4A45H+R6yixtT1V082Q6fg7+Z4oiZlRlZW43fjCDMa9KzgpDt8l6Elpg6+AUZGvsSNWPdYSYjKDTLxul6GGeWntA8OA4i5lvQTdoCSfOvvXqdC4Avf11TKDUFVMDKR9xJGyvM0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlSVBDFakK5n6WKcIUNkf7zDr/gts/fhzdsUjhAC3Ls=;
 b=wUBuml5Q+mcwBYaSl2HuGFOTHRiQwRr6tKCklPOZ1Ixgt7M2k3W6CjZF3ifAwsnzQIytwjwPdRdmRuLcbCsl/+LpXRIoepjtQGo55IdrhLsCwWXenPugSiwfheG/3n8W3qKjVpvF+PClWnXVwLI1FIdZAZdZQ6MRgMjtnOkK5C8=
Received: from CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19)
 by MN2PR19MB4112.namprd19.prod.outlook.com (2603:10b6:208:1e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:10 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::ed) by CH2PR20CA0009.outlook.office365.com
 (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:10 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A162D34;
	Mon, 20 Jan 2025 01:29:09 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:01 +0100
Subject: [PATCH v10 08/17] fuse: Add fuse-io-uring handling into fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-8-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=1729;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=XaOAR0F2EgLfvpkxN5z224zB/8pEgoSlzo5zWOXVVjk=;
 b=e0LQtvrVgGUCy2vFiSPBGWyUqeKBpvteTJsBKDqsZdqMYIchRtbJxTMpD9P7BLJpK1sWveLQf
 xYP+PXEUUjHDnsiC6AOiavytXR5bxS7vIk0PjkZBG0sM9UFv10rKkqI
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|MN2PR19MB4112:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea4ac69-d1e6-4a00-c628-08dd38f1d71f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R25KN0NONTVORS9jZWhxcTRFOUE5eGRFSnVmU0JjYVllV3QxRGhCOGR1SWZ5?=
 =?utf-8?B?aHYrajdMNExWcnFya2tEeFZuSEZIMU9QSzF2Q2w3OWNtb2FFSHRyNnUzTWZ6?=
 =?utf-8?B?NnhGZ0VybjVJbVE5OXFKNk9RTFBEZVh2akN5czlkSTByaEZ0elJ4alpLOGJu?=
 =?utf-8?B?N1JmaVNYVjVPbmxtUk5PcGxzbWdwdEhVODlCZU1obUJIUzFyZExMTkdVeGoz?=
 =?utf-8?B?ZmNKQnlTaFptMTdMdEdDQlRaYmo1Q2VML1Y4eGE3aUtJeklrVUpqSXNrK3lW?=
 =?utf-8?B?enhZcWpQK29JVTdpcTAwNXh3NTFVT2VwbkM4U09ZUHUrL2JGVlNHMytQWEVq?=
 =?utf-8?B?NGFHSTUzUW5XQnd1THpGRkRnVGljRFN3ZWNuSU9QaHVTVUNqUUF4MHVuVVVE?=
 =?utf-8?B?MWxuamhXTnBvN091MUw4aHVKclNqdGlxMnd0cHpKMTV4OG9WNnJYb21WWHFj?=
 =?utf-8?B?L0IveTM4c3pSUkhlRFFnelRZSUVWeXc1MklpZFhwdTZrN2wwRm9naDZUU0VK?=
 =?utf-8?B?c0IzMldKZUQ0L1BBWUk1LzRhTG9TbkIzanc3VEt1M2VVeTZYVGoydHdySVBR?=
 =?utf-8?B?QU5tb3FMRzNCajM1UHQ5QVR1VWdLY0hHS2VQbUM0WDlaQ1FMalNGeEpxcy9O?=
 =?utf-8?B?NlkwUmJzcm15WUo3d3U0NmNHTzhFSHE0eXNVRTU3OUl0My9BNjJVUll4UWoy?=
 =?utf-8?B?L3IxU05ubWVKcTdLZHdYRmk2Uk93Sm91VitrczVwdlhzaE1ndWpQdjJyWHEr?=
 =?utf-8?B?T0U0UlVBajEvRzdDRFIycXlHTWF6cmw0a1prWEc1TTcyOHBHY1QrRENhRGtB?=
 =?utf-8?B?dklzRnQrS3diVFBYTFFmWWJUbWVESUhSWjYzWUg1U3ZFNFpyYlhLNk1oQndN?=
 =?utf-8?B?K3dSQmE4L1pXdU9PdGlBT3dPdnhmSFBCYm1oUGFSZFN0UENiNGU4NnRNalRx?=
 =?utf-8?B?Nkxsa3BMM0xYKzZYVDVYaGo3WDkxTXh4STZscjY0V25oZFFEMkk5TTQzZllx?=
 =?utf-8?B?R2RNR2RZN3lIQnQwR0hUSktiN0kwVi8xeThvNFZuaEVObjRxbjlXWWZ5V09k?=
 =?utf-8?B?TjdBQ3R1TkI3SCtENWpUSWNKVEw1QnMrQndJbmc5TTZVSmhnZUlyeFduK3VQ?=
 =?utf-8?B?emQrU2l1TlZIZ0MrOTJiMU02QnNrYnlFSWgvb2tnRE5RNW1KcjFWdjJJa1dQ?=
 =?utf-8?B?cDFTbGQzMitXbmd2STE5VWRRODl1aEluclM4aHAwUzhnL3MwVGhzK1FXUmYw?=
 =?utf-8?B?V0RXSW0xemhORlpVN0s5SEt0T2VsWkYzcHN6ekdaQ3E0Q200ZVNtWTdNbGw3?=
 =?utf-8?B?d0trOHZKSTV0OGZYM1R2T1l4MmRRSTZScVhrbVBuT3pNMWFyRGJ5RFlQWlBF?=
 =?utf-8?B?WjJUTWlvOW43RmE4K1RiZDBlK3VRMzFhRit5QnNSb0ZLcENKdTNwdmtDako5?=
 =?utf-8?B?SzZ0MVN4U2VvUDNycS9SYW15b2RWSGZGdnNkQUwyNCtRZUJkcE55ek9oS2hD?=
 =?utf-8?B?YXZsdTc4U3ovWWg4RkRoRkRsQjJwZWxkOEI4MDZKNWlNdC8yMDF1L3pQQ0FX?=
 =?utf-8?B?WTFDK3RNSzBaRXhmemU4aEFFbWFBV0xwUTY4VG96aUdXN3FjSjROeU9Ecy90?=
 =?utf-8?B?S2pyaVBuQnI2Z2hLNVBRMEsxRWJwY09YSWoyTGwwZXYyVkp6bGhpZVd4TEJx?=
 =?utf-8?B?TjlrRWRCVXh3aGdsN1lCeitLMDVaam5xaWhjc1REd2VjNDVCbUE3MjVkUEdi?=
 =?utf-8?B?ODZ6akdKMkZCV0pwQmtOL3NhRFRiTDRXeWlJS2QycE5GUzNmay80UWhGQXNQ?=
 =?utf-8?B?RGlrU25IZnhxMEVMb2UwSGE2Yjh4WEJhNVRkc3grbno2R2ZTSEd0UGVvWm9s?=
 =?utf-8?B?V3hDR0RETlI3a1JCUnl1Ym9aM3FwUnczNTNYY2grY2JRYzVacm82TkFmWUlX?=
 =?utf-8?B?OXJFMFpoUUx5enZrMzF5M0ZiTWxHMGUyNWpBMkhnYWxlcVFyQ1FvWXdEbjM0?=
 =?utf-8?Q?GEPOtDcrP6ItMu1kXdG96NKbpMui70=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y6peLv3bHsnWdeBznvFw7W+QQSpeXmY86K8gbp5hwCcng01TKzcVXcquvAljmK7eIuDmfDpTHvBH/qQYFZdao305I0WnJtIiq6zh+9XUh6D/pctc5tJ5WiLUPMEwFZyxIDge317EfFriVs9oLgZzO5mgZTWhi4Ic6i5v1OA4o8uTcrPuuzgUcbpgFzh4rzwOqgQeq7bdVqB4nUHhLjPeCQKia3OdvQQnBpQUYF5D1huWb8SIrfdE8Pc7K3HZ9oYJmLZa/UU6buwjEPeE6QBYY7YvE59tQBSaMjsroqKBQTf71JLGZUPzwDWYEE4ws/x5tcuSnGNp/lc2qM4flLpQZt7Y9QXX+92ng7SGXm1Wj7zOtBukf52FnHyD3u0w4yqslnJqyx7qFhsVNZdUaLIKBGDTDYa9U+KtU5Sxv5hC894uH45IQawNxQ63FyJCKjG4Adm7TLxxWEdtOUa1JUCVHDPJ2FOzgQ+MGlHgKivU7PuwAPrNdBjKrfFHBOi94dfhsZVPlvJgyt00odTT2M7AI95a4GreCZnVdLF07DQumcJz/0AIaGp0ZoAu3D4FL1xDeD9Bh+sWU3eeK8h4Dqs8eHEJATu3U5ocxJZZKMF4/kOip1afFu/aATC2qwdklVPO6yCVPcViYiTF92TDjTrFvQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:10.2998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea4ac69-d1e6-4a00-c628-08dd38f1d71f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB4112
X-OriginatorOrg: ddn.com
X-BESS-ID: 1737338502-106115-13447-16000-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.55.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZm5sZAVgZQ0Nzc0MIgzdIkyc
	DAIsU4LSXVwMTY1DI1ydDE2NAozdBIqTYWAJ8J/ORBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan23-253.us-east-2b.ess.aws.cudaops.com]
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


