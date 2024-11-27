Return-Path: <io-uring+bounces-5074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D98559DA8BC
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CD98B233DC
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5E01FDE1F;
	Wed, 27 Nov 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="A9qcTsJI"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1571FCF45;
	Wed, 27 Nov 2024 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714864; cv=fail; b=F4vVMlC5QTSn37j/LHatcDVsFdaS27c6v/FyX39t4tg5H1ikjjaEXjQ3EVRr7zLYNygRfYkzxB8j6MlytRUCNrok2yaf1+KuUmth676GsLj1Oh3vKyG4UboQ+yf6oUnIXANDWegVim/98u3wldWxkEqkfctwvLubqgfkpYzHJwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714864; c=relaxed/simple;
	bh=FP4kaQrpOhGoijBglp0kC3Poxw+CWk9aCgwJwUICPEU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A9sNhLAjzi70hNzzcnrR0ji4ZKPtNL35FaqQvCoxkw1bVM6b0AT6Xqjk+mb9T4HhHcLEp/MuYtWKVpqIxr1qsXthngXEB7kddhu4oytRvAkHd29SJMlpGX+WAnQ+bC0sA2TVns9iO7rYCb7cqnzKkgPJO425ocwwlTJrZ9HiGpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=A9qcTsJI; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168]) by mx-outbound21-113.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpwRcEncA2b+caKA/WCbBlEbLC2/0dC9Kkz2Ya1FheRTqs23Zj5Pe/vk8iypBv1ZOx3EwhLXVTyaFUDKLwPNUM19zYWC8+7+U/uajblKJ50ganDiE54vUHwVPMgmZgQZFDktFMUMM6s8ifN5p2XseCp6427xuGc7u9hA0NgEscQISRQPf43U6YR9zQt6FKdepLC39WhPHuDKR+Xpx2aF7rKk+SP2bGnyJWKQ0qfiVMrFZvcoy70DigWkXOXMDI49vgoQJX1u6NQR/13r9LxMLU2tBoFnGOsHXMeOhCv6hlVOSqZHGXKhRYrYUhkHySjyz3dbz6H4PODDkZQ3glNpAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DflUWVFNG5DdHkfJb4MR5OPuglwmiwARfvyo3IAeyDI=;
 b=hXBx559NK5lT8WdtJj4WwjCrmiIuTtDuqoVZWNqKOLDGLaE7QmIuk4IcHBw4dgh4xZErziJZfm48mKpH2lXVz6mVvocu5c0Kteqv4CKcG6dFeDgAg71iClKcbg+sPUWvmA2Vy9jVH72rUI/Dm6YmF/6EgwgMwKaJHVHtygYlrpcponEFwcFrc0MgobQA5tJWEj0GLGGnKh80p03A3cN6ueVkdY5Sa7P33aYsTThUK/Hsk7PB0W2NYNZfPmy+a8S24RaoKOINuN6nVUjuTB6OKZT8aMPrLBFWd3EFxdmlChmKCDfHaNs9cCfreUEUnxWsXV4gIJBE+U9IhCXKkZq58A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DflUWVFNG5DdHkfJb4MR5OPuglwmiwARfvyo3IAeyDI=;
 b=A9qcTsJILlnDSlIVZ6tpwiuSbDWWDjlMLNegC4VL5wYNXPGKuptK98QnDW5eNpgvj6mmo8MR9tDctxAbYatK8vQFYKwqwwD+pCdEAs6oYk0iwAoKmVT3eFAh/8C8OtfletfB9MacOhH8ek6SbYUCh9ohfBjWv0WDROABHhmHbtU=
