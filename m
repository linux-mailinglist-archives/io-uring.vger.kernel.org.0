Return-Path: <io-uring+bounces-5072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 577539DA8BA
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F14C167CCF
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E551FDE0C;
	Wed, 27 Nov 2024 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ylcXZ72/"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56B1FCF66;
	Wed, 27 Nov 2024 13:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714863; cv=fail; b=NByMyI7KtNRRGDCk1ETv6xjuTiPeHAXnvRr1M6dpi+pddecqN1kyKSev8z1QV3GaxiADhC+JEeRfop4eDOosYLKyy7vaGX2MhgeVnd4YNOeD84Qe8pOx6I4SCEvGYipJ87MyidnjhGcxpzCLAmhA9ljGWIAt3EbhLYhI9p3SZDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714863; c=relaxed/simple;
	bh=Hdi4JQx9cZhfAyOVZa1v58hu1bYTNfj8l3d1uVWb7Js=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ej8oz2LaoXgw6g/lnerDLnvIzAqVwdyj8TMZIyF0fbtYSCINrFRrz8cbOm5nwJwl/jv1UJwQqiw9dy+s+id/dDTukqZOQY2FgjVuXc0/A/4IAu950Te7Li24SaO2bNyUNV/jnV+VVq0u2dlGOKZYNTS2NdnrB8eKkZPhdMHwCOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ylcXZ72/; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41]) by mx-outbound45-240.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFQPpPmcYd4KAtpEBlawa9xpdiV72ATUGl0FCfNpPRBcbEiWaDWjsq7sjJEnXoHUuK3/kjU7n1nMIhPacS1bLTSZnVa/hwYkrJNA7qovEbEBHzuTEnhDn1ewe+TKBZZqVHo7RBYsem547tBM/F/KM16+nDRPVXloNAq+5IqyCrngtbe/SAUYzb/aQ+DbJ8uro/W1f52W70bzkD5mMVyQplYRDGmHEUH0Y4M9m4T006rNN28Y8Wuy9I3vAZwFfmd8NGOHUvsWFnX0h2HENCX7DoFStTujeGUkkm9LoiC63/8OMc65BsQ+TMTT5fG+ItMzqJskK/UIyt+nhtY2HD9R5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ts7qj2oHeGmEh3ZrZY9pB1Tnvu8iQGgjUn3TQhzn69M=;
 b=JxqOhSVXL9RzEE765MkNIOLF3hjlGNiWoDbnxrgKtLNu6eqKv67fMFhBgUUQWEZHesl1RGkfra/+6KCKubf3n6WOJ4xEWQegK0l/qOq+xPJnCf9fW0ai+GAk/zEYzWp7Mdiv4W5OdkOOo2mqE9qVpe3QaNRwu7aamYpcEBWEGf71+gQgsLSlp+934l4qFGUa2mr7iKjs3aM03Io9tLjd3a4nSmVpmZ3LevVFr3LDzftiNooDXM3VsCNuwcpbsVE6owUYT4rAgJLouAxwVKOA7Rbg+9gFxPfT3w8pOT0aPJTNf9HZu3HnBByuNX2snUwbqNaLhoQhMQ2MYwTOqP512w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ts7qj2oHeGmEh3ZrZY9pB1Tnvu8iQGgjUn3TQhzn69M=;
 b=ylcXZ72/FP7QN284idxfwimuE4cwqsikkXHOw+UO9pYSA5QucU/4p3tx8vw/lec9OdoreJdhjrNsnlyuODuVirOGVXyeH3NlvBoPlbhWHlwkmIze/1Q0ejMFSpzKuvPOWC1ZfVm0+QK992UpRLeexW92CHkxKAEgssUekjvKzR4=
