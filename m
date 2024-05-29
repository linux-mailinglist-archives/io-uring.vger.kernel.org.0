Return-Path: <io-uring+bounces-1992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B72BB8D3E6D
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 20:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA6401C2178D
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 18:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE00F15CD55;
	Wed, 29 May 2024 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="uKYidOJ9"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9503C15CD59
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717007717; cv=fail; b=QRJUnD7ZijSp2v3QtW8G4A+GcE1zNT1UMc+S8goJT90giGAPUDjdv3f61FhWD9IGHEQ2VftlG9/f2MBObO5/iLXV3gD9Q+2H+zn8czE/UHfTwNWZqkFXBC94XNtcRrvPFbXvKh2QEBGfoN+/I33Az/H6EeP/rstWasjDWXC1Y7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717007717; c=relaxed/simple;
	bh=be5I/fCIGJkeMIqQLt8CsnX02PT1ZAJpx6Mi/yghSug=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UHP3mqKoTL4ZLU3Hg63P7QORQ0sfdVYLJ9vjSvRWhy7YR84yvMCz/d+T0rSXG7jNpiekfW2Uiscal1zwa+q59AM5sBo8EIy0dU8ikprqTT4GzUzqgpMlG+ql7r8EqgK3qsx8B98Oz6iQ0ib0iXkv78ywk07zcXli2sXX3DYDgO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=uKYidOJ9; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169]) by mx-outbound10-178.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 29 May 2024 18:35:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gU+Xeb/zyhLgJwyyGSuMr/vwG63HpnQqU8dSKYl+CeNr1rF+ysz0BdA5qQc0F2SMGVmmEG8v3zVvituHzkhOClwPvCTjNLM8zh6r3bsxixeTg3nWVj2qiRM6Yq7Zk8tErYvNOVSU166HZuSsYRMOjBhqnD6fS5yClyitBSLu0Q4eA/3iJ0tYumb/jpgbmUNis79i+CWLqXtgV8TfSUS78O/noaAjhlcKwPA59mZu5i1ZTKiLHuKzF9Vsxr98D+bCAzeR5+PAxoqN3XflB3ekaF6S5q9Ac+QErIY87RcR/l0LH2KY39HMghGxNJkNxRYYgmSCkK4QhRlyJLk7fmlbIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vmutbj0tjKa363MbiJmipKG1TCsDwg+4/VgWEDgaiDg=;
 b=b99dzT34tuwtYvOXCH1kqqLBXf+ZhpJefrzg5BLzMDAVI/FGvVkCu2WIWV9CfOT3VeS+Db0Xtt/tg6J44nqnruS6fvinkjUUpwT3PwFYZMyE7RNvxW6t7N9TCmFbiceacN97m8dNdRhtNaH6QiZmIyNz4tZ5K4WRDw+0PPYwQkjMr5n6XRdwUE0A0LkdOXfg7q7d87hKI6QW74dz+3akpaGoyD0fhouP9bwCNTvvxor+yMXc49wal1Wn5dqDzNiz3ImdYLidCcOjfQgafx+e23MiClN12qSOXFsmss1OJ1/7NwSfCgwdD9txgzLuywkh7eqysm+VpMlzABXY0B7gUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmutbj0tjKa363MbiJmipKG1TCsDwg+4/VgWEDgaiDg=;
 b=uKYidOJ9o+jabwZ/foCBUL4HvQWzj1gQ9agvZmZTCllP/BYLfjl7uofyCbYbnU+BF9xCmpe34ommIu7PleMUdR02ByGNoCTerhAGfWtIwI3ncu9uQbXK8Cf+4ujXzlKgwdzD7oVnlxueexJr5/YdDcvKYacsa0iQayPhpUMLAvg=
