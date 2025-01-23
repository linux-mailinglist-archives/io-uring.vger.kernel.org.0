Return-Path: <io-uring+bounces-6073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BDAA1A62D
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A5333ACA23
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5ABD212D86;
	Thu, 23 Jan 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="0/gq+J7p"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38EB20FABF;
	Thu, 23 Jan 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643903; cv=fail; b=OGu3bwTM3FF2pZTa9bBzMG/LlRqGQ5wX6JSoM9xSsFtaa7Z/VWYFaS1QnyvM30c4+7leQEIWL2trtcWYr5nenckMI6s0NQAtZPutZ9DztPdj7VF26mXtgFZQE+svgtfHjKdKkh3q/gRAR7PqKpBcZpQvUJDJR0lP1y52OGsT7Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643903; c=relaxed/simple;
	bh=DxFFW82ck0JpkHBPQyoJWsxpDbXQrkTmp2d94ED43EE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iQunpqo9OBA6A8azKyJWoWNGd9E32amePHKJoWzk/BqCuU+LIZ9Ppb5PDg912eUO9WaFEKz/24XOtkkTcrWtOlKYuBYCLobYJ4iWeB2uzI4FBujDIdJP58V9GPvwHhOahI73gU6cLEICU0iWGv+7nlurXxikGaiHZoEXbRMcMwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=0/gq+J7p; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40]) by mx-outbound44-0.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErK3aFO78omFePS6uwqWvR7Hrun+ULnppdJYYAAw8nDe7XSXl++1HO2/Zd0lzt+LPeoVmYOHIiK7Ayd9uoEn3kkshwA1gr4mmEs33F4SAZiAb0pJNPHwlputq/ru+vSD5dDZQ088B8wurXghsi5HWmJo19qpsa4x/M+PdD7T8m2vI5ue90TfCCLYJcaC2D6JvEejWSxoaVaYPFYHyc7fPW1uWb2luu5vLbIbwH3EevAjWN9J90Al4kOOw5nxi74zJtF5dUscBxPcirTXLjtO03BSn1vlcl2brLkZxaEBaGBwgjE2Ba7mE1MpJmx1um3U83cNVmLHMdAN8TS2j2ewzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1R1klReX8byb3AEoLbiaMDPg7/A3ndtW7LKrbMbLvU=;
 b=daHHH4bZz9SlqKsyXPEW06Jdg2CZG+g3fu2YOpeL40lTNaoVR/sLeB6SWJ3v10G2lgGdVho5xlGja7+RmfpbXAG7yIv+J2TDz6A45lEsM2rMmAQ7YQgXU+nz6yvPDymvRkQE/Uqm4kz4v+Uf+G0B8baHD5mJ5SpxE1pa3tHx8aOOSCUHGSzv9HpbF0ldulbXSz2p6ec8lRuhdxkw/jeJJvE3jwc5auk3ElOet4rLWz70gMdYJiUF983+G986hdi4MutZgKxR20T/maUq1V4Zcl3vkOHfvTsVqt040oYLc4YN5cdbWUi6iVTUDbocuLtWlIQQObgGLHjmkMwrYb39cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1R1klReX8byb3AEoLbiaMDPg7/A3ndtW7LKrbMbLvU=;
 b=0/gq+J7pJxtWoe3Ka8R2DO+qJtWVENfv0JeZGLTqFtH+rydlZN+lpSGpD1exZOcqQ97PhB558l6/1hxJ9h1k/ejTvTh4H4GpNhk/r3UVTNGZOKpL8lJz6G1v6X5ix87ggQ5Gz1iQMlAxEMQFFElxOdXhZgNdU2BIsUyrt2mEL/k=
