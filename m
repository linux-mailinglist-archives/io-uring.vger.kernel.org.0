Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BFA789217
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjHYW4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjHYW4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:05 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E04CE77
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bf48546ccfso10232995ad.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004162; x=1693608962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ln8V9k0rRAhr6XrGjbtxwTzjhCtFBJCGaH+v0PgMKkI=;
        b=gYBvcissV08k68uzUB2Xh3MQU/BLzSPnlmtqyugkeD+xxbPH3Fnd1UMMF+h5k7xswc
         6dwDT2OO1NNBhUNv/g5ZixWuHz/I4Ly4sqQcvGXPLbEPHfq9WLLgViLpcxp2QhM8q3R9
         TFtqffsBqT0Wsg24AQ+Y3wBbxOYL9um7s9d+ds0A3wo6EFZAMgD7hU730nTYsNnX6Ijx
         /5EtkL2TK60AeYqI9cVLAREv6Q8PQ8Jr/JjLDMDGFV0idCx+tVTwTUbnYLADGju/8Jrr
         T0zrQnZ5uWkl/hX6BTT97zgQBwHj+Nt7cVE8zuVgaFelJkJN6UFOgSKQP5myaYapHHaY
         cSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004162; x=1693608962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ln8V9k0rRAhr6XrGjbtxwTzjhCtFBJCGaH+v0PgMKkI=;
        b=TA51Ys6T1rBVpOAyGX+k2/Pf265Qvhlt7jaUvWskC6hPhGn+8gnAFrEEBK4ftPciFH
         JFdg8J18VhO5tV9Ib63TynWs85V5EaFXVtA+Wg6by8HrtoDs3aHeKr04QrSf9fYyETix
         gHWe9Ev7P3ln6PfK83Foq1q68oGQIHr9K9QqH1q0aUJCkeRtYjPLFYi3BsSwX7hEo+Xr
         HIEmcD6nRawYn6lUWLqs/SiwehnhLEtvxB9PZKugi5mwsJTo5aytox8Z65kGE34ZnavU
         ULWTD7Ui0BC4cxfCCRuEeuJ6cz5CaHH1xmWDOV3S9U+FqtMwILBG4/igHe5L7jHoODk5
         RZuQ==
X-Gm-Message-State: AOJu0YxQvr7Hu+pHds3laHJNnx0OUCLA3MmhpqhsHZ78QwDFhArFuU5n
        1yMhaKVmagRQqpSfcZrpq12brA==
X-Google-Smtp-Source: AGHT+IHTb+olHTOvQ11MGsmTvUmrIwnWqJEuIzKguIom5ByihYwi2CdfxNJ1RiQYSnqQ/uRKjn+dXw==
X-Received: by 2002:a17:902:da82:b0:1b0:3a74:7fc4 with SMTP id j2-20020a170902da8200b001b03a747fc4mr19242532plx.24.1693004161658;
        Fri, 25 Aug 2023 15:56:01 -0700 (PDT)
Received: from localhost (fwdproxy-prn-010.fbsv.net. [2a03:2880:ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001bf095dfb76sm2276461plg.237.2023.08.25.15.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:01 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 00/11] Zero copy network RX using io_uring
Date:   Fri, 25 Aug 2023 15:55:39 -0700
Message-Id: <20230825225550.957014-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patchset is a proposal that adds zero copy network RX to io_uring.
With it, userspace can register a region of host memory for receiving
data directly from a NIC using DMA, without needing a kernel to user
copy.

Software support is added to the Broadcom BNXT driver. Hardware support
for receive flow steering and header splitting is required.

On the userspace side, a sample server is added in this branch of
liburing:
https://github.com/spikeh/liburing/tree/zcrx2

Build liburing as normal, and run examples/zcrx. Then, set flow steering
rules using ethtool. A sample shell script is included in
examples/zcrx_flow.sh, but you need to change the source IP. Finally,
connect a client using e.g. netcat and send data.

This patchset + userspace code was tested on an Intel Xeon Platinum
8321HC CPU and Broadcom BCM57504 NIC.

Early benchmarks using this prototype, with iperf3 as a load generator,
showed a ~50% reduction in overall system memory bandwidth as measured
using perf counters. Note that DDIO must be disabled on Intel systems.

Mina et al. from Google and Kuba are collaborating on a similar proposal
to ZC from NIC to devmem. There are many shared functionality in netdev
that we can collaborate on e.g.:
* Page pool memory provider backend and resource registration
* Page pool refcounted iov/buf representation and lifecycle
* Setting receive flow steering

As mentioned earlier, this is an early prototype. It is brittle, some
functionality is missing and there's little optimisation. We're looking
for feedback on the overall approach and points of collaboration in
netdev.
* No copy fallback, if payload ends up in linear part of skb then the
  code will not work
* No way to pin an RX queue to a specific CPU
* Only one ifq, one pool region, on RX queue...

This patchset is based on the work by Jonathan Lemon
<jonathan.lemon@gmail.com>:
https://lore.kernel.org/io-uring/20221108050521.3198458-1-jonathan.lemon@gmail.com/

David Wei (11):
  io_uring: add interface queue
  io_uring: add mmap support for shared ifq ringbuffers
  netdev: add XDP_SETUP_ZC_RX command
  io_uring: setup ZC for an RX queue when registering an ifq
  io_uring: add ZC buf and pool
  io_uring: add ZC pool API
  skbuff: add SKBFL_FIXED_FRAG and skb_fixed()
  io_uring: allocate a uarg for freeing zero copy skbs
  io_uring: delay ZC pool destruction
  netdev/bnxt: add data pool and use it in BNXT driver
  io_uring: add io_recvzc request

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  59 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   3 +
 include/linux/io_uring.h                      |  31 +
 include/linux/io_uring_types.h                |   6 +
 include/linux/netdevice.h                     |  11 +
 include/linux/skbuff.h                        |  10 +-
 include/net/data_pool.h                       |  96 +++
 include/uapi/linux/io_uring.h                 |  53 ++
 io_uring/Makefile                             |   3 +-
 io_uring/io_uring.c                           |  13 +
 io_uring/kbuf.c                               |  30 +
 io_uring/kbuf.h                               |   5 +
 io_uring/net.c                                |  83 +-
 io_uring/opdef.c                              |  16 +
 io_uring/zc_rx.c                              | 723 ++++++++++++++++++
 io_uring/zc_rx.h                              |  42 +
 17 files changed, 1168 insertions(+), 20 deletions(-)
 create mode 100644 include/net/data_pool.h
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

-- 
2.39.3

