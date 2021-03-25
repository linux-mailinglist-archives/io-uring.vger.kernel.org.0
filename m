Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8B53492CC
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCYNMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhCYNM0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057CAC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x13so2223352wrs.9
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S8I3P8xxdw9EjQN2JcNJokQ4V6jGp8zYO3Ndwg10XHY=;
        b=K0Q3JXIc+SR6X4/F3G/eaVdXHIzLlzFN/wA6CGVAR1ymyp+fVndgxe9P8FwyHScUu5
         GAlwovaGhcctyoyr9rhacoL4UUmLwf5o5AYgMtku1E/G32X74D9vq2pnPXK2P2Zczs9J
         ydfGeb622eHWwRr2l0X7Ymo3Dojnq1yI3Ffzo6QXJvtULWsz1ZkoxgAbTx+h+EdTxgAE
         xLvnLM3bBBMTtxWdMsrcrarFshCp5vf2MhGd9asduzL00EtrkhLJh99Vd28a7QHXn4E+
         i6LYbUkWLkwwyFgPpnZC3Jc2CBOc42htVnrCpn9bG9zKTJcHTVtHI4FvijW6/ASHK0bB
         GliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S8I3P8xxdw9EjQN2JcNJokQ4V6jGp8zYO3Ndwg10XHY=;
        b=gOLB6OFu0GoJuqKIFDPwroGkwjSGr+BsCrG0GF1nFenCl1Ys5xcPGLLf3NoxAaZPTH
         xsvTQOlwdu3LcxTe1RDIO2ZxrnDy/BSf+ztZqgAxzHKZ33mcTm4yJ0sV1Pj6kuLGFSgw
         ZfNrvrbrvUvEtZZP9J33ag5zRGpGo4aG0u0eKPGa7IXY8jvt4jNzsQ+OSlf8VBLWAuUl
         ZjuoG4e7sdw5aemh4rNNIIa37Q9hFbxQVQ6kqbdvmBAX69QwmBtRjtpANNYPS304jGzp
         9yP2Df6gG1avo4UTmK3V4YQOinDPSSrAluk5xVkyCskTNmUAaoOlS5TU6JBnYlRCJpVi
         KsEw==
X-Gm-Message-State: AOAM531Pbn9NvfwiPt74K9t00ye1FrBQAMqKHA4mfs3cE/gg4NtOSNgD
        suRvcOE1rqvjdAJINSDoVGI=
X-Google-Smtp-Source: ABdhPJwOOj4BfYkm9m+V3WCxE2ZAtY7JXa3faSs2kBJFPyZ3kLHyFjXWReRwddXR4jLoYn/UsWmUMw==
X-Received: by 2002:a05:6000:223:: with SMTP id l3mr8932326wrz.5.1616677944803;
        Thu, 25 Mar 2021 06:12:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 10/17] io_uring: refactor rw reissue
Date:   Thu, 25 Mar 2021 13:07:59 +0000
Message-Id: <7618dbc2eba8f0747674caee997c3a622c19326e.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_rw_should_reissue() check into io_resubmit_prep(), so we don't
need, so we can remove it from io_rw_reissue() and
io_complete_rw_iopoll().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a57fe91f06d2..350ada47d5fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2472,17 +2472,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 }
 
 #ifdef CONFIG_BLOCK
-static bool io_resubmit_prep(struct io_kiocb *req)
-{
-	struct io_async_rw *rw = req->async_data;
-
-	if (!rw)
-		return !io_req_prep_async(req);
-	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
-	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
-	return true;
-}
-
 static bool io_rw_should_reissue(struct io_kiocb *req)
 {
 	umode_t mode = file_inode(req->file)->i_mode;
@@ -2498,26 +2487,34 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&ctx->refs))
-		return false;
-	return true;
+	return !percpu_ref_is_dying(&ctx->refs);
 }
-#endif
 
-static bool io_rw_reissue(struct io_kiocb *req)
+static bool io_resubmit_prep(struct io_kiocb *req)
 {
-#ifdef CONFIG_BLOCK
+	struct io_async_rw *rw = req->async_data;
+
 	if (!io_rw_should_reissue(req))
 		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
+	if (!rw)
+		return !io_req_prep_async(req);
+	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
+	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
+	return true;
+}
+#endif
+
+static bool io_rw_reissue(struct io_kiocb *req)
+{
+#ifdef CONFIG_BLOCK
 	if (io_resubmit_prep(req)) {
 		req_ref_get(req);
 		io_queue_async_work(req);
 		return true;
 	}
-	req_set_fail_links(req);
 #endif
 	return false;
 }
@@ -2556,9 +2553,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 		bool fail = true;
 
 #ifdef CONFIG_BLOCK
-		if (res == -EAGAIN && io_rw_should_reissue(req) &&
-		    io_resubmit_prep(req))
-			fail = false;
+		fail = res != -EAGAIN || !io_resubmit_prep(req);
 #endif
 		if (fail) {
 			req_set_fail_links(req);
-- 
2.24.0