Received: from DS7PR07CA0023.namprd07.prod.outlook.com (2603:10b6:5:3af::28)
 by SJ0PR19MB5491.namprd19.prod.outlook.com (2603:10b6:a03:422::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.19; Thu, 23 Jan
 2025 14:51:24 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::d) by DS7PR07CA0023.outlook.office365.com
 (2603:10b6:5:3af::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:22 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E1E3158;
	Thu, 23 Jan 2025 14:51:21 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:09 +0100
Subject: [PATCH v11 10/18] fuse: Add io-uring sqe commit and fetch support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-10-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=15510;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=DxFFW82ck0JpkHBPQyoJWsxpDbXQrkTmp2d94ED43EE=;
 b=zfi7MIlmSBt8iqGfzUtpfkTu9VcK8yj1ZBqCv8yyUHmo4Zs8thiOhSrh322fEHkvuH90f9E/2
 JkJR5Dn4Y/zC8PefTEGtHozERtSASoOu5r52IBrLAN5uyX/TQ2lyJWn
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|SJ0PR19MB5491:EE_
X-MS-Office365-Filtering-Correlation-Id: ba038c04-32aa-4f5c-3607-08dd3bbd675f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDFkd3dLb25rbXJyMzgydWRWZ0VIWG1vaTJEOTRBaDRqU1hlMUtadUZFMEFL?=
 =?utf-8?B?R2dZUTZmVmpOY3FLUlVGM2w2aG0wb2ZLU3kvTCtiT2hGMUJNY0U0Q3pNUnBp?=
 =?utf-8?B?ay9zZHJZbzZMb3NuNnBHMVJmbUlMbXd6MHhVZlJibmV0UkZWN3pISFZyUVJk?=
 =?utf-8?B?azQ4ZEhvM0tHOGQ4ck14OEZKcUtTdHdTY3pTa2hFeDhkeHBNWVd2SnhLTThS?=
 =?utf-8?B?RmNJM0NxRHFpaTdCNFJQWU4xcDBTZlBVb09reEc5bEZ1dkp3bjVrZWhPQU9J?=
 =?utf-8?B?K0dGZi9zbG9xbERFYjdISEFTbkZqTUdud2JOeFk5TDBYV05hOFBKQzBVYjNr?=
 =?utf-8?B?UTU0ZElaR2pqVFVFbDNkU2NGWnp0Zjkxc1ZKZTFZMi9BN1A2U2M1NERTMmZz?=
 =?utf-8?B?V1J5M3RLcEJKN0M3Y21Vem9QQzRxb3VvN3NKbEtGMTJSdHJ5WUpMVXJ3QlQz?=
 =?utf-8?B?ZkE4eHd2UmZ4anhhZEpVRmkwTUVsQWpKVkYxaWQzM2x4ZE44RDJMZFNCOXJn?=
 =?utf-8?B?c00xSWFlMGVkY2d3UndEdXZrKzlzVzNwS0FVT3kwQ1hpc1F2L214cm12cGt5?=
 =?utf-8?B?bGFweW9sd2cyTzh2Q3dKL1FFc2tuSHlMb2JIRnVNQ05yVzhKUWRKVFQrVjNT?=
 =?utf-8?B?elp1RFBxRG9MQjJNUFFiSVJpY2FJTXAvSE9jVXRHdEJOUFVGeVVLcStRMEVp?=
 =?utf-8?B?VVorWTczS1N0YTJVMlFYZDFJQVlBQVVlLytuMnlscTVtS2RvdkNxblBCaTJD?=
 =?utf-8?B?MWNEOXIxVnpHQnhuZlFTY0xEcC9haFZKZnAydXF6UUNqeTc0WWYzUjFIb1gy?=
 =?utf-8?B?VmVhQjR3OTZyVVprTnM4MlBwd2x3cTlyMyt3dEFjMzVIbWd0QnFSV0wwa0JE?=
 =?utf-8?B?VWRKRkFHWWQ2ZHIxNGlCUzYxWG5JT29CN0tRcjZpSVZXUzRraktxTXlYQm5G?=
 =?utf-8?B?MWVaRm83WTFPRTJBVXFoVmU0RWkzeEFHNDNMUGpyVUF3RndxbU5XREJxYUI4?=
 =?utf-8?B?K284aHdzQWhCR2h1OC9wWnhESW5PM1kyelp2UnFtQjB2S3VlNTQzSnRGb2Mw?=
 =?utf-8?B?c3lKUVlOWjE0dDF1R3AxY09oUnZqOHB4UWQ4VGlzT2hNWGV5WlRjVXJuRDRJ?=
 =?utf-8?B?R1RwLzFDdU1Ma1JTUC90UVNVUjY4ejdJelA2SXZOdnVIWGN3ekdVNjM4UTBR?=
 =?utf-8?B?N2JiSWoyQWN0TExnNEJoZVNVWUxSNHBuQ1M0VVgvSzlaMzE3UU1Yd1VaVG1n?=
 =?utf-8?B?OGo0eFphTXdKOWF4SURvVUhDV2JsOVBXRFcyVHFYZ1RaMEVGZFN3ZnVKbk1E?=
 =?utf-8?B?K1ZUWUdBeFdZdDNubWhyTStGaVJNU2RSU2Z6V2dTMWR1N1ZBRWpIM29DT2Ux?=
 =?utf-8?B?SVNKaHZaZ0RpZ01aZ25vL3FNT3JFUEYrclFNZjhMNzhZbHRwT2ZsblJuVmkv?=
 =?utf-8?B?YkJudi8rU2N3eU4vN1QrUDNVRlY2ODVNUkpDKzFZUGhLNndqSWh4YllhNzJs?=
 =?utf-8?B?VUI4cHBaVTZNSnd4MG92ZGpkRFpkVkVhVG1XOEozb3FBa0ZLc2F3WHVQcm1K?=
 =?utf-8?B?OVRINkhxVVlXbEFVKzl6aWNDeHI3RWpJSnVCRndDTEZYV29JL3J5Y28wbFh3?=
 =?utf-8?B?TEdicGVPYlF5RFNoY2JycEp3UkJZdGx5TkhRMmE3bitaYmRJZ2srZTl4eHdF?=
 =?utf-8?B?a3QwSVNqVnNtemp0K0JCZXQ2akVHVGk4azNTT1VQM25XbnRJekhSd0J5Nk1B?=
 =?utf-8?B?V1JrRERYVW52U0piMG9VN3BWWHFVcGppWjBVNHp2ZXM2cjFCVm1NTHdWRU0v?=
 =?utf-8?B?QnpRcTBIU2k1bHRHK1VWUTFOQTRCMTdxL2tIMnpPdFlMK0toZ0FLME1FTE5y?=
 =?utf-8?B?cU54eEVzaUNVcTloQm1KLzdhRUg3UytFQnhTbXJaWU9qaE92bmdFMldEUi9X?=
 =?utf-8?B?ckRidGhiaVNuWDhvWmVyemRHU3V4b1c2VGMrYkMwKzA1NHgralI3NXpTa0xU?=
 =?utf-8?Q?pxiUiZX/FA99MxyJxy/iKkjKv+yek8=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y6Z5OYGbgeUwlz4nQBlZYhumQyhbriSMtAO8O6fxekFeI/QEnEdkFX7QB/kjTOyksD6A+2EKNcAVhKznmF4sAPAUkOn8M3Sqbt2gNsYwAvUAz91NzhxLnhtPG25o9XQw7/6MhB4lJaH8qzHmyt4oA4+oeC/7mAKLgBqwSFvlVQjY6tGvJ8NwDNNqfxOmcq3uZV/7YYKJDIzELdxHgRnMo4qMTYV99P0ngccMv6nlUyiOm7+RlPRO88xHcZVGFeilJa09OtP4xrV/SjnxqsDouPMDVa8sgV/dBYctbIBwEilQ4VB0b5xaT4bjwO4PZHRCSBsNtLCt1KiZgLyYXMDPowTCqfffPSpyN3peLlmkRFApyQgTqBheMuaXTjjt/EapJ61k/tIarX1koVvapILoGr3QryeVfxnYJuXmNLvdJtp0p2sJlk62hVTbgpIIhl9FKcZcitSL5inVIYBcD401Sizm/vuGEl+F7KlyWv5Gn3tDD/PzChk+mdIHlXs+o3NqhNoDRCBCey0MYEIji78Z1CznkkABCFkt20aV8V82phHVAm7tz26sEvRyBmmt4xST68i/lpr8NfFmrfJmg1cDJJ82QWBpcR4pUDiCdbwv3twyes8x570+nRE6oQdfP7FLtZHeJGJOr7bGB2SAq3x0VQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:22.5004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba038c04-32aa-4f5c-3607-08dd3bbd675f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB5491
X-BESS-ID: 1737643886-111264-13463-6499-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.58.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmlsYmQGYGUNQwLTkp2STVJD
	XNIskizcI0NcXUNMnMPM3INCXFJM3CWKk2FgCPu9DXQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan9-179.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_RULE7568M
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev_uring.c   | 448 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  12 ++
 fs/fuse/fuse_i.h      |   4 +
 3 files changed, 464 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 42092a234570efce46b42c56b75767ce487aee24..ec4f6a77c8d396057a586797ca84b8e4582fd5bf 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -24,6 +24,18 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	if (error)
+		req->out.h.error = error;
+
+	clear_bit(FR_SENT, &req->flags);
+	fuse_request_end(ent->fuse_req);
+	ent->fuse_req = NULL;
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -39,8 +51,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 			continue;
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_w_req_queue));
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -99,20 +114,34 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
@@ -126,6 +155,213 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
+		/* Not supported through io-uring yet */
+		pr_warn_once("notify through fuse-io-uring not supported\n");
+		goto err;
+	}
+
+	if (oh->error <= -ERESTARTSYS || oh->error > 0)
+		goto err;
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
+		goto err;
+	}
+
+	/*
+	 * Is it an interrupt reply ID?
+	 * XXX: Not supported through fuse-io-uring yet, it should not even
+	 *      find the request - should not happen.
+	 */
+	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
+
+	err = 0;
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
+	int err;
+	struct fuse_uring_ent_in_out ring_in_out;
+
+	err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+			     sizeof(ring_in_out));
+	if (err)
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
+static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct fuse_in_arg *in_args = args->in_args;
+	int num_args = args->in_numargs;
+	int err;
+	struct iov_iter iter;
+	struct fuse_uring_ent_in_out ent_in_out = {
+		.flags = 0,
+		.commit_id = req->in.h.unique,
+	};
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
+		 * Some op code have that as zero size.
+		 */
+		if (args->in_args[0].size > 0) {
+			err = copy_to_user(&ent->headers->op_in, in_args->value,
+					   in_args->size);
+			if (err) {
+				pr_info_ratelimited(
+					"Copying the header failed.\n");
+				return -EFAULT;
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
+	err = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
+			   sizeof(ent_in_out));
+	return err ? -EFAULT : 0;
+}
+
+static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
+				   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	int err;
+
+	err = -EIO;
+	if (WARN_ON(ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ent, ent->state);
+		return err;
+	}
+
+	err = -EINVAL;
+	if (WARN_ON(req->in.h.unique == 0))
+		return err;
+
+	/* copy the request */
+	err = fuse_uring_args_to_ring(ring, req, ent);
+	if (unlikely(err)) {
+		pr_info_ratelimited("Copy to ring failed: %d\n", err);
+		return err;
+	}
+
+	/* copy fuse_in_header */
+	err = copy_to_user(&ent->headers->in_out, &req->in.h,
+			   sizeof(req->in.h));
+	if (err) {
+		err = -EFAULT;
+		return err;
+	}
+
+	return 0;
+}
+
+static int fuse_uring_prepare_send(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+	int err;
+
+	err = fuse_uring_copy_to_ring(ent, req);
+	if (!err)
+		set_bit(FR_SENT, &req->flags);
+	else
+		fuse_uring_req_end(ent, err);
+
+	return err;
+}
+
+/*
+ * Write data to the ring buffer and send the request to userspace,
+ * userspace will read it
+ * This is comparable with classical read(/dev/fuse)
+ */
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ent,
+					unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	int err;
+	struct io_uring_cmd *cmd;
+
+	err = fuse_uring_prepare_send(ent);
+	if (err)
+		return err;
+
+	spin_lock(&queue->lock);
+	cmd = ent->cmd;
+	ent->cmd = NULL;
+	ent->state = FRRS_USERSPACE;
+	list_move(&ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+	return 0;
+}
+
 /*
  * Make a ring entry available for fuse_req assignment
  */
