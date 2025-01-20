Return-Path: <io-uring+bounces-6015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E59A164FB
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C30293A0473
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB8B13AA5D;
	Mon, 20 Jan 2025 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="f48jXWw7"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DF3199B8;
	Mon, 20 Jan 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336575; cv=fail; b=dfghi3VuRtpB7nryAjvgjnk2ByZMRjJsQqZvM+q7Nj9mqD2Us2iEfiBzxwh3hwxqwVm9tJ6MPr4RMjp2H4gTn1eqf/nJq+Ki28r/xyYGMFIc0qJ0J4byvSLh7xsjtjX+QcxoD4PKUI3wuq5QfXNsvGI9TsHVZ2Qs8MKTyY58n9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336575; c=relaxed/simple;
	bh=lGgU/6mKYjWx+26uCYFdN2LgH+8yA8kYYPtM6i5hKbY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OUUi2xYPcSzGSLoZjydA/pnk1CvH+7LGf1aN3/BdzsQVJSt5f2HLQDfIUz8SVQsihRkGf0Ral5D1SODON6kG0B/P6uQNRwFheXkdydD6BZYIGf4E/BK3z7pk+ijjlEF/yNOVQHc55KKA+J382Etju2f9ERr1G9m46FYALYia6bE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=f48jXWw7; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49]) by mx-outbound23-227.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwFcIjwaaOCD1DaM44rvDQgRngAVik7PE6j96meLbNOZDJH+wUZ2AgB6yafjsusZ0qUaNHijVlTpbP2wQQuNI3BNajf23JotLmwMP51TEiTcfiOTLrymnL8X9JY7O+OdpkpTiI2ppeyFt3Odu+HK20CwKIXrIazMVIVug95oWRRMitvERNjFuG/zt+VEsRbqv86h1dG6jLh52ybpxR0hJplm08m9Y/Q9Lzg7luJbrk43bp1p8zR4kgc+Hyv43ZZVpI1Gzta3qguotP8HgbLuPol8pELscWFESmzKBHtTOUHe060byFAMWe16CkcRf0KcOw6EI3s1ZUi8qUsVbq5RzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SczpqaghsQ24i9qW4T/+7guNut3vKv0OD/9PTH4CLZc=;
 b=NHn3usgHisEZQPQMQRPIi7LvA0gciVh6OV5Nsn/9hPZoB1W6sRTkXXT5GtL6HZDeIvbPqVEDt3w6XBxWtaZGgjOdepKV8ccDgmzovsP+HPgvZfUTRWMOOo4Tf/6nxQYjewHxObVY78c7CbSLGfqeasZj3Rlsh6vswuZJx81fOqR9R/6AwnY1PK/XMGfe4Y71Q4foVceZBp9/S+Emf9DchUZjtQiIDaAiMkztCO6AK8UkF6U9K8mUpOdwsC8rwyU4KmpywviN/gEnkHhXzgSa/4c/XOW1dFllA/+XhTp7fnf5wjGIccnmo6SZoUENXS/c6s+g6GQnvYD9p/4w1TXpUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SczpqaghsQ24i9qW4T/+7guNut3vKv0OD/9PTH4CLZc=;
 b=f48jXWw7gcNH/1Mv66TWOTI2UapCY2UfHlO/bj0eQ8peLly0sCZPekkaqM8ykybF0IZALp4/cu6bsSkmW5QitaABc85LO6SJUkKLQGhIHLFcW0wSxbBhtRwEgA5b9Ig9NREkRvBKEiDVYy4yVUsxQ8scY41xLV2DL0M/qqr1dW4=
