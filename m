Return-Path: <io-uring+bounces-5704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B39E5A034B9
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C0833A3E91
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279725680;
	Tue,  7 Jan 2025 01:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="i2CfzpUi"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E43FB1B
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215092; cv=fail; b=GMdnm8Eeb6WhwGRW68i6MCWCKR5MG955+ZDuqA4xqlwrFIfCcqZ4bA4D77zA5aqudi90p9ZoZfqy0WOhqZG1pqhDoWDqNV/toEugvPYiX8XtlPneptjmxZwVzVx/FlODPvRlTFbcKqu5/l85F3MXWKtiudR8bzgT2kSyK5JDlfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215092; c=relaxed/simple;
	bh=1c8nwG+AvizMXYL6lMtMaTcWJG4uUtDdhcv5gi9lF1E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EORlCYLnIDaMkWq5cdYLliv9MkJxeftlE3b2lIr/iawxwhp/Ba5vi0/AgpTNDGQBRYC9VFr0o5U43cXnEoieZfgAIFu4w2l2hs1LJ+r2y9qvRSM+w9mSTgHpfgPy5nSGd2lb38ZyuvGs1oAQW7dzqjCvIbhugjm9/XkATuN8Zw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=i2CfzpUi; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48]) by mx-outbound46-163.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:57:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzQ4couGxgkijeBxosLsi9blpZUe6/2Pa0ugIN4OxuwmuiNFf7Na/ChcF9Mpr8lP2M2U/ttoiGg8bFHtG+ZSx0MujvZvg3rnhfsFlRCR6Snl3u7dwjljVrRI9CS77GORcdPi6YUVCp4M91qGPBCaoSZV4aYPWHSTm3tuGARmJY+wXWFMS/UxsngXjx8ktpMRZZbtlXqWiR4rd020sryqOgPB8v6M2i2hs5AI54biv3s/6+H7w4DBWooEjZ0to3LlZ09atOo5/mBgcrKJFAW/2i/umrTY4uB7Pc1sGrJCNUJMMxpSGNFABRra33Vm0zFCXmorlPnFhcLYPB53Z+YEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUliw8EoMQP9g855liKYfhxuE58FbYehdsrFaAXSFjc=;
 b=I6ASgoC+eeguJC1WJzvxZri4RrHMQa6dpkrGVzYCrtHSzjFH0D+BfEUMVV8rBkgDBTU+uhzhiuYqvCkk6L6q905oIBJx7OQhELzKWhKv57Fh4H8Z5xhY/ArF1K9vWG771ozPf0cLXFVOuarMDsmT5H/OhGoseCjVMkiFgLttg7atmZYu+yBYuRP1XL9SUZQEvfT65l/57YLEN9sf9vj3fvikUYt9D2j/nJo50An944ykYmtu9n2Cyd0PaWvJp1YRoDDILZfkWUZ7HUzRgtioikYSUQqImWqtxIV6Pa6ifu1a8ISA1ywMLWrkPlPyRDsTEbm62+q6oxO5HRUjRFphuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUliw8EoMQP9g855liKYfhxuE58FbYehdsrFaAXSFjc=;
 b=i2CfzpUilokoLmKzcefFwG8FggoMFmI1B3wZPiFoAJGhdS5j52aCNy+mH9spy2AHrHM+lVx8uQk6m6e6Ih0UJ2I+lj3PI7WbB1tmj7ckPHGjoQy2dGWJe1kda6RmhfMA1IP5ELS0ftMSpXCu7Xm6QaZAPuphGeaijkt87blf+ys=
