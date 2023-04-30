Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BB76F2855
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjD3Jhk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjD3Jhi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:38 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AFC10E7
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f315735514so104062875e9.1
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847455; x=1685439455;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pgw7SAEgZCYi0/kvNLII9HWX7GWjqzemguADE1p49wc=;
        b=QwIAidmOgbxrzXBC/YYYWdXXyMdqgUU2ml5IVchYqH/U+zCccsh3kxRXGZCn0E3BaU
         8lwi5WUB/5qgNrKZmHLKlBbHjKdy7GbEQNVBTqIQOV2bhzANTOyZQbRSV5te1CwfPCw4
         t+rCTLDKkaQTSSP/geHerkpy23QbrVlPOyJN3txLf0F8kHgLuApH+vZnaz2oeZbTs1+h
         Z/J44FNR7h+Tk8z7stsbr49y98m5aOKvShJAqCslpQUBouYnngG3tZmLrz5GTxSP65sc
         3NQV5xVvnGGOgggl/in+TWKx2Pug7jQ4ZpLsznZNq/njdB2mT9x8+47Tocb/3lHjeX0w
         TKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847455; x=1685439455;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pgw7SAEgZCYi0/kvNLII9HWX7GWjqzemguADE1p49wc=;
        b=hqqs1/kQbgdhSKxq2C9TNAVo1d1ThC0vB+ts6OlneTdgL4FlxJh/xcbOsMIVD3cbyl
         DKajA7FD/oMqfjF4G9UP40kc60+gu6+FwDIsvAi5Uixn1UJ+9tj08kidP6yfuSqu9Adf
         IbQ0soNHadhhxpKlp909/KuL6Ayj8mzPGORnG7Emjuzi4ItbllUBVH2gbKY+VQpEa4Jk
         Im0AFUSHAu1ffEK8ENiegthpLVFhdexcj8CfgI0T6wMHmrFnO7M49iCtqD4K9kvbiqOn
         l3DzcUTnwFZLyAu5RBiC2Uwwe3yV3tcqm7dqCMa+ynSN2riOHBHB5955XVV7qoRfjXiU
         j/SQ==
X-Gm-Message-State: AC+VfDz7lmGu75kLvnQ7kqvbe5YiK3JVdKcbd4n/QnmKTJCiuH+8vYYv
        BFivFBogQ354DFWMtolYRBZ1IDQgDCU=
X-Google-Smtp-Source: ACHHUZ53QYkFXkHndswnWKLzZPceMigYPFMAMwLiW35MWtzD4zhkVYJ/bTSmfFwCCTd6l3AHa34fNQ==
X-Received: by 2002:adf:e347:0:b0:2ef:84c:a4bc with SMTP id n7-20020adfe347000000b002ef084ca4bcmr11163352wrj.19.1682847455119;
        Sun, 30 Apr 2023 02:37:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 0/7] Rethinking splice
Date:   Sun, 30 Apr 2023 10:35:22 +0100
Message-Id: <cover.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

IORING_OP_SPLICE has problems, many of them are fundamental and rooted
in the uapi design, see the patch 8 description. This patchset introduces
a different approach, which came from discussions about splices
and fused commands and absorbed ideas from both of them. We remove
reliance onto pipes and registering "spliced" buffers with data as an
io_uring's registered buffer. Then the user can use it as a usual
registered buffer, e.g. pass it to IORING_OP_WRITE_FIXED.

Once a buffer is released, it'll be returned back to the file it
originated from via a callback. It's carried on on the level of the
enitre buffer rather than on per-page basis as with splice, which,
as noted by Ming, will allow more optimisations.

The communication with the target file is done by a new fops callback,
however the end mean of getting a buffer might change. It also peels
layers of code compared to splice requests, which helps it to be more
flexible and support more cases. For instance, Ming has a case where
it's beneficial for the target file to provide a buffer to be filled
with read/recv/etc. requests and then returned back to the file.

Testing:

I was benchmarking using liburing/examples/splice-bench.t [1], which
also needs additional test kernel patches [2]. It implements get-buf
for /dev/null, and the test grabs one page from it and then feeds it
back without any actual IO, then repeats.

fairness:
IORING_OP_SPLICE performs very poorly not even reaching 450K qps, so one
of the patches enables inline execution of it to make it more
interesting but is only fine for testing.

Buffer removal is done by OP_GET_BUF without issuing a separate op
for that. "GET_BUF + nop" emulates the overhead by additional additional
nop requests.

Another aspect is that OP_GET_BUF issues OP_WRITE_FIXED, which, as
profiles show, are quite expensive, which is not exactly a problem of
GET_BUF but skews results. E.g. io_get_buf() - 10.7, io_write() - 24.3%

The last bit is that the buffer removal, if done by a separate request,
might and likely will be batched with other requests, so "GET_BUF + nop"
is rather the worst case.

The numbers below are "requests / s".

QD  | splice2() | OP_SPLICE | OP_GET_BUF | GET_BUF, link | GET_BUF + nop
1   | 5009035   | 3697020   | 3886356    | 4616123       | 2886171
2   | 4859523   | 5205564   | 5309510    | 5591521       | 4139125
4   | 4908353   | 6265771   | 6415036    | 6331249       | 5198505
8   | 4955003   | 7141326   | 7243434    | 6850088       | 5984588
16  | 4959496   | 7640409   | 7794564    | 7208221       | 6587212
32  | 4937463   | 7868501   | 8103406    | 7385890       | 6844390

The test is obviously not exhausting and it should further be tried
and with more complicated cases. E.g. need quantify performance with
sockets, where apoll feature will be involved, and it'll need to get
internal partial IO retry support.

[1] https://github.com/isilence/liburing.git io_uring/get-buf-op
[2] https://github.com/isilence/linux.git io_uring/get-buf-op

Links for convenience:
https://github.com/isilence/liburing/tree/io_uring/get-buf-op
https://github.com/isilence/linux/tree/io_uring/get-buf-op

Pavel Begunkov (7):
  io_uring: add io_mapped_ubuf caches
  io_uring: add reg-buffer data directions
  io_uring: fail loop_rw_iter with pure bvec bufs
  io_uring/rsrc: introduce struct iou_buf_desc
  io_uring/rsrc: add buffer release callbacks
  io_uring/rsrc: introduce helper installing one buffer
  io_uring,fs: introduce IORING_OP_GET_BUF

 include/linux/fs.h             |  2 +
 include/linux/io_uring.h       | 19 +++++++
 include/linux/io_uring_types.h |  2 +
 include/uapi/linux/io_uring.h  |  1 +
 io_uring/io_uring.c            |  9 ++++
 io_uring/opdef.c               | 11 +++++
 io_uring/rsrc.c                | 80 ++++++++++++++++++++++++++----
 io_uring/rsrc.h                | 24 +++++++--
 io_uring/rw.c                  |  7 +++
 io_uring/splice.c              | 90 ++++++++++++++++++++++++++++++++++
 io_uring/splice.h              |  4 ++
 11 files changed, 235 insertions(+), 14 deletions(-)

-- 
2.40.0

