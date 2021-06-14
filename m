Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2273A7228
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFNWlL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:41:11 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37496 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFNWlK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:41:10 -0400
Received: by mail-wm1-f54.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso418648wmg.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2cSxfPrdyNMqj2IdtXAgOTjeegPn3JW6UX1ZSYGPOSg=;
        b=Mu9on9Ktv4J0Ocwn/ICQvsT1vcpWE7gYA+Gqzt741LSEhnj9k4dvTu0l3BbqhbBVHa
         I7fPUqHwG9iS1Qrq5qGuZ7v5IftOx+ApBBZtbrlcVciIv064I9+ZbakX7wczx+vqFeg7
         cExuTOCwwLfcqEXdUTbnX0buT/x1DNq6rTcJED5vDS3dGRrRuMt7ZPkGpHUEk1prmoks
         zJJGmDm57NGvPgWdPLRIvX6VNgKJ8Zy9hXzH0yDRzAAFME68WvzynojBAMg/h0b62M8B
         ZCLEeRUvmFoUSW0QFYwdbsbFYSF4siZpJTUf7nwvreiQ+VED3iFR28hGpSO2c7J1rgr8
         qRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2cSxfPrdyNMqj2IdtXAgOTjeegPn3JW6UX1ZSYGPOSg=;
        b=M8z2ZmO4CMVbv3f35oTrl2nLrYNLSu4ozpDRAYvowBo+SvgqAyPGZWJS9jcdYFqrUS
         5FM5wnU7BrfZfbWvlcY/x4IkxR2INHIbi69m+4fE8urbAdtd8Tz8N70RXAjLcwS65DJ8
         cwdh5vPzFqfwSJ4wYtKCVuTMZ834oxzMFXejLJFVaC3lw3R7RN9VhRq18Sp6U/+7FsgQ
         15RRNmKA+6WBHIEHEWrXh0OQrbJ1qBuK0Ev3aBNj9TVtzLK7bn57zJXTXUTC6DT/Mq+v
         XFLeENBMwpTN7qrUZsXqWF8vLLqCMFYZrILUolGLLCRpGOYJCukU73qOraY7BUXuteJa
         t+TQ==
X-Gm-Message-State: AOAM533BuzaxOYDQT86fw+rscerJkcTiegJhPjaz4KjhtQbN1GyvDhjX
        5orvqjZF1wEYYdsNLbOkXKpQbeiHySI5ZHdx
X-Google-Smtp-Source: ABdhPJz0+b37zbwQgiLOjNPJGYYp0rQ7niOFmfY8Vz/XM/UEniZHgmmKmomdCxhJtM8Nf2JqxBvi3Q==
X-Received: by 2002:a05:600c:3b13:: with SMTP id m19mr18914203wms.53.1623710270582;
        Mon, 14 Jun 2021 15:37:50 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.14 00/12] for-next optimisations
Date:   Mon, 14 Jun 2021 23:37:19 +0100
Message-Id: <cover.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two main lines intervened. The first one is pt.2 of ctx field
shuffling for better caching. There is a couple of things left on that
front.

The second is optimising (assumably) rarely used offset-based timeouts
and draining. There is a downside (see 12/12), which will be fixed
later. In plans to queue a task_work clearing drain_used (under
uring_lock) from io_queue_deferred() once all drainee are gone.

nops(batch=32):
    15.9 MIOPS vs 17.3 MIOPS
nullblk (irqmode=2 completion_nsec=0 submit_queues=16), no merges, no stat
    1002 KIOPS vs 1050 KIOPS

Though the second test is very slow comparing to what I've seen before,
so might be not represantative.

Pavel Begunkov (12):
  io_uring: keep SQ pointers in a single cacheline
  io_uring: move ctx->flags from SQ cacheline
  io_uring: shuffle more fields into SQ ctx section
  io_uring: refactor io_get_sqe()
  io_uring: don't cache number of dropped SQEs
  io_uring: optimise completion timeout flushing
  io_uring: small io_submit_sqe() optimisation
  io_uring: clean up check_overflow flag
  io_uring: wait heads renaming
  io_uring: move uring_lock location
  io_uring: refactor io_req_defer()
  io_uring: optimise non-drain path

 fs/io_uring.c | 226 +++++++++++++++++++++++++-------------------------
 1 file changed, 111 insertions(+), 115 deletions(-)

-- 
2.31.1

