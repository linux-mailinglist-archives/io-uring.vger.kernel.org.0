Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B299200D88
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390399AbgFSO63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 10:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390388AbgFSO60 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 10:58:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1707EC06174E
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 07:58:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j1so4540469pfe.4
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 07:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sCfJ6MRetCzZa1NZ4rYQiXY2G31ZEnc/4E26KrcXmPc=;
        b=QZny18/SqgE+neIyWHL2sFRFJb8lqyjueOj1pOy0V6d5j1S3n0MqvWbGeu8El0o0Ta
         5ZnIo2kqLVpAH/4d2CBUPD4VdDtyc0/z+gGARF4rUK2nkQcNLTp3k28lsHUOhK+Z9OK4
         IkVvVNV4LnsjKA/z4ShCGiz6AQIKy7NAdxEM5Fe4iz6FuNb//7bYw1G2OrSaIS4aYIae
         fCB8jWF5VbztYAjw22xKsMZtPTGl7u88wjU6jOuilHqfCXeJO5pEZBXZ+Urh22haijfT
         Ku1nbjvpIbBROK7jqUbSbnu7xfDgB4b4b7Z5zPRyf9xr1BGnUsB1iMJFdTLwrbHzF+kM
         wC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sCfJ6MRetCzZa1NZ4rYQiXY2G31ZEnc/4E26KrcXmPc=;
        b=am9L1usQjdaRzOK8KunsIP3b/1vvzs7daeetaMiymvRDMZxRGTMClBuq9Q7DAj90O2
         zocGjuQqE4u+FSkIudi/PXjujrLlZLdv60ss11stD0Q5GOEnAOkbQV+xS3JioaxRzCBL
         29PVuxC6sKz+iTeYFzPD/3N0KUnhTrATEaCVLM8Tn7RD/uV26yfuTCx0jqYogscPouKA
         qubD33pUuA5qpT2u3KNJRH0jh6zknGsUj7pHi/kmg8ri3PBW0oBLHI2BuHgzdBaCvQqT
         zqKMDI5q06DCXpMCFJHIakgXMSgF0wvY8HBotIJg/dIxskzx5sJxyZIzSGSjuYOt0ut8
         eTUw==
X-Gm-Message-State: AOAM530c9CXRRvLBIePn0TonhnFftA13JufvmQsOlck0d843MkHlrJnP
        7gmURdrSwDo4xA+T2VrhzgEgXkJO9novZA==
X-Google-Smtp-Source: ABdhPJzR2GkfaR9ElBMnp1MlDz7n7rV5CEI7/KJfOSG2rVMrYC18qTlMIAVyZ7fTrcf1jTVRAlwiOw==
X-Received: by 2002:a62:aa07:: with SMTP id e7mr8097875pff.87.1592578705575;
        Fri, 19 Jun 2020 07:58:25 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p19sm6251000pff.116.2020.06.19.07.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:58:24 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc2
Message-ID: <bf5c364b-aaf4-ed48-4f52-07304d6e732b@kernel.dk>
Date:   Fri, 19 Jun 2020 08:58:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

io_uring fixes that should go into this release:

- Catch a case where io_sq_thread() didn't do proper mm acquire

- Ensure poll completions are reaped on shutdown

- Async cancelation and run fixes (Pavel)

- io-poll race fixes (Xiaoguang)

- Request cleanup race fix (Xiaoguang)

Please pull!

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-06-19

for you to fetch changes up to 6f2cc1664db20676069cff27a461ccc97dbfd114:

  io_uring: fix possible race condition against REQ_F_NEED_CLEANUP (2020-06-18 08:32:44 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-06-19

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: acquire 'mm' for task_work for SQPOLL
      io_uring: reap poll completions while waiting for refs to drop on exit

Pavel Begunkov (7):
      io_uring: fix lazy work init
      io-wq: reorder cancellation pending -> running
      io-wq: add an option to cancel all matched reqs
      io_uring: cancel all task's requests on exit
      io_uring: batch cancel in io_uring_cancel_files()
      io_uring: lazy get task
      io_uring: cancel by ->task not pid

Xiaoguang Wang (3):
      io_uring: don't fail links for EAGAIN error in IOPOLL mode
      io_uring: add memory barrier to synchronize io_kiocb's result and iopoll_completed
      io_uring: fix possible race condition against REQ_F_NEED_CLEANUP

 fs/io-wq.c    | 108 ++++++++++++++++++-----------------
 fs/io-wq.h    |   4 +-
 fs/io_uring.c | 177 +++++++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 177 insertions(+), 112 deletions(-)

-- 
Jens Axboe

