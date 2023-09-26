Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2C7AE627
	for <lists+io-uring@lfdr.de>; Tue, 26 Sep 2023 08:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbjIZGlg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Sep 2023 02:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjIZGlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Sep 2023 02:41:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10374E9
        for <io-uring@vger.kernel.org>; Mon, 25 Sep 2023 23:41:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3231e138f44so509253f8f.0
        for <io-uring@vger.kernel.org>; Mon, 25 Sep 2023 23:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695710485; x=1696315285; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ffVsp3XgCa3HFUWUSmx44KcvJBm4g8vYR0LbPrRFOWA=;
        b=Pey6gtEWMIegUm5jPk53P85QRcWuFCtHLijxt6VipS6QtMmHnlDJHHi8rFVKSxlTMQ
         N6vRhYdpSFcwzUuuHrMcZojBTsnfVzX3U8epyfnfosEcgsQQE9bRHDOBnXGh4R4t4ieu
         ZUSrhhv8PUnUMAjuVnCU+CIVP2v10iQMtxqK8L6Y6QOVs+ELIkHXAIipeCatCk9fCLmE
         MyywKsJsLjC/pUTkUrHqBUBe8z1swgAtvJLKmTFz4UBtXKTBpxGJDrAEbZhM8lz9IVST
         6/5+2A4nMPOxUEobm/rApNepva2lE9yT4fOSDhC95L6WSsLy1LOvXQ3+/35g5DCojSB8
         12qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695710485; x=1696315285;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffVsp3XgCa3HFUWUSmx44KcvJBm4g8vYR0LbPrRFOWA=;
        b=RI9HNbhjj+NBthO+reMKiaN8vBHPTuQj5Gr7M73DWYRQEhOpTULTxOOc8usPyyIlPi
         6bE+rQsKtEuBDIq0neJihz7YWciTQwQClMhyJq1bMBaeGSn9Q8LQn0gZgf7RMXsSIpe2
         +/N5fH1wKbUbvNAaLckjC2HXEIW9AqDbT8W8DMY9SWQeh3mvwyYbQiYqyeyZj3v1DAXb
         R+iI6E0qIPnXz9rnru5xdcjfl/vcnr4WKLrL6gAEA/iMjPH15/fA5qGsFPLohm1e+rjL
         AYGFtfLje4EgbcQVNrL02nqSpxyz08q4Uhdb+WyM8TUzuVbkhsSHDJ7vyYr2xPd12AVa
         w6Ow==
X-Gm-Message-State: AOJu0YwACdF1kdejwq3v+bdETDLx2u2X1KgUAzHnYSsIBABp8qT2L3Bo
        438u9yQBT8U4QQHuTEQpTP98gsjOo3oTEsELtyPEBjNS
X-Google-Smtp-Source: AGHT+IESscYEKAKNzE15oQfDIyUWfZoGqReJWnCIZkFy9ySvXdllwfCRKQnSo2oF1LCnCk+sDrji7w==
X-Received: by 2002:adf:e7c7:0:b0:317:5f08:329f with SMTP id e7-20020adfe7c7000000b003175f08329fmr7964722wrn.1.1695710485575;
        Mon, 25 Sep 2023 23:41:25 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ay18-20020a5d6f12000000b003143cb109d5sm4624976wrb.14.2023.09.25.23.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 23:41:24 -0700 (PDT)
Message-ID: <9eb0fa5e-5f8d-4a55-940c-5e1ec22bbfd9@kernel.dk>
Date:   Tue, 26 Sep 2023 00:41:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] io_uring: add support for vectored futex waits
Content-Language: en-US
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de
References: <20230921182908.160080-1-axboe@kernel.dk>
 <20230921182908.160080-9-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230921182908.160080-9-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After discussing this one with Thomas yesterday at KR2023 I had this
nagging feeling that something was still amiss. Took a closer look at
it, and there is an issue with the odd case of
futex_wait_multiple_setup() returning 1. It does so if a wakeup was
triggered during setup. Which is fine, except then it also unqueues ALL
the futexes at that point, which is unlike the normal wakeup path on the
io_uring side.

