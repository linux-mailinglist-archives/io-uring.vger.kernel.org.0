Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A5D202CC0
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 22:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgFUUg4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 16:36:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34227 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730643AbgFUUg4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 16:36:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id z63so7385714pfb.1
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 13:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fjt/djgISzTUPHwaazm8rvFzpgZY4JsfMSL/rh5ghP8=;
        b=V3xMJSLRrHVXewmqnRtz/cbLjDXT/68dtHT0nMmNVE7rkb2z7vEVxpXYgctwpIC0Sn
         WKKXU4nM1icsgTiKpG2MSw2gfoHiCoe1iBwR7ES9BVM0+R3bINSe+0T1mgVLe0PYBoK3
         BZ4G7KHvdFnFNeaK7jzXJYNZq5BA8hPtOolQpCASZ7PgrmPJ67IpqxFPX7zM2lqze3OY
         Agk4Smt2ac5rN9MUZn6nf2NSZtB2MFtYWwy6HK8Vu213eiyM4RDWSgPeFvK0b/Oz/H9w
         QzLx4/fk+WoIbhmQLyiLThWKoHrCEOmoCkmmuscKBgI/goF0o6S+b2XNndAGTWrcypzH
         ZrYw==
X-Gm-Message-State: AOAM533NV4oKYnOr50oJ5NnpUiKPYWFwANMHN/SXhuXUcIqWKdxfWrht
        gVf8JrX9XIZ4LaABRy7i7AA/ug81
X-Google-Smtp-Source: ABdhPJxeYlchv+2YIdjYqajBBAI4u4YRjMVK5qikkRCkvHg/7NgzJaVuFcndDj4prwd5ZIO7WOYnew==
X-Received: by 2002:a63:2246:: with SMTP id t6mr10525326pgm.211.1592771815216;
        Sun, 21 Jun 2020 13:36:55 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d5sm10861387pjo.20.2020.06.21.13.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 13:36:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 1/3] Makefiles: Enable -Wextra
Date:   Sun, 21 Jun 2020 13:36:44 -0700
Message-Id: <20200621203646.14416-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621203646.14416-1-bvanassche@acm.org>
References: <20200621203646.14416-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable -Wextra and disable the unused parameter and different signedness
in comparison warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/Makefile  | 3 ++-
 test/Makefile | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 9bbbacf03d59..3099f7cd51ec 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -4,7 +4,8 @@ libdir ?= $(prefix)/lib
 libdevdir ?= $(prefix)/lib
 
 CFLAGS ?= -g -fomit-frame-pointer -O2
-override CFLAGS += -Wall -Iinclude/ -include ../config-host.h
+override CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare\
+	-Iinclude/ -include ../config-host.h
 SO_CFLAGS=-shared -fPIC $(CFLAGS)
 L_CFLAGS=$(CFLAGS)
 LINK_FLAGS=
diff --git a/test/Makefile b/test/Makefile
index 93e58f4ba9b0..e103296fabdd 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -5,7 +5,9 @@ INSTALL=install
 
 CFLAGS ?= -g -O2
 XCFLAGS =
-override CFLAGS += -Wall -D_GNU_SOURCE -L../src/ -I../src/include/ -include ../config-host.h -D__SANE_USERSPACE_TYPES__
+override CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare\
+	-D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -L../src/ \
+	-I../src/include/ -include ../config-host.h
 
 all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register \
 	       io_uring_enter nop sq-full cq-full 35fa71a030ca-test \
