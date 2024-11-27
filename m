Return-Path: <io-uring+bounces-5070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C48D39DA8B5
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24CB9B2345A
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D291FCFF7;
	Wed, 27 Nov 2024 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="x7fZ8LCm"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F91FCF62;
	Wed, 27 Nov 2024 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714862; cv=fail; b=BwcEw8CGIT4FQ9XYOcxhcDy1IkfYdRqRlCsJB73OwbqwPF69B+NsngsMs4ZC5F10aDaO9o/JoeJYVbJtmzKlc6h53E5+ftRDeaXNf8X9JAggi+pd9kvIuPj19tb22bvM0QLz6GK+4xFy+D7WH40JMoplYprukCzGDYxwUkhziWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714862; c=relaxed/simple;
	bh=CGd2kJgZT7wKAUlWE4ja3E5A7pEy2IsX1oiYSSDjXA8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QrA0L7n7CLBNKtD0cJ4c9/j6Qtwfx/60qJp5PHuUSptl7LnJl+CXjZ4iLqbCdAwgDuFnWb9hhPtIHweqqdBheINWsfD/N8lQGJAnHVXXSDXEXcP9U59rKnZskLqqz1S4bRVHem4rOXOPbPo+h2fqoMiQEfqUXAtxWVdCWyETsBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=x7fZ8LCm; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173]) by mx-outbound8-59.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gz9BeD07D3d/xHKMklnksAVIaKM8ivcR4gdiEJUtNnN/nNkrYwNJsmBEWCm1wIg5lX3qH2oUneLpneWmeSNM2Gvwu+jWwXn4a9MsuzQeQsgM3Ccg0ZCRrluRqtsbOal6SoAdnEt+X9cPKxjYobe9FsadnRxNMrm6e4rhJSZxRGA/7gu2MhfREg5c+V6Cg4hg5dmRLEv+mFaYgLBGXtz82J1jChdF2vfx8+7PVttudTRy9kIn2Tb53oRc0wMoHxvkYq0KzEDu1aJKF9ikVs1mPV59xhY+FGXrQIbT8GDTc3odBIl6ezK46hVwRup+6ZLEH8nEASWlP+o+PODWQWEsIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBRSlVe/+LDEbr2xMDB7t7ibUHe2r+rMTjSPR7kGyY0=;
 b=rixOgQxfDr6y7knYD3xgtUjJKXi2ZlHhmq1uiMT3Clc+psCupRSFhdbj+k2uLmAgq0UWrVqfh4SjkuBj1vYYb91AG/pPEJsT63t8cujFAAkR8NqtBJ4iv5b9wEC+IxbU8qFHhuJ4iCQgEVK5tp2tCf8QEp6TWJOtan3LXcYab2VSfWMnVQfsZ0e4P7h30gHDGfCyZmz2HmqRR3y7mgzGqvUFW+o9rTwM2J7ZxDC3QyRgtKNxKJpOmrxDhR2l2Io/k3pGiB8zIcMmBNURyILzeUpbW0j6BBoswFvPe17gxC27P8KEPB0LXME+4aUA5X9gLq74uUTLFuU4UnwA/m4g1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBRSlVe/+LDEbr2xMDB7t7ibUHe2r+rMTjSPR7kGyY0=;
 b=x7fZ8LCmtDrz5ecWGeYYsGo0RLUd4QZVEkTtIrRyheXQQdAThBPJ1wMEi5cnwQJyh3v39iJrLuVRMYnD60Fr1B0VNjr0/dg8RPrj6UQ8jZzR0zjMOwbu9QZdC/IdXJeYxbiyn6O0r2fQwZF0g8LiG5WLP18t552Q5BW01ThYNyI=
