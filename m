Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0D1C4796
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEDUCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 16:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726441AbgEDUCI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 16:02:08 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A21C061A0E;
        Mon,  4 May 2020 13:02:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x4so873153wmj.1;
        Mon, 04 May 2020 13:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KdlOL0+4+Ykci+7yQYazMb8JW9d/9xEljqxcf/GDuEk=;
        b=sJcXHxLSBnzJGMaKNW+99617mOPEmXnMG5Noq1kdinn6Ed89n3c9c+GeJVczmV0vCu
         pvDt6LRa1hz1a1M3pbXUYY+71rble+dJs0BQ4tholGGBuEof7kKZaL7p97aHQVhTq22W
         Tkm/t2uTcMagqEp/CE014kqT9GmDoUIisRe97eJs20d0MqBMGNQwJRYRnaMhGfR2IS/i
         YH8KEnMqltUdXf/GxTZAZiyfgHEm/mORzPhzh+Q7BsIpH71rJkRPrksfpZmKA5IhnUIO
         GII3sCKzYNjXKmlzMq/3nwTahAUEaDyS5ng+aESP14gzxHO/Mq/qngu+GZP9SFL1Pr0x
         DOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KdlOL0+4+Ykci+7yQYazMb8JW9d/9xEljqxcf/GDuEk=;
        b=b5JFLj/Q8jPUhhL3LgdSTQz9Jc8ICZQ5f3dwv46HjW4hi4UhYDe79DwOz4v5kNAABA
         6UUE7NCu+uYUdS6LYDLuSHuMJ48uKmNaqcQsBQ/hfm1Pq1jvlVymWAU4FFoNmi+rROBJ
         4ymiQIgJygAGd8Ji6XuFJuxc3pKUg8CRoLGGp5U5WRM8HqrKlw1PxzzK0jC0+sglJSJK
         owci6jLgYVQ8XhNuygOm7UQiqvEmtv/DR420Qcr2Gs3BXtbWpkuR74TyK7RiSrp/oAp2
         AxUxvLuTCX5m5VZQGZFviMP2Wgpp5a2UaiNnfaS+3lorT0M1uRaLJqipbJBy4RHXVPwp
         0QKg==
X-Gm-Message-State: AGi0PuZQoiE2kthAWFukEFAFdqH1XYUNvxvdHk66mlWcXcpBmoz2Zx+Y
        Iv8ZsE9kLte5jCUyVcqQE5WnMwKN
X-Google-Smtp-Source: APiQypLtdII6d3Uh6/K5h+dxXP5Ugh8M97Xscg7xDlXEjK1u9cJyQqNmpchCvB+ACdDUmIXUsWo5mA==
X-Received: by 2002:a1c:40c4:: with SMTP id n187mr15844209wma.28.1588622527018;
        Mon, 04 May 2020 13:02:07 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id c190sm25482wme.10.2020.05.04.13.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 13:02:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for-5.7] io_uring: fix zero len do_splice()
Date:   Mon,  4 May 2020 23:00:54 +0300
Message-Id: <c7dc4d15f9065f41df5ad83e051d05e7c46f004f.1588622410.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_splice() doesn't expect len to be 0. Just always return 0 in this
case as splice(2) do.

Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65458eda2127..d53a1ef2a205 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2772,16 +2772,19 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
-	long ret;
+	long ret = 0;
 
 	if (force_nonblock)
 		return -EAGAIN;
 
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
-	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
+
+	if (sp->len) {
+		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+		if (force_nonblock && ret == -EAGAIN)
+			return -EAGAIN;
+	}
 
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-- 
2.24.0

