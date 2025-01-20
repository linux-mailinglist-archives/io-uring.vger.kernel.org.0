Return-Path: <io-uring+bounces-6014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B2FA164F1
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2E1E166209
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0FCC7DA9C;
	Mon, 20 Jan 2025 01:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="YrVjDkND"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1681CD2C;
	Mon, 20 Jan 2025 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336573; cv=fail; b=YDeYP478Exh/PXQRlCgX2hlGBt7f99n4SnYMYo6BJsXzbYLTdhy0KbJDJAFEksgU2jeUPwfJhVXnwaBnmpkMrxlm0rNGteAP3wII/uuuw5h3OtNd6QFxzzjZgOPFi+ZmIPOZUuLaiiasq7jWoRoMdG+Ynu5rmCKE38lLDvt3F2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336573; c=relaxed/simple;
	bh=Zo2EkSOv1NPauKXDRdImC3x8ypCIpeDQNYOqOik5DNY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oJ0dxGwrWjRF/Wt+ukykjF1xB/N89dn3h0wBphxoFa9AJkfdYlQdEE1dn+DzH6s3kYIXK7D2+VDxcVhcVr0lkroENTlf1HwgbGekngBQNrdJCpOsJJSBlIz3ElBCPB5qK5trfvecFM2GSpw/kr1jmfxXX4Mw7FIIb0jd/OgyrlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=YrVjDkND; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jCGv1GbOcXAao9ZFqR4j7+9T1NpH7KeOO/coRBWpR85515NVM6BAzT65H6ZlIcSuRmysTsXZov6M8+00kYUkrWzyZ9wjEOakoaa+nTMPyZuq1gjow1vYhKoZysZ9U1RmxWW6ri7FYrEbXH4YyyW3shwg2binsjI961OJZIN51OxCpNSd04MI6PAmjuDIJV6tKGLYta9c8sMJhZav0bEv/HDXfdjeYPfmssSK3w5be7wzf1xUxXdecSp0sbY/FxEQuwA+oIb2pj3dJZv0wAHuO7QI7wm+EdR1042KlYwj8TkM+YnTLVA4sXN4yysEiIlfjsUVxXtQbYYRPYqTs7ei+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCJnM09yTlejVTQpR4aEFFfgq5YghJtpIlDKjqpcaDo=;
 b=i/M2B0u9mK7129j2U1TUYLoKbJC5O+Awx0Gpr8WyxTccKnr1xA6TCT8pdZYOPHXb1zMQTqbFTdyzwfZgn+LjhHCRwqgtgRc+3r6pFWSrFCzzbGLcOAsp+RwsnCVJzGWR8Dm+cU7C4sc6cfKRdFiPk4dQ4A/1EuxqVhfKmJUPcNfim4vXsaFM9Cg/0PwKhsuIy7qmkj34ZFZDrw70b4V1Oh0k4tsZS/R8OJEXbcrSkf/1iqLfRuqZfHNeDiL9rWkrUWgwzg2zrZqPokUnw8mumGxxrPMTBouI5swKLziAfxooXJDGOpdwnp8lEBLPr1UrJg/zOuVn3TmwEeUoXQUiUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCJnM09yTlejVTQpR4aEFFfgq5YghJtpIlDKjqpcaDo=;
 b=YrVjDkNDAbUQ98b1RGm5FbtmKBOKs1zhsJe3qmPHk18JT16GmlYMgLc6iGij+cmAnvY2U+qflQ2mtRl9OFvJ2uwa3TV+3N2QCRDNziiOW80dPxFjfQt5H7z9VSU4kKUX2t6VaM3H7Cy8K0vs/sbiPbohekQsMtRSxWAiobOJAXk=
