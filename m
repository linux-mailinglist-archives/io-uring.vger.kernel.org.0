Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E903274F0
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhB1Wkp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhB1Wkn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:43 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18D2C061797
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:27 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so2130983wmq.1
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SPkwou+yAzqeqDsHylAkjymin2kPcIg+c2nBTMMDsNo=;
        b=m39sJMpf7Pue+ariHamdgzaLIfUxZHHEWfBIAQJ9+CMURVs7Dhg0UQf22cEj1xwRLD
         LvnnKH/6bHzzW502u+EN1Od2BMebSSaeAOPY47nnAISNAsdMpwmLtInuOuXlZ4tu7K/J
         Ok5lgjxEHn+6XtuZrcwhJmU+/uJCU+vZ3URWioGcxVgtbm1y6rqGXfqiaoKckMgG4gpN
         G183BGDLmsS/FOON6/OIJSZqxn+1kVz1UBOT6CbclmYSHMSRikjsVkzgNSgS+xYrPeB6
         Cre9IYp8MC/f4vtXpEeBQOupL7RZTTZi0iKXqpDbyBmNNqLN/DRyQesT4UrHzrn03H6/
         5/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SPkwou+yAzqeqDsHylAkjymin2kPcIg+c2nBTMMDsNo=;
        b=TYFyS8OtOJCjKg8sjcMZhhg/ikGwORzs1aRQonTeurTBBX7sywkXnX8M4aIGc4KaMq
         rkdFvDMJwoQP/J/gv4e7W4SdB2xGEI3JM+9FkflxJVuJmAFoopc8G3VyZNiMrQdnszaU
         yXlrTVZDnel8/+D1m4U2bXml8a09Qk/7LM1BhRIl3z0zTpcfy3D8u7khPhzi59qFLMg+
         kNHysWvA+XkTHoJHscP7x5+0VUfqMAQJO30SHaV/JdNDQC8gtP8gtBgawRdE6BdEwe1x
         QDUpXNg/kganXd+/eXqCIx4iBaw5sj/NBKji+NZxpR72GEctlr2uTOE03dIALNUr0nDK
         GXEw==
X-Gm-Message-State: AOAM5315WV0XIKDKG/5yt5QEzvjfw2adX2Owhe98JO21WdagzXUa0178
        TH2RSv4GEUssgFLevnTOHD4=
X-Google-Smtp-Source: ABdhPJwNd8HbiutN+smxbxF5u3U9UD06U5Y0arglpjq8+6+nHPQm+CLVjJiwVX+uJteo0XLyBi36nw==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr12569833wmc.152.1614551966734;
        Sun, 28 Feb 2021 14:39:26 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/12] io_uring: untie alloc_async_data and needs_async_data
Date:   Sun, 28 Feb 2021 22:35:17 +0000
Message-Id: <d296f66f127f936939fbff9dc306aacbc000f44c.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All opcode handlers pretty well know whether they need async data or
not, and can skip testing for needs_async_data. The exception is rw
the generic path, but those test the flag by hand anyway. So, check the
flag and make io_alloc_async_data() allocating unconditionally.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6fb2baf8bd26..bfc795e8258f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3062,21 +3062,13 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	}
 }
 
-static inline int __io_alloc_async_data(struct io_kiocb *req)
+static inline int io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
 	return req->async_data == NULL;
 }
 
-static int io_alloc_async_data(struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
-
-	return  __io_alloc_async_data(req);
-}
-
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force)
@@ -3084,7 +3076,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!force && !io_op_defs[req->opcode].needs_async_data)
 		return 0;
 	if (!req->async_data) {
-		if (__io_alloc_async_data(req)) {
+		if (io_alloc_async_data(req)) {
 			kfree(iovec);
 			return -ENOMEM;
 		}
@@ -5770,7 +5762,7 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	/* some opcodes init it during the inital prep */
 	if (req->async_data)
 		return 0;
-	if (__io_alloc_async_data(req))
+	if (io_alloc_async_data(req))
 		return -EAGAIN;
 	return io_req_prep_async(req);
 }
-- 
2.24.0

