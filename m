Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F03B3F862D
	for <lists+io-uring@lfdr.de>; Thu, 26 Aug 2021 13:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbhHZLOm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Aug 2021 07:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhHZLOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Aug 2021 07:14:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7378CC061757
        for <io-uring@vger.kernel.org>; Thu, 26 Aug 2021 04:13:54 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q11so4402013wrr.9
        for <io-uring@vger.kernel.org>; Thu, 26 Aug 2021 04:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onRyYqPrllyKmtmwDRZBDhN4phd09Hrl13/rSNztNOE=;
        b=cWOuQJsE1nIVT2KWKOLWfXiuosQCjEzWcZR8FtUi12HuJVLFVfolXWQJIQRW1rwdvz
         MG8jrAc2CbTcYNlYO+Bw2Q2ySRyEQKyvTYABcYF1qhlFks56f/zAHBu3Z1NNhJuL07Tb
         x5rh2VEQlNKR1pp0cWIMhugbn7o9HrtE9MYOiNUn4fKhRgpl02+9G+eEKdNWerP+xIix
         ufegHtUpqA6FydZCcczeEUYhMukBwYrJOAgY7hMkPN9sMcJ0LHwjT4ApXjPPs0kORBGA
         2QUvAhIxRTwsPltmCKpjTPypNksGPIoCxVhZWBSg5RaV+p4xmbvGKxRrpZdCwlfd1A1h
         qIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onRyYqPrllyKmtmwDRZBDhN4phd09Hrl13/rSNztNOE=;
        b=GfpsRs9W+TV6RehcrNvexyFIIjYI4GqKN+uPVxjHWFY3pieImBUGxjNhTuT0//1kBN
         mSusBgBuAVxoAdOIYJ2i+ToIx0OqrFo9bj0DAHsM1bMVP1eZJXZD07n4QCnI2RQMTE4r
         EpRtlkjo8Q/u1G3wHUf7HXKXU0brqV5xAoWPiJwgVXXZeMA383MJwLOPi34LW5CqBCjG
         hfUKUxXr1/RkKI9vkhYdDH0jsXJEqfv/qda8MvlvpmCpEaxvZ4SWPaQKRGqA7BNlpTHN
         oSyMctB6ijOvYVuS7F2+r8MgXVkrY9lrZFQA0aD2kcMXIhEzdcG6KZ9QdR1jtIsAf4V7
         PJ5Q==
X-Gm-Message-State: AOAM53288AexU1BjaumSkuXwshH33A76EcxXOGtJRxcGqI0g1DRXJ3I9
        Kcqxr9N95f2Eh8j//qV1Nzshm+gMaT0=
X-Google-Smtp-Source: ABdhPJxBzUlr6pm5Fb8IWdBuKy3sUU4vUMgLwhgn4vMzy25h0OmIf0FrkBMTkI7mQwPFCB1HJm5m2g==
X-Received: by 2002:a05:6000:259:: with SMTP id m25mr3335455wrz.53.1629976433016;
        Thu, 26 Aug 2021 04:13:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.64])
        by smtp.gmail.com with ESMTPSA id o8sm2223039wmp.42.2021.08.26.04.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 04:13:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] io_uring: update buffer update feature testing
Date:   Thu, 26 Aug 2021 12:13:16 +0100
Message-Id: <de5fd2626bd4eabd0eec3eb8310888b4eb1a2539.1629976377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_FEAT_RSRC_TAGS came late, and it's the best way to check if a
ring supports resource (i.e. buffer or file) tagging and dynamic buffer
updates.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/rsrc_tags.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index 337fbb8..a82ba21 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -75,17 +75,17 @@ static int update_rsrc(struct io_uring *ring, int type, int nr, int off,
 static bool has_rsrc_update(void)
 {
 	struct io_uring ring;
-	char buf[1024];
-	struct iovec vec = {.iov_base = buf, .iov_len = sizeof(buf), };
 	int ret;
 
 	ret = io_uring_queue_init(1, &ring, 0);
-	if (ret)
-		return false;
+	if (ret) {
+		fprintf(stderr, "io_uring_queue_init() failed, %d\n", ret);
+		exit(1);
+	}
 
-	ret = register_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, &vec, NULL);
+	ret = ring.features & IORING_FEAT_RSRC_TAGS;
 	io_uring_queue_exit(&ring);
-	return ret != -EINVAL;
+	return ret;
 }
 
 static int test_tags_generic(int nr, int type, void *rsrc, int ring_flags)
-- 
2.32.0

