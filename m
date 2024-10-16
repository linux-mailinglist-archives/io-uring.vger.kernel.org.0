Return-Path: <io-uring+bounces-3713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF02A99FD48
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E33828219E
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4592D1078B;
	Wed, 16 Oct 2024 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Bwf0fltm"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386DC156E4
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039194; cv=fail; b=B9QyyU1Sges+y8ABkOIqp1NeQnV0Qs+FGsO7Q4RCses4QBH0YHMJpwtAPsz6kinSBLmv1qqim1T/fnNS/Idcr1XWSfZOorO7St1FN67GDshgqbO7pLLpQGMK8p/A5aRviYNamq7k2S84AvzWak58FxIZO5U/HPuR3N9KSbU9QGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039194; c=relaxed/simple;
	bh=Xyu4lzOIYK3rydC7fD7Qp2upw2uHgx6RcLTassdicXk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=djxJ4LO61OjR1+QHtWCtczRlumlaSRlQ4/G8QKlH0BW9pJR8CnAXCOuvHnwdGrSKf2cCTUR6UFd89yt6ut6ucZ6hvjKiGLwMSrBArnCX6n5qTCxstxofkRyk9hTSGr/QQyaDwbD7PEj2s3NrLXEqZvrDj3cmf8v0ljU2lh6aX5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Bwf0fltm; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:39:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHwKe0BQwZ8MNwQNOIZPp+5xbJ8CZoXzTXk3WHlHuuJF3DzX1CvTPfHQsS/yFKiI3kSQhSqFKRpD1xiqXnC1u1AhSHn6a6rcfG5lCTCw8DcAA3MRw6I3PfnsDdgvniz1NfAGzOOXifVkr5hvJfltASbkuh8LH3vamyhItGnOKRggQKH33cLHYhFBA3N/9mVOhePYOAMxzTB9ZWR1eGeo/04nnO6XrCdHUUBGnLt4BN9adxIkC9iqqNYCCpEfVCtPc+o57GU7ssoGviV5y3e8n6W62TnKJZtifYHqo4N5lzAdjNWG125oPytXXcTMHlDFtvm/Afi8sZ1s6SoQJ+dN8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N41cDtaw3XrpYKhdfFo1lNO2AIt7smgvknmSUcdyQ4I=;
 b=axlAlQlNSQ2Wzz+ICadaI9beB7XDJGNZxe72TeTP3X9u0A1vA3bScwJ0TdH+kJyxJ6iMRAPCcZX5pds9t6ggCWG4oVoGpwp8v57Smte+zKn9W0PwDcMap0GAv94NrJcbnjMrZX0kFbCAkbk3ds633RDg/PD0R/Ttz7zcJt7BTAD0kWbMcVy5U1KbO1FHXWBEN6TzwtiVZ+GGhw4cpN5uuhQi+GMUBL4nHH66SntGS5QoeBKmNVyocJLSnYJIAWRLbXSsQlYdgRuhAwptE7rVycZEtyFVBxi0E3JZmuuyzI6WwRlrvotRzQgIfIjj/A+PUJpq1ZXJ2GndWJtRB+4fXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N41cDtaw3XrpYKhdfFo1lNO2AIt7smgvknmSUcdyQ4I=;
 b=Bwf0fltm5qSmGr1z/691KSB3ZohdPXuZKz2hmisnRoVdmJHTm3OfR2gcD1vQNOVMJGeM1/HFGYIpVauMTb6/7GUHuXdvPcxhXiYlvk0AnjmRDeZKee/DICwOQbV+4/MD7kFZnvrhyImYXDAmr5c5gLx3SJB6RiEfB7UfnGEjGlw=
