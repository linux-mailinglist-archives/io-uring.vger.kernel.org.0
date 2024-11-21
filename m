Return-Path: <io-uring+bounces-4959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6FB9D56A4
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68468B21C2F
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8AD15A8;
	Fri, 22 Nov 2024 00:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="QuW34mES"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948B4430;
	Fri, 22 Nov 2024 00:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234649; cv=fail; b=nD+qHaxPcIpw8398yI/IQ8mVjR8hvpIElULdqPwSu24vmfMAJ+W4NZjYsj4BxoY6Rnj2qIWtx+IGKPYuxoG0/haWj1sgV2iihbPZwabzMn00ZV1dCx414nxyd8cVlFCV0mLYtQV753/l6tHTBgfTBtVhv8xMvlKUnSY1AIjW1no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234649; c=relaxed/simple;
	bh=jgthYjzC6cbaVL5qIhUchuYhbBj/1i+GKM1tE/IWnes=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mDSRXXMRJzMqHS5Xn0pGtjNyM2NgtZ4ePMsCN5Xb+0sFabO52koQ2up+mjYbD5n9AH4UhyNr56+vYtb/T0RF+vNl+GoPMMsbr1yHhqg37aIizFHxhplwxuoVzdxQjm/HePasj7Bbj2z1hDwqOD2Pk8L1qMxyY7IvvZluogf+D8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=QuW34mES; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168]) by mx-outbound18-0.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XzwT5v8SMMBPkh1UPJF2ZyZ25SqsGayc8or1yl3ekmNNY49sCgKi4lVyX798TRm2gh2DVG3RsRNIQDHryZdrNkHYmHOI+UpMQl6jDdnewOCZn+hKxmdF/vM9QqikxYZMVg39SbCEDP3x5L88bLRxlZfKP2d/bqPLVJlm+MZljlk0lLWvoZmAGxu8mX8KsPNdiwWE3IVkQAP1MgvqZynjcjxEh0ILJolJSCPSUB6qthT6f35sV1KIzsWLH3/vRoyviqHqOwKsWEsXJxZpOMBA+dt1GCZ+D7tTYrzOfNpnCnaau6ZNIfdU0bwIEn0HwdGva76OXu2ln9ve9gPMZXqwGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhU8Xpsr6eZYJ5Pu3Gi9ouoKQ5IjiLBQQwdmtKjQXjo=;
 b=oUrcmzohpKzZLmzIlL7D5/Y/0dE1474RIHj3b3aHgSIrAo8lV56UfmuzXxyA4RNxl4MHuzi0gEiTGvt9alkXqaVJCrXD1KCAdX8+rWlvx14qyiHablQfDzjVp6Db7GpJN0cJi88h+7fd1Oy3BH5n7CilfzLJHfxXn2MvLp7hDyv+bW++hBShG/d+pFLb8sEnU6ctkt2X65wcBuBjS8fcydSa5p6qvDKsbXvnEvbBp597kozzOzlXwPPZY8NzzVxvc5QxdNg1hhr5G+87mQG2Er3vwC3+loAudYsPPvg0nt2gST8YYrIxU2SO0VonC4n0F8+5yAXYaBI22kxT76eckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhU8Xpsr6eZYJ5Pu3Gi9ouoKQ5IjiLBQQwdmtKjQXjo=;
 b=QuW34mESvVotXtClbchRyla/66GyXWRKQv7UyVldS+biYh25xfne/iVngsokDSD/0i7DIXdhOUEKgaj4J0Bkb8VqesxMkeKqLhtKYhqM2LQqZ9Hefl25gaYXqhSKOCmi5peiiH181NuNHAhOALoPGuedZn8aUEu8nfEr7a8GALI=
