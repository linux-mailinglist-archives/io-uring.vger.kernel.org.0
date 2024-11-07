Return-Path: <io-uring+bounces-4550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FDDC9C0D11
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B0191C20853
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E460215F72;
	Thu,  7 Nov 2024 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="fzsCSdPW"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E4B191F6A;
	Thu,  7 Nov 2024 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001095; cv=fail; b=eaHK70x/allIwYM+Ph3G+RjRR3qDMz6+anlC9DBPYGgXZl1xr9FTtLpgWa+Ux6Jq3g0YRzPi46VEG4sTiHSxprphUtNid6jgd4mDyYlc4BrNDwMtJsKq00yGh46Q9dPVhW3l+BinFef1iz18BFkHOAXYXDH3Wj47lABPGc3u6Uw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001095; c=relaxed/simple;
	bh=xQ5GLMmSmBuC7f4wx3JMYdena8LXo96WQCpVOtnI4EI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Nrl6oqN6GsWgDCyRVYjWYgESmlmIhmG6LodLxH4gPAc1PFvqE2zLb1lfSlRQB/F0z/I7O1YKETt/KvKCvS/Aoy+NC6RpxKLonys5VhVcsCMPR+AsR5orQXScnNUnHTwNi1lS2CAJ2QtRt+biFqUtZDPFl+AV+Kr4xEsleMIiFEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=fzsCSdPW; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43]) by mx-outbound42-219.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCniTYaD/MaevGD7SjIEAeq4Sa5xsHb0hKxOwIv8keFz7MKB5v3K7L6w++k5tSsThDP2aYKUwdWcIngeFsAyM6ifgDoCqDLT5gB6J4H9ByuyKgdDx/UqkHkszMfyqGhvNnhdDJc2TCcP0LjQuxreg3Dw53JhpOku9qr+qLHeIZyUyhY4KJY1hGhZ+za/hiaSkUoKO5S0Tcmc4fXOJj4ObsM5r1F6sSzxmFeprmqTQ17fPTZxeF0jR+bnTqJE284IijCa1MyC+RDFaSQGfd+GCHG8YobRTUGwTjktaWIoKzPZmYBXPUAHQAhfMR+ni9SnazY8rbt/4NbVTv2pZK9dyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lkuu1u9USQ7DntGvcOfS4aOKOUVGKmcj1YaoPjshfZ8=;
 b=FWX3ngD9noA47+ycI95MsodNqbni77JEtnzru9AWz3EjwkzJor6bIVAHoXaLRBO7gZX1pEOLl+kdHAs33uZ3C/k31zCjzytP1f/seJUvcPl5BJdyJHsopz/L3uZRLszHbaqT363wg4xcqUEDvjfQofus2uEEUz1Znu9Ablw08oAkM5K/ni8KAIvGtFraVs6VITLc2mi8tUQEiW5hjBVK6yJoo+r5iw1LdvURjQfXj+MlwSfDJwggXc6Z9xUr1loWgcSPEQZ9EW4vZmcTeOtVS3LigXfTpGQyYO4sW8uZaaoOR2xwge9bdWPVIWFNzoD07EySK9hRv+GvX8HxjSxJVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lkuu1u9USQ7DntGvcOfS4aOKOUVGKmcj1YaoPjshfZ8=;
 b=fzsCSdPWv81Uvv/uQgE2/Ym1XCIiO3SBirX0SWcoDBwEQEqw57ita2hXjMAnK72yA26MV5Zhley9bEknucMGHnZ56VIR/1HK6iUSROsLveuGPhSIwTk9TvmlQutlDGQA6WXR0mXhonsy9lZrOM421/r+7ENCSSmlbTPDxTThq/w=
Received: from CH0PR03CA0113.namprd03.prod.outlook.com (2603:10b6:610:cd::28)
 by MN2PR19MB4128.namprd19.prod.outlook.com (2603:10b6:208:1e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 17:04:11 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::35) by CH0PR03CA0113.outlook.office365.com
 (2603:10b6:610:cd::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:11 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 571457D;
	Thu,  7 Nov 2024 17:04:10 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH RFC v5 00/16] fuse: fuse-over-io-uring
