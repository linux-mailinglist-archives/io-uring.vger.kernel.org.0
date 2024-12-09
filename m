Return-Path: <io-uring+bounces-5321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB0D9E99A6
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11F50283D59
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FA61C5CA0;
	Mon,  9 Dec 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="E4ut91P5"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F12C1BEF8C;
	Mon,  9 Dec 2024 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756221; cv=fail; b=HxE78tjdvZhw09maPOQ0G3F5I7mbHhhGLXI+WUivlTiZKvbjW1i6hqKuJQHMe7LkzrVWB3GKaZrbdXfjCB2oVbgC02sXBm/QV+k5MvbN7t99M3lLOT5p5kk3RRw4JluewtE6po7j4Q3dg1NaIvO47I1z2iSGd5V748lEg7EzKps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756221; c=relaxed/simple;
	bh=DZCxR+9y+0VlsjDjUKCRoKY0s9jGT+XUZ1X4k7iI99Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SDzfSLssJpY5TDa1dZWS0u6J/F+PCApY2PQWQ7Ym13DVKc96aYBIKnR+OV8sn4szmyt1tg4+nKdh6v6Xscc9rvwie4mFLik/UoHwhu2j3jzX/gDWz/MdtGmzRdrXz6Wt7R4tOoYjOHFOI9Ijf0tMdgTC4+OBCBAkRnsWNl0MTUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=E4ut91P5; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174]) by mx-outbound41-18.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=td3QNpU4gtIk1esFayKa4RjmHap281TUqgdiZne/84rq0I+CT+EDsUC6rp9BM+NsMsYWEeq+UDzAk+dwVchlijCQ934CT2J+MaWvT5ACT81rXxB+a59d/lri0SD1MmudkEtnUwmacFJw/hnK53sNAWlsTJabvjuNtq9H8HstwNDAurENwz50RJcAMM2Kvi1g7e6mQSL+2OJc5fYB38PyUnChH3kbLIsFCIm4j0AfdT4gQGeIfIies6iDG0tdWSg6JfegJeiqH9eGGo78762kyqAfqdBYec5/99ZEmOf8Eb5mPctGEkwW7o2Qc/PYxtRlYBOZqSZIja12FXfSDwQu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJ17exbkEPno46IkvCvwmhAlMktHh0hGC08hsLQfEoI=;
 b=dK0p7HgplovmJO7kIKYLw6UkHUiuHvitOT+suvbLoMeFMS1fHsdqgH6MgZ62RD5CHwJIXjcEZOXCB6o+qdWSzARIGj18/TY7le1g5jYfy66xJW8gLWs1bildizCtgptpqohc3F4t2bZ0WonGqRMyzTFD8eO9I+L2tOt4fehJIo5C61/2Sq+StPC+hqSyZAtIWVD0WWOOiC6tShZKtNv9MxGpqyqe/E7AD+UiloOs/ToSv8tzN8X1PEj5IKu9/QibzT8gklAUB+4PiBm+JThc55UHnOMxrchCpnAx4WgZ6fmi3fuo0qXGbvYooDruRkd7lYNbw7CYViidyVOj7usVGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ17exbkEPno46IkvCvwmhAlMktHh0hGC08hsLQfEoI=;
 b=E4ut91P58z0uriPcAz3W+aXSJldANrDvWpW2S/iGH3uiAemGUyNL/Cz4xJzLbe3oXxfQF+L/hmtLYxeJQpJ9bxU+vHmALhIiSxhpIeSPl8mt7ooZY5K6RrJCnCrs2mDnttU9zvitz+ldUGvhFakDWxV6gToFGrcjqrZxIF2rHs4=
