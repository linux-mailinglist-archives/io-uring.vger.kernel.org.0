Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3836B159A2D
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbgBKUDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:03:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55648 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730912AbgBKUCz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so5266377wmj.5;
        Tue, 11 Feb 2020 12:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OiH+02ziKtnOG8xgRb7M30iMhSugqwUS+kAPH3uo6xE=;
        b=ielnlRFKPlRS7XN3izTLQLFmjbKK8WMP872CwhuwIi0M5AYP4JG2PNz0xbKn2/lfxC
         O/vM5Vxnip39X7w8jkvTy3fQ1Rx5o7Mj1nUaLLj072+GSYy92CT1Yt5JUbrLOwpeHyiX
         ZkY7QICICj8Cll9UeC0a9BhyyYNXzw9LwAz+ymJLK34ZKODFI6fV/R9AMYTjq++Peu/a
         HTWevZSnbNdWiZ0KrBp7IhNhdUiPsLRcEb36GB9bPHYBlHP59kfJ4+aDvLoToygKJ8uD
         NAjONvGnXcgElHlbXS5W9XSsgf+aayT1zxRNFwAfdlG4JjXZrX0aTQUGcJYQEkN4BJT3
         ZfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OiH+02ziKtnOG8xgRb7M30iMhSugqwUS+kAPH3uo6xE=;
        b=VQ35Le0Y+SAIf1JvnpB7x3N3xCD9WldOEOvUHiWnKkKOPo4eUzsHKYJWCX4lzdohvC
         Cwu78mFEE5FRTe28clmjUrzl/iDdKAmyNzI/M9qlFvHfYC0XLU6HqrjSUpZolDlmjmbV
         avtWf/zz/zF3+8/41BPjHgBLa0jTDov9zuisvbYqz8GlqV7KFrrdp9X+cgDspmEvcnNs
         0NaDIoJ9lvLNscHIWZUSOYQTpVTy7ZdXhkDVuC+YKHFz6yaWBYWyN+KEUoj7z28f5Dg/
         px2sWahTYsNg8T1jPgZcr2QOmVmkRlzY/XiPm8si1ZUs+lNl+6XIkRYdlJWF2OlJo7Vj
         EauA==
X-Gm-Message-State: APjAAAVKTPyHPgpxKysnd0rJ82ItLx4l5+R6o2i7Pcvi8yD90iE1ykFV
        xaJpcYxtM7y7PqstnY8lauQ=
X-Google-Smtp-Source: APXvYqyzJuDfzjvW2+rfty1C+evPWsoiWOWwUIYZ3RoQa7ydIAi0d6gDDk/DKntfMPt+rP/ZNcn3sw==
X-Received: by 2002:a1c:688a:: with SMTP id d132mr7990674wmc.189.1581451372841;
        Tue, 11 Feb 2020 12:02:52 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 4sm4955101wmg.22.2020.02.11.12.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:02:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] io_uring: add missing io_req_cancelled()
Date:   Tue, 11 Feb 2020 23:01:57 +0300
Message-Id: <0a34342f63cd7a535cc54e5e1fe3ab73907a7da9.1581450491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581450491.git.asml.silence@gmail.com>
References: <cover.1581450491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fallocate_finish() is missing cancellation check. Add it.
It's safe to do that, as only flags setup and sqe fields copy are done
before it gets into __io_fallocate().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3108bce4afe..b33f2521040e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2529,6 +2529,8 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	if (io_req_cancelled(req))
+		return;
 	__io_fallocate(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
@@ -2905,6 +2907,7 @@ static void io_close_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	/* not cancellable, don't io_req_cancelled() */
 	__io_close_finish(req, &nxt);
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
-- 
2.24.0