Received: from SJ0PR05CA0168.namprd05.prod.outlook.com (2603:10b6:a03:339::23)
 by SN7PR19MB7817.namprd19.prod.outlook.com (2603:10b6:806:2ee::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Wed, 27 Nov
 2024 13:40:49 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::60) by SJ0PR05CA0168.outlook.office365.com
 (2603:10b6:a03:339::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:48 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 14E022D;
	Wed, 27 Nov 2024 13:40:47 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:26 +0100
Subject: [PATCH RFC v7 09/16] fuse: {uring} Add uring sqe commit and fetch
 support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-9-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=18145;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=FP4kaQrpOhGoijBglp0kC3Poxw+CWk9aCgwJwUICPEU=;
 b=xzG9Qr0v0H9k+Qb8MO0IVwbiY7edd/VZwGPAyAP+bgGqXWpdJ/djMxCec18gxJnIhM8EOPAX/
 fDf9t9F15ucBvVF070WE2SAnREQWZFDeuWaKcwpeVMILgcI+pOhZC3+
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|SN7PR19MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ba7d59-088d-4103-73b2-08dd0ee91a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlJvaXAzMm5sL2g3OVJLSFlmYUdPc2FDei8yVkpXQUxuSTZ3anhGaUpLeUFJ?=
 =?utf-8?B?b1RSR2tscG4zeVN2NHZoZXJTQ1BsSld3TW9oTW1WVXB3U3pGandOR3RhQVVw?=
 =?utf-8?B?ODNRYUNjWWRVQXFKU3kvK0FmVFBUaU9Id1BHd2FYWkpCQWJqb2FidWpNanJ4?=
 =?utf-8?B?aXlWZDdQR3FhUms5VTNMS1pGeWRsSlQvdlJibGg2WGZ3eElLTFlTOEpaWVd3?=
 =?utf-8?B?ZmZ1NUNjazZhTDlpSlR3enRKTllPa1MxcWhSblUrZ3ZJYUdmRm5lMytKVzF0?=
 =?utf-8?B?bHp3ajNwK09uTDZ0NnhjbDcralRZWTB5WTNxYXRobkFvcUxpZXhBU3VINys1?=
 =?utf-8?B?NU5Ia1hVNElUYTRXWlViL2FOUjFQbUQwbC9oemlHMldhSHlMSmF1eUpFdXdi?=
 =?utf-8?B?Q2tRenlPaGpacUxBM2JFd1JOWTJRZDIrTklUV2IvanFtZ1pqMWVBRGdpOGxV?=
 =?utf-8?B?bm5DazhqOU8vekdPaGFLUEFjRlVHWm5UeFEzUmVYbHhKWkgvSzU2RFhkQ1dv?=
 =?utf-8?B?Vk4vQkRzR0daaXA0dEwzOXFWOXk4V2Z2eHdPWDJLRmVSZXBaUE8relRYTWYy?=
 =?utf-8?B?OVlJTk5XMmN4MW1SSEtOSUVuMWx2SldveVdZREk2eWtzMTM4Wm8xajNiblVE?=
 =?utf-8?B?SC91ZlN3RVc2bFQ0eHJqQ21rblRzN2o4c2tTU2FqTmRYWWY1ODIrNFZDRFZR?=
 =?utf-8?B?bUFrUm8yN3pNS0RKdVJmZ1d2WGRweEppK2YyRDhnZ3A5VytrWTFxaEtXcjJh?=
 =?utf-8?B?NDFXdU1oeXlBUjJuRHBZNTgwdmFLY3U0c1FlWFZVYlNycVFPdFEvTkZOWFRE?=
 =?utf-8?B?NVdiZ3k1Q3h1RUxQb3VHVU96SkFHRUhrcThYNkUzN3I5OEMrUVpRSENvMmFN?=
 =?utf-8?B?YnNseld1S0dFR2RUSkFZWS93YWNpVnhINzZQcmp6U0JtNlMvRm10Zk9CZVdk?=
 =?utf-8?B?T0J1a1JyaXlzMEJPQm9iYzd6ZWN1bE1pcnNNblhNcm15SEMzWGJPSUM3VmxE?=
 =?utf-8?B?L08vdjRIbVBValkzSkhpaUxmQmxjQUI0ZEdoTklKR1ZIbXh1UzBZMkZsRlFt?=
 =?utf-8?B?d0thMU9PaGh4cnU4aUU5dFpKMjYzVDdRUnhkSlh0MFVjc0lvQnIyVURFczd2?=
 =?utf-8?B?UjYya0tpNGJDa2VrS0tmOTZmYVE1ODZ5VXhWakY5VDhwOEIvdDFFdEUvNlBm?=
 =?utf-8?B?d0tRK21admZvZjk1YWRLZkZnNTJqMzQyQlloNUtOU3JZNnorOWVSQmhtS3g3?=
 =?utf-8?B?L3pwL2w2ZXA3YzN5a3ZvTXFRZVE5UUhmNEl5RW9mQ1dTUGpSS0hoYXVUS0Vl?=
 =?utf-8?B?ZE91ZFArVFVTdzBTeTVZdDZDUG0vWXZnbnA2b2lWcjJvVER2bkp1V2tZNHA3?=
 =?utf-8?B?RHlpOEJaUXA5RlQ5czZMT1BHQ2xJNkhVUERZc3crM29xMzVKUlk4VmJRNmdS?=
 =?utf-8?B?UUJNellEalc0Z1c2cXFNQ1VJTG02Nk52bXQwQ0U5WVBKZkRGQm9ONVVXblQz?=
 =?utf-8?B?aHdhWnBOTkpFMXBhbFNETWg0cjZZT0hHdVlnbElnVUs1WEdtQ0hsRDFzL2ZS?=
 =?utf-8?B?V0lKMGJWT2d1U3U5ZWRLN09LTXhaL0xvMWFSZE5QRHR4OEx2MitZUGFnZHR4?=
 =?utf-8?B?MWEwNW5NeWJRaFlIcitubDN1YU5VSTBDMHBGWEVMc3JyNXhMamtkTDZFak15?=
 =?utf-8?B?bjA0VkswWWNtZU1RLzdMMTNuUjBERnhMVmJaNGUvWVMwdFNBWTVnai9wdHdY?=
 =?utf-8?B?K0NlZ3J1TmhTQkljay9KcWMxS0pHdmJ1K1BIcjQ1SVRkclFiT0t5OForZllj?=
 =?utf-8?B?ZGNPTndacndycXhraDJtS2JyYnMwaWlIQ21sdnFDekQ2TjRnTkRDWEdRclov?=
 =?utf-8?B?YjBaT0xidFZOTngxUWMzenhCS0RMNWRyWGhYUms5dEJUVnhYYTVUZkRvNG0r?=
 =?utf-8?Q?0whwQs8NF8a5b8wqnEgKbTwP8ZokHuEa?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cGsltAR4SrIeGBDIvJtrCrDN6pcyBDL5Own1/rzvSSP5/QHmu9Ihs0w9bhjSvE2TIFQt1WPH8zOv6pLkRQKNy2F5JUvQnn5AdxutRolr+Hw/cXicABeYyH7BChKlShrG+6TC7rNWWK08DMyLzyjT9/w0ovvZVeTFxAsUvfHRMinjb1hjlj123QYlXUMKObvJavnBDdMngMgBWGjwMlyzi+1GicsNKW8cSf5v/ZYQUmESBx5xM0SqCv7TjjKvIeEg5jKsG+MnLp28r8/wfHH6ykJ0tX0tipWY3Lo4JeiT3XcoHDGrZSYBovbsAqAngWRV6mnLOGRjdbBVO+v/WfGzQsWPnBtCB4yKlA+kB5C10XxuVrHF4Hi+H2sJ7Tr3Nb0OA/vin0vQi/CUZpb0nfgAclvhVJw9SZzGvy6NDZFsRHGtgAJ1E11U4de79oUOGHxmCRmWKCp/TZFjVZAgo6IiGtznquoE4ixxx7M9HHN/aign8LcIh15IcSGanL5yBCKpxnfcRk36ChdqODs6uHLMzLLNsAHJym3GE27WC212FawyLb874IAWxGjuJ9juz6MY1QUAnPiRET8Y52oAPQd+BcvgJY7lIfVDimUY6QOB4t+l2T4UGmsL8Qipbgk2cICv0Wyu5ftfb/2jyU87HH83rA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:48.7452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ba7d59-088d-4103-73b2-08dd0ee91a54
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7817
X-BESS-ID: 1732714852-105489-13355-11895-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.56.168
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobmpgZmQGYGUNTUwjgl1dAsyc
	Ak0cI42cTUMs3C0sg4Jc3MKNHQNDUtVak2FgDKjgiNQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan23-53.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_REQ_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   6 +-
 fs/fuse/dev_uring.c   | 423 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  12 ++
 fs/fuse/fuse_dev_i.h  |   6 +
 fs/fuse/fuse_i.h      |   9 ++
 fs/fuse/inode.c       |   2 +-
 6 files changed, 454 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 51d9c14a8ede9348661921f5d5a6d837c76f91ee..143ce48a1898d911aafbba2b2e734805509169c2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -221,7 +221,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1899,7 +1899,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1983,7 +1983,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index af9c5f116ba1dcf6c01d0359d1a06491c92c32f9..7bb07f5ba436fcb89537f0821f08a7167da52902 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -24,6 +24,19 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
+			       int error)
+{
+	struct fuse_req *req = ring_ent->fuse_req;
+
+	if (set_err)
+		req->out.h.error = error;
+
+	clear_bit(FR_SENT, &req->flags);
+	fuse_request_end(ring_ent->fuse_req);
+	ring_ent->fuse_req = NULL;
+}
+
 static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
 	struct fuse_ring_queue *queue = ent->queue;
