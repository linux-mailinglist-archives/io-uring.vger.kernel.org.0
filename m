Return-Path: <io-uring+bounces-6023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA86BA16546
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 03:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ADCD18813D1
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61C31DDF5;
	Mon, 20 Jan 2025 02:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="y2vZCgYG"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C284278F45
	for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 02:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737338576; cv=fail; b=CT9EpVxMcWLo5VW5fNduzBx5vFx5umBKVeBsTsBKosc069KqK/3Job5arK1AovLpYu1ykbTmxvgh+FOqMg4d+2yrKoZmPUeOL7A6gb0jxhSQS8QPZsIqtPBDo0J8Aga5I2cAsI0UCa7cLu3Zii4eFUZ+t9qN+J2EhqHYgOzqfig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737338576; c=relaxed/simple;
	bh=455vpR6hkQ2u3HTcvd4tTICV/lcjLmUkyQgxI7osccQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QckgX0zKeb0f/zO6LLYLgw+zf2VrqZ0sZ0rz3CsINLd7t0Sxy47LXDX9hogwycpF7T/vgSYgeKjJu7/n14FuNa3UM40u0ruB54jh+BRStUBhjRDSqRsPonvgNNdG5AMZzWwRJqvmcmC2z/s/SaFjU4MXQTH5G/5YikBmfHfzJXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=y2vZCgYG; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 02:02:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGjlogpVT7ag1tFrw5oDvRFG5U65fRl/vFqWwQSJO6lPmxh+ePQ/H+4SzC4zMCiTDaBXau5nCeemDbxdupPKUATMngCFcQILCoZN7eCvMCqcgAY0K9XGeVVceMahuXVO8jEasrtyT6GfghB5fAZWWJ48pTgSggD42XODZOOMG7JUGwGAlrBCFdUSfJC9ZTY4ug9TH9sf3SJGNwB0i4Q/lNvYvHA14HWRLNSl/J28s4KeYGnoA+qQcFEUCW92/pNxwqO5hyyUw5cxoXeFm5yETYihncUIQepPwmgnV9x2UeR/hyUxXLvuyaNzPhrZ9HhTl1kDcW9ml7Hzv3UcQd+ioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuXSOUK7SIRmeDldD+kaeaGEIQyBJaCc0JTjXP0ob2Y=;
 b=bX75g25jiZd71umNXJwWyXjC4yWOs2SXB3LwrqwPHXFH3h6PIbl69xIM2MMgbSdgURhMyWPoP8jeFFy9nEN6suoJW2pFH6XqdWWGsRCCdoeYGOy1iKCIdzgxz8/QsIOWv22ih91OGD7lLCFyGIdDl3lDDmIVJRCgXK7IaPlnpmcf7rZMPe7s8JmklZsPLQqjeKzYR6jiSRd+UU4vNgKDeOHXYD+kRUhxlfkT99MFGmx2sRVjkdP+c+JhZgwLLBUvdUS1Kot7MEAhWbiH6RRV2L3I2kdXFDEK4uqIQcLo9XpmkmjoVFhp/kB7fwX5vZHVCtUQ/tMBAPmwAkJZv95irA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuXSOUK7SIRmeDldD+kaeaGEIQyBJaCc0JTjXP0ob2Y=;
 b=y2vZCgYGumdD6/bbNuUDs8LVvqftUHR70UH9L5oOZY+KsZ7DhYv9O93zKyvXXtrmlHHJV4n1jxvjZ6tcMLvxemZfUO5ioDbaw0aeL2ZW0Z7dVg/lSZ6zsxT/zznLbkCEms7IpadGmo4KlccHZmNe6KYNF8Bb3VFWh2uu5mIk/34=
