Return-Path: <io-uring+bounces-6080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0544A1A638
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEE691667B8
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1837211276;
	Thu, 23 Jan 2025 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="bjl74Jwq"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B711A2116F8;
	Thu, 23 Jan 2025 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643906; cv=fail; b=aGRj2chKy9FCgJ1a7i0tRUymBp30Vsqc1qa988rNqBNxq5I7T7bn2kfFRWSlU87w8MxEyvRXuvGpZ+F9u4Y3dJNll426MgZ6KGiZR2pslc7g5jlRCW+1jMBgsj55Wosx20tWtZc70ejG6XVOVl+GLjyhivE93SVCffMVx6TRLqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643906; c=relaxed/simple;
	bh=HeY3EhXYC5jVvvjZaGcoPVKjge2ebAVJJEGjsX2NA1o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ISPofSOfAhzy//gbnuwPkOF8jefKXENH+fGj+xSNwMkVgcHEVHowBz3whmx3lWm9kAj7mxzx/4NRByVmcSpOfSFNbwHcRTg7j8LxDNBA/c+P8CTHIGjwJtvv98ZVpnCyGXMpD+Na5sJEua7dcjkn624EtXYFmy2QEq9D77Uxx+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=bjl74Jwq; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42]) by mx-outbound17-198.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xO2s7OQwX4feTaUifQbliQj3W+8wthP5Ls6cbjzWgFwDqqpfBs7nSUnYIftnqYlQDs1Ed8kZwvfmWRkWu4TW8etfdMJI3iRUZDtVXHP9Upsl0kpp80oNX+3bp1QOF6gAsSGNBrFqX7ap3E2uVblinmrEuOpoelR/i8jWZOxtbRtVqcZzp6akFLRIQG3dmYs8Tdta+DlIBCEoiduApVdkXSfdy7ZyePEz74oudg8YMSrVkX5Pq+zZdPuRAQcO4TFciR6IwekngBV+/cPHZiTLr7+B5vZvFe+ABJWNc12e7CSiTRAtA6ipk8jvrRKv0vkO5eoruFLKrdZQTmR49ojqqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tj2t7f/3NLTCrKUWvaXAnq1q4D+wXYfl2pXx5jxJ4Eo=;
 b=QoGW98Qrh9QUDZ0ovG2KQlJm9Eiy6+bh73G6ibAEzcohc8gI9BBAYayhcacWTjALN+4vGiWUHsx9glkeQ0sW8rkL7sbe3VrTqq50HJxBFrsCeZgIYUw1NodaNW5vWf2lreF08lP8io5gcQFY1MjXQVHlkKaDuXmpKQXNgz1IPUqTPocnBZvO2nldzwSQoX1sOS8TszPuojKvf2jmkKeIkTJAOdE58Mlnurgr3+lm806HHDtXSpZS6AjGs3ERMjqB8RYWW7V65T2Q0z9mPD0GBVT8h1AHpVsq1ul/sh3Dt57OjC9G4rjw1IsXX8gFNymAeQeZ53YkUiuhWDRakN9X2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tj2t7f/3NLTCrKUWvaXAnq1q4D+wXYfl2pXx5jxJ4Eo=;
 b=bjl74Jwqlku1bDcv6gzXsGiHB6qvxNIoT0ufGoBWfV4T15vsVXZk53LpK0cJfZm0vW14EahpRrVI+m1iSIwMYHsDr0lG3ElqtNnwWfhHNCp/lgnDGro6ZVqcsfEC94logkYHwMXn/KlvKxax+oWvornNV3IsFYjrOQoZz3rw1Ak=
