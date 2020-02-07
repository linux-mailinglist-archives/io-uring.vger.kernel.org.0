Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912E1155BA6
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 17:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGQWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 11:22:16 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39307 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgBGQWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 11:22:16 -0500
Received: by mail-ed1-f67.google.com with SMTP id m13so123246edb.6;
        Fri, 07 Feb 2020 08:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qfPiejj3XjGvU4zBUXMU4/Zw2o3mtsbKmeUjXUlQCt4=;
        b=tL3/C7IJyhHnzAvP1jQPm8SPP8Bccj1/Ij6am24KgIwmagn2v63pdIi0n18LvIa0QQ
         VNm85boNKrtZiHoNSESHUfltpmIc1+BVuA78Dh/ap81rTLzm/Wqpf5gSifv7Ed61E2Se
         n9S8SB+lTRSfMO1nDSYmTTegoOCiisc7B5zFeR9aER+Ynh8/wOMNYjcXynCfobEYTZ8h
         hWXszghTC7bGLxejWXdDJGjSMVr13G4gRX9lylI7MoXyWAhqNKmF97FdUZqRzTarjdnz
         0Bv0lWK3rG2SMGK7fH4B3RA7GbXz3cvKOgaJWvvsGWIIW5AibvhVMGugrvzKD8WgZRW3
         stbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qfPiejj3XjGvU4zBUXMU4/Zw2o3mtsbKmeUjXUlQCt4=;
        b=RA5qmDOcTPFyRB0IWBsnfTduGF5+5eKez9y+gBD8Uwt4nESI0uWR6aY/tg+9M3QOtj
         q6UVBTs8y4DRI7kHuPy4XVnEr/57VCc93RU4XenulpzQkS9gmKccOQjIxByWuRV4lMWW
         CkPO7Nv6Ms8XQI7yusSZF0EkYPw1CA1IMRlYUt3mj1/DEa5Qej+VWmYmNyC+SH7ja/qu
         MCe59Yd1au/i4iZbWCj+LxY8lmgEob5PA3a1qPWDRoZiQbTSMJHN4gjxJ1dY/YYpyEuE
         gpg7w2/kCr2YRMqrBZzhlTLk+UbntQHy5PfqjjEu+MK9eEwUr/XNR29TjCf4xsUygKH9
         FjYQ==
X-Gm-Message-State: APjAAAXFPZrkjYaUkfKXcDAmP3aXMzBgWDlM5RGyseh9/oYoSKiXbqst
        /QdgXdJY7lX+jxXSSYJjRSXsNGGl
X-Google-Smtp-Source: APXvYqw9VI/kfHd1ym3TppQrGns491gBqQgRSf8cLFqecunVf2pvve8Sei0BE1UZ3goBzo6eCxdqQw==
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr2338ejb.341.1581092534265;
        Fri, 07 Feb 2020 08:22:14 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id x12sm426368eje.52.2020.02.07.08.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 08:22:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: remove unused struct io_async_open
Date:   Fri,  7 Feb 2020 19:21:25 +0300
Message-Id: <a14a8fc0c22be0dbbd9767f424e876704d9e9c8d.1581092449.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_async_open is unused, remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index deff11e84094..bff7a03e873f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -450,17 +450,12 @@ struct io_async_rw {
 	ssize_t				size;
 };
 
-struct io_async_open {
-	struct filename			*filename;
-};
-
 struct io_async_ctx {
 	union {
 		struct io_async_rw	rw;
 		struct io_async_msghdr	msg;
 		struct io_async_connect	connect;
 		struct io_timeout_data	timeout;
-		struct io_async_open	open;
 	};
 };
 
-- 
2.24.0

