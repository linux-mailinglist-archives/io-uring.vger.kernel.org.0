Return-Path: <io-uring+bounces-4957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB479D56A2
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43F671F21B41
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA7D15A8;
	Fri, 22 Nov 2024 00:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="c7deaYxK"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293CB10F1
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234642; cv=fail; b=BkYJ0FTpYJ+H+C3QkIa9PUZ2ddSxjAOZZEIhZPLDRCXFShBL1nmstf5QoaedEC4sfrt9d3Gy68a6+L02g4a9FdPqc3v+AJe0mJ/INgJsyEExvzAcog8nN/0D+Qc3er7p9II524IM3TBKwZysdmZLD4ePn2lpVeKuXFmVDT6uI0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234642; c=relaxed/simple;
	bh=YF145zkUB7cYx+0Rk1Z2Wg1AFIYTLqbVRhKe5LqNvDA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gF/0d2gRPtSFteJjOD5QJIRhvBW649+kPgZYZvaNGJifahi3caYRqK0OZhE//SytpqzQG97di3C1P3JI96JTuYuX4hvpZm1lD329lEQZ4Y+m9/Ko2mUX/PekvTc4QBQtGhlG0Tpn/VExSy/zvAIMi32zzFhs+cShXplb7DvBWMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=c7deaYxK; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169]) by mx-outbound47-71.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:17:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G93tkcIekbJE7NXf6S0SYOcm/kAW1t00PfMcHpesJj41Eto4qe2O610x6xA8OrrI2Yp+qtNCATMyyx+Opn4dVpeazmGMjTw+c5aP942mvTmSYMp0qNKhwtMNy04hiW7kSwXvkzzv9qq60UhRMROoqkt1qsTyXLUhYFewQkTjKbQspUUFUgZWt2iNU9xK2tNHbIWEatMS7GW6bxb4ivPweGoDb1G89mqviHOY5Q9VaH3GyQIhiK9oZQ6JJQ9i6WbCOmplCV8vg3bPJKwMkUlGQ+kKH2EHngzQN99oIJD5FUOEY+2Zh35UpPJCLmLvpH8ROYrw1eHBGVqcHeQyKueyYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+50uXvpQ5qI9g4ehAfVRZtXE7FrOTbcJt349uDKqEj4=;
 b=iA05a8xjwSVQu29/nFarQ/9UZVVHubvgP9Uu+o8P/qzWOXh2GvrtPzFq41DlmJUX8z0+lOlKTYD2YOA60wKOZ7kBzs5R6n55OBtaavoBuJTNwMa+Yk3CoF/kuwlyjQOp8qf1G5jWmrS1I0U89IgnNV6XMLPyArKmqU2Riv2YvBMPJo2oDiAoGxYK7Jqwo1bHZmPc8IlKCuSTI8AaNdVFzYZXbcs9XwylBv4ROgYvZ/NpOnOcAB0iu74Fl81kR4LZ03x+x4Vi+lezsa2h9Jl4r3XXYpnHX/gVN6k/zseyd+D45V789e5JmgTaiZPsFIrdBPkQ4ep+9OBlsGXycIzjaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+50uXvpQ5qI9g4ehAfVRZtXE7FrOTbcJt349uDKqEj4=;
 b=c7deaYxKZ/s0nDgBcbxzFRPsEUSHAb6Lo8kSc6vCWy52S9FGVrzaAnD3jo03S5PkYbiomgtv7nOcVGYLDdO2+BfOUj10OJv0xRt7x2YfIQkn57oBksJwlmAftRvMarXqNaaT0k39jJ8i4hfbRk9Ua1DsGugOkpQU+GY7H1qHLyI=
