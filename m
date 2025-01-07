Return-Path: <io-uring+bounces-5703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F3BA034BA
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 452F77A0105
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA23481A3;
	Tue,  7 Jan 2025 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="RQuHq97C"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C52D5680
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215089; cv=fail; b=gTm0a2FziMyQ0/1iH+mlhOp4XQ7BFagNdezvslHfV08af2fsOP3+3yn+CnPCqzqd5mWeMHKIWtIWI2os4NByttwShIX2EOkY4uGTmQJaFjTYNXKC7NfOdaxgYrC2qbzrJnQVr7Kr0nznoffbyHRXOaYlVfiZ8zE1NoQwyeqzf5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215089; c=relaxed/simple;
	bh=AvsBUPQfhNKAli9QrA4nArV8nI+dbIIZOg4iPrMRRVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sr/D8PORXUiqlFbdSqj03GqCfRRtrtbO/HwBxiFbjKXrIfLlyUXEaDONh3KbNTZ2+t6lgZqSHZLXuMncAHe9JmQ1KWMl5ABPMuOpkQtZXosa0XMHUjlrE7fRe9IP578Y8Znq9LJ6PpGhVtZiXo/QcwXlijscWf0ghUL0TEIvdjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=RQuHq97C; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49]) by mx-outbound22-77.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:58:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKGzkzuvqCZ3Xii7xuU56+rUbvvyLDJIFN9nOAwBeR7jKD9HysPo5YlKABsvnCkmDAPlmGs4ZSe7be761utUb8NRu0lEA8GFxKKptgc8eojKtF7NwWqV8i1cjSB3aD+L8SxjgV0IPWPKf04Bpz/R39rtveNLpSrORPcpfSYRJ9oaW0ABOQD1oCQTqtmFebdQtxbDAWnvQAU6d1rObt0txfhZ5PmNVk3PDtHZkuMCrnW9DoCOn8ZJYIYIknZSTv5AIjRJl4MUq4TVuCD2MhJHU4InaL75abHrwLMeuu/mSunmt4opQXz4SQvSNy+geqGt+n04X27RiPU02RpRpu8OPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4y8bmvGWbSK87f4CPhigqrP+Vwk8f4NI1+JX7qr0avY=;
 b=I7r4es8iKLX/J0PNUgwZAwGf6ZbM04Ft/C7LbcZRBm4YsSIiat8SzQi8zeOxBKl/9beEpGjSJZ2V+3h3358jdYfuwxew2gVpazkA3dljDjiQ+Sk5iy4S7KOM3Wb2nyJ7t9H74jclSa0ZhhgR9lojO1rXKNZgTpB50x/QxywrruHBnvjvMzzfZbl/HJ+YRRtssJV33N5kiM/S+aMZ8hXb13yzKsvG9YEeA5kBvp+hB+0ifyqhs38nOEW6o+6Qn6kbLIQ2jWtMx7ur1Hom6jo9WxP4GIhPue24fzRL+rUoddeHwnbyImcyf2WpfbqUHpKvPsL5Xhxw3mePb3W8Y3OohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4y8bmvGWbSK87f4CPhigqrP+Vwk8f4NI1+JX7qr0avY=;
 b=RQuHq97CWlzgwLlzB+YhkDGOaBvZXy8Tvpakv3LedJ9WNijNBOt07Pufw79lpn1UP2kJ3j3McVRo4HxWBJSlWi9lPu8ILUwJperWCKGJQgbe8BHSOe6sQ9vgb2zOgGbH+CTvArhaYqOXMA4ETFoZndusOO/XbC9NhZOIcRgm+I8=
