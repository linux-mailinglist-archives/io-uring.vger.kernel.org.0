Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBD3623B95
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 07:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiKJGDW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 01:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJGDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 01:03:21 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CF97248EC;
        Wed,  9 Nov 2022 22:03:18 -0800 (PST)
Received: from zju.edu.cn (unknown [10.12.77.33])
        by mail-app4 (Coremail) with SMTP id cS_KCgAHCc0jlGxjOmznBw--.42812S4;
        Thu, 10 Nov 2022 14:03:15 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] io_uring: remove outdated comments of caching
Date:   Thu, 10 Nov 2022 14:03:13 +0800
Message-Id: <20221110060313.16303-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgAHCc0jlGxjOmznBw--.42812S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW3Cw4kXF48Ary3uw4UArb_yoWkCrb_XF
        ZxJrWkZayjyFsFk3yUCr40qrW2vw429F4xuF47JasrJa47AFZ5Cr4qyryfXr98Cw47Cr90
        ka98KayfJr429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb28Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Previous commit 13a99017ff19 ("io_uring: remove events caching
atavisms") entirely removes the events caching optimization introduced 
by commit 81459350d581 ("io_uring: cache req->apoll->events in
req->cflags"). Hence the related comment should also be removed to avoid
misunderstanding.

Fixes: 13a99017ff19 ("io_uring: remove events caching atavisms")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 io_uring/poll.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..74ba910c1f22 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -310,12 +310,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 static void __io_poll_execute(struct io_kiocb *req, int mask)
 {
 	io_req_set_res(req, mask, 0);
-	/*
-	 * This is useful for poll that is armed on behalf of another
-	 * request, and where the wakeup path could be on a different
-	 * CPU. We want to avoid pulling in req->apoll->events for that
-	 * case.
-	 */
+
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
-- 
2.38.1

