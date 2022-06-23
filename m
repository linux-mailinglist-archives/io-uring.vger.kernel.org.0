Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6485576B4
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiFWJfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiFWJfM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:12 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F2349269
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s1so27065767wra.9
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K1E1JLCe4USh2kriw3egu2gKlFBp9BC0Bq/laD0bxNE=;
        b=WVAHGOzjjHvrRALc+qALDe2+cIWqAUbrJBbaT/cNn69W+IXMEb/TJEweuqYiOUhZ9N
         e2f9aOsM4gmP23SVr96jHF1/qwBOagKAGQowpBvBQ7hAYOPRfcmnurs7XLY5dyPYManF
         ecA5wco/uOaXq/CfvXgYvczPLyjiKmsyjyQ/vaXzMGBa5mRCH4w05FGTiqPNAq5m9EA8
         Bzpenz9hzYmmXS53GDmsvnaEo6Zh/e/jGxDYt9aJOUJcv1oNcy5V/W6AfpqGcb247CT9
         uqYPkK+AlObyI/K0oOAS5qbRm/kSHFNVc5MAmdsUMrlKsI4m6uuS4hRnPm9lr2IDF+Yg
         gJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K1E1JLCe4USh2kriw3egu2gKlFBp9BC0Bq/laD0bxNE=;
        b=73q2L1QtBYAD15H3WKIb9cCK652b4lZ5IGhMAR+GS1aIW4FKxASvq57rRwpdNNDSB9
         6ELynoIA1qBXQ/1cW5mHfxXr1NuhAZy1RXmoSj81AYJxLSydH/dSx41tOxHu1VItbgdY
         lb0wt6uih2g78fV+GhJ4BMD7KbH4uM9pjrMY57cE/yKNWzAkVe8oWgjdCImPYhzGQMc+
         SaU/Z8HAD73MIx7vIIQ1ynEcDIAYsbxGNadgS0vCyan9F8LX2t7m/93JxpYSycG4R+XQ
         7VXeJNRDjKAMI4y70/HeUZb6plMGWsVZRoPbvvc/5fjNrnW3LCSy4m515gYPK1g2KMyp
         8owg==
X-Gm-Message-State: AJIora9+MZtaRIGr6tbJH4MlEh9juVRl+RPAvNk5LprtroZsHE5dBC6m
        pIIY9ZsearjHBwUj4eMau/FytDrN7DtHAPl4
X-Google-Smtp-Source: AGRyM1s7Nbr6t5dPeVf3PnRpyMbAOoO0XYfwFxTM/6ieDzhW1gkOvr/UMBKBx9zsqXSyz1G6E8tDkQ==
X-Received: by 2002:a5d:45c1:0:b0:21b:883e:6116 with SMTP id b1-20020a5d45c1000000b0021b883e6116mr7121967wrs.346.1655976908310;
        Thu, 23 Jun 2022 02:35:08 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/6] io_uring: change arm poll return values
Date:   Thu, 23 Jun 2022 10:34:33 +0100
Message-Id: <529e29e9f97f2e6e383ccd44234d8b576a83a921.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655976119.git.asml.silence@gmail.com>
References: <cover.1655976119.git.asml.silence@gmail.com>
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

The rules for __io_arm_poll_handler()'s result parsing are complicated,
as the first step don't pass return a mask but pass back a positive
return code and fill ipt->result_mask.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aef77f2a8a9a..80113b036c88 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -34,6 +34,8 @@ struct io_poll_table {
 	struct io_kiocb *req;
 	int nr_entries;
 	int error;
+	/* output value, set only if arm poll returns >0 */
+	__poll_t result_mask;
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
@@ -462,8 +464,9 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
 		io_poll_remove_entries(req);
+		ipt->result_mask = mask;
 		/* no one else has access to the req, forget about the ref */
-		return mask;
+		return 1;
 	}
 
 	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
@@ -813,7 +816,7 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events);
 	if (ret) {
-		io_req_set_res(req, ret, 0);
+		io_req_set_res(req, ipt.result_mask, 0);
 		return IOU_OK;
 	}
 	if (ipt.error) {
-- 
2.36.1

