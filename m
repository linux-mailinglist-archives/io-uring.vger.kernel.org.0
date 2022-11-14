Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB4628337
	for <lists+io-uring@lfdr.de>; Mon, 14 Nov 2022 15:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiKNOus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Nov 2022 09:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiKNOur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Nov 2022 09:50:47 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB8B23BE5;
        Mon, 14 Nov 2022 06:50:44 -0800 (PST)
Received: from zju.edu.cn (unknown [10.12.77.33])
        by mail-app3 (Coremail) with SMTP id cC_KCgB376rAVXJj+uwGCQ--.58627S4;
        Mon, 14 Nov 2022 22:50:40 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] io_uring/filetable: fix file reference underflow
Date:   Mon, 14 Nov 2022 22:50:40 +0800
Message-Id: <20221114145040.14365-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cC_KCgB376rAVXJj+uwGCQ--.58627S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFykuF1xtw18tw47Kr47CFg_yoW8KryrpF
        Z8J3W0qF1DG348K3ZrGFWrAF95C3yxAF1DZr95ur4Skr1UZFnYyr4S9a4Y9a1jkr4kAa4Y
        qr48K398urW8Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is an interesting reference bug when -ENOMEM occurs in calling of
io_install_fixed_file(). The tracing of this bug is shown below:

commit 8c71fe750215 ("io_uring: ensure fput() called correspondingly
when direct install fails") adds an additional fput() in
io_fixed_fd_install() when io_file_bitmap_get() returns error values. In
that case, the routine will never make it to io_install_fixed_file() due
to an early return.

static int io_fixed_fd_install(...)
{
  if (alloc_slot) {
    ...
    ret = io_file_bitmap_get(ctx);
    if (unlikely(ret < 0)) {
      io_ring_submit_unlock(ctx, issue_flags);
      fput(file);
      return ret;
    }
    ...
  }
  ...
  ret = io_install_fixed_file(req, file, issue_flags, file_slot);
  ...
}

In the above scenario, the reference is okay as io_fixed_fd_install()
ensures the fput() is called when something bad happens, either via
bitmap or via inner io_install_fixed_file().

However, the commit 61c1b44a21d7 ("io_uring: fix deadlock on iowq file
slot alloc") breaks the balance because it places fput() into the common
path for both io_file_bitmap_get() and io_install_fixed_file(). Since
io_install_fixed_file() handles the fput() itself, the reference
underflow come across then.

There are some extra commits make the current code into
io_fixed_fd_install() -> __io_fixed_fd_install() ->
io_install_fixed_file()

However, the fact that there is an extra fput() is called if
io_install_fixed_file() calls fput(). Traversing through the code, I
find that the existing two callers to __io_fixed_fd_install():
io_fixed_fd_install() and io_msg_send_fd() have fput() when handling
error return, this patch simply removes the fput() in
io_install_fixed_file() to fix the bug.

Fixes: 61c1b44a21d7 ("io_uring: fix deadlock on iowq file slot alloc")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 io_uring/filetable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 7b473259f3f4..68dfc6936aa7 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -101,8 +101,6 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
-	if (ret)
-		fput(file);
 	return ret;
 }
 
-- 
2.38.1