Received: from MN2PR03CA0017.namprd03.prod.outlook.com (2603:10b6:208:23a::22)
 by PH0PR19MB7550.namprd19.prod.outlook.com (2603:10b6:510:28d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 14:56:50 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::75) by MN2PR03CA0017.outlook.office365.com
 (2603:10b6:208:23a::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.15 via Frontend Transport; Mon,
 9 Dec 2024 14:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:49 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8E62A192;
	Mon,  9 Dec 2024 14:56:48 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:31 +0100
Subject: [PATCH v8 09/16] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-9-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=3396;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=DZCxR+9y+0VlsjDjUKCRoKY0s9jGT+XUZ1X4k7iI99Y=;
 b=9jlgygMESdQ2+cnVjpGtsikH/ESH+1L8sHHc4w+jFjxT+y+JQU82vnFRxFVicY1hX+8SJvLOi
 ghIyDel/l5FBgqsMMgQ31uBNS5Z6+H6RyI5Hegs7lDPdzR3GQWdiENa
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|PH0PR19MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a520ce-e113-4720-62a4-08dd1861b5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXYvM3ZqYTRUbHFxU01ieGdzbk0rN1Z6Wkw0WUZDNGxRY1B2SzJMcEozVkFj?=
 =?utf-8?B?dEFvVUZkVVVlV0wrdE5NbnhBSDZkNHd3cGR1b0dzL0xnK092bUNlM3hzK1dN?=
 =?utf-8?B?S3NFV25wM1QxNDR2M1oyNlVId1V3SC9VK3hTNlNRbk5uTW0xbzc1MFk5dkJy?=
 =?utf-8?B?U2lEb25ieTBibEpvazFoVE94SHlNaHNFZWFyL0c5NzdnRnZYd2drK0Q1RjBs?=
 =?utf-8?B?TCt6SHlKMEF3cXZUYkJuZjRVa2dXbzVxNWtxUDBVN0dCRTg0VktFMlhHZFha?=
 =?utf-8?B?WWg0cjFubVpsaW1rNVpjbFEzemJOOWUxeFczOS9jeGNGMGxDd2JOOXFEcmxP?=
 =?utf-8?B?NVdocDJ4OXBuM2RXalZUL2xTK1R0ZUI0L0Z0cnFudGl4MTI5UWFLV3I0T0JM?=
 =?utf-8?B?RUlJZmYwdndqdmhvQmVqQmVqcjJxc2xLeTRsN1RGSmE0SVNhOEJlYms0ekEy?=
 =?utf-8?B?NUNyNi8vMFJYejZDZXYxeC8zeWxBZDI0RDNFamJzWTU0akpOWkFxSGNDbmNu?=
 =?utf-8?B?d2FlMHBxWkhJYnA4czhMSHJ4cnorRkNvL1g2QXhRNEFxNzBjNTFFdVBwSSsr?=
 =?utf-8?B?WUtONkliYjY5N0o3T25iTW1VNk5RNTg2c0d3L1dkRFdXWFRkRGhWVmJ3SGFq?=
 =?utf-8?B?SVgxdHhWRTQ2SDFQZkFVOHJKUndPR0hvVFpTWUlidWtrbzAzVzlSWjJlbnor?=
 =?utf-8?B?VXZmajVuOG13WFVQZDl0NHorUzRTQXdzbFY4Wk1SQW1XcDNLd3FKRXR0QlN3?=
 =?utf-8?B?d0hmMU1JTGhxbkpyejhYNXNuYTlRdEgrWmk0YlFsZEVhcDc5WVVlZFpTdWt2?=
 =?utf-8?B?S2R2Umo1b2pGNWNEMTZVTFQzVk1HZVFQN0R4K3B4eXhFQTN6ZmMzMGI4OU9x?=
 =?utf-8?B?QlRGTzF3ek11WGk5UHBLSXk4a3U1Sit2WVkvL25lRXBFTGxPTWYwSm5EYm1h?=
 =?utf-8?B?UVhwbXlpZXc3czVmS3p0UjR5Wi94ZTUxbGkzN0dyS0ZDdWRBR3llWFZYVFg0?=
 =?utf-8?B?Y0cycUhRdzJLd0NFbXN1eCsrSGNrRXZXWUlOQ1VwTXZ0aFlqSGFxTWtzQ0xu?=
 =?utf-8?B?ZlJTV1Y5OFQwekk3ZjhFQzVQMFZUSzBBVERWenJZa1B1N01lSjBkL1lqS3ZF?=
 =?utf-8?B?VWUxTFY0S21sdXE5OUo1ckhLSm9iemdrZGtQaklNUUc4bUloSE1aT1M3eFNT?=
 =?utf-8?B?SWh4b2YwbFg1RE9JNll5MUkyQ1hCKzFIc0JhcHNadHBXVGxDN0dPMGdGUGc3?=
 =?utf-8?B?Ymg5K1JiS21mQ1lPMXRISmZxMWRPdUZqRktaNE5jL1VmWENXVUlhYTlRNWtO?=
 =?utf-8?B?TEI0OUcya2ZGbGJIUm45S3prSU9MRGg0SlNZbzk4cFhKaEgrSENHYzhwOWd0?=
 =?utf-8?B?c1JJK3E3bHBpU0ZMSTNRVHJwdDc0WFltdFh1Vk5JNG12TStLdk1GMnh5QWsr?=
 =?utf-8?B?UFNUSWRkZEtVdmI1N1RxQUtPN2tXWjhHcjZwWk9ZdDJMYTVnOWJvaUFTY3lC?=
 =?utf-8?B?a1RRbUYxVnlia0ZCYi9QRUlMemVXQjZWK1c5Yzcyeit4NkZ0aW1EemhGWEtK?=
 =?utf-8?B?L1dPcXdsN3hqOFZYT0s3KzBPVkc3MlNHTENVbEw5VFVEQTZpNVpkTTJxUGEz?=
 =?utf-8?B?dUF2VHUwL3pCVXFkZVBTQXVyQWZNenU2NnQ3OXdhVFl1VEc1azFOV1JubVhN?=
 =?utf-8?B?L0JDc1g0QjRvNCtMNkMzVnpzODFXNzQ0cWRXYXFmcXpuTlkxYzh0STNGQVZj?=
 =?utf-8?B?K1VqQ2dvSUtGOWNDSDBSZGJJeVB4WDkvMVJGb3VZMHUwa2RJWXR1SnhFOTMx?=
 =?utf-8?B?VGlHbUtMejVuRWN6YzhYQms5bHQ0WlMzanNBMFNIRUtnb0tmTjNpSEljU3ZF?=
 =?utf-8?B?c0tVbEhCYmVKa29TS1VrR0psNkhRaUVXYXllL0ozeDByejY5b3VUSCtLd0U0?=
 =?utf-8?Q?MFwxS5gDSdiZHa/8uJIBz/GPn6gUsrFs?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ajh7AVGJSxHTkMvL4bnxGURajsJ23CMpwcdPe6pun+WLoavw6LlH0NAAfK9pgZftkbpEjwZGHrRij4C8EnjzYKyb4TyJfCt+gkmSq2198ikHUt7ddPAEp+LXdipO50xVCRqfHYJF62g38hYdYVE2J5WbG9rihDW7BwmLvieK479fjoNwW3o+khoOTjIsYHKO4RPU8eUE/V7GEA99dOooxUMZfcKa2hhdV5zyPWslwgOxFj62/0D1dmkzQ9+s/AAD4+lSESmGORv6hluji2vw5amtJqk3FD7M1hVZQm11iv+BE41MTf1067MV534eEUxeFxzv/GOurWiVY9oJ7M8xdacU4OSwkIdkNAWSzwrsFTq6mv2eGulPmFee2Zwp/SK9rlDE2hMar542/ZPha4vO8xLgASbKaYxlC2isV9zsCy0pfn2LrA0FJ6oNz/je7aR6PTfqFmqgoDrVDJeNyk1mR/q+V/7RhS+bUIkcO4Zhx+sjBcYhW4fhCcZ3lcTVmHyLbYxyLAtvYjAvFQKcZ4kONDhjUb8iGNQfnaMGaH5r3sG+lc870mhDqhHiEyvAg62veYzjAAmKof23Gq/6OAHmCVWHREKu+Dh7eLs9XUFaIfiEv6uposOv+Xpk7glEPdYMGvGYVWAqH9/y/ogSvLUwbw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:49.4040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a520ce-e113-4720-62a4-08dd1861b5c3
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB7550
X-BESS-ID: 1733756212-110514-13456-2496-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.59.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsZGlkZAVgZQMDkp0STN3MjQOM
	3CKM0k2TTNMs3QzDjF0DglNS0tOSVZqTYWAJhHGBdBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan8-150.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

fuse-over-io-uring uses existing functions to find requests based
on their unique id - make these functions non-static.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 6 +++---
 fs/fuse/fuse_dev_i.h | 6 ++++++
 fs/fuse/fuse_i.h     | 5 +++++
 fs/fuse/inode.c      | 2 +-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 2ba153054f7ba61a870c847cb87d81168220661f..a45d92431769d4aadaf5c5792086abc5dda3c048 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -220,7 +220,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1910,7 +1910,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1994,7 +1994,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 0708730b656b97071de9a5331ef4d51a112c602c..d7bf72dabd84c3896d1447380649e2f4d20b0643 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -7,6 +7,7 @@
 #define _FS_FUSE_DEV_I_H
 
 #include <linux/types.h>
+#include <linux/fs.h>
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
@@ -14,6 +15,8 @@
 
 struct fuse_arg;
 struct fuse_args;
+struct fuse_pqueue;
+struct fuse_req;
 
 struct fuse_copy_state {
 	int write;
@@ -43,6 +46,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d75dd9b59a5c35b76919db760645464f604517f5..e545b0864dd51e82df61cc39bdf65d3d36a418dc 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1237,6 +1237,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
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
index e4f9bbacfc1bc6f51d5d01b4c47b42cc159ed783..328797b9aac9a816a4ad2c69b6880dc6ef6222b0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -938,7 +938,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