Received: from BN9PR03CA0235.namprd03.prod.outlook.com (2603:10b6:408:f8::30)
 by PH8PR19MB8151.namprd19.prod.outlook.com (2603:10b6:510:1be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Wed, 27 Nov
 2024 13:40:41 +0000
Received: from BL6PEPF00022571.namprd02.prod.outlook.com
 (2603:10b6:408:f8:cafe::d3) by BN9PR03CA0235.outlook.office365.com
 (2603:10b6:408:f8::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.20 via Frontend Transport; Wed,
 27 Nov 2024 13:40:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF00022571.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:40 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 597D02D;
	Wed, 27 Nov 2024 13:40:39 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH RFC v7 00/16] fuse: fuse-over-io-uring
Date: Wed, 27 Nov 2024 14:40:17 +0100
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEEhR2cC/33OPU7EMBAF4KusXDNo7DjjmAoJiQPQIorgn42LJ
 CsnMaBV7s4kQstSsOWz9b55ZzGFnMIkHg5nkUNJUxoHDubuIFzXDscAyXMWCpWWKGuIyxRgyWk
 4QhwzEEiEHJ0Gkh6jo6aWsRFcP+UQ0+dOv4qX5yfxxo9dmuYxf+3nit6/NhktSnjX1zibpYKPN
 HfjMkPftyfgjGAVmmgqK7XWj94P927st3M/A+n/gUVvda46U1dEFC71bVmpL2ukRHODqZkJDRG
 2lldY+5ehK0apGwwxo5pAznsMDP0y67p+AwQEzB+YAQAA
X-Change-ID: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=8554;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=CGd2kJgZT7wKAUlWE4ja3E5A7pEy2IsX1oiYSSDjXA8=;
 b=nevxf4RtVEQNJlIjoJ0MOC67iuqPcEWCSokWbzk5iguaCXqNH1Fia+UdAAtS0vrVziHlqv9pE
 1uGP+rsguHiD6Xxr7cT3IAELaJcjOLSHVSECPYqwuhmwwpJMjceNWnL
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022571:EE_|PH8PR19MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 04fe5234-ab7a-4735-e495-08dd0ee91555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEF0UUI5bmM0dmpudWswRGxDeXBlek9kelF5T2tmYjAxRm85UkRwbDROUzNG?=
 =?utf-8?B?SGhlWlVMcjY5Uy9UZnVHa1k4MVRPWHZyaTkxU09SaGdXVEkxdGRESm90VVh5?=
 =?utf-8?B?eVRvbjVOTWJkMjJCV1J2bHhBSkwzMzFveU5Sd1VnRGVTb0tXT3E2ME8zN1By?=
 =?utf-8?B?K2hkejdKMFoyS0FOc2xHMFdyckhhNjRSZGFld0syaC9Md0oyTDlFM0dIR25t?=
 =?utf-8?B?WTI3alVhS0t5OXdiajBlamc0UllsSUgyTVh5SEZVM2JpdG13Snc3aWdXZnpu?=
 =?utf-8?B?TnM4cXVhWWxodUFHYnJUbm9SKzNjVDhSSGdmM1grZjN4a3VKeXFrNG5zSXR5?=
 =?utf-8?B?RXhmT2c3UVlNdW1icE05dVRTSjNzcjJpRmNmdys1QnB2elo2akZOc3YyRFZP?=
 =?utf-8?B?UWJ4VFpzYWtnNndRVkFkaStOWWZiN1ZITDREUlhCcGNBVHBCVUpSQThmZ0Uv?=
 =?utf-8?B?aVJrc1E3dC9oblZtWDBqN2QrZzJiWS8zY3ZvTDY2OFFaNEhUY0R4dTh0Njls?=
 =?utf-8?B?Nlh4RHBPV0xmdlVkWisrSW1Ma2l3cVJGOFJDUVNBU29rUFArQllNNGtKK2tw?=
 =?utf-8?B?eFRrNUQrMElHaGU2eDZBWFQxd0ljUkkzWk1BM2pZZDZLV0tDUzdiKzdZeVlH?=
 =?utf-8?B?YXFraXJvcFNDWW1OOEpLYXhNQzBtRHVNeXJ0azY5a2kzRi9FV0FMZUJ1djZj?=
 =?utf-8?B?VDFpOTh1cFo5em1XNDV2ZllsRVN6SWhhUDVEMTdVTnlxbnl3L2lRV2xDYnhv?=
 =?utf-8?B?MEtBUGx1eEhCcWk3RWtLb3NlMjRuZnJUVjdlbUE1bWxuU201WDl4MXhsYWkx?=
 =?utf-8?B?bHAvQU5TYnUreWFhM2VYV1lXZS8zOHptaStOS2VZM1RYV21KSzA3Y2NKQk9R?=
 =?utf-8?B?ZjhQZDBBUFhnOEpQYjE0TlhSQ29ZZEdYNFRkTWdhbTk4ZC9TdkszYVRmbVVO?=
 =?utf-8?B?VUhiKy9tVjl1NkV5K2NSNmpZck5jTGpPZlFyZTVrSEZpMGJ0Sms5TU5ic2ZL?=
 =?utf-8?B?VXRtYkFsQ1lCbkw5c3RJTVhnV0QxZThTeU5jdmp4NGlhTm4rRndEQXlwaVFB?=
 =?utf-8?B?bCtZbHR3S2tQRzZ0L0Zxbm1jc1grcVludVpMNDRvZlNqQ25NZUFCbWRYbGZ0?=
 =?utf-8?B?YmpPam5oTDlGbFBHOVNXUHdrdHVzTW1QZ1Rjc2kyQzhiTndHSTgxNXcyTWc2?=
 =?utf-8?B?WHhxS3V5ektqYTJEUlFPbHFScVVmRkc3VnpId1JrQ2tVckpGWjIrRjA2aFc4?=
 =?utf-8?B?UTV1WjhnQkh4WXNZRGw2Kyt3QUlXUXpVamt4RFJNdFJRVThwYmExbWJZaEtT?=
 =?utf-8?B?czBOaVgwVGFueXdtMElLS3VKU3g0Z3RRUXh6dmdtZ3BLRDZScDZJbDJNR2Q0?=
 =?utf-8?B?Q083VHFVcDhvNEpQL2N6QlhQTk1kZ2YvdjZwU1JETVFqMm9Ud1BlV0IwL09C?=
 =?utf-8?B?cGNlb2xaRTlFWG9HWU0yZEdicDRveEwyTVROZDBzNXQzRGIzTjNVeFRHRU5t?=
 =?utf-8?B?b0RaZDdEaHFWVTVaMmUrOVVPckYxdXhwdXVmaWdkemw4ZHVObTd5QWVLRmdu?=
 =?utf-8?B?ZnluZmQycjE1WVd6aXB1QWh1eWR6bm9jN2VCSENuU2R2aldvdVkrT1I3by8x?=
 =?utf-8?B?VlpHaWNwUi9tNWN1NmVIcDFzaE9PYmk3UlVYSWFGMExsTVQwSXgwU1hKcXRZ?=
 =?utf-8?B?M0Z0MWQrUWl6b1dpSzY0N0VXcTJFQjMwamtSQW9lRXVtMkNxT095V21xMzgr?=
 =?utf-8?B?bGVyUW1JL2x1UEQxMWFUQTcvTUVRa0FnbXdlZHFMZHZMS2xXT28zM2dmdkxW?=
 =?utf-8?B?d1JjT1hJdjQ1eFlLYjFDam51ai9EOUlRSm5tSlZPelNRTnhrNVNlSGNIaTR2?=
 =?utf-8?B?YmhNYXpXZml6TU5wRUdVUnJCLzJPd3liRGhzOFZCL0psOWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1jf8yWpt7yMwCeQVs7hZTQB04SxEQkBSkDPxaITzF90qHCMy2Phm4a4y9hHS1HOBE9xsuqKBQlHOya6Yoda+lOsXOUp+yroVJ7pnc2q9AbhpeAIwvxFatMDZtUxBY6XbTJgizeSXRC/slqvC0mFEJyQ7DQmTjXhQQpR6i1nJiOnJNKKbYBZ0HL8m81o7nD1DtMM6OXbfg6ynsTAJFBtULUbfDYALVF04S5539zDGjaLJDfcq75MYyUMhKSceQF9d8DvE9tO1NfvbXOV90g/qpFiwk/gxziSMLPdoGPU0yDm9TS92l877qhKmKp4/udAkGFCITDp3CNFgkRK/e4vU0tEEvq00KN4hjGmFEsejcOoDPK7ps0UY1w8Czko7sRyfxFLDERgQZsMfLbw/PVtjnYdWBxjMW467PGrF3+nU4UR/gALkey5prokTs2SSFfTwTlCZhCKSU5W4W3ls55BqNd4e8576fVXMmsW/s83j5yhOy6cAe3YycZC6agh/1e9htH4NSmiDctSIE3Sq7Rip3fFl/yi/reuBEIIKq1phh1+dF3RWP3km//iNnHVBQb/xom/lxAsWhkKDi12s/tFuelFYzqHKpNVToaOwKbihvfWKEQW/KsBswZUP4k0Rx8IEVY9IqL47hhglHb24ITq4Og==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:40.2566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fe5234-ab7a-4735-e495-08dd0ee91555
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022571.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB8151
X-BESS-ID: 1732714845-102107-13455-2163-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.59.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhbG5gZAVgZQMDk1zcjMJNXU0N
	LAMs3C0DLN2CzN0iQp2SzZwCzR0CBVqTYWAKkwW1hBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan22-228.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

[I removed RFC status as the design should be in place now
and as xfstests pass. I still reviewing patches myself, though
and also repeatings tests with different queue sizes.]

This adds support for uring communication between kernel and
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
Bernd Schubert (15):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: make args->in_args[0] to be always the header
      fuse: {uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add fuse-io-uring handling into fuse_copy
      fuse: {uring} Add uring sqe commit and fetch support
      fuse: {uring} Handle teardown of ring entries
      fuse: {uring} Allow to queue fg requests through io-uring
      fuse: {uring} Allow to queue bg requests through io-uring
      fuse: {uring} Handle IO_URING_F_TASK_DEAD
      fuse: {io-uring} Prevent mount point hang on fuse-server termination
      fuse: enable fuse-over-io-uring

Pavel Begunkov (1):
      io_uring/cmd: let cmds to know about dying task

 Documentation/filesystems/fuse-io-uring.rst |  101 +++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dax.c                               |   11 +-
 fs/fuse/dev.c                               |  124 +--
 fs/fuse/dev_uring.c                         | 1269 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  204 +++++
 fs/fuse/dir.c                               |   32 +-
 fs/fuse/fuse_dev_i.h                        |   68 ++
 fs/fuse/fuse_i.h                            |   27 +
 fs/fuse/inode.c                             |   12 +-
 fs/fuse/xattr.c                             |    7 +-
 include/linux/io_uring_types.h              |    1 +
 include/uapi/linux/fuse.h                   |   67 ++
 io_uring/uring_cmd.c                        |    6 +-
 15 files changed, 1866 insertions(+), 76 deletions(-)
---
base-commit: 3022e9d00ebec31ed435ae0844e3f235dba998a9
change-id: 20241015-fuse-uring-for-6-10-rfc4-61d0fc6851f8

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


