Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77014F586
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 01:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgBAA6w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 19:58:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38169 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgBAA6v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 19:58:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so10724568wrh.5;
        Fri, 31 Jan 2020 16:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZb1n8G3lJ99OGYyaDhlaG/vkcxK++nESS/jsSHjsOU=;
        b=uRWaCTccM1/ZvzhssBwy7AWUw4x12+kCVG//d0F9FcNVfNRgw5ByS2dQIixybJjAci
         /daoh5cRCsUqumoV8uYOKOmNs3QJarTz5KHIhYboAUk0wpK15Ywf3xZ0MVKlx1M8aJCg
         jWkOhJ9XTXwcIadHl8njghdzEAeR4PpqJb2H/32211rcBqxzopOnGr3l7GUvIr3iTvAF
         ixLS6nlNYfB5FSZZ98eq+NWNJP+PMoGhlGEImEayjt1OA9jzUQZ4Mio+vCjzihq2ruTZ
         SUy4eED199hzTvimxeUSiwK3kK3cfUSp3fhpGhIrhZiJbTHQrFUHNp4dGqlUk8b2CLsL
         L3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZb1n8G3lJ99OGYyaDhlaG/vkcxK++nESS/jsSHjsOU=;
        b=LzFyvz4dteGBTVEpe15zGgPFoqG9zb/Nc1wuG4FeYb5qrfo5hsO+T7v9RhKUEwGmJJ
         tPKjD2WX6/wwteA8aMIbNkKPaHGUQyqCnxRiP3IJZ3fK032bFoUq5K4PhqalJP9/yHXy
         kM6bUaBrumY5IvrIlsDgw0ZXF13yGEXac9mgkKUwY4O9geRUeioxtnvXAZVgm1PgwfQe
         HrnbSPskF9Kn7oGoq3urYzyb1RQxxELquwbEIsdDgrP9oLFQob5j9BN0pHU2dAMbhDxu
         C2TWVJ8x6Sp0gLrgjoaWjSyhDckphnXE9dzG54/BJ2kBPvdM7Q1hZFtalTSGWcR9HOHe
         ixlA==
X-Gm-Message-State: APjAAAXkwMSsa1eUVwYtluc10PUC67gfCea+5meJxY+1lVl8p0Ld09rD
        S99z+zC2K3w42x3jEiIqKZl4HbWA
X-Google-Smtp-Source: APXvYqwvCKi/uD4fvDYMUyWbpJNbxzTl2kIAuQpihx3oSWD8UQ2Cgwn72x79Kesl1W914AAPOjaEeQ==
X-Received: by 2002:a5d:6206:: with SMTP id y6mr1114837wru.130.1580518729583;
        Fri, 31 Jan 2020 16:58:49 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b16sm12677551wmj.39.2020.01.31.16.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 16:58:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: iterate req cache backwards
Date:   Sat,  1 Feb 2020 03:58:00 +0300
Message-Id: <df6e93383161cd3bdbe19fe816b761af0096c303.1580518665.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Grab requests from cache-array from the end, so can get by only
free_reqs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb5c5b3e23f4..73a6c6a4ec50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -585,8 +585,7 @@ struct io_submit_state {
 	 * io_kiocb alloc cache
 	 */
 	void			*reqs[IO_IOPOLL_BATCH];
-	unsigned		int free_reqs;
-	unsigned		int cur_req;
+	unsigned int		free_reqs;
 
 	/*
 	 * File reference cache
@@ -1188,12 +1187,10 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
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
@@ -4837,8 +4834,7 @@ static void io_submit_state_end(struct io_submit_state *state)
 	blk_finish_plug(&state->plug);
 	io_file_put(state);
 	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs,
-					&state->reqs[state->cur_req]);
+		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
 }
 
 /*
-- 
2.24.0

