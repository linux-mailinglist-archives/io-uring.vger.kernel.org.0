Return-Path: <io-uring+bounces-6007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB23A164E6
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CE841886AA1
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68B4DDC5;
	Mon, 20 Jan 2025 01:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="FxYoBaDX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1F17BBF;
	Mon, 20 Jan 2025 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336571; cv=fail; b=dwbQjcpyq3aHXGbN5wgMlhx8mq3v87h6HieFB0qfaVmzdZtI9AJXgUPWpefkcOY3jgCR8PN1c6hnlUf/wuUWpgpolxvqkrT7utZJI2f+WphykhZ9m3lT3ZivIKubFIXq4/c0NM3Eeuszu3wPDy/2JgAoyn2zbCDP8wDcAM5kA8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336571; c=relaxed/simple;
	bh=wxYO2fuIGkvqmeC9PNGhH5rOX2Wls8HlW08RzezL2Zw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FcJmjayDfBupWbGNB6C9pLtA0IZCiUu1OS90drvMAsJ23wTQ2pLP7t76dfkDIk/8EUHHsjoA+mwr/fJr61RwVzJsAL+FI5OqBWigCWMPpevKRCMprTLUf+MlUKCh07GO4/0BytEOkZMFbfuzl8tYxAL9TGOBSUf+PFnS1L5lcIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=FxYoBaDX; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43]) by mx-outbound23-227.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9qsWd2jf1+YX0gSOlz1VYwLYXF0Yg2NJTNPH4BiG+IWOE9xDwJ4hDOMxsrJA4DoGkV08smwDuO0Iy04t414DQEZBAhTCf3cIUxEfrqB4RIR6N4Oj2EXyHrGiooVGam2OWbo5UNlSP7KEYbATFPg244CjWQDSLPHpddckQHpcJB7vODhwbchztk6jH5DSQKSPpGViL6qdiBXM7ORPPp1xfqWwNJSCOdhXwlNivEJnTNTC7+YvO5Hra6a6cxk0nNP9EHSoTXPFRuHvE7kfB7vy/ttc5DEQCJ9OzhkPFgTXMWZeuyQ9cw6srir+JYmNwfCCEacPm4TLj2SE7zvBdDXMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAgBjLWkV7oHdA35f4ET93Ocl3k2rLGZEn+8xfR4iOY=;
 b=UyRENuGBoZ5OB/Q/gThaVRbf1dq+F8gDQm77sKfBTswSF8AK2Nn0GM67PEf51QOykiDA7Xac5nFSO/LDJ1xfb7ewYwd7X+AXDRH4REkvic79CWasXQsCzXzrA50zGR+UtIlr9/5ePHcdg9WQbcwtQ1eHcddRm9G4oHf5qncfGE6haCjRirqwnHRoS14rqdVweDtwxidk9wt3PL+Xen/E6GFJ4J6OS8u/ermLByAzr3KPVqjb6BzAyv4BZaIJc1cRKXLN3Bb33XPT82PlO+TLTa8oarDSfURNg+2yLUj1OBJyp8tPwiRzEfTasQqlTAP+nzzJNvboyrDPH60fmZLkdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAgBjLWkV7oHdA35f4ET93Ocl3k2rLGZEn+8xfR4iOY=;
 b=FxYoBaDX+dciVY2H7ZNnhrkrQyUsnbgU/82fR3mlPDY9F9O3nrgEL06P1ErwWi3UScM1MMs90Zu88FQfL94gETwxvAyzHxTLc5vOZVTs0IAnp2qR7KayXVQgOqp0u6Iv6OI4hzUx45EowBy/AMeeFMXnivXRLVxO3em2j0GHdwQ=
