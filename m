Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7B6B2B84
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 18:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjCIREl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 12:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCIREP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 12:04:15 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3FDE7777
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 08:58:32 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id cp12so1926498pfb.5
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 08:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678381111;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6aCfv4STRRGIFkooAouQgbwMrAUQE9quqkucriFKPYk=;
        b=Llo1R/k5N0zREQ/pLb/1BYlV3O55lWVv/Gla1SBVOy2tG8jh3oPNCsiXcyFYSCRfIZ
         jNOM3E7OxXQMoYrDhi8pddlu9Pcp0ZyiVAaO/jXllP+JGXPObOjatWzQl72YXcKFTd+5
         LFkUTge+oi82I5jGM2hO2eTJgyYefzeZNpoVMYhDT6JsrhS6/LDRwe8FSBJ7bsKD8o5o
         aF1G80q//U+OgryOciiWNdyNjSj2wWCnNiQaH8vz4z/hk1Y2kxeqIIJ0ooBzDu09df0a
         sBSGnnUbBFhH6ppnUP9EMXaFQ4TnWbpe40xtkl7IQZZ/33e2KkwtO4YGU2T+zTUEBqUf
         U1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678381111;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6aCfv4STRRGIFkooAouQgbwMrAUQE9quqkucriFKPYk=;
        b=iGtpICe8iz28R+VF2noW9iSMHcBB/WRla7dN9ZffUlXx/lSIGqyfjn8eiZy0zdD1un
         AgltVZwEUS8Ql/M6ICh0O/6hgEeyDVzQwCNEwiMycmXQXITonf/VnvOD+xN6eZsLi/FZ
         raMD50gBTYYRt1IMMapDTgS+NOHPcxrHMvhuqVqu4FsJcQWzdk5JPXlHyTgcxw2Pao3a
         MG5uzSup1dPZu/orbcRiyraWU/mkWxhi7Oew0cP8XZSNJPSOm0d6l3ErktV/2oh+q+AZ
         9omgvV6NxKMcvFxFAdV1V8/JR9qhHsNfMh9rJ3zIGOs5btP8VGdpbwhIG2h+A0S2PH5h
         Kyyg==
X-Gm-Message-State: AO0yUKXvriD8+4aol8oGHXC4Nd1EKG5gZDvkV8od1M81GfEUnv6/oUwR
        UzaDQZKnAPE8boMmq+Kv9JB6KsSDDWhKZjhZUpQ0sQ==
X-Google-Smtp-Source: AK7set8tn5g8f1nzJsCoEmhlYLTYLcWgOqV+i+6HP7ciPqBQxGRrr+WTlJy/3Mw0K0myaea7Z/5OWg==
X-Received: by 2002:a05:6a00:2d29:b0:5e4:f141:568b with SMTP id fa41-20020a056a002d2900b005e4f141568bmr21850676pfb.3.1678381111226;
        Thu, 09 Mar 2023 08:58:31 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id j14-20020a62e90e000000b005a8de0f4c76sm11793147pfh.17.2023.03.09.08.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 08:58:30 -0800 (PST)
Message-ID: <f2499a3c-5e15-eecd-2ee8-4a4e3ea4f9ad@kernel.dk>
Date:   Thu, 9 Mar 2023 09:58:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: =?UTF-8?Q?=5bPATCH=5d_io=5furing=3a_silence_variable_=e2=80=98prev?=
 =?UTF-8?Q?=e2=80=99_set_but_not_used_warning?=
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Content-Language: en-US
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

Resend, not sure if the previous went through...

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