Received: from DM5PR07CA0105.namprd07.prod.outlook.com (2603:10b6:4:ae::34) by
 MN0PR19MB8300.namprd19.prod.outlook.com (2603:10b6:208:3c8::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.26; Thu, 21 Nov 2024 23:43:58 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:4:ae:cafe::57) by DM5PR07CA0105.outlook.office365.com
 (2603:10b6:4:ae::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:57 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id BF4F732;
	Thu, 21 Nov 2024 23:43:56 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:23 +0100
Subject: [PATCH RFC v6 07/16] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-7-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=3665;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=YF145zkUB7cYx+0Rk1Z2Wg1AFIYTLqbVRhKe5LqNvDA=;
 b=EwYzswPXQGoQEhzWWCh6z3MdTIDvexwk9qA6/28u3drSd7/YT2ogDIMK6+CKqeQCRf+gpDh5m
 JUglYEouXZRC2sCxIxv0d4P03xgObYchrr4+z87aewKHVb8GMeGXr3n
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|MN0PR19MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: 078bf8e4-9499-40fb-374c-08dd0a865e0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?OUx1U2JvQ3JaRDM3YXU0b216dGdKaFF0NEpSV25DaEtBL0hZRGFmaDFKMGs4?=
 =?utf-8?B?L3JMUlJINGFiblJYSE1RNmdnYzQrWjd0MnhrdVNGVXRqc1NPV1Uyd1pZVU4y?=
 =?utf-8?B?RVB6ZWxDR2kzWG8yZU1nbFN3N3ZhR09yeTh3KzVyZzkrTDhqNnpwV0p3RWFJ?=
 =?utf-8?B?cFQ2SU1vSG1PTnJEQ0pjS2NWaUEwVGxBS0lWMExqNVptRlNhOFVNS2syR0Nv?=
 =?utf-8?B?SjcrU25wSEZHd3RsSTRESWN4N0NaeElRK3hSTEk5U3hDVG9xUXlqYW04dTF0?=
 =?utf-8?B?L25sOEZGZGpsdWNKY25vTnpJU0liaWRYaWxTM1VrcEUra0NyWTRiYnJlbzdR?=
 =?utf-8?B?QnFhVyt6bHNIYzh4MlRBRXA4UWt5eUNzQ2sxTmFXbGltYVhua0sydElNWGpD?=
 =?utf-8?B?QWkzUXNYYXA5NGJiblp5T0NNQVdxRWtkNWJHaFQ0MFNCbjhNWGlmUUFQRU5y?=
 =?utf-8?B?bFhkbyswaVBWSFJoTWRweU03K1JpV2YrcFdhSVVDam50OUpJZS9FNXdjRFU0?=
 =?utf-8?B?Wk1YZWlFTGFSVERRblpxamJaWE1SQTR3NHFPRjhJVGRhVGl3Z2RpeFAvSWM1?=
 =?utf-8?B?ODAwdTBMVWQxU2taMUJoRlF0b3ZxVGFuYmtwZFpTK20veUs3aE1sVXVHTkRN?=
 =?utf-8?B?MVE5cnY4L01lTjVSWkl1VVlHMlkwYTcwOEdTM0hXL1RMOE81eUtxTTlBUXNU?=
 =?utf-8?B?REQ4eUpva0I4WEZDd3JxY1FVSnJqSmZiYUhqTnRMWWJyRlVJMEZ6UWFmaHU0?=
 =?utf-8?B?RDJ1OGlYVnNyUk1VT0JVNHV3ZGN6RVZuVHE3SlV0ZEt0OFFBa2ZQcHZZd1h1?=
 =?utf-8?B?YmY2QmJHaFVTQitpTzhKOXcxdWRBQi9qTWJJbE9JejB4TnRLakF2S295M0ZS?=
 =?utf-8?B?Y0EwS29QSTZ1Q3J2Y1o4SlZSeHJ2YnI2d21DWXBSd0prNksyWG1yYXhiZHYw?=
 =?utf-8?B?ek5LK0QvaVh6SGJUQWNVSkdqTEpscUJINFBSSG9yekxXRXc3TStWUVo1ajNn?=
 =?utf-8?B?dDB4SVNycFVicDRwQTFlRWg5a0dCblk1REhtMGd2TkFtYlVOSVdxSlpTL0gw?=
 =?utf-8?B?cDVUQUU0Sm9WWXJGTThrRms4cHlJQTNrekpsRFB3UlcxRytTQ2dsd3p4ZDJT?=
 =?utf-8?B?aWhMcGZxS2dFaFFKSnlEVVFSTjloZHEyUFY0R3lEaEEydmdyMno2K3c0RVZU?=
 =?utf-8?B?a2V2OWVZMTl1eTNGS2dBcUkrSnNYcjdNVVBsQUU2U3hmbjkxcXRXS21VL2xE?=
 =?utf-8?B?OGp3eVROdjhQaDBLQWhuNGxpczllRSthblVwNS9IejUzSU9vMkcvVEozandv?=
 =?utf-8?B?dGdBNEJoTGtEcTNMYVQ0NkUzZjF4V1o5dHloVDZvZHhmdVVUbktYRXROQVlR?=
 =?utf-8?B?RGlQSUxSL2JzaFNXRnlzNTdmT0JVbXliQWIwa1hjZGlGcFJRYWdJNk00bVpJ?=
 =?utf-8?B?K0hEZVArZGhUaS9PQWlEWkkwQmN6Q2t5cjZZM0F3SU5YNE9OS3JGR0VjdXkr?=
 =?utf-8?B?d3pLQkFYMWU5MEQ5QzdmYUM5dUZnZDhkaURnYjJMR2dKenpCZnh5T0pMOTBO?=
 =?utf-8?B?U256QmYzeDVHWkdKcGVEdkpveGhqcWVkd3k3WDJEZlhqVnl0MHJ1bGFFb3hH?=
 =?utf-8?B?YnNxbGRrRC83TUhLdVNnTG00b21JMWIrRnVhaUJySFdWNWh2c0RoZGcrWjNl?=
 =?utf-8?B?NnBNRzZOQjJHWmhBSTdLWUhUcGYxQWZoUUY2ZHY0TFZhUnlsclEwZjNyZjNT?=
 =?utf-8?B?dDF6UGRyd0k3dFdoUVdsRjZoWUtpTHFKeG1lL1RyeHh2b0JWR2lXa3A5UFBI?=
 =?utf-8?B?ZXdwbEFGbi9vUDBQMU04V09XRHFpVWdSQzEyTzI1emRDdW9SK3c1amtZbGNv?=
 =?utf-8?B?bFNCL0RMOVZZdnRGT3VJUmwyd0FWVDJGcHhuR3lBZE85WWc9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 9mifbUQaRwt+dw81oO04rrsNDeHAs9S1St4YTQbKiZKxrsSuORIoceJ6+rWJ5N6gMsDLYkq9bKZmEN+9f+lzrrIL+Gu+annfy9IZ3IIhcy7ukn8GeWx8aGp+0T0dqUIBRoTPw69ZthrlacuumUl/E4jOlpJWHuAz/COYlqPFWuqT/f6IcMNiETmf449wMZETTcv+tW/W153Figqt7nFVjuULdbv5uQsU6Tyjz1iKb39ysXf3eqMAj6O2J1RsBjSSPCY5PMKnqwRoTnqTDzJjqd/UoMxBnlnC6PuQF1UTe9WbcGRhyT3DR4mApsfLki9tH+5xqfpYFLEy7AgHrBf6xCo4TAo7sTPNBgZC2IPZ2SB1Ns+Z+T2TF2b+0XVRYJJEIlJsJl6M9rqpcJC6IGudCQXPMXDWc6cKdQYrRkblNri4WXWw+22l/u/izmB57PySyX+JfwWrZJjb6dbZF3dVI9Wth62v3+kJ5ojUTAvyoFQVNxtRmrykWktPohibHd+h1W5HaY0DTaCjKRbsdiDPKaev1igf56qdagl/AYSszjlqEoaGUqw7PdX+gFlUTHRo/NcYdKuRVbec4wjrYlb+9OPUR8v0rQiGeE9pNOS/yr4yLNbIRCj/dUpdPYccSH0ZySWkagW6qd8YwTyb8lWcOQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:57.5673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 078bf8e4-9499-40fb-374c-08dd0a865e0d
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB8300
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234639-112103-13740-60912-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.57.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsamJhZAVgZQ0DLRLMnIwjjNKM
	3QOMXAMMkgyczEPNHC3MjQwtjAKNFUqTYWAHlYYT9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan18-148.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 53f60fb5de230635d1a158ae5c40d6b2c314ecd2..aa654989d768df3dd82690ef071bbe0aa87817b0 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -679,22 +679,8 @@ static int unlock_request(struct fuse_req *req)
 	return err;
 }
 
