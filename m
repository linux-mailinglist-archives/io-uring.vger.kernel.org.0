Return-Path: <io-uring+bounces-6013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E49A164F2
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 567891884174
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53A378F45;
	Mon, 20 Jan 2025 01:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="BNwwba7y"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB811BC20;
	Mon, 20 Jan 2025 01:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336573; cv=fail; b=oFWWPh1BOxz5e252yS7ooCgOzMhXx4NIbm9dcHDoVcDMJquzLcZApZhKeAhRJnvNkT54WL+UGoWMW3HTAkBNIx304vpX6Ho7I57AYWD1PoH4HdYmfn/ovKdOo6WASnK/79/8FGl6erQKRV0RD06wmc3M0j7dunbO08nD2CgFsp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336573; c=relaxed/simple;
	bh=jThg05zJUL/eUd1oNdbYL3LkPpFfiaUWamdr4PZZXsc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QsJZK9LUUNgczPwEIvJQaVmAkA5yKDsas6BNSvGlw4xAbZeIVd0beKuHSXqpF2VjR2eBvcRJEQ6+GwTQpV6B5WkYE7yce7wbJh+ML29OLeLGTutVi84Ywj9gNY3z2JJRzmQyWDGdAKeMH72M3uCecmokiz6gUxgjI2kKHltfFqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=BNwwba7y; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49]) by mx-outbound-ea46-177.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XcN1CDFkUG3dpQA/B8smrnziyjNUDp06IQ3fb/znFVZUGhRdZVGGAx4bO96jSD+p4t9dI3boA0ozSnPTkN5DWrpMTZySnqn5rZwIAcpVwXDoBc2jsJH2Ekj0IWZl6xBx/kKik4Z5VTK9QEYtH6C2DbrasshNlHFswdjOGCLsxjVhhZWn+gfuBBkXAAbTSogyGFtp5WzdpBcbwyZebUipy2fbih8BbygqRuKHIS6gA3Fua/vneLcAe9Ard/cKFHhqmQfMu/rnm+bUCgFi6EWbtiaHaP83OMu5OJtTGYKlzJQnu2EYJ+aeOAdlTk+7nospljMgkSuYpAaaDnBcmb27QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGn5Rqedju/4N1gd+zFusbMwFN7UcIdy62aqJ6ESOjk=;
 b=wvGZopFnRAH2MfdKfWqgllI72IndtG2YxQmsKcyPp1sKg10+w3QLpIs5YV9THOAk7zpsI2B1ABV1fjIxL8vr6EU8gdu0Igam6y1rLsgcEDvujInTi5+IGm7SFSqzZ2UkWcaPJCg0JhyrgMk9GTigX53hk7LqCXSa/g1FcoAiOynpczvnbzkV0z5J8VB92wi5xOA+8GtUTiZx4SZ0RmFHaeAwgLzYVhoqTJQPqCKVhReJZTj1lQpylJyA33x9o0C07Lv3yV8hVJObrYYLi1Fguc9k752wI6tjbetOncZrbcAR8Z2wf0hM2DNJ0hP5ez0abJertlOcXCEQA80PX03Q2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGn5Rqedju/4N1gd+zFusbMwFN7UcIdy62aqJ6ESOjk=;
 b=BNwwba7y7CKKdG91U+NYkTzDqE+82RI5Xvtj1gQGcpHBeBy/fgJvPlPSIfND+i+ZCm1YdGO0dmltMwolS3Gp8bFTVdExXK94RzgsPYgo2irdAdbT805InsBovImFPPh3T9ocoKg8w2OWzyuUH+0Al+oqCs6v7QZW7XKBL62Dvxs=
