Return-Path: <io-uring+bounces-4556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45399C0D19
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93BE928548E
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC63215037;
	Thu,  7 Nov 2024 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="eCO2ZYgv"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1A191F6A
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001186; cv=fail; b=BoVWMzxOGlB6s8w39cOk6r09RyrxEJtFoLmKeRNMAEMplnb9SKQdENpAGQcjYYT7UhpNWuI1twZY97gJESxh+81lXX6laa92JE6CXSuacn0oYa31Zvs861rnvfsqx5LQ6m34tcK/RBef//VN5IzsSpN4jqvXjkWsZz5IVypAok4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001186; c=relaxed/simple;
	bh=vNi3ideG1iLjK3+IpG5ceXtr7C851qaww+bttzRaeqM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UduCwHNRwRYIUw0Hfj4uuHEjjt2TEtOzc/cSvybJtzmLSbt03Ugm7ApIH7PUpIf+8p78e/K8tqNmxkDw/d9+Lbsh23pDnx1mCVAy8m33JiAzacpQH4HXnuQg4ZWwiC76SDYrZh3/ASgprVUFTkbrYXxvI0d/wbSl7xNTNoGqB+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=eCO2ZYgv; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172]) by mx-outbound22-27.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuRDBpqb/UIcqqDLiKVWOx8sghwsFLHj/kl7Iyk5QCsjB3osUuxA9OZlWt/AZNEmuxw2Df29Xf2hzKb9MXxNAQTSnTq0vzzjm+Ikp8SodRJv30wPznAoOglMDW6pG4ijrSAV8UfCH2BV5aH/m1Et3fuV7Ekn7UySZgZx7x9LkkMlWFi308UWPxPc1fuzYRNmFUlpPrEouo0KijtuywggUK4cHKQ2Xfz99+eB4kK4EGp902zYXiAWRnYseWY37vUrt+b9H3XHKYoKUe3tfrTrIRcR8F3eM8Y8fWb/1qwflliunlpvyJLt/DI10MxwQ7+BNpxpNPVYjJ++9u1Q0yLOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBvVN7b+Ds0Ig2dbL7M3V9/Qz+0WwfDX3oe8Zqg06po=;
 b=T5OLSnwtK8lUCbSEZ6NkRCGl08MrXRka3umgOiE8461i7+BW2AM0SmhOMWGqbuXVEKTeHJ4l7KNq25BmVPd66ci3r1HLAw2M7LhaK8m67QrdPk03QaY7VTTix/0m2qNlP+flsihsLlulp/6Pw/PBfRXKO9l35kTJ3uK8VmMkBpadmWQi2cNLKzpF7Sh/BX9FzAAL20FFRoDyb6kWlf772i6BmFWarM4XjAWCiviim4WJwdgLg87GbXyp3jzjNn0CyBxWnSEN3gqA33xOwmTlNibDd/7PfBop3/KwMTkadXANeBit2G5dENs0tCiEntZQDjdfVWTqhnDm0mXipQWrlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBvVN7b+Ds0Ig2dbL7M3V9/Qz+0WwfDX3oe8Zqg06po=;
 b=eCO2ZYgv08wkCeDi1lCR1k0vxtCUAwU13qAsFe8ug1+Tz6A0ZN4ZGFR72EJNkUqYONyOxK2lNl09o1rg1lGTiWCDRjT1+lNFnfCEZyBX43cj0elE4H4tNpeWHlsCS0XFjfgAzlUu+dc/HrrWgC6uVoyepg1csBiuHaQEeE6vlfE=
