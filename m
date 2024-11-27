Return-Path: <io-uring+bounces-5081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BF89DA8CB
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C27F1B23D9A
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229251FCF65;
	Wed, 27 Nov 2024 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="k/+4Rpa/"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815E61FE454;
	Wed, 27 Nov 2024 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714871; cv=fail; b=gd3yqcHQVswzhUm9QnQ044gQ2WikyH6mbrKxiu14ehk1ld4jBLVVhgQg9wZ7ZjwMX3wzw0gvGEkrU9MVYjs8ByKswPm/uQQdXweOoWjnUU4nR15MC/3daLF5IQSlE+12w5XTHAfHWijZC4JLYt/TzL+7qXnyBuyQk5jd3684Fw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714871; c=relaxed/simple;
	bh=9PzkB61bj/XR2Z+Wxlq+/t+fdgKvUzyQ0tG8Huxq6vA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mIfyymTX+Nx3zenAQLvI1SMC4wtJBoH8OsCcaKIR5Kzbwhq7RVYMyUSoDpGQTGgGNElaWNsbMmMQtycHkEgzV/JTsDTO8CVF1v6ht0c1IzWTjFwnlw7W4QFMhu7q7+fNy6OpHdyx3YqTDDcdefthEm/gvODzizcEO2nvdbbeA9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=k/+4Rpa/; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44]) by mx-outbound45-131.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AV+93w9NdBul7FfsGw84fsb/wtyQPusHDPVzcOrFRf5TUi2EfNdLuaflziyZ4NCt9Z66eedNI5NUX5yqaALjxCBKUc+kyi/nz1xhn0d7YB7N8kCZmUY/mzsau/5eHygohug1PXvcLNY6X5kLc6SNea7wcal1taO4SXsATStML3QAhSl6FtmJ5dceHdZ8GpxSDdqUgxyF+kjqEME/IfkPJcMwwlubYbBAV4+D2B1Hn+pkEd2Z4OsRG42fODcn7Hte1Gq7EhSdsWuEzz1Q+BkMQVRj9ZNH4yENOPgg9BQTg5uKiPbCtFL5nhfADLhAjKRQ0MuQqTWRMXthyBezn8eh9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K6grFXYQFUPscAqxdj4dBIZiGWdtyrh7ixfQODKKbA=;
 b=xQSANleaMaw8KRRdHpXK53wRV8/2dx8arO9xKdutAEnmiwsm4/pyMWpWxqwpoR+m+t3oJoptP1lX+Uda50FYruX7JxM42cccv/pWmN++655JJddkyBmsKyON7rtMNRG2kRScS0YVEXY7tFJrokDjICsDO8Ms5jWcM5inn+wPnRPZPVZtGxOVWzBXj42oKHkWzjb0i845LxFa+xGbWpw5chQhx3aFLuy6WzZf0YP6Zd+MG+H3Tn9mAja1v0Tzbu3q5RUaL4wQV8v3YNGloGAkxFBDH4oE77IZ1vHZ5V1g21Futav6j4a48MDlj1u22ZzKOVI2uw0Zl0V8fofYgdrSEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K6grFXYQFUPscAqxdj4dBIZiGWdtyrh7ixfQODKKbA=;
 b=k/+4Rpa/nCnoi9MJJpK49V33IuB9JXDuJeUiGtkp7XTrZdQH9Y63cYHzdvyQoKwrsOWNb13RxafJ7PDlg562ktjCVHHcQ6ApFmA1EmXJMj0hqC6rRTL7AdffoFezuOQ7wcRP2FkTcDvmoAr+0/HECGQx4mEOPnxjT9oHHD4IA7M=