Received: from CH3P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::16)
 by MN0PR19MB5684.namprd19.prod.outlook.com (2603:10b6:208:373::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Wed, 27 Nov
 2024 13:40:50 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::19) by CH3P220CA0014.outlook.office365.com
 (2603:10b6:610:1e8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:49 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 0CFCC32;
	Wed, 27 Nov 2024 13:40:48 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:27 +0100
Subject: [PATCH RFC v7 10/16] fuse: {uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-10-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=11593;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Hdi4JQx9cZhfAyOVZa1v58hu1bYTNfj8l3d1uVWb7Js=;
 b=3r6PO5C3e1gDcBjZ385ALWjzo2Wx7clSJ8nIpgFS49kLtz4eIwz/8Ru5xK67zK339xRlRaolc
 q7dkUpEBlx3AFr3YmAe3wfE3rDsEFtS6WjpSNijpHArBMzU4t050Ghu
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|MN0PR19MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a1d0ed-3e28-4f8f-3cd3-08dd0ee91b01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUlDVTBZcTVWU1hIeVkrYVQ1aGJ1VFFHRjhZVWF6Smdva1d1d3ZDK3kxSEpz?=
 =?utf-8?B?T2VHN1VRT3I4dUpodUtrTVcwR2IvZys0ZkhaRkZkMFhydWVJb2Jtd1IyYkpG?=
 =?utf-8?B?dWd1WHBCc3hMRDhBcDZVcUwyOFdRQWVHZkxsbWt3UFhNMmJMbUN2TGlJZTV0?=
 =?utf-8?B?MU5SeDR6Rk93cFVmNVE4TkFnM3NlUFhXWVlBWkpOdG9iNjdhUHczTHo5cEFE?=
 =?utf-8?B?NjlXWFhuQ2hTZ2pudU1wblY4ZUc5ZDhIWVF4SVJ6S3BaZlVuY0ZzRi9oRm5W?=
 =?utf-8?B?WWxMNkN6aTcyY3liR2lKVkRzQjdELyt0SGE2akR3NVlVQUFJNG9HUFNGSmM2?=
 =?utf-8?B?RS9qaTlkM1A3ekE3YVU0ZkZEbzI5Q3dTNWI3UW9aUHdvZ1EwaFJzeHF5NTN3?=
 =?utf-8?B?aFFSZ3hNTW0xZ0VoZllkd3IxTEVvQUtXWUU1Q1VuMjZNRWdnMWp5NTFXOWFO?=
 =?utf-8?B?WnJ4UDY5T3BnM1I4bzMzS1Q0MWRFTGxZMEZhVFZxYVBsL0w3MkpBZHdkQ0kv?=
 =?utf-8?B?QXU2Vy83emVtdVQ1TXduSVludmhKaVhWbmRJS2gyNkVjMFZXMmp3K0RiUFh5?=
 =?utf-8?B?dzZQWURFUHNiR1pvdkV1SE13YmFTS0NoQWREYmhvNWR2T1RBbk9McEVNSDAr?=
 =?utf-8?B?S0ppaStvbjFuOWVqdUw4Wk9BQ2Y2QmdaWEdwQTVHbVAwOGdISXcwRTQ3QWV2?=
 =?utf-8?B?TDhIbkhuY1VVcmtja0FlTmkzaGRONnNTMXNjN3pKWlBOZHZPRC9FZ3BrOUwr?=
 =?utf-8?B?SXBwNkVITE5MNThPaVN3NnFManhCSTYrOHNTYmdZYnZCS3ozWDNGOEtnK21o?=
 =?utf-8?B?UjRtdUZzRXZFNFptSDVXVHFrcTZ5WlVnbDMxY2JRWDlPeGpPVDhmcHlmc0cw?=
 =?utf-8?B?QmdTN2c5blRwTldrd1dEMkxmSVZYZlIyR2wybnF3a25ucnVmdmt5T284OUts?=
 =?utf-8?B?SEJvR29KdHVPb3QyQjdFNDB1UWU1Mlgyb2tFbWdDT0VGTThXU29yLzBjNk0x?=
 =?utf-8?B?d09vKzkxTW9iV3hVWDUxc0ZuYTErYnJFQ0lIQURIcGFxdytzbzJ5clgyMURW?=
 =?utf-8?B?L2pXOFk5MkI3M25qb0pDUDQxL2F3S1pkN0FyU0JUQTJTdGN2aW54OWRNRVox?=
 =?utf-8?B?SHpIU2kyeWRybmxuNWFGYVVKZmdhcENzU3g0NjVrcmQ4eG5yV2ZqandLTkxs?=
 =?utf-8?B?QVp3RU9nL2pMdE1wRUVpM1hIRzFVYnQveDllVmRNR3UvZ1FEeDM1N3ROL0Fy?=
 =?utf-8?B?WGUrZTJLeEhaR3FyclRLQWRJUXBVT0FjMUhKckZwbjRORFlSdk53NjRRbzIw?=
 =?utf-8?B?cDVtV20zTktzb3VqQlpkY2xjckQrMFd6K0dueG93VE9YK1EwekdUTHYweTQv?=
 =?utf-8?B?MnVUYWVjYjZyOE5kUDNVcDhxWUI1U3lGZ3FTS2hXV1JLZnUycXBubGhmZ0dy?=
 =?utf-8?B?czR3ZG91Q1hkSU1VSlNaNWRveVo1MUROWjBiLy8wRmJPYWRnaVcveHJiU3h1?=
 =?utf-8?B?YnU4V3dTQ2xCS2RndStSQW9McE1sSnU3WlVnaVRIbHVDNUpXRy9lVmtXK1VH?=
 =?utf-8?B?SU5rOUd1czRGcENZWGdEejFtNC9YMU1OYkdXbjRuSHdjcEZDUStWUXY0WUZq?=
 =?utf-8?B?WVJwUXRQZ055NGQ3Tmx5R2dQWnJhUk1oeUhSaHdGakQ5WmV3a2lqTVoydnph?=
 =?utf-8?B?WkZ0VnVucVNOOStzZWtuMm5CckpkcFYrcnRHZTJ4SUJzeUJnd21mMGlmbmpC?=
 =?utf-8?B?RVJKcHlQSWp6ZVVyTGR2YjhaSWhZdi84NFlLVExEa0w1M3VJRG5Yc2FBSnNy?=
 =?utf-8?B?M0dUNnpITFA1WmgzMUxBeTQ3dkplQklwb1F0M1dKRjNHeHlNTmczbHpRT28r?=
 =?utf-8?B?YmFsT21FOEdkU0FlY3FIOUN4ekJUV25hbURLeEowSGRWYWIrUDYrVjZmOXB4?=
 =?utf-8?Q?4BuPkomGLtkJ8WsBa70j9e93MuVuOzmd?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zWOMpMP31rw52nekfKj00JLeUGBXhmBQCirLBD1Gh/MWd2q4fmyV6nbc6L+DLYIcvonInG5b2qzXmFAOAQwjLUKPvNi0m1Cs6sK6KQf0s0OuSs5+N8qw3GXMAaubEMjsHeOT74UU7TMS6Vo/lRsIszr2Y4ofnBLmYuV6OPNgR5g7liHGyIpRNzDpBUt1yQwnoycr0AW7Y0OuhRhgG7h0+bsm+hMtkkKTjiXkN8zbJYwXFgk4rbzehMM12rwneBPymz8nMuO537UjEfmAQLqqlZHldII1jaN1G7oXhczJaLKszIgaIOkCIe4/hY1f+tB/Hyof9YEQX2pp3o/xRZVAFxrG4zdNh4B5TcRVfOllegyrY/01L7jeiszCuEf7L3Dlwuwj1FfZXBIpL6tY/uTr79aF0egYqQpt3Z3+TqJJaSQof40NhTkJ/BfTV0EKajlWkRQUp57DdchqOPPo1MiNeOkEhA8Edn4ReVOh4B/qqI0ZTZkczUiUoqPs1NV2PNQUP9f63/iiYbH2QakhR45yZLmZyHtxqR5aIYctUYAK4K3dMjVQi3NtApTf7MBDyA1HcMdjyXV2EOOJf1VS2oaBUtHi1aRLJLPron0jS0XUdmQn79Bo+Z7+Mx4ahZzjiZGt5W6Ke6dYbH5PVobIPyWRug==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:49.7994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a1d0ed-3e28-4f8f-3cd3-08dd0ee91b01
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5684
X-BESS-ID: 1732714854-111760-13381-2159-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.70.41
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGhhYWQGYGUNTQxDzJNDXZ3M
	LI2CTJxCAtzcTYLNnc0DLV3NgkJdE4Uak2FgDFLVvsQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan15-69.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On teardown struct file_operations::uring_cmd requests
need to be completed by calling io_uring_cmd_done().
Not completing all ring entries would result in busy io-uring
tasks giving warning messages in intervals and unreleased
struct file.

Additionally the fuse connection and with that the ring can
only get released when all io-uring commands are completed.

Completion is done with ring entries that are
a) in waiting state for new fuse requests - io_uring_cmd_done
is needed

b) already in userspace - io_uring_cmd_done through teardown
is not needed, the request can just get released. If fuse server
is still active and commits such a ring entry, fuse_uring_cmd()
already checks if the connection is active and then complete the
io-uring itself with -ENOTCONN. I.e. special handling is not
needed.

