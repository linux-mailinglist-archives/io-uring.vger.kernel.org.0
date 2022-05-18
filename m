Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655DE52B589
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiERIkb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbiERIk3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7921078A7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=aYeW7fe3tqt7eOZhO6qodf1YLqFtMMH8JlWFnC3q7gs=; b=PAExOTorQo2Vt9Fy4qzCi5Rt/G
        pDM4nFbNXFUxNksoitZzN17X39tSGIV1fn2vc/DuSU7TboOsc5iA9axdDDloUAZPDu9kmBqZoqC6s
        iFb9bcn9PLcQ3o06p615GkCMVP6dZK3hB7TbfrVmaLweINxXBWWCMXTsBehznjpFKUG87ZSgrTvKL
        dpROGVngMlhdHtVg4gxZmEkFKQH1vdMJm/YNg7/ZUrEQIPCsH63x/6HVEp0YeNJM1NqOjjQUsSLz7
        dInCAf8fcn0LYUZF3IaLgF9oy8UtymN2tKHn8ERQyFfkaxZ5IsfWabPOrILHp7GMsTe3JOkfdfBm6
        5KEdQS7g==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFEJ-000dWE-AB; Wed, 18 May 2022 08:40:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH 6/6] io_uring: use rcu_dereference in io_close
Date:   Wed, 18 May 2022 10:40:05 +0200
Message-Id: <20220518084005.3255380-7-hch@lst.de>
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

Accessing the file table needs a rcu_dereference_protected().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c9596d551bd67..2b848a8dfc46c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5984,7 +5984,8 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 		spin_unlock(&files->file_lock);
 		goto err;
 	}
-	file = fdt->fd[close->fd];
+	file = rcu_dereference_protected(fdt->fd[close->fd],
+			lockdep_is_held(&files->file_lock));
 	if (!file || file->f_op == &io_uring_fops) {
 		spin_unlock(&files->file_lock);
 		file = NULL;
-- 
2.30.2

