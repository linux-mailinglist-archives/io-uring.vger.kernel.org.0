Return-Path: <io-uring+bounces-6071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2117A1A627
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A05D1643AD
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA66E212B3C;
	Thu, 23 Jan 2025 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="mAB52wEs"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8267210F7E;
	Thu, 23 Jan 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643902; cv=fail; b=ePWL9oT10CsNe3tbN/qcApquNZtzXYQfeRb5vmkcW5QyCxwGDWRSmi/G2kpR0sogCnaQY0I+e0P2JExLWtMMAbthnDaPDFO63C86I/0QtWQTV3qaIZ/QJFP5lx2D2f6HSvHqjN1ljGmOTn2GDtc9mfvfi9alUcvZXe9EFKw5vRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643902; c=relaxed/simple;
	bh=If1lajZeRWbxVBz2Rfvth04TaNmhiGlP4Z7rhLJjhNg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CEjKIh5+ODYGt9MNSDMskSEglLT2T7GKh0PhdunqzU2TBpkpDdfkyylmgNuJ6XPayWInU8EiHmRWUhgBUWePRMTh5ZbeOyt0+8Yc/m4dRvoQrVdAk9rb3/6YSHHyKb9Jcw9z5Nq8tQFJDYYhTR0PP8FtBevA90hurCoJatoVD18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=mAB52wEs; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41]) by mx-outbound-ea15-210.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCGdRRpuY8Hnz1LZNeQs9IBMihBdhiJx9vbeF9jXELvEeMPW2Tn2ONTVdos01grEu68rhmWpslIJjA7R/5T1hOL1X7NMzaTrxJsScVkmJnJ/LA6CN0cfBOdfybQGWcvC8qAN5a4twsM6WEuWj5QeN9/qkfcNJeQg49F/C7VMVky4o8GDUeAHY8yhvurv26nNpNyA+4HHk2GXozOiYVfGMqjUtPn7kdMf/Uz355mViLlloFHM9waBu9/NGX4q7a3WTEc7BJ2oJXdEkJkJPtiL1yeMLYKKvtXnMx8zYOSTZ9a1ynEG+l/bSO1Y1pDMYGjkCqxMULTLPp62IxqPXCC55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKwCxcV5gUIleIxoq20o0LZA3SNWR7LkuseKim6YRqQ=;
 b=lrbt0rTc07VW3L7L2c/KYmEqMt/iwXkEsS7XoVl1+/7UflJiOKfuXaEN1u6CSf/ec+wGefQxH+UjTNSAJZXAlM3eertydK8QDoiwSEREv9Dib5oRxBkGT8Cowu9gdu40z1U/Vk3DLi4DsmCYqFYYemfSf8uW1uNvDsL46F90P7KdfXL8CVKdKh865NioRCTmpa1wvYYLDrNpuQVwLalrRlblEGAkj5+MTtGiJzs5bfMkJrXOS/atiURD12WqJzzi08q9UEC7C/t/gD3BC283iJsrbK7WdVgAMJPJl4j9wcQkVi5EMl5APswndpqkyyzWwiwiRxspfSDrIlUNM3sQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKwCxcV5gUIleIxoq20o0LZA3SNWR7LkuseKim6YRqQ=;
 b=mAB52wEsqUnqnGblhuX2LmoWAKcDfAwuZOYbfqARa6bDlHy0YJAqydaqk70rUvBnM4DkOu5HEofpg5VuW+U4JTonbFa9Qtr4L4rgH1vr9a1M34dgM/EwdZNuuVvjWMfJg9DlWxpNabO40GtDiPg29TGPSeekkbzf+ayTMeMqZYw=
