Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249AC7B10CC
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 04:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjI1CbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Sep 2023 22:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjI1CbI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Sep 2023 22:31:08 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EABF191
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 19:31:02 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230928023057epoutp0205b1976b73e404d7d8102ac18bc3c792~I7zIF2DB61142811428epoutp02Z
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 02:30:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230928023057epoutp0205b1976b73e404d7d8102ac18bc3c792~I7zIF2DB61142811428epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695868257;
        bh=phR98v9y8l1Bi3dNmiWC+zZrMiNiEm3JGyrCS7t+Eok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVqyCjSfVkpXkZtNLYrxJ+uKezwBblPMudywJ24y5fU5AbIySzy6rYRbjenHUXgjR
         VYgHS76D+LlWY3GnXA8hF6ppB+ZZuIXTnlFuQMOUqLR8iomIf5PInQouFMhkhZVKlU
         W+Ydtvu/UZjGloqcsb9J88lh3A3dl16NGe0gq0tQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230928023056epcas5p32063873a28ff1bc19c778e0760db6d76~I7zHOssCf2816728167epcas5p3q;
        Thu, 28 Sep 2023 02:30:56 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RwyC33Ty0z4x9Pw; Thu, 28 Sep
        2023 02:30:55 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.E8.09949.F55E4156; Thu, 28 Sep 2023 11:30:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8~I7ygcFF7M1568415684epcas5p2I;
        Thu, 28 Sep 2023 02:30:15 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230928023015epsmtrp17ca3517f88f3ddab7dfa50ab843be849~I7ygbGHI91037210372epsmtrp1c;
        Thu, 28 Sep 2023 02:30:15 +0000 (GMT)
X-AuditID: b6c32a49-bd9f8700000026dd-c2-6514e55f29fb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.AB.18916.735E4156; Thu, 28 Sep 2023 11:30:15 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230928023013epsmtip1eab11b66930a2274adf827fb2e468e3e~I7yedTBhZ1192811928epsmtip1u;
        Thu, 28 Sep 2023 02:30:13 +0000 (GMT)
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
Subject: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq
 threads.
Date:   Thu, 28 Sep 2023 10:22:28 +0800
Message-Id: <20230928022228.15770-4-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928022228.15770-1-xiaobing.li@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHPffe3hZc9VoYHJlo0+mmEB51bTkoGJeZ7aJsYyPLsodgQ+8o
        obRdb7sJmK0bYhjYgRhwMGQYIpkImhXqABGRwipbUFLEZUBV5LHxUAYDVFRcy8XN/z7n+/t9
        83uccwS4aI4MEKRojYxBq9RISG/inH3L5pDEEV8mfN7ij8qqzwF02pVPIudQL4mOjX1FoJEC
        G47uZl8hUMeTOyRy5RcRaCHPBZBtdo6Hmi90EqinqYxER++OAuRsrcDQ6AUv5LC0Yqgl5xaG
        Zu33+CinfR5Htg43FdU3YCjnYA/Y6UfXlNcAurHUxacPtvTx6Qqria77MYju6TLRA9ebSXqq
        pZekv62vBnTdb5n0P9b1cSs/TI1SM0oVYxAz2iSdKkWbHC3ZE5/4WqJcES4NkUaiCIlYq0xj
        oiW7YuNCXk/RuEeViD9TakxuKU7JspKwHVEGncnIiNU61hgtYfQqjV6mD2WVaaxJmxyqZYzb
        pOHhW+XuxH2p6hMjl3n6J6L9VyfO4mZQvToXeAkgJYMdtacID4uo8wCWPH6T4xkA7Tm7c4E3
        xwuzTiwXCJYMNos/pzcCuFgyALjDGIDWWRfmcZNUMPz9TC7PE/ClvsFgU+XNpQNOFWKwpv4q
        z5PlQ70LR06aSQ8T1CY4Yx1bcgupKPho5ATJ9bcBXrzUhXvYi4qGF2fGSS5nDewsGV7qG3fn
        ZNm+xz0FIHVfALOy53DOvAvWzxXyOfaB4476ZQ6AY/mHlpmF7Yfv8TizGcBj/b3Lge1w8Voz
        4Rkap7bAs01hnBwIi349g3GFV0HLw2GM04Wwofwpb4KnnYMExy/ACfPDZZ2Gx+fzMG5fBQCe
        /GmIKADi0mcGKn1moNL/S1cAvBqsZfRsWjLDyvVSLfP5f9ecpEuzgqX3HxTTAFy3/g5tA5gA
        tAEowCW+wsF+ESMSqpTpGYxBl2gwaRi2DcjdGz+CBzyfpHN/IK0xUSqLDJcpFApZ5CsKqcRf
        OJF9XCWikpVGJpVh9IzhqQ8TeAWYsZfzHJfbHjdmlla94bWGdym4LzCYbdr73PCBU/ybCQk/
        RyQcyFb7Ga9tG0Rxjttda8WqMMx7v71qVazv0UfGKp9pfm3Zg+nJztHY/ryBWOyH6soJ51ae
        fdGxe0XqJx1vvVcrrhVH9tW55FMru3383lEease/XFejisPxvzbL/jxiHm/xTr0+ORAlMgnV
        3fiLReu+kDzY3i123V+hMc8N2YLLizcGWmK+gzFSaUZWBPnH5EvxH2TS6as/vdHeen68L+NK
        oX0HYYm13Y7Z6aMqXuiU+k7c2aBYLJG/XWQuyNTvmyYM1MY9kcUN1ld/ibf53dj79fqYtI/f
        r/0ofWq4U1xJOiQEq1ZKg3ADq/wXGSzFFogEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnK75U5FUgzUnOC3mrNrGaLH6bj+b
        xaXHV9kspr9sZLF4OmErs8W71nMsFkf/v2WzuNs/lcXiV/ddRoutX76yWuzZe5LF4vKuOWwW
        k989Y7S4dGABk8WzvZwWx3sPMFns63jAZPHl8Hd2i44j35gtth4FsqZu2cFk0dFymdFBzGPN
        vDWMHjtn3WX3aNl3i91jwaZSj80rtDwuny31uHNtD5vH+31X2Tz6tqxi9Nh8utrj8ya5AO4o
        LpuU1JzMstQifbsEroyFT0+wFvwXqjj/ej1zA+Mq/i5GDg4JAROJrb3iXYxcHEIC2xkl7p0/
        zQYRl5b486e8i5ETyBSWWPnvOTtEzXNGiVnXehlBEmwC2hLX13WxgtgiAjOZJCb8iAQpYhaY
        xyTRe+MuG0hCWCBAYt2ls2ANLAKqEp82vWQCsXkFbCT+PF3IBrFBXmL/wbPMIDangK3E/k+v
        wI4QAqo5stIdolxQ4uTMJywgNjNQefPW2cwTGAVmIUnNQpJawMi0ilE0taA4Nz03ucBQrzgx
        t7g0L10vOT93EyM4JrWCdjAuW/9X7xAjEwfjIUYJDmYlEd6Ht4VShXhTEiurUovy44tKc1KL
        DzFKc7AoifMq53SmCAmkJ5akZqemFqQWwWSZODilGpi2Xvr/WOVFk6fihfnXdgk/2sc3k5+9
        dc4p32NdoTekLLX7/V+3TBf9ZGXR9qLsFp9J/Z7+NA6DNK6FiaccT4e0ntCJuhL+fL5pevDK
        qgx+z4o5/UbrNvw+uCzYi/fXwTh+c63k7816t3s0b26wzLj6TMHUurX10IKNEoemb930xzX9
        7M7gPXv6TK6yZ0XmMu/8N2Oj6c5Mxo8RHzLWqLjtlZrxUMjupFBWMFd8Y2KuwiULw29c0paa
        eZUPrlo/N7Iq3D5D/DvfqtqpVh8qVfb6MUhUP07Ive8133mKzbKnJS81H6zrnOusm7/7dvIS
        0z+3nru6eF18pdp9tN/e69HCjQKKe5w2nshZ8S1TMk+JpTgj0VCLuag4EQAFHibMOAMAAA==
