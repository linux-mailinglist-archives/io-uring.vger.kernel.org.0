Return-Path: <io-uring+bounces-5707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0765A034C1
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 937D91642A1
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466B513635B;
	Tue,  7 Jan 2025 01:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="RleUVS2p"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0524786329
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215136; cv=fail; b=f64zxFf+C9q2/I/To78yVEhtj54Ev8fiuJnkB0KAoLHHbSjQKsROa89kPjIcD/DXBW9ASc6BR71J+7YIqll969pKzFwvAyjzTEL4tYfuVgMgpQLwEDHog9tTYjwLiGvpu6/0+yH7x5XguQb1ajKVvy9bVmD5dbLmfNCTf50+lpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215136; c=relaxed/simple;
	bh=dSCAEfSgLkiYei/XmiPlLaIXgD77ZRwwbeQrvA8DELw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ioh6Hmhg0n06PNt+NZraaKDdmocmJljDnUSnzr9scfzzT18Jw7qVlHCnmhBefDSLEf8/u2utP+ilctyWrIi7SSZiLeJAQ4el/1O7p7CnraIROHK3ILhqj+jbL+Wsjbsi2Fu0ncDcUnlo0zh10rMzB+TYnV33QRzwaNGLhJzvWmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=RleUVS2p; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49]) by mx-outbound14-191.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:58:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPdVFumbEEwsYltgl/EnyIZefj3yZHlAn9vZrmJ4utGsyAH5w8BwIbUbkjPT+Om6OwUyV+lPVEBGc1JTxhkJMCGqxI1SOmLuMj7Yjljm5PW/Y3K+KssvQgPgsStqNPKW6bNA7kqVaa9fNkYKV0EK3ZH+z6pYKw0kpNBeXkmcH53krZMoZ4SfgRponKZV+H6jQt/HCA3FOnOQokQF4kHp2D6tFlSszxMg7op2DxID52vNFplXENgzi/B6Vsb5eP+1lY0dJuaAccwSHHshxpSJBJUIbaKOzLHE76XFmPz5gD09gaRP4zEppRGSs/kVg5QgjfzExJXCOMI1aKPVDot2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=325DGlVwqkIo2XMaBUFl9I8Ms5qb5Pj43WbHrk7BX1M=;
 b=oPni5xqbC2umX3lP9j/eFK8kOhoI0QyS6M7Opgqn8yEPaycPxlcKLzT1+dp6SopZxh1AYB1++n4TkpsUnvk9XBmrdISTteJHtpRQwTlKvPYsePmwn0JtSA+jXyg2Mblm8OMKo0IiGmLUooaeCiXYS0XjLdrPRNGBdTZ1/SZrXCURA5EBFfpheEtyTOHjwPNLB33YZNUC3X3GinrWO6tnRR5rvUdqEGu0UBPhZvfEPKZCvEk+CGJYxceEBS3/Xytr0nc10aERLSiUrEag2D3T5HaPwUhtGa37btAjTbhGBdb906LtVjnrTpJTuzzbectx7K83VCVCOApwv7lfCG/Rqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=325DGlVwqkIo2XMaBUFl9I8Ms5qb5Pj43WbHrk7BX1M=;
 b=RleUVS2plCeabe92h0hkiS6S3DkiQD2EuWLE1nEIaSzRYGp3EmnTqlVJ7BUOitlOj31qPDob11wJY1HGC8EHkZxaq4isR48jineR7gsqMCx1UuA4wYGfm+T7VFAOJQs66B6gzvNAw8a8KEX1vJ3diK9jY8yNsv5z5ndeiAPxKtw=
