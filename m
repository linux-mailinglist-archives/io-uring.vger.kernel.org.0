Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D273A1EE9C0
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgFDRsl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgFDRsk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:48:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E317C08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:48:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 185so3783465pgb.10
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tFIvlmqwp7vk00WoD/UasbxBMQwU9FlTZ/DhGANreCo=;
        b=bI9x8z7xLOV+v/xrdw8COrfu5DdQVFeROTfsyEMUzScznDXU9UW2bKTNQARWGMRR7X
         /vkwjPRzQcHbfFh7dOAURNpimsMHnfoeXvZHph+sH8IHcg4Gn5GGmn7zfv1gXeVAIs5M
         Bi15SPgPo/UpN/4b7HIH/0b5XDG9Rv6XE8AssaCMeI8bUzzJ8LoB4mEU3FwtQL6qYsGa
         /k5fSznczz3JW8qmF8la6xGeTir29RtGErVdAPexGDCOqaG6vYPC/gnoLpcaTjFAze2Q
         XXpR4NPRkjPLgNqSM0KpWF7AaMOwQo8BralF+t3N3UcwsIKUqCqR5hF8h3HzqpOWFLoi
         PqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tFIvlmqwp7vk00WoD/UasbxBMQwU9FlTZ/DhGANreCo=;
        b=Gk2419ltfxZbCDHedjXYYa5nFWW5GT7VWrI4dlTIvIx5ki23QCyeyjTnrwaStZdyOT
         3uQxNPOE9s/HnyNUU5cSVvSSBIJPx14n3G4bwGrriqiljKbzt5WPfQ7v/9uf2wOazbSM
         OgTiNmTUmSKyTD7Os8Z/KxftcY+Z+lrmJPCA35YYZuyXXzBtgt+mu9yNShG1INlINISi
         QRerVfUhbhsYxr4OdhGofMg4Yxn67h3DZ1u2CMwl3Kvqs5Ju2jXv3/QvPgVMaHt1OcQW
         D7dR3hglaD/x8+Pfk2LzjSz+KuLIfjL28q8ShkCDv6zx4paGmeVaGXbs52zZFnw9PemK
         5ISQ==
X-Gm-Message-State: AOAM531zkUIAqI+AK5fdiVAQW/LJH2pHDxqWWkZaqvmCBSfturwHuE9y
        9ZO4sZOx4ks3DbfU7z+7HqkzbBBwRGYfQQ==
X-Google-Smtp-Source: ABdhPJyKckDxc6OLo9ELJQLc4QkUEu+H6+Ukin3TxI2mphT+BY6+L1DzFgXeMsHujM1Z+fNVoo8U7A==
X-Received: by 2002:a63:d40c:: with SMTP id a12mr5529013pgh.124.1591292919382;
        Thu, 04 Jun 2020 10:48:39 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n9sm6044494pjj.23.2020.06.04.10.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:48:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: catch -EIO from buffered issue request failure
Date:   Thu,  4 Jun 2020 11:48:31 -0600
Message-Id: <20200604174832.12905-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200604174832.12905-1-axboe@kernel.dk>
References: <20200604174832.12905-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-EIO bubbles up like -EAGAIN if we fail to allocate a request at the
lower level. Play it safe and treat it like -EAGAIN in terms of sync
retry, to avoid passing back an errant -EIO.

Catch some of these early for block based file, as non-mq devices
generally do not support NOWAIT. That saves us some overhead by
not first trying, then retrying from async context. We can go straight
to async punt instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b468fe2e8792..625578715d37 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2053,6 +2053,15 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 	return state->file;
 }
 
+static bool io_bdev_nowait(struct block_device *bdev)
+{
+#ifdef CONFIG_BLOCK
+	return !bdev || queue_is_mq(bdev_get_queue(bdev));
+#else
+	return true;
+#endif
+}
+
 /*
  * If we tracked the file through the SCM inflight mechanism, we could support
  * any file. For now, just ensure that anything potentially problematic is done
@@ -2062,10 +2071,19 @@ static bool io_file_supports_async(struct file *file, int rw)
 {
 	umode_t mode = file_inode(file)->i_mode;
 
-	if (S_ISBLK(mode) || S_ISCHR(mode) || S_ISSOCK(mode))
-		return true;
-	if (S_ISREG(mode) && file->f_op != &io_uring_fops)
+	if (S_ISBLK(mode)) {
+		if (io_bdev_nowait(file->f_inode->i_bdev))
+			return true;
+		return false;
+	}
+	if (S_ISCHR(mode) || S_ISSOCK(mode))
 		return true;
+	if (S_ISREG(mode)) {
+		if (io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
+		    file->f_op != &io_uring_fops)
+			return true;
+		return false;
+	}
 
 	if (!(file->f_mode & FMODE_NOWAIT))
 		return false;
@@ -2611,7 +2629,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
-		ssize_t ret2;
+		ssize_t ret2 = 0;
 
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
@@ -2619,7 +2637,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
-		if (!force_nonblock || ret2 != -EAGAIN) {
+		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
-- 
2.27.0