X-CMS-MailID: 20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
        <CGME20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8@epcas5p2.samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since the sq thread has a while(1) structure, during this process, there
may be a lot of time that is not processing IO but does not exceed the
timeout period, therefore, the sqpoll thread will keep running and will
keep occupying the CPU. Obviously, the CPU is wasted at this time;Our
goal is to count the part of the time that the sqpoll thread actually
processes IO, so as to reflect the part of the CPU it uses to process
IO, which can be used to help improve the actual utilization of the CPU
in the future.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 io_uring/sqpoll.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..2c5fc4d95fa8 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -11,6 +11,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/io_uring.h>
+#include <linux/time.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -235,6 +236,10 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 
 	mutex_lock(&sqd->lock);
+	bool first = true;
+	struct timespec64 ts_start, ts_end;
+	struct timespec64 ts_delta;
+	struct sched_entity *se = &sqd->thread->se;
 	while (1) {
 		bool cap_entries, sqt_spin = false;
 
@@ -243,7 +248,16 @@ static int io_sq_thread(void *data)
 				break;
 			timeout = jiffies + sqd->sq_thread_idle;
 		}
-
+		ktime_get_boottime_ts64(&ts_start);
+		ts_delta = timespec64_sub(ts_start, ts_end);
+		unsigned long long now = ts_delta.tv_sec * NSEC_PER_SEC + ts_delta.tv_nsec +
+		se->sq_avg.last_update_time;
+
+		if (first) {
+			now = 0;
+			first = false;
+		}
+		__update_sq_avg_block(now, se);
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
@@ -251,6 +265,16 @@ static int io_sq_thread(void *data)
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
+
+		ktime_get_boottime_ts64(&ts_end);
+		ts_delta = timespec64_sub(ts_end, ts_start);
+		now = ts_delta.tv_sec * NSEC_PER_SEC + ts_delta.tv_nsec +
+		se->sq_avg.last_update_time;
+
+		if (sqt_spin)
+			__update_sq_avg(now, se);
+		else
+			__update_sq_avg_block(now, se);
 		if (io_run_task_work())
 			sqt_spin = true;
 
-- 
2.34.1

