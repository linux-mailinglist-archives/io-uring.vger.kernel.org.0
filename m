Return-Path: <io-uring+bounces-6016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DE1A164FC
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C62301662D2
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874BFC8CE;
	Mon, 20 Jan 2025 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="KBogC/lk"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AF121106;
	Mon, 20 Jan 2025 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336575; cv=fail; b=O18+0PQYn6At/7cceA4kODJojsTiZC1AEOstw4cgeBGQt1SgxWmicRDVKSU+3ATXftiru+Wl8b+yx10CsNORe1lftQQBz6xYlOueWlaF1lzAaUoYhyy0awshpsuAp4D3No3CZ+HuzmDQVIs3KT0iDgUpfiu1DPVOcYvQBoqQoyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336575; c=relaxed/simple;
	bh=A7fY8phy6fOm8qv58F87DVyXUfT/Xm20UDYB3ujETI0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M/3EmS8gI206AjKgnzAXwD6E/GyrBbKbZHqImNHZ4PoYof7d8XUSWTpl5GKhj+sc2EffgiY/SCZiRIoIQ07/3Vi7ElR4Eph33oTUjYKolS0Q0k47EbC8IRnxyZ9qNnpn7P9v/EvBxCXkY1CgqEKG0KvwrpiGWtES3FVNCyByssY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=KBogC/lk; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175]) by mx-outbound23-227.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4fveLYB2DfWynRxKcVPPhOLoFmqsTD3z3jWJnUVL1dGaQTQMVnSHiN8BCFHGBe6I3gzI/rImgyFGdQMsXmbl7Y0YY1j5ss9mz5jFZwIACHHNDcIShZZsKv9FFDUvZS08MRUe4GYc3jVDdb9B93NIj+cGjM7NwBf8uBos85RyEKr3LCHNXLCKkH5Yt7ewuhy8mHJYjaD7hu0tf8t5FR73rfhxK2AGtyrd3qb76ZRUAl9XDFN1RVoJN+RoMWS1FkPjckB89AGgAZLoWtssUWon3IXjIV63xNcwuSQlTQemuUOqlbC+Bi2h4nHTPs0UwXTNuKJDWXspLG82i/dLFkHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikNBXQ/zdsE496uE/mPWLzONaoucBhOaWu14uv41fn0=;
 b=fosjm5cgvMZTDUMnc/hA81mL8g3SdDRebYjPiMyq9FyoBL7w64obebnUot9HbE0jx/biGfkwEtw6BZDkOTVTNZJzyTcKKr7FgCk9rYur3Hed2Jo3f2h7q++gJJRzg8h4uR1rjvw7scT30cB+V3dUijLUpKp4xxxZGnN2PHhvArjmsm15VR8b4waSrJdDubEfBfvvlezBm5dxteclOps9Lm1KnFVol/aclQeiNjzWsM8gT/5fKPQg/rxDEkt61OmFycWbFT4TjLBF6Nnl9h02DPSApsKUZvLrbblPsJjeSnvPm5oa0SsoyDmHokiZ7ddoEkWIGqAp0knyKIDZ1MoOSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikNBXQ/zdsE496uE/mPWLzONaoucBhOaWu14uv41fn0=;
 b=KBogC/lk74cvBiD20gW1BFTdNI9PnfMsi+SQ9ro6PDaNQk7AhPbUhFifyNi5egAZo1o24e1z08p5FaaICVQmobBv+UefFX11TA1kfbR2zCSqToeGH/alLy+YuWjgAjYiRqkty/JyDV2gS/s2Uk/3YtJASHe8x5KJV7QosMT7Ogw=