Date: Thu, 07 Nov 2024 18:03:44 +0100
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPDyLGcC/3WOvQ6CMBSFX4V09poW2iJOJiY+gKthwP5AB1rSQ
 tUQ3t1CjHFxPPfm+86ZUVDeqICO2Yy8iiYYZ1NguwyJrrGtAiNTRjnOKcGEgZ6Cgskb24J2Hjg
 QDF4LCpxIrAU/MKIPKOGDV9o8N/UNXS9nVKdjZ8Lo/Guri3R7rWZcYQJ3+itPzljAw4ydm0bo+
 2aAlDFUOS51WVSEUnqS0u6F69e6z0D+f2CkK55QUbKCc66+eL0syxttzCrUCgEAAA==
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=11251;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=xQ5GLMmSmBuC7f4wx3JMYdena8LXo96WQCpVOtnI4EI=;
 b=lvtL0jnAR+T79vbAZYoTAGt6y/XMd7+rwlJ+CoaAcraBiEiF0TU5rPHBvkQhZrZoY1vOGo2TD
 ZpFfaxQkKOcBkdOMgHVvEBB+DUQ9u1GDkCtydkbveHEx8iRQlCbPexd
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|MN2PR19MB4128:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a40e39-93c4-4632-1b3a-08dcff4e333d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?WHQyVldUUWZJV1pMZU81b0ZpcmhxM3EvUWtJbE5Nd1RrTXNRVjdoZ1FFbzds?=
 =?utf-8?B?Ni9FcTRlRlUva0dvbkZNajkrYi9tMmVZNnNCelhPeFhqS0YyeTVHcHE0SzlU?=
 =?utf-8?B?cTNDTnZRVXRFRU9tSXllU1JKYjNpcmM5SW9sblNkOGpxUFFvQitnOEdHa200?=
 =?utf-8?B?WHptMWZtSGZBRUJsK3ZUTXRkWmJxTGdnQXlaR2RjTGMwRWdFWlM0Y1p0Z21X?=
 =?utf-8?B?YU9vbUk0bXBtVVpUMFJDcWdBSTZKODhWNlNpNXJCV2xyWTZ3RWRWM0JEVjVv?=
 =?utf-8?B?WW5LQWF0RXFoMEw3c1ozaHhFdkl1anUwQ2VuZUNjQ1ZoRExDV2tYRithaEZt?=
 =?utf-8?B?OTI3TXl2OXJ4N00zd3VyKzQxK1FEVVg2a2wvTDN6d2pmc0tPVEY5UTV2QmY2?=
 =?utf-8?B?VHM5VG1laHFaUUMvdXlsTEZMYU5KbXRKeERjYkYza2xMYkJkMnRKSFF5MEJp?=
 =?utf-8?B?YjVoempncDBtd21sQkx4SEJlTkRwcDVpWiszWW9VVjV2SklCRFhET2VWeGh5?=
 =?utf-8?B?MXdQMi90YWZtK0tFUEx3TnRFcTVkSUloZTd4MzAycXVEbEJ3djQ0U2R4Kzgy?=
 =?utf-8?B?TVVST2I3N2VMcmRObXJMNjVET3JXQWtQajlvQ0NzMEh5YmdlM0tkS29vQ1M3?=
 =?utf-8?B?dSszK05pWWlrK1BaUzduQ2pUTzB0RHlsazBXWU1qei9Ta2t5S3lydUppeXFh?=
 =?utf-8?B?WkpQWWxEdlNPQTg3aFpoN2JNaFdXallQdXVBYjJRZ0ovWDJwY1hUUFZEenB5?=
 =?utf-8?B?eU8vbFVDRUxsck9nN3JrMGpKdDNuTC8zcVJRMzlIUUZVMGlpcU5TcDArSHYv?=
 =?utf-8?B?VlJySUpRVFc5MHdzR2ZGb0RoLys4RmpCbWhnMVZIQ2RVb3dDWmNQNHRnSzE0?=
 =?utf-8?B?NGJNOWczWFY2VlVGWi9leFF2Nll4elIrWFExUzZEWk43NHlHT203Z0xWVlFn?=
 =?utf-8?B?QUxjcjB6K01rOHdwU1pmUDBzbzJ5cXI3TDFFNDZCb0o5bWh2b2VDbTdzYVdJ?=
 =?utf-8?B?aWFnV0ZUOHBJZUxpU3BuRk9XOW5oQmhFZWNLU0JtVDQyQTJ4RmRGOTNBQTlp?=
 =?utf-8?B?bmtuR0FsYmZZYlJUVStzdGdONTF0NDlCWVMrc2c1VWpUeVpCQXJTckwzbFdM?=
 =?utf-8?B?TlhJREV0d1hyYVR4NlJqTXl6SktCWjd2VkdUZnliUDg1ZmRSMU5LTEZRMm80?=
 =?utf-8?B?Wi9RUGYyMFlxSUorRGlMVzBpd1pBTFR1dm5uWURRMjM0Z2NpSkJyZUFtazdN?=
 =?utf-8?B?OTZGZUhBQlV5dGJ5YlFkYjBHN2dpUFFwWVNLbklUNklwYjZZSVpXczBGUEJm?=
 =?utf-8?B?ditjL3FHUGF2ZzBwRFpWc01Gem9yaUZrL2NaRG51TEtjbjJ2bEMvWHpiUmcr?=
 =?utf-8?B?NU1DQWtMd2VCeTFmVHhJUGlKeE1aM2tuQWplSUZJb21nNEhUUEdXZkZVdWF6?=
 =?utf-8?B?SStvMzdoRXhwRlZsUUVZc2pmVHJYZEJDZFRoTjNUSVlSUHN1WlJnWTQ0bzJa?=
 =?utf-8?B?anpGQTduKzJrQlZZMFliUWQ0bGlhTURWT1hvYUIyMmU2WGRjZlRSdzJkY01F?=
 =?utf-8?B?SGsydHZqV1E0eDdVaFBMekVDaTlnRWdPVlJMNkhxcmw5bFhlZUZ4NlNFWFBP?=
 =?utf-8?B?cThldjlBQ0tSYXNTRlZlOXBwYkc0RUhhYUtwSm5zQXA2SzJxS1RvQlkyN2xN?=
 =?utf-8?B?YzZjc3pKK2VxQnB3ZEkzVVVNVzN3RGxqdExJVkRMK2JNSEpQQmlyeForM3RB?=
 =?utf-8?B?clEvd2lQaVE0OGRRQkZWd1ZqbVJXenFBSnhWUm9zbDJaRTZ1Rkd6elVmcEww?=
 =?utf-8?Q?MwijvYZ2msxe35pFmt6ZBf6+RsNYz69GtG02k=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 QdMoOs+YfOenR6zbiP9hk4/v15s7JXjgjzuv7ptzQk0BWfU3Ld4GJFJ5T53uIMulNxKFJRivMD8og48jAPj+LByQn7K4ox3gLv9DBDzHKy1Q4hRHnnYqRG33OnzwzH2tAaxqqCNtRh3gxswCkHsdg+4j2objtPo0u96IiXQW76uG3n4vcE+JjDb1V2Ee0Ss6Zjdbf9xepJBdUJ6wPVciAcAsj9hmZJLGVg3lc9IZrdiONMxQj8CUD0YfSv8qkBYLqgHrkXrvn/CBW5TlgTCpeWloXqKegeJATaCOGL6hRkkykJzoCAS/Kmukh+KucTQ+9QLpyAM+JyonsHnFWfvBD2TuhccjKXDfLF1dfqXgKJJhT0cznqkG4zrBvex4jY5sG1bQ+Od9OHYhjqdVRxxZ5RlzHhPPllSG5OWvbL8UoObyfkQcsk4e4oYeFMgiBjz9vKCzW8jaKYZAzaNpzVWf8+TLdM2a+0fusuJlxQHR7mnCAff8qInBKc1BS4s5PJ8yKPha/hCpUfFKKjH6wyHHFqQ0oebVACLPffWhHPRd0qXCwUDEhDo/mYIj8AuN6cD69FwCz6EHytepHD5Y/CuQYMs8NR+ZI3ECyhtse5T2S3kosrSGg6bWi5JbYIjpsvTuMg0gLWLDvbjVz+JOlzq9/A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:11.0379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a40e39-93c4-4632-1b3a-08dcff4e333d
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB4128
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001074-110971-12656-9456-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.57.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGlpamQGYGUNTcNNksycggNc
	nI2DDVINXC2CQxOcXIzCDR0sAg2dQsWak2FgA4ozYpQgAAAA==