Received: from SJ0PR13CA0203.namprd13.prod.outlook.com (2603:10b6:a03:2c3::28)
 by MW4PR19MB7128.namprd19.prod.outlook.com (2603:10b6:303:21a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 14:51:18 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::4a) by SJ0PR13CA0203.outlook.office365.com
 (2603:10b6:a03:2c3::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:17 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 0FFD658;
	Thu, 23 Jan 2025 14:51:16 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:04 +0100
Subject: [PATCH v11 05/18] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-5-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=7363;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=HeY3EhXYC5jVvvjZaGcoPVKjge2ebAVJJEGjsX2NA1o=;
 b=m04toV0i/18SwSECmdwUn0xRjamyPCAAQYSuMU83QLMssFfAKustAzzBBs3wCf0kNGWj+v+Zj
 A/UaRwAqFC9AyV0Si30YnPkGMSMzxjxqARj3YFEv7VKSIs/2kJMFns9
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|MW4PR19MB7128:EE_
X-MS-Office365-Filtering-Correlation-Id: 14dae810-0b8a-48a2-690d-08dd3bbd6497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTMrUnZtQldLVC8vUjBGdWRyOEFWenVlVDBlRjZHdE1kR2pmcDBZWVgvQS8v?=
 =?utf-8?B?c1pUZnNCMlRzSHAvMFRHc1RqeVZnMDRLdjlRbFlCK3pqMlJZV0xWWTJ0TUVp?=
 =?utf-8?B?VDVTK291K1RIajYwYkpQTFZPdytWM2EweWdtVXd1SWtiVzQrRDFPR1Z4anZi?=
 =?utf-8?B?eFZSbUo5UjlJMEpRV0RYTDVMdmt3a21Sd01vNDc0WVljRHFYaStiR1ByNHdm?=
 =?utf-8?B?R0RacU4zQkhKYjRnMVZMNTdIeHRLaU5TZ0N4K3VnZWxIQ2hEdTBFREpWeURZ?=
 =?utf-8?B?S1YzcncreXE1Z0VWWEpSMkVhalpqM1Y0U1BLK1ExMEIvcWxjYmVXOUhBbDZP?=
 =?utf-8?B?M1Zzc0d2blVEMEpSZkgzbE9XYkUwZjc4YUdCbDBKUHZUUU1vZDBCcW4velpU?=
 =?utf-8?B?S05GYWxCOGhkcWwzTCt1OTRGeWhacVUzTThjZHpsRXNUZExxbTQ3V3hBUS9k?=
 =?utf-8?B?U09TMUFzRHdSTWNkRkJoK1RzR1BvS29TVzY2U3dia0U5dGJ2c2hDNUNCMXJu?=
 =?utf-8?B?TldWZURVeHJGUkduT0lSWVdiWG9sYXo1bEFMT3NsUHhoNG56Nk4rQ0J5dG93?=
 =?utf-8?B?bVU4VGIreFlRZ2xOczFlY20zblBBbkFjV3VneXV3WDZISkhQODFOOTlNRjJz?=
 =?utf-8?B?VmwvclFJbFdFNmEvd0JXZ21KWCtwcEJUZTRhOHJpRE1nQ09IVlpXc2FkVXNz?=
 =?utf-8?B?L1dQMzB0RmQzVnduL2hNdmhrYUVFaENORUc0czMyaWFSNGk5MXcvY09XcFpH?=
 =?utf-8?B?TnZnWmVZalhMcTNsWk8wYitiV1BwQllsMEdOOTFkVW5vd2hCVDFjM2NQTklv?=
 =?utf-8?B?bUJzazRKOWFDWlh6eTNlOGpRb25CWGdMWWJKakR1RFVWNGk1UTRUeUpqL1hF?=
 =?utf-8?B?SnJHKzBpei9XSlVhR3lYa1A3eEVBV0xhVy82MmRRQjIzNGZKdi9xbFpHYjlR?=
 =?utf-8?B?N2JaeHRxWWZFcWF0TFppU1VtbUFpcUpCWmdsTDk4Uk5BMTlrelNUbVBMNlhQ?=
 =?utf-8?B?ajFmbjlOWXM5cDExYnlSYjlIK2dOY1hhMkUzcUVIT1U3YWJ6MGpiVFYzR042?=
 =?utf-8?B?bitHUEZuS05YeDg4UHI2TW5naWorcExidHRLbU5hOVVpWS90ZHhGclpqYnRa?=
 =?utf-8?B?TE1keDZpc2hpVWJ3Y3dZTWhoNjBMSGpGeUdLeVJwdUhZVkdBSVJaNU9YVlMx?=
 =?utf-8?B?cmlSNG5oZGlMRjVuU0UvdWJmaDJYUEVSVElNMVJ1eWFEZlBtbzQzVXY1NE5R?=
 =?utf-8?B?eDZENDVJRGI3bzVlOFVCYzNjS1Z6eUpnOXRPQVQzVkRzRnF2cGFjMlo1VjQ3?=
 =?utf-8?B?U1BRU0liNWFIMU9SZHppTEdKYlA2eFpOeGtZMnJyektFM2lCbUE2RjY2Tzlk?=
 =?utf-8?B?MzdqMEc5R0htTFlOUmxOdkNrQlgyVktTdk94ZDFuZ1dPUWpGOEZob1VscHlK?=
 =?utf-8?B?MnU1SHpMZlpUY2JrdW9VQkpRdFpZWXhmbzVaNW1ocFNhcFZTNWZaTlRpdzcw?=
 =?utf-8?B?cGNsTlF1SVVxMk82QnlFQlVtVkhiaGlDMmJ3SUtKOTQwaGZXdUVQNklVWEZL?=
 =?utf-8?B?cnZlVDBDbm81ZUNFaDFLVTZDTFBjYitIMVJyNmRNelJTb2Q0TUN1dThZZGRO?=
 =?utf-8?B?YkdEODBvOUZkZ0VRM2liaXMySGhsaEh0VlhmWVBpNXZpTzRmNGNjNER6TlND?=
 =?utf-8?B?SW9ST3VlZ0Ewd1VIeHpBMUxFdTQ4d09qVklMbXpTQ2ZCOUV0aDJwNVdRcTll?=
 =?utf-8?B?TWQwNmpLY2lkWm9WUW1YRUQwdW1zamcvdythWGRoekxYSGp5NzZndHFUM2I1?=
 =?utf-8?B?SGF4K3htemp3eUVoVzQydEFjUW9JR1dmZUVUczZRNldaMEJpbW5pamM1c0ha?=
 =?utf-8?B?aU9mSnJJaWpGd1NzK1JrK1ZuVjUyWDAwYXEwYVl1R1BnSkdPaS9Td1FaZWVu?=
 =?utf-8?B?OWRTK0tXVy9uWmN5RmpLMWlRc1l1RXorSWJhT25kd0QyN2puSXBUUWFQN0Yr?=
 =?utf-8?Q?bigfgwlQLqdY/AxsyyQVGA9EveFU8g=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o5s2zyq0WLhMZt9wi3C9BNUqXPnBotUkJnf3kCRcC+/rppreJQCLENm2lHRSb0WpGgTP9OKYVRWsXrTwAUgeYQh/aiinNCgOKEHm2B+IRaO8DsfZcxiX49M9IgxyxKY80EDTr+M0C6ReQFa2E2vLtHFKkbs7TZX/O+Fi4jpGzrcDOp+mnkGTAP3hKIsYnKb2TBwGFqoEc5ny516g3dAwiX2lEPizujuJOmlLSjokwAZCVM0/H+z0e2zPavxRPoxPePPb9bFjsUgw96E4nJIQWrc7Ml3uDC866MRsXgCZOgVAnUqlzWs7Yg0B3+iTih0bi72jchjQco7DaKOmsAeD3+L9y6eMxjRnZdU0nvZ95dhVkZzqcqLsTJDruuUzuvwEW26DZjXGfiVl5WlF+J2bJTl48oEdZ1TnElDqp5IXwgp+d7uWYuqmnB2LGqAQjnI4ZgwXCB2UMzutPyeycqC0CYULz56udF8JI8AaLQ4Fd+u0g947BMbSnRLP1lw3O9H/hzW4zZBl59dOfXGzxuSOK1ONGDE+Srb/+wO9ZtCnAHcpq/WCUUb7FRfioXjSyk+ABQXCwH8SgvwfeDkeq78uRftZw7ifXCAda5O6ZP61jursFFrlKqeDi7UgUlAcyazGp3PT1yTHr1eyvLi2EnI7AA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:17.7886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dae810-0b8a-48a2-690d-08dd3bbd6497
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB7128
X-BESS-ID: 1737643881-104550-13340-13959-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.66.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuaGZmZAVgZQ0MA0OcnYwjzZNM
	0yLTXZLMnCwDglyTTRxNQsxSTJxChNqTYWAImNBYdBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan18-27.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This change sets up FUSE operations to always have headers in
args.in_args[0], even for opcodes without an actual header.
This step prepares for a clean separation of payload from headers,
initially it is used by fuse-over-io-uring.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Op codes that already have an op code specific header do not
need modification.
Op codes that have neither payload nor op code headers
are not modified either (FUSE_READLINK and FUSE_DESTROY).
FUSE_BATCH_FORGET already has the header in the right place,
but is not using fuse_copy_args - as -over-uring is currently
not handling forgets it does not matter for now, but header
separation will later need special attention for that op code.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dax.c    | 11 ++++++-----
 fs/fuse/dev.c    |  9 +++++----
 fs/fuse/dir.c    | 32 ++++++++++++++++++--------------
 fs/fuse/fuse_i.h | 15 ++++++++++++++-
 fs/fuse/xattr.c  |  7 ++++---
 5 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 9abbc2f2894f905099b48862d776083e6075fbba..0b6ee6dd1fd6569a12f1a44c24ca178163b0da81 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -240,11 +240,12 @@ static int fuse_send_removemapping(struct inode *inode,
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4f8825de9e05b9ffd291ac5bff747a10a70df0b4..623c5a067c1841e8210b5b4e063e7b6690f1825a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1746,7 +1746,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1774,9 +1774,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index e540d05549fff8bbe0977e909ecfa7149655fe66..2ecdb8f14d46584c54bbafde88d91afdbd410263 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -175,9 +175,10 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -928,11 +929,12 @@ static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -992,9 +994,10 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -1015,9 +1018,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 74744c6f286003251564d1235f4d2ca8654d661b..5666900bee5e28cacfb03728f84571f5c0c94784 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -310,7 +310,7 @@ struct fuse_args {
 	bool is_ext:1;
 	bool is_pinned:1;
 	bool invalidate_vmap:1;
-	struct fuse_in_arg in_args[3];
+	struct fuse_in_arg in_args[4];
 	struct fuse_arg out_args[2];
 	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
 	/* Used for kvec iter backed by vmalloc address */
@@ -947,6 +947,19 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_header {};
+
+static inline void fuse_set_zero_arg0(struct fuse_args *args)
+{
+	args->in_args[0].size = sizeof(struct fuse_zero_header);
+	args->in_args[0].value = NULL;
+}
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 9f568d345c51236ddd421b162820a4ea9b0734f4..93dfb06b6cea045d6df90c61c900680968bda39f 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -164,9 +164,10 @@ int fuse_removexattr(struct inode *inode, const char *name)
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