@@ -137,6 +373,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ent,
 	ent->state = FRRS_AVAILABLE;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ent,
+				 struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	req->ring_entry = ent;
+	hash = fuse_req_hash(req->in.h.unique);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
+					   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ent->state != FRRS_AVAILABLE &&
+			 ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ent->queue->qid,
+			ent->state);
+	}
+
+	spin_lock(&fiq->lock);
+	clear_bit(FR_PENDING, &req->flags);
+	spin_unlock(&fiq->lock);
+	ent->fuse_req = req;
+	ent->state = FRRS_FUSE_REQ;
+	list_move(&ent->list, &queue->ent_w_req_queue);
+	fuse_uring_add_to_pq(ent, req);
+}
+
+/*
+ * Release the ring entry and fetch the next fuse request if available
+ *
+ * @return true if a new request has been fetched
+ */
+static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
+	__must_hold(&queue->lock)
+{
+	struct fuse_req *req;
+	struct fuse_ring_queue *queue = ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
+	if (req) {
+		fuse_uring_add_req_to_ring_ent(ent, req);
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
+static void fuse_uring_commit(struct fuse_ring_ent *ent,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring *ring = ent->queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_req *req = ent->fuse_req;
+	ssize_t err = 0;
+
+	err = copy_from_user(&req->out.h, &ent->headers->in_out,
+			     sizeof(req->out.h));
+	if (err) {
+		req->out.h.error = -EFAULT;
+		goto out;
+	}
+
+	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
+	if (err) {
+		/* req->out.h.error already set */
+		goto out;
+	}
+
+	err = fuse_uring_copy_from_ring(ring, req, ent);
+out:
+	fuse_uring_req_end(ent, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ent,
+				     struct fuse_ring_queue *queue,
+				     unsigned int issue_flags)
+{
+	int err;
+	bool has_next;
+
+retry:
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ent, queue);
+	has_next = fuse_uring_ent_assign_req(ent);
+	spin_unlock(&queue->lock);
+
+	if (has_next) {
+		err = fuse_uring_send_next_to_ring(ent, issue_flags);
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
+	struct fuse_ring_ent *ent;
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
+	ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ent_set_commit(ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ent->state);
+		spin_unlock(&queue->lock);
+		req->out.h.error = err;
+		clear_bit(FR_SENT, &req->flags);
+		fuse_request_end(req);
+		return err;
+	}
+
+	ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+
+	/* without the queue lock, as other locks are taken */
+	fuse_uring_commit(ent, issue_flags);
+
+	/*
+	 * Fetching the next request is absolutely required as queued
+	 * fuse requests would otherwise not get processed - committing
+	 * and fetching is done in one step vs legacy fuse, which has separated
+	 * read (fetch request) and write (commit result).
+	 */
+	fuse_uring_next_fuse_req(ent, queue, issue_flags);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -318,6 +758,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
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
index ae1536355b368583132d2ab6878b5490510b28e8..44bf237f0d5abcadbb768ba3940c3fec813b079d 100644
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
@@ -67,7 +70,16 @@ struct fuse_ring_queue {
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
index fb981002287d331b55546838865580e5f575d166..ba6901c1bc2d0ac102f762f3d37e8b8a2d5ae2a4 100644
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


