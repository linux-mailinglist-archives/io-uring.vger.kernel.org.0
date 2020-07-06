Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F53D215A2B
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgGFPBZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 11:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFPBZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 11:01:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F0EC061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 08:01:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so41313580wrs.11
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 08:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kdZSl9K8MVVajtvjSWxTm+p7YgzxpNHKuBHS9gWIfb0=;
        b=h+8BHER0KZAQnSD/xFTFiRfwuksAKTugX0UMY5tfn/Gw8KIqA8abFCl8v08gjnXPg2
         lrAM9XAbEc9B0nvIsEiIxroKloCb5O+i8xaYHjn09Y4TAY8+g+4tbyX5VlNl7kgiQF1j
         80vsZ4tTSRpdDTvt87yJrEMSXXvyzB22kiwejkopBupSP9c7Ppyn959VixDTspC7Pqf0
         3YHwNP55dTjbexqxf/2YbhvwfoFxPhpBEVwAg8SaCldEpcJXd/aWJK9Z0jfTv5BhYAbT
         DDg94gJ+KHIz6cLPsR0A20M20usvXDdtVelDQhRUKhZ9R/UOFEdd4TAI+L0E0rmob4eO
         1pqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kdZSl9K8MVVajtvjSWxTm+p7YgzxpNHKuBHS9gWIfb0=;
        b=mQuZqRJa/sfF1llSB250vacUhRWYUcC5nR+VaaMT4jN/XVYFx2xGBK62uswq9AuxL3
         dSXeUFRmfZoC/gjbaxv6R01yriE1eIANZHN3aBtU7C5XG2Bi7XounWD2pQft6Fqw8Cm4
         1qXStuCKnP8TYbvv8tXlmQnqCILP90B7wASwQqxtwLzB7cehvwEh28o52e+Y53IT77M5
         SDLa2TAt35Q4nk2gQT1igMDIxZ9SVNF+AQzYQ8Eu6c3Y2mMrpZjbEalYELhD4pOuyyIe
         5E59PnpWBsuQxtuaTpBAaPsCLW8YZJ+TRT+UjII+JNGwMgmEK+/L7ph/MHPtp0iXPdOA
         pFpw==
X-Gm-Message-State: AOAM532Urhe3N63I3dTy2AMtlM9F9nRwHBFR3WI5b/lGEnoWfzy7LMs+
        CRKeH3uJdlinr/cnkfIfy9gtBmuT
X-Google-Smtp-Source: ABdhPJxAZpDSfxzYFIHtV6efIRjTH32MzQTwCZItc+xL4tPIFJpavKTTFwcoh6Kd8xoulYmJD6/Uww==
X-Received: by 2002:a5d:5310:: with SMTP id e16mr47139069wrv.289.1594047683701;
        Mon, 06 Jul 2020 08:01:23 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id k18sm15626168wrx.34.2020.07.06.08.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:01:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/3] io_uring: fix stopping iopoll'ing too early
Date:   Mon,  6 Jul 2020 17:59:30 +0300
Message-Id: <064b9efdfdf59b289f6ae399e09d5dfdf37f3083.1594047465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594047465.git.asml.silence@gmail.com>
References: <cover.1594047465.git.asml.silence@gmail.com>
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

