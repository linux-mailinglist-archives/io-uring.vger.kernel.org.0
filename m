Return-Path: <io-uring+bounces-6078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5326A1A634
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 836927A5023
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85923211A1F;
	Thu, 23 Jan 2025 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="aaSc1f/2"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11D7211276;
	Thu, 23 Jan 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643905; cv=fail; b=RkIe62pFHqNsnFyUKh2QljM/QVWP8DZ1VN6eNHWHJwrkKGEW9LxSDxQMNmRvw+c+Cd49WfC17yV9WvWXtL9KRBzmsR+JMYEsh2tPIBuwl5onKcZO3G3ffEUy4r4eMDMiqoTulZ2J3u7N3RfVfoTTtkSZHzyRav6Z+nKOuM0oMrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643905; c=relaxed/simple;
	bh=4blnZ4raCOQssK5VYofukU/Ypo36uQarVF/gfi6L24U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rv6wWSH9JQaoeWK0FeMaGpHc1hM85WDw0N5fhtn+OF4S9xWUWJUWjfw5GvJ8qhU+h03Pb02bfoASBaQ1rsz5CZbJXqoQY/AGnHH84Ml9Ko+caAQCaXNv8Ua8hF5i8oI+wf0SzK0xbZBIWaiynhQyZWDNm6BAYkoLsE+8rpmbOhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=aaSc1f/2; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174]) by mx-outbound19-68.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tp0e6rdY8rvOkyKRoU0BwoFOz8EihS1FJoVmkSWOb38TmPYZLHVhS4y+EHZ9v/4tDqyP737mJuyXcOfMwXFmd0H2sUdM+oOBd78gAfBGeoh1l1lSLcx6hUgaS0Dx2KBADGFtzYXpXFS3rGrKfI72E3MZSMMmTgRNCT2Cs6VWI6NuRV5kvQLp9ZcpoeCVx84/nYvfa+n6mzv9TB6Ot/et/uZc47GLcD8OoeNxZbr33z80sTpO6hja+woWn2KiK1KV+4T+dxCYA/cF9boVpHW1uApY51V83TFmMmXdJEQB22iX8VQpQNnIE9fFGVzG7/ZC2QGD4f6Zp/XfMcWqLQZY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjvnd2bH0tsUG8eTYZrQ8XASjbi2L1OJdUf3saNyz/k=;
 b=cExzsH2y0rYd+R64ourmc6QaFxc9egDzKeOXOLUhychdK/bCy+8FbbsCib6X/qFISb5xFT1j7d0qACOWrvRmFKT1TRbaGysZGeOEh578UQVV41yTDT5IoAow9SogO0Sb0jLYZRqvlXVUEU7LljGdHjhBYHSub/Dzth3iItjb6ibrN+PoDYm6XGpp5KDbijmHh/UOsh8G5Oi5bUg1LuIsT5i0QTBG1uPuPRaOCFDNebSGWd1fABkuzE13LwWqXG4/jXITfCM7mIucidgyT+3v5NgJRWFGR4xklZvrTrCzD5bnN7+MKnWGfnGSO3zw4FxhB1DlMO+h43koJAkwp/a36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjvnd2bH0tsUG8eTYZrQ8XASjbi2L1OJdUf3saNyz/k=;
 b=aaSc1f/2h8QPBJcfL16M3AxqSlCB/n2QM9vxA9Kt2fz5jxQXQjh5t5peHPUfXB5pw6gw6rY7r1m0bpI6uaeaUrL5CVBQCzILZZdEzftBBvsnKBFZ5vgAgKPOvFNceG+s8QthvADkqHNvMdjoFLtojs9aqh1xmhfl2JcKbBI+CGs=
