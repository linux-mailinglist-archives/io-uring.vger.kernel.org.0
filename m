Return-Path: <io-uring+bounces-3003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08558967705
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 16:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 800FE1F215D2
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 14:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0808D14A4FF;
	Sun,  1 Sep 2024 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="l4n55oB+"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3630C17F394
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725199894; cv=fail; b=lCoSr6Ghx2svvmPmkWsGGAS67wr2DHzoAfkWWezQjMtkGz+RKdLGR4rh9cvQHQA21vE4nq38t1fOgPV+w5nVc5UYsXwVgYXuM27RE4YzFwS6QAc5kk7X3sEs54e/lfLw2AMhVmw+INqOIrmN4bxUeI05XYbJ4emPGERAiohXmh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725199894; c=relaxed/simple;
	bh=TfNQSKeB7F3/+dh+Af4cyQEWuwq5YHJ0xf5InxsLB9g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pad1e8wprbKxtzb9TrorYNodFzo1byDogUd3GS7xu1Ce7udZa8xU1VsFb3jlL2cwdMDjXFcyDuYoZI9vtjbhY8q6IucBqoEvHAMAIwtReaZHDBHViCj1lt81fZuFamTfi1vvnXKLvGfxbz1IdxXnB9v3uGx9TYsYp9jAJfL9Htw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=l4n55oB+; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100]) by mx-outbound47-8.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 14:11:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q8MIergY8wqEH9REI/q7rbjoZshqXaJWnxks/gQ1ujP4/Sgwc3P4rh+eHWMVS6b/tWjeNrcfxOkI9Qq2sOqs52xurIF5FFnTsd6C3pEcTBogLrUBl+Twud/YJhfKnL+v7jNAFu/JeG6p5FBCU17AcnD5ZPwfZ0a1ILK2fLFqHiuCQ5FHopPZBXNl9xcdVnn+X4XOzyKWCsgKu4db/sUy2Njbd0pQA2BkkBBuYY/27CJrutBuHaNqGYifeIGlCkNJ17nt2jdoqcO67fo9ay/1Obv3WC7bFxiWudXqFT5NJMttACHxdzM9CbelCYchE/9rD3wT+FImw6vunHAb6pRWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DT1T7381vULKsMd3buvk6qO6/yqyAwmtdMrJdlOxvsI=;
 b=J6Zqd2gtqzjMmUAz9S5axHhJxyCY1Ie3aLIVoBVFyk83bIY/m+rh0pIn2qkp/vKh6Cw8CsVVo2DP1tz0u2bUs8vHclC2ZiIqdWF3RyPsP/nBFtMZNe+OoGY31Pd8GRYaXxjbIrKkmtwkSr4n9uEwXAE7aG7u6mxRftgfrzd8IEUvc9+qhAjFwFIngO4YVsBa/GPuIOgLp99BPWM2VCQgNpFRJ2x0ChqTH/sZOodQ2xxAu9QoswYZdezbmwCDt1LHhq2AZwh5KXlnCG1pZmldm6F4K3Q3PeM801jtz4qqxytxQRYGP2puWNoTGYrizDFGZ2oz2nOGZoURJWbZC3Xi4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT1T7381vULKsMd3buvk6qO6/yqyAwmtdMrJdlOxvsI=;
 b=l4n55oB+xEEwH+kngL7Usb/UdFIpZ/Z/fSyWlYNS4T6F6l3El/GvQ4+rxCCT1JYQq2WxstO1G2By9cH1cXsItx8T3DRd9qeXIhKl8OGlNiar05ByVMbuBHhTZpwY2nAfolcdmXKOZ0kpx5dgyxEtZnYmUXQPqRN9OMM0wrbxVOI=
