Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECB731937
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 14:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjFOMvC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jun 2023 08:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245606AbjFOMu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jun 2023 08:50:59 -0400
X-Greylist: delayed 77881 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Jun 2023 05:50:57 PDT
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E38B2126
        for <io-uring@vger.kernel.org>; Thu, 15 Jun 2023 05:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=iJw8F+Y4aVx+d+Ckq+S6NcFQ7LcDhQJeExf86hEVhuY=; b=e
        nHOwDDXvtGQ4c13ap5LXt1dbtce6chVTgWjdrhlVK6Ez6OCJP9IjuHYKWizjGk1q
        yOcWQo+nwNrFnotuQz675tNwK7nvR51EKvUJ84M3qjZhGnh1diLFRFbV7L4x6rSo
        7S7uha3Xi05XlG6geox0vsCLMrdZbBjGCg3oq7ncfM=
Received: from ubuntu.localdomain (unknown [183.157.8.87])
        by app2 (Coremail) with SMTP id XQUFCgC3vcEqCYtk5GchAQ--.63893S2;
        Thu, 15 Jun 2023 20:50:50 +0800 (CST)
From:   Chenyuan Mi <cymi20@fudan.edu.cn>
To:     axboe@kernel.dk
Cc:     sml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyuan Mi <cymi20@fudan.edu.cn>
Subject: [PATCH] tools/io_uring: Fix missing check for return value of malloc()
Date:   Thu, 15 Jun 2023 05:50:45 -0700
Message-Id: <20230615125045.125172-1-cymi20@fudan.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: XQUFCgC3vcEqCYtk5GchAQ--.63893S2
X-Coremail-Antispam: 1UD129KBjvdXoWrurWkuw1kZw48ZFyxXr4rAFb_yoW3uFX_uF
        n7WryDWr93KrZ2yF1qkr48Xry8GF43AF109Fsxtr13JF13CaykWFyDXrn5CF1fXr1q9FW5
        AFZ8G343G3429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
        6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7MxkIecxEwVAFwVW5JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUjsYFtUUUUU==
X-CM-SenderInfo: isqsiiisuqikmt6i3vldqovvfxof0/
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The malloc() function may return NULL when it fails,
which may cause null pointer deference in kmalloc(),
add Null check for return value of malloc().

Found by our static analysis tool.

Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
---
 tools/io_uring/io_uring-bench.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/io_uring/io_uring-bench.c b/tools/io_uring/io_uring-bench.c
index 7703f0118385..a7fedfdb9b84 100644
--- a/tools/io_uring/io_uring-bench.c
+++ b/tools/io_uring/io_uring-bench.c
@@ -560,6 +560,11 @@ int main(int argc, char *argv[])
 	pthread_create(&s->thread, NULL, submitter_fn, s);
 
 	fdepths = malloc(8 * s->nr_files);
+	if (!fdepths) {
+		printf("malloc failed");
+		return 1;
+	}
+
 	reap = calls = done = 0;
 	do {
 		unsigned long this_done = 0;
-- 
2.17.1

