Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196F654B3A8
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiFNOhp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiFNOho (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:44 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972A811443
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o16so11586834wra.4
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ToujjDMrgxjXImVoVU6hciJcYYHsx0thIW3gWEU5SEA=;
        b=HE3wDBPv0/eb+nDpl+5ucOakSdPeonehkWrbXi0ZxX0nK2AYMnOtB8El2y+P3Mnimp
         Rbbx1cXwqsyAtFN+hCBqka5TsoRi/B3OV9RmZRwRJsib46r5gb5zMO0dUhicnqMQoMZ7
         99N1+wwT1IW4lQG1JR6LSHN6xE/zLrT+oheZiDNsQQm9FJVlWSmqj5yxlVY5wJQyvdn7
         6mRk9DEcPLeTfhKFB3eDtJRZQNlOFmWDpOH4ibpUF+o+QRbM4wNHJypUTlF+2jjpKiVM
         dCWqqIP1qoSHfyCd/7KxYCecztCXwofIXlGIXeBhBnbFM9cW8UJi+GS48NqicbpLX4IT
         1isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ToujjDMrgxjXImVoVU6hciJcYYHsx0thIW3gWEU5SEA=;
        b=5xaBCf4g3fehVVcmWaA28IBeA3krAZK82ekTyr4X8pPbm7/ftpF0DwKgtsKxzfJy7c
         viR+UwaRfoE6bn01re4Jw3ysWy6LhizUz1GvgVrD6WuoxJzorzX59CuyJzNlaVteXnkb
         3eJUlAJSDzX1+mePKA9aiv/UVbL3kMauEym8aEEv/DDD/EDOFC008z1BfetEvevGxrGA
         6UHoVEKA7xT7xdYEWoCCr9Y+29RUvfM8JZQ7N8NsAz8+9BLThoOhmMxHHtAqKgU0c8cg
         OKPFJ9SaYGtD1oSJ4a1YnEIw7CrH6RCsp8hUAFNPmJzE4RuoDdtuND7XoX7Gnjxic3+/
         arIQ==
X-Gm-Message-State: AJIora8UNUg8JPqYP3KreMZzzxXH/9tB8PppuH5jlh4g2epaLgKvwqCZ
        r+TDv9QQLRySf0Eg1bvsKTzOQ/apsuGPjw==
X-Google-Smtp-Source: AGRyM1vwI+6ddkJNb98+NqsWs0EuB06M3u4vhEeSxMtMjBo2qHIvUib5s1i5iqH9w2rqvh2g3P5mFQ==
X-Received: by 2002:a05:6000:1812:b0:210:2eb1:4606 with SMTP id m18-20020a056000181200b002102eb14606mr5409646wrh.593.1655217460710;
        Tue, 14 Jun 2022 07:37:40 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 02/25] io_uring: move defer_list to slow data
Date:   Tue, 14 Jun 2022 15:36:52 +0100
Message-Id: <097c9f3eb3f8ab052e10160567928ec8df0f1303.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

draining is slow path, move defer_list to the end where slow data lives
inside the context.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring_types.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 7c22cf35a7e2..52e91c3df8d5 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -160,7 +160,6 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		struct list_head	defer_list;
 
 		/*
 		 * Fixed resources fast path, should be accessed only under
@@ -272,8 +271,12 @@ struct io_ring_ctx {
 		struct work_struct		exit_work;
 		struct list_head		tctx_list;
 		struct completion		ref_comp;
+
+		/* io-wq management, e.g. thread count */
 		u32				iowq_limits[2];
 		bool				iowq_limits_set;
+
+		struct list_head		defer_list;
 	};
 };
 
-- 
2.36.1

