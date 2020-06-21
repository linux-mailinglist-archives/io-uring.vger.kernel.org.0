Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8C2202A11
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 12:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgFUKcQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 06:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729724AbgFUKcP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 06:32:15 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C59AC061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 03:32:14 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dp18so14939400ejc.8
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 03:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FXWwVRAk0KB8D+Os5fV/CIHPSm5aVrfd9Asx5GMc9O8=;
        b=ALB82+WyBy1Qc03IIR6TxSOzcfCwb8UMRtUJaMUCa0liDmQYlsjIdvRTwjC54lRaXR
         SYUBV4E2x1obt0wJktlvREPmuBbcjyGFRaSD4tgRSpkU4FQXDM6TWtE9CBHU6k/PhQF0
         fx9xRWrD2bQsV6sNz9vOk++LZXlOYUVj8TqiLzPMsX68duscdW4mWZOw1bHrKYg7gqi8
         paxBYSuLDiH+k0FhVqhuR7RxGi7iL8HiP417LbN+cueUq4k52H0m2XztDxAN/qOZ9rZq
         Rsb4aZGojb85Ri1D8AOuNlhBZRT6bpIPgMmC/ltS4kI3rHaUp6bFECAJkwb2yyF+f5wP
         6n2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FXWwVRAk0KB8D+Os5fV/CIHPSm5aVrfd9Asx5GMc9O8=;
        b=aOkZt1iApXmDXBnG5inkV35MYkRuMmmG5ayCrJ6JATtkae0ftx+DeWgqblQlMH14Aa
         cbCo6fHb7YneTiEcoDweCSii9SX3TrblYLv3EVUibEtxmiitRjh0Kgru/GiGTrBDYqFw
         nzUAUzz/RQYAGK3erzFGFyztFwYMH5aBGn81D8ZJJT25IT1r8jWRYghFy1qj1ebMMtOL
         b5gMKNMPA2njgIGIGcuTiWKN39d4d6Ei78pgGTLWFbevNqXoglI6y4Pirhx3CEfr5hXd
         +YDUThKvO5eYeqcOLyd8zLf+EhYmHKBWLUzO51riojYao8vdMMZWi1cP6r6h13n4F7+e
         ljeg==
X-Gm-Message-State: AOAM533YEgqarhMfdQ1tOUZBmYeHmR4ZqC+GlYnPFeO+i2naSfm6Z/H+
        RKYwH72bYNRtwNnFt19cXRk=
X-Google-Smtp-Source: ABdhPJzxd1/q5Ju7op2HgdotLcHCFdvhDk5DWSpX5+Dx05XJ2WwJ/jqmpkfCfOXIKgW2zri5Usv3xg==
X-Received: by 2002:a17:906:2409:: with SMTP id z9mr11000146eja.442.1592735532977;
        Sun, 21 Jun 2020 03:32:12 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id ox27sm9198521ejb.101.2020.06.21.03.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:32:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] Fix hang in in io_uring_get_cqe() with iopoll
Date:   Sun, 21 Jun 2020 13:30:29 +0300
Message-Id: <c1c4cd592333959bf2e0a4d2381372f1b40aef7b.1592735406.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Because of need_resched() check, io_uring_enter() -> io_iopoll_check()
can return 0 even if @min_complete wasn't satisfied. If that's the
case, __io_uring_get_cqe() sets submit=0 and wait_nr=0, disabling
setting IORING_ENTER_GETEVENTS as well. So, it goes crazy calling
io_uring_enter() in a loop, not actually submitting nor polling.

Set @wait_nr based on actual number of CQEs ready.
BTW, atomic_load_acquire() in io_uring_cq_ready() can be replaced
with a relaxed one for this particular place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/queue.c b/src/queue.c
index 14a0777..638d0ac 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -32,6 +32,14 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
 	return false;
 }
 
+static inline unsigned int io_adjut_wait_nr(struct io_uring *ring,
+					    unsigned int to_wait)
+{
+	unsigned int ready = io_uring_cq_ready(ring);
+
+	return (to_wait <= ready) ? 0 : (to_wait - ready);
+}
+
 int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		       unsigned submit, unsigned wait_nr, sigset_t *sigmask)
 {
@@ -60,7 +68,8 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 			err = -errno;
 		} else if (ret == (int)submit) {
 			submit = 0;
-			wait_nr = 0;
+			if (to_wait)
+				wait_nr = io_adjut_wait_nr(ring, to_wait);
 		} else {
 			submit -= ret;
 		}
-- 
2.24.0