Received: from SJ0PR03CA0200.namprd03.prod.outlook.com (2603:10b6:a03:2ef::25)
 by MN2PR19MB4013.namprd19.prod.outlook.com (2603:10b6:208:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:15 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::f2) by SJ0PR03CA0200.outlook.office365.com
 (2603:10b6:a03:2ef::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:15 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8A9494E;
	Mon, 20 Jan 2025 01:29:14 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:06 +0100
Subject: [PATCH v10 13/17] fuse: Allow to queue fg requests through
 io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-13-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=7047;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=A7fY8phy6fOm8qv58F87DVyXUfT/Xm20UDYB3ujETI0=;
 b=LBFWKBcCzltNoBD/PhFbi8XuA35PvqA8glwxcUoliAvhCDU9PzwVgTqWJZliJ3Bj3NRU+2Ok+
 CIjhaSEDZZtBVY3kPX+kz14EODFocrv6TO7Q9PkbNIGOQt8obtRU7je
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|MN2PR19MB4013:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ee1c67e-97bb-43a6-1baa-08dd38f1da08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3BXOGQxdVJMRkhYNGlLYThpUThxUk5OanFYcHN2Y1k4WUhlOUtaWXRYT1kx?=
 =?utf-8?B?bjdQVnNKcU93ZnJ6ckUxK08wai83UHpleHVHWlJOSWx4Wk9kZmFEMjMvUGdV?=
 =?utf-8?B?VjdvZ0M2V29KZXR0SnIxb3packh0SXJyaWczZjVnWFpSVm5MTjlndklTZ3Ru?=
 =?utf-8?B?dmpMbEdENk5Nb21sQk5sZE5RSjVpSkJxR2FLQ3BYb1BTLy9ZaEtHdzYxR01Y?=
 =?utf-8?B?SlVXdkV6NC9pWDludVVwMkV0MnBXbnFPZERlcUpnMW1lWTZSb1VWSnhieUg1?=
 =?utf-8?B?WGgreWtGT3pHYjlhb3pHYzhyMFZ1ekFEZXpQSjFlY0R5S1k0RzV3Vy9TSjF6?=
 =?utf-8?B?bTlNZWxSRnN3QnJaWVJSTTdGM0JKMVZQdWhtaUl1VmNvQWl4NEp5YkE4SER2?=
 =?utf-8?B?aVpiNzVoOWZrTis3d09YMis5Q3JBdkdhWXRvS0tkMkJ4dlFzc0hJRThVcVRp?=
 =?utf-8?B?MXYrTFZwNHArWUpOQWZtUnp4SG5YaFZDYk5yYXVBcUJqT3FUcDhPcldDdWJV?=
 =?utf-8?B?UFFKTjRLVjNMOS9yZFZnNmJPRHM0YmVNWFlrbC82RmYyOWZzaG9ockZBV081?=
 =?utf-8?B?ejhsajdPdkE5VXRrVlo1OXRSRjgwVTFpbDBPcmQzMTVaa2pkNEk5S0kwNXBI?=
 =?utf-8?B?TUpZcHRDWThlWm13ZGtmUGZBSGtUNkxucGI5S0lmODNLNHdOYXRXVys2QUI1?=
 =?utf-8?B?RjN0QmVJZGhUUGd4SW4wRis3UlVtTE4rKzgrbGVUVXFPSFVZOGhsUG5udHBN?=
 =?utf-8?B?RmZtTFcxTmRsOVYwQXVmdXFFQVNoaWJ2MXBvK1N0Unk2b21LMS9iRGdlM1hw?=
 =?utf-8?B?STBaZFR2ZThpZVcyQ1RiNDd6WkZjL0lWdTNuTjZVVzlYY1lSUVM3UnRsaDZB?=
 =?utf-8?B?Q2x1R0dMa0lwUkhkMmg1dGVYVnVkRis0UVVvRlAyV1BtbXVCU3pjQ1BuZEdD?=
 =?utf-8?B?UEZTL1JTQ0FSZVE2bk1meUtWeGhzcXRuOUsvM0dNcHBleW1aZ1lYSHRsM2NZ?=
 =?utf-8?B?TU43a3VhaXBJV3N4Ny9qR21ONjNkcVBIUWdza0hjOW5FWk9DSThlTkpSdGZC?=
 =?utf-8?B?djc2aVNtUElqZStveWdIK0VLc3pNeFArUTdDUmtWdDNvM2FxMWV2ODBiSG85?=
 =?utf-8?B?ZjZtSFVkeEpUY0drcjNMekdpaEU4aTNVVXMza2tpUFMzUzQzSDNpeXJqcGV5?=
 =?utf-8?B?TVh4bUI2am9nUmttVTJSSmZSZ3dXekQvQ0ZzcjdwU2F0a3lOaE1hMFdTaHFY?=
 =?utf-8?B?MjFlOVVRQVN0NlN3VHpjSjhsZU9VYjFsWlhUN3EydDlKczdzcldaYkRCNkZk?=
 =?utf-8?B?YXdGMVJSWTVYbExjWU1TejRjQnlZVjhGSEdnbStHZlZQd1hQQzhrUTZ3azZx?=
 =?utf-8?B?dVkvdnpVY2dnUGpJY25RdFJWZWoyMlZqV25BK3B2UWZyZEk4c0xGeDNTQ3ox?=
 =?utf-8?B?dU1meDRTM3Z4cWtrZEFHTWlsN1N5RUI1QnVUOU80eU9QcmdjY1BCQXM4Tmkv?=
 =?utf-8?B?WXdvQklOL05VUFFzU050YjQ3dHpkSjZUMDA0ODVGYUVBQnVWUzRYODQwUUs3?=
 =?utf-8?B?ZmFnOHQyeEtwMytPVUJyUzlrNDhVQmpNcXFUZnE4TGZQTk5tV28zMGxoN2sr?=
 =?utf-8?B?WFJaRHpSRHJjR2pTN1c5ZERzOGViNkVySC8rbnhtUnQ4V05QWEc3WTh1aEVN?=
 =?utf-8?B?Tk10QURwOXNiUURhV0Rrb25vU3JvaExIbG1UY0p0N1RDVWFxYWFibnAyek94?=
 =?utf-8?B?cU0zODRVZUd6S1JacVBMK2xUSDh1RW1OeWxkUFVFZXFDZXJGTjMvRjhzaCtW?=
 =?utf-8?B?VkJ2TnZ6ZGxaM3BZejRkbVNIMkVGL05KUmREV3p0aWFNS29HV250WHU2Q1Nw?=
 =?utf-8?B?UG5rWTNBVk5idHRaZ1RoNmU3V0d2aHNBb1lxN3RXRFBaRlBWakVHWEpkSVNR?=
 =?utf-8?B?U0o4aUFEbzBYM1ZsbDFWVEcwWUwxZEt0TXZDMkhBellqem9weHlSaEtYODJu?=
 =?utf-8?Q?WZMI2O1l6JYv6YiwamDcy76vE5M6xo=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+RSzZzCEturujyv04BYXSbWkLP42Jj31XK1hfp3O5HzJtqnzq70g7Cq3WNCpfdc2G3GeVUrYAF9lnZfo7GWeoRCPwDbAlrF3A7i8BnBk+zogoLTDUIr8t8dgXk7lebQn+F/PSUEBiZf9TXkFynhqmDdP7RVn+s6JxGsyJ+uF77BT3pSDKEDiWjimuJZAgku65VxSack2HdAN0NUNOmqhK7/wpjqgHckvkeXoeFlX4+NF4eJZHvwQu083gQ0rLhijEHR+RP0RyOmwhlpSLUvvxJfLgvERFHyEzHwKykhbftA1DWg24lwLUnaoC0cTVvtSbI0aKtSFy5LiRKd4CANNisUd31FMRTMoawz6+XrBoj77kd0AePsD8iaexMltp2XtUPjTZvBnA/CCoJclDhq64xqDQ6Inpy3XkMQ/hnce1hUKbvrkXIV7I/+c6lgVQgmt+ftaJRS8QrrZKgQl6Rl9NL9HVtyBZZYVf/9r/YBCVZIZntMWtJDndcWtnlQM2OENhxK5HaEbwOqnlH8eEAcXk705a84g6JlDKYmON+c+oQzL1SQTp+wOVAY8kZLw1i5ETG5jvU4BObWXte784dR9EqzlaCMux/nAbIZ++aN2E4fPso7SXduDufy63ap588XzymZeQzqjoX7I5L8pCYvNcg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:15.1622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee1c67e-97bb-43a6-1baa-08dd38f1da08
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB4013
X-BESS-ID: 1737336558-106115-13447-11016-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.56.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmbmFhZAVgZQMNnSNC3N2MA82S
	TFzMIgMTE5LcnIxNzAzMDQyMDIyDhZqTYWAJRC865BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan9-34.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending foreground requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
---
 fs/fuse/dev_uring.c   | 180 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   8 +++
 2 files changed, 188 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 86433be36ac4d4c5d6ab7c3da8565acdc3d1e4bb..c222d402a7e0eaf4e1898bb3115b10cff1e34165 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -24,6 +24,29 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+struct fuse_uring_pdu {
+	struct fuse_ring_ent *ent;
+};
+
+static const struct fuse_iqueue_ops fuse_io_uring_ops;
+
+static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
+				   struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_uring_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
+
+	pdu->ent = ring_ent;
+}
+
+static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
+{
+	struct fuse_uring_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
+
+	return pdu->ent;
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
 {
 	struct fuse_req *req = ent->fuse_req;
@@ -774,6 +797,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	return 0;
 }
 
+static bool is_ring_ready(struct fuse_ring *ring, int current_qid)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+	bool ready = true;
+
+	for (qid = 0; qid < ring->nr_queues && ready; qid++) {
+		if (current_qid == qid)
+			continue;
+
+		queue = ring->queues[qid];
+		if (!queue) {
+			ready = false;
+			break;
+		}
+
+		spin_lock(&queue->lock);
+		if (list_empty(&queue->ent_avail_queue))
+			ready = false;
+		spin_unlock(&queue->lock);
+	}
+
+	return ready;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -782,11 +830,23 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ent,
 				   unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
 	ent->cmd = cmd;
 	fuse_uring_ent_avail(ent, queue);
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready) {
+			WRITE_ONCE(fiq->ops, &fuse_io_uring_ops);
+			WRITE_ONCE(ring->ready, true);
+		}
+	}
 }
 
 /*
@@ -970,3 +1030,123 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 
 	return -EIOCBQUEUED;
 }
+
+static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
+			    ssize_t ret, unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	spin_lock(&queue->lock);
+	ent->state = FRRS_USERSPACE;
+	list_move(&ent->list, &queue->ent_in_userspace);
+	ent->cmd = NULL;
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
+}
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ */
+static void fuse_uring_send_in_task(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue = ent->queue;
+	int err;
+
+	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = fuse_uring_prepare_send(ent);
+		if (err) {
+			fuse_uring_next_fuse_req(ent, queue, issue_flags);
+			return;
+		}
+	} else {
+		err = -ECANCELED;
+	}
+
+	fuse_uring_send(ent, cmd, err, issue_flags);
+}
+
+static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
+{
+	unsigned int qid;
+	struct fuse_ring_queue *queue;
+
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr queues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	WARN_ONCE(!queue, "Missing queue for qid %d\n", qid);
+
+	return queue;
+}
+
+static void fuse_uring_dispatch_ent(struct fuse_ring_ent *ent)
+{
+	struct io_uring_cmd *cmd = ent->cmd;
+
+	uring_cmd_set_ring_ent(cmd, ent);
+	io_uring_cmd_complete_in_task(cmd, fuse_uring_send_in_task);
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ent = NULL;
+	int err;
+
+	err = -EINVAL;
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		goto err;
+
+	if (req->in.h.opcode != FUSE_NOTIFY_REPLY)
+		req->in.h.unique = fuse_get_unique(fiq);
+
+	spin_lock(&queue->lock);
+	err = -ENOTCONN;
+	if (unlikely(queue->stopped))
+		goto err_unlock;
+
+	ent = list_first_entry_or_null(&queue->ent_avail_queue,
+				       struct fuse_ring_ent, list);
+	if (ent)
+		fuse_uring_add_req_to_ring_ent(ent, req);
+	else
+		list_add_tail(&req->list, &queue->fuse_req_queue);
+	spin_unlock(&queue->lock);
+
+	if (ent)
+		fuse_uring_dispatch_ent(ent);
+
+	return;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+err:
+	req->out.h.error = err;
+	clear_bit(FR_PENDING, &req->flags);
+	fuse_request_end(req);
+}
+
+static const struct fuse_iqueue_ops fuse_io_uring_ops = {
+	/* should be send over io-uring as enhancement */
+	.send_forget = fuse_dev_queue_forget,
+
+	/*
+	 * could be send over io-uring, but interrupts should be rare,
+	 * no need to make the code complex
+	 */
+	.send_interrupt = fuse_dev_queue_interrupt,
+	.send_req = fuse_uring_queue_fuse_req,
+};
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index a4316e118cbd80f18f40959f4a368d2a7f052505..0517a6eafc9173475d34445c42a88606ceda2e0f 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -117,6 +117,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 bool fuse_uring_enabled(void);
@@ -124,6 +126,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -147,6 +150,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;

-- 
2.43.0