Received: from DS7PR06CA0002.namprd06.prod.outlook.com (2603:10b6:8:2a::16) by
 SJ0PR19MB4638.namprd19.prod.outlook.com (2603:10b6:a03:279::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:22 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:8:2a:cafe::80) by DS7PR06CA0002.outlook.office365.com
 (2603:10b6:8:2a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:21 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 13F7D55;
	Tue,  7 Jan 2025 00:25:20 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:15 +0100
Subject: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=15633;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=dSCAEfSgLkiYei/XmiPlLaIXgD77ZRwwbeQrvA8DELw=;
 b=c/FjBv3MuoN/44I6pCadtnJ3iessvpuWUr8uUWsD0SDJ2BTN+BvLEuycFDlK3iZjJ8nbyKsSU
 RsLMiEOa1jmC+z/iGhVvmkigX/evI4KllSgDfQ6ZUJsrrTxBDi5x/OW
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|SJ0PR19MB4638:EE_
X-MS-Office365-Filtering-Correlation-Id: bb6258fb-5749-47a8-6425-08dd2eb1c5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWxZcGtaVmNWSzB2NU5jQ3JvMm1pOVVrQmhSd1AzUWNCSzRKR1NBUXhMVU93?=
 =?utf-8?B?M3p0ZHhoY3FwU1VPUUVmU0t6UHVJYk40QUlZRjhCbGR6K3FlR1JzYU5jZU8r?=
 =?utf-8?B?ZlY4SjJBbjB3N2lycVVYQ0JHRG9CRHFXL1J6YkUrbUtpOGx1TnQwanRwQklJ?=
 =?utf-8?B?dTQ5Ri9LVnhnWS9Dc3lCencvdzZFTjZIV1A3YjVvOHBOc2NNcy92Mndsb2hq?=
 =?utf-8?B?UncvaUhkbjJUMHNjeC9ZbHNvVFBvSHZuNjB3ZEN5czRtOTkxMDVHNTRDN2ZW?=
 =?utf-8?B?Y2I4Yi9vQndyV3QxRlBFUm5nMERHYUpralpYbFN6a0dDV0xJcWVXTVBZaVFn?=
 =?utf-8?B?VFVLTEFRbDV3YTdGMkl2Z0VJV1ZLbFhsM2hIL3AvNTRRMTJ5bUJ1OUJ1MU1W?=
 =?utf-8?B?SkN0elQyNitCY1dpamVjVU50WkIvV05GcXY1RzdnNGgwREVxd2dsYXlsNGRm?=
 =?utf-8?B?eWNablM1TjJyQ2Zwa0t3ZE5POUsrWmNLc2pqQm82ekpvSmJING0rVVNVU1Zj?=
 =?utf-8?B?RHYvWVpXaVdDdGRucDZEQS9mbFdSQTk0V2JnTC9kc2VodjR4a1VWUWVtSjBy?=
 =?utf-8?B?SFA2dFM5ZzlSbjBtMkxVYk4wQWRuS1BhK002U0FpNGI5T0FibTNlQUxxMnhU?=
 =?utf-8?B?TFhsdVQ4aUNEYkQ1WlNXV0xXY1R4bEVYdTJNdGx1QmMxZ3lDUHBzUDEvb0lj?=
 =?utf-8?B?MlRLdy9KSkh3NU1VNCtnWS9sUGh3WU9MaEsrc1Y4YlB6R3RkcUV0dWJvNDN6?=
 =?utf-8?B?QXd2RHJxaDJXZlB6aXJnSzhmZUxIdXhpOXFTWGd1TG8xTWpnbXoyV1hhdkxt?=
 =?utf-8?B?K1VCU3M4M0UxVUIyWUpyWmI1NEx6YVpaN1JsV1R0VHNkUEk5M3Rqamt6L3BM?=
 =?utf-8?B?MURWcCtsV082eS85Ry9GeUhtTWZUNHNoNEpqUWU1MUZKNVMwUlJmTUV1Mzh4?=
 =?utf-8?B?a2tUa2hkN2FVeGRKWkF2TnZiWVBLcTFqMWtiYnFwU2RTZ1JNZWN5WWN3SkU1?=
 =?utf-8?B?VXN6TEdkaGpDbW1KUkpERUZTV3NHTmNqL2k0ajBtalNCWEJ3a0F5UHpxOGxU?=
 =?utf-8?B?b29hUkwyd0ZCMnNCcXVLL2NXOUR0MzA5cm9Xci9pdUk4WWIzb01lUHJlOGtI?=
 =?utf-8?B?eFhtbk5jcDBuWVhKMjVOdTUyOVIvWVpMN0tSamk2bmQxeitGRXN5YUgrSWJu?=
 =?utf-8?B?THRLdkd3RzI1TXFpZlFVbzVMd3dNaVFMclJNQWdpc1E2SWQ4VDRXcjZJRjdQ?=
 =?utf-8?B?M0ZlS3lKM0NidUE1MkdROWlESVVadWZQb1VrSnFaV3hmRi9RWDNMOW5MT3Ix?=
 =?utf-8?B?QlRvWEg5djFPTi9Cc0VPRlpVcXVMTk1WS01EL3NRTllNRU1UNFYvZXZwZnVq?=
 =?utf-8?B?bzlndWhLZG1Nam1RbHZmekM2TTA2Sit5TThpaHBZbXZqOTRiRGNic2M5TW41?=
 =?utf-8?B?Ryt1RTN4dlVHTUd6S1dqWXZuWlVZWDd3N1UxaG9wWUVUelpvNzRUR3d2Zmp0?=
 =?utf-8?B?K3o0dHlXbUZDcFV1aFh3V0c0Y1BkQ0VtTXdPN1dPYVBvZ2Z5Z0g2MDhVK0tE?=
 =?utf-8?B?N2dVV1JSeFhkc2dtOHcwdU91NTY5dGRyTUdGOFNIa2U0RFI5bnA3SFR5Umpn?=
 =?utf-8?B?WTJGQmtVNzJlZ3ZWNHRPQWpCREJlQzBDSzFoWXU4TzAwNFdHenh6ODdtNGtY?=
 =?utf-8?B?Q1FTSkF4bW02Z2hoeHF6c3FrN3psODk0NHV2RTNmVE0vbUpWbXMzRitnUzJE?=
 =?utf-8?B?c0VteU1yK1JXSnIrL3B5VTBWeFRocHJNMWJlcWxZdFRGNnNsUU5kWjY0cHZj?=
 =?utf-8?B?V0o2b25NZzQ4M3NydTNoc0pNMStGLzJENjUwWDhlMVprQVFJeEJJTDJQL3hW?=
 =?utf-8?B?WVE4bnkwLzM4eFFMcTA4VGMyM1AveUNuSElDTVRRMFF2c1g5bUN6U2tZNVkr?=
 =?utf-8?B?ZkY1a3RqVEhrR01wV1ZKaXFOSGxCU1dtczRzRDBIRElKWUJIOXp3MGhySDVq?=
 =?utf-8?Q?SGsDCSNMqQGeJJjJXZfRPbtK94slHc=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	07A0DFYzdIPRzz9SFzNeu8MhseBQCoccxpDmu1ztgQx17nigO+HATfbo0uMBao12DXMsQMUYPysbXLsvsY26AssTUIPaZsI0fRuIw+VoX+lU4LWy6rHpUEKMwd5t2RiHj9ghc5gf/aC0Aae0LT0mZMjoC4nD8y+3Py1+URBlgKj05i88rXNZeOYsda02qOMkLWcKEpY3kqU+HRoFx3pZjViQ9rK/3tyfg8k0cbqgFjHEZ82R47POiiLDw7sjFMvZ4I6/h/M3yM4yf/KQlQFG5dzPLey+6XiOSFUYJ7IjE4tg3e8DygF61+/jFrnRUTudLlnlPFqxtPo2k2q1iO+zw4Jf8ny266UGQ3RKFAECH0Zo5dqvs0qkPkNJ5Uz5D7zQZbl0TEXto7dvGa2U5Ps5fBvV5TauozF5SvX8x1DoTkMRa3nXwdc2cfrDre0+LxDPAbMIqB4lK284KFKWSnwL05YOvM9IdW23bia49kYI8Y2QeGl0WV9Mau7jAjr1fGeML4hqT3Fz8tYu1bGbw/yLGZPcNF4J1pJM339F5zaTbDGHAkvpfKm0G24dJXNf407FWZcqLu2araY/C3f6PorBVjNO2l3jQ4rJd5l+FCSSgXhxtxALNf7U1K/X7LvvYeo/teK4914K8SspZcb8J8wj6A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:21.6321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6258fb-5749-47a8-6425-08dd2eb1c5c1
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4638
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215130-103775-13339-57251-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.58.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamBqbmQGYGUDTZ1DzZyNjQOM
	3C1NI4ycjIMNU42SjNIDXFMskyMdkyWak2FgDg04/zQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan17-177.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  12 ++
 fs/fuse/fuse_i.h      |   4 +
 3 files changed, 466 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7d118a9416898c28 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
+			       int error)
+{
+	struct fuse_req *req = ring_ent->fuse_req;
+
+	if (set_err)
+		req->out.h.error = error;
+
+	clear_bit(FR_SENT, &req->flags);
+	fuse_request_end(ring_ent->fuse_req);
+	ring_ent->fuse_req = NULL;
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -41,8 +54,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 			continue;
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_w_req_queue));
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -101,20 +117,34 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
@@ -128,6 +158,214 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
+		/* Not supportd through io-uring yet */
+		pr_warn_once("notify through fuse-io-uring not supported\n");
+		goto seterr;
+	}
+
+	err = -EINVAL;
+	if (oh->error <= -ERESTARTSYS || oh->error > 0)
+		goto seterr;
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
+		goto seterr;
+	}
+
+	/*
+	 * Is it an interrupt reply ID?
+	 * XXX: Not supported through fuse-io-uring yet, it should not even
+	 *      find the request - should not happen.
+	 */
+	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
+
+	return 0;
+
+seterr:
+	oh->error = err;
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
+	int err, res;
+	struct fuse_uring_ent_in_out ring_in_out;
+
+	res = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+			     sizeof(ring_in_out));
+	if (res)
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
+static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct fuse_in_arg *in_args = args->in_args;
+	int num_args = args->in_numargs;
+	int err, res;
+	struct iov_iter iter;
+	struct fuse_uring_ent_in_out ent_in_out = {
+		.flags = 0,
+		.commit_id = ent->commit_id,
+	};
+
+	if (WARN_ON(ent_in_out.commit_id == 0))
+		return -EINVAL;
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
+		 * Some op code have that as zero.
+		 */
+		if (args->in_args[0].size > 0) {
+			res = copy_to_user(&ent->headers->op_in, in_args->value,
+					   in_args->size);
+			err = res > 0 ? -EFAULT : res;
+			if (err) {
+				pr_info_ratelimited(
+					"Copying the header failed.\n");
+				return err;
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
+	res = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
+			   sizeof(ent_in_out));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_req *req = ring_ent->fuse_req;
+	int err, res;
+
+	err = -EIO;
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent, ring_ent->state);
+		err = -EIO;
+		goto err;
+	}
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info_ratelimited("Copy to ring failed: %d\n", err);
+		goto err;
+	}
+
+	/* copy fuse_in_header */
+	res = copy_to_user(&ring_ent->headers->in_out, &req->in.h,
+			   sizeof(req->in.h));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		goto err;
+
+	set_bit(FR_SENT, &req->flags);
+	return 0;
+
+err:
+	fuse_uring_req_end(ring_ent, true, err);
+	return err;
+}
+
+/*
+ * Write data to the ring buffer and send the request to userspace,
+ * userspace will read it
+ * This is comparable with classical read(/dev/fuse)
+ */
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
+					unsigned int issue_flags)
+{
+	int err = 0;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
+	ring_ent->cmd = NULL;
+	return 0;
+
+err:
+	return err;
+}
+
 /*
  * Make a ring entry available for fuse_req assignment
  */
