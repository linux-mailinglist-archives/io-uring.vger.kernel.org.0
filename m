Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9BC14979B
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAYTyy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:54 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52552 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgAYTys (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so2763260wmc.2;
        Sat, 25 Jan 2020 11:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UxPjvRLp7HH7wMgifu5tZ7EEC3wPbmsFC8Mid7/22c8=;
        b=Qcs7oJmBCgKjZJdPpAsBUIl1/TEEiDWoyvDe/Cbc1IkLcqxr9eGqegjgfh1OqYl3+o
         lG8KfWXu2RryXLURoynkszkPkwVchQbqwM98LZFWEiAQWYHfuUPWkyWNXkRGjE8/hEEC
         v0hEES3PoatK6/LXZ+4rcleU2QmKsDcQTYHZTQv8tUBTPyDQSU6M+6oAtTgkfQaoqnJE
         gdfVqRqFcDOzPGtMEpRqT7h6Iw4GaPe/wX5+b8F6d6OnaZdZyZrwVcLqTWixwYq6lc70
         wRUSsc4RAJL0iSd9WVlRVrdC3j+YW520yja7nuPFBJEAEu4UvFUIwRF+80mnlx/uVzXp
         ttbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UxPjvRLp7HH7wMgifu5tZ7EEC3wPbmsFC8Mid7/22c8=;
        b=fOspklvjCmbBvIBjEOoHLRSew4ay7brUyPQMJ2U74Jsxj6HCK7IoG8HLGx/gJ3cokl
         1S9pFyQXKrL2X/J30Hf8tzibzTI7pRT2n1iVcTF52udmY9sr40QxrPQAWUTiuPGJAAWn
         4adgYzvHZ/3Y5aa6LdCtAkeazErHmHF6l87tfq/EsZyEEOGjOD9srArxzBXLEugEMgbf
         GhWFUNDGuO8xVP/a2xsHcfPC6WMKSlJ5LAHslgEDGilA+34T0V6HKPP6w49IjpXUxh0F
         f8Nl5T3FLCb+B71YTmSikMvdMlv1GDZ2PvYwJ2/DRqrc7HDKF67bblP4TTtf/vp5AMl2
         h7Qg==
X-Gm-Message-State: APjAAAXSpcaA0wuzdcAMclyB1ENFva0W3wyJO3neENwY3qYyEQ3tLujl
        9kyqa+mn3Nj+EtYnZxV7z7A=
X-Google-Smtp-Source: APXvYqwayEpuZJo6DrX77T471PdvaJ7DJ727rJhTVRilF9qR530ub4yGdhzluZ+3zPjIroSj6lnrWA==
X-Received: by 2002:a7b:c14e:: with SMTP id z14mr5009732wmi.123.1579982086717;
        Sat, 25 Jan 2020 11:54:46 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] io_uring: optimise req bulk allocation cache
Date:   Sat, 25 Jan 2020 22:53:45 +0300
Message-Id: <b67d587509e46c9ae379a9492a0b01539c218ec6.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
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
index 82df6171baae..744e8a90b543 100644
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

