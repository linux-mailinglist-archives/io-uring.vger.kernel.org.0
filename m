Return-Path: <io-uring+bounces-5705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1341A034BB
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B4791882D21
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A76481A3;
	Tue,  7 Jan 2025 01:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Q/SKvNQg"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0135680
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215113; cv=fail; b=ZAVkxnwOG8/qlwyys0CnbzGE5mcEair7tBp7AEY6s11tYUxAAR1VcWMNN2g9dCpfeZYFsieiddnR9/KzDj9HExwjh2iztwplpsVCgmm+M4lP6xftsDqxBYZt9zgE2Zw4DAGTeOjV3alRGu57jdaWx8jajin50ueAZ+MIkoKeCyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215113; c=relaxed/simple;
	bh=raf6CgBujJ2M7YlVi6vdDhGBoMyGB4azvfrJzcZzmzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TdzljNbc5O7TVq2GBDY8DRMlJLMeyqXk9d3oVy0VvS0KywyXP5QaVbJBEXuLePVJ6ndbijqmbbfHf2xssUX3i0Ibs0CRw9r4GwT/bzzPViEXlF4Od/JSuRx7szmH6qHUP+GLTI1vos/IF948BRcU111B8E49OpG9BGdT9Z1XJeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Q/SKvNQg; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175]) by mx-outbound16-53.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:58:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8K5yUlJiBM6WifH/X1MWP46r5E8RjMLfw0ckbxD0SDdAjuk5hfIfbaSqR8cS79ke7ydnV6MNhx/GamDNk+LbxQ6WaM5vCJPQTAI5Usv4QMQDbv9GT+BlTTjPp3qrsmQ2ywXj2TEZaKHnBRIZWnCAaWLfubTf3Happy0LhC6KX3NcaN7FeVIme7EHhwIVE46pU+Sl9W32UAeRwBHegJNzDbjKOmv/ssfF3GLQ6eJv+4LWENYXg8uu+NfPHRQU+4yUu7l+yAMMpF4XGGIG5JqeMWAvrVVHxVSW0GK6wgCk2OeTPZycD5t2SsZU0dPNNEVevErr605tJyMqoo+NLIDWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KmHuPvxHgleuHsdm/S1FN6pWuiP40/gOcp3ZK7K0Xg=;
 b=egGYHMrZeASe1mKaR2ML5HunQtx7350KIaPKuFIQ72HG5qxLngJfIzZEjW19tVZuDpdfukSpSUm5n9wK5aWtflfllISQnvFblJTtO6BhVytdAiujZ1Gnq/Ck9GHgBmceCq6QcLCa8UFZ8Nv4dhripbXqz6AOgE/vZkZU3Ij+S+x/VAznTZbNTUXIDEsWDTxrhTKSEqhkydavPd01XjdgiI5aFiOtMWL/eVkxF2mkpicR6LSOHuntThS3tyIZIQgeRcjfb9xxWcI/vimsEwjEP4B53Nw99Bz6JzPNdA/NsWtr7UX7GfULqtFJf3/gg2+K2bhmCii9dqvA+VW/KpqKaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KmHuPvxHgleuHsdm/S1FN6pWuiP40/gOcp3ZK7K0Xg=;
 b=Q/SKvNQg9VZAXoEQ3VbxdLstZTFnPb1umv5qq3TxUSi/O+pRtAygJRK7FFbRIwXGQBBqhnDhQ96jNvATgwly/WQZT8CKXJx5BIQnIkyATNvWFLWGJRKMtzrYXJGKWUr+0wyqsxwroV4fyxGVor/kHh95F4tLimljljehLTQSBZE=
