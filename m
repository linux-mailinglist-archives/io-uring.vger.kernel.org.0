Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3AC30B417
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhBBA0W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA0V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:21 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F37C061786
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:41 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 6so18557321wri.3
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qIoqyE4Fpaf6vuFNVJumhbJQpn+cWb3TqLJpyRoKHzs=;
        b=vIvSXiLO3V1b39+4D364pOljLPUhZPoCOA6bSZOd69B4glgvUgA8XzT92N7OpbZ9ex
         O/4IySeuH4cXzb3eUItCoeW29N7betoKgeCr45hF3jY92zZJ7+TJmLUdIzwt7VPBlfiH
         on7NaxBpt+QOlE1CKjieSV1ZXgHm3yqIu/JPKxFqKtX7yFaRpMYoyRB2BFIIEUpt2l2f
         th2eWLVONALKDSPVrTb9+BjFDDTKaiJkkwvgZkgctr28b4rAjtDmXTnRj6sw6HBn5E/d
         g2ilMQC+c6IdShA2nckqLbIk5sEk9/MkVOdP/bGbxd1RkiqPqdvLv2zpvQmBrNXHny1W
         OzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIoqyE4Fpaf6vuFNVJumhbJQpn+cWb3TqLJpyRoKHzs=;
        b=CRj4oyqTDj8VwjA73LFQM/AjLqu4IcltSQUArRIhw96r39SX2olU5TJaQmGwNDe/rI
         LqG1MsEHcgDqb/9Yg2MppN3zUO2GzRKjClYZHcrWColLtHS3OopKhkoaYwTMWMb7ux2w
         a0yICaHZTG2f8nW5BjOWWh8oz0gESKGGXtynGLGt7V+NUeZflZx2aldRIDnkImyZJkhk
         XO7yUtJy4FDguhdBBgMrzmzl9/SBgcMEPH2psp1muLQDwHsAcxsv+r0RheC7ao2ecjM/
         VQNdgNzcVPsiE6p+q7KKXcnbgq9fHCqkEE1G17AKJT2WEL4H1fvcfBSy3LMetvQ9D7bD
         o0Ag==
X-Gm-Message-State: AOAM5329InoEV+YGy/tJk824k9bLqsZJTCHyDT9iIhO+RQ7dpFa9BdWH
        eALBkYjJn/uM0v87OJPhEMc=
X-Google-Smtp-Source: ABdhPJynzrM/W6pGHqaLYqQOM9LOt9uuvMckaOkRIHBHAnxF37O2oZA9dNiM/3HwF90G9dsh5ilx4w==
X-Received: by 2002:adf:df12:: with SMTP id y18mr20933242wrl.141.1612225539940;
        Mon, 01 Feb 2021 16:25:39 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: further simplify do_read error parsing
Date:   Tue,  2 Feb 2021 00:21:43 +0000
Message-Id: <d2946a35aa6f5e5fe536dbf23338275c36251f12.1612223954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First, instead of checking iov_iter_count(iter) for 0 to find out that
all needed bytes were read, just compare returned code against io_size.
It's more reliable and arguably cleaner.

Also, place the half-read case into an else branch and delete an extra
label.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 866e0ea83dbe..1d1fa1f77332 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3552,19 +3552,18 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
-		goto copy_iov;
-	} else if (ret <= 0) {
+	} else if (ret <= 0 || ret == io_size) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;
-	}
+	} else {
+		/* we did blocking attempt. no retry. */
+		if (!force_nonblock || (req->file->f_flags & O_NONBLOCK) ||
+		    !(req->flags & REQ_F_ISREG))
+			goto done;
 
-	/* read it all, or we did blocking attempt. no retry. */
-	if (!iov_iter_count(iter) || !force_nonblock ||
-	    (req->file->f_flags & O_NONBLOCK) || !(req->flags & REQ_F_ISREG))
-		goto done;
+		io_size -= ret;
+	}
 
-	io_size -= ret;
-copy_iov:
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2) {
 		ret = ret2;
-- 
2.24.0

