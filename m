Return-Path: <io-uring+bounces-5716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D857A034CB
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 03:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8240E3A4C9A
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF39481A3;
	Tue,  7 Jan 2025 01:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Uj3lgr9T"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76945134A8
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215196; cv=fail; b=czm0dVGAXuVsdB+j06UP8074bINB5cd2WAWSTfkmFsNig4YXFkYnLbp0H+4ESCeh2wf4bbMm8dEHWldDMTd0Gt8O4/r5qc/cmRcXWGS992cumNpEdLcvVFemc1BOqPeLzvWVCoYiKFo3/Pdw6+Pgn1+N7e690xVW+vXMO8hGvyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215196; c=relaxed/simple;
	bh=qDrJQD5GIUFgEPfAsu6PeustEMyFEnEPmBk1X6gapVc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NTt4zUAwytRLzVnVnw4/eL2je+bF8hwoIH1Q+zdZcPuhMuxO7ZsvHgZ5JYpMoRLRUu5lgsz2Z4QdlQ+KdbF6EyNhay2aRGBnMlgx7XXVrOxeASdfuBlEkASGFdJKddK4Qr2HpnNkAfBWYazQuhhN9wqM1GSI3OhAWyJK9pieN4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Uj3lgr9T; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177]) by mx-outbound22-188.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D+in07hx6KzCOA5xThDupNNM4ZMR8tzExkp+Gwq0hvWKI5e0procd+2eysbdNWw33GDebdSxLoJtEGCSBIFps/TJ8wdRFbiijAL1tXSgYz+Wk9CwhZaQxH7BE2pl9XzsF28yR+UfmtcVCf1CkbRpMtgEmTSLXd1feQ4ee07cvQX09bDnrTtkJ0Var6xhTV4qcQaejoK2++cHF+DPsP9aeDUT3ofBBQNLsQXPUdIoSYmntperQTuge+WdYSqQLC2Ytlt+vg0JDdLu8i+T4Isz8+MW6HzifqRA9OX+mpdqMEsbDRmDkzmXGY7uq4cBo0eki8fre1MrccPt2pEW8txiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Bs8av6muO2dzP8iqIxkblkMbf84WzArLrGlxzRam0Q=;
 b=kbas8I7ZtQb/A1I+AjAKQKEflh+0CF0fK4TwxnOU842KW2aw2Nt3SAAhdoc4zAvWIwO8Hx6obhNCpcEuznFgg0EYwRlTNKdZGGLnrBXQV0bzJz1pEppOyHoXujdf0HCEvho4gR49bIGuEJIh0g7fwVUXZM4GMpyUzaCqFTdKJtyHVo4uiVpHMm/XD+YdyfP1dN9OZCfTtXb/GI9wWtPGz9+xmzgIDC+rrrpbn6GE/KuzftrNYQJmlW2elqHz19NY73njJr11pIRcbNLB9GZPzO/yhYdyp7GcOHhUL4LbDtr9FAyCY4qRE9I+h6vvG8fSU7u8E4dj5lty/QYmVpt09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Bs8av6muO2dzP8iqIxkblkMbf84WzArLrGlxzRam0Q=;
 b=Uj3lgr9ThdDRXn9jMCjc30bdfwwSolrBnwTYz9zsvUNoxUV0q1Lrbms3RllZLv7EvBjDKI2NgNdQL4+Gb5io5Qz1cKOOcwHi2NKIiWEt2UoRBVrEVfIx/KETcHPqu60SU2BRBalFrrcWFbAPCGNzt4H+WvNWnwWi5r1njorxqA0=
Received: from SJ0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:a03:39f::6)
 by BY1PR19MB8013.namprd19.prod.outlook.com (2603:10b6:a03:532::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 00:25:12 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::24) by SJ0PR03CA0211.outlook.office365.com
 (2603:10b6:a03:39f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:10 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 5D6034D;
	Tue,  7 Jan 2025 00:25:10 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH v9 00/17] fuse: fuse-over-io-uring
