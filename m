Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A324DE3D1
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 22:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241231AbiCRWAn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 18:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbiCRWAi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 18:00:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF26F61DA
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 14:59:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b8so8428577pjb.4
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 14:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=vwnxuRTsLry+wPpRW6eu1MPClgUKeVBSKubmoYgGNTQ=;
        b=Vzq9gPLjzhDga2Rp0rNUq0ulWD88QjZG6UDb0rNmn1K6Z1fJ7KLgyJG9CSbVSXqeAv
         O0eQrdkifilY5t+twBfdzUIQwuEZStjDNmQjVfglsBw3PxAwlfCCE+SE7yoDKDIUYts1
         Szg/lt3aE4kD7xA2bZouNj7vxdtUxktHye0gUGjI0MIvJi9tqrlSN7lxusqtH6K1S612
         ZmU+tWeUjsdXjM4llB4lSbyogw/j04nqlv+83dFwGjtRsd7uu308V4L+HS05ykeigDs/
         iOHgBSvkRthIEeZwQMIjGcyUC0eYfIzNOmIEt2VdEcL6hYUGk5+2MQ1nqz1ik/PmVloF
         CZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=vwnxuRTsLry+wPpRW6eu1MPClgUKeVBSKubmoYgGNTQ=;
        b=4klWTSUBeDeQWYyqt3XOiYOz2J6+PDopn6rdgfzIqUuMSe6MYi1benuY8mrh47NBCi
         /r5NLfB1Ej5gv14W0pjAkCzAEJzilNAKBgwNP91/e8xMe99UKCoYc+jsDojG/vVJ6Azm
         B7/QYjTSuUkIAf/bS83eLGqXGqsg14GYGrqPYmuo7XMVvzm+9C6JVYlfUokY/XSXfOCg
         u9SM3XTHBWrJdRhKlCaSTmExwWruRMn2sskRGFhTlV6IPlPT5485Yl5Von88YwLWoW3S
         53U2X7/ZrU84qtP8hcicfAuOsNnioQiuOC2FOOGRJs0dFssCBwt7sOiVUfhMa9Pa8tmk
         XRcA==
X-Gm-Message-State: AOAM531/gG440OVYtOUTijznMkoy6ilbx23ZoJibDUf3ne9Tver7xV3f
        Ok/xLT1d2dLqUEUEU+OUNGkttONBmd5WaM+N
X-Google-Smtp-Source: ABdhPJz6tAfM030r3iGV9wKsKa4BWyGD9i/B+qA5XqWI6NUrR4LLTjuG6+ga4rGptr9au8V9+UIoaA==
X-Received: by 2002:a17:90b:3656:b0:1c6:b47d:f9f0 with SMTP id nh22-20020a17090b365600b001c6b47df9f0mr4897051pjb.235.1647640758226;
        Fri, 18 Mar 2022 14:59:18 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z198-20020a627ecf000000b004fa5e41ab2esm4598679pfc.186.2022.03.18.14.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 14:59:17 -0700 (PDT)
Message-ID: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
Date:   Fri, 18 Mar 2022 15:59:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.18-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

io_uring updates for the 5.18-rc1 merge window. This pull request
contains:

- Fixes for current file position. Still doesn't have the f_pos_lock
  sorted, but it's a step in the right direction (Dylan)

- Tracing updates (Dylan, Stefan)

- Improvements to io-wq locking (Hao)

- Improvements for provided buffers (me, Pavel)

- Support for registered file descriptors (me, Xiaoguang)

- Support for ring messages (me)

- Poll improvements (me)

- Fix for fixed buffers and non-iterator reads/writes (me

- Support for NAPI on sockets (Olivier)

- Ring quiesce improvements (Usama)

- Misc fixes (Olivier, Pavel)

Will merge cleanly. Please pull!



The following changes since commit ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2:

  Linux 5.17-rc7 (2022-03-06 14:28:31 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-2022-03-18

for you to fetch changes up to 5e929367468c8f97cd1ffb0417316cecfebef94b:

  io_uring: terminate manual loop iterator loop correctly for non-vecs (2022-03-18 11:42:48 -0600)

----------------------------------------------------------------
for-5.18/io_uring-2022-03-18

----------------------------------------------------------------
Dylan Yudaken (5):
      io_uring: remove duplicated calls to io_kiocb_ppos
      io_uring: update kiocb->ki_pos at execution time
      io_uring: do not recalculate ppos unnecessarily
      io_uring: documentation fixup
      io_uring: make tracing format consistent

Hao Xu (3):
      io-wq: decouple work_list protection from the big wqe->lock
      io-wq: reduce acct->lock crossing functions lock/unlock
      io-wq: use IO_WQ_ACCT_NR rather than hardcoded number

Jens Axboe (15):
      io_uring: add support for registering ring file descriptors
      io_uring: speedup provided buffer handling
      io_uring: add support for IORING_OP_MSG_RING command
      io_uring: retry early for reads if we can poll
      io_uring: ensure reads re-import for selected buffers
      io_uring: recycle provided buffers if request goes async
      io_uring: allow submissions to continue on error
      io_uring: remove duplicated member check for io_msg_ring_prep()
      io_uring: recycle apoll_poll entries
      io_uring: move req->poll_refs into previous struct hole
      io_uring: cache req->apoll->events in req->cflags
      io_uring: cache poll/double-poll state with a request flag
      io_uring: manage provided buffers strictly ordered
      io_uring: don't check unrelated req->open.how in accept request
      io_uring: terminate manual loop iterator loop correctly for non-vecs

Nathan Chancellor (1):
      io_uring: Fix use of uninitialized ret in io_eventfd_register()

Olivier Langlois (3):
      io_uring: Remove unneeded test in io_run_task_work_sig()
      io_uring: minor io_cqring_wait() optimization
      io_uring: Add support for napi_busy_poll

Pavel Begunkov (8):
      io_uring: normilise naming for fill_cqe*
      io_uring: refactor timeout cancellation cqe posting
      io_uring: extend provided buf return to fails
      io_uring: fix provided buffer return on failure for kiocb_done()
      io_uring: remove extra barrier for non-sqpoll iopoll
      io_uring: shuffle io_eventfd_signal() bits around
      io_uring: thin down io_commit_cqring()
      io_uring: fold evfd signalling under a slower path

Stefan Roesch (2):
      io-uring: add __fill_cqe function
      io-uring: Make tracepoints consistent.

Usama Arif (5):
      io_uring: remove trace for eventfd
      io_uring: avoid ring quiesce while registering/unregistering eventfd
      io_uring: avoid ring quiesce while registering async eventfd
      io_uring: avoid ring quiesce while registering restrictions and enabling rings
      io_uring: remove ring quiesce for io_uring_register

 fs/io-wq.c                      |  114 ++--
 fs/io_uring.c                   | 1251 ++++++++++++++++++++++++++++++---------
 include/linux/io_uring.h        |    5 +-
 include/trace/events/io_uring.h |  333 +++++------
 include/uapi/linux/io_uring.h   |   17 +-
 5 files changed, 1200 insertions(+), 520 deletions(-)

-- 
Jens Axboe

