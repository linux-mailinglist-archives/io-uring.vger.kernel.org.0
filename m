Return-Path: <io-uring+bounces-5167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B30409E04B5
	for <lists+io-uring@lfdr.de>; Mon,  2 Dec 2024 15:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 740CB283AC1
	for <lists+io-uring@lfdr.de>; Mon,  2 Dec 2024 14:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E673C1FF5EF;
	Mon,  2 Dec 2024 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="cPdoI6Z6"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79041FECB5;
	Mon,  2 Dec 2024 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733149357; cv=fail; b=Z0XF3rqP52SSECmviO5rJQ9o2F51mVtGKhw4XccVpS5HqCw1Ay4kA07LPSgvZ4Ql/rTTgsmTvWKioja5Ihquj2TzHIVwrcZBPYRYCadpJHSPHEN2h3QWMbjVPwVDEcbBQs3apIfC1KHgx698obNLdO/i8FJwJ6OtZctGjmuFDoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733149357; c=relaxed/simple;
	bh=b/kQPnww33L7qzXKzq4LlnNBYkpstgz6XZGTA26G3/4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=P/NDn8R8noYjlyqpx4XhLyZ2ba3wvryYuYAUVo8BLUtCG7aAQzUL6uNep7c3hlS8yGwyi9utDpCyqL+OAERoQFRl3GyCFE8DcicSprkXNb8B8leSoGzyr+Qa4fkLf8tNYH0OoZAUHD0xXJFx9BI7CH1KGlGY+l41ocAzUIXmx/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=cPdoI6Z6; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48]) by mx-outbound43-151.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 02 Dec 2024 14:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sb6xpKxnMegiSZIgLHfJg6Ph/Ih0d6LctwkIrZXXQPQ/SgZuirKwWQO6vwLeBPhUrmoLjhAOTkXjku9Fj3PqciZNCs8OuGZGIEF1Mnk0tn0alHT1XWY8yVpWHNBOU8Kj2yiXEmOB43jDr1VWYQ4Ap7lwdGCHgkYtgg7VQA02KlhYS8kZ9/h8N4n6fS97aAi+JdQ0pRLIOU8ufBCXZl6u+MkUqsYJVpmQ0wJRZy+5ClRGhjeWmKL5pEdZZolEAMVoZJ3IlHp9l+DuyBR2yBqTUdAKk+9EaR7k+SSOZv7rBCG/PCVc4o1i25dSOi0oLoNS3ky2hP6sBASmn4ZuRdrKVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uN1U/7zX65BvMK+7aSiOnFT1NOkoitMIZEj2vKGjTMA=;
 b=I6ODQuipZA4p62vNnepqjyIEsoz0AASUTpGiExdiiDl/JStEtYyaYUu/foTASvyDWSasccJ56HIYb1BXhA3SCphCKn2yyI6hkg/AS/5TYf5VPYaYK5E7CFQjGvwlndhdIeFJAGZ8GyPxE6wKuZRjHXat+rUCKmPWifOioeqpmRIWCjcEM0dAxUivSWR/EDBx7pL9KvuQmwnH5qf5vVk6fy2KkC0HthdaEoiO2XFyWOzEahsoH+JQOw+k9d8Gp5M0xXqbSZXZx5/ZioTbwIz/GyQwHDO7V+FWpF/LcgGmO5HvLWKqo9QIt3wrWTGO0UshRMcawyurAYgx/8swaXPwWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN1U/7zX65BvMK+7aSiOnFT1NOkoitMIZEj2vKGjTMA=;
 b=cPdoI6Z6Fk2g+x0jBDJ9HHBb2qyp9k12WKohnGgeYvZiGDCqydiY7KL90hGsqgepjSzFfPLF57Z1bNsEx3qEte4soB8zfrD6qD6zLk8pWs+8uIvyCd44LzjEXW13qHzkDdxXVwfTX6rHS+69Zkf9DC3yqqa1iUoMaTpAqb0e8I0=
