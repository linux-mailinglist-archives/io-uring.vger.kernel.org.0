Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D31E362BED
	for <lists+io-uring@lfdr.de>; Sat, 17 Apr 2021 01:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhDPXdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 19:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhDPXdV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 19:33:21 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7872FC061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 16:32:56 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j5so27191637wrn.4
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 16:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zdRYFq4rsuafd51uHL/pkV2l1d3Dkd8AfzBXYVGQuk8=;
        b=oILmeX723AEjsJ41MRd7pd7CD6j2F+MaLAUs1IyLjt7asTSKphmR9vt3s1cKaXfxlo
         F1plGiauhdr9KND+n94cIuEbMAm3oo6EqgeiAX6yA3yYmKApb9yy+IATysL22w7U21lz
         hjeErB9KPmnFgRxjdZ+UEEgkl512GGKv3NtwGOE8cX4VyeYQwRYDSy7hy2KyWluFoDzk
         +S06rHoudENekDbI0CfhAfIAMOap4ca+M/3nZIv5JzNuws09aiSRD/SXyzc2qLsdoCQU
         AE0Xiv6B4zUJNvJ29pCsagm49BazONazlhlNbdJkoJJ2uTKiEdJq6KanJaDV7VV5S1SL
         I5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zdRYFq4rsuafd51uHL/pkV2l1d3Dkd8AfzBXYVGQuk8=;
        b=Gd2sICPjj0PWgRrunFsx8nny8zecw6KDB58BVfY9XGQ4m6klQScz4xETbsZk7JOcsM
         l/gtJniXur8wspyZnsN3IO2ct49e1cj81ZNFdXSv3wlQ6SrwpJsGG3Skqtciq6MhwtWi
         QjvYZ5EBeAM1X6ay4SeGTS8HPt0tGAu/pYfg6auAdwQKehfw/oiKy8c+XKHjlmV51DtP
         SSJJt/sUikUzSgqWoT1HWjNOSGPHyhjXERNqNcOKgQrHWjW6YTqRVLtXZkia92qPyVte
         y6KWBvUC3tGY2Hv7+Y+08Ep3SaSHVBK9E1tLG9TUcSrQqFYdzeDgsL2HipxbdDjHIUgr
         RGXg==
X-Gm-Message-State: AOAM532DllRa3EBA7ID4AeIboW2Uqk07rqXszSPKWzAjL/f0AKkG98qz
        Kr4yZEfjWmkdQL/TCULkL3kgX8jt3lseAg==
X-Google-Smtp-Source: ABdhPJzsbETJYgdealTt3P7D2xh9vlZXpxcVUetgdiU7o+58CWXdkzDRY0CFluI9oL9xuGlWmNYZ5Q==
X-Received: by 2002:a5d:55cd:: with SMTP id i13mr1465697wrw.393.1618615975292;
        Fri, 16 Apr 2021 16:32:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.77])
        by smtp.gmail.com with ESMTPSA id 91sm11942827wrl.20.2021.04.16.16.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:32:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: don't fail submit with overflow backlog
Date:   Sat, 17 Apr 2021 00:28:37 +0100
Message-Id: <0933f5027f3b7b7eea8a7ece353db9c516816b1b.1618489868.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't fail submission attempts if there are CQEs in the overflow
backlog, but give away the decision making to the userspace. It
might be very inconvenient to the userspace, especially if
submission and completion are done by different threads.

We can remove it because of recent changes, where requests
are now not locked by the backlog, backlog entries are allocated
separately, so they take less space and cgroup accounted. 

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

since RFC: commit message rewording

 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 357993e3e0d2..21026653e1c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6673,12 +6673,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	int submitted = 0;
 
-	/* if we have a backlog and couldn't flush it all, return BUSY */
-	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!__io_cqring_overflow_flush(ctx, false))
-			return -EBUSY;
-	}
-
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
 
-- 
2.24.0