Date: Tue, 07 Jan 2025 01:25:05 +0100
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGF0fGcC/33PSW6EMBAF0Ku0vE5FnijbWeUeURbGQ+MF0DJDE
 rW4ewyKumERlt/Sf/V9J0PIKQzk7XInOcxpSH1Xgnm5ENfY7hog+ZIJp1wyyiqI0xBgyqm7Quw
 zIDAKOToJyDyNDnXFoialfsshpu+N/vgsuUnD2Oef7dIs19cNpYYyqOXeLdws4CuNTT+N0Lb2B
 iVTMJyqqIRhUsp377tX17frpb9t+P+2Wa71UnWqEogYHvV12Vw91jBG1QlTFSZoRGpNWWHMkcE
 dw/kJg4XhOqDznoYCHRm1Z87WqPVTQtbCoqmts0dGPxlOzQmjC+NNNJGj5HUQT2ZZll9UniY3I
 QIAAA==
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=12590;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=qDrJQD5GIUFgEPfAsu6PeustEMyFEnEPmBk1X6gapVc=;
 b=m2YzJ2FdwXIyvPL40JD3fo9/2VXu4TZE1EJqVgfTNGq7KTTkTlPSyWBPfUan81KybwOy4+8w2
 cwyHcp2MET6BUv8Uh8pcYXi8Yj0p83GjkyFsYY6x0gG1KeWEfipRTJ+
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|BY1PR19MB8013:EE_
X-MS-Office365-Filtering-Correlation-Id: 9176b514-0f2b-43bf-8ff2-08dd2eb1bf59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czllNnd2OUx6cG01emQva2s2cjY1SzkycHE3SzNZZHpxaDR6alpDRVlsNEwz?=
 =?utf-8?B?Zm1rUmlqd0hhTThqTUNBQlhZWDY2T0piME81d3lQaGtYSEtkRndIK1Q1WnRs?=
 =?utf-8?B?bnNidjg0Tlo0eXJpYlJtZ0s2S2RqSWVhcmtDTEhsamdWMFUvWStVZHRzK1ZE?=
 =?utf-8?B?Wjl3SFRZMjM0eXd6VFA2T21mb2t6alloUmZYbkZ5aFRYOVlWWHRTV0JVRlVr?=
 =?utf-8?B?bVF2cFUvYkljTHV4Qi9NaUJaQUN6WHpTUFY3aWpQbnJ4SStRZTB3blNFVm9E?=
 =?utf-8?B?TE1CRTdFUTNCUjRHY1JnTTRXTEpEV0tQRjU4WGtSbE00eTNxL2g1V1VmSlQz?=
 =?utf-8?B?QkFuS0VOenh3eUEySFNOdzM1NmxLdGx3RUlCbHhCNTVGYkhjT0cvVERvOUZw?=
 =?utf-8?B?YmFvcW1iOXZwRU56T3RndXZNOWNBTmppaUN5V1RsMzRMRUEzc0ZMclRnREov?=
 =?utf-8?B?bGJsTjBHTEVSUUpNR1g4cGRyb2tYQWpNeW55Q3dwcmVVc3ZQaGlna0ZocVlS?=
 =?utf-8?B?SGlkYnJpbHVuRXk2WVhjalBvbC9mRWRSQXp4UTMvOE8yOXhwUjhiODFVNDhV?=
 =?utf-8?B?bGVsZlRKTDhlVWI1R2FGSDZSVFZWc20yTy83WXpsQzdWN3VOVDRDaHNZd3E5?=
 =?utf-8?B?R2sxakpyS0FvamNiU1J6clZ3dGdWTzRjeThFczE3R0ZiQ0VLSTNwS0t6bHNQ?=
 =?utf-8?B?VWJLZllVNTZoOXFHZlpQNExkYkdIMUdpZlBYd3ZDTm55ejdYOCtsS3VmMWZv?=
 =?utf-8?B?cEQzbGpSaUZYN2xTOEpFSzVkZTJqa3VxUFdZRVJXWTNYRGRZZUxrNENnQUVG?=
 =?utf-8?B?M0dBOHNoMGh4QkpUTTR3cGI2Ui9lRU1uVjMySGdURGFzM2pDWEVrMmhvMVV2?=
 =?utf-8?B?MElNR3F0VnF3aTRrcVU4SUFVdUdRUmEraXdxNDR3MzlEVjFkUFlSL2ZiKzFZ?=
 =?utf-8?B?Y2lOMDE3ZWU0Y2pWV2N0Z25YZmxRM0l2UDQ0SzVxa3o0UHQ4UFBOQ3FHZWRo?=
 =?utf-8?B?TUFYb3YrNzVRaWdoMzd4NWZtZEw1QUdVN3VqY2dPcldmSUpFVFIrV3gxL0hz?=
 =?utf-8?B?ekVBUkdKVUR5NElVeTY1c2FySnAxUS9rb2dRb3J4YVVUbjIweGZBNHZDak1p?=
 =?utf-8?B?YnRNWkxUTm9Nd1FNQzYxN1ZZSHVFcUNtaTFpNmZmdENJNzd3M2toUE4vbUp2?=
 =?utf-8?B?QzhIL251Q3JJM0pSRXZCZUtpN3ZXZFpPWk9XcHY3L2d1Q3cyN2s1dE1WNklE?=
 =?utf-8?B?SGtkY05wSXZpOURPeXNxTGJlVmpZTElUdDRwWXJoUTBDdlBtU1NPMzNhSC9S?=
 =?utf-8?B?ZG56VjFWMkpDN1hJNW1zS2pVaUFMdEdmbXpQZWRPRXpGQ3pIcTNEakZHelJw?=
 =?utf-8?B?UlZvMjJuTTl3TmtrWk1jM1NqNklZWHBITjhqT1h2NEI3UUJwMmJUTDBEQy9x?=
 =?utf-8?B?dTlmTHhIeHR2aUd3ZlErVGtlakdySUxFaGFNZmVDWklxQzVzNXVSd3NyU2VX?=
 =?utf-8?B?bzU2WGZXTlF5bE9Xa1NSM1g4V21BUllXTktRVHlNdHp0d1Vkb0JUQmJRTnRM?=
 =?utf-8?B?NGlrcWRTK1hQZFVqMWpwZGgvOVkrQzlRZFRsOGRVUFRZK0JNeGNZamRNakN4?=
 =?utf-8?B?U3kxZ3hSU2hGQVlySE9NcWpYNUIrZU1vZ3Y0b080S1VOSExUY1huUldNTFF1?=
 =?utf-8?B?YkV3WTBZRmRVcFVnUENoeVdhSkVoRjdMMXpqRnV2WitMUFZyYUJ0MTQ1UExT?=
 =?utf-8?B?VkUySSsyMU9oZE9NRXZWUFpTWE1wZWxFQzFseW9oWEtlNVdHVGpJMnFCemVD?=
 =?utf-8?B?bHZDSTJ3YlJDRFprL0lBODFJTkUzbUVrajR1SHcrVU8xNzFEVTd5byt6Zmto?=
 =?utf-8?B?eURvYys1emYzUzJBRUhxQ0N0NHpZSmV4STR0UEFwWVg5bDlKL3pkeFA2QUx5?=
 =?utf-8?Q?dXnuB9dLR70=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mXLKuhB+RokPHy4BqxkvBV+WXuDom2931VPyopbVqUAx60loHZ6z5zHSrDw/ltKE6KBOVTlc5EUO2n6JpVDxUNNE8VZSiTVQv56ejqsoPixHG6ozuiol+ZDoHreS0b5DsdSj1jIh6W/C20DJBGVaz6qaBDt9dXm2HOX3xHDmPmDR7xo2F1m/CEnc/hx+VpIpllCXIDet/VAedhhmChG2tG7PDU1FRVxlTRTLx7crI/3TTRiSWMwkwrPgpHaH03EU7F0HlqXi0Mq+JTVzqPLdvUAC3JULK3nGXKZ+h0FyUOZWqpUoBxL15UFGEKwr1EOA63i95gGUy5njrpIPijztronP0G9Etjf9Dio2celW8DiRFcqi/tpmHs8hZDfJ6YSOherAZ5+PMpm11rer6WLJBCXClHgrR01757VOq+ZgLZcUJdaVo5UerTrjvzLzIgUGClbuiAMQYRm0os/wIAeqOIKNAkluMDtDPlCWZOGktfEcp5pGltfvedueDJ19aKr/J9leE0xdRuQIqzDFD6m6kmv85KZJjfh1eJaYgpl9HXcHeKBWkfUTck6Oo2lonODDbeLZX8fsP1lGTp5UrEp2/X/KXnF8nf5zPAG11mPUW+ke57jW3UyyPEFENlwfJq3gkZyNl7VTfEv3x34wMGGHxA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:10.9947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9176b514-0f2b-43bf-8ff2-08dd2eb1bf59
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR19MB8013
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215190-105820-26427-20220-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.55.177
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGxsamQGYGUNTM0CDRLDUtJc
	XYINXczNTA1NTIPNHYwDLJLNHcKNXMUqk2FgAyYCYYQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan17-177.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for io-uring communication between kernel and
