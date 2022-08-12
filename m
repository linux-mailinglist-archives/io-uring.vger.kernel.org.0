Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A4E5910E7
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbiHLMqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 08:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiHLMqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 08:46:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6B796FC6
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 05:46:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so826214pjk.1
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 05:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=+nXFXQUbpvgVOf2q0sAH5LfCgd9gu9OSlMgG3d66SjU=;
        b=k7N7ouuEhrlUkShU8S+UtQmBZpEcJiV9m48zb3BezlZLEoLWh6w1kzaKFYSmti7YDU
         8SMFrcmsqCvg0v1jv3i+kFYn73jErS41K/fgKX2GXlrkoo8np5A0MthiKyOTGu+RFH5z
         A+xJooeC5uku/Ig+f1T2cavb20Qqyn8iY5FwQao6vUXnHk+zZZPdtU/TPsMeN7jB6aOi
         Prh9Am/Z9tLZzZtyhpTX1t2OpIRCHvhbnBcjKUh5icxJASdtiZP7nmCBa6rCmN1Sp3qA
         LJyWXT5NLpUtB0jBIsjx1PwaX6sH29V/C7NKY6zIk6xrF2tlJAwkhGkFrWXeyjJoOpOI
         oBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=+nXFXQUbpvgVOf2q0sAH5LfCgd9gu9OSlMgG3d66SjU=;
        b=o95W+PVnFt1IS3CR7+glJ0nbY4kWK7TkwcZXlnvhpImZgIQusNR8VqXejyFRi+MRSD
         tMqUOqwa5CCVJhZltYkqZ1PvcTnCB5qbAhZKA8Y/Orf01pI1X1bcyOZxwllwsi0joh9s
         Ha7u0miB2KEO2NB2nlq0aiSX5DyLbz6i2zdfgnomtN191nkepFS9eoyFUgTNx9d5/hHq
         wykntU99yvikjmFE+GHTQLRg09rPkh53QB7EBB9uwQq8cbzeHGrwfJiYpie4uhWHV0us
         9/ztFnd3plV0/HTL7m5GMV8z3RPsD06wyvE04byBnenDkSJuzLHwimDLoYGkNFlu1HMt
         lBnQ==
X-Gm-Message-State: ACgBeo38jsZfddiX0jeWcpRUgnqr6aAUOdyoaY1THoDOTqoJcvgh+WNA
        TEex8lryQF9hrAWBpDaOXMmlP64fs3KbRw==
X-Google-Smtp-Source: AA6agR6QBeO1eqy8eVwT1ltsX2en388HtlA/LLDwQgHAtprbSJ59p59NhJcIPWSh7NXyvUjROaWbOw==
X-Received: by 2002:a17:903:1205:b0:171:4f8d:22a8 with SMTP id l5-20020a170903120500b001714f8d22a8mr3841842plh.11.1660308378094;
        Fri, 12 Aug 2022 05:46:18 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z6-20020a170903018600b0016d2db82962sm1689403plg.16.2022.08.12.05.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 05:46:17 -0700 (PDT)
Message-ID: <b6f508ca-b1b2-5f40-7998-e4cff1cf7212@kernel.dk>
Date:   Fri, 12 Aug 2022 06:46:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go upstream before 6.0-rc1. In detail:

- Regression fix for this merge window, fixing a wrong order of
  arguments for io_req_set_res() for passthru (Dylan)

- Fix for the audit code leaking context memory (Peilin)

- Ensure that provided buffers are memcg accounted (Pavel)

- Correctly handle short zero-copy sends (Pavel)

- Sparse warning fixes for the recvmsg multishot command (Dylan)

- Small series improving type safety of the sqe fields (Stefan)

- Error handling fix for passthru (Anuj)

Please pull!


The following changes since commit e2b542100719a93f8cdf6d90185410d38a57a4c1:

  Merge tag 'flexible-array-transformations-UAPI-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2022-08-02 19:50:47 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-08-12

for you to fetch changes up to ff34d8d06a1f16b6a58fb41bfbaa475cc6c02497:

  io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields (2022-08-11 10:56:13 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-08-12

----------------------------------------------------------------
Anuj Gupta (1):
      io_uring: fix error handling for io_uring_cmd

Dylan Yudaken (1):
      io_uring: fix io_recvmsg_prep_multishot sparse warnings

Ming Lei (1):
      io_uring: pass correct parameters to io_req_set_res

Pavel Begunkov (2):
      io_uring: mem-account pbuf buckets
      io_uring/net: send retry for zerocopy

Peilin Ye (1):
      audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()

Stefan Metzmacher (3):
      io_uring: consistently make use of io_notif_to_data()
      io_uring: make io_kiocb_to_cmd() typesafe
      io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields

 include/linux/audit.h          |  5 ----
 include/linux/io_uring_types.h |  9 +++++-
 io_uring/advise.c              |  8 ++---
 io_uring/cancel.c              |  4 +--
 io_uring/epoll.c               |  4 +--
 io_uring/fs.c                  | 28 +++++++++---------
 io_uring/io-wq.c               |  3 --
 io_uring/io_uring.c            | 19 ++++++++++--
 io_uring/kbuf.c                | 10 +++----
 io_uring/msg_ring.c            |  8 ++---
 io_uring/net.c                 | 66 +++++++++++++++++++++++++-----------------
 io_uring/notif.c               |  4 +--
 io_uring/notif.h               |  2 +-
 io_uring/openclose.c           | 16 +++++-----
 io_uring/poll.c                | 16 +++++-----
 io_uring/rsrc.c                | 10 +++----
 io_uring/rw.c                  | 28 +++++++++---------
 io_uring/splice.c              |  8 ++---
 io_uring/sqpoll.c              |  4 ---
 io_uring/statx.c               |  6 ++--
 io_uring/sync.c                | 12 ++++----
 io_uring/timeout.c             | 26 ++++++++---------
 io_uring/uring_cmd.c           | 17 +++++++----
 io_uring/xattr.c               | 18 ++++++------
 kernel/auditsc.c               | 25 ----------------
 25 files changed, 178 insertions(+), 178 deletions(-)

-- 
Jens Axboe