This scheme is basically represented by the ring entry state
FRRS_WAIT and FRRS_USERSPACE.

Entries in state:
- FRRS_INIT: No action needed, do not contribute to
  ring->queue_refs yet
- All other states: Are currently processed by other tasks,
  async teardown is needed and it has to wait for the two
  states above. It could be also solved without an async
  teardown task, but would require additional if conditions
  in hot code paths. Also in my personal opinion the code
  looks cleaner with async teardown.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   8 ++
 fs/fuse/dev_uring.c   | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  51 +++++++++++++
 3 files changed, 265 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 143ce48a1898d911aafbba2b2e734805509169c2..ed85a5f2d6c360b8401b174bc97cc135d87e90d9 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2280,6 +2280,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->lock);
 
 		fuse_dev_end_requests(&to_end);
+
+		/*
+		 * fc->lock must not be taken to avoid conflicts with io-uring
+		 * locks
+		 */
+		fuse_uring_abort(fc);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2291,6 +2297,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 7bb07f5ba436fcb89537f0821f08a7167da52902..b5bb78b5f5902c8b87f3e196baaa05640380046d 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -52,6 +52,37 @@ static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 	return 0;
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(req_list);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry(req, &queue->fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_splice_init(&queue->fuse_req_queue, &req_list);
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&req_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		queue = READ_ONCE(ring->queues[qid]);
+		if (!queue)
+			continue;
+
+		queue->stopped = true;
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -111,9 +142,12 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 		goto out_err;
 	}
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->nr_queues = nr_queues;
 	ring->fc = fc;
