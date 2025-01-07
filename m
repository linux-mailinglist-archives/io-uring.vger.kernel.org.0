Return-Path: <io-uring+bounces-5706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2E4A034C0
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DA80164232
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207E186338;
	Tue,  7 Jan 2025 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="rO0NghWH"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBE47080E
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215123; cv=fail; b=isSucQ3W/KX1A2y34/lXo9SuX6roxUjJUfxdIOGk32fowkodKFVb8YcP/GLblerntTT+pRYqQs7uFixDMd6PGMP56HHkpyRJIASkI+Uhx0/jQRWlD+/drm5/WElY/IyQveoAzypXOAiKdlKYlWQymTuF7plOMv5UJWv+ba/SI34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215123; c=relaxed/simple;
	bh=jEU9v9MQqjXXNTVqVE/JQKAEP7TCQNGW6wzND3gEIJ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QIVqeyL2HgrGJEft4Ceth8Zvu/5F3L/N+cIQSmpAMNHdYsFfoyrb53usZ8ycwfGMIJyen0rs0GiKj64fFps5sCLBC6Y8V1qfPT8LAtd7yTKsx+KAjz0NBENrUZekvkRKHxF6YsVimvqnIrm+wS8B16lZPCHIJ1VnCQkexbhEYmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=rO0NghWH; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2047.outbound.protection.outlook.com [104.47.70.47]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:58:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hyyq0jv+1n7w2Jd3YfHQreI9joca35tpf6I7pSRvlN9s/0sbCotcevsGb3Kv+T/Cjot14cXLDwjw5o7qJZwJQrgWY1DxRmQ0HX9eND1FMtirIjlGzXs4hk6Iij1SxmULgc1+PG28uxWqRjZsLgMhVxkFKqdgQR2BV28HQrQX/L9wQxASupDeRYYFXXKSfSo9m71dvURDch8pQny1k0KthiNIdbTiQv37AVzBZcjTyy9xJPRY6GnMNfzfWhECnb6Udaf9CISy+UshqmWZVeL4oZ/SQfqvCd6hjTqhckrZRC4r1HPFp3Nt76YEbL8JsNRgSfaV/QOZTRTROO/N4VpJjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9CwB0kRTb+2ILbnV3fElttG8j1HgxbuxfCXYQMvVng=;
 b=F03RU3i346EDY+3dIHyhsjisVYuwQ5bckdOcm7m+HjMzVHPVvS5YUC7BFrY1ocFIntx65Y2DGgnP7RbP14BVIG31dunW3Vu97UCjf21kdmo4q1aDUmoxQ1uguZVCEpzXy5ZIvRq7UnvEsFB4fS27sIWE+5GC1qOmEXN5uvJz2UuTUvZXsIHdWNLWwx6E5wXWfiTzEbaeE/tMNtCjkV1v3j1JWbm1/6aT2tEQtcgOPGM05xW5gz57cH6CEkUpVnQDKeW4xtndKsX3wmbUpQmxeHqG8kXMom4Gb+tG5HX86UrrdnRN6gyOGqNg0hJRQPQA9TuksV07uf1ZaoiCUL5LnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9CwB0kRTb+2ILbnV3fElttG8j1HgxbuxfCXYQMvVng=;
 b=rO0NghWHABodpJw3C+QddHr0u5BnZZS1dWyhmbsbBoVMBkjyiXunjBu2zS/rt9eLZCLuEpcA0ndZqRMFIC2/bLh/fBrIY6rjOQDtaqv/maQpnHyY/cBeXojDp4Skx2lq/FFz8gKmaFI+2biIh9RP1ini36mUOseAYsfCGHGX2IM=
