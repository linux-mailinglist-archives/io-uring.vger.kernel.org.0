Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1590A3A5B61
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhFNBkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:00 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:33682 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbhFNBj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:39:59 -0400
Received: by mail-wr1-f45.google.com with SMTP id a20so12651416wrc.0
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pptAvDXZoGUvE2BDKf3NcQTo8Rs0U3XwGkuJz5fhiok=;
        b=azd80NxSk4ulYA9bMnu3j1n9Cl3dV1buqyzys91rEgKBTov/lp3KyWEGvsSUSxVzKF
         r9EWQHWDN3cuRu5r0yH803pVKi33Y2pOKNH9eEiylUEqsZL39ckWCaLvugdbs2t3X07M
         NFLTPxvuPdIuIxt+L5mnkkpPbHmAr/S8MWjXd2MhOlnrbx+sBN9DgYkZmjGX07x7nAPx
         a3o8dy9bq5H6tbiklB/N8dA8cpVoZ2GjGl0Ag9O3FkURbqhLxi7H6jkeSjxctTBFImua
         jGY2Spe3V8Wico+XR2TCWj47FTfuaAUi5IEH75KvAwmnCxlpstdDFknduyY2sc9+gqsM
         FvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pptAvDXZoGUvE2BDKf3NcQTo8Rs0U3XwGkuJz5fhiok=;
        b=T7UtoWSC0wutF689tx23srxAsqm3nwbUpQi4AxfHcxeioUEFF7b/9HNROeiVJP94d5
         dPvHoq6bMJ/QkbBU7ZJwv9mQ2qORIXI0LtARfnfc3wuyPfJpFQKvZc2JouWDx9LkdC9t
         facQ4KLCn6OXgLx6Wm9IsZXe43JA5qbMQgnEKLsf8xqBUQHmRqiyjrjRlo2l+9pBjjvC
         foOoi4EGQrM1rBhvOexTg5CjwH7CMZeV4QnUTx1eIK/btHAOoOxP81PU5XshjOBciBuf
         M9GzByVm4mmyuixHTIj5rmi/A9fUdjAN+QYZ4++agzTvKdHLlK/cUXtSMoRrSWvCK4tO
         LGyQ==
X-Gm-Message-State: AOAM5318vRSP5F//DKhjFNNqNzS0x35zqgGDhKeezTrwV6amv5OM3+xm
        ZwpWt1/+oh9OD/vbCYWJ9DQ=
X-Google-Smtp-Source: ABdhPJxtWcV+Eh0Bqp1Taq020apkltbXY8rdyYtIorqUjkUlRKzKE0aWOae98CRdVViXcFfs65/W1g==
X-Received: by 2002:adf:e68a:: with SMTP id r10mr16047844wrm.326.1623634617161;
        Sun, 13 Jun 2021 18:36:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/13] io_uring: inline io_iter_do_read()
Date:   Mon, 14 Jun 2021 02:36:24 +0100
Message-Id: <25a26dae7660da73fbc2244b361b397ef43d3caf.1623634182.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are only two calls in source code of io_iter_do_read(), the
function is small and pretty hot though is failed to get inlined.
Makr it as inline.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23644179edd4..9c6e1d7dd5b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3248,7 +3248,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	return true;
 }
 
-static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
+static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 {
 	if (req->file->f_op->read_iter)
 		return call_read_iter(req->file, &req->rw.kiocb, iter);
-- 
2.31.1

