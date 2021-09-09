Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D81404D5D
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241588AbhIIMCC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 08:02:02 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:48932 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345849AbhIIL75 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 07:59:57 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1899nqdq017605;
        Thu, 9 Sep 2021 11:58:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=G8kwzedl3RCJR8pBQ+BkegapjU8vs3UmuYre/bhwvjU=;
 b=O7gKXUsX2/k8MEsTOb5LsH24/RRoPq8x+vxQu3h8NbWCPwgpR6pVzhriYoC4pgxrJnM9
 ltC/lx5uyLvggGWdl+zeNJTAbWi5VjjTVEs0QpEdMMv4b1YrjLind3RK+vx15MZR6fRf
 tdQmIqJ2d9ezEQCkg7Rjgw31TahdX1LLn4OuCTItjqRS5XAPYJ4iB8LDCsrRiX7bEU8V
 pHWR8BseOD1VenR/Fh5C2t3FTDGwXd65jbuGLehYmpP7qdu/gyiGfjM/CZGWEPGEaJfv
 x+F2YfQwv7qIezHHIQIlsumuMWhV8qUj5++V+1e9DaPJCxBeqRoKCT1JqZMfXPjSJzdw Iw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ayaf2r8rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 11:58:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSXTUazDgVhx5qWLdKFhBvEO5xDoIH0BZi2NRfqHv/4ZA/MtiFhXHOWBXXI5VAib4J6+BniJ9bYfX7bbhOl2WJZce1uXnBTmQOsi5aK5rhECAWFodG/pdRLd7BqdY4a6M5lJfQ12w/KtLrLQ1+spwglbuTRKSWUsukb6BELlDbrv5jfP+s2ExrGUd1jx+dUjbLLJuSIsExZzBT5AdiDk3+2p2XGBknxLyDv/iFeS9zbA2mIC9tu5nwMwrrFGR+s/eCEwX+t53iESCRKSsroxKsbhPUfcyTq7wDTUOfv0fsaA7yUrUzbKxeMy40xFdS6nG8dO8C/UlKkzBQ38lWaymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=G8kwzedl3RCJR8pBQ+BkegapjU8vs3UmuYre/bhwvjU=;
 b=aBpKQHWdXnHausExq5GO32Tv9y/BsY+29uELujbGXIvFf0+993W8e45dU6cg/NDrJi5PPlWMH5tggnPfPTQQc+0zZeufoD1XgGQZT3Ms1Bt95jePU33Jimyvh3TZA5Eswf7dbidgmR4zPkm3ZAjRpVW3YA/+2ExPg/Vn9bq/NpQ2ctSzBq3myGr4CFQjHmiDLpveouvJGnIabW5qhrAb+phFmpBYBw9iYCXU5m/AVKcj0Wi44NYczWktYhoKmrMB7wPXpavfta98U4TOGg5/r6jndxSKFmBgRakC64mxkMa9VrPDDU08G592cg1YUM9mGHJ4zsSj2yZ34+hchMvSqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from BL1PR11MB5478.namprd11.prod.outlook.com (2603:10b6:208:31d::12)
 by MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 9 Sep
 2021 11:58:41 +0000
Received: from BL1PR11MB5478.namprd11.prod.outlook.com
 ([fe80::19db:ee0e:abd0:df6d]) by BL1PR11MB5478.namprd11.prod.outlook.com
 ([fe80::19db:ee0e:abd0:df6d%8]) with mapi id 15.20.4478.025; Thu, 9 Sep 2021
 11:58:41 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: fix memory leak in create_io_worker()
Date:   Thu,  9 Sep 2021 19:58:22 +0800
Message-Id: <20210909115822.181188-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0118.apcprd03.prod.outlook.com
 (2603:1096:203:b0::34) To BL1PR11MB5478.namprd11.prod.outlook.com
 (2603:10b6:208:31d::12)
