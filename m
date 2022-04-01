Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF254EFA6B
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 21:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351650AbiDATdl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 15:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiDATdk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 15:33:40 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A73176647
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 12:31:50 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id p21so4381099ioj.4
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 12:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=66oZ5MWTKaMAU9Hp/zUIEZTjyrg9yA8QBunpyvwl914=;
        b=DnuCS8jRk913lkcRtmZr6ybMsfESHE95m0QwBhii7bDALyByuzmhvxqpFZ2S08Z7Fl
         hobm/FmcW/AC9w8IxkV2mj9EFN598ojxubORJIcQ/cWRl3iOiuOntWElxoEWq+2ipKXI
         RvcSboAgwuWzWGoUyuJ5UbtIaj8JCuTOYyTL4uaF9kU1YpHkB/x4rK6aKW0GeuAWEAVM
         ZAl7n5/5nOD1Bcofpt6oaAHGkQ2nAhPRa4YzUGrgOxq9CZAhEBV0EpmKAahFFiJrlVvM
         d5/1qGi4hSd6ohwd/9y6XQwYmuJDM1Vq5GaywBz+nhhw9QNqMZxjkjp/Rb3K+ALl0TKK
         bCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=66oZ5MWTKaMAU9Hp/zUIEZTjyrg9yA8QBunpyvwl914=;
        b=k479Qp8SqfMYPOGC93+VoWtHphz+eMZjKFLexXEi9NTJve78pzoPWCBLN9t54FICDN
         uI5R/JjIGdICqa0ljTSkJKOK9v0Dvx5A77MaLwXjdY0l2WzAhvLudcn3U2up213lTRz4
         xU5/CRaFRTtL8cqh5o2jIf95znQik0BD1KeWwCQjKcJXlGymD2SwDxL6UZz5PxOwsEHA
         4zxcuT4zKjdYA/0+TykmHszUSB1A7orh92Ri2DB7261jwEjrl2CCBgW5tpjgLYpz4Ky2
         s9WCj0EKK2QnQwrd9ebmcfX/kowqNTOmpE7ibFBvutoY2+C7jnoeERiN4RkACfT2N33z
         QEaA==
X-Gm-Message-State: AOAM531W/odbYoWip5HkQWzRetGbBniWjYTvWQaoyXAB1mV5JHkhzA6o
        lT0CWzbX1t7QWKG/7Um89gaBUvGoWvfX007H
X-Google-Smtp-Source: ABdhPJw8OWa1vlG6pIioRw+fDb7a1C7Cd3lcT5QwL8IWBsV064BLgrpIx/joJD+o9mlOUAk69oauSw==
X-Received: by 2002:a02:c809:0:b0:323:94c2:219d with SMTP id p9-20020a02c809000000b0032394c2219dmr6337844jao.320.1648841509289;
        Fri, 01 Apr 2022 12:31:49 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm2224570iov.46.2022.04.01.12.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 12:31:48 -0700 (PDT)
Message-ID: <2589afe7-d581-167b-b404-066bdcead097@kernel.dk>
Date:   Fri, 1 Apr 2022 13:31:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.18-rc1
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

A little bit all over the map, some regression fixes for this merge
window, and some general fixes that are stable bound. In detail:

- Fix an SQPOLL memory ordering issue (Almog)

- Accept fixes (Dylan)

- Poll fixes (me)

- Fixes for provided buffers and recycling (me)

- Tweak to IORING_OP_MSG_RING command added in this merge window (me)

- Memory leak fix (Pavel)

- Misc fixes and tweaks (Pavel, me)

Please pull!


The following changes since commit 5e929367468c8f97cd1ffb0417316cecfebef94b:

  io_uring: terminate manual loop iterator loop correctly for non-vecs (2022-03-18 11:42:48 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.18/io_uring-2022-04-01

for you to fetch changes up to 3f1d52abf098c85b177b8c6f5b310e8347d1bc42:

  io_uring: defer msg-ring file validity check until command issue (2022-03-29 14:04:28 -0600)

----------------------------------------------------------------
for-5.18/io_uring-2022-04-01

----------------------------------------------------------------
Almog Khaikin (1):
      io_uring: fix memory ordering when SQPOLL thread goes to sleep

Dylan Yudaken (2):
      io_uring: fix async accept on O_NONBLOCK sockets
      io_uring: enable EPOLLEXCLUSIVE for accept poll

Jens Axboe (12):
      io_uring: recycle provided before arming poll
      io_uring: ensure that fsnotify is always called
      io_uring: remove poll entry from list when canceling all
      io_uring: bump poll refs to full 31-bits
      io_uring: fix assuming triggered poll waitqueue is the single poll
      io_uring: don't recycle provided buffer if punted to async worker
      io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly
      io_uring: add flag for disabling provided buffer recycling
      io_uring: remove IORING_CQE_F_MSG
      io_uring: improve task work cache utilization
      io_uring: fail links if msg-ring doesn't succeeed
      io_uring: defer msg-ring file validity check until command issue

Pavel Begunkov (4):
      io_uring: improve req fields comments
      io_uring: fix invalid flags for io_put_kbuf()
      io_uring: fix put_kbuf without proper locking
      io_uring: fix memory leak of uid in files registration

 fs/io_uring.c                 | 133 ++++++++++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |   2 -
 2 files changed, 110 insertions(+), 25 deletions(-)

-- 
Jens Axboe

