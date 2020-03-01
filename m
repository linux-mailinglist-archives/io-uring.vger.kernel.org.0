Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC0174E41
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgCAQTe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50314 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgCAQTe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so8555464wmb.0;
        Sun, 01 Mar 2020 08:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9LZRsEkKnJ2S97XhKeNcGIIBb8RD8P25Q7UYpYoF+Ic=;
        b=vUcH2Ok4A2jnI7/AeMXTfQ2tg0/d5Hz02KY07KCw9IBCcCxDdMQISt+MoAvtOXmx4w
         0LTQJHWciNAznLgva2EHcroMUsuL9W9h2gdtLcd2w/gISxZnC9kKxC3e1ykxkokn/Tg0
         cxNreCgoU9WdMJnMBdIdf/FNy0S56nqFAkTtLAul/ERLiZ7Au29POSz7UtMsF9hDWoyd
         V9u+7ft8uZp0tiPnRIK8GRxoP6fxeW3J+rNDyyayl/wQVPva8RpwQExa4B49heWdliBa
         Nxid0LwiUdZI913BNvU8g51PgBitUoT6e17FlPuJTd5QKlwS44iqbCyDwmAl2N4Jz2xn
         pwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LZRsEkKnJ2S97XhKeNcGIIBb8RD8P25Q7UYpYoF+Ic=;
        b=n6q98C3vl21Ujupyd6uO1bc8NLnYUMSzmdYE80ufqkWttJkhf9U4wSX5xmrFmomwia
         GziUP/9p34myoJCZrA9awvwHLTrM3Lw9LQtGZFfGC4Cp9Sz4gRWzRg4+e7dZD7j/VVbk
         XYHJxOfZlvd9hyGXsrFOe3UTMM5694S4R4qtdbfGS+cyuG3XEV99NFDIsLzb/xDPHv38
         SQq7XSr1LOVaoPu/vRJuvVd0PDLNB3XjTwT4Sp//LjiWlTuLbdfjOUOvxqNeNwNyS8bZ
         /8T3wXUJ0yXUxcUsAau/GozwYw1z86cQRin7kT9npJnIYz7JV+AfJQrGe0V/dsEnAKMV
         L8ow==
X-Gm-Message-State: APjAAAXZyMWKkNy9C3UIHQw4WTPRuWS2DvrEIjQfZxPsi6wouid4EDjY
        lWHdhGmq/ciLOX44V0hp3zqbe16a
X-Google-Smtp-Source: APXvYqx2vlN/bUf2hT6dBMF/YqEYRCPGUlhpWYBaLzRwdj01vt3S7A5gUKPUew8cQCnmd3Aq5aQKRQ==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr14345045wmi.166.1583079572947;
        Sun, 01 Mar 2020 08:19:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] io_uring: clean up io_close
Date:   Sun,  1 Mar 2020 19:18:18 +0300
Message-Id: <666c2026db6f8644230cdafa7b00ddf8ed18807e.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
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

