Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651E1674067
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjASR65 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 12:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjASR64 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 12:58:56 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F19F8F7F4
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 09:58:43 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id m15so1567241ilq.2
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 09:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EIcP0Sb4lKpIBY56Dm25GSOSg8HaED3u/YYyAbTFqQ=;
        b=6xWoDCMIsEtZzBE8ZbiWT50jAFIt9LZVJZxzFP0rrbF6SEatkbgSTaAblXwq01ChNW
         qjfzAs+dSATvY3rh9+zpOfd4o1ouJb6mmWXyUZYBt7QY3TN8WwVjibhxRL8qkqechZou
         MqGxQoF5lYGvMonD4T6Gatad3hNwyMrZgKpyS2YprAGQNOsh6XTxMySw3Pq8Gpms9nOk
         etZ2bjTj2lQXOQpQpDDpul2HAoimpFnDRLaecxZ3BCBF16HIwWEpcJiswkVyGkThRuPn
         HJu5PmrlUKDzR7R2XF4jUmGoOzfZvWcjB8e4b2Ut9CW80/HLVTpIIjJkV+4bKM0vo3n9
         dmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6EIcP0Sb4lKpIBY56Dm25GSOSg8HaED3u/YYyAbTFqQ=;
        b=Zn4JluZ/EuaLuHrRTJWtnkS2jwcVmW8SqlAPvEoMYvepCFZiaAMCsOtq4t5/d9WcqI
         KcDCp7V4jEnUwzlSoRcsBWn0v/TW/3uofm5ZKnu6/DgpHi3dHSUxqTpNlWOawpOmZNCJ
         tlNRPcT5pqUK1nso7Fs9iIC+wuG45S4eTCqGBp1xAhfl0jc7ZsVMLD5G3/NSbQPMOc3C
         6e0CLT6blxStwvoteUXA3X5TALSv5ChS3EYE8vel67XkyklGsyhcT4QDroByqrEakDiH
         UiLns33ERyKXwx3nXMDrDTU6BH6iPIRXFwKP/wJIHwYMqiTu56CCHu3oveQmLOVcsKsl
         8pPA==
X-Gm-Message-State: AFqh2krII75f7npOvliJBWroZVfUsnjgnlUfOKC+ooaaJsVE5SnWVr4K
        6R1oN6SF3E+yrKkHUBa0EAatCw8b+4xd9/nb
X-Google-Smtp-Source: AMrXdXuC+1FiV+rdQ5uWDMUQIEogbiKCzq2FBedR4XKgUZIgfLgNNnazAARQQ7Ru9aTCAAIOFSvCXA==
X-Received: by 2002:a92:9501:0:b0:30e:f03e:a76e with SMTP id y1-20020a929501000000b0030ef03ea76emr1490645ilh.2.1674151122180;
        Thu, 19 Jan 2023 09:58:42 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a6-20020a056e020e0600b0030edd1501a0sm5741005ilk.74.2023.01.19.09.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 09:58:41 -0800 (PST)
Message-ID: <1fb25d24-0def-9511-5d6d-06aa6de0166e@kernel.dk>
Date:   Thu, 19 Jan 2023 10:58:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/msg-ring: ensure flags passing works for
 task_work completions
Cc:     Breno Leitao <leitao@debian.org>
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

If the target ring is using IORING_SETUP_SINGLE_ISSUER and we're posting
a message from a different thread, then we need to ensure that the
fallback task_work that posts the CQE knwos about the flags passing as
well. If not we'll always be posting 0 as the flags.

Fixes: 5ffd63f2b73e ("io_uring/msg_ring: Pass custom flags to the cqe")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index dc233f72a541..5d052d2f3d93 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -49,11 +49,15 @@ static void io_msg_tw_complete(struct callback_head *head)
 	struct io_msg *msg = container_of(head, struct io_msg, tw);
 	struct io_kiocb *req = cmd_to_io_kiocb(msg);
 	struct io_ring_ctx *target_ctx = req->file->private_data;
+	u32 flags = 0;
 	int ret = 0;
 
+	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
+		flags = msg->cqe_flags;
+
 	if (current->flags & PF_EXITING)
 		ret = -EOWNERDEAD;
-	else if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	else if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
 		ret = -EOVERFLOW;
 
 	if (ret < 0)

-- 
Jens Axboe
