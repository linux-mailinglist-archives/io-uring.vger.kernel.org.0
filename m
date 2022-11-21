Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5112E632744
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 16:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiKUPE1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 10:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiKUPEB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 10:04:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C2BC6D21
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 06:52:30 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y4so10807975plb.2
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 06:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdB9KzAivEjMhOcjn85wRD1fSLjWAh99nsFzyAlSGw0=;
        b=V6DKIFmcMvfWY/4nEs/9yfmrGuv1/fN8Ufw6RCXLXNaH+9GLaF/sdPWUyauM9iYcbc
         Y8eOU0N1BCST/gj7FaHyfR6dP7uM1/IFOX6BgzrCbkyy2f7HVKdXLXrehCtnIaf/H4Bh
         i6HNn0QNF4Wgpmd181L+SZMUdMe7JzYcusD8sW1Y+nm6QbDu1g+kkezV+58Glddmruqa
         W/eCl+ZcpI4ojziLIRY3X2kjLFxQAxz7ZqWcAFRHEwPZrfS1Ls6Yu7KGE08Ylqqypfm9
         0lXFuMcQbJMlz4eeO64AZdNY8N0wRwXe+izCPflRWkduE2W1MBfMBUpVQRRiWIZwMwnR
         JEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CdB9KzAivEjMhOcjn85wRD1fSLjWAh99nsFzyAlSGw0=;
        b=HzIYVQfr3zC2uV8vLEzc2i74r94hP+38t+U+moFe+ADY02gjZc4AZEP6FBW0JINSVZ
         dZ9E7WX4TZvETqUeE5z940oQqnujHspYWtt9Q/VnGsUFl1OqHfGKUwDTAA89kuTfhqUT
         mes15J5Sp+GBevfPlrc7q7Yt/4PtLlxwYZTrVZFexkZ5ZCNgOcxChTYJavEQG0AJEMcL
         XZFNAeQ0HumL4ZXfrjTb8B24rkMaGIvUF+Qqzo/p0ky/vKjj7z6XBeJEQnQqwN/cMoSX
         aHc/tnKD0bc2XozhZZPtSg32QNUxh1+9pCMfci7nGMynFumYieOy0ScE4sBky5Qtw9Mn
         DH6w==
X-Gm-Message-State: ANoB5pnhOVhrAEKrLS3Q0JzBEyxdm2Obvp4PopGfr9Zvfp3Tf33zGKsn
        ndvtHt0h78YHwmgol3qbyZNmHeiltWWRPA==
X-Google-Smtp-Source: AA0mqf6S2J9bn/eUFYX5NUyY3dANHudvjWi6MX26APRXwzytBXY2uA75OqrhEsbb5VzBzfJ1MrwfrQ==
X-Received: by 2002:a17:90a:4e41:b0:218:a971:d847 with SMTP id t1-20020a17090a4e4100b00218a971d847mr7031879pjl.91.1669042348662;
        Mon, 21 Nov 2022 06:52:28 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p67-20020a625b46000000b0056bd59eaef0sm8792244pfb.4.2022.11.21.06.52.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 06:52:28 -0800 (PST)
Message-ID: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
Date:   Mon, 21 Nov 2022 07:52:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
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

__io_cq_unlock_post() is identical to io_cq_unlock_post(), and
io_cqring_ev_posted() has a single caller so migth as well just inline
it there.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 762ecab801f2..2260fb7aa7f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -581,23 +581,14 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_eventfd_flush_signal(ctx);
 }
 
-static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
-{
-	io_commit_cqring_flush(ctx);
-	io_cqring_wake(ctx);
-}
-
-static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
+void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
-}
 
-void io_cq_unlock_post(struct io_ring_ctx *ctx)
-{
-	__io_cq_unlock_post(ctx);
+	io_commit_cqring_flush(ctx);
+	io_cqring_wake(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -1346,7 +1337,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		if (!(req->flags & REQ_F_CQE_SKIP))
 			__io_fill_cqe_req(ctx, req);
 	}
-	__io_cq_unlock_post(ctx);
+	io_cq_unlock_post(ctx);
 
 	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);

-- 
Jens Axboe