Received: from BN7PR06CA0070.namprd06.prod.outlook.com (2603:10b6:408:34::47)
 by PH0PR19MB7570.namprd19.prod.outlook.com (2603:10b6:510:288::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.22; Sun, 1 Sep
 2024 13:37:13 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:408:34:cafe::60) by BN7PR06CA0070.outlook.office365.com
 (2603:10b6:408:34::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:13 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 3BD8972;
	Sun,  1 Sep 2024 13:37:12 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:09 +0200
Subject: [PATCH RFC v3 15/17] ate: 2024-08-30 15:43:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-15-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=1851;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=pxJAJ9fhLRnwTzrQw0INNc/zulJ2qjLgXu6t66nWwDo=;
 b=tcAZWbgGD+w6Y72Jc4UiG1+upNbxqc2NxiT2vFWjNLqJJuuqOItFYp84ecCwom+0duIoD05mV
 4nZg8/6wOAiAY+VI/OYP4p4bTeserhCgRphqb2sKll4SyFQW4jBcLwq
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|PH0PR19MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: bbe227e4-fb5e-49e3-c820-08dcca8b2fee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1ZISXE2a2l5T3RlaXowcDY4UDU2YU5FQ05CWWpvZW5lUW83R0VrS3c4VmRp?=
 =?utf-8?B?RGxQR1AvbTNNamZGRjc0RXlzY2NpSXZ0eHd5ZGNpQXJPQmZsQWlaTENsdTlR?=
 =?utf-8?B?TjJCYUQzVjYydzZkMER1MXZPMFdFVjZ2Q0w2QnFQVGJ0SkY0T3NCSFN0MW1u?=
 =?utf-8?B?bURJdmZPMjE4RlRXY3pOOUpRNkZIa1VOQVZZWm9xWWxFNEY3NXdOSEl2OGNu?=
 =?utf-8?B?V1h3MnBoczRNell2alZlUzJSanc5ZGU1NUVpallwSk9YcVYwNG44V2hKZm9V?=
 =?utf-8?B?V0xIM0RwZzQ1NGZkcTZiQlVTZXdCZkNVZ29iRDAvREZ5aWxvRDJTK2x6TmRk?=
 =?utf-8?B?bWI2L1ZWdE92VHVkaVNaWW0xZ3UrdWxKeEtpSWpJUjFxcHp4YUZLUlh1TVZx?=
 =?utf-8?B?clk3aWhaUXpvQWVWTzNtYTNUUkR5bmJuNWdjMUhmaWNQN1lYU1pma3d0TllN?=
 =?utf-8?B?WjZjMC9uNFoyMlo3NzhNeWNrK2F1aGxmaUl5ZE1wellReTJCRlFPTTh5cjdy?=
 =?utf-8?B?cHhPOUI5Q0MyalJEUlpnVWZWYTkvdXMzVjVDYUJLNldpenh3VUgrbzQ4Qm1t?=
 =?utf-8?B?UTZvYnFma25ZZVBtSHpZbnpkNkdFMHZsSTZId1UyaU9XTkpFNER5cEdhSER3?=
 =?utf-8?B?bWNPTWlNZnpHY1lUWjg4cHpQRHR1OUVnUDhwcVRPR1FLblFob3BnYTduS1Ro?=
 =?utf-8?B?R3dmN0hka2hGMXRJQWFhZVlwU2k4dkFFaFpzMHl6M0R1UlcwOVpYVUdqQlJZ?=
 =?utf-8?B?R21qN0FFTGpFRTR4dkJpam9yZkVVM3NoWitLNis2ay9jandjUnpUTklFTUxn?=
 =?utf-8?B?SFROcWdyUlMwN2MvL1JGOVhScUhWOGZEc25LRlh6NHlRU2NiandGOENsWjF4?=
 =?utf-8?B?NHBQdWJQZWs3OTdSUlp3bFNEZ2s0TUNtbVZxQndMK1lZbEhRcFhBUmlmV2po?=
 =?utf-8?B?ZERJRkQxS2piQ3R2ZGhKa2IvY1E1Vno4dkVCNmZ4NlhjZVRTYjBPb0FtTFJU?=
 =?utf-8?B?RmcvQVVzQWtBbU9sMGg4WjZZaTU2YW5BSUVxdG8xcjhhMytiNzFDWTZYQlZU?=
 =?utf-8?B?VHdDYzM0N3VlNndzY2ltY3grV0FiRWEzaVVaOVZPYUtVQWRYRFJoUXh5T0tj?=
 =?utf-8?B?UkpVUDJ4Wkl0M3FXTE9salNwRkZsSmxKblZlSFYxZWJ5WDJabXdPWVZTajdw?=
 =?utf-8?B?Q2ZiL3crMHpwVXpSUHBJSU90UHc3RlhqcDNxaEJrd3dWYitXUU5PNlVBaE9L?=
 =?utf-8?B?Qyttb1ZoODhuS0t0Lzcrb3FxeUE1SUIvdVVGeEJBeDlqSjZPYzZ2WWEraFpH?=
 =?utf-8?B?VEloL3U1c3FkTGNnem1yZUhtcUdGbERzb1F1TFByTzdkUjlTTHBpb1F6enli?=
 =?utf-8?B?b2F6Y0NpdjhwbUQvaVpqL21QRllvZDF5R3FQd2dGa2lOakxmYzBFbjBzaWcx?=
 =?utf-8?B?d3dlZm9BU3kwaHY3TjJZb3NXZUVTMm10bzhnWUZlZXhUTkE1a2R6NVlxRTNE?=
 =?utf-8?B?OFBlTnpkZEpmNUhLOXZCMVVPbmRielZFNHdMQUJWQTBZS3FLajljcU1QamJi?=
 =?utf-8?B?eFd6Sm5JVTdjUWtZTE9DK2NxOTN0MUxjaGpoZm9hS24wYnd0WllxMUZaQkxh?=
 =?utf-8?B?WTMrdkVKUnVBM3lvclFnUHE2OWpKbmJ3V0owZjVOWHh1aCtiK1BJdG9Nb2VQ?=
 =?utf-8?B?QXd5U1dIbS9iQzJLVmZIb2JCUnkwNkxISHFLNzY5emE4VEtIVmpINkJzemF0?=
 =?utf-8?B?WXc5VlVUU3NKZGJkWW1FeWVKcThpQzFFSUg1SGo5U3c3a3lDbWx0ZjhwaFZ1?=
 =?utf-8?B?VGpJV3RyMWZiRjFJZzRzQmJ1NWVWZHc5SUVMS1Bqa00yVGhYRG9WcXJueXpO?=
 =?utf-8?B?TEt4S25BMExiblpHOWoyRUx0dlJKWTJ1QndYczUwYVlmNlF6YW5Bcy90VmM4?=
 =?utf-8?Q?pD+j8lbA7WhmpIozqEt9Vi3fGZi5qXSF?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XI3b2McSECQtuQHo1CG89xJVbE6kdK5Zbg93/CNReyXQ/npUusmOeccArPjJLAPXum+JPHEnngs0VHhcyRZIr9sygIwhYpr7S0UXpGUUFkc+xbPjDpxIEn+5JVu7kyP6tR500WzJNAs5RXuConZqpptSw42gmPAgPnvKH5Z1aIj9S/LQh9KsncRFygZdoRiUKPQqkrsS+EA8vEZnpVd/MvaGUz2jgS0cgKYbJv/0FBXKYxgey93yfR13LyVEScTLjll6id0dlNfi8XgIoGAB42fsGH3Gz8CRHkVpfLUgNazX48PruuHCMnVCW9KDLXcaZUIwI3XS1Nbfna2o9Re5Xfz59/HUpsR9Ql1dIdd5D7cqN0n/tXmnZJlhcAr64EH8VNcHRGmY6MrRMt8N6QHXG3L+8hkmaeO27W4DbCJ2TpZ1Co5pJTQgc68337zw3gqVJ6SmvEgDtgHPQ2Uv1w6+V1YPnUZJ0BTTHQam0oQPT2UtMuD+FeyXqZkdP1j7qiDdvGC9AbhmpA+EEXMD9R/9pYwc6Tff5N22z1G1DFqWmg+qZvgaQcX1XZhyIgC15iVn4qv3415GXsEkYv/LCUDDtydvNsgboigbsqiOJhdJzK3yfbadulalPotCqcC/mho1lifIKbV38KB7wId4/Wy3pA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:13.1804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe227e4-fb5e-49e3-c820-08dcca8b2fee
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB7570
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725199891-112040-12656-1465-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.58.100
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWpgZAVgZQMDHZwDTFJMXA0j
	Qp0TjJPMXYLMnEyDLFJDk1LdXSzMJMqTYWAGA88etBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258744 [from 
	cloudscan8-19.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND, BSF_RULE7568M
X-BESS-BRTS-Status:1

From: Pavel Begunkov <asml.silence@gmail.com>

io_uring/cmd: let cmds tw know about dying task

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
index 7abdc0927124..869a81c63e49 100644
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
index 21ac5fb2d5f0..e6d22b6fc0f4 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned flags = IO_URING_F_COMPLETE_DEFER;
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


