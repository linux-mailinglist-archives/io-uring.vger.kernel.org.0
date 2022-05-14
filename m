Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3284D5271DE
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiENOUd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiENOUc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:20:32 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5F62B3
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:31 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d25so10113037pfo.10
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/mq22+FKrgy/Ihxrny2SoNA/ypRtCXxqGehdt+V7/g=;
        b=PLmIVBIsT05nprF8d+1jQLl7cWNFEHPYOFhMkErG4LL8qNLRLKQaoHefjXU7OmN5SX
         IyjIiYq/oxxbM815BkBuHmhIuKxYhzt8+ArI2z5Uwd8Y2Dw1KUauS4ZxiXnSt4ADV534
         bwfFot4aXmQAbNUfBrY1JDPPUE4HcR1bvV1ACEWxbov5K5aukVQ/EpYWIoDtEpN/+jgZ
         umuH0bqGphCenE+BTAdZ7AwJzvUY3UcbP+LpMngtat3A1mGHrPxixflBbqDHsofNQL25
         yHnjqAbWm1F95XnK7tIZNi+hvfhtmq8EfDRm4YfYztrgXHn59ruJEP98xpgIkX70AFiO
         b4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G/mq22+FKrgy/Ihxrny2SoNA/ypRtCXxqGehdt+V7/g=;
        b=sKLdcmWbv41Gj685YiQ+zqzRN4tE7xIjUvjeuLb0sts448522X8uOh2wfzPvcma7BW
         cHROtesCYhfJUYuNYKgRpIVgEWXGKTDfowK/gfA3BL3vyPIl+kmQpM/ZC4/9lzGGdQVu
         6+9tA3yBXDmid7Q3/wTm/pXuFSBptjXpgkwRJx5vkEjzraxpUwLm/mo+uCKQuCFZdb5l
         +FFruuHMflJLJNdBxGSzLGXrP6RIJxIQ6ywJxjbhjNhZCNEB85yjsGlr58NE4jzwT3ca
         djmb+8aBFTqB2X+zUZo2/SqqjrDFFuR2DvMpA1xLN+4L5aTmfXOHFcLHjUACNLZBOZSp
         tjOA==
X-Gm-Message-State: AOAM531yPsW8RoXqLF2XuvXZh7P5uM+EXjNs+vzOwuQxFiPsH6IULO3w
        NFNnB0FYU717cFuIas2+x9neh/JUrAI6CPaR
X-Google-Smtp-Source: ABdhPJzn5EhR+BfShAFjN5WJWKsybr0kMkZwslRsZws/joVP5yoErcxOfqIRi4bJkvM9O2ZpFPLkxA==
X-Received: by 2002:a65:4c44:0:b0:39c:e0b5:cd2a with SMTP id l4-20020a654c44000000b0039ce0b5cd2amr7995446pgr.481.1652538030808;
        Sat, 14 May 2022 07:20:30 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b0015e8d4eb27csm3815968plg.198.2022.05.14.07.20.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:20:30 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 0/4] fast poll multishot mode
Date:   Sat, 14 May 2022 22:20:42 +0800
Message-Id: <20220514142046.58072-1-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let multishot support multishot mode, currently only add accept as its
first consumer.
theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userspace) --> accept inline
                              ^                 |
                              |-----------------|
    - multishot:
             add accept sqe(userspace) --> accept inline
                                              ^     |
                                              |--*--|

    we do accept repeatedly in * place until get EAGAIN

  2) when connections come in at a low pressure
    similar thing like 1), we reduce a lot of userspace-kernel context
    switch and useless vfs_poll()


tests:
Did some tests, which goes in this way:

  server    client(multiple)
  accept    connect
  read      write
  write     read
  close     close

Basically, raise up a number of clients(on same machine with server) to
connect to the server, and then write some data to it, the server will
write those data back to the client after it receives them, and then
close the connection after write return. Then the client will read the
data and then close the connection. Here I test 10000 clients connect
one server, data size 128 bytes. And each client has a go routine for
it, so they come to the server in short time.
test 20 times before/after this patchset, time spent:(unit cycle, which
is the return value of clock())
before:
  1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
  +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
  +1934226+1914385)/20.0 = 1927633.75
after:
  1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
  +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
  +1871324+1940803)/20.0 = 1894750.45

(1927633.75 - 1894750.45) / 1927633.75 = 1.65%

v1->v2:
 - re-implement it against the reworked poll code

v2->v3:
 - fold in code tweak and clean from Jens
 - use io_issue_sqe rather than io_queue_sqe, since the former one
   return the internal error back which makes more sense
 - remove io_poll_clean() and its friends since they are not needed

v3->v4:
 - move the accept multishot flag to the proper patch
 - typo correction
 - remove improperly added signed-off-by

v4->v5:
 - address some email account issue

v5->v6:
 - support multishot accept with fixed file

Hao Xu (4):
  io_uring: add IORING_ACCEPT_MULTISHOT for accept
  io_uring: add REQ_F_APOLL_MULTISHOT for requests
  io_uring: let fast poll support multishot
  io_uring: implement multishot mode for accept

 fs/io_uring.c                 | 106 +++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |   5 ++
 2 files changed, 90 insertions(+), 21 deletions(-)


base-commit: 1b1d7b4bf1d9948c8dba5ee550459ce7c65ac019
-- 
2.36.0