@@ -138,6 +376,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_AVAILABLE;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
+				 struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	/* commit_id is the unique id of the request */
+	ring_ent->commit_id = req->in.h.unique;
+
+	req->ring_entry = ring_ent;
+	hash = fuse_req_hash(ring_ent->commit_id);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
+					   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ring_ent->state != FRRS_AVAILABLE &&
+			 ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+	}
+	list_del_init(&req->list);
+	clear_bit(FR_PENDING, &req->flags);
+	ring_ent->fuse_req = req;
+	ring_ent->state = FRRS_FUSE_REQ;
+	list_move(&ring_ent->list, &queue->ent_w_req_queue);
+	fuse_uring_add_to_pq(ring_ent, req);
+}
+
+/*
+ * Release the ring entry and fetch the next fuse request if available
+ *
+ * @return true if a new request has been fetched
+ */
+static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
+	__must_hold(&queue->lock)
+{
+	struct fuse_req *req;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
+	if (req) {
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
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
+static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring *ring = ring_ent->queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_req *req = ring_ent->fuse_req;
+	ssize_t err = 0;
+	bool set_err = false;
+
+	err = copy_from_user(&req->out.h, &ring_ent->headers->in_out,
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
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	if (err)
+		set_err = true;
+
+out:
+	fuse_uring_req_end(ring_ent, set_err, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
+				     struct fuse_ring_queue *queue,
+				     unsigned int issue_flags)
+{
+	int err;
+	bool has_next;
+
+retry:
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
+	has_next = fuse_uring_ent_assign_req(ring_ent);
+	spin_unlock(&queue->lock);
+
+	if (has_next) {
+		err = fuse_uring_send_next_to_ring(ring_ent, issue_flags);
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
+	struct fuse_ring_ent *ring_ent;
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
+	ring_ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ent_set_commit(ring_ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ring_ent->state);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+
+	ring_ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+
+	/* without the queue lock, as other locks are taken */
+	fuse_uring_commit(ring_ent, issue_flags);
+
+	/*
+	 * Fetching the next request is absolutely required as queued
+	 * fuse requests would otherwise not get processed - committing
+	 * and fetching is done in one step vs legacy fuse, which has separated
+	 * read (fetch request) and write (commit result).
+	 */
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -325,6 +767,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
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
index 4e46dd65196d26dabc62dada33b17de9aa511c08..80f1c62d4df7f0ca77c4d5179068df6ffdbf7d85 100644
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
@@ -70,7 +73,16 @@ struct fuse_ring_queue {
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