userspace daemon using opcode the IORING_OP_URING_CMD. The basic
approach was taken from ublk.

Motivation for these patches is all to increase fuse performance,
by:
- Reducing kernel/userspace context switches
    - Part of that is given by the ring ring - handling multiple
      requests on either side of kernel/userspace without the need
      to switch per request
    - Part of that is FUSE_URING_REQ_COMMIT_AND_FETCH, i.e. submitting
      the result of a request and fetching the next fuse request
      in one step. In contrary to legacy read/write to /dev/fuse
- Core and numa affinity - one ring per core, which allows to
  avoid cpu core context switches

A more detailed motivation description can be found in the
introction of previous patch series
https://lore.kernel.org/r/20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com
That description also includes benchmark results with RFCv1.
Performance with the current series needs to be tested, but will
be lower, as several optimization patches are missing, like
wake-up on the same core. These optimizations will be submitted
after merging the main changes.

The corresponding libfuse patches are on my uring branch, but needs
cleanup for submission - that will be done once the kernel design
will not change anymore
https://github.com/bsbernd/libfuse/tree/uring

Testing with that libfuse branch is possible by running something
like:

example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
--uring  --uring-q-depth=128 /scratch/source /scratch/dest

With the --debug-fuse option one should see CQE in the request type,
if requests are received via io-uring:

cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 7060
    unique: 4, result=104

Without the --uring option "cqe" is replaced by the default "dev"

dev unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 56, pid: 7117
   unique: 4, success, outsize: 120

Future work
- different payload sizes per ring
- zero copy

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
Changes in v9:
- Fixed a queue->lock/fc->bg_lock order issue, fuse_block_alloc() now waits
  until fc->io_uring is ready
- Renamed fuse_ring_ent_unset_userspace to fuse_ring_ent_set_commit (Joanne)
- No need to initialize *ring to NULL in fuse_uring_create (Joanne)
- Use max() instead of max_t in fuse_uring_create (Joanne)
- Rename FRRS_WAIT to FRRS_AVAILABLE (Joanne)
- Add comment for WRITE_ONCE(ring->queues[qid], ...) (Joanne)
- Rename _fuse_uring_register to fuse_uring_do_register (Joanne)
- Split out fuse_uring_create_ring_ent() (Joanne)
- Use 'struct fuse_uring_ent_in_out' instead of char[] in
  fuse_uring_req_header (Joanne)
- Set fuse_ring_ent->cmd to NULL to ensure io-uring commands cannot
  be used two times (Pavel). That also allows to simplify
  fuse_uring_entry_teardown().
- Fix return value on allocation failure in fuse_uring_create_queue (Joanne)
- Renamed struct fuse_copy_state.ring.offset to .copied_sz
- static const struct fuse_iqueue_ops fuse_io_uring_ops (kernel test robot)
- ring_ent->commit_id was removed and req->in.h.unique is set in the request
  header as commit id.
- Rename of "ring_ent" to "ent" in several functions
- Rename struct fuse_uring_cmd_pdu to struct fuse_uring_pdu
- Link to v8: https://lore.kernel.org/r/20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com
- No return code from fuse_uring_cancel(), io-uring handles
  resending IO_URING_F_CANCEL on its own (Pavel)

Changes in v8:
- Move the lock in fuse_uring_create_queue to have initialization before
  taking fc->lock (Joanne)
- Avoid double assignment of ring_ent->cmd (Pavel)
- Set a global ring may_payload size instead of per ring-entry (Joanne)
- Also consider fc->max_pages for the max payload size (instead of
  fc->max_write only) (Joanne)
- Fix freeing of ring->queues in error case in fuse_uring_create (Joanne)
- Fix allocation size of the ring, including queues was a leftover from
  previous patches (Miklos, Joanne)
- Move FUSE_URING_IOV_SEGS definiton to the top of dev_uring.c (Joanne)a
- Update Documentation/filesystems/fuse-io-uring.rst and use 'io-uring'
  instead of 'uring' (Pavel)
- Rename SQE op codes to FUSE_IO_URING_CMD_REGISTER and
  FUSE_IO_URING_CMD_COMMIT_AND_FETCH
- Use READ_ONCE on data in 80B SQE section (struct fuse_uring_cmd_req)
  (Pavel)
- Add back sanity check for IO_URING_F_SQE128 (had been initially there,
  but got lost between different version updates) (Pavel)
- Remove pr_devel logs (Miklos)
- Only set fuse_uring_cmd() in to file_operations in the last patch
  and mark that function with __maybe_unused before, to avoid potential
  compiler warnings (Pavel)
- Add missing sanity for qid < ring->nr_queues
- Add check for fc->initialized - FUSE_IO_URING_CMD_REGISTER must only
  arrive after FUSE_INIT in order to know the max payload size
