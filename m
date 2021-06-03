Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F3399A01
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFCFcV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:21 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:46980 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFcV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:21 -0400
Received: by mail-ej1-f47.google.com with SMTP id b9so7271750ejc.13
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxZ4K/bcAb8jbOqtZPrygGqlOB1DDEfIHD50KCvHH64=;
        b=LfZXnHuClLbtUG3+kMQlt8QAPqZeGVXMYeNz4YuHkS2AoUq/k8h/aDQqIg0PVQ4shj
         cKQsDbVfcRFii2Wuv6lZQQ3nH6l1DaHWyEohsXcfVuA3S6eq7J50T5nidbmH4vaOsero
         vduYIC5LfwgtxIJqtAzmr/3UmNbDWGJyr4Z9o1MzPm/wNnJ0dkw3UirylfLxE/sL3A3h
         H9na++itf+qOQUBgNKWq/3ZQqQnirJVKeDOuViZhsPi5TUYQHGzm++n0b++NzcsRRbGo
         E/8DKbISaOrYvG2Xd0z4NQYdoOEkq9IDr9LKqqrbhpqITqMnQR0DhW7cKcGKdKmOAkQ9
         fOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jxZ4K/bcAb8jbOqtZPrygGqlOB1DDEfIHD50KCvHH64=;
        b=XI5SnH7/MDdvdc+rGY8K4OBNR4lx1JX+rThCRWauGdzAAQaw/9YvTs2D9SR4CXlxvM
         F0QrAYP+6EVlZYd64lB8Qzm5WoROxf3sEzR0hqjLzzp39bHP9XsXG0kP34egHVXeflsi
         E7B7Tdjxqh91A5bfpYk1XpxAtMMjwaWLg9Y+3SnRQNxJJ4mvpwZ7P+Y2Yf8djUjfs4Ok
         ANBo1Llrh4qyHW33B5AeY5qPrp//H4lQehfH1yiHzv08K8urNsanjMKrPGn2x4tuA8Zv
         hemmTF2axQC6WQbx+lgsUR/T3i5l0mz0mDwtIzxbqbTlIVVeBRhB19ByeZ966FeK8njy
         zXjg==
X-Gm-Message-State: AOAM533gfvtuXXZ8uAQn4DJ1c2crUumrNF0bO5yJCpFHP1QzjdoRUBtS
        c5dg/dx8AyfoNRKWGgkYx3E=
X-Google-Smtp-Source: ABdhPJz20ucZjIwvtd7s9mgNcQZEAcR4Eh+cs+u0/TcDxQXSkEhLK6SiqyJK+aUj4dwMmbwT4eg3fA==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr35739835ejl.430.1622698164684;
        Wed, 02 Jun 2021 22:29:24 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:24 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 03/11] io_uring.h: add symlinkat opcode
Date:   Thu,  3 Jun 2021 12:28:58 +0700
Message-Id: <20210603052906.2616489-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603052906.2616489-1-dkadashev@gmail.com>
References: <20210603052906.2616489-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 src/include/liburing/io_uring.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 5a3cb90..439a515 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -142,6 +142,7 @@ enum {
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
+	IORING_OP_SYMLINKAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2

