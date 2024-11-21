Return-Path: <io-uring+bounces-4954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FFF9D569F
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA77F282CFC
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34BA2309AE;
	Fri, 22 Nov 2024 00:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="hiZhILI9"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C9F5680
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234615; cv=fail; b=ckD/s73d9q9z+Gq2umxw8/5UQw5mE0L+NoQetzUINp5fKfp23FcU0y8SvxrAs8badRFmr3aE0Qq/pF/DrOij2juNKzYWRuIZ/LJBgrd2Kiujl8XH5DjS7AxfkY4hkHtcifykWuiihaQyRUKmS8Ynjap5sdrX1vSVxFJMiubolsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234615; c=relaxed/simple;
	bh=2Luee4LJP7dDyAS7bu0Pq+sCS6Tayg+HsMqk/18uS2c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mQlGTV6nL5cETTP/KLlGaJiTTWhNDneyiJ1M/BfuvUMs5CZge4kfUT3u3VVzYrYURIEdC1ICYYc6o42oFb5XVr9Oq5nmzJ+FLcInzHGW2uPl+iqTYlWGXMPYRcaDVcHpoH16p8LCUquJuq8tNnfjvhwz+nTOwrzS8zLDCisM0gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=hiZhILI9; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170]) by mx-outbound47-71.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:16:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kV4Nxkog4PEIwhW8uuif0H03eCRnqC5EulijrETzJwhTt7F2hzlHzCRuArOZthnWYKbQ6X57sGKS2Qvmq52PekMWOb8rfXUwmNCDJzP4OcB9QhzvC8WWWBR0TNMVE1BVpRO6ivyPvBnJe7/1+O9AUoCw0HRYlIzKnzZJuy32Wg4+3SfqKN4Lb5HZukzl9yzOKJxeNLoKPkb8KccJ33J8f6pBHGUVVmx/tNtuhAVhDMRIGoC7TDBVhcDLmFC6gInCvhgcseyzpKQ9ZJ5UhN2qk5yWZFeY3wCPmCSsn21cRiiRK3KvB6W+NgBj6U+Wd8KJmhLGHSgpgpD5mMuZedLKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FC8P0EzozdIp8fFeo4tlulUzBMRxS4NMCTc9gKCnZvk=;
 b=oU7wX17F5KOEU22IHKgtaFWype8LKHhSS/QG2IhkM1nlR3h8tVmrNxWWdg64c5UmVD/4/rRfU8/0Ow4iSjtzPE1dUmjSjOf3KVsULQGcfUwooFNnGkMaUZGUYTZUUmCE6a1LC9ZnB1f4a/ieOqQ9bueI3AnjoFkggimw8Lw04K0kKSHdV5vsMSQLbpSB+onaiMlTHMC5rmMkfBo42IEUBGzChlcUdE16VrYiq85eyMbT6Xv6A3Dzjw/VBl2jmoBY3T94defwvlDZJ5uhOE73wIuziVeZ/lcUykithxMpkhGqUPfdfpXbyfEM6JnhAAQ6hBEdHKSbLZuPod0boBp5Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FC8P0EzozdIp8fFeo4tlulUzBMRxS4NMCTc9gKCnZvk=;
 b=hiZhILI9NLNnaRj28TwVXiYNyFYagRwQqGtKBXarsUEDgP9murEBm9cZC6pjV14WHZ10ok2foqsL0Lx/FYh5KlbETdLgSJdTqgxZbiPcyu/V/dyTOZDvwrAVAddUQZVev9LQEIgUNmwXSKog+pM4YVbrWL1PT5r0tiAvHxhEnn8=
