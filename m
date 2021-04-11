Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA1D35B104
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhDKAvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDKAvK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:10 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A14C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:55 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h4so225038wrt.12
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oURJzJslfzYzQ4+aiFzHbKsvxnMqH+O6KnjlEySi2JA=;
        b=aC+8geURe2bANAuAiAEBg+LVTxnX0v7mzmrSZZZ1b7JkDKtocnE+g9eoMWYUkHF6RT
         QaYQozpo7cDstBMHYsUo/WtG8HwCECClW152S0jhMUPKbnGsxLbbC/kCx29FpXHQ2Gcf
         h1F7dzZMQ1qBSJYlFDX/CKUbytkG7Yd4JmHSOQvYmKPV4zvZgzQokFEMfrJsIfHfLWkH
         Kimd3jNJWQ1goXtQRpsV/WazFynzl1I9XwcXlD2IIA926N5sQPjR+SbkYfKkXBMDVAb4
         PazW7Otwzug99HDqTvUVzryHm4G/dwbikfuPAc/nW7QeNzU+VclGutv4BoLPEx5YLkgd
         mjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oURJzJslfzYzQ4+aiFzHbKsvxnMqH+O6KnjlEySi2JA=;
        b=OZFwdCQ+4IwdUrB1iC4mouVRPHFEP/Lwnx6NfcJFWDRH0LG2XWwrNLkvgOt1uBgeuJ
         eKNGgC5D+wwZhtye+cU4Z8XpKvIYCYRmfal5C7vsYgFnOolimKNAm7msBQAhP22Q51Dr
         49HpIi5ADc6jj9q7/Vv66fkKZKguaL56Zo/802HCFgSXX3tDd9cz8ERj+hWWusDztHBl
         cDfIBzcEke0fHfn2BXkY7uEj++R6jjwIRsrpEmzOovoeFgCdEPPcCZ4h0Y3E5Cx4jhNS
         FQb5w224rbx6ax8KMijOYzQeEyBwYoJBFWzWJcnQeCqB5CXeUFDJSvw6AwFsiltBHEW4
         goAA==
X-Gm-Message-State: AOAM531qLa12J6nHr78T3B04dIZDX4QfoMrNRvZDSbaX+gngQ2ckJWy1
        e80qv3leOuuC7POA2a2XapQJV2O0PdBcIg==
X-Google-Smtp-Source: ABdhPJz5R/qlzoR4o9b3vv9CDViISgXbsE99zS0ATmU5oK5fH80FM9LeibNQTIet+267KZP8LC0gHw==
X-Received: by 2002:adf:f3cf:: with SMTP id g15mr24455904wrp.414.1618102253716;
        Sat, 10 Apr 2021 17:50:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 00/16] random 5.13 patches
Date:   Sun, 11 Apr 2021 01:46:24 +0100
Message-Id: <cover.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-3: task vs files cancellation unification, sheds some lines
8-9: inlines fill_event(), gives some performance
10-13: more of registered buffer / resource preparation patches
others are just separate not connected cleanups/improvements

Pavel Begunkov (16):
  io_uring: unify task and files cancel loops
  io_uring: track inflight requests through counter
  io_uring: unify files and task cancel
  io_uring: refactor io_close
  io_uring: enable inline completion for more cases
  io_uring: refactor compat_msghdr import
  io_uring: optimise non-eventfd post-event
  io_uring: always pass cflags into fill_event()
  io_uring: optimise fill_event() by inlining
  io_uring: simplify io_rsrc_data refcounting
  io_uring: add buffer unmap helper
  io_uring: cleanup buffer register
  io_uring: split file table from rsrc nodes
  io_uring: improve sqo stop
  io_uring: improve hardlink code generation
  io_uring: return back safer resurrect

 fs/io_uring.c            | 386 ++++++++++++++++-----------------------
 include/linux/io_uring.h |  12 +-
 2 files changed, 163 insertions(+), 235 deletions(-)

-- 
2.24.0

