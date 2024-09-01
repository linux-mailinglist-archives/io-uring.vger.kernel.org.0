Return-Path: <io-uring+bounces-2995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FE39676AA
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 124531F213CA
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0122718132A;
	Sun,  1 Sep 2024 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="yyqigBaV"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD96913D606;
	Sun,  1 Sep 2024 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197840; cv=fail; b=DLAks0yZQtmClZARJ20onttYEXECcT8YyLBz8cnLElvhn6zPt8ArrYMo47tWxK25MbSgq8gG96Q83Fc0oDWABSsqjBIXqvgd4xPSNnzm0WKrQhITKJscqXn6MHY5F+CrcJ1jL63Wgbvco4CY1APl/fRvLnXVqDSQpQeo+K7R45Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197840; c=relaxed/simple;
	bh=95qTbUW97WWpiVcnaY/Q8JPMTXK+qrrYxhYEPAZAO2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PDHqkTVkbi7LojpG2T9Hhif5PAFziuKpPV3EPNtIu/rFtG9U3BcQm0N0338BidANmLyu9pywEkw1uGKbelB86vnUSsLRhHMFP6TQoMzrZ9A7svCy/f++5yWuxq9oOvX6EtHCRkGJzD+ow1oeJwdMvdDLtHPXxEzsE2LICkZYZTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=yyqigBaV; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxIYnDBusKz9jigMxmLDs+AOxRngHtOhQU/ja53/9JiEOK1ArW9tC4tIxAxAJA4XeYmaEshQVz2HrgehOCeqEgrjM9UQTujwir4+rVn2VDiiOiCsdaLRdetExBCM3GB/wn5CWbtjRRBDsREVk+wTpHFsTBU2hAvG/FE0JlabJI0ydUInWew6WSgzo8lBvqgV64335EJmoLT4gF+3Yo+R7/XGnE7Yo0cJ6r01aWT4bpikUopp9hq1FfmpZJU9kZCNmf0+EaOA+dOT1vHEVIFguD69fftRVzc2Mu7FgwmQZuSnZz/LFfAJCluUN5VVHK5Jn71fsIgH8Oo9tZg8HXz8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsH4lX8Q+W42yKJAe4yrQfi0tMPwtu+oohQy45fNVj0=;
 b=ZscJJtv5AO2FE7rUTwOijmTmtm7gURkGivjH3ifI4hJPjqAj7v91Hlx1pbRqoP4H+IumhXlXzo2eaVrlIzXDRmyl/64sNCabzzb8DI/4zyfINfAKeAgDfsJh4I8OB7pPeavVWmdYco3xjYVtHSg+YIhYsJvsDiDQitNeIIDqiy/bIkq6zsoRgwpITKhgsP2E2iceSRpEqGy+1SK25c9/AkOOuXyaeefVKjwV5XDyyYLIDrSITtAztAvuK35nzxzqK2oGLPFggMBMyG3ZfgXSGS/dqzT6Iqpns9sRjea7lXUEgf00yFhTSNRP9GpIrXmVhqX01U1OgMA5QqK4uE7WRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsH4lX8Q+W42yKJAe4yrQfi0tMPwtu+oohQy45fNVj0=;
 b=yyqigBaVtjnydXCYXSL0Zu2D+Q2/FurH8RgwqX4dX9WXWHWgacPSxyB2ZJ5rOWQ23L4cHmZRFZGK1I0A1WAMJhiCxJav3oP/0Fzg6WTGsv3lRM/iXziDaoh+NBiuFNcQq+J2D3g5/K1J9GkFKjifdoKEP6I0tFhPG007a0wTIDU=
