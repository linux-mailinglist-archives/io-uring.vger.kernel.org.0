Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6A438345
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhJWLQ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJWLQ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:29 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13512C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:10 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso6811167wmc.1
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QgDodxneIFX9AAjOqQQRfc1V9vfhQuhXANcAUBynZl4=;
        b=X1PWltNisPoh/qAxmaJ8QpI/+9JMyXYb6ufiL1p9Y1R0X9cRf20Y221Y/L/yZyJJ/w
         nUF66QTspml2zRnAqnZ6qoPJW4zYu8t+zkme/U/6RI6A4J5tOTdc2djV162dDRnRF8O2
         rki1qyOFXNKUgbtlAKRMN2GOeLacBPvdAu1vMNMxhJBjk14Az0+1iZ5jmRwJ7uf/Q30D
         b0P73ox9VoF5iA65HQTTFusLrszg86VXX71NgX72dX3T3cHbY7Yogsj7ILS2CCR25zsj
         w9xwzduiFoH3Rv236YXCkRAcsj4PfeLK8LrA73OkjtBEp3WEeCUX13QtuPaBrUe4VqEF
         iDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QgDodxneIFX9AAjOqQQRfc1V9vfhQuhXANcAUBynZl4=;
        b=UK0iyl9ZCcXZcUQu6ZbcR8NYTwSfW6+V+dNW6mozrHuvML9CB2uuYfm0M+EC1csc3U
         9viBjlx6RXxFrWXzQUK3qkgTB8bnq4LMeB81hbSl2ZYU0zuCCM+M5NI+t/yMgU/hWYm+
         vosIQz5AE/pWpX7qJFObAy809OK8JkNGzgzmAEwTmATksxMHcFdmm4/h0oZ47pJNHTGn
         ohZH6Q/wyQri2JIzqQuLRms6PHjy7iMeRb2J2azazfyNVtra1OCMoQhQeT7V7xBX3Fin
         5iohZDLwVXS+ZXvmNTS80WhRTzX40lZvnPes49+/xzKJb9CBxZoxuz20CRkL6rnki0nW
         zvlg==
X-Gm-Message-State: AOAM532DCawk7zCUJC78B92bwxobWU2X0oPstOSOqBpssoIk3PhZ4FAl
        uvJU5EuloMCVqdzrTqoUBjYcv0cJmo4=
X-Google-Smtp-Source: ABdhPJzaUdbNXevv8cE6afXtGemEpf4ZnWXSb+DnVjiZNlux4YLNBP2DNB7KBBqbz/qSSeH5dCWXXw==
X-Received: by 2002:a05:600c:1c8e:: with SMTP id k14mr34860102wms.27.1634987648344;
        Sat, 23 Oct 2021 04:14:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/8] for-next cleanups
Date:   Sat, 23 Oct 2021 12:13:54 +0100
Message-Id: <cover.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let's clean up the just merged async-polling stuff, will be
easier to maintain, 2,3,5 deal with it. 6-8 are a resend.

Pavel Begunkov (8):
  io-wq: use helper for worker refcounting
  io_uring: clean io_wq_submit_work()'s main loop
  io_uring: clean iowq submit work cancellation
  io_uring: check if opcode needs poll first on arming
  io_uring: don't try io-wq polling if not supported
  io_uring: clean up timeout async_data allocation
  io_uring: kill unused param from io_file_supports_nowait
  io_uring: clusterise ki_flags access in rw_prep

 fs/io-wq.c    |   3 +-
 fs/io_uring.c | 115 ++++++++++++++++++++++----------------------------
 2 files changed, 52 insertions(+), 66 deletions(-)

-- 
2.33.1

