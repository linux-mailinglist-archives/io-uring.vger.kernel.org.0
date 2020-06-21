Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAB4202B85
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 18:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgFUQQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 12:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgFUQQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 12:16:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C04AC061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 09:16:33 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y10so1019458eje.1
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fK8cPjOGKxnNcn4UQP0uF/jFK43AYsdxChkW7/6dpUI=;
        b=piW+JNbaWcKpUaKTjgg1J/0ryl/h/8MycXKjTY+NgftfqHagXEc6oFX2eAO1YL4pSH
         JtT5vnh3Rt7n/X0cICFq03rQ5We11HMEyUZlNsOy4xAs6yQCOHetUZW6kJXdszbnEWaB
         yz9aHwq09IDfG3LnCPjk+i6XWj+Niebh+aCIz8x7BO0xThfe14t9y4K648F8ZCpdGLLe
         tXFqWbN6FAMnbO2Bc36sp/9otJOVhTiI/LapPxntvLLh3vffEItUSJgvkyyaIEmvoma0
         s9mzUzBE2unDVZVTNGKUKZ1pyXjBuQaZtrnzsaUJrhfisUFvtaadEDpVxGBhBw9ANkGS
         OTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fK8cPjOGKxnNcn4UQP0uF/jFK43AYsdxChkW7/6dpUI=;
        b=S1zI5PPW0ZSFvbQ7GfUs4ukkxuilx5xUZYhO2i/z5JCejMVnhZg95WxjsXWidjSJ1s
         FfNZaMs1FoqgGTmC/3xBCHP13ICtjroxX1Bu9V62gWVEKF6mnGQn6iORZ07tpLTwIzaU
         zIrA4NwcDFHGqHEAvsTJlTqjm43Jn5YnWw7TJJ6+oyGh3EL+BrCggKnLc43Du8vLg5mn
         KklShSIx6jM9WCjtHyEJDIbucIXpT7vzNkcgrhQb192WrpuBG3o3t38KPE0Sd5p/9IUV
         EbHpaPYrqxf/gmaSHj1/5yeY6KWai7zo0+HxCPAPSzdEqtIrNMDgvpnTn0aPXp3R+QwH
         wZDA==
X-Gm-Message-State: AOAM530fsce8/bSFEeMh40wfDf1tSWn9THCbuSnDaunbGHrByBCVm+Av
        R+VwtsTxewvm6H/NTq/DzET3u/kZ
X-Google-Smtp-Source: ABdhPJxto49W1WcXJEHA/7WazEym6Y/3pb2PLQfs1bi3AidckEkBzLj7Brk/39LmEZtPv+Y17bivlA==
X-Received: by 2002:a17:906:191a:: with SMTP id a26mr2301878eje.315.1592756191789;
        Sun, 21 Jun 2020 09:16:31 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 64sm10160292eda.85.2020.06.21.09.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 09:16:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] barriers: add load relaxed
Date:   Sun, 21 Jun 2020 19:14:25 +0300
Message-Id: <f7de9c7842c666cfe7b255224bd934427274b465.1592755912.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592755912.git.asml.silence@gmail.com>
References: <cover.1592755912.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_uring_smp_load_relaxed() for internal use.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/barrier.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index ad69506..6a1aa52 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -47,6 +47,8 @@ do {						\
 	___p1;						\
 })
 
+#define io_uring_smp_load_relaxed(p) IO_URING_READ_ONCE(*(p))
+
 #else /* defined(__x86_64__) || defined(__i386__) */
 /*
  * Add arch appropriate definitions. Use built-in atomic operations for
@@ -55,6 +57,8 @@ do {						\
 #define io_uring_smp_store_release(p, v) \
 	__atomic_store_n(p, v, __ATOMIC_RELEASE)
 #define io_uring_smp_load_acquire(p) __atomic_load_n(p, __ATOMIC_ACQUIRE)
+#define io_uring_smp_load_relaxed(p) __atomic_load_n(p, __ATOMIC_RELAXED)
+
 #endif /* defined(__x86_64__) || defined(__i386__) */
 
 #endif /* defined(LIBURING_BARRIER_H) */
-- 
2.24.0

