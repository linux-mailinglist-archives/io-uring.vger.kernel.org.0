Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9766E7B10C5
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 04:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjI1CbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Sep 2023 22:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1Ca5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Sep 2023 22:30:57 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A66102
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 19:30:55 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230928023051epoutp012cbd3d8cb1daaea13b44cc3dff67abb1~I7zCcTU0g2374223742epoutp01e
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 02:30:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230928023051epoutp012cbd3d8cb1daaea13b44cc3dff67abb1~I7zCcTU0g2374223742epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695868251;
        bh=WTFp5Vr5HivTWCAVmF3NpzIT1Lf+kl+P72Qzrl5ReU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJovRlm90U27App2zIv+RwExHtWMHY58jCgaD0Y9+lF5bZjGyLqpMvd4RbdgVkHi8
         m82y6WuVl0ot4lYaqMhPnvixxqHmu/WHltOWpaAjMXfvwnNJ9K+AhKYhNrtLRn6A69
         KMllS4jTltpi9QO9JF6Ycn5cPFGx4EidNcmNiESI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230928023051epcas5p3bb33ed4fac719af1ef5da9dbde1d462a~I7zB7wbo_0480204802epcas5p3w;
        Thu, 28 Sep 2023 02:30:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RwyBx645Wz4x9Pv; Thu, 28 Sep
        2023 02:30:49 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.8C.09638.955E4156; Thu, 28 Sep 2023 11:30:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230928023007epcas5p276b6e029a67001a6ed8ab28c05b2be9c~I7yZllfei3125231252epcas5p25;
        Thu, 28 Sep 2023 02:30:07 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230928023007epsmtrp27b4006b9f4955f51fedfe4f3bec4afa6~I7yZkeGmo1134711347epsmtrp2t;
        Thu, 28 Sep 2023 02:30:07 +0000 (GMT)
X-AuditID: b6c32a4a-6d5ff700000025a6-af-6514e5594fc0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.9B.18916.F25E4156; Thu, 28 Sep 2023 11:30:07 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230928023005epsmtip16085199ca976dd349f984fe31ae0ee3a~I7yXilTaC1182111821epsmtip1C;
        Thu, 28 Sep 2023 02:30:05 +0000 (GMT)
From:   Xiaobing Li <xiaobing.li@samsung.com>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, axboe@kernel.dk,
        asml.silence@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, kun.dou@samsung.com,
        peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com, Xiaobing Li <xiaobing.li@samsung.com>
Subject: [PATCH 1/3] SCHEDULER: Add an interface for counting real
 utilization.
