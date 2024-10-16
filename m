Return-Path: <io-uring+bounces-3704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4921C99FD3B
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 641641C20C22
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B091097B;
	Wed, 16 Oct 2024 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="R5+zLeYD"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F26E574
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039098; cv=fail; b=mB/0cJrjBAlMzrVqqHKEVzyO2UNSrRZ0JoGZMlOBNuvpBs5ditjKTtFiU7T06dEKw9VXQVl3k2hpx/fRYgWupupjhUwG/403LKE7s2RYu/VlkIl6QCR7/zuO/oxgHkOsENy29eGJiAMS99Ik1IdXIeQ5SLZ/bxW+h4glPoPcXNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039098; c=relaxed/simple;
	bh=mU3szheieHXl415rxDpIhayWwwyqD3ouR8ejSyLQvMI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gdmMkDWPqkg++0lwf4Iu0RBJglPxWBqkoJjvDKgUq4s41uhtrrOhpNKsGFqK3vP9+W2OkcxL46ATikb7GYN/x+XgJ2Cu3k40XRAHtm2qR6QPNMxIc/aAdG6oGG/t3MXQDrNtD6j1arOdEREZRWFN0yZX1mVuPh7DX6FDxVkb00A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=R5+zLeYD; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejmaD/SkS3FXtFqFDrIMM+IvxgICivEe9YWErSfC9P6HS0Ykxcv8dXHn7W3mcb/VFdOSrYaImpr1oCXprMcHETz1Y8brQviMhDB+QWVQX9O/Hq7UpVKV5Mi9KQ3ZZzqbTLeLrCyD/amcE1PlDkz0Bqm4hr6KJuuNL3rn91d2sdwAamJjhBQeLSvKdZFtiptBndXv0rFOsK3jx63DkVsFPPHRP3AlDUaITizH3OMjL1Vv356sbaATd+fXxC0WS4cTwjxaPKE7b0tlq863mPerNiXwU+QGM5IYOF7gvdpWJY3eljFpu1uh2nqHHlpMHJeDqU8aGcCyY9KkU2f//I4DKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XacU0YAbrG7JdIaoTYB/qvjRkj59jvvDqv9jKDlmg7Q=;
 b=UkbrpP9qyXlqVUcOO2h1LL5E+GuZfq91KzUy+jddX5Otu4q6Mkh0mWE8vZg2b5R3DNdHRhdqrIcMA/ApCRHeDZH4q030w5yX2KnjTRxJqQjl9/E/T7W8KKtyPN4RvIMvP+x7mEM/aPWXVbCpqaYTibBp8jO6cqZwp0YhAi3VgaUYzpQEcWFG73sLEq6wUbdUbDe/pEjAkC97dCVPwtmGJrJf+njqYrNe7SFEAdV1nD1AUhupjs1bbIT1em/CNs+PtbyimhlLT64/Tu1B3KqitOefFv0rjZXDMw9zxU1SwYGDSgNVNTKsKht/BVz5uolaVsM8H3a8HbyG3eZFc8AhFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XacU0YAbrG7JdIaoTYB/qvjRkj59jvvDqv9jKDlmg7Q=;
 b=R5+zLeYDphouY0aECvmjkYwGRr9euUL/C+apk/BuV33YXMR/ONGTcToiNPAFCCkwyJpHTYBhtneekqsBZ7GFjFO6z/jmU2hrGd42Ar5fJnGEbpzMthI5CZaZgpxw4nL/Y4OXnAuQFI1Ukyb7ThjJHGAlf4YoEGttMLsrVTtCliM=
