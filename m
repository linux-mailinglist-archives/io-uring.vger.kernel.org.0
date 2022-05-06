Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0AB51D1C7
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiEFHEl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386459AbiEFHEk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:04:40 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7AC4BFF9;
        Fri,  6 May 2022 00:00:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so5539972pfb.4;
        Fri, 06 May 2022 00:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/TKpkXNk/JV0I11CglzabSSyetImwOe5rCmF3RGpCI=;
        b=iB+F+tA8pQzBJGSZXK+GFFP8xRT+oHr8/CbAJKo4KIfzXRu9mwDthqa+FhiyffA1gg
         Rlw95moDsULGn7AU3VUKlGpT9h1O6NaNbWTLjCqZmlUK1MscSog+O6pLPrfKPS1V26WY
         K5kTfdDa3DFOx7oiMKmKoNp4JXVrZ7Q9XRzgvW0U2nc8nzcWg/Kqy2HlDozeDGlLi+JL
         j2n5m8qDvFIivSpCvAcfBJpGmh8SD6lRAk3qwwwyxBBqcyS1qa7HYBjwzNIErI6pT6GD
         jb/Mlrp6lzg6DXo7p+WEzlQSHsaAeN2zrGd0KM4EIY2iQIoUzHAc6WzNg/4hqRqLzJaH
         tPFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/TKpkXNk/JV0I11CglzabSSyetImwOe5rCmF3RGpCI=;
        b=lgxIYTvsfDSVyzjwILy2FtImZiWmrovyH8vUTSfZ/BBuRfHxRtILxDdReoFaGbTz1W
         Ymo6uuHoN0mIPlTlIUCfHsvGMr7UmvBq4g/pcikKvFrPRSUv9bsCBxGcNZiIuV6D/J7C
         IelL+wCSNF3od8jmTM9SSOFNFVe2UHyNI9fQZC9j/C8eGdHvGwaZWuHlvEINpzUE5Fdw
         ZafX/Wzu4AP6NJfRaxAhprQBL8Ivk3gVrU1Q5rh14CJQnTK5QwiRM+0azoLQcpH4h/D/
         7k1FQz/mWVZ4PnG48VTqPiVwiW2IKUeAPJZd4eCO5Q7pyIWSVNaUZ20hsRsXcpC6dSEy
         3ChQ==
X-Gm-Message-State: AOAM5335isUuqV1OeVs87b74AuHt362B+/kPCA9jkQ4LiAmRPxL5b+HU
        /sSE00t8EfWSaJYxHqm/ClXt70oBZI0=
X-Google-Smtp-Source: ABdhPJw1qqMhGWMc6tcvOz5w9cyT/PlGv0CCvuBQIzcD0H1h85bquNoMy3WS1tWR32hb7wo6yy94Rw==
X-Received: by 2002:aa7:8b48:0:b0:50d:cac9:adae with SMTP id i8-20020aa78b48000000b0050dcac9adaemr1938134pfd.30.1651820457908;
        Fri, 06 May 2022 00:00:57 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2desm813112plb.296.2022.05.06.00.00.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 00:00:57 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] fast poll multishot mode
Date:   Fri,  6 May 2022 15:00:57 +0800
Message-Id: <20220506070102.26032-1-haoxu.linux@gmail.com>
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

Hao Xu (5):
  io_uring: add IORING_ACCEPT_MULTISHOT for accept
  io_uring: add REQ_F_APOLL_MULTISHOT for requests
  io_uring: let fast poll support multishot
  io_uring: add a helper for poll clean
  io_uring: implement multishot mode for accept

 fs/io_uring.c                 | 121 ++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |   5 ++
 2 files changed, 100 insertions(+), 26 deletions(-)


base-commit: f2e030dd7aaea5a937a2547dc980fab418fbc5e7
-- 
2.36.0

