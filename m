Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E4C63D951
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiK3PX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiK3PX1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:27 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F401174CE2
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:25 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m14so3677657wrh.7
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxlMuKJgc1CFXoxEQrn/owGBJpxjUhSInGIm+vaV3uE=;
        b=qLFLxYzU3LQN9aT+VsDRHK9Usjn2o+ph7eVFCEn8ZVr3jmFTgCN67hC2kLHzLbzq1F
         2iE50D/i+g4BiNYXNzCksutObbZa/aXGWALvDIHWEoVbjLLYkBYHMy5+FjDEfOwj++R/
         VTXJHtuyYX2yNxOlVLzwR1gpvZ+OBXjOqIORE/zWi5PJUUUTy3WmEsOWZ44CS7B8dmPB
         1eQeWQczNxuPAffywSihs1ozrLQZoGvWC1w4Fhl81uQhylH3DPOpOXiIYgZFr5p/lIab
         WDx2JWEIWzcUPBJDa0kfAnS6ks5PeRM6oOEGGy7XqN1jvYeQYnAK5r0pIrZNnPsbfIBT
         7XVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XxlMuKJgc1CFXoxEQrn/owGBJpxjUhSInGIm+vaV3uE=;
        b=kegYShVM1Y27a6i9363GUIMnltffwMEY2zibKJGiqvb/aAFVjO4C7xJOJV+A6iY8AE
         dcVrYMAigAXYd9NTRij5KEIkP49cV764ljUi1NJMI1h6UBcg5cSum9W3tX85AoUc7mzP
         qm9AUTAl+Ivelavj6iP1N+v57jxgc3K5qgIDKAdWsSyHPW4CFjCo2ubdGisxjYWaJmgy
         DvXsb4STJBeQVMlmqmXvVZyu9WV1KZuyK1M8mX42r2qpClJoRabDlF0oj1O0cJ/Ajahg
         5MzRb+7iLsEcL+5IjFoTc9xrgW0o/zKy5I6NiAQ7nRutGOYsbfmkjQzG+HDkRkwyti62
         /ZmQ==
X-Gm-Message-State: ANoB5pkg+udlVxLugU5vHASCaZ47Oqq/aAQ/AxsVfBalYmANQKHphkS6
        ddyogUZQMpvb3qgWlpxXJD23jrRO+3w=
X-Google-Smtp-Source: AA0mqf6k1SuSy3RFj2kIjtLA/33LaSgj1vTi/71nMVGNoj+f8+UP9aTRnChaNphqrrGfC6+hutWaXA==
X-Received: by 2002:a05:6000:3c3:b0:242:378:38d1 with SMTP id b3-20020a05600003c300b00242037838d1mr17910779wrg.352.1669821804348;
        Wed, 30 Nov 2022 07:23:24 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/9] io_uring: imporve poll warning handling
Date:   Wed, 30 Nov 2022 15:21:54 +0000
Message-Id: <31edf9f96f05d03ab62c114508a231a2dce434cb.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
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

Don't try to complete requests if their refs are broken and we've got
a warning, it's much better to drop them and potentially leaking than
double freeing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index ada0017e3d88..8f16d2a48ff8 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -249,7 +249,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		if (unlikely(v != 1)) {
 			/* tw should be the owner and so have some refs */
 			if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
-				return IOU_POLL_DONE;
+				return IOU_POLL_NO_ACTION;
 			if (v & IO_POLL_CANCEL_FLAG)
 				return -ECANCELED;
 			/*
-- 
2.38.1

