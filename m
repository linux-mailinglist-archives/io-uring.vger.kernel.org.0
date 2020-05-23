Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E27D1DF3FE
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbgEWBvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387581AbgEWBvL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:51:11 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D60C08C5C2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:10 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w20so802863pga.6
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JH4qffDw1bR16LSZOmXHQ8vTjhgFWUTnPL/hN0raEaw=;
        b=ETmKby8pAAIxY9U6WKn9CNosQ44mYgxTdTEtopdfdIDXO+NjGX+ifvqGeQRY+HJLIA
         zY/uuUSY7ifcyny8cCud0KJJtWED2SwscDrPgSbt9iDpo6l5rWhZ/iWY3YeImMCN8iMw
         L/7j62wezVNEzhqDM3bI8PBpBnkH7SjhNbw41sQr28LB9x44BGLyFn6rdBNi9M1yaRJJ
         XZU/iC4PhJhfemfcMMM8/912GLbEFK+hudvmr0EFF29TKybjESBwie4GPrS5paBlNGpI
         +3XhOzxy9MSMPaP2RNYzlt8xEZiiLsPjce+rDPBpL7L7WQNe5ic1esa1XcBzqGkfkR/u
         tRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JH4qffDw1bR16LSZOmXHQ8vTjhgFWUTnPL/hN0raEaw=;
        b=Z1P5Ui0p31Y++dLzzxXcKzA+fHecZdUmS8aglkA2qgOhmP0Dvmi30BxrCyAi3lsDcg
         M36u/KcHVZDWDa8VZZr4bbcz0jG075IZScmS6Wd9E4AGPWpSMZOcTt4EFjNhW+/XWcBI
         Uez+lKEsH6khCa88suf0vJeLlN0mhTz5wxmSz98ikDVghW7qvlS4sBQRweoOGv9O2VuL
         JYpi2S8xJCchse3e7r0NPIsS/LfeBZKfWABUXx6hxN3Zpkd8EIXHsukKIS8UBWRDcMrQ
         1B4zV/AYFY273ho/ADvtsjcxXNydwx8DiERySZ0IjPlP5Ik4PcE31UmqP9uR09oAbCcl
         4UoQ==
X-Gm-Message-State: AOAM531NtkdnfPRdyNLRkg4rrN+STilQay86ezUftmfIoFNV2sksAtXc
        CLugePRWX4kW/cudZeNVVBCawC9JeKE=
X-Google-Smtp-Source: ABdhPJz0nFKgn1N3JiIfLboWuIb5grjg380HgPkl+kUx5EXcYlCR6fXRG759tLrdb0IJ28scGhXSoQ==
X-Received: by 2002:a62:641:: with SMTP id 62mr6411983pfg.283.1590198669882;
        Fri, 22 May 2020 18:51:09 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:51:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/11] mm: add kiocb_wait_page_async_init() helper
Date:   Fri, 22 May 2020 19:50:48 -0600
Message-Id: <20200523015049.14808-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523015049.14808-1-axboe@kernel.dk>
References: <20200523015049.14808-1-axboe@kernel.dk>
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
 include/linux/pagemap.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e260bcd071e4..21ced353310a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -468,6 +468,24 @@ struct wait_page_async {
 	struct wait_page_key key;
 };
 
+static inline int kiocb_wait_page_async_init(struct kiocb *kiocb,
+					     struct wait_page_async *wait,
+					     wait_queue_func_t func,
+					     void *data)
+{
+	if (kiocb->ki_filp->f_mode & FMODE_BUF_RASYNC) {
+		wait->wait.func = func;
+		wait->wait.private = data;
+		wait->wait.flags = 0;
+		INIT_LIST_HEAD(&wait->wait.entry);
+		kiocb->ki_flags |= IOCB_WAITQ;
+		kiocb->private = wait;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
 extern int __lock_page_async(struct page *page, struct wait_page_async *wait);
-- 
2.26.2

