Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291BB20F75F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgF3Oil (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731288AbgF3Oil (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:38:41 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25719C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:38:41 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f2so8549794plr.8
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0jKBbJwfq02BYc7//GBletWwGYnMRSROFeS5aufOboM=;
        b=nn2IxqZa1MQS87ypP4WT8olJIMAiB58lisH2o9HxUkdPpKq7hz+5Vi5/RAefCtp67a
         fcEUMGzrkdG8PUinK0TwU2hXMPvywjPQ+01JjVTY/pLWzda/cYbQ0pPKNCI/hK4v8Mjh
         1IO2DNowHjPc/NpQN497k9H0e0ibmlm7S0znsPfPrYjsdq/NaL44gRPnpg9eVJzjCvW+
         le8mXKyTnBhgLxaOCzaZhD9Gv+gexwT4pDTRVGv5DrGRj/F1Es62kzFJ/z1pvrFczlz7
         aVvjavj1FJW9bz8LPZKNDaTVXKLezjYl1oco+E8cqsLQx/KhY8MqR3oZCjQ8pz6+lnrX
         0rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0jKBbJwfq02BYc7//GBletWwGYnMRSROFeS5aufOboM=;
        b=tNMg1HFCsWWH1u+yZi4qm+3troQc9q1phryOuuAARUXywf5GPDUhpnIFfoCTzuJA3F
         TV0JigSxgFpQkOnSfgcrGdWl2fPWq3ljWH21xHKbmPTGFuLQO45/nI/Uk9Yst8WrEDp3
         PXG3ZujHZFMnZEJA/dw8aR3rBdKvq/crnOswKiPMWz/TfxEEW2cLCOfEZ4MlBol6hI3g
         Pv13Aape6OjorAhBAyKV8gxBGP/kfCkbifAyswQRGoLxBujwlhXf95jzTI0llVKTBF3D
         9xDRYM75/XOocD1i6ZTypNqSeu5Sydqess0Euekr+zdAXX8rg8fkalc8kfKyeaG3dol9
         CYcA==
X-Gm-Message-State: AOAM533y+gw1BqTeqlxphK83CDfVh3kT2yUEaQOV72KxNykrmVPQG/kR
        tukmLvNcVh2E5N5XMkMFpeNxDT0zsR94tw==
X-Google-Smtp-Source: ABdhPJykepJKIKgUJZjz/RoIJx442JP/NsToA9EBlCGx+hN7GLBJaY0zEIywP3rH69T85Vv2dZHdCA==
X-Received: by 2002:a17:90a:24ed:: with SMTP id i100mr18447332pje.22.1593527920234;
        Tue, 30 Jun 2020 07:38:40 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id nl5sm2860598pjb.36.2020.06.30.07.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:38:39 -0700 (PDT)
Subject: Re: [PATCH 1/8] io_uring: fix io_fail_links() locking
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
 <a306de0c1e191b12bb4183b26f4df3e66b2a770c.1593519186.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <12778c43-c890-c983-29a1-fe732e39fec5@kernel.dk>
Date:   Tue, 30 Jun 2020 08:38:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a306de0c1e191b12bb4183b26f4df3e66b2a770c.1593519186.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/20 6:20 AM, Pavel Begunkov wrote:
> 86b71d0daee05 ("io_uring: deduplicate freeing linked timeouts")
> actually fixed one bug, where io_fail_links() doesn't consider
> REQ_F_COMP_LOCKED, but added another -- io_cqring_fill_event()
> without any locking
> 
> Return locking back there and do it right with REQ_F_COMP_LOCKED
> check.

Something like the below is much better, and it also makes it so that
the static analyzers don't throw a fit. I'm going to fold this into
the original.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index e1410ff31892..a0aea78162a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1600,7 +1600,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 /*
  * Called if REQ_F_LINK_HEAD is set, and we fail the head request
  */
-static void io_fail_links(struct io_kiocb *req)
+static void __io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1620,6 +1620,23 @@ static void io_fail_links(struct io_kiocb *req)
 	io_cqring_ev_posted(ctx);
 }
 
+static void io_fail_links(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!(req->flags & REQ_F_COMP_LOCKED)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		__io_fail_links(req);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		__io_fail_links(req);
+	}
+
+	io_cqring_ev_posted(ctx);
+}
+
 static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	if (likely(!(req->flags & REQ_F_LINK_HEAD)))

-- 
Jens Axboe

