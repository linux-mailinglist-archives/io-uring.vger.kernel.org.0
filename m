Return-Path: <io-uring+bounces-6070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E03A1A625
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD301888448
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E18E212B1A;
	Thu, 23 Jan 2025 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="08CXqHHm"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0414620FAB7;
	Thu, 23 Jan 2025 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643902; cv=fail; b=HBv06sJOds3P4mhn94Q8sz+d0jcXLRVkb3Dw8HfGI2hqeIgZm6lft/BOOsiT4TdEbSdOb5O7L3/y0udUQ+xU9+YwZ3qQoagw+59JadLswRlLWJQzqDkXKbkilsjFVeNklzmT5CfQDuAeGVu3cdm6VOcroW16MxQSy+MrBhbB3Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643902; c=relaxed/simple;
	bh=tRNVQ5go8kvTNyzhroZRIZbqhPCa4//8Pg8Fhd25zLk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JugFkp21J5AhkbkD04RAPdKmx+gIWNbeZDxGsmpzctWKqiP+Gn4C5U2GLQ02LyJsZgJuOf7XQPT+SN6h1zwGiPBQSfgvX7nag1p1BUlOt0w86xmg03V3p3Cqei6GS2CsmdM+zeYkCHu0YM7vcK3Ku7YQHMyHIQMvZLGglpVq1zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=08CXqHHm; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169]) by mx-outbound17-87.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FULEK4iBQ48Piph3wt69ICl3KpY33MhJe6EIIqpNWrTGb2YUDd0w6midws86hChQfexw10im0JbxBOYEsiiymwRV7xSXkpEZKRLFvVMWfvF3t2pXr0SARKguUJvgfIczYwnwdOvibkcCAot52z7P5WXtVkaD4sb5FHyh++B+6ipph9PkomANq08Za7fc1Dn9EiGBDAiWC+NqbbkomTmyMaPrppK0FTW2HuLbe2lyugjDhMaRSjGEYbIZNpcrYuurbYVKe1Q6MWFWQr2+QY9bjkeT5ipQBMMWDY8RZo7M5xMzPsNnJOVg1PAKMQWor0lgs+Kmrc7PZP/PwyMEQbmLHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fU594p3fb+5uVgkprJVJk58r07ogeJDVdcBfEbEavMQ=;
 b=gfbgfQQqtANxiYGpnD1wajRT5kMbbjIlGJLjWud6OQ49PPy53SiYBNB0zg5kAMWa0gKuwj6PCZrHTQLDDchXHN8HLHMKarS/uZhFt85FzKJGIZGu0FenRwWHHl2BHrS9HsBH1zydrnN3ykYlMAlDX1LkchE+cicV8wEaJzicO/rB30sGaJ6t1KQxY6WOcGfH5DBcmVDFxCxqZm0p1XHK+YK7iJPnWl9n/pEmmvc3N8kRTXI43b1NyndM4+lHadMCnUA2iOOhTH/+CZ8pY5rUKXoBfMplVO4kEWZyR+oaZWYW+By/DxWHBsXaB8LBaW/kZniVh6eD2MZkRraor5cXxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fU594p3fb+5uVgkprJVJk58r07ogeJDVdcBfEbEavMQ=;
 b=08CXqHHmeXuJZoIZyetSLyCkDNIN5bI/P9XCUh0cgOff89morvGdnkneLj4yNPCnBbJlqqH4euk3Xxhq7xUZo8sBIrkq2cEnfkaQkjCee690+qeEDmC2kEwwwfFWvdjUvr3THj97N0cdEimgWRnq29sLD2hq6oBiJfwcWFBCPmA=
