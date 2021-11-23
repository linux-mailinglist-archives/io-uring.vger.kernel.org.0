Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E4C4598FB
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 01:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhKWALr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 19:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhKWALq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 19:11:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D6EC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:39 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so504698wmb.0
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3mj6V2jtiOF0XIa0IrL9KBqA7RExUAbt8rE+d3724YU=;
        b=nyi1piQ73Xk2wqFZ3DMtNisSv336jRgeEapHtT1O0/1vKs6CacObBOUUcvesIyqsyW
         k73Cj+1LyUlBBuNkPPrf5gDPSjvbhv2CA/jr6Sw4omhBY2mkZKvcVunPb2D/tLsJ2V0q
         2aqALUJ3qnP+oX3uY3Nr7+XzxCI/9iEwm55vyubrIKohdeRkHnVa9iptdficZZx/46Ci
         L7ymnqm3jfcGXO9g4aQS+5lvmfxAUvqbHITBV5TyJuYMgxu/ytcNbeT3MSKE7JVj4Jj6
         FOeuyYQefCnLXaVQ6zdidh8GSc81y1NJQeaxZwg5JBWunHCvYd/zFfvIBChFO7w8kXIc
         82SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3mj6V2jtiOF0XIa0IrL9KBqA7RExUAbt8rE+d3724YU=;
        b=A5ZAiiu8VqOES63U++jYWfdWLUv89a81x1iQVGZZNBTcQKbXOxxEEOUM7DThxu/KrM
         vij8XSTIfGDXf8KNMLdYWAeD/z1pKBDjj54rWF5mt7ZrADXV7pO1mwk4hHBDFX/0SwBc
         8ci3WDDNVN3/wkT7g8/pCG+yBS6k3csBg/xpKH/b63OGEXI5A9QhnksGQKpiIxUQ7v+T
         +kF1DlkIavKvPvJEKmtCCA8nEv0tC3eptt+K60dQFFepEriUyhaoSkkUiF61d5XUQ6Ch
         5qGvDm4AQRr0+LfqrN1KiKtoEpJKB7oNnljAHoBXrDVM5W2Sdb/oYQcocq3nJLpmVyRd
         o5GQ==
X-Gm-Message-State: AOAM530NkGRTaOt5TNvsWVwrn7lnlBd4O6aiBsJC3DRhbFSe/4W58m/6
        gvTrwPkbaLCe8Gw1fymwO3oYGeYzwcQ=
X-Google-Smtp-Source: ABdhPJyio5bKMf0EUFwoXKv53NC1pUJ4S/COT5Cs/ASq8YspSl0UcwiPVxDPSaG5Q2l29iaMAEToLw==
X-Received: by 2002:a05:600c:4149:: with SMTP id h9mr1515259wmm.100.1637626117763;
        Mon, 22 Nov 2021 16:08:37 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.196])
        by smtp.gmail.com with ESMTPSA id r62sm10139409wmr.35.2021.11.22.16.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 16:08:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3/4] io_uring: clean __io_import_iovec()
Date:   Tue, 23 Nov 2021 00:07:48 +0000
Message-Id: <5c6ed369ad95075dab345df679f8677b8fe66656.1637524285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637524285.git.asml.silence@gmail.com>
References: <cover.1637524285.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apparently, implicit 0 to NULL conversion with ERR_PTR is not
recommended and makes some tooling like Smatch to complain. Handle it
explicitly, compilers are perfectly capable to optimise it out.

Link: https://lore.kernel.org/all/20211108134937.GA2863@kili/
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8932c4ce70b9..3b44867d4499 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3179,10 +3179,12 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 	size_t sqe_len;
 	ssize_t ret;
 
-	BUILD_BUG_ON(ERR_PTR(0) != NULL);
-
-	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED)
-		return ERR_PTR(io_import_fixed(req, rw, iter));
+	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
+		ret = io_import_fixed(req, rw, iter);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
 
 	/* buffer index only valid with fixed read/write, or buffer select  */
 	if (unlikely(req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT)))
@@ -3200,15 +3202,18 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 		}
 
 		ret = import_single_range(rw, buf, sqe_len, s->fast_iov, iter);
-		return ERR_PTR(ret);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
 	}
 
 	iovec = s->fast_iov;
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		ret = io_iov_buffer_select(req, iovec, issue_flags);
-		if (!ret)
-			iov_iter_init(iter, rw, iovec, 1, iovec->iov_len);
-		return ERR_PTR(ret);
+		if (ret)
+			return ERR_PTR(ret);
+		iov_iter_init(iter, rw, iovec, 1, iovec->iov_len);
+		return NULL;
 	}
 
 	ret = __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, &iovec, iter,
-- 
2.33.1

