Return-Path: <io-uring+bounces-5701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCA0A03442
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4554D163BA2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD67482CD;
	Tue,  7 Jan 2025 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="iKpWla4x"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEBD4501A
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736211611; cv=fail; b=dhx+NNtm5J2JbYYdX4NgJ3q0xKfDqglR2vK0Sp2yPQHZ5ofwx85Mf2CQbq9MfFZN8VAsqtGFGN6qfHV1HOJ5yth8Vo+vMzEO3HJOte9ERcjGUzIYrQaKcUX3ZQXBKhPkrkgK6LNcHIqBWlhNy7iSp0fByQmJXW7XEifSSe5YGq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736211611; c=relaxed/simple;
	bh=dQutDZUt3SL0iDOtLH4tYA2LbMaI3JbibTNcglIVU9g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sl6XMwkhUDi2Agl/Y9IKI9tAVamART804GuiPCFklzeBrxlDPCZ4OpwV449RvaJs+DZz2qD4kbJq9fZtQnTn1YytxVLbKXe1oiUonn4/+xWtqyF0i+LJVtWembhcaGVYKHU5WQQ3ZwI4zM5g06NEYmmgQF9XRxCYGok/rt+aTPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=iKpWla4x; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42]) by mx-outbound13-219.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:00:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=astEywwfQAKdODoc5+vJf9HSlQVRNsg8Qlg/g/KtjBnU0R1CvlfmgaIMDT0kzlYX9JQmJ/06QadvBEBNJkL/itKewpgtHh5Ro06nrooZbKUW15z1y7GmxEg3mkJaRjcfy9VoV8h6kQRs1oIplkVdX18C8MXsqUe9+wDK8weOuydsVRrIorbfqdzi6dlSGiwla6541aOQfVSf+2ff4sCG2TvNKa8Zg8glLcsujaXv45MnMPL8oOGPJOvXGYCFetjLQ64tJARB8/faW+rD48snFNZCtlAd1PjZnUMoF9L5iQQYgkFCEwTWalfma2h+kyRTnF2P4H31IJt+S8KAc9xxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HY1B3FX5iLFwEpv5V1hMiSYUnwO73xOTjLBvps+TfJ0=;
 b=fRLXfk1kj9Ivou2HDZHKkcOvyEF4YgmEYu6SO4/i6J1C5rHjHHzPYTWnedMIGI5oZON7xe7ao3njCYbdc2K5Q5kVj3kmYS02jIBgCoL/o4jDyfGm/z6eClRBIV27pi5T2bMzSzktaUwsBVz1/kafaGuFo21ZwpLsmxW4cZaZm3Cve3irCstZcrFIZ6dI/81VZZ9qB+2BAXyPDO9pjT7JubEpUwjUloMBC/F/l233q2lCqGqDkKQYpuObY2On2mQ81nUCPR2kL7SStk8AfwzudJbIjJnKDQbEJJr6XSKMOn4r7uJsob17cfmGGlrfdix6RpLk9AerZacp63NUV88awQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY1B3FX5iLFwEpv5V1hMiSYUnwO73xOTjLBvps+TfJ0=;
 b=iKpWla4xY2Jq2dyWn5v2ALnBgrbLHSpwOHz7/xlUEDrIiSj2RUrgUoCYdajDSbNMiu6HosyW4kUqRy0oe/Dm8KLqKrQQGuir0pwlMHYp/ri5Ty8PevgxSLwLGsN7Me01zHpFwel/4YXtk2XyD1RuNBiify8ZyLZ4CdNOmS8/T+w=
