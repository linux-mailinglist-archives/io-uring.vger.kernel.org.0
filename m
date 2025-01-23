Return-Path: <io-uring+bounces-6084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A7CA1A647
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAC801888BD1
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D69D212B04;
	Thu, 23 Jan 2025 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="mS/ThgHa"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805EB212B17;
	Thu, 23 Jan 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643911; cv=fail; b=cvDHbK80aW2UjymBatvymi7S9QIDh1Rv0O6WBD8Borm3P9ydJ7mlrmuvdL4jRAo83zWBNSrcrOb+EbzVSY5vAHSpYdGMwjxg3ZEj+2DOxsqg9Zip0vE4ikOAdq0dETRU7iSEtJAmRmNlWWVN0kszCfFRauwdyhWTnBlaSuyI5Ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643911; c=relaxed/simple;
	bh=LJQecb3ocJvXdn3e2oFE4AuTpaY6Fv/feNfyVbDxNT0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QxbiJ0qc6k65hA3oNzezevkNTMIQTS+tuNGhCY/xx/bLaWAdGCIHLbx5DsnEJ0lF1nlA4ZBgAz4nrE9g0mFvAki7JXMBBXvdTRXcOOapDL2TGjBpNeHRcS3ZeTSmLjFeKNL3Q0E6Jagqu1ta1pvP7BLXois8Wz4kdAJOf7ArRDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=mS/ThgHa; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176]) by mx-outbound13-143.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A0pqhYvdMoiLDtAATn0rtsUbXeBRZYtEkvItU+hDF7RbItHQZrVbHBzt8UdDrfPrEByL5Nr6FoEbBQXIr2hy2gsDoY/nMFyihZFlyE1rC39rS6+HabQIJIcSoxSyWTbNj6QkTRs9eu3rOok7h8zUrXalC3q2EvBKWeP3l3oYOGXYndGSrfx/plgtdK4+XvnpEgJwzCDIzaMjvy6yEAueLCtjt5/+OodV+Dv6MZy0Fh8H8kb7CTPpHTBQHAj9sICRHt4VSZTAzADgRmfqSRzX22UqRLQ+3aepnJOgtLiKQecm5u/GrpPx2Mh+dD8doOMV2p6zzZWs3N8r6+su9GE02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnIutSkBPaczSw6BWakgveWlws8JzaTa1kVTSmYh9U8=;
 b=q7CEOGo9xX3rMUkLgRbaIPy+7eRRunqiYo5fqmD0U5ojAFsM44grLXKUy5ky/uwhcqIyC3ox1ycG4iWqAR1sh549e3Tdhu5VjqCbsg5Qp6RpO909zuK8gwUpMXjEYc8OI8V5JIu0dps4LpahmEE0RkEf5YWimNuOpGdhTvoNJKQ4tFIaqBvIJ8S/vlu3ODtHUE7R4mXrAYGeVn5P+4SUC+ENNn4G+JQmJnLBAaSGC0NGEwGYd90COvpDHWCKTzrwMQb83Qn42Cl6R46GF0RVepoOMBEURnAwiNRqsuIWTF0sEx1C4TnV2gvHvziHtYlKUsBFtEleEVlMBPVkoBofNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnIutSkBPaczSw6BWakgveWlws8JzaTa1kVTSmYh9U8=;
 b=mS/ThgHa62QHnxdJbLrsZXXYwbLloiqZ+fRTIQCLyTLcwF+Ce5NWkvV8hPXhZnrtDSOlUu1OQdM06LIvMhfrO1YYLfihSQWwtPZ2GzfGm1z/ebfrvCE6gcTzZGZ+GYFZCu1Cq7eS07aWgCVf7diq7C7E7RF0JAdl237wDXP/NHM=
