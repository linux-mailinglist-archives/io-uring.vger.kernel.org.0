Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF56635BDE
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiKWLfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiKWLfG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:06 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C511DA29
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:05 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso2805451wmb.0
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ltvh2Gi7o+LSCX0EJRNMZ1KcgcZ4TbP6TUTFtEMBCLE=;
        b=A6eoK7csYMx/DqzAwvDZaPBM5FYD2k2oeQYUxcc21bAWYITAOlQbB27u8XiEXxWXtR
         OO8GSeBIBzSisvfozV9LEnxzbqKvS+aS/mGe5OTM1bn3Z6UrgjPiwJN6fIr3taLnMFEI
         cG2sXC+Js5ILd3AK5sOHuLyUQv9ycENNl44l9otDiZCqLnl0cKimmmllb7cLsO2JnkHW
         k3cRV3qokKi3KxvNCKLKyCy0mwD14+6vhw5/d9GZMvcJopPQ7vB2i4IZjcMerFaQOKgG
         U+qcZLSY+JIsBYhAm4002kWaylkdsUzmOlR1sm1ySUMo9AVOhwkNzHjMYWXqrdIHgNUA
         FQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltvh2Gi7o+LSCX0EJRNMZ1KcgcZ4TbP6TUTFtEMBCLE=;
        b=N1I4WdJusSUMw/tbVnncwp2rYocjOu+v9UMIS1Ql7bi1xq3ZyyHf3uQDjPeHbVbciq
         K0ztBoy/TaerbKanywWh5rpbxtwHKcfYGyLXm97q1NcZrYr7xEXlO8v5vkFrarhcfE8G
         zMMCjnufMnrBYHtJaFA1XmGJaP5NHnkSHT8dUVKXiulP8Kt07mPEnHKkgJb8XWVMvOGx
         SiMpfh5OI4MFyVOe3Sb+By1ahNT8B6pBUTR6e4za69X46AhL/hg7sOxMvZfh0zv9J0Ce
         8gazwOGGe9zRI7j8GjO+o5m7jwPrlPURktXSRWEOOUD7C9l1ycUT1gQEWohjmNIBild7
         Fleg==
X-Gm-Message-State: ANoB5pnDqdXUIVZ/U2DhWbELugWMe9HYnZ8R592+eFbxucKj2xX+x6P+
        MP8gm8JBgORtUIo4aHfsvzTHmeZr+qs=
X-Google-Smtp-Source: AA0mqf7FOgOuwZqamGIC9oQo9LMbnP/Rr7Gg2UR/f8uHbn0fevP01VdJkzLw0/2mxCnCH3+eNHmXYQ==
X-Received: by 2002:a05:600c:3514:b0:3cf:a985:7692 with SMTP id h20-20020a05600c351400b003cfa9857692mr13238933wmq.104.1669203303657;
        Wed, 23 Nov 2022 03:35:03 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/7] io_uring: use io_req_task_complete() in timeout
Date:   Wed, 23 Nov 2022 11:33:38 +0000
Message-Id: <bda1710b58c07bf06107421c2a65c529ea9cdcac.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
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

Use a more generic io_req_task_complete() in timeout completion
task_work instead of io_req_complete_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e8a8c2099480..a819818df7b3 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -282,11 +282,11 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 			ret = io_try_cancel(req->task->io_uring, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_complete_post(req);
+		io_req_task_complete(req, locked);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_complete_post(req);
+		io_req_task_complete(req, locked);
 	}
 }
 
-- 
2.38.1

