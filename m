Return-Path: <io-uring+bounces-6074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C38A1A630
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1A743ACB19
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BA2212D9C;
	Thu, 23 Jan 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="OzIqDF3W"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268EC211495;
	Thu, 23 Jan 2025 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643903; cv=fail; b=lGmA45LpipR2HyR/senUQO3aCN0xcNqjvop8X8Sbes5N3GXDwcalgQEjiyTt2zQkOJqQvC7XpsJE8qiyXBTma4TTyaIwswV0rSM3td1FJ/lpQ587FFJvekDBOIaFJAjJWUBXrwSynOM6jgsrMu4D2l2/sHERqFz+ftwsFID7OMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643903; c=relaxed/simple;
	bh=44YYi/kSi4ZAcLrMpgpKiyXupXSIkJHnY6zAgbMWRzM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dGfK2qimUIoOTVEn4r5d0yztwvl4ClZjAuvDJ+nnuCGF2YvF0VRi373bKu5YC+RV7Ilj/fbTNkxEnCcPZI5AnkEmKR7ENgbVKx6KjQ5QHCovO+RNUjRTBdlrv9O0rBTo9W9+4j2q4gEd0elEGA3zO9G4IzAPA1MZ0wMmuVsrWOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=OzIqDF3W; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44]) by mx-outbound13-143.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u6k/rHauswj94//vYzX6tfe0BhDxhoKKxscjDdRR+aR7eXobMCnlbig/pSqBt6z7zhNeNjVvsv6gevakrergfjgExUmYqYOfqs9G2RchSPQhiK4EHO4AVIu7oTMiP8BKuW8Nf3N/RXrz+afEyPkRoyz1c1GsIttwOgs2PljIPhsvJuR48ioHrhXax7CZWY9hSGovmE2dC+v1RoILNwkNiyXcf/I44Tk2GEMSV5EUhbRkA9+DtGLMP4175O48G9Hq8iIXnxeNVY8gZd07YCi8AUnyebvKQBiT3YH2ZqFKStBg83TO2rwPBYtIHnZtV2YYl/72D9HRHcFaDshqnw2CnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sELY9LhD5ytR+A7X2vaSqjAAqj8qDNG14rcNuOSHmDQ=;
 b=Zg1qxSSN3faXrXFiGd/cdioNBNrG562KL7EXYzxQNr2ntR/ziAypueWlFMewXm2mppn4KbW3HO9lYd7foXrMZy0DZW0f5CHdLXN2h8ADIkO3v7CXzKAzJHX6B3SBV/jvCrAHo7f0mj7gGkXhsMWlxqBCruixluKgIuGiOJ2FG+GBfMch6V/EUm25QYsmIcPXKFdZ+k87/Xg3S2RMDpRxg5Pnot8dV72q3IWasMZK/45K7UGaxtoSaO25+kH2lOhHZItX2OpZbM2gK6JqqBxf+debmAOAGzkROjp5hVpKnaJQSOYLMNghszxnG9VLqy/NFJ3BnoOIqvelyG07KWpnww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sELY9LhD5ytR+A7X2vaSqjAAqj8qDNG14rcNuOSHmDQ=;
 b=OzIqDF3WBe/iqAI5HBHrhe3j/DArHELWysaK2CAicZqkd6fj4NW1bf6hbplHq+NGQjwClhF5yVZYfDsxDAW8vCWy36rsqIgOwU2P/mvDs+9RcpSOVj/JrBmL7Gmrbh6UoIvvmNbTJ6tJd0P0WqXl7aArnzej94brkRpLAOlYRfQ=
