Return-Path: <io-uring+bounces-6017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC4BA16503
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A48D91883EE4
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA87145B14;
	Mon, 20 Jan 2025 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="b+VJaEJT"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4DE4C80;
	Mon, 20 Jan 2025 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336575; cv=fail; b=cvJkR1PIdxqnQlOLrLCUOnuoX7/RSC+PzSTiGKmgpgxGaze7T6VCs/a7fZCr8+r/Kmo/s9VTHfchNsc/kgGYTZtd8NcA9VCWSme8zClhkqj41fLUFQ60ie+p5093evGMni8KlO/pFJnVmYLXBsgJO2aLuJQOD1EhjPZVrQsndtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336575; c=relaxed/simple;
	bh=Ya1E+Ku/QRkwCEaIbyaS0TPDqDs2gP54NDs4ZV63gYQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AMjd97v6W9jE9V9paji1Te3M9YwH4TVygH01uIuzTfNf3Xj04pM1I1lO4paQybb2IVr36Na4hEHk3iKvlleTerEwAJEKQPqamthNzAxulFtUfYnCG3wOsNEiDmp9eB7IdlxL/xvndG6k+MH+2oaXmV3W3QKjddZECu7+LgMeBU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=b+VJaEJT; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176]) by mx-outbound43-175.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4kDhdc+9MbSczX7DQGf2Shoh/yo14z31aTq/i7h0XUJ6z5Nyu8M21IZfLStr2zU6H38NCoS5hB42sSjGBrEoRCbgrg3RyToinDw1/FPcXCQmgJKh+HYjBi4m1ORWCwDIXl7CfXmnN7LwWG0jvDnBl6/UIGwm7EPROwcIzK8Fh57eFS4K8DwfyCfyskXMdFVwEJHG6kATQt0nhy4kGWfGy2AjtRXRS81tB9YgFt+ewWZBGj6eGCSgTEAhV4jWKs1n3MDzWCsVvQPvD15PqeIRBsefAXrFxFTSxYsDWjfUZPE+u/PoHx13gyyMAOIs42vkRhU5exp6THfgXPIuiASig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6RfwqruhsUJ24uvHOhy9dXWf83Pkk0jDujN/3YHBFg=;
 b=dDu2AlSHzDY2kg7cn2nW4UvVO1yE+bPF9NBfb+7XExthBrTHwU5bEAowVKvc0zV81gMxPUyLjZNKLOLe4hO1XiHF7NhJrr3F9uD+tTHsOMe/gRYPnAlLwApYUQuy1g607otS6+czCTe9rfw9BqwYG48redeCv7S0MHNxeiUqYkiBUN8fXIbwouun8KxrPsNxCxJKdEnQSW3nBPqWalHcibH/kLhzUNLlwqmni73xp2Nu8lCc0MnfQAiQh98+uGyD54iV/q02+F8KOcTBH/h6PSiA0BqHx4xrDS/TjBpKLAEWy8m314TdKcceK94udy9DA+kvSVN93x8ckvNDmmQeRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6RfwqruhsUJ24uvHOhy9dXWf83Pkk0jDujN/3YHBFg=;
 b=b+VJaEJTVYMnSX7o6VIuQtiO8hzJCOuxZj5wsey+Vxm5Xrvo9vsTdzp237Wbp2DDczAQK90QmRwpKNlfraueRf6LPxc5JJX3W2MSTenurF6E9UByUorEV4AM3Y0vjJnfuhaAJbvK7T6n4xv2+XQxicz9cXMPiSoC8A1EFsG0rtA=
