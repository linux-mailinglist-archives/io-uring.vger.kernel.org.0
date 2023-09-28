Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412E37B10C8
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 04:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjI1CbC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Sep 2023 22:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjI1CbB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Sep 2023 22:31:01 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CF0139
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 19:30:57 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230928023055epoutp0281b8e16216f386b81d693d76c5ad4494~I7zFxP-c91143411434epoutp02k
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 02:30:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230928023055epoutp0281b8e16216f386b81d693d76c5ad4494~I7zFxP-c91143411434epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695868255;
        bh=IPFMkhvUhh2Nbce6Uqs8Hy4irIy4VWJBDhiYhVwQ2kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qs9Ux3U7LyzvYXOG/cNX98M1PG5ui1nrhd1zpuitIwRCNnv+7deA3fNcuH0Qwy8ul
         eJ93Kmk0kFIS+KsW2G8ydSeqIJTPEbKNJL7GVwxT+lmTvvyl5EsSowbblCwgnrKRpO
         NS27q9RVAH1H8dvAztn1U0wbXssmIRKbX09nPin0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230928023054epcas5p415ca6b1d7463b9c2a135b47edd2030a3~I7zFFNtnQ0071000710epcas5p43;
        Thu, 28 Sep 2023 02:30:54 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RwyC12sqZz4x9Q1; Thu, 28 Sep
        2023 02:30:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.FB.09023.D55E4156; Thu, 28 Sep 2023 11:30:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230928023011epcas5p32668b193b447f1cd6bf78035f4894c42~I7ydaBPLU2327723277epcas5p3z;
        Thu, 28 Sep 2023 02:30:11 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230928023011epsmtrp10b18654ae936abd952c42aa65696781a~I7ydY1_vL1037210372epsmtrp1J;
        Thu, 28 Sep 2023 02:30:11 +0000 (GMT)
X-AuditID: b6c32a44-a21ff7000000233f-28-6514e55d9751
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.49.08788.335E4156; Thu, 28 Sep 2023 11:30:11 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230928023009epsmtip18196df64eb77d978dfc95071ab3bc7d8~I7ybU1qZW1182111821epsmtip1F;
        Thu, 28 Sep 2023 02:30:09 +0000 (GMT)
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
Subject: [PATCH 2/3] PROC FILESYSTEM: Add real utilization data of sq
 thread.
Date:   Thu, 28 Sep 2023 10:22:27 +0800
Message-Id: <20230928022228.15770-3-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928022228.15770-1-xiaobing.li@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbZRT3u/f2toCd11K3D9DZ1PAHdDw62vJ1A10c6sUniWYxZNo19FqQ
        vtLbytBFS9wECxvoJJOOVzY1Bgooj8lYeayAezCEUGFzg0zCYwGyuQeMZGxgyy26/36/c87v
        +51zvhwBLlomIwU5JhtjNWkNUjKUONUbExP3wYyYSXRfDEeVdacAqp8oJdHI1CiJjs0VEGim
        rA1Htw79QaD+tZskmigtJ9CD4gmA2haXeMjTeYFAvo5KEh29NQvQSE8thmY7Q9C5wz0Y6ir6
        G0OLvct8VNR3H0dt/X5U3tqOoaKDPrBrM+2udgP6tGuCTx/susqna5vtdMvPsbRv0E6Pj3lI
        +p+uUZI+0loH6JaBz+h7zVszwjJzU7IZrY6xShhTllmXY9KnSt94V7Nbo1QlyuPkapQslZi0
        RiZVmvZmRtyrOQb/qFLJJ1qD3R/K0LKsNOHFFKvZbmMk2WbWliplLDqDRWGJZ7VG1m7Sx5sY
        2w55YuJ2pb9wX252Q/F3wPITtd9X4gAOUCh0ghABpBTwr5JWzAlCBSLqDIDO0SXAkbsANpx/
        SHLkvp9MloANSUHbEM4lOgFsHPARHJkD8EbvUSxQRVIyeLnRyQskxNTXGOw4eX2d4NS3GHS3
        DvmJQBBOvQO7josDAoKKhtN9Y2QAC6kU+Kh7jc/ZPQ+7zw7iARxCpcLuu/PBmqfhhYppIoBx
        f82XbcfXW4LUmgCOPxzFOHEa9AwukRwOh/PnWoOPRsK50q+CmIV9Jcs8TuwA8Ni10WBiJ1z9
        00MEGsWpGNjUkcCFn4PlFxsxzngTPLwyHfQSwvbqDRwN60cmCQ5HwQXHSjBOw8X6MT63rjIA
        Lw3f4ZUBieuxgVyPDeT637oW4HUggrGwRj2TpbTITUzefx+dZTY2g/ULiE1rB1dqVuO9ABMA
        L4ACXCoWTl4TMSKhTpv/KWM1a6x2A8N6gdK/8W/wyGeyzP4TMtk0coU6UaFSqRTqJJVcukW4
        cKhKJ6L0WhuTyzAWxrqhwwQhkQ7MVQhK14rP7A0z7XxldXpmWDgZmpegrf5FcYU3V1A1VEk7
        aS/IPHB272VHlvhIC7+Jp2z4ML+6+8EMfEp54N5UDzzdLxrufX1+5cSljMze3zS/f570pIFN
        vro5x6j0Jnwh60xOahdS4IeQqIpVz6YXBiLm9q2uZUg/rpDNDpPtYzcejX+/YDbXqLFuxWsp
        00RYlUI3n/Z+1HuZmps72PQ9MzJX8+3doVFpkrHclx2StzsdeR+VvKWObNhWX7b0RNXKScmK
        T4gPWUVL17fk3znhPeyu1m97SR8hS28qLhQ3RKTXeNKLzqvC9m+He26rp4qf3SWTox9/jS5N
        Ni9sNTrdUoLN1spjcSur/RfWjcXSigQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWy7bCSnK7xU5FUg4+fTC3mrNrGaLH6bj+b
        xaXHV9kspr9sZLF4OmErs8W71nMsFkf/v2WzuNs/lcXiV/ddRoutX76yWuzZe5LF4vKuOWwW
        k989Y7S4dGABk8WzvZwWx3sPMFns63jAZPHl8Hd2i44j35gtth4FsqZu2cFk0dFymdFBzGPN
        vDWMHjtn3WX3aNl3i91jwaZSj80rtDwuny31uHNtD5vH+31X2Tz6tqxi9Nh8utrj8ya5AO4o
        LpuU1JzMstQifbsEroy13VMYC5YJVFzuaWBsYGzn7WLk5JAQMJFo3HqeuYuRi0NIYDejxJ6z
        T9i6GDmAEtISf/6UQ9QIS6z895wdxBYSeM4o0fZADsRmE9CWuL6uixXEFhGYySQx4UckyBxm
        gXlMEr037rKBJIQFfCX+vn/GCGKzCKhKPDlyDSzOK2Aj8Xf/f3aIBfIS+w+eZQaxOQVsJfZ/
        egV2gxBQzZGV7hDlghInZz5hAbGZgcqbt85mnsAoMAtJahaS1AJGplWMkqkFxbnpucWGBUZ5
        qeV6xYm5xaV56XrJ+bmbGMGxqaW1g3HPqg96hxiZOBgPMUpwMCuJ8D68LZQqxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPfb694UIYH0xJLU7NTUgtQimCwTB6dUA1Nf9V+2Ct3oueydIt91Ahea
        nqoRNbwe/qCFf2WcZNgDm2/nz925fMH/6eFL7P5bG/yMQ+62yvefyhQomcdqHrOL+fO1u8k7
        b1/udDy5YFq3c84Op+C3egtn+csGyJU3rZ8vp1TH8vJB2aLA8EQ+Y4v3z6fdDbovnDx/e/w0
        3omeKeeTBfbV6kfJdp7Sij2x1ojhHbu/2DQf9uOpzgoffm97I2DEkrVVruHq3a0fK+fJlnkG
        7WlaMoHHULyUPb5LSf9Ap/oWX6b5V/Y/9frXENZavM6S5zHH5a0Cchzuov/XHeqd6nBw6q6D
        lQ03o8RfmH7i3nDgvJ2zt/3jbRyOJ3oz0to9Dkdeq6pg0jlir8RSnJFoqMVcVJwIAO4Q/SI8
        AwAA
