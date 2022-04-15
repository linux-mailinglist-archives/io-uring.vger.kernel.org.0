Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F562502AE5
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiDON1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiDON1M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:27:12 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565C6186D3
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:24:43 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 2so7637085pjw.2
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=/0ucfi1fHgao2WEXOWgxYBbPcaoI6nX+P2dzyIICVow=;
        b=6vmDjKAzRV1wwdtQHqz4/cBNku64uAEECcAhgz06JHEksA0Z0WY9xq7AnnUH/Dg4F2
         OX99fZNnozbcDeAHN2VdY/axnuqr/DomF4slicOi7tKZ4pPs1rkRfaZzDNDqW4fLl7M9
         JJQKRu6J5osgIRC21fplPq7wQnBPf1WhKbVAsU6UAKq8nqX3+51OXQ78XokRWy0thVgd
         js/SryqzKW8vpGtKYm08J1EEgGCoxISplrGeKyFnUsWpPDI5Yd3g/KoPWlh6IcSkrJL6
         /lty/G/XTidrHjSiubujRYkiM9yP6NcLSGHVk3VPsmFfS0o8GEsnEsU8hDGR9RA/Ic8T
         wZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=/0ucfi1fHgao2WEXOWgxYBbPcaoI6nX+P2dzyIICVow=;
        b=JVjgOUjuCcYAulqYRf0OTls0ZNobq5INpawFhLcRs/vmxGHRUsiZRlE4XG/PT61g0d
         Hu7caZ97N8uGZtQ8oEDEBBma6SoW5NCg6gTuDC6fd5t5PufrculhTsN+b+iefUBNiEEX
         7RtQCmDEFEdS7iSxljvTd1efYGPikGnbnnLJo3qVGFiMbN0aRn7Qc/v24wn43sOhC8Df
         1PES9UL7TB+UkcU38CMvTOOVqP21Je2NuGz6EF1eLZUyc4ymUj4gcEpcXeJcOKAr6JKG
         +Wrepfz5rofyhYebCGmLZ9ErSJ/xiQ4OEpsaaZRUIqo23F/OYBS61wPnJoi1djHm19y4
         dtxQ==
X-Gm-Message-State: AOAM530fK7Jmp2Ca12UYuPJ0lErC49Xm/qPOablkyFqjxWl2eLL5xldF
        pN+bzUxwoWgTLtfWH55DeDiYWkDmk18s1g==
X-Google-Smtp-Source: ABdhPJyj2NZLszPtzzCxm5Hd5Z4NPiQ3kLJfB31K2JOBcvTTwVUIy6t6S7BthfQMSWyrdXeMZm5qNA==
X-Received: by 2002:a17:902:8ec8:b0:156:847b:a8f8 with SMTP id x8-20020a1709028ec800b00156847ba8f8mr53018530plo.121.1650029082705;
        Fri, 15 Apr 2022 06:24:42 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y3-20020a056a00190300b004fa2411bb92sm3143519pfi.93.2022.04.15.06.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 06:24:42 -0700 (PDT)
Message-ID: <948f7d10-526e-206b-6014-2654b5170d56@kernel.dk>
Date:   Fri, 15 Apr 2022 07:24:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.18-rc3
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

- Ensure we check and -EINVAL any use of reserved or struct padding.
  Although we generally always do that, it's missed in two spots for
  resource updates, one for the ring fd registration from this merge
  window, and one for the extended arg. Make sure we have all of them
  handled. (Dylan)

- A few fixes for the deferred file assignment (me, Pavel)

- Add a feature flag for the deferred file assignment so apps can tell
  we handle it correctly (me)

- Fix a small perf regression with the current file position fix in this
  merge window (me)

Please pull!


The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:

  Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-14

for you to fetch changes up to 701521403cfb228536b3947035c8a6eca40d8e58:

  io_uring: abort file assignment prior to assigning creds (2022-04-14 20:23:40 -0600)

----------------------------------------------------------------
io_uring-5.18-2022-04-14

----------------------------------------------------------------
Dylan Yudaken (4):
      io_uring: move io_uring_rsrc_update2 validation
      io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
      io_uring: verify resv is 0 in ringfd register/unregister
      io_uring: verify pad field is 0 in io_get_ext_arg

Jens Axboe (5):
      io_uring: flag the fact that linked file assignment is sane
      io_uring: io_kiocb_update_pos() should not touch file for non -1 offset
      io_uring: move apoll->events cache
      io_uring: stop using io_wq_work as an fd placeholder
      io_uring: abort file assignment prior to assigning creds

Pavel Begunkov (4):
      io_uring: fix assign file locking issue
      io_uring: use right issue_flags for splice/tee
      io_uring: fix poll file assign deadlock
      io_uring: fix poll error reporting

 fs/io-wq.h                    |  1 -
 fs/io_uring.c                 | 98 +++++++++++++++++++++++++------------------
 include/uapi/linux/io_uring.h |  1 +
 3 files changed, 59 insertions(+), 41 deletions(-)

-- 
Jens Axboe

