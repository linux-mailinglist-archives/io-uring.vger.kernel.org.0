Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA50D20F47B
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732221AbgF3MWd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:32 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5210C03E979
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:31 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w16so20319865ejj.5
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DMSW5Px5ew74EsZ4xWJwd5rFCYznwwWjLlcEHYck3p8=;
        b=dOMCIja4oNMyxX/NUsqwAjm5uynISd5uRI7kX9XjZPWfvpFXRJzrp9sVaA2P4kxYXG
         ZmUDPLNUStI6d5ZJmlOpkX25T7rRn4vJdp3oe8+CCQG8hmpRZGcCH9CAWVoth4G/xr5N
         zQ1dlA7z9TfC3Mly7KnFcsK3K66KzBzW4KvC9sxCpp36czmvpoBLdyPVRIAVwf15jRa+
         m7ks44yh+IA42qc0T+mmZ8gok/pn33gbq2jlN9VfEXMPcaFRboiTuw15cWBgCZLvqpEL
         Cl5rI5t0Mz3DpFov/prMJ8UIcHZU+72IX+es/5/HdCgXy1ifK2kYEn4qQtqXNWhRJwEr
         bNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DMSW5Px5ew74EsZ4xWJwd5rFCYznwwWjLlcEHYck3p8=;
        b=q/i5bvWrDGP9og1AyyQgDv5rqL0g69Qc2t7L+A+Fb49bBZxE8LEjzZBBJZ/P56ZaQW
         Ly54PfCiYDTMRHm3sBeqNfU7tMGvjJujIv0Y+rKVMKeGAMmn15qkTNZhQJfAQnEwanLr
         /R5hAoZisIN03dJ9RDPw6HwCOPNH/Adsbqoi/Czrt3GW8I1VtQcsqZ4jCcZYQs2CVMOY
         VFLxCsKGLxO9a4YOUVY3yLQkKgmjhNxyKh6iv141JvV+0lazlKc10LGF+/robCNURaYI
         8VtwMeDO09ZqiRhc9qoaJA+yWz2cBktDroeTm2l9kfeI5vAf/zHegzRac//MYz0eSo5o
         609w==
X-Gm-Message-State: AOAM531dhCpzsttJWgGkk+903S39NrsN/PQ/FygJ26httQI3P0S/ix1H
        NM1g0hGIWXuqOTY+1myNvrY=
X-Google-Smtp-Source: ABdhPJx6NyvMabsnvzw/m+BuYlnNmJlK+1Ww5tDymlV/pilVI9Ht/5b0tGJOAnGKVP/nEPNe+oBiog==
X-Received: by 2002:a17:906:46cd:: with SMTP id k13mr17584413ejs.312.1593519750421;
        Tue, 30 Jun 2020 05:22:30 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/8] io_uring: fix io_fail_links() locking
Date:   Tue, 30 Jun 2020 15:20:36 +0300
Message-Id: <a306de0c1e191b12bb4183b26f4df3e66b2a770c.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

86b71d0daee05 ("io_uring: deduplicate freeing linked timeouts")
actually fixed one bug, where io_fail_links() doesn't consider
REQ_F_COMP_LOCKED, but added another -- io_cqring_fill_event()
without any locking

Return locking back there and do it right with REQ_F_COMP_LOCKED
check.

Fixes: 86b71d0daee05 ("io_uring: deduplicate freeing linked timeouts")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5928404acb17..a1ea41b7b811 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1620,6 +1620,10 @@ static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
 static void io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags = 0;
+
+	if (!(req->flags & REQ_F_COMP_LOCKED))
+		spin_lock_irqsave(&ctx->completion_lock, flags);
 
 	while (!list_empty(&req->link_list)) {
 		struct io_kiocb *link = list_first_entry(&req->link_list,
@@ -1634,6 +1638,8 @@ static void io_fail_links(struct io_kiocb *req)
 	}
 
 	io_commit_cqring(ctx);
+	if (!(req->flags & REQ_F_COMP_LOCKED))
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 }
 
-- 
2.24.0

