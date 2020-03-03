Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE221786B0
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 00:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgCCXvE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 18:51:04 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37210 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgCCXvD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 18:51:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id z12so71010pgl.4
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 15:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aP+DornMpasSWrMEhEUkI2m+doEEtKK39O+kGynj+ck=;
        b=T9KJBK/Jqoy4r6PeFA6c8LuPNfU23M2zz2OH7ZgtZXQyEwEW26EZ3A4lJ3KIe9U4JI
         MWJpJP/dOSqB0OGQofv3kJjYJDmNJcA2npolGyPFD1ti2bkSZSq74Iqd3sN5Xu41VOBI
         7sF2Q1YTedCCCGfWeFA7qW37FCamofYOIlmZovER0gZYNI2yDNJJH9m1w4wZPk6cv29h
         uPasLljam5smAhYqxOlAcirLTMIIJ9LMCVrS1NW0ijulN59CPvwSC2e6K1arCRBDfU5c
         MYfrN/cKUbplfqy6tCs+eIJaDVjGM14YADjDam4hkwmYAY8Z6A/fwcy2/g/AtqdO+LZU
         8cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aP+DornMpasSWrMEhEUkI2m+doEEtKK39O+kGynj+ck=;
        b=Q72QkGYcgFXA45DgEmwsklGyTmhId2K9EcBeZ9D9nEN3sWf+jnq1oZTo/Lv4gtQ1Wf
         137i/+ElWJYScCH3VaiAemHqXIfxOdXlXAjhWU8tyixjAtLJWQ2BLi0GdITSA53mgITk
         q+IVXoT7Njzr4zasBvAyOBOeeVcDaqUQccfNQa4zwigezxjzcNcjdOltYtAKheLpt72A
         9z1zl1fi01psrs0cnZIG5wYN0xH3vBYWWjL/hhIf2tE7D8HlttB44h06TKW6CobmNp7g
         rP9+38oJQZ/agemVO4dztllsyCPwKe9Lq2am+jYmgqvk3CujeXynqwYbODQ3k9gAoH61
         fIZA==
X-Gm-Message-State: ANhLgQ3xF8X5M+Qe1wjlquuSH9CWhDCGZgXxzqGDqYjy2UDwDIfZ2U8R
        lvbPcwJUZXJbV0JmhamN+7cZZGgCHys=
X-Google-Smtp-Source: ADFU+vtWC/Y7mJrH3g6qK4UQTOQVZ4IyY2lHMk0T6dsiwhlnTIZFO4PXTWAgGQcWNHnBh/Wal9NTtQ==
X-Received: by 2002:a62:e30f:: with SMTP id g15mr231998pfh.124.1583279461544;
        Tue, 03 Mar 2020 15:51:01 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d24sm27041503pfq.75.2020.03.03.15.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 15:51:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: move CLOSE req->file checking into handler
Date:   Tue,  3 Mar 2020 16:50:51 -0700
Message-Id: <20200303235053.16309-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303235053.16309-1-axboe@kernel.dk>
References: <20200303235053.16309-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not needing req->file in on the prep side at all.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0464efbeba25..9d5e49a39dba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3367,10 +3367,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if (req->file->f_op == &io_uring_fops ||
-	    req->close.fd == req->ctx->ring_fd)
-		return -EBADF;
-
 	return 0;
 }
 
@@ -3400,6 +3396,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
+	if (req->file->f_op == &io_uring_fops ||
+	    req->close.fd == req->ctx->ring_fd)
+		return -EBADF;
+
 	req->close.put_file = NULL;
 	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
 	if (ret < 0)
-- 
2.25.1