Date:   Thu, 28 Sep 2023 10:22:26 +0800
Message-Id: <20230928022228.15770-2-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928022228.15770-1-xiaobing.li@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxbVRjGPfdeLoWleFdQzkoUrKCBDWih1MOkZJnMdB8mqMnmxxQr3BVC
        abveVoczE8cIjI1RMYAyWCoYXAAZ30KFgnS4McKQMmR8dKNhTBgZLgzohAn2A9z++71Pnue8
        ed9zDgvnLJFcVopCQ6sVUjmP9CRaTMHBoe9P+9B8w3AIKq1qAajakk8i89QwiYpnvybQtK4Z
        R/NZ1wnUs36fRJb8QgKtnLEA1Ly45IbaO3oJNGQoJdG383cBMnfpMXS3wwNdyevCkDFnEkOL
        Jps7yrm8jKPmHjsVNrViKOfUENj1vKTmQg2QtJVY3CWnjGPuEn2DVtJ4MUQy1K+VTPzZTkr+
        Ng6TknNNVUDS2Hdc8rDhxfgtH6TGJNPSJFodQCsSlUkpCpmYt//dhDcSokR8QaggGr3GC1BI
        02gxL+5AfOibKXL7qLyAz6RyrV2KlzIMLzw2Rq3UauiAZCWjEfNoVZJcJVSFMdI0RquQhSlo
        zU4Bnx8RZTd+kpp89ncTpmr3P3azxURmgJltuYDFgpQQdtkic4Eni0P9CmBm/pibq1gA8Lvx
        2SeFac5IbCbaFt9y6W0A5tTfI3OBh72YBbBaL3MwSW2HI7W5zrAPdRqDhorbzgKnCjBY0zTg
        5nB5U29DXVMZ7mCCCoLzt0fdHcymYqCx5wcnQ8ofdv7W7/R4UGLYueDqxqa2wt7v7xAOxu2e
        zObzuKMBpB6xYFllC+4Kx8HR9dYN9ob3rjRtHMqFD+c7SBcz8PJZm5srnAFg8fjwhul1uHaj
        3TkzTgXDS4Zwl/wCLLxWi7kae8G81TuYS2fD1gubHASrzVbCxX5wLmN1Q5fAgqUOwrU7HYCN
        Q9OEDgSUPDVQyVMDlTxprQd4FdhGq5g0Gc1EqSIU9Of/X3OiMq0BON9/yL5WYJ18ENYNMBbo
        BpCF83zY1nEOzWEnSdO/oNXKBLVWTjPdIMq+8W9w7nOJSvsHUmgSBMJovlAkEgmjI0UCni97
        LqssiUPJpBo6laZVtHozh7E8uBmYYOG9HdHlkUU5+yxj5Z6HZaJyc2/gRGH1lilr4qGpkfTA
        OX+/omf8WYNFR34R3jxyML3w/OSOL7MrXjmUvkvc/tdFbn/tat/eSs6/5h8De2vrmFumvXXL
        XO/jvMndsYa6j9AJ6YCmzsdXXO/lYd2zrnu0vEeXt3XBPLJz8J2rsfkdK7HZayeE3iM/v2zO
        Crp0ru7W/Q+jt1ungtsGoG62P25guuLqT8zH1mJ0Mk45OJGYWW8k5Zr9+YEzUUE3Ho/qY2wr
        fuNHDV+tvmr6tPYl/rWBx6UWvc0a3nny+gP3f5J9Q9aHThcU/XFs3VZ58PDE2rNGr/qw7KNT
        vcKZiD5wQHRm9yqPYJKlghBczUj/AymX3x6IBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnK7+U5FUg4UTDCzmrNrGaLH6bj+b
        xaXHV9kspr9sZLF4OmErs8W71nMsFkf/v2WzuNs/lcXiV/ddRoutX76yWuzZe5LF4vKuOWwW
        k989Y7S4dGABk8WzvZwWx3sPMFns63jAZPHl8Hd2i44j35gtth4FsqZu2cFk0dFymdFBzGPN
        vDWMHjtn3WX3aNl3i91jwaZSj80rtDwuny31uHNtD5vH+31X2Tz6tqxi9Nh8utrj8ya5AO4o
        LpuU1JzMstQifbsEroyeY4eZCvbIV9zYdpitgfGFZBcjB4eEgInEzi++XYxcHEIC2xkljn6d
        wwgRl5b486e8i5ETyBSWWPnvOTtEzXNGiU+HG5lBEmwC2hLX13WxgtgiAjOZJCb8iAQpYhaY
        xyTRe+MuG0hCWMBfYvav9YwgNouAqsS7+zfZQWxeARuJfUcXskNskJfYf/As2FBOAVuJ/Z9e
        sYEcIQRUc2SlO0S5oMTJmU9YQGxmoPLmrbOZJzAKzEKSmoUktYCRaRWjaGpBcW56bnKBoV5x
        Ym5xaV66XnJ+7iZGcExqBe1gXLb+r94hRiYOxkOMEhzMSiK8D28LpQrxpiRWVqUW5ccXleak
        Fh9ilOZgURLnVc7pTBESSE8sSc1OTS1ILYLJMnFwSjUwya/1EHQUdczbk1/obSQtXKcdVflS
        l135xNtJ/A4CL1eb563qOegYELrujh3Xj6fLjrVe7VkjfHtm45snIsocYdNPtffFPEv0qlu0
        v/1p2u3WeUdLz9ctr2c1bDOYspP5SdIZh6kbLeszp22bHCj6X7vt47ZjS4zP8b52M+l7dFHX
        bId/4dHGbZUL/zJenxPWHqbedm7HwjkudhmMi6q3vjn1N/N+y0HOpWkTPf6fYBFM5rglsvWW
        i2H1ZdfAnIMXK+a933n39wnnyM/h63NXhd+sqfm+JD+tQadkY1bypR3aMuZ5/aFOhy7uV1m1
        O+5IaFW3YWf6cyNNzb9Vi9xvXpN4vni1jc4Pu4DY0C9MSizFGYmGWsxFxYkAWRRgXjgDAAA=
