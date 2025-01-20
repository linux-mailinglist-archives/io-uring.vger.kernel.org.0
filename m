Return-Path: <io-uring+bounces-6010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 282CCA164EA
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A75416602D
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814532110E;
	Mon, 20 Jan 2025 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="IIGiWUY3"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B64A199BC;
	Mon, 20 Jan 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336572; cv=fail; b=LsEv1crRDnA/w2kOFdJWiHSaG99S09/y5K8WXbNLSdnthGvzGkPfuDTKXiSXCB1+qZ7DAArWoyX7wwqpy4JdX/VkXDGX2948nZjx9PtScXbxbH7nTbMuH3PbRWIZeE21X7Pce4UuDYs02wQymeVP8TRO9lcKSVSg4/FcAgU6gAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336572; c=relaxed/simple;
	bh=Bb62cvtV/o9ssfWt19sVvk+kkAD7g49zLvyeTxykUlM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VpqpHaYOm9BO5DdWZp72ujTCqI9SDgLEV7P72l11fOImWSn7oWKO+TfGuRr7uP3Ctjdkt9X+YXqFkaEHd///xBgmXywBGSLM86/PKqujASMDWC72o0hTUtIj5tRn1l1csowPvpVShArLUch+//LK2u1nBNgwn2hkediPmC8BGQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=IIGiWUY3; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172]) by mx-outbound19-105.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkgfoXRWdPqdugGeDSuxwPuRC5GakPMPTLxRCa84QOgttO4uiqJTOqqRdvubu8y901mum0jfkiE9EYXUYNtfUmwFnlELD/9yaRHjYO7PNVdrL95D4E2G4TxxQKjyYKmvED/EB5LGG7Ft70V5bB77EGqEnNrc09eCGFnKtqO/OjMaAlRHgbcSztQRoopM0LOTpHZNr6hhfOkW6fnV+7z1B7mcknAtFJ4He5ZwZZlv25KwxJlWBMvN93d3zWy/majJY6az82JFKw3hw7hs01l1WsAJu9qHtjgMUhzFUb4ijq7JZvyv3D8sRjfJhFDbZGCFFuesRkdsRizjtT3mlPXm6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piXLzTrofLN8IVqKi2dc457lad8/frs5TR/+4yP9fSY=;
 b=cM7MPVsPOWFA9bzhmkZUKZqvIvlktpzFX2BZjId3BzLYlr4rBxWU2T4IUC7DNYZAF4tHZmSvUazvmQT2VrkUnF+EFuYz6i0qcElxLJjjKsP7pF2+dNyKrdUHiey4MKwT6HjVHuF/pc6AbSs91kLx8nlM9SOCD3bMfpsiChfukjc0B5ECPAt50d6JxYmT2KI34Z81Lzaj+1d21zbpA/VlzoD9IinOuLcdVe+CiAhWy1aWn1F7RB3LOubnBBQHG48AWmEXe9xVzbhAaoZz1ILXkufG7GjMiEMerkrlfOAgi/+HjqQ8IsSvjiqFLYyiP71r07TxgowBlnsQSh9iFynszg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piXLzTrofLN8IVqKi2dc457lad8/frs5TR/+4yP9fSY=;
 b=IIGiWUY3AQzKIkqc7Hp4pRkJop5Bo3doMdISPpA9UowB0vIgM/rohllXRQcYAK0vxnwEMMH/MO5E37Xr7Y9owdsQSPTKYpDDKYNa9ZRoJE1cfKmGlVrMwU5VfKwycSgVgGjX7LOQE7ddsxBm3u3WvBVwdQ/JbsH5+RDGtZG1eaM=
