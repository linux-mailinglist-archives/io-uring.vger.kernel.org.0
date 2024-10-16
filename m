Return-Path: <io-uring+bounces-3700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 845A799FD37
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A86E11C20DE5
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B583E574;
	Wed, 16 Oct 2024 00:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HnBfLGNA"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C7E10A0E
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039060; cv=fail; b=uXbIWEhut5Hx7gmm/3+lES3bV4VT00T+EofrhmyVoMtXdTba5sHlBaM9HACrpR2toj7dNF7zzFQx9LMfe/X8abQJLJ6i319yBaOWM0psRyJQfT3zTxR04i9FUXhhb55pOrlOMc6g5lDtVdhTqRYCEzLLpkB1iN1xql3We7gZT1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039060; c=relaxed/simple;
	bh=pNuXHqYBMelL+iq3r157MkqfPX8Plp4UFsidoOeclY4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B7rpvcwjuMzBZtchu8XYb7GC9YFVGTazdXe5R6/hrXXo3TNvxecXsrZE7TpeRXaGyl2L48WK/hNX1NVxcU9AhWFa3n8UDSyOtlNOP15yINVWNAef4eR6DMxUbIc9yNZq+39Eh1++hKdPrysXrhvgGkJRVb+G/fECxATFO7gYUAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HnBfLGNA; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48]) by mx-outbound10-224.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4gq17YjXqrfsMwEQjBu9urn9VN/oXK4qoo8ZOWrk8yDeJblgrIEVenmWt+QALcLbP/RliGpEpLD3xQdvhy8cF67btso4dVLRkOvMnhDAWqwg6Lufh97FTAWLiwCH3/wylRNEDSUO+yD7QydHP4jl0l/ZA3dGY8uIXhgzFiJEp2i2hU5nZCF2Cq0qvpZpQOQStxC/13L4bN94urFRc6+K7iUCgAb9/1+93j++AzjcG7zPJr3L8WblnL2rJPSBOtZ4PPdAq2yxOK68hlYeHPFPMfUPXpMV6NYBe8hMzRGAtwYHRTXU31KNq4EuLoRbP36zOPy0qEFJmJ7/xCmt3nSrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfnHHdzb39eJZ8k53FfikwN0df4vGqbRyNXofbLxbVg=;
 b=uR1CsDO6Nx71r2dbu7om5VCi+816gjpq50tNHS4ufkLJbOCUhpSvK1PW1SDLD8+uf4MoOuuC4GQcVWtemTDflkwJKRKzyRqpoTvURAW6EcDKNPiZ0Ys9SbvBFwjufQdUMWCJGVdHWAAwwlQ2dwOg0phiunflZAj26iXerTYElMR3iU2OILhgaFqPVn5O7kzqtsgYzExm/Nuj8ZebtB5LcXOQnKQcUiftKoRaJRljVUtcHbfUCfNyw7FcPkVVz+7As4/y3WSJqLrjawCFQamWKago/QuB6x+h1zga3z9NfKN1uQf+5QA87sQ6udMw6225NLVn1lVnezA417SmXiNlSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfnHHdzb39eJZ8k53FfikwN0df4vGqbRyNXofbLxbVg=;
 b=HnBfLGNAmdH798l5cr7Jx0HQ7+FG1o4G075mRREg8JxkhfiZW8U95SePLKzgk3HaJc4TiHrrf6kRv4pKthLYp04A9zCmNRku6fP7GaXplz2q/2XXIiCLuh/MCywfkgU7kTvyMFmiqHOfi/vAaFBy1v257nNXJGPOstQZQadIDPY=
