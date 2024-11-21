Return-Path: <io-uring+bounces-4949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6B19D5656
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CB102844A1
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 23:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14371DED6C;
	Thu, 21 Nov 2024 23:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="MsD1kFTX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A15F1D9324;
	Thu, 21 Nov 2024 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732232654; cv=fail; b=eIK2qFJVD/DAB/3iYLR5tXAOXGBt6VM+HdyAVstojdOd84vjfOt2sQN2rwvzwRein3WmRdpSD6JpZAu88gIAKpNj6tKpbp69QQgbscx6tkHThXrjyH+F4C+axCnZs/fWQ9MBEvz/bq7dizgrKTLAoROmVS8j/3qJbqDCAZ4EIb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732232654; c=relaxed/simple;
	bh=hHIbt6kUTJcNo1h8PKVWdB/7uc2niHFVNzyHIghBQ4g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KUjS+wDurN/8CbGJ8SyoCL8KOs8cetp0tf68saqoMiZNiH89vbBsQa+ZDhWPFLljLv+G01CHAJm+MVKEJuFDJ7qj/Lq1tCLSCnedWzg4V1lLgFB+aqN00tFzzPAriMMaM9ZPLOzvpmSsBfUo0xZKy/9kOQcH4PREheNEwO1Gwmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=MsD1kFTX; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound47-71.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 21 Nov 2024 23:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRonKsk4sh3JsuSfhd9ckwQ5jpGjVp98gcAKyAJEPvdRQyzYdpkn/mrFOPUOaWtVbG/n1e1niRs1LACMiHt4f2xPy1vyvqHJAz8GqKtV7KjrsynpAp1tth0MD6LOacZjwzznOi4cVDeJZZ02sU2dDGkqIc80TRKYhEZWtGNo/q6yuD5rR5LkbcCq5fScNgwLNJv5hEp1LFa+AYaqWhvWbGHgnX2edJddC55nqSL/xHNM2ZklB+ViXnuZ5AixwnyoKL3ZNbkbbJqaJm14ne/wu3tBw/pFLdS6RCDtqjlCBwTRwRq0YzJtBn73046ZWytxfP7iBFlbra8rb6akiOMs2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpCM0cnd7z4dUwxOoylIpx1vAuZ+bcl4BQ4GDi1yQW0=;
 b=DFnFrj3rq1TK6gsznvmPp4Ot1J9T3o/K0xH6isxdolqXc/ujjLRvgYqz/chfXYVkvzbOGWZ2fjWhteDU7FEatDyKprc619wlGGCUSucptik7XKd2sWtiruERyEXSPYGQWf1BGigJDsob61UXruhxm6xsIoF8Pr4i91tEw/vGWyFLRymtIAzjJjQeyEjxybWc7AlFLXQZEAqjzBRzsfEu0M0FHxnc+ONZpYLk9hUFQGKVhoKQsPDjhva08BHzP06zi53Nuf/yBi6Y17AhO7HMxQPBGSgh2MlAH8b9bicyfVMe7u0k97whPvJLV6SKMzvdUrzAFFOGft6YwVlT4AMyUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpCM0cnd7z4dUwxOoylIpx1vAuZ+bcl4BQ4GDi1yQW0=;
 b=MsD1kFTXHSIqUTaGbb9VsQztiY28Nf9nJvPlymQmT2pfM4qJ21tlUF8tu1BrLrXuojT/pWMbs7lDtK4tM80R/1pLdLc2OnNkjCUqmvVKV9CZVB4A+yWxgSmYJ/hb7sAU+SEWc9z9W2MY9XjqUcsz31CVZUUv5zVLsODRuJvtnC8=
