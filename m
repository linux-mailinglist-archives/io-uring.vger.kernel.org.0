Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D25615F5
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiF3JRV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiF3JQz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:16:55 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B124205DA
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fi2so37687256ejb.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QrDJbv7hodxTmOkHyYFWVJ4gHQ4HcCzGLPo//xF4i0I=;
        b=HWEaI/HGZOPZ3J1/ERd4jeXVU3l1DButGaxeCiP7RCpwXoHbRlKqhio/yp8XwrZ8Cr
         pRRueFjvosPJ9EPL4bhl7TwCOUq4QJkyjCtVZsv0Z+7EQZcJxyX4iwVEhX9TzxAAC5hB
         lcLU7BopUKDYcjyBCcYQKW/I9ns1/jJSvxtdfnzsS4PpxvxfJTmtBRWg9VSxYqayw8B0
         O6Nj0wjh+ex5CQ/u/mXpBO6Zt3rfwjXjWRfiwtO5o+PlRt48HxedAZpHOMJ8PeqbYSxt
         kfQpWCAp4GtSHRGuhVXCTY+sCxbZ2iiKuYO7C7Orw/1A9J7H1vNJBOU4fEtvtAkg1AsT
         mULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QrDJbv7hodxTmOkHyYFWVJ4gHQ4HcCzGLPo//xF4i0I=;
        b=k02m1Hx6KpXH4ZjXyZlqBCpuWINv4n/tLAdOVqiecQnfi1QI8vLYwbejL90wkZfHat
         zPAp8PQ+S4IKswBj+8RlCigIwM7pAa82LMI9GMOAG5OOBWPFqeqflwZsmXWQyYoF0vDu
         poFqdhe6hs+76IyguwjQthptvi5avXD8hpTu1aGJHpxk2hBbqjtF8J3653KQzUK62Ejo
         KqEXB3T/3J9cREFHJqDbpEvqYDkW5NVX5FXrBamd9+VWtL5/87rv5hKVSf7gJkEuXE3C
         rdldZ3xE7DW44HFT+jdkRzxER7PzwsOj8ziQhyrP/nlVCjQWugGim99XQq7ruVdvZAaV
         Fdww==
X-Gm-Message-State: AJIora/fBlZwDtB0XnEC7F1PIg9wGwb55Z0hYKSrm2ozyEa5/G3z97WE
        VzcwzCBvBjqAviPiKbLkexxk+1ydLaSUyw==
X-Google-Smtp-Source: AGRyM1vGVimGeoRHt6aY8qkrZs/FqNJ4l+8QN+Rmn0Y3YRwzh/CMwXC+fQ5MymVFUWFLgboSQ5Q+CA==
X-Received: by 2002:a17:907:7f90:b0:726:e8ed:3c28 with SMTP id qk16-20020a1709077f9000b00726e8ed3c28mr7971031ejc.63.1656580544526;
        Thu, 30 Jun 2022 02:15:44 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3ae])
        by smtp.gmail.com with ESMTPSA id s10-20020a1709060c0a00b0070beb9401d9sm8884925ejf.171.2022.06.30.02.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:15:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/3] alloc range helpers
Date:   Thu, 30 Jun 2022 10:13:38 +0100
Message-Id: <218118e4343c04010e9142e14627a7f580f7bca5.1656580293.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656580293.git.asml.silence@gmail.com>
References: <cover.1656580293.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h |  3 +++
 src/register.c         | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index bb2fb87..45b4da0 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -186,6 +186,9 @@ int io_uring_unregister_buf_ring(struct io_uring *ring, int bgid);
 int io_uring_register_sync_cancel(struct io_uring *ring,
 				 struct io_uring_sync_cancel_reg *reg);
 
+int io_uring_register_file_alloc_range(struct io_uring *ring,
+					unsigned off, unsigned len);
+
 /*
  * Helper for the peek/wait single cqe functions. Exported because of that,
  * but probably shouldn't be used directly in an application.
diff --git a/src/register.c b/src/register.c
index f2b1026..ee370d6 100644
--- a/src/register.c
+++ b/src/register.c
@@ -352,3 +352,17 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
 	return ____sys_io_uring_register(ring->ring_fd,
 					 IORING_REGISTER_SYNC_CANCEL, reg, 1);
 }
+
+int io_uring_register_file_alloc_range(struct io_uring *ring,
+					unsigned off, unsigned len)
+{
+	struct io_uring_file_index_range range;
+
+	memset(&range, 0, sizeof(range));
+	range.off = off;
+	range.len = len;
+
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_FILE_ALLOC_RANGE,
+					 &range, 0);
+}
-- 
2.36.1

