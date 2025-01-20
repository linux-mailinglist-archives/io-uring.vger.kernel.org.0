Return-Path: <io-uring+bounces-6009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2A4A164E9
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 326603A0450
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2738A11713;
	Mon, 20 Jan 2025 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="qxy2V1ka"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51E01802B;
	Mon, 20 Jan 2025 01:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336572; cv=fail; b=dmYT3f35tSpjBjvkjq9CLi842v9naC9G7ptvxcOmEEuQULB3BUAnEIAhNSDsIWrmo9CHSwiw4zz5YQYGYY0Md93AA0KA0acDRZKlhUceJFHpnOvzvelmKGYnRzvuCZGbp0FsDsC4MprsOcKauJb3vQi8qY1ZY+OabgBVdj+F/tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336572; c=relaxed/simple;
	bh=9BrSyfWSSxLbGoiiPy+ZsQVkgMofKZdyjdQtV6Kq/EY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=idYNz8zFmZdjAXLHG75NSniGCjEFscP+wJTQUsaCy6CwfqIdRHUFBiTHEEimpl1xECdrXgXwzxf+C5hsYqsMFdo3aXMVUiDwPNH+o9X8trwuNx9xNUriGR9yVCw1gO8ZpzkzEDKXx1HQGscISYoLfes54D01LcXmtKF+Mu18SN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=qxy2V1ka; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MfbKv3o74AVk/gRzfBw4Jz+PA22J5ZNPH/XMulqgsUtn0IOgRgdFGiL0dEzH/ODATmTqMu3kd291Rf1bAVJnCEMdk6Tc1Xd7zRmuB0NVNnFvM9mo2WYzOPWaEeQxK40FUdl356VZwLYKm1olIzrqjZOrp3UWIwAr49upYZiN/+87gH4vgxHCITzeC/8GeR8s1/b/ob3dngjm0znpCK5Z02oEFXeiI3d3xaCvB7GwCuHQajG3oYoawGablcdERx1qVj0LmnCvgAbbuBCJREF/F8s0TJjNUziLr2yO3jzs1U9MMASDgPGS14/0oi+w5lHVGIH2HF1Vk39eWNDgxoMmxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbvoq23j5qXFs0VeGHVv//ZhH/h1AVJ9J7gm6cUP6Bs=;
 b=LvKcAz8hcU4V26urhumoI5BdnYQly2RoRZj+B+1VoWMZ82m/D0DU4AgQNbeG/IFgHIJz1BC+N53lHaTj0R6ofVYBWMxZh+m32YGKueis1+ag/bDJsAOVUi2tCV/wv5NZUDjO7xowKy6pz6P4u8H4tj0bMfW/hdqFWYBrHplWpFNqnhTtG8xs1YZi8Z5Nxkj9XEv2nm22QDwRLJ5Or4lphZlv20blehKbtq5UhlUM6O9mdFULJydsrEyWYEjICTkME8otsQ4rRjyESNb+yaskMVMOetuRUCHwkaBBstEH2kHKa3LPQKCnnzQajCaQVdgDtcT0N2fz76mr0yl0CmqtIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbvoq23j5qXFs0VeGHVv//ZhH/h1AVJ9J7gm6cUP6Bs=;
 b=qxy2V1kaWppi2Q6uN1eHZAf1zKzKvZbNXN3ht5xEV+1kHDC4exK3Agbm9ROBCQt/QLCQINz7fWyHRX6iQVL7BwRDjKC+Dz8dodMbOWeNY03eRF5zOrzQ5o5grbBRb7+5DQFcdaFVjlGDo/w4AR9zdZ3KPTlQGIhOT5njiRQsVeo=