Received: from DM6PR04CA0014.namprd04.prod.outlook.com (2603:10b6:5:334::19)
 by SJ1PR19MB6258.namprd19.prod.outlook.com (2603:10b6:a03:45b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:29 +0000
Received: from DS3PEPF000099E0.namprd04.prod.outlook.com
 (2603:10b6:5:334:cafe::a3) by DM6PR04CA0014.outlook.office365.com
 (2603:10b6:5:334::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 00:25:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099E0.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:28 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D6D684D;
	Tue,  7 Jan 2025 00:25:27 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:22 +0100
Subject: [PATCH v9 17/17] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-17-9c786f9a7a9d@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=1366;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=dQutDZUt3SL0iDOtLH4tYA2LbMaI3JbibTNcglIVU9g=;
 b=JlOC1bXJK06sKNpeeVQdEGNtPprCaGViGxnk0rmSt17Jaow8TFKeIZ4Ru4uZ/LFIswTKPnrTL
 yQCSn1hgvniDoR2NNwmdO3WoYJCyySTaoIUros9rGzQfxcB8mRjI9qL
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E0:EE_|SJ1PR19MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: c93d05ff-5178-4aa7-80f3-08dd2eb1c9c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?eVY3Q2JhSTBzbWZXZ1FCUDNaQ0VIOEhUZFp2TXI2SURheFQwQ21Mb1lwNkVL?=
 =?utf-8?B?anRSdk0xTWh2cXR6Zk1La2xoMkQzSnpqTDYxUjVlZGx3NHVrSzIrRkRMdita?=
 =?utf-8?B?eFRwUGd4SitRVnFjUk5rVjYwZ0R5QXRLYmxicVpWeDRNMjVqYXM4TG5wQi80?=
 =?utf-8?B?VURGMnRtSklkcnUzdTZsRkFnZ2QrWVRvOFNQZVBSdStScERGaDdiV0RQR3J0?=
 =?utf-8?B?eEhlbXhHcG1La1JuSnJBZ2NWTnplbW1CditUUnI2aC93TVowTmdZZGpsSUtB?=
 =?utf-8?B?VGUyT1REb2VUSjY5czllVFFpdjZXMmwwMHNiQVlHUjFJZVhUOWZDOW00YVNZ?=
 =?utf-8?B?Wk1SMHFJYmoxNlQ4WWd3U1lHZTN2YjJzZUo4b1d2czl2SXRRcURaT29DenQ5?=
 =?utf-8?B?TlpVeGtvZmtDbWRKSDlhNXJGWlJTNWtBRmpRY0tyRlZDUnFVczUvRE9Gdm5h?=
 =?utf-8?B?M0YwaU1veC9VNGk0ZExwQVUyaTl2dWpoaWdMbitRcVFuQzd1Q0l0QjEwR29S?=
 =?utf-8?B?TzA0dzRIVmhpUmhDeURXQkw1aTRuYTNHSTcxTldRcnNiV3NZN1VuU1RwaDZ4?=
 =?utf-8?B?a29JMldSaHV4Y29pOWdEWG94TTRXYlczVzBxaFg2a2k2Ry8vY1FWRGJsRTNp?=
 =?utf-8?B?cFVvWURXRVhMSEpCdmNGblc2dDBCZUJ4cnlsMXJ1Zkx5SG9idWFzTDladnBl?=
 =?utf-8?B?dURhekZteWNjSGpGRExTVjBqaFh6VlovcSt3NHVtVTNvY3V6NldmRDhWK1FD?=
 =?utf-8?B?VHVXQitQYmc0eHFwT1JyUFFXRjF5ekhnRmFkWnFhYVZndmhJWnpKSEJrZStz?=
 =?utf-8?B?K2dkVDFtY2hjT1ZnN3kyZnZGT2tqQ1Vubm9ZdzAzaXlyd1czam80RkJGZEFI?=
 =?utf-8?B?ZEhTZW94Ynp5RkpxMTkxK3FINFk1RTVtWU4xNGJvNmhsY3lkTlJvVWVnRlRX?=
 =?utf-8?B?M1NiOHMydm1Fb3pyQTVubzFDMWtEZkFkMW9qZHpxVEszdHRFYi9IZWgvdi9k?=
 =?utf-8?B?VEcyT3VHa1ppVXdCd1Z4NFRQWHRoNjNBb3RlWmNaaVZCTXpmZjV2Vjc1dmFZ?=
 =?utf-8?B?Y3hBZW9YMlIvVDl5R2VwaDJwdmpqL001bXpsYjMxSTh4RGFhczdHOGpYM2R6?=
 =?utf-8?B?ZUI1R1NuYU1EZG1jbUxmd2NXLzBkQjRKZXZMWmE2bFRndUgvN2x6UWo2b0lE?=
 =?utf-8?B?K1d1QTExMitsR1BPeWJkQnN1UWtLRmEvY2JRNmREeEhlaFp2cEVWb08wQWxm?=
 =?utf-8?B?VUJzWHUrYjJwVnVmY0FKdTRramZ4b2cxZ0xyWm01VXBYWjM4eEphOEl0cU04?=
 =?utf-8?B?WU5CRmJqSyt1N29tWHJsdGt0SzkzazkvemZaYm5BeHc1Z0JRRnRFVVpQbkYr?=
 =?utf-8?B?dFE2Ty94ejFoNUsyMXRSN3F6L2NvYUNoaTZ3OHBtWGhvR1VaaUdVbTRlYWY1?=
 =?utf-8?B?L3V2czh3emdxSndNdUpZUHV0ZjdJN2JuNHRUdFhtclJ1djA3aXN0MkVuMU9t?=
 =?utf-8?B?bllhVEdUQk53VWxoQVNvWWsrZHdZcXZ1Q1gvdWh0Q2J1aDEzc3RBTEdnQXdi?=
 =?utf-8?B?QUgxUEM2TUxmekt0MEpHY1VHaGovQXNTOG1RZzR4dUlwcG1yWmttejBNOXpw?=
 =?utf-8?B?dEh6R2RHMXRNMzUrOEdkUU82T2tPUHY5MXhMSzhpWEoxVjBhVEM4U1dPRkd5?=
 =?utf-8?B?RXRQaWZkTTROMGRGL3pIQ0JjTkRWaEQxT1ZrR2NlUEFIdDhvVDlWTFhnN0kr?=
 =?utf-8?B?WGI1S2l0WHQ0cWlKYVhRVDF2aXhGaFBEUWw2L0xIZWUwdkc0YVE4eUVzVmN3?=
 =?utf-8?B?SkZ4ZUozZmRMbEJ2NFVETHlBS1dIVVNqamlyWmJSWlJPL0xzZUsrSXd5bTRD?=
 =?utf-8?B?YmV3R1ZsOENUWHZLam44ZHRKaUdUZmRReVh3V2p2U2ZhWGhsZWVTQ3NCYmxo?=
 =?utf-8?B?WW5KOWhLQURMaUdVNEIxYmxzOUZqV3dQbmh4OUcrNnY4UHJEV0ZpNTlPczM3?=
 =?utf-8?Q?5mBtQwqLz9s5w+uBlBzzlMkyoS+6DA=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 e/x0JizAjYSxz+0sR2duiCSVo1NTTA1B9O5KgFl8jz21/LEoqnPml2Kl4lPmuY0dqgF7CYaILHNA8VvDFx+6nxTTPD/xQzx7wM99JHXn2nz/gkdiD05Arlnci/niuSM+ZwVpNj64Z6nLfgw6FGv3YSd/fptsSDwQc8JbS4l3oDrl1SkY60ELx9R/zihtv1945NvimrdmMDirP3eprJR62nf2mYiZtS17/4rL6W7TrUStPknq+k3b/0eZr6yTvaU/HCYFm8oTCAPAY+CZTOfvjwJ0aCuM7w4QE8v/h0Jmaimh2lv3cPWjQ/rO1U2LddzSVeipUvMMyldxY4pnTz1pgCPafaRqjNkVOw5tD+BPVamoy23/sHuqdgqIyuIggN4SvS7nOTI22+j/8xxr1gs02RCcbxqJmTylmyjGE7MRbrpkiJ3tzIMpX0eCFeSIOWBQ+mkFuoYVvAnWQwQw9/liYv3PLgNxBG2P0smqBklmxVefgxbsfY2RpprQW5kYw16l6WDEVyjP6AWypX5X7Ub1P2eKct3VlgltnlgyqICEUJgkiuF99A4cuvdHkIfH1pw/HPKGlNucScdy8l7b7hbSPsQO50osutnPR9ZkFpfC/p0NhPE79vQTHZpusFWc3VzLo0ogsXcX9VC5wkcuEA95QA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:28.4859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c93d05ff-5178-4aa7-80f3-08dd2eb1c9c6
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 DS3PEPF000099E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR19MB6258
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736211604-103547-13338-48655-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.70.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGRuZAVgZQMMUo1dAixdLUzN
	TY3DwtMSXZIsU0KcXUIMnMIiXV2MJUqTYWANwvbpJBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261636 [from 
	cloudscan11-89.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
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
index 45815dee2d969650efe0df199cc3bd1f3e2e08f7..946b8468959c14de9e0698d63b52c99fe6ad352b 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1090,8 +1090,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
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