Received: from SJ0PR03CA0197.namprd03.prod.outlook.com (2603:10b6:a03:2ef::22)
 by LV1PR19MB8898.namprd19.prod.outlook.com (2603:10b6:408:2b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 01:29:14 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::f6) by SJ0PR03CA0197.outlook.office365.com
 (2603:10b6:a03:2ef::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:13 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8F1EE4D;
	Mon, 20 Jan 2025 01:29:12 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:04 +0100
Subject: [PATCH v10 11/17] fuse: {io-uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-11-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=11548;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=lGgU/6mKYjWx+26uCYFdN2LgH+8yA8kYYPtM6i5hKbY=;
 b=meItYGegdaNgNJgiYtW4BQ9GhtPZmUHpBUYkEXtwVTdjH5jtAYLAuib8cMS4DoD9rrm8XYkb/
 hdp9cXTG+SUA14s4x2m3xrc2gwUU/xl+ym8/skiSPMz+csSUjLHxtSV
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|LV1PR19MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bd4c404-424f-4b89-0097-08dd38f1d8ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2pCQzFaMFBjUS82bkZvRUloS0tGQUdVZVA1eFZKOFp3bjloRUN3RjlLbnBW?=
 =?utf-8?B?eDU0YnhmSTNtNHRKSHdDRUFSN2VmMG5IMmJLRy8wbkJrRE1UT0tsOUd5b1dQ?=
 =?utf-8?B?aVNScDBrRFBxbW9oc0E2MG9NVnA4aENMVmRoWThKSnBJTmM0Mm80SEwzdjla?=
 =?utf-8?B?TGpETER0NFcyQTlnZG9UckhrckxCdktzMDY5Q0tGRUlEZnpScmx6UjR1ektL?=
 =?utf-8?B?a0x5bGZmQlpTUDVyOHFCTWlQTisyYlQzS3Q2dUJiaHBPY1J4V2ZwSWNvYUJD?=
 =?utf-8?B?TGxTSWFLRUxKZ1p2SGk1T0N2RHdOZ2UxOUZhRXJxZ3Jaa1U4MGN2RFFFbU5N?=
 =?utf-8?B?MW5jdWp5K3FyREVqZnk3RGVqSTBhOTJzb1Y4NVpFQ0ozd3VTbUwvUXNOdFRj?=
 =?utf-8?B?RE0xOUF0ekFkeEtROUYwZ0hkSWxwQXVsS2dlYkgwN1lxc3NFRFZ1dytYUEtn?=
 =?utf-8?B?bllId090TXBHRDBEbDdKZHFEMGFKZFBnZkpSK2hGMEY2MFFhRGNaV3pEdXlp?=
 =?utf-8?B?U3JRVmpGVlROVXhaWkJKdVNZUVpyVFRESEcyMklQWUxFdnBjenZkcHpvQW12?=
 =?utf-8?B?VGFYWHRia1dyWW9kcWppRzVhT1lLdy82VTg2Ukk1SnlDSjdLd1l0RnpTRkFh?=
 =?utf-8?B?VlBGc1N3RTNCR0xPZFdvdGF6VmxPNXFVUWxGSmE0aVdwanFFb2h3d25XQ0ZU?=
 =?utf-8?B?SndHOG1DdWRqOEo5SjhiczBxQ2V5WHlPanRpbDQ0RVhCb25mMnVjYVEzb2FP?=
 =?utf-8?B?Vmg1SWV5MzlNU0FWL0RldFR0QTV5TVVOSlF2c1oxdmNRdWMrTnlkd24rWDZ0?=
 =?utf-8?B?bStBTHJWQ1BKUHlqRFpyZVdJemgwS2g3VDlrTmQ2NW5PWjRXQ05iREp6QW1u?=
 =?utf-8?B?bXZ3UjNxU1BPL2pXUUFNM091VkptSG01L0JnRXgwd0hWSGgzZGdmemVSK1JE?=
 =?utf-8?B?c2dsYjdjeXFwL2pCdFJWSTEzSHpKaXFlaXBTVVVMdmlUdUZhZEZtczJVcTF4?=
 =?utf-8?B?TDVGQU1pd2dMS2lrbWVBSEdMbnhSdGRzOHFnZWd0MC9iZ2tkNlFiMTRESWhJ?=
 =?utf-8?B?aXIyQjZMTzJVY2NDTVdUSGg0N0hhZ0tybHZwMkV5bkZZV09RN0Z5ZWRESXI0?=
 =?utf-8?B?QXo3Z3MrdHlFdWdZVTJtdlBiUUZoeURDaGNlTFNkZEtIM3hDdTNRdGpEbWZZ?=
 =?utf-8?B?TW5sVHBISEpKRWFDWFRDUnNldDRXN3dFcVdIWW1VYTAyeE9zRHlkTG9QWnUr?=
 =?utf-8?B?L2YwMnBralR0Rm14OVFvd2kwSG1QUVVKRzIvaXh1ckFrUDVlVU9kOGVObExO?=
 =?utf-8?B?dDd1Z05GcTg2U1p5ejFmQ2tjZWc1V3pkU09NL3RhcEdDWHB1by8ybjJCUitE?=
 =?utf-8?B?T0ZIQzRndlBuemt0Wm1NVlFkL0FoU0NEZ3ZIbUw5ZTRxUzk1WU42U2VCNjdZ?=
 =?utf-8?B?cE85U2Y2S2hBQ2xJMS9wVThYWmFVWmhrZ3pyUEs4L25CZ21uemRVK2toSkZP?=
 =?utf-8?B?Z25SS01xbzduT1I0dTdRcTNndGY2ZkZNbUhtaEZZd0xCWVAzbGhSR3B3d1dO?=
 =?utf-8?B?dWFORmZTZXZjRXpQVWMwcTlFdGJocG51Mk5pR3NycXlUSEdQM1pmamoyWmEx?=
 =?utf-8?B?dVU1RzZKQURUZ1R2MDlZallxSzlpUnhIaXpCdktRMnJTWlEyU3ViQTJHS3Vt?=
 =?utf-8?B?a3VvQU5rSkhOajM2dytZczBONHNwalJHLy9ZQ2IvYmR0KzhieXVOYjJmYXFQ?=
 =?utf-8?B?aFJrM0YwanMyc2ZUZnduVDVscUdXbk16TmtJL0ZsdGJYVkl5TFZ1aXZVOEJG?=
 =?utf-8?B?czYyRWZXQVBrSDI0Q0loMW1FRHhyVHVpaDZSUmVNcTYrbVM5dmt3SjdWZVJY?=
 =?utf-8?B?UHRPNlo4VlRoN0RjWXZpZFp4TUt1anZDcEZsaS9ldVplUHBGbVBHbU1uWGxL?=
 =?utf-8?B?V2RHOGdkc3doanIvWUdjcVRxYUdiUk16WkRVU1ZhK3ViVG42UlNJaVRzTWNB?=
 =?utf-8?Q?5iYsBoIjGiKlsAp2OBT06CICx+hSOg=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3WoUgZ0cEjpO7qZwKZiZF6d2K16A19vdVW7ZxSj9BvJUa4BLt0uuWOlEsU4uX2fZr5MtvEne5ryvKl3uTdlBRIneW5WPf2JOSZt+nETtprT6NUmQy86d+gAhtz05Rr6glakRcFJaghHLuERrcPNqs3+oiaTJGhnGUDXw1G2SYvhlERrdlnrQNMll4Qp9kMZm9tQHZm8e5lQ/mHLdmyxfXOGmoVERsBYBQLnUWJaoqETTFw+3RfQolaRMKhi3ckzljZZDrgqGra01TtzzuLhzVdYoBnmMK2rBpFtJXB47frHK8bP29T1IEheEXE16YrukTQHOAqqGHz18m4MKmgEjbavIBQ+6ESL11LpqFxM6Inq/jhGI/bmGIjsH2mmni0PlHkLsNJ2WpLwy4YEIe7173p8WvfqLz6YuDUyA0cggkgK7sb/F8eq/I/a3iT53hPmKbMxxWsyyy3dAE93GPslIt/BFUh9nRSmJuIPPBz+xsoNKKpBwHDkQOWDub9zLdN9Y2WQ347hNcx0SWoJcvY/Tnt6LYr17KJPhzmcpVU+kAcVm2N0OB8d6uStrv5SBPYRHy8/jE269lFuusFQo+6Lg80T0RKG2fyCP0EahAYNt1Q5vrBmnt/j4ljJlWnHB1/A8kESzZami/iYELhxVH1X+CQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:13.3028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd4c404-424f-4b89-0097-08dd38f1d8ea
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR19MB8898
X-BESS-ID: 1737336556-106115-13454-11011-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.66.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGhiaGQGYGUNTCKMXYwNLC1D
	Qx0cLUMs0iOdXSJM3CIsXMwCjJyCA1Vak2FgAeVx6wQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan14-7.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_RULE7568M
X-BESS-BRTS-Status:1

On teardown struct file_operations::uring_cmd requests
need to be completed by calling io_uring_cmd_done().
Not completing all ring entries would result in busy io-uring
tasks giving warning messages in intervals and unreleased
struct file.

Additionally the fuse connection and with that the ring can
only get released when all io-uring commands are completed.

Completion is done with ring entries that are
a) in waiting state for new fuse requests - io_uring_cmd_done
is needed

b) already in userspace - io_uring_cmd_done through teardown
is not needed, the request can just get released. If fuse server
is still active and commits such a ring entry, fuse_uring_cmd()
already checks if the connection is active and then complete the
io-uring itself with -ENOTCONN. I.e. special handling is not
needed.