Received: from PH7P220CA0118.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::18)
 by BY3PR19MB4931.namprd19.prod.outlook.com (2603:10b6:a03:360::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 14:51:20 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::1) by PH7P220CA0118.outlook.office365.com
 (2603:10b6:510:32d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:19 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 017EE34;
	Thu, 23 Jan 2025 14:51:18 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:06 +0100
Subject: [PATCH v11 07/18] fuse: Make fuse_copy non static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-7-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=3770;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=If1lajZeRWbxVBz2Rfvth04TaNmhiGlP4Z7rhLJjhNg=;
 b=oCAbrjUH1z3gacCsh6EvqWL5xiJsuQ8EUAsYO7zAkUkre0DGthiIH8TeJeOZqgm0QskrWyEKe
 hYh7T3x5mNRDhTRIJf8D9Fmts3I1FZ9dkbcY7eAbqolJLfxFX0A4dqi
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|BY3PR19MB4931:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fc3d70-0783-43dd-2e14-08dd3bbd65a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmkrYmJKcTMrWWVuRDlSMGw4VUhPanRXN1VvRlMwTTM4L3pVbCtnVktBQlFi?=
 =?utf-8?B?RWxaSzJwaTRqWjNpZmxzNmdEVDJEaXJTSEVpYmVkZ3BBNmN2OGVyVGtsaTZK?=
 =?utf-8?B?dXlrcXRpb1ZxYTBYZFhEZUJHTmdORTYzWllGOEFSYnNPOXlQeVZWUURWUDRN?=
 =?utf-8?B?TXhkMHIvb1FadGxYaGtERW80bnBqT1pMeEU1NTMzSDMyNXJHeFhYUWVjUjc2?=
 =?utf-8?B?U2RlWW4xYWU5RnJEeWVxVEJqcU9vTzliSmtpR0RaUm1WaXVRdit0bWNjckxS?=
 =?utf-8?B?Ujc3eFl4TzJKUTBmL3Y2dmhuNEVZajZCcjdzb1Nyc3BPN2dNekFoUkRLVjk5?=
 =?utf-8?B?MDVpNVFaL0IxUWM2REU4cnpYUUtSZm52dzB3TnBULzhUa1AwclorT2JMSldI?=
 =?utf-8?B?Z01iejFhc0s2bDB3WlZWMkVFWVBmeWVWeVduNnZSQ1B3dkFPdjhJS0hkbW0w?=
 =?utf-8?B?Y01VU0svZktvbS9oZlp3RjV1VmRpVElwM2xuTmkvY21maC9ta0JIMnZxUkZX?=
 =?utf-8?B?bGNPbElBSVFTcHNHclhDazFSWXhWYkZJWWM5RC9PUmo4TDhyd0xoc2JHbGdq?=
 =?utf-8?B?UC95cUt5ejU1My95alpMQXpJTmhzMXo5V2FTTjZvWjZGM1FPK1BXN0c4bWJQ?=
 =?utf-8?B?dThkL3VCaEFpbmNDbkd4eW9ScWpEMG1iYlhpc0RCV2V2d3BJbVdPQjhzNWNv?=
 =?utf-8?B?RGw0Zy9TQ3JrbGFWM0NlNmZobTlQbGduT1d0K3BJeGZrdEYyUW12YzA2eXd2?=
 =?utf-8?B?UUpncGpiNHYxd1ZITkNFdzArU21XSjdOclFRUndQMDdKOFVIM0ZjeE5YbkdT?=
 =?utf-8?B?WUhnd1Z1RGJBbllLdjZGeUdXaC8rVEw2ZmFIdW1YVDBvSEpTdVM3Y0orTzFr?=
 =?utf-8?B?eWJ5ZjUzeC9CY3pVNWFRMW9aZGJvL0FYK003TUgwbjZVVXRwb2R6SjY4d1FW?=
 =?utf-8?B?SUNNVi9VemJoUDV0UnQ2NlJsa01uMThIZ0NIUkZvOGFmL0NqL1NKTDJZdHRS?=
 =?utf-8?B?d1JhUWlTN2x6ZHhmS2wwK2JES2oxQ0ZuLzZUTGZiV1FidWNOb0ZWZUhSdFdN?=
 =?utf-8?B?dXNrMmQ0UVZCYUhGUTF2dHR6b0tVamRvU1JYc1FmN2poWTNWdE9HbzIvSXhI?=
 =?utf-8?B?cVV0YTA0dFZxS1ZqZW1rUUU5UCsvUzhBNFZDNWdFWEdET3NVWGtpWXRRMWlT?=
 =?utf-8?B?ZkFHaDZCbUFXc1E4VUpHa05kNXo4QW94TnpYcGtSVEFMTmVzQlptWXRGS3ZY?=
 =?utf-8?B?M1ZSTGF5K2NYUGx6V291VU84aVc1RGc0RXBBL1lDRDBZVUFaL0VkRUNiWkNs?=
 =?utf-8?B?cktYL2c5a3dmUnlBQWZFbXkzQlM3L2dkcFh0T2Y3K04vZkExMDRtMXlDOFEw?=
 =?utf-8?B?WGZTRmc3YjdmaXJnWndjV2w1bVRuTFJVVVFrWVZnWWNPbm9FdFhzeEFudk5o?=
 =?utf-8?B?cXBXcXpsSnpPVStzYmFrdW9aZGxqZjlGUlFxRG10bVZoeVdtOUtXVUplaUhW?=
 =?utf-8?B?dUFhMUdaTUhrZ3FVcTNhQkR4dEU0TlhPdmpxeVh4c3g0NzZ1M1Y1UVh3dlZK?=
 =?utf-8?B?SzZsbVlDTHdEVzlFWDVnYmdoRzdlazM1Uko3eldlZ3pna28xVjBQSjVRTzVa?=
 =?utf-8?B?QWRXaHRoTkpMVzRlS0F1RjF2V1RNYXkyWjlFNXFUQTdxU2pLeDV4S0hOeTAw?=
 =?utf-8?B?MVFIUlFpbGNYU3cycDd5cEJtY3d1MzhudDhhYnFqdHE2M3I4dzh6ZlhYZkg1?=
 =?utf-8?B?OEV3bjNJVEhuV2E0Y2xCeUNmcE5SVGhEeW5RbU51bzYvTWJWcTJaM0pvOGl3?=
 =?utf-8?B?U203dGdwSlNwWDBFYkNRdHh0a1BZSEg3UXNQek0rNWVWZjF2ZVdnWGJSb3Q1?=
 =?utf-8?B?a2RIZFpERnpDVlEwdWpvakFoT0MrVkxSZU9VdmZ0c1hUbWpiaVhRR3VuelVw?=
 =?utf-8?B?QmxtUWZhc1JDNThiK2lhWE5VMThjKzVzYVFOZUMvRVFHVUdmV1RJZEU5ZC9i?=
 =?utf-8?Q?+txzuRrDm2FrLdeQLZPvdBSafi21us=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yWa+9wOIkgbxXX4xLHvWDHKKUBJT9pFZL8Z9mEpgjFozsCzQcTbWSMsJTl13X3FI4HC/uG8MqOjfCxVCDs+utslMn4Yhw63oTlYcyZDnDLJ4+MHSdVH4gdHycaztgi9SsOYOlnkVNN2izDkeg89X+z2kGYvptoRP8ng1oyBURe/N55w8K+mqAihBMJ0F0Pyra4aZQRMp/siDUAEyVDc0O9nPRw73aE/BY+CTotKT39TBbD5xIOefYzEkCO7TdXmQ+kAJ+xeLg4bdAmba9Oja9OM6y8vHzCP1tILFvNx969Q3vz9KCGyKLSl8DLo9NNlnjcQU2LgZ+02NG/2ptudkglM0/KYyKbodovfZKJZhj5Skaf7Nsz8/mW4f7QPTn1DekTBSnj4g0zjvYsnoNKXMVVFupFY2TtjF51puLcplaQb2kQd7lZ10PEBcYvc04VVzuaAFDbBVGVfmcJmEm5aT0WqSBcQF/QzsgiMIXPho+7trCWY+pNBTqo20qG17Xge03camW6iZlWSvVNZZFIdE7oTFdoOrMqJy6Ov6HpR8tFctaMLJoCDHs9oAjLD8s8JqgvD4elF1NcuhuEDmxa3W/IAxhnthdqCK0KBvl2B0pBZ1m/ELgHuQtXJcch8Ny2IdRBJdesgJiPqCg840A2ofdQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:19.5707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fc3d70-0783-43dd-2e14-08dd3bbd65a0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR19MB4931
X-BESS-ID: 1737643885-104050-25950-28755-1
X-BESS-VER: 2019.3_20250122.1922
X-BESS-Apparent-Source-IP: 104.47.55.41
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsZmpkZAVgZQMM0yOSU51SApMS
	nZxMDEwNwg0cTQ0igl2TQtKSnFIjFJqTYWALueic5BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262003 [from 
	cloudscan19-26.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Move 'struct fuse_copy_state' and fuse_copy_* functions
to fuse_dev_i.h to make it available for fuse-io-uring.
'copy_out_args()' is renamed to 'fuse_copy_out_args'.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c        | 30 ++++++++----------------------
 fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 623c5a067c1841e8210b5b4e063e7b6690f1825a..6ee7e28a84c80a3e7c8dc933986c0388371ff6cd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -678,22 +678,8 @@ static int unlock_request(struct fuse_req *req)
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
@@ -1054,9 +1040,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size)
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
@@ -1933,8 +1919,8 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 	return NULL;
 }
 
-static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
-			 unsigned nbytes)
+int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
+		       unsigned nbytes)
 {
 	unsigned reqsize = sizeof(struct fuse_out_header);
 
@@ -2036,7 +2022,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	if (oh.error)
 		err = nbytes != sizeof(oh) ? -EINVAL : 0;
 	else
-		err = copy_out_args(cs, req->args, nbytes);
+		err = fuse_copy_out_args(cs, req->args, nbytes);
 	fuse_copy_finish(cs);
 
 	spin_lock(&fpq->lock);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 08a7e88e002773fcd18c25a229c7aa6450831401..21eb1bdb492d04f0a406d25bb8d300b34244dce2 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -12,6 +12,23 @@
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
@@ -23,5 +40,13 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 
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


