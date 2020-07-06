Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65A7215A2C
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgGFPB1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 11:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFPB1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 11:01:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6FDC061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 08:01:26 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so42569150wml.3
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 08:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lNhhT5zICpCU0Vdw9Rm8eS4i0kyOPY83FeG06hGuko0=;
        b=jpBAKKpvV7BIconjlk8/1igiRJIDMxkUajKWuA5V4gsu6MLXTOl7da2f43McMtxv2p
         t81cIHy63AWNqB9BYXl/ek/ZzxnC70tv5A9cgG/FxUJbEgtIZ7NMA7Q5yt6Dc086l2Zq
         Ls4r+ChyZvIS7Z8zOHFSaOriJaqdk4k7+hdrGoPBRtsEc7OSegIL70+q5n5IG+iC4xM4
         XYeXK+N4FPqKEOtNRwWugbAfI3qZbWLuiYX9nLOYOrZiHoMXPrz8ruvswZ8vUdvNztXT
         32LUx6JN3ek45e0kko+G1GDTspyrSyha4aNaEble01dNRkAY6aIqudNwMWV9T2mn4MkR
         an7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lNhhT5zICpCU0Vdw9Rm8eS4i0kyOPY83FeG06hGuko0=;
        b=iBUXQ/19GOP0LUAh7ICL6IKVLRDnGkYrmOyWtchoEO+5ne604uzrAVsBpm9MKrlRJG
         6kTq3A37l5ZZ8mOEyVjRiL8W+WmLx36YDsBzzTX0qF3syCzX4g0UiMYsN6xMTKzuIhc7
         nPxCx+sB2qyQ/6U/FeiI468blYdN+wrqd6RGyYN63uzFhZARKH28afkYub2Fa44fybEj
         NF/tCXo8JFhhWZNuI5ki0ecPI55AbBB55fsgfoPNn0+dGcoYp+wy2h8YA7s5fHYy5fhU
         ox2ybBP0eFsPDkfTT904RC4zpWUpS37D5o93NICR4amU+nhGfZZD6pS8W3HLON4Jghdo
         8FIQ==
X-Gm-Message-State: AOAM532OHUK/B1yF9S6xymhHglcBfFSAM5nCZ3QpTjsb3JaxsHFZ6r0R
        JKDc6dPfXbAW3JBS+tsYI3U=
X-Google-Smtp-Source: ABdhPJwf8+8aO0AImWwWYhon6KxtJDpR7CFxa4OADu39WPmSEcCZAnTLikFs1oiGC9W9MCfDsXrrkA==
X-Received: by 2002:a1c:e209:: with SMTP id z9mr50567447wmg.153.1594047685653;
        Mon, 06 Jul 2020 08:01:25 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id k18sm15626168wrx.34.2020.07.06.08.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:01:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/3] io_uring: briefly loose locks while reaping events
Date:   Mon,  6 Jul 2020 17:59:31 +0300
Message-Id: <e454be4ccca6059df91a691b64f4fd40578925de.1594047465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594047465.git.asml.silence@gmail.com>
References: <cover.1594047465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not nice to hold @uring_lock for too long io_iopoll_reap_events().
For instance, the lock is needed to publish requests to @poll_list, and
that locks out tasks doing that for no good reason. Loose it
occasionally.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 020944a193d0..54756ae94bcd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2062,8 +2062,13 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 		/*
 		 * Ensure we allow local-to-the-cpu processing to take place,
 		 * in this case we need to ensure that we reap all events.
+		 * Also let task_work, etc. to progress by releasing the mutex
 		 */
-		cond_resched();
+		if (need_resched()) {
+			mutex_unlock(&ctx->uring_lock);
+			cond_resched();
+			mutex_lock(&ctx->uring_lock);
+		}
 	}
 	mutex_unlock(&ctx->uring_lock);
 }
-- 
2.24.0

