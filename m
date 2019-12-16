Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DAC12198A
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 19:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLPS6M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 13:58:12 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:33040 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLPS6L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 13:58:11 -0500
Received: by mail-pf1-f177.google.com with SMTP id y206so6110132pfb.0
        for <io-uring@vger.kernel.org>; Mon, 16 Dec 2019 10:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BXkBFyFtr5tdaXSjW4PmqtfoNMbDiY1WQ3FHIwB2KWM=;
        b=m8rUwJSdn0esdRxdJWNp7kiMdEmnuMt+eDZg1+qv80AU8lT1kQKoYOxdRtUcKupy88
         E9m7EOfgVbagLTxryU/d6sR02xLhBd/bX95qAcmhiSzWnlnzi9rJLNI3BBbgE4aP0Dw7
         cKDXl6hBuo5w0Kr+thOkkiAmFY5H9lGPCy4/Q4eJ8QgnPh5bAFj4qCkJA1ykKx0PuaEa
         YTmlB1PSEQuEV/DLdHPY/jGk9ZNZTKwdWImfNW/FgznXBhv/Ud6CCDrn32wZj+LBbyQQ
         mJ67E1h2Rt1nShAHEk9HGpAAL9drBwv0DltXDPyAWydiIucA3FV002/DNJIkQlzh8Cct
         VgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BXkBFyFtr5tdaXSjW4PmqtfoNMbDiY1WQ3FHIwB2KWM=;
        b=fSJvlYhYvQwN1cxsw+9n/UkbfjgqvIDjJyjuBHSUpTRIB0ucbswu1dHX78iYepbz2f
         gvSJHhpPsyskbOpDc9+9UGBBIDLQ5HwsI7ZQrL4NT4FvS8d6ueqoc29ie4Q3S9ieXubf
         AX6cQ8WVr5E6l5TLUzXEvzQ4qXgvmT1tDIUUKKUV8IMJWEu87D1vPkZEhVDCW3U+LeA1
         jviTB8r9CknHKXT20KlymTolx2vKzMDCwIUZCUr2WLNqIQhgG/P/ic/wWZT3+Y3ZM8MZ
         8iE0fyAFNGCTv+N3je7vXm3YxqfpYzrid/Oz9ezmUNhXmnEpsmnf8SxRprkhoGyXbsQs
         6KRw==
X-Gm-Message-State: APjAAAW5HED3x1P+Z2kTV5Zpo40/1mwOmLfXBUjIJuYLG8E+QJwgl3dS
        2SUIOqGcywjvZAZoSUnYAsfmljH4D9w=
X-Google-Smtp-Source: APXvYqwMjmmeCe4cwvFgGAwYkURzkvZpE6s+jt+61WPC8pTCccGlpt2uP6SRC3vVNG57QT7nnZxMKQ==
X-Received: by 2002:a63:2a06:: with SMTP id q6mr19307331pgq.92.1576522690718;
        Mon, 16 Dec 2019 10:58:10 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1017? ([2620:10d:c090:180::7616])
        by smtp.gmail.com with ESMTPSA id y144sm24409734pfb.188.2019.12.16.10.58.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 10:58:10 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: any deferred command must copy sqe
Message-ID: <cbec4bab-be5a-e9d0-1cb1-a2d60af746cf@kernel.dk>
Date:   Mon, 16 Dec 2019 11:58:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently copy the sqe if we need to retain other data between the
original sqe submit and the async offload, but we also need to do it
for the cases that don't. Otherwise if an application reuses SQE
entries, we can be reading different SQE values from async context.
This is a pretty rare case, but it's valid. Ensure we have a stable
SQE when going async.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

See https://github.com/axboe/liburing/issues/41

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff89fde0c606..339b57aac5ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1984,8 +1984,11 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return ret;
 
 	/* fsync always requires a blocking context */
-	if (force_nonblock)
+	if (force_nonblock) {
+		if (!req->io && io_alloc_async_ctx(req))
+			return -ENOMEM;
 		return -EAGAIN;
+	}
 
 	ret = vfs_fsync_range(req->rw.ki_filp, sqe_off,
 				end > 0 ? end : LLONG_MAX,
@@ -2029,8 +2032,11 @@ static int io_sync_file_range(struct io_kiocb *req,
 		return ret;
 
 	/* sync_file_range always requires a blocking context */
-	if (force_nonblock)
+	if (force_nonblock) {
+		if (!req->io && io_alloc_async_ctx(req))
+			return -ENOMEM;
 		return -EAGAIN;
+	}
 
 	sqe_off = READ_ONCE(sqe->off);
 	sqe_len = READ_ONCE(sqe->len);
@@ -2242,11 +2248,16 @@ static int io_accept(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	ret = __sys_accept4_file(req->file, file_flags, addr, addr_len, flags);
 	if (ret == -EAGAIN && force_nonblock) {
+		if (!req->io && io_alloc_async_ctx(req)) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
+out:
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);

-- 
Jens Axboe

