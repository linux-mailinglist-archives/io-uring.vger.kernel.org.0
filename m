Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88F27071A5
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjEQTMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjEQTMk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:12:40 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50183AAF
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:23 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3357ea1681fso559795ab.1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684350742; x=1686942742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVbbeVhOmjwSyjTSnsPUaCjEOb0Ai/UlhSkz6YZfab8=;
        b=s5joX0Tut/zCLIhBhuwyRgELx61plpyi9YqTtuKrhVmLl5aSgwwSeu6FpcNO9i19Ub
         NVUSgSojFM2CeDypaY7D5x1o/0N6BcHL8nKBSB3plMUylRPiRnWeBQoXoL7F1ls5TTeO
         svO3WbFcIv44UJRz7SSn8qQIGxsKajTwtw8+wio8x6BRSDhIfO3LqpYCqkWE+a+uBGvW
         /lNz2VrQwGlwH1ljO0lNxStoJr1sB3Yri/u7WWfZzyiGsevfidUTKe7KX2K96dZgjpMh
         c9ar/Oc+qdXx64rKLXYcDePh606zdk4oF1FSo1Ky1B7bN7RTq4+/2HfYafCHlxTDkyvv
         xWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350742; x=1686942742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVbbeVhOmjwSyjTSnsPUaCjEOb0Ai/UlhSkz6YZfab8=;
        b=ZB0bz5EwxcSiEJO0VN4Sp/aOtU0JhrdhziI5e1vx8LzzZ23iy3V+w8gGT2TxLy07SG
         yIQlS/MssCqsDBze7X1mUDJtRKKftrzJ3Y+DmnmKDF/T88NsYVR/Q3IB0ESPJ45E6gbr
         /A/MQ6ucuCIDV4KmjDARZe1XTGPlX7fgOFky50n6ycnvtA/+HoW6RsmOC6GyKfPfZxiI
         +gJtZEUhjTws/YU8hDebNM+XjOtOG7ZzSrkJZBh/JoBNSK8g0OqGzyNc+GOYxfF3AdGX
         6KJTZ6ppjbuUCKp38KcFxvxl9qwVo2bz/PpHoHCLzOxbVJUsrhKSz20hT1xLfguQ5vdl
         WY5Q==
X-Gm-Message-State: AC+VfDzvQtHaaVnmx4+JAvWWfbRoD83+grt8EvAvmVy/kFLPwdlQLjSF
        EvhTWPDc0qcbhyUGDvVBSj9R7aNtGFoUawu1FM4=
X-Google-Smtp-Source: ACHHUZ5gPFMgKDKedn1rJtBWG9n6L8d7xari5Ix/t0qoFyOJ/lxMVh8CK3iGO8MHApKP+3x/LBAOTw==
X-Received: by 2002:a92:c569:0:b0:32a:eacb:c5d4 with SMTP id b9-20020a92c569000000b0032aeacbc5d4mr2551611ilj.0.1684350742239;
        Wed, 17 May 2023 12:12:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b16-20020a92db10000000b0033827a77e24sm628996iln.50.2023.05.17.12.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:12:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/net: don't retry recvmsg() unnecessarily
Date:   Wed, 17 May 2023 13:12:03 -0600
Message-Id: <20230517191203.2077682-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230517191203.2077682-1-axboe@kernel.dk>
References: <20230517191203.2077682-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're doing multishot receives, then we always end up doing two trips
through sock_recvmsg(). For protocols that sanely set msghdr->msg_inq,
then we don't need to waste time picking a new buffer and attemtping a
new receive if there's nothing there.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9e0034771dbb..0795f3783013 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -635,7 +635,15 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		if (io_aux_cqe(req->ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
 			       req->cqe.user_data, *ret, cflags | IORING_CQE_F_MORE, true)) {
 			io_recv_prep_retry(req);
-			return false;
+			/* Known not-empty or unknown state, retry */
+			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
+			    msg->msg_inq == -1U)
+				return false;
+			if (issue_flags & IO_URING_F_MULTISHOT)
+				*ret = IOU_ISSUE_SKIP_COMPLETE;
+			else
+				*ret = -EAGAIN;
+			return true;
 		}
 		/* Otherwise stop multishot but use the current result. */
 	}
-- 
2.39.2