Received: from MN2PR20CA0054.namprd20.prod.outlook.com (2603:10b6:208:235::23)
 by SA1PR19MB8022.namprd19.prod.outlook.com (2603:10b6:806:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 17:04:24 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:235::4) by MN2PR20CA0054.outlook.office365.com
 (2603:10b6:208:235::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:23 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E6692121;
	Thu,  7 Nov 2024 17:04:22 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:57 +0100
Subject: [PATCH RFC v5 13/16] io_uring/cmd: let cmds to know about dying
 task
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-13-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=2087;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=OmthtYeq8dVdFY1LwFpLQXA5OxBwj2Q9ybgpxjq0bpA=;
 b=BOy+6XxmfrlRUXmdZrga9t7IOr5ma2a1s1/v5FJFpGIumRxeNhFDqfoTnVkxQsw3U5CThpWc5
 JtAgtg/rFS6DNHZNJ10i/UWLtnIYSdULpKuRQiWlspdhiLIKjtJirWF
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|SA1PR19MB8022:EE_
X-MS-Office365-Filtering-Correlation-Id: ace8564e-5a6f-438e-edea-08dcff4e3aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R001WDUwdGptMW8yRVVRM0Q0bmw2R05WTFRqT3hMeTExTjFRTWJ2TnJ6S0pn?=
 =?utf-8?B?Zi93WE03MnkzUno4Sk1hWjVzRXBTWWlKOEgrS2ZiMFhBNkpBMkVWSGIvS3J5?=
 =?utf-8?B?VkFYakVoeW5Qc3h6WmtPWDdjZ2lMb20ycVpCd0xyUFljbXVDSXBhUXM5UzRr?=
 =?utf-8?B?RGZOWkZHNzNPUHZ0S1hySXhSanFYYzB6VDZya1hTRjZWNHhPSTYzNHNnNFlt?=
 =?utf-8?B?ZlM2TnRYQko0bzc2b2t6a1EvQ1NZNnNnYnJGd0Y3eGpZdjB5UWhKTG8vbnUx?=
 =?utf-8?B?NExEVk93YzJCV0c0bStUTlB1YlVvUS9leVBKcFZWcGVBdkFBU1FXUWdQZDFW?=
 =?utf-8?B?WjdFNnhWcXBKUkRnMDBHelpWWDRkeUNLWHJsS3hDOGYreFVtSlhGaXE3RGtj?=
 =?utf-8?B?UGl3Y3dVVDZRdmN6M0x4a2F3cmhQM3JYSTZiUEI0U0g5bGVpZ1djRUpwRTh6?=
 =?utf-8?B?ampuMjlPVmVSTzB5aEpEMUNXL2JkL3JxSU5FRC9VMWhCVjJYaE9uYjdxbkpI?=
 =?utf-8?B?Wm0xTDBhaFZKQkttakRBZlp2Nng0Y1hieXZLNHlYT0pWZ2NSTlFXbkQ5OXpU?=
 =?utf-8?B?dXdhN1BseU5PdFBDK1dwaDV1RTlRUm1qWEZrQmZKdTBZWjBSOWJTWTU3ZWtF?=
 =?utf-8?B?RDJKN2d1WE1KNTVKbHlnRU13aVVrSlZORzZ0Ry9JUWhyeThhcUNkZ0FEOWhy?=
 =?utf-8?B?NVBubGxiZkpVcWl4S0VjNFJ5ckRyRWVVTXdRTGdkUGQ2M242c3dmdE8vK2Zz?=
 =?utf-8?B?ZUVvNEdVK1NNclc2RkEyNzlpOVh0MFFvajZpODE3bDdFeld1TjZKdVFsZ0xx?=
 =?utf-8?B?WU5Zb05hTVcyM2VrMGUvVFBEci9EOTBWb2JtR2M0b3UvQUtPcEFYbUFjb1Yz?=
 =?utf-8?B?NGh0Ylgyc2sraEs5c0ZRTEc2REZjSUg3Zk0yUWdhenFqZDZDNmcrOHV0Q3FZ?=
 =?utf-8?B?WWhJandZMmV3VUtLS3p4c0lobFVEY0x3S3BMdkxBekY4NmZHVElDdGJXZWli?=
 =?utf-8?B?aXFPMlZUK1RGSUNsbUxMWmpkV2RqTS84ZU15dmUvWjBvaE9CRG4zZWJHbENr?=
 =?utf-8?B?TlMwN3lwU1BqMXI1MzdkdUhhU3VzczgxZFVJcWZsNlBQRjRNZHl4bGZqMHow?=
 =?utf-8?B?Z1dLM2tJNG5wTWVlY1FtbmhxOXNaYUNIRW5YU01HTE53RFNxNmtjZEhqRUtF?=
 =?utf-8?B?dHdkWFB4QlFlckNmOVkzS3h5ZzdqNGFQdllkbmFKM0UvRHZGZTdpcUxmbG13?=
 =?utf-8?B?d3ppdFIzdWFXNW9xSXo1eHBzL21EOFk2Y1ZuQ3pwSitpdlNKQmsxVzY0dTdv?=
 =?utf-8?B?N1JJaUI0L0JlWlpnTll4RkVCakw3RnZlNFlyOFljUTBHN1RyL1Y0TWRBZDM2?=
 =?utf-8?B?MCtiSlpicm0wQ1M3SlM3U0lYb0ZYbVVtTDYvcG9rcGROQ2lhd0s3TFpZM1RR?=
 =?utf-8?B?cmNRaEZaUlR0bVhwV2JjSVY1UGZON2N6RnFZcXErQW9QWjVMZFo3SHFlTnhU?=
 =?utf-8?B?WkNQTnBtL0RWaVRKaTZYOEpPelNPK3FTRUoxSkk1NHlUaUo1bDlUL3IxMmg0?=
 =?utf-8?B?aE9UQ1RWd1djVjBqMXVVTVc0WGJDcVVDd3V4YzNmVi82K3VPTGE0dEZmZ1Uv?=
 =?utf-8?B?d0VRNEd5cHU5cHdvM2FkdW9MeDZtVFdVV1lMOTdBUThjbjU5bkc1ckhTM2o1?=
 =?utf-8?B?V1RYUTJWN2VpK0xRb1hvZForRk9BT1hibk13UzRxTHhEL1FvcGM4Vmp3TG1U?=
 =?utf-8?B?ODBkMXhLcnZCdEZBaTFvMmwycEd2WkNXQi9vRk5iK2ZHWjJ4aFpXV1B6N0Ev?=
 =?utf-8?B?Yzh4Yis4M1gxendBbjczbExoSlpsbkNUMDVuWE1FazRyS2QwZG83RmozNExH?=
 =?utf-8?B?Tkw2TG5nSmpFcEUvK3ErYStVaDJSdlk5R1pmckRGcUgycHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kbuPVMupXnwquX/FJ+4xh9ZQxAbE2M3/3HQ97uEV+dRiY69AmRRGdBZB456TxxfihpJMjKDhMeAe54dg/S+Qrzjl7T3/yiVSriOojfDOHuduyCqtAIrO/7VKYW3q2wmWOpNuBu++oSVYLv3fWz83y4qd7dztay0wJsPxhCpAiRxIUX95rTsKQEZUSSU50s+/dRJBLd+J1ApPPwHd4S4SBnLrXKZ5m2DXG+1XcWIrs9f+zGWBvFraXoXjmSnrniMhyWREGRF8YLgaCh+CeMXjDty/43HPGCwF2d9uJxRLms2Rb0vqxppx8w/LR5gutnUNQ366fU1S8nybhtasYUXinbpvP/UxTAZxOlG+8Uw5shC/h8HZjEwB2xwocYvjlmD1IkaeIq4yKl+C08CWkSMNz1CT7B2st1kTe8mc0Xn54DoC7rYap8i5a3RwMRq+mXa3UTtaxvqNdjnc7/Lp89KVDIh8GrNu8treg4HAEVNDDm7aPTamY2rQrATCtFA8X5Mf2aV7/CWzi6oN4CjcjgyPF6uRYLrLayRHLvOVTUJQvT3oMX+9PdKU0yOGmMBHNMk1qUk+krP1OxPAXbSAR9eTCjTzskB86BT+3VdYoPH98sxcPEmguO0kZITBnwBQwfXeUA9ABP1Mu7UCS96bxUCs9w==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:23.9055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ace8564e-5a6f-438e-edea-08dcff4e3aea
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB8022
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001183-105659-32192-2032-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.59.172
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYGFkZAVgZQ0DIlzdAyxcQwNd
	Uw2TTN3MzI1NwiySjRxNggzTDF1DRJqTYWAEXSBnxBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan14-251.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Pavel Begunkov <asml.silence@gmail.com>

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Changed to
if (req->task != current)
based on discussion with Jens, needs to be double verified if really
needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/uring_cmd.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7abdc09271245ff7de3fb9a905ca78b7561e37eb..869a81c63e4970576155043fce7fe656293d7f58 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 21ac5fb2d5f087e1174d5c94815d580972db6e3f..405a39fdd91c9abf741c2b3b6bde2f4d850312ae 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (req->task->flags & PF_EXITING)
+		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,

-- 
2.43.0


