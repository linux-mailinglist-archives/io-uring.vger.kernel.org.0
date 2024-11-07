Return-Path: <io-uring+bounces-4545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E659C0C8F
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 682DD2826AB
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EC12178F2;
	Thu,  7 Nov 2024 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="W19WHX96"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA79B2170C2;
	Thu,  7 Nov 2024 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999096; cv=fail; b=Fpu/eZahhFCsmV90s9eqngyAkx5/xOnR72T2VweXdI4VYXIBbdyZ5Stz3iA2Ub+sm4frPJvQhGXIu0vAP7a+YZAqUJ7Ya3HtA8cbNMbFno2WhBbDka5LzuLVWbRw1Ly/0WN5LX/gnmPftwUZvOFw3CNWFxPfspjcBw+9Kj+GzlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999096; c=relaxed/simple;
	bh=kxd7WZI62yzyG8I2jj0Qg1Mf0LWeh2pb5fEjZ+QpxYc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XVjT3xwHvkT7Z8gK8cLWoH4U5r3DD26YXA3fxFSS4LUhVI3psUZt5kwZTzeo4nQ+tZHYiMQJXmj8Am24Isl3chjg5AV+/H4IxVF/UqwojopOzq7pNNJRBVdytbT24s04TWtJgXoqWBAFzMLV/1XS+rE9kTdo7A0A3/k6gruNpsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=W19WHX96; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174]) by mx-outbound8-74.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/XVCEyyyP+ofTnjN8u/5XhDPQjwds35vR8I/jzegRVJYcg8+01wNPXJ38WlJLPsx83Uw+TnQE+YwJd/nBVSVl8VCUEtzadS/amr8zHKvqi7M7T01swGHYcqn++3ei7VBpvUqL0WVGKNefUfg5w/eAYLSu8psx/5bkhKIL8MQVjQu8CftRF1J5JFI+sTVK/zvVq6F6cj7snZMTxSNbfqhRwg9fM9saupTjEzXhrDQaEb47PEWAgeRDbMLwaYmOQyXwwZAXI+x7vA25mOrQ6/JIBhrEHzPTe5ARaZpW2Qe3jGc3WeuM+PLXT8aShDi7dW4pud+GpRx/1kz3NK4qSreg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcIGYKzNIixd5dmjaCE4zhPOtcctg7hqHSHo7mkIorA=;
 b=ToeIE8rGHMAT4XtLdUmgM6+uyS82ZAp7+5+0xNnWEjmZtZrepIhNXvHkiAnjZSWY1wpBuzAVAhDIcXc0vcb5ckZOfk0WBF7FzERGVWp0GDN06G0drFX5vfzbOI6bXfAnyAk2CZk4uBhJ7nhu3h/Kp2VjmhcASUv2PBO3ZaJ5I8LSkmeOURR9VFZAf2NHAFbc9lsh3xsIDQHNEXvBo8i1fYRxDhqwXOzPua/5nmJ2axQSFN+2Hyiw04wKH5wNY7rvYKXYIaPENfAFA1lMgvOAtJyvQ8lJTl4Gu5OFl91TktZUSVSaVljMJeulC5sSNBUk4g57+ttscDKcxRRwJM0jfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcIGYKzNIixd5dmjaCE4zhPOtcctg7hqHSHo7mkIorA=;
 b=W19WHX96f+LX4qfZ+3QbszLX41iw9Rc4fYm7kOSGEXOTj7VDNltgE8+/c8c6ISYdKLr8m2RfFoAQTh3m528JkCR6TAFMSusuBDXI456D+7v221YvbE6dAKQ6KLeeTcqSug3Do9evd9u/FGjE4iVNqa43Jgk2sMkvULYEqGhpCHA=