Received: from BN7PR06CA0067.namprd06.prod.outlook.com (2603:10b6:408:34::44)
 by PH7PR19MB5751.namprd19.prod.outlook.com (2603:10b6:510:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 00:05:24 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:34:cafe::82) by BN7PR06CA0067.outlook.office365.com
 (2603:10b6:408:34::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:24 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id DDBAD29;
	Wed, 16 Oct 2024 00:05:22 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Date: Wed, 16 Oct 2024 02:05:12 +0200
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADkDD2cC/02NwQ6CMBBEf4Xs2TUtLCCeTEz8AK+GA9IW9kBLW
 kAN4d+tnDy+mcybFYL2rAOckxW8XjiwsxHokEDbN7bTyCoypCIlKWSOZg4aZ8+2Q+M8FigFetM
 SFlIJ0xanXJoTxPnoteH3rn7A/XaFOoY9h8n5z3630F79zKISEp/0L4/OJcMXT72bJxyGZsTIA
 qtUlKbMKklEF6XssXUD1Nu2fQED9PQsywAAAA==
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=11640;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=mU3szheieHXl415rxDpIhayWwwyqD3ouR8ejSyLQvMI=;
 b=OUlhFKED/nhfg1AGvhX/RdQHUsa34Nc5+2EwIx/0m/aTG5G3wBD8plv/Tw9SJ9q4a9pjhbZED
 zZXgGj71YnyD1PZE5XZFcu2ScMM/zI9otN6Hy1ENShb/L4yF5370ZW4
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|PH7PR19MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: deeb3251-0f2a-43ad-c396-08dced763ba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDhKOStERjZyYWpQUEhFQ1hKUGhWVlF2RnkrY2dQUXpmT1owQlBmWGlYbmRM?=
 =?utf-8?B?dEVXRWlJMVJQTXhPWStrbEpwdHh6Nm0rcGg4cW5YZGdGZWlnZVlheTQ3NXN2?=
 =?utf-8?B?T09FOWJENng5ODd6UDE5ckRpK3N3YUxlQTNadGJoVUpiVmY3eWxvakZZcTZm?=
 =?utf-8?B?YzVrRnhCMWNnTFgvQy83bVVDM0h6Z2VpNVFyRUcvWTBXUkNCTDFLeVpKbmNo?=
 =?utf-8?B?ZDBtZlNDYlRURUVpSjhkZFRSZGUyL2g2YjcvZ1BpT2l3d01OdkY3VWFBR0ZW?=
 =?utf-8?B?VThZMW5HWE5PK3FZY2s0MUVYK3BTMkh2cWw5SUQ1MnJYdUJFeUVGdllkWURm?=
 =?utf-8?B?MSs2U3RTVk02NEd1c09XU3dYMFpmSjhJVXNTcCt4d3FKelhvRDAzYmJNZEJJ?=
 =?utf-8?B?RVB3OERXbCthb3VwSEVKOS96MlRCS0Q2dUpvUi8rbnhlYUFGbXN5Zi9ETTlL?=
 =?utf-8?B?MVIvVG9GZHg0cTZCeVZoTnVIa0pKVUs3aEI5S3c4eXNGV05SVmFvano2WnhO?=
 =?utf-8?B?MHRHbHJNVUR1Q1I2VTJoOGVZS1NtdnpMdG51WlFhTFd6ei9LUkt5U2NNZng4?=
 =?utf-8?B?QkVFWkF6Vzl3Z1h5Z3daajVIVUVpVFRtVWJUTDJjbHExTGNiQW96b3RnL0xV?=
 =?utf-8?B?S0R4cVFkdTJtZHNIcGcxS1RmekVSbXRnZ3lLSWVBRjlzL3A0ZlpzSTh2ZEQ2?=
 =?utf-8?B?SUszYW9qU04rSXFTeCtoNCtKVFpvc0p1c0EzNVlHbmwzbE1JZDZRYnV5b0tH?=
 =?utf-8?B?ZjA5bDlsNzByYkRDV3NTMS9ydkJKbE4wNmtEdVhyUDhBdmExS3hzcDFBUjJx?=
 =?utf-8?B?U3ZERTFKMFpxbFhzTkJ1NUx3aWRkYUdZL1dBcHZFOWtlZ1pZc0Q4MllEbWJM?=
 =?utf-8?B?N0FHN1JUZk1PM3R6VmI1M2RiY2l3R0l4KzN3QmgzdW1rTVJGVFl2Qm5tcG42?=
 =?utf-8?B?RG4xQkNBRTBVbXN5eVdWT21uLys1KzRhNlNIMUNTMWEzN3llbnBwLzMwdmYz?=
 =?utf-8?B?NEFLQU1haUZSQ0lhRm5sb3JvT3JVajduTEEzZndERU4wbkRhblNFZDMrOWpN?=
 =?utf-8?B?VmtCcXJUNmpnald3Y2M0YmZuSGMvY0Jvc3V6MnJPa1hha2dzUVhGaCtvVTYw?=
 =?utf-8?B?RUFqb1B2SVhtOGdYRFFyZnhLYjFoVUpKak1BSzRWN2UwTnZqL1hWckp6Mzly?=
 =?utf-8?B?QzlSVVNVRmhBcmxwYUZPOXlKWjBKZWt3ZTZkVDZVbEFGejFWeVBCRTBuTVd5?=
 =?utf-8?B?MHFlb1hHZlZDRjFuVEM4SXpyeG1CaEc4dGZUU3FQOXIvUzlJWDFLS0ZCcW92?=
 =?utf-8?B?WFRaZWR1S21BMDJtU1d2YlhPWnBLQjY4d1N2RERQd1oycDAvNzhRUms5MWtl?=
 =?utf-8?B?akxlTVZ3TkN2MHpkQ3ZyRFg0N2oyU21LV0E4MDViNC8vNVlIYWtmajlWWXQ5?=
 =?utf-8?B?bXFRcGgyUDR2Sk9hMnB6RlNwR29nYmZTbUNrUzFicWRYTWxaY1RsMXJyZk1L?=
 =?utf-8?B?bDhNWDRsRWNzNENFb1FpK1o3SXhkbDdGOXQ5M1IrWUJtSnRFLy96aHFiRzZ0?=
 =?utf-8?B?MUJEbjlRRVZOWWpRclF5MiszcEtLVnlLek9QSkdUR3Bhbk9Nb0NzcVF2TzNz?=
 =?utf-8?B?QllVNTVCUDdmOUxjMGZ5T2VVWEVXaFB3TFYrTWxXRUUyeit2SEk3eUNrWFg1?=
 =?utf-8?B?YXFxQnVRdkFTM1FRSXB2bGJDZnV6SktJMnRjODA0VjZ6Y0k2RnpTK0NvUTlK?=
 =?utf-8?B?dmtGdVpjcmtPM1ZLSGp5cDlQSFlKYkx0bEZybjlqdEVDaVd0L29YTkRwaUZG?=
 =?utf-8?B?MEIraXVRQVhIbWQvNzVKZz09?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fHwmETEu0flqtOxQ9gU2AeUdztkuRHu2uPGC8J1dA+CHxBN5IJYMMx+g2NNRqO3pAm3y1Xhm9NgQxOAnzbzqumnVSqiNZhwOeY5xObA2gwzAKTXIahHvfkAJ+KWxqN+SgUiMhwQasGVz8GoPQE0eYwQirNI2qfheKMlwDgW1ek9fx4heniK/8rAjKJdmUMgE3nwOXeMe6glJ6QQtXh8VcwYgrMWxDGhOa9rwgj3fqIeFVAhP/iGIgHKDNxiEoNCiYymoPqyyzxJK9Pl5iVdgUAC3gRmf/7XPQVJD4lje3AB8Yuo6ANgx/Cif/yW/yy4wiNN9+47fkKI7fSFM6Ao/opzD+qKx15VmqRIoiSZ/E9vO216ELvQExkKUYUmUB4R4KaDibaYeUk4VtIXEPuhoSTDHpOsM2gPHTrbsTTe6rY6KgwGdf9T6gFet0mXA6w4xVLxTvBHnYA2B/d6iUIS4HSgKPOos4XtZrDNjhMIIvVEhDg9ZHaM95YDN2smdYK/s0M7zT4QvRAMbxvF7UXoTOPR7Qy9Pyyk5p1nkCmGusv0ONrhGEP3SOBRdoFeCg+Tqwvowh24t3iU+xxpqVF6pWTa60DxJq2AkWLu0apwqvgs4RKHNF2cZHmUOVgF3/drkr8O/Nrmu3bnC+CSp/0Ubww==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:24.0676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: deeb3251-0f2a-43ad-c396-08dced763ba0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB5751
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039089-105647-24799-9730-1
X-BESS-VER: 2019.3_20241015.1555
X-BESS-Apparent-Source-IP: 104.47.66.46
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGxmbGQGYGUNTUINnQMiXRwM
	zE0jw12Tw52dIgJdXY3DzZzMDQxMTcVKk2FgCH6ybMQgAAAA==
X-BESS-Outbound-Spam-Score: 0.90
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan20-202.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.90 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_SA085b, BSF_RULE7568M, BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for uring communication between kernel and
userspace daemon using opcode the IORING_OP_URING_CMD. The basic
appraoch was taken from ublk.  The patches are in RFC state,
some major changes are still to be expected.

Motivation for these patches is all to increase fuse performance.
In fuse-over-io-uring requests avoid core switching (application
on core X, processing of fuse server on random core Y) and use
shared memory between kernel and userspace to transfer data.
Similar approaches have been taken by ZUFS and FUSE2, though
not over io-uring, but through ioctl IOs

https://lwn.net/Articles/756625/
https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=fuse2

Avoiding cache line bouncing / numa systems was discussed
between Amir and Miklos before and Miklos had posted
part of the private discussion here
https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBPRfToLEiA_0=w3=hA@mail.gmail.com/

This cache line bouncing should be reduced by these patches, as
a) Switching between kernel and userspace is reduced by 50%,
as the request fetch (by read) and result commit (write) is replaced
by a single and submit and fetch command
b) Submitting via ring can avoid context switches at all.
Note: As of now userspace still needs to transition to the kernel to
wake up the submit the result, though it might be possible to
avoid that as well (for example either with IORING_SETUP_SQPOLL
(basic testing did not show performance advantage for now) or
the task that is submitting fuse requests to the ring could also
poll for results (needs additional work).

I had also noticed waitq wake-up latencies in fuse before
https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmail.fm/T/

This spinning approach helped with performance (>40% improvement
for file creates), but due to random server side thread/core utilization
spinning cannot be well controlled in /dev/fuse mode.
With fuse-over-io-uring requests are handled on the same core
(sync requests) or on core+1 (large async requests) and performance
improvements are achieved without spinning.

Splice/zero-copy is not supported yet, Ming Lei is working
on io-uring support for ublk_drv, we can probably also use
that approach for fuse and get better zero copy than splice.
https://lore.kernel.org/io-uring/20240808162438.345884-1-ming.lei@redhat.com/

RFCv1 and RFCv2 have been tested with multiple xfstest runs in a VM
(32 cores) with a kernel that has several debug options
enabled (like KASAN and MSAN). RFCv3 is not that well tested yet.
O_DIRECT is currently not working well with /dev/fuse and
also these patches, a patch has been submitted to fix that (although
the approach is refused)
https://www.spinics.net/lists/linux-fsdevel/msg280028.html

Up the to RFCv2 nice effect in io-uring mode was that xftests run faster
(like generic/522 ~2400s /dev/fuse vs. ~1600s patched), though still
slow as this is with ASAN/leak-detection/etc.
With RFCv3 and removed mmap overall run time as approximately the same,
though some optimizations are removed in RFCv3, like submitting to
the ring from the task that created the fuse request (hence, without
io_uring_cmd_complete_in_task()).

The corresponding libfuse patches are on my uring branch,
but need cleanup for submission - will happen during the next
days.
https://github.com/bsbernd/libfuse/tree/uring

Testing with that libfuse branch is possible by running something
like:

example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
--uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 \
/scratch/source /scratch/dest

With the --debug-fuse option one should see CQE in the request type,
if requests are received via io-uring:

cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 7060
    unique: 4, result=104

Without the --uring option "cqe" is replaced by the default "dev"

dev unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 56, pid: 7117
   unique: 4, success, outsize: 120

TODO list for next RFC version
- make the buffer layout exactly the same as /dev/fuse IO
- different request size - a large ring queue size currently needs
too much memory, even if most of the queue size is needed for small
IOs

Future work
- zero copy

I had run quite some benchmarks with linux-6.2 before LSFMMBPF2023,
which, resulted in some tuning patches (at the end of the
patch series).

Benchmark results (with RFC v1)
=======================================

System used for the benchmark is a 32 core (HyperThreading enabled)
Xeon E5-2650 system. I don't have local disks attached that could do
>5GB/s IOs, for paged and dio results a patched version of passthrough-hp
was used that bypasses final reads/writes.

paged reads
-----------
            128K IO size                      1024K IO size
jobs   /dev/fuse     uring    gain     /dev/fuse    uring   gain
 1        1117        1921    1.72        1902       1942   1.02
 2        2502        3527    1.41        3066       3260   1.06
 4        5052        6125    1.21        5994       6097   1.02
 8        6273       10855    1.73        7101      10491   1.48
16        6373       11320    1.78        7660      11419   1.49
24        6111        9015    1.48        7600       9029   1.19
32        5725        7968    1.39        6986       7961   1.14

dio reads (1024K)
-----------------

jobs   /dev/fuse  uring   gain
1	    2023   3998	  2.42
2	    3375   7950   2.83
4	    3823   15022  3.58
8	    7796   22591  2.77
16	    8520   27864  3.27
24	    8361   20617  2.55
32	    8717   12971  1.55

mmap reads (4K)
---------------
(sequential, I probably should have made it random, sequential exposes
a rather interesting/weird 'optimized' memcpy issue - sequential becomes
reversed order 4K read)
https://lore.kernel.org/linux-fsdevel/aae918da-833f-7ec5-ac8a-115d66d80d0e@fastmail.fm/

jobs  /dev/fuse     uring    gain
1       130          323     2.49
2       219          538     2.46
4       503         1040     2.07
8       1472        2039     1.38
16      2191        3518     1.61
24      2453        4561     1.86
32      2178        5628     2.58

(Results on request, setting MAP_HUGETLB much improves performance
for both, io-uring mode then has a slight advantage only.)

creates/s
----------
threads /dev/fuse     uring   gain
1          3944       10121   2.57
2          8580       24524   2.86
4         16628       44426   2.67
8         46746       56716   1.21
16        79740      102966   1.29
20        80284      119502   1.49

(the gain drop with >=8 cores needs to be investigated)

Jens had done some benchmarks with v3 and noticed only 
25% improvement and half of CPU time usage, but v3
removes several optimizations (like waking the same core
and avoiding task io_uring_cmd_done in extra task context).
These optimizations will be submitted once the core work
is merged.

Remaining TODO list for RFCv3:
--------------------------------
1) Let the ring configure ioctl return information,
like mmap/queue-buf size