@@ -54,8 +67,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 			continue;
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_w_req_queue));
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -114,13 +130,21 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
+	struct list_head *pq;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
 		return ERR_PTR(-ENOMEM);
+	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+	if (!pq) {
+		kfree(queue);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
 		spin_unlock(&fc->lock);
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		return ring->queues[qid];
 	}
@@ -131,6 +155,12 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 
 	INIT_LIST_HEAD(&queue->ent_avail_queue);
 	INIT_LIST_HEAD(&queue->ent_commit_queue);
+	INIT_LIST_HEAD(&queue->ent_w_req_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->fuse_req_queue);
+
+	queue->fpq.processing = pq;
+	fuse_pqueue_init(&queue->fpq);
 
 	WRITE_ONCE(ring->queues[qid], queue);
 	spin_unlock(&fc->lock);
@@ -138,6 +168,213 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	return queue;
 }
 
+static void
+fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+}
+
+/*
+ * Checks for errors and stores it into the request
+ */
+static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
+					 struct fuse_req *req,
+					 struct fuse_conn *fc)
+{
+	int err;
+
+	err = -EINVAL;
+	if (oh->unique == 0) {
+		/* Not supportd through io-uring yet */
+		pr_warn_once("fuse: notify through fuse-io-uring not supported\n");
+		goto seterr;
+	}
+
+	err = -EINVAL;
+	if (oh->error <= -ERESTARTSYS || oh->error > 0)
+		goto seterr;
+
+	if (oh->error) {
+		err = oh->error;
+		goto err;
+	}
+
+	err = -ENOENT;
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
+		pr_warn_ratelimited("Unexpected seqno mismatch, expected: %llu got %llu\n",
+			req->in.h.unique, oh->unique & ~FUSE_INT_REQ_BIT);
+		goto seterr;
+	}
+
+	/*
+	 * Is it an interrupt reply ID?
+	 * XXX: Not supported through fuse-io-uring yet, it should not even
+	 *      find the request - should not happen.
+	 */
+	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
+
+	return 0;
+
+seterr:
+	oh->error = err;
+err:
+	return err;
+}
+
+static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
+				     struct fuse_req *req,
+				     struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct iov_iter iter;
+	int err, res;
+	struct fuse_uring_ent_in_out ring_in_out;
+
+	res = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+			     sizeof(ring_in_out));
+	if (res)
+		return -EFAULT;
+
+	err = import_ubuf(ITER_SOURCE, ent->payload, ent->max_arg_len, &iter);
+	if (err)
+		return err;
+
+	fuse_copy_init(&cs, 0, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
+}
+
+ /*
+  * Copy data from the req to the ring buffer
+  */
+static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct fuse_in_arg *in_args = args->in_args;
+	int num_args = args->in_numargs;
+	int err, res;
+	struct iov_iter iter;
+	struct fuse_uring_ent_in_out ring_in_out = { .flags = 0 };
+
+	if (num_args == 0)
+		return 0;
+
+	err = import_ubuf(ITER_DEST, ent->payload, ent->max_arg_len, &iter);
+	if (err) {
+		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	/*
+	 * Expectation is that the first argument is the per op header.
+	 * Some op code have that as zero.
+	 */
+	if (args->in_args[0].size > 0) {
+		res = copy_to_user(&ent->headers->op_in, in_args->value,
+				   in_args->size);
+		err = res > 0 ? -EFAULT : res;
+		if (err) {
+			pr_info_ratelimited("Copying the header failed.\n");
+			return err;
+		}
+	}
+	in_args++;
+	num_args--;
+
+	/* copy the payload */
+	err = fuse_copy_args(&cs, num_args, args->in_pages,
+			     (struct fuse_arg *)in_args, 0);
+	if (err) {
+		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	ring_in_out.payload_sz = cs.ring.offset;
+	res = copy_to_user(&ent->headers->ring_ent_in_out, &ring_in_out,
+			   sizeof(ring_in_out));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_req *req = ring_ent->fuse_req;
+	int err = 0, res;
+
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent, ring_ent->state);
+		err = -EIO;
+	}
+
+	if (err)
+		return err;
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info("Copy to ring failed: %d\n", err);
+		goto err;
+	}
+
+	/* copy fuse_in_header */
+	res = copy_to_user(&ring_ent->headers->in_out, &req->in.h,
+			   sizeof(req->in.h));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		goto err;
+
+	set_bit(FR_SENT, &req->flags);
+	return 0;
+
+err:
+	fuse_uring_req_end(ring_ent, true, err);
+	return err;
+}
+
+/*
+ * Write data to the ring buffer and send the request to userspace,
+ * userspace will read it
+ * This is comparable with classical read(/dev/fuse)
+ */
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
+{
+	int err = 0;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_complete_in_task(ring_ent->cmd,
+				      fuse_uring_async_send_to_ring);
+	return 0;
+
+err:
+	return err;
+}
+
 /*
  * Make a ring entry available for fuse_req assignment
  */
