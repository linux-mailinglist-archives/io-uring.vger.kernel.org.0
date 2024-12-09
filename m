Return-Path: <io-uring+bounces-5324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FBA9E99B1
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E73AC167706
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE941F2C27;
	Mon,  9 Dec 2024 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="dRVL/6sJ"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBAC12FB1B;
	Mon,  9 Dec 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756225; cv=fail; b=jgsjoXwyzk5IufYBC6boy3ymI1VqkYUfUltNkBKn9ykPEhjXdK6I4x/hJs9xyR8VfUtLROqW+5xlZ9CA2rSHiMVR6DQ5fXy2bIXnXbsPlCFdR7nsqT02YS7bef7ll4y3Vj9nwqcszS8uo7l98Pk1yVVDxoxAdu7BTMX1vJP0COw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756225; c=relaxed/simple;
	bh=eKI0U+AuJtwB+fno4Bz3mNklFoJFvo+ps52gGtzqSAA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k5F03pQIXnUYjMPI1Hm0x0rjJkZFZ+a1bYwhUOb2FeS2hEtQmQgnECRyjcJxHPOER3OBSblsq/D35Fjj3u7+pgNh3rxoIT1mJyMogvCvxKFmi8pv2IIbA+Gy/dDNBNQXSJY+NmUqPTkbLk+aeHKuOLBO1xai9ZW0EyP+MmIP2ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=dRVL/6sJ; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169]) by mx-outbound13-209.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9zNsp79SiPfEw9puPv4FSodM3kpUae4zuWNVdf1cPSk8rKRCkXfd7faDpYQhuSFT23vYnOl28/C3sr8Ymf1jvyw/UJHAcPTXtA4Y/fWYJ5nzhPoArSYHZrTGnBpGx20TQEEBYk7KoFPADnIMU/gfGkQ6XELXN2x6TvZD+A6B6Y/HR1EtqW1qkh8E+IVxl7v5kmIdqm/oidRYJJcsecjaKS+wUovXjz2XCwksPqr87fqnxUygyGBI5tK2DgqFIkK4GNbs0EtLc7O29xTYtChTyWdbBIds2OqJD7kiISJmw+5D2TvFkiL7TjUbe3f5SDLJHpN6tSOqqvHuPFJ2uLsgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnkDbC7ZyYtC3bq9n1BrP7lWmOlzW6ZEWMvLboo70Q8=;
 b=YPfaWeE97AKbXukpKnCDMblORo9g7mVXgot3YjVVgVDe5vEWk52/q5OgEmKDhSQG9T3cE5NUSmp+Ljp7HR70LZjmb2Fld77ctmGOhq7i+sA/q4xMxSbTTVz6Ce2E/bDUb8FD6koV+EFBo9buItpu3GGTVAZ8OvT9pOYeQAuZT7Tye5XHZIN/1s9UZbker0rm59N5lJmQYYURXTDX8aLCt4/2LwuGqruZopPfnIOvaKkXCj3CFP0vzHZ162VADBslr4ZA1Z1ptEJSuGL8MIfvEsmb4xkzM7bvUkwRrjbGauYxIQrladozNsC/rxJyqDfw5O1hjRxStmcWG5lTktNoNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnkDbC7ZyYtC3bq9n1BrP7lWmOlzW6ZEWMvLboo70Q8=;
 b=dRVL/6sJQT0zgl46OadR7rdn9xCR/m9LdfCqeHBM8at4FgRSxNuElL3rDhhphsedvUGaAv9Gki5hdx+6oaT5IXluzx1YYjOHWaLTnpPr8OiqA16PVWvbycF9r818KozFjYZ8y03aYQ+UmBhcVwHr/jfL79PSImL9Gu7jT5YUlSc=