Received: from MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24) by
 PH8PR19MB6641.namprd19.prod.outlook.com (2603:10b6:510:1c0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Wed, 29 May
 2024 18:00:51 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:208:23f:cafe::d7) by MN2PR01CA0055.outlook.office365.com
 (2603:10b6:208:23f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.31 via Frontend
 Transport; Wed, 29 May 2024 18:00:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7633.15
 via Frontend Transport; Wed, 29 May 2024 18:00:50 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 455A925;
	Wed, 29 May 2024 18:00:49 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Date: Wed, 29 May 2024 20:00:35 +0200
Message-Id: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAERtV2YC/x3MMQrDMAwAwK8YzRUoIim4a6EP6FoyhERKtdhBr
 kMh5O81HW+5A4q4SYFbOMBlt2I5NXSXAPN7SqugLc3AxD0NHFFrEaxuaUXNjleM6Doz5vpBpYk
 oEg26KLRhc1H7/vcXPB/3sDOM5/kDHf0OrXUAAAA=
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>, 
 bernd.schubert@fastmail.fm
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1717005648; l=10551;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=jmKQyjCw8Z3G1+bPaHe6ZzpMyQOCtY2dzHMB4dyHc3o=;
 b=fnWBb4aXr2zWemyzuMQIC3Ktx53DXpqhdEETKyqCEW6u8RgIDDyHjrT933tViDTxjVActI9pP
 hqcHmfDuJ2YAB4wgdS3Bfl/uekqDD/JR01stk4u18XXbDbZLxO49V01
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|PH8PR19MB6641:EE_
X-MS-Office365-Filtering-Correlation-Id: ee96da7a-21b3-46f1-9486-08dc800946e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|82310400017|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODV2RGJtZlYzRkNpbGI2NzJyZ2NSVDc0dUFEY3BVbjVEZkY5N0l6MnRyd0Rl?=
 =?utf-8?B?NnRBY2FkZXQzRVRBOTJNMEJrOU5LMVdJYWRYTDhPMGlnMDh3RUhwbjFlV1J4?=
 =?utf-8?B?YUdoazFVc05SdlA5ZnhwYjEybGZ2K1ZVQ3o3bkh3Nnl0ODFwVDZ1aFZkb1Ni?=
 =?utf-8?B?MzFwQmg1MTY3V2lMRCtVcVZnMW9lRkkrMWZFa3ViMXJNMDUybXk3OXBzYXJq?=
 =?utf-8?B?MTBlZTN5RENManYvMEEybnJ4UFpMZkgrbXNYTjU0RWpWdnZhaWR2Zng4SDl5?=
 =?utf-8?B?WmFpWDBYMXUwWXdyaDdkZVZ2Y3MxbTJrWEJycGU3TUtNWEJyQUMwUUdWY1VJ?=
 =?utf-8?B?aWNKTDlEdGR3ZmY1YmlKSlplOU1QcEhWTlRrZmpaRWxZK2dlRnA5OC9SZmFS?=
 =?utf-8?B?QmtVa2JlZHhqdnlneFZqU1FrV3BJWk00akk5UXJVdTNLUzlUTW54NDM1NGE0?=
 =?utf-8?B?R2VwOUJiRTRJZHpYVG1tcmNzQWhWenBvaXgvLzZ6MVdTcUk2RjlqQnY0dUh6?=
 =?utf-8?B?SmZEeWdJaVBXT1kwdTdmOUZ1M1VUdkxpK3FSdlhWMzBWTmFMb0xVMFR2cEJP?=
 =?utf-8?B?OFZidWZ0NFRUVDFKbGJmZytOaEkrdUlnRFJCZjZBQ21OVWpybGF3NmNQUk8w?=
 =?utf-8?B?bDE5bjBZcWw5N2NqTzdGVVZQNDUydzRNTzF4eUdKbDhLM0NIZHBvZENueEdJ?=
 =?utf-8?B?UzM1T2p4OWdReExOdTJNdVhLYitPRCthdFZzRVppLzJLdHJjeFBpRXZnRlBT?=
 =?utf-8?B?S1JVYnBCYVFOeEdqM1ZZZnZQK2J0Y0VTa1pTSU1xNzFWTHJMMFNzeUxhNFNJ?=
 =?utf-8?B?WkNpbDd6Wkt4ZUd0c2h6SmFUd2tNSklZc0p4S0VlQUdUV1lQNWxnNWFqMENr?=
 =?utf-8?B?bklyR2lzaFRydjJBWHBJS0NBK3pMMjZoeVplS2o4Tmt4OGRXeXJTTk82cDRx?=
 =?utf-8?B?eWc1aXNLb0hMWnc2Q2RucUdBcWphZ0pqMmk5U0Q1cVQ4Vk1aUWFIbXhjUm1F?=
 =?utf-8?B?RDBVM2oyUDgrNXpSdWR3NzhjUlRza1hOZnozYk0zWUNJSUg3K1N6QWtMNzl3?=
 =?utf-8?B?L3RvcmxkbXdZOUdMS1dPcmhiN29GdHBXZGxCWmN0cytqdDJTYlpxdkNHTEdQ?=
 =?utf-8?B?aEpuVUg2Yld4a0N5SXNGY2VPZVU3OElxck95VHpZUTh1ZmlKMnhTaUhyWVBR?=
 =?utf-8?B?Y0llZ2NIV1BvV2l2ZVMyU3FHSTV5MUtzZEtQcHpYSGtkaWpUMUZCSEgwdTBU?=
 =?utf-8?B?NEtQdVk2TXJiOHpTajE0UWN2UWlUdWJNYjN1OUJNa2prc2VnMjl6Q0gyL0JP?=
 =?utf-8?B?S1ZjL0FzMUJBeVdJZlc0OHVWL2Uyd0d6UUZ4OVZaUkpGQWthTnNXRVhraTE2?=
 =?utf-8?B?QWE3VVc0N2ozQ2lZN3JtbGdTZ3dxNi9hZUJCWEhwQmhObW12QzRFQU4xTU16?=
 =?utf-8?B?czdXNGYwb0RhaHhGMCsyaTU0V2tmenVRcllMRGNJN0pCR1RUcTNRbzZqejRK?=
 =?utf-8?B?LzUvSHB6TURNN2lRWmFnSGRydzFEeTB6UGFYTkE0azRTTWVrd0dUZFBlNDNa?=
 =?utf-8?B?c0R3Y2hWODZrVFgyNnJreFBpcUh3SlFTSGRneS9HdVJsb2x4eWUrRkREbXNl?=
 =?utf-8?B?MWtpZGdhdFh6YW5iQ0R3dE5HZmhGVDRienFLN3A4NDBxanM3VmpZaWJ6YXU4?=
 =?utf-8?B?SndvZG1IZC9uV3NNdGpEdE92WldoNURicDV0Wm1mcFBYZkpYVDQ0MTZObnpF?=
 =?utf-8?B?Z05vUmU0VUFocWZyL0xuc3RLTCtzTDJmdXBsMXJydlhBOFU3RkdJMG5wZ21H?=
 =?utf-8?B?YTkzckdJL21hd0FwMU1JQT09?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400017)(1800799015)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QGmHoPUUo4iTWODzn9i6Yq9rn1V4vo3DhvOz9Ou/7gQaG0ccLFWzlcIDBe4atyAT84D5bi4oGV6S9vMrd08Yn2DmMtz7hKwlljWbL1AcxI2UiNnB/A6gyG7t96hBjwe+FNYov/8FvFSrQrgOwXQ4ker3uqvIFkSBk4myWCOMaTy1iKlkZAMzfZtYtVlpgGC/WucX/q0ySGhzMTP0Qs8cTUEFneBpjYp0yzAeXO0pnogIpsRwVcnAWH94hZc9dzUQZfJOmx+ViMB1hkhk/Rv/lLwfgTNevfsLThJJ8/iFFvD5Gsypfmwhl+/8ILx0QbyW+1Lk11/HGAztRcyUl93RyVg4RlWJ4vyWGhbM+DNPsfn0dR3iCnWlG7MlbucP5TIdJNqvo5/Etq8LTJBfKVQBDrAnmN2yi9noCj//HdLulLVYNQzpCxMVJ35mMNnsQI0tDHQDw+Ew+5263a7WoBAB409Tx5ys7Ou56fkqUP6XrAE3+nuJK15Wk/sOBJyr4Gm+b8Hm4X8LoWZWeEJBeMdjHwoMBqwnDosiz42HWaVi4Ybsi+efDRKtwxM9TDYrC4l6ftYwKFnf6iQ1Xnvxde5IVTSZKu6KBl8CO4iXuR/Wq82jgu5q0CrgFSUHm3fXJvvO7YAcdGhniGFR6URLEZckCA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 18:00:50.7173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee96da7a-21b3-46f1-9486-08dc800946e1
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6641
X-OriginatorOrg: ddn.com
X-BESS-ID: 1717007711-102738-12825-47682-1
X-BESS-VER: 2019.1_20240429.2309
X-BESS-Apparent-Source-IP: 104.47.73.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGxiYmQGYGUNQyJdnE1CAx0T
	g1Kc3EwMTMKMkwNdUgJS0xzcIw2djYUqk2FgDu+pH0QgAAAA==
