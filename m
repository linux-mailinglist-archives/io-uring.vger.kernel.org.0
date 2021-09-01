Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB833FE64C
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 02:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242536AbhIAXkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 19:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242439AbhIAXkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 19:40:01 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC10C061575
        for <io-uring@vger.kernel.org>; Wed,  1 Sep 2021 16:39:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so125596wms.4
        for <io-uring@vger.kernel.org>; Wed, 01 Sep 2021 16:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vr/1YtnWLalugmjOQ2NtRDXaYJ/VSXoB5ieKwnkipsY=;
        b=gPLCBaYDjICh9AdAf0DtoI0Cp6hAd30LB8vh7V37DB9WXavefsZG+xN8FaG1aRPLux
         GXsH9SVA9odb20ZA7OI/G+SPhodHntO2s8QgTzDEsaCK5mBVA9RsLyzlgd4ZauuUCayv
         dt40u+hBfvksm1Uy71YdTXbX/NrL1+KJ5AiCk9Y8NPOPNcOteKz7eTW4ULgfxRBDehHv
         gNGdsfLOHQ+afzMRSLjPIJGYPJgYWi0yRC+jjsq2Fjq8HrdEenE7rzd6kWefsHDInVx8
         NFkOjwxe4ArHhtUysyKJckIKBSA7fTw3zpBMy0CVPjx7SixvtvipDvL6EwpyJgUUFrhI
         ihxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vr/1YtnWLalugmjOQ2NtRDXaYJ/VSXoB5ieKwnkipsY=;
        b=qVi1ArpJvHLwSfz8SNQLI70gvxpXHIsAlWwTChGtcq/zmImSWRxGQVHqh8ucXGZQJz
         Va6d3aT6A20LO0JPYZDFAYmFpMcZLSlHY07sUolYcFKHatv8yoLTklYp2VEyRZKcHeJu
         k35BtkhWSrLekQX/o0us4p8TbEGgr1kTkxn3KXFv4E2k+K1lfH4OvnGfH9W8L5AaZZDw
         W2GyqG2ZEoXoYdGJba8ga2VrlP7EnTM12feCQAfDIrnWyGq8e9aTQCukrseEYaedKprQ
         E4TVd8IvcdNmXJDDaOmPF7qfSNMXbwJVQqUPjbd3kS12qwUDcDlIGzZ90kxOxU8rUw5A
         /nsw==
X-Gm-Message-State: AOAM530ApfsmO/QptJyHK/HZP5GZ5iM8qL1KoC8DS9gH0o1e1QYaiZ9C
        eTnkgozakjKlyqXCV5CTA8E6qPGJnXI=
X-Google-Smtp-Source: ABdhPJzt5Cm/05SqkMQ3ejtLtrRN4IiMRvpUsLtK54SXymnyh97yMKozPklLgF+Yht1DVfrdbvdiew==
X-Received: by 2002:a05:600c:3b84:: with SMTP id n4mr326026wms.50.1630539542906;
        Wed, 01 Sep 2021 16:39:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id y15sm134912wrw.64.2021.09.01.16.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:39:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: don't disable kiocb_done() CQE batching
Date:   Thu,  2 Sep 2021 00:38:22 +0100
Message-Id: <b2689462835c3ee28a5999ef4f9a581e24be04a2.1630539342.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630539342.git.asml.silence@gmail.com>
References: <cover.1630539342.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not passing issue_flags from kiocb_done() into __io_complete_rw() means
that completion batching for this case is disabled, e.g. for most of
buffered reads.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef0c7ecc03a0..14b074575eb6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2656,7 +2656,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	__io_req_complete(req, 0, req->result, io_put_rw_kbuf(req));
+	__io_req_complete(req, issue_flags, req->result, io_put_rw_kbuf(req));
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
-- 
2.33.0