This scheme is basically represented by the ring entry state
FRRS_WAIT and FRRS_USERSPACE.

Entries in state:
- FRRS_INIT: No action needed, do not contribute to
  ring->queue_refs yet
- All other states: Are currently processed by other tasks,
  async teardown is needed and it has to wait for the two
  states above. It could be also solved without an async
  teardown task, but would require additional if conditions
  in hot code paths. Also in my personal opinion the code
  looks cleaner with async teardown.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
---
 fs/fuse/dev.c         |   9 +++
 fs/fuse/dev_uring.c   | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  51 +++++++++++++
 3 files changed, 258 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0..1c21e491e891196c77c7f6135cdc2aece785d399 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -6,6 +6,7 @@
   See the file COPYING.
 */
 
+#include "dev_uring_i.h"
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
 
@@ -2291,6 +2292,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->lock);
 
 		fuse_dev_end_requests(&to_end);
+
+		/*
+		 * fc->lock must not be taken to avoid conflicts with io-uring
+		 * locks
+		 */
+		fuse_uring_abort(fc);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2302,6 +2309,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 74aa5ccaff30998cf58e805f7c1b7ebf70d5cd6d..86433be36ac4d4c5d6ab7c3da8565acdc3d1e4bb 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -36,6 +36,37 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
 	ent->fuse_req = NULL;
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(req_list);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry(req, &queue->fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_splice_init(&queue->fuse_req_queue, &req_list);
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&req_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		queue = READ_ONCE(ring->queues[qid]);
+		if (!queue)
+			continue;
+
+		queue->stopped = true;
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -95,10 +126,13 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 		goto out_err;
 	}
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->nr_queues = nr_queues;
 	ring->fc = fc;
 	ring->max_payload_sz = max_payload_size;