Received: from DS7PR03CA0278.namprd03.prod.outlook.com (2603:10b6:5:3ad::13)
 by SA0PR19MB4223.namprd19.prod.outlook.com (2603:10b6:806:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 00:25:23 +0000
Received: from DS3PEPF000099DD.namprd04.prod.outlook.com
 (2603:10b6:5:3ad:cafe::7e) by DS7PR03CA0278.outlook.office365.com
 (2603:10b6:5:3ad::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Tue,
 7 Jan 2025 00:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099DD.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:23 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 05FE855;
	Tue,  7 Jan 2025 00:25:22 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:17 +0100
Subject: [PATCH v9 12/17] fuse: {io-uring} Make
 fuse_dev_queue_{interrupt,forget} non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-12-9c786f9a7a9d@ddn.com>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=1912;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=1c8nwG+AvizMXYL6lMtMaTcWJG4uUtDdhcv5gi9lF1E=;
 b=dCy/grhtyRwjxqSqfg4mMKq1+23Q25iF+uB+1xjeQVP5bNRlqyHuKy9ANb8LeHqx/YKM8wTiY
 6RlcjJQB45mDWxZ0Vm1fv5CvmgDrrCPq05qE1ZxsNj8hjwixhZ5hr4/
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DD:EE_|SA0PR19MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e46ae08-40be-4c5b-e8f6-08dd2eb1c6e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDl1ZHhZbEM1QmNWSUhmeE1lYWdPOGJsYUptUlVLSFZhSUxRRTFKMEp3RGtW?=
 =?utf-8?B?QkxlK2V6Y290UEUzdGVIbU1rWnFkL2pjOVZKcTEvak14V2VoNCs1bEVBSzFQ?=
 =?utf-8?B?WEcrcm1rblZFdXNXN1F0dWpmMlM3bTA3Q1ZEOTdVRzFPU3dhaGEvT3N0ZnhK?=
 =?utf-8?B?WnE0ZTluZmpaMWY2S0tSZmVSVVl1dFNKV3h3Y2NwUCtkeDZ5QUNqRjdwZWlq?=
 =?utf-8?B?dlg2Y0tEdGRiZDJFY3lkbGxCVytCVVpMYzFiRy9BQjlvTWFSMTN1QlBFL2RQ?=
 =?utf-8?B?U3ZVOTBJMjlZV1MxNGhwODhoLy9IQUtUbE9HZ3VHdEp4WFhtYjlNOEI5bWJq?=
 =?utf-8?B?dmIxdDVvV0hmZHFPL1VzNXFaUFFhRlAxV0pGL3VueVdVNWxnLzBNSGNJdFYr?=
 =?utf-8?B?RWFTQitRTTRJcGd4OFFmS3pQYjFWUWFYNmprUlI1b2Iwa29rRmluUTRBaHNy?=
 =?utf-8?B?WmRLdFB2V080VnowMnh6U3Y3ckF4bktwTGY0TzdrdXJTYnpGa01DcnJRL2xQ?=
 =?utf-8?B?YlYvQU14MWx3Z3c2Y3NEbnNPVStMdGRWaWVLdWJzQnBNWXZuMnZ1dXRnWWNq?=
 =?utf-8?B?OCtIRWpJVU0wWTFkeE9UZ2NldHpOSi9MTDlQLzZNQW9TQ0lybzJiTkpJNWhj?=
 =?utf-8?B?U3JqV1JibWtGaE0xMm5TY2dFa01yY210cDM4Qnl4Z1I3UEJNeEhSd1hxVWox?=
 =?utf-8?B?dGNSQmhlMWZRaUpFbmk3dVBIVnNQSHRZTlZPbVd6ZDV1Z1dPaCtOWVNHbFA1?=
 =?utf-8?B?SmFvblArOTl0WFJwNFhoQ2FhOVlKZEF3QldXQmdsS2pwQ3dlUVEyK09OQ3lp?=
 =?utf-8?B?cFpuR05lQzVaS21CRDkxL05OcEtPMTJaSUxOeUpBdzFwMjBCdDVkYVFsMWhK?=
 =?utf-8?B?YlYxUGc0SlJETUpwZ2RqM1E2R2dZVEJXNmVGYzJGOTZRTmRDNlZ2bGlUZnAx?=
 =?utf-8?B?NHJiZDBVR1FrSFpSRmtBd3lwOVVSVy9wTENGYVpCOU1qdUpKSTczS004RGw2?=
 =?utf-8?B?ZjlUd1B3VFhGNUM2eDRuSHBuUDB0bHUyTVNCcEtSSWkwOEhaUzlpWGVEVUlR?=
 =?utf-8?B?UEduN0htNXcyR0tNbWM0d0xHamlDTGNwaEYvWnl5OWhjamdGQy9FcWRCdlln?=
 =?utf-8?B?SkJFWXFRV21nMEhXOCt1Z3YveVZjY3V1d01Za2RvWWlzYjZjMWMvZ1RrNVJ6?=
 =?utf-8?B?NXB0cE51ekxoWUNEOVVoYkUrVWVGQVhhZnUwaTNIRkRvYUxTeW5LejVhZEkr?=
 =?utf-8?B?SlZicWszZHJvZHFyQ0VLVjRDeTJhTW1IVUwwb1lqd2RqZi9GTEZwcUUwM1BD?=
 =?utf-8?B?N3NxUzRYR3FGaFg0K3F3MEc0cTczdFhjU3BmcjRsWTZhNDVZTmV4ZHhwdmlt?=
 =?utf-8?B?NGxQMC90UDhHajlRblNLc0twMVRNVFFBSjB3aE12UzBOKzVzbU9MeGNJaEZh?=
 =?utf-8?B?d2hWRkZqQlZQcFA5RElrbkp0OUdvN01Iem9kdWwzT2Njb1NWckpqSUh3SFkz?=
 =?utf-8?B?Q0xoU255bTREOWlFMGw4c1dHakRLT05nY1dYWU8vNGRkRW0wV1lLZVAzRzFn?=
 =?utf-8?B?Z0drZkxSeXFzMWQ2TUYvZTA1bmNHQmVhaEErZmR2eXpINnF0ejFYZzhGODY4?=
 =?utf-8?B?bjAvaEJKOU5zeHZibUZkNjRqWXM4bHBBRjVqNXBkNmVRQ2h2SzZKRzJVQ1hG?=
 =?utf-8?B?SXcyVjBnNVhiS1BjRE1ZQWs2VTJ0MFI5VkR4Q1hMSEdONkN4TTh2enIwTlFC?=
 =?utf-8?B?Tmh6eHJjWmpTMnVQaVV2ckwzRjYyY2dBSEJxZWxQZjVaRlBSajNMRzlmanNy?=
 =?utf-8?B?YitWc0VXd29PWVlncnRTanVpTlU1cFI3RVduZWgyRGRoMU5WbUNaMVhkZXlK?=
 =?utf-8?B?V3FGclo4amtlNmhrZkl1TEdwaGJGeGpPcHF2dVk3QmZTdkZFUWpKOVNxOGNU?=
 =?utf-8?B?emx3U1pVTit4c0M2SDZCblRKakw5OWFSVkRWODhvQ05DcDJWQ2x2K2lrclVJ?=
 =?utf-8?Q?G2+IYCqOKcUAECRWNhhFL4YP2aKlZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	swirHN/V2Ngt7ngOKoxvuAj50LLnQldIoITnCAgm7lEJdfaCdRoFqCjNGOb3Z3V7Zuy0O1ueSSwKTcnnK3G5WGWJwpMK1RXfGsLrLvjYXzZ6VoIS5ky14Pdb0T8mv73+dQU4HyYJze/6F7DFocBmjVVh+ot6pCUcybZP3cnVAaZWQEG3RC0eaulqUqAENVhEos3XFITBHfboewlehE0RphIZ/5oCNvVXzECb94E5egjZ0g3HsO+1/d8jRnk4H8NdCRXPwzLu/XQf3F1p1yyJ+Kr+daF2/jHW9I3NxTKZ3RUg+Os1TWLMc7nnnBzQckB4Ui6WqajWOt+BzMmgGErRBM4btILvr4J9QaYvBIJqdRX++c3La60PoPbPRgb2g8iVlcm4oDhKhBATZAeKo6IJHr7HEouDrODYgoIONNiArkOpbWVqmvdogkJ/+KkXwoYxnAEdW6wzkc9iqFqZ9gO1VqJYm7jCqBYD4t/GrSnOoTBRPNWk+MZJLUq5c2c9/DQBYwjI8gzGn0iIEDVADmUu9M0NwQu6lpvhnqKekmf8Yn4BtGIfm7cXka2vcOklI65r4Vf84mvGFn4u3WxHdDg1GKwzwIqDjzvBCkVRKVfp9P0gscHmafhLb3wF//q7aL6Vc0nYSfpPw84bCTo9T8A4uw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:23.6011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e46ae08-40be-4c5b-e8f6-08dd2eb1c6e1
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR19MB4223
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215072-111939-13335-9596-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWpmZAVgZQ0NLM2MDI0Mgs2d
	Q41dgkzcLCwMAkLdHS0sA4zczUPNVYqTYWAOzGOQdBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan11-173.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

These functions are also needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 5 +++--
 fs/fuse/fuse_dev_i.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1c21e491e891196c77c7f6135cdc2aece785d399..ecf2f805f456222fda02598397beba41fc356460 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -237,7 +237,8 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 }
 
-static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_link *forget)
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget)
 {
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
@@ -250,7 +251,7 @@ static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_li
 	}
 }
 
-static void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
 	spin_lock(&fiq->lock);
 	if (list_empty(&req->intr_entry)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 599a61536f8c85b3631b8584247a917bda92e719..429661ae065464c62a093cf719c5ece38686bbbe 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -17,6 +17,8 @@ struct fuse_arg;
 struct fuse_args;
 struct fuse_pqueue;
 struct fuse_req;
+struct fuse_iqueue;
+struct fuse_forget_link;
 
 struct fuse_copy_state {
 	int write;
@@ -57,6 +59,9 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   int zeroing);
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned int nbytes);
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget);
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 #endif
 

-- 
2.43.0