X-CMS-MailID: 20230928023007epcas5p276b6e029a67001a6ed8ab28c05b2be9c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230928023007epcas5p276b6e029a67001a6ed8ab28c05b2be9c
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
        <CGME20230928023007epcas5p276b6e029a67001a6ed8ab28c05b2be9c@epcas5p2.samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since pelt takes the running time of the thread as utilization, and for
some threads, although they are running, they are not actually
processing any transactions and are in an idling state.
our goal is to count the effective working time of the thread, so as to
Calculate the true utilization of threads.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 include/linux/kernel.h |  7 ++++++-
 include/linux/sched.h  |  1 +
 kernel/sched/cputime.c | 36 +++++++++++++++++++++++++++++++++++-
 kernel/sched/pelt.c    | 14 ++++++++++++++
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cee8fe87e9f4..c1557fa9cbbe 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -37,7 +37,8 @@
 #include <uapi/linux/kernel.h>
 
 #define STACK_MAGIC	0xdeadbeef
-
+struct cfs_rq;
+struct sched_entity;
 /**
  * REPEAT_BYTE - repeat the value @x multiple times as an unsigned long value
  * @x: value to repeat
@@ -103,6 +104,10 @@ extern int __cond_resched(void);
 
 #elif defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
 
+extern void __update_sq_avg_block(u64 now, struct sched_entity *se);
+
+extern void __update_sq_avg(u64 now, struct sched_entity *se);
+
 extern int __cond_resched(void);
 
 DECLARE_STATIC_CALL(might_resched, __cond_resched);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 77f01ac385f7..403ccb456c9a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -583,6 +583,7 @@ struct sched_entity {
 	 * collide with read-mostly values above.
 	 */
 	struct sched_avg		avg;
+	struct sched_avg		sq_avg;
 #endif
 };
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index af7952f12e6c..824203293fd9 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -479,6 +479,40 @@ void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE: */
 
+void get_sqthread_util(struct task_struct *p)
+{
+	struct task_struct **sqstat = kcpustat_this_cpu->sq_util;
+
+	for (int i = 0; i < MAX_SQ_NUM; i++) {
+		if (sqstat[i] && (task_cpu(sqstat[i]) != task_cpu(p)
+		|| sqstat[i]->__state == TASK_DEAD))
+			sqstat[i] = NULL;
+	}
+
+	if (strncmp(p->comm, "iou-sqp", 7))
+		return;
+
+	if (!kcpustat_this_cpu->flag) {
+		for (int j = 0; j < MAX_SQ_NUM; j++)
+			kcpustat_this_cpu->sq_util[j] = NULL;
+		kcpustat_this_cpu->flag = true;
+	}
+	int index = MAX_SQ_NUM;
+	bool flag = true;
+
+	for (int i = 0; i < MAX_SQ_NUM; i++) {
+		if (sqstat[i] == p)
+			flag = false;
+		if (!sqstat[i] || task_cpu(sqstat[i]) != task_cpu(p)) {
+			sqstat[i] = NULL;
+			if (i < index)
+				index = i;
+		}
+	}
+	if (flag && index < MAX_SQ_NUM)
+		sqstat[index] = p;
+}
+
 /*
  * Account a single tick of CPU time.
  * @p: the process that the CPU time gets accounted to
@@ -487,7 +521,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 void account_process_tick(struct task_struct *p, int user_tick)
 {
 	u64 cputime, steal;
-
+	get_sqthread_util(p);
 	if (vtime_accounting_enabled_this_cpu())
 		return;
 
diff --git a/kernel/sched/pelt.c b/kernel/sched/pelt.c
index 0f310768260c..945efe80e08c 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -266,6 +266,20 @@ ___update_load_avg(struct sched_avg *sa, unsigned long load)
 	WRITE_ONCE(sa->util_avg, sa->util_sum / divider);
 }
 
+void __update_sq_avg_block(u64 now, struct sched_entity *se)
+{
+	if (___update_load_sum(now, &se->sq_avg, 0, 0, 0))
+		___update_load_avg(&se->sq_avg, se_weight(se));
+}
+
+void __update_sq_avg(u64 now, struct sched_entity *se)
+{
+	struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+
+	if (___update_load_sum(now, &se->sq_avg, !!se->on_rq, se_runnable(se), qcfs_rq->curr == se))
+		___update_load_avg(&se->sq_avg, se_weight(se));
+}
+
 /*
  * sched_entity:
  *
-- 
2.34.1