Received: from MN0P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::12)
 by BY5PR19MB3827.namprd19.prod.outlook.com (2603:10b6:a03:225::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 00:25:28 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:208:531:cafe::34) by MN0P222CA0008.outlook.office365.com
 (2603:10b6:208:531::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Tue,
 7 Jan 2025 00:25:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:25 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id EBDB355;
	Tue,  7 Jan 2025 00:25:24 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:19 +0100
Subject: [PATCH v9 14/17] fuse: Allow to queue bg requests through io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-14-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=7364;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=jEU9v9MQqjXXNTVqVE/JQKAEP7TCQNGW6wzND3gEIJ4=;
 b=UDwmPC7iXfU+uJPvryzCzfywSg5q2n0bJyJuZfSBnpSOpKCbjHfPQUKTXz0yBX88aUp/iOF5q
 8LfMiCs6ehfA2Ul8aj5oTcDH9Aqj5wcJeoZdbTJGs5joopYNDA+46bg
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|BY5PR19MB3827:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b42fd24-f591-4854-030f-08dd2eb1c835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVU0SWd1MDR6RXRwc3BiRnVNMnBONEVHU1hUbkk3THlLQk9kWVIwQkxIeVdH?=
 =?utf-8?B?NVZwWmtpbk50RnAzd3QvSEtGS0xrOHc3Nk1oeUh6cHg3MUVSWDlxdndpYklB?=
 =?utf-8?B?MGdCOWY4bGJJTWdqZnFDdk5QWUIyY250ek42aDVsMEZPRTVVaW1oSW1aSUlu?=
 =?utf-8?B?WWk5amNrcGp1UisvaHpwaGdQUmVNcGMrWjdGYWp4Z1BpdUdRZldiYTRObHhm?=
 =?utf-8?B?aWlQRmF0SVJRNkQzY1BtWm5wbEZEemJSbFV0QjdIWjlFZVpKcmVEN0lLOXJU?=
 =?utf-8?B?NWpxcEptRVBsekxXSy9iY1hjZjlybENUaldiTVMvU0NMejBUakZQNWhMU2VH?=
 =?utf-8?B?OUJQNi9YaHFnTVdKV1ovSDMwVnNkc292VzRPTGIxdm9wTXFVM0FPVno4aUlE?=
 =?utf-8?B?bXl6YnNSTkdHT1NETzA0S1FGVFg5alBHMGc3Q3pWZmxtWmxFaWg4bExtdkk0?=
 =?utf-8?B?Q1dNWkdyN3loNzdVMkNZNEx5dXQ5cnROS0dPNUg0Z2NjRGx1QmJLU3NzUTRq?=
 =?utf-8?B?elpMY1liUmFmYjd6MU5VeGZZSXBLd0N6MzJUcElvQ2xKSFAxSjhPd3FVMGUy?=
 =?utf-8?B?eitlb0ZKUSszTXBDR1IzcStCM1N1YjR1SGdOSUVGRHpUVURXSUZyTWJvbDRW?=
 =?utf-8?B?UU1haFAxM0hQV1gzbTBXL0FGNWdWdzg0dFlnTkRCcGpadnVyWWl0TEVSUXh4?=
 =?utf-8?B?QjM5ZDlFenBZeWYwUVh2QXhweFpMSWsxTVNBaEdSWEd0cnd0TWViR3Q1Vkhm?=
 =?utf-8?B?bGxLQ0srOW9RYWdUdXFKaVRtWGt0L2krZkxJajdnd3JMdHpGd05vcjB4YTNr?=
 =?utf-8?B?cWU0Rk5Walg0eS90UE9WZzg0S2NYcWVCMVN3QlhPRnc3eGtGWmhwbW1WODJD?=
 =?utf-8?B?eWRKSWNnQzZUQWE3akwvcWZVQjNoMnQ5VDMwSjJ2WGhKY3g0dU5ubXhnMTI3?=
 =?utf-8?B?d2ZJYmlYMk1RcU5JajFjdnFkejhEcDN0bEcyNmNKcjYwQWVMTzJpL0MweUh1?=
 =?utf-8?B?bkZ3NE04U1JwZWdpczN5U1lvTXYxaDk4Y2tHcHd3a1V4ZndydmJ4czN2c0s3?=
 =?utf-8?B?VC8wUnZaRnRrRHZoak5DaGpXVFI3SUZ2MG14REpEOFRQZ25MakFxbUh6WUxV?=
 =?utf-8?B?ejRxdENjakFUeFozWWdNUk1GMVI4MCttWngyREcybTRCc0dTRk9vUXBWWGsv?=
 =?utf-8?B?Zm9XMUlHTXRMYisrOFV1eFg0L3l0dWRSQW9QajJLQzhUNkNsRGU4Znp0T2FO?=
 =?utf-8?B?dmFvY0xMU1VKN2JvZTNidXZhRHNCWXhDQXF4dWJoQUR3ell4ckhPR1RpTFhx?=
 =?utf-8?B?NEdmSC82d3dJYlR0SmdnNUJOMHRsR0ZUdmkrdXlZbDVBYlF5MTZWRUFBdU1I?=
 =?utf-8?B?WWdjN1ZYK2NoSC9IaWwrUnBiSElacVdCNVZydGZjZk1vUW5zL3RlMDVqSHJz?=
 =?utf-8?B?YVY3TDlUcXpvSVhCNWttWDBhVy81NmpEQi9paWJVZXByNlRvNDAzMXkyT3I2?=
 =?utf-8?B?cVJ0eGV3U3UyWmh6TmpVTXN2ZHZmSXlqU2JjY1o0WVdSVU5PNnJpSjhaRGd1?=
 =?utf-8?B?VjMzd3o4N3E2RE5FNmtHQ2NDbFhaUm0xN3phQ09DNXRpQkZFUlR5RHhCanN6?=
 =?utf-8?B?cFYzWTE4L2pZRFRMMXdicWp2bWRnZTdyaDJSVGpTTlJTTFkraGUrbi9lRHJN?=
 =?utf-8?B?UTZuaXVBbzZNQVVZanl3dFV6cXVCR09ZNE04T3VQZXowdTg2dThoQjl2a2ZL?=
 =?utf-8?B?QnNtckJEYUJTclcwQUxNSzRodUJjc3NmSjZrTjkvdUdvOWY0eHlPQ2dNM0ZX?=
 =?utf-8?B?UEZ3VCtPMXk1TmtjSmJudTBPQlZzUlNlNW5NV25WREdPNFNuZTVUdXdwcDBl?=
 =?utf-8?B?b2syWGxyZDg2R3R0NHdIMDJvK20rYkxpQkxtUUNFUXF0UUlXZ3RQLzJISHEy?=
 =?utf-8?B?QXQvQlYrS1V4dndPWEQ1TlYvbVZRb0xIUWdqZ09lYkxwa0g2M3FXKzVJeCtO?=
 =?utf-8?Q?NfQItV0eVql+xFThUz5OGL+3mf59s0=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZJ/qgS3daBMEtsqT1fqvGB2ZmDoWUJiTGI2XBcEUyE4itC1zCMGjkCgFcqmTIrQPUYH7cPIC0kJbXruzOj/7xs1lcJgR+nhkA08Lk9xNpGwlyk+dxqIzAYOdw72WP0vLSxvlcasSxxHCWv7cHAsOBPeJ72SqpZLNQ/1Q4bcMWPu5GlVpBpToEtWHjaIZsXiQd+pijB0zgiBK+9D2uWFM8OHQj2fD5+91c4M6dVxuZ4RRvPJio6v7tZMUETCWmZuW04K8iSfGDLAg6X3xd9wPqjgiOLc93y8AvBC1AhLUNuessx9pED+TwMhue3SZ17RrmR0LsNdoX9DPeVzWPqV/bpaxKH8yKnk7g0yHDJgkvTiMqEJi5dE32VJYv9kjzEXQsfbsaWSGS30nycjx+auNFjY7EqtKfBdr1DARQCcZqS9PGq0TO9lGI9hCdIdH/fdfvlkqHfQ2ogmklPvlNgZHNbFCEwelqd8kI4v7vtPGO9SLrT8c+zwTqCEM8eLHdzgpWpJ/uszeMScYCFlvA+LnuxZiz/rC/lerunBIuMTXB9najGGn+pc6z+bItK7VH85WB13BOiHBhchV3WmtUSTcx7BOZDnLLDL2Hg3PtJMen6/y+vRvv4wCZ/HNDcxmFEphYVSwY6okSiMiAf/Mt53hGg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:25.7922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b42fd24-f591-4854-030f-08dd2eb1c835
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3827
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215117-104050-7681-51592-1
X-BESS-VER: 2019.3_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.70.47
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuaGRpZAVgZQ0MDAJMkszdTAwt
	AyNdXcyMLYKNUo0dTEzCjZwjgtzdJAqTYWANB/gWxBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan12-178.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending background requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 24 ++++++++++++-
 fs/fuse/dev_uring.c   | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h | 12 +++++++
 3 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ecf2f805f456222fda02598397beba41fc356460..afafa960d4725d9b64b22f17bf09c846219396d6 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -568,7 +568,25 @@ ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+#ifdef CONFIG_FUSE_IO_URING
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	return fuse_uring_queue_bq_req(req);
+}
+#endif
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
@@ -580,6 +598,10 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		atomic_inc(&fc->num_waiting);
 	}
 	__set_bit(FR_ISREPLY, &req->flags);
