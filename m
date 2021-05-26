Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8A6390FF7
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 07:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhEZFZO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 01:25:14 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:28692 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229522AbhEZFZO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 01:25:14 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q5ETd1028387;
        Wed, 26 May 2021 05:23:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0064b401.pphosted.com with ESMTP id 38re2qha1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 05:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLc2fKXmRqB0zwfPrgacCnbCqr632mUtaoaWPjh70tNZB7/C1IesUExGPmPH3h8jmj1XspBcC+Rp27Z+uBo/omMjT+KLA/FcGkppFpVlehe1jR3gmNyt0io/E6GpNCwgq4U3/oSf1Kpyye33byHu7+7WQ2CzgAmidMqBkSxCwAqP4baoh0bsm43aEuOmnU0J2byYIz5PwFJ3eOnLFpf8mVDqiDqbsP2BGn08JpP9hW++XtgqIq0xAFiSu0r7I3nRJx29W4huc0eiswD6m/sbPo0bcaWEP/WrDRNlbKqNjkaoQdmQB0PliEHVoXIq1zTP/aRTjhcjIkhmstVzrc24aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs9AkcxfiIxXmopJjWnpOsPNuPB7OMKe/aLBwAZmA90=;
 b=AWPHmqDMiOw0+/KPWZyXUJUyX/E3R849g8RQodTu9m24zchlVHcYGbnvfvUw/3SWHwQ8AtVjwKh7RrIu/baq3DsOK6aAuzad7pf9YjYzYq0i3x4hU/gQ8PhgsgjTVW9Kmndsner8W1icF2JAaYwNPea3SG0Wbn+paUhEiAvMszWmg8h+BXGRKO3kj04JuOIZ2ndz/t9pQpjaSSbKSOkwjLICL9kHv3z4JzEdwnX4wx6WXW9MhOlDKCiE5oXLscf9+IgE007pn4xgZqQZMw7GwvWJgrL8yd4CpYk/T1pCRDk72krFRxwrq6HxgbgOxudVIawt91rQV2jdUraEc4XOHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs9AkcxfiIxXmopJjWnpOsPNuPB7OMKe/aLBwAZmA90=;
 b=l6y5ij/M1uCUAYily6eBjofESts6fBUujHGHVGGQb/KK+/EVMrxJ8Jt9BHxaghtLw9FjzBUp/Ww8Fiu0w0fxMrBsJS6wU3jrVu8xhJ9sdePGwMs0MSZiCL0s1xONCzq3exUWHRm+2XuxT0byzl1pWn+9HoZ4WJ1WBYyKtVLAT80=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM6PR11MB3868.namprd11.prod.outlook.com (2603:10b6:5:19f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 05:08:17 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18%7]) with mapi id 15.20.4173.020; Wed, 26 May 2021
 05:08:17 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] io-wq: Fix UAF when wakeup wqe in hash waitqueue
