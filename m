Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F82A54B123
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbiFNMe1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiFNMd5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77874B878
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w17so3574055wrg.7
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBEXlpK/N89FNLVTHLSAOv6cYdu1Mi+Y2oi1hv0ROqg=;
        b=nRRw0B7Cyd5L/fKnw9F0cKxZ/WoyexHat7DHrAI6N0/te61smXxwFCxSXKXSDwPpFF
         e3pf6PyynpdiGzFqMJxBDgbVo4eZ63rjZrfcmVc+mm3nK6GNtZcdks+6AIqHxEE+jT6H
         2M/NzUrnB3mniNcscN0iSlOSpzfOfB0HMnNxfrmBH9uuRLsb5AH1N6Wxabh2oT3Kex1D
         LN4qo3sk7Y7oRaBX7FlEwmHO7B5epLxTHxCvk6acL44ohk8r6skLzxs1wEegkN8eI2/c
         dc7mYyfpWArfpiSQN19Bdm16DbCyNVA4v72OXFVtKgogKTkiEns6YfvN+dH4DbabZnSq
         y/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBEXlpK/N89FNLVTHLSAOv6cYdu1Mi+Y2oi1hv0ROqg=;
        b=mYOUqsrY50k33MYb77/9NN2ijAC2S5hK2sSJJjFtEtA8oAujqplBGZvtCipWedNg7h
         imfIxGtmDQPO0Jr1ZozCNJflgm959JT1FDcx4dtV+g8D0+BHiTBy9JQqUiYzZYHInsm+
         NN9rySaNnpRNisf4bR9Lownonj7J/AiSd3+YgXNmiATZH1Q+/fubio6z3QztU3cK0WKt
         B3an1mf+RsDWamJMO98xZFY7NRLh0rbB8+G7+4f/JFUMYrImV3e0EDTACV8gpPUxvjr0
         R9t2tSXa5XIZtMZcXBh6IZ2q8YIIqnXK5q3LgKarTkA94jqWiQRKnjoAYcIKIVqv11h8
         U6ag==
X-Gm-Message-State: AJIora+lypJJcleXAuNHP3y0ztbzlbK6FJxN696+b0ym+ZPzxgshIVWs
        8IOpyjv7xI9ucaquxAQLOnkrfsmd/K432A==
X-Google-Smtp-Source: AGRyM1uiayyA0tNM5tj8npnH1vzMUY/05KvdjUYVZzsJ+n4rGceMVASPR0bvXRe9eeUSSy3a7preZw==
X-Received: by 2002:a5d:64c4:0:b0:219:b73f:48a7 with SMTP id f4-20020a5d64c4000000b00219b73f48a7mr4677687wri.180.1655209852752;
        Tue, 14 Jun 2022 05:30:52 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Hao Xu <howeyxu@tencent.com>
Subject: [PATCH for-next 14/25] io_uring: poll: remove unnecessary req->ref set
Date:   Tue, 14 Jun 2022 13:29:52 +0100
Message-Id: <2cb6a90af34475a9ae2c2d1aca55a9edb3d3975e.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

We now don't need to set req->refcount for poll requests since the
reworked poll code ensures no request release race.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b46973140ffd..be3dd77fa21c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -683,7 +683,6 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
 		return -EINVAL;
 
-	io_req_set_refcount(req);
 	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
-- 
2.36.1

