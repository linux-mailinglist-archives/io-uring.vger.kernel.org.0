Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CADA424D50
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 08:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhJGGeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 02:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhJGGeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 02:34:17 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5CBC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 23:32:24 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 66so4705679pgc.9
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 23:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5LYwOQUbXLCJz8O08vGECteVF5V9YcnNfss5ot4F+HQ=;
        b=V+i6mhK/6QQkrD6TmxwAuzPMnpbI66jzfuG+uotiNt+MBZHPFi5QQl863FlX0biOn3
         +HLl5VFI12/bEWkIayf4BDxIWO9kQLqVB2+ren3WV56tR+iBOiL88J7mKilzOuE8wh/c
         8Q3eVGYOJtlUgGhiwjMbHguUNJov1QaC6fq5nZmM7y3pyCJuv+OdjUoiV8ZIuSbrqnkp
         946b6zhF7WnzEE11buDcP4pYp+gDVyPN0z+Q4KBDA0bt5iAjcv2iTKrPyT3O+e2LVy0p
         gHrN5iLvSVvpyXzYG/zvIZIQtDNPJfF9wcBScBKKAuzCIkWbPTYzoAA/X4mHphY/J68K
         Kqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5LYwOQUbXLCJz8O08vGECteVF5V9YcnNfss5ot4F+HQ=;
        b=2YBXyuC+DR1/+2BnpXdvIs3b2AIZ6Saz+9BEYQNyjotuAl4OErs7I+RwjO9vLWsrR5
         DxBBDLMMEzo8KYydng2g4XdxzxYWdH6fVxUAJJAMbhKyE5nx8+UyzlrX1DRA+klGMJ3P
         4NbiG6ITCpdQNaZ84gm4ZFVWZmfmknwcEQel196tBtjSY2TXelbbfafGhmM2GybJJ1zF
         7qBV81pr0JzUL3MmXrP10x4XjOBY8QjBOP9FpHjFTs4LPqILcuLsRTeIqOhnpGPG3w4x
         gsffYdEg5uhLe4+K3jGJEcdiIq6aWNypGf2/0sQ1cSbKOd45MaajQxfqXh50NK7GVKcY
         ijQQ==
X-Gm-Message-State: AOAM532LdpDVeu3G1rnOhxXKmIzELHr8Onc1vofLPg7nABHXeSI29J+W
        MRbxFvWKxvXOlFNhygTwaJV0Akjy4RjXxc6T
X-Google-Smtp-Source: ABdhPJyRRj4KyvgkX6mBGt39a2CjUiGBGRYn2U4TBo6ym22E7WgfY9FR+uIWUg+3cJUIlBmdorkzYA==
X-Received: by 2002:a05:6a00:c88:b0:44c:27d4:5cd4 with SMTP id a8-20020a056a000c8800b0044c27d45cd4mr2341438pfv.32.1633588343990;
        Wed, 06 Oct 2021 23:32:23 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id k35sm7103919pjc.53.2021.10.06.23.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:32:23 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 RFC liburing 2/5] test/cq-size: Don't use `errno` to check liburing's functions
Date:   Thu,  7 Oct 2021 13:31:54 +0700
Message-Id: <20211007063157.1311033-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we build liburing without libc, we can't check `errno` variable
with respect to liburing's functions. Don't do that it in test.

Note:
The tests themselves can still use `errno` to check error from
functions that come from the libc, but not liburing.

Link: https://github.com/axboe/liburing/issues/443
Fixes: https://github.com/axboe/liburing/issues/449
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/cq-size.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/test/cq-size.c b/test/cq-size.c
index b7dd5b4..4e6e3d1 100644
--- a/test/cq-size.c
+++ b/test/cq-size.c
@@ -45,14 +45,20 @@ int main(int argc, char *argv[])
 	p.cq_entries = 0;
 
 	ret = io_uring_queue_init_params(4, &ring, &p);
-	if (ret >= 0 || errno != EINVAL) {
+	if (ret >= 0) {
 		printf("zero sized cq ring succeeded\n");
+		io_uring_queue_exit(&ring);
+		goto err;
+	}
+
+	if (ret != -EINVAL) {
+		printf("io_uring_queue_init_params failed, but not with -EINVAL"
+		       ", returned error %d (%s)\n", ret, strerror(-ret));
 		goto err;
 	}
 
 done:
 	return 0;
 err:
-	io_uring_queue_exit(&ring);
 	return 1;
 }
-- 
2.30.2