Received: from SJ0PR13CA0192.namprd13.prod.outlook.com (2603:10b6:a03:2c3::17)
 by PH7PR19MB6753.namprd19.prod.outlook.com (2603:10b6:510:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Thu, 21 Nov
 2024 23:43:59 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::ce) by SJ0PR13CA0192.outlook.office365.com
 (2603:10b6:a03:2c3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:59 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id AFEB12D;
	Thu, 21 Nov 2024 23:43:58 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:25 +0100
Subject: [PATCH RFC v6 09/16] fuse: {uring} Add uring sqe commit and fetch
 support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-9-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=19177;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=jgthYjzC6cbaVL5qIhUchuYhbBj/1i+GKM1tE/IWnes=;
 b=lpyoF+fbE3CmDpsMhqYEq8DzPtaGxWcxcckZvkx575wOTNuVwwP3xajfylDXAgHSzgHW4lzqh
 1D0AmGpAsaEDSKO3GzG2s3plRRJKWa/Uu9fheBN+Zf3uQEiCeRZoWat
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|PH7PR19MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: 390b4d02-76d8-4245-9e68-08dd0a865f52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?MVp5UFhjSm9ONUhRSWc0ekp5OWRyNm9qQXZPOUlRL2Q4RmtWcmhuQ1lSOUI1?=
 =?utf-8?B?RG1uMU5XYWVqd1JVUEUvNnluelhoWlNnUDB5RlkrZUovVlp0bS9sNjNoeTFu?=
 =?utf-8?B?V2VROVRZVE1BL1hKeFF6bDRlSXViSHdQUnkzc1ZMdDlsTzVmZm1nL01BK0d0?=
 =?utf-8?B?dFR3a0pyMzJtVTNoV2JBclZUOFArejB1Q2tkbVZKT244ZE56ZVBXVGU3WFRZ?=
 =?utf-8?B?OUtYQWVLeDlOTmE1MnkrbjZvcU5tc2JKY210SnNheGZWaG12SzdhZGZnRXFv?=
 =?utf-8?B?Q2dPcHl1ZGhLdGdqTkpXb29QN2NkcGVnS1lGNStoeTR1NkwwWE03Z1cyQ3FS?=
 =?utf-8?B?a3lIeUxuMkNZNE1HQkVaSHNuanJCK2hibUQyOWZVMnRQMUM0SnFWVFE2Y1Fi?=
 =?utf-8?B?ZVNPaVpSTmFSajVFTnVJRzY0YlBzVjFlUStPbXZZMi8zRXF3TE42Umhtejky?=
 =?utf-8?B?UkRaY2VBblVuajZROG05empKbW43c20xQ01TOE1HTVh4VGZZMkV1UHpwUDNP?=
 =?utf-8?B?TmM0eFo4QVlpcDFpbCtiaHV6cjRvblZVRHZqb2hCbkxUamtIbWh4WmkrdDl0?=
 =?utf-8?B?b0FOcSt3YzNGZlZCK1BRbzJ6SG8rRWpaWjhGU1F1dXNsMGpLTHhnY25jdUdC?=
 =?utf-8?B?L09RamFES1BIQ2ZnYjRRQjlkOThCT2ZBUm9NbW04eDlQRUluRlpsZStrSnF6?=
 =?utf-8?B?Y2Exb014NXBSY3RCZmVDQkc4WlVUTEExS2FielNIM1dLVlAwV1lOd2R6VWEw?=
 =?utf-8?B?NjdxR3FQbTd2U2ptY2djTFJRMjlOeVpDWGZLZjFPL0xvdGNMVFU4ajMrcDFR?=
 =?utf-8?B?QU5TRlNDZWt4TjhXWjI4QkRjNVpyaW9mUnJjZnJaVjZVbFNSTkxlVFdsVVAv?=
 =?utf-8?B?Z3NQVE91QUxibWpQckRzL29CZkczUUp2VFQ0UndCTU9rSWRNZ0VSL1ZvOTVr?=
 =?utf-8?B?M3psbDVqcG1YS0hrS3Ftc3NodVVGOXc4TXRkN3VuSkI1WW4wT25SVm1tUEVU?=
 =?utf-8?B?dVFvN09lSmRkbnIvYWMwbUJTU3paR3IvbXFrM0FzQ0Q3MEdFN1NmSkozUmVj?=
 =?utf-8?B?bUczLzBDRjBGSVRyckxSUG04NzVkMC9xeGplOXFjNGNVdkt0NHRjTnZ1bEZr?=
 =?utf-8?B?bnh4Y1lUcVpETTluUzIxNnY0S216MkJYQThDR01nYUtoZnQvOE4wN3VtV3Zw?=
 =?utf-8?B?ekEzaDdYODZjL3JRcmEyNWE0Q2FRaFNjejR0Mi9mRVZhdDJPeWMzaE8wSUN4?=
 =?utf-8?B?aWtRQjJJTHlNOWVwbi9md1Rxc1R6SWdKZEtzTFdPZXFyKzFoY0UxdkVTdkEz?=
 =?utf-8?B?ZnlkZ2hzcDJUcUM4VlRYTEg5U01hMW1YT0NmWVdNWk40TGRIamF4WjZWdzN6?=
 =?utf-8?B?d1JUWkZaRFVUb2VlUDlmQVU4NUxIdTE1RWpabnlEckJXaEt1OTYxU0JIVGIr?=
 =?utf-8?B?N3IzM1VheXVXTVBIb3dwaWN2OE1lMjJDa1RVdzJIRXJLbytTSkhYbjFKUmxV?=
 =?utf-8?B?RDB4OUxPYVNseWlBZVBna1JkT1RVWHpXUFAzWmp6TzhidEl3K0hmakI2TEdS?=
 =?utf-8?B?WHpGcTZrb040cFRpTGpuUkpnemVQUU1WK3pQd25kUmt6NkNVZ2tjU0wxN3pr?=
 =?utf-8?B?Z0JrQXJNOUkwSWs4LzBsM3VMOHFMckVTNXVOYmNCdHYwL3EvKzFLcGJGQkxU?=
 =?utf-8?B?bG1vYXZsWG5nMVdlRWxENTV5TzdhZTR4b2hWRkZ5ZnZCeXlBcXlVdjNTNW5X?=
 =?utf-8?B?OHZEeXFLM29QeGNyKzVkcjdXOGIvM3lPUnYzUnpqQVkwVkh4UDJUT1U3RGlG?=
 =?utf-8?B?dkZvK2RPU1Y2WTE3UEd2eWpRYncreWFEQ1gyTWRsWVM3bU0vT1J3eHpIVWJD?=
 =?utf-8?B?MTVuQmtYM3RLYlE1UFRTdlVZalBWdGV2VzA3TlNIVGZxblE9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 i0RJZiNfb6pNrdAdLa2xqXAgsIBQLe9v7rW9vqfxpGW1FfPMfMsb48tN/7gRFOoF+f0gtvrqq+F57s2B6Vs1R3pp2D7ut806vYEMEPYzWD5kVoiU5Y8Z3Y1RQlkR+7Qz7wGMfYehkEJRpU+ei9MOC56Vt+KDI+WxPdCOsGMaHmLX6/QNkuJfe9D9ZgByD3AgbFoDo6cipoKEL1LQjxO9sZ6r+BGtBAp8JjVJ1Wnf8Yq/nqJlP//b2WKd+gwTnnxH/rTb4TlNUzsVzZlDPpovAy2dObjBr/bnws7GZZOXfteWiPpwUbFwaFHm6vPoeXX3uULrpqfIjv0LD8LpN0QMOp+/uaJx1UEriTpDnG/sT1xADe2hoicCaE5wHxW/JKn9rqn5Egcv2cearfRoj+iG6iO5/EljljXkYUvWSk0OQmy8Ork666giImE+1NsBDU6Si52Nmiq3nzXnXcGK55YKXiumzbKZNOWnh8uyD20b921zgN7wXks6OUELKyRBXd/toxV7saYw7TwsHNTbfKtnmIFX/RQDX2Pl2NhI67vYDpxpNPtUOQwAbb+i0TwkGMpP9wE+z9kVqCE572ebKwW8+fs7+2p6Mv8oLr8s62Cl1ES/fYaUPn/o6m+eOt6dyUkFANd/FjaY+Yi4ayJmC1u2sg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:59.6686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 390b4d02-76d8-4245-9e68-08dd0a865f52
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB6753
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234643-104608-31573-63567-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.59.168
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWpgaWQGYGUNQizTgpOc3Awt
	TIMNnEyMTANMUgNTUpzdDEwMTY2CDNSKk2FgBsHTP2QgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan12-183.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_REQ_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   6 +-
 fs/fuse/dev_uring.c   | 451 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  12 ++
 fs/fuse/fuse_dev_i.h  |   7 +-
 fs/fuse/fuse_i.h      |   9 +
 fs/fuse/inode.c       |   2 +-
 6 files changed, 482 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ad65ede9c7723bb6f3589e64b8eef7429fa4b488..15dc168fd789bf11f27fae11a732a3dfc60de97d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -221,7 +221,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1914,7 +1914,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1998,7 +1998,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ef5e40dcbc5154d8665c7c7ad46123c4a1d621ee..46aab7f7ee0680e84e3a62ae99e664d8b0f85421 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -19,6 +19,24 @@ MODULE_PARM_DESC(enable_uring,
 		 "Enable uring userspace communication through uring.");
 #endif
 
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+/*
+ * Finalize a fuse request, then fetch and send the next entry, if available
+ */
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
 static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
 	struct fuse_ring_queue *queue = ent->queue;
@@ -49,8 +67,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 			continue;
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_w_req_queue));
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -109,13 +130,21 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
+	struct list_head *pq;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
 		return ERR_PTR(-ENOMEM);
