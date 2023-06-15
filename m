Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360D273193D
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 14:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbjFOMyB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jun 2023 08:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbjFOMyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jun 2023 08:54:00 -0400
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 773062135;
        Thu, 15 Jun 2023 05:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=EO5RSXH84NgtzlB/n7zUHf0E3OWx09iEwoSpUSmQVTc=; b=X
        iY2lMZt93+lkrhnOe24mjlDTk8o3lGHrf+cQLSyCEerOwJZNq+V11DJskMR0J7NM
        J3XS/ZaYp8fWP3zoFTW2FypZY+uQ3oi3VbmhpNWiACvSJFnXeK4KKh/Cr9BdGVH3
        sAnpU/NyG99Uomg35iAwuRR933BI7oLHYiYd7DO45k=
Received: from ubuntu.localdomain (unknown [183.157.8.87])
        by app1 (Coremail) with SMTP id XAUFCgC3vfXgCYtk0Sz8AA--.58755S2;
        Thu, 15 Jun 2023 20:53:53 +0800 (CST)
From:   Chenyuan Mi <cymi20@fudan.edu.cn>
To:     axboe@kernel.dk
Cc:     sml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyuan Mi <cymi20@fudan.edu.cn>
Subject: [PATCH] tools/io_uring: Fix missing check for return value of malloc()
Date:   Thu, 15 Jun 2023 05:53:50 -0700
Message-Id: <20230615125350.125557-1-cymi20@fudan.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: XAUFCgC3vfXgCYtk0Sz8AA--.58755S2
X-Coremail-Antispam: 1UD129KBjvdXoWrurWkuw13Kr18ZF4kWF1Utrb_yoW3ZFgE9F
        n2gryDWr93KrZ2kF1qkr48XryxGF43AF409Fsxtw13GF13CaykWFyDZrn5CFn3Xr1q9FW5
        Aa98G343Ga429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUjE1v3UUUUU==
X-CM-SenderInfo: isqsiiisuqikmt6i3vldqovvfxof0/
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The malloc() function may return NULL when it fails,
which may cause null pointer deference. Add Null 
check for return value of malloc().

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