+	atomic_set(&ring->queue_refs, 0);
 
 	spin_unlock(&fc->lock);
 	return ring;
@@ -155,6 +189,166 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	return queue;
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	/* remove entry from fuse_pqueue->processing */
+	list_del_init(&req->list);
+	ent->fuse_req = NULL;
+	clear_bit(FR_SENT, &req->flags);
+	req->out.h.error = -ECONNABORTED;
+	fuse_request_end(req);
+}
+
+/*
+ * Release a request/entry on connection tear down
+ */
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
+{
+	if (ent->cmd) {
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0, IO_URING_F_UNLOCKED);
+		ent->cmd = NULL;
+	}
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	list_del_init(&ent->list);
+	kfree(ent);
+}
+
+static void fuse_uring_stop_list_entries(struct list_head *head,
+					 struct fuse_ring_queue *queue,
+					 enum fuse_ring_req_state exp_state)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent, *next;
+	ssize_t queue_refs = SSIZE_MAX;
+	LIST_HEAD(to_teardown);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry_safe(ent, next, head, list) {
+		if (ent->state != exp_state) {
+			pr_warn("entry teardown qid=%d state=%d expected=%d",
+				queue->qid, ent->state, exp_state);
+			continue;
+		}
+
+		list_move(&ent->list, &to_teardown);
+	}
+	spin_unlock(&queue->lock);
+
+	/* no queue lock to avoid lock order issues */
+	list_for_each_entry_safe(ent, next, &to_teardown, list) {
+		fuse_uring_entry_teardown(ent);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+		WARN_ON_ONCE(queue_refs < 0);
+	}
+}
+
+static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue,
+				     FRRS_AVAILABLE);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_ent *ent;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		spin_lock(&queue->lock);
+		/*
+		 * Log entries from the intermediate queue, the other queues
+		 * should be empty
+		 */
+		list_for_each_entry(ent, &queue->ent_w_req_queue, list) {
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		list_for_each_entry(ent, &queue->ent_commit_queue, list) {
+			pr_info(" ent-commit-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		spin_unlock(&queue->lock);
+	}
+	ring->stop_debug_log = 1;
+}
+
+static void fuse_uring_async_stop_queues(struct work_struct *work)
+{
+	int qid;
+	struct fuse_ring *ring =
+		container_of(work, struct fuse_ring, async_teardown_work.work);
+
+	/* XXX code dup */
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	/*
+	 * Some ring entries might be in the middle of IO operations,
+	 * i.e. in process to get handled by file_operations::uring_cmd
+	 * or on the way to userspace - we could handle that with conditions in
+	 * run time code, but easier/cleaner to have an async tear down handler
+	 * If there are still queue references left
+	 */
+	if (atomic_read(&ring->queue_refs) > 0) {
+		if (time_after(jiffies,
+			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
+			fuse_uring_log_ent_state(ring);
+
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
+/*
+ * Stop the ring queues
+ */
+void fuse_uring_stop_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		ring->teardown_time = jiffies;
+		INIT_DELAYED_WORK(&ring->async_teardown_work,
+				  fuse_uring_async_stop_queues);
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -532,6 +726,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = &queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -663,6 +860,7 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 	ent->headers = iov[0].iov_base;
 	ent->payload = iov[1].iov_base;
 
+	atomic_inc(&ring->queue_refs);
 	return ent;
 }
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 44bf237f0d5abcadbb768ba3940c3fec813b079d..a4316e118cbd80f18f40959f4a368d2a7f052505 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -80,6 +83,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -97,12 +102,51 @@ struct fuse_ring {
 	size_t max_payload_sz;
 
 	struct fuse_ring_queue **queues;
+
+	/*
+	 * Log ring entry states on stop when entries cannot be released
+	 */
+	unsigned int stop_debug_log : 1;
+
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
+	atomic_t queue_refs;
 };
 
 bool fuse_uring_enabled(void);
 void fuse_uring_destruct(struct fuse_conn *fc);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring == NULL)
+		return;
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_uring_abort_end_requests(ring);
+		fuse_uring_stop_queues(ring);
+	}
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring)
+		wait_event(ring->stop_waitq,
+			   atomic_read(&ring->queue_refs) == 0);
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -120,6 +164,13 @@ static inline bool fuse_uring_enabled(void)
 	return false;
 }
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


