Return-Path: <io-uring+bounces-5332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF299E99C3
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8A461889641
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C221F0E54;
	Mon,  9 Dec 2024 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Evlf3tEw"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E704E1F2C24;
	Mon,  9 Dec 2024 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756230; cv=fail; b=U95o9rHATMx6NZaqVYrxDTKD9jPukteiqMFh1gZUHxTs/DBMh8Wvf9Ek8sBQrvyMb/1JpDPMx9qe4UQvKSkl+fBK0q3Ljgs+GRbCj/HIJes9di6X2gpk0YlrKT8cU96JttmH/aWwPCYm3XAkmJtoaOT8jsE2/TmOhtR4k7OKv6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756230; c=relaxed/simple;
	bh=cKZJS0TQimjXXv+dr7LLkRkboc05UBW4qYNp2Q3qbv4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OMtovRUNV6KbBiu/k4xRiRa9x5FT5FSchjEGVDO8UB5hh11kagQlzEBhW3E3gB7B4J2JBCpPXTacYoli/wDUWfbhYHpka4Fym+h8FhBp6beuwJOr5GxT+8TExqlIb8ouBOTgq4KRiJKcLkNQrIg7eE5acAcuR6MnEtK3mDy3X4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Evlf3tEw; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43]) by mx-outbound19-183.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDzfddfV1l9r3ZC/ZSkrhTFHzUnHQNf8aCW89y1gx3QO6Kswip+vhgCNutqtjVR6HfmZn0QQP8hp+WdF4r0uu+oSOZ+VnG9IDMEP/0MUX6/NXtW5eAxqdM8kCstaGMtIKPRUZtLoIZ1MSILdR6qPrl8W4q2NkJftgCLHe0+rDSAGyNXI27eMc2AR5WY/xf+F73cpxQhaYz37wh7AbYg1Xl70Gb6RlDX0WFOvYZ4HXjWOcL/gcH0Z84r6xEeLh6HNtF6xjvB7OMLHsPepyM5BvKaC9iU0AuCmbUXn8qIvM5FzBYVJUJZEiF/U6I7YsBW+mqkJ8D2A0e67C3yiWGL3EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bx/AltGE5Pl/F4L17QtrNcKDJvytw6ekIKoMMr31Jc8=;
 b=o7Ba9NoqELPV0t7FaThf7xFkuYhyztpB16NljNaPimH/nyItuA/kMn4llEpvkXGz87qHvJgpaSD3S4cX3mwsaP5Ohntj3j4tmTZvaiThZJFB4lEykIvUu6Dhy/liT9ElUkyxNA4GXrAXpt4uqimv5uyFByz1ghr0y+Y8/8egKflS48GP3tPtBpgm2OUXFcNjT3XZzDf+ajQHFWuxwGbzAfeKwnner2KjZVoSSBsThgTRhNE0WcoaS5L/oyPaBtmbPYHeP4oF9Jl/X6xc5hR/ghxNIqQCJhoWv94sxTGHvt6Zic8vEA011SwR0mpJ90tkHcayTxLboXie2xrg8PbIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx/AltGE5Pl/F4L17QtrNcKDJvytw6ekIKoMMr31Jc8=;
 b=Evlf3tEwVyELZQH/MUvuxE3lD7DV1+EOHtxQFJPpCpDeJbt6RDkYmczTbUp9IyVy1mvdHqaYf5ApAInIllxYNcIo6UrkuXEHL1ewqpGlKi1Cgn9Ir4s7aU5yw6EFiPyZWPE1YP2vo4zBjyIcuh0FCGWgg1hKxFtvec2Ejr9q1Mw=
