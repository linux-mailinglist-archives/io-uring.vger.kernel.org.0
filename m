Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355944FF9CB
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 17:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbiDMPNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Apr 2022 11:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiDMPNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Apr 2022 11:13:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F018737BE4
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 08:11:12 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id s18so4694272ejr.0
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 08:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/7F52Zie4S+XL437jWaBIHHDGqVkmygaRbGckC+C7+Q=;
        b=eXUbvsqt93EZXZeQEiCcirur4tbSmyuJ1zLi9IHyMR8cuNvpPZKo4C6Jsg0SFEM1QO
         EzLy9gKSSv0b+w7uvijNEEZUieQvuoXIZ2dhZ6EGKi0pR2DRBdIUgO11RfP81ir2Z0V8
         xE3TgPN6pCbbRLC/KVBID6va1j6sggVs7zMWzrXMJ4rkuzYXIRvugggAgWTZyJQoAEMs
         ChU2GVJsZtncgRm2wvShck3nUZ9yGPLqHFRBcEMqzxREl1BMB47sSaxn+3ksAz9ZkI1B
         /jX6xI6VPBzEtADNM2XUNKC/chtjGHSelN4hHtJRgtE10iHh/ClDZD1O9K2yIymcqAX/
         zE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7F52Zie4S+XL437jWaBIHHDGqVkmygaRbGckC+C7+Q=;
        b=aFG/NRGUmF001NsREPdGybF4BiMd2AcN2Ge1msZhyWseB9SnRONy3IulTkLhW5JGMV
         ITbeqcRuYA1uLzxtiZBwD/QRNoXANT3jvcZwuLprQzVnyqcimR6nUn3Fd7OvB8vogKp8
         HSscoVFqO6HXJn1xw5K86XEHSQmPXuOYsyJSsye0UxUPuLOyLtYDtWUuhaKlkCr9gJkU
         wUdkxYQPmoY3BzP70mF+LfoDfYGrHPPzrGEwMfjdLS6YC6WywtOHfx51Bal1Jv+FOUf5
         g3Q5YNMempYGBdKKOJdw7IRhMa2JVJ0k+7lrAJZZLKeuDNQI1Eyf0G4jFAfN/C3vaxfY
         HPSw==
X-Gm-Message-State: AOAM531ZLICgQaglE/H1FYyr/v64yw2kQW1EA8pWqC29Ul2kq8X9T6rf
        VjajLpbzHDK+j+dAeY/T5pjOM53HiVM=
X-Google-Smtp-Source: ABdhPJxdyfHZBW5xZ1mIlmr+3O0A0GpTifaqKstxarY0trJSZqY9+aJdl3KsutcwmN9SsJ2YGUTxuQ==
X-Received: by 2002:a17:907:86ab:b0:6e8:d60e:d6c3 with SMTP id qa43-20020a17090786ab00b006e8d60ed6c3mr1165124ejc.346.1649862671334;
        Wed, 13 Apr 2022 08:11:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id j2-20020a056402238200b0041f351a8b83sm1037152eda.43.2022.04.13.08.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:11:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: fix poll file assign deadlock
Date:   Wed, 13 Apr 2022 16:10:34 +0100
Message-Id: <2476d4ae46554324b599ee4055447b105f20a75a.1649862516.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649862516.git.asml.silence@gmail.com>
References: <cover.1649862516.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We pass "unlocked" into io_assign_file() in io_poll_check_events(),
which can lead to double locking.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d6cbf77c89d..d06f1952fdfa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5858,8 +5858,9 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
+			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
 
-			if (unlikely(!io_assign_file(req, IO_URING_F_UNLOCKED)))
+			if (unlikely(!io_assign_file(req, flags)))
 				req->result = -EBADF;
 			else
 				req->result = vfs_poll(req->file, &pt) & req->apoll_events;
-- 
2.35.1