Received: from SN6PR2101CA0024.namprd21.prod.outlook.com
 (2603:10b6:805:106::34) by MW5PR19MB5506.namprd19.prod.outlook.com
 (2603:10b6:303:192::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:05:33 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:805:106:cafe::9e) by SN6PR2101CA0024.outlook.office365.com
 (2603:10b6:805:106::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.5 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:32 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id BBF0929;
	Wed, 16 Oct 2024 00:05:31 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:20 +0200
Subject: [PATCH RFC v4 08/15] fuse: {uring} Add uring sqe commit and fetch
 support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-8-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=18785;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Xyu4lzOIYK3rydC7fD7Qp2upw2uHgx6RcLTassdicXk=;
 b=WRqbtKM51kkY7AUij2BYE+0w3Yi3qrihVV8Itop01JgjVfbSB2WKvR/u9wN/0SkVtSjdhylrD
 UlhkQROQ5aICkzL8TcSCO0HueBBNTXYRoI7UNPpVlbEnXuSxOU9uF7s
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|MW5PR19MB5506:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a784b8-4142-43d2-86a9-08dced7640bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlVLNEVmUWZzRkppTDNONkg3eWZNNWdCK0NCd2daMnRDMTdWdUtXdGN5NG5U?=
 =?utf-8?B?SVdObVQvRG0yLzdYZmdtZllINFNrSWd6YmgyQkxBMGtoUWt3Y0dMUzhOZnZW?=
 =?utf-8?B?VzJNak5EUUVEcUg1TlQrM0Q1SXByV2taSENXK1VveUFRRVBHSHJ4VHh4RTdS?=
 =?utf-8?B?WVorMHczRWhna1lBTU9Pc0Z4bHZodHI1L2IwTmlkQ1Y0OWZiWXEwTStDODdy?=
 =?utf-8?B?TkZhbDVMRWMxRkUyczdBSWdmc01QcEh0bTJqTVBIR0htSm42aDBDMjRRQmlj?=
 =?utf-8?B?enpjZTRnRDRtT0c3M2Q1M1dIK3hLZS9jRGdRWXZBcjdEMUJkTWhBTmdyME03?=
 =?utf-8?B?MnlCa0RuUHdRUGljd0d3ZDE4YVdROXMvN0tFTkhqYmhhdXRtOVMvWDc5dUlo?=
 =?utf-8?B?SWswYktlUzg4aE5rWnk0OUFtU0V3bHBJdFg4dGVJRWZmVWpnWVVGU3hkMHZ0?=
 =?utf-8?B?RTcxTFVMc1B5MUJDQTcyRG1vcTFCR21jR0MvTlV1TDQrUjNONFNaWnQydDBi?=
 =?utf-8?B?M1lKcFk3YkhYU0dnR3VoUWxhcnhPWG9XYk1pOCtISWFyTW1hNjRLZnBoOWNo?=
 =?utf-8?B?N25ITmg0YzhQWU02MGRWaGpRVW0vZWQvOEs0UHU2STVnT2pxUDBFV29Sa3Js?=
 =?utf-8?B?ZDZCeVE2VVU1bEg2UXkvWkVDUXBBczJIRzF1QXpOR0E1S0ZDclhqZ3BoUjMz?=
 =?utf-8?B?RGdoZTNPOVNBTlgyU1JWeVhnUUxvLzUvSnpOcjdDN1UwMy9XRG9EYlhHR1Vz?=
 =?utf-8?B?R2l1VWg3VlQ3cER5T1N6bElrZTZvTE1veXk4TG9FRmxzSldoQTYrcWIxMnR6?=
 =?utf-8?B?MjFtbXFUNTg2Wmo2eTYrOVQxNmNwSmZTTGw2WjhrS1dnSFZQTzltb2tidWNY?=
 =?utf-8?B?cGw3NEhZem1odGpqNExpc3FGR3E2ak9oajhzZmlsTWp0Ky9WTUVlUzdubHFI?=
 =?utf-8?B?WDlOM21CMWl3ZTVibFpVZU1QazRkWlAvc05XaE5pVGUyaFpXbmZmc3JNbkFy?=
 =?utf-8?B?S3JId3NuelA5YXIwU2NYQ0R2MGVRdDhSYUM4anBXTnEvN0lQRW5DUW9hRUl0?=
 =?utf-8?B?WWliOGcxWjIzemp1MzhxOTdZdVI4bVpmQkg1MHY2NnI4OHFBemRwSGRtSnM3?=
 =?utf-8?B?OTUyUm00N29aTTJHYTg0NUFUaEJuTy9nRDQyZEQ2S29NeXpSankwYS9vUGdN?=
 =?utf-8?B?aS9aa2JvQXl3cTU0TlEvZ3ExcTZna0N1cHVXQUFPKy9ocjM3RGMrMUlZZVRN?=
 =?utf-8?B?bEVHODdiUUxTcW1vT04xbDhKdTE2U2lOQ1NFNWFyMzRVYVZGUytTTmI1S1VM?=
 =?utf-8?B?TGNVZUErZ0svbTJKRGQ5eWpSRkcyUFpKVGhGWTZ0cWRVYTF5em95MWdwc2ZE?=
 =?utf-8?B?QmhMNUo5czh5QVgxR01VeG9iV2hGaUtydW5NTGRuMWpncU1HRm1WOWtSUUF6?=
 =?utf-8?B?a2ZUc2dLa0hOQUY3TzJMeWxKMUlzVXdVRE9samNLNm1IRFF0QVdLR3Q3NDVC?=
 =?utf-8?B?TVB3bG1qeTVuaDJ1Nm80OXErWlFjUXNpNlpTMFdyVXpPUmZFVEczeTNFdG01?=
 =?utf-8?B?ampFSUpFejlmRWdKemQ3TU93UkNGT0FJYVNrQ2Z6UktTZzhUV2tJQnhoa1RU?=
 =?utf-8?B?RERlbG5PVGJTbVlSY0RiUWxXY2pKc0w5c1hUSy9Xbm9IRUxzSGg3bkI5eWxC?=
 =?utf-8?B?VlpySXZ2UmpSZDNBZlZpRDI0OVFWZm9jUG5aWk01SnNIRVBxczVDMWdLR2Vz?=
 =?utf-8?B?NjE4OE1IdXUvMEhKMmtYWWNXS2JXV2FHejN1cjU1ZlF1NWZLKzZnUUhBMW94?=
 =?utf-8?B?ZzFOR3lkMFl1aWFmZjEzWFhENVg3eVZwV3ZJL2hhYm1Ha0pYNEo1Sm1Pbktl?=
 =?utf-8?Q?syv8TTYXmHZyd?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LNoCR6oA+zYedqU5eR+etLu4+buEvfMB/MSu4QWmWAeevU/IjuxppYkh1EKOax1/DwKL3m2En5/wz+lDKYC0OMGC0UWpuOPoWMULP7Mps8x5H/FsItfo0IGQeCftMl40QLAEwp4/Al7K2TbEqGjrIjs0Kte1gYV1f5XsN1ETLyyn9HkPuIfFYtMr/i37AzswXXg9APkk0vhzUmfscD1PGjNCZFtFN5xAi2o7JFGRdAsj5U6gVB1UIRcEs/YJRTHfFiHMziG7QPUnwwQ8Bgb+Jc/xKtQ1HYdIx1XRbHOTPWVePHAz1HssL+SaKKDYUWWUNaJXapM62bYxebNAvf0AxoN76+RwBbfdWRy2N7addCggACrGSdEfm6hvSaBXJyn9rmufvkrGqAyXm8YghERHZSHvjzJ2jLIDdPWyIkumXV10iQTW3fI6KyqY+PwVXLhuaIstZl+LNk97fB1Bi/XsZ9niYF+cYKwhmy05hFznCrRm45aBvIx0RcVlxWj8qvjO4kQZKs7Y1qzHrfattvjjSJMbNa1IHSQOZsZIVrAeFo2e3Rn5GoNbA0QhzTi/DHk0F6MIAS/S0DGcx2aydGtjBl0za1ObqntcE/oHuF3+UZ2It21b1wNIer9tAutDbKdqMxJXTCCMpVBtiRZ+VCWtcw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:32.6851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a784b8-4142-43d2-86a9-08dced7640bc
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR19MB5506
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039190-105647-17923-34648-1
X-BESS-VER: 2019.3_20241015.1555
X-BESS-Apparent-Source-IP: 104.47.73.41
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWhsbGQGYGUNTQ0tDYwszAON
	koMdEw1Sgxxdw8ydTQJM3Q1CjR3DzRXKk2FgDpjgbwQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan21-66.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_REQ_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   6 +-
 fs/fuse/dev_uring.c   | 430 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  13 ++
 fs/fuse/fuse_dev_i.h  |   7 +-
 fs/fuse/fuse_i.h      |   9 ++
 fs/fuse/inode.c       |   2 +-
 6 files changed, 462 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 12836b44de9164e750f2a5f4c4d78c5c934a32b4..fdb43640db5fdbe6b6232e1b2e2259e3117d237d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -188,7 +188,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1844,7 +1844,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1929,7 +1929,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 724ac6ae67d301a7bdc5b36a20d620ff8be63b18..0c39d5c1c62a1c496782e5c54b9f72a70cffdfa2 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -19,6 +19,22 @@ MODULE_PARM_DESC(enable_uring,
 		 "Enable uring userspace communication through uring.");
 #endif
 
+/*
+ * Finalize a fuse request, then fetch and send the next entry, if available
+ */
+static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
+			       int error)
+{
+	struct fuse_req *req = ring_ent->fuse_req;
+
+	if (set_err)
+		req->out.h.error = error;
+
+	clear_bit(FR_SENT, &req->flags);
+	fuse_request_end(ring_ent->fuse_req);
+	ring_ent->fuse_req = NULL;
+}
+
 static int fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
 	struct fuse_ring_queue *queue = ent->queue;