-struct fuse_copy_state {
-	int write;
-	struct fuse_req *req;
-	struct iov_iter *iter;
-	struct pipe_buffer *pipebufs;
-	struct pipe_buffer *currbuf;
-	struct pipe_inode_info *pipe;
-	unsigned long nr_segs;
-	struct page *pg;
-	unsigned len;
-	unsigned offset;
-	unsigned move_pages:1;
-};
-
-static void fuse_copy_init(struct fuse_copy_state *cs, int write,
-			   struct iov_iter *iter)
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+		    struct iov_iter *iter)
 {
 	memset(cs, 0, sizeof(*cs));
 	cs->write = write;
@@ -1045,9 +1031,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
 }
 
 /* Copy request arguments to/from userspace buffer */
-static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
-			  unsigned argpages, struct fuse_arg *args,
-			  int zeroing)
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
+		   unsigned argpages, struct fuse_arg *args,
+		   int zeroing)
 {
 	int err = 0;
 	unsigned i;
@@ -1937,8 +1923,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -2040,7 +2026,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e82cbf9c569af4f271ba0456cb49e0a5116bf36b..f36e304cd62c8302aed95de89926fc894f602cfd 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -13,6 +13,23 @@
 #define FUSE_INT_REQ_BIT (1ULL << 0)
 #define FUSE_REQ_ID_STEP (1ULL << 1)
 
+struct fuse_arg;
+struct fuse_args;
+
+struct fuse_copy_state {
+	int write;
+	struct fuse_req *req;
+	struct iov_iter *iter;
+	struct pipe_buffer *pipebufs;
+	struct pipe_buffer *currbuf;
+	struct pipe_inode_info *pipe;
+	unsigned long nr_segs;
+	struct page *pg;
+	unsigned int len;
+	unsigned int offset;
+	unsigned int move_pages:1;
+};
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -24,6 +41,14 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
 void fuse_dev_end_requests(struct list_head *head);
 
+void fuse_copy_init(struct fuse_copy_state *cs, int write,
+			   struct iov_iter *iter);
+int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
+		   unsigned int argpages, struct fuse_arg *args,
+		   int zeroing);
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned int nbytes);
+
 #endif
 
 

-- 
2.43.0