+
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+
 	spin_lock(&fc->bg_lock);
 	if (likely(fc->connected)) {
 		fc->num_background++;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 89a22a4eee23cbba49bac7a2d2126bb51193326f..4e4385dff9315d25aa8c37a37f1e902aec3fcd20 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -49,10 +49,52 @@ static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
 	return pdu->ring_ent;
 }
 
+static void fuse_uring_flush_bg(struct fuse_ring_queue *queue)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_held(&queue->lock);
+	lockdep_assert_held(&fc->bg_lock);
+
+	/*
+	 * Allow one bg request per queue, ignoring global fc limits.
+	 * This prevents a single queue from consuming all resources and
+	 * eliminates the need for remote queue wake-ups when global
+	 * limits are met but this queue has no more waiting requests.
+	 */
+	while ((fc->active_background < fc->max_background ||
+		!queue->active_background) &&
+	       (!list_empty(&queue->fuse_req_bg_queue))) {
+		struct fuse_req *req;
+
+		req = list_first_entry(&queue->fuse_req_bg_queue,
+				       struct fuse_req, list);
+		fc->active_background++;
+		queue->active_background++;
+
+		list_move_tail(&req->list, &queue->fuse_req_queue);
+	}
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
 			       int error)
 {
+	struct fuse_ring_queue *queue = ring_ent->queue;
 	struct fuse_req *req = ring_ent->fuse_req;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_not_held(&queue->lock);
+	spin_lock(&queue->lock);
+	if (test_bit(FR_BACKGROUND, &req->flags)) {
+		queue->active_background--;
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+	}
+
+	spin_unlock(&queue->lock);
 
 	if (set_err)
 		req->out.h.error = error;
@@ -82,6 +124,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 {
 	int qid;
 	struct fuse_ring_queue *queue;
+	struct fuse_conn *fc = ring->fc;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		queue = READ_ONCE(ring->queues[qid]);
@@ -89,6 +132,13 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 			continue;
 
 		queue->stopped = true;
+
+		WARN_ON_ONCE(ring->fc->max_background != UINT_MAX);
+		spin_lock(&queue->lock);
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+		spin_unlock(&queue->lock);
 		fuse_uring_abort_end_queue_requests(queue);
 	}
 }