+	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+	if (!pq) {
+		kfree(queue);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
 		spin_unlock(&fc->lock);
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		return ring->queues[qid];
 	}
@@ -126,6 +155,12 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 
 	INIT_LIST_HEAD(&queue->ent_avail_queue);
 	INIT_LIST_HEAD(&queue->ent_commit_queue);
+	INIT_LIST_HEAD(&queue->ent_w_req_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->fuse_req_queue);
+
+	queue->fpq.processing = pq;
+	fuse_pqueue_init(&queue->fpq);
 
 	WRITE_ONCE(ring->queues[qid], queue);
 	spin_unlock(&fc->lock);
@@ -133,6 +168,232 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	return queue;
 }
 
+static void
+fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+}
+
+/*
+ * Checks for errors and stores it into the request
+ */
+static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
+					 struct fuse_req *req,
+					 struct fuse_conn *fc)
+{
+	int err;
+
+	if (oh->unique == 0) {
+		/* Not supportd through request based uring, this needs another
+		 * ring from user space to kernel
+		 */
+		pr_warn("Unsupported fuse-notify\n");
+		err = -EINVAL;
+		goto seterr;
+	}
+
+	if (oh->error <= -512 || oh->error > 0) {
+		err = -EINVAL;
+		goto seterr;
+	}
+
+	if (oh->error) {
+		err = oh->error;
+		pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__,
+			 err, req->args->opcode, req->out.h.error);
+		goto err; /* error already set */
+	}
+
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
+		pr_warn("Unpexted seqno mismatch, expected: %llu got %llu\n",
+			req->in.h.unique, oh->unique & ~FUSE_INT_REQ_BIT);
+		err = -ENOENT;
+		goto seterr;
+	}
+
+	/* Is it an interrupt reply ID?	 */
+	if (oh->unique & FUSE_INT_REQ_BIT) {
+		err = 0;
+		if (oh->error == -ENOSYS)
+			fc->no_interrupt = 1;
+		else if (oh->error == -EAGAIN) {
+			/* XXX Interrupts not handled yet */
+			/* err = queue_interrupt(req); */
+			pr_warn("Intrerupt EAGAIN not supported yet");
+			err = -EINVAL;
+		}
+
+		goto seterr;
+	}
+
+	return 0;
+
+seterr:
+	pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
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
+	struct fuse_ring_ent_in_out ring_in_out;
+
+	res = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+			     sizeof(ring_in_out));
+	if (res)
+		return -EFAULT;
+
+	err = import_ubuf(ITER_SOURCE, ent->payload, ent->max_arg_len, &iter);
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
+	struct fuse_ring_ent_in_out ring_in_out = { .flags = 0 };
+
+	if (num_args == 0)
+		return 0;
+
+	err = import_ubuf(ITER_DEST, ent->payload, ent->max_arg_len, &iter);
+	if (err) {
+		pr_info_ratelimited("Import user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	/*
+	 * Expectation is that the first argument is the per op header.
+	 * Some op code have that as zero.
+	 */
+	if (args->in_args[0].size > 0) {
+		res = copy_to_user(&ent->headers->op_in, in_args->value,
+				   in_args->size);
+		err = res > 0 ? -EFAULT : res;
+		if (err) {
+			pr_info_ratelimited("Copying the header failed.\n");
+			return err;
+		}
+	}
+	in_args++;
+	num_args--;
+
+	/* copy the payload */
+	err = fuse_copy_args(&cs, num_args, args->in_pages,
+			     (struct fuse_arg *)in_args, 0);
+	if (err) {
+		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	ring_in_out.payload_sz = cs.ring.offset;
+	res = copy_to_user(&ent->headers->ring_ent_in_out, &ring_in_out,
+			   sizeof(ring_in_out));
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
+	int err = 0, res;
+
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent, ring_ent->state);
+		err = -EIO;
+	}
+
+	if (err)
+		return err;
+
+	pr_devel("%s qid=%d state=%d cmd-done op=%d unique=%llu\n", __func__,
+		 queue->qid, ring_ent->state, req->in.h.opcode,
+		 req->in.h.unique);
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info("Copy to ring failed: %d\n", err);
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
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
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
+	io_uring_cmd_complete_in_task(ring_ent->cmd,
+				      fuse_uring_async_send_to_ring);
+	return 0;
+
+err:
+	return err;
+}
+
 /*
  * Put a ring request onto hold, it is no longer used for now.
  */
