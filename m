Return-Path: <io-uring+bounces-5068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB30F9DA8AE
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CF42B230DC
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA6D1FCFD7;
	Wed, 27 Nov 2024 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="p4OQj/VO"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A059463;
	Wed, 27 Nov 2024 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714861; cv=fail; b=IIg/59wiZr5XWJWDtBq778dq3A6DDvhItXKKccVGKlZ6u/go5jqCOyAhjqqDaRUfOl2UOhGnZkI+WPFsSeEkTxob7IZJI89hGJAEkdU93dAPcRkVcRaeszQkYLIvjjK5Uq+dXV8ExNTe4QjZNIFgHWmkn4LXquP4cpLHIr5bau8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714861; c=relaxed/simple;
	bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a6+31ORthdaml0ZSnUX/OMbKTh/S1+wiSmMou9D4HU9KaBOLp/gGBa3j0mZT6vvW3AyhEp/RKuY4G82baCfRa7jA3KyufxTKj4yg3trINDf2Tergm+PwPALRm/dFQR9WByccm3nM7PHm8CStZiipU83k7xhSY62GjnTXG6h4f0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=p4OQj/VO; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e66/9sGburXIXEYZjJSNpH72a+TqBiTDlys5IA8Xsc0xojKvQwVN0gyn9Wl9vljywiGLbuguy3n1nyFl2o2qARQG+C5U6JacXDDT3DvtLNxH2uYbDkAJFFXKbBlq1zqq/JMWkl9iVqIMZrv3HoIaFKVrObruf8L9AaEDMlzcr5/5lm/MHggURVYbQV0RMybg1MJzBcoO09LHNsX8cWOkmlW009bQi0K/2Z+tELSO6OncZpcAw/aUFohAF8LLlerKex+TvFqVQ5vEe6+hj04GewXKA/k/1MFRo6iZbE01/gk3TTPyoAHcwzyuFvQU4km8A7l4CEyxkKsIDLwbE5FYMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=kdHFJS46CYEqIdwHxE3uGvNrreWDDzCAT7sCKAUJsjKC5Pm1w5yHImsnN5PHVlyqN7cS/K5S1J2CW46h4Jg3Pnt+Wdd4La4GCc2M8f5hKB/05fxfTW0HCQmRRFimpe6zKy+SHfMbGJecNtH2kcyPyFCcgSulEVbHS263h7K5t22a6up6F5tcyCtoYVm2zt/Q3iTRFShcr287s/0/kJFbMeerBf//3NWqg5+uJ6JmzL1FS+KvOVy+Qbs7h0Qhdh4BHT9cEy0pwvDjuZtrVNyXbRV3O5hJ+1hg6DxAEuaTckFNCLWzq6/HCfsT0s0N9h+DAhHkiKKNDwU8OywhDXxXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHa7n4UGF0oKchdUGLawEi6S0wIRCEXCHai9Y5sQ2zM=;
 b=p4OQj/VO0elKyirRXkqZd0NhsV128Bppo8iQMLQ6VhGfsq9kgctW3FNdgzr7e34LarW2sTULKIpi/EunODKSbxUDlgaDpnmeBwSJl2YugyrJ1w+4EKdwZ7no8cIZG52pMcIjsehuu6tvxJ9kz6KX0cY8JUoWhwmKjzOgZcfzBuA=