Received: from BN9PR03CA0568.namprd03.prod.outlook.com (2603:10b6:408:138::33)
 by IA1PR19MB7879.namprd19.prod.outlook.com (2603:10b6:208:455::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:09 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:408:138:cafe::7a) by BN9PR03CA0568.outlook.office365.com
 (2603:10b6:408:138::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.20 via Frontend Transport; Mon,
 20 Jan 2025 01:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:09 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A75884D;
	Mon, 20 Jan 2025 01:29:08 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:00 +0100
Subject: [PATCH v10 07/17] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-7-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=3717;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=455vpR6hkQ2u3HTcvd4tTICV/lcjLmUkyQgxI7osccQ=;
 b=AO6b3Ej68anZt8Umb5lLHd3PNQLshEImjiesItBszWlZo5XVSKi0sEN34351i8hFC8ZRIc0Zz
 +A1FdhOW9J/BsvYw0/AWeTnxLKGHQb0pABjLMC6rn9iusqGk2R/FYOK
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|IA1PR19MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: fd957916-61e0-4eb1-b4a6-08dd38f1d6ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3V4R0hYNXpGS3h1dHlEZ1JHNi9icm5NRG9oT0FHSzRtcTRPZ1Uvc0xsYWZ2?=
 =?utf-8?B?dm5BZTZ3Z0o3L0JBQlI4R0QzeVNoMUlaNEpjNEhqWmtTeXVLRURLdTRCUkVa?=
 =?utf-8?B?WHlWQTkzWGxHY00vRDdNVm45V2dnNlBSdDZuK1BkYUU3U3R0UldLeVJaeUsy?=
 =?utf-8?B?MzlQbHN3QXRERFVxaFluRGdHY1V4T21TOEt6bE10TUx1OUtiUnBYUnNXOEU5?=
 =?utf-8?B?K2pGSUl2VkJNZWxDWHptMm9zVndXYXJrUUk0OUhXczhzcnlodG5JZVdOZng0?=
 =?utf-8?B?eDR0NVNIK2ZZZmNUTGhwUzUwREo1NkNGSmtkSGpNVHFyTmJIQ1hDeTBsdm9v?=
 =?utf-8?B?QUZPTkRyQVBUNUgvZmw1U0xLOFIxdDlxSEtzL3dncld5aFNLUk85R0pqNUVV?=
 =?utf-8?B?VW5PR3hOa3haNlRieFpLV1hZQS9ENmtsS0E0dk9ETFFvZjdrVTN4V0p0Y1Bn?=
 =?utf-8?B?VWZyUXdnTlVKdy81VEl2dWZpU1c5Zm5vR2ZQbXlTN3VDTXk3WEFKSWRia1BN?=
 =?utf-8?B?MlZTYUw4V2p2ZjZkM0cyUEtvQnVPSnJzUUs4ekp0V3FzaDZXMUM2SmIxK0o4?=
 =?utf-8?B?N2RWMDFtdGlIWDEyK01JbEJFbjhzWU1RNTBQd01hNHZFNVRuTGZTVkMwek5M?=
 =?utf-8?B?TTVXMEtzQ3VLUFE1dnJIb0dHUkY5bS8xMi8zejZydHdNY0JFeGczcHEyRjgy?=
 =?utf-8?B?ckM4YVFndzJQV2FQbkFzOTVWTXZMS0NET091bDlMdVRlSEZXdk55cFRPaG1l?=
 =?utf-8?B?bVRlaTBhWTVYQVZ1UXNsWGVxTWJmMjRUSDJrMEovaGk4bkdlRUVxdDJuTDd6?=
 =?utf-8?B?QVFqTnJ6anJTRWZuMDJKdnRWbXV3d1VmQlJJRU11WmdtclJaaE5BNzFsa2lh?=
 =?utf-8?B?R3Y2VEx4QS9UdS9vTTBqSkpVUXRHMjEvTXQwOHdvVE13UC9PT1dDTm1PZ1pW?=
 =?utf-8?B?bTNBRnNJTmlBTFl2eW9OMlJHRll0TUpPQlprYnAxMWozL1BoU3RQYk5abWpJ?=
 =?utf-8?B?Yy9GZlVJaG9MWkY4VHdZYnpGRk1LbE9HRUpWWkNTVDlLZVBua2tqYWFYU1NU?=
 =?utf-8?B?cjJCQTZTdEVwa3YvVStNc0Rxb1JYMm1TSk1tNUtEYndXU3FnY0E4SHF4TXJk?=
 =?utf-8?B?cEJqTlEvSnB0MkdVL2VKamlaK1M3UG5SYUFZWFowQWdQZVk2bXZuWlR5YmFl?=
 =?utf-8?B?T3ZuSGR1bmM2bmtucXlGQzJ6M0JrZjhla1k5N1doek1JQTBEWG1jbUwwTEFv?=
 =?utf-8?B?LzNhbHUrMlhDNmwyVGJYanNXcTRSK1d5L1NmM25TSVdoSEZDYjhVNWw5d3k1?=
 =?utf-8?B?K0p3Vk4weUtEMUJ0TmtFRzR0ODdXdHhHOXlBL3NPcnA1VkZWZWNXeEllQi90?=
 =?utf-8?B?bFdkTjN1aWY3N1V5SUNmTjdJOEFDUE81QUlEbFltYmcxYWFRSDBheUwzM1NN?=
 =?utf-8?B?QS9sc0VqbmUvQWU2TUtOQlNoZDhFN0NSOHY3VytZeENNTWhJY1p4ME5PdFhO?=
 =?utf-8?B?WW56ZXQrS0JsQlM3QjMyRlZQNzhMN2ZKUW5OOUFWaWZYMkpnOXFMUldvajE1?=
 =?utf-8?B?U1dxR3FPMmY0VUNCQlVRR21ydnl0ZHJVWW1SRVVTKzJMNzlhVHZDcll3Tll3?=
 =?utf-8?B?aVYwb3lMM0Nvenp4Z0tQMCtlYXNKYzJ0WEgvYXdWNEN3SDZWS3VBVGVyblov?=
 =?utf-8?B?TDVSaTVLa3FSY0ZpQTM0Q3F0L3RXcjE2UFEzUjhDTU02azRCeXN4RERYc1Jn?=
 =?utf-8?B?WG5yUFBMNzZnSGRqb0F5Q1pMaHhDK2hIMHlJaFBFMGI4bWZEcmEwR1h2eEZQ?=
 =?utf-8?B?R2pkNGl3b2N5SGZZODIrZXFnWm9CREJmNHZuWjlxR3BxVEJRK0dSekNSd3Z5?=
 =?utf-8?B?SHJzLzIzQThsN2dDcEtVUXpYUEtWSittYzZsZGFnSjJNNEQxNzZDZUZOaWo1?=
 =?utf-8?B?UjB4bDdBcGJGa0ZDcXk2V205SHRUZzYyb3VCTlpOc2RHYm1sMGwyTXRpNHV2?=
 =?utf-8?Q?WVBl8xr3emZukbj6MoEXQYhWTVhZQQ=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ohtI3r1gytwdI/1Ds/oQH3cWglxA+xX5R6k8lEgd72NQKaLkIZt2Kg2MKYqmKZwWv2QiFuM8gUfRIQz3ABBHVQYX7+yznm5hM+Nl0uRxmpd9X7cIWjExhd6Zh7vJbgW/fyJSjtiVx5+mmNRLlxPSUHGuMc7tidLy2bTERaT//i/5ee8BIoIN9B5SVz2KskUeSLYYhm6JCVNlV/bHRNIva8xCojdzIGmbXHwev7wKZxpfxJBJoNxy6HVxhUcuSsZW7f0vvyvAq0IFMoybPT7I4ZxiYsAqxmbkex/jTOS7sJDZ8pz+npaJYCsDKtCqGoHy2i48ayg1X1WiHtY49LaAS8GY+a1qQqRIhJLoBlPk4kCgVwVZPgjtZfGxoeDD4BXomGAsgWgXHDJlKw6MnW8701Ljxi7HSbRXlUfOvvgAJR1WYynYdPw0wE+AXdyrA/nCMFQ1GNBTMrpF79N8b/Tn5ZQ/LbbZ1TN8KiDDvRUFnNn7hxgKVbsj0YgHpY0H/vFaYkNCzTsdvrcaNDC9EhPfBQJxPhZbu/gLaAr/JASgUPDn7pnGOGyFDCOFx88EIBLD3Fh15PgKKA5qmGMaq3jbR9FmEc4XqFc4W//PuWv4kEmaoNOrizr7KnHxy3+zmHKlOD5erpY8ff4+2oU/vv+OTw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:09.4923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd957916-61e0-4eb1-b4a6-08dd38f1d6ab
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR19MB7879
X-OriginatorOrg: ddn.com
X-BESS-ID: 1737338552-104050-410-274953-1
X-BESS-VER: 2019.3_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.56.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsZmBgZAVgZQ0NTMxMAsydQ8OT
	k1ySwxLdXAOMXANDHV1Nwi2dQgzcJQqTYWALZTIqNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan19-27.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-io-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 623c5a067c1841e8210b5b4e063e7b6690f1825a..6ee7e28a84c80a3e7c8dc933986c0388371ff6cd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -678,22 +678,8 @@ static int unlock_request(struct fuse_req *req)
 	return err;
 }
 