Received: from PH7P220CA0120.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::22)
 by CO6PR19MB5338.namprd19.prod.outlook.com (2603:10b6:303:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 14:51:24 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::34) by PH7P220CA0120.outlook.office365.com
 (2603:10b6:510:32d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:23 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id DA31D34;
	Thu, 23 Jan 2025 14:51:22 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:10 +0100
Subject: [PATCH v11 11/18] fuse: {io-uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-11-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=11601;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=4blnZ4raCOQssK5VYofukU/Ypo36uQarVF/gfi6L24U=;
 b=ObUw5/b2toeIt09tMvJtAiX2TQDRY4nWHoArsnN9I86SWAH4KQo4rjJjf/C8C0J0dI2MMPB3E
 qF9jDJN3uZIBPXtSFtjwP5icPStHGIHajSG/7U4S7QAGHdFukoy3omA
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|CO6PR19MB5338:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a652149-15e6-42c7-75cd-08dd3bbd67ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFo4NUNaZGh2eDN4bXVPbXVidDhncjNCK3FTOXk3Qkk3bkVoVHVBSDNEZ3pv?=
 =?utf-8?B?eVlKVFVPZ0I4ZVJ0bUU5RHNtVXVqWW5UK21pc1V5by9PK3lEZFRWbjFNQ05z?=
 =?utf-8?B?R2lSMHJzYS9oUklJL1I4aGJnUEZWdDhKaDUwR3d0MG9hd1ZmNE53Y05jbjlT?=
 =?utf-8?B?NnREbG1ZUk1WTSt6ZlR0dldpclJZbVBjQ0ltOUFOYUhRT0wwdnl3bHV6Qkxk?=
 =?utf-8?B?cVFZQXJ2WXQ1bGlhWUo1T21DZ25tTzEwdW1qa0tJODZJYUx0RWVsd3V2a1Ix?=
 =?utf-8?B?cXlYLytzanFqNEd4V2xzSjUwdHdwREUra1pHTWlmVzhvUjBTN1k0N3lyUTdz?=
 =?utf-8?B?VDgzb3N1RmtRaU5JcWtNelNmOHU1VGpPUDNNcUlYSE9WallyREZlWlJuS3pY?=
 =?utf-8?B?SUp0NERxRENOVDBkditldzdhbExxdDliUi9sQ0UxVlRGV3JNVENQdUJ2ZFVC?=
 =?utf-8?B?M0xOSDdYaDZ4UkpQVEFaWnB4a2JOSktHdThNcStzNWc5RGhtY2tzNWxRZUNa?=
 =?utf-8?B?SUk1Q2NZQjR4dFk1SHVjWld4ck1oZlA0MXFoVnM3bjVnZTdUUDlSNzJudHhY?=
 =?utf-8?B?NnNZTFpUdm85QlBuK0pRQ2VGd2pzV0hXM1ZhcVQwZXA0V0M4WVFrUXF1cjhk?=
 =?utf-8?B?cHlVc3dnZlErdGYyYjBSUk5xamlyOGpFN3pnZE5GQnlIc2JoZlZzVXRsUzJn?=
 =?utf-8?B?RFUyT3NGVUloS1ZFd3cwZGhwY01BcExTbVJEeEpBVm92N2U5NVhzNjBoMTEy?=
 =?utf-8?B?aTZJMEdkOGx2bGYrcjY2bUkyVnc0VU1IcE94Q1FLUXB0SDJVczRzSW9MRk5Z?=
 =?utf-8?B?UnpXVTN3UXFtNy9wdnBzNkxud01nQTdCZVdxMFdPVUJHQ0Z1S2NBdFJVaWZB?=
 =?utf-8?B?YldzOFlMYytXcFlqTnp1d3FKQUc5dDVhOXk3RVhMYjBWejMyejNMeFlZZ0Z2?=
 =?utf-8?B?UkphaGJXWFh4NVVhclpkTmtIT0tFOXI4c2NKa1FObTg1K0NsV0dKUEdGbTJx?=
 =?utf-8?B?ZDFZV2VZV3pDdEVSbk1LTERvOExITjNUNkhKSWthNjBmSzR6eG1ZaHZ2K0ZJ?=
 =?utf-8?B?VEFoQjRpWldRdUpnZkwzUUlBUzA1ZTZPU0hTYVA0WFlQS1VqdlVlVkxoMnZr?=
 =?utf-8?B?aEZpM3R0ZHJQVFU0dFNqR2ppQ3FFQXU1SDNXTEh0UFlsMjZUb2pDbGZoVGZJ?=
 =?utf-8?B?Mm9xU2QyMXlIcGN0Sm9iSERmTzBzRVJwaFhDczV6VWpvNStBRlRZckhiWjFV?=
 =?utf-8?B?UE1hdjd2c05UTW8xc1ZHYU5uRElBbTRNYVJ5eDBTYmNSWHR6b1ByVUhiQ1Mw?=
 =?utf-8?B?azVTZy9aQzZ0Ti90VXk5TzVzMWRpS2NiNFJKazZJbTBNQStnSHArQlZCVEhM?=
 =?utf-8?B?U3JlNEYwdFRxSHVaNzVHTzBBVkZVNU04MG9kTW1odDAwSzljWUlsV3MyRU5Y?=
 =?utf-8?B?ZEUvUUE0U1p6Nnp5WXZ0SlJhaE1WVThFZ0l4ZHRHVTR6eDJmdXdnUWcrREk2?=
 =?utf-8?B?TExNYjBoN3BNbTVtL2VIaUZ1OGhMNDZQeHJxWEVmSkVuRTRqSWJaeHNmN2xI?=
 =?utf-8?B?L0xWTit2OFBMUnRSYk9PamNlZURNVTI2RjBiaG5CN1FlRXIwQlAzZGluRVZm?=
 =?utf-8?B?SjlnVlloaGJzZXF2ZFJlT25Wd24vWHl5c0pnWmhVOHFxV3UrTktHWjkvdThr?=
 =?utf-8?B?SERXNSsxbytxSndsUXFYdXR1enJ5YUJodjVIRkhma2F0UGgwc3NGM3ozVTdq?=
 =?utf-8?B?OTFsVm1ZeVNDR3ZBTG1nMGloQ0xZVExzREIyck11QkcwOXhLUVFJenNGRFNX?=
 =?utf-8?B?T1NTNnZaaUpVRGRHSmV0b0JHdng0c1QxVkxjUGppM2hEckZ3YytHQmF1OWpq?=
 =?utf-8?B?MjVBbGZXTGJrRVN3YTZXc3FSY1p1MjlkZUIraUlQQ3pBS1ExOE5ycGlEeGJ2?=
 =?utf-8?B?QnFiN0Q0ZWE5bUo1aFZMNC82TjA3bjc2UmRrTktDWXAxRE9LclI4YWVVS2ds?=
 =?utf-8?Q?+WqQFZ7bhV+19ANaIcOg/8F2eLUR28=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oaPaU3gTU52xowAOJO90rb6bvocLyCgUgRuzXd9qdTiyfLYsiy0LCAaeyIJgaWzhW8SA2oeqY49qMghvfCSmngBQwXVdkIgjJwqhB4gzeGZ8V1j0XsiBKhk9PXu7/eZ4VHCnahaV22AvgJKMn87ptvNJdWQBpV28lcfdLEbLfYZprbL0b62fGGlgfcQ7JWQqlQ7QSzLI3ynyfWpA2WPZhR3BfzYYD+llSPZBmoX984TwvRkIkky8RUTDmimTiG3gBlFMQhm1jWDiX3pV9JOwIj0g8x24QNleHagNJS+EOhzLeFz0+Ef6jQRl4yVEUYx6q50tV078LwXnV1XPMfhuzJEhlOIj5+v6NRYTLUVCzqqGN551vWGaD+lhxw9JrGP5XAEtWGfZ0rbQgeQAh81GUwnbFZxCZt9XyAT1/nRKMFFnE7i8NqnPHJrhGnnfdtgIBMpEKeCRAZyPz6+/7jafuhbI/gDBDgXDlGZslkwrj50A6PVHgdKFn1P2iGsUNEQFGDkTbzw2fIwIIDiEqOBTPwRZSM2ixmFmiHSma7JFimXUym1MA+mbbPuiqf7KWRkcBDCxHdDegFhxUvyw4DCvrTA82Xz4r019AYuhG+aHcWv+oDRAymrSI6bfdAD3ourZ8s7rdC9hRHPggQd6ncAtlw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:23.4457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a652149-15e6-42c7-75cd-08dd3bbd67ef
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB5338
X-BESS-ID: 1737643888-104932-13481-6511-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.59.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGhpbGQGYGUNQy1cQsJcXcIM
	XEJNHMxNjQ0sgsOTXN0tQyNTHJ0sLSUKk2FgBABVQbQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan17-79.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On teardown struct file_operations::uring_cmd requests
need to be completed by calling io_uring_cmd_done().
Not completing all ring entries would result in busy io-uring
tasks giving warning messages in intervals and unreleased
struct file.

Additionally the fuse connection and with that the ring can
only get released when all io-uring commands are completed.

Completion is done with ring entries that are
a) in waiting state for new fuse requests - io_uring_cmd_done
is needed

b) already in userspace - io_uring_cmd_done through teardown
is not needed, the request can just get released. If fuse server
is still active and commits such a ring entry, fuse_uring_cmd()
already checks if the connection is active and then complete the
io-uring itself with -ENOTCONN. I.e. special handling is not
needed.

