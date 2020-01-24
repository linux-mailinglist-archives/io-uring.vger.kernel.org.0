Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36D7149045
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAXVle (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:34 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54162 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXVle (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id m24so862395wmc.3;
        Fri, 24 Jan 2020 13:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/EsbjcVb4PmLGRLOo4fjDzsj8rqTy2jhH7Fz+a3ZxRc=;
        b=oa+WtCJ31Uz1BR4ovJRn1Zi+muTQzhyp2T9r/dW7Nf0OUWHusjmLqp+7pbXQC8sfVJ
         GrENv/9NvCSTheeJB0sBthWf7YHa3k+khLXevx3gC4dtrwKnNcUO2nVGxMVRWE633B8k
         0xCBMLmR5JkFLuvzMMaU4uzXKJj8RodJUNeFYgKq8y4dgRvFCiSLfsVkIzwqrGeH+fxv
         wJnemeuyBiFv248KtxH27DIHqzHFs3tYB+dyLHaoawq0RCMFSJUrtTK8nX14pDFkhva1
         XBCKn1oTagq5mEOA0GT+qF0nXBudBxLI3Doj2Hcg80FlU/McvL+ZFW+c7Q4aev+ly8fq
         jMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/EsbjcVb4PmLGRLOo4fjDzsj8rqTy2jhH7Fz+a3ZxRc=;
        b=kkLZ5e8gTK2h7vDA4DlrovAJpTQ8Lk7YQhisi3xnpprl+AFoQ7p4g0w6MbcVAc2OtC
         5Skp+hEq396BWWpZrYoS/UVtGSsF1XQMLF8kvfUjLYoINTv0tGINOuqalYc1Pdh8YLOG
         uEmMVOqpR5wDN31h3/udQ/TFRWbR6ovl9S/yaOSZpDo/iDuZ7Sn8IYo9WPbeVCzuuHBR
         tRgJEPlT+mD/590+Lj476rqn9s4Rj18zG7cLd/I+tu6vbA8HIffBlX23DnF2dVjLEer0
         2vW7ovjKYv7CJCt14Hl0hR7GtcAivDl3I7cUlyH7X5BCPgfSGjjFBeNDBJ+Cw5CiFcRJ
         bzYw==
X-Gm-Message-State: APjAAAViMlFxx7HGbokehYo21exMcAXb8bSKCjCGNauarD4yP8J73RB4
        TkAuNXrLTZccEzGh39E7e6M=
X-Google-Smtp-Source: APXvYqx4VvdpPSIfrO0uupxkHeIYQI3sjLG71kvVEmfWa4hlWQ0HPHrwtVelkpyXUKiofkIoMlKccQ==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr1044410wmc.111.1579902091904;
        Fri, 24 Jan 2020 13:41:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] add persistent submission state
Date:   Sat, 25 Jan 2020 00:40:23 +0300
Message-Id: <cover.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apart from unrelated first patch, this persues two goals:

1. start preparing io_uring to move resources handling into
opcode specific functions, and thus for splice(2)

2. make the first step towards some long-standing optimisation ideas

Basically, it makes struct io_submit_state embedded into ctx, so
easily accessible and persistent, and then plays a bit around that.

Pavel Begunkov (8):
  io_uring: add comment for drain_next
  io_uring: always pass non-null io_submit_state
  io_uring: place io_submit_state into ctx
  io_uring: move ring_fd  into io_submit_state
  io_uring: move cur_mm into io_submit_state
  io_uring: move *link into io_submit_state
  io_uring: persistent req bulk allocation cache
  io_uring: optimise req bulk allocation cache

 fs/io_uring.c | 219 +++++++++++++++++++++++++++-----------------------
 1 file changed, 120 insertions(+), 99 deletions(-)

-- 
2.24.0

