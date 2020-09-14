Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2B26917D
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgINQ2m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgINQ13 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:27:29 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD857C061352
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:10 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g128so687304iof.11
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fI3E5QX0uVQkcVr5GunUfNvKf324g965urLWSQ9Wtio=;
        b=hdTzwoJl2JZMo65edT3yRtbEf6DK7nVOB3Kg1o8Be5CHf2DlBAXHzwsedtti5PE53m
         1BaRP9syLNwjlfHuli1YKxs1RoDqbPmbj0Hzfkrb+c62VLQ+s3vdrXOm+95B+VLKjBg/
         AE10NwP+sXphQ3cUM/qt4EcYEJKxdIE5kCKfno6wmCLAtNLWO0Q1+2a6CxT5acbf7pBY
         PqUoFvTwCmZ5pxLOkcx0z/ACOy7LRi2NAoBSD0XXLSY/3ob4zDafb/Q2DsbyZNxsKCzx
         eFTBNjk25VXO+AiUOuE7ztCu3Dfd8xUEfwimv1TGxMR+PInbjBhC2Q1c0sXlq50QDkhf
         lZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fI3E5QX0uVQkcVr5GunUfNvKf324g965urLWSQ9Wtio=;
        b=bK8F3EJuZtRUDkhfBC7dx+nldMy6purmTp9ugwFwfoELmPjBVrCV3z1/Zy65ESp5s2
         ieBZNB3o8Zi/IMdyKoRIXVsoRUbkpj72bixdxYcxKrB6xfQRKfpDZ/pIrRNAGoPyBP8b
         qqrU6wLNeKJ4EyeqNF0D7epYmFWBk0yNKnlGdqUo9+DWv2XFhRKl4B8GIcbufFcL4eRn
         tjWer7fBZpDr/RtI/+yrZosZgiflrjQ0Hg/LqQmap6Gv/rXgd+wS0sq6r1mjuOcvU348
         eYkFftus+7Tu6/9eMvwpqRHLZ6WHNl12N8M5ZFGFjoVKpHMk9qrvMQVgLsQz0KKbUG4z
         64Jg==
X-Gm-Message-State: AOAM533LhP/sC/Pus/IIYLl7lGGZDtEhws5oqajkdU7BZ2XaqGAH+gTI
        ahw6GsmueKveqo8cTtiXrpOMN3fDEux1KhTo
X-Google-Smtp-Source: ABdhPJxKxa4Znto/EUM7qKbg8sTHeEDsHhoDkogAmvGKBcwE9VOd7HRWAPrZIJUcdtcFp8hCFnofNA==
X-Received: by 2002:a05:6638:248d:: with SMTP id x13mr14307153jat.39.1600100769979;
        Mon, 14 Sep 2020 09:26:09 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm7032261ilq.29.2020.09.14.09.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:26:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Zorro Lang <zlang@redhat.com>
Subject: [PATCH 5/5] io_uring: don't use retry based buffered reads for non-async bdev
Date:   Mon, 14 Sep 2020 10:25:55 -0600
Message-Id: <20200914162555.1502094-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914162555.1502094-1-axboe@kernel.dk>
References: <20200914162555.1502094-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some block devices, like dm, bubble back -EAGAIN through the completion
handler. We cannot easily support the retry based buffered aio for those,
so catch it early and use the old style io-wq based fallback.

Fixes: bcf5a06304d6 ("io_uring: support true async buffered reads, if file provides it")
Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05670a615663..c9be9a607401 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3100,6 +3100,13 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
+	/*
+	 * If we can't do nonblock submit without -EAGAIN direct return,
+	 * then don't use the retry based approach.
+	 */
+	if (!io_file_supports_async(req->file, READ))
+		return false;
+
 	wait->wait.func = io_async_buf_func;
 	wait->wait.private = req;
 	wait->wait.flags = 0;
-- 
2.28.0