@@ -159,6 +420,193 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_WAIT;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
+				 struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	req->ring_entry = ring_ent;
+	hash = fuse_req_hash(req->in.h.unique);
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
+	if (WARN_ON_ONCE(ring_ent->state != FRRS_WAIT &&
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
+	struct fuse_req *req = NULL;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	if (!list_empty(req_queue)) {
+		req = list_first_entry(req_queue, struct fuse_req, list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	}
+
+	return req ? true : false;
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
+		pr_devel("%s:%d err=%zd oh->err=%d\n", __func__, __LINE__, err,
+			 req->out.h.error);
+		goto out;
+	}
+
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	if (err)
+		set_err = true;
+
+out:
+	pr_devel("%s:%d ret=%zd op=%d req-ret=%d\n", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	fuse_uring_req_end(ring_ent, set_err, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
+				    struct fuse_ring_queue *queue)
+{
+	int has_next, err;
+	int prev_state = ring_ent->state;
+
+	do {
+		spin_lock(&queue->lock);
+		has_next = fuse_uring_ent_assign_req(ring_ent);
+		if (!has_next) {
+			fuse_uring_ent_avail(ring_ent, queue);
+			spin_unlock(&queue->lock);
+			break; /* no request left */
+		}
+		spin_unlock(&queue->lock);
+
+		err = fuse_uring_send_next_to_ring(ring_ent);
+		if (err)
+			ring_ent->state = prev_state;
+	} while (err);
+}
+
+/* FUSE_URING_REQ_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
+				   struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	uint64_t commit_id = cmd_req->commit_id;
+	struct fuse_pqueue fpq;
+	struct fuse_req *req;
+
+	err = -ENOTCONN;
+	if (!ring)
+		return err;
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue)
+		return err;
+	fpq = queue->fpq;
+
+	spin_lock(&queue->lock);
+	/* Find a request based on the unique ID of the fuse request
+	 * This should get revised, as it needs a hash calculation and list
+	 * search. And full struct fuse_pqueue is needed (memory overhead).
+	 * As well as the link from req to ring_ent.
+	 */
+	req = fuse_request_find(&fpq, commit_id);
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
+	err = fuse_ring_ent_unset_userspace(ring_ent);
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
+	fuse_uring_next_fuse_req(ring_ent, queue);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -335,6 +783,9 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 			return err;
 		}
 		break;
+	case FUSE_URING_REQ_COMMIT_AND_FETCH:
+		err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		break;
 	default:
 		err = -EINVAL;
 		pr_devel("Unknown uring command %d", cmd_op);
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 17767e373d31969fe2987fed31c66b5077f209c6..65e8ca9bcb10f11b1b62f2b59cda979da961ebd4 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -20,6 +20,9 @@ enum fuse_ring_req_state {
 	/* The ring entry is waiting for new fuse requests */
 	FRRS_WAIT,
 
+	/* The ring entry got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -72,7 +75,16 @@ struct fuse_ring_queue {
 	 * entries in the process of being committed or in the process
 	 * to be send to userspace
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
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 7ecb103af6f0feca99eb8940872c6a5ccf2e5186..a8d578b99a14239c05b4a496a4b3b1396eb768dd 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -7,7 +7,7 @@
 #define _FS_FUSE_DEV_I_H
 
 #include <linux/types.h>
-
+#include <linux/fs.h>
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
@@ -15,6 +15,8 @@
 
 struct fuse_arg;
 struct fuse_args;
+struct fuse_pqueue;
+struct fuse_req;
 
 struct fuse_copy_state {
 	int write;
@@ -44,6 +46,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 5e009a3511d3dd4e9c0e8b4f08ebb271831b1236..55cac719ed7355a73546c148f1b2c257fa1b70f7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -435,6 +435,10 @@ struct fuse_req {
 
 	/** fuse_mount this request belongs to */
 	struct fuse_mount *fm;
+
+#ifdef CONFIG_FUSE_IO_URING
+	void *ring_entry;
+#endif
 };
 
 struct fuse_iqueue;
@@ -1215,6 +1219,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
  */
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 
+/**
+ * Initialize the fuse processing queue
+ */
+void fuse_pqueue_init(struct fuse_pqueue *fpq);
+
 /**
  * Initialize fuse_conn
  */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index c8f72a50047ac1dfc7e52e9f4e49716a016326ff..b0d44176601f6f7591042d8553596888a7490a85 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -906,7 +906,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