X-BESS-Outbound-Spam-Score: 0.90
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.256584 [from 
	cloudscan21-2.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.90 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_SA085b, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Bernd Schubert <bschubert@ddn.com>

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

This cache line bouncing should be addressed by these patches
as well.

I had also noticed waitq wake-up latencies in fuse before
https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmail.fm/T/

This spinning approach helped with performance (>40% improvement
for file creates), but due to random server side thread/core utilization
spinning cannot be well controlled in /dev/fuse mode.
With fuse-over-io-uring requests are handled on the same core
(sync requests) or on core+1 (large async requests) and performance
improvements are achieved without spinning.

Splice/zero-copy is not supported yet, Ming Lei is working
on io-uring support for ublk_drv, but I think so far there
is no final agreement on the approach to be taken yet.
Fuse-over-io-uring runs significantly faster than reads/writes
over /dev/fuse, even with splice enabled, so missing zc
should not be a blocking issue.

The patches have been tested with multiple xfstest runs in a VM
(32 cores) with a kernel that has several debug options
enabled (like KASAN and MSAN).
For some tests xfstests reports that O_DIRECT is not supported,
I need to investigate that. Interesting part is that exactly
these tests fail in plain /dev/fuse posix mode. I had to disabled
generic/650, which is enabling/disabling cpu cores - given ring
threads are bound to cores issues with that are no totally
unexpected, but then there (scheduler) kernel messages that
core binding for these threads is removed - this needs
to be further investigates.
Nice effect in io-uring mode is that tests run faster (like
generic/522 ~2400s /dev/fuse vs. ~1600s patched), though still
slow as this is with ASAN/leak-detection/etc.

The corresponding libfuse patches are on my uring branch,
but need cleanup for submission - will happen during the next
days.
https://github.com/bsbernd/libfuse/tree/uring

If it should make review easier, patches posted here are on
this branch
https://github.com/bsbernd/linux/tree/fuse-uring-for-6.9-rfc2

TODO list for next RFC versions
- Let the ring configure ioctl return information, like mmap/queue-buf size
- Request kernel side address and len for a request - avoid calculation in userspace?
- multiple IO sizes per queue (avoiding a calculation in userspace is probably even
  more important)
- FUSE_INTERRUPT handling?
- Logging (adds fields in the ioctl and also ring-request),
  any mismatch between client and server is currently very hard to understand
  through error codes

Future work
- notifications, probably on their own ring
- zero copy

I had run quite some benchmarks with linux-6.2 before LSFMMBPF2023,
which, resulted in some tuning patches (at the end of the
patch series).

Some benchmark results
======================

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

Long term TODO:
--------------
Notifications through io-uring, maybe with a separated ring,
but I'm not sure yet.

Changes since RFCv1
-------------------
- No need to hold the task of the server side anymore.  Also no
  ioctls/threads waiting for shutdown anymore.  Shutdown now more
  works like the traditional fuse way.
- Each queue clones the fuse and device release makes an  exception
  for io-uring. Reason is that queued IORING_OP_URING_CMD
  (through .uring_cmd) prevent a device release. I.e. a killed
  server side typically triggers fuse_abort_conn(). This was the
  reason for the async stop-monitor in v1 and reference on the daemon
  task. However it was very racy and annotated immediately by Miklos.
- In v1 the offset parameter to mmap was identifying the QID, in v2
  server side is expected to send mmap from a core bound ring thread
  in numa mode and numa node is taken through the core of that thread.
  Kernel side of the mmap buffer is stored in an rbtree and assigned
  to the right qid through an additional queue ioctl.
- Release of IORING_OP_URING_CMD is done through lists now, instead
  of iterating over the entire array of queues/entries and does not
  depend on the entry state anymore (a bit of the state is still left
  for sanity check).
- Finding free ring queue entries is done through lists and not through
  a bitmap anymore
- Many other code changes and bug fixes
- Performance tunings

---
Bernd Schubert (19):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: Add a uring config ioctl
      Add a vmalloc_node_user function
      fuse uring: Add an mmap method
      fuse: Add the queue configuration ioctl
      fuse: {uring} Add a dev_release exception for fuse-over-io-uring
      fuse: {uring} Handle SQEs - register commands
      fuse: Add support to copy from/to the ring buffer
      fuse: {uring} Add uring sqe commit and fetch support
      fuse: {uring} Handle uring shutdown
      fuse: {uring} Allow to queue to the ring
      export __wake_on_current_cpu
      fuse: {uring} Wake requests on the the current cpu
      fuse: {uring} Send async requests to qid of core + 1
      fuse: {uring} Set a min cpu offset io-size for reads/writes
      fuse: {uring} Optimize async sends

 Documentation/filesystems/fuse-io-uring.rst |  167 ++++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dev.c                               |  310 +++++--
 fs/fuse/dev_uring.c                         | 1232 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  395 +++++++++
 fs/fuse/file.c                              |   15 +-
 fs/fuse/fuse_dev_i.h                        |   67 ++
 fs/fuse/fuse_i.h                            |    9 +
 fs/fuse/inode.c                             |    3 +
 include/linux/vmalloc.h                     |    1 +
 include/uapi/linux/fuse.h                   |  135 +++
 kernel/sched/wait.c                         |    1 +
 mm/nommu.c                                  |    6 +
 mm/vmalloc.c                                |   41 +-
 15 files changed, 2330 insertions(+), 65 deletions(-)
---
base-commit: dd5a440a31fae6e459c0d6271dddd62825505361
change-id: 20240529-fuse-uring-for-6-9-rfc2-out-f0a009005fdf

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


