Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F082290C82
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 21:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391538AbgJPT65 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 15:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391494AbgJPT65 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 15:58:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FBAC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 12:58:57 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id n18so4337807wrs.5
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 12:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IV5Irtg1kQROjALInvaOxPaTKmykLPyNTncEih282aI=;
        b=enNIYKIy95O/YH31ONe7boZ3qynvrJJTiPNzw2UgTpiJhtsfmsZ6ApFsO2xw8EP9sW
         YECZrA+Al5FNzuTVGEMDgBZ7jk1JxMZpLnVXYURhk27BzTkc7dCKGLhrH20A64o4x2/O
         gZryfFvnVSt5X+E34ffnmDca/b5/t+RgTvPwJHpg0/4OW6caOrowYMU55ziOiMl7E9ca
         x52nUydca3+WYzp2K9p2Yhxk3MDr0RrNciqu0w7t+hoZxN2SklYhB5XR//hZiKAg3ezn
         5OgRVM8XNbCT4NKjNY9QjlG4J76ex6F8x4G+MdyoJxZYRhQUOySP+oFd7V/bhblWLACc
         c/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IV5Irtg1kQROjALInvaOxPaTKmykLPyNTncEih282aI=;
        b=fbKV89rhiZUA7JkjADIw+gmckYo+WmYgbyT4yWIVgGbbRzKcCLGsne/89TEdR3gdZE
         zDFy6b6BFzuQacXJrCOVtPVu+1qg9Y4igkKnk9UTeLrkZGIWmHnq8mpH7wV+leQQvFoV
         WPccALjb5oZr0NOBULLGLHvHlT5Ckpr4LKN4bHxm5W+F0AWOcS7qpzck49IuuEFK2vDw
         DywZOxI699JFNwWWKMVbH2JryQEMG+qJJG6JJxyB3JPI2UrPUpODXgQHZT30w/sMM90C
         34+KNCElxwKCMpl0elm/SWAAQrjQn10NCG/+c9QfgVZQQZWxBVYNBexIp17A89QdFblN
         IfvQ==
X-Gm-Message-State: AOAM5337LcX7pPRLZ05maXAs+Ox2+5crhehb/+T8lPn68c5Jiqge60Dn
        4UBgnk/HHUBLMYs7tleRsjDXgIG4vTSQow==
X-Google-Smtp-Source: ABdhPJyaG2q+ltiGt74tUiOwk8WS+pzGliXlOVL2wG2Q0FPNPcQTrIpMyzjduyueQE/gjX3BSuEoOg==
X-Received: by 2002:a5d:5748:: with SMTP id q8mr5820586wrw.299.1602878335814;
        Fri, 16 Oct 2020 12:58:55 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x6sm4334460wmb.17.2020.10.16.12.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 12:58:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.10] io_uring: fix double poll mask init
Date:   Fri, 16 Oct 2020 20:55:56 +0100
Message-Id: <1c2b730ad1b1d0ec12c818457598cca50f4505af.1602878022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602878022.git.asml.silence@gmail.com>
References: <cover.1602878022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_proc() is used by both, poll reqs and apoll. Don't use
req->poll.events to copy poll mask because for apoll it aliases with
private data of the request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c83c2688ec5..ff8fe29e2931 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4890,6 +4890,8 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	 * for write). Setup a separate io_poll_iocb if this happens.
 	 */
 	if (unlikely(poll->head)) {
+		struct io_poll_iocb *poll_one = poll;
+
 		/* already have a 2nd entry, fail a third attempt */
 		if (*poll_ptr) {
 			pt->error = -EINVAL;
@@ -4900,7 +4902,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -ENOMEM;
 			return;
 		}
-		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
+		io_init_poll_iocb(poll, poll_one->events, io_poll_double_wake);
 		refcount_inc(&req->refs);
 		poll->wait.private = req;
 		*poll_ptr = poll;
-- 
2.24.0