Received: from BN9P221CA0029.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::27)
 by SA1PR19MB7087.namprd19.prod.outlook.com (2603:10b6:806:2b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Thu, 21 Nov
 2024 23:44:06 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:408:10a:cafe::9f) by BN9P221CA0029.outlook.office365.com
 (2603:10b6:408:10a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Thu, 21 Nov 2024 23:44:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:44:05 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 812CA2D;
	Thu, 21 Nov 2024 23:44:04 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:31 +0100
Subject: [PATCH RFC v6 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-15-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=10060;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=2Luee4LJP7dDyAS7bu0Pq+sCS6Tayg+HsMqk/18uS2c=;
 b=2VgyTA1IDBmL7v1AnjF44TmcI+9Dwi8cBHujzShH0UbjeSR4PJlvCsqo0yMCW+9AfWhHSz0yI
 nSZPwwfwaFIBl9fWemVq06CQoGH1pIZhN0oVraKRv8ph723ilUsxlii
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|SA1PR19MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: ec518bcc-920d-4c06-db16-08dd0a8662e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?YlIyMUYvZTNnVmFBbElmS2llbjJNS2Z6ZzJ5blU1emJnVVlkd1pQODNnUjBT?=
 =?utf-8?B?Q0taeHZNWGIyMG1aNnhIVjYyVzBhblFFeVYrM1ludjQrNWk2cGcwUW9yN2l4?=
 =?utf-8?B?RjZvZEF5U043Njg4emVha3VOWUpqY2RzSkExN1VCc2ZmM2lKWlZkV21GNTZz?=
 =?utf-8?B?VHV6R1hKTEg5cWhCUExYK0JyVkExZlFDaGZRSmg2MlFva2o3VmR4cVFZa25I?=
 =?utf-8?B?dWJCVncweFljdkdrZytyQU9oaEd5NUgvQlU0dG5EWjBPeTZ0UlFKWmtmdm5H?=
 =?utf-8?B?YlI1cTlXZEZYbmRhRVdDWitNQWFHLzZYd3JwcnJ2WGtFeUlnUFByOG1GTzVo?=
 =?utf-8?B?bktoSnMrK3FmQVBldnoxVnJNdjRXU1BIZGY0TjZCdkJrUVR4aUxlSFRqVkpo?=
 =?utf-8?B?L2ZVa2U1eEljdEYvRysydUwvdVRNd1h2L2JNdXFhcWhmd3ZpSzhtUS9wUHhu?=
 =?utf-8?B?UGdxQnZzT1Fob2IyajBORmlpcVI4U0ZkdUw3MEVmcEdaUGE3bWJ1TmFXbXlY?=
 =?utf-8?B?K0RpTGJrUkJ0eHJxd1hzQ0I3eFhNYUtESk4renF1eW92UVFrbW1wenJ2U3BI?=
 =?utf-8?B?akpqVzAxN0s5Wklmbi8yN1BGK1JlR29IbVRKeWdSOGo0bTBWMDBQY21wWHZs?=
 =?utf-8?B?VDJ4ZU9BQ2Q0OUMzZTYvSXN3UDl6RS9YUnNYZ25QRGp6MWViQ2RLYmZqL09u?=
 =?utf-8?B?OUVROUs0V0tPaDJIc0E2V0NuOHJVRFB1UzNEcGs5V0F6QkZ1RmlDek9jejl5?=
 =?utf-8?B?RHVjNUJJTllBTHZXNXBNbFEyM0ZsVmxFbXNNSytCYjZZYXVWUGlLbXJnTGV2?=
 =?utf-8?B?ZDNYWitqNHo4RjVaUXowblJ0TkVmaVJSYTNmOU9OL2hhTEhBTkoxanlKcFRa?=
 =?utf-8?B?bjE5M3BUZFJuUzJtTGYvMDBTb0Via0kwQU9yNmF4UzZOVnhidHQ2K1RZdi9G?=
 =?utf-8?B?aHIxbytPQU5ScEQwUGZEeXRvODdVWXV3WmZUS0VZeTlUaDFvbklyQ0hHeUND?=
 =?utf-8?B?L2pFY29BL3RhbUlEZ0ZXK1VNTFlUcE5iUi9DaVRXYVJqVkEvMG5QTHB2Wk5o?=
 =?utf-8?B?ZkFyWW0wWlN6bFJzMWI1b05PU05RdERZVGUyeGpjbFdOamYyM3RYa3lrY1R4?=
 =?utf-8?B?QjVveXJseWNLSkdpTkx6UTV3SHhFZ2dsdUZSL2tTVEVtdU5ybEZqV2Vmb2FF?=
 =?utf-8?B?bnlPaDE1aStudnpnNlQrQzkzZWR6T3J0TG9hRWZkb2swYkhqei9UK3V5bE9s?=
 =?utf-8?B?bDd1SHhITmRoMWw2MUlidlkzVDczL3RvT3Z0RU12K2Y1bVhPR1RaR09qM2VX?=
 =?utf-8?B?MzlFZUZIcXljRExOQmk0ZG5Bek9VWEcyNFRDdzFTa0tKbDg0MHJTMUw2TjF0?=
 =?utf-8?B?SVdDanNJYXp1dkFFS3p1bzRHNEYxeUEyeGp1WjhTcVdML0VaZTdKc3FHaG85?=
 =?utf-8?B?SnBxSHdTd3RNclVrN1ZnYndKb2Q1V21udDdaOHdZenI1N2plczdnODc4Z0F1?=
 =?utf-8?B?Y28zRUpNblVJNFNiMWYwRW1sT0JJK1VMTGtkd3lvY0RScVlMcjl0aVp4VzJK?=
 =?utf-8?B?NCtQNHUzbytZeTkyWUFxNFJ4WmlVVGVrcG1Rb1E2Wm1LWHNCZGR1NGVheTcr?=
 =?utf-8?B?anhFOVAwSGZDdmFPdkVHTEdzVWsyZWNGWFV6bmRJUm9FcEd1djlkeitJczZt?=
 =?utf-8?B?NytoRzhCNUVzcGxGSlcvV0hxM0VuREhDREUzdDgzMG8vam5PKzN4dE82M2d5?=
 =?utf-8?B?cUVVMHFscnowNEdjRmpUUDE1RFF3OXVrSFJhUWZiamFJU3lWcDcwRzVjMkRV?=
 =?utf-8?B?azV4bjR1bGd6UEF0cmMwTWZjSTAycnBqUjRkeEhlQ2lCSU9HcHdWZmhldG5h?=
 =?utf-8?B?REdPazdiWUhrd09wUzl0TGwzOUpEaFFuOWgwRHpuaHdTaXc9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 FqvvPrhHaNpnJMh6oxaNq9RFqwEuL0q9OjELF7mEnMz+5ypLnpo3GCxuvr9qpwg5q53wKNoo2r1jbpcl/7CXQgMOS3nx8kKJmzjOzxOhEPEvC0sxvanq46hhFqVSVHo5nOp60AbwbahHFtB2pKpATLIejhgfgpNhSQm9ctwrjWz8hoxEvVJ2IDmI87yhzEe49b0QAnAL65jODm6qBpsf0xu25meglrHfGwVQpDnITLTwr0EL3g8xUtgMivhjPaKq4V7+LFotADtICt94mk8Ttm+BrcD9iB0lqECNlsjS1z+ydJ3GAvauWEwKJXHtUx1fbObFHvwqYPKmCAkn81S3Gt5jX564qPCdPIOmqgMSwrFCaxFPF+7I6gqUF9NMYWWtFuLvVeehqTdvjHM6kjJaZixOtMfA5NgqbW1scJa3F5njlO3tlCTh6+cgbSW2FGx/CXEpc4h2JjTneT+RvZ/eshLB0GYHB9GcgGiOpeG5GW41BxVIOpN19wG8g9gfsJEnC17QANwyOTEUKIEH30DpS8RH2rDJ6TvkQF7qe3jSQwsi7FVS/BXfoMoD4xPNeZHUo4Kp24+8FzhGwCjmCuJ9LVRHGFWW/T4DWebG7RX+Sc9cbhAIpYkvbYt8MzXjGa4sfow7bzrEcQ2CHfN3YBot9A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:05.6329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec518bcc-920d-4c06-db16-08dd0a8662e7
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB7087
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234612-112103-13741-60790-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.57.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVpbmppZAVgZQ0MzAyMDIJNksNd
	XQyDgt2dA4xdQyycAoLTHF2NTC0NxYqTYWAOoQU0xBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan23-156.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

When the fuse-server terminates while the fuse-client or kernel
still has queued URING_CMDs, these commands retain references
to the struct file used by the fuse connection. This prevents
fuse_dev_release() from being invoked, resulting in a hung mount
point.

This patch addresses the issue by making queued URING_CMDs
cancelable, allowing fuse_dev_release() to proceed as expected
and preventing the mount point from hanging.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 103 ++++++++++++++++++++++++++++++++++++++++----------
 fs/fuse/dev_uring_i.h |  12 ++++++
 2 files changed, 94 insertions(+), 21 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index d0f8f0932e1715babebbc715c1846a5052419eb9..b7a6c3946611a9fdecd4996117b45b3081ad6edd 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -23,6 +23,7 @@ MODULE_PARM_DESC(enable_uring,
 
 struct fuse_uring_cmd_pdu {
 	struct fuse_ring_ent *ring_ent;
+	struct fuse_ring_queue *queue;
 };
 
 const struct fuse_iqueue_ops fuse_io_uring_ops;
@@ -221,6 +222,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
 	struct list_head *pq;
+	struct fuse_ring_ent *ent, *next;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
@@ -249,6 +251,12 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
 	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
+	INIT_LIST_HEAD(&queue->ent_released);
+
+	list_for_each_entry_safe(ent, next, &queue->ent_released, list) {
+		list_del_init(&ent->list);
+		kfree(ent);
+	}
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -281,8 +289,7 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
 /*
  * Release a request/entry on connection tear down
  */
-static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
-					 bool need_cmd_done)
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 {
 	struct fuse_ring_queue *queue = ent->queue;
 
@@ -292,7 +299,7 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
 	 */
 	lockdep_assert_not_held(&ent->queue->lock);
 
-	if (need_cmd_done) {
+	if (ent->need_cmd_done) {
 		pr_devel("qid=%d sending cmd_done\n", queue->qid);
 
 		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
@@ -302,8 +309,16 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
 	if (ent->fuse_req)
 		fuse_uring_stop_fuse_req_end(ent);
 
-	list_del_init(&ent->list);
-	kfree(ent);
+	/*
+	 * The entry must not be freed immediately, due to access of direct
+	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
+	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
+	 * and accesses entries without checking the list state first
+	 */
+	spin_lock(&queue->lock);
+	list_move(&ent->list, &queue->ent_released);
+	ent->state = FRRS_RELEASED;
+	spin_unlock(&queue->lock);
 }
 
 static void fuse_uring_stop_list_entries(struct list_head *head,
@@ -323,15 +338,15 @@ static void fuse_uring_stop_list_entries(struct list_head *head,
 			continue;
 		}
 
+		ent->need_cmd_done = ent->state != FRRS_USERSPACE;
+		ent->state = FRRS_TEARDOWN;
 		list_move(&ent->list, &to_teardown);
 	}
 	spin_unlock(&queue->lock);
 
 	/* no queue lock to avoid lock order issues */
 	list_for_each_entry_safe(ent, next, &to_teardown, list) {
-		bool need_cmd_done = ent->state != FRRS_USERSPACE;
-
-		fuse_uring_entry_teardown(ent, need_cmd_done);
+		fuse_uring_entry_teardown(ent);
 		queue_refs = atomic_dec_return(&ring->queue_refs);
 
 		if (WARN_ON_ONCE(queue_refs < 0))
@@ -442,6 +457,49 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on daemon termination
+ */
+static void fuse_uring_cancel(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags, struct fuse_conn *fc)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_queue *queue = pdu->queue;
+	struct fuse_ring_ent *ent = pdu->ring_ent;
+	bool need_cmd_done = false;
+
+	/*
+	 * direct access on ent - it must not be destructed as long as
+	 * IO_URING_F_CANCEL might come up
+	 */
+	spin_lock(&queue->lock);
+	if (ent->state == FRRS_WAIT) {
+		ent->state = FRRS_USERSPACE;
+		list_move(&ent->list, &queue->ent_in_userspace);
+		need_cmd_done = true;
+	}
+	spin_unlock(&queue->lock);
+
+	if (need_cmd_done)
+		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
+
+	/*
+	 * releasing the last entry should trigger fuse_dev_release() if
+	 * the daemon was terminated
+	 */
+}
+
+static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
+				      struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+	pdu->ring_ent = ring_ent;
+	pdu->queue = ring_ent->queue;
+
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -665,7 +723,8 @@ static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
  * Put a ring request onto hold, it is no longer used for now.
  */
 static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
-				 struct fuse_ring_queue *queue)
+				 struct fuse_ring_queue *queue,
+				 unsigned int issue_flags)
 	__must_hold(&queue->lock)
 {
 	struct fuse_ring *ring = queue->ring;
@@ -682,6 +741,7 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 		return;
 	}
 
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
 	list_move(&ring_ent->list, &queue->ent_avail_queue);
 
 	ring_ent->state = FRRS_WAIT;
@@ -789,7 +849,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
  * Get the next fuse req and send it
  */
 static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
-				    struct fuse_ring_queue *queue)
+				    struct fuse_ring_queue *queue,
+				    unsigned int issue_flags)
 {
 	int has_next, err;
 	int prev_state = ring_ent->state;
@@ -798,7 +859,7 @@ static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
 		spin_lock(&queue->lock);
 		has_next = fuse_uring_ent_assign_req(ring_ent);
 		if (!has_next) {
-			fuse_uring_ent_avail(ring_ent, queue);
+			fuse_uring_ent_avail(ring_ent, queue, issue_flags);
 			spin_unlock(&queue->lock);
 			break; /* no request left */
 		}
@@ -873,7 +934,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	fuse_uring_next_fuse_req(ring_ent, queue);
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
 	return 0;
 }
 
