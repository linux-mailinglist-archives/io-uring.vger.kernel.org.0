Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9C6185134
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 22:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCMVcP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 17:32:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMVcP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 17:32:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id l18so13853570wru.11;
        Fri, 13 Mar 2020 14:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8khDX0zguZrOlxAUt6xpu1sxtgNiPNQNNt6SjsyrRj0=;
        b=g4wd3Hcj138srG/HA1xKC7mQLEP3G0Wj+AiIqrAyQ4I5IIb14Jcqb2XWAAfCf9HEUz
         fiAdplxbhJs26+Gd2EVVAe3M91rQBgPledkmeQdG1XfMCx8qfx4aumY10xKRoUyBMz7e
         4WWYPmRzwUdsOP9AWKcW+sqaumhg2qa158BH8ZNiRTVtXQR3IcPNjoWo3T+MNQu95Diw
         Xp3ftFbyf4RNX4JY36V3uRYtkTSnt7ZsKXiqnfZQwk13feTMd1eIDsdrYfwWXvIKRSNa
         Z4f/sIdtfXXUDqiobaHpyccwQkKZlSMHX5tygiCOL2O1TPajLio7n5QGj2TrkJJU1aVU
         K05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8khDX0zguZrOlxAUt6xpu1sxtgNiPNQNNt6SjsyrRj0=;
        b=mR3ho1hxwnwHQtbr5NuXsBOy8mXCYuV5HwKubnRE8gVARYCNJn4Qk7qlPrynU9VH3V
         DTe1+SQkZnVfUhzhOlV4+BCJxUN5p9pJ7RemCcvY6yUHTQXuq0iTosb0RPz1/rTSM3Dx
         9jYeXzxeQ3cPVeqOI+eAstmabONR/33hv6WAK7jYelQB8TRzHbr8fmXknhFJZkquD1FV
         415Ma66kRZ29aRsFfI3QuwI6cAGP9T5/Z8VF7mNBQtqDsk/rFG+LmjV5ocXYeFv62dGO
         t/emnBOu/KcF7OkrrDaoJdy0k1MX0U4qM0VJwAX0UdxQ3IQNl/q8nPhsdnMzpDoQ5w4w
         4rHA==
X-Gm-Message-State: ANhLgQ2CxEt24Rlz1ZTQxtw3xaOWpR4pDogPJCTCtwUObnSqEp2NNzZi
        JFz9xWJHfvNpJtHUvrohn0EdTuvr
X-Google-Smtp-Source: ADFU+vth4URq8X6X+GCquXtPHcRxj1rXHg2MlvBQAZCzyE5Iar8h5g/1IU4G6iOpGZGhwJaqK7vNhw==
X-Received: by 2002:a5d:4104:: with SMTP id l4mr20985102wrp.55.1584135132057;
        Fri, 13 Mar 2020 14:32:12 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id v8sm78676011wrw.2.2020.03.13.14.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:32:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io-wq: don't reshed if there is no work
Date:   Sat, 14 Mar 2020 00:31:03 +0300
Message-Id: <96c4e978564b3bf3674e2dbecb60b012c8e79f81.1584130466.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1584130466.git.asml.silence@gmail.com>
References: <cover.1584130466.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This little tweak restores the behaviour that was before the recent
io_worker_handle_work() optimisation patches. It makes the function do
cond_resched() and flush_signals() only if there is an actual work to
execute.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0e7c6277afcb..8afe5565f57a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -458,10 +458,12 @@ static void io_impersonate_work(struct io_worker *worker,
 static void io_assign_current_work(struct io_worker *worker,
 				   struct io_wq_work *work)
 {
-	/* flush pending signals before assigning new work */
-	if (signal_pending(current))
-		flush_signals(current);
-	cond_resched();
+	if (work) {
+		/* flush pending signals before assigning new work */
+		if (signal_pending(current))
+			flush_signals(current);
+		cond_resched();
+	}
 
 	spin_lock_irq(&worker->lock);
 	worker->cur_work = work;
-- 
2.24.0

