Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66EA75F9CF
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 16:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjGXOX6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 10:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjGXOX6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 10:23:58 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22C1E76;
        Mon, 24 Jul 2023 07:23:51 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-991f956fb5aso661601966b.0;
        Mon, 24 Jul 2023 07:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208630; x=1690813430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x34eE6rssNnP3AKTFSt9LRtCqJGRKZEC5FfRHT31dv0=;
        b=KaHj/Pc3xgBNQq6L81rSrkes0Kp9gh5PiJ3Vf5N71oAhGKq7bIlbboWgIcEGg8CC41
         SBQjbbmCK2kMwrYcD91L+TWhRGpcV5pluEJ+1CsOW/FuBwG3txVzHsyGXMYuIQ0ms9TC
         nIupL5Bjc2U/E7iPArkic3JNJd4xh+Bl/buF2qFatfxrFOiSNOofY9W+1On+M8cVxaA+
         OCvuXK50ul4Xv3N0vc8oAb0Ox003iBg4XA17Z77Mk7MKRpE3Y73Ifw9id4wdm0KImGY8
         3ZIEpfgeaVcvpM3rzk8IpBSJWPLuvEonOAWc0M4J6GQtBqx4T+KDnggAjkNf9IPUQyAX
         ReLg==
X-Gm-Message-State: ABy/qLYYiRaxqCL5Nly74QiZUlDo5T37KGE72aextpfi/zaKsksK33eQ
        6h3dkriPvnXuBXvYOBHGs9cr8EahJfw=
X-Google-Smtp-Source: APBJJlECpMG0omCqFKhxt3meieCf6TsZ7tjLOEIdTnOWJ+HMO7Q6H2neBAUDGWlSN25k+t2wYxf9sA==
X-Received: by 2002:a17:907:7819:b0:99b:4790:a4d4 with SMTP id la25-20020a170907781900b0099b4790a4d4mr10050814ejc.38.1690208629659;
        Mon, 24 Jul 2023 07:23:49 -0700 (PDT)
Received: from localhost (fwdproxy-cln-007.fbsv.net. [2a03:2880:31ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id qx26-20020a170906fcda00b00982cfe1fe5dsm6835841ejb.65.2023.07.24.07.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 07:23:49 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org, leit@meta.com
Subject: [PATCH 0/3] io_uring: Initial support for {s,g}etsockopt commands
Date:   Mon, 24 Jul 2023 07:22:33 -0700
Message-Id: <20230724142237.358769-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all levels
and optnames. On the other hand, SOCKET_URING_OP_GETSOCKOPT just
implements level SOL_SOCKET case, which seems to be the most common
level parameter for get/setsockopt(2).

struct proto_ops->setsockopt() uses sockptr instead of userspace
pointers, which makes it easy to bind to io_uring. Unfortunately
proto_ops->getsockopt() callback uses userspace pointers, except for
SOL_SOCKET, which is handled by sk_getsockopt(). Thus, this patchset
leverages sk_getsockopt() to implement the SOCKET_URING_OP_GETSOCKOPT
case.

PS1: For getsockopt command, the optlen field is not a userspace
pointers, but an absolute value, so this is slightly different from
getsockopt(2) behaviour. The new optlen value is returned in cqe->res.

PS2: The userspace pointers need to be alive until the operation is
completed.

This patch was tested with a new test[1] in liburing.
This patch depends on "io_uring: Add io_uring command support for sockets"[2]

[1] Link: https://github.com/leitao/liburing/blob/getsock/test/socket-getsetsock-cmd.c
[2] Link: https://lore.kernel.org/all/20230627134424.2784797-1-leitao@debian.org/

Changes from RFC:
	* Copy user memory at io_uring subsystem, and call proto_ops
	  callbacks using kernel memory
	* Implement all the cases for SOCKET_URING_OP_SETSOCKOPT

Breno Leitao (4):
  net: expose sock_use_custom_sol_socket
  io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
  io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
  io_uring/cmd: Extend support beyond SOL_SOCKET

 include/linux/net.h           |  5 +++
 include/uapi/linux/io_uring.h |  8 ++++
 io_uring/uring_cmd.c          | 81 +++++++++++++++++++++++++++++++++++
 net/socket.c                  |  5 ---
 4 files changed, 94 insertions(+), 5 deletions(-)

-- 
2.34.1