@@ -915,7 +976,7 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
-	fuse_uring_ent_avail(ring_ent, queue);
+	fuse_uring_ent_avail(ring_ent, queue, issue_flags);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
 
@@ -1085,6 +1146,11 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (fc->aborted)
 		return err;
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags, fc);
+		return 0;
+	}
+
 	switch (cmd_op) {
 	case FUSE_URING_REQ_FETCH:
 		err = fuse_uring_fetch(cmd, issue_flags, fc);
@@ -1142,7 +1208,7 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	return;
 err:
-	fuse_uring_next_fuse_req(ring_ent, queue);
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
 }
 
 static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
@@ -1197,14 +1263,11 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 
 	if (ring_ent) {
 		struct io_uring_cmd *cmd = ring_ent->cmd;
-		struct fuse_uring_cmd_pdu *pdu =
-			(struct fuse_uring_cmd_pdu *)cmd->pdu;
-
 		err = -EIO;
 		if (WARN_ON_ONCE(ring_ent->state != FRRS_FUSE_REQ))
 			goto err;
 
-		pdu->ring_ent = ring_ent;
+		/* pdu already set by preparing IO_URING_F_CANCEL */
 		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
 	}
 
@@ -1257,12 +1320,10 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 				       list);
 	if (ring_ent && req) {
 		struct io_uring_cmd *cmd = ring_ent->cmd;
-		struct fuse_uring_cmd_pdu *pdu =
-			(struct fuse_uring_cmd_pdu *)cmd->pdu;
 
 		fuse_uring_add_req_to_ring_ent(ring_ent, req);
 
-		pdu->ring_ent = ring_ent;
+		/* pdu already set by preparing IO_URING_F_CANCEL */
 		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
 	}
 	spin_unlock(&queue->lock);
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 8426337361c72a30dca8f6fd9012ea3827160091..6af7754249623102f48a4c5c924a21b20851925f 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -28,6 +28,12 @@ enum fuse_ring_req_state {
 
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
+
+	/* The ring entry is in teardown */
+	FRRS_TEARDOWN,
+
+	/* The ring entry is released, but not freed yet */
+	FRRS_RELEASED,
 };
 
 /** A fuse ring entry, part of the ring queue */
@@ -52,6 +58,9 @@ struct fuse_ring_ent {
 	 */
 	unsigned int state;
 
+	/* The entry needs io_uring_cmd_done for teardown */
+	unsigned int need_cmd_done;
+
 	struct fuse_req *fuse_req;
 };
 
@@ -84,6 +93,9 @@ struct fuse_ring_queue {
 	/* entries in userspace */
 	struct list_head ent_in_userspace;
 
+	/* entries that are released */
+	struct list_head ent_released;
+
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 

-- 
2.43.0


