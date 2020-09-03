Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6C25B8B2
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgICCVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICCVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61131C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ls14so696330pjb.3
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dn11zwhkmCJhg+mgdZgPgjCcclzNUtad0iCNo9wv9zw=;
        b=pMYAow64+13O26AXEXzXjOKIKId6CnBWZmmsb75cL0D6P/wkS796lrcH55sSnlcy34
         7ZGVpR4+CjZ7D8YZ7Hbnagmz3/i1gr48SnmdJS3Zw4YBDOtKFSbGiajUGDeNmDYnrB4L
         uuahcu43ii+uz8QZSlRnIyvS7HoYbIp8IMg/uc52s6XQ3qUQBX1zZTuR79yy29krHTlF
         zdRlSxDnX11gMzuopieQ5Q5ccdCBxixYj/S6B9qKlyl5r8NWdlapOhSOTUyYeuVLYgBz
         4zRgg7CO3v96Rqyr43khSMBhkM17Pmeylg9Fw9YlHZ/R8lqyXqh1n8o32pPImRSJ3ERQ
         /pFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dn11zwhkmCJhg+mgdZgPgjCcclzNUtad0iCNo9wv9zw=;
        b=XVu3CZsZZlolCQRTkFnL99/JiBPh6Q+w1DjzheaUL9C7oFUuI7Jdq4Es5knsolXE/L
         85AsB0tPcZnFfw4InXsck5yaoUNsAMkFwmqEomXxkAkJYxuVghIk8Bc8ceGt/9rGj+Jn
         dSbO2Iv/BmGieQlkc648cxKBeYkpJYzxp5teJGi4s5ykScaRKwzpIwHoB4sFFysY8/2H
         UH6lSeXsHgFk2hNv8GFzqiFzsWhszXWzch5LDF6S7tlkEDMUglmVtcavXn5jJeWLK9Uk
         Hvq4ZL6s1yRadoUrP1baqHvyQZOBw9PQc79Y9/kSy/1Sk7QynNU/Ru1J+gKW3fJ19uT7
         ZiDw==
X-Gm-Message-State: AOAM531pMukv2n3HUsNcqxkAbPNXBVoRVj04320bIVUMjWdCG9XdYsr4
        Y2rT87ZCYl6YjlaeOpmZHJuuP+yH7dDlold5
X-Google-Smtp-Source: ABdhPJwnQhFfVjXNqxYdknp6HVSeEtpzToCtYLxblhWKARf7Lo+5QREP3rw3Uqde/sejp46RCkPB6A==
X-Received: by 2002:a17:90b:803:: with SMTP id bk3mr794625pjb.57.1599099660487;
        Wed, 02 Sep 2020 19:21:00 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:20:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] io_uring: allow SQPOLL with CAP_SYS_NICE privileges
Date:   Wed,  2 Sep 2020 20:20:47 -0600
Message-Id: <20200903022053.912968-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CAP_SYS_ADMIN is too restrictive for a lot of uses cases, allow
CAP_SYS_NICE based on the premise that such users are already allowed
to raise the priority of tasks.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4766cc54144d..e2e62dbc4b93 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7552,7 +7552,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 			goto err;
 
 		/*
-- 
2.28.0