MIME-Version: 1.0
Received: from pek-qzhang2-l1.corp.ad.wrs.com (240e:305:2582:5de7:b861:3e32:b738:ea47) by HK0PR03CA0118.apcprd03.prod.outlook.com (2603:1096:203:b0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.13 via Frontend Transport; Thu, 9 Sep 2021 11:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d55fcfa4-b23e-4222-eedd-08d973892a94
X-MS-TrafficTypeDiagnostic: MN2PR11MB4598:
X-Microsoft-Antispam-PRVS: <MN2PR11MB4598EDA2237F6B5785BA7374FFD59@MN2PR11MB4598.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlNCbYhJuYLkmukgo9a2Pss1ZYuEExjZ8jjqqvNj4Bgipv0wjMnK7nq09oFtPq4A913jexFVC2QUTJ72NJQ8PnVFzuSJKZgmxRz4dcNUu/Eor5gARMvGH9XZU02Ys+8cEHsxnv3WOxZFU8SVsVIDDtvm61LKEtNZqFlWzYTkSDrTtR02uoz/BLNnhHv6zUQXHeFZSTfEDK9S18saEYPZnoXwHCxN1XaS0qgAdsJaav6v/XieiBozob/MV38zzL7d5uVW5kl05XQg5BEpbbXow8qRUgCPdfVB2sRAlHhu0clDqRccT6sYHxToqBrURIkegBEfrHmxbOnVty1IbcvjeZvl04yWtLLWgGf4vH1AemFWhZVULbW/UDvWKQFVG+k52MZcFUsYf6QG1U8BSXDMqhgt+c31k5Yrtnny6frw/jXS5Wod+XkuIvcy8BjEUpzy2Jvb2FNUaOfasha35hZshv95zi/eA6m8ez5wkk5F6VBgzvLaf1jMaV1XtJcLesjkbK4yRyBruMTfdbYwHBmq2ZmH3EV9nJ4DQa/OnWBDNjbxCYvbDnkyDEO54LnoiSgxJuuth4tm0rao4NYtA/9GKszxWGRZaQRXK3mc7CjVW2T0xxFNRbgOlEe+OKDGmjMdQMN5fe37Vkyww92KQSEZaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5478.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39850400004)(376002)(8676002)(2906002)(6486002)(6506007)(6512007)(9686003)(66476007)(316002)(5660300002)(66556008)(52116002)(66946007)(83380400001)(4326008)(6666004)(36756003)(1076003)(2616005)(38100700002)(478600001)(86362001)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wgCzcN3ieepT4Yh+VkPttWbCP6SJQDpBsE1FBYJThwUgNR4e0CD0ysJWl2p0?=
 =?us-ascii?Q?k3mfUYmoNlA6aNOA6093Tn/0QNYO9hoYcVP6f7lsMV6FuFHDtpm2XXX2zI99?=
 =?us-ascii?Q?3t3iMuNAks+UtTV0Z7ZHIJP1ejS3PiczSD3h08GBbHWmw1QQ1hTFc17/47QP?=
 =?us-ascii?Q?m6HsAorXYnbD6rcEasR+SHVgP2DsCBdaLB0hWy+MpfjQyf5CwJQqLydEQGnu?=
 =?us-ascii?Q?ChWdgs6lt90qQmJBfT9lXJsnB7Bd/iz1OxSIp392GUWx2CIQQ3iBNRDP+YXw?=
 =?us-ascii?Q?AaZezMkSu7/ywXdnJuUdHZmC3cEMfZvcYCMYdlU9FZNJwTNtaEUV55v1P6/D?=
 =?us-ascii?Q?pL/L+fmhr/1RF2lU7ceQmJqxhmb06Cr+r4Mt+4TNPw23goyhu95oLAlqaNGT?=
 =?us-ascii?Q?wMoTzblf19zakId1Y2tXszw4m7DFzaeWSXXi2SqdXpPQ0OdlXpjrd1/hCqHe?=
 =?us-ascii?Q?75kcHGlNMtvLLohE8NYqcmotbQbWctbtipQLKpeEdTMomfZ/LLgA0q0dfG9/?=
 =?us-ascii?Q?+TsLY5ZrrWfm6BNKhUluFMwz72BGMyuhkYJeu5i9l2p2Wwm2aABXSAIVy48/?=
 =?us-ascii?Q?4fd4IjZxQzVbJzond+wFUboJC0LkMuroB6l4i+wuZFknRPKqhJW5cGadeauE?=
 =?us-ascii?Q?DIxEwvPDNxvY7eSS6pCBSXG3wxlYeA/Jny6XMfLrhx3Z+v4RcEabwe46vjx8?=
 =?us-ascii?Q?3tqHf9tzStJKZzDIXZunq074tE58IaJD3VShLG6fHIMUBG5ExosVGynsY4BS?=
 =?us-ascii?Q?FT7G1UxL6ME76iwQOmwNrBBYuKzYwhhfE8N34+IjGZVhTAgkxlNBpJhhyw9/?=
 =?us-ascii?Q?Zsz7SQba+Cp54dPcbUvY8AYYISXalwxKYWE4p7pMy7KQbZL34nHhLCzr3wkD?=
 =?us-ascii?Q?7URiLwe65MuSq1Hn35pH1W7vpAleTwVn4q3BJC+LqqJdmgel8Gm0P6WVmlkV?=
 =?us-ascii?Q?dAWTAYDzZz37cefDnV/147/L/laTBW77+JBrEI5sjRPMvx0I59eqgiUW/DYg?=
 =?us-ascii?Q?EGSKz4LgN9IFTmLXHRvnaaBFUmq7EFjYJBagylPuKXFY+ObSAHrSrkJtQFnd?=
 =?us-ascii?Q?BlLNykModo28fMDeG/oWVDowP5S3v+ABduJwBaDt9n0ySH+xf4JN91GsrNra?=
 =?us-ascii?Q?9KFj/d2AleBnfkfysXIoUcNQm+0RPlkt70e7yiXWmCzuS/fVif4/X20w5OCW?=
 =?us-ascii?Q?6GcltvryffX3lTNU9rT4EkoQvpjqlwnjXzms9yXkqg55r0h+7+ah+7PEo4PR?=
 =?us-ascii?Q?JmRnd066QaCbB7DKABA2t/xGtLkrPZiUh5kmK/TaBxLfiZOsj95/FUn8ejry?=
 =?us-ascii?Q?+n8MEDWr4E171FjjvIl3LWhuNBAtlsFTB+Hm/4W4MmLzpBz2/Tlf2a0UiA6r?=
 =?us-ascii?Q?hJg/HX/krow+A9axxoU6A8vo3zJd?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55fcfa4-b23e-4222-eedd-08d973892a94
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5478.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 11:58:41.5476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuNjuWOzIUllfJbv9xZOwAjgfocuR2OVaEJyNEWaDY2oXNeugMZFzC9Byrw1l2QIVkE7FkduKJ8AT7spdeR+BzchuclDGQy86DXzvGpYsQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-Proofpoint-GUID: qlTZxRVfmKrNzgPr6wZM_osuCONTXvn9
X-Proofpoint-ORIG-GUID: qlTZxRVfmKrNzgPr6wZM_osuCONTXvn9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-09_04,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=909
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090073
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: "Qiang.zhang" <qiang.zhang@windriver.com>