Received: from BN1PR14CA0021.namprd14.prod.outlook.com (2603:10b6:408:e3::26)
 by SN7PR19MB7355.namprd19.prod.outlook.com (2603:10b6:806:34d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:10 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::95) by BN1PR14CA0021.outlook.office365.com
 (2603:10b6:408:e3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:10 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 5285ED0;
	Sun,  1 Sep 2024 13:37:09 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:06 +0200
Subject: [PATCH RFC v3 12/17] fuse: {uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-12-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=12273;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=95qTbUW97WWpiVcnaY/Q8JPMTXK+qrrYxhYEPAZAO2U=;
 b=p4ys6hnZIiEaJw7zE1De8tWhnCsFDucYErm1uN4RiS+ceqNxbK+BLsAattwPpp49YjYjC1zmp
 Dn+dtWEZpHbBdk6hZfBYa0rnT27s0xq0QZBg0GvBtSCOa3MrSe6tYDn
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|SN7PR19MB7355:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5aeda8-84fa-4e8a-554b-08dcca8b2e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXZ1UzIwaU9ScHNscXQrZDFnd2JuSW03MEdVZE5wRU9vekNqQ2s5QUU5WWlq?=
 =?utf-8?B?MkNpby92NDQ2TXNZMnVKVVYzMkcrOWJuWjRweWpWemp3ZUVoVWVQSHNvdXRL?=
 =?utf-8?B?LzVxSXNsdWQ5dFl4VU9yeFVSU2FzOWFZYnJKcGxOWWN0cnZYV0IvQVd4dFEy?=
 =?utf-8?B?QU41cEhKKy9GS3NHaysyN2ZyNU5GdnJkUHpCNXBqdDZYSG5wRi9hR2x4Qmh6?=
 =?utf-8?B?WUlmbUlIbzRFcFUwUGNUQ3ZTNE0rNkdMMGFoZnNGUXNLU2ZDOXU0dmVXNHUy?=
 =?utf-8?B?Nmw2L2s0TXJoU2VTWFpsK0NmYnMzVXJNUDZpRC95a0lOSnVCMjVXckJrT0lu?=
 =?utf-8?B?c3dFK3FyWXYwaXpQUjUxV0kyaVJWQ3grd21lM3ZIREJQalBGTFJ5RkhZdGdC?=
 =?utf-8?B?dnFmcURQMkxRSU5sa3ZrckREYnRoMit5d0IrS3pWamx2bHpuUzRQZmk1cFpj?=
 =?utf-8?B?UGxPVTNOb3dWanhJeXRoY2lWTXBhVUltZFBwLzNoVEgxVnhQdFlhSHFNcUFQ?=
 =?utf-8?B?c2ZxbEt1YVVOYThYNVByTFdCWWRiL0hhMkJhRTBPUWYzajhESzRYTmp4VW91?=
 =?utf-8?B?RlpxLzJVYjdpbHNPSTVsYnh4YjNuUjZBRUVWMjMxUFY5TG9CRkdQUWg5WVpn?=
 =?utf-8?B?LzlJN21KS3Fqa21zeE82WnpKWEp3bzZ2Q0lHaXRjNnJxa2lSaGJTeHN1Ry9D?=
 =?utf-8?B?b05UcmdjMi9mSHlWZjQ1MUd1M3IvdEt5dHhJZjY1NUlSWUFyU1hROWlKSmtP?=
 =?utf-8?B?TVByYzlJRU9XRnZRMy9Hb0RRUWtMaEZUT0FlandOWmFLbTZib1BPdVlaMUxX?=
 =?utf-8?B?dWFjNDhWNzRVNTc3V2hyQmJkWlZUUU1meU5maXp2WnIreXF1U0lPbFRiSUJh?=
 =?utf-8?B?bHZxMEo2alRRMDB5MzNXN2IvL1dzQmNWYzc5ZkVQWjMxdzdOL29wRy96YW5p?=
 =?utf-8?B?UUFMYzJNVFVUY1ZGSUg3T0p0K0dkYTVUWE1xYnRMSW1DVG80MEwxcG5PWnBR?=
 =?utf-8?B?N1R3V0E4dm9WcklhVm1rZUNFYzFRSlBlS0pLNzN4UnpkZzJjNGhTNnVKSVRC?=
 =?utf-8?B?K3NGajEzU3Jkc0ZUMTF5WjFtdTlEaWdLTGN1WS9zT2FZZGtZcHVHWUMwL1JQ?=
 =?utf-8?B?UnlTc2xEelRhMzdBbUsvMEpJR29GdnF1R0RPTlliZThBV2hvc3lXYnczTkov?=
 =?utf-8?B?SFhDK3pWNzRrMFhMamVHSHhlNFVYSC9uQlMvODdFTUpQdnhIcW10QnpPd3hE?=
 =?utf-8?B?eDdlK2FRREpEbVNQMnhBdG84Sy9UWnZaMmNEVlozb0NQekRjT1IvMEEyblE2?=
 =?utf-8?B?dTR2OFN2WmhYM2dlWjJqeGY4eTZ6TVZ2R0J2aVpFZVlNcFJlTVQ4TkllUmd6?=
 =?utf-8?B?NERtN3d6RHgvL0YzUXdYVkQxcHBMbjhOSERrU1RBeTFBWG9DUnc3SDRnam5M?=
 =?utf-8?B?aTMyMEkvYXUzUmhtbmwweFo3ODBrVUo1UTdFcWZhTzZsdThaNGRka01rbVo1?=
 =?utf-8?B?c3Vlbnk4L2V6YXhRbE5jTmdPOFdweWdNeFRNaFFGYzhpaWgyT01VeURiQk0v?=
 =?utf-8?B?N1Z2OHZUMS94alZ3R0VzZkJSTjBvcStidTdwWDVnOGZqWWpFa0FkMDJtVkJ5?=
 =?utf-8?B?a0FOeW5NektDeUtPeWo3NFh2OUpiSXVyVGhVRytpV2k1Wm1sYnJXWE5hRTd1?=
 =?utf-8?B?dkJMNW0xVkd4eVhLVzBSbVYyTzhrMWhIeUlmeWJtNlBpdU0vWHlqVDg1elBt?=
 =?utf-8?B?MzlwbThiRzAvNktCOWJRS1AreFptditYYXU3cFV6R29jQ0E0dVpYSEJQdkEz?=
 =?utf-8?B?engzeDI3MnVRREh6ZnppK3RkOHM5NGt6UGtralFyMElwVHlVL1JFUjRmTUZ3?=
 =?utf-8?B?UWVEcXdvajd6YkwrQ2xwRExwMkdKeGhIMks4cVl4SVBDTFZHbGJqRUpMVXNm?=
 =?utf-8?Q?2zXn0j7HCedAuP4S4F3KuX8sCdZA5HsY?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kBOqrXnqbsP4ct3Y8wAUfr7qCSOJDwYDtKXObwGPHEbw1Tq9eS+NdXcoC2woL5NQ/rAX2skCOjPPK4+ws5YiGCaDRJSaR6UTCDOJuXPkUB6BR5d83gqkOP/B0otKKqTJ8nhox7SjjWUmLgaW/5GmhML3mKFcGJzsK3vdWNPftjU5imhrpUGoUiXBxf8Z+g0wopYOehROAgETfNgw5z35xyFslz02Oze42eZrT/t8h83puI0/xHJn/yj4ogJJ+V1qO/cUBrwZOYY2I7wiVeMKsnFMJ1fvIHAqMOthnbr/cwcrBVkb5uKFyX1nVUZZ8G/IkHlib+rR/HOvwKkh2vfsvUWtg63xQNQXWh0rxoZu8YUgp9l251ja1khBFFS/B0SSUtaFgteFuybD1EaNM2PUUuuLxgNtSJz59kQw2VZVH2KHQlfUxdf4l/2FwSmylmFuiLTDFyyHjDy9z7Yt5iqrApZMLHjF9txEqTD1Iob4QEGDszXTCSJZwM9ALJ16XxY+fwt8+O2ML7YtibtPHODfzuarSrjhllAvyNxAwEPTUJ5nIO+X+MOiq/I4iZnTCS+dnRchEe3XmF4F10qBaHrs0lzNRCIU4bvxCxxRevrao03KbBsx8kP0MWs2EWD4yWrDDalbPM7Uhu7Wjx8XgzmiFw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:10.2021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5aeda8-84fa-4e8a-554b-08dcca8b2e28
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7355
X-BESS-ID: 1725197832-105647-21816-50042-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.58.100
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGFiYmQGYGUDQ50dg4xTTRxD
	wpzSTRONnIwNQiySItydgoJS0lJSnJSKk2FgD9VheCQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan9-142.us-east-2a.ess.aws.cudaops.com]
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
 fs/fuse/dev.c         |  10 +++
 fs/fuse/dev_uring.c   | 196 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  81 +++++++++++++++++++++
 3 files changed, 287 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 71443a93f1d4..3485752e25aa 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2190,6 +2190,8 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		fc->connected = 0;
 		spin_unlock(&fc->bg_lock);
 
+		fuse_uring_set_stopped(fc);
+
 		fuse_set_initialized(fc);
 		list_for_each_entry(fud, &fc->devices, entry) {
 			struct fuse_pqueue *fpq = &fud->pq;
@@ -2233,6 +2235,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
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
@@ -2244,6 +2252,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 96347751668e..52e2323cc258 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -67,6 +67,41 @@ fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
 	io_uring_cmd_done(cmd, 0, 0, issue_flags);
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(sync_list);
+	LIST_HEAD(async_list);
+
+	spin_lock(&queue->lock);
+
+	list_for_each_entry(req, &queue->sync_fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_for_each_entry(req, &queue->async_fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+
+	list_splice_init(&queue->async_fuse_req_queue, &sync_list);
+	list_splice_init(&queue->sync_fuse_req_queue, &async_list);
+
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&sync_list);
+	fuse_dev_end_requests(&async_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = fuse_uring_get_queue(ring, qid);
+
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 /* Update conn limits according to ring values */
 static void fuse_uring_conn_cfg_limits(struct fuse_ring *ring)
 {
@@ -124,6 +159,8 @@ static int _fuse_uring_conn_cfg(struct fuse_ring_config *rcfg,
 
 	ring->queue_size = queue_sz;
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->fc = fc;
 
@@ -203,6 +240,165 @@ int fuse_uring_conn_cfg(struct file *file, void __user *argp)
 	return res;
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
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
+	struct fuse_ring_queue *queue = ent->queue;
+
+	/*
+	 * fuse_request_end() might take other locks like fi->lock and
+	 * can lead to lock ordering issues
+	 */
+	lockdep_assert_not_held(&ent->queue->lock);
+
+	if (need_cmd_done) {
+		pr_devel("qid=%d tag=%d sending cmd_done\n", queue->qid,
+			 ent->tag);
+
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
+				  IO_URING_F_UNLOCKED);
+	}
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	ent->state = FRRS_FREED;
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
+			pr_warn("entry teardown qid=%d tag=%d state=%d expected=%d",
+				queue->qid, ent->tag, ent->state, exp_state);
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
+		if (WARN_ON_ONCE(queue_refs < 0))
+			pr_warn("qid=%d queue_refs=%zd", queue->qid,
+				queue_refs);
+	}
+}
+
+static void fuse_uring_stop_queue(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->async_ent_avail_queue, queue,
+				     FRRS_WAIT);
+	fuse_uring_stop_list_entries(&queue->sync_ent_avail_queue, queue,
+				     FRRS_WAIT);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid, tag;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = fuse_uring_get_queue(ring, qid);
+
+		for (tag = 0; tag < ring->queue_depth; tag++) {
+			struct fuse_ring_ent *ent = &queue->ring_ent[tag];
+
+			if (ent->state != FRRS_FREED && ent->state != FRRS_INIT)
+				pr_info("ring=%p qid=%d tag=%d state=%d\n",
+					ring, qid, tag, ent->state);
+		}
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
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = fuse_uring_get_queue(ring, qid);
+
+		fuse_uring_stop_queue(queue);
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
+		struct fuse_ring_queue *queue = fuse_uring_get_queue(ring, qid);
+
+		fuse_uring_stop_queue(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		pr_info("ring=%p scheduling async queue stop\n", ring);
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
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 697963e5d524..432465d4bfce 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -14,6 +14,9 @@
 /* IORING_MAX_ENTRIES */
 #define FUSE_URING_MAX_QUEUE_DEPTH 32768
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -31,6 +34,9 @@ enum fuse_ring_req_state {
 
 	/* request is in or on the way to user space */
 	FRRS_USERSPACE,
+
+	/* request is released */
+	FRRS_FREED,
 };
 
 /* A fuse ring entry, part of the ring queue */
@@ -143,17 +149,32 @@ struct fuse_ring {
 	/* Is the ring read to take requests */
 	unsigned int ready : 1;
 
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
+	 */
+	unsigned int stop_debug_log : 1;
+
 	/* number of SQEs initialized */
 	atomic_t nr_sqe_init;
 
 	/* Used to release the ring on stop */
 	atomic_t queue_refs;
 
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
 	struct fuse_ring_queue queues[] ____cacheline_aligned_in_smp;
 };
 
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_conn_cfg(struct file *file, void __user *argp);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
@@ -189,6 +210,55 @@ static inline bool fuse_per_core_queue(struct fuse_conn *fc)
 	return fc->ring && fc->ring->per_core_queue;
 }
 
+static inline void fuse_uring_set_stopped_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = fuse_uring_get_queue(ring, qid);
+
+		spin_lock(&queue->lock);
+		queue->stopped = 1;
+		spin_unlock(&queue->lock);
+	}
+}
+
+/*
+ *  Set per queue aborted flag
+ */
+static inline void fuse_uring_set_stopped(struct fuse_conn *fc)
+	__must_hold(fc->lock)
+{
+	if (fc->ring == NULL)
+		return;
+
+	fc->ring->ready = false;
+
+	fuse_uring_set_stopped_queues(fc->ring);
+}
+
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
@@ -212,6 +282,17 @@ static inline bool fuse_per_core_queue(struct fuse_conn *fc)
 	return false;
 }
 
+static inline void fuse_uring_set_stopped(struct fuse_conn *fc)
+{
+}
+
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


