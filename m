Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3555717C834
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 23:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFWQT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 17:16:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgCFWQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 17:16:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id m3so3978679wmi.0;
        Fri, 06 Mar 2020 14:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/j1T882kpdTB+xU9Pa7Mjqyda6ZI9wU/9+N6UU71UIA=;
        b=uSDUuU/P6iCMlQKs+oWn+03baStJwUexZeV0BAmAZo0lMI0eozSOhf6o/ZO9rjrJSZ
         2jqejJz8gFQoJOVZjcZE2Gem13AwnewQ3t4Qkhw15zz0eWta3ESGvXnk7HU3hwjgP4M0
         P1Kg2XVJCIJpPwR8ZR0F3q534uKCa2z3vhTsFMe2PEQX2QXeyQ3G9kZljKooLcllSFIL
         O9T7w2SPbiTgJFZkvDhQnmTn+/c8xIGyDGleLV5jk8+pQTkESd/UxK6xWUK4CmVRUpMJ
         WyiyAgluj7kUKlisVu5AyZZFwVAxQMLY7ZTJvHjvVH++wOKEpGuraRhesp3bXpzjJeZl
         h0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/j1T882kpdTB+xU9Pa7Mjqyda6ZI9wU/9+N6UU71UIA=;
        b=lARdoLeWJQ/PcPyYz/ibYz8h8r0aPY03jSPz7jn/rrBBPaO4VvvWrlIOh7+y7Lx9pY
         j6clW0a9bMhCUH3T2nu9E9chVlhNonDT+3uasOgfuHXCtHMHw9RcJ/duVqr0j4Hns21h
         j0U13nSfzn9FqAAkJJ0ky1fR39lCwNzWUBgQHW7fA7WG2fI3fc/f1SNp9HIq7le4mu1D
         ZOo+RL/rysBiddxSz13Eh4Kkv399f3x+j/EPFF8+SEDB+W9rt5DySRFYitc/f5c7JAUY
         u5viCnTzujsoE/+X4DMio5iJ1KAyzTwe1eHY3gyHHdLwplDLNE2wJci8eG/oyyma+fFU
         oMnw==
X-Gm-Message-State: ANhLgQ0m9NPg8Grc3KefEyPb4KGj1hbnAOlmhCc2NepcReZLiyxhhtPe
        sFP0dsYA6NDZ95isKRSW4UyDqcmU
X-Google-Smtp-Source: ADFU+vsZMBvdEhNjOHFkyfx/FCSXMfBltUFRIQIAlO4kfizh/XRAKylY221r6UbcNbXc8P3tI4Xb+w==
X-Received: by 2002:a7b:c76a:: with SMTP id x10mr6028129wmk.49.1583532977341;
        Fri, 06 Mar 2020 14:16:17 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id g7sm50350384wrq.21.2020.03.06.14.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 14:16:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix lockup with timeouts
Date:   Sat,  7 Mar 2020 01:15:22 +0300
Message-Id: <54e141c75da11f55f607d53c54943b9fee5bbd70.1583532280.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a recipe to deadlock the kernel: submit a timeout sqe with a
linked_timeout (e.g.  test_single_link_timeout_ception() from liburing),
and SIGKILL the process.

Then, io_kill_timeouts() takes @ctx->completion_lock, but the timeout
isn't flagged with REQ_F_COMP_LOCKED, and will try to double grab it
during io_put_free() to cancel the linked timeout. Probably, the same
can happen with another io_kill_timeout() call site, that is
io_commit_cqring().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 104f76aace29..94eca92d1354 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1089,6 +1089,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
 		list_del_init(&req->list);
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
 		io_put_req(req);
 	}
-- 
2.24.0