Received: from SA1P222CA0177.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::25)
 by PH7PR19MB7148.namprd19.prod.outlook.com (2603:10b6:510:20f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 01:29:08 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:3c4:cafe::84) by SA1P222CA0177.outlook.office365.com
 (2603:10b6:806:3c4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:08 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A898B34;
	Mon, 20 Jan 2025 01:29:07 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:28:59 +0100
Subject: [PATCH v10 06/17] fuse: {io-uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-6-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=17119;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=jThg05zJUL/eUd1oNdbYL3LkPpFfiaUWamdr4PZZXsc=;
 b=VoxHIB3w0KlFFFJzZ5bNSLmcxw+1RKpjjw8XatoELKJFU7UlUPIanm4600lzR91NauZRmb1sX
 eHA93CZtsmoBPS4T1rRCxZKW0vJW0eCrm4vGDF3C8pCTkMcNClqBn9m
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|PH7PR19MB7148:EE_
X-MS-Office365-Filtering-Correlation-Id: fb2ec544-9e31-4e0c-ba3e-08dd38f1d5f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHQ0Ymp2djI2K2xyUHhwd3hoVnVWSzhacmxxMjRqWlg2SC9aZ081TzBqeHQw?=
 =?utf-8?B?Ris3eUhJTmpnZWFGckpSSS9ENU1Oc0QrelAveTdsVmpKMTRobmVXSDkzRitY?=
 =?utf-8?B?UElCZ3JRaHc5TU9VN25RRDFaV25hKzk4MWd4VXBDZlpncjk4Z2FrWXJxOWdv?=
 =?utf-8?B?a2xJcDVlOW1lZERGQTZ5TkFYbDg2UjRsczcxL3lZZjltVjhnRWdZeEZ5aURF?=
 =?utf-8?B?Y2VkSWhHZFBoaC9IcG1nZzViY2dpVHV2TlovajlMeCtmenJMT3E2TzN3VnJp?=
 =?utf-8?B?TndRMk5LRnBrNkczQjN6T0tCWlNVcnNxZlFBanBHem01QkJjRC8wUm5rMzA2?=
 =?utf-8?B?WDBBc1hKTTREWkNmWGtkTWhKV1FIU21kdDBpeGJXdTEvZExoT3ZwNTNWai91?=
 =?utf-8?B?UUJKZTJjd3hPUGltbTEybDdJVHhDUDJmamhXQTFhSTlFVDJ0MUVuRWc4akUr?=
 =?utf-8?B?VS85WUh5WEpBT2REbXhrU1ZRclRFS3lNUG1jYkNiNEhZM3BRWmpsSThhY005?=
 =?utf-8?B?UkZMY2lXa3JCNFd3R3lTVm55ZGdNQVBtZ3l4TXBCVm53bTRqMzY5c0VBVHBN?=
 =?utf-8?B?bzA4d3hlOVQvc1BpM3d0TlVBcldMenB1WFVTa3hKbkFGRFVkMElueEgzTEZN?=
 =?utf-8?B?Z0ZjWExzbVplbmNxRXp6OXdxR1A0NVlPVnZ3bTBaMDZrUVRZUG42eWR2aVZq?=
 =?utf-8?B?eWRLQis1WEs4Ni9nNkFzZ1hab1F2czY4QmlrblhzdzhQcTZoVXh3YmlSbjha?=
 =?utf-8?B?T0tJYlNzWW1Fd29LUXdyYWR3ZVZaTjRwRHAvRFI0R3JQNmVTakoxSTZ0SjBx?=
 =?utf-8?B?a2dDKzkyOHVKYzNFcUJLZ2U3eUYzRjA2OUZpbG8wY3dyUmZnMVBGWXBmUDN6?=
 =?utf-8?B?K0dObWJiZ0Fhc25tSEpNQ2hZbTNXS2NNUG5vVmM4c01mVERBbDkwTE9hcGNr?=
 =?utf-8?B?UVdwMWN5TGFUcEtnbUt0MU9oS2ZRbCtaUGVrOGJXcnhWUmVNL2ZwN2dMWkQw?=
 =?utf-8?B?KzRQM0tYYllZNzFaNjg4cDR3S2VVbHFOdlQza0MxTG05UnUrK051ZzNEelpW?=
 =?utf-8?B?dndFSmdyU2MwMlkzckppVHRIdm93R3JFRER6aG8yRGJjT2RBUTdtSUdsa0Ev?=
 =?utf-8?B?MTRFSXBKZ0FoL0tWY1lxN3RnbkdtV2lLdnlhMSttei8yajA3djJwQU5zWTNQ?=
 =?utf-8?B?WEZMcjZXSFQ1c040anVlWDNQZlNvQURxKy9VRUsrU1ZldUlmOVdVYWNCVGdr?=
 =?utf-8?B?cElIdXliMWxkWmFJOVJrdDVpZUFHTHBTT25nVFBhb3dEY05halpOQ2hzK2tl?=
 =?utf-8?B?REVHcnNFWXdEcTc5SUpUMFc0MXA2d0xsRG85MGpJSlpoUW8zcC9UUmpMb3VH?=
 =?utf-8?B?MTZ3WXBmcTdhS1IvWHhOQnRqOTZMMlpucUk1VExBZklMYTI4QlZtUkJ3VURw?=
 =?utf-8?B?OFZCMkdHQXNVbHoxeUc1TEtqN1JYSlQxa3k5akppajdxLy9saWRweFNrOHNC?=
 =?utf-8?B?a2pWQm11NE9GU3l3N1hIOGU3SW93Y2hhOFhrQVhsNjYvMVd5QkNWWFJNMits?=
 =?utf-8?B?bUxYVVhFdGUvMDVTaEl6MFNkRDgrM0kzeHRnd0Z4ZWRwVitsTTR3SnF2b2hC?=
 =?utf-8?B?YW1kRHl2MXZDanZVZW90R21BbmNXQzdNQjQzbWE3SEM1UGdadzJpdVVnTGp1?=
 =?utf-8?B?R0xTdVlMb1hPZ2VxL1lRbjBKaGZRbUpUVTVQNjdFaFB0bjdtN2pBSXRhOU85?=
 =?utf-8?B?aVZpLzY3V0RDZzVRYkRrT0dna1ZVYWlUOEtNbUIwNEZiQWZnTGZRN2FaQlBB?=
 =?utf-8?B?Wnc0RjJOY2RLT1ovYWdjaWF1ejdUVWZ6ZCttNStkWHhXUFFla3dReHQ2VlJy?=
 =?utf-8?B?WXBDczZrcHkxakd2R0pROGV1dGtZMWhaY0FCYzZQalZPd0VseVV2MmtIMkNC?=
 =?utf-8?B?YTNyMkRtcG91bm9ndmtBbC9QbDVPS1pjcXZ4K1FWb1BLbnc1K2Jad2pkblda?=
 =?utf-8?Q?SzqEzDCttjmgkFQ7xfnBsbjI8F1JQw=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tlmg68nTstf6rDWI/S9XhnSEpII0ywx+Awmf5wOYDQeFn9N2mKJd+2LPKrOv9XTYfJJuJTE3qHP4ApkPdEI24ZdGLyDTZP8/y66O++90iVtjC1yehW8J5nUjHhBE6e0rg1Aq92hTQT2bfxX4umk3WdG8aVMHyHCcSP4Mdsq/orRRA0b5OoEygT1q21RnGk+MwAuUs/EKqmSz/tlbgJH9vXfs3OW2jVEXzw9MRLVD//Fjb4xNKDKDELKrLh95IxEtm2DcpFUb6LcOHhUSurt6NAUmtyoc/xp9mlZ7d0Vc8cZnE6MNYYngONYX6BbzDTqPNJ+DaaD4lqtLV42sJ5lKeSgx3B73oMOqMUsoWS4XKR+mJx8R61DCV0V0Kcbs5RTWdUBH/6vKOwf7FQb+rAXJIUeasCmRegm6n9d53+l0xFcMriXicL+xV1vU7XEe5TrUm0BJaAANW8LKtqwqA1Xe0guIL6ievYaqGDrtaUtS3MNzqYXHdGCfHtgUPj39IzvC0cWkqUW9XOPXJ3NyqG164GuSph6zKBem4Fu9cbst0pcND1XgsLoBZ+v5Qg0fJFCs9TusMmdtaqbBxdsD7X4yFmgtY5/q54dtYfcRiHdskNOy6oveip+ucljYSJhlQGKCtzxNkA6lcIpuVIyv6EVWjA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:08.3309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2ec544-9e31-4e0c-ba3e-08dd38f1d5f5
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7148
X-BESS-ID: 1737336551-111953-11879-196394-1
X-BESS-VER: 2019.3_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.55.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmJqamQGYGUNTE1Mjc0NLE0s
	Iy0cTcCMhONDY3NDY2NjQ0TklNMjFQqo0FAF9J70BCAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan20-49.us-east-2b.ess.aws.cudaops.com]
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
index 0000000000000000000000000000000000000000..60e38ff1ecef3b007bae7ceedd7dd997439e463a
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
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
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
+	err = -ENOMEM;
+	queue = ring->queues[qid];
+	if (!queue) {
+		queue = fuse_uring_create_queue(ring, qid);
+		if (!queue)
+			return err;
+	}
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
index babddd05303796d689a64f0f5a890066b43170ac..d75dd9b59a5c35b76919db760645464f604517f5 100644
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


