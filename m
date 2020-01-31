Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730D914F46F
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgAaWRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:17:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56238 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgAaWQ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so9713178wmj.5;
        Fri, 31 Jan 2020 14:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yDObMkkxZHiB5mrA8yPEQOU8lLX3ZKhAwgKvqu28hoY=;
        b=PwcNvZ68cHeFPMTL71i6DL/Q62t1jlA2tVoL6z4K0ateXYlIEmNK7gXGD0dIcbdd18
         LTMrBG1/wcIlQDt9+TUg46VOuc+TzzR4HCdYMNbceNwLvsmrxBxensXH5rhE4zMs/PJW
         AsZusdE2fIzD5djbhLYxvn57AuP6WFZPkKL3aKHXsQyXeQs2oqrQkRQoA+rd+fy27/oT
         oU7GQo2hOHCWhditWpHZj6Bn8biH77EvFTX6rTGU4yO1SG6KcKQKpnxqye4/1jl97/EZ
         VSmeVhdPUWk6VXE3rk2uMzy23KbJROrxnFwZfRRUA7/JyUtzWjkQ45wFHrFQzYqW4r9r
         25uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDObMkkxZHiB5mrA8yPEQOU8lLX3ZKhAwgKvqu28hoY=;
        b=l6ScUiNIkLYuvO+biB+F0df1m1mTBsRE5yYiHhAx4LLiI1n6GTN/akZxirSNUJd5Gm
         rewAWjpjlKGnitl9iSfOWiK+JhWBhElydGZBHcV+n7VyoU6BHmMRv4r/Bb8yqzVHnCqZ
         aQuHK8mWQCmlm9WHP7ia67mHoHSiAL+McBLl3JpE3ikfAbEW6DKk7A2ub0mi//oyBUbd
         SLp87g8x1ussPm9BqeQpyWkWqle0AD16DEaOM8ng01z8vIX40wkLpQNShSHKxYZ1RMth
         Z2w7FnCpHXg6JgQhsBnHp7Ec8VZ/yciIcUBSkIawn+Ls5zQ+Tc4lrY2fyxv/hqA9p83h
         boSw==
X-Gm-Message-State: APjAAAVOwuYUCK9ogaEysS8fOI89F7NAydPopjdec3YZ5fATlET/RHdZ
        9vFyvUJGwYhwrxwah2KLFBf0S2L5
X-Google-Smtp-Source: APXvYqwm546152FHR1DqhJETMuLkNmdEOlEj6pzvX8Ss2vZEqMKS4DiWla1h0bvsFtwMbk6um2uxiQ==
X-Received: by 2002:a1c:f003:: with SMTP id a3mr14556981wmb.41.1580509012460;
        Fri, 31 Jan 2020 14:16:52 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] io_uring: optimise req bulk allocation cache
Date:   Sat,  1 Feb 2020 01:15:55 +0300
Message-Id: <3811fb8e56319d8f1b7952bcaf2c73abd2acd770.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
References: <cover.1580508735.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66742d5772fa..799e80e85027 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -206,7 +206,6 @@ struct io_submit_state {
 	 */
 	void			*reqs[IO_IOPOLL_BATCH];
 	unsigned int		free_reqs;
-	unsigned int		cur_req;
 
 	/*
 	 * File reference cache
@@ -850,7 +849,6 @@ static void io_init_submit_state(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	state->free_reqs = 0;
-	state->cur_req = 0;
 }
 
 static void io_clear_submit_state(struct io_ring_ctx *ctx)
@@ -858,8 +856,7 @@ static void io_clear_submit_state(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs,
-					&state->reqs[state->cur_req]);
+		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
 }
 
 static inline bool __req_need_defer(struct io_kiocb *req)
@@ -1204,12 +1201,10 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
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