Received: from BL1P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::10)
 by BL3PR19MB5258.namprd19.prod.outlook.com (2603:10b6:208:339::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:16 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:2c7:cafe::70) by BL1P222CA0005.outlook.office365.com
 (2603:10b6:208:2c7::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.11
 via Frontend Transport; Mon, 20 Jan 2025 01:29:16 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 83CD24D;
	Mon, 20 Jan 2025 01:29:15 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:07 +0100
Subject: [PATCH v10 14/17] fuse: Allow to queue bg requests through
 io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-14-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=7347;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Zo2EkSOv1NPauKXDRdImC3x8ypCIpeDQNYOqOik5DNY=;
 b=rz1GXOUfbcB1h0vQlvWKGN12LAN2NWfNUDCipofhEmP+y1WR6ufYtHQHvE+ycwnJ4VeYryejl
 PHk9ybqcrwND+Sy4trp8dk7NK/f41PBfdGIFwcR/0T8JsMXo4MpPE5L
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|BL3PR19MB5258:EE_
X-MS-Office365-Filtering-Correlation-Id: a89654fc-75d8-40dc-c682-08dd38f1dacc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0FDazRmaXZKWmp4OWgzcjNhSWtlMVc4TnEyQUhzV1VKZHlNd092THRUK1Vw?=
 =?utf-8?B?a3BBZmE3WHF4TTdzMzIrTUM4cHcvekVDYlhXalhqcFBYTGlsNWZtY1F0bng4?=
 =?utf-8?B?bkZRTVI5VnYrekZtckJlbGJkcDBaNHQvSEljNWRkUFl1WmhzWGNOV290eW1P?=
 =?utf-8?B?eksvMVdvR2N2U1ZxaDMyUjZraFpsSHRPV1FpOWZ2Z0hkU1ZORXNOWkxubDBp?=
 =?utf-8?B?YTh3MWRqNnRmd0V5Nyt0UDF1NkQ3MzFvem9vZzBYNFZlTnVxZ0RVQmo2cHNa?=
 =?utf-8?B?RXZTV2ZtL2s4OWdyNUdPdERQUUZVUmtKbE5vVzVUbWhBNzNMeGZmdlBEaXNO?=
 =?utf-8?B?OWMvMWVqemNFVm5CQm1xYU42QVlTUS9DR0hDS0xPSEJmVG5QUkZZUzZVakdl?=
 =?utf-8?B?dE40dGs5ZW4xNUFBOUxnbGV4RDRvOE56QlJnWWlxUFBuWHFiQUlBMjJoKytH?=
 =?utf-8?B?b1VBbllMSWIxWEg2NVdYaWNDSXoxSGVsS3lYKzZSQXRxcGlyTEU2QjNLOHdo?=
 =?utf-8?B?THI2OGE4SERnTTB1Q1pOM1JhVFh1VVNLNWtHZi83eitoQlE1ZWdkeHVPNjZy?=
 =?utf-8?B?THlsUUhTTVdWTG45RXovYU5XWmM1N3Q2Vi8vUHdScWxlVTl2aGhxUHB4Nm93?=
 =?utf-8?B?SVNnamo4QkVCb29tdGI4ME5FRnk3NU5ydmR1cUttR2pRckU5cDNZWkVrYlJn?=
 =?utf-8?B?Ti9lU1Qrb3BUcVE2UURUSmpKRlU3bUZhWkt6YzZvUndiRS9weGF6NnJGTzA3?=
 =?utf-8?B?cnhyckVaRkpqL0dQOHF3Q0pqRDhlK3lYckQ5L2V5SEJZbHZvbW9ELzBnWHlP?=
 =?utf-8?B?RGVXYzhhbkpIdHNFcGRCSUdmc2Zhb3FjeW9rYmVya3lac0hKOWZQTnNnQ09B?=
 =?utf-8?B?cFhTakkyVWJrZlZrdWc3dmwxVjNEYlR3Y0ttN1NIN3VYbndNQ2RCV1NSb1cw?=
 =?utf-8?B?eWxBTGVOcCtHNk5NODNWN1hqeWQ3eDFPWDVtRkp0RTRuTEUxbVNnMS93ZWd0?=
 =?utf-8?B?c0hreUJUS2VheE1jVjlEbGNHRk10aFNJcDc5Q2xSZlRGajNkVjJyYTNTT25u?=
 =?utf-8?B?L2J6eGQrczhNWk9kcTFYZFVLV1JZN2lCalZ1L1BuZDVXQTQ3TjNQb3F6SEZP?=
 =?utf-8?B?aDUxNjR1bWlsQVVNT3hUOWNPeDRPaXNKSWdSdXJtanYyWnhteWVtRmVuTm5S?=
 =?utf-8?B?YjRsMno0NVpUOUIya1c5a2o5c0gzZkFzNVR2TkZrRWQzMUIxd1IrVmdpVUpQ?=
 =?utf-8?B?ZGV1c1BWbXVMUGxGMjBzSmNYZnY3UFdmYzFSQ2FzL1hjZy9NcVdXYWJaNENm?=
 =?utf-8?B?bGJUK1Y0T3I5S1NSU0tBcS8rY1hGMVhQWkJhZzB2eDUrYVJBZlpNSXlHSUdD?=
 =?utf-8?B?L01LWDhPRnJKb3dIZDlxNll5dnpMUzBMYjlmMUZwZ3Z2Y1RaQk1nem1FOUo0?=
 =?utf-8?B?OHhoVjM0cDhTNmhlYk5QWUNJMUQxM0c3YzNlSWY3U0wvc0M3bUpoK3BRT21t?=
 =?utf-8?B?UC9GazYvNTZhUFp4NUZuT1N4L2hmdjN5RGZ2YTNmTW1DZzBramNXbzB4bXpD?=
 =?utf-8?B?NzliMjRNMWd3Vm55QUZrY2VOekwxcjkrZy9rU1o4MmpRRlhUMjkxUlRrU3Vv?=
 =?utf-8?B?Z0s1djVrZm5zdEdtOFYwcUxaR1FEd2xzVU5YY1hDWGMvNWRnc3o2SFFZTTlt?=
 =?utf-8?B?SE5aa3pxcGlyMnc0RmVHdmlzMklPSHJnVTFaNGc4RjIvY29QWVVzeW9pVEov?=
 =?utf-8?B?WnBtZVlhZEcrekFBUG9CY1NMeFQ4SW1IUTVrRDU2TTVvbVJWUnlSYXVFZEtO?=
 =?utf-8?B?Q1RoNkdvc0lxTHJ1QkluM21CUGZUQ1JzRDdERHhPT0ZLUmR3TWo2UzFKVVls?=
 =?utf-8?B?bjVMTlg4NUl5V2NUTDVQYkVQYTRNcklYQi8xeVQ3bEpmQXhzTW9uSm9qZVMv?=
 =?utf-8?B?alhZYmNUVzA1UzJEa3dqUVA2REwrWk0wR2ZINk9zMWlqSUdoVEV4WDdTeWJM?=
 =?utf-8?Q?w8dTxH7DC/wHThks5GueTMGkXfWK/g=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f0aXlSPC/9ZtW9gOt6BJ25NaSsJ31s4hYq2aH8ZvRTmBnTB1LQvdv+G2QfDiKTLiRbjISKALPv1NLdDfbJXfMTnS3+8/KN7h9ZtZEz87F/q0ZbJUXozZ2yMa0L26XRLtFW/0lpU3FWrrS9bMwzxNrt7L5uLjz9hQH9yeyqZXsGzCK5F93MadDP15Gy8M501yZFcM5b7ZS/qRg9Ip2t3Y0Z82XvE7o2Ryp5fzkbRlgA1cd/q2h5AIbaK6K6NVlWj2GuXxWliWqmvEDD8p6A2JfvfjmWv5ZuL9cLa028ozkh3fhcsHeYyZ2uNUPfI3bh9u3NFlB1pG/cLvQrjUigrVMdNRqtoG67T1LcBfoTTq3+1VCibnCZMlUXeT+ggAL47+j//B2PJrSXfujFbMMhHzLJmfHBMIhUWtye+fFrnMG3dSccHKmde+74zy25a5qeWaf6krGfRiRMju6jgrBe9okeEia8b+K6+dLG1/RA4pCHFRmdV+FOWCrG9Xh9UZXt+bN/apFjlrbC1nfgfSThMuwZQmriFRIRIwo7xU/9yXiQ2u7VxqeS4ZMfSNfF9I51G4YfPCVQSdGnGNj7z4Sm00iCidjTdxzBJvdMgbuFTUWflmnVu/1PvvEsWJu+3Jgrbfpi7kJ9a7WNu99h/RzDQ6Vw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:16.4199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a89654fc-75d8-40dc-c682-08dd38f1dacc
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR19MB5258
X-BESS-ID: 1737336558-105647-17571-264330-1
X-BESS-VER: 2019.3_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.51.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuaGhoZAVgZQ0NzI0jg5JcXSMD
	XV1MwiNdXY3NDUODkx2Sg5xczM0jJVqTYWAAlDtC9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan10-85.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending background requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
---
 fs/fuse/dev.c         | 26 +++++++++++++-
 fs/fuse/dev_uring.c   | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h | 12 +++++++
 3 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ecf2f805f456222fda02598397beba41fc356460..1b593b23f7b8c319ec38c7e726dabf516965500e 100644
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
@@ -580,6 +598,12 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		atomic_inc(&fc->num_waiting);
 	}
 	__set_bit(FR_ISREPLY, &req->flags);
