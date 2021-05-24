Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6150B38F679
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhEXXw7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:52:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21866C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:30 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x7so10575789wrt.12
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7KQWzZ5OvtGp/jF7rHxh/IoDrdiKRXeFCUKUedf0X4=;
        b=MmlsngL7UkMhR+rvz5tWBqNOQoELMh2KRlFdBw7DfuNb47BVfS6XZQ+3G+oM6/fHEz
         vjwucjLMvd40iihWPLLbgK9r1LoWHKQ3hrn49+uQ4q1WkHLuQGGNyh270/o/pt4XA8Mu
         te1CVp1+XOUeyz9F8unOagWqdIqqbcyKypFie8zd8wnuVyyvyo6U/3NTirKUavrqVubl
         Sgpqc6YH1fKIC26AckjLx6q46CQDpnU3nY5Em2UY20w+E8cO2K/2hFsvo40RNBBbKlLR
         758G++KbLDqyc6LGHsk50f0THsIgXRFd24uSpZm+X0CrR1b1IhNDYlLO1MP4gWFXQ+85
         t8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7KQWzZ5OvtGp/jF7rHxh/IoDrdiKRXeFCUKUedf0X4=;
        b=WS2GFwvQ3yUifan86A/W9qr1k0HAPnFGrFICz4PXAnNdnywjVED5mad6qG2RWzxW4e
         lzlEfCee756S1CPmvAP7mvjXsMrvaBD6uboVFheM58t+YSES8CMWijLYMm0CWJcdunC2
         NRgWX4tW1SA+xiM1ypHNUfrjcTdtOyuVZR7+LSf+5mgbPgDsS49rdGp6LG3AtRBU6gFa
         Qc8kXINxSOoSpQeyOmBnozBANWg+FYFN2Etrcmr1ei52rp0IQzPiukSvBHSUj2p6Z2U+
         kgZKHlvPXHTCJrEimuW2w2nm1tP48RyJDmQFPhtXnU0Udr6EZb2VQxApNjtmUgNhhpCQ
         urpg==
X-Gm-Message-State: AOAM531K9WDfFCbJxyEMCib/UX74/867GsOek4u7ZIaxZfRCd6uDopCQ
        8MTl8iopl1MQMPgQrFB+D1R0jE9Bc0L/Tzs4
X-Google-Smtp-Source: ABdhPJybmNa0zf0VU1DxVsxKSPz47jXTKLrMzUH3/pbZQg7MJ/FrhLnJUlhQggHvRijdOSvbXg6t8g==
X-Received: by 2002:adf:f687:: with SMTP id v7mr24145272wrp.185.1621900288768;
        Mon, 24 May 2021 16:51:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 00/13] 5.14 batch 2
Date:   Tue, 25 May 2021 00:50:59 +0100
Message-Id: <cover.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On top of "io_uring/io-wq: close io-wq full-stop gap" sent for 5.13.

io-wq cleaning and some rsrc-related technical debt. 12/13 is about
not measured optimisation, even though is already nice but targeting
future use cases.

Pavel Begunkov (13):
  io-wq: embed wqe ptr array into struct io_wq
  io-wq: remove unused io-wq refcounting
  io_uring: refactor io_iopoll_req_issued
  io_uring: rename function *task_file
  io-wq: replace goto while
  io-wq: don't repeat IO_WQ_BIT_EXIT check by worker
  io-wq: simplify worker exiting
  io_uring: hide rsrc tag copy into generic helpers
  io_uring: remove rsrc put work irq save/restore
  io_uring: add helpers for 2 level table alloc
  io_uring: don't vmalloc rsrc tags
  io_uring: cache task struct refs
  io_uring: unify SQPOLL and user task cancellations

 fs/io-wq.c    |  38 ++----
 fs/io_uring.c | 347 ++++++++++++++++++++++++++------------------------
 2 files changed, 195 insertions(+), 190 deletions(-)

-- 
2.31.1