Received: from SA1P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::7)
 by SJ2PR19MB8204.namprd19.prod.outlook.com (2603:10b6:a03:55c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 01:29:06 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::1b) by SA1P222CA0006.outlook.office365.com
 (2603:10b6:806:22c::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:06 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id B63F134;
	Mon, 20 Jan 2025 01:29:05 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:28:57 +0100
Subject: [PATCH v10 04/17] fuse: Add fuse-io-uring design documentation
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-4-ca7c5d1007c0@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=4855;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=9BrSyfWSSxLbGoiiPy+ZsQVkgMofKZdyjdQtV6Kq/EY=;
 b=rvwvl2HXswd1t7SG50x2a72JEFIwAlXjqwmTfvgqFHTJytGvoXyezm1o6YMpmV2OcfY3rhuV4
 UVB6aLo9y+lDDACFCI6RT8+1Ws4yqV7Q3q0q3Jkx1xtVnRFGmAYChSj
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|SJ2PR19MB8204:EE_
X-MS-Office365-Filtering-Correlation-Id: 811c4f69-a74c-46ef-d7b4-08dd38f1d4bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUp6NkFyOUN4M1QvbzlCYm1lZ2xhaXBEZUIvRkV1QkVDYlFxckxCWm16K2E2?=
 =?utf-8?B?Y0loaEpndUtQMk9icWppQjZCdTZrTzhTdkFCZHBuQlNFSjZBTE5YbnYzdVgr?=
 =?utf-8?B?bjE3dllSanNJb3BlcUF0K0JOQnVLcmhGRXRuTllSQ0xFM09vYjQrV09xbFNq?=
 =?utf-8?B?WHdpQkNlNUdwcG5SR0kxTWRhR3Exd0NuZ3cvNHVVMEdFOXFBOG10YlZ0aDVw?=
 =?utf-8?B?cWhYL3FYL2NmL3BZYUx0NDJyT2k5N3Qyb2xWNjRFUGliTUovUHBoRjdyclVw?=
 =?utf-8?B?eWJjd2t2RWxQc2t4QjM2RFRsZnRZRXdhVHBKOG5lSnY4SDIwYktwZmY3Mkt0?=
 =?utf-8?B?QURqM1RKOWpIVEkwejl2Rkp6WWs5VVZDMGpCRmxYRmZUb1Y1WWt6bE1TS3Jl?=
 =?utf-8?B?VzdRK1laTlU5SDZVK1lTcGFkdUtMNWUzV0ZmMWpHdzMrc0kxWmhpaWlieldo?=
 =?utf-8?B?cTg3dWJ4WWJodi9KLzdsVDlwdEhIZXAvbG0xWE95eVMzWG0wejRkUnVFNGJO?=
 =?utf-8?B?U2Jqd0JOT3dwOVpKNHlZU0g3b2tpR0lEbUc0UVRTSVNwMERac3Z4OFc1Snph?=
 =?utf-8?B?NHk3UEpmWXJDbllYemVHajBkRUNQU3BOZGp1MEFLbXU3QTNPbUF0M1lFZ3Fv?=
 =?utf-8?B?YmVwQ3ZoWVZtK283TEowZzZUWjB1Vk53UklPUENKZUhBL2JHVFVxWGZnY0tz?=
 =?utf-8?B?U1ZQRW1FWU8yMGRoTE1MeHlIbXhXbjlXdVVLeEY4aVVaUkFRVEZLS2IwaVkx?=
 =?utf-8?B?bzVZZE1oYkQ1TSt1TXRyU3N1TmREWDEyQW5qbGd3Mkw3N1pybGJFYThzeGJN?=
 =?utf-8?B?L2l6UlVkRkUvSE50U2NhbHNVc250N1J4WGxkczA3SEFzZmZQVTloV1EyOFhs?=
 =?utf-8?B?andMWitPdVFwdkRxUVlucjlmTWx6WnNHeTlZaStBdVhvODdDaFp0TlZQMmQw?=
 =?utf-8?B?bHJwNElFd1BkV09Ec3hLaHRVbDJycmlwS0U3b093Z0xCeUJoSUFMRWZCUG1O?=
 =?utf-8?B?REZIV0M2b2ZqTkJyWEJOVFNZRnJnUFhVc2tqamYyKzhaSVF4d2xjS29wcmF0?=
 =?utf-8?B?c1dEZWl6SlQ0QnRMUGxmK2hZU2lUbE5teldWRnRmeHdhajZsYWtTeGxRVDBX?=
 =?utf-8?B?ci9vQ0p4bi9xVmhQYWgxVzlLSjV2NWhMUVc5SDgzaXdJTVBXODdJcExoOEVw?=
 =?utf-8?B?bTVybytHZEw4L0pQdThuNTFtKzQ3MitRN3BLWmM3cEpjQ3BEMHE1bGc2WUcz?=
 =?utf-8?B?OEJTaTcrZVU0MnFYYkZkYU5MVEVtT0w4b25rOTVDaDNNeEtVdzRIcWJRV1Fz?=
 =?utf-8?B?MFM3dSsrZkNrdkN0QWJpMWhZbi93cktkQUV3N2xjdmhiazUvRUswQitDL1lF?=
 =?utf-8?B?M3p2bGNOUW5lRHRYWUNOSGQxbGNQZ1EyQldXVElmK1dScERRRVhYa1JHallJ?=
 =?utf-8?B?cjBLbnU5em95OXlWeEl2dXBqckI4YTNLUVBrYWMxSHNwS0RCMWtZbE9uUWZL?=
 =?utf-8?B?dUhBd1dSNjZOMW12R011cFBuU05ORVhFM3F3SVBrbzBtUVIzenZ5eUVGR3o1?=
 =?utf-8?B?allha2xKbENHV1N6QkMxSUY3VFA2L0lHQ0k5T1RMNzVaTCtYK3FHa2kzK0JX?=
 =?utf-8?B?Yy9Mai9EM0JXZ3pDMVNXY2x0cVo2a3J2dlBGNkJReGZmM2xsaGxmeWk5eHpw?=
 =?utf-8?B?QnJaV3YyRkswSkY2RTJYbTMwOEhLSEhNc1JRWkh6Zk9EY2EvWHpTU2RRM281?=
 =?utf-8?B?WHZwRS9HTCt5ZC9FWDRRUDFWeERvNUg5SEJoYkFuc3N5alhhM1ZoNGFNVnE1?=
 =?utf-8?B?ZnJYeFkyd0RPbDBkSUpvNWlkUGh1TzFaVUJxalBobHBtSmV1THFza01BWkta?=
 =?utf-8?B?UC9tNTRreWNTbnhMVU9Wd1FUU1hHbVkwMnA3UkxrZXlYYVlyQmRGRUd4bmpP?=
 =?utf-8?B?VVJ6aFlPOWVlS3JxdDJtVnJmVDNOUDhackMrVGtKMW1PMk90c3hRdFpKV3pE?=
 =?utf-8?Q?sLNJF2vVWvGy0xFtcrlGDfi0Y+DqO0=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M3a0lHiaqj36+tqGRgubbs6SVxppOfs3CHErpwgybkaVmM2fQNDwu2WFavMQ4DjT8KV54UqxBK2RnfTUqFv1iTjUOo5n2l3+3XrxeCQ7MeL43tW0TNQDWbdrqOUwElvcAoQCkkQ1XXCcGTqA968GqrL5C7tXUpo9713wMLur1sKrkJNkZnUAu+toYhEtTlMtJw6y+US9ccudGuFc5cYLkgPDxddGo+YsSY9vlen5HGFocBtOgxwbkIR1Hv/0qQYZ0XmRItSAPcJHkgXk97/Ue/c/emtNYs8lCJ64WfCkTCakXtJRo8dl/0/D/4PgjMiSIu1Sc2hWewChcIi1HRYvO+Nwr66fQ9C5dGZpAty9KHFTJLgKSLQR6vGUUJZsV+8lE0mBMQ7fAk4LU8EW6N8YNm3vKfdtLstpBSMRDPUBs+8U76RmrmFP4bDOjYu6HH1IqXyXW8nRsfDt6LM7vAf7pyHjB1kVB+WZQrkFLlaeknjXdvLQlO0GC52jLVJ3nxcGMmHrHsRIOgaNTGgjxfMeFBiLdoCMpvZdJnaGzNk1Kp5JfLZ0ws9Sc7w/XilJ6osAMbGItl9jxVsMI/c5MLrVuSuBdRcwXtnNWjp0QrW305PL6Ky0iJoSJVGgO1PRJOLaMxflONYZJzqy7t1ZdGW9ow==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:06.2894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 811c4f69-a74c-46ef-d7b4-08dd38f1d4bb
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB8204
X-BESS-ID: 1737336549-105647-17571-264310-1
X-BESS-VER: 2019.3_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.55.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVibmJoZAVgZQ0MDM3MQs1SLV0t
	jUwMAixcI82TAxKdncwNTQxNA0zdRQqTYWAEnvPKpBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan10-106.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 Documentation/filesystems/fuse-io-uring.rst | 101 ++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/Documentation/filesystems/fuse-io-uring.rst b/Documentation/filesystems/fuse-io-uring.rst
new file mode 100644
index 0000000000000000000000000000000000000000..3c6b127d68a78e2fb7caa6d980e6cab27af4945a
--- /dev/null
+++ b/Documentation/filesystems/fuse-io-uring.rst
@@ -0,0 +1,101 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================================
+FUSE-over-io-uring design documentation
+=======================================
+
+This documentation covers basic details how the fuse
+kernel/userspace communication through io-uring is configured
+and works. For generic details about FUSE see fuse.rst.
+
+This document also covers the current interface, which is
+still in development and might change.
+
+Limitations
+===========
+As of now not all requests types are supported through io-uring, userspace
+is required to also handle requests through /dev/fuse after io-uring setup
+is complete.  Specifically notifications (initiated from the daemon side)
+ and interrupts.
+
+Fuse io-uring configuration
+===========================
+
+Fuse kernel requests are queued through the classical /dev/fuse
+read/write interface - until io-uring setup is complete.
+
+In order to set up fuse-over-io-uring fuse-server (user-space)
+needs to submit SQEs (opcode = IORING_OP_URING_CMD) to the /dev/fuse
+connection file descriptor. Initial submit is with the sub command
+FUSE_URING_REQ_REGISTER, which will just register entries to be
+available in the kernel.
+
+Once at least one entry per queue is submitted, kernel starts
+to enqueue to ring queues.
+Note, every CPU core has its own fuse-io-uring queue.
+Userspace handles the CQE/fuse-request and submits the result as
+subcommand FUSE_URING_REQ_COMMIT_AND_FETCH - kernel completes
+the requests and also marks the entry available again. If there are
+pending requests waiting the request will be immediately submitted
+to the daemon again.
+
+Initial SQE
+-----------
+
+ |                                    |  FUSE filesystem daemon
+ |                                    |
+ |                                    |  >io_uring_submit()
+ |                                    |   IORING_OP_URING_CMD /
+ |                                    |   FUSE_URING_CMD_REGISTER
+ |                                    |  [wait cqe]
+ |                                    |   >io_uring_wait_cqe() or
+ |                                    |   >io_uring_submit_and_wait()
+ |                                    |
+ |  >fuse_uring_cmd()                 |
+ |   >fuse_uring_fetch()              |
+ |    >fuse_uring_ent_release()       |
+
+
+Sending requests with CQEs
+--------------------------
+
+ |                                         |  FUSE filesystem daemon
+ |                                         |  [waiting for CQEs]
+ |  "rm /mnt/fuse/file"                    |
+ |                                         |
+ |  >sys_unlink()                          |
+ |    >fuse_unlink()                       |
+ |      [allocate request]                 |
+ |      >__fuse_request_send()             |
+ |        ...                              |
+ |       >fuse_uring_queue_fuse_req        |
+ |        [queue request on fg or          |
+ |          bg queue]                      |
+ |         >fuse_uring_assign_ring_entry() |
+ |         >fuse_uring_send_to_ring()      |
+ |          >fuse_uring_copy_to_ring()     |
+ |          >io_uring_cmd_done()           |
+ |          >request_wait_answer()         |
+ |           [sleep on req->waitq]         |
+ |                                         |  [receives and handles CQE]
+ |                                         |  [submit result and fetch next]
+ |                                         |  >io_uring_submit()
+ |                                         |   IORING_OP_URING_CMD/
+ |                                         |   FUSE_URING_CMD_COMMIT_AND_FETCH
+ |  >fuse_uring_cmd()                      |
+ |   >fuse_uring_commit_and_release()      |
+ |    >fuse_uring_copy_from_ring()         |
+ |     [ copy the result to the fuse req]  |
+ |     >fuse_uring_req_end_and_get_next()  |
+ |      >fuse_request_end()                |
+ |       [wake up req->waitq]              |
+ |      >fuse_uring_ent_release_and_fetch()|
+ |       [wait or handle next req]         |
+ |                                         |
+ |                                         |
+ |       [req->waitq woken up]             |
+ |    <fuse_unlink()                       |
+ |  <sys_unlink()                          |
+
+
+

-- 
2.43.0


