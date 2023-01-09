Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A7663399
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 22:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbjAIV6v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 16:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbjAIV6u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 16:58:50 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAE100F
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 13:58:49 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id y205so721899iof.0
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 13:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/8JnfxX94ysIoMG32xmrGjJnGR76CRYat5D7yW3CG4=;
        b=MgSHC6nMmIj6jyk265rSYkadfOUkLpLJLD323lEIjlkQpccx9fpWdC69LFfWlICpyg
         EHPLKPJ7FUEF8A+bCiL3WJWNRJpH6Q3RTh4jJJTW+SAecaSwhNn2bkhOK9Gcudq2kJd+
         mURpojpoWBFElIn3gCt7ils/IzT3NbJitibqfWrmm2uMMtQQeVR1IdA/G2sZAwXAon8k
         pUCx1z2jKR8rOxv4TxHNQQ/M3GBHHPWgbJBRdXH5lGkZpAEwCfDRkJ9AWG43bGBub9gI
         lC2/Cjxlu6zhRCLHYJn+ZxzgecL3wr5Y5BPqkgwAJhQo5B6FBlO/qOPgfKlAAtLbxFtp
         cEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e/8JnfxX94ysIoMG32xmrGjJnGR76CRYat5D7yW3CG4=;
        b=EHsuRyNQ33ni/PxDm/zBKEXLn9EPlBgtFkZ81dILHJTxip9NNYtBUgytdPcIJLHJ6B
         Q9SKMFZPw050Ag4/V2Jso6CQKz5VUu51t1o/f18Hm2wd+MIs7qAe5uvnd/aLmt58xbCi
         /RcTuJ9t8RkyAKNSiZKehc+EaQxtIMgMt8oEpjI6RA+c84I5wWj6NvGD9o0lRTMHPnfK
         OoIf1SKBf+r1BCUuTz3//TxHG3VL3JCYNRCs5G9bq+ajVdewrqPTOrFnHAbxYigkZErS
         C8MekDt2w7uwBPalx4G0pOIqh8nwXp/Ah6A5r4xMJtU+U65Qnzb5TWmkoIrNyjZQ5Gkd
         2P8w==
X-Gm-Message-State: AFqh2krM9OPwSeeucaRLYMrCLuALJPZe9SEg7lIFiyTtL7kmGYYQJpUH
        vA/htm6VR10fxVfHnTZc7qdVQx8jHScEDXBt
X-Google-Smtp-Source: AMrXdXsfdFokM7lwFTEfJGj9MDJlPXJvhJVcyXggeB4AGyX/AmN3RW8F9F7xPywPezpWsCb7g9TlHg==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr9835436ioq.0.1673301529125;
        Mon, 09 Jan 2023 13:58:49 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e2-20020a056602158200b006dfa5af69f5sm3600589iow.0.2023.01.09.13.58.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:58:48 -0800 (PST)
Message-ID: <559d2a90-25c5-626c-c643-25a86cf15e6a@kernel.dk>
Date:   Mon, 9 Jan 2023 14:58:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: add hash if ready poll request can't complete
 inline
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

If we don't, then we may lose access to it completely, leading to a
request leak. This will eventually stall the ring exit process as
well.

Cc: stable@vger.kernel.org
Fixes: 49f1c68e048f ("io_uring: optimise submission side poll_refs")
Reported-by: syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index ee7da6150ec4..cf6a70bd54e0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -533,6 +533,14 @@ static bool io_poll_can_finish_inline(struct io_kiocb *req,
 	return pt->owning || io_poll_get_ownership(req);
 }
 
+static void io_poll_add_hash(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_HASH_LOCKED)
+		io_poll_req_insert_locked(req);
+	else
+		io_poll_req_insert(req);
+}
+
 /*
  * Returns 0 when it's handed over for polling. The caller owns the requests if
  * it returns non-zero, but otherwise should not touch it. Negative values
@@ -591,18 +599,17 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
-		if (!io_poll_can_finish_inline(req, ipt))
+		if (!io_poll_can_finish_inline(req, ipt)) {
+			io_poll_add_hash(req);
 			return 0;
+		}
 		io_poll_remove_entries(req);
 		ipt->result_mask = mask;
 		/* no one else has access to the req, forget about the ref */
 		return 1;
 	}
 
-	if (req->flags & REQ_F_HASH_LOCKED)
-		io_poll_req_insert_locked(req);
-	else
-		io_poll_req_insert(req);
+	io_poll_add_hash(req);
 
 	if (mask && (poll->events & EPOLLET) &&
 	    io_poll_can_finish_inline(req, ipt)) {

-- 
Jens Axboe