@@ -194,6 +244,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_w_req_queue);
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
+	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -1141,6 +1192,54 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	fuse_request_end(req);
 }
 
+bool fuse_uring_queue_bq_req(struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ent = NULL;
+
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		return false;
+
+	spin_lock(&queue->lock);
+	if (unlikely(queue->stopped)) {
+		spin_unlock(&queue->lock);
+		return false;
+	}
+
+	list_add_tail(&req->list, &queue->fuse_req_bg_queue);
+
+	ent = list_first_entry_or_null(&queue->ent_avail_queue,
+				       struct fuse_ring_ent, list);
+	spin_lock(&fc->bg_lock);
+	fc->num_background++;
+	if (fc->num_background == fc->max_background)
+		fc->blocked = 1;
+	fuse_uring_flush_bg(queue);
+	spin_unlock(&fc->bg_lock);
+
+	/*
+	 * Due to bg_queue flush limits there might be other bg requests
+	 * in the queue that need to be handled first. Or no further req
+	 * might be available.
+	 */
+	req = list_first_entry_or_null(&queue->fuse_req_queue, struct fuse_req,
+				       list);
+	if (ent && req) {
+		struct io_uring_cmd *cmd = ent->cmd;
+
+		fuse_uring_add_req_to_ring_ent(ent, req);
+
+		uring_cmd_set_ring_ent(cmd, ent);
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+	spin_unlock(&queue->lock);
+
+	return true;
+}
+
 static const struct fuse_iqueue_ops fuse_io_uring_ops = {
 	/* should be send over io-uring as enhancement */
 	.send_forget = fuse_dev_queue_forget,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index cda330978faa019ceedf161f50d86db976b072e2..a4271f4e55aa9d2d9b42f3d2c4095887f9563351 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -82,8 +82,13 @@ struct fuse_ring_queue {
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 
+	/* background fuse requests */
+	struct list_head fuse_req_bg_queue;
+
 	struct fuse_pqueue fpq;
 
+	unsigned int active_background;
+
 	bool stopped;
 };
 
@@ -127,6 +132,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
+bool fuse_uring_queue_bq_req(struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -179,6 +185,12 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
+
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return false;
+}
+
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


