Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF8B14904F
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAXVlt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35738 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgAXVlp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:45 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so895301wmb.0;
        Fri, 24 Jan 2020 13:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KSvta4TBQX/4nmodSvroY5yj7bHCl7+1H41So5HeKu0=;
        b=gEFeUptWe1iCY1Zmn+Daj4BnKN+y/+RsHT2VOnbrWPJ/kFmJVsTWGsw+G9QebiCq7d
         ZvIlY9BS0rSHPms3/JTug+q9csj3v4gCouulZ52cLC7Zm4/oepPB90VmmOFxDh1X9nr/
         NdWnjsaOPEFamuVIBob7q5LWDeJ5Iyiao5Ua2m3+hRv+mCjODGIjTGj/9GJ21EWAwNcG
         mx2PGFnYBJNAnV/sX8oOhIwSsduLFcVVPY7AEohiDab2IWNRPoXKPn9SMAmXUonbmcuV
         nf8tfipNqG6W7hOj/696wCD16KN/4HOGN1ICUOivyjyW/QL2gULVjLjejc+BJ3GjkkUE
         RmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KSvta4TBQX/4nmodSvroY5yj7bHCl7+1H41So5HeKu0=;
        b=tgDri8IgGdGjvyvz7x94yRzgwVyGAsz6MCoqHqpU6XiZVHhEF5uYVDu8yoj5fMsdan
         kleyo9s20oVYiWUtT1Z287XulQXJGOZnX90h9VqPTPMCHp5w8SyGbubsbfkM4+toKjcy
         h67d4gHHdVpEuWyaeLA1kPWfJ0TPsCzFfyIt1dnUuHcVuVjZABtZxw0W6Fe3+MVrICbV
         iH2eQw/m0Ka+9wvGNngpUXA+7DeFLMebmkNe2P/dZGEtQY3+Ro55xnX9y1yyP9S5ioUn
         kkUL8ZDVe38GorKIUbXkCXW9EP264pciwThkEKuf0qVKm0eB30FDYkn9iIWn16w2N6hb
         pGjA==
X-Gm-Message-State: APjAAAXE8Kv+hRnxMfSrJq2CaXKVkx/ZgkUUjzi8MlDMvN9fmS8S2nkC
        wETdQ3GgbKg/+pHH9hgiNq4=
X-Google-Smtp-Source: APXvYqzro8IOxcaj0yJexm/IHhOH24EdfhzX/zCkUcF9jbGj3nHTMyYGfWeVQCB2vkpXP+vLNomJYA==
X-Received: by 2002:a7b:c389:: with SMTP id s9mr1015352wmj.7.1579902103267;
        Fri, 24 Jan 2020 13:41:43 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] io_uring: optimise req bulk allocation cache
Date:   Sat, 25 Jan 2020 00:40:31 +0300
Message-Id: <6fecf00beff16ec089733dd502a55649ac672e43.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Traverse backward through @reqs in struct io_submit_state, so it's
possible to remove cur_req from it and easier to handle in general.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aed19cbe9893..a4b496815783 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -206,7 +206,6 @@ struct io_submit_state {
 	 */
 	void			*reqs[IO_IOPOLL_BATCH];
 	unsigned int		free_reqs;
-	unsigned int		cur_req;
 
 	/*
 	 * File reference cache
@@ -839,9 +838,7 @@ static void io_init_submit_state(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	state->mm = (ctx->flags & IORING_SETUP_SQPOLL) ? NULL : ctx->sqo_mm;
-
 	state->free_reqs = 0;
-	state->cur_req = 0;
 }
 
 static void io_clear_submit_state(struct io_ring_ctx *ctx)
@@ -849,8 +846,7 @@ static void io_clear_submit_state(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs,
-					&state->reqs[state->cur_req]);
+		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
 }
 
 static inline bool __req_need_defer(struct io_kiocb *req)
@@ -1167,12 +1163,10 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
 			ret = 1;
 		}
 		state->free_reqs = ret - 1;
-		state->cur_req = 1;
-		req = state->reqs[0];
+		req = state->reqs[ret - 1];
 	} else {
-		req = state->reqs[state->cur_req];
 		state->free_reqs--;
-		state->cur_req++;
+		req = state->reqs[state->free_reqs];
 	}
 
 got_it:
-- 
2.24.0

