Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C1525EB15
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIEVsa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbgIEVsX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:48:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F351C061246
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:48:21 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a15so12996685ejf.11
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+vNv0ZaqJZjvLjFdE9I2Y+JlaFsH69eT1hMW4bCVddI=;
        b=JYlEdnXkYjVBJ5wVILWUbmiWpl5NqRLQMlOIMI6WVtpzWbZIGDqIN8rb9uCBqkElgj
         zcVdaaBWrvnDdVYgnLi1u9ek07JlGb1wnnN7QjN0/bBchUImooiUCCG2fpcB7ZOZV6gm
         Bba9XhmJycpb9KeszXXzZBaYnPuqX793lR7HxPK1zCLckqXpYao3Gru7CpbxQObidwAG
         u3WskByR+3f/iBcDXe1sZ2fPT7QZjabWBXdXepygC25PWC7YuC//qrAPvfngFSshQsK1
         qhAMrWiBU2OXA9EJR/sYSvEd0sTFqUMdMVzP4fVVZ0+QbXa9Rkm8NdapIVuOpLkh2kq3
         +EXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vNv0ZaqJZjvLjFdE9I2Y+JlaFsH69eT1hMW4bCVddI=;
        b=E0s4fBuRv76WQBBvEnsynaO7maewEATl6lTtTut30/C9j2LkYL6PnkzjDTTW/GdDkj
         YBGuYAbPOQYpwFnNX5QRXs9FCvRaWC1/T6sZ4//eo3gIGUA+aiNBm3sl4R7L3fL9y9ad
         quFZOCaS26q4hl+6S75tcZ+7BIt99u3Lhf+WMBUzwFisndSSvDn84wrrdIWPyDFqHCRF
         pgC/RwsuX9SaZEkS43Z3SBc7zQ7TpRwIFJp1+Gk8bIFYktg8fkKFF4lL3zsFwLyFvUoH
         N1CPWmQ0bKKa99Sj8gry2W7ecza//JGX1x8OE245nszfpAhlj572LTGXm9GBePoOigZI
         q+jw==
X-Gm-Message-State: AOAM533I9oNYHBlNDjfBgeAFHCuZzZvRpV4z6O/k6wK8z+HURSD0jLVf
        TyFzs/EnA/JuE7JZ/P2u46c=
X-Google-Smtp-Source: ABdhPJwaLkrik9SyilRm72AHS+hJ4HsPIcJV6O0cQGy7JNHV/aaegc+63KC3WOSJ7j04/2bu4VUiVw==
X-Received: by 2002:a17:907:2173:: with SMTP id rl19mr13710910ejb.514.1599342500230;
        Sat, 05 Sep 2020 14:48:20 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id g25sm7965603edu.53.2020.09.05.14.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: refactor io_req_map_rw()
Date:   Sun,  6 Sep 2020 00:45:46 +0300
Message-Id: <aec70b7263344b198af81afdfbd7c48ccc9fae98.1599341028.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1599341028.git.asml.silence@gmail.com>
References: <cover.1599341028.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Set rw->free_iovec to @iovec, that's gives identical result and stresses
that @iovec param rw->free_iovec play the same role.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e45572fbb152..03808e865dde 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2925,7 +2925,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	struct io_async_rw *rw = &req->io->rw;
 
 	memcpy(&rw->iter, iter, sizeof(*iter));
-	rw->free_iovec = NULL;
+	rw->free_iovec = iovec;
 	rw->bytes_done = 0;
 	/* can only be fixed buffers, no need to do anything */
 	if (iter->type == ITER_BVEC)
@@ -2942,7 +2942,6 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 			memcpy(rw->fast_iov + iov_off, fast_iov + iov_off,
 			       sizeof(struct iovec) * iter->nr_segs);
 	} else {
-		rw->free_iovec = iovec;
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 }
-- 
2.24.0