Received: from CH2PR07CA0046.namprd07.prod.outlook.com (2603:10b6:610:5b::20)
 by MW4PR19MB6649.namprd19.prod.outlook.com (2603:10b6:303:1e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 01:29:13 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::c1) by CH2PR07CA0046.outlook.office365.com
 (2603:10b6:610:5b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:12 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 9553D34;
	Mon, 20 Jan 2025 01:29:11 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:03 +0100
Subject: [PATCH v10 10/17] fuse: Add io-uring sqe commit and fetch support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-10-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=15453;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Bb62cvtV/o9ssfWt19sVvk+kkAD7g49zLvyeTxykUlM=;
 b=7Mrl6BhmOCh8GuboR2DRGNGO/sAO+kO8O5I1pEk0SHZRPcdhEyRAwkh3J/auZK6bwKkULsg6R
 092XbbLBsnjDooyrKTZtC7vaU4R1C6zEjPkjVNKZNOvldY9JYIQnuKP
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|MW4PR19MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 66620804-f52c-485f-d3bb-08dd38f1d86a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDdCWllTQnZFZDJnTEJIejUrMUZEK2VQWUhCTFRIVENOSW11aWhiK0g5VWFo?=
 =?utf-8?B?dGcvenlrTlhCTFFhdVJ1c2ZJRGs0SWFheXFCUUo4M2hWUmFua1I1UmJrK1Mr?=
 =?utf-8?B?NUlndUlZcHExaVZCRkNrTXpLZXI4OTl0MjRtOHdpZkJ3Nlh0SWFBVjBERkNK?=
 =?utf-8?B?WTFFaUo0QXBBcTU0RUtFL1lpREZSM0hzTUJYaUZvbHlnaTh1bnZ1dDdrRUhh?=
 =?utf-8?B?STF4bGtoSjVpODBsYnFsb09jeU5BK3FWMjdGdm10MGFRN2J0MCtvdEdTVzBq?=
 =?utf-8?B?SXJORWVlamVrSVZyOVhOZ1NJeHFkUHV3NzIrVkxKZWRUazFyY2RrU1ZTbUpO?=
 =?utf-8?B?U0NMeEdId2tBRFZhS1FwbytZZVBqTFBIUlgrYUNPYWFveTJ3cTNveEdRc2Vk?=
 =?utf-8?B?TWxSdmd5c3ZrZkt6b1VoOUsrb205Yy8yL29KQVFVMUh3VVlVelo3U3RxZm5U?=
 =?utf-8?B?VXc4S0pyRzlIS3J6N0w3MnROalRjZEtxZzU0VTRyYmNXMmtQV2F3Ynl5SHdK?=
 =?utf-8?B?RytNY1FpTVdEQkdBZEJrWUhpbzhGT1dsNitXV0VCQXgzOWF0V1RJOXB2TEhU?=
 =?utf-8?B?cmVLWisyb3dlUXBNVUhGQ1NzNHN0NFU2SFd5WEVKNDZaZmRiTGVSRWdIRHlL?=
 =?utf-8?B?eXFkYkxmY0w0TnZ0UDB1a0piR1NPdzVJM3lyNmdaVW50bUo1Qm94U3lHQU5M?=
 =?utf-8?B?OGIyL3ljbVpnNlBpTXVFc0hvcGZ3MnRFdGFmRmZlaVJZYU9YbHdpbEdGQnU4?=
 =?utf-8?B?Vjc3TVp2NjNXTml6SlJQaEhERmdzK1pWbHpoKzRRVk5pekQ2WnhIWXFJZytO?=
 =?utf-8?B?WlowTG9hM3NPY3RHaWEyUEIzR0JkU2xNck40RVBlTG9LdUkrSG42ZXJMT3R0?=
 =?utf-8?B?WkwwNzJ4emRYejdNeGplbXZXcS9vMzBKRjhodnFEdmZ5c2IrWjF5T2xydjlk?=
 =?utf-8?B?dVBlU0hDaTJXaE1icmNBT2hDVlBMRWVrR0lyOE9pYXorbmVIQ21hZm5KUEJU?=
 =?utf-8?B?R0dvUTdtOXhkUVI3V3F2SEU3MGFINmFUazM4Ylh6enJra2JMZ3EwdWducWxv?=
 =?utf-8?B?VzlIOGExUnlPNTAySFpQQzB5ellXRzNhR0F1QW40TEw2S2JSNzlLREk5NHlZ?=
 =?utf-8?B?K0g1NUtMZlNvQkY4dkJkMVViRUYxSUVpWjBDMDRaMnF0VFI1OUNoVFQzak9U?=
 =?utf-8?B?Z1cvaUtjRlVxU01Mei9nT2xyT0hwbDNUdWtTSlRhdFZJU0l0SjBXZDA1aDk2?=
 =?utf-8?B?bSs3N3JCM2xvTERiTkxteGVTUmpVVkhVNWxScmJjTTdnaUhhQ2RvVEl6SFpq?=
 =?utf-8?B?S2hvUW9PNmg5d0cvYmd3UVl2V3dMNzM5QXRCa1RjS2RBc3B2OERlT0dnTndX?=
 =?utf-8?B?RE1Xc09GVmJ3d2NEaW9tVzBLU3J2UGEyNEp4YzRXNVhuYWQ3Ync3VWNlTVo0?=
 =?utf-8?B?VnI4amRrN1hUVjdObWpGaEpaNERrYXJUMXpJTHpQQTE1cGVFWDdCR0h5RjJL?=
 =?utf-8?B?MHpzVkV0bldGWnFOZytWcllqWS9STzlQZllOeHlKMzNvZGV1SlJ4c05ZZUZP?=
 =?utf-8?B?Snl1WU8wakZ3dGdPUWRIK1NSVkY2RnhkN0ZkMXk3My9qYTlZSE1qWWUrQkFn?=
 =?utf-8?B?RWpPVXdEREFIckRmcDZoa01sYzFwT0RqR0VZbjZsWVl3YndQVnlTZWNKMFFX?=
 =?utf-8?B?K2lmcG9pQ2pFQ1lXT0VFdHk2RHJNQlFyN1kySlJQOWNqVHV0S3NCS3hyV0JL?=
 =?utf-8?B?L3BNOHlGMFVaNmZJUEJSZTRFa1VPdjY0OVJYWk1MMDkveFVxaG8wYTRNdGts?=
 =?utf-8?B?OHpFcHpTSDUvcFVMR3JSQnpNVGREUUtpQ0t0K0FFYStjSVl5ek4zQkJCTGpM?=
 =?utf-8?B?eGNJaDhad2NXUXZOa0dkYVpMTS9BdmJUNGh0K0NmMHc4bEkrbFhmUktZN3N6?=
 =?utf-8?B?MXVkbEZhNjRVbk5RUGc0UUxNSUhsSFpUaUtJcExNNXgwNm02ZlllRk1waUxT?=
 =?utf-8?Q?xUoZ94yTv4P6a2fVSYXIqFf5eBlIxg=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NnR5iQS1f0w5h82AQnBXmBFAEEcczNls4SNbAc6MR6KsrqLFr056C1nO/kj8HDpqQbEo/Oqv2U6Pe4U9jrnpWWEU00//bCvLTvcCbIuCZtn5cDMpt55UjzvvY+D5ytayvQ1dsAO32jVRaP5fWG3jxMhwX6PpKVZrCoAUeTWnmn5vgdSFFgzszmCffoyVP6k6calxXH2Og4VEfyWj0R/QnV4Ixn3fuN8hEVtvplNOMd0F/J0fmaJFzL+Ib+uAHkuc6hZB0HNK7ZRjxvU/j+PObjQ0sTkVbDnyvS+JDKHlEBo4EhCY7EN5P89Oin8hoUNUZMtPY5xhk/kT3RX7xOS65MHuCLIt4DwNHt2eJvfvaIfjpVVJyu19ay9I1nXUj9sOuWSN28plPWSIS/JnxIRQ8C4Fb8OO9fqm2RJgiYtb/m/ap3LVRlVRy8lndvRZISmesSHFl2T4OPkp+3z/20+4LiCJKb9Ls6m6b2rf1q7qyJ8DIFHtRyowFhlFSdgSI90ZwgBn8AAFG5662Z3U9g+nV2dpjJrotg4+LgQ8TwQO8r6B7QNkMdUhgmRri/HDb/4AcrrV+25UswWnKZTqQNz3Yw9f9mNDf8RMetnx+4uErWv8hhA3ll0S0T2PhSOhMxUkAZBI0bzjr6JD8BiTsiAjaA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:12.2663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66620804-f52c-485f-d3bb-08dd38f1d86a
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB6649
X-BESS-ID: 1737336555-104969-13364-2412-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.56.172
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmFuYWQGYGUNQg0SzZ2CzJzN
	LcMtXYxNLSJDUl1SDJ2MjMMsnUMMk0Uak2FgDPcuOjQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan9-147.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
---
 fs/fuse/dev_uring.c   | 448 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  12 ++
 fs/fuse/fuse_i.h      |   4 +
 3 files changed, 464 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 60e38ff1ecef3b007bae7ceedd7dd997439e463a..74aa5ccaff30998cf58e805f7c1b7ebf70d5cd6d 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -24,6 +24,18 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	if (error)
+		req->out.h.error = error;
+
+	clear_bit(FR_SENT, &req->flags);
+	fuse_request_end(ent->fuse_req);
+	ent->fuse_req = NULL;
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -39,8 +51,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 			continue;
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_w_req_queue));
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -99,20 +114,34 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
+	struct list_head *pq;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
 		return NULL;
