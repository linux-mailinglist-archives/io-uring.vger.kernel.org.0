Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0DD52B575
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiERIkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiERIkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7896BC8BE0
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SDLfs/lKOmEecD7rLW8XM7B/pNb5s2qArw4hhBChVwE=; b=FCGlgd+bYmwZTJb6TVKcKBf9R7
        y0EjU0m7aOIyJhXksSiS5/NAqVu74UjZGlTAhgNGPjrUPnfXUsJznqywf5sQhd8dHLsM8+XwLKIbq
        WF5kQMcQSA9idV9tiM9mprjmHb/5IfUvz5+VFeKYu+VruR8eDp+sDySxN4E9zXGJbkYIGjJQeDQYw
        L7Fy+7V0y8AUmo6mANsMVvSpu8JuYljJcr46/lU9aGWp1FMPrF9zGGL1pQddv9rC4iWxOx8l+jSco
        k3wZJB+X2lfj4u5ba11nB1mHc9V/kjIcxe2Yna7qgpWvo70Tfl97hf7NDYt14km+oX/zp0hESw9SD
        MJ6I7bZw==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFE6-000dTK-2P; Wed, 18 May 2022 08:40:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH 1/6] io_uring: use a rwf_t for io_rw.flags
Date:   Wed, 18 May 2022 10:40:00 +0200
Message-Id: <20220518084005.3255380-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518084005.3255380-1-hch@lst.de>
References: <20220518084005.3255380-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove the bogus __force casts and just use the proper type instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b05d5aa5891a..99862cbc1041c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -644,7 +644,7 @@ struct io_rw {
 	struct kiocb			kiocb;
 	u64				addr;
 	u32				len;
-	u32				flags;
+	rwf_t				flags;
 };
 
 struct io_connect {
@@ -3636,7 +3636,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	req->rw.flags = (__force u32)READ_ONCE(sqe->rw_flags);
+	req->rw.flags = READ_ONCE(sqe->rw_flags);
 	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
@@ -4274,7 +4274,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_flags = iocb_flags(file);
-	ret = kiocb_set_rw_flags(kiocb, (__force rwf_t)req->rw.flags);
+	ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.30.2

