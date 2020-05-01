Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9961C176F
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgEAOK4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 10:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728840AbgEAOK4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 10:10:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9381BC061A0C;
        Fri,  1 May 2020 07:10:55 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so6070905wmk.5;
        Fri, 01 May 2020 07:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IAf6Gre4CI3bCwa5vEmyXDJKlM4nN1VUj17/dj4XXpw=;
        b=KTWaNlwUNym5z0Gt3KcWT7BTxBawtoLjOTOI6QkKArofrtUh+JBpHOjY2U5PRXxZ/m
         yJ13N2Xk7QBM0cKVN8jm2NWan7OuZbAJ7dR9h7BZxmZT/BjnNhcrIDHb1UilQgL7IdY0
         ynG8OE4kp7tgYcEXxIqzjP69edNjO0KCwAeZSyli13c14iSbhEs6jqF109WB3PGWkCsu
         hN7quWswi555x9inwGEfjvwWM1p4/ObXsZY6PK8Mly537EPdvnNTD6sQrRX0D7LRM0AX
         QBc3ie21q1RaIsSYnAS1GXEl/hnRImhZbb4skWJvUBJdGJi4O9GNNDa/RHJp9dApDRJP
         KI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IAf6Gre4CI3bCwa5vEmyXDJKlM4nN1VUj17/dj4XXpw=;
        b=fnwbERojtHbGY7NAIwc9kRMIonCT5Qx4KsucDr4by+JuyvtQzmg9KCencDtZMnjIyk
         yIzmVsIuNcUgl77wRm/KUpHXLSDz1AEHN0eo682GLCjMPPBNKK0yoI7k5TSpaFTChvxc
         wwsFZbXpi0WxuYdYfs4qICQK3IfbIfYpGvTCviDbDpGcQ6CIYguwr2Rtcd5FiwOtkVNm
         5pzsh7m/trRbpXV2QgydzOOC02l4eAtW1x2dvIVz1kQdSaHVGCysK7qOc9jrJwemFDs3
         UbFFtIE8bBJ+ns4DdDLuS0mxi7m+PzSD9+6ucYdanAqb4sZK2NJbyOCgNQVYe3m1DvJ1
         UwGw==
X-Gm-Message-State: AGi0Pua/tznYuoHpWjZUPu3HrhEo+KOaykoSUub6g0l34qo6myJQ0Lr3
        BA7bDmJrU7JI3jOu2MCsCGfyP7Fx
X-Google-Smtp-Source: APiQypJGNdSnTtWpOpKeeONoIF+z0quTiMIo5dhXcAfSbjl/Pj02o8HiAay7CPqw0waVJ+xI6vWmLA==
X-Received: by 2002:a1c:6455:: with SMTP id y82mr4154900wmb.128.1588342254204;
        Fri, 01 May 2020 07:10:54 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j17sm4837390wrb.46.2020.05.01.07.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:10:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: punt splice async because of inode mtx
Date:   Fri,  1 May 2020 17:09:38 +0300
Message-Id: <ca4741da198740647d3d90716d63facf8bc0a53d.1588341674.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588341674.git.asml.silence@gmail.com>
References: <cover.1588341674.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nonblocking do_splice() still may wait for some time on an inode mutex.
Let's play safe and always punt it async.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5d560f2ce12..65458eda2127 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2765,15 +2765,6 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static bool io_splice_punt(struct file *file, int rw)
-{
-	if (get_pipe_info(file))
-		return false;
-	if (!io_file_supports_async(file, rw))
-		return true;
-	return !(file->f_flags & O_NONBLOCK);
-}
-
 static int io_splice(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_splice *sp = &req->splice;
@@ -2783,11 +2774,8 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	loff_t *poff_in, *poff_out;
 	long ret;
 
-	if (force_nonblock) {
-		if (io_splice_punt(in, READ) || io_splice_punt(out, WRITE))
-			return -EAGAIN;
-		flags |= SPLICE_F_NONBLOCK;
-	}
+	if (force_nonblock)
+		return -EAGAIN;
 
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
-- 
2.24.0

