Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344AF73357C
	for <lists+io-uring@lfdr.de>; Fri, 16 Jun 2023 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjFPQMH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jun 2023 12:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjFPQMG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Jun 2023 12:12:06 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7D269E
        for <io-uring@vger.kernel.org>; Fri, 16 Jun 2023 09:12:05 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-760dff4b701so10285939f.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jun 2023 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686931925; x=1689523925;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGJEaKObx0a8nkVCi1xGQ1K3bo/lzH3e6MJ/uM4/MT0=;
        b=B6Q4DwMqhs6udD8dp5Bnb3b/Vn4Je851Ulrnr2XOCZByn33bBAN6z0/Ci22EDbLXoi
         FyNaCWujNYNM9ogzSWqu15G/B3pmE8cIHhoQ6A4GO92bOhH6Sy/QNiFUKuAus/kvDBOP
         UwBwjNP2NZwJsgH3cOZInruxi9oEsCWt/e9DmXh/mMrfVM5fHrV0FhIghXH+ikWJWYrJ
         jpkoltjTYGQ/MrtfJuNq1aiAkbbytTkSVTjE9b60pIFxz9Q1ZCr6efte1dpD4Xhxja6F
         XgtLpqtP0w0pxj/6qhYYjBOn+VMVwQVdzQi3YJtOwCBZvm/XU/dkSWQpSYZg/iRcH+RY
         B7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686931925; x=1689523925;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FGJEaKObx0a8nkVCi1xGQ1K3bo/lzH3e6MJ/uM4/MT0=;
        b=S9t9/JGdGITMv6mWwbhJxBJ1nwl0G218ulkt/+Mtw7QaxPbBm2nMc/YnOGFGf4Bnth
         EAT6YOg3UUMj9Rr1pHK0Ty6lyzWesgNU5B87eQHRrz+DLyLGuuV3uEcj4M3PMaV7biN/
         /iOF+Wuw9oXXFTDd5laq/o71dc3dHTS2SvGvBLpPpO/QV/WNlQN8Qw8B1eqp1+RujPEO
         vvRvDjDVYWEGqUe5qOYelCvbwTu3VnxzfGABKzr+znjODrKWBoA55jxnYIo1bCz6TYwd
         7MusTkO4aAoI+8D0e4a8AkfRsQZZCvlMW2sWKf48mo8WfdiESDDHz8zbUf+/snzy9uIa
         x8Og==
X-Gm-Message-State: AC+VfDw7O5nuhEhRGNxyI18JtfmNq9tPgcAgO0hMlgCLCKJF0WoDEul+
        Pgp0uUr6XlDDPaiuqOSEYzEm7yyiZARm7QvnVyA=
X-Google-Smtp-Source: ACHHUZ4FP2kinav2G0NT9n+kECGXrvYYfBLWLAvNAMsvbiRTLX0A1ieC2QJkDbu6G8StgbOlE6TTVw==
X-Received: by 2002:a05:6602:1a87:b0:774:9337:2d4c with SMTP id bn7-20020a0566021a8700b0077493372d4cmr2795193iob.1.1686931925084;
        Fri, 16 Jun 2023 09:12:05 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l8-20020a056602276800b0077dc051150dsm256657ioe.42.2023.06.16.09.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 09:12:04 -0700 (PDT)
Message-ID: <d2d1c92b-e682-9fbb-120b-23a8726c142d@kernel.dk>
Date:   Fri, 16 Jun 2023 10:12:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.4-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A fix for sendmsg with CMSG, and the followup fix discussed for avoiding
touching task->worker_private after the worker has started exiting.

Please pull!


The following changes since commit b6dad5178ceaf23f369c3711062ce1f2afc33644:

  Merge tag 'nios2_fix_v6.4' of git://git.kernel.org/pub/scm/linux/kernel/git/dinguyen/linux (2023-06-13 17:00:33 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-15

for you to fetch changes up to adeaa3f290ecf7f6a6a5c53219a4686cbdff5fbd:

  io_uring/io-wq: clear current->worker_private on exit (2023-06-14 12:54:55 -0600)

----------------------------------------------------------------
io_uring-6.4-2023-06-15

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/net: save msghdr->msg_control for retries
      io_uring/io-wq: clear current->worker_private on exit

 io_uring/io-wq.c | 7 ++++++-
 io_uring/net.c   | 8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

-- 
Jens Axboe

