Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980C31E2F5E
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbgEZTvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389269AbgEZTvo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE013C03E97B
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so9105690plo.7
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=egusxH2Kf4IsegITvpm+Q3F8VxKliDk7k1e8lkissGM=;
        b=MLDFg6dOL3wi94Sm49zoJiHajT2Z6Uem1NGpbbefsORGLMzmbgt6H7oJbyNaRmzLhC
         8Gf5ZNcnIwrFrsP15fHb8Hmk8a2hfjKN86KGFvtSh4PMPlyXApwguNjE2pUXQI5wzJ0a
         rImtmWOl8q0Gt2VD5UOeqH755bpc04N3G1iq2vwGTCann04vKvGxeoLEFP4xQ4fRN5L5
         Wg9gBx9FYIQvKM0euflOkFd88eUTLbrv+ERHN3wTJKYKJYMp38rMrtrLJwTNL4ghE1HN
         EtuRhPWgN+n1jwAN6pgdhE4EdIt7SHFVS5ROARRrp8WYRbT1BdjRgRCf0aEwWTyQqK88
         EjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egusxH2Kf4IsegITvpm+Q3F8VxKliDk7k1e8lkissGM=;
        b=mVHqLUIs8Ge8g0+bJu7505oTkhDqAykkcXqz8T/Zk77USLMZbWYqgNbURc0olMJitY
         SOtOKCBFsB+BZi/1+hW5zmI0GnpH+NS4JVPi/Ehwa+Xae3QflZ0GTcdzXwU4s6sJaeDw
         n6HIVIfccog1OBjAWm0LySWW3PYQGwSmi1bsTlSiq1bXm7NIpPs9UMyJyJe0I4b8FrRM
         WNP762IOyTdMmKczwjy5RGLhoq7GVebfroLYjSENbbbPPn+wBitlGsfGRtFvPRpLS0C5
         sBhAoiGeoSCT7MIrUiALVFxGvBEg9DI32GTUld5I4VEur+5KP9h99HBPuUbz1KGNrGXH
         +lOw==
X-Gm-Message-State: AOAM530bfyUZSJHYLIy4KOXQLSkCzp6Qhrelr4bwqjdEPE8s4lZSd1/+
        3ybeZQ2OG7m3GzmBPKSxalnRdFFLpFg2Tg==
X-Google-Smtp-Source: ABdhPJxAwu286c9tdXeF8Jkxcn+Zoh3JziTFwAwrgLKM/2XtZ0wj0VRphyzFquzNho/fJP8ygPEQiw==
X-Received: by 2002:a17:902:b289:: with SMTP id u9mr2621523plr.138.1590522701930;
        Tue, 26 May 2020 12:51:41 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/12] mm: add kiocb_wait_page_queue_init() helper
Date:   Tue, 26 May 2020 13:51:22 -0600
Message-Id: <20200526195123.29053-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Checks if the file supports it, and initializes the values that we need.
Caller passes in 'data' pointer, if any, and the callback function to
be used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/pagemap.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d3e63c9c61ae..8b65420410ee 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -493,6 +493,27 @@ static inline int wake_page_match(struct wait_page_queue *wait_page,
 	return 1;
 }
 
+static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
+					     struct wait_page_queue *wait,
+					     wait_queue_func_t func,
+					     void *data)
+{
+	/* Can't support async wakeup with polled IO */
+	if (kiocb->ki_flags & IOCB_HIPRI)
+		return -EINVAL;
+	if (kiocb->ki_filp->f_mode & FMODE_BUF_RASYNC) {
+		wait->wait.func = func;
+		wait->wait.private = data;
+		wait->wait.flags = 0;
+		INIT_LIST_HEAD(&wait->wait.entry);
+		kiocb->ki_flags |= IOCB_WAITQ;
+		kiocb->ki_waitq = wait;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
 extern int __lock_page_async(struct page *page, struct wait_page_queue *wait);
-- 
2.26.2