Received: from BN9PR03CA0876.namprd03.prod.outlook.com (2603:10b6:408:13c::11)
 by CO1PR19MB4981.namprd19.prod.outlook.com (2603:10b6:303:d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 01:29:05 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:408:13c:cafe::b7) by BN9PR03CA0876.outlook.office365.com
 (2603:10b6:408:13c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.17 via Frontend Transport; Mon,
 20 Jan 2025 01:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:04 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id C3C4B34;
	Mon, 20 Jan 2025 01:29:03 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:28:55 +0100
Subject: [PATCH v10 02/17] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-2-ca7c5d1007c0@ddn.com>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=1631;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=wxYO2fuIGkvqmeC9PNGhH5rOX2Wls8HlW08RzezL2Zw=;
 b=Lnz40p853xfFVldiMhE5s2BuVOY08WK61NAfyWpHGObnO0YrcLRshIjiub8/GjAow5kCMiWLw
 ZPg9iEagrdxBJWy8iFJh8PAf2ypwpHq9lsthXtrQ6v9jVedbzbNWac2
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|CO1PR19MB4981:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c840da-bcb3-4647-7baf-08dd38f1d3c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmJSczIzRXRXN2t3TXJhd3cxdjJSZVdPdUVLc1BMeW5MTVIrTHE3OGJmelRt?=
 =?utf-8?B?YlRPZnhBa1J1SFdOeWN3OVJUUjkrVTlWcnRyT01md0Nmckg3d1BjUzAvWWxQ?=
 =?utf-8?B?M3NDczM4QTVhUlRoQnBiTXhDeit1TnJLSmdqSEU4MmZJWXp5Wkt5Sm9wV3Bv?=
 =?utf-8?B?Mnh0K2NZeFVNKzAzK3RqVG92a1kvSFk5cnVSM3V2TkQ3MGJvb0pIRzhuSE5y?=
 =?utf-8?B?YzhxRzZ3cmoyRzNsZ3VRMmRtR1cyNVBVVVJyM0NrN0xPK2lUZDYvVld0NzZN?=
 =?utf-8?B?MzFkajRLdHdsSm0yNFNudWMxTU5uQTNJWkMyRnRDcTZ4NVprd3FvUXluLy9l?=
 =?utf-8?B?MVJycDZUWkZQamlTQ0FDVUlleXh3TjloRHd0ZDc5dHhyZm81aEFhTmNrRWlJ?=
 =?utf-8?B?dzUxVXIxYnFIaG5DZkphLzdUYU9XWXVVNDdnVDFmTXVQckJmWFVLRnRjQjNZ?=
 =?utf-8?B?ZXJFNXNzZWV1OC9kNE9RZ3lObHdoTG9jK3I1T1NZeU10Y05SZUUzOU5IajQy?=
 =?utf-8?B?SDBqZEV1VGhHOER4RFJXTDZKVUVOZGJpeC9xREZCRGZKTkhxcFJkTWF0UDZE?=
 =?utf-8?B?ZSsyN29CSDN0OW10MU50QjJxR0ZjMlBIMkZpd2plbjc2aUFEMzQ1K3VmWWZ3?=
 =?utf-8?B?Tm95a253UG8wdFY3ZG12ZDR1dEVBRXNaa0hZOWRTUmI2Z0lIdmdTT0RUWm4x?=
 =?utf-8?B?K01heVYxaGx0VmtEUDZmeGhseDROem91aGUxMjFxazlTMzVUUVZQUGQ0SDFv?=
 =?utf-8?B?Y3V3eU1iVmRoZ2pYd3RvUGNpZkhkZGw3b2w4cnA5MU80OE5wTFl0eTVZUEJT?=
 =?utf-8?B?Tys0TmgzcTV5RXZHWGNZYkJFSkxsSGJWb0R2U0xqL3ovWFJlSURZL2FDdUhL?=
 =?utf-8?B?Wkppelk4TEJhZ3ZEMmFtSGpQZVVWdkJFZmxDc1FjRFVZZW1aTndnbGtmN1dn?=
 =?utf-8?B?YXc5TlJQQmFZU1hBb0FPWG0veXZmVWtZTkhHcFN4VFdsRWpLMTg4M3NyVDVV?=
 =?utf-8?B?cEw1L0l0U3VuZWtFMEZCVXlEeWQ1V2J3amp0TVY3TEtpMkdOMG82dHlENUJI?=
 =?utf-8?B?ODdGZWlncVVPSFpoeVViZi80dkV6MTZ3bnNaYnFuc1BHS2ZNTXExcnozMFZq?=
 =?utf-8?B?Z2c1dGpzR280OVQrcnRzRndZeXRPNHJCQ1l5bVRGbEVidXdhMGZ6QW5TWWUr?=
 =?utf-8?B?MTVnOEZQcU9iOVc0N1NSWjE5NllIZW9Xb29SWExWVjVQaTNRUmw2NWdtRmFo?=
 =?utf-8?B?ZkRab1gxbGl5bU1xdVRCQitHVUp1RzYxejd3bndEbXRvMUJtZTRrVjNjd0Q5?=
 =?utf-8?B?bzNQNXVTTW90Mm15MUZaU2t6RUFtVFozdFNzS0dJRGxMb3l2ZFo3YkJpcGZj?=
 =?utf-8?B?Q2U2c2t0dFdtMEVZZEJOV1lGWE14TmVSOEZFMk92SGEwMzNoZklobytHSHVv?=
 =?utf-8?B?RU5RVHphU2trck1RNTZjTEM0cCtYdjhibENXZkUwMkRHczVhbFJrcXZJWjM5?=
 =?utf-8?B?SVNWdXp3M0tyQXR1VTJBRW1HcTZzNEpOOTdFdU4xQUxjcXkwcE42Q3N6VUY2?=
 =?utf-8?B?MjNrZWZQMlNTU3ZJd0VNYm5xNWhDVXUwV2N3OEZ1WHZDamtEcDJLQnJway9o?=
 =?utf-8?B?QVY0aDQyQmttcW9QRndmWG1TZFc1U0Q5S0daSk8rMTdQOWpBNlhCSGl4cTFr?=
 =?utf-8?B?ZW9nV2VyUUwwNjBOQzA1TDFaaGp2UERacHZkaU1wVEx3dHJ3bUhDWWhVUm1x?=
 =?utf-8?B?YzdJaFRWWm5QMC9NbkRxQUdOai93SS8vNjdsbzFYS2JGRlF6S1BjT2xNekhS?=
 =?utf-8?B?eHdZbzJxNk5mZm12ZVZiS2xzaXQ5NmtnK0FlYVk5U3BldDkwamFWNWdIcWJH?=
 =?utf-8?B?TTR1bnh5akJoYlhtOThNUU5ncFUzaENYaUtkb0liRE5YMDdzV2RzOU0rWDMz?=
 =?utf-8?B?ejlMWE53b1NTVEpReDRtM3ZZd3JNUlloU2JVV2lvS2E5UnFjOUJ4TjNCK2ov?=
 =?utf-8?Q?qI/7Oz1fTc30hwgf6NQOnlmB8CxRkU=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xiV/8LbqKYVXOkTGDoxYiPHO6lejcL0IDkFLK/vj77VkytYrUaXb2QJU4C5iIEiG6/CetCPpP0XWk6d35pcOYHAC+OdLDOE8Ji3OV+Lt9DDiAuR7tedbvtt8xcVVPXU5VudMk2B2ajx3snNTsmwnIQEXSGKO4i09IkcZVOFyQI3gXyx6CbkkF49mDbaKv26BHK0gxnWLHt0Z2O2MZRrZGbIfmQBKMmDHn79LzydXzPeQoP+g0XHTO7XOfq4x6twGqO0ZPJna6pEjWGWhl4FjGEjKuxHpBcXgL0rtyFgiBA8/9CcWzCaNTiGp23o28byw2GeaFCaZbkkYN2txvBs9EISU4zEayW7tIsF6u3cGYWek5yd/HWuqC/k8QrniPUbX6/5tL9mQXj16OyyQDVFiqbA06emERwbjvwsO9oSrf7DHTkSe3xm3qWoVsIeeIAO4PYFKtHZ/4DUI3pz+CW/0c40lYSx77gYA/Gd5S/5DiVKruNtXIQ7qJ5RPJ/9sH90KNxMEQckAXZy6TlEuNDLLMthNPdTSbOxAyGwUDSKntHrTMdqDIFhlUGeLes5giUeStFmonjAjbBYXW5pZyRGek4ahGuQFgCwLwA/AKtJ1iHIOzXEIkUPvoYsATopnOC3E93XnaGYAbxOHm7l/yGwgnw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:04.5953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c840da-bcb3-4647-7baf-08dd38f1d3c0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB4981
X-BESS-ID: 1737336546-106115-13449-10989-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.58.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoam5hZAVgZQMDXNwsDEwMg0KT
	k5zcw81dDQxNgi2SLZ3CjVwsQw0chAqTYWAMycoyBBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan23-253.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
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


