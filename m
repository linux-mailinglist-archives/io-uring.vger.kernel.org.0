Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B640720CA3E
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgF1T6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:34 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50851 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:33 -0400
Received: by mail-pj1-f67.google.com with SMTP id k71so3623087pje.0
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MeIMb29PydievU5nd6hRsuBTWUW2euMf4nWY+4INVIQ=;
        b=EtAACLthqD/ItocvwpfTmma7RmvcaL4clyjFE8vrhg+ZTYcohOr1bf9TGX77d3uQWq
         83SG71IKX1so5Bh2/8YZCdPtmBLsPBdskAt3Ky2+Jvc4Nk0Xx5PZ7jcIezUKdOzexmyX
         1Tn6xqHHXq8JGWfpI4REEuIDvDw5cG7ZGF/zxQs14OfdNc0PRw/C5TiNmeLUbFQoCJf6
         IBM9mAK3aDXrRcOSHjWDkS0B0c1TxXt0hzu2pxJl+XedsqiLkbziPKcTGYRir80YMSxK
         j3ka2EZY/8mOoS9u6Y1A1ukJsfPhH2R2iWTM2f5diPq7c/NLT61M3FgT3AD0rpk3BpJF
         N2Lw==
X-Gm-Message-State: AOAM532UrvTU79NzsbcHHCmPMaIUR86/v5+V3/JhY6lN0q7Sy5wwvuVQ
        Efgbw8osT50lCgrnXjpykYc=
X-Google-Smtp-Source: ABdhPJwBrrke0EykL4Tgb7Y25+9Mi4Hdx+7/iqxj4ct2w1oXKly4eGaX0I2WoHW9uwjj3evuVjtZyQ==
X-Received: by 2002:a17:902:e993:: with SMTP id f19mr10090549plb.305.1593374313428;
        Sun, 28 Jun 2020 12:58:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 2/7] src/include/liburing/barrier.h: Restore clang compatibility
Date:   Sun, 28 Jun 2020 12:58:18 -0700
Message-Id: <20200628195823.18730-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch fixes the following class of clang compiler errors:

include/liburing.h:150:3: error: address argument to atomic operation must be a
      pointer to _Atomic type ('unsigned int *' invalid)
                io_uring_smp_store_release(cq->khead, *cq->khead + nr);
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: b9c0bf79aa87 ("src/include/liburing/barrier.h: Use C11 atomics")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/include/liburing/barrier.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index c8aa4210371c..57324348466b 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -24,13 +24,17 @@ after the acquire operation executes. This is implemented using
 */
 
 #define IO_URING_WRITE_ONCE(var, val)				\
-	atomic_store_explicit(&(var), (val), memory_order_relaxed)
+	atomic_store_explicit((_Atomic typeof(var) *)&(var),	\
+			      (val), memory_order_relaxed)
 #define IO_URING_READ_ONCE(var)					\
-	atomic_load_explicit(&(var), memory_order_relaxed)
+	atomic_load_explicit((_Atomic typeof(var) *)&(var),	\
+			     memory_order_relaxed)
 
 #define io_uring_smp_store_release(p, v)			\
-	atomic_store_explicit((p), (v), memory_order_release)
+	atomic_store_explicit((_Atomic typeof(*(p)) *)(p), (v), \
+			      memory_order_release)
 #define io_uring_smp_load_acquire(p)				\
-	atomic_load_explicit((p), memory_order_acquire)
+	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
+			     memory_order_acquire)
 
 #endif /* defined(LIBURING_BARRIER_H) */
