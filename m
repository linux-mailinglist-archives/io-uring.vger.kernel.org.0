Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A819021C84F
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgGLJnI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F49C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:07 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z17so8148564edr.9
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFjbPy/Zf0PhWsDOdfL74T5SBO6bNz9Vcbvl5aYBld8=;
        b=WXEz1EdO9qnHYi7saCFVsUl+3c+BuAuC6IC5SQZSn2whUUXjaJbt59bau9wKzai1Tf
         5YRSZT1aal4DylQvxfX9JjdLq7ml0iAZRotTHkh/aD5mIlV9dU5IFHKvhlJQvMrttHs7
         s5Ds6qf2Lxp2BDbxbMfnHFaaQUQ5UdPIW3qQUts1n43+PwDXXfEqAmlM2aYIkVEtGzcH
         MEh8ZjxQHUBEUoXPVpXtsQk+1zgMVrJYavEii0ul27rp5clW6hWc7ta/odz67uZt/t5q
         6B+XZgeNEQteUQqoX0J8OuHysmT1JHXW0b4IvnnDUirKPR2OF3bmWvqX0KDccC1+hRh6
         m74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFjbPy/Zf0PhWsDOdfL74T5SBO6bNz9Vcbvl5aYBld8=;
        b=f793RrkEe7ZfYG2aNyBZ9qy7Zo1zXBje96YGlYS1uWYW1C4ukqNSZYjDJPcXWwoYKP
         /yHfLfvNQ7Y3kv0utusEFKZupvSlilbMhFSnY2XNLbaA1d3FY6CiylgdxrmcRV3u+deP
         RA1s+AHC6S7IaGV9e7oAgVkrYe/0OZVLsvbDEzPZj6Atnd88hs3WbGxaQYrxvVbyQsDf
         h5kQI3K1YGOo1Y2Bwt6skQjXuyw5lsaivTHvJsOULFSj4OVDrIOoSK95YI3S+SgdAVvx
         jb2cXwXWOtojf+d205U4JauKAI+VJH4cX61SjgjjWhGXU0aSjov1O4aJrFO+wS37KVoo
         mAog==
X-Gm-Message-State: AOAM533FWKiv+49vSym9zM5dQ5Ia+25zgMVASxzuEKhZqmsrkDSc+O89
        eXb0L1BUJry20JVlh8newsyoJ6CB
X-Google-Smtp-Source: ABdhPJyEamIOZamanr3P6b6zqK+VaHemlY1v1yB1+OUflCzDa5/d/FmIdEMOTLUDt/GF4nva4XnwLw==
X-Received: by 2002:aa7:d744:: with SMTP id a4mr85439182eds.94.1594546986138;
        Sun, 12 Jul 2020 02:43:06 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 0/9] scrap 24 bytes from io_kiocb
Date:   Sun, 12 Jul 2020 12:41:06 +0300
Message-Id: <cover.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
drawback is adding extra kmalloc in draining path, but that's a slow
path, so meh. It also frees some space for the deferred completion path
if would be needed in the future, but the main idea here is to shrink it
to 3 cachelines in the end.

I'm not happy yet with a few details, so that's not final, but it would
be lovely to hear some feedback.

Pavel Begunkov (9):
  io_uring: share completion list w/ per-op space
  io_uring: rename ctx->poll into ctx->iopoll
  io_uring: use inflight_entry list for iopolling
  io_uring: use competion list for CQ overflow
  io_uring: add req->timeout.list
  io_uring: remove init for unused list
  io_uring: kill rq->list and allocate it on demand
  io_uring: remove sequence from io_kiocb
  io_uring: place cflags into completion data

 fs/io_uring.c | 188 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 116 insertions(+), 72 deletions(-)

-- 
2.24.0

