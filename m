Return-Path: <io-uring+bounces-6012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D46A164EF
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F6E23A11B0
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696B1DF49;
	Mon, 20 Jan 2025 01:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="vvR3oXrU"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8381A260;
	Mon, 20 Jan 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336573; cv=fail; b=mDpT7eCSELdBW1M7Z0L7Uq1ZG4wWVPv030JoqseNO/oCL7Q+Y9/aBp/0n0nCv8Qg8S/euVNOwyFr7OJEXCXIRjpFHs0Df+A4Q4jAj8rk3W2ytl5p4/cB0uXrOf/QAT1MLLinmmmhqZ/52IoPyB/2CoTWpO/cK9dlpR0Z7C/BEK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336573; c=relaxed/simple;
	bh=MxfJjh+KWyLM/pBEqZ+TVduRkvAsbRDO2XTjnbrCNS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NtRLiFGu5wE1WR+VQICQSKHWlmRtcfo8ZkASxWGCHMjz7/0Ved/Q6uehnqZSTMCWSVAa0y3fP8FyWdtxb/2gTjsJZOnpfDJV07G6uimnQkjUyl7WpFhsNX7YEmTK2Hfhia9lOZHALoG5xG+u3bVbOEkaYRkTdgt+7rboqpnETqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=vvR3oXrU; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43]) by mx-outbound8-131.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s38ewsImeswYFuEKjg0si+vQmHQiDSeDrZhL3wFfHEb8pvpS8qfwV4zBDWnITw1V/GtjpeBgPWDahDSdrniYmdV+3/bBOJ8iiZ5+Lu1cmXQSxRLoo4HuY2CBlh+5BxGZV3FU+ZXLzS4DaK01jgdhvw/nAdDNNlRyooWCfkeG7vme0rprByKFh7Ol/WJC2U5DpqbzQ3CQLyMLbIkfl66pN/5Af4LPO9oDnFiBt1pLABedPMUssHhTnNkxIrsoFzQQFdQuvWnWxfwznizssHGaxtDRBKSVqBdbnbzXkyOrfSPPcwylOogrTOJoU122+jkaZhryykX8TvhIU6jYg08CXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROJ/GyNgfYoF7z0FAlOmFhvKYoHCgYvO1Q08mJI7h60=;
 b=d6LigeH1Ntm+qq9SaWUFYtNSIESQ4RvhijvObPOoQZ2dGL5DZTLQZGO4Mlba+Tm+5RfY4vD2VtgRlpgSc2IAGkoCwkS6s77Oc9/OJKxFldEZRKyqvjTtkyhHQskfkOEP66D3hXUp4mmnARG1CdnXnJmwsWhH0UzufhR5e+f4218Tibc/5MVAoEqHTI9W5RZI5bIFilmFm681LpQw43jMi8cNCzA14wh0y56SWuXffuTZqCXLesORS6sF9MtaOFiHxIpqStgD/R5Cu5RrT0Aou5tRkhSf2StKJiVB18DGg/2O1jvTp9bM4qKuwngxaSpGVr8IOX4I81ha4Bq6+vlrrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROJ/GyNgfYoF7z0FAlOmFhvKYoHCgYvO1Q08mJI7h60=;
 b=vvR3oXrUt69Z7VFDOgthL11fywYp1ZYHe59XW00t5x5VLjiYqXN08npNY2I+Bin2SDLLvU6gtmJpDaVOmdBjEf2PpwBLpFqf3Ajr9HV9LcUoftDZfVkuzCP1Op8Fb4jiExTcOXPlxtox7bhG12JEVxpMAKk06x7OwJzX+4rsRZo=
