Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3497419EE32
	for <lists+io-uring@lfdr.de>; Sun,  5 Apr 2020 23:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgDEVKB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Apr 2020 17:10:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53119 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbgDEVKB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Apr 2020 17:10:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id t203so4179354wmt.2;
        Sun, 05 Apr 2020 14:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lSOKc+HQI/g1UnrgTsNvtmUHVD7LObr5lhFzq0FRBR0=;
        b=s+tZRGxPyr7Np+lIw0qzvmoe2fAmJ2YUCw+6fE5AHahZi1aDh+KDchydSTJbBLZep9
         VzjA4Vb/qtpkcGZols3+8psvwqqWmmG9+ksBU5IOtOoXwxlRem9B486BeFRFa+2iu6YR
         en4dd+CKxiAS3TWvcW07VJzV+E4HHXpKHwUDvOTWtSWzlgkp/cfik0NbpxMubqsspeJs
         2zwq825FH1xWMwKbpfCGHIAO0F3cIALjuZd2bq5m2/hby0BK7OaRFKz1xFWlciDyfTGW
         hBn66bmS8H/mLdD9h/Gr1a8ezVwpCikVJBJuY/k2Mjp1GpVVv2odIbcHwTsZOynDCsgB
         72BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lSOKc+HQI/g1UnrgTsNvtmUHVD7LObr5lhFzq0FRBR0=;
        b=hzBrCIW7rNrXqAp2+3eBp6xocpkmlHOgqIlHVdJxzjRzVmLhjqTIYeoxtsr1rDgGow
         GBC5A+qcGLsHHtMPUxVAqEQJKWuATNQgDbdR2MJJuuco/qFz7MF6Mlas3H52F/jO5BVd
         Q6UdXQaOLaYCfNA9wGHcGi6tENdv/h5gU/sQTNpL4+jIwNTZ8MtPo3tHhzvcT5F/FtrH
         x9KJjjKevm4lc+XNvUUgY1QCCbx+cDnR9r0CZtch4cEMo73c7u8gwiZ4K3vtjr4avP6B
         3UjxCUii3N2u/OFd+FaxII4CRlhWQGv63EMrj5FOhCKw9fqMzbGPUna831egtKNYUUnu
         VEJg==
X-Gm-Message-State: AGi0PubKiJo7M6uRo4YOaz4cC8KxH+9ASoHCuaJEW0KffQd9CjUqOL0n
        0cc9tBKfdG5TZ2pM5X53jhbozdyT
X-Google-Smtp-Source: APiQypJdesLbJ+IShoTkBhLrfkaSFeYabAR9rXXYGlcHXzzOcfKPJ1SB9DzFXVoASoKhktBqeYNhCw==
X-Received: by 2002:a1c:6a14:: with SMTP id f20mr18386952wmc.125.1586120998987;
        Sun, 05 Apr 2020 14:09:58 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id f1sm24493791wrv.37.2020.04.05.14.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 14:09:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix ctx refcounting in io_submit_sqes()
Date:   Mon,  6 Apr 2020 00:08:52 +0300
Message-Id: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_get_req() fails, it drops a ref. Then, awhile keeping @submitted
unmodified, io_submit_sqes() breaks the loop and puts @nr - @submitted
refs. For each submitted req a ref is dropped in io_put_req() and
friends. So, for @nr taken refs there will be
(@nr - @submitted + @submitted + 1) dropped.

Remove ctx refcounting from io_get_req(), that at the same time makes
it clearer.

Fixes: 2b85edfc0c90 ("io_uring: batch getting pcpu references")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 78ae8e8ed5bf..79bd22289d73 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1342,7 +1342,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	req = io_get_fallback_req(ctx);
 	if (req)
 		goto got_it;
-	percpu_ref_put(&ctx->refs);
 	return NULL;
 }
 
-- 
2.24.0

