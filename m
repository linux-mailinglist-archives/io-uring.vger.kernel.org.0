Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38259F910
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiHXMKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbiHXMK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:26 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B545F2A
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n7so14948372ejh.2
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=D/r0bwGS4j43HMvjNKZ5xY8Hl8R6rMXkcIwjNTHFPZs=;
        b=N8FdgVacw5y4q3O7zBRiLOFYnR3WPHc1qN+nYeQ9oPcwHiZAlNykkU68jhPY81fZdT
         a/YarC4GUBgOQeWftmx+xVlZZ8gcDcBF+VPxPA4uH7AiI0AM5oH4A4hYFYHJMpuoesPp
         ky+cGoZMRGR/Fj/DnLaGWfM1oNJ7jdECEnnw62c2kAigfyqvni5fGs/iT5qkshtbOsro
         s7oTRKZ2IJSCtsGpNV6J810Mo7PW/VEZ3bm2OFD4xnOlB/El8YxaoIuRTbu6Tjk8qk2H
         vLLchYcaZfR/ZcveDsV1+aKfSPYEI9uJ/E37YdvIjvIRF0Mo3EqpAMMfMmXEQHZHo3xU
         EnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=D/r0bwGS4j43HMvjNKZ5xY8Hl8R6rMXkcIwjNTHFPZs=;
        b=kY1X/d7GP9ilziBRYGvIF2+E1I5yCPRLQV2leC/5HThHXIhip5uevbaz1gaEQDiWg7
         eGGjGYU0dAh43WP8vpbI0YP1AEoef+m+LOHjhsq3ilucBqOCSXUkOICWCfL1AeF3TwTf
         tNe07EVTY6toFutfzjHvFGFl5ZempHJ1pN2tRKEulNpd9m5oTKsBL/FRlh2QAJNzy9ep
         nrAgJOMOse8TSf9AZwFygWgQ8dB8uwzgAIkdRzTlKBI0wV+9ikEXdiC0dQ6AeZC7xOtA
         z6xUTSkw5Zy0gOOIaO7HYDQfKL/O3mMrAgZKkNhMKN8vmxNg1hVw+q2becPviGw8Bo+e
         rweA==
X-Gm-Message-State: ACgBeo1ikIBq5VHDrw0Fr22+PzeQpKB8j2iV/IzaCXwL3+TtOwRzdI/k
        25FsgxETMxOXApOaeeOl2kKY1XYOrXW4Xw==
X-Google-Smtp-Source: AA6agR7cvIGW9228m/Q2vriyFjoqFD4uQnukd7a1zrareBLfwZhnXeihMNlYOdB3k3BW92Ieqd6w1g==
X-Received: by 2002:a17:907:3e1d:b0:73d:a9c9:819d with SMTP id hp29-20020a1709073e1d00b0073da9c9819dmr2759830ejc.170.1661343024004;
        Wed, 24 Aug 2022 05:10:24 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/6] io_uring/net: fix indention
Date:   Wed, 24 Aug 2022 13:07:40 +0100
Message-Id: <bd5754e3764215ccd7fb04cd636ea9167aaa275d.1661342812.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661342812.git.asml.silence@gmail.com>
References: <cover.1661342812.git.asml.silence@gmail.com>
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

Fix up indention before we get complaints from tooling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d6310c655a0f..3adcb09ae264 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -989,7 +989,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
 					(u64)(uintptr_t)zc->buf, zc->len);
 		if (unlikely(ret))
-				return ret;
+			return ret;
 	} else {
 		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
 					  &msg.msg_iter);
-- 
2.37.2

