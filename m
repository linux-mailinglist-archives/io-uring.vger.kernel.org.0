Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEC816897B
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgBUVqP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:15 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40219 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgBUVqO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:14 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so1421611plp.7
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e6Oq3V8WrT036RQ9hRYSwWbzu72piftLiqkSPNTLQtk=;
        b=TKELixQmH9K750Fx8JnZPu6+mG1GK5pCyXcjm08D7UpXozX9zAjhi79Ax0cwVXKqTC
         nRX23UVPU2ZC8B1eKTgMod76FFtnTBwpurclPnET+8WDkY/oZtkNtFUKcdzKYUIKmzii
         Ctr5RkYzi3WSBfVSBFvMXKqJb8ToKy8VKWFi2lFpepM5Vc8/v2tu7rJouC4QPPM4/w2Z
         q8AKO82K4Q0TVlGutRZHnivRzPgD5rFv4MxmJrS6CEcdzkn9rDywxFMvaAzmgqk61nlg
         oI0K0Fe3SLi+Q/eJCRExCF/cX5IyV04tTWH/lLlbICh/h8j18xQi0pv3vQeYCP6vltc/
         /p9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e6Oq3V8WrT036RQ9hRYSwWbzu72piftLiqkSPNTLQtk=;
        b=YZg6f5EKXKj3stcBYf9vnvu8SPv8lG9Kgjn6FhZN10iJQiL5QVsy/Q36BZyJL0Qi9j
         abVZ+9HXwB87nwxLf88Bf7rr5keDikA7jBmWHDTSH0HdJ+LpwEskmLNRtE1zqo9U1/Pc
         DdcVNYsRJ7UBucX+zmus46qB871fSZ4w78YfwmHb/gweZa0Gs6Pzz4lbgfJn0yB2X9uD
         zyvkxAn4OYrk5V6ELt4Yif9Bk6Ue+s90nUwwC1H/sULccbpYc8L6mJB9FEIzGE1Cc6U0
         5zcvleoBgt+0WJIoVVn4conCdW5ieAk5/XZxno2I+gBM4K2pQuoR6WBHeN/XkHlmiq9j
         onTA==
X-Gm-Message-State: APjAAAXfD4pWybbnnYdA8sOtm0dkY+ghEGd1vBDTeqK/0FfKeA2OOKlp
        xl2i6gmqgsQyNcYapTaDndN9h4MmN7Q=
X-Google-Smtp-Source: APXvYqzVm+wb1jggjN1utdbrjvEZa3G+8sNm+qk6yxHCK5zSndKrfnCyC8+1EyrJoHAbfUrRo+/3UQ==
X-Received: by 2002:a17:90a:6:: with SMTP id 6mr5569856pja.71.1582321572329;
        Fri, 21 Feb 2020 13:46:12 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring: io_accept() should hold on to submit reference on retry
Date:   Fri, 21 Feb 2020 14:46:01 -0700
Message-Id: <20200221214606.12533-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221214606.12533-1-axboe@kernel.dk>
References: <20200221214606.12533-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't drop an early reference, hang on to it and let the caller drop
it. This makes it behave more like "regular" requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e175fed0274a..c15f8d6bc329 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3353,6 +3353,8 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	io_put_req(req);
+
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, &nxt, false);
@@ -3370,7 +3372,6 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	ret = __io_accept(req, nxt, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
-		io_put_req(req);
 		return -EAGAIN;
 	}
 	return 0;
-- 
2.25.1