Received: from SA1P222CA0107.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::28)
 by DS0PR19MB7902.namprd19.prod.outlook.com (2603:10b6:8:15c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 14:56:46 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::1e) by SA1P222CA0107.outlook.office365.com
 (2603:10b6:806:3c5::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 14:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:46 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 99FF955;
	Mon,  9 Dec 2024 14:56:45 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:28 +0100
Subject: [PATCH v8 06/16] fuse: {io-uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-6-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=17444;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=cKZJS0TQimjXXv+dr7LLkRkboc05UBW4qYNp2Q3qbv4=;
 b=C9ekvteGlKPISWkJv30hXMfW0KP42fEv6F1mkr0MPTsbLB5u03DgUzGR2WZ/ce6SECjIhqSoU
 iaTJo/4N7gdDZy/uWMFhEXujgHOci5HjwK1VwlcYtYjDFhRP5bMLqNZ
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|DS0PR19MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: e3dc2cf7-4f74-4ba2-47c0-08dd1861b3ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qm9uNUUyNzJHS3RDb2F6U3BzZlpONnlhbVVnNjBNMTltZlE2Sk03b2ZYSTZs?=
 =?utf-8?B?L0hEOXAxbmU2N3hGZmY3K0ZoU0pibFowZ1UvNitRbVVOM2JsTnNrN2dxOWht?=
 =?utf-8?B?RTM0NFlqdmJTWnIxeGhYZndNcU1EK1NQQkd5YTJrRGRURWlIaE5aUEdEN01i?=
 =?utf-8?B?dzR4cVcvTS9TdGpqTnoxcUZBQXNlQnJIVVdQclJnYlcvK3UvYUV3Y2ZGdTJw?=
 =?utf-8?B?dlJGaXAyRWR0QnVGWmk1OWFyendOSnBHUEc0eXFQZjhjUzNyek9NQm1UZGRl?=
 =?utf-8?B?QU9yUVZPWnNpMlBGZXVOai9jaXBYN3pkSmEwTVhZUThaWklQTmdYRE9hRmdt?=
 =?utf-8?B?QWlRTzc3c2VZTjlheHZWQ0FjL3psNE5qb1FSL1c4MXJYVE9oeE1TNnRBQjhp?=
 =?utf-8?B?VWVwelUvcHVSL1pVTkg5VmhUK0NxTnR2eFVKNFlzUHNRamx0dFZmM28yTitq?=
 =?utf-8?B?eEZ0WnlaYVluTW1XZ0JZKzQ5MWt0MW5LQ1NDRGpKUTBwK3A4Ylc1VU5icktQ?=
 =?utf-8?B?aTJEVmZCQnFuNDExUlZNaVorVWNvRzFHQ0orcnMzS1J3MU84cktuT2sxNUFV?=
 =?utf-8?B?REZhWWZtSEVqZk02UXlUeFRlL251d2JSOVh4eGVUV2UxclhDZ3lrMzMrRGtj?=
 =?utf-8?B?RTdlR3psaXI0bENGRC94Tyt2UEhpTjM4VUhmMHRTNGFaNTVObWQ0eFFCbmR6?=
 =?utf-8?B?NGN0R2tVeHZaaEdmeEJEZDArS21hbnpJemVyL045YmV2VXN2ZXNmcXVFbjVn?=
 =?utf-8?B?S1dWcFBJM2wycElKLzhJakN3b0dYTGFOalpmL0U4anVmMGpPWVJxVStCZFF5?=
 =?utf-8?B?R3NYdVU4dVg1OXFVaTQvWHNIZzVrZDR5NmZvOGdGams5Y3l3dU9IREFCMzB2?=
 =?utf-8?B?dGU5MWpKN21GV28wUDBpTTlleHZ2RjgyMzFHZ0VXeElkckMxWWRjY0szV0Rn?=
 =?utf-8?B?UitDSkI4OWZZMHA0ZmdMY0tmMmdBUXZFS0dEWVUvZGxSVjNwN2JFMGc3OG0v?=
 =?utf-8?B?TldvTk9CMEJLT2EvY05JRVdIRS9JOE5nZEFJamg0UVlhWTcxM3cycE1GR1Ns?=
 =?utf-8?B?RS9QdWhvRUVhbVZ5RzJsSXdZSDNvWW9USFVTaC83K00zTmtuSkhGTkJucktC?=
 =?utf-8?B?eW0zY0JkRDZPMXdPcHF1WmlSSlVPb2tvTXFPSHJuRHZSN2ErNlpVMDVJdVlQ?=
 =?utf-8?B?OGIzUllHcVpQYjBqM1VyKzY1ZDFLRHJlMFlKN1BYVVBabllnTkJOenl1OWlP?=
 =?utf-8?B?dG9YYzBFbEt5dUxBTEUweEw3a1E5dUl4SjZVMExZbjJKbW1Pa2RIVmI4VWFN?=
 =?utf-8?B?M0Uvek5mRWora1AxVkNxTnBqOGVReWh4K01FaytrWU1zak1GM1ErbXZUVXAy?=
 =?utf-8?B?T3lzZmFQTEhSUVBBeHdQMGhEcUFEbm95b3JwdmhKcDRCNFl6bGEyMURVUUVE?=
 =?utf-8?B?YytIT3kvU21KYlF4clRPakZnMHhrTmNNVHBrRlB3VEFEWWxnNzJyeHdFNXY1?=
 =?utf-8?B?WHcxRTl3bjFZbGtKVlpjOTVrc3VLdEUraDc5cVJIOVZtM01wYkJ4eUp5eXpm?=
 =?utf-8?B?V0hSRWYrcWczQlFyMU15T3ZnRFhtNGJxeTI2b1NTcldieWlwL0FlcmJYZGpO?=
 =?utf-8?B?Z0JhT3E0M2lON3A3TGRNQytxbHlvSHRvYlJHUjVPNHVrSVB4Rkg4cE1zYUI4?=
 =?utf-8?B?YS9SQjZNSCsyeUo0VS9FaFZnU0tBQWM0Uy9zV05aWHhub1ZjcnlVWXRuTkYy?=
 =?utf-8?B?NXo5dTFPUTlPc2J2OFRzVzFiTHFtR3UrcVlaYjJ5TkpqRTU0Ny9NUHZGL3N5?=
 =?utf-8?B?VlJUT0M5WlVmbmlpZWZ3TmlHZ0g5TWFucnVkRU5jT1JJNU9aVkxscXdRMFU2?=
 =?utf-8?B?akFQRGw1TXhTUFl1QWtlTm5zdnhjcEdoR1VlN1dGcDJpd3hFVkNzNHJhZ0dz?=
 =?utf-8?Q?jq9cvpxHN1AcNiE8f9lGSu/6SKMaWzWt?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1hqSOlUDDo1L/fdF7IfpXO/x5FEHLdtInynCfv9DQJYc1RW2FCBjaVlLHW67P66MQDt3rkeTysK7Q7tEysfnFCpTVq6qY2DS1tomoSD/ERtz/EYRsrPxKa0p1Zllo8DzMPBeglQhpF4NMNxDVBGbh3Y7zkwjMeOn1aM2pP0y3bJn0gLUXMHsmi1sBiBM1rt7b4zpV2eg0FiG2V8RtroRbHTSgFDnxd9I8eJB2ZzQkwylx3OecO926T/sZOfJXwBBNQ5zcbJIehWCx7Vh8C3GgUz43LkoVi/RUPrd+SKY1QrjvgsXuw5B54XfanBqxyYc2gIZbVep2lA+APv89ZTdocbSD8tRwKRDMX6W3LqJcnKJeg603NCGxtWnVwkYGqonCV9ZBIRHHYGEk2rpbcE2/K6ZbY4RKMVDe1oNgaLr971eO5I2Dt8zDFOcDk1GKr7w9wpo+fWG1oqmP5TaGzVVh6DRMqGxy4PDKI9qrJlwqS0ZJCDEecA7uIYKbm4VOxq+XcF+aXstDreatiMgIlZc+6mYqYKQfEr9LFPWMXmMyRvaJqiiTMqEmtF/TpZoZM2SsKS+EdXp72TtWLKSIVYc77zKaXimK24itEtWXIjF+pBDEq7mHX1MhNX9K1N6Ts6TFVBBVdYLm4hxZWFySG0gCw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:46.2657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3dc2cf7-4f74-4ba2-47c0-08dd1861b3ca
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB7902
X-BESS-ID: 1733756210-105047-13355-6305-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.51.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZm5mbGQGYGUNTA1DA1MTE52c
	LSzNTANDXRNMU4LTHF0NDMwjzR1CLNQqk2FgAwajnaQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan13-27.us-east-2a.ess.aws.cudaops.com]
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
---
 fs/fuse/Kconfig           |  12 ++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev_uring.c       | 339 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 118 ++++++++++++++++
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |  10 ++
 include/uapi/linux/fuse.h |  76 ++++++++++-
 7 files changed, 560 insertions(+), 1 deletion(-)

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
index 0000000000000000000000000000000000000000..f0c5807c94a55f9c9e2aa95ad078724971ddd125
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,339 @@
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
+#ifdef CONFIG_FUSE_IO_URING
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable userspace communication through io-uring");
+#endif
+
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+
+bool fuse_uring_enabled(void)
+{
+	return enable_uring;
+}
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
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = NULL;
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
+	max_payload_size = max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_write);
+	max_payload_size =
+		max_t(size_t, max_payload_size, fc->max_pages * PAGE_SIZE);
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
+		return ERR_PTR(-ENOMEM);
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
+	WRITE_ONCE(ring->queues[qid], queue);
+	spin_unlock(&fc->lock);
+
+	return queue;
+}
+
+/*
+ * Make a ring entry available for fuse_req assignment
+ */
+static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
+				 struct fuse_ring_queue *queue)
+{
+	list_move(&ring_ent->list, &queue->ent_avail_queue);
+	ring_ent->state = FRRS_WAIT;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static void _fuse_uring_register(struct fuse_ring_ent *ring_ent,
+				 struct io_uring_cmd *cmd,
+				 unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
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
+/* Register header and payload buffer with the kernel and fetch a request */
+static int fuse_uring_register(struct io_uring_cmd *cmd,
+			       unsigned int issue_flags, struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+	size_t payload_size;
+	unsigned int qid = READ_ONCE(cmd_req->qid);
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return err;
+	}
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
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
+
+	ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
+	if (!ring_ent)
+		return err;
+
+	INIT_LIST_HEAD(&ring_ent->list);
+
+	ring_ent->queue = queue;
+	ring_ent->cmd = cmd;
+
+	err = -EINVAL;
+	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+		goto err;
+	}
+
+	ring_ent->headers = iov[0].iov_base;
+	ring_ent->payload = iov[1].iov_base;
+	payload_size = iov[1].iov_len;
+
+	if (payload_size < ring->max_payload_sz) {
+		pr_info_ratelimited("Invalid req payload len %zu\n",
+				    payload_size);
+		goto err;
+	}
+
+	spin_lock(&queue->lock);
+
+	/*
+	 * FUSE_IO_URING_CMD_REGISTER is an initialization exception, needs
+	 * state override
+	 */
+	ring_ent->state = FRRS_USERSPACE;
+	err = fuse_ring_ent_unset_userspace(ring_ent);
+	spin_unlock(&queue->lock);
+	if (WARN_ON_ONCE(err))
+		goto err;
+
+	_fuse_uring_register(ring_ent, cmd, issue_flags);
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
index 0000000000000000000000000000000000000000..73e9e3063bb038e8341d85cd2a440421275e6aa8
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,118 @@
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
+	FRRS_WAIT,
+
+	/* The ring entry is in or on the way to user space */
+	FRRS_USERSPACE,
+};
+
+/** A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* userspace buffer */
+	struct fuse_uring_req_header __user *headers;
+	void *__user *payload;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	/*
+	 * state the request is currently in
+	 * (enum fuse_ring_req_state)
+	 */
+	unsigned int state;
+
+	struct fuse_req *fuse_req;
+
+	/* commit id to identify the server reply */
+	uint64_t commit_id;
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
index f1e99458e29e4fdce5273bc3def242342f207ebd..388cb4b93f48575d5e57c27b02f59a80e2fbe93c 100644
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
+ * FUSE_OVER_IO_URING: Indicate that Client supports io-uring
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
+struct fuse_uring_ent_in_out {
+	uint64_t flags;
+
+	/*
+	 * commit ID to be used in a reply to a ring request (see also
+	 * struct fuse_uring_cmd_req)
+	 */
+	uint64_t commit_id;
+
+	/* size of use payload buffer */
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
+	/* struct fuse_in / struct fuse_out */
+	char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
+
+	/* per op code structs */
+	char op_in[FUSE_URING_OP_IN_OUT_SZ];
+
+	/* struct fuse_ring_in_out */
+	char ring_ent_in_out[sizeof(struct fuse_uring_ent_in_out)];
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


