Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F9174E46
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCAQTi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35511 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgCAQTh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id r7so9422675wro.2;
        Sun, 01 Mar 2020 08:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cQ7//9PlxkUktrtKg4greMUmTpeUBK6XCx5dz48e1js=;
        b=dYQzxJH00peUb2T9wVL19zA52LxzCFFEjhIW5Mj3Lu5m4QK5gO42d1drhAaWvlCkHf
         CG2HuM3Q/YEh4Y7QapsfMRyExOOaD93+S8y5e2XwBcICRAA9XX64twQUss38yMgh2krc
         By00x44iBKwvmyLhPcIHeMBlgg0glw2UFTa4cHi08lU2T0/o99DiTbuAhirCLelk+neB
         p9OrfXGx54E9RXY/IOjm9V0vi/qiU1Bc1ljjEEQtTamQKqHi0OzgQp9+aRbJKr90SZvZ
         j6GAgh1W3s+uexzXrditw5VGUzdLP5WeR0tAWu7CiluMFaswBm8Gc8x79m9yvd2FKqoo
         5yKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQ7//9PlxkUktrtKg4greMUmTpeUBK6XCx5dz48e1js=;
        b=sPoZKOYxIX0ZxXCj+IyFtfieiBdch2lKwhGvcydpzYPImko/dJCBd0WlQoIpgONYGe
         yZirxqFqtgY8PV+2/kEW85q2exy2bCoZ5114IT+zkt1+cSfKDr8Jpo6QrhaOBdpe1MZc
         fO4jMKfsDok1CbZjJQcohfvvIP/Cfp5WWcTu7D8dojbsGrf9rCVPq7qjOx9XvhXbYge4
         fEOuy+N0SAiqvSqAqcFC6LbrfLWIrdpy7XJEBYBvWrJvTTi+2OB2+ry1p1L96ODrr8xU
         uKEbyb4Ah/E+SYz6uGUpU0atXBAwJfMapiQLXQcjoW/Soh1WnbOUMhKMHlUA99RdxzoG
         +MkQ==
X-Gm-Message-State: APjAAAW1/NVEgGpN8zodM43inY+3FWlIu1trFWpFSpJDwzMe542hgK1k
        URdvrPndqz7KruS2lehBQ+s=
X-Google-Smtp-Source: APXvYqxCFTKgKNuJx+muxQQ54nVMOLLJkhjqOWV/yn/e+zCeqeYYg0M3y4gH0am5ZCR88INIzC7dpg==
X-Received: by 2002:adf:f846:: with SMTP id d6mr16616548wrq.125.1583079574170;
        Sun, 01 Mar 2020 08:19:34 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
Date:   Sun,  1 Mar 2020 19:18:19 +0300
Message-Id: <909fe09940628654554531ea5fd2fc04b7002ed8.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

To cancel a work, io-wq sets IO_WQ_WORK_CANCEL and executes the
callback. However, IO_WQ_WORK_NO_CANCEL works will just execute and may
return next work, which will be ignored and lost.

Cancel the whole link.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a05c32df2046..f74a105ab968 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -742,6 +742,17 @@ static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
 	return true;
 }
 
+static void io_run_cancel(struct io_wq_work *work)
+{
+	do {
+		struct io_wq_work *old_work = work;
+
+		work->flags |= IO_WQ_WORK_CANCEL;
+		work->func(&work);
+		work = (work == old_work) ? NULL : work;
+	} while (work);
+}
+
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
@@ -755,8 +766,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 * It's close enough to not be an issue, fork() has the same delay.
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		io_run_cancel(work);
 		return;
 	}
 
@@ -895,8 +905,7 @@ static enum io_wq_cancel io_wqe_cancel_cb_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		io_run_cancel(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -971,8 +980,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		work->func(&work);
+		io_run_cancel(work);
 		return IO_WQ_CANCEL_OK;
 	}
 
-- 
2.24.0

