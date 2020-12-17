Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAF02DD406
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgLQPVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 10:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQPVt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 10:21:49 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1AFC0617A7
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:08 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y5so27817552iow.5
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H/UT3sBLb8t/BqsRQfslxhHw28TrTlyUgKP8sgwvxLo=;
        b=Ipg6HzF7fLfze5wN82fn3rot42wpnmGwcSSKE5yLJ1rxQHt2KKum7XUfAVWioum1eN
         LVuij/9r35t/Ram/VC5w3jJdje250GQ7xx/WKXrlMDuX2h4Qojw4j12wS/HFdLfaq0tb
         Mq/x6+EERQAviPhXQZDfapFmLUfHJNI+dWjx0rQPHOLjJJ9BSoWXDelN1dtcSEdmD69/
         1FkSlGhDN43w9pSf5qw6OQ9zpBG7sY4xHZy0oepBrKEnEaOPsC7b8tZes/Gr2ASnHwdK
         uWX0d+E77Y54rfFDE6mnR6pplUt5d96k/Jp205esJkwi3GeFGuLMOnjht0IQNJ9OHRrg
         /sIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/UT3sBLb8t/BqsRQfslxhHw28TrTlyUgKP8sgwvxLo=;
        b=tqpG8HBHXT6dxUN54Oqc+XULTw91caxQ18lFVH1xdqCV2GqyNXE+69q/bP9pe0nrWO
         9jrdWRORvFE/mL7WelEQ6VMw7IYOPL1H6qC9ul7GcQx1sxf1e7JGnYEUJU6OjUCsAJNV
         d+DfpBG+otdJFsg3HqoX9n+p7/lbxu9J+KCo6aMMHFnq0FPx7u2Ed/ZvFuRzpqR/JMjh
         suPpRTh7JZdbmpE8D5BKLQ75t4s1sArS4/TiGPKn2jg6HZ8mdYYep/Px9yqc810F9UR1
         nLXQUvp2t84dFEdYW9t89gHvI9k23FwgooXXG9x/OX6PG4QrRJrgkZ7AVPszdOQf+WSo
         u5aQ==
X-Gm-Message-State: AOAM531vCqcv0tOuYPD7RJ8oo77AkXpXFpEUZpRb6TZlZpryKuqUJC8y
        BGlhU1gLD1Y2PbnqYrHHByzSvpEYlKVxpQ==
X-Google-Smtp-Source: ABdhPJyUk9l6RzJHAsaCWD9aBEF+/3d0K7Kjz4+lNv/bGmVITKdYXkOtNU6z5wnauruVsf2ZMzYOXg==
X-Received: by 2002:a6b:cd02:: with SMTP id d2mr11563717iog.4.1608218468027;
        Thu, 17 Dec 2020 07:21:08 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l78sm3611793ild.30.2020.12.17.07.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 07:21:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: break links on shutdown failure
Date:   Thu, 17 Dec 2020 08:21:04 -0700
Message-Id: <20201217152105.693264-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217152105.693264-1-axboe@kernel.dk>
References: <20201217152105.693264-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure that the return value of __sys_shutdown_sock() is used to
potentially break links to the request, if we fail.

Fixes: 36f4fa6886a8 ("io_uring: add support for shutdown(2)")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f9392c35eef..6a4560c9ed9a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3784,6 +3784,8 @@ static int io_shutdown(struct io_kiocb *req, bool force_nonblock)
 		return -ENOTSOCK;
 
 	ret = __sys_shutdown_sock(sock, req->shutdown.how);
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_req_complete(req, ret);
 	return 0;
 #else
-- 
2.29.2