Received: from DS7PR05CA0088.namprd05.prod.outlook.com (2603:10b6:8:56::14) by
 CH3PR19MB7212.namprd19.prod.outlook.com (2603:10b6:610:144::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 14:56:52 +0000
Received: from DS3PEPF000099DB.namprd04.prod.outlook.com
 (2603:10b6:8:56:cafe::90) by DS7PR05CA0088.outlook.office365.com
 (2603:10b6:8:56::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.11 via Frontend Transport; Mon,
 9 Dec 2024 14:56:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099DB.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:52 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 82B9C4A;
	Mon,  9 Dec 2024 14:56:50 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:33 +0100
Subject: [PATCH v8 11/16] fuse: {io-uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-11-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=11744;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=eKI0U+AuJtwB+fno4Bz3mNklFoJFvo+ps52gGtzqSAA=;
 b=3bbSnMHDf9AHCJZ3iIHiJvKFK/wBN5wwfLr8tB9FiZ9QasG9oChOkbV4YceggfTBaIlDRhC1Z
 cGoS+eKj16VAMNCL9YdcNImfvswEK/XKHkhQ7vYO5HQ8RgKQWEhnGtI
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DB:EE_|CH3PR19MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a3ff317-432c-4b60-2f32-08dd1861b74f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SStDaWZmdHJtYVpVMTN6UHdHdmQ5NFJuUnNyS1c5dWRDb21vMzdlVk5XZDB5?=
 =?utf-8?B?bmg2U09zMEVRNlZaRlVhLzhoQkUranFEbmpvbVZsY1ZxdUlxWkR5TjBWNzlV?=
 =?utf-8?B?aHVGbEZRSjAyaTJJY3o2NjV6QXJaTXBrdGx6TjhQMzhzWFZpbko4MDFibUxZ?=
 =?utf-8?B?N2FPTE13RCt1WkdnK21RRllwbE1KcEtLOHhocWxRUWZrOE9wbE1GK0pxWlhY?=
 =?utf-8?B?NmFmVXkvczB2U1VPTVJuM1R5emNFTy9RbHlDY1hPazU0MHU1dER6eXZiejRa?=
 =?utf-8?B?cWxsVnZxQVZ5eENvdlIxZDVYT1hpT2E3aEdKR2pkNFBLeUZYNUJxdmk3TDR5?=
 =?utf-8?B?Mk4zWmJDb1RpWEV3N2V3K0dQcE55OXQyVUkvSFFlM0ZzTmp0SkFaMHl5cHFX?=
 =?utf-8?B?dWx5TXhkS2x4cEhNRU9IVE4xdGFndWVzWjhJV0EwOFZyNWhuRkNyakRDL0pZ?=
 =?utf-8?B?Z0xpekozaFc2by9sQkorNE9RS1RNY3pJOXBxTTdyQkFGVHRtdlZlMEZyQi92?=
 =?utf-8?B?bko2czZnSTVyQTFtL2NkN1RValhYazNEa2VaQkhKb2dsYWlZaUdYdmI5Q2s3?=
 =?utf-8?B?UlYzbkk4RVcyQmR5MXFjaXY0OS90NnpEelZVeThCellkTlBiU0Vaa3VCOFpB?=
 =?utf-8?B?NFliOWVxaytGdldUZWxnN2d6SkFLaXM5UGgzSklISEVtN3B0Tkt5RjhIQ1BG?=
 =?utf-8?B?OGRDWEJxYk9oSUtxUFAvRUNqMjZyQXVNb1JFbXVlcjNJMGx1MFcwN2xjWVln?=
 =?utf-8?B?aGwyVjE4QmUrWnY4MFZOR3BlSWJwZDZUbmFHZmNvSk9WS3BTdFlEZnNCckp4?=
 =?utf-8?B?dGxCME1XRlhvTnUzeU96SEZEYjBGNGJIODVtejU4c1hKNXlBOGdzbXAyWDZP?=
 =?utf-8?B?Q0JjTmdpVjVCbzlzTDdsR09GMEVMMmlHREttVERSVGYyTC9xSENCTVRNT3k2?=
 =?utf-8?B?eTQyVjBtcWpxTTFxa0Q1RTUrcDJFakdyT3l0bzlPSWlTUTJGRk9GeEN6Zk0r?=
 =?utf-8?B?MXFKWDF0RmxXOGsweGg0V1dabGljZzA2Y0g0aWFJaXBXZzFHZU9wQWRLVjFF?=
 =?utf-8?B?ZTlydjNyWm4yanVJckdNK21lTjJmU2JETFo3OWVnQzA0UldyYWxFalZwZzRF?=
 =?utf-8?B?SmRDQVVDT1Ywcno3cW1oQTdwOFArUFc1NHpVcFluNkdsV3dXUmdqUE9ndHJ4?=
 =?utf-8?B?UFI2Yk11bUQ1UzNmRjN4NDNZSm45UDVhWlNOOHBaaGduUGt3UG5ldE1lbmcr?=
 =?utf-8?B?eGdCa1dTT0JHRFJrSDBzUWpMNG1laGoyQk5ibXF0Z1ZJQ2FOcFpxa29kWVMy?=
 =?utf-8?B?VnlJeGhZMU5oMjR6Y1dCVTFxUHUvYVFaM25lMTBrR1FEd0hEUWo5T2kzdE5h?=
 =?utf-8?B?UTJhRHVLM0VleGJ1b2w2ZTFkOTVmY0dTWHhqM1pUd1E4REdKZ1dISjlzaUwr?=
 =?utf-8?B?Q3NsQXJla0cwTVVNcCtBWTEza05NZ1dOWDYwVmg3NWFlWnJCaVlCNWpYbnF4?=
 =?utf-8?B?bHZ1NlpWTDZhTm5rSC9HYWJVQXlCSHpZS3lnRkJ2QzZXVzZXbW9XbnBHdlQ4?=
 =?utf-8?B?NFBMeWtuZzVFSTlsclJhV0dkNUNmRjQwS3BvNHdwVmpxc3V5R0VjblNzN2k1?=
 =?utf-8?B?K2N5SVNGL1plbFFvYW4yV0lKWHBYUFNRWncvZ3VJRndDTzFOR2I0aEZEQklY?=
 =?utf-8?B?bERpNDZEVVErcW55TGZsdGVvREJ2djR1bkxYd2xKTGY0QXl5bG5DendoVmQr?=
 =?utf-8?B?aWovb2d5UHR1TThHcFlrRjdXZkprNUR3OE1EZTIvOFllY01VdythcG9tRkdW?=
 =?utf-8?B?aGEyWFBjYXhlbk5tZFJkSXNjQ3hOck1PN2kvcEJIcFNPOWxJMkdSOTBKVlM4?=
 =?utf-8?B?WXp0QTZhVmkrZjdnWUlrUEt4elZYbEN1bHdCRHlUTG9wQ0ZnVUY1TEMwQlN6?=
 =?utf-8?Q?B4XAgubvPONREjQ0r/qMDLp5ZyxkQZ3K?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iDU2O+Pce2W852nWPdhx/E25hf/BcIKUtMwc4u/wo7PgKW/vRKfuxmm25kO6IR+7lZNIh4N89CN076lTI2cw7nT/7TfgcAwJG9VIPQsPS6FBStO4Nr75YKtiP2MX38lAETeQMZkEFaQPgbaWuyya7dMWP23lxte7ISpLBUxZSQJ5IkoT8CFX8goLfeBS+bWCWKtR44703+Q3NB9VVtaavtOlTZN5SKHppoITaD5hoplv0D8kbfwCHYmTw1lpUF49S+7wCveBg/6s5ib/C5xXgDNyuS2pVoxdaPH9iT7z5s9qXvJtSFjmrX1F/1PeSc/7wghJD727Gdx2gdrYgc3mveTKMdD8Ez1momZNgV23E2/o1/FFqsPOLLPDRNllGhT8AnG6lKBhmsYGRp1QJDLKwQt/QsZ5EWVllpFd0ccJhZG32Ox2MxE6cLmVCANKqO1r1Eoirh2cgE7EuOPCssK8LQY5F+rcXD76p1h0Ie6gH2xR8qIuJEhXNYl3QGO125GWVbKCSTF64meCDEULjeIe7qpJFssv46ysm9oi3MflwAfcB1lmMhUffVtgwI5SiJ14tAr4DP1RFemLXKuWOInR/uFiRTJJl9Wgg+GBrZxhw8F961+IlPG4DH0omHLYXcf/hDs6xVynhSPoS76hzkp4RQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:52.2011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3ff317-432c-4b60-2f32-08dd1861b74f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR19MB7212
X-BESS-ID: 1733756216-103537-13392-6407-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.58.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGxsYGQGYGUDTVKMnYwjzZMN
	E8LcXEwsjYxCzZ2DTF0sDI0tDIzMjUVKk2FgClph0QQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan12-245.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
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
---
 fs/fuse/dev.c         |   9 +++
 fs/fuse/dev_uring.c   | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  51 +++++++++++++
 3 files changed, 266 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index a45d92431769d4aadaf5c5792086abc5dda3c048..8da0e6437250b8136643e47bf960dd809ce06f78 100644
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
index b43e48dea4eba2d361119735c549f6a6cd461372..60bcddec773d1cf3bbefc674fdbdfb7823b7fbc1 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -54,6 +54,37 @@ static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 	return 0;
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
@@ -114,10 +145,13 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
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
@@ -171,6 +205,174 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
+					 bool need_cmd_done)
+{
+	/*
+	 * fuse_request_end() might take other locks like fi->lock and
+	 * can lead to lock ordering issues
+	 */
+	lockdep_assert_not_held(&ent->queue->lock);
+
+	if (need_cmd_done)
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
+				  IO_URING_F_UNLOCKED);
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
+		bool need_cmd_done = ent->state != FRRS_USERSPACE;
+
+		fuse_uring_entry_teardown(ent, need_cmd_done);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+
+		WARN_ON_ONCE(queue_refs < 0);
+	}
+}
+
+static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue, FRRS_WAIT);
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
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
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
+	 * Some ring entries are might be in the middle of IO operations,
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
@@ -532,6 +734,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = &queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -696,6 +901,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 	if (WARN_ON_ONCE(err))
 		goto err;
 
+	atomic_inc(&ring->queue_refs);
 	_fuse_uring_register(ring_ent, cmd, issue_flags);
 
 	return 0;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 6149d43dc9438a0dec400a9cebb8c8b7755d66b0..392894d7b6fb15472d72945150517a9f0a029253 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -85,6 +88,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -102,12 +107,51 @@ struct fuse_ring {
 	size_t max_payload_sz;
 
 	struct fuse_ring_queue **queues;
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
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
@@ -125,6 +169,13 @@ static inline bool fuse_uring_enabled(void)
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


