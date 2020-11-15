Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659732B33BF
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgKOKjP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgKOKjC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:39:02 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC8DC0613D1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:01 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id j7so15484300wrp.3
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJcvJ/0p9B6njuuB9woRilfmH78V855R25GxqpyZcug=;
        b=rVgYude8N8XsL1pL3VXkB+PaaevKuTPw7QtbvjPhNsQrNku+V+Ux2Fle5gJs6HsOKB
         YJPblDwLuEGylFBNkIsxJbuTRtS3IrpfsVtwCerMjvAyDyq2mjwbQfa/bWsUx0s5m5ZH
         YMrJwPTvSNFbW6HwLdGCaS58GQaXvp+unQKgfZCbGOrZloJET/j85UbEZ2zLggfeidHV
         4DWi0NMc0zT2bU3wZQX4UzZT6cY9zM+VWkZJ/NCjhQdm1rlySjP0oG0AMPQDo02M1wud
         r6LQplcqHSom//Dy0o/IdeUY42eTUIKY4qmnYi2NzPARwzl8o95+YfQ9a9btCq6WLVFW
         i85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJcvJ/0p9B6njuuB9woRilfmH78V855R25GxqpyZcug=;
        b=fj34W+zkKS9E3r5ORoYwVwlJsQTQJu0fR3QcpKIk17HAU4cx3/aNZzOPZhGRxNgZRc
         watL/RVcKdoeIWKKB9cS9WGUz07pA+ukngYM37aM9uJRuKonNs/+BNlTXq2OcZ2aByEG
         VxdHSUHIVkxAk3tmf9MpJAh0iJ+bcoMn9DLsWMvj46QqWebDpp0FkVnEIEeCzpr64KWf
         LtwLUkvkJoxvXHg0vVXxd4wkKmIvleGtQyGOO1T12nGk04oikTifT549F8ABMLZrT4F1
         8M99CdHNcC5VHqZgtxqTWk7IqVNXh2/rjhOnfpVzvyl/7+nDE+8O3jz00gjCB/sGYwRf
         UNpA==
X-Gm-Message-State: AOAM532qKSa9PSJ5yZfIbIcfCVTCpCmis1ZmaYIBCmnJc9Iuy8qAdN0L
        sBUQaVCiy9La0c7YRSgukUs=
X-Google-Smtp-Source: ABdhPJzsBuzJENY5C6NdxgXl+jbDmzRSa6HvS4/vHqKDdrNquleInEuYxz/SZ4fDuvjG+3Hko6i09Q==
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr13603069wrn.15.1605436740589;
        Sun, 15 Nov 2020 02:39:00 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm17790900wrs.46.2020.11.15.02.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:39:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        v@nametag.social
Subject: [RFC 0/5] support for {send,recv}[msg] with registered bufs
Date:   Sun, 15 Nov 2020 10:35:39 +0000
Message-Id: <cover.1605435507.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

By passing IO_MSG_FIXED with msg_flags teaches send(), recv(), sendmsg()
and recvmsg() to work with registered buffers. In that case
sqe->buf_index should contain a valid registered buffer index, and an
iov or an immediate {ptr,len} pair for recv/send have to point to a
buffer as it's with rw.

As unused bits in msg_flags are never checked by the net stack, I'd
probably need to flag it somehow else.

That's mainly for interested to toy with zerocopy, thus RFC, though may
be useful regardless. Based on 5.11 + 2 my send/recvmsg cleanup patches
of the same day.

Pavel Begunkov (5):
  io_uring: move io_recvmsg_copy_hdr()
  io_uring: copy hdr consistently for send and recv
  io_uring: opcode independent import_fixed
  io_uring: send/recv with registered buffer
  io_uring: sendmsg/recvmsg with registered buffers

 fs/io_uring.c | 321 +++++++++++++++++++++++++++-----------------------
 1 file changed, 171 insertions(+), 150 deletions(-)

-- 
2.24.0