Received: from DS7PR07CA0011.namprd07.prod.outlook.com (2603:10b6:5:3af::22)
 by CYYPR19MB8029.namprd19.prod.outlook.com (2603:10b6:930:c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 14:51:26 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::4e) by DS7PR07CA0011.outlook.office365.com
 (2603:10b6:5:3af::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:25 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id CB46658;
	Thu, 23 Jan 2025 14:51:24 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:12 +0100
Subject: [PATCH v11 13/18] fuse: Allow to queue fg requests through
 io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-13-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=7100;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=44YYi/kSi4ZAcLrMpgpKiyXupXSIkJHnY6zAgbMWRzM=;
 b=ly2YL/8ypmVjIMlx8VHqLtIvjlSqbjzyY7fHcMqJ1efnJpG/GDJYQnkCNcWdgp9sErty7GBhN
 tJv9suvLhuaCzSWghryW2PAOZR34ZH0xz5GxhN4XHHl+7qINa2rYOB8
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|CYYPR19MB8029:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c372cf8-2e37-434d-e90b-08dd3bbd6915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dm9UdHo0RWJNUzkvK09wT1ZDbyt3dE9DcGxsZEtsNmJSWi9TTitqUGpNaUQz?=
 =?utf-8?B?T292V1BwTUJJcXlMdTczY2N5Szl1T0pzejJXSzE0dFVmdjV4MnFIYlFNZjVC?=
 =?utf-8?B?Y0FGQjFvTmx1Q0RKWElvb2M2UlkxNlE4SzFnSU41N3Uvcyt1MlN1Tk5teU1a?=
 =?utf-8?B?MXVUeGF3WW04WDZSdVVQL2NvOVlSV3R0UVNyUEJ4WDRjdk80TmRCbCt0cjNr?=
 =?utf-8?B?cnFoRys1NytTSERQL2hFUVQranROVlUvenROZDBjZjZrTlRBYXY2UVZ5dDlG?=
 =?utf-8?B?dm1FMEVnd1Z5YlVlS3grQk1jVmxpODYzSTF5YWd1ZXpUZ1ZzTGxxejRUYW45?=
 =?utf-8?B?ZEpPR0lpdldNa3UzT2NNdHpIcGM3OHM2L2owYUhxZ0xjYkJuV0V4RmJ3ZXdT?=
 =?utf-8?B?K1RVN3p5cXdwR0JxZHdjb0RSNGlKOCtKRWQwdlJqUlplSXVVOTV0SURodVM5?=
 =?utf-8?B?NHo4dnoxZUxBNm9ZbGtOV0szZDFzMUVMRXFLbm1PMFQrQXpGUWluVnA2alZJ?=
 =?utf-8?B?M2M2QjJrcU5Ra01KZ0ZTRm1QaW13TWlra3BhSVFBNXJWSVkyOVFzV2VKcGp4?=
 =?utf-8?B?SG1pQXhrZlF1Z2Ywb1plSWhSNzJ5dEdEcXhWYU1Fd2dMaTczN2tGNFY4U0RY?=
 =?utf-8?B?b0k4eW91S0xFU3FIYXdrR0pIZ2hEUHVubzlwZ0dHeFk5VFI5LzgxWG04ZWtk?=
 =?utf-8?B?akVDaFhMcmJpQ0ZrMzlVRGJqWDV6bkxTUlpuNGxsc3hZKzVla1NCcWpPb0VH?=
 =?utf-8?B?a09NSVNkS0hBWjZpZSt0SUpvc1I0cW9mV0QzM0RIdnJ0cFljVDQ5WmNEL1B1?=
 =?utf-8?B?UkFBa0JRTWNBMkFUWlFlUjNaT1g2QSt0YTBibDBTNVhYSG1LUWVWWEovK0NB?=
 =?utf-8?B?eHJsQVplVWlZekx0SHN6ZVAyd0dzblNJS2tLOSt3QVNRWHBjTzZEVDExazFm?=
 =?utf-8?B?akY3Zk9JRVg3ZXR4WkJ1ME1WNFFnNXh3SDJVUURPdGVtYlpLRUVzSWhDeklT?=
 =?utf-8?B?VlM0VmNiZndlVVlJYkc4QXJxSm03TDA2emxZR3M3N0MrVWVSWnA1ZGtBcmc2?=
 =?utf-8?B?MUgwaG0yOGt3MGVwRG1NeXZNcklJSDNnd3ZTRC96WUgwYVBTUTViYTJNQi9F?=
 =?utf-8?B?ekwybjMvd0JrZzMxTUtTam1USzRWMmVNcVU3QUtTaitiaWV6UUFqWkFyS1Fj?=
 =?utf-8?B?QWR5cEhpMVc3RXhJV0tTNGxpVUc3a1hmbXBJRVp1R2tKL1VDN3Q4T2IveFA1?=
 =?utf-8?B?Zk9NRExZdTJQOTVvT2trZkFJY3RNL0paWGxza0xuUnlCa3c1aFJUTmVaY3hD?=
 =?utf-8?B?d1Y5L0M5MjhUMDRhVjFiR1duZERGUzkwZDRTVnlRaXBvdEJKMEdTM2pGa2pH?=
 =?utf-8?B?QWhHcllReVZTSmkrRVJGUGQzSjlObmVrWUxsRlpLUkhDcHFJd3lublpoaGxt?=
 =?utf-8?B?US9tYVF0UHIwNWVoK3crT2NqWHk5SEQyV2FSRWFmZEhOUW9vcUNVWkloUDBv?=
 =?utf-8?B?SXV0dHFKbTUxamN1ZE5HMFJMaXEzZlN0YklQMGIyV2gvRXgxR1NZcmZnR1N5?=
 =?utf-8?B?dzBYV0tSMDlrTzNleitvbmxwb1hPb1gvM1kwQ0ZMelExS0pHMEVzL0pramRt?=
 =?utf-8?B?WHhZTW9jUkgvbjNsdVUwc1BNdTVWRXRGSktzSHp0U2dWcmQ1QlVSWTliTmN5?=
 =?utf-8?B?dFpucmo4ZUlCR1J5bEFReTJHZEdSbjdEYjhsemVJUUxCMVJYRzJ0NW85NTJB?=
 =?utf-8?B?WW9EczBIWVBDZGcybi9rSENMWU9LdHJwdXVyY2V2RjhSU2pDZFJxbXFERlNj?=
 =?utf-8?B?cmEyaWpDMTJSWGliL3ZRRHY3akJ3K2pwRU54NUNEZWJ5bTFRaGtNdXBxajUw?=
 =?utf-8?B?MFRUQ2pHRkQ5a2cyb0kwSFdSdCtyLzJoSXNiQUc3SnFmMTAzNlB4V2o5Ujdv?=
 =?utf-8?B?MFNWS3ZpbUI0dGRCS25zZXArWElVYUVkSVR0ZXQxczlTOERZYXdZTUVxcFVv?=
 =?utf-8?Q?d8NAio4IVrM7ZiXXCUuPibUXbwdDkM=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fZgJ/A9gUDhP6LXQsxuDH6MDTPNOwWOQD7+iCXs0HMyqjsW4UzVwLdPSKyCsDTnBkAA2oHSLWIW9by1PVQmYz9bV/IxT7LRTCDyxndYMha5UnEVR6DaorVdZrN4d+VEvz1osg9XmP6BxCSdmkibbDvfM5WViF8qMtzCSczSIC5r4DHv9l1aiYHR4ghmTvZyICLRJDLtVPyTuIZqiM80gJdJp/6sDOA9AmxCWGhYvUogHd91nU8W/VwCNKJkja88wYYzpiN0vsNLNN63xpQa7ca61uNXhqGI7BeDJNTIttQhOW+RyvBf4u7Y15tWSrNDtPwjs2wfqTpKvZtAyNIm1HYQ2b+a8yyX8XlAsms5Kzzm0WkKI45w07vdVuxkxe1cz/SYazDhdJJcXPnoU5oNq6izk99DE+wp2NQiWOvNXBHFNm0Y05VhNIQ4J70jPz9PiB7U9hXjgUaU29bWirROe6IKb9JYlS+N64IxVBpji6gToYPl0YFDEOIbZ1vQMv/94j7OBR+fzJgDV/UWcmJtcE7t6Z2mbtRfXFXQdZrS4odE2EI/Xx0umsrHgv4PNH+My7HN7ZPG1oTX8tWi9RAIIWYTLfb3wniLy7Zud58HC16nS6tfOpDKZCCvo2oadNZgNr2Y/3ZPVFp7gozD4rRiGYA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:25.3911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c372cf8-2e37-434d-e90b-08dd3bbd6915
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR19MB8029
X-BESS-ID: 1737643887-103471-13468-443-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.74.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmYWJgZAVgZQ0Cg1KdUiNdEozd
	LM2NLSOMXMwjQpzSjF1MQyxcjcMslUqTYWABHhCg5BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan8-114.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending foreground requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev_uring.c   | 180 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   8 +++
 2 files changed, 188 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ec5ca294a4fab42c31f1272c2650ca23148cc2b6..d5de116ec136f806c4490fc446a0fa0f3aa79e2e 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -24,6 +24,29 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+struct fuse_uring_pdu {
+	struct fuse_ring_ent *ent;
+};
+
+static const struct fuse_iqueue_ops fuse_io_uring_ops;
+
+static void uring_cmd_set_ring_ent(struct io_uring_cmd *cmd,
+				   struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_uring_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
+
+	pdu->ent = ring_ent;
+}
+
+static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
+{
+	struct fuse_uring_pdu *pdu =
+		io_uring_cmd_to_pdu(cmd, struct fuse_uring_pdu);
+
+	return pdu->ent;
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
 {
 	struct fuse_req *req = ent->fuse_req;
@@ -774,6 +797,31 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	return 0;
 }
 
+static bool is_ring_ready(struct fuse_ring *ring, int current_qid)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+	bool ready = true;
+
+	for (qid = 0; qid < ring->nr_queues && ready; qid++) {
+		if (current_qid == qid)
+			continue;
+
+		queue = ring->queues[qid];
+		if (!queue) {
+			ready = false;
+			break;
+		}
+
+		spin_lock(&queue->lock);
+		if (list_empty(&queue->ent_avail_queue))
+			ready = false;
+		spin_unlock(&queue->lock);
+	}
+
+	return ready;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -782,11 +830,23 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ent,
 				   unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
 	ent->cmd = cmd;
 	fuse_uring_ent_avail(ent, queue);
 	spin_unlock(&queue->lock);
+
+	if (!ring->ready) {
+		bool ready = is_ring_ready(ring, queue->qid);
+
+		if (ready) {
+			WRITE_ONCE(fiq->ops, &fuse_io_uring_ops);
+			WRITE_ONCE(ring->ready, true);
+		}
+	}
 }
 
 /*
@@ -970,3 +1030,123 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 
 	return -EIOCBQUEUED;
 }
+
+static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
+			    ssize_t ret, unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	spin_lock(&queue->lock);
+	ent->state = FRRS_USERSPACE;
+	list_move(&ent->list, &queue->ent_in_userspace);
+	ent->cmd = NULL;
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
+}
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ */
+static void fuse_uring_send_in_task(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
+	struct fuse_ring_queue *queue = ent->queue;
+	int err;
+
+	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = fuse_uring_prepare_send(ent);
+		if (err) {
+			fuse_uring_next_fuse_req(ent, queue, issue_flags);
+			return;
+		}
+	} else {
+		err = -ECANCELED;
+	}
+
+	fuse_uring_send(ent, cmd, err, issue_flags);
+}
+
+static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
+{
+	unsigned int qid;
+	struct fuse_ring_queue *queue;
+
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr queues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	WARN_ONCE(!queue, "Missing queue for qid %d\n", qid);
+
+	return queue;
+}
+
+static void fuse_uring_dispatch_ent(struct fuse_ring_ent *ent)
+{
+	struct io_uring_cmd *cmd = ent->cmd;
+
+	uring_cmd_set_ring_ent(cmd, ent);
+	io_uring_cmd_complete_in_task(cmd, fuse_uring_send_in_task);
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ent = NULL;
+	int err;
+
+	err = -EINVAL;
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		goto err;
+
+	if (req->in.h.opcode != FUSE_NOTIFY_REPLY)
+		req->in.h.unique = fuse_get_unique(fiq);
+
+	spin_lock(&queue->lock);
+	err = -ENOTCONN;
+	if (unlikely(queue->stopped))
+		goto err_unlock;
+
+	ent = list_first_entry_or_null(&queue->ent_avail_queue,
+				       struct fuse_ring_ent, list);
+	if (ent)
+		fuse_uring_add_req_to_ring_ent(ent, req);
+	else
+		list_add_tail(&req->list, &queue->fuse_req_queue);
+	spin_unlock(&queue->lock);
+
+	if (ent)
+		fuse_uring_dispatch_ent(ent);
+
+	return;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+err:
+	req->out.h.error = err;
+	clear_bit(FR_PENDING, &req->flags);
+	fuse_request_end(req);
+}
+
+static const struct fuse_iqueue_ops fuse_io_uring_ops = {
+	/* should be send over io-uring as enhancement */
+	.send_forget = fuse_dev_queue_forget,
+
+	/*
+	 * could be send over io-uring, but interrupts should be rare,
+	 * no need to make the code complex
+	 */
+	.send_interrupt = fuse_dev_queue_interrupt,
+	.send_req = fuse_uring_queue_fuse_req,
+};
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index a4316e118cbd80f18f40959f4a368d2a7f052505..0517a6eafc9173475d34445c42a88606ceda2e0f 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -117,6 +117,8 @@ struct fuse_ring {
 	unsigned long teardown_time;
 
 	atomic_t queue_refs;
+
+	bool ready;
 };
 
 bool fuse_uring_enabled(void);
@@ -124,6 +126,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -147,6 +150,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;

-- 
2.43.0