It'd be nice to unify those and leave the cleanup to the caller, but
since we also re-loop in that setup handler if nobody was woken AND we
use the futex_unqueue_multiple() to see if we were woken to begin with,
I think it's cleaner to just note this fact in io_uring and deal with
it.

I'm folding in the below incremental for now. Has a few cleanups in
there too that I spotted while doing that, the important bit is the
->futexv_unqueued part.

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 0c07df8668aa..8a2b0a260d5b 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -23,6 +23,7 @@ struct io_futex {
 	unsigned long	futexv_owned;
 	u32		futex_flags;
 	unsigned int	futex_nr;
+	bool		futexv_unqueued;
 };
 
 struct io_futex_data {
@@ -71,25 +72,21 @@ static void io_futexv_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct futex_vector *futexv = req->async_data;
-	struct io_ring_ctx *ctx = req->ctx;
-	int res = 0;
 
-	io_tw_lock(ctx, ts);
+	io_tw_lock(req->ctx, ts);
+
+	if (!iof->futexv_unqueued) {
+		int res = futex_unqueue_multiple(futexv, iof->futex_nr);
 
-	res = futex_unqueue_multiple(futexv, iof->futex_nr);
-	if (res != -1)
-		io_req_set_res(req, res, 0);
+		if (res != -1)
+			io_req_set_res(req, res, 0);
+	}
 
 	kfree(req->async_data);
 	req->flags &= ~REQ_F_ASYNC_DATA;
 	__io_futex_complete(req, ts);
 }
 
-static bool io_futexv_claimed(struct io_futex *iof)
-{
-	return test_bit(0, &iof->futexv_owned);
-}
-
 static bool io_futexv_claim(struct io_futex *iof)
 {
 	if (test_bit(0, &iof->futexv_owned) ||
@@ -238,6 +235,7 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 	iof->futexv_owned = 0;
+	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = futexv;
 	return 0;
@@ -278,6 +276,18 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = futex_wait_multiple_setup(futexv, iof->futex_nr, &woken);
 
+	/*
+	 * We got woken while setting up, let that side do the completion.
+	 * Note that futex_wait_multiple_setup() will have unqueued all
+	 * the futexes in this case. Mark us as having done that already,
+	 * since this is different from normal wakeup.
+	 */
+	if (ret == 1) {
+		iof->futexv_unqueued = 1;
+		io_req_set_res(req, woken, 0);
+		goto skip;
+	}
+
 	/*
 	 * The above call leaves us potentially non-running. This is fine
 	 * for the sync syscall as it'll be blocking unless we already got
@@ -287,29 +297,23 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 	__set_current_state(TASK_RUNNING);
 
 	/*
-	 * We got woken while setting up, let that side do the completion
+	 * 0 return means that we successfully setup the waiters, and that
+	 * nobody triggered a wakeup while we were doing so. If the wakeup
+	 * happened post setup, the task_work will be run post this issue
+	 * and under the submission lock.
 	 */
-	if (io_futexv_claimed(iof)) {
+	if (!ret) {
+		hlist_add_head(&req->hash_node, &ctx->futex_list);
 skip:
 		io_ring_submit_unlock(ctx, issue_flags);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
 	/*
-	 * 0 return means that we successfully setup the waiters, and that
-	 * nobody triggered a wakeup while we were doing so. < 0 or 1 return
-	 * is either an error or we got a wakeup while setting up.
+	 * Error case, ret is < 0. Mark the request as failed.
 	 */
-	if (!ret) {
-		hlist_add_head(&req->hash_node, &ctx->futex_list);
-		goto skip;
-	}
-
 	io_ring_submit_unlock(ctx, issue_flags);
-	if (ret < 0)
-		req_set_fail(req);
-	else if (woken != -1)
-		ret = woken;
+	req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	kfree(futexv);
 	req->flags &= ~REQ_F_ASYNC_DATA;

-- 
Jens Axboe

