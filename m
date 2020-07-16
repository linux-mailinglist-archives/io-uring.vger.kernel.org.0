Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F5E222CD2
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgGPUaH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D902CC061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so8465639wrv.9
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=z2gENNtV+rmbzuMqHFuB+c2hM01ZynUmmTtYSpnaFP4=;
        b=dzyx9D7Rot9g+4wEsO4mTnDP/Vl9Awn9Hhvs8SGAM+WGeDwGhHbA0xgkV6c8uGdzU3
         b3BM1+ZVxp1xK9i+00D/AT6iSHSWJ1GRLgP028+7Pp0WqHZSKgOiR5HEBHlzV8+RPLkS
         MC1iQlRKJGrqnNfB4rHKeR81hD1qQXUlWKfT6OoV2WEJGXj6yeKcobdPFH/xp7Hefppw
         eKW7FXeIrGO2e5xtkoZzH8xbKedsVxs6hP4QKjAr9rZlCiRtBDmYpMxzEKbfVh/Qy1ab
         MX+L7WomavCVizIqK7576U/WgqTuGL58oMM0N6Us7xcZ2e7g0XNemCXZaeEUQgSNmiss
         baJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2gENNtV+rmbzuMqHFuB+c2hM01ZynUmmTtYSpnaFP4=;
        b=gYbDNEKYQBrVUEzL92zDNxNkgY//lYlExkH3dv+oyDeTb5/xF9Gsc84+Rx7GYzSvaf
         PXIxq4ybfOXMYQLQqfW8Dw8cxbqlF5oCpGz4h7Zq+8w4MwWY443wEZqYmgbLdIV9XIj5
         EGvy8YUpU/J5zXa+kgPFip7OOu4kvZzIGrOtnIrGShRjK9bq/H4RZd0NyA9sc7IZjTrx
         S3yvAxxK6E5lzRwjcauAOScF4hN+uHKQGyOfrcMyAqU/6qBuACqWPwwNIXpPqPoBARJl
         VksLQ/bivXBYauOuPkBNvY0AtZibq+HnVfplEjm/8eaFMapeLqtmqDfDr5KEH5VVGECP
         yZew==
X-Gm-Message-State: AOAM532QzkTVTUX8oue+Z4dfTVwJD/wbvZrK0fpu6Kaain2QVDDkZnXu
        C/BZAOhfAIlWh0FOnYYKuTo=
X-Google-Smtp-Source: ABdhPJzaRTFgtBavbGeDhXL40ppKPM/HHTaWvQQm/a5wH+23aGCLDfrGKhHig9UkJOO0xM2CJiRfqQ==
X-Received: by 2002:a5d:56c7:: with SMTP id m7mr6500630wrw.223.1594931405638;
        Thu, 16 Jul 2020 13:30:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/7] io_uring: don't forget cflags in io_recv()
Date:   Thu, 16 Jul 2020 23:28:01 +0300
Message-Id: <9080155dcdac563b84e44983ddc72611adc9ac5d.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of returning error from io_recv(), go through
generic cleanup path, because it'll retain cflags for
userspace. Do the same for io_send() for consistency.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d5c7f3feec4..ba6f68fd2038 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3979,7 +3979,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 
 	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
-		return ret;
+		return ret;;
 
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
@@ -4235,10 +4235,8 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 		buf = u64_to_user_ptr(kbuf->addr);
 
 	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-	if (unlikely(ret)) {
-		kfree(kbuf);
-		return ret;
-	}
+	if (unlikely(ret))
+		goto out_free;
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	msg.msg_name = NULL;
@@ -4259,7 +4257,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 		return -EAGAIN;
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
-
+out_free:
 	kfree(kbuf);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-- 
2.24.0