@@ -50,7 +66,9 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
 		WARN_ON(!list_empty(&queue->ent_intermediate_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -107,6 +125,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
+	struct list_head *pq;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
@@ -114,6 +133,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
 		spin_unlock(&fc->lock);
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		return ring->queues[qid];
 	}
@@ -125,12 +145,228 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 
 	INIT_LIST_HEAD(&queue->ent_avail_queue);
 	INIT_LIST_HEAD(&queue->ent_intermediate_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->fuse_req_queue);
+
+	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+	if (!pq) {
+		kfree(queue);
+		return ERR_PTR(-ENOMEM);
+	}
+	queue->fpq.processing = pq;
+	fuse_pqueue_init(&queue->fpq);
 
 	spin_unlock(&fc->lock);
 
 	return queue;
 }
 
+static void
+fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+}
+
+/*
+ * Checks for errors and stores it into the request
+ */
+static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
+					 struct fuse_req *req,
+					 struct fuse_conn *fc)
+{
+	int err;
+
+	if (oh->unique == 0) {
+		/* Not supportd through request based uring, this needs another
+		 * ring from user space to kernel
+		 */
+		pr_warn("Unsupported fuse-notify\n");
+		err = -EINVAL;
+		goto seterr;
+	}
+
+	if (oh->error <= -512 || oh->error > 0) {
+		err = -EINVAL;
+		goto seterr;
+	}
+
+	if (oh->error) {
+		err = oh->error;
+		pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__,
+			 err, req->args->opcode, req->out.h.error);
+		goto err; /* error already set */
+	}
+
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
+		pr_warn("Unpexted seqno mismatch, expected: %llu got %llu\n",
+			req->in.h.unique, oh->unique & ~FUSE_INT_REQ_BIT);
+		err = -ENOENT;
+		goto seterr;
+	}
+
+	/* Is it an interrupt reply ID?	 */
+	if (oh->unique & FUSE_INT_REQ_BIT) {
+		err = 0;
+		if (oh->error == -ENOSYS)
+			fc->no_interrupt = 1;
+		else if (oh->error == -EAGAIN) {
+			/* XXX Interrupts not handled yet */
+			/* err = queue_interrupt(req); */
+			pr_warn("Intrerupt EAGAIN not supported yet");
+			err = -EINVAL;
+		}
+
+		goto seterr;
+	}
+
+	return 0;
+
+seterr:
+	pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	oh->error = err;
+err:
+	pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	return err;
+}
+
+static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
+				     struct fuse_req *req,
+				     struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_req __user *rreq = ent->rreq;
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct iov_iter iter;
+	int err;
+	int res_arg_len;
+
+	err = copy_from_user(&res_arg_len, &rreq->in_out_arg_len,
+			     sizeof(res_arg_len));
+	if (err)
+		return err;
+
+	err = import_ubuf(ITER_SOURCE, (void __user *)&rreq->in_out_arg,
+			  ent->max_arg_len, &iter);
+	if (err)
+		return err;
+
+	fuse_copy_init(&cs, 0, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	return fuse_copy_out_args(&cs, args, res_arg_len);
+}
+
+ /*
+  * Copy data from the req to the ring buffer
+  */
+static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_req __user *rreq = ent->rreq;
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	int err, res;
+	struct iov_iter iter;
+
+	err = import_ubuf(ITER_DEST, (void __user *)&rreq->in_out_arg,
+			  ent->max_arg_len, &iter);
+	if (err) {
+		pr_info("Import user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+	err = fuse_copy_args(&cs, args->in_numargs, args->in_pages,
+			     (struct fuse_arg *)args->in_args, 0);
+	if (err) {
+		pr_info("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	BUILD_BUG_ON((sizeof(rreq->in_out_arg_len) != sizeof(cs.ring.offset)));
+	res = copy_to_user(&rreq->in_out_arg_len, &cs.ring.offset,
+			   sizeof(rreq->in_out_arg_len));
+	err = res > 0 ? -EFAULT : res;
+
+	return err;
+}
+
+static int
+fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_req *rreq = ring_ent->rreq;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_req *req = ring_ent->fuse_req;
+	int err = 0, res;
+
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p buf_req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent, rreq, ring_ent->state);
+		err = -EIO;
+	}
+
+	if (err)
+		return err;
+
+	pr_devel("%s qid=%d state=%d cmd-done op=%d unique=%llu\n", __func__,
+		 queue->qid, ring_ent->state, req->in.h.opcode,
+		 req->in.h.unique);
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info("Copy to ring failed: %d\n", err);
+		goto err;
+	}
+
+	/* copy fuse_in_header */
+	res = copy_to_user(&rreq->in, &req->in.h, sizeof(rreq->in));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		goto err;
+
+	set_bit(FR_SENT, &req->flags);
+	return 0;
+
+err:
+	fuse_uring_req_end(ring_ent, true, err);
+	return err;
+}
+
+/*
+ * Write data to the ring buffer and send the request to userspace,
+ * userspace will read it
+ * This is comparable with classical read(/dev/fuse)
+ */
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
+{
+	int err = 0;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_complete_in_task(ring_ent->cmd,
+				      fuse_uring_async_send_to_ring);
+	return 0;
+
+err:
+	return err;
+}
+
 /*
  * Put a ring request onto hold, it is no longer used for now.
  */
