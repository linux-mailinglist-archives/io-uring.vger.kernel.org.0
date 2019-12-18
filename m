Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05718124EF4
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfLRRSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:54 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45890 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:54 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so2752462ioi.12
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2Y5wZeu1fsI0u5DYdrTxT+NRE4vgiU7iCU3Xv/0qRM=;
        b=okjGVFkOVDKICUIfHGqq07sK1ghsBlP7SYdYT0JN5d6svdN3qWXTK9dA1Fg4uyQr51
         09E9ceolieNNd9Wol9Apd8YC9EecHGf0EyT3A/tv2J9lVJart9BS75YugpPQqW7yjPAc
         8U8HTr1dCjOYFydeKJJ+8uwj+90nBkoAlqdaMtaDqk5Fzbs0kqTyRU4Jk9d/dgm252bF
         I5s5Ti2vzywa2q8bYS9aJ6ZXHiQBtWPbzsi/qNRDVedUOatLjVGFg06I0w+hY02aXbgG
         zDwZ38P4rFbC++ziKjB0wX4ag4XSnOwIDQ3m0qDncMalhblY/xAkbgkYid749cSTUUnC
         wi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2Y5wZeu1fsI0u5DYdrTxT+NRE4vgiU7iCU3Xv/0qRM=;
        b=Ev17W13oWmduzp18cv+FCQBOi0O4WqwT9W4KFG+Lnw83pwXjVW95DUKw7zecI2x9gj
         lj/93j4Tzx7bc3YG0QiHZE3q2N6MfinKBjEqkXrzeQR3bRZYZZz/RBd3Vy1ox+FJNzXY
         WzK4sDYwN5hvwel0dNk9v+ja1NWUNY714aq5v2c+51iiaLoGo5QtFBGMI1qf+1BFsYuz
         iAz0xtCM0UXRuCNfC0P4AUV+JW3cz1DRRTB/c1pv1Ta7CXKoU4I55W+8hj4LqkX6j9pf
         GwbpMWpYiy66E0ZmEpayQGJhRtUha1jMDU8Tp2JZ2pqQ+X9dSYYsEvRt8jAAm3WgG0t5
         Rz1w==
X-Gm-Message-State: APjAAAWdcIDIsbbVRYBbpDCPbghhanejZV4QW1MFHp4WjyRvj6GNzdwB
        YgIFNaKjzKYkPJTdI/gQjldBjE/0KFTy0w==
X-Google-Smtp-Source: APXvYqy8w95T+DetDweuSLvr/lq80PvnBRuKdhBvCIcgsR+a5k1+Zh8o6Gtehb3jNRg2RqmWMRePpw==
X-Received: by 2002:a6b:cf03:: with SMTP id o3mr1386585ioa.184.1576689533717;
        Wed, 18 Dec 2019 09:18:53 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:53 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/13] io_uring: warn about unhandled opcode
Date:   Wed, 18 Dec 2019 10:18:34 -0700
Message-Id: <20191218171835.13315-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
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
index 9f10f5a9da8d..74dc9de94117 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3077,9 +3077,11 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct io_async_ctx *io = req->io;
 	struct iov_iter iter;
-	ssize_t ret;
+	ssize_t ret = 0;
 
 	switch (req->opcode) {
+	case IORING_OP_NOP:
+		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		/* ensure prep does right import */
@@ -3139,7 +3141,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 		ret = io_accept_prep(req);
 		break;
 	default:
-		ret = 0;
+		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
+				req->opcode);
+		ret = -EINVAL;
 		break;
 	}
 
-- 
2.24.1