Received: from CH0PR04CA0065.namprd04.prod.outlook.com (2603:10b6:610:74::10)
 by SN7PR19MB7471.namprd19.prod.outlook.com (2603:10b6:806:32a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:11 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::b) by CH0PR04CA0065.outlook.office365.com
 (2603:10b6:610:74::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:11 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 9ACA84D;
	Mon, 20 Jan 2025 01:29:10 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:02 +0100
Subject: [PATCH v10 09/17] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-9-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=3448;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Ya1E+Ku/QRkwCEaIbyaS0TPDqDs2gP54NDs4ZV63gYQ=;
 b=qetoywlwrtXLnPyBQzMU6wpQjIWrwG2pLO+/pD6jkAk7gfOpYcXiTnmSC3WG500B8LM/jKKoa
 PM6qPynkQp/CBnI2tPEt6ywThV0sXYvtSWLjrbZRPQM0q0mOUB24FI+
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|SN7PR19MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf06c3a-2e15-4d1f-caa4-08dd38f1d7b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHA3S1U0YmpVMmRBRm83WXFmS0RIbk9GYjVLTEw5L3ZYRkQveVBnUXZpYXhx?=
 =?utf-8?B?Q3B4NE1HQk1OZ28yaFV4L0pJNTNCUG1UUUdTSDVaUmlMTUhOMjhsNjRENWhG?=
 =?utf-8?B?ckpGTUhIOUJzNU9Damx3eVFGNysrT2ZPR3hoZFdESDlsU0M4OTR6amZTbmxJ?=
 =?utf-8?B?enpXMkJLdmFjamh2RDFDUUU4ajIrR29hajZzL01UTTI0VUk2cjVKdUpzRUQ3?=
 =?utf-8?B?SDNGRWlDWFNTZWlOV29rWUVVNFZReG5GYk94NUlGZkJlYWc3aUdpcXFBY2pR?=
 =?utf-8?B?OThjQm9JRDJlbUpSdkhzUU9VVy81aEhnenBBdWVqVXJvejJSMEVIYVJuRU41?=
 =?utf-8?B?UkVaaWd4RHBERlM3MDhVaXVNMUtRdHVMWXRlaFRhNk1GWnF2bXQ3eUtmd2hC?=
 =?utf-8?B?MHdxRDAxNStVcGRtekpOOU1HZSttUGlMZEJnMjlkckxPaUE2WUpUcDdEQ3d5?=
 =?utf-8?B?dEN0NmhYNFlHY1pWVVRXaDh5WTliZnlNNzlSWTVsSnZ3UnZOMUVzY1NycFRJ?=
 =?utf-8?B?elVDNjFRREcrT1ZtNUhpVDlaakdHVEhSRHE2OFRSallLNTlVVXpjYmh6OVdT?=
 =?utf-8?B?aytBTlpIcWtQbVdScndPSXVYMlJia0FlcExXVWo4SWpENlluRCtPS0tzQmd1?=
 =?utf-8?B?MG9jbThyMmRjWktyR0dpeE1mRG5CRTNDV3VIU2FkVEtzYjBLdFRCUzByWi9w?=
 =?utf-8?B?RWw3cGVsSHZ6Qkg2ZEg5Y0d4ZWZUSThld2pqT0l1UG9kQ0JSOWxHK29VNThi?=
 =?utf-8?B?ZWVaZG9xRG1QNzZscFhJZG80RjRneU5acUw2d3lJUGtwRHpGY3JnTjVrdUlO?=
 =?utf-8?B?eEVERFdoaUpVZEhkb2k3WmxMMWpxNDh1TlhxNXRoeG1CWGRXTWRoaFBaQTNS?=
 =?utf-8?B?aFhudjdHMmswMURHams1Vjd3Nlo5Q29Tb21ZMTRVbzVxL0tJTnFFeExkNE0x?=
 =?utf-8?B?UVV5U0hIQUM1TWxKM0xTdzdHOWQxY0tqNWgxNEplSkRybVF5NmdpV2gxbHFK?=
 =?utf-8?B?RlorSnhrZTBHbGJjQXU4U0Y3Z3NGbktFWW9PR0RUSTNMbE9lZThkY3VhdDF0?=
 =?utf-8?B?WG5xT3pYSFFvd3N6VUdKbmxFOGpLMWQ1anIrUWZ3dGtBUmVPWXVpMUhNQ3dZ?=
 =?utf-8?B?TGxJbTdUWGRrZ2t6VzdoRFdhdlk1T0lKK09zanZJTjFNaEk2c2FwSjdSL3do?=
 =?utf-8?B?YnBhYVorQ3lJbXMyR1NyR1YxZlBkZnlnMGlxK1VkQXVuenVTVHUvK3hHR1VW?=
 =?utf-8?B?M0tJRkxYVlE2M3ZUSVlEQnZFTmY4b2FiaE9yY1NmQkxaSElmdnVITmNzRno4?=
 =?utf-8?B?aVZqQm5BenRRSWQ0bjJTaEl1QkJjM1NtOTNwZndaeUdJOGFmNmkyazJJVVQ3?=
 =?utf-8?B?WmhUVEJqSW5WM1ZGM21iUUF3TzJVbmxBVXArSGdDenIrdHYzYWJJcnREc3F0?=
 =?utf-8?B?QXFqOFVmS0dhUGJjSHN1NFZWa291THgzQTMwYyt3Z1IyR2tnQW05M1FScEFU?=
 =?utf-8?B?VDZDNktPZ3ZibUtybW5YTlh2YkFBeWgrSXNBZUFoRzNUc0dyS21QVUJVNWdZ?=
 =?utf-8?B?cHAyU0xSL3p5ajY5RXBHTTBiZzlxcnE5SDgwUkFaYnNKUG5kR1NWbmM1SWRq?=
 =?utf-8?B?bXhsK3VhbGROR21QaElndnRvdGdwUkkzM0JrMGtsSE9PWDhLYVFIUXF6Qi9U?=
 =?utf-8?B?TXVsMUxtR21oUkdTNk1PZE44dW5TbWljK2tkZVdGVDVldVFIcmlIN3VVOWtV?=
 =?utf-8?B?WG5xZytCMTk5bWZaTWxMcDdBMDRwei94eFhlRW9FNGJnckNJN3doSmcwR29l?=
 =?utf-8?B?K2xCTHlKdHRFeDBEck9VWXpXWWR5ZXZiSVFsRXd1ckpRcURNUU5ZNlFvQkZQ?=
 =?utf-8?B?UjRlS1drUWc1eUtIc21idHB3NHlLazBvV2hWek1HQlF0NUJUenVjaGhvOTFi?=
 =?utf-8?B?YUp5cnVBeitHUW41NFZ2VGtNQTVxMmZpd0Nyckc3eksralg4a2xLOFBEUER4?=
 =?utf-8?Q?pFzIEhPTXZss6IEOln0GfFq6WP/LN0=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sC/adklkETGxGDcso7agvvMym6OO5iVF7dyzoRBGwiYEFlZoRchtms81g14g/rVbUDxQGFnf0FSK8ENu/+XGbR0gqmvI5c6ynY8wkfYqCebXxM1l/Dip8qeh07A8DFg4Cj4sZ0AfWcZrthMn3uc8HN5o3P/VvhSjEUtGwD/Dh5Zo9R5ioYZSWc7cAvJTIVwExjafUX/lrH7js3sYqZPoSuePDod4SOYYRex2qUkp/YL5mZDYXPIDSg4LLV73We+YehVU9vsvHH7iWCcylBUMcLeGneJ72jJSM6At7bXHb0DrDlkuIKYIgUIbKQ4CgD9G8LphgV6W0NhPTgkEXyUWanqNlLYUPDl4I+gNUl5DRTEHGe+hV6QEHJ8P4REJ5R+vVzsHQ+NEMonUjvABkWqPgOjK3PBMnHV67WijNY4nErdMs8vwlJPeBXWG+Kam3cTTa5JHHHyrNUiJCExNlKxXRv2mdJu7FJrvkJsNh01fJfWPZqoCzliNKyKD5D1D8LGCUfBTwhMlcn3OHbNhglzecqdU5YnFEmQf7sOvbaRg+Wmllgm7s/WwcNfTh0H+ar54euRHZbfiFOYvkqcCQgrcK714TWJDt62vQM/RqEXwyCx+89qLx414hjDX+SkCh5saZQRRaxF+MmmyiZcCSwaerg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:11.2346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf06c3a-2e15-4d1f-caa4-08dd38f1d7b0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7471
X-BESS-ID: 1737336554-111183-13447-2043-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.59.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsbGJsZAVgZQ0MAyzSLFwsTIyN
	zEMi3V0CjVzNzSPNHcPNXSwtDczCRVqTYWAL2zPpRBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan12-163.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

fuse-over-io-uring uses existing functions to find requests based
on their unique id - make these functions non-static.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 6 +++---
 fs/fuse/fuse_dev_i.h | 6 ++++++
 fs/fuse/fuse_i.h     | 5 +++++
 fs/fuse/inode.c      | 2 +-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8b03a540e151daa1f62986aa79030e9e7a456059..aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0 100644
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
index 4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615..599a61536f8c85b3631b8584247a917bda92e719 100644
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
@@ -42,6 +45,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
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