+
+#ifdef CONFIG_FUSE_IO_URING
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+#endif
+
 	spin_lock(&fc->bg_lock);
 	if (likely(fc->connected)) {
 		fc->num_background++;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index c222d402a7e0eaf4e1898bb3115b10cff1e34165..859e53893eeb5544d57dd961da0e99e7b3d5d9a9 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -47,9 +47,51 @@ static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
 	return pdu->ent;
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
 static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
 {
+	struct fuse_ring_queue *queue = ent->queue;
 	struct fuse_req *req = ent->fuse_req;
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
 
 	if (error)
 		req->out.h.error = error;
@@ -79,6 +121,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 {
 	int qid;
 	struct fuse_ring_queue *queue;
+	struct fuse_conn *fc = ring->fc;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		queue = READ_ONCE(ring->queues[qid]);
@@ -86,6 +129,13 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
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
@@ -191,6 +241,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_w_req_queue);
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
+	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -1139,6 +1190,53 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
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
+		fuse_uring_add_req_to_ring_ent(ent, req);
+		spin_unlock(&queue->lock);
+
+		fuse_uring_dispatch_ent(ent);
+	} else {
+		spin_unlock(&queue->lock);
+	}
+
+	return true;
+}
+
 static const struct fuse_iqueue_ops fuse_io_uring_ops = {
 	/* should be send over io-uring as enhancement */
 	.send_forget = fuse_dev_queue_forget,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 0517a6eafc9173475d34445c42a88606ceda2e0f..0182be61778b26a94bda2607289a7b668df6362f 100644
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