X-BESS-Outbound-Spam-Score: 0.90
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan23-37.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.90 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_SC0_SA085b, BSF_BESS_OUTBOUND
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

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
Changes in v5:
- Main focus in v5 is the separation of headers from payload,
  which required to introduce 'struct fuse_zero_in'.
- Addressed several teardown issues, that were a regression in v4.
- Fixed "BUG: sleeping function called" due to allocation while
  holding a lock reported by David Wei
- Fix function comment reported by kernel test rebot
- Fix set but unused variabled reported by test robot
- Link to v4: https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com

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
Bernd Schubert (15):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: make args->in_args[0] to be always the header
      fuse: {uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add fuse-io-uring handling into fuse_copy
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
 fs/fuse/dax.c                               |   13 +-
 fs/fuse/dev.c                               |  174 ++--
 fs/fuse/dev_uring.c                         | 1208 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  191 +++++
 fs/fuse/dir.c                               |   41 +-
 fs/fuse/fuse_dev_i.h                        |   64 ++
 fs/fuse/fuse_i.h                            |   21 +
 fs/fuse/inode.c                             |    5 +-
 fs/fuse/xattr.c                             |    9 +-
 include/linux/io_uring_types.h              |    1 +
 include/uapi/linux/fuse.h                   |   57 ++
 io_uring/uring_cmd.c                        |    6 +-
 15 files changed, 1827 insertions(+), 77 deletions(-)
---
base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


