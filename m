Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9920D423383
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 00:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhJEWdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Oct 2021 18:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbhJEWdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Oct 2021 18:33:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B51AC061749
        for <io-uring@vger.kernel.org>; Tue,  5 Oct 2021 15:31:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s75so689385pgs.5
        for <io-uring@vger.kernel.org>; Tue, 05 Oct 2021 15:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pDGYP11AORxKJU4HF/f85dJHNbMt9cs1awc7vn//G8I=;
        b=J1AkTyhbirrPF3/xKLkay3VAIFgRbc6aPugGuDwMZMvq+hF89yXzHeGiTsJ1DS+Q0k
         ngWeNCDttLH9J2dVt3kLig4ECWAiWUEb6Zt725wnUJCu1zJnVzfhbl8B7GVLJA5E3taH
         4+DI8zBJS2ajC18ED8HtCDIjdLf9ySnnfs90evJy7cx4SWgU8ZS4E1yfHLpza3ne0YPe
         H4dPQf5hpfFCUSXa1ryIjWQe5tartvTX3qtuhHPjokuq7u2yVbR+WZyTUiZxqTPkkALx
         QnQMN0Jnv19P21X5PrP9E/uD45miiGrkeWH0orNCWLc19wTcQBQtTflkwJF4+jpGxxwC
         OZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pDGYP11AORxKJU4HF/f85dJHNbMt9cs1awc7vn//G8I=;
        b=Av4cbwHT3Q9tE2BTnhJjsQff5EmUItkRYvvWRl/jQ9QSrO1tHJfSDyaGhveYjUEhir
         yu5h975iLuootGo70v9vMYX+n43eAqsggZuzUtC1eU8DZWx1RyNX59w4qwoOKgShATjG
         VTfdH5kIc2XpRbcvB/0qJVHL3NvUcuBhyQLBTcxsBdXl+kRaSnYDEz9idD5/8GR9cDl4
         b0tZSjW7SzUgn4HJOD4lk9z72jQ89wp4Xy7NJ8QoBbaW1ee7EAbNchmJs+P8libcIltr
         k9LEA++oleq3PqkZycvQV2Uz/oxAlG5soaLgdJ50nOtAcEhcuHoCLA97BQ7D7c5KMUZa
         7K4Q==
X-Gm-Message-State: AOAM532h74gtp4fUr8SlEfBZiEq8sXx4oklDJSEd/+6+DWXXIWufiORQ
        FLSIlp4xFOdU6TNe7HaQcl572Q==
X-Google-Smtp-Source: ABdhPJwm7ynFNvJVPrdttmJ94O/3neidf1CZh+ToPTVye8H9FlHK3gwb3ePCqCnOiZ8vg+FO0+yPGA==
X-Received: by 2002:a05:6a00:238a:b0:44b:e2bb:e5ff with SMTP id f10-20020a056a00238a00b0044be2bbe5ffmr34500847pfc.14.1633473091069;
        Tue, 05 Oct 2021 15:31:31 -0700 (PDT)
Received: from integral.. ([182.2.37.98])
        by smtp.gmail.com with ESMTPSA id b10sm18211671pfi.122.2021.10.05.15.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 15:31:30 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH] Fix typo "timout" -> "timeout"
Date:   Wed,  6 Oct 2021 05:30:10 +0700
Message-Id: <20211005223010.741474-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cceed63f-aae7-d391-dbc3-776fcac93afe@kernel.dk>
References: <cceed63f-aae7-d391-dbc3-776fcac93afe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Olivier Langlois <olivier@trillion01.com>
Fixes: a060c8e55a6116342a16b5b6ac0c4afed17c1cd7 ("liburing: Add io_uring_submit_and_wait_timeout function in API")
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---

It seems Olivier got rushed a bit when writing this. How did you
test this?

 src/include/liburing.h | 10 +++++-----
 src/liburing.map       |  2 +-
 src/queue.c            | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index fe8bfbe..99f4f37 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -122,11 +122,11 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring,
 			      struct __kernel_timespec *ts);
 int io_uring_submit(struct io_uring *ring);
 int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr);
-int io_uring_submit_and_wait_timout(struct io_uring *ring,
-				    struct io_uring_cqe **cqe_ptr,
-				    unsigned wait_nr,
-				    struct __kernel_timespec *ts,
-				    sigset_t *sigmask);
+int io_uring_submit_and_wait_timeout(struct io_uring *ring,
+				     struct io_uring_cqe **cqe_ptr,
+				     unsigned wait_nr,
+				     struct __kernel_timespec *ts,
+				     sigset_t *sigmask);
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
 
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
diff --git a/src/liburing.map b/src/liburing.map
index 09f4275..7f1eeb7 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -47,5 +47,5 @@ LIBURING_2.1 {
 
 LIBURING_2.2 {
 	global:
-		io_uring_submit_and_wait_timout;
+		io_uring_submit_and_wait_timeout;
 } LIBURING_2.1;
diff --git a/src/queue.c b/src/queue.c
index b985056..9af29d5 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -313,11 +313,11 @@ int io_uring_wait_cqes(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
 }
 
-int io_uring_submit_and_wait_timout(struct io_uring *ring,
-				    struct io_uring_cqe **cqe_ptr,
-				    unsigned wait_nr,
-				    struct __kernel_timespec *ts,
-				    sigset_t *sigmask)
+int io_uring_submit_and_wait_timeout(struct io_uring *ring,
+				     struct io_uring_cqe **cqe_ptr,
+				     unsigned wait_nr,
+				     struct __kernel_timespec *ts,
+				     sigset_t *sigmask)
 {
 	int to_submit;
 
-- 
2.30.2

