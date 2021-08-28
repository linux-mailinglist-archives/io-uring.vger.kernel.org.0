Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D043FA726
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 20:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhH1ScQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 14:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhH1ScP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 14:32:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A897DC061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 11:31:24 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b6so15702004wrh.10
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IgHEVqFatwCA/3LEei71/wao4/kB6wQeGywkiGxjXeQ=;
        b=Z8LFUsryDXL2WB8iK6fiXeo2fzLgVxVF/0yIESpJGCuWwV7RA/Rrw/1BtI3+AjrqBI
         4VYK1ANfQtD/MZZrPkD2MJKigSVs7Ig4MPYH7YltNfobgjDMgbSMv2x4IMtiIDVyRi4M
         tt7aAV9aqPHLbL1Giblhu38eXpWK7avng87sNKhefgH1JCpETgvcsQ8iSU2vhfsvk3Nf
         D9gVnnvJ7KPIaAtxHBFRMRv2D8XUlQrpXnJdIt4j2fanpoGGtbhs0kgphAR5ZaLDSuvm
         y+CxrsVgVa49McnvTW5zXTL2TDcUITjQuUX+GU+uWbw3utP5n57JsYyrSPWGQdt4/UEi
         4NRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IgHEVqFatwCA/3LEei71/wao4/kB6wQeGywkiGxjXeQ=;
        b=ebjAJm5KPvdMAzRBKWbWKveC0ptt+0EJAensJHdRhFlrUGvFd/9ivff1yXpldM0yT2
         4+dgDAoh45G32m0/mEngmw3FTRc3jMY4thbVNaTIneFPy+PAdgtl8rQhBVF+4bRgEh/O
         RzCrRMKUMCh0z2Zxnn0ReWo5348GWbLgiaqOSDSgdWqRHcFhAmJG361BmcWdUSeGCx1X
         a/jL7dKHQU/pvz8QuGIA5unC/cpwGxA9V14bYtIYyYbimnvrVEmnRPcdNmmTEXIfLWvn
         oNl9dwPvie8KpcGbTVaSHXWrAfXqjRhrE8Sx1N8BKUOuTo/HiGH6ISZfpAdBAG8bCllG
         +IXg==
X-Gm-Message-State: AOAM533L0F1c9eraasyHCb0M/XRIDMWew5FfzV8VskffmyfE6KnVEin6
        8Rg0BcHpjU1vJ2dsIfsuV9r/+LPmjV8=
X-Google-Smtp-Source: ABdhPJyn6r3NJUaFAxrQpyRICOkbZjMNVm8BmHJQ/OwKvWPR3L0d+gatxBJtL6jKIbVMUfRs8YYL0g==
X-Received: by 2002:adf:c411:: with SMTP id v17mr16851703wrf.160.1630175483253;
        Sat, 28 Aug 2021 11:31:23 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.102])
        by smtp.gmail.com with ESMTPSA id b4sm9939275wrp.33.2021.08.28.11.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 11:31:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] man: fix io_uring_sqe alignment
Date:   Sat, 28 Aug 2021 19:30:43 +0100
Message-Id: <82fb889efbf3a7138a564eb10ce7c14d04227701.1630175370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630175370.git.asml.silence@gmail.com>
References: <cover.1630175370.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tabs make man to go crazy, replace them with spaces where it haven't
been done yet.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 00f0778..fc81099 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -162,18 +162,18 @@ struct io_uring_sqe {
     };
     __u64    user_data;     /* data to be passed back at completion time */
     union {
-	struct {
-	    /* index into fixed buffers, if used */
+    struct {
+        /* index into fixed buffers, if used */
             union {
                 /* index into fixed buffers, if used */
                 __u16    buf_index;
                 /* for grouped buffer selection */
                 __u16    buf_group;
             }
-	    /* personality to use, if used */
-	    __u16    personality;
+        /* personality to use, if used */
+        __u16    personality;
             __s32    splice_fd_in;
-	};
+    };
         __u64    __pad2[3];
     };
 };
-- 
2.33.0