-struct fuse_copy_state {
-	int write;
-	struct fuse_req *req;
-	struct iov_iter *iter;
-	struct pipe_buffer *pipebufs;
-	struct pipe_buffer *currbuf;
-	struct pipe_inode_info *pipe;
-	unsigned long nr_segs;
-	struct page *pg;
-	unsigned len;
-	unsigned offset;
-	unsigned move_pages:1;
-};
-
-static void fuse_copy_init(struct fuse_copy_state *cs, int write,
-			   struct iov_iter *iter)
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+		    struct iov_iter *iter)
 {
 	memset(cs, 0, sizeof(*cs));
 	cs->write = write;
@@ -1054,9 +1040,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
 }
 
 /* Copy request arguments to/from userspace buffer */
-static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
-			  unsigned argpages, struct fuse_arg *args,
-			  int zeroing)
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
+		   unsigned argpages, struct fuse_arg *args,
+		   int zeroing)
 {
 	int err = 0;
 	unsigned i;
@@ -1933,8 +1919,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -2036,7 +2022,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 08a7e88e002773fcd18c25a229c7aa6450831401..21eb1bdb492d04f0a406d25bb8d300b34244dce2 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -12,6 +12,23 @@
 #define FUSE_INT_REQ_BIT (1ULL << 0)
 #define FUSE_REQ_ID_STEP (1ULL << 1)
 
+struct fuse_arg;
+struct fuse_args;
+
+struct fuse_copy_state {
+	int write;
+	struct fuse_req *req;
+	struct iov_iter *iter;
+	struct pipe_buffer *pipebufs;
+	struct pipe_buffer *currbuf;
+	struct pipe_inode_info *pipe;
+	unsigned long nr_segs;
+	struct page *pg;
+	unsigned int len;
+	unsigned int offset;
+	unsigned int move_pages:1;
+};
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -23,5 +40,13 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
 void fuse_dev_end_requests(struct list_head *head);
 
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+			   struct iov_iter *iter);
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
+		   unsigned int argpages, struct fuse_arg *args,
+		   int zeroing);
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned int nbytes);
+
 #endif
 

-- 
2.43.0


