Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B53A62E47E
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiKQSk5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiKQSk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:40:56 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAE68517D
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:56 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id 21so3876599edv.3
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IagVhcJKWNzYWTs+WNTUmU/RW/4LaiwYEYL1CF+wA8=;
        b=hqdXBs06YYotLjZOhSdF7brPnr08gZB6Rej1b+Rmu/gQ4z2wRsJUNhVk2ISp0+LjhG
         ss6f0J4Fc1xiGgE+Ng8iKXhSGnS+pGz5muXqnPj1YLJPmPKeGayddgsiMd5YAY585ZSp
         32HxX4nBKSTs83PqqPAgSrtoihJiUj+qbjUUxizRcAxudZMf4hKV6zhYsf4Leo2vpCoB
         jtXnIvi39uB6PX7GICI8QbBa+xf9lpRmNDKALjTIlUJJgZU22OablElyin/EHaxP4+x/
         rqN1hDJRZjwKQdYa+3c8WK7HrHfj61JirPtxsPyh6vLRWIK44E53pmWpGupQeY5HoKzK
         Lb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IagVhcJKWNzYWTs+WNTUmU/RW/4LaiwYEYL1CF+wA8=;
        b=s+1bxqBlzQtMpxB4kQl6KHHt8ue/+OtFZkiELGiVatiLfydeFyBauYLxk6xbqA/KKH
         LHDJkMErzudliliiTPulIIxvii/vqVK4YKyWxZI/hi+2p9uKRQMpZ+rMtnB35CG7nc8s
         qnOOrod+XEAKhlK1356gtFE2he1O73vgAyfKrvGA3Peqh47wvBIWJmwdQQ6iK4GqSpMQ
         Ip3ZCC45IBq/zuq9LPJxv7gSgdFq1aF8mxJjjaGd/mFa4Sc2P3aSOOt3Vqc3lpBbS3Pi
         Ao4ffErxxIlDWLnhoNPjTRKk/H9ZsyCx61HOMLpXO1BgV/GezueXW76USkU/Nw9GCbuk
         9TNw==
X-Gm-Message-State: ANoB5pkPRUdmSjyCXbrFbYT5UEY7Qh937n4+O5uSG7PXT080y/q3plbP
        qOO3i9mjLDZZWpy4sQ03KD32RdNC/o0=
X-Google-Smtp-Source: AA0mqf4wl1w0fcoFfBj2yJgiJAmmCdjnPQZOS5rYEgU6yo0pY7ZN4Bl4QyqZ4nPdJMICowEe9x+uIg==
X-Received: by 2002:a05:6402:43cd:b0:467:c68b:b06c with SMTP id p13-20020a05640243cd00b00467c68bb06cmr3168282edc.428.1668710454346;
        Thu, 17 Nov 2022 10:40:54 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b007838e332d78sm685486ejc.128.2022.11.17.10.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:40:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 1/4] io_uring: update res mask in io_poll_check_events
Date:   Thu, 17 Nov 2022 18:40:14 +0000
Message-Id: <2dac97e8f691231049cb259c4ae57e79e40b537c.1668710222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668710222.git.asml.silence@gmail.com>
References: <cover.1668710222.git.asml.silence@gmail.com>
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

When io_poll_check_events() collides with someone attempting to queue a
task work, it'll spin for one more time. However, it'll continue to use
the mask from the first iteration instead of updating it. For example,
if the first wake up was a EPOLLIN and the second EPOLLOUT, the
userspace will not get EPOLLOUT in time.

Clear the mask for all subsequent iterations to force vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index f500506984ec..90920abf91ff 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -258,6 +258,9 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return ret;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->cqe.res = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
-- 
2.38.1