Received: from MN2PR14CA0028.namprd14.prod.outlook.com (2603:10b6:208:23e::33)
 by LV8PR19MB8352.namprd19.prod.outlook.com (2603:10b6:408:201::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:05:32 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:208:23e:cafe::59) by MN2PR14CA0028.outlook.office365.com
 (2603:10b6:208:23e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:31 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 9FFD97D;
	Wed, 16 Oct 2024 00:05:30 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:19 +0200
Subject: [PATCH RFC v4 07/15] fuse: Add buffer offset for uring into
 fuse_copy_state
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-7-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=1743;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=pNuXHqYBMelL+iq3r157MkqfPX8Plp4UFsidoOeclY4=;
 b=aqaW2yUyFQ2jU2qooXUHW2BixrNMMde6j3r6zW14Uyd36u8EWqXYPN0ySCga/N/dNwDDgcrSN
 t/J09wl/J3uCN7+C++32Sn5cTJ1NIacVh/DzTf3IOPWCUu/j/sUgWQq
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|LV8PR19MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ad4e6f0-c704-4797-576c-08dced76403b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEhZZmV0Z2loQ3hlUGprVTdKcEZlcU9BQWgwZE5zVG1Nd0pLN0VaTXgzcjRu?=
 =?utf-8?B?YUdPS1ZYWndtUWNOUXljdVpEUkwrK01HckxIa1pjZ0YvZ01ZMlRWVm4xbVlR?=
 =?utf-8?B?Z0JsNUJ0blNjNmZLeXlMVzBaZW9qajNnSnVEb1VnWDR2bCt4czRZa05HMFFu?=
 =?utf-8?B?T2RudTZUaTIxa0N0eTI1bGd0N0kxUWpzMXI4WTlzeVNZWnRCRnJmK0Fia2Rp?=
 =?utf-8?B?ZGtiZDZMdnFEekdVZE1OdkJhTWZVNFJPRm5yd25vT2JGYVdvZEh4M1FhWE5z?=
 =?utf-8?B?dzRMcUxDaEhWMGd4YS84QThrVndINlBEZlpQckRURldodlcycXdWdVBQSlpj?=
 =?utf-8?B?c3d0aElhTytsc0hsdmY3ak1xaEFXc0NNTk9HRno0WHJ3VG0zZmMxWEtJeWdj?=
 =?utf-8?B?a0xnc2xnS0xSUTlsaWtsT0locmp1OHphWDhVZDdxUVgzRTJkOW9lUlhlN3Rw?=
 =?utf-8?B?MmJKTWkwZkh6d292MVYrZnBIdWxCRFBLVmx6VWRzdXpWeHBNSFU2aktLVnhY?=
 =?utf-8?B?TndrNVdRSVF3NzRTY0wyOFNHdHJnQy9HaS9qY0VLTUNKMTIxVmRhdzBxaEdM?=
 =?utf-8?B?c2pqNm1FbUVaSzRqUlkzV2tHRFkybzQ5T21qenl5dzVadFg4NDkwNmdmb2Y3?=
 =?utf-8?B?VjNRMjZlRXd5S2NQRzJsT1d4Y2g0SVBQRGVmUFVIbVR0TURiVXhyZDN4bEcw?=
 =?utf-8?B?WGYwNzFzZzVaS1NLOXJtWDFEbG1YMWZwRktvNW5XaHU0NTVNMVFKSmluSmRO?=
 =?utf-8?B?OElya3gyR3BUNzIzbVdsZFM2c3lzSSt2NVZETkh3cHlsMTJIUkwreDF3ZHA2?=
 =?utf-8?B?SjJ6YmlURXlkSDdwQjJpalFvZFVNRE9QU0NRdDNrL1dZL2NqZXcvQzRPN0tj?=
 =?utf-8?B?SnkyZ1RXMDFUVkJ3RG5TM3JGZGYyaUI0Y3ZrT3kwT0dsaTJLbS9VV1Z1RGtT?=
 =?utf-8?B?SjA4R2pOd1ltNEpyLzhxc1dPckRud0tNWTVBRVBqdTdmZnJEQUM3Z3Zmbk13?=
 =?utf-8?B?dVhYSG9IeXFlWnYxWDRCUTR5WlkrUWE1NjVCTXlXTjFMS1BBMk9QZFdJb0Fl?=
 =?utf-8?B?ZFZtakp1dzRPMXNFYWZvV2RHZkhlVTkzV0Z1MGk3TEdQMDN2eVhmYzFITk9X?=
 =?utf-8?B?NWVBV1NpNUF2bHRQRDlkcXNpQWUwOXpWV2d3WHBVbm8rSHBPdHZLUm01REJ5?=
 =?utf-8?B?ZHlzTEd4OVprQ2ppalJvUEVkeGhBYTNmcFlrYU9SVEtlYi9IY1kzMTFjczA1?=
 =?utf-8?B?b2lSdkI1TEhKWkdLVjBHL3BvMlBqRllIT2V0dW8zdUFrYzFVcW5jREJmSG50?=
 =?utf-8?B?YXdHQlMxeDczNFlGUE9ZZ1J3MEk1YkdPWkhaZnIrazNDWjB1QXpPSC9oWjlh?=
 =?utf-8?B?ZWhnOEhEMjk1THJ6RUM2b2hvQy9FV2pTZlVMTlFqbFFoRkxWWTloODBFanJz?=
 =?utf-8?B?dk9DeFkraVZDYWxwU1J6WVpjcEZ1RnVRbXAwaVdyZGR0dmQ1R1VqUzRIREZl?=
 =?utf-8?B?TU5ieWN4cmxoS29oeTRTaFNDVVdGYy9ma2xYWUVjd0p5R2VtRHptWUJ2eC96?=
 =?utf-8?B?YURzU2xiNGZ3R2xoL0VGUzZvRnF3K3pvV2xWaTFQMnh4cUVrZHpOTDV3ZytW?=
 =?utf-8?B?MGtwZGxZTnRVY1JYSDhGaytRVUNtOU5RdGxDQSszWG5MNjJIRkpUaWptZERY?=
 =?utf-8?B?R0RJNzZYVkNiQmljWCs2clZUYWpsRjk0eFZBMTNWeEFhSVh6aDk2ckFtYXY4?=
 =?utf-8?B?dHZ0YmhGVU9meGJGcDI1MGRVa1VjTlYrcXZvWStNS3lDaXlmOHhSeUJWbVZs?=
 =?utf-8?B?Z29EZGtHK2svVkVvcFVpSURIZVNma0t3VSs1ZEgrcVlMNU4ydWJPZlhENVpy?=
 =?utf-8?Q?f6H2DClOeiJcm?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P6HNpNvOOQ15XjSwEk1nsve2FJ4Z0d8XPYXxwXN/JE/Ln9Q68xmrpBRQNYu4nW5tuTWqiXBVew1pdVH50Dx9WAfndh/onMMW2/XqA3iFxbHzQ5ILnjGkm98YYudE6K+jYZCSyepu/SA8IzOM4ZbS0IVB7KbfcBEh2PUhh+kvqgiAWskiJmAcBQ/HGUW2/duN9otifNffz0SZm5DFzh1R1AucaYmyvl1AGaGKzBmouEnrig867dZoYB9z7pdDaD399ObopEOY1fF/7W/Zy5w6EmMIYCDoHAPE3d6YJMnQ2NmeSghHqmPmTbvgqMi9gc+9PuHzHbuIs0/rZEQeP74V0OJVFpyVAf7oXr+nbu3MbMM75izFOYeeihylISc6NDRX1t720T5TVWrezGlL6qVMaCauQxSeyxDglJJp0qN23ubMCQpQOBdHFfvRT9bCZQ+QrcK9jrsq0q/wjoR/dyTQBpx/QYR2iHTy+6eDALPSjamaYSbaYu5AddFWiEb90GtAkDIYceykE470yVWLvbJLcMta7MK9fkdujq/pNESmRBx1uNmJ4G8s9sIYXJ38yHTRfgdn+7GeaGypw62vOgSFWB4eK3lJSUE/ZnmAnbgJtKMpZnDzkZmkMKWF8HW7vvfDSVC7a5qlcPufkroqRH2GJg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:31.7760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad4e6f0-c704-4797-576c-08dced76403b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR19MB8352
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039056-102784-8768-66017-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.55.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmFmZAVgZQMCnNzDLRKCXV1D
	DZ3NTcKM3Y0tTMyMDCxMIkySINiJRqYwGzmMVrQQAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan16-20.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This is to know the size of the overall copy.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 13 ++++++++++++-
 fs/fuse/fuse_dev_i.h |  5 +++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index dc4e0f787159a0ce28d29d410f23120aa55cad53..12836b44de9164e750f2a5f4c4d78c5c934a32b4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -738,6 +738,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.offset += ncpy;
+
 	return ncpy;
 }
 
@@ -1856,7 +1859,15 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned nbytes)
 {
-	unsigned reqsize = sizeof(struct fuse_out_header);
+
+	unsigned int reqsize = 0;
+
+	/*
+	 * Uring has the out header outside of args
+	 * XXX: This uring exception will probably change
+	 */
+	if (!cs->is_uring)
+		reqsize = sizeof(struct fuse_out_header);
 
 	reqsize += fuse_len_args(args->out_numargs, args->out_args);
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index f36e304cd62c8302aed95de89926fc894f602cfd..7ecb103af6f0feca99eb8940872c6a5ccf2e5186 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -28,6 +28,11 @@ struct fuse_copy_state {
 	unsigned int len;
 	unsigned int offset;
 	unsigned int move_pages:1;
+	unsigned int is_uring:1;
+	struct {
+		/* overall offset with the user buffer */
+		unsigned int offset;
+	} ring;
 };
 
 static inline struct fuse_dev *fuse_get_dev(struct file *file)

-- 
2.43.0


