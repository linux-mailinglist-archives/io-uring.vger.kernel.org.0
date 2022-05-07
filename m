Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B65E51E7AA
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiEGOKD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiEGOKC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:10:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1AE47AF5;
        Sat,  7 May 2022 07:06:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so13219603pjv.4;
        Sat, 07 May 2022 07:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s1ziljaqBG9DbdVUX+jIB0sj5EqtCAUFUXV/TuT96cU=;
        b=cMx7jM3e4TUL9J4K7GbsDbkUCn9DesN4LPv4G8tSwXSHG+k7nj4jacuLsntXvmY4yv
         ByP1QmP0xr1lZvVNPKh9E3OzlWXT8DoCkxoa/DtwOJOw4vKjGenqE5ZBX16HfCiEV168
         dp4YQwb3J718HSGVUOlxSBLVmZsygZMhdbnL/RbPWlhkF9YJrIOFZaAxFZM8LuQ3hInp
         C5O/bn8TjTMKNcg9FcuIyJbL4v0HiZw1B/SH0g7h8oJisnzqOOprDhCplQcuyRYYc2WO
         p86d11KU1Yalo0L5Ytwz6R1H7qbXDSJtZUC7RfkCPeW9l10szKjjR7EHMJCTh1AoFNSZ
         1VVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s1ziljaqBG9DbdVUX+jIB0sj5EqtCAUFUXV/TuT96cU=;
        b=q4TCBQe6/GwuiA4UrfbDp0aDCUID4DR2TFHd8ElgpP45Y4YqG3tLETC4pSWb/k6qJn
         JJYioqFLDmDUiBk7+gMu9gqxL7G9AnFpfp6O8vGaMvRmo8UF1S9pEJeiWURsLOG/qzF2
         W08YqFt03vy+rPTq1dYBDzosCejtQcZ7WvNcptUTX3kkTuZaEqPRxVGKu77mGq3gCVsg
         zS14yPWJW4OQ1382J8qbTYVIz/xtSAS0Z9gecb8DT2TmHW5rAq2fCP8jmCxbjAh86CIJ
         qCI6hFu9wIvFy6/VMtWoale04/7s5qJZ96vh9Qi37nsYqwn2I3U+zW5YS/xS2FUoz6zr
         rblw==
X-Gm-Message-State: AOAM532537H/OaSWbXK819ObrEb/OoIC0rlyTE3P2067LOG+0AfgSSkM
        CyWL4GMwv4hhKlNuY02iT5CEclqcHWGvhA==
X-Google-Smtp-Source: ABdhPJwW/R+Ur4I+kxdLkXFXgimQwuDF9il9GZEV9FDwEZnLoAVMzmx0ISpvI8cUHsuUBjIa+3baew==
X-Received: by 2002:a17:90b:1d83:b0:1dc:4362:61bd with SMTP id pf3-20020a17090b1d8300b001dc436261bdmr17768744pjb.126.1651932373142;
        Sat, 07 May 2022 07:06:13 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015e8d4eb2acsm3674813plj.246.2022.05.07.07.06.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 May 2022 07:06:12 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] fast poll multishot mode
Date:   Sat,  7 May 2022 22:06:16 +0800
Message-Id: <20220507140620.85871-1-haoxu.linux@gmail.com>
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

