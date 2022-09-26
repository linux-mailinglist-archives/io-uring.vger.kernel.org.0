Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E645EB5F3
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIZXqE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 19:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiIZXqD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 19:46:03 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00D18A1FB
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:46:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c11so12466152wrp.11
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yeTVKqHS44D0sYF8vHhQLsW0veSVF9jujNYiKozf49E=;
        b=nKxEZ2zVV9wpyGPciSAddIOdShVzxIeV1w0WQ9HVHY2yefVmSJcwl1gx1/8yD+JihW
         6ZI9x6YLaxfZRSyauC7JXB4P594f3NQ1NnKaxz4w0jOCjP7U9o7OSOOtm5Kdl7z63w/f
         mm/SjNc4qOe4QHPDJ36ANX3zs8EVIKRunEpUumqZtB1Y/8mTWy6HXMlGJb5cneBWi8Ny
         qeRmhKg5JOR7Oj0qQ6i71dYZnlr1U3dEHsJIOi/13RbRbtXb+UxjcVJMy2jqQAJqPIxv
         WWxrVZhqj0+NnviSZZviiC61qSvgd88TEsD7jfL5Ej9SjPBLeGEu4y3TR0zdDaqT0T5j
         UnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yeTVKqHS44D0sYF8vHhQLsW0veSVF9jujNYiKozf49E=;
        b=EmnMe26U7eRY78QucYHNLFVMqJvKFdRuJCnp9kXj7El7/mfHJUUoeqWYbdkpazGpHU
         X5GAd/Re8DyqGO6jNPOJORTK/hdkdJmAi5ITfiZqOXZUslMc+gYOk97Z98fo3D/RdI0g
         OVhlv7MjdkYjOUHblUO2Tm2I3ydQ2Xaj8aJcpDGVodRVvmgX6D4tnyDC3Qbi0z7CpFQr
         iqUnMfKWEA2QWLEuLmvgQ+2xi9KFXMjNr98UHJGdm+XD/c7874M+A6/6jnLiSfINqmFD
         V2zRG/azB3D50lVVrKceCjS41zEPsHY8Ow0005hyVPQ5//vt+HPSTXEd88iReUlwkVpX
         ZDyw==
X-Gm-Message-State: ACrzQf0PzBsqxrmKTBNHRpCbgGP5IsMKcCeg82+YIaz1oDcnoYCyZOcC
        4hMGliyTHnge4imr2xc+XRd+UMCd82I=
X-Google-Smtp-Source: AMsMyM7+p5WimJbflwdGsKdLNGJQXk2SD8CkQkDmlX0eTAhPgmcqIvOG+kklHgikpA5chHwuJFPv7Q==
X-Received: by 2002:adf:b646:0:b0:221:76eb:b3ba with SMTP id i6-20020adfb646000000b0022176ebb3bamr14665544wre.237.1664235960065;
        Mon, 26 Sep 2022 16:46:00 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600012d000b0022abd7d57b1sm89318wrx.115.2022.09.26.16.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:45:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 2/2] io_uring/rw: don't lose short results on io_setup_async_rw()
Date:   Tue, 27 Sep 2022 00:44:40 +0100
Message-Id: <0e8d20cebe5fc9c96ed268463c394237daabc384.1664235732.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664235732.git.asml.silence@gmail.com>
References: <cover.1664235732.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a retry io_setup_async_rw() fails we lose result from the first
io_iter_do_read(), which is a problem mostly for streams/sockets.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index ed14322aadb9..1ae1e52ab4cb 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -764,10 +764,12 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	iov_iter_restore(&s->iter, &s->iter_state);
 
 	ret2 = io_setup_async_rw(req, iovec, s, true);
-	if (ret2)
-		return ret2;
-
 	iovec = NULL;
+	if (ret2) {
+		ret = ret > 0 ? ret : ret2;
+		goto done;
+	}
+
 	io = req->async_data;
 	s = &io->s;
 	/*
-- 
2.37.2

