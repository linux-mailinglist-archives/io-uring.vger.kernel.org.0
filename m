Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3EA51E6FC
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbiEGMmI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 08:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiEGMmH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 08:42:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B3223BE1;
        Sat,  7 May 2022 05:38:21 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so9835106plg.5;
        Sat, 07 May 2022 05:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s1ziljaqBG9DbdVUX+jIB0sj5EqtCAUFUXV/TuT96cU=;
        b=XaGooD6TPcr6WoBitXeF6igCHre+X1N80TWdsCPoRnvl4pWIhJhqRsyqnmRmEiHAxe
         KQdAFiieqzUHqur1C8R70qpgRHPS1UYvvgSqdRA0O4Wq2DTjfwB4ljbrthnaugYiDbAn
         Y7XUSfUCkEjDV6wTIfxFYjp9ZldmbI4Tsx8lCec+MFiP8LRcoguaPJrDY8O/wk20/yub
         Ib07T1nlUM7lSV5C31za0uOjsow8kuA6Ra9p1tUrZGojqpjg25NeTSgR6SO1Eos6774y
         JoA1WLUV6+SFIrhliAvay896HypO3v4L0yIEJUdBQ3HwTs8O6kKmUJEZKNHgJpejj/I8
         d+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s1ziljaqBG9DbdVUX+jIB0sj5EqtCAUFUXV/TuT96cU=;
        b=HB1UjLXG8g6zZBvo6cr95Zq1Rbzhzx5hZ7tT7j6trM6tgUA64UaQI1HF/VBljqtkZ4
         +2MhaS+hGhq60gKw7BevckM+DOE5YK5ESvYbqyZQeV4AIl9h+JGqMusoXHNXLeFfJ9Z0
         zLvp0hZ8WZe5l7qbylaeOQTw600Cd6KTG3e1S8wEdq+Zy1D0w7158Vx59zeGsJ3ydt76
         IrYpuCjcBuF4I6fR9oDjzI0tCJTumKPItAwxbLSuvt2oUqbrTN1n+8ZRYUXWtWgMWRWi
         5rh2/sbtrKkjEkj+26l1s1uCIK1a6ZydhkZ0lcIMwBzKC2LXCIP407Kd21r6Asmme/c4
         41mA==
X-Gm-Message-State: AOAM532zbAhYFk12CqBYYAKwfBHWltlvwlOcKoDDAWR7O5Ahyacw3bwY
        jcuPBY1BOA+Vx0WFDQ8FQHf2anAHi6uILQ==
X-Google-Smtp-Source: ABdhPJx5cZ2S+udwQqwtb8Ay9NCwr/4PeqtxP/1LucuCu//MsTQhM/O2WWdGwAlJXD2oWk7vqi2cgw==
X-Received: by 2002:a17:90b:3442:b0:1d9:8af8:2913 with SMTP id lj2-20020a17090b344200b001d98af82913mr17664548pjb.199.1651927100511;
        Sat, 07 May 2022 05:38:20 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id d3-20020aa797a3000000b0050dc762816bsm5208178pfq.69.2022.05.07.05.38.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 May 2022 05:38:19 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] fast poll multishot mode
Date:   Sat,  7 May 2022 20:38:24 +0800
Message-Id: <20220507123828.76985-1-haoxu.linux@gmail.com>
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
first comsumer.
theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userpsace) --> accept inline
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


A liburing test is here:
https://github.com/HowHsu/liburing/blob/multishot_accept/test/accept.c

v1->v2:
 - re-implement it against the reworked poll code

v2->v3:
 - fold in code tweak and clean from Jens
 - use io_issue_sqe rather than io_queue_sqe, since the former one
   return the internal error back which makes more sense
 - remove io_poll_clean() and its friends since they are not needed


Hao Xu (4):
  io_uring: add IORING_ACCEPT_MULTISHOT for accept
  io_uring: add REQ_F_APOLL_MULTISHOT for requests
  io_uring: let fast poll support multishot
  io_uring: implement multishot mode for accept

 fs/io_uring.c                 | 94 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  5 ++
 2 files changed, 79 insertions(+), 20 deletions(-)


base-commit: 0a194603ba7ee67b4e39ec0ee5cda70a356ea618
-- 
2.36.0