Received: from DM6PR02CA0092.namprd02.prod.outlook.com (2603:10b6:5:1f4::33)
 by SJ2PR19MB7487.namprd19.prod.outlook.com (2603:10b6:a03:4cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 00:25:28 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:5:1f4:cafe::9) by DM6PR02CA0092.outlook.office365.com
 (2603:10b6:5:1f4::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Tue,
 7 Jan 2025 00:25:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:27 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id DDD0B1DB;
	Tue,  7 Jan 2025 00:25:26 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:21 +0100
Subject: [PATCH v9 16/17] fuse: block request allocation until io-uring
 init is complete
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-16-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=2651;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=O/2YNgt+Vne/zwL4Xkn94aO/pImf6Sji5SRc7zTLOqs=;
 b=5tbtVDbVpbHE8beRDl0/o2O4rDaOEbLLZiawyLCobl4woFu1FFe610Gl0ZoV81BduxtkeTuMf
 TmDIa77Xm42DKTVc31vST8YPiFm0i0Nekv/yRLSa6k8F4TvfxSvZBYt
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|SJ2PR19MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: ee87f84e-d356-44d4-2234-08dd2eb1c914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?Sm1WTlBscFRmMFVOY3JyWm9paFl1bEZlRHFWNFFlWkI4T1RYRDVpMHg1cHpy?=
 =?utf-8?B?dXJCSC9taTlHRnQ2dlp6Y2lwN29BUEc5bnZBSXJVUDh4UVp3RGhNaU1SWE4w?=
 =?utf-8?B?WmZPczg1Q08zVUk0KzZ2MmVjdUpOc1dmK3hwTmcwZUtBaUluWTNmay91b2NU?=
 =?utf-8?B?dHBQajNsTmhSODFmT1IvSHZxRkhuS3o2QjhrMnlRalVscFI0Ny8yUXVpcWVT?=
 =?utf-8?B?VG13UjhJcUxzZkhqcmNHaitHV1lKY0R0TDFWaTdqUjZ4dTYvNDUrWWpBQzdx?=
 =?utf-8?B?emo0TWhubGFHS0hWcndXUTBoakZBNUlZWURDVTZXVWgzZU83MlpOOVNXb1d2?=
 =?utf-8?B?MkttTk1oWHk5czcrblh3R2VuVC9FM3ZZODRKMWpCeXlORUQzWkpoZWFrUlg5?=
 =?utf-8?B?YUw2OE5ia1Qza0kxNHRjQmh4WVZIeHFiZHNBY3N2RXJjcXF5K2pzTEV6MTBj?=
 =?utf-8?B?RjdQQi81cjZhQkJwb3RkSjZaS2kxdlpYUGpXU2xFeWZlNEcwbTV1dFc4NGpO?=
 =?utf-8?B?S3pPTzVtT2I3dWpPVDV5SkNEbU55VUxxU0NRUHJFL2JoRkFNUlpOVnVqU3Yw?=
 =?utf-8?B?dmk0b0srVnAxY2RZRkFFeUtJcnRuYjVIYlRSZlpVUm82azRzY2xiUjVxUmgy?=
 =?utf-8?B?RnhaZjhkQzgwdjJiVjU1MCtTaDVDQnE1UEp4ZC9ERDFzMm1zTjhTSDY2ZVFp?=
 =?utf-8?B?dm14U1FtMXFUR1FDOE1HL0ZOQkphYUdSeUswMEZsY1RSa3ZvMjd0Mi9KeDZP?=
 =?utf-8?B?Q0hzdFNTMHg0NGV2YmZCaHlCSUZGODJEWkFxTnNaSTh3TlRGOC9MeGlJZlFK?=
 =?utf-8?B?U3d3ZVFoNS9Xb3dQK1R4N1BwMVp1WFR6WjJ0ZFdwcGlTRmJZYXJ1Vy9JUWg3?=
 =?utf-8?B?SzBnS3ltTHJWS21sRWRjMmJwVlpTQVBIdmZkZm1FYWxrQnJoenFZYzU5K2FL?=
 =?utf-8?B?b0FyVzhHRDVkZHQ2WDc0ejNhUFBMVW45WEtPWEZBa0ZYeUlvNm9Pa25ZMGk4?=
 =?utf-8?B?NmdVOHB3bDBST0tTMC9uKzhJY3IrQUJBTm5wQmZoeXdtNi9IVkdndXVETnNZ?=
 =?utf-8?B?YTI5WWZqdDE5c0pJWVViQ2s4b1YwRUlocWhSc3Y2ZGlGTXIxTitDOFNYS3h6?=
 =?utf-8?B?V1Y3RzVpYmhRWnV2RTYvVVdxWitRWEFCaVZLMmxMSm5xazhOekFZU0NYTmFm?=
 =?utf-8?B?azhWWW5wWWdxRC9JZ1ArbC8wR3U0cWFpa0gyUU1iS29LQzFteWFJdzR2YS93?=
 =?utf-8?B?WWd4NGlaNEl5bE45azVDdk1SeXJ2ZW1LUjFBTFFjZmhXNFlXanJBejB3SHFu?=
 =?utf-8?B?dHlQdGRnNmF5M3NMU2VYbndsWnhNd2xqSFdBSFh2bE52NEkwNit5d0hrbHpt?=
 =?utf-8?B?dEpUV3ZiRnNXdHZxbzBxNWVOa29meWNORUtSM1VwZHoxaDF2d2thVmViK1hM?=
 =?utf-8?B?eU5qZ0lOZWtVOW1nUGN1Y1MvMER6UkFxdk56ZWpGT09xVEI0SmV4Vy8wYmtr?=
 =?utf-8?B?bzdyUkorelRrOVpreUsxM01QVzVRMDVrZ01sSzFlOHE5eXlIbEpMZnlwN2Rx?=
 =?utf-8?B?SUE5WXhNS1Fzek5zQkcrcEJDUWQrNk1MR3U0dWhJWW5mVUYzR0g4eUpyYXUr?=
 =?utf-8?B?dzlCbjV4NCtwWWg1bVNtTGxQbkxNMHRFTytFb0htSWhjdm1hbU1WYVVSL0Nv?=
 =?utf-8?B?RGZCeHJud3dEd3ZLTUgwTmhmMlFvWTMveWdyZ1dpN0FJOUlSNUd3Q1VyVEd0?=
 =?utf-8?B?UnhCWDVMclJ1bFM0cHI4QjhjamI1U2lqMDVNTkp4UVdRUU9DeFFzVm41QkMw?=
 =?utf-8?B?Vjh1Ly9EdVNMVXlyekdtb3RNNEJLTTU2Tms5K3lMU0Zsc0VCQi9zZmk4TndK?=
 =?utf-8?B?MVFpZHZJR0lPS1Brc1JYWFB3TjBNR3R5K0YyN0YxQlZkMXoyeGZEc2tyM0My?=
 =?utf-8?B?c0Rudk1Xcml4Q2J0RTZYc3FvRTlDb09lTC9vU1BLdDloQmdCVVNwbllDbEpH?=
 =?utf-8?Q?TvAB9rh+tytcFZPi/vydcEZn0oMICU=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 Use26U0+VBkRoAyBzAIH5ev4gn9sOK+DhkQfc/Y67goXkOKi8tDkoEvafxDWGtQWuoSJ+2yKRsaRHgKG2/oK4+uFdN9yi1LRDClzgEUYE70W836edwtqyw3WUeaD12ttwTNBbwrwPCge7oMcgAzZbymhyDFcrBi1oIbvR4+IqS1842JbjLLSg1afWXRlVC9AzD0xXolJV6SeTCvkbh3CVQ1NR4CLxCXItsUtNGpnT+tZsgNAt9QxahibcsTfuMJCs/PRhA78FYucVoffNBJx6bqBUDfgJZjWcpad3TcVpLNTMpmsEizYkqDtGSKXOkhL7iTQRhegO8CzU0R5Tpfrq/d1iCHsFqrvJXGV46OiGo6qeVNCH1FTazfjky2UGye9bPT3ED28EvTiCSXAjxf9YcWRaSh3wHDhMCQpvN0VmlXmxAT4A5JDMpVW+Q9eZH9UkeiDauAR4PEdOzUvkJuQ5rtSRXFPrAyn10DInF0HlPdpy2VGnxFozzIa79Eg/QLKCnH6v4sFxjWrk2kVkUYKP9yq+INcG08+Lcnu77D06HQu5NGi4olt2CsffcISNiIvZkConz+93p7/vNB7VofTl1VYw4d7zf54pTFSSmHv+t5+6JyHlFXh1r3kscATCVyZqhzhqC1J7cr1lU8fC3vA2Q==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:27.3169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee87f84e-d356-44d4-2234-08dd2eb1c914
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB7487
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215084-105709-13559-20600-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.70.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmhmZAVgZQ0DLFONnMMsksLd
	E42dzSzNzYMDnJyMDM2BgklGiRolQbCwCCYJjpQQAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan18-99.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
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
 fs/fuse/dev_uring.c | 1 +
 fs/fuse/fuse_i.h    | 3 +++
 fs/fuse/inode.c     | 2 ++
 4 files changed, 8 insertions(+), 1 deletion(-)

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
index cdd3917b365f4040c0f147648b09af9a41e2f49e..45815dee2d969650efe0df199cc3bd1f3e2e08f7 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -956,6 +956,7 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ring_ent,
 		if (ready) {
 			WRITE_ONCE(ring->ready, true);
 			fiq->ops = &fuse_io_uring_ops;
+			wake_up_all(&fc->blocked_waitq);
 		}
 	}
 }
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