+	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+	if (!pq) {
+		kfree(queue);
+		return NULL;
+	}
+
 	queue->qid = qid;
 	queue->ring = ring;
 	spin_lock_init(&queue->lock);
 
 	INIT_LIST_HEAD(&queue->ent_avail_queue);
 	INIT_LIST_HEAD(&queue->ent_commit_queue);
+	INIT_LIST_HEAD(&queue->ent_w_req_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->fuse_req_queue);
+
+	queue->fpq.processing = pq;
+	fuse_pqueue_init(&queue->fpq);
 
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
 		spin_unlock(&fc->lock);
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		return ring->queues[qid];
 	}
@@ -126,6 +155,213 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	return queue;
 }
 
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
+		/* Not supported through io-uring yet */
+		pr_warn_once("notify through fuse-io-uring not supported\n");
+		goto err;
+	}
+
+	if (oh->error <= -ERESTARTSYS || oh->error > 0)
+		goto err;
+
+	if (oh->error) {
+		err = oh->error;
+		goto err;
+	}
+
+	err = -ENOENT;
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
+		pr_warn_ratelimited("unique mismatch, expected: %llu got %llu\n",
+				    req->in.h.unique,
+				    oh->unique & ~FUSE_INT_REQ_BIT);
+		goto err;
+	}
+
+	/*
+	 * Is it an interrupt reply ID?
+	 * XXX: Not supported through fuse-io-uring yet, it should not even
+	 *      find the request - should not happen.
+	 */
+	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
+
+	err = 0;
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
+	int err;
+	struct fuse_uring_ent_in_out ring_in_out;
+
+	err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+			     sizeof(ring_in_out));
+	if (err)
+		return -EFAULT;
+
+	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
+			  &iter);
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
+static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct fuse_in_arg *in_args = args->in_args;
+	int num_args = args->in_numargs;
+	int err;
+	struct iov_iter iter;
+	struct fuse_uring_ent_in_out ent_in_out = {
+		.flags = 0,
+		.commit_id = req->in.h.unique,
+	};
+
+	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
+	if (err) {
+		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	if (num_args > 0) {
+		/*
+		 * Expectation is that the first argument is the per op header.
+		 * Some op code have that as zero size.
+		 */
+		if (args->in_args[0].size > 0) {
+			err = copy_to_user(&ent->headers->op_in, in_args->value,
+					   in_args->size);
+			if (err) {
+				pr_info_ratelimited(
+					"Copying the header failed.\n");
+				return -EFAULT;
+			}
+		}
+		in_args++;
+		num_args--;
+	}
+
+	/* copy the payload */
+	err = fuse_copy_args(&cs, num_args, args->in_pages,
+			     (struct fuse_arg *)in_args, 0);
+	if (err) {
+		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	ent_in_out.payload_sz = cs.ring.copied_sz;
+	err = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
+			   sizeof(ent_in_out));
+	return err ? -EFAULT : 0;
+}
+
+static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
+				   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	int err;
+
+	err = -EIO;
+	if (WARN_ON(ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ent, ent->state);
+		return err;
+	}
+
+	err = -EINVAL;
+	if (WARN_ON(req->in.h.unique == 0))
+		return err;
+
+	/* copy the request */
+	err = fuse_uring_args_to_ring(ring, req, ent);
+	if (unlikely(err)) {
+		pr_info_ratelimited("Copy to ring failed: %d\n", err);
+		return err;
+	}
+
+	/* copy fuse_in_header */
+	err = copy_to_user(&ent->headers->in_out, &req->in.h,
+			   sizeof(req->in.h));
+	if (err) {
+		err = -EFAULT;
+		return err;
+	}
+
+	return 0;
+}
+
+static int fuse_uring_prepare_send(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+	int err;
+
+	err = fuse_uring_copy_to_ring(ent, req);
+	if (!err)
+		set_bit(FR_SENT, &req->flags);
+	else
+		fuse_uring_req_end(ent, err);
+
+	return err;
+}
+
+/*
+ * Write data to the ring buffer and send the request to userspace,
+ * userspace will read it
+ * This is comparable with classical read(/dev/fuse)
+ */
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ent,
+					unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	int err;
+	struct io_uring_cmd *cmd;
+
+	err = fuse_uring_prepare_send(ent);
+	if (err)
+		return err;
+
+	spin_lock(&queue->lock);
+	cmd = ent->cmd;
+	ent->cmd = NULL;
+	ent->state = FRRS_USERSPACE;
+	list_move(&ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+	return 0;
+}
+
 /*
  * Make a ring entry available for fuse_req assignment
  */
