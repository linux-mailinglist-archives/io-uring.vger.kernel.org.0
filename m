Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC06B2B5B
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCIRAZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 12:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCIRAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 12:00:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B12980909
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 08:54:14 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u5so2641797plq.7
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 08:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678380853;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqc9oMrgkQUibO1kTeMAOuc92j7JV/u9PliAiT119Ec=;
        b=4TlBfKRzAU8/kIvVZIv8MRxP9zd6OG5SJi42bOkpvWhFVhoz5+oy0btb8ZtsPDfymd
         D97bryZ518s1x1lDosVRS8PbKymXtyz5B21zCf1O7jclaAs3qQLMY60D5hZWPTntnKhD
         kr6IEfxnzVHguk4d9GZCGCa7CTHowV7tjjBXU0aG/cFbcbop59/QKUGtYpcUS1g8TmsP
         4Oi9gqDmUgdj1DyRB269nCzFA5mSAI7xYvO8qBpSD+VLMmogjvD5Ti9ITwN+tV1yksgL
         y6sY8c48nrdRvCxmGWs4X0F+4kp7YkgBQlBAFG5+yv8oL9/ThdI8pHVCWJTAESNIrX7o
         ixHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678380853;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vqc9oMrgkQUibO1kTeMAOuc92j7JV/u9PliAiT119Ec=;
        b=bw7yZMlTDIBRM48XH20nNmE5QwJdIQYn36WsmBleBRiCxD4/eW5nXLz+LqQlp+4f55
         Y26DAHy81nu/ytOfXIZXgMpbzLCnqtT8zpcJB3NlsCiBHuk78nbpR+QNxY7fj6/Z+U8l
         slAzyppysWbO2jmPLDF9ey8x/7qT6iTeZMKByxfu0XU7OUHeyCxkexQACdGgm52cdjCH
         4fSy37+IO30Bi/SZWXG7/+MqZcm42hnk1GwiNJkD2NRPvJpCB86brCHiDB8z6615RmR8
         aC2Ylz8Y6bcrfyLy3R5EFtSPfuaoQgwomElSMPWE7fKzDR6EM6XoNM6RF9CzWbkHFueA
         G5Ag==
X-Gm-Message-State: AO0yUKXhflHwLlubhQJtX9s/v0m6SdQPxcl2chrzzQAV938WHqZCUDOh
        ocV9itSBiXlxwS6ENfBs9LXEmRcD8iJvTVMhzxY1Vw==
X-Google-Smtp-Source: AK7set+GKn8OXAClmQWPU/r9Hjk8Win68Kj2wr7yZ8b+aGMyVvZZIHhHAjDQOErq5W8wS7Wf9l9bQA==
X-Received: by 2002:a17:903:84e:b0:19d:1e21:7f59 with SMTP id ks14-20020a170903084e00b0019d1e217f59mr3722383plb.0.1678380853259;
        Thu, 09 Mar 2023 08:54:13 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id kv3-20020a17090328c300b0019c922911a2sm11886371plb.40.2023.03.09.08.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 08:54:12 -0800 (PST)
Message-ID: <d625f034-cccc-df6d-30dc-bed858bf6cd4@kernel.dk>
Date:   Thu, 9 Mar 2023 09:54:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: =?UTF-8?Q?=5bPATCH=5d_io=5furing=3a_silence_variable_=e2=80=98prev?=
 =?UTF-8?Q?=e2=80=99_set_but_not_used_warning?=
Cc:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_uring.o is built with W=1, it triggers a warning:

io_uring/io_uring.c: In function ?__io_submit_flush_completions?:
io_uring/io_uring.c:1502:40: warning: variable ?prev? set but not used [-Wunused-but-set-variable]
 1502 |         struct io_wq_work_node *node, *prev;
      |                                        ^~~~

which is due to the wq_list_for_each() iterator always keeping a 'prev'
variable. Most users need this to remove an entry from a list, for
example, but __io_submit_flush_completions() never does that.

Add a basic helper that doesn't track prev instead, and use that in
that function.

Reported-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd1cc35a1c00..722624b6d0dc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1499,14 +1499,14 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
+	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
 	/* must come first to preserve CQE ordering in failure cases */
 	if (state->cqes_count)
 		__io_flush_post_cqes(ctx);
-	wq_list_for_each(node, prev, &state->compl_reqs) {
+	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
diff --git a/io_uring/slist.h b/io_uring/slist.h
index 7c198a40d5f1..0eb194817242 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -3,6 +3,9 @@
 
 #include <linux/io_uring_types.h>
 
+#define __wq_list_for_each(pos, head)				\
+	for (pos = (head)->first; pos; pos = (pos)->next)
+
 #define wq_list_for_each(pos, prv, head)			\
 	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
 
@@ -113,4 +116,4 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 	return container_of(work->list.next, struct io_wq_work, list);
 }
 
-#endif // INTERNAL_IO_SLIST_H
\ No newline at end of file
+#endif // INTERNAL_IO_SLIST_H

-- 
Jens Axboe

