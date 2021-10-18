Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21444319C5
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJRMsp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhJRMso (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:48:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88022C061714
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:46:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q5so16061980pgr.7
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=btbR2pioYB+kAv444NCMQyOO8xBTQs0bRsgZjOfXS7s=;
        b=JCY+PgtuebCpm0KuoIVIb1dtCHeJOj8nTx0KwX7zy1TefEm+f96oNlXsPJIYLnX7R4
         5+UE8j3rcFc2U7s/5A8wg1V4e1+2oD6e/v2wlawK4gSsrRyFAo6foo+R0NU3cQJ0thFt
         dpoYFZSk6Qk0PEr2BSyb1s5lLKXMWJkWeMVF6fobxQHJ7IHDVrT8kl4FHs55HPO1ww4l
         T2UhtmV6RzC+N/MpJCQue+a/pDtEKlRCf9obvmniiFP+DMShXbE6+OO8ALmN/2Rsph+c
         tOtz7jyXghwRlyHJTNux8461aAJ7DQr3kGadbelZLAAovPS1l26xxsxgMdHWWr84X6bg
         r5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btbR2pioYB+kAv444NCMQyOO8xBTQs0bRsgZjOfXS7s=;
        b=IuKRB4yrB+9tI2AsN4QgEHinEKqcZ2JNHQwRFWICtlHDmGL2kuxAWkeXW9C5+0TqjH
         rgp+12wtAtfv6o1j0FuyTA6It41NsGMmHPUb7Bf+iMNrRrKVYPJNZ4/bMvZOhRszKZEF
         J7uTKSgR1MEoO5tw/qpeKeR9RVAEHexurtTUzuPvHQ5LdHvwIjP1K71nneeGSSrtuxVo
         Ztx37Loy4tyaItz4zEJhKQkotYBMTl4vBA6nRXUNfL0kehDiM+7A1VTyXCG7Eqw1E8Ou
         NavujTxE7m3sqCtjRvrAET0VHmq6YvcJ1rR3wn6S5MNrjk6ixtIVr8o6uFQJVu59ibiS
         he7w==
X-Gm-Message-State: AOAM532BLCWiQLvoa/lBAiRqQ+RxcWApO4+huKfAarbxVS1EzGm9c/h6
        DiFsg8aduzYFdskkkQUzrfTgaDKkepyOyzyn
X-Google-Smtp-Source: ABdhPJzMoGdAyiCJUoxctnjDfNHrLGuh53/aNaT2Zs2/HZMAcvuMOPBKZkZpHcgfOd61+5ftpWdZcQ==
X-Received: by 2002:a63:bf45:: with SMTP id i5mr23342631pgo.161.1634561192968;
        Mon, 18 Oct 2021 05:46:32 -0700 (PDT)
Received: from integral.. ([182.2.39.79])
        by smtp.gmail.com with ESMTPSA id l14sm20096041pjq.13.2021.10.18.05.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:46:32 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        zhangyi <yi.zhang@huawei.com>, yangerkun <yangerkun@huawei.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 1/2] test/timeout: Fix `-Werror=maybe-uninitialized`
Date:   Mon, 18 Oct 2021 19:46:00 +0700
Message-Id: <hgUsvvrR9xY-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
References: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix this:
```
  timeout.c: In function ‘test_multi_timeout’:
  timeout.c:590:20: warning: ‘user_data’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    590 |                 if (cqe->user_data != user_data) {
        |                    ^
  timeout.c:601:51: warning: ‘time’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    601 |                 if (exp < time / 2 || exp > (time * 3) / 2) {
        |                                             ~~~~~~^~~~
```

Fixes: 37136cb4423b27dac2fc663b6a0c513b6d7d7ad1 ("test/timeout: add multi timeout reqs test with different timeout")
Cc: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/timeout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/timeout.c b/test/timeout.c
index f8ba973..8c35b00 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -563,8 +563,8 @@ static int test_multi_timeout(struct io_uring *ring)
 
 	gettimeofday(&tv, NULL);
 	for (i = 0; i < 2; i++) {
-		unsigned int time;
-		__u64 user_data;
+		unsigned int time = 0;
+		__u64 user_data = 0;
 
 		ret = io_uring_wait_cqe(ring, &cqe);
 		if (ret < 0) {
-- 
2.30.2

