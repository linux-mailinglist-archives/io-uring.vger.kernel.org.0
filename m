Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27782624220
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 13:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiKJMVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 07:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiKJMVK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 07:21:10 -0500
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2921A2AE03;
        Thu, 10 Nov 2022 04:21:07 -0800 (PST)
Received: from zju.edu.cn (unknown [10.12.77.33])
        by mail-app3 (Coremail) with SMTP id cC_KCgBXzqmw7GxjD9XhCA--.5792S4;
        Thu, 10 Nov 2022 20:21:04 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] io_uring: update outdated comment of callbacks
Date:   Thu, 10 Nov 2022 20:21:03 +0800
Message-Id: <20221110122103.20120-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgBXzqmw7GxjD9XhCA--.5792S4
X-Coremail-Antispam: 1UD129KBjvdXoWruFW5ZrWUuw4kuF1kCw1rWFg_yoWfZFb_u3
        yDXw4xWrn7Xr10kry5GFy0qr4Sk3sFkF10q3WxWrsrJa47ZaykK3yDZrykJrn5Xr47WFy7
        CFs8Wa43Cw1IvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb7AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z280
        aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07
        x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18
        McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
        1lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIE
        Y20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Previous commit ebc11b6c6b87 ("io_uring: clean io-wq callbacks") rename
io_free_work() into io_wq_free_work() for consistency. This patch also
updates relevant comment to avoid misunderstanding.

Fixes: ebc11b6c6b87 ("io_uring: clean io-wq callbacks")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac8c488e3077..a1024b7fcc73 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1782,7 +1782,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
-	/* one will be dropped by ->io_free_work() after returning to io-wq */
+	/* one will be dropped by ->io_wq_free_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
 		__io_req_set_refcount(req, 2);
 	else
-- 
2.38.1