@@ -157,6 +393,197 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_WAIT;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_req *req = ring_ent->fuse_req;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	hash = fuse_req_hash(req->in.h.unique);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+	req->ring_entry = ring_ent;
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
+					   struct fuse_req *req)
+{
+	lockdep_assert_held(&ring_ent->queue->lock);
+
+	if (WARN_ON_ONCE(ring_ent->state != FRRS_WAIT &&
+			 ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+	}
+	list_del_init(&req->list);
+	clear_bit(FR_PENDING, &req->flags);
+	ring_ent->fuse_req = req;
+	ring_ent->state = FRRS_FUSE_REQ;
+
+	fuse_uring_add_to_pq(ring_ent);
+}
+
+/*
+ * Release the ring entry and fetch the next fuse request if available
+ *
+ * @return true if a new request has been fetched
+ */
+static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
+	__must_hold(&queue->lock)
+{
+	struct fuse_req *req = NULL;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	if (!list_empty(req_queue)) {
+		req = list_first_entry(req_queue, struct fuse_req, list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+		list_move(&ring_ent->list, &queue->ent_intermediate_queue);
+	}
+
+	return req ? true : false;
+}
+
+/*
+ * Read data from the ring buffer, which user space has written to
+ * This is comparible with handling of classical write(/dev/fuse).
+ * Also make the ring request available again for new fuse requests.
+ */
+static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring *ring = ring_ent->queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_ring_req *rreq = ring_ent->rreq;
+	struct fuse_req *req = ring_ent->fuse_req;
+	ssize_t err = 0;
+	bool set_err = false;
+
+	err = copy_from_user(&req->out.h, &rreq->out, sizeof(req->out.h));
+	if (err) {
+		req->out.h.error = err;
+		goto out;
+	}
+
+	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
+	if (err) {
+		/* req->out.h.error already set */
+		pr_devel("%s:%d err=%zd oh->err=%d\n", __func__, __LINE__, err,
+			 req->out.h.error);
+		goto out;
+	}
+
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	if (err)
+		set_err = true;
+
+out:
+	pr_devel("%s:%d ret=%zd op=%d req-ret=%d\n", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	fuse_uring_req_end(ring_ent, set_err, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
+				    struct fuse_ring_queue *queue)
+{
+	int has_next, err;
+	int prev_state = ring_ent->state;
+
+	do {
+		spin_lock(&queue->lock);
+		has_next = fuse_uring_ent_assign_req(ring_ent);
+		if (!has_next) {
+			fuse_uring_ent_avail(ring_ent, queue);
+			spin_unlock(&queue->lock);
+			break; /* no request left */
+		}
+		spin_unlock(&queue->lock);
+
+		err = fuse_uring_send_next_to_ring(ring_ent);
+		if (err) {
+			ring_ent->state = prev_state;
+			continue;
+		}
+
+		err = 0;
+	} while (err);
+}
+
+/* FUSE_URING_REQ_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
+				   struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	uint64_t commit_id = cmd_req->commit_id;
+	struct fuse_pqueue fpq;
+	unsigned int hash;
+	struct fuse_req *req;
+
+	err = -ENOTCONN;
+	if (!ring)
+		return err;
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue)
+		return err;
+	fpq = queue->fpq;
+
+	spin_lock(&queue->lock);
+	/* Find a request based on the unique ID of the fuse request
+	 * This should get revised, as it needs a hash calculation and list
+	 * search. And full struct fuse_pqueue is needed (memory overhead).
+	 * As well as the link from req to ring_ent.
+	 */
+	hash = fuse_req_hash(commit_id);
+	req = fuse_request_find(&fpq, commit_id);
+	err = -ENOENT;
+	if (!req) {
+		pr_info("qid=%d commit_id %llu not found\n", queue->qid,
+			commit_id);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+	ring_ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ring_ent_unset_userspace(ring_ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ring_ent->state);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+
+	ring_ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+
+	/* without the queue lock, as other locks are taken */
+	fuse_uring_commit(ring_ent, issue_flags);
+
+	/*
+	 * Fetching the next request is absolutely required as queued
+	 * fuse requests would otherwise not get processed - committing
+	 * and fetching is done in one step vs legacy fuse, which has separated
+	 * read (fetch request) and write (commit result).
+	 */
+	fuse_uring_next_fuse_req(ring_ent, queue);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -281,6 +708,9 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	case FUSE_URING_REQ_FETCH:
 		err = fuse_uring_fetch(cmd, issue_flags, fc);
 		break;
+	case FUSE_URING_REQ_COMMIT_AND_FETCH:
+		ret = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		break;
 	default:
 		err = -EINVAL;
 		pr_devel("Unknown uring command %d", cmd_op);
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 9a763262c6a5a781a36c3825529d729efef80e78..9bc7f490b02acb46aa7bbb31d5ce55a4d2787a60 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -19,6 +19,9 @@ enum fuse_ring_req_state {
 	/* The ring request waits for a new fuse request */
 	FRRS_WAIT,
 
+	/* The ring req got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* request is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -43,6 +46,8 @@ struct fuse_ring_ent {
 
 	/* struct fuse_ring_req::in_out_arg size*/
 	size_t max_arg_len;
+
+	struct fuse_req *fuse_req;
 };
 
 struct fuse_ring_queue {
@@ -69,6 +74,14 @@ struct fuse_ring_queue {
 	 * to be send to userspace
 	 */
 	struct list_head ent_intermediate_queue;
+
+	/* entries in userspace */
+	struct list_head ent_in_userspace;
+
+	/* fuse requests waiting for an entry slot */
+	struct list_head fuse_req_queue;
+
+	struct fuse_pqueue fpq;
 };
 
 /**
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 7ecb103af6f0feca99eb8940872c6a5ccf2e5186..a8d578b99a14239c05b4a496a4b3b1396eb768dd 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -7,7 +7,7 @@
 #define _FS_FUSE_DEV_I_H
 
 #include <linux/types.h>
-
+#include <linux/fs.h>
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
@@ -15,6 +15,8 @@
 
 struct fuse_arg;
 struct fuse_args;
+struct fuse_pqueue;
+struct fuse_req;
 
 struct fuse_copy_state {
 	int write;
@@ -44,6 +46,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 33e81b895fee620b9c2fcc8d9312fec53e3dc227..f1ddaba92869518db8854512ec8dd5ed0a0eeaa7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -435,6 +435,10 @@ struct fuse_req {
 
 	/** fuse_mount this request belongs to */
 	struct fuse_mount *fm;
+
+#ifdef CONFIG_FUSE_IO_URING
+	void *ring_entry;
+#endif
 };
 
 struct fuse_iqueue;
@@ -1200,6 +1204,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
  */
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 
+/**
+ * Initialize the fuse processing queue
+ */
+void fuse_pqueue_init(struct fuse_pqueue *fpq);
+
 /**
  * Initialize fuse_conn
  */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 59f8fb7b915f052f892d587a0f9a8dc17cf750ce..a1179c1e212b7a1cfd6e69f20dd5fcbe18c6202b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -894,7 +894,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