- Add in 'struct fuse_uring_ent_in_out' and add in the commit id.
  For now the commit id is the request unique, but any number
  that can identify the corresponding struct fuse_ring_ent object.
  The current way via struct fuse_req needs struct fuse_pqueue per
  queue (>2kb per core/queue), has hash overhead and is not suitable
  for requests types without a unique (like future updates for notify
- Increase FUSE_KERNEL_MINOR_VERSION to 42
- Separate out make fuse_request_find/fuse_req_hash/fuse_pqueue_init
  non-static to simplify review
- Don't return too early in fuse_uring_copy_to_ring, to always update
  'ring_ent_in_out'
- Code simplification of fuse_uring_next_fuse_req()
- fuse_uring_commit_fetch was accidentally doing a full copy on stack
  of queue->fpq
- Separate out setting and getting values from io_uring_cmd *cmd->pdu
  into functions
- Fix freeing of queue->ent_released (was accidentally in the wrong
  function)
- Remove the queue from fuse_uring_cmd_pdu, ring_ent is enough since
  v7
- Return -EAGAIN for IO_URING_F_CANCEL when ring-entries are in the
  wrong state. To be clarified with io-uring upstream if that is right.
- Slight simplifaction by using list_first_entry_or_null instead of
  extra checks if the list is empty
- Link to v7: https://lore.kernel.org/r/20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com

Changes in v7:
- Bug fixes:
   - Removed unsetting ring->ready as that brought up a lock
     order violation for fc->bg_lock/queue->lock
   - Check for !fc->connected in fuse_uring_cmd(), tear down issues
     came up with large ring sizes without that.
   - Removal of (arg->size == 0) condition and warning in fuse_copy_args
     as that is actually expected for some op codes.
- New init flag: FUSE_OVER_IO_URING to tell fuse-server about over-io-uring
                 capability
- Use fuse_set_zero_arg0() to set arg0 and rename to struct fuse_zero_header
  (I hope I got Miklos suggestion right)
- Simplification of fuse_uring_ent_avail()
- Renamed some structs in uapi/linux/fuse.h to fuse_uring
  (from fuse_ring) to be consistent
- Removal of 'if 0' in fuse_uring_cmd()
- Return -E... directly in fuse_uring_cmd() instead of setting err first
  and removal of goto's in that function.
- Just a simple WARN_ON_ONCE() for (oh->unique & FUSE_INT_REQ_BIT) as
  that code should be unreachable
- Removal of several pr_devel and some pr_warn() messages
- Removed RFC as it passed several xfstests runs now
- Link to v6: https://lore.kernel.org/r/20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com

Changes in v6:
- Update to linux-6.12
- Use 'struct fuse_iqueue_ops' and redirect fiq->ops once
  the ring is ready.
- Fix return code from fuse_uring_copy_from_ring on
  copy_from_user failure (Dan Carpenter / kernel test robot)
- Avoid list iteration in fuse_uring_cancel (Joanne)
- Simplified struct fuse_ring_req_header
	- Adds a new 'struct struct fuse_ring_ent_in_out'
- Fix assigning ring->queues[qid] in fuse_uring_create_queue,
  it was too early, resulting in races
- Add back 'FRRS_INVALID = 0' to ensure ring-ent states always
  have a value > 0
- Avoid assigning struct io_uring_cmd *cmd->pdu multiple times,
  once on settings up IO_URING_F_CANCEL is sufficient for sending
  the request as well.
- Link to v5: https://lore.kernel.org/r/20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com

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
Bernd Schubert (17):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: make args->in_args[0] to be always the header
      fuse: {io-uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add fuse-io-uring handling into fuse_copy
      fuse: {io-uring} Make hash-list req unique finding functions non-static
      fuse: Add io-uring sqe commit and fetch support
      fuse: {io-uring} Handle teardown of ring entries
      fuse: {io-uring} Make fuse_dev_queue_{interrupt,forget} non-static
      fuse: Allow to queue fg requests through io-uring
      fuse: Allow to queue bg requests through io-uring
      fuse: {io-uring} Prevent mount point hang on fuse-server termination
      fuse: block request allocation until io-uring init is complete
      fuse: enable fuse-over-io-uring

 Documentation/filesystems/fuse-io-uring.rst |  101 ++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dax.c                               |   11 +-
 fs/fuse/dev.c                               |  127 +--
 fs/fuse/dev_uring.c                         | 1318 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  205 +++++
 fs/fuse/dir.c                               |   32 +-
 fs/fuse/fuse_dev_i.h                        |   67 ++
 fs/fuse/fuse_i.h                            |   30 +
 fs/fuse/inode.c                             |   14 +-
 fs/fuse/xattr.c                             |    7 +-
 include/uapi/linux/fuse.h                   |   76 +-
 13 files changed, 1924 insertions(+), 77 deletions(-)
---
base-commit: 5428dc1906dde5fb5ab283cda4714011f9811aa1
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