Received: from MW4PR04CA0062.namprd04.prod.outlook.com (2603:10b6:303:6b::7)
 by CO6PR19MB4739.namprd19.prod.outlook.com (2603:10b6:5:347::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 2 Dec
 2024 14:22:19 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:6b:cafe::65) by MW4PR04CA0062.outlook.office365.com
 (2603:10b6:303:6b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.17 via Frontend Transport; Mon,
 2 Dec 2024 14:22:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 2 Dec 2024 14:22:19 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 049802D;
	Mon,  2 Dec 2024 14:22:17 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 02 Dec 2024 15:22:17 +0100
Subject: [PATCH] io_uring: Change res2 parameter type in io_uring_cmd_done
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-io_uring_cmd_done-res2-as-u64-v1-1-74f33388c3d8@ddn.com>
X-B4-Tracking: v=1; b=H4sIAJjCTWcC/x3MQQqDMBBA0avIrDtg0qDoVaSENJnoLExkBktBv
 HtDNx/e5l+gJEwKc3eB0IeVa2kwjw7iFspKyKkZbG+daUGu/hQuq4978qkWQiG1GBTPwaE1Y3D
 kxvf0zNAeh1Dm7/+/vO77Byb5O4VvAAAA
X-Change-ID: 20241202-io_uring_cmd_done-res2-as-u64-217a4e47b93f
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 Kanchan Joshi <joshi.k@samsung.com>
Cc: io-uring@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733149337; l=2205;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=b/kQPnww33L7qzXKzq4LlnNBYkpstgz6XZGTA26G3/4=;
 b=AUCj83OcKHDaCLTNeZvob1Bd4Mdh9Df6f02Mf9QSB8ecMzLvKyUNAgRrN79+LNxhAj/Zq5uIN
 kifUlPW3MvPBiBEsWF7yaYY67hHuyeRci4BTCxiKzyIxS9c2znW47/T
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|CO6PR19MB4739:EE_
X-MS-Office365-Filtering-Correlation-Id: 11896859-35f7-460a-5698-08dd12dcbad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk9CUG1WS0dRUE1mU1JsMURxMi9hTndJaDIxUmlFc3dGQjFpYVFvbW1ZT3h2?=
 =?utf-8?B?QzhLSWRjcFhwNnUyQVhVUUU3QTlTYWJldWlBZnJKRjhndDJiQWNSTE80K1lZ?=
 =?utf-8?B?cjFuRXk0OUZVbDR3V1NpTkR4UTltSVVLSTlSMmhIeThOM0lHcks0MVkxTE9n?=
 =?utf-8?B?bk1sNlRDZUJoZ0Z5S1p5VWxVQ1ZSYTRNS09ZbllRV1dYVWI0N2YvNE5OWmwz?=
 =?utf-8?B?Z1cySXljUzduV1JuRjhBelBpOW9QRVJ5dTFhTUpWWnFiUGVRMi8rZlBVWWdn?=
 =?utf-8?B?b0ZEQmk0cDl0dGpMdW9UeUtSaGRRT1UwUEUvWTUvOUlwSUlLNlpqUXdSUkhM?=
 =?utf-8?B?U0RhcllvcWMwTkdXdnhmekRzeUcyN0wvRUEydWh0ZCtFcGd4dFFuMUcwTnM1?=
 =?utf-8?B?cVpIVysxcnNmaGVRM090WWZFN2U0Rld4c3NHTDBLU2t5TGpzU3JhVzNpRXZM?=
 =?utf-8?B?akRxR2RsNWJLTE4wZnh1OGVEWlV5NmwxVDdXbmpscGZrTjU3UWpYa1VVV2Y1?=
 =?utf-8?B?NTgvRXRqYXFVT25uUXQ5R256b1NiQjE4cTdnN3JPYkYwWTlKVnFGR1NaMVhC?=
 =?utf-8?B?NkUrQjZXUkZQdkkrTlhFMEkxTFIrZ1ozaXc0U3pJU3R3S0FYVlN5MXJOc3pQ?=
 =?utf-8?B?WlFFenRUU0V1QmpDclZtRU04cEI1cWlDdUk3cyt4ZHdGU2RaOTdjZnd2YVRz?=
 =?utf-8?B?Z0hFdjV1Q3JKYWptMU9ITXdJQnA2cFdZRHFhTTVXTml2RG9temphTDJGWXBr?=
 =?utf-8?B?RU5KMGtyRXZOd0M3MlN6bUFmeWx4Z3YvY3d2QVlTQ3RYV2M0d0JoWllHaGs0?=
 =?utf-8?B?bWRucld3RUdoaWU5R2o4d2szRk9pSmI4Q2VSYXlMTkd1bE1yY0dEMHhmbmlH?=
 =?utf-8?B?MkpwOU9ZNS8weHlqbDZLdjhWTnpZc09zYlJsU1lDWkQxNzNmWXZleUIxdy9U?=
 =?utf-8?B?QXluQ3dXL2RLTHUweWFSaHRLak1kNCthTytESUEyUzdqdkt6cHdNS1VGcjJo?=
 =?utf-8?B?aXp1eVBUTm9qS0lWZVU4ZUtab2wrbks4cUo0dFMxK1N1VzdrN0hRbHhEa1dk?=
 =?utf-8?B?TUF1ZWY0d0RZSS9sS2Y4eGNtd3l1VGxpSi84S1VqMUdMbmlsV1hYZlc2QXcr?=
 =?utf-8?B?RVhLZE9EYjIrUWtZRTEyTTFDUXo2ZW5YNjBPUU9SMkpINFloWVZkTVpOVlVn?=
 =?utf-8?B?UWZQRGNvNExYdEVINy84K1JUOGJVNCtYaGUyM3N4VE8vQW81M0dEUkI3aHVM?=
 =?utf-8?B?TXdndGJFTThlR0JicUlyVUtJVW5qcVE1WUtwWWNheCt6YzJHZitDOFJiKzFy?=
 =?utf-8?B?ODBzOWw2aW5WRmlVQzdTcUl4NzhZQk1xVDM1clp5T0FFNTRRMU5YMFQxQ0I1?=
 =?utf-8?B?SzRsUE83NS9ZenB4dDFJNjRVRlJ3ZHZsdVoxMzZ6MjFTdzZWOGtXMC9Vckdv?=
 =?utf-8?B?cGVEM2k4dFFmS1NkVmZYY1NuZGVwamZqUXVYelA1eTAxSE9BajJoelJCUS9H?=
 =?utf-8?B?TEU2VFpzZEtKcldFUkhPdFNTOVJGVWRJTlVyUUZscEJwMUN4cEEvbm9iQ3N4?=
 =?utf-8?B?TGM3bDlRY0tVWVNnVDRMWUFVOVhxaVR3NHFwTDhHZUNTNm53bGNTNWp0bFl6?=
 =?utf-8?B?NTR6c3RjOFZvMVJIS3g2Z1ZrbmpHM1dyNkROM1Q1REF1UVAwYVo0K2NPR1I2?=
 =?utf-8?B?OUZqdW5yVXhWVjJKZ1ZtZE5oVlp4NUhtWm5SS2UzbWNOMkdWTnBRMWk2cW5s?=
 =?utf-8?B?azVtVWErNHNzOVV5N05OSHVsRjhIUXd1MVBBSll4cVJJMkRTQjJIODJ0d3V6?=
 =?utf-8?B?c1lTaTBnVEs5UjlPM3B5cXhJTEJGMVNWdUpzVVZNWktVOFg5bTZtQlZZbVdq?=
 =?utf-8?B?ZTNxNnN3dlBTUGV1UFZGR3NwQ0pYYjZaSExUcHdtcDlHU0FROU9aL2Y5YSto?=
 =?utf-8?Q?ma9ATZeh+EpGo4ZL66ZBFYEkYbzN5yND?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MWpBF1iO07KmjiQaSvbjfMP977bwrI3ARCklK8DPwRfo5hupMSxbp6+RiYDpQzw0nptVZFslLeyo4DGQMLo/jZ/8ygx/pMbV8pbwPCHjNCGuSJG0wA3F731QxjGMDV8lgGux3fWdxSyUIyejMRX4gTtIw7Usc1BWxo/ElSFfEUdaBO3LLbVd2nBx7JWcZM4NJTF9sw3psylR57op79MeVd1D15c4vJeDBqGI3DN0COIq9JYlZoyPw/xhbY5H1x8DGGMCuEJy8tqGHZA6BPFwnJyeC+9D7IciDKHq7LIpH88K0uMx6x2um19M7cZaYB99QlPKfS4J886QtkIn9jSVll4fBsi1naA8r4RQVcuTL50/WqaLE/D1Zddf+gVnvWI9s3hSMXIAbjIvxTwYH2wktB694jd+93JfPEu3d0mimuT3jtnXd7kp8a2nlH5KIbAYXMXXP7ZFJEgxQkpVtpdmjiycj02LtDwWYzi7zMOP/9p+lMcoyXRSBtrGsJuuIRomcV2dsLVXNKmsXFtZdT9sZKYsiOHiIqTpvnQ/0wqkefe7n5GQxrKHiLCxukYq9Jyqi0SpR+n6xgwwgorkAT6PpT31Da5U44PkbqRw72DDNDjm51ox1pgYXyAItMx0M6c2/Fr9cyUTqqgua6gqyrSQ7Q==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 14:22:19.2386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11896859-35f7-460a-5698-08dd12dcbad8
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB4739
X-BESS-ID: 1733149342-111159-13540-4031-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.70.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaGpqZAVgZQMDXJ0MTAPNXEyN
	I40cLC2NIwOTHJ0NzE3CAlMdEkzdhQqTYWAFRqH35BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260838 [from 
	cloudscan17-245.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Change the type of the res2 parameter in io_uring_cmd_done from ssize_t
to u64. This aligns the parameter type with io_req_set_cqe32_extra,
which expects u64 arguments.
The change eliminates potential issues on 32-bit architectures where
ssize_t might be 32-bit.

Only user of passing res2 is drivers/nvme/host/ioctl.c and it actually
passes u64.

Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Cc: stable@vger.kernel.org
---
 include/linux/io_uring/cmd.h | 2 +-
 io_uring/uring_cmd.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 578a3fdf5c719cf45fd4b6f9c894204d6b4f946c..75691ca2043acdf687709bb2f27829a1bc7a1103 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -43,7 +43,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
  * Note: the caller should never hard code @issue_flags and is only allowed
  * to pass the mask provided by the core io_uring code.
  */
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, u64 res2,
 			unsigned issue_flags);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d9fb2143f56ff5d13483687fa949c293f9b8dbef..af842e9b4eb975ba56aaeaaa0c2e207a7732beba 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -151,7 +151,7 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);

---
base-commit: 7af08b57bcb9ebf78675c50069c54125c0a8b795
change-id: 20241202-io_uring_cmd_done-res2-as-u64-217a4e47b93f

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