Date:   Wed, 26 May 2021 13:08:26 +0800
Message-Id: <20210526050826.30500-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: SJ0PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::16) To DM6PR11MB4202.namprd11.prod.outlook.com
 (2603:10b6:5:1df::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by SJ0PR05CA0041.namprd05.prod.outlook.com (2603:10b6:a03:33f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Wed, 26 May 2021 05:08:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc365c22-7570-479f-563f-08d9200445ac
X-MS-TrafficTypeDiagnostic: DM6PR11MB3868:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3868AF9E82119E7BB69F09D4FF249@DM6PR11MB3868.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /uY1Atlp3AZXQWBUFLKv6wcYu2y7DAPBTgHXNd83xm0CZFROni30aS4ZY+slWmu1CqRLX/UGFA2GoiP6qzTNG1mHRJhC1F1wCgRBavKxzABdmQPjmShTiIvoSYGTeo+/b1vIeB/EZA70RfjnwDQaWjCyXxBTI5Ta7bInTbE3EUNGBnsg+wNf8yyo69o4O5DEM4xA0lcbT4XFMzYhkqv4A78xpvRJJ0B0I2kW1jFQTDuXmwg3uh5gFRX0TJpyyGITwb7L0B9A6JrhGFZAum6u50LyH6F2IrsoeNqrUM578U1+hBMRoxNA+XqXmstxiXKUJkm/Axy2w0DhjmIdCwMZaI54tNCBDvqpSvq7eAAYFftDq9T7cUniUp4SDs2jalI9QsVrt/gydEXI6R8X2cLpNabqo+CnVXlHPtZJ5dFOkDbZexzbJVQrtwpbA0ITu3r1Rb6/LIBdfJ797CAa0/48r3K8v/fkTdYHP6fcdZHtHYeY0LEb2REXRdtE/HH64XgClrqx4rwveA2put/Jw1w57YdgZebuhtWPoEOzm1jTJKovub2GGpdEMasEhPusMVaT6dGclx8Qg3xZb8ilaUnsHd9L3UecXlc8QsQiBybgpXdoK0c1rUIlQIDCSUIomSKrgoOgvI8EFGhekSmK9bKi8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(39850400004)(346002)(6486002)(8936002)(8676002)(2906002)(4326008)(38350700002)(316002)(9686003)(26005)(38100700002)(478600001)(66476007)(6512007)(36756003)(83380400001)(186003)(66556008)(6666004)(66946007)(52116002)(2616005)(86362001)(956004)(16526019)(1076003)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q+wtDaOTthjVZXrEAdzBClYgKuZzut0JhIrpW++b3lDrsNZlERdyXJIAwoh9?=
 =?us-ascii?Q?tkaGQy5w1gkmsPjRmoNk+nlUKPw+bnPmrRFfrEaZFSSYKSEYQGgepybH4m01?=
 =?us-ascii?Q?/SGAF7lJejV0VXTaz4v4JgDpmOb/LAGn1BrciRcZQe+P+JpWSwp73nGGrCjs?=
 =?us-ascii?Q?uXPQQm43IprJZFbumSvEfEEE3oVR/QWGl74vhWZKBVmkcMyZW3aeNuMYhRYX?=
 =?us-ascii?Q?0WgQG8K4l0XsqL16U7AzR5lFmS0X3U8Ffo1Ci5gnNO+FrcRr9wgypUx8cgMB?=
 =?us-ascii?Q?frOdKS24PqJKGZR3yaJdrPhmdVoaYZ3Rg4zAY81E+SSxCU1oW+cu3r90n2d1?=
 =?us-ascii?Q?Q6fl/srowx2vz0+Xuiv/IKplrTLIBOrbZ6HmE9s9Jp62zt7C2R41ppgqn74y?=
 =?us-ascii?Q?+gnGH/+DbitFc5fUmsFlnZ0UPs/HnqheOav2ohBGcI4R4JkJ7IwiOPomKHQU?=
 =?us-ascii?Q?Dw022D+fU6ST14Qt1B9/wGNt3QOHhUUpDKUYMD+haw1M0RhNVievOJ5KcQl4?=
 =?us-ascii?Q?buww212aMVErgILgbLrDH9I+PeUC7aL+x7Cwog8dVb1ueuf1vY37KXsP2fHq?=
 =?us-ascii?Q?9yPRP+LhlqYSI6HaRZkrKVdM5cqfh1MaHtWVKyGZC0q/7cMqYNTWkHnmUf2I?=
 =?us-ascii?Q?4DMnC10Xy4KN2igPJoLvDMNjXhnJ2rTA73tM5z1T5Cy7vn2EDRsEcYqvcqy0?=
 =?us-ascii?Q?ubl+PYs3Gh1c/ZW/ExPbsUwfjzgSVo6b4L9vzE5WjuoPKUTdEZKBzaF1yxqw?=
 =?us-ascii?Q?Dvck/UqAY2x2+ZEH+712uaGDvwPE9cqgWQtQdO+NLxckeKdAHFNbPkgV+KGJ?=
 =?us-ascii?Q?30sN7/qfFl9gVscQSdYLMO/GVSIRjQq0fUT/3PtNAOrqKPNHGo6Efve5jcBD?=
 =?us-ascii?Q?oSArVXN8nOrcoBcRjM1u4iN3OOAF3uSj7Y/K3p3VEDQAjJCtnTwrv7yhEbiW?=
 =?us-ascii?Q?/p8q0tGaVpgmSN0j3sGP0aAlcCaHBuj5au6k85Vixh/szYXabmkgVFjIU16a?=
 =?us-ascii?Q?5EgQgXcy4h6/hIZ8rxU1nI4i/dbsmKY/fNcVu2OzKV0oGbD/egjPAXFPyXnh?=
 =?us-ascii?Q?NPfMQk0/DLge1udjP7/WWEFOfpYtgEn73RVkqvX0+H8SLhVbthLPWYRie9sc?=
 =?us-ascii?Q?0c2uh9oIoEwuUQwNR5Lo2uZq62vz6ljzR23ClPkWL9jmx0at8mDziHxAOLz4?=
 =?us-ascii?Q?BBwv09Dnt3x3L6Hz08RtlxOHBx3RvGtEt/y1PWBCUoGPl4vLg1I0LVaNVUFF?=
 =?us-ascii?Q?n2y8vUp8DqIoBCn7BDtMq2e48nu23BmPSMTQJO7AJujgEuJ0Pn5+dZsMo5qq?=
 =?us-ascii?Q?lLvwaKSbqbXGMV3VWShQEnUO?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc365c22-7570-479f-563f-08d9200445ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 05:08:17.5303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVj+UYvDKD2vPMXGSGvewxa4ulHnuLqe6BjAZcSx7oWZW7M33J3l7K1ZsUb9FGzHMvL5SYh/xgWmES4QZlA0uE08wX7KHcCM3/R2IIyiJEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3868
X-Proofpoint-GUID: 7HrPRDEShhk61aJPyThbujN_vA5fCGnP
X-Proofpoint-ORIG-GUID: 7HrPRDEShhk61aJPyThbujN_vA5fCGnP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_02:2021-05-25,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260034
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650
Read of size 8 at addr ffff8880304250d8 by task iou-wrk-28796/28802

Call Trace:
 __dump_stack [inline]
 dump_stack+0x141/0x1d7
 print_address_description.constprop.0.cold+0x5b/0x2c6
 __kasan_report [inline]
 kasan_report.cold+0x7c/0xd8
 __wake_up_common+0x637/0x650
 __wake_up_common_lock+0xd0/0x130
 io_worker_handle_work+0x9dd/0x1790
 io_wqe_worker+0xb2a/0xd40
 ret_from_fork+0x1f/0x30

Allocated by task 28798:
 kzalloc_node [inline]
 io_wq_create+0x3c4/0xdd0
 io_init_wq_offload [inline]
 io_uring_alloc_task_context+0x1bf/0x6b0
 __io_uring_add_task_file+0x29a/0x3c0
 io_uring_add_task_file [inline]
 io_uring_install_fd [inline]
 io_uring_create [inline]
 io_uring_setup+0x209a/0x2bd0
 do_syscall_64+0x3a/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 28798:
 kfree+0x106/0x2c0
 io_wq_destroy+0x182/0x380
 io_wq_put [inline]
 io_wq_put_and_exit+0x7a/0xa0
 io_uring_clean_tctx [inline]
 __io_uring_cancel+0x428/0x530
 io_uring_files_cancel
 do_exit+0x299/0x2a60
 do_group_exit+0x125/0x310
 get_signal+0x47f/0x2150
 arch_do_signal_or_restart+0x2a8/0x1eb0
 handle_signal_work[inline]
 exit_to_user_mode_loop [inline]
 exit_to_user_mode_prepare+0x171/0x280
 __syscall_exit_to_user_mode_work [inline]
 syscall_exit_to_user_mode+0x19/0x60
 do_syscall_64+0x47/0xb0
 entry_SYSCALL_64_after_hwframe

There are the following scenarios, hash waitqueue is shared by
io-wq1 and io-wq2. (note: wqe is worker)

io-wq1:worker2     | locks bit1
io-wq2:worker1     | waits bit1
io-wq1:worker3     | waits bit1

io-wq1:worker2     | completes all wqe bit1 work items
io-wq1:worker2     | drop bit1, exit

io-wq2:worker1     | locks bit1
io-wq1:worker3     | can not locks bit1, waits bit1 and exit
io-wq1             | exit and free io-wq1
io-wq2:worker1     | drops bit1
io-wq1:worker3     | be waked up, even though wqe is freed

After all iou-wrk belonging to io-wq1 have exited, remove wqe
form hash waitqueue, it is guaranteed that there will be no more
wqe belonging to io-wq1 in the hash waitqueue.

Reported-by: syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
---
 v1->v2:
 Modify commit information

 fs/io-wq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5361a9b4b47b..911a1274aabd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1003,13 +1003,16 @@ static void io_wq_exit_workers(struct io_wq *wq)
 		struct io_wqe *wqe = wq->wqes[node];
 
 		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
-		spin_lock_irq(&wq->hash->wait.lock);
-		list_del_init(&wq->wqes[node]->wait.entry);
-		spin_unlock_irq(&wq->hash->wait.lock);
 	}
 	rcu_read_unlock();
 	io_worker_ref_put(wq);
 	wait_for_completion(&wq->worker_done);
+
+	for_each_node(node) {
+		spin_lock_irq(&wq->hash->wait.lock);
+		list_del_init(&wq->wqes[node]->wait.entry);
+		spin_unlock_irq(&wq->hash->wait.lock);
+	}
 	put_task_struct(wq->task);
 	wq->task = NULL;
 }
-- 
2.17.1