Received: from CH2PR14CA0059.namprd14.prod.outlook.com (2603:10b6:610:56::39)
 by BLAPR19MB4289.namprd19.prod.outlook.com (2603:10b6:208:27a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Wed, 27 Nov
 2024 13:40:53 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:610:56:cafe::80) by CH2PR14CA0059.outlook.office365.com
 (2603:10b6:610:56::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.0
 via Frontend Transport; Wed, 27 Nov 2024 13:40:52 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E95F62D;
	Wed, 27 Nov 2024 13:40:51 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:30 +0100
Subject: [PATCH RFC v7 13/16] io_uring/cmd: let cmds to know about dying
 task
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-13-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=1916;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=DJ3dd+IL74OJQCvDusXpPNgQqk5rs1+4ays6c3lVSGQ=;
 b=BwV290uqXxlbs6b8SA4yNxILekT+PsQg02svrXRhPnZzkym53RmUhI+yfOZAQXEL5lX0mpyFl
 zRVzxqbcLlJCh1BkxBzHOkOTv2+Rn03Me79g9JjqD6nhRKpUe/pQVlK
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|BLAPR19MB4289:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b4b2b7-cf7b-4006-67bd-08dd0ee91cb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0E3M2xsR1gyWUp0SFRvZmVOKzJKQnB0Qk0wMlpWRlVveEIwbW8zUURrYU81?=
 =?utf-8?B?bTVteW9HTlhDd0ttQjY0T080ZjhPVHFNYnlsS0lyRlZOdXJ6YkpHQ0hZdysx?=
 =?utf-8?B?ZmRHQXpqWFhMVmplOG54VzkzZjJJem0wNEdmS1JyRHJ6c2s2REwzNyt4dzlw?=
 =?utf-8?B?VVRsMlNYclQrZTI3V2JtaWxhb1RZa1h5RHp0OHJWamJ5SXFNb2o4aUdrQ2Rz?=
 =?utf-8?B?Z0FZSzJmamZ2RXA1QmJXUlRnQXlUNW9QRWgxTGdZdVY3Y2FOYjBqWnFzam4v?=
 =?utf-8?B?Q0Y5U3paNHZlNE01UHZybzZpakRkZzNxeEVRaUFsNmY5ZTdkNkRZcnB6LzVi?=
 =?utf-8?B?R2dSbEhyc1pYU0JUN0RiTmtzYzNpVkhBeGtmeG1sM1gyWmhLVXVmVU5FVlcv?=
 =?utf-8?B?VWJ4cGVaWEhYRWRRVmtQOFg3WXR4QWs3Y0xaOU52TVBEeGpQU21TVUhnZXFG?=
 =?utf-8?B?UTlkK0hTZmttbGpDRzg5c0FtcnkyQlV2K2VINjdLc3ZMUGZVYnFkOHN4UDJa?=
 =?utf-8?B?VEFTSGRSa0MxM0IrbzVITUtMWFJ6a1YrWnB5Z2N5ZHp5SzE4QkJLbVR5TTZZ?=
 =?utf-8?B?dGJNVGM2c1pGQW81NDFmQlhGRk9kd2owR2VNRUtwUlhUVmdsRDJBNUwzNWtP?=
 =?utf-8?B?bUQvWnpDNi9YOVhucHAxa3lFQ1orZHc4QlI1a1RQTGwwbkIrT05nTGQ5eHB5?=
 =?utf-8?B?d3dWMnUxbmQxa25ISXErdmJlNW9ZWGtaemRFdjNEU3JocUVSZnQyVUFvNFBT?=
 =?utf-8?B?ZWRjLyt6WmhlR0p6QXNrK29tVFFjK1YybHUrNTBKN3hRQWpWdElPeFVyd1Jz?=
 =?utf-8?B?R2lXSm84UmZtcDYyRHg3cTFlejJxYXNDL1I2TWdTOHZnQXN1WnBBZUNNVmdF?=
 =?utf-8?B?dU82Wk8wdCtCc0ZtbUgzTjNaZkJGZUFlR01CMW1mK0dRaHdVaHl0YWxUYWpw?=
 =?utf-8?B?bmpHaTNUVUZ4Ync4Mjl3YlhRL2VRTXhPRXc2bEk0cjRuNy9HUTdSbUZpcjVl?=
 =?utf-8?B?d1JiYXVLK3pyNFVlZGt6K3NwUHdRa2plYUpINXpDdDNJTVNQWWsvTE1hemdR?=
 =?utf-8?B?TjZBUlRHTUtPUk5PY0RaaCtXc1hNaXZJUFlhNDlnc3J5UHFFdzRvRW1wSExx?=
 =?utf-8?B?QysvWWJzK0tFUWVtOFQ1N0lwVmhJOXJtWEJXZ2lla1pYTHZPaHpOT1M2dElW?=
 =?utf-8?B?WVRMbldUVEo5dFBoRHpzSWhUSnlqYzRNcEhBL3N4M3RsUDd0SEw3SmtpQzkv?=
 =?utf-8?B?SnhUNDdDZGR4Tmd4RWIrZ3BTQXdGQWptRWI1RWVibVZSRllmbG9kdS82UElY?=
 =?utf-8?B?cnl3cFFrclh4TFUwb0ZXditnWllSZUNHZFhDQXZYS1VuUjRPTTdadXp4YTly?=
 =?utf-8?B?V2pqR2xvN1NKTXFHK2xpR0wrSWdqQlNweWdBN043VGlmUEhwV3M3YTF4a0Y0?=
 =?utf-8?B?di9Wa3VjUmZvOFQ2ZG4zbDR5TDExblp2dVRWQzR4K1dxSUZMcitkeTdUZzkx?=
 =?utf-8?B?R3ZqT004cWpHR01wUGxlaGpkcXkrWEdIbGpGenlQRHczVDQyK2ZZNS9SZmxN?=
 =?utf-8?B?NmZhTHAxZk5QRWs4VFQ3MkZ3cG5OTXlXRFlYbmMzZ2xWSXlFdklqekZvSHNK?=
 =?utf-8?B?aUg1TE9PWTJteUF2UFVUTC9iYnpDU2RPaTRYWGdDZ2x3Ly9GYWVHVURTNlZk?=
 =?utf-8?B?WXBuQ1YyYVRjNS8vY1V5YUdnN0l5c29adGlUNnhWUmxNU2IxK2tQejVtSVhs?=
 =?utf-8?B?V3V1UWxjV3paQUdNNjE0N2o5cnE1YmtGdXp4emJwQzR0YXpneUpZME1NREVB?=
 =?utf-8?B?U3N2RlhTL05NaUJtbEhFRHlxK1A5dElJT1lBdVN6L3kwU043ZGRxYW1KUEZJ?=
 =?utf-8?B?V3dUL0hNb0xLVnJHRnBCTGRNdVR0bEhIYU5mZGQwRFN1RlFVQ0JGZmR4ditP?=
 =?utf-8?Q?FA4yz3pwF/PLx5hojAo0M+OC/dezOLLv?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+eaAJcXa96i9ol6b9mbclcOtrDPGVdY8XTdwLcEJF6gnab8AE3pYG1VOCuykKgNSPlWhj4ygVu+xdsxcm6SXfnB8WHRvTnwMmZFuvT30WHxlnF3yuCKp2/wl12t8h/wlYyTdlR2mq3IJTwAlQV/AmmWHEs7F4Y7ckUEOuxirzsAs6ilbv7n1bFzD68Ktv1PXr9ITLplDZkvI+TVKQZboh/Ee2qVfLLGlYiTpgQBewAlUrTW/nMHmC/PPsQLldL2lgWyZvceemoSbYc414w2sTtn6v8I+nvXzAUNGDqhXy09Tx2zb4EMoRtTqG2Q+XF2axF3ai0i+NXGTUCzv7RkmIEPYsWT3L8D0wQldTPft7q3SkuVqMFfI/9VFtVQlC11ZxwmFjKJigb5B3WDjLH76dZ3bpoOfjTCVop43DC/eEkgV2XL98OEgTytmaYBMUp9piMC+coFPVmX7LCfOoz6v51FLyv2UcLSAY0UodTcA5wQ1XGh5CKGS0YPMVNNnWqWm22hdnJB9yeUTrK2XWP6thdHszIab5DcJVMj3eA+K5Kf5KIxjvBscL0dEts0le8q65TQ8mfYziy3+zq6NlEayVI6EA1rY9NgqOfoaTkiPmlrNEjR2l5tBX3Z8Y0wZlQwzsEyMZhIqCfHzYJyi93B9lQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:52.7400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b4b2b7-cf7b-4006-67bd-08dd0ee91cb8
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR19MB4289
X-BESS-ID: 1732714856-111651-13407-2136-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaWhuZAVgZQ0MwozdzMNCnROM
	0s1dDI3NLEIM3SIsUg1cQ8ycQs0SRZqTYWAP8mqz9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan12-175.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Pavel Begunkov <asml.silence@gmail.com>

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/uring_cmd.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4b9ba523978d203ae23fb4ec9622d6e4e35a5e36..2ee5dc105b58ab48aef347a845509367a8241b9b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 39c3c816ec7882b9aa26cd45df6ade531379e40f..38b6ccb4e55a1e85d204263272a280d3272557a4 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (req->task->flags & PF_EXITING)
+		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,

-- 
2.43.0