+	atomic_set(&ring->queue_refs, 0);
 
 	spin_unlock(&fc->lock);
 	return ring;
@@ -175,6 +209,174 @@ fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
 	io_uring_cmd_done(cmd, 0, 0, issue_flags);
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	/* remove entry from fuse_pqueue->processing */
+	list_del_init(&req->list);
+	ent->fuse_req = NULL;
+	clear_bit(FR_SENT, &req->flags);
+	req->out.h.error = -ECONNABORTED;
+	fuse_request_end(req);
+}
+
+/*
+ * Release a request/entry on connection tear down
+ */
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
+					 bool need_cmd_done)
+{
+	/*
+	 * fuse_request_end() might take other locks like fi->lock and
+	 * can lead to lock ordering issues
+	 */
+	lockdep_assert_not_held(&ent->queue->lock);
+
+	if (need_cmd_done)
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
+				  IO_URING_F_UNLOCKED);
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	list_del_init(&ent->list);
+	kfree(ent);
+}
+
+static void fuse_uring_stop_list_entries(struct list_head *head,
+					 struct fuse_ring_queue *queue,
+					 enum fuse_ring_req_state exp_state)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent, *next;
+	ssize_t queue_refs = SSIZE_MAX;
+	LIST_HEAD(to_teardown);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry_safe(ent, next, head, list) {
+		if (ent->state != exp_state) {
+			pr_warn("entry teardown qid=%d state=%d expected=%d",
+				queue->qid, ent->state, exp_state);
+			continue;
+		}
+
+		list_move(&ent->list, &to_teardown);
+	}
+	spin_unlock(&queue->lock);
+
+	/* no queue lock to avoid lock order issues */
+	list_for_each_entry_safe(ent, next, &to_teardown, list) {
+		bool need_cmd_done = ent->state != FRRS_USERSPACE;
+
+		fuse_uring_entry_teardown(ent, need_cmd_done);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+
+		WARN_ON_ONCE(queue_refs < 0);
+	}
+}
+
+static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue, FRRS_WAIT);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_ent *ent;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		spin_lock(&queue->lock);
+		/*
+		 * Log entries from the intermediate queue, the other queues
+		 * should be empty
+		 */
+		list_for_each_entry(ent, &queue->ent_w_req_queue, list) {
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		list_for_each_entry(ent, &queue->ent_commit_queue, list) {
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		spin_unlock(&queue->lock);
+	}
+	ring->stop_debug_log = 1;
+}
+
+static void fuse_uring_async_stop_queues(struct work_struct *work)
+{
+	int qid;
+	struct fuse_ring *ring =
+		container_of(work, struct fuse_ring, async_teardown_work.work);
+
+	/* XXX code dup */
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	/*
+	 * Some ring entries are might be in the middle of IO operations,
+	 * i.e. in process to get handled by file_operations::uring_cmd
+	 * or on the way to userspace - we could handle that with conditions in
+	 * run time code, but easier/cleaner to have an async tear down handler
+	 * If there are still queue references left
+	 */
+	if (atomic_read(&ring->queue_refs) > 0) {
+		if (time_after(jiffies,
+			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
+			fuse_uring_log_ent_state(ring);
+
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
+/*
+ * Stop the ring queues
+ */
+void fuse_uring_stop_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		ring->teardown_time = jiffies;
+		INIT_DELAYED_WORK(&ring->async_teardown_work,
+				  fuse_uring_async_stop_queues);
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -526,6 +728,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -683,6 +888,7 @@ static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
 	if (WARN_ON_ONCE(err != 0))
 		goto err;
 
+	atomic_inc(&ring->queue_refs);
 	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
 
 	return 0;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index b2722828bd20dce5f5bd7884ba87861fb6e0d97b..52259714ffc59a38b21f834ae5e317fe818863dc 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -85,6 +88,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -99,12 +104,51 @@ struct fuse_ring {
 	size_t nr_queues;
 
 	struct fuse_ring_queue **queues;
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
+	 */
+	unsigned int stop_debug_log : 1;
+
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
+	atomic_t queue_refs;
 };
 
 bool fuse_uring_enabled(void);
 void fuse_uring_destruct(struct fuse_conn *fc);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring == NULL)
+		return;
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_uring_abort_end_requests(ring);
+		fuse_uring_stop_queues(ring);
+	}
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring)
+		wait_event(ring->stop_waitq,
+			   atomic_read(&ring->queue_refs) == 0);
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -122,6 +166,13 @@ static inline bool fuse_uring_enabled(void)
 	return false;
 }
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


