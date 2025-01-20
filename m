Return-Path: <io-uring+bounces-6019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C22A9A16523
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECAFC1662B4
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7C4DDC5;
	Mon, 20 Jan 2025 01:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="BRF5cQRg"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E163D28E3F;
	Mon, 20 Jan 2025 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336579; cv=fail; b=HazHjUvhguzOiBiB1QZkwEI9GPyPuez9q5dTw3nz+dpMjwjz81eUG2X9AgJWlB3qH2q0lF0zwAyawrTP3lFmnkw6i94sYVO7ClA4Soq61WqwiIofD0PH2yKgjbgA4qhfYvT7C6ke+9jth6TWVFAzFqJvlcZ3apWZdzCkvmYmiHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336579; c=relaxed/simple;
	bh=PtkHbQtgTwdO+BfyISwQHmB+lYymfSW2vYL89BCuf6Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fag6wh229TPgMxbXoeRqB/0zzI5o/b92S7YP5BjSqJdvj1U9WKhVxiRsQawlyyRzUEpksMHNc5COrGB4e/vXnzcU06XfGSGLjOrhMqFypv0CV7bToBckGGuBRFbL7oC94V7L1qariGb8BM6moTCtLijAMHumuUlRQGHHVDzcvkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=BRF5cQRg; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43]) by mx-outbound8-131.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwuD8udJ1bp5GfV0rmrSJTOpAT4dI2TYDIaEwqaFsoUKSkNulIOdQHMoYlqCYZFvDX46P8+HdFlW95jU3GKEfT4higZ5ZcSw7MXoaRr2RLS3lUFl7rdzQ2gXTkNUu4FnWdGtOjEbdqrOCKTFmpPpnUj6/k7NSobkHLFqNA2nVy8sd96Gfhs80ata3p9QnvXPzfniTRiR2kebnvQfeQD0999EOdk4UKoPgU1Powyh3jxVQQLmLTRLWHYZ7/9SdghOLb374joGaRjcoZoBILTW4YS6Tw8QTSGlcqx64ptDB6Aja6k+cLzo78H6b2O8pWrPmywYck5en1MSuvb0o1Vvig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G804zKEHS0lOfYhRhWhJaw9vJglZVJlLF+b8lscdVQY=;
 b=OowtGWpRtEqLi8o7+AKMIPPWiwcw/h97qCcxGd1UUKBo+4cC68XtTMLopkpk2OS4DIPNb+Xt3iXZ2Oo3/q9GohJv0N1uei4dX9DFiiYYroGnGKohRuPqz7pxLQ7gF9Vn6jsTP0F1UHy+fw/EiuRncC9GLjukD243yUVJ+AISs/gjJeh/PGNQn+v9dXL2C9TIAErRiKE0peH3L2OIP9tjx/IKvkG7UAvMkKL3VNFWnjEzV5k5/urhVCZjEmqyIIoY80/IRzDQao+AO4ePGqkmDHbCFkLyeiY/szrbo9ShT6wcb7Rx6ZIdctCPZlB2bb6DOhJDXIIRXar1hLPnRw/6FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G804zKEHS0lOfYhRhWhJaw9vJglZVJlLF+b8lscdVQY=;
 b=BRF5cQRgHbjroUYex+1/tcfFqvG/1ADPpt7oSRmHlnnQFNfvU945f7lCtoxXCDCFWnQU4hNdz/bZoq5msFDVZDJYAmn28vY2GNhjaQrwogU/hIsOQIt8m8t0uiBqPKLWC3ayj7CkkoeqOJp7rx+dxIr4HgsyE1CEU2SKwv/Ee8A=
