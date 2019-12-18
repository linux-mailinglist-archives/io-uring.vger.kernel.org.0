Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20A9123DF2
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLRD2Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:16 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44685 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLRD2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:16 -0500
Received: by mail-pf1-f196.google.com with SMTP id d199so393322pfd.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mVVi/SbfmC5upQTZn+FNodv8UbEea8HplNdPmxOm2xs=;
        b=GpK9GYKt8g6dojocQBF1T+IFXW8gDc0NXsTyigPUoDqFU9uz93QWehhyDUPC5iYTq7
         Xykhh2cXoJ5qWZwjwcl4gSS6pKbSedzYVxq1oeut/K503FXhogZUS7RDyBOuPVnuPTOm
         Has/WSiOnycGrE+LVC/my24R0mQTRFOZ0IM5pyv/KxG7d6rMozox/fr1x0ikdQX3XMxP
         jz0jsIucb9fQHtssHR6wXRW55TlaeQVFAbmZ9byshs4hev2u8+joybL+uP6uJvUoVawM
         IWOjr0kPVKJBPhFI6CaRMSux8JTBCpN6mR5EvhaoTN0XT3R++EaIaBW0M3Y9i1ElkERk
         excg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVVi/SbfmC5upQTZn+FNodv8UbEea8HplNdPmxOm2xs=;
        b=G6GT9mLe3OVxPGjt4mFQt21vjOzZCNhmt4NZ4w1mPipGUaeo4p6JlsM23q4mJj4jo1
         Mg3P+QUJ+KDU/MdCj9pvGwC0JFNFIJyFZVstb8kJhvO/MUDG61tr60SdrD+4r5vWPf79
         HCS4+Mep4QuKBlx6IgOKuv2xPAfoBs59hD21vvmEAxFTDFWkIlFPLubYAdxMfYkqABpi
         xQBS0NkhwxmgFO+vUVsZ1VZz9gJcL2cnHXZAzxX6WVX+agn1vRq+ebjNglA0pP+TNIQq
         tbzArW2G0nFsKfOHb8C/vGgPNTcO4wHNLq/in+5tBb6mJCQ5kP66pObRHSrXIxmre9Dk
         Oe+A==
X-Gm-Message-State: APjAAAVXFj8POZATlPAOmgGRQmWmba5pVpNgAfvYjFWMATFf8aYnFwJm
        kHYYr7uRsGlTpSV8FBdY0402CkVqegCtGg==
X-Google-Smtp-Source: APXvYqzNa6GaICMYp6GrlooDsnGcKO3CzKMwDNQZfHwbTb2/6aSQVSoVhE8kt4W3M5m6mM0W5GsYPQ==
X-Received: by 2002:a62:1c88:: with SMTP id c130mr487469pfc.195.1576639695419;
        Tue, 17 Dec 2019 19:28:15 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/11] io_uring: warn about unhandled opcode
Date:   Tue, 17 Dec 2019 20:27:59 -0700
Message-Id: <20191218032759.13587-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that we have all the opcodes handled in terms of command prep and
SQE reuse, add a printk_once() to warn about any potentially new and
unhandled ones.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5dabe0a59221..8650589798de 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3074,9 +3074,11 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct io_async_ctx *io = req->io;
 	struct iov_iter iter;
-	ssize_t ret;
+	ssize_t ret = 0;
 
 	switch (io->sqe.opcode) {
+	case IORING_OP_NOP:
+		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		/* ensure prep does right import */
@@ -3136,7 +3138,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 		ret = io_accept_prep(req);
 		break;
 	default:
-		ret = 0;
+		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
+				io->sqe.opcode);
+		ret = -EINVAL;
 		break;
 	}
 
-- 
2.24.1

