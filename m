Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2EEA156BB5
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgBIRLV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:11:21 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54430 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgBIRLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:11:21 -0500
Received: by mail-pj1-f67.google.com with SMTP id dw13so3121098pjb.4
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U9VBN+HDadv8KUlGUmU7ObV9XSdQxE2IB6nBqcm7eRs=;
        b=Kbai2yHvpgrKdR2yBdfYYYkcQhwITX9DvADg7Wt0K4Krae7eJKD8GPeheyCjcsal47
         4fvxnUUZCORgCBS22caglmptsJPGuSzH7hP6zQhrPH+PtHaaDc0Lp19laD5buXhz96WE
         RYQifRUZcMnp2El6Fa5Wfxamf2VB+7cLikn6wrdI4c5J6CxyFjptrRwVdw9/lmAzgBQj
         GSQ8F4t9CFsB1wPY7vmURw62Bimqo99wiTJS86r80VNXyrGLE+ayFiMxg5MEBJN/7Owg
         7j0kdXPtLUk6NCq/8msb43qyBNMMOtyRskmCtgQ9tnox8CQ0fuAxe5D+pNdf6XLaHC4S
         MdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U9VBN+HDadv8KUlGUmU7ObV9XSdQxE2IB6nBqcm7eRs=;
        b=pugqJL2TqBe/6dTjEY3QkwkajC46V1zEUFmIlokLmWygzUB4dQL1teis5tXdAe9KQw
         ArWraaEhyHGlLJdeJ0iohjVvewwp0ecAGR42N4NJyCN6/GiqxIIlSUQkCE9nhqTsHBOv
         TLA7DPySoI9vqvpP2P3E9BV74kolddyztd8wAC0QVhZLZjMrT81cljwwQ1AbBQKpz9uQ
         9B+dOv5ffdox/PuwR5SSBrdgVU8waTF7XbX5BM50QJ0sLMTENGfCYvCvFDeStn5RE1fv
         T1rEMdPxnFoMcrGtrPE6O4sdNw7nv4xqpBZf/luXIHGeUYQl53NwJe3OP8FQQVq3X5Mc
         Jvhg==
X-Gm-Message-State: APjAAAVJXlvPriJuZa7WyjreOtEhMH4RhItfbE2AuqbmQr6wjmPlDa6O
        D0+z74FonmsdHla3/bFr9Sqg+8rlMJc=
X-Google-Smtp-Source: APXvYqyp1vmGP6Sv8iE4hTk+dFL6U+Aq6Z1MQxtdksXqJOARv143bIJAHRufo5h/n9CDsIa8j3e0bQ==
X-Received: by 2002:a17:90a:b386:: with SMTP id e6mr15817757pjr.106.1581268280740;
        Sun, 09 Feb 2020 09:11:20 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o9sm9703271pfg.130.2020.02.09.09.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:11:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: allow AT_FDCWD for non-file openat/openat2/statx
Date:   Sun,  9 Feb 2020 10:11:13 -0700
Message-Id: <20200209171113.14270-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209171113.14270-1-axboe@kernel.dk>
References: <20200209171113.14270-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't just check for dirfd == -1, we should allow AT_FDCWD as well for
relative lookups.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a7bb178986e..e6247b94c29d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4543,7 +4543,7 @@ static int io_req_needs_file(struct io_kiocb *req, int fd)
 {
 	if (!io_op_defs[req->opcode].needs_file)
 		return 0;
-	if (fd == -1 && io_op_defs[req->opcode].fd_non_neg)
+	if ((fd == -1 || fd == AT_FDCWD) && io_op_defs[req->opcode].fd_non_neg)
 		return 0;
 	return 1;
 }
-- 
2.25.0