This scheme is basically represented by the ring entry state
FRRS_WAIT and FRRS_USERSPACE.

Entries in state:
- FRRS_INIT: No action needed, do not contribute to
  ring->queue_refs yet
- All other states: Are currently processed by other tasks,
  async teardown is needed and it has to wait for the two
  states above. It could be also solved without an async
  teardown task, but would require additional if conditions
  in hot code paths. Also in my personal opinion the code
  looks cleaner with async teardown.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c         |   9 +++
 fs/fuse/dev_uring.c   | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  51 +++++++++++++
 3 files changed, 258 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0..1c21e491e891196c77c7f6135cdc2aece785d399 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -6,6 +6,7 @@
   See the file COPYING.
 */
 
+#include "dev_uring_i.h"
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
 
@@ -2291,6 +2292,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->lock);
 
 		fuse_dev_end_requests(&to_end);
+
+		/*
+		 * fc->lock must not be taken to avoid conflicts with io-uring
+		 * locks
+		 */
+		fuse_uring_abort(fc);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2302,6 +2309,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ec4f6a77c8d396057a586797ca84b8e4582fd5bf..ec5ca294a4fab42c31f1272c2650ca23148cc2b6 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -36,6 +36,37 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
 	ent->fuse_req = NULL;
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(req_list);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry(req, &queue->fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_splice_init(&queue->fuse_req_queue, &req_list);
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&req_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		queue = READ_ONCE(ring->queues[qid]);
+		if (!queue)
+			continue;
+
+		queue->stopped = true;
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -95,10 +126,13 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 		goto out_err;
 	}
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->nr_queues = nr_queues;
 	ring->fc = fc;
 	ring->max_payload_sz = max_payload_size;