Received: from MW4PR03CA0257.namprd03.prod.outlook.com (2603:10b6:303:b4::22)
 by IA3PR19MB8708.namprd19.prod.outlook.com (2603:10b6:208:516::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Thu, 7 Nov
 2024 17:04:14 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:303:b4:cafe::30) by MW4PR03CA0257.outlook.office365.com
 (2603:10b6:303:b4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:14 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 44240C6;
	Thu,  7 Nov 2024 17:04:13 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:47 +0100
Subject: [PATCH RFC v5 03/16] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-3-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=1326;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=kxd7WZI62yzyG8I2jj0Qg1Mf0LWeh2pb5fEjZ+QpxYc=;
 b=igczCXxA6W67b8Tdytsic/uThPq6paPKlLPRcy/+Dx/5JJ7J2jZQCK5MKGqjFoxUfYI2mdmR2
 ZR2NCpswOF/A2gFznwI24PZIwQUdyNviT5ka9ojY7L895/cO6sN7R1r
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|IA3PR19MB8708:EE_
X-MS-Office365-Filtering-Correlation-Id: e134b788-72a3-4d1a-b96f-08dcff4e34f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmIxYk45OFBxenBNWXV1T0hWUnVYMUZrR0tBWFphbXkwV2lzV0VtSjE4b0Ra?=
 =?utf-8?B?eThQSnByOC9rZ0YvVFV6ZXQ2MG9oNlhiU2dMbWt2ZDQyUWk1WEQ5RG1SL2Zx?=
 =?utf-8?B?Wk5iYi90T01RNUcrSXg5UGZCQzBobXFJNWwrNjQ2bUFBV2Vyb2VNakZSenNn?=
 =?utf-8?B?SGhQWlRnenpBZzhyRkdQT2kvdW0wUk13UThucFZRUzQ0ckNnanZjak05VDF0?=
 =?utf-8?B?QkdYUThaVVF3WVJlL3hJc0kybWJyNXpHMmYxMUw5SzQyUzBFOFRISG84Zm9L?=
 =?utf-8?B?VFJjMTFJb3RNeFRYREROQlBaeW52WUdEREQ5UTBFYmgxVjlwVDh5WloxclYw?=
 =?utf-8?B?UkFrUEVlNDZ3TmJXU2Z2czRVczhtUnIrRktsNXpRbWNlRVptUVhSRlFaRWJX?=
 =?utf-8?B?c2JnNE1ZdmFQSmcwd3hUb0hud0xJZmNuYXVXYlVxWTQwVkRmWUlCMHFIMFRz?=
 =?utf-8?B?eFNmRHhSVk9RWkhlUmZyMWYyVHZuNjRhV09mdXF1ajFTWXVFK1ZzczhQNkcz?=
 =?utf-8?B?d0NROVVLa1k3TWt5TkVsclc3YnhrRk9UN3gxaG81Sm5UMUMza25lMlRuVS9D?=
 =?utf-8?B?NVVxZ1I3eDgwczNBTWpWMjVEeWd3a2Jndkk5M1N6Tm0ya3FJaXVpV2hNMXE4?=
 =?utf-8?B?c0JUaEJQOGZ0WWp2VlhiWDZxV2JTRTZwS1FMS2FZTFFCeEdpRU9lUlJ4dFJB?=
 =?utf-8?B?WkhiMmtIZXR6RkdweDZnYmc0MzFzKytVbkhGYUkzUllxRkhFMzY0ejJKNThR?=
 =?utf-8?B?Qlk4QlNJcnc5OVRiVjkraWRmOHBxUjJpaTFwSmFGSGhORmx0R010akJ5dlFQ?=
 =?utf-8?B?MjE3cldRN0hRcHZNV2twNmFEb2RYU1FvQUJ2Q0JpNjZFNUN5S3lnSUV3NStt?=
 =?utf-8?B?Vmd0WVZRMElXSko3ZW02eDFaVWhaMXo3TVlIMHFYOUtOaEFmdFlLWGUxL3hZ?=
 =?utf-8?B?VUY2aWlOdFJTTDNDYmdpLzQxSW9SVUJwNHU0OTVrcTBLemFYZ0c2a0VoTFJk?=
 =?utf-8?B?THY2MXdBQVlHMzBOVk1Kb1d4RERyTUlqVTNtVUJMNFpRNzR1YkdqNnNSTGNw?=
 =?utf-8?B?bnBDNjUyNDExY2lPU2FHalBoY2NWSjA2R1dIbVNOOXRSNjZkaHZiK3JmMUpy?=
 =?utf-8?B?WnBjMjFWcTNNSk5TamlzYWxYaTJyYUNod1poUEdndzJFRjd4aWhXcmo5WHk3?=
 =?utf-8?B?ZlJnSWYyVzlNUzVqWGlsY1FtQVZraU9sVktLNWpKN1ViNnFvYlExRlFpejRK?=
 =?utf-8?B?WGxLMlpUbUwwMmlzMlFVM09NZ2RqN2tINEhTVWY5elVBbkdzYTA4UWVkOVll?=
 =?utf-8?B?RXJCKzRqaDVsVGxZeFVtVU9sbHA2Vnp3UStjS2dacWx4UWpnSUxXNEZidGY2?=
 =?utf-8?B?TkoxcHN5Q0Nna05pTmR4R1dnQ2FSWFRPaEtUMkdBWlVKZUlqWGc4dEY2UWRn?=
 =?utf-8?B?d002aUxBZkNwMkR4M3Q1T2hTVVlxcGpFV3Y1VWRrdWFib2k0YnJEU3M4c0s0?=
 =?utf-8?B?cU1FdmxUUW43Z0NGVy94ZFZNRUJ3MUxCekxMa2ZtcUIvTjJndThpd0xGbktl?=
 =?utf-8?B?WmJyaEphWTRQTFJBcHduQ1ZZdlIyUVNmeTh4YkRGaWpYNlY2QWJsUXZNWmYy?=
 =?utf-8?B?WlhFQk9LMzkyOE13aERCRzJmM0h0bTVsN24xZGp1Qk96d3JLWFVGQWoxTCtm?=
 =?utf-8?B?MnV4THZ1WWEvM1I0dnVWR2lqeXMzOFFibVduY1c4Mm5MUXE1d2N1MENVYnJp?=
 =?utf-8?B?andGenBLR1VIeWM3Z0IrRkN0Z2Z4L3E3cURWWWRPWGt2NzRDNEsxSmM1ZUM0?=
 =?utf-8?B?dmF4VEVXWU1VOGh3MmV5UzYvQjFYd3dQSDJLWkp5OEtqdVdFL2NxekRlWks1?=
 =?utf-8?B?dGx1YzdCSDdmNWhsVTZQV1FaOThUT0hzUjlNVDBRRnRpNVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pLuCOWuBH/7yrknc8xYCcPXq8VSeIZYFNOQHC6nFA98gQpvh5JM7QljpNWHXeYIig5nw7pfMu8QpjlvQSkJrsR6y62GUj3RgsOoM9wgvD6ykt3pbrNv24w9F1PTMdXFz4gjHAf734otwrk20mGr1VDZrapM/gVgFuiPk3Iun6zHIghqvRkS5Ardmf6ycWZLD37y6Ys1LCHRmztRVjRynM6JQXSokYixwNEXKLjRdNS6u7eNVfcOd6aSbit/8hWvjxzfudExfgaqKgQOvlMPoGsiYyy0xXciXgFHLGatG5HVMa0BNQ6etpC0tDnAfeNj/XGBrY9s6sN/Nq/4loh/jKrG3pK952mvHTINhOqigb+TXbMEThQeR7UYsxqJREhZmWkGU53aJeWciNs6+Ddrv2k+pYMBt1a4mz6QVQvJpxGVZSYlQtbvjn2lIbuAhbtyhm/EUlj10JI4aIZ0hjNXEsumUd8DgbvCLbZGwWEh1Ku+rAfVP2YHb9pRHaJ/p2hgOma+zBozYbSyF6TFliKeCFbt9QsDgYBpHk73NQW0LvBJencA+g4I2Lm3ipuAqQIgwYIXQDbY6SHO5o15g3mNsb5N5b0euLDIHqXMQebrlC+EoVm3XiTgFT1Nkm7cRH737Zg20iRLRhcX/AXqPsUpEdA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:14.0143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e134b788-72a3-4d1a-b96f-08dcff4e34f9
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR19MB8708
X-BESS-ID: 1730999061-102122-12672-29984-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.58.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGFqZAVgZQMMXEONEwJdkkxd
	LMyDTZ2MTE1Mws1dQ01TTZyNzMKNlAqTYWAFfTRnhBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan16-55.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These are needed by dev_uring functions as well

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9ac69fd2cead0d1fe062dc3405a7dedcd1d36691..dbc222f9b0f0e590ce3ef83077e6b4cff03cff65 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -26,10 +26,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index b38e67b3f889f3fa08f7279e3309cde908527146..6c506f040d5fb57dae746880c657a95637ac50ce 100644
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


