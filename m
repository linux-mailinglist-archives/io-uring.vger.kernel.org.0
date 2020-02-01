Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEDC14F58A
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 01:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgBAA7f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 19:59:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51732 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgBAA7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 19:59:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so9988319wmi.1;
        Fri, 31 Jan 2020 16:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o/Z1Q9j16pnd5qHxzj1VfasD9Q7tF0Et5G7N/eWy7Ks=;
        b=XJ2DHsui8Xaz0JCtJ2EYXlxrz+FjhsQ6TzlTwhQv32cVGz2+OWC45CVtN7wcyB3YG2
         p7EMsclbgumy+RQk0jWg20LI4/ojv/lHvr7xcdXeXyC0tmdCS8RVeedtR5F5ajN2WEJZ
         gysPQgF25Wt+HIOLBUdaoAXQJTNPAXhqu6V3gMedbHMSpbCHjwiEUAn3nWSikduoZUZT
         qfYTG/gpSE/r7mUuwCNvUxvg0OAofA8f2GExxmjY9C4aZnaNcduI8x6WU8kVunUNHnYD
         CJG0dJPPLyaFFfh9ekvT6M1WBuFwmFNAgf1j7pmAb3jcDNEynk6Nv8Y/fOscTHXdRfAi
         vIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o/Z1Q9j16pnd5qHxzj1VfasD9Q7tF0Et5G7N/eWy7Ks=;
        b=MOwVzEM0RYOVy4nV2mUtVuNG9+dvoAGes2kfMOQsXSmXJABONrqYQj1ztgdBjj+5Ld
         Z4dNra8JlHyJUqhVq1EEq2J+XqkkvIbur90ynAcLiqcjThJptdWALs5C7URoXjLfqjyT
         s0Rn90qDao47S55jUOlwCV0hR2gGRxRqSzJA3z7/I0Wiua5Cgm9Qhm0/9Tc3/pASRWuZ
         z0Myt9e8Csh7y/3Lzo8XbpQD9f0cvGmg9U/iNPR5TWWKJaQjI2XScTfZtm9I4NZ5nvvn
         vCzikqAoj0DgnjirdcmXxX7lEusRG5wQbSBEWmsfCXWJpa3CDKUhF0gPFJdb4yqqgn2c
         v2qA==
X-Gm-Message-State: APjAAAUjjMTV6zULzPzYTYOwmVON27rffIyKWNFxmAIjllwTmGRFk2er
        Tl3UwUQjM2KtI+L1oO+eBjNae9Sf
X-Google-Smtp-Source: APXvYqxVaMLA0kmq27KIpw7WmGCxp3GYPy6zFg4Oj47SappJUhZE7DFyOz4vg9iVVmn9TXUXSMPHKg==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr14770673wma.121.1580518772615;
        Fri, 31 Jan 2020 16:59:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id c9sm12979291wmc.47.2020.01.31.16.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 16:59:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: place close flag changing code
Date:   Sat,  1 Feb 2020 03:58:42 +0300
Message-Id: <aebc542fb8d3625178fa02c6a8c6a5b2b89466c4.1580518533.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both iocb_flags() and kiocb_set_rw_flags() are inline and modify
kiocb->ki_flags. Place them close, so they can be potentially better
optimised.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73a6c6a4ec50..c3687bda92d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1865,8 +1865,11 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_CUR_POS;
 		kiocb->ki_pos = req->file->f_pos;
 	}
-	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
+	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
+	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	if (unlikely(ret))
+		return ret;
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -1878,10 +1881,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	} else
 		kiocb->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
-	if (unlikely(ret))
-		return ret;
-
 	/* don't allow async punt if RWF_NOWAIT was requested */
 	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
 	    (req->file->f_flags & O_NONBLOCK))
-- 
2.24.0

