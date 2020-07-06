Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AEA215939
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgGFOQK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729201AbgGFOQK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:16:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB81C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:16:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so41085074wrw.12
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kdZSl9K8MVVajtvjSWxTm+p7YgzxpNHKuBHS9gWIfb0=;
        b=qyDYyBHAsCmiq3UXOnAcpjGwEHFcAvYIB/gApVO2lMgr+rnv8kJHG3TYxMrmHWPYnb
         vupKzo8IRklLP+dywjtzC7Jp4uB4GqwXdzanfOVBjjspY8PYkcygT3KkBjZo4BaZQJT2
         1p3S+gdhyoQ5qVbQByM340BkTnIV3qKJNmhNlBHPR7A921HZ/i1kXxCjEttSB2JETWQd
         RMmSZqzsfu0y3qrGu7mbz+qNiYZr/doF30N2BokOrrBuSIEWarmT5N3Bc9MLgFX8qBD8
         sxrjsr8JO1/bEU2nvG82htBp8Dh+eFBG7BARCeQiCTRpP6j3WKnc45BYfSNn92NwI5To
         qaag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kdZSl9K8MVVajtvjSWxTm+p7YgzxpNHKuBHS9gWIfb0=;
        b=Xk3CUdeikHFzQJeZ/KlTIGwcnJURJx643lQEC1oM6RemtpevXVzeviWpiNQ7jBmdrw
         bzxqjXzj6Nh5++dibwxOM+BN7NsVC1cj7wS3aLE+o+dJXoUtnBlTZ/e72VAO+yCBGQk6
         gCuSpwMXJk9IlWRRKKGqGdJRnTV3O79eLmhd/jRluhLb2zKkgYR/cweJ1yR7aR5tVlKa
         urmdFsaL9KQ6VOID/IjdLqWHLMaHJdsuuAIor9mZuIVd6e1mAdKrSaEXwN6RakTYXhWV
         UOT60aQGRf/67NTzFI6arcG7GoYXPwMfH6q6GPYaAjPO+dgGlUTnjVkiXqVK6PI3QFvS
         jHVw==
X-Gm-Message-State: AOAM532ZGjWV0+met4cIHanMGd9M7t00k98SD00pNWYfSB2jIRa+G5Zj
        eiwFh2tQS1hcgrNZemU3GYo=
X-Google-Smtp-Source: ABdhPJw3ufObSXITay/BKQzFuhWpAvg6b0Gvj42r4LwFqdx+bPSLeceSgJc4uxO/REj0cUxmapUfJA==
X-Received: by 2002:adf:de12:: with SMTP id b18mr52676039wrm.390.1594044969084;
        Mon, 06 Jul 2020 07:16:09 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 1sm23719286wmf.0.2020.07.06.07.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:16:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: fix stopping iopoll'ing too early
Date:   Mon,  6 Jul 2020 17:14:12 +0300
Message-Id: <064b9efdfdf59b289f6ae399e09d5dfdf37f3083.1594044830.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594044830.git.asml.silence@gmail.com>
References: <cover.1594044830.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nobody adjusts *nr_events (number of completed requests) before calling
io_iopoll_getevents(), so the passed @min shouldn't be adjusted as well.
Othewise it can return less than initially asked @min without hitting
need_resched().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 50f9260eea9b..020944a193d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2037,7 +2037,7 @@ static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		ret = io_do_iopoll(ctx, nr_events, min);
 		if (ret < 0)
 			return ret;
-		if (!min || *nr_events >= min)
+		if (*nr_events >= min)
 			return 0;
 	}
 
@@ -2080,8 +2080,6 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 	 */
 	mutex_lock(&ctx->uring_lock);
 	do {
-		int tmin = 0;
-
 		/*
 		 * Don't enter poll loop if we already have events pending.
 		 * If we do, we can potentially be spinning for commands that
@@ -2106,10 +2104,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 			mutex_lock(&ctx->uring_lock);
 		}
 
-		if (*nr_events < min)
-			tmin = min - *nr_events;
-
-		ret = io_iopoll_getevents(ctx, nr_events, tmin);
+		ret = io_iopoll_getevents(ctx, nr_events, min);
 		if (ret <= 0)
 			break;
 		ret = 0;
-- 
2.24.0