Received: from CH0PR04CA0002.namprd04.prod.outlook.com (2603:10b6:610:76::7)
 by SJ0PR19MB5662.namprd19.prod.outlook.com (2603:10b6:a03:42e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:07 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:76:cafe::24) by CH0PR04CA0002.outlook.office365.com
 (2603:10b6:610:76::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:07 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id AF07C4D;
	Mon, 20 Jan 2025 01:29:06 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:28:58 +0100
Subject: [PATCH v10 05/17] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-5-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=6974;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=MxfJjh+KWyLM/pBEqZ+TVduRkvAsbRDO2XTjnbrCNS8=;
 b=S3Ln79WZS1iYYtyIL72Uj+OjLgjKmk3esU/xfWoHm3Xqna/PW8E3Em66iy9u3rywyxRm55nwT
 TUL3OaO4E/ZBv1gsAJcGY0m9c6+/wKRtNkMiJJHyFWtCBxvXeV3uRZJ
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|SJ0PR19MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: d3713432-20b9-498b-d80b-08dd38f1d56e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEFZWUJnZWs5NG5ORzFrMnFwcEJ5MEtuVVRGb3I5dUFkT3VsWlRsYXRmbDN6?=
 =?utf-8?B?MllSb0NWTXg4bU9VVnlwWHYwTWNZZUJNQVJkUTZMaUFCdWVFNmFMR0hKQ2R6?=
 =?utf-8?B?TGRHSUlialpUMWM0ZUo3MEI0cHE0YXNyTVFlYWZ4cCtCSnRLQzArWmxKWGxo?=
 =?utf-8?B?YTJoUmlYMXFxY29oaFZsTEdjeEd4M0VDTlVtZWY1bjFKUGQ2dEhIeXJ1dHhB?=
 =?utf-8?B?ak5kb1Rvb2V1STVlN1ZDeTNBSXp5aUY4V2FlMDNaU1ZVZ09aMk1DdVpERzdG?=
 =?utf-8?B?aXpaL0hqSmxZNUJpMzJoVWthbHBwcFU2eFRPdklkZWlZY3VpRkFVMHAvUlZO?=
 =?utf-8?B?dkt6d1V1YkRTcWk2Q0xsc0VFbmZya1NjdXNVV2hHazJYL3AxL3BvWVY0a1o5?=
 =?utf-8?B?T2hsMkNFeEwrZTNlaTIvSHNKZm83dWxSblVNaU5TUEFyZ1J4MzNZNVRpU2NF?=
 =?utf-8?B?RTQzVzMwZW9DemtLcU5YVml4Z1h3Vi9NcDhnNUlhOExXNWxMaDFHUEQ4WWxu?=
 =?utf-8?B?R3c5bllEWlRBYWFFYUdZYU5QQ0lZb1BpVnpVUno2V045ZlVRajhNYVE2YXRO?=
 =?utf-8?B?R0taQnNMUER5YlJMUE1lemVXV1BtMDFkMU14TnA3YUlua3o1eFl1T293OVll?=
 =?utf-8?B?ZllLMndScGtpR3lVVkZ1SC92M0JmOHhidDdDK2Y3YWF4bkZQWTc3T2VkSTRU?=
 =?utf-8?B?RXMwa0RmZ0gvM2U0Mm8zNDNlSDAvYURRRXdVKzFkNUNyWEtKcUt4bTIvVGhO?=
 =?utf-8?B?SWF5UCtxa2xuMUwwYVBRQzRydEhQeklxL2I1SWhwYng1TlNNdDRram5aM0FI?=
 =?utf-8?B?czFxdm1uMFNFb0dCUjd3bE9WcHppRFg2a21sdEJUdWUwdXhLVnpOWWc4SkdZ?=
 =?utf-8?B?ZGlZR1cwall3eWRmMmwrRGIxcXdxVmdwd0hvbEd0V0xRM0lUcjBhaVJaa2RK?=
 =?utf-8?B?NG9Jb2FYam1FODR1aDhSVnFVUlZnMXZKdkRMQ2tkUGJuTVh3R3d4TmhzdzlE?=
 =?utf-8?B?NklySURGOVdSdlZBNTJJQTRob2wzZDE3dHBlb1RsOXZWNmxPMXhEVkFSVVo4?=
 =?utf-8?B?aVFoTTJKUFhMUnJBZlQyaVhQMSt4ZXpRM1JvL2E0T0IyUllmbzl2MXVjU3F2?=
 =?utf-8?B?MmhIMUtDVWNaQUhaVVdld0RWdU1CZWxreXdMRHBnVkd2OWcweG42MUtaOUNa?=
 =?utf-8?B?dHQ0d2ZMaDNkVGFCNVlzZXkrVGZhaWMzRkN1ZFA0cDBrZUpUMW5WZTNFM2Zj?=
 =?utf-8?B?TWlsYzFtcExycDdpMHdmRFBDWE5jY2VsK01abkt6UnpTV25HNUw5VFQxSm9G?=
 =?utf-8?B?VDVscFlndjBGQW9XQW84TFVJQUkzS0dEYlBQYlkzVTVLcTdvVGF2WENEMzky?=
 =?utf-8?B?QkVRNWhwNU1LRzhDWVkxVjdOa2xkcDI2N2duNlg1RXc5a0FBSTFXakJCN3VG?=
 =?utf-8?B?YzAvb0VIWUU1bmdLRmVwcUFaWmxoWm4zUDJCSXN2N2I0Q1pMd0ZETCsyTldK?=
 =?utf-8?B?bWdiWUlVVWc1d0M3YklybmNNZ0I4UytBMWVYSzRHT1Q5bStDSVFLL0hRcS9I?=
 =?utf-8?B?dkNNSElTb3V3clJ4ZzJHT1dMSmxQT2RjVE1zNXN5VjF5d3I4M1hCVWhnY0ZO?=
 =?utf-8?B?TEF5dVpBaURRZjhnMUJ5V29ZYmQ1ZUNZN29HeWNUUnRBd05VUktXN3pLRDdN?=
 =?utf-8?B?L3lLcGYzQXBLS09JUlM2djZMWS9ocGo2NnFxaU8yWVBXWld3WEh0MEZCcml4?=
 =?utf-8?B?dExsZUE0aWZPWndRTHh1U0l3aE9pZ2VFR2o1N2FoUVBWaEFaOFluSVphT0N0?=
 =?utf-8?B?UXI5RmcxaXpGTGprRWNQR1l1eDEwQmRQK0F1cWdwdXd6RmhrMHlNMVFsREFr?=
 =?utf-8?B?b1k4TloyRitWTTJVbENmdGlIT2hBZU45a3ZmRE5oaTVDR3ZMRmcrbWpxWEJp?=
 =?utf-8?B?TU0xdHNvTTBZQ1FrNE5YaXAvRXpzalhyZFZpSWllZnhHbjlLeStNUW0rTWpx?=
 =?utf-8?B?aWE1RE4vTkZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9M1/hVR+I2qH0IH8qfYaksMKdqNzTeE6ijwrEs2xHXTa37Gn9zOKlnpdtj1Mk2a/1FVaQzHtUyEb2iuD0SkAsvthrgZlFKGFjJusyWgfu676gGowcrI8Qd/Yq9pciybLBFObsEemPNqKn/LZXByAlzAh18TDgrnhwl3YaAqwx4w6G54PjqiH646AfMco5hI+59WIJ6jHUYYsgjwV4n5VMysKMlPLU+xnSI5HTrTr1QZ5O6x9vlrBYANs+uxPdRORyVwLwIu/LSqiDdOUWJ9ImxU7lLcHgg6Nilv777OVsv6H4NtslCMLHegHEWIz6f2apVVoum/+s1PdmZYBVIpaI5/RnjTYhgdqKCgjus+k93yOeeanq5RAgeL5oX9KfvL6usO/EKqvTWRnMGLi9wzQTZ2r5+5Z/bzUgm5FXXaeaDAB9Dg/IiWaYhf02IB761Nn+0JnF31f9VmZUuEWzgqOHbFegHAnFevXj2dIcGE12my9HmkPe6ae0JBCSXO1pDwkoICMSe+LPgN4aF+2eiDj9yQjDwkYisVCvUrMmqAht2BPW4m1F9PkvwBiQ4hsoVvNq6f5u0mayX38tYtvIZ33LgpZv9/6/38o/nzNF+/qsghgLdgmDRXsMhfdn0fug7r8+ncS4leblJNH5TAAKr5XNA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:07.4313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3713432-20b9-498b-d80b-08dd38f1d56e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB5662
X-BESS-ID: 1737336549-102179-13329-11575-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.66.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmbmFuZAVgZQ0NAo2dDA0NTUJN
	UyzSA5ydTE3NQwMcnSICXJ0CTFKNlEqTYWAKK1z+hBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan17-25.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This change sets up FUSE operations to always have headers in
args.in_args[0], even for opcodes without an actual header.
This step prepares for a clean separation of payload from headers,
initially it is used by fuse-over-io-uring.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Op codes that already have an op code specific header do not
need modification.
Op codes that have neither payload nor op code headers
are not modified either (FUSE_READLINK and FUSE_DESTROY).
FUSE_BATCH_FORGET already has the header in the right place,
but is not using fuse_copy_args - as -over-uring is currently
not handling forgets it does not matter for now, but header
separation will later need special attention for that op code.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dax.c    | 11 ++++++-----
 fs/fuse/dev.c    |  9 +++++----
 fs/fuse/dir.c    | 32 ++++++++++++++++++--------------
 fs/fuse/fuse_i.h | 13 +++++++++++++
 fs/fuse/xattr.c  |  7 ++++---
 5 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 9abbc2f2894f905099b48862d776083e6075fbba..0b6ee6dd1fd6569a12f1a44c24ca178163b0da81 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -240,11 +240,12 @@ static int fuse_send_removemapping(struct inode *inode,
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4f8825de9e05b9ffd291ac5bff747a10a70df0b4..623c5a067c1841e8210b5b4e063e7b6690f1825a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1746,7 +1746,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1774,9 +1774,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 494ac372ace07ab4ea06c13a404ecc1d2ccb4f23..1c6126069ee7fcce522fbb7bcec21c9392982413 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -175,9 +175,10 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -928,11 +929,12 @@ static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -992,9 +994,10 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -1015,9 +1018,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 74744c6f286003251564d1235f4d2ca8654d661b..babddd05303796d689a64f0f5a890066b43170ac 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -947,6 +947,19 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_header {};
+
+static inline void fuse_set_zero_arg0(struct fuse_args *args)
+{
+	args->in_args[0].size = sizeof(struct fuse_zero_header);
+	args->in_args[0].value = NULL;
+}
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 9f568d345c51236ddd421b162820a4ea9b0734f4..93dfb06b6cea045d6df90c61c900680968bda39f 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -164,9 +164,10 @@ int fuse_removexattr(struct inode *inode, const char *name)
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