@@ -137,6 +373,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ent,
 	ent->state = FRRS_AVAILABLE;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ent,
+				 struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	req->ring_entry = ent;
+	hash = fuse_req_hash(req->in.h.unique);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
+					   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ent->state != FRRS_AVAILABLE &&
+			 ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ent->queue->qid,
+			ent->state);
+	}
+
+	spin_lock(&fiq->lock);
+	clear_bit(FR_PENDING, &req->flags);
+	spin_unlock(&fiq->lock);
+	ent->fuse_req = req;
+	ent->state = FRRS_FUSE_REQ;
+	list_move(&ent->list, &queue->ent_w_req_queue);
+	fuse_uring_add_to_pq(ent, req);
+}
+
+/*
+ * Release the ring entry and fetch the next fuse request if available
+ *
+ * @return true if a new request has been fetched
+ */
+static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
+	__must_hold(&queue->lock)
+{
+	struct fuse_req *req;
+	struct fuse_ring_queue *queue = ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
+	if (req) {
+		fuse_uring_add_req_to_ring_ent(ent, req);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Read data from the ring buffer, which user space has written to
+ * This is comparible with handling of classical write(/dev/fuse).
+ * Also make the ring request available again for new fuse requests.
+ */
+static void fuse_uring_commit(struct fuse_ring_ent *ent,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring *ring = ent->queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_req *req = ent->fuse_req;
+	ssize_t err = 0;
+
+	err = copy_from_user(&req->out.h, &ent->headers->in_out,
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
+	err = fuse_uring_copy_from_ring(ring, req, ent);
+out:
+	fuse_uring_req_end(ent, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ent,
+				     struct fuse_ring_queue *queue,
+				     unsigned int issue_flags)
+{
+	int err;
+	bool has_next;
+
+retry:
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ent, queue);
+	has_next = fuse_uring_ent_assign_req(ent);
+	spin_unlock(&queue->lock);
+
+	if (has_next) {
+		err = fuse_uring_send_next_to_ring(ent, issue_flags);
+		if (err)
+			goto retry;
+	}
+}
+
+static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
+		return -EIO;
+
+	ent->state = FRRS_COMMIT;
+	list_move(&ent->list, &queue->ent_commit_queue);
+
+	return 0;
+}
+
+/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
+				   struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring_ent *ent;
+	int err;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	uint64_t commit_id = READ_ONCE(cmd_req->commit_id);
+	unsigned int qid = READ_ONCE(cmd_req->qid);
+	struct fuse_pqueue *fpq;
+	struct fuse_req *req;
+
+	err = -ENOTCONN;
+	if (!ring)
+		return err;
+
+	if (qid >= ring->nr_queues)
+		return -EINVAL;
+
+	queue = ring->queues[qid];
+	if (!queue)
+		return err;
+	fpq = &queue->fpq;
+
+	spin_lock(&queue->lock);
+	/* Find a request based on the unique ID of the fuse request
+	 * This should get revised, as it needs a hash calculation and list
+	 * search. And full struct fuse_pqueue is needed (memory overhead).
+	 * As well as the link from req to ring_ent.
+	 */
+	req = fuse_request_find(fpq, commit_id);
+	err = -ENOENT;
+	if (!req) {
+		pr_info("qid=%d commit_id %llu not found\n", queue->qid,
+			commit_id);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+	list_del_init(&req->list);
+	ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ent_set_commit(ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ent->state);
+		spin_unlock(&queue->lock);
+		req->out.h.error = err;
+		clear_bit(FR_SENT, &req->flags);
+		fuse_request_end(req);
+		return err;
+	}
+
+	ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+
+	/* without the queue lock, as other locks are taken */
+	fuse_uring_commit(ent, issue_flags);
+
+	/*
+	 * Fetching the next request is absolutely required as queued
+	 * fuse requests would otherwise not get processed - committing
+	 * and fetching is done in one step vs legacy fuse, which has separated
+	 * read (fetch request) and write (commit result).
+	 */
+	fuse_uring_next_fuse_req(ent, queue, issue_flags);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -318,6 +758,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 			return err;
 		}
 		break;
+	case FUSE_IO_URING_CMD_COMMIT_AND_FETCH:
+		err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		if (err) {
+			pr_info_once("FUSE_IO_URING_COMMIT_AND_FETCH failed err=%d\n",
+				     err);
+			return err;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index ae1536355b368583132d2ab6878b5490510b28e8..44bf237f0d5abcadbb768ba3940c3fec813b079d 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -20,6 +20,9 @@ enum fuse_ring_req_state {
 	/* The ring entry is waiting for new fuse requests */
 	FRRS_AVAILABLE,
 
+	/* The ring entry got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -67,7 +70,16 @@ struct fuse_ring_queue {
 	 * entries in the process of being committed or in the process
 	 * to be sent to userspace
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
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e545b0864dd51e82df61cc39bdf65d3d36a418dc..e71556894bc25808581424ec7bdd4afeebc81f15 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -438,6 +438,10 @@ struct fuse_req {
 
 	/** fuse_mount this request belongs to */
 	struct fuse_mount *fm;
+
+#ifdef CONFIG_FUSE_IO_URING
+	void *ring_entry;
+#endif
 };
 
 struct fuse_iqueue;

-- 
2.43.0


