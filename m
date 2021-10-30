Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F2D440A16
	for <lists+io-uring@lfdr.de>; Sat, 30 Oct 2021 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhJ3P7h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Oct 2021 11:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhJ3P7g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Oct 2021 11:59:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D13C061570
        for <io-uring@vger.kernel.org>; Sat, 30 Oct 2021 08:57:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o10-20020a17090a3d4a00b001a6555878a8so1482309pjf.1
        for <io-uring@vger.kernel.org>; Sat, 30 Oct 2021 08:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n7NOvXKyvRvFamcD6I/j+IA2DH1hgS6Vg7ghiKXeRGU=;
        b=g5NQwI/LkkhDVjSna1cJsCoY5gSB9CsvmVgyqe+1RQIMQK78H1+M7bBLfMBMrkLf48
         yd4W7yZ1ssm15qyg27NmPPRwiTJ2zBwb8bM49bAX2S1LfN1S+F4XEsWWw9DdnIoo87zo
         JQ+cNCQ+jeDUCvSfepOojdCPiHfCTddykD2WwsxnKxnnVwK2Yku+zvdxjrbynNGIj8Iy
         FaMIFwrC3on1tGAuszbxlUQPL0AAwlBxKfyPRRBgZEXLNj4lDU+ToGOqR+q0Ik+/CzBG
         qGBbJ+8ZfWy0ypiXLTLgxJxH6g1UfiZv/hislkaI8u21/yU2H9YHRirS9hLcQgCkxRTB
         pMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n7NOvXKyvRvFamcD6I/j+IA2DH1hgS6Vg7ghiKXeRGU=;
        b=UMAHGL4neTATFN2WDYmgW5oumDbw8MSDJ4gU6poqqnq4plo4MwApd7DTyEDQm4HIAW
         rxmUMyJDIGUue0C9IwPgnGMOCq//Ec9+61YGL71eAYHHW8jMtwwORYOjibZrx3ygGnMu
         HY0f7NkiOjUXXqruorZcqkn5myT0k3mp4jEJduN2MH+S5MHn5L8p7z+WuDpDlbqliERs
         AyjqYzTR8IpTy4jiWcxx6QM0fnSAvigQw7GEJfQD2/sJgfpx4F3vpQCNOAB1SJ3LiuNZ
         3RvAjYBDvkfzIj5HQce6St+DZ0JJs7th7eDo9mMg5oQm1bF9j97jkArwMiBblS9Ht7QX
         g48w==
X-Gm-Message-State: AOAM533t+QrsVuULxOSgektkDatVqtFm7JTtVSZS57agV9s/WrxSc5Or
        U7gupAboJfmOPcSN0sdcre8OuBhGOjota6+r
X-Google-Smtp-Source: ABdhPJy0ejnHBLX39zClTPsucxOJ02+Jsv/SxhbTpV6eacani3LRVvAZHb7q3FuFq3vAIACCdBvwAQ==
X-Received: by 2002:a17:902:e750:b0:140:5a4d:207a with SMTP id p16-20020a170902e75000b001405a4d207amr15604321plf.69.1635609426130;
        Sat, 30 Oct 2021 08:57:06 -0700 (PDT)
Received: from integral.. ([182.2.69.43])
        by smtp.gmail.com with ESMTPSA id z73sm2284818pgz.23.2021.10.30.08.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 08:57:05 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 1/2] examples/Makefile: Fix missing clean up
Date:   Sat, 30 Oct 2021 22:55:53 +0700
Message-Id: <20211030114858.320116-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211030114858.320116-1-ammar.faizi@intel.com>
References: <20211030114858.320116-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Several things go wrong with this Makefile:
  1) Using `test_srcs` to generate `test_objs`.
  2) `test_objs` is an unused variable. So (1) is pointless.
  3) `make clean` does not remove `ucontext-cp` binary.

I assume (1) and (2) were blindly copied from the test Makefile.

For 3, the `make clean` removes $(all_targets) and $(test_objs). But
`ucontext-cp` only exists in $(all_targets) if we have
`CONFIG_HAVE_UCONTEXT`. When the target goal is `clean`, we will not
have any of `CONFIG_*` variables. Thus, `ucontext-cp` is not removed.

Clean them up!

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 examples/Makefile | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/examples/Makefile b/examples/Makefile
index d3c5000..f966f94 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -10,20 +10,29 @@ ifneq ($(MAKECMDGOALS),clean)
 include ../config-host.mak
 endif
 
-all_targets += io_uring-test io_uring-cp link-cp
+example_srcs := \
+	io_uring-cp.c \
+	io_uring-test.c \
+	link-cp.c
+
+all_targets :=
+
 
 ifdef CONFIG_HAVE_UCONTEXT
-all_targets += ucontext-cp
+	example_srcs += ucontext-cp.c
 endif
+all_targets += ucontext-cp
 
-all: $(all_targets)
+example_targets := $(patsubst %.c,%,$(patsubst %.cc,%,$(example_srcs)))
+all_targets += $(example_targets)
 
-test_srcs := io_uring-test.c io_uring-cp.c link-cp.c
 
-test_objs := $(patsubst %.c,%.ol,$(test_srcs))
+all: $(example_targets)
 
 %: %.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-	@rm -f $(all_targets) $(test_objs)
+	@rm -f $(all_targets)
+
+.PHONY: all clean
-- 
2.30.2

