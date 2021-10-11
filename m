Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699BD42870C
	for <lists+io-uring@lfdr.de>; Mon, 11 Oct 2021 08:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhJKGwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Oct 2021 02:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbhJKGwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Oct 2021 02:52:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B523C061570
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 23:50:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v20so3545527plo.7
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 23:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m2oteJ1dI+61Ga8S84U4XkpzkwyXiphaVmkNksAxI+U=;
        b=DKw/B/K/37uPnO0qDIuFq/mbFqPoHEeRp9HiFD/836HsNi+jnzCo6sdEfRq7qxx+qf
         CGLGuc6khJCkEEAUR3FHxk1d9aGu+s1x7atakGtH5mBJY/KmvSLaHxCSIw7uYOckKor5
         3WSVFv7I/BmK7C9lfyrWgA6VnQRpLkdsKF6bwqVtY/EfZ/jYlNWga1v/PavmlcqhUwWm
         eHmDxVq0i8cuC2vIvwenc8CPZGH1BmyCXybgvooRKHwVgagMqCd4J6xuY1XaSVIAjmQr
         4QUu3YBvSlXRUlxmhh4hIZwV3n+YPHkbsZGTed0hNwu3ViTMqO7EV1uE1YlqGYcAh8mu
         9WCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m2oteJ1dI+61Ga8S84U4XkpzkwyXiphaVmkNksAxI+U=;
        b=TpeQQ+ZxNRDIpDJxtc79zOwJBcDYns5Q+xePw3DJkLzZeMS3coJX2N6gA7+29Wg+wY
         ghMevwuCed1++Vb6UnprtXNvzYobRfoKlODWENHyzbjABFWV3nbpJM6czFKoUCaO1o8r
         H30fJayFWPPg/iVmv4+FoXOSv1epdI4+iB8yrGP0d2rVModTC7U24fxZ81iEhkfkvXzj
         rz7RX7bq8/txq8LixSEyH03YY4gVxS0xZkM/WW0esZqZdsKZ4BpquS1jHBSPXVsfM1Zx
         9AA/NlkQJVYHoz3Yrb784PRxfOxnRsQSCCjHcE0S+lq6V0a95eBWMsey0VjH0PDkmx/a
         +82w==
X-Gm-Message-State: AOAM532RC7hQcyEbcgbhxqymNUwFBTUhKX1w316UZrmSufBxjFjvX8KX
        AXDl90FRNLlpPl2FUHALANxh6w==
X-Google-Smtp-Source: ABdhPJz59FTwAOd+HTMmwr75jQ5u5miLQXJAX2lft+Uw8qFgeLctZX0eEfAH2FhjgM3ZhR6gf9HzMQ==
X-Received: by 2002:a17:90b:1b49:: with SMTP id nv9mr27783186pjb.134.1633935015628;
        Sun, 10 Oct 2021 23:50:15 -0700 (PDT)
Received: from integral.. ([182.2.41.40])
        by smtp.gmail.com with ESMTPSA id w125sm6517485pfc.66.2021.10.10.23.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 23:50:15 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing] src/nolibc: Fix `malloc()` alignment
Date:   Mon, 11 Oct 2021 13:49:27 +0700
Message-Id: <20211011064927.444704-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add `__attribute__((__aligned__))` to the `user_p` to guarantee
pointer returned by the `malloc()` is properly aligned for user.

This attribute asks the compiler to align a type to the maximum
useful alignment for the target machine we are compiling for,
which is often, but by no means always, 8 or 16 bytes [1].

Link: https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Common-Variable-Attributes.html#Common-Variable-Attributes [1]
Fixes: https://github.com/axboe/liburing/issues/454
Reported-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/nolibc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/nolibc.c b/src/nolibc.c
index 5582ca0..251780b 100644
--- a/src/nolibc.c
+++ b/src/nolibc.c
@@ -20,7 +20,7 @@ void *memset(void *s, int c, size_t n)
 
 struct uring_heap {
 	size_t		len;
-	char		user_p[];
+	char		user_p[] __attribute__((__aligned__));
 };
 
 void *malloc(size_t len)
-- 
2.30.2