Received: from SJ0PR13CA0211.namprd13.prod.outlook.com (2603:10b6:a03:2c1::6)
 by PH7PR19MB7001.namprd19.prod.outlook.com (2603:10b6:510:201::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Thu, 21 Nov
 2024 23:43:57 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::5f) by SJ0PR13CA0211.outlook.office365.com
 (2603:10b6:a03:2c1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:56 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id C6CEC2D;
	Thu, 21 Nov 2024 23:43:55 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:22 +0100
Subject: [PATCH RFC v6 06/16] fuse: {uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-6-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=16736;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=hHIbt6kUTJcNo1h8PKVWdB/7uc2niHFVNzyHIghBQ4g=;
 b=q9ArzBukrXUE/ImwUWwVmR6uPwF7Nn4412gg6wEt0qOjuEhO6FiJfA6+zoj87WvO/g4snpTA/
 H/rPEF4wikRBldo6fZKy9z+jaYYuyq4z8wxds4uoULJeV2cH2So7q4T
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|PH7PR19MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 1256a60d-90e5-43f0-e183-08dd0a865db0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qy9ocTlSaHNwQmdraFpiaEN4d2FsK0kyTHIrWEF6M2sraitsKzZyTGNlQ0gy?=
 =?utf-8?B?aGU1cEw0R1FWSldVcGJFZmc1S1c0YnJjYjA4aUpTQVJHTmU5cmE3bkxUbGxR?=
 =?utf-8?B?R2RNSlc3V1VpU3lzK2srdGN0SXkrN0wvdmozNXdtOTNJVE5WeDl3VTFaQXA0?=
 =?utf-8?B?bUJHTVVmWTJ4ckRuUjhBNFBzdnNFUkJJK2xjUGJES0JsV0J4S25ZMlI2dDdT?=
 =?utf-8?B?OVdadHpsamJTQUdXM3VoTzFjaTV6TDRtYTAzaWY5bjdKSm9ZZzJSeFhHdzZk?=
 =?utf-8?B?Q01CT0d3NFMxeS95RFdOdWF3RGxaYW5Vdk1peVA0VWhWdzRHeGZTazJpbDdk?=
 =?utf-8?B?YkZheUdNemZsRGcvc0VOUThCZ1lYekIzMm41RkhKUW5OczlheHNwdUk4Z2Nt?=
 =?utf-8?B?M1FQa0NTc2xXWU42d0hUdFc4NHlCOFFSYUduVG5qdG9Hek1qNXRmV1VkcW9F?=
 =?utf-8?B?V29Iak9Pb0xRbjZkdFJIei9pZ1hNa0NrNXJWUGM5SFBkcll1Wk1jK1BROVZE?=
 =?utf-8?B?VHl5ZG5RZUI5M0xza20vY2tjUWhHSTdqQ1gvWkJmNHpUN1FvQUJPTzB6cWVC?=
 =?utf-8?B?eGdKb2Y1a2tBVXNtU04yUXdLQVAzRXJpL0VDdlBPUzVTZlQ4YzlMcUdwWWg4?=
 =?utf-8?B?T2Z3cXh1VW1DVlpVZDlTcU1XN1p6SFdKWFpEKzEwVkpYSWVycUdhcmhSeFhu?=
 =?utf-8?B?NnhhK1ZlcG9nem1yWmxiTWp1YzhTekVlV1FGb01SLy9KTStNSzc4U2VvWmdF?=
 =?utf-8?B?bXAveENDdWpvWU5pZU8ySDU4OFcwZDNiYU9ZYStaNHZtRVcwVjR3Yjg0Q2tk?=
 =?utf-8?B?MjlGbEM5K042RFpuOHNiUXRiaXgzZWI4Sk5jWFA1cVBtTmt5T2w0L2FJanRx?=
 =?utf-8?B?OFFoVWY2bmNYYmRrdGlCUWJYbXV6ZE11U1JaRG1NZjhFM09vQlE3S0s1SmtZ?=
 =?utf-8?B?T2lhalBMMUdvL25kcDBxTlFlSnQwOEpBb09OeFFVY2hIeWlaUFhtZUZHelF1?=
 =?utf-8?B?a0xjeWJwM09Pb2dwa3pXR0c5VytvN1NBNlE0Y0pwUTltOG5veit2TFVrRGZJ?=
 =?utf-8?B?dGs0SWM2R0VFaEZRSzZTL2dlRmJnV2x2NHROOXdJQS9ncWtUbFZUZXl3QUFJ?=
 =?utf-8?B?bVdBYjEzOFhvQ3BvL0swVEFpOFM5SXIxMXg3OVkyd09KaTlDRlFPVzRTVXpG?=
 =?utf-8?B?VVQ0UU1yS3ZCNFcvVDF3U0RycTlYVlJXZlZCRDZqempvQThKRFV1aXgyRGwr?=
 =?utf-8?B?dmd5NjZjeUtGenNsQkJ4NUdsU1RIS0s4c2tuKzRDbFVCRHdReVdNRjZaeld1?=
 =?utf-8?B?aTZzVU1jZ3gvaW5oVzE5Y0J2SHBneXVtdmZiaUEvM1dad2lzZm5aZUdoYTJu?=
 =?utf-8?B?aDBFTFdNLzRaOUlLeURFZ0ZsSWZDdjhvVE9BYUtNT05CTzFLR3B4bU5mZDJ5?=
 =?utf-8?B?eU1ZVkVpcTNmUmpsV3EvZWFEb2d2Q0tZR09XSDN1VjZsYzhmaHIrbVNobW13?=
 =?utf-8?B?dWNrbURWT0dLeFBCbHpnM3Uvd0lFY0Q5N0NXS05BeE1hVHgwSXdKdjNyaURV?=
 =?utf-8?B?OVI1eWFuQXpucHNhMDhPakUwcDBhVjRwVFE3dGhvVHdJZVdSQkxaZjZoQTlO?=
 =?utf-8?B?Q3R0dythbHAyN0hOUk9TK29GVzJxSnRkNURHbDRrZjhkb1JKTDQvRDZteXg1?=
 =?utf-8?B?Q2hSN05NUDJSNDk1SFFvR1l6S2QxZ1ZFK1RDTjgycWdxYjYwN2hoakhYamo2?=
 =?utf-8?B?YXZzNWhjS1AxeHVPbXQ3WUkzSEZ1SVJ6ZXdybTRiQzF3SDRaVUluQUxvemE5?=
 =?utf-8?B?SmQ5Znk3MDFqaFR5S0RDTUw5MWpIK3RpcHlkcDJKeXdBUkU3eHdWNjhzVEY3?=
 =?utf-8?B?ekVmMzdXWjNGdEJ5ajZla1V5bm1YR0Z5eENOV1JtMWJuSkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q45rox9UxU7d3Lg/oPly4zbpBY4KuoJU2/WJTXAuoUh8ziKj/bNMWAqGi+juP72FaGWZG6Sn1ih+56Pco+8tXVNSL2P6ZRBqNtCldzN82H4Yn1QrNmHIB8zvpuOKAgrvgAIu1sDL7Je1g7moyQiCAzpFBx5zj95ysLlRUdveSuhh9gX7qwDbkgeXCTU5InFRsKeo76oQekDm4I3t3/7uYLqoZsLdmbrphEaY6HVcFLsyIK4F83ctv6aNssh9fQzV6atJMWQqP8EZUPdWy0SsOUUmhAsU0tvaAqXGo0iQ7tjy2kIM2SGrqobDeARIJwGNX0VTrvOYCKUjJErT673FSR0bE2ASE+/fQ+6s/7q933to/vo7uu7lVPpubEqhIq/sFLzN1WXVmTimlBSoDlEOEXCwi4KOxkudA87jErUgOH3An6W6IX/VCIsRWjF7wUjlhu9Los8dBsYzCviFJLkg6Bet5GKSFom07dw6VaikTyOIjYbonJIfCDFoRtRuzC9QVwDcS1JlK40NH0ATzfTLxHlOzDwXfbyMZUXaDXKGYNuwUAd95gMllUBF46zjagoooqgNGq8frBHYwEOngwprYTHKkieL3LInwUPyNZXM19dSPs7pOkpuLYyHUjjKGSY0VAiSvt6RsDjrAOsrkZGx8g==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:56.8215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1256a60d-90e5-43f0-e183-08dd0a865db0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7001
X-BESS-ID: 1732232644-112103-13742-55435-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmBhaGQGYGUNQoNSXV3MDU0t
	TYMDUp0TjNzDQx2dDS0tjMOMXYONU8Rak2FgA/zZplQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260587 [from 
	cloudscan8-206.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
For now only FUSE_URING_REQ_FETCH is handled to register queue entries.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/Kconfig           |  12 ++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev.c             |   4 +
 fs/fuse/dev_uring.c       | 348 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 109 +++++++++++++++
 fs/fuse/fuse_dev_i.h      |   1 +
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |   3 +
 include/uapi/linux/fuse.h |  57 ++++++++
 9 files changed, 540 insertions(+)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..11f37cefc94b2af5a675c238801560c822b95f1a 100644
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
+	  This allows sending FUSE requests over the IO uring interface and
+          also adds request core affinity.
+
+	  If you want to allow fuse server/client communication through io-uring,
+	  answer Y
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index ce0ff7a9007b94b4ab246b5271f227d126c768e8..fcf16b1c391a9bf11ca9f3a25b137acdb203ac47 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -14,5 +14,6 @@ fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
 fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
 fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
+fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6cb45b5332c45f322e9163469ffd114cbc07dc4f..53f60fb5de230635d1a158ae5c40d6b2c314ecd2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -6,6 +6,7 @@
   See the file COPYING.
 */
 
+#include "dev_uring_i.h"
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
 
@@ -2467,6 +2468,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
new file mode 100644
index 0000000000000000000000000000000000000000..ef5e40dcbc5154d8665c7c7ad46123c4a1d621ee
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,348 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#include <linux/fs.h>
+
+#include "fuse_i.h"
+#include "dev_uring_i.h"
+#include "fuse_dev_i.h"
+
+#include <linux/io_uring/cmd.h>
+
+#ifdef CONFIG_FUSE_IO_URING
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable uring userspace communication through uring.");
+#endif
+
+static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
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
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = NULL;
+	size_t nr_queues = num_possible_cpus();
+	struct fuse_ring *res = NULL;
+
+	ring = kzalloc(sizeof(*fc->ring) +
+			       nr_queues * sizeof(struct fuse_ring_queue),
+		       GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return NULL;
+
+	ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
+			       GFP_KERNEL_ACCOUNT);
+	if (!ring->queues)
+		goto out_err;
+
+	spin_lock(&fc->lock);
+	if (fc->ring) {
+		/* race, another thread created the ring in the mean time */
+		spin_unlock(&fc->lock);
+		res = fc->ring;
+		goto out_err;
+	}
+
+	fc->ring = ring;
+	ring->nr_queues = nr_queues;
+	ring->fc = fc;
+
+	spin_unlock(&fc->lock);
+	return ring;
+
+out_err:
+	if (ring)
+		kfree(ring->queues);
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
+		return ERR_PTR(-ENOMEM);
+	spin_lock(&fc->lock);
+	if (ring->queues[qid]) {
+		spin_unlock(&fc->lock);
+		kfree(queue);
+		return ring->queues[qid];
+	}
+
+	queue->qid = qid;
+	queue->ring = ring;
+	spin_lock_init(&queue->lock);
+
+	INIT_LIST_HEAD(&queue->ent_avail_queue);
+	INIT_LIST_HEAD(&queue->ent_commit_queue);
+
+	WRITE_ONCE(ring->queues[qid], queue);
+	spin_unlock(&fc->lock);
+
+	return queue;
+}
+
+/*
+ * Put a ring request onto hold, it is no longer used for now.
+ */
+static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
+				 struct fuse_ring_queue *queue)
+	__must_hold(&queue->lock)
+{
+	struct fuse_ring *ring = queue->ring;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* unsets all previous flags - basically resets */
+	pr_devel("%s ring=%p qid=%d state=%d\n", __func__, ring,
+		 ring_ent->queue->qid, ring_ent->state);
+
+	if (WARN_ON(ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+		return;
+	}
+
+	list_move(&ring_ent->list, &queue->ent_avail_queue);
+
+	ring_ent->state = FRRS_WAIT;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
+			      struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
+	ring_ent->cmd = cmd;
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
+static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
+			    struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return err;
+	}
+
+#if 0
+	/* Does not work as sending over io-uring is async */
+	err = -ETXTBSY;
+	if (fc->initialized) {
+		pr_info_ratelimited(
+			"Received FUSE_URING_REQ_FETCH after connection is initialized\n");
+		return err;
+	}
+#endif
+
+	err = -ENOMEM;
+	if (!ring) {
+		ring = fuse_uring_create(fc);
+		if (!ring)
+			return err;
+	}
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue) {
+		queue = fuse_uring_create_queue(ring, cmd_req->qid);
+		if (!queue)
+			return err;
+	}
+
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
+
+	ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
+	if (ring_ent == NULL)
+		return err;
+
+	INIT_LIST_HEAD(&ring_ent->list);
+
+	ring_ent->queue = queue;
+	ring_ent->cmd = cmd;
+
+	err = -EINVAL;
+	if (iov[0].iov_len < sizeof(struct fuse_ring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+		goto err;
+	}
+
+	ring_ent->headers = iov[0].iov_base;
+	ring_ent->payload = iov[1].iov_base;
+	ring_ent->max_arg_len = iov[1].iov_len;
+
+	if (ring_ent->max_arg_len <
+	    max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_write)) {
+		pr_info_ratelimited("Invalid req payload len %zu\n",
+				    ring_ent->max_arg_len);
+		goto err;
+	}
+
+	spin_lock(&queue->lock);
+
+	/*
+	 * FUSE_URING_REQ_FETCH is an initialization exception, needs
+	 * state override
+	 */
+	ring_ent->state = FRRS_USERSPACE;
+	err = fuse_ring_ent_unset_userspace(ring_ent);
+	spin_unlock(&queue->lock);
+	if (WARN_ON_ONCE(err != 0))
+		goto err;
+
+	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
+
+	return 0;
+err:
+	list_del_init(&ring_ent->list);
+	kfree(ring_ent);
+	return err;
+}
+
+/*
+ * Entry function from io_uring to handle the given passthrough command
+ * (op cocde IORING_OP_URING_CMD)
+ */
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	u32 cmd_op = cmd->cmd_op;
+	int err = 0;
+
+	/* Disabled for now, especially as teardown is not implemented yet */
+	err = -EOPNOTSUPP;
+	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
+	return err;
+
+	err = -EOPNOTSUPP;
+	if (!enable_uring) {
+		pr_info_ratelimited("uring is disabled\n");
+		return err;
+	}
+
+	err = -ENOTCONN;
+	fud = fuse_get_dev(cmd->file);
+	if (!fud) {
+		pr_info_ratelimited("No fuse device found\n");
+		return err;
+	}
+	fc = fud->fc;
+
+	if (fc->aborted)
+		return err;
+
+	switch (cmd_op) {
+	case FUSE_URING_REQ_FETCH:
+		err = fuse_uring_fetch(cmd, issue_flags, fc);
+		if (err) {
+			pr_info_once("fuse_uring_fetch failed err=%d\n", err);
+			return err;
+		}
+		break;
+	default:
+		err = -EINVAL;
+		pr_devel("Unknown uring command %d", cmd_op);
+		return err;
+	}
+
+	pr_devel("uring cmd op=%d, qid=%d ID=%llu ret=%d\n", cmd_op,
+		 cmd_req->qid, cmd_req->commit_id, err);
+
+	return -EIOCBQUEUED;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..fab6f2a6c14b9de0aa8ec525ab17e59315c31e6a
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,109 @@
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
+	/* ring entry received from userspace and it being processed */
+	FRRS_COMMIT,
+
+	/* The ring request waits for a new fuse request */
+	FRRS_WAIT,
+
+	/* request is in or on the way to user space */
+	FRRS_USERSPACE,
+};
+
+/** A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* userspace buffer */
+	struct fuse_ring_req_header __user *headers;
+	void *__user *payload;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	/* size of payload buffer */
+	size_t max_arg_len;
+
+	/*
+	 * state the request is currently in
+	 * (enum fuse_ring_req_state)
+	 */
+	unsigned int state;
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
+	/* queue id, typically also corresponds to the cpu core */
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
+	 * to be send to userspace
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
+	struct fuse_ring_queue **queues;
+};
+
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
+#endif /* CONFIG_FUSE_IO_URING */
+
+#endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 6c506f040d5fb57dae746880c657a95637ac50ce..e82cbf9c569af4f271ba0456cb49e0a5116bf36b 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 
+
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
 #define FUSE_REQ_ID_STEP (1ULL << 1)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d9c79cc5318f9591c313e233335d40931d6c7f58..5e009a3511d3dd4e9c0e8b4f08ebb271831b1236 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -914,6 +914,11 @@ struct fuse_conn {
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
index fd3321e29a3e569bf06be22a5383cf34fd42c051..c8f72a50047ac1dfc7e52e9f4e49716a016326ff 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -959,6 +960,8 @@ static void delayed_release(struct rcu_head *p)
 {
 	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
 
+	fuse_uring_destruct(fc);
+
 	put_user_ns(fc->user_ns);
 	fc->release(fc);
 }
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index f1e99458e29e4fdce5273bc3def242342f207ebd..623ffe6a5b20d73dffc8f2abe781953540c79c9d 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1206,4 +1206,61 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_RING_IN_OUT_HEADER_SZ 128
+#define FUSE_RING_OP_IN_OUT_SZ 128
+
+struct fuse_ring_ent_in_out {
+	uint64_t flags;
+
+	/* size of use payload buffer */
+	uint32_t payload_sz;
+	uint32_t padding;
+
+	uint8_t reserved[30];
+};
+
+/**
+ * This structure mapped onto the
+ */
+struct fuse_ring_req_header {
+	/* struct fuse_in / struct fuse_out */
+	char in_out[FUSE_RING_IN_OUT_HEADER_SZ];
+
+	/* per op code structs */
+	char op_in[FUSE_RING_OP_IN_OUT_SZ];
+
+	/* struct fuse_ring_in_out */
+	char ring_ent_in_out[sizeof(struct fuse_ring_ent_in_out)];
+};
+
+/**
+ * sqe commands to the kernel
+ */
+enum fuse_uring_cmd {
+	FUSE_URING_REQ_INVALID = 0,
+
+	/* submit sqe to kernel to get a request */
+	FUSE_URING_REQ_FETCH = 1,
+
+	/* commit result and fetch next request */
+	FUSE_URING_REQ_COMMIT_AND_FETCH = 2,
+};
+
+/**
+ * In the 80B command area of the SQE.
+ */
+struct fuse_uring_cmd_req {
+	uint64_t flags;
+
+	/* entry identifier */
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


