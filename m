Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798B73223FA
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhBWCBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhBWCBI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:08 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EFFC061794
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:54 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h98so16185658wrh.11
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KUKtNNGJAmu1NPZBvBMKijmfKA7sL6hg28BNMJwq4OI=;
        b=H7i5Qdw7EqLu9seZX9xJNfccTgUwOnubLkAc6zasNYWYIRa8UIZ5EZSHZMxAWWinXW
         PNJT6fpkw2wW2lXpLHhy/D0OHhf7D7rQ7OOmzpaCRqks7jkw6S8tTfRLp0fqzMIxL5NC
         xBJ8u869kdk2LykJhsOwgXKHmCZu/1FT65DsYgYU+N7dAsL2AToHmvdwJYK9AgCvZGJR
         EaJyMDBEcDV3VydSb0MtSeM6pwxZgKdFdP7gYeTdkwkvObl/W6IasnguJ5x1mu2Q4nmL
         a3wNu6RDBwKxi4F8fyIPlF11gxz9OZLedhOsxCLEsnvH8x8UT6CKrcwmgriUD+kcoPq0
         6XBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUKtNNGJAmu1NPZBvBMKijmfKA7sL6hg28BNMJwq4OI=;
        b=bKbsUrW2i8UPPXadvJdXJydV5W20uV/lAL9/+ELWhDWUwumSspOmLnwLGaagetbSEa
         1HVGQiAclmrrID+dWan+4WOoRjE8HcEw+UuL9GP0HPDeHHoEnRdterfg1v2k4zGB4a5p
         mHlCh7xuIGGjZ3CRceCcAfrnoQ6W1jc2D4nEB8EeSVXHKINAoXFF4ocKGq0GPVfH8+Di
         ke4ufPMpCZltXKIoOiHH0AVBxNBydNq+RN31ZdkBj8hcMEFNeimmW7xAZ5oToXV5BhRO
         KVT2NPRlZjVbCPCjlF57i4FJh7VS85sKggveKu1bCbVifcQEcQsL9Wlxr3El9XAIR1Ip
         AcZQ==
X-Gm-Message-State: AOAM531XxoRZL6tg05waqIjH8MlC4DuL9+snTcc13JwrZN6N22CAjfhz
        s2PKdRAmz3WcPNFCjRgEIzU=
X-Google-Smtp-Source: ABdhPJyI6KfWjmj+yPgs5nkXds3ulcXc4b3EfFA9ZlIp14nWfmgvPMl+/8sX4v+Fa2ApsarfBAhJGw==
X-Received: by 2002:a5d:6503:: with SMTP id x3mr7652739wru.249.1614045593245;
        Mon, 22 Feb 2021 17:59:53 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/13] io_uring: don't restirct issue_flags for io_openat
Date:   Tue, 23 Feb 2021 01:55:42 +0000
Message-Id: <80307210ea4680385eb989dc170729b4b92fe914.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

45d189c606292 ("io_uring: replace force_nonblock with flags") did
something strange for io_openat() slicing all issue_flags but
IO_URING_F_NONBLOCK. Not a bug for now, but better to just forward the
flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39aa7eef39c2..d2cbee73fd4a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3870,7 +3870,7 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	return io_openat2(req, issue_flags & IO_URING_F_NONBLOCK);
+	return io_openat2(req, issue_flags);
 }
 
 static int io_remove_buffers_prep(struct io_kiocb *req,
-- 
2.24.0