X-CMS-MailID: 20230928023011epcas5p32668b193b447f1cd6bf78035f4894c42
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230928023011epcas5p32668b193b447f1cd6bf78035f4894c42
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
        <CGME20230928023011epcas5p32668b193b447f1cd6bf78035f4894c42@epcas5p3.samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since it is necessary to count and record the real utilization of the sq
thread, it is recorded in the /proc/stat file.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 fs/proc/stat.c              | 25 ++++++++++++++++++++++++-
 include/linux/kernel_stat.h |  3 +++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index da60956b2915..bd86c0657874 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -79,6 +79,29 @@ static void show_all_irqs(struct seq_file *p)
 	show_irq_gap(p, nr_irqs - next);
 }
 
+static void show_sqthread_util(struct seq_file *p)
+{
+	int i, j;
+
+	for_each_online_cpu(i) {
+		struct kernel_cpustat kcpustat;
+
+		kcpustat_cpu_fetch(&kcpustat, i);
+		struct task_struct **sqstat = kcpustat.sq_util;
+
+		for (j = 0; j < MAX_SQ_NUM; j++) {
+			if (sqstat[j]) {
+				seq_printf(p, "%d %s", sqstat[j]->pid, sqstat[j]->comm);
+				seq_put_decimal_ull(p, " pelt ",
+				(unsigned long long)sqstat[j]->se.avg.util_avg);
+				seq_put_decimal_ull(p, " real ",
+				(unsigned long long)sqstat[j]->se.sq_avg.util_avg);
+				seq_putc(p, '\n');
+			}
+		}
+	}
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -187,7 +210,7 @@ static int show_stat(struct seq_file *p, void *v)
 	for (i = 0; i < NR_SOFTIRQS; i++)
 		seq_put_decimal_ull(p, " ", per_softirq_sums[i]);
 	seq_putc(p, '\n');
-
+	show_sqthread_util(p);
 	return 0;
 }
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 9935f7ecbfb9..722703da681e 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -11,6 +11,7 @@
 #include <linux/vtime.h>
 #include <asm/irq.h>
 
+#define MAX_SQ_NUM 16
 /*
  * 'kernel_stat.h' contains the definitions needed for doing
  * some kernel statistics (CPU usage, context switches ...),
@@ -36,6 +37,8 @@ enum cpu_usage_stat {
 
 struct kernel_cpustat {
 	u64 cpustat[NR_STATS];
+	bool flag;
+	struct task_struct *sq_util[MAX_SQ_NUM];
 };
 
 struct kernel_stat {
-- 
2.34.1

