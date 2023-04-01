Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE346D33A4
	for <lists+io-uring@lfdr.de>; Sat,  1 Apr 2023 21:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDATvo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 15:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDATvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 15:51:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6071026580
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 12:51:42 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v1so25587850wrv.1
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 12:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680378701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bI3pr0sf4QW0PzMxr51CCOrNmbtWq1+TF77A+52vbL4=;
        b=ORLlEiffdCwH9uFnhzEqPv4dJgywgzlmSSWUHvXB2ExyCGKYume1wmjAc1uXELgxlr
         H4ymrsTWQr0hYefG2OoSnEHeQA22MjvK8kEL7zPyKOifXWfp9MWFFWLxIj5MrtFjZdsa
         JJlhXKEMoiOm2n+UaWDzpWWr/+aSLi+0COBI8/lANO7WrnnAfacFLSEpzHGJ2eZlUoM8
         5+WIaW/RWBWDh8XVmjGjRYOO3YQAWToSWzCvSKHFXDMW2gbROHgTqxd63+cgiYfDU8j5
         4cq4P4B9T0pYO1wEksM3uL6qC3sWS819luT4zyNNrh8+636tp3PJnCeEkWsVMl2ZyUVe
         F4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680378701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bI3pr0sf4QW0PzMxr51CCOrNmbtWq1+TF77A+52vbL4=;
        b=onsUm9F/K4NDLULI8SAlCOCPdwyGkpLrwxVUDRwoIcdCfKuiVUuiCL1CVd2MMTrAx6
         UYHYHm6yPs2jHW3F8RBHfRi28dc5Cg1duJTFmqTJC73/yzfZDyFqR1q2+EwXIvOvw332
         6fTB2LTF5xeQzeekXvltdbcu+ytkMuGhT1pbuIYUXzEifYbyuwl5K4E6p+t/YAis7PsR
         Fu8Yt792poRrD6VL0E7TfK/wcZi+9QN6gnMTI70BpFkhHphviZGU/q/XpR+ydYfts62D
         hAaRdJ1qg1mgIY5CCw56kBGzzTwWxEOhJgRqYNtq3r4OYq0ydd1v5P1Nq26gH/CGWtWQ
         0RYA==
X-Gm-Message-State: AAQBX9fRpg9wdkXKueO8+zigiVogsbindtuMN0KddUx1k7maPCqInMRi
        bF0rlHQPa9t+kILh3BMsEio=
X-Google-Smtp-Source: AKy350ZXSLcyyZss61QnwVi5wU+tN+7D/tjG5rerz1FWWxlaid8HwOFC+NZ3R2l/loSbAsi7fz98Rw==
X-Received: by 2002:a5d:4fce:0:b0:2d0:354e:dc77 with SMTP id h14-20020a5d4fce000000b002d0354edc77mr21938857wrw.66.1680378700763;
        Sat, 01 Apr 2023 12:51:40 -0700 (PDT)
Received: from localhost.localdomain ([152.37.82.41])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d5506000000b002e463bd49e3sm5561009wrv.66.2023.04.01.12.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:51:40 -0700 (PDT)
From:   Wojciech Lukowicz <wlukowicz01@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Wojciech Lukowicz <wlukowicz01@gmail.com>
Subject: [PATCH 1/2] io_uring: fix return value when removing provided buffers
Date:   Sat,  1 Apr 2023 20:50:38 +0100
Message-Id: <20230401195039.404909-2-wlukowicz01@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230401195039.404909-1-wlukowicz01@gmail.com>
References: <20230401195039.404909-1-wlukowicz01@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When a request to remove buffers is submitted, and the given number to be
removed is larger than available in the specified buffer group, the
resulting CQE result will be the number of removed buffers + 1, which is
1 more than it should be.

Previously, the head was part of the list and it got removed after the
loop, so the increment was needed. Now, the head is not an element of
the list, so the increment shouldn't be there anymore.

Fixes: dbc7d452e7cf ("io_uring: manage provided buffers strictly ordered")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
---
 io_uring/kbuf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3002dc827195..0fdcc0adbdbc 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -228,7 +228,6 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		return i;
 	}
 
-	/* the head kbuf is the list itself */
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
@@ -238,7 +237,6 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			return i;
 		cond_resched();
 	}
-	i++;
 
 	return i;
 }
-- 
2.30.2