Right now libfuse and kernel have lots of duplicated setup code
and any kind of pointer/offset mismatch results in a non-working
ring that is hard to debug - probably better when the kernel does
the calculations and returns that to server side

2) In combination with 1, ring requests should retrieve their
userspace address and length from kernel side instead of
calculating it through the mmaped queue buffer on their own.
(Introduction of FUSE_URING_BUF_ADDR_FETCH)

3) Add log buffer into the ioctl and ring-request

This is to provide better error messages (instead of just
errno)

3) Multiple IO sizes per queue

Small IOs and metadata requests do not need large buffer sizes,
we need multiple IO sizes per queue.

4) FUSE_INTERRUPT handling

These are not handled yet, kernel side is probably not difficult
anymore as ring entries take fuse requests through lists.

TODO:
======

- separate buffer for fuse headers to always handle alignment

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
Changes in v4:
- Removal of ioctls, all configuration is done dynamically
  on the arrival of FUSE_URING_REQ_FETCH
- ring entries are not (and cannot be without config ioctls)
  allocated as array of the ring/queue - removal of the tag
  variable. Finding ring entries on FUSE_URING_REQ_COMMIT_AND_FETCH
  is more cumbersome now and needs an almost unused 
  struct fuse_pqueue per fuse_ring_queue and uses the unique
  id of fuse requests.
