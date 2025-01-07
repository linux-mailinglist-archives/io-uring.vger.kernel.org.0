Return-Path: <io-uring+bounces-5709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF70A034C6
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE65118868B8
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCAE12DD8A;
	Tue,  7 Jan 2025 01:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="B8wZzpRX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CCF86355
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215146; cv=fail; b=Q8bZ7FoXeL9BfoIPDI6k9Cw6OnLfwiYaCTXa7LfLATfHep0pYmEWlla/aafhoHW6L5haDNBT2cj5oYWqNMaCDm7KCKn+CytKTawyJzMUOew8wlCSR6cQfMQjIR1aPid0iRzBVjgr1qxmjre2Xa8Sk+n68KphhUkRnIckDitNAGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215146; c=relaxed/simple;
	bh=wxYO2fuIGkvqmeC9PNGhH5rOX2Wls8HlW08RzezL2Zw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IIvYNf4A2SuBOxQcapCPvVziQgL3It388h99EeOnt8z6p/gh9LT1U/UABTZxZmTyVkYVv0aCZEpqE52b5ixO/Z2f/ncm5ul7EqdZJQP31brUQJjCdiVvFzItOZwJ1Wh/vsT4z6w7DLuyyfmN91m3v+VXVUe6etSCflWGjPoThHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=B8wZzpRX; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45]) by mx-outbound22-77.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDy4x79QSxc5m71YtODBNQQnqrTCxw5a4QYiVsjuperHjPmjZykhMOEHIXtNs+fIB4/RYmH318vYnAvEqh7uls+CoDduOf1e5zCVp61KsPmXBPyGTComlOG/FQ7C46bmt6lBpGpI8tubZdDOe89V00+x2Vg7ne7ShbxX37tLYmeI/g978lLiPxO2TEPaWY+tx5OgOFJjw9zW2hofYJGnGCfnaE0+2RjYq/vDnA9UGkE8QrlbY/cEJD22apNgYyalbeyMiiHaYCAXHSh4ee6OqpSHur6c1pSHHBqtMK5I4BnuBOmEWXwI7iiEdiG+NOsW0IB96Uh1PaXit9/FPr3zQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAgBjLWkV7oHdA35f4ET93Ocl3k2rLGZEn+8xfR4iOY=;
 b=sRYqBFbWa7NLUd5m0/BMfZhPt1E/j0hRYiXaO9NKcMCgTg5Pd8KrnEkCrEroIw5nQcs82dwRj5DfCiTJ8ju9AzXwW25x0icPPUWOxEe7DytjA6itUHDJNPZTz6hKZktHyMVjfyJZkegMKeecIacJ8lAk7ppv6mX6DzKstWgnU4biAPt7kCZwQ5bMn3/dWMnhB2uTgFzPH3JhRZr0/BeGKQz0UPYvKDHm9xE6ZXNi4ZeiNf4DBWTohlfMG3SqtCv7wiWiXCAMNEcpec8NhWhS5DXGoW1OTxn0tBPyC1TiR2ZryRIIfS+I8LaeLV+KOTurHHqc/+CvIXuynDVIevvqvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAgBjLWkV7oHdA35f4ET93Ocl3k2rLGZEn+8xfR4iOY=;
 b=B8wZzpRXZJsxrFqO193Ts2ZjSrnSryTLJ2abvlnmIIAYic/0zoUETpJFECKEeV5w3HCDnXq04D9ze9qSR5nUsQthIGKTzojPaPlWAtZgukxogxnBGa8nmW8XBpWAeHBB/gbJyGMEQDy0dUgVYASCC1aUEqKBYQuFmsyd4sTs14E=
