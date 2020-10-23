Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8516D2969A4
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 08:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372498AbgJWGUY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Oct 2020 02:20:24 -0400
Received: from mail-mw2nam12on2072.outbound.protection.outlook.com ([40.107.244.72]:43489
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S372497AbgJWGUX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 23 Oct 2020 02:20:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik2QyskoBIPaNjB/eST4rU0DSjn9JagR4XyOLzjJRLdU/w2MAj7YeASA78y99i+hC6U6YkDBxtjRwDwY66yXRNxqRD/y4wpiL1mlU2mJXNvMDtyB3LDCYI+BvJGnNHm3R6H0f0wYY0RI7nTUGK9Yt6HVxCe6vMpzczWtyQUjM+ukYjHbPERXF+CUFsQu2R+JOTHk4M8Oy35hvMNESYcT2bFk8tWa9mG2cRVCD2d5lmu0K1RCq5UB4hgruM1iGbAE98YTKgnbwf2A8KkvSMaUamYmexWVMZE8lLz52E8PMISOvJH8lzoBx0FX1f6wgYNEEb4KqTRb+8pGALKRD+1rNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us9KZrMSXCLyU0MhHT0h2hJTL4e7Vp60kF6bbjCXnQk=;
 b=ShVOS6p63GxzFanTVTlJclXcb2tkiOu7nyqteBwExwNPgy4UJiaDxPIoV+Mf50FK9/shuKiDUiaQBrdzQ+mMEWHm1YF58c0Nzuakwg5faxSERoTQRmDeu7gp9275pok0d56uk9jJPu2GtY08pNukTRwGy0QwwydvTIUCus98hC/DbG9XJTCQMKObFEP1KuYhDsl5ty/9wFMlHcga22QSZJBiJcx+tIICticUrPUxMDo2Ll69PQFJ4h0/E9+q9D3Yu+9acu1vMF5w1pBSH8cKjv8Otq7qrICUsVse7SH9owxCnSTlCump7PrW/gbhc+59uQa1aUWRcdJNJRa+Sr12hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us9KZrMSXCLyU0MhHT0h2hJTL4e7Vp60kF6bbjCXnQk=;
 b=EQr2shg1/ha8+/dE1jsdVhkPNRvxYF/754h2Ds3mBDzbIMhM5UY0E2y24HexkApjjlDxvCij+8czoshNz2Zo9PpRtRfjamrUshI8BzWV3ojXNre8wKUfyA73+Hf5iRDR+IW3J2eVsTwtSo9yKXf82flgO/HUeoZpGhfkxF7fIc0=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB2901.namprd11.prod.outlook.com (2603:10b6:a03:91::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Fri, 23 Oct
 2020 06:20:21 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Fri, 23 Oct 2020
 06:20:21 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: fix 'task->pi_lock' spin lock protect
Date:   Fri, 23 Oct 2020 14:20:03 +0800
Message-Id: <20201023062003.3353-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0077.apcprd04.prod.outlook.com
 (2603:1096:202:15::21) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by HK2PR04CA0077.apcprd04.prod.outlook.com (2603:1096:202:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 23 Oct 2020 06:20:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e72916-4049-4976-3929-08d8771bb7de
X-MS-TrafficTypeDiagnostic: BYAPR11MB2901:
X-Microsoft-Antispam-PRVS: <BYAPR11MB29019927FDFD50F36AA20792FF1A0@BYAPR11MB2901.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vUoWqfOv/B3Wa1sK8+emdJVsbAOFMBmkHM9EiBexT2Z2CGhwpy26CCpjL9f3LrwC1odoFXS2cRFzl9FNlM+VAZKgZxyz4YvW+z+vShqNq8JIOnqZO7zj3Tcy1eNOWgHW1XCbnmo/o6+g8uGigmSFtkWyxkYU04BXdlkaowUNPXgCndTbqNp/5eq+GS4/QgIyXFdDxzBXMMvvvegWxLNaBQU8m3oNRfG/vNAJwohvdhHTtBesmwsEqtXVMIrO72qXKH6lgaLPG8DgiOLN7uWS2aXhNirZhLHV5jguXdP1BsfgXM0DdTHEJRtwYJ0azfOz6NnFo65r7budob5TaaCipQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(376002)(396003)(366004)(478600001)(186003)(5660300002)(4326008)(26005)(6512007)(9686003)(2906002)(1076003)(316002)(6506007)(4744005)(6666004)(2616005)(16526019)(956004)(8676002)(6916009)(8936002)(66946007)(86362001)(66476007)(6486002)(83380400001)(36756003)(52116002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TsgT3vb3PB7QGQT+31+hZbayxG1ql4O+HoauVuc4QgaX2ySnRQabXGZTYT8H0OKbBh+3mMhAJmed+pEnAoEG/tPsODvf4ExDByYPyQqRJ0wAHlhh90C+6R2BQnA/dtjddtq//3QeCcqfOk+nmHTZM2EiUvoI2yr92BJ8LQqTs3BhhZpZgey0GLK1Lkq25JpeSfnEtURY0vWvjwaeys6+WYRoysjT3M2yJ2DbWkZN9wxb6jb3WgU3UZAMimH571HNObCBFJBvkKDTLZ6FHGdefQqiqKn7t6UTfE0Orn4CNAXrla05vpNIPPRPOaxsxLZwr6NaZLvNyV1qzC6utECBA3SCX5FmRMK7XwejZPosJhUR1BN40ezozCpKehpEko7GaAHzhVAroRL4fbesKk0Ui+HqNt7amR3kKBjCU4KmBzt+3SJP4MvnzJRVH7tjyS22m7FWafhnTgF/ZfjHYOnklEy2uL2ISAv+DFlAub+gu14MAKnQWvj2JpNBwgni7g7DZUuhEZ+xSt+EGhf8CXLQPOXmYl0aN/mvsemakWCs++X38tCpVL4CCLTmpCVfrCu7Q+qGJxIgYjFDCphK4zTqO49PhlpI/kb8koqFtcVuIHFlpiOIjh0jje/vvyv+EOF786oqxpUFNreQlbvIG/IjnQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e72916-4049-4976-3929-08d8771bb7de
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2020 06:20:20.9419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHor9bKmjNS78kp0wM9Rh6tOEhQ3EXFw4UQYIiM8yTb5u00wogm9c0Ap6vRgW9UTYpr1yKtGn1LiketVeGYe1Q//8GIG5lDCsQthyHTWXGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2901
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

The set CPU affinity func 'do_set_cpus_allowed' may be operate
'task_rq', need add rq lock protect, replace 'pi_lock' spinlock
protect with task_rq_lock func.

Signed-off-by: Zqiang <qiang.zhang@windriver.com>
---
 fs/io-wq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d3165ce339c2..6ea3e0224e63 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1209,11 +1209,13 @@ static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 {
 	struct task_struct *task = worker->task;
 	unsigned long flags;
+	struct rq_flags rf;
+	struct rq *rq;
 
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	rq = task_rq_lock(task, &rf);
 	do_set_cpus_allowed(task, cpumask_of_node(worker->wqe->node));
 	task->flags |= PF_NO_SETAFFINITY;
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	task_rq_unlock(rq, task, &rf);
 	return false;
 }
 
-- 
2.17.1