- No device clones needed for to workaroung hanging mounts
  on fuse-server/daemon termination, handled by IO_URING_F_CANCEL
- Removal of sync/async ring entry types
- Addressed some of Joannes comments, but probably not all
- Only very basic tests run for v3, as more updates should follow quickly.

Changes in v3
- Removed the __wake_on_current_cpu optimization (for now
  as that needs to go through another subsystem/tree) ,
  removing it means a significant performance drop)
- Removed MMAP (Miklos)
- Switched to two IOCTLs, instead of one ioctl that had a field
  for subcommands (ring and queue config) (Miklos)
- The ring entry state is a single state and not a bitmask anymore
  (Josef)
- Addressed several other comments from Josef (I need to go over
  the RFCv2 review again, I'm not sure if everything is addressed
  already)

- Link to v3: https://lore.kernel.org/r/20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com
- Link to v2: https://lore.kernel.org/all/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com/
- Link to v1: https://lore.kernel.org/r/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com

---
Bernd Schubert (14):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: {uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add buffer offset for uring into fuse_copy_state
      fuse: {uring} Add uring sqe commit and fetch support
      fuse: {uring} Handle teardown of ring entries
      fuse: {uring} Add a ring queue and send method
      fuse: {uring} Allow to queue to the ring
      fuse: {uring} Handle IO_URING_F_TASK_DEAD
      fuse: {io-uring} Prevent mount point hang on fuse-server termination
      fuse: enable fuse-over-io-uring

Pavel Begunkov (1):
      io_uring/cmd: let cmds to know about dying task

 Documentation/filesystems/fuse-io-uring.rst |  101 +++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dev.c                               |  155 ++--
 fs/fuse/dev_uring.c                         | 1130 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  199 +++++
 fs/fuse/fuse_dev_i.h                        |   64 ++
 fs/fuse/fuse_i.h                            |   14 +
 fs/fuse/inode.c                             |    5 +-
 include/linux/io_uring_types.h              |    1 +
 include/uapi/linux/fuse.h                   |   70 ++
 io_uring/uring_cmd.c                        |    6 +-
 12 files changed, 1706 insertions(+), 52 deletions(-)
---
base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