Received: from SJ0PR03CA0266.namprd03.prod.outlook.com (2603:10b6:a03:3a0::31)
 by DS7PR19MB6071.namprd19.prod.outlook.com (2603:10b6:8:82::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:13 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::79) by SJ0PR03CA0266.outlook.office365.com
 (2603:10b6:a03:3a0::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:12 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 4FB3B1DA;
	Tue,  7 Jan 2025 00:25:12 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:07 +0100
Subject: [PATCH v9 02/17] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-2-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=1631;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=wxYO2fuIGkvqmeC9PNGhH5rOX2Wls8HlW08RzezL2Zw=;
 b=B1IReqKRpfmf+1+csct4gaCWVicvG8oa01GHiOYfZkxMRKYayyYTG6qfyRRZEXxQx0LpfHdWQ
 RZsjf0YyfryArZoAKZrw9uWvN36wUREgLU1JzUp5ErODl3lKETRZToV
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|DS7PR19MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: 89319898-9d80-408c-68c8-08dd2eb1c084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?azlxTExzRURFdk5HV2t4YjMxT3hyZGtWWDFRSEJ5VEZVNFVrRmxIS09LdnA4?=
 =?utf-8?B?UGJvZ3N6cFpPd0twOGhDczhzRytQanBxbEIrRUY2ZUdZSTZHaTUvQjl1dVJj?=
 =?utf-8?B?MU1iTVBXZGcvYlByL05Mb2t2bTRodndzQWRMZm1EWkNvNENhYTQ5Q1hNaDZX?=
 =?utf-8?B?NFZLdXNHeXljdUNBQWtISnJ6T2Vpc2I1ZTZVUkFURzQ2VTZkOGFsME8yUmlG?=
 =?utf-8?B?aVZ6NjU0T2hYa2V5OVUzWS9JNFJpOGg4TUdnM0FWYjRmVlBCTHFXZjNsYmx2?=
 =?utf-8?B?QU5JNlhNTWlmeG1JTVJkbjVWZzB4Y25iaTdVZUhRdXZ0eUcxUVQ0KzZDM1J3?=
 =?utf-8?B?UFJoZ3V0MmVOQXFXbTlFRzJ3WjFXWWhQbVpYRlVqRTBGZ3YzVlVycjBxdGhk?=
 =?utf-8?B?bUZ2VzdFbGRPZUVnT21JeDAxajEvZERsS0NiLzZDR2Y5d0xjK0JsTzhqaExr?=
 =?utf-8?B?TEdqeXRJanJSeVBTc0xvUlY5cWIvQ2tFdlBUdjJsV0Q3RTdDcUJVVVlTYzEy?=
 =?utf-8?B?R0RnRU9nRlp6MzZZQURsZVhLYzZBTjVxUW5HZVovMHY4S014R3IvNDUvd2tR?=
 =?utf-8?B?NGJrRGlmcHNUaXBWdFJTSUEzdS9DTGNrbGZNZjZ3bHRaMlZPYURMTitrQ2li?=
 =?utf-8?B?cjR1c3UzY2JCcmtrc2ZleUZZZExLUURwVUIwUGJ3aFBQUCtmSTVuVys2MHQ0?=
 =?utf-8?B?Z1l4N1RaU3VubTZCMWZ2VHJCUlJuV2RoQThESWJ0QkFIbkhMSVlOV1pnclBh?=
 =?utf-8?B?MVQ2V0dhUnllK3JuR3hONGpPeEUrVFZIK2FsSnBWcGgrSHczR1lxbWZFUnly?=
 =?utf-8?B?STFzN2FPeWNZQlp5VG1LZVAzWDYvTTJuL1NhVHFMajlkNzhhc0VQQWZCK2o0?=
 =?utf-8?B?Z292UFMyc2lsN3RTaE4yak9UL2NrR3VpMzR6bGVhN25rS21sQXllQ3AvaFRL?=
 =?utf-8?B?K3hwZEFIZEZjcXd1Z2s0Z1VRd0wzZWM0SUFmbkZSdEZ4ZWMxQkFzbi9XMDk5?=
 =?utf-8?B?N0U1bEhZS2JjaDkzZUNWNEI1b2w3d3FPTC82cWZzMEI1ZEtiWHRjREd6NWk2?=
 =?utf-8?B?WTUvN0JTVGZmNGJkS3U5Ukd5MHhwMnloZTk5UjJVSkwwaVg1U0RleC8vOTFl?=
 =?utf-8?B?Wlp1QVFDd0R3Y0dlbDZQZzlWWkN3aFc2UWVRcHFDaGRmVVFVb1prRHdkWmYr?=
 =?utf-8?B?a1lFQmVwTG95NDMrc2RBcElHWmlIeXB2S01FeWF6MmNPcVF2TVNVTUlXQ1RJ?=
 =?utf-8?B?RExEdWFhRmxHWGEzeVhFL1o2UUpYazVhMGdCWkpXbWdWVXFIbEZvaU5EU090?=
 =?utf-8?B?K3JlRGtQeHJJbTIvNmZMbTkrc0x1VnRXSVQ0NHdEVUIvbXVKbWNSenI2dkhF?=
 =?utf-8?B?b085SzFmT1RhMEdBS0JWSHg2ZTFxdjI3cHpReFpkSWpPSE5sVTJoRU5INHI1?=
 =?utf-8?B?VVF2S2RmODBiWjdsVVdrTGl3Qy9sVmlQd1lOclphVTNiU2I4bmtHZEZqalBV?=
 =?utf-8?B?Zm1KM2Z6azNvTGJHNktEUlZkdmFTRUpHWFlxR1lKbFduR0FDNTNCVXNQd1Fz?=
 =?utf-8?B?Vm1RejlhMlVTTjV5dHBzcFFPSTQxc2ZzTzM4V0JnRUtqTXJyTnVGR00zMGly?=
 =?utf-8?B?bTUzOFdIUDVWR3ZIQ3VQMHBDSkVoRTlvdUt0UUY3WDlKZmxLbU1sb0h2T2NQ?=
 =?utf-8?B?QTZvcmJkYlJYMlFmZngwRndSV2NlT1Jrcld5RXNLalpteUEzQ0ZTeGIvWTdQ?=
 =?utf-8?B?UTZ1OXZUNlo4WXErZkdQQmRPNHA2UDMwNlp4VlAxeGF4Z0Vha1lqN1lXRVlx?=
 =?utf-8?B?YXowdjdyWjF3WFZEUGZYdE1mS1QzRWVjdVdzSS8xQTdxZXhVSU1lZkZhcDRk?=
 =?utf-8?B?T1BNOWw4bEJtL3VkbHkzTWh2RHNYNkFuaE5uYzZrWmNFSHZadmxFcXUwampK?=
 =?utf-8?B?VWNQN2syMmFPWERUSlprU0pKUnVsNENINmRaNXhyRDB3dVZ4VmpzSktzaEty?=
 =?utf-8?Q?8kd5DRGKK7qw4qmGsC7HbARkvuRKoY=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 MCWwkNgW/TNx75A5XS8H5xj+eSlJKnGTB2C24fSK3F+mUzaQeBA3Kn6eFr5BkUUA8yg8E4yg+BZSUxAZOMc0VpM5C7CoyjMeR72/AITC4b9XARJLzVBHDubqbcatMLHgf/lX7yAhW+Zd3vwgM+L0G7hDt9Dln4S1dyMDXql02XpLDnbfX/9VJCvGLi89fpdmcAOyEcTt+evPR+f36xTmHVgdxUAWLz7p6JYgQBGYQcH9g5D6T9B5NzwgGrXo7mFNZ8WWDqxyBKcKBfSvvP2IEjPXRuZh0iFks/j27fkY4NKxWi3cB6Hip0emwx7SQi0BPvlW8eSvnhXynLT5KC8Y5yh2BwT3jyhS393qcOhVvOyuc6rEB+yF71BL4jFhCoW4vFsoRukaZeYElYczE2XZWmMr46+4JJY8X6oOLsFMf/q5SHMtVV9MCWg7ixyZ3OrK6ArUr+ikOgZ89XTtALYjCZHRvBHuKeuYrN5nGhvO05noOmaAGl6ceqpts2DyMpH+8uiEu7W+CLBYM//VuZQGdasrJPA1LJF1fb5kiHFcdd1aBC/ShhkXAOnwv8iQeCvTYfVe2gbcPCvXS71kidt4ETjk6bKWR6plski4x1Kwsa1Xj4eLC7pm0u1EGtAgVq4ydeuf4lXnpFMOuU9FCfhQwQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:12.9376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89319898-9d80-408c-68c8-08dd2eb1c084
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB6071
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215141-105709-13550-20686-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.55.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoam5hZAVgZQMDXNwsDEwMg0KT
	k5zcw81dDQxNgi2SLZ3CjVwsQw0chAqTYWAMycoyBBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan8-252.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Another preparation patch, as this function will be needed by
fuse/dev.c and fuse/dev_uring.c.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 757f2c797d68aa217c0e120f6f16e4a24808ecae..3db3282bdac4613788ec8d6d29bfc56241086609 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -35,15 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static struct fuse_dev *fuse_get_dev(struct file *file)
-{
-	/*
-	 * Lockless access is OK, because file->private data is set
-	 * once during mount and is valid until the file is released.
-	 */
-	return READ_ONCE(file->private_data);
-}
-
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 4fcff2223fa60fbfb844a3f8e1252a523c4c01af..e7ea1b21c18204335c52406de5291f0c47d654f5 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,15 @@
 
 #include <linux/types.h>
 
+static inline struct fuse_dev *fuse_get_dev(struct file *file)
+{
+	/*
+	 * Lockless access is OK, because file->private data is set
+	 * once during mount and is valid until the file is released.
+	 */
+	return READ_ONCE(file->private_data);
+}
+
 void fuse_dev_end_requests(struct list_head *head);
 
 #endif

-- 
2.43.0