+	atomic_set(&ring->queue_refs, 0);
 
 	spin_unlock(&fc->lock);
 	return ring;
@@ -155,6 +189,166 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	return queue;
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	/* remove entry from fuse_pqueue->processing */
+	list_del_init(&req->list);
+	ent->fuse_req = NULL;
+	clear_bit(FR_SENT, &req->flags);
+	req->out.h.error = -ECONNABORTED;
+	fuse_request_end(req);
+}
+
+/*
+ * Release a request/entry on connection tear down
+ */
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
+{
+	if (ent->cmd) {
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
+		ent->cmd = NULL;
+	}
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	list_del_init(&ent->list);
+	kfree(ent);
+}
+
+static void fuse_uring_stop_list_entries(struct list_head *head,
+					 struct fuse_ring_queue *queue,
+					 enum fuse_ring_req_state exp_state)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent, *next;
+	ssize_t queue_refs = SSIZE_MAX;
+	LIST_HEAD(to_teardown);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry_safe(ent, next, head, list) {
+		if (ent->state != exp_state) {
+			pr_warn("entry teardown qid=%d state=%d expected=%d",
+				queue->qid, ent->state, exp_state);
+			continue;
+		}
+
+		list_move(&ent->list, &to_teardown);
+	}
+	spin_unlock(&queue->lock);
+
+	/* no queue lock to avoid lock order issues */
+	list_for_each_entry_safe(ent, next, &to_teardown, list) {
+		fuse_uring_entry_teardown(ent);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+		WARN_ON_ONCE(queue_refs < 0);
+	}
+}
+
+static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue,
+				     FRRS_AVAILABLE);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_ent *ent;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		spin_lock(&queue->lock);
+		/*
+		 * Log entries from the intermediate queue, the other queues
+		 * should be empty
+		 */
+		list_for_each_entry(ent, &queue->ent_w_req_queue, list) {
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		list_for_each_entry(ent, &queue->ent_commit_queue, list) {
+			pr_info(" ent-commit-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		spin_unlock(&queue->lock);
+	}
+	ring->stop_debug_log = 1;
+}
+
+static void fuse_uring_async_stop_queues(struct work_struct *work)
+{
+	int qid;
+	struct fuse_ring *ring =
+		container_of(work, struct fuse_ring, async_teardown_work.work);
+
+	/* XXX code dup */
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	/*
+	 * Some ring entries might be in the middle of IO operations,
+	 * i.e. in process to get handled by file_operations::uring_cmd
+	 * or on the way to userspace - we could handle that with conditions in
+	 * run time code, but easier/cleaner to have an async tear down handler
+	 * If there are still queue references left
+	 */
+	if (atomic_read(&ring->queue_refs) > 0) {
+		if (time_after(jiffies,
+			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
+			fuse_uring_log_ent_state(ring);
+
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
+/*
+ * Stop the ring queues
+ */
+void fuse_uring_stop_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		ring->teardown_time = jiffies;
+		INIT_DELAYED_WORK(&ring->async_teardown_work,
+				  fuse_uring_async_stop_queues);
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -532,6 +726,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = &queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -659,6 +856,7 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 	ent->headers = iov[0].iov_base;
 	ent->payload = iov[1].iov_base;
 
+	atomic_inc(&ring->queue_refs);
 	return ent;
 }
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 44bf237f0d5abcadbb768ba3940c3fec813b079d..a4316e118cbd80f18f40959f4a368d2a7f052505 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -80,6 +83,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -97,12 +102,51 @@ struct fuse_ring {
 	size_t max_payload_sz;
 
 	struct fuse_ring_queue **queues;
+
+	/*
+	 * Log ring entry states on stop when entries cannot be released
+	 */
+	unsigned int stop_debug_log : 1;
+
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
+	atomic_t queue_refs;
 };
 
 bool fuse_uring_enabled(void);
 void fuse_uring_destruct(struct fuse_conn *fc);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring == NULL)
+		return;
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_uring_abort_end_requests(ring);
+		fuse_uring_stop_queues(ring);
+	}
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring)
+		wait_event(ring->stop_waitq,
+			   atomic_read(&ring->queue_refs) == 0);
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -120,6 +164,13 @@ static inline bool fuse_uring_enabled(void)
 	return false;
 }
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


