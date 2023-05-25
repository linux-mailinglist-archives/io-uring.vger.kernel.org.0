Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95027107EF
	for <lists+io-uring@lfdr.de>; Thu, 25 May 2023 10:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbjEYIxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 May 2023 04:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjEYIxy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 May 2023 04:53:54 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91D318D
        for <io-uring@vger.kernel.org>; Thu, 25 May 2023 01:53:51 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230525085348epoutp047f8a680288b5ffda7f5136ce4351929f~iVvbJeQ032193521935epoutp04c
        for <io-uring@vger.kernel.org>; Thu, 25 May 2023 08:53:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230525085348epoutp047f8a680288b5ffda7f5136ce4351929f~iVvbJeQ032193521935epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1685004828;
        bh=6rZXhuqUwEUyJ1n9SgGz3Cpuoe0L6XNpZFiNtajnt6A=;
        h=From:To:Cc:Subject:Date:References:From;
        b=dQXZ/n5i4z//JHAUXSZSIozGKZeW1Cz4ZLKGAWyRFvUb5DBceBUDTzaeetGGKU098
         W+x/qnJZsb1OoTPkA/ydZkmqcfaeS3QHm3uuklUmhgdihktEL3DzvlhZRjA4MVD/35
         EhIJO7400IwpfQeuDeoNeDXfDiqCP+WblY8QlteQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230525085348epcas5p32f06fa0b3ba2495a215e4d57bf0dd1dc~iVvarsfRr0230102301epcas5p3f;
        Thu, 25 May 2023 08:53:48 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4QRhfx6HSgz4x9Q5; Thu, 25 May
        2023 08:53:45 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.EB.44881.5122F646; Thu, 25 May 2023 17:53:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230525082004epcas5p1d05da68508feff3f9dd82646a0b40aff~iVR_cNBga1722317223epcas5p1Z;
        Thu, 25 May 2023 08:20:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230525082004epsmtrp20a42dc5a7d130185a806134c361fc753~iVR_bk-ee0256602566epsmtrp2k;
        Thu, 25 May 2023 08:20:04 +0000 (GMT)
X-AuditID: b6c32a4a-c47ff7000001af51-62-646f2215aebf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.90.27706.43A1F646; Thu, 25 May 2023 17:20:04 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.125]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230525082003epsmtip1a3d73cb074325a19dd202ef614a92cd3~iVR9iFYoL1097610976epsmtip1O;
        Thu, 25 May 2023 08:20:03 +0000 (GMT)