Received: from BY3PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:39b::26)
 by MW4PR19MB5591.namprd19.prod.outlook.com (2603:10b6:303:16b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Thu, 23 Jan
 2025 14:51:16 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::ce) by BY3PR05CA0051.outlook.office365.com
 (2603:10b6:a03:39b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:15 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 1C79658;
	Thu, 23 Jan 2025 14:51:14 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:02 +0100
Subject: [PATCH v11 03/18] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-3-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=1423;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=tRNVQ5go8kvTNyzhroZRIZbqhPCa4//8Pg8Fhd25zLk=;
 b=bEduAQbubWk80hmalafVW3HqFx9chk1Ic06c51scdNhgrrTL0whZlR7iygi9Y6XY3S4iLnT0l
 zadTjQKjsX5DtmRbPYNJGORxntnYbo1Q3dOqp+Z1s8Oel/xRT1ft1Li
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|MW4PR19MB5591:EE_
X-MS-Office365-Filtering-Correlation-Id: 614a283b-d7f4-4268-615e-08dd3bbd6379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzdqZVRlOGhwRWtIRzFFSEhpTGczOUl4NlNjUXZlekFwc1cwajRjSjZlVDE2?=
 =?utf-8?B?SnZTU1N1dXYzMmhxSzJsUko0UEU3ZUpFRFN6QURZQTYrMDZOcWozTW1zck1o?=
 =?utf-8?B?TnB4ZGNCaDdrUE10emVESUFhdXc2NkZUUGxhWXhYV0JYSG9EOTVlS0o0a3hI?=
 =?utf-8?B?QUpsYVhVSzFDWVhyOGFiN0pNSnUzN0JrZmw2d3ZIdkJYV2tNMWVJT3ZXaStl?=
 =?utf-8?B?VS9qcHVzSGJ0T0ExNnQxZFdicmo0MXl6TVJZVzRYOFdYVTlIckd1VmdvM0tn?=
 =?utf-8?B?T0FyMTJrbE5Wc2UzVlVzQzluV1BxZG8rVGtDZmVvTHpacGpFc3JGNy82KytO?=
 =?utf-8?B?RkhFdlpCcFhINnpQMnBOazVxMlRIb3NLeTMyMFRZWjJEL3AvQzNXTVJzY0RO?=
 =?utf-8?B?SFRkV1JTTkR1ZkxTeTk0THFPTTV3YmxDS0NhVmJoaVRSeFlhSHdHMlJEREx2?=
 =?utf-8?B?dkV1b3NGREJ3L0JKanc3MHkyNENjV1hKWWlHNklUbnVtY1BUZDI0T3pyY0Rw?=
 =?utf-8?B?TDA3RmVUamUxY1d5Slhlby9NbHBiaFk5TC9WR2hhcm5haGVyck9MVzNRQlJ0?=
 =?utf-8?B?TlN1MDVzWGczTWY0a1NqOVB6emhqRzlIaEdWS3Z6d0MxRG4ycFJaRXV2U0hk?=
 =?utf-8?B?WWVqZHFGQXY5aGM3Z1hpLzgzTEQycGhRNHc1OWpyT0RZaDN6VXJqekZkUkQy?=
 =?utf-8?B?M3NaSzJvRy9jZlVIVzJtd3NkRlh3Ni9ybmlVd0pReVNDNjNiR3ZQKzRaNXFS?=
 =?utf-8?B?Mk44V2ZubTNxbVMrMkY2ck9sL1AwejN3clRMUEF0R0NaOGpaSlBTTkNPSWZN?=
 =?utf-8?B?Y0h3RXZ2Nzc4QjV4b09kdzBFUGtGcmE4blVmeXl3TFg0UkJXTS9iNmEzU0RZ?=
 =?utf-8?B?RUQxQUdYbzVWVUNiSmxYNWdWOUdLcit5TkNNNU9vUTByWHBaVE5zRnNWd2J0?=
 =?utf-8?B?YkJVU1NhTVNiM1JxWFJSRzlLOUg0U1QyeUorc0JrTTZyQ0l5WkZmKzZ1c0Ev?=
 =?utf-8?B?YVN5SWY0RmZkVzhISjJiMVFmd0swUWFnZmVya09IMy9FT24vOWplaDNtSVVD?=
 =?utf-8?B?Ty9oTFlqU1VaM05PVjV2Wkh0N1BHZHFDdFE1aGl3MEtrRy9HZzdjSGZLQTRT?=
 =?utf-8?B?aVhqZ0hBOGwxRFBWLzZaNHhVa2k4L3krOHFkbHAxWnpVWThpek94WHNuVHZi?=
 =?utf-8?B?cy80YnBCWnZGcGhmQVl1azVVcEtUWDNKZThncUxMQnpBWmJZQmhyOXpmSkhs?=
 =?utf-8?B?ZFVtcW9kODRKeXBXbjJ3ZjYwSHp1RmVnUlRhN3N2RjFrOG5VeXFTVWxMWG9J?=
 =?utf-8?B?VTIwemNTNDFWSXIxR2VmUkpKWFQxakxnOFFMaHlhL1lTRUt2VmR5RHhqNUFq?=
 =?utf-8?B?Q05KemtGYzBNYnNzUlZuaU04czJrTDV3d0huK3dESnZ1K3dGVzk1MWpFdUQr?=
 =?utf-8?B?WjA5SVBEZndBREdIY09JQVlwL0pORWRqUS9jYUJlRzdkeFFmN1F2anBwdmZ2?=
 =?utf-8?B?Z25OeHVQdVBXdG9ERHovL2o1bnBKcUdrVVNmSjhNd2t0N01aaEhvYTFPcHhn?=
 =?utf-8?B?bjNWR2dRamJNVWg4eVp1Vi94dGtsMXZ6ZjhGU25WMWtjRkdJdFpscDY2eUpX?=
 =?utf-8?B?aVFhSmlOMFhMRFB1L1EySFFySnNtNGdPdU9Qa2tQSDFiVnVDYVNTcHB4K1Rr?=
 =?utf-8?B?RzAxRUxxRFk2WFJpcEE2TXNRU2wwNzRBMXF6OHZpRDFSWHlCWjBQYWl4MEp5?=
 =?utf-8?B?Nkc2bEx1OEhMYzdNOTNOWC9HNy93LzBya3h0bU95RldNcFU5NHJFOURnQTRU?=
 =?utf-8?B?MlpRV1paQ1J0dGh6REZPM0FRVURDbStRVEwwczdCUGQxR3ZKdG5CR1RMbE8r?=
 =?utf-8?B?V0R3WTdzYlFtRy9NYnh0UWJrNHVrMkNMdmtBYU90NTJjRTVNQnJ0VjQ0WmVj?=
 =?utf-8?B?ZDFEaUVVRTZyYVBFNStpdE1Nb2dlNS9OSzFZQlhLQzBhYkJmYzBYcEZLTHFL?=
 =?utf-8?Q?ggDc6R1oR0aWcA5MCAfsUvr7+mDCvs=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NoNpKBw6KBs905gZ/w/CNqMapx+gsdu4h4Phg5A8tcDRMuN1N6vROwLA9Zbu5ZGyCyMalEXqx/dcOUNPPjjcgxoeLtysLnVd2VcNdKgw0dfJwy0rh+7sv5EcrXQEoceR82A5XrXBl+EYdCMXW0DHWzFiIAXukfG2Ngct1NIMilUcgR9uasjzlPQMKuq5rd2qAakj3vcfPq8l5HSRSHc/T2vldAQjTQM1BXLdEyvfjdhVtcOBu09o1DldjnCxoguNZRY+YrkP4Rkai8Un9PT+bBcblm6etQekTd0M5zdtVl8dEdLpRPRR2cahCySFFvxUWZNDZYFhFHV/R9ST7PTp+sw57sOFFZsscIKY58n3uIKTbZzoRHVaSHWdOrmtTmxX+kFV66hL/l8x3HvYSYzJOftbFCWYQtnX9AeYvJt8S8wB1IKZ/AMNw83oPja725fNv3IbIUfenTDHHo02DQeJLskr5EnzpXLrU0JHBw3GYj2633+ZmixqNWx/Ptuf3WG8+jE+ILczNfSmykzF06VL4bOyD7Y8b3kSV8VYjV58mI3EiIjQ1osP0LjRD82xqB7aiZDOgbv1IQOIGs2SwlhxdaQxI0/wmEZd2xwlXJcQpUgAvQXVbO4STUcQ6LHhNBQXaDPwI5h4F3SNMmPNriiBEg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:15.9297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 614a283b-d7f4-4268-615e-08dd3bbd6379
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB5591
X-BESS-ID: 1737643879-104439-13387-14049-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.73.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGFgZAVgZQ0DjN1DA1zTAtxS
	TZwCTNzNwy0cLCxMIg2dTA3NAgzcJcqTYWABStzHtBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan10-242.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These are needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3db3282bdac4613788ec8d6d29bfc56241086609..4f8825de9e05b9ffd291ac5bff747a10a70df0b4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -29,10 +29,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e7ea1b21c18204335c52406de5291f0c47d654f5..08a7e88e002773fcd18c25a229c7aa6450831401 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


