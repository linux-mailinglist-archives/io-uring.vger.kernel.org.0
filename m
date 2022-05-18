Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4026952B570
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbiERIkW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiERIkV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06786126983
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=O3Hwh9FMK/Y+mVRf2nPDA4yKBB8tjOZN8Y7yWPvmkuY=; b=ryFUQfaaLxMx4y9FsJ7dzJtyF3
        qZkotTPtaiiErrFefMMsrS8arylISg3ZPjW1EaKLMv1RZCyP70CRvVJAmodEy5VskFpYB8f5Od15a
        NYrkuSdy3+DAe3468ADP1pDo45BXrmXI7AsHY731IYyA/s+ajATLDQyifKjm9jQlhpksoeqT/XdfN
        8cyrC8tgIkwKnsbzxaO0mxcUrKVI57YtIu1ixnNs0TZGKa8h3UcU9xpm6ZThy8OBpr50rZGbJ8rly
        27PO2cl3S1N+W1Cwq7NVj8XIJqchB6hsl6sUTsnSr9/z1gy0A0v3hd+mrO0OJWfVj1yeQpz7RN+gH
        HdybGynQ==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFEB-000dUY-DN; Wed, 18 May 2022 08:40:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH 3/6] io_uring: drop a spurious inline on a forward declaration
Date:   Wed, 18 May 2022 10:40:02 +0200
Message-Id: <20220518084005.3255380-4-hch@lst.de>
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

io_file_get_normal isn't marked inline, so don't claim it as such in the
forward declaration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index abb7108258f96..fc435f95ef340 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1354,7 +1354,7 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 static void io_clean_op(struct io_kiocb *req);
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
-static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
+static struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 static void io_drop_inflight_file(struct io_kiocb *req);
 static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void io_queue_sqe(struct io_kiocb *req);
-- 
2.30.2