Received: from BN9PR03CA0451.namprd03.prod.outlook.com (2603:10b6:408:139::6)
 by SA0PR19MB4174.namprd19.prod.outlook.com (2603:10b6:806:82::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 14:51:32 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:408:139:cafe::fe) by BN9PR03CA0451.outlook.office365.com
 (2603:10b6:408:139::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:30 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A6BE9CC;
	Thu, 23 Jan 2025 14:51:29 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:17 +0100
Subject: [PATCH v11 18/18] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-18-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=1484;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=LJQecb3ocJvXdn3e2oFE4AuTpaY6Fv/feNfyVbDxNT0=;
 b=LJ9iRDJ2ek/iZPxx8lw7RmRHW5byn5a/kZqurNn/zCHPYu+XNTTkjPuFqXgzqnTdegYysSoqo
 KVcCFjL4AZLCi8w+Ax5Vc9HiVGJgiarqSYVKurztbJaBc0cfHZMP/fz
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|SA0PR19MB4174:EE_
X-MS-Office365-Filtering-Correlation-Id: e39d1d56-5cc3-4155-d9ca-08dd3bbd6c61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHZCT1AwanZleENNdk5PRzQ5ODJmazBaVlJxdG1OVFhvTnJBeEloOGFMUUNu?=
 =?utf-8?B?WG1UQTRULzVZamdrM3dBNjdVZmp0dDJQV3hZeWxDb2lkaXpTVmxpa1dwR0Nl?=
 =?utf-8?B?NWRNNjJ6M0V3ZXZPWTJOaWpVSzhJbXpOdXJCNC9nZkt4NW9lVWhTUVhISmlk?=
 =?utf-8?B?TklkcDRHOW12VXVjTHBxVHZaT1RxcnpqY3Q3aEtYRnhIS09KSkQvK3lydFJW?=
 =?utf-8?B?MnJOVk5ZZHRNSlJha2FkKzdtQlNHYVYwdXhpVGVoY2VBakVZN2pGdlNmam53?=
 =?utf-8?B?TXY1Y2hRa3g4WXAzNjRDN3YvL1dWanlqbzZMMFUybUxmY2dPRVdQZWE0V1Fs?=
 =?utf-8?B?VzZYMzVQVFp2Nk1paDVVT0tjVmN1NjJTT290TG5yMU9xUjBWZXJHbVQvSFdZ?=
 =?utf-8?B?WE10aGZmVzhQTUhqVktiTDVManZuNnZaWThUaFdsVCtWRkNHNmlORmQrZUFK?=
 =?utf-8?B?VEM2dVA0SDhRVERvbXEvMnJLZWZUMjJ2cFl2V2puVjJ6M0t5ckk4L1ZmZDNI?=
 =?utf-8?B?WStOb0xTOE12bm5PWXd2Q1J6T25VdGprN3h5OXRpS0NTVnM3VWpzTGFXN2li?=
 =?utf-8?B?RWNySHdUNnMzZHFURlFaV3FqaVpsencydHU2cUVzNFNMUXBuM1Z6QUZMMGla?=
 =?utf-8?B?MlZHNnZtVVdjNnlGSjVvVkFVWEFCOFNXSSs0YUh1Zmc1aUZlR2VFeEhiUldQ?=
 =?utf-8?B?RHhVQTdmOWxMY1I5NlZtQVFmZ3pqMlJZV1dUTHJmdVp0ZEQ4K0picGFGVkty?=
 =?utf-8?B?bHU4anlPREJEMUxpeXpnOUVDaUdWdDhtekV6QVZMU09RMXZjWGtjRzZBblh2?=
 =?utf-8?B?QmdTRXFvakJTdmU0aWF0OXFKZUtlYzJPZTZLbTlMRnVQR1h1bkVDbGd1bkZv?=
 =?utf-8?B?dVdHTlpaRzlSL3FuWHhtOFJSTXMzQ05BMEdJSEplU1hMaG1IVEtHd1RRL3BY?=
 =?utf-8?B?ZHI1OE9Ndkt6ckJnR0lYUzdEYi9HK3NBSU40OThTWDZjMUk3MzFEdDhSS2RJ?=
 =?utf-8?B?eTRuaUNieTMrc0lqZFlFNHhHeGZBQkhlMlFEa2RkM3BtdGVDRkx1V0t0K1hQ?=
 =?utf-8?B?ZEIrL0tzWWJrU2ZiTzVMdGN1bFFQQkNPQmgzTEgzeFNCL0Q4U0QrSUJhSTgr?=
 =?utf-8?B?ckVBczN3RHhMZVlwbFZPNzA5eWw0ZWhHOXpuLzNzeVNHL1JzSzNQd21tbUFz?=
 =?utf-8?B?QVl3UDZueldYSUl1cUVydjBRWlF2ZUhmbzFteG9zaERLbU0xdGRYUDdEZG5p?=
 =?utf-8?B?bkkvelozZWFmaG1XWVJhdjgremhrY1NKT29ISTZncGQ5dUdDTnIvZ09DQkNB?=
 =?utf-8?B?Vld3N2hLa1poZEtVb1FJUmNtckVsYVU4QkNuektnMk5ZcWJYRTZ6S3c2MUNq?=
 =?utf-8?B?V0pDbDBhMmZjcGZyY1NLV01Jbk4wQjV6OFpYZGtheXU3QVF4Y2pXbkREcU9E?=
 =?utf-8?B?T3JzSTZGMjhBaGRzdms4cDVaaWV5TlJiUlkxTklpb2twaWJyTXVDL3dVaHNn?=
 =?utf-8?B?SVhSemtkWGVVQWpPdXVXK1VTdXBVZ2JyQVh1NWR5Mk1nK2pDTFArZ2RKL3Ns?=
 =?utf-8?B?SEpZNVJEN2hzekl3KzZ0MGVWdnlWNHBLQ1V2d2ZucTRBdGV3VmJlc2dLc00v?=
 =?utf-8?B?YkVMaWIrWlpOMXRBdm11bUUvaGk1ZWF4SVJmUjU3VC9YZHhoRW5GT09PbXZU?=
 =?utf-8?B?TjRjM29UL0RibDZqQkJZSklIRGpPUGc3NGphemdYSnpyK1l2QVVSczRjWVR1?=
 =?utf-8?B?WGZvcGRmMjBEQ0JZOFRlUzlLZzJtL01sU2ZxaVo4Rjg5OG4vdHhETVNDSGxP?=
 =?utf-8?B?UC80WDdqbDlBV0NIVHhvU1BiRGpYS2sxMzRZMXRQb01tVTdQZTVVdGRLSUFF?=
 =?utf-8?B?elNMb1JNaHo2MTFXd0p6UkkyZE80VzV2elVqS0F5U2VBTzc1VEY1Sis5c0pu?=
 =?utf-8?B?RzZiQ1ZneWFoZ0RkdnZqdGRTVmtzSjlFb01BbXZSbzdYaE9iVjU1T0xsMUlv?=
 =?utf-8?B?b2dQMFN2ZTlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SJAD0BhCnxb9nJ6xPSedzeZY/Fymg5pRMHaU0cC/5ZvC55zm5P95UR3l/n0bItR828syqAOoQBiuASV1uGuNfLVF/gBotpTaHx8XZXrjofcCyEsqKVTKW/p9OmDzknShgmlke7+X9JOkZ67YKLHbg2TNLcPcCeZUk+2fVSl2uGmg7JU2jH+Gm5Ls3BWrHlpP0M2XHCOSdPTjoqiuTI0h7WNFjRXg0IYSCOUzDGJ1h4t9htoyVdCJtOz/tV2R7H2qa3fVSYeqBdkPDPIQ+pziWM4lXj9RRpaa10ve3LeasImi3SGhktoTKn+1Hdgut1fFcTCrPSX8BTW+gj6fTFJmrs1cj/A9QtT/jC0DK4VvDVUAsVpf8BN5hMbsE9W60EVpVmlJKqtR0XaP+bNEnmadWyXecqLsQaTct5/NmwIN/KP+TiBB7EC/ehLb/mfs1d/WPdOJERmoJT/xvkz0Y8rI9SfvaESzpk628+BTOA9KnjdT0CoNx2sBxxMChNLWjqYcMZJg3dWiDCRmATS9VDmKDADqJGY2jgb0TyHStK/5V/9CNbf2g40A0+KNfSolljtRtvRAvilpnl7O89C1gfKsQk9c9ARJmGVOwR0qwXsuuBrtOOUbr4bIHxZlVv9cUyTR55soNR+1mUopWZuIpjstDQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:30.7344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e39d1d56-5cc3-4155-d9ca-08dd3bbd6c61
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR19MB4174
X-BESS-ID: 1737643895-103471-13473-457-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.59.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmJsZAVgZQMC0lxdI82TLN2M
	g0zcLM3Mg01SQxNdHSyMDQIjE5xcBIqTYWALCxurVBAAAA
X-BESS-Outbound-Spam-Score: 0.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan10-181.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.20 BSF_SC7_SA298e         META: Custom Rule SA298e 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.20 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC7_SA298e, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c       | 3 +++
 fs/fuse/dev_uring.c | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f002e8a096f97ba8b6e039309292942995c901c5..5b5f789b37eb68811832d905ca05b59a0d5a2b2a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2493,6 +2493,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b67bde903c126fcd1426771b4a96071fc37fffba..a2abcde3f074459de3dba55727c5159f0a257521 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1084,8 +1084,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
  * Entry function from io_uring to handle the given passthrough command
  * (op code IORING_OP_URING_CMD)
  */
-int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
-				  unsigned int issue_flags)
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct fuse_dev *fud;
 	struct fuse_conn *fc;

-- 
2.43.0


