Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB6C66CB0F
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjAPRKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjAPRJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:09:35 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0887B30E96
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r9so5270834wrw.4
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wOFxYl+IwkJPDCs4oErn8zIhjGgRCEYtnumZCpr7igY=;
        b=bY6qNLI69LbTWYsZhHeanhA92zBRD34Nl1jzUKwgKZXDfdQtlfmtP2HHYEqBLXhkcP
         4FFSIV71eEW6MQ8NXwMYIKvwVGMK/0zbWc0jf/d7WsSTwU4+HzqK1gWa5ugnMRxF8Md7
         Shf1pjuea4jFHBcu69d/pg/PQXalfr2RBvYdrqEX6vela0DQCxblPcBjEI5fPHKWpxpP
         b2VKWfO3jSGKB9OwQJrxN9kCJYbotmC6g7GU7qT+6Cp7YnjaXqZv71/4J9PqrOUOpN+O
         KYCsj5x+rNPbMmi+2QQOLAvR3uMO23hwrMZc+SPHyfVhAk+UWcbMGiP5CDjKzIQ6wC8T
         Vq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOFxYl+IwkJPDCs4oErn8zIhjGgRCEYtnumZCpr7igY=;
        b=eY1GHERimTkFWstFIYIv13PhQzSnNLVSYsAqlZ/fZszF/KSvs/CpgCSMNkKOZOoiz+
         h98/TQISYw+uudUTLWFzPDw7WU7VNQP4U2wXTbc8aZbkAQGUXAV0qmPN8wPGRNJq/NOR
         eIjOfnwvNeqFUwrvOU3FNTSEnnC3Bcq077npyjgcHgej9RCvyWd9lIJjEiJ7d+LJOxsh
         SnUJIn7dh4cfiK8WPThG5RcS+GGHzo6uo2GElRa7jpGomg6f+OL/A7BO0OA8Kyq8qYw0
         286hP/SFeo0x9aTXTwnTXV0TE9mhe/VvCN2WFu2bjoLG8/LHJ3b5pyhJq9HjphS+hAWy
         /mbA==
X-Gm-Message-State: AFqh2kqPpDn0OBIA8kOtIxT1AO7UG2upWGkpzIdIvBoBLzxGKBTd3bCk
        xIGiFvIzrUdtcaaAGNQA9FWFyI0Bdmo=
X-Google-Smtp-Source: AMrXdXuXfnSAbqYz+aKut/5kN9SDDxjx0KMSEAUstOFeKVNj4uKuTwydhxjjFib/34XkUmZGjDd+Sg==
X-Received: by 2002:a5d:6a87:0:b0:2b8:fe58:d368 with SMTP id s7-20020a5d6a87000000b002b8fe58d368mr150425wru.29.1673887803498;
        Mon, 16 Jan 2023 08:50:03 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm20872372wrv.11.2023.01.16.08.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:50:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/5] io_uring: refactor __io_req_complete_post
Date:   Mon, 16 Jan 2023 16:49:01 +0000
Message-Id: <2b4fbb42f404a0e75c4d9f0a5b16f314a839d0a9.1673887636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673887636.git.asml.silence@gmail.com>
References: <cover.1673887636.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep parts of __io_req_complete_post() relying on req->flags together so
the value can be cached.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e690c884dc95..27d9abd24a83 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -974,14 +974,14 @@ static void __io_req_complete_post(struct io_kiocb *req)
 				req->link = NULL;
 			}
 		}
+		io_put_kbuf_comp(req);
+		io_dismantle_req(req);
 		io_req_put_rsrc(req);
 		/*
 		 * Selected buffer deallocation in io_clean_op() assumes that
 		 * we don't hold ->completion_lock. Clean them here to avoid
 		 * deadlocks.
 		 */
-		io_put_kbuf_comp(req);
-		io_dismantle_req(req);
 		io_put_task(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
-- 
2.38.1

