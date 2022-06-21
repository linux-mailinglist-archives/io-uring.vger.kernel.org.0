Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2E0552DFA
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 11:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346726AbiFUJK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 05:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347543AbiFUJK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 05:10:27 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADA79FF8
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u12so26058079eja.8
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dSJAIiunNrHPEzYvkJC6mZtsdg9AzL9qXPBk49vYeBE=;
        b=d2LdA7TJaN6XhHoqJlMqelmwbwGWWO89wvyctYssDX3dz+bJUysbm2mM8UobWnAzUd
         Ww4k217BleLTGWjkIv2+/pdXyjIY4YamDvp1O4tbkwZklvWcyFlvFiJ91GTdoRvSP2mR
         0DsWfBB7Ed4qWbmK8J8GAjGCzDMdDGGXaHvsw1BObBHdGfQAQ5mAScn0LvuqsKh8fRST
         7o8hRnwt4B7dv6H13MYLNU6/2GrJulRYl7tBHSMCyVYZX4qH6FqdhrKs3StY3M9cdmxv
         NX4r5KLX/hWnqNIu9XGFk2PrvsAQU3BQdmFT9q74iUHB3XSljmD1bNS08aLbb/1fJteA
         NWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dSJAIiunNrHPEzYvkJC6mZtsdg9AzL9qXPBk49vYeBE=;
        b=OrMvNSKkaeqZnqkMhMco5IoQp90G7nRM/osWRW9s9o7U1KkclpyT0Y6Tal7dyQ26g4
         32PVmppx6yAibowUhgTrdCWqYBpGahHShT+h0plXBm3tOsCptzFvmlPn8b604r2UbrVO
         1vx9i3mN1DUpTmNQ+68ioXyJKIWKplhwIXRi4zenLAFp1K5R8SEMwIaNiyP/XOlwNHXh
         +tw+Ha56x5xVVag2Myf0HMF28tvPFDV9Hrwi4Q9L5xjFnT8N9+slQ95BUuFw4REMjoA3
         GbJlfBnYpucN8Cp62wGbqOz/9S/NoKFQgw9u2KBu8G0GLjS3oORsqKvEx3ro/S2WBWQq
         MxHg==
X-Gm-Message-State: AJIora95Ofc8aLaaaDVeZxIF+v6moyZE2Aesa/LgxzpNw4yPYVudImth
        GTFg3D1pB9onRe8WvpKzDDgeqnbKRqyHFQ==
X-Google-Smtp-Source: AGRyM1uUR1dU3TjSCZEJ/k2BgweKSR/J24YcDmAmNBMY6TzppdZt5A69+xGghnnxSYt1QYgn4qMHmA==
X-Received: by 2002:a17:907:c202:b0:710:8d1c:2501 with SMTP id ti2-20020a170907c20200b007108d1c2501mr24092172ejc.377.1655802624764;
        Tue, 21 Jun 2022 02:10:24 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:d61a])
        by smtp.gmail.com with ESMTPSA id cq18-20020a056402221200b00435651c4a01sm9194420edb.56.2022.06.21.02.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:10:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/4] random 5.20 patches
Date:   Tue, 21 Jun 2022 10:08:58 +0100
Message-Id: <cover.1655802465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Just random patches, 1/4 is a poll fix.

Pavel Begunkov (4):
  io_uring: fix poll_add error handling
  io_uring: improve io_run_task_work()
  io_uring: move list helpers to a separate file
  io_uring: dedup io_run_task_work

 io_uring/filetable.h |   2 +
 io_uring/io-wq.c     |  18 ++----
 io_uring/io-wq.h     | 131 ----------------------------------------
 io_uring/io_uring.h  |   3 +-
 io_uring/poll.c      |   9 +--
 io_uring/slist.h     | 138 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 148 insertions(+), 153 deletions(-)
 create mode 100644 io_uring/slist.h

-- 
2.36.1