@@ -148,6 +385,189 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_WAIT;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
+				 struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	req->ring_entry = ring_ent;
+	hash = fuse_req_hash(req->in.h.unique);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
+					   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ring_ent->state != FRRS_WAIT &&
+			 ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+	}
+	list_del_init(&req->list);
+	clear_bit(FR_PENDING, &req->flags);
+	ring_ent->fuse_req = req;
+	ring_ent->state = FRRS_FUSE_REQ;
+	list_move(&ring_ent->list, &queue->ent_w_req_queue);
+	fuse_uring_add_to_pq(ring_ent, req);
+}
+
+/*
+ * Release the ring entry and fetch the next fuse request if available
+ *
+ * @return true if a new request has been fetched
+ */
+static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
+	__must_hold(&queue->lock)
+{
+	struct fuse_req *req = NULL;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	if (!list_empty(req_queue)) {
+		req = list_first_entry(req_queue, struct fuse_req, list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	}
+
+	return req ? true : false;
+}
+
+/*
+ * Read data from the ring buffer, which user space has written to
+ * This is comparible with handling of classical write(/dev/fuse).
+ * Also make the ring request available again for new fuse requests.
+ */
+static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring *ring = ring_ent->queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_req *req = ring_ent->fuse_req;
+	ssize_t err = 0;
+	bool set_err = false;
+
+	err = copy_from_user(&req->out.h, &ring_ent->headers->in_out,
+			     sizeof(req->out.h));
+	if (err) {
+		req->out.h.error = err;
+		goto out;
+	}
+
+	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
+	if (err) {
+		/* req->out.h.error already set */
+		goto out;
+	}
+
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	if (err)
+		set_err = true;
+
+out:
+	fuse_uring_req_end(ring_ent, set_err, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
+				    struct fuse_ring_queue *queue)
+{
+	int has_next, err;
+	int prev_state = ring_ent->state;
+
+	do {
+		spin_lock(&queue->lock);
+		has_next = fuse_uring_ent_assign_req(ring_ent);
+		if (!has_next) {
+			fuse_uring_ent_avail(ring_ent, queue);
+			spin_unlock(&queue->lock);
+			break; /* no request left */
+		}
+		spin_unlock(&queue->lock);
+
+		err = fuse_uring_send_next_to_ring(ring_ent);
+		if (err)
+			ring_ent->state = prev_state;
+	} while (err);
+}
+
+/* FUSE_URING_REQ_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
+				   struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	uint64_t commit_id = cmd_req->commit_id;
+	struct fuse_pqueue fpq;
+	struct fuse_req *req;
+
+	err = -ENOTCONN;
+	if (!ring)
+		return err;
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue)
+		return err;
+	fpq = queue->fpq;
+
+	spin_lock(&queue->lock);
+	/* Find a request based on the unique ID of the fuse request
+	 * This should get revised, as it needs a hash calculation and list
+	 * search. And full struct fuse_pqueue is needed (memory overhead).
+	 * As well as the link from req to ring_ent.
+	 */
+	req = fuse_request_find(&fpq, commit_id);
+	err = -ENOENT;
+	if (!req) {
+		pr_info("qid=%d commit_id %llu not found\n", queue->qid,
+			commit_id);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+	list_del_init(&req->list);
+	ring_ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ent_unset_userspace(ring_ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ring_ent->state);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+
+	ring_ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+
+	/* without the queue lock, as other locks are taken */
+	fuse_uring_commit(ring_ent, issue_flags);
+
+	/*
+	 * Fetching the next request is absolutely required as queued
+	 * fuse requests would otherwise not get processed - committing
+	 * and fetching is done in one step vs legacy fuse, which has separated
+	 * read (fetch request) and write (commit result).
+	 */
+	fuse_uring_next_fuse_req(ring_ent, queue);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -310,6 +730,9 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 			return err;
 		}
 		break;
+	case FUSE_URING_REQ_COMMIT_AND_FETCH:
+		err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 75c644cc0b2bb3721b08f8695964815d53f46e92..b2722828bd20dce5f5bd7884ba87861fb6e0d97b 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -20,6 +20,9 @@ enum fuse_ring_req_state {
 	/* The ring entry is waiting for new fuse requests */
 	FRRS_WAIT,
 
+	/* The ring entry got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -72,7 +75,16 @@ struct fuse_ring_queue {
 	 * entries in the process of being committed or in the process
 	 * to be send to userspace
 	 */
+	struct list_head ent_w_req_queue;
 	struct list_head ent_commit_queue;
+
+	/* entries in userspace */
+	struct list_head ent_in_userspace;
+
+	/* fuse requests waiting for an entry slot */
+	struct list_head fuse_req_queue;
+
+	struct fuse_pqueue fpq;
 };
 
 /**
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 0708730b656b97071de9a5331ef4d51a112c602c..d7bf72dabd84c3896d1447380649e2f4d20b0643 100644
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
@@ -43,6 +46,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a21256ec4c3b4bd7c67eae2d03b68d87dcc8234b..dd628996bbd45b375ca36694067f7be3e58698fa 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -435,6 +435,10 @@ struct fuse_req {
 
 	/** fuse_mount this request belongs to */
 	struct fuse_mount *fm;
+
+#ifdef CONFIG_FUSE_IO_URING
+	void *ring_entry;
+#endif
 };
 
 struct fuse_iqueue;
@@ -1221,6 +1225,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
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
index 76267c79e920204175e5713853de8214c5555d46..2943d25bff9a96fde8c3b51ea8fb02eedd3e6004 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -906,7 +906,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