From:   Wenwen Chen <wenwen.chen@samsung.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Wenwen Chen <wenwen.chen@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2] io_uring: unlock sqd->lock before sq thread release CPU
Date:   Thu, 25 May 2023 16:26:26 +0800
Message-Id: <20230525082626.577862-1-wenwen.chen@samsung.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmuq6oUn6KwbUmK4s5q7YxWqy+289m
        8a71HIvF0f9v2Sx+dd9ltDg74QOrxdQtO5gc2D12zrrL7nH5bKlH35ZVjB6fN8kFsERl22Sk
        JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
        CkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74vGYb
        a8FO7ooPD5YyNzCu4uxi5OSQEDCRaJo1h7GLkYtDSGA3o0TL8UYo5xOjxKmtm5khnG+MEp8u
        NTDDtNzZt5YNIrEXqKqpB8r5yijRt2EzG0gVm4C2xPu1LYwgtgiQ/frxVBYQm1kgS+LS22/s
        ILawgLfEhT2fweIsAqoS65c8BIvzCthK3Di8kw1im7zExNl3GSHighInZz6BmiMv0bx1Nth5
        EgLH2CVOft4DdZ6LxISzx9ghbGGJV8e3QNlSEp/f7YUaWiwx8eAXdojmBkaJ4xe/skAkrCX+
        XdkDZHMAbdCUWL9LHyIsKzH11DomiMV8Er2/nzBBxHkldsyDsVUlzj4/xwphS0u0zGmAintI
        NPztB7tBSCBWoqNhHcsERvlZSP6ZheSfWQibFzAyr2KUTC0ozk1PLTYtMMpLLYdHbXJ+7iZG
        cErU8trB+PDBB71DjEwcjIcYJTiYlUR4T5RnpwjxpiRWVqUW5ccXleakFh9iNAUG8kRmKdHk
        fGBSziuJNzSxNDAxMzMzsTQ2M1QS51W3PZksJJCeWJKanZpakFoE08fEwSnVwLSk/QWLY/pv
        jqNHC3ds8cgo9zgptfL0V97JmU/7egX9DVkcLk1fa+VQ6PUzcrrukRU2rNU1CretVz8wOhp6
        evFyOZ+0Xc0x5mtUFP9/nhP3TqzSvNF1qbuufqth47fr+9XVMsReptXGa2jclE0+uaAsua3o
        zlG9eX3/1pZszeS6qM2W8igoatWlv4sqSuMOsn27PK/1xk+l0+89vU9IWX6379Kf9MMiQpuH
        XSLgZ73WX363Npu58+d9lZ8n7+7ruFFMYKmzwpRfJ9q2z9+UW7vH83lyFfedO+qrqqO9M9r9
        fKc3Ll0e715WcDP1yaT5B1lntmw59vNdwySZpU88HrTf2vWwy/bcCkHRhUtCViuxFGckGmox
        FxUnAgCbTUXREgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnK6JVH6KwY/ZOhZzVm1jtFh9t5/N
        4l3rORaLo//fsln86r7LaHF2wgdWi6lbdjA5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
        zcksSy3St0vgyvi8ZhtrwU7uig8PljI3MK7i7GLk5JAQMJG4s28tWxcjF4eQwG5GiQuHlzNC
        JKQlDl37zAphC0us/PecHaLoM6PE+x13WEASbALaEu/XtgA1cHCICOhKNN5VAAkzC+RI3Lz2
        HqxEWMBb4sKez2A2i4CqxPolD9lBbF4BW4kbh3eyQcyXl5g4+y4jRFxQ4uTMJywQc+QlmrfO
        Zp7AyDcLSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBgamluYNx+6oP
        eocYmTgYDzFKcDArifCeKM9OEeJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZq
        akFqEUyWiYNTqoHptHvSekH1NXE88lefRDC8yJ6U53vrrae1q9XWpfsyz+fsu+918I/lOoP3
        Bu8Ov/tw9ctRBa8p5nmfAj4u/asnJud+75kuz5nVLLveH+gJ+PWlvaz+pneYytfeVewuJ3iX
        n+RfxF3u/1/mpU/8gv83d/2a2GQh7NTEyJO9r0vprZbTmRs/Qm4q3VuY2f9s5QJfu5kr9kSr
        fnin+YZn7ZqFzay75KZ/CnjP+UFj72EmtVbOgPQHEfNYTs7UmvwyTXj+ArGZPc2vZb5kfZlx
        g/tNu3nCZU1L4x/PpzOE8M9/cnRnikXIjO+bul9wbeO/oNE28WTRkwimUz9q9cVcFv6zLp+h
        HH5mYXDKTPdtVfaVkkosxRmJhlrMRcWJADsCy6S7AgAA
X-CMS-MailID: 20230525082004epcas5p1d05da68508feff3f9dd82646a0b40aff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230525082004epcas5p1d05da68508feff3f9dd82646a0b40aff
References: <CGME20230525082004epcas5p1d05da68508feff3f9dd82646a0b40aff@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The sq thread actively releases CPU resources by calling the
cond_resched() and schedule() interfaces when it is idle. Therefore,
more resources are available for other threads to run.

There exists a problem in sq thread: it does not unlock sqd->lock before
releasing CPU resources every time. This makes other threads pending on
sqd->lock for a long time. For example, the following interfaces all
require sqd->lock: io_sq_offload_create(), io_register_iowq_max_workers()
and io_ring_exit_work().

Before the sq thread releases CPU resources, unlocking sqd->lock will
provide the user a better experience because it can respond quickly to
user requests.

Signed-off-by: Kanchan Joshi<joshi.k@samsung.com>
Signed-off-by: Wenwen Chen<wenwen.chen@samsung.com>
---
 V1 -> V2: Make sqd lock shuffle dependent on the need to reschedule
 io_uring/sqpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..5e329e3cd470 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -255,9 +255,13 @@ static int io_sq_thread(void *data)
 			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			cond_resched();
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
+			if (unlikely(need_resched())) {
+				mutex_unlock(&sqd->lock);
+				cond_resched();
+				mutex_lock(&sqd->lock);
+			}
 			continue;
 		}
 
-- 
2.27.0

