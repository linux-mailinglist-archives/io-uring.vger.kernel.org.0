Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8DF6E318E
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 15:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjDONWL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 09:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjDONWL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 09:22:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F5D10D
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 06:22:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so9388834wmq.5
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 06:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681564928; x=1684156928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tOAH0/yohS+qoWJmwURrbZQRh+ER0W46vLM+F+eZxG8=;
        b=QAvAkcnEjFpyadLQlK9tLTWEFj2Id2onJd8wbe1I16Xa+7iPvcp2+1LT9fXnhMkRdl
         NCZRn9HhGIQMIal3yTfEiDGjd+Aq0BLapGZfyxXrTQFf54cTwJJ+a++h0Z3TL//QvgFT
         WrKc8fW46NuF1ui8FSyC5FoCwbmmEKP8fTfIohpz2ecR8rznbRp7h7KtualOuKwfrxuX
         VtsEQIFW9gVs6ek3MpHX++jpJkiwlaG3SAqihqUtfRS9lWp2t2i7NU6I/OU7C9GpZFCu
         7GsNcsLwLPoOhU2s5P5Wdt/oENd73LgIW7dJpMR+sTmNZRFFcrvhB0tfzQL2CUBSHHOi
         kgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681564928; x=1684156928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOAH0/yohS+qoWJmwURrbZQRh+ER0W46vLM+F+eZxG8=;
        b=VQGBh8ayYylnIBv30fGMyY15GC8Oqcjc35zUPk3Eiqk5ax/lbEDLKo8kJJ5JOxsqJd
         99vhPzjhOisCja2bTizRU2VOxmj/Am4dSkHQYEMAr+aWAIk9GUev6SPmT2qDfe2UtfMy
         pbV3TCS2pekw566njrCbH3t/qbs8qhP0y65IQiORgyHwcFaTyuQpvozTBo/5f9FMhFTr
         XeM3X6VEHTzzruCVrWdUAM126LS1KRMUwbpezREzUiz8PkbeKYH1b4mQh8Z1AP3+oaqL
         suFfzrMwwgNc4jTcYGru+vmnh2AuxNXp9u0jklaviHzs76w/6joBl1Fvo5pgpCz1Nvvh
         PQHA==
X-Gm-Message-State: AAQBX9fywQBz30RwWcjd6ZeNnFE1vhcKAJ82qqqD4Bcc+EZRsdCyP4ql
        x7DDYP5kY9WgSHzemDtDeknknaCS2y0=
X-Google-Smtp-Source: AKy350bxerO5qKEZow3Cjt64M9bqu019FhH0gWCu+mggMQdr3+Hn4GuvB4Q5gmE+ApwPUXy9QyawMQ==
X-Received: by 2002:a05:600c:201:b0:3ef:76dc:4b80 with SMTP id 1-20020a05600c020100b003ef76dc4b80mr7074540wmi.9.1681564927839;
        Sat, 15 Apr 2023 06:22:07 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.98.134.threembb.co.uk. [188.28.98.134])
        by smtp.gmail.com with ESMTPSA id 14-20020a05600c020e00b003eb596cbc54sm6739755wmi.0.2023.04.15.06.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 06:22:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring/notif: add constant for ubuf_info flags
Date:   Sat, 15 Apr 2023 14:20:08 +0100
Message-Id: <2906468a8216414414e8e5c06dc06b474dff517a.1681563798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

Add a constant IO_NOTIF_UBUF_FLAGS for struct ubuf_info flags that
notifications use. That should minimise merge conflicts for planned
changes touching both io_uring and net at the same time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 2 +-
 io_uring/notif.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index e1846a25dde1..d3e703c37aba 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -79,7 +79,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->io_task_work.func = io_req_task_complete;
 
 	nd = io_notif_to_data(notif);
-	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	nd->uarg.flags = IO_NOTIF_UBUF_FLAGS;
 	nd->uarg.callback = io_tx_ubuf_callback;
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 6dd1b30a468f..86d32bd9f856 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -7,6 +7,7 @@
 
 #include "rsrc.h"
 
+#define IO_NOTIF_UBUF_FLAGS	(SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN)
 #define IO_NOTIF_SPLICE_BATCH	32
 
 struct io_notif_data {
-- 
2.40.0