Received: from SJ0PR03CA0218.namprd03.prod.outlook.com (2603:10b6:a03:39f::13)
 by SN7PR19MB4749.namprd19.prod.outlook.com (2603:10b6:806:106::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:19 +0000
Received: from CO1PEPF000066ED.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::b4) by SJ0PR03CA0218.outlook.office365.com
 (2603:10b6:a03:39f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000066ED.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:18 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 7B2C634;
	Mon, 20 Jan 2025 01:29:17 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:09 +0100
Subject: [PATCH v10 16/17] fuse: block request allocation until io-uring
 init is complete
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-16-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=2934;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=gfucKS4wCiZXcsbZYV4HxvxB7feQM2tuYjq92kan4BU=;
 b=A9ILRCoq5jQ8uDeb5rLZPV30U9Xe8njTfUKtHXfjJyjawpn031b+BwdHuop5dZNe9BJuIh3l6
 TxCmOnTAAtOAhDwtFddzSURBwVk+iIzicWlJE1BIHIeXHaKGf8Iw8a8
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066ED:EE_|SN7PR19MB4749:EE_
X-MS-Office365-Filtering-Correlation-Id: 66ee525f-1cbd-40a8-e9f5-08dd38f1dbca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTVMT05BSjNwQ1RabTdNT0x1UkIwZUxvRS9YbmFiTm56ZFg5bExZYjhlNWVx?=
 =?utf-8?B?MHA2UkNSc211Q1JjVnB1UDdUZFZQSThLMlN1UzB4MWFxbFNtcEx3QXVaUVZW?=
 =?utf-8?B?L1RNZGlVWHhEN2RhR1crR0NrZ2xlbGhpR0QrZ0VKaC9mWFpiQkNMTWNIVXdN?=
 =?utf-8?B?amRydGh1U0FkVEhoN2hRNDRMUXB4eCtUYythaCtmbE9zU1JFMWNMMFlTRDV1?=
 =?utf-8?B?cHBwczNoUFNkVW52MHNpNEhiblVkZ0xRZG9FbHhCZW1aZzVvY3Q4RTBtaHg0?=
 =?utf-8?B?dmtTWUpEbG1OcEhrZTVHeUo1VkJpUnBmMU0xS3JnWHhPS3hUUmZYZmE2RG52?=
 =?utf-8?B?RThCa0U3N1BoSTNnbWszWFRsZC80UWtsZ28wWHp2WEpUYVVuRHRSRlc2M1pu?=
 =?utf-8?B?Y2dYMXBsWTZWL0FHdlVMRFN0bGFBZGtxS3JsaXJ0TElwSm5hRlQ5MWhUV3pU?=
 =?utf-8?B?L0wzekk0Q3BGUGlISzRpSUlQelhJM3ZvT3o1ZHJ1TXFPVWl5bmJ2enM5QXg5?=
 =?utf-8?B?OHFpaThFSHkvenRLNjV5RXNVaTQwcTV5K3ZpT2VwWGNBTkhqYXNHUDY4Y2ZD?=
 =?utf-8?B?bHVEQnB1Nm41Z2lLTG5NdnkwYzZrdlIwS1l0dWptZUdray80dXh3cXFIc1Z2?=
 =?utf-8?B?Zk8xVnY4S3pOeUQvclRScURvNk9VNU0vc09NYlNWM1NsMzhJRFAyZ2o4d3Ix?=
 =?utf-8?B?dm92WHNpT3ZXSEJaWnVQTXg2cWR5b0UxR0ZySitTMUNYdjltTG5LN2RNT3l0?=
 =?utf-8?B?YldseTRnaWNLUEN4MDV3bDFnRkVhSnpod3ltWHpCSGFLMXJsUHJFYlhrZGhX?=
 =?utf-8?B?RkVDWnVtVndkZmR0MGpDVy8vRzB3dy9ySWN1OEdKTi92TjFkbW5vbFpPc3d4?=
 =?utf-8?B?bTE3eStMY08rZUIvQnk0NEw3WStncGVTWGQyS2VsZHBoVW9vc3J3d0U5dTR1?=
 =?utf-8?B?MUFiM1RWN1B6Ulg3S0FQZW9yK296Z2xHeXdhYlNXcTFCZk1CZzU2Q1hVc3Ba?=
 =?utf-8?B?MFBaVzZidVN3YUFMRFdPNzc5M09sUDRaTVE2bDE0N0JCODg5b2hERVZXSGk5?=
 =?utf-8?B?OWRpNEtUNm1mQTdLUmg5cm42MEtIM0dQY3RTQWxKWEM3WTM5K1dWS29ITE1P?=
 =?utf-8?B?MURWUGYvL0ViMytKaXNwQmdUbXVMMzB0ZnE0aEZGTGNEbnVUaG84akw2MGtJ?=
 =?utf-8?B?Q2NhZnQ4ZWhhVUZoUlh4ZjNLQVdxdzlNYndGWENHaW5wa1Q0VDFiUnl6VW1T?=
 =?utf-8?B?UXRFanVmSThTdGNoOFFKN1A2UXk3T2w3UUNxZWVodFdKaGlsUmxTd1FhVG5t?=
 =?utf-8?B?c1dSY0ZlYVdkdnhCNmRYdHlaL3UyT1hFYnJJQzV1VWdQSjZzTTJHY29GSjlM?=
 =?utf-8?B?Z3FHbmVtZVZ6ci8rTDlkMUZFZko1aEpwQlkxNFpPU0lQVEM5bSsxU1RpbUF3?=
 =?utf-8?B?RlVaem5oWlRCTWo5N0RoVDJkZmNrRFVOcWJpck16aVNwOHlTYkVyanlMcytl?=
 =?utf-8?B?VWhXbGhZNWpnam9ORWFWa0h0M1Q5MjByNEtFeXFHTDhxcW5nOXJkK0NIVHRB?=
 =?utf-8?B?Q1JpaDRhZ21ubVFxMzJYcVFUWkw5a1FJZEdEK3FEZno2OXNaT0hmdFhwM3RC?=
 =?utf-8?B?bEVpenVBaWtCQkM0dFZpajU0ZkpYczI3RDQrWmp1NC96VjA5dURYYnB5RXg4?=
 =?utf-8?B?YUhncldEYStEMnRpNlBRU2lEblFHbHBHOXdoY2x3cytEVk1ZMVBDVHFzc1lJ?=
 =?utf-8?B?U25hcG14MTNsZmFOYm9WYXZuS3R4S2gxQTlzUlFER3RaNHlVN2xXTFV6Z3J5?=
 =?utf-8?B?ZDdvZ2szNE5sTmxIMmlCUnVrUi9jZXdodzVVMWlMOEVINVZCTENjYVVxQ2s5?=
 =?utf-8?B?UGI1VW0wMSthaTRkaHBrdVYvZWk3ZHJicnhvVllYVGpHOExDNTMzdVBrbGo5?=
 =?utf-8?B?RHZDN0lwOHAxeUJCR29ZL1hnTFVGSGN4NG92V21DTmVGdzBMTXQ3b2JyZVZs?=
 =?utf-8?Q?hjECuMpuOE23sC6OXG1fdsAQlHFCBo=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mcc0/rEaAhGu/HiFvTZKhQUaW1gCwIdqlN4rd2GFHJQeasNr6LpfkHaNIZQ8g2cHBpZjPBhRNG3yv20kLaP5PiQUQyTGt0XdaxMse3CnqWPI/1DpG/ZmkWBSqEFG57PVpZRaY/e5mbQAW2OaY1r2Fe+tF1/Tx0zYoS4PKdIGqEOv7/WbFYxZMXZcAT2BgksRiteOtlpdDY+zG0qkv7RjxEmKfQ6PW8KI9lMWCPLcmt4/3v9HMENz1IssJ/XhgKQ0vTaesplTIrPyUYMluHBpOhCBqB0/dDAQVLYWGXVQmV02PjAUyCq2TZsE9mErgsAkZZNUYVfK+1r9sp6lMWhtFIXa8iZ3LjWWJ2PS7dDDCSxQ4o8qRsntGeH4JKeWHtzWL3Hi4PxHUKnn2M0qSEyIpEgwJk3HTsfg+4kSqqr59jk7/4pvJsT7HVQ3ZCIL8vFtPXbNz1J26XdUdGGv80uTm+C6Q5/64Lc8/bmYkiQ4uTCOaOnrysOR/PgPr/RvkKZNJ8k3LuLlt/+A24/gcOEhWLC1fsKD36CyQJD2Mzn1Joeb1Stbh0Cgr3dOC7/kRw872FcvHxfqBNoHHFj/rnu3MLf+2r17wor3ZU1CgrZkOjwDf3Jf+y6q5duWQ9syZUWrRl4b5D0JZKfgz3rFThreiA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:18.1323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ee525f-1cbd-40a8-e9f5-08dd38f1dbca
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB4749
X-BESS-ID: 1737336561-102179-13331-11611-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.56.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYWlgZAVgZQ0NgyyTgxxczUID
	Up1dDC0izZKNHC0tw4xSTJxMI0xdhYqTYWAMsn8YZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan12-61.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Bernd Schubert <bernd@bsbernd.com>

Avoid races and block request allocation until io-uring
queues are ready.

This is a especially important for background requests,
as bg request completion might cause lock order inversion
of the typical queue->lock and then fc->bg_lock

    fuse_request_end
       spin_lock(&fc->bg_lock);
       flush_bg_queue
         fuse_send_one
           fuse_uring_queue_fuse_req
           spin_lock(&queue->lock);

Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
---
 fs/fuse/dev.c       | 3 ++-
 fs/fuse/dev_uring.c | 3 +++
 fs/fuse/fuse_i.h    | 3 +++
 fs/fuse/inode.c     | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1b593b23f7b8c319ec38c7e726dabf516965500e..f002e8a096f97ba8b6e039309292942995c901c5 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -76,7 +76,8 @@ void fuse_set_initialized(struct fuse_conn *fc)
 
 static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
 {
-	return !fc->initialized || (for_background && fc->blocked);
+	return !fc->initialized || (for_background && fc->blocked) ||
+	       (fc->io_uring && !fuse_uring_ready(fc));
 }
 
 static void fuse_drop_waiting(struct fuse_conn *fc)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index fcce03174ee18153d597e9cd1a2659b1c237e3eb..1249c7fd4d63692413d103e72eaa5e502188d3bc 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -957,6 +957,7 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ent,
 		if (ready) {
 			WRITE_ONCE(fiq->ops, &fuse_io_uring_ops);
 			WRITE_ONCE(ring->ready, true);
+			wake_up_all(&fc->blocked_waitq);
 		}
 	}
 }
@@ -1130,6 +1131,8 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 		if (err) {
 			pr_info_once("FUSE_IO_URING_CMD_REGISTER failed err=%d\n",
 				     err);
+			fc->io_uring = 0;
+			wake_up_all(&fc->blocked_waitq);
 			return err;
 		}
 		break;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e71556894bc25808581424ec7bdd4afeebc81f15..886c3af2195892cb2ca0a171cd7b930b6e92484c 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -867,6 +867,9 @@ struct fuse_conn {
 	/* Use pages instead of pointer for kernel I/O */
 	unsigned int use_pages_for_kvec_io:1;
 
+	/* Use io_uring for communication */
+	unsigned int io_uring;
+
 	/** Maximum stack depth for passthrough backing files */
 	int max_stack_depth;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 328797b9aac9a816a4ad2c69b6880dc6ef6222b0..e9db2cb8c150878634728685af0fa15e7ade628f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1390,6 +1390,8 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				else
 					ok = false;
 			}
+			if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
+				fc->io_uring = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;

-- 
2.43.0


