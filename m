Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1694B3DA70E
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbhG2PG2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhG2PG1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:27 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593C8C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:24 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id g15so7372686wrd.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBz3llATDRXlwmQDTJ02ro1q5DMnykNPomigzjBIdP0=;
        b=Oq3Xw7bTv/YGQzEZlauAyXHJ9IAP6jkTL2FZ0PUXdBu4CTF1YwdGROWlKuqyqHTvH1
         AuFVC6qo6Uh5WYCuG7HORPIoAIkQ3JsiH69SvHePNSYIPCl96Za6K92psdTd5B1FN/+T
         nQJvU8aIT6M6huOChSpk4BaJ+xbYy28AjlMkWduRAqdi97A55bUaHevjEvoBC7HTHNGH
         I/0rK0htN/2EJIMkdTKjt4sTuS5HF9pRYKudpaLCpoSjRuVFIt3Iq1MYEPTczi4hahJC
         /0ff4bMwkQ0MDehlGEj3HlKJJpgJWjTgDGMF0aC6bzSVLRzZGpw5BDUCVqGlmLi6hZ+H
         zjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBz3llATDRXlwmQDTJ02ro1q5DMnykNPomigzjBIdP0=;
        b=uJQ5GCUetvxuivvWpO6s8SGsPhWkBSb/qUPPfXckYnc7JFj37igcW1HEWb6b60hFet
         OiQaedSn1BAjeNKYPPsAVLjvR8kctsaPpS2HQprU5VHRDCDzVkzAXeJw26AKZs7MRit3
         nT+yeihBJic5k5wcRvqNLD6AukBIRPK6AdkGtvyBOj2KdWTPVgRDx5WXuDZSl1ZVkLoZ
         xQ1KmllZtXVZHGKoDoSb+XXaqeQK77ybx+U6/O09kR8wAB8eWojWm8NAYcFVqPnWInqn
         eL7yDcPe/DYenaZT1VlV7Gqba9qC3mnDauQ7QmXYh9j1vDYvmUp5sA2lg5byosEX+H//
         Dp7Q==
X-Gm-Message-State: AOAM530czsZDPHo1E41M+ykK3FxMaDZYUFyg0w8TJw1VYHyflE1P0qPK
        oX+U78utaFtRr3j4eO5fPd8=
X-Google-Smtp-Source: ABdhPJzGCNaswMVLIER9jduP1bvaLa16eeCrSXMMASmK+tkx9Op0dSn6Xr7BrKm/00hwdSKkGsCfHQ==
X-Received: by 2002:a5d:58d1:: with SMTP id o17mr5265902wrf.119.1627571182891;
        Thu, 29 Jul 2021 08:06:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 00/23] first 5.15 batch
Date:   Thu, 29 Jul 2021 16:05:27 +0100
Message-Id: <cover.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A bundled of small cleanups. Some of them are preparations for
future changes.

Pavel Begunkov (23):
  io_uring: remove unnecessary PF_EXITING check
  io-wq: improve wq_list_add_tail()
  io_uring: refactor io_alloc_req
  io_uring: don't halt iopoll too early
  io_uring: add more locking annotations for submit
  io_uring: optimise io_cqring_wait() hot path
  io_uring: extract a helper for ctx quiesce
  io_uring: move io_put_task() definition
  io_uring: move io_rsrc_node_alloc() definition
  io_uring: inline io_free_req_deferred
  io_uring: deduplicate open iopoll check
  io_uring: improve ctx hang handling
  io_uring: kill unused IO_IOPOLL_BATCH
  io_uring: drop exec checks from io_req_task_submit
  io_uring: optimise putting task struct
  io_uring: hide async dadta behind flags
  io_uring: move io_fallback_req_func()
  io_uring: cache __io_free_req()'d requests
  io_uring: use inflight_entry instead of compl.list
  io_uring: remove redundant args from cache_free
  io_uring: inline struct io_comp_state
  io_uring: remove extra argument for overflow flush
  io_uring: inline io_poll_remove_waitqs

 fs/io-wq.h    |   2 +-
 fs/io_uring.c | 531 +++++++++++++++++++++++++-------------------------
 2 files changed, 268 insertions(+), 265 deletions(-)

-- 
2.32.0