BUG: memory leak
unreferenced object 0xffff888126fcd6c0 (size 192):
  comm "syz-executor.1", pid 11934, jiffies 4294983026 (age 15.690s)
  backtrace:
    [<ffffffff81632c91>] kmalloc_node include/linux/slab.h:609 [inline]
    [<ffffffff81632c91>] kzalloc_node include/linux/slab.h:732 [inline]
    [<ffffffff81632c91>] create_io_worker+0x41/0x1e0 fs/io-wq.c:739
    [<ffffffff8163311e>] io_wqe_create_worker fs/io-wq.c:267 [inline]
    [<ffffffff8163311e>] io_wqe_enqueue+0x1fe/0x330 fs/io-wq.c:866
    [<ffffffff81620b64>] io_queue_async_work+0xc4/0x200 fs/io_uring.c:1473
    [<ffffffff8162c59c>] __io_queue_sqe+0x34c/0x510 fs/io_uring.c:6933
    [<ffffffff8162c7ab>] io_req_task_submit+0x4b/0xa0 fs/io_uring.c:2233
    [<ffffffff8162cb48>] io_async_task_func+0x108/0x1c0 fs/io_uring.c:5462
    [<ffffffff816259e3>] tctx_task_work+0x1b3/0x3a0 fs/io_uring.c:2158
    [<ffffffff81269b43>] task_work_run+0x73/0xb0 kernel/task_work.c:164
    [<ffffffff812dcdd1>] tracehook_notify_signal include/linux/tracehook.h:212 [inline]
    [<ffffffff812dcdd1>] handle_signal_work kernel/entry/common.c:146 [inline]
    [<ffffffff812dcdd1>] exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
    [<ffffffff812dcdd1>] exit_to_user_mode_prepare+0x151/0x180 kernel/entry/common.c:209
    [<ffffffff843ff25d>] __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
    [<ffffffff843ff25d>] syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/common.c:302
    [<ffffffff843fa4a2>] do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

when create_io_thread() return error, and not retry, the worker object
need to be freed.

Reported-by: syzbot+65454c239241d3d647da@syzkaller.appspotmail.com
Signed-off-by: Qiang.zhang <qiang.zhang@windriver.com>
---
 fs/io-wq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 35e7ee26f7ea..27fa0506c1a6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -709,6 +709,7 @@ static void create_worker_cont(struct callback_head *cb)
 		}
 		raw_spin_unlock(&wqe->lock);
 		io_worker_ref_put(wqe->wq);
+		kfree(worker);
 		return;
 	}
 
@@ -725,6 +726,7 @@ static void io_workqueue_create(struct work_struct *work)
 	if (!io_queue_worker_create(worker, acct, create_worker_cont)) {
 		clear_bit_unlock(0, &worker->create_state);
 		io_worker_release(worker);
+		kfree(worker);
 	}
 }
 
@@ -759,6 +761,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		kfree(worker);
 		goto fail;
 	} else {
 		INIT_WORK(&worker->work, io_workqueue_create);
-- 
2.25.1