Received: from BL1PR13CA0383.namprd13.prod.outlook.com (2603:10b6:208:2c0::28)
 by BL1PR19MB5985.namprd19.prod.outlook.com (2603:10b6:208:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Wed, 27 Nov
 2024 13:40:44 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:208:2c0:cafe::f9) by BL1PR13CA0383.outlook.office365.com
 (2603:10b6:208:2c0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.13 via Frontend Transport; Wed,
 27 Nov 2024 13:40:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:44 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 3CBCA32;
	Wed, 27 Nov 2024 13:40:43 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:21 +0100
Subject: [PATCH RFC v7 04/16] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-4-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=4808;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=LFN5iHBpQL1ZELcsQiNVADSnkWR8kAU4UAejqcRjIy4=;
 b=SGF2kUgoIvEbK146SqwP32x55fJEBUxhbHC5cxemOMFFfKodLO66VAX8v4yApyAkQ9o4reL3L
 w6uuanYF6K7BQ1HT0tRbutvjE26AHHbio6tzopCSP8plejakvw+M1W0
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|BL1PR19MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f06f6b6-de76-4fd8-3eb5-08dd0ee9179f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K01BcTNrYVd1RTE4Y2Q3OTBtenRZbklKU3kxaTYyZ0t6a3BIWTNTM1o3WGsx?=
 =?utf-8?B?WmtIc2JDNVZXZWFCc0lXVENGamx4L0FxNGx3QW5PRzdqQ21yVGFqNjk0cFVB?=
 =?utf-8?B?RUVocE5mczkyYkpFU2NocUJmM29iUGV5YythazRLYnhrcUJTS0hJeEVzV3hW?=
 =?utf-8?B?N0tHaVRnUTRhNlU1eVpUTFFxWUxtTWRIK1VrTVZXeHY1c2JFa3Fuc1BqWnRa?=
 =?utf-8?B?REh0RHkwZTZUbHB2MUlZcWIweitZN3cwUTNnYTB3b1I5UFFWYjlmMWZXdEl2?=
 =?utf-8?B?a1Z0cVRSeEZ2UlJYWThwUllLaTF3eElvQTVMYTF4b3U5WGVlNTBUUVNVT3lx?=
 =?utf-8?B?Qmg2N2RBSFgrVnhrNDZsWFJVeUFMb1NnUHNTNzFjWHBscWd2UVgza1JpVWpz?=
 =?utf-8?B?M2dFTUtTZWZJR2tuMEVJbmdFdFFGQmNUOWNra2VNcHNlbWo0K0pJZlNtN2p3?=
 =?utf-8?B?aTVCNk9yUVRKeHVwZ09jMXpWUXFuaXp4WjFaNXM5WVVuQVJQc3M0L3dVa29D?=
 =?utf-8?B?TEFOa3BhM3QzTWxUaE1RMGovVkMwb0dJbzc1UFNEaHB6UnNha1BVL2pTZE0r?=
 =?utf-8?B?NmlWRkF0Nmx4MkJFUHd2WUY1SWdKS1VrQmEwVE8xRGRjcUE5ODBtWHRCQjU2?=
 =?utf-8?B?cEpXSHlqZkwxang4KzdKRnQxaWtlMjFQc0dDM1RwT0E4Mmw4QlcxSnNTNk56?=
 =?utf-8?B?bWdDbDUrSjMxVGFVRmd2WVpUd1lXT2hDV2hheE4xNW8xYk1ocm9nNFE5a1lm?=
 =?utf-8?B?TXBNQ2dCWHdwK2ZmZE5NcDkxd1hoVE1tb0E2bW8vb1l3L3pJK2pFeWdUazNP?=
 =?utf-8?B?TE03NXRIcTc0U2lCTVBWT0FzalQrUG82WFpiV3BGMlRPalFxdzZvQ2hvMEhm?=
 =?utf-8?B?UnhMRFZZWFZyV0I1ODJybXR1OUl6MkN0cThSRnBXVyt4VnJkcWpTU2FQZzlZ?=
 =?utf-8?B?NjFrTzY0d3dyc1YraXpxRkh6dUljL3cxT09JS093SUdpZXE5amlzZ2RPUUd1?=
 =?utf-8?B?ZVVpWFFMdEJ5cGNhMFJRcHljRFRHM3dySHplQkVpUi9nL0RUTGdQRTBjRm9Z?=
 =?utf-8?B?T3VNcFVXU2lNYVRaZUNHc3daamx2SStXT3FUSHBkT2RuMmN1RlA4VFFDcFRk?=
 =?utf-8?B?OS8ySU80dkRJVHZMdFNpWWIyOXlHS3d0eTcxa1l1b3NNL3NHNmRYZlE5WXpx?=
 =?utf-8?B?VGkvMkRsRkoxZk1YN0pCNy94RHNTVXJaeEFHa09jVFBGQm1BN3RMb2JBRmIw?=
 =?utf-8?B?Y0orQmhRamhSLzVMQUVOWmNDYmNXekthcjk2K21ham9HWXhBYWxiTzNGRTVo?=
 =?utf-8?B?RzFvcjBrd2FQUmw1SlZRRkJBZFhaWjhrL1VqNklpdy9YbFFETGRWdGhNbEFI?=
 =?utf-8?B?b1RhZWtIR3dYWmZVLzZWRXV6SDBLVTB5UEEwNkVaYllTMG1iQUVvNkZ1RDNy?=
 =?utf-8?B?ZUhUd0EwbUd4OVBkMWFNMnltZFNFUzJ4Z01zeGdYSG4wVXNUakcrb1hnZ0NR?=
 =?utf-8?B?SkxJRVdwbTc1OG8yR1NHcjk0cVJLMGlkNW1pSklHVkhEdFRMckhTRnlpdHFa?=
 =?utf-8?B?b3VsY3NqQmIxU1A3b3hSeEszZm9WY1pKTE1QSVhQTDh6eUlScjJGdUd4b3ND?=
 =?utf-8?B?WFZtWlZweDFqOStGQ0o2YUFrcWhVZlJkR3RadGtCa1F1dER1eE1Bb0d3UkxC?=
 =?utf-8?B?NUd4TnF6NWRmTGxzalJVZmJLckRPSkZzNyt1ZnozV0JEdXFqR25NcStBQ2xi?=
 =?utf-8?B?QjBoVTViaTNtUTFVbnpSMnVkMC8xY21TUkxRYUs1U2xiejhCcW1zczVlZUJE?=
 =?utf-8?B?akV0dHVQYnlaZmg2UjBZME5xUWlKOHhWRmZUTFRJNzFDSS9zVmNlSFpxR1dw?=
 =?utf-8?B?a3p6d3BXVko4OUdMN3lkVGJET3VXQWZqL1Y1dGttYVRBWUVpdkZOdk5RSGhP?=
 =?utf-8?Q?JoWHFhewRDR+DHN/IThwJDyoOQWYHGcL?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UxXdyxULGG1EZboSdgb6xmY1/srtt9b/QhdY3Az3yvouEiPLhP9jpNcMdQMYn6K999Ltr9Opht51A9XTkZOsJk7NVdPL0Y5OXjvpHm7IA5jPaKcXW6+fTOVdNsEIqjP6O6xlEJlaNe2dGo0WLOoMGs3xXwlso1DITma87OpRBQI++01NqolEaeDg1s3sev9OsYw4n6SKCX9ZeeHN33dWbojlX5SS0PBAgltW5yWSiSYAtGJo+Tm5P1CahUsmFgZFNxZ1TuEWbhHOVdTPSGLcTlyxkAschyU+NzThDf5CDM+pqtDXLc27fz0+TSCvrheJwwg6ejHdVjOYG0NGP+hfeUJciqMB9b9aGtTE9IJBL/iEVf6n2bpPztI4S/SFc7h4h8mCBgWUaqUq4rEheD23IUT3Ud7c4jadycZM8fgmTKW8vNeCK5i8eu9a/Slhg+SDNo+r75rryrAvVllLVfR9ZJeTGnRty9NLUY3p5vpHIyhPkZfVNNrw+iL5mVG6IbUJmXzN6xssgbZb909SMaAQdp4YotjohCjRqiLGtbiu4Ev6o4GB0obluBLX22Te5yqV79fxZdm6QD7/Lvf8xX0TYj/KN9HHsu1f6nTqjr+kQTxEAEbAaCsBAY7+7uHKnaDBGcLt6629AXdNspo5t3p32w==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:44.1240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f06f6b6-de76-4fd8-3eb5-08dd0ee9179f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR19MB5985
X-BESS-ID: 1732714853-104050-2077-13668-1
X-BESS-VER: 2019.3_20241126.2120
X-BESS-Apparent-Source-IP: 104.47.59.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViZmliZAVgZQ0MLE0ijFNMU8Nd
	HA0sjQ2MjcPM042STZzMTIIi3FKNlcqTYWAKwEH+ZBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan13-243.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 101 ++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 0000000000000000000000000000000000000000..50fdba1ea566588be3663e29b04bb9bbb6c9e4fb
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,101 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+FUSE Uring design documentation
+==============================
+
+This documentation covers basic details how the fuse
+kernel/userspace communication through uring is configured
+and works. For generic details about FUSE see fuse.rst.
+
+This document also covers the current interface, which is
+still in development and might change.
+
+Limitations
+===========
+As of now not all requests types are supported through uring, userspace
+is required to also handle requests through /dev/fuse after
+uring setup is complete.  Specifically notifications (initiated from
+the daemon side) and interrupts.
+
+Fuse io-uring configuration
+========================
+
+Fuse kernel requests are queued through the classical /dev/fuse
+read/write interface - until uring setup is complete.
+
+In order to set up fuse-over-io-uring fuse-server (user-space)
+needs to submit SQEs (opcode = IORING_OP_URING_CMD) to the
+/dev/fuse connection file descriptor. Initial submit is with
+the sub command FUSE_URING_REQ_FETCH, which will just register
+entries to be available in the kernel.
+
+Once at least one entry per queue is submitted, kernel starts
+to enqueue to ring queues.
+Note, every CPU core has its own fuse-io-uring queue.
+Userspace handles the CQE/fuse-request and submits the result as
+subcommand FUSE_URING_REQ_COMMIT_AND_FETCH - kernel completes
+the requests and also marks the entry available again. If there are
+pending requests waiting the request will be immediately submitted
+to the daemon again.
+
+Initial SQE
+-----------
+
+ |                                    |  FUSE filesystem daemon
+ |                                    |
+ |                                    |  >io_uring_submit()
+ |                                    |   IORING_OP_URING_CMD /
+ |                                    |   FUSE_URING_REQ_FETCH
+ |                                    |  [wait cqe]
+ |                                    |   >io_uring_wait_cqe() or
+ |                                    |   >io_uring_submit_and_wait()
+ |                                    |
+ |  >fuse_uring_cmd()                 |
+ |   >fuse_uring_fetch()              |
+ |    >fuse_uring_ent_release()       |
+
+
+Sending requests with CQEs
+--------------------------
+
+ |                                         |  FUSE filesystem daemon
+ |                                         |  [waiting for CQEs]
+ |  "rm /mnt/fuse/file"                    |
+ |                                         |
+ |  >sys_unlink()                          |
+ |    >fuse_unlink()                       |
+ |      [allocate request]                 |
+ |      >__fuse_request_send()             |
+ |        ...                              |
+ |       >fuse_uring_queue_fuse_req        |
+ |        [queue request on fg or          |
+ |          bg queue]                      |
+ |         >fuse_uring_assign_ring_entry() |
+ |         >fuse_uring_send_to_ring()      |
+ |          >fuse_uring_copy_to_ring()     |
+ |          >io_uring_cmd_done()           |
+ |          >request_wait_answer()         |
+ |           [sleep on req->waitq]         |
+ |                                         |  [receives and handles CQE]
+ |                                         |  [submit result and fetch next]
+ |                                         |  >io_uring_submit()
+ |                                         |   IORING_OP_URING_CMD/
+ |                                         |   FUSE_URING_REQ_COMMIT_AND_FETCH
+ |  >fuse_uring_cmd()                      |
+ |   >fuse_uring_commit_and_release()      |
+ |    >fuse_uring_copy_from_ring()         |
+ |     [ copy the result to the fuse req]  |
+ |     >fuse_uring_req_end_and_get_next()  |
+ |      >fuse_request_end()                |
+ |       [wake up req->waitq]              |
+ |      >fuse_uring_ent_release_and_fetch()|
+ |       [wait or handle next req]         |
+ |                                         |
+ |                                         |
+ |       [req->waitq woken up]             |
+ |    <fuse_unlink()                       |
+ |  <sys_unlink()                          |
+
+
+

-- 
2.43.0