Received: from BN9PR03CA0115.namprd03.prod.outlook.com (2603:10b6:408:fd::30)
 by PH8PR19MB7757.namprd19.prod.outlook.com (2603:10b6:510:259::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Tue, 7 Jan
 2025 00:25:23 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::f6) by BN9PR03CA0115.outlook.office365.com
 (2603:10b6:408:fd::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.13 via Frontend Transport; Tue,
 7 Jan 2025 00:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:22 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 0D2EA4D;
	Tue,  7 Jan 2025 00:25:21 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:16 +0100
Subject: [PATCH v9 11/17] fuse: {io-uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-11-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=11467;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=raf6CgBujJ2M7YlVi6vdDhGBoMyGB4azvfrJzcZzmzw=;
 b=tlddwqOZTPcdut+yzvm5nuEqTDxrDhkIp6aDwe964FaIF6/aJervu4yCtaUnZLOv5Zb8rHjLt
 ryP5bICdzZfCHl88qPR81MUaHEt+wLxjC5wF8kYXmE5kAcRzEaRyIXm
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|PH8PR19MB7757:EE_
X-MS-Office365-Filtering-Correlation-Id: 938602d6-e46a-4cb4-53e0-08dd2eb1c67e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUR1OU8rdXRjMG5MaUl1ZGpheTRWVGVIR2tGMUZuQzRYYXp6NHlzaXNOUG50?=
 =?utf-8?B?a1ByTUNLTG5Xc1ZwMlFHWklLaXF3and2VVV0bTN4Ulg2OVFIdUMzZHRGanNY?=
 =?utf-8?B?djdyWktlR2VTMjZ1VWRaaElaek1TVUdiaEwxZEMwZnFDVGFrSkRXL3BseHN6?=
 =?utf-8?B?azFEU2FVblRFcWNxNGV1a0RJdzBSbDA1Z1g5ZlhBV3QrdEcxNWhkWVhKQUxP?=
 =?utf-8?B?S0VGRXRPQmZIZlV3Vm9EVDhBTUhhMjM5Q2Jwemw5azJFY0s3WWg3b0dQbkYz?=
 =?utf-8?B?dkR1M0hCS2hrSUFMOEd6aWZwOE5OUWw4ODRhQmE5MW5aczBFRTZ4U3RDNElS?=
 =?utf-8?B?bTRTdU9XaEJwZXk5d0wvZjNMa1JUTVM5bFJPbTdQcVdJRExpSTB4YXRWc0JP?=
 =?utf-8?B?bmZtMk82TkZpWWdncG4wRldrbE9yRjRvNGEvK1FRZkFHZjFXVFI2UC9yaXls?=
 =?utf-8?B?VStZTUpCM0lVK0thWWhBYzY5MDhJVnBCRVdlaExhNld5ZG0wdTdVWUl4WGda?=
 =?utf-8?B?cWR4RVg5ZVA4MTY2WVJqYmhqOUpOZEZmeld0eVpmU0ZUU0s2TVl0NlpIdFg0?=
 =?utf-8?B?MWpMSW91MTdKdzU5ZnBoZmx0bTdNMXVPekpHVFFNYVEyRnNTUjdKcWgrR0Ir?=
 =?utf-8?B?K2g5NjRsM1JaMWRXWnI0R2hMbW5NVGdrQm5VMEtDYkxTK3dUN3Q1eHN3ZDRj?=
 =?utf-8?B?bGFUVnZsTE04SHh5b093dTc2VzIxV0ZLclR5MzhaOE1JUmhFdWs5TnNHZDBQ?=
 =?utf-8?B?QjEwSzFhcmN4ZnFEMlJjckczT1JBeWFzQ0gyeWM1d0t5ZGtNZVdhUEw4WnN5?=
 =?utf-8?B?dWUvRHh4ZWVPdVBXenNWQVN2d1UzQm9SUnlSMVpUZGhBV1JTdlBsUXRoT2Z6?=
 =?utf-8?B?MTBmYTdycEhiZ1ZubGEyZUlVOHFDaDFzb1JrOEtRcm44eWFpVHcyOVF3Y2pR?=
 =?utf-8?B?c2VRWHhpR2VGeG5CeHFsV083cU1sOTdhaUtzekY0QVhUSThQQlVrd3NyZFVF?=
 =?utf-8?B?cGxNMlRFWkM1RkxObzdObjJFelpNYU90WWh4NjZBelIyNm9kM3pLdE1QYkI1?=
 =?utf-8?B?QnMxOSt4cjY2QStMMlZJUzFkQ1hCNTh3bW42YkpWUk9lWk9IbVh4QjhJQ1hG?=
 =?utf-8?B?bWFqTjJmekZJRHZzd00xbXU0enRMSWsrMmhZc29iYUtZTHRVOS8xZ01aeEsr?=
 =?utf-8?B?Ryszdnhhd3ZZeWlKK3Q0MVpGeDFDYWVnYVBYWHFFYW5pcDdSajd3ejJhdC9P?=
 =?utf-8?B?SnYwSjloUy9Sd3c5amhVR1UwbGtLMUJZakZVNWJzNXBJb3hrTmZtWUc3aUla?=
 =?utf-8?B?S3loSWlRajAyQUVCQTN5SnJkeVNEeUdXMU5DajZHQkp6VFhFRExTemV6dUUv?=
 =?utf-8?B?YVlJeXhQdHEzN3VzTHZYTWRUSUpGNE5ZclNVSGJLbFM1WGVra3NGQWpvdVNK?=
 =?utf-8?B?S1ZKS2xvUmU1NXdXblpHQk5GYUt2Q3VxUlYvWlVaQVkrYnRaUno0MFBCVkRt?=
 =?utf-8?B?Z09VamJyMk9uMEpSUEY1L0FKZ0tOeWVDZ1R1VGtsY1NXbmt6YXJoSktIUkkw?=
 =?utf-8?B?a1VkVHFsTDdVcXJjdVFPcktrNzV4cVFHWTYwTjhYaHNkcTB6MnNjL04vaHA1?=
 =?utf-8?B?SVJSU2RKZnpmdkZNRFlEZk50V24zN09DNDlnZVFDSzFUb2Y3U1kvd2ZPWkpl?=
 =?utf-8?B?WWZwY255SHllVEJNak9tTkEvaHBJbjVjVjNTT2h6YjhMQWJ2b2tEbkkxT1lw?=
 =?utf-8?B?NmxtNUpRaWcyTEFGSUFQa3hMWmdKTUZkR1hhSklROWJBajlTck96V0lzNWJR?=
 =?utf-8?B?bkNIUCt3czZLc2lXOEd1Ykx6RWpPViszS0NFM0VyTGxhYSs5Q3hLVW12VE1Z?=
 =?utf-8?B?MnRmcUxOcWFxb3kzeTd3VzRJemtQSkduVW5PWXU2WDBpdDQ4RHp6MnAwM2xp?=
 =?utf-8?B?ajVjckZuYlVKQkJtalNseVp6NXJkVGZyY1BMK2liQlNkck9PVS9LL1NUbjJF?=
 =?utf-8?Q?uoBIVQSK3AFLrxfkPE9lW984zDv2pY=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DeDI0/QubzwJrEaG4XfTjytIHbHgn4JEtcLVFzMJyJFaXmZUXhAphSnApXhzJfp5TRQiMGcbJcMcf+AlNPEKY2Ju+Va5kbbnbniiGDBux3XXiVMTuwciqZKdnksFMTC++8X2TX2pgGRWbhsf+kF/CtnMOmb9IMOUPW4br1IHYd+mwMOikyhoNealhvcJE/ZwasBNjFBy5U5ci8sKSKnS+K8HXXnAbj4ktXkQ42dydKOORbY/Z+TGdJd6zJmqaBAJVTP9b4PJk5xPhKQjNXO719cGpgPcgAp6mokLV381fVtpgPmF2MYu+mhvI8fdHWseH0ZseL4p7L2iFzWB3pVrCx3wIUt8t+Paewvx6dLJxF3DKVOS248oMpnSeOJjC0VjhEvsZqkuXUF5RfuFbnXFfwRqEpNsAxHVulj5AQy6yA3i0sgAnmrBW1XP8AkcAsVckgXiVkjN33GlVRDBpTxH0jpl1i4zROXQ3NMjPlf5wLXmusFIkSbEK4U2i5CuOFJTV60rLMgJ3ZTG9knNbSclZc5SxC6yLE8qF2NVP6pVnwUvhRCARkPdUbpnyQ8sCS3FEeuvoXrjb9z0mDmdAWcsTp0vMaXErivFahDp7LwGByNh/sMwJX+so5jLfMzk6KAOCHYnQoWSZn1TFNDF5D5JQQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:22.9329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 938602d6-e46a-4cb4-53e0-08dd2eb1c67e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB7757
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215108-104149-13340-9483-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.59.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGBmaGQGYGUNTIIMnIzCDZIM
	kkOTHJzCI1OSXRwCjJIsXSNNkw2cAoUak2FgA2CXOCQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan8-192.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
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
index f44e66a7ea577390da87e9ac7d118a9416898c28..01a908b2ef9ada14b759ca047eab40b4c4431d89 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -39,6 +39,37 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 	ring_ent->fuse_req = NULL;
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
@@ -98,10 +129,13 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
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
@@ -158,6 +192,166 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
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
+	 * Some ring entries are might be in the middle of IO operations,
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
@@ -538,6 +732,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = &queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -667,6 +864,7 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 		return ERR_PTR(err);
 	}
 
+	atomic_inc(&ring->queue_refs);
 	return ent;
 }
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 80f1c62d4df7f0ca77c4d5179068df6ffdbf7d85..ee5aeccae66caaf9a4dccbbbc785820836182668 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -83,6 +86,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -100,12 +105,51 @@ struct fuse_ring {
 	size_t max_payload_sz;
 
 	struct fuse_ring_queue **queues;
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
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
@@ -123,6 +167,13 @@ static inline bool fuse_uring_enabled(void)
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


