Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A320CA3D
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgF1T6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:33 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39230 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:32 -0400
Received: by mail-pj1-f68.google.com with SMTP id b92so7080645pjc.4
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bndz9/sOa8cPkj6Q4c2QqSM5tyv5YUivFUQzEZNvJIQ=;
        b=rm5GwqOPKF3xA/WQJaxsoyVKFwZhPpRJMw4yA2fEU46tdNdCyqWCqkb69htKSEbCfk
         psvaXTl1XbO1QmENox8kE71jWNslyd02Y68iAZ04uD6C+8SKOwFxtcrznWKs/5TA/xBF
         q6yM3H3h57mbgfKKAZDbSW6xPTk5vfCHV/ZvVzoNwzFhAxk0nQTCMofLOvOmm3E64WeO
         INNPr3xTQYcx0Qs1pbQnk8t2/PUJ54dTIvA25NHx/Y+TUZuvzkZ5dFdtAaKi9jqdgoov
         SL7XU618oGZSLQiTuGYJZRjI54tzIZkavqSnRSMObM7afZXDcOh3Ilnxr3K9D7u4Dibj
         pzdw==
X-Gm-Message-State: AOAM530jDYOOCvNSuUt3XOJHjfdnVUf57gXRNp3cEth+A2kdr9LoP+rN
        BR0YkQjSZVqYBxmyJ6mqRpo=
X-Google-Smtp-Source: ABdhPJxeD9y5ifB8r8C6/1ms4yRJ9B/eIFH70BULpBJisv0dl181/kctzcbbsF9LvgPgGqOdK56FaQ==
X-Received: by 2002:a17:90b:1881:: with SMTP id mn1mr12593393pjb.198.1593374312218;
        Sun, 28 Jun 2020 12:58:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 1/7] src/Makefile: Only specify -shared at link time
Date:   Sun, 28 Jun 2020 12:58:17 -0700
Message-Id: <20200628195823.18730-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since -shared only takes effect when linking, only specify it when linking.
This patch fixes the following clang warning:

clang-10.0: warning: argument unused during compilation: '-shared' [-Wunused-command-line-argument]

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 3099f7cd51ec..44a95ad78afa 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -6,7 +6,7 @@ libdevdir ?= $(prefix)/lib
 CFLAGS ?= -g -fomit-frame-pointer -O2
 override CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare\
 	-Iinclude/ -include ../config-host.h
-SO_CFLAGS=-shared -fPIC $(CFLAGS)
+SO_CFLAGS=-fPIC $(CFLAGS)
 L_CFLAGS=$(CFLAGS)
 LINK_FLAGS=
 LINK_FLAGS+=$(LDFLAGS)
@@ -51,7 +51,7 @@ liburing.a: $(liburing_objs)
 	$(QUIET_RANLIB)$(RANLIB) liburing.a
 
 $(libname): $(liburing_sobjs) liburing.map
-	$(QUIET_CC)$(CC) $(SO_CFLAGS) -Wl,--version-script=liburing.map -Wl,-soname=$(soname) -o $@ $(liburing_sobjs) $(LINK_FLAGS)
+	$(QUIET_CC)$(CC) $(SO_CFLAGS) -shared -Wl,--version-script=liburing.map -Wl,-soname=$(soname) -o $@ $(liburing_sobjs) $(LINK_FLAGS)
 
 install: $(all_targets)
 	install -D -m 644 include/liburing/io_uring.h $(includedir)/liburing/io_uring.h
