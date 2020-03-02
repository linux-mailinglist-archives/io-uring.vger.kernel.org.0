Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22245176533
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 21:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCBUqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 15:46:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38976 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgCBUqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 15:46:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so1558482wrn.6;
        Mon, 02 Mar 2020 12:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9LZRsEkKnJ2S97XhKeNcGIIBb8RD8P25Q7UYpYoF+Ic=;
        b=HiOkxIL2wRxMFKWaZimnvK63CcgcFIHPIefLtJ3PTMEVizxfCrvIPmcOcanEmWCITD
         ZaVfpU0zJZhiQs1xATGNVLGvYQVGw8HdB7LzPrSxxchSwarccguokyWB3us54ypZkOVH
         QwfbA+5bwcXKUcIOGyGvznq1uot3weiSWqTGzk/4xvG0kpifdRTL1jHgON/EUTXV/UmG
         tbORqLJWqCkt5DNNU4LjtqDM+3eAAp4DF+1/+yKs1kR8LUqTVoLeeypo/WHizN6AjH8J
         VdSnXkjc3ZrLW7Os9R9+KPU8WO8kdvyWqNZw+E9DiQ2FWhZOoxojhnQZ64mKttJxl9Q5
         kkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LZRsEkKnJ2S97XhKeNcGIIBb8RD8P25Q7UYpYoF+Ic=;
        b=SjvfsDnkWhI+OhkvAZa2vF/fGb/cFac9d6Ex1tEHAYYw6bHAmIk+dwsEi+vB1mn78L
         BATt7EUESpDpN7vnYnhC0+pXs+FjEVO5hUuimClnKeU6J1eHDUXRwHRLj4jIxaGQDYDT
         wp3nfTNHOMZ3MFnci86VtXxwcmTIt1Vdz8HOJpiTk1GQN4cFDu2fT2KY+WeZrlmnPzro
         cYu7o0a4l5xWiWkgsZaFXIEm0Y/OT0N/0O3HBnqL9utMpRI4GkRKsmzTLd9cV+gdi4Px
         rWfifxWJL0+219dapIYv0WkheqZyZWJcp/0UNLAHibwlr68GuD0ZxO+9FdFYcPzRwils
         FWxQ==
X-Gm-Message-State: ANhLgQ15OKOx/H8MLn2kiM+V/kATxhrL2L12aAhp+4mQD+4okT0VnuPS
        b5u/oW+E9DpFSQwbgo/CxGKx5oY0
X-Google-Smtp-Source: ADFU+vtvsuyY4lNLJm8yNm7eb/4nARj23ySB8MSjwnecDYZ05jAL/gjsp54caK4rTuq28ewfqP+mKg==
X-Received: by 2002:a5d:4984:: with SMTP id r4mr1248619wrq.137.1583181976509;
        Mon, 02 Mar 2020 12:46:16 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id b14sm20186549wrn.75.2020.03.02.12.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 12:46:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] io_uring: clean up io_close
Date:   Mon,  2 Mar 2020 23:45:16 +0300
Message-Id: <d79646ca3bafce163d27405fd8fd180fce900b71.1583181841.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583181841.git.asml.silence@gmail.com>
References: <cover.1583181841.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't abuse labels for plain and straightworward code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb8fe0bd5e18..ff6cc05b86c7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3030,8 +3030,16 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 		return ret;
 
 	/* if the file has a flush method, be safe and punt to async */
-	if (req->close.put_file->f_op->flush && !io_wq_current_is_worker())
-		goto eagain;
+	if (req->close.put_file->f_op->flush && force_nonblock) {
+		req->work.func = io_close_finish;
+		/*
+		 * Do manual async queue here to avoid grabbing files - we don't
+		 * need the files, and it'll cause io_close_finish() to close
+		 * the file again and cause a double CQE entry for this request
+		 */
+		io_queue_async_work(req);
+		return 0;
+	}
 
 	/*
 	 * No ->flush(), safely close from here and just punt the
@@ -3039,15 +3047,6 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 	 */
 	__io_close_finish(req, nxt);
 	return 0;
-eagain:
-	req->work.func = io_close_finish;
-	/*
-	 * Do manual async queue here to avoid grabbing files - we don't
-	 * need the files, and it'll cause io_close_finish() to close
-	 * the file again and cause a double CQE entry for this request
-	 */
-	io_queue_async_work(req);
-	return 0;
 }
 
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.24.0

