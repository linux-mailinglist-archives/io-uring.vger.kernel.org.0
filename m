Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF16759301
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 12:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjGSK3Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 06:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjGSK3N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 06:29:13 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF47E4D;
        Wed, 19 Jul 2023 03:28:39 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3fbfcc6daa9so62438345e9.3;
        Wed, 19 Jul 2023 03:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689762475; x=1692354475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cOBlb2uZSaoprD5zYhFtl37js7STcjBByS+3b2Fr22Q=;
        b=mHFoorMg6VVQgrLB4kFGsJLqLt4Nj9Z7DHB5Oh93VvMl6RJ8zdAiKH7yxwTraSDaCt
         7rHwHr5I197Q5P2nbiwzdhjBlrIEy9KtY2NDQDyyCxoEiARYIyFJYYPC/n5fsvp3RXKR
         fHZuKgwMckVBtyu9vOFtc6HmZR2xRDxgSxwnQhPAETD5G70BW7R5uZVrithD9o9K5U6K
         dwqS8mz1wagk4FXipbRZUj3g8ui8S28wkq/XGYXx2Ejury9lPR0JlAtesb52Dd03+8IK
         NVavkXE7sVkMCgn1o0W60bOSkN1JM/9fm3PgPGq3GadsCSKn5078BvaTauBKPck3QEXM
         LQow==
X-Gm-Message-State: ABy/qLZrb3ft8h6BXlBUPi5F7R/9iIGZfqoQvgw8cM6/NG0ko1Lryfm8
        e40Anu9LiX+TJNJiQvHOwVc=
X-Google-Smtp-Source: APBJJlEMb+0s55WnXERlUmWMqi51ijcbOZX6o6dCllgdD0EAMBAMwMToDnjkDkgS0wxjHCei6s7Waw==
X-Received: by 2002:a7b:c5c8:0:b0:3fc:4:a5b5 with SMTP id n8-20020a7bc5c8000000b003fc0004a5b5mr1554891wmk.29.1689762475274;
        Wed, 19 Jul 2023 03:27:55 -0700 (PDT)
Received: from localhost (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id l3-20020a05600012c300b00313fd294d6csm5012397wrx.7.2023.07.19.03.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 03:27:54 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] io_uring: Initial support for {s,g}etsockopt commands
Date:   Wed, 19 Jul 2023 03:27:34 -0700
Message-Id: <20230719102737.2513246-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds support for SOL_SOCKET level getsockopt and
setsockopt in io_uring, using the command op. SOL_SOCKET seems to be the
most common level parameter for get/setsockopt(2).

This implementation benefits from the work done to leverage sockptr_t in
SOL_SOCKET path.

For getsockopt command, the optlen field is not a userspace
pointers, but an absolute value, so this is slightly different from
getsockopt(2) behaviour. The updated value is returned in cqe->res.

If this approach is good enough, I am planning to extend the support for
those "levels" that have already implemented sockptr_t support

This patch was tested with a new test[1] in liburing.
This patch depends on "io_uring: Add io_uring command support for sockets"[2]

[1] Link: https://github.com/leitao/liburing/blob/getsock/test/socket-getsetsock-cmd.c
[2] Link: https://lore.kernel.org/all/20230627134424.2784797-1-leitao@debian.org/

Breno Leitao (3):
  net: expose sock_use_custom_sol_socket
  io_uring/cmd: Add support for getsockopt command
  io_uring/cmd: Add support for set_sockopt

 include/linux/net.h           |  5 ++++
 include/uapi/linux/io_uring.h |  8 ++++++
 io_uring/uring_cmd.c          | 51 +++++++++++++++++++++++++++++++++++
 net/socket.c                  |  5 ----
 4 files changed, 64 insertions(+), 5 deletions(-)

-- 
2.34.1

