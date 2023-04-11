Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7941A6DD915
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDKLNL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjDKLNB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:01 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2723240E2
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gb34so19514663ejc.12
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qJr80jmTR1BiBKNw3zZ4tIoh9XbAoHhQ4NrZfxhD950=;
        b=dFypLVGFS7AIHFu5pD2mf6JTxkKxjBxkg/lFi2inDL1b0jxtJnyQk+5O9cmLR3RduP
         lUEuy7E0WT3Su1NktetW2ag1w/aFHNkqdZveuIbtPDpmhZ5282eNWSKIASSWsPDQoyN+
         Y6cWAsseK6RrDlyIz8igNZ6nW4+lwzE01tZZKO+1vlzQQKTto2RAeEPWf0JUX3ENGT4f
         BAVavl3sh3TeE9+WwJ9CUnKl0gkF5claDnggKKqzni9iqrtyVbLTsTb9fwUwcnhiY2eM
         7yyV5LqhvE0o8j4vMUCiU17Q2OIBAdG50mDzrjtfJd3cHa20vw+T2f7fYi/HW/eA69T/
         hiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJr80jmTR1BiBKNw3zZ4tIoh9XbAoHhQ4NrZfxhD950=;
        b=Fh1jB4H7AAA9kRmV/ISmm/EnRR5hPKKSQtg3Z0k3sEdNv1LS684i0N26waTFIjOCze
         lgtyFOeb4iyrdEINMsg1h7k6XjDc5++xz5MCd78VF6lCKu8SiwIOpgyzIgE/pacxpQXu
         m+VCk64QAQqAdnSpf5EF8ClQFnbmGiggH7GpL9cLjt/TivWvvtyPEc66AqPZp4F7v/Je
         umnk9kudNuK2qeQWE+V7I1vibtiP0eKRRVormWCOqKOboKFtiocG2AGFQMq8enAh6Ga9
         z7O1Wy6W0ZxIMaEqmNELyrfAujrVZC4WJTx1lX9V/d6eOt7JV/PiIPIJbFJkk4MC9VxN
         veLQ==
X-Gm-Message-State: AAQBX9fWqVk47/JvvTJ7Amyb61iAi75Vxa0U+HaYTiComyrHx9ZBlsfs
        ibSo8cG81uAb3FndoxSB6uS/8fsLbRM=
X-Google-Smtp-Source: AKy350bMRegZlRew4KjK6Medbsnya9gENvimjozuQNKt8dd4omRBjWQRUgsU446D0d2NMXT77RKW7Q==
X-Received: by 2002:a17:907:7b06:b0:94c:548f:f81d with SMTP id mn6-20020a1709077b0600b0094c548ff81dmr4031876ejc.71.1681211567063;
        Tue, 11 Apr 2023 04:12:47 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/8] for-next cleanups 
Date:   Tue, 11 Apr 2023 12:06:00 +0100
Message-Id: <cover.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A random set of cleanups

Patches 1 and 2 address kernel test robot warnings.
Patches 3 and 4 add some extra lockdep checks
The rest are doing minor rsrc cleanups.

Pavel Begunkov (8):
  io_uring: shut io_prep_async_work warning
  io_uring/kbuf: remove extra ->buf_ring null check
  io_uring: add irq lockdep checks
  io_uring/rsrc: add lockdep checks
  io_uring/rsrc: consolidate node caching
  io_uring/rsrc: zero node's rsrc data on alloc
  io_uring/rsrc: refactor io_rsrc_node_switch
  io_uring/rsrc: extract SCM file put helper

 include/linux/io_uring_types.h |  1 -
 io_uring/alloc_cache.h         |  5 +++
 io_uring/io_uring.c            |  9 ++---
 io_uring/io_uring.h            |  2 +
 io_uring/kbuf.c                | 14 +++----
 io_uring/rsrc.c                | 73 +++++++++++++++-------------------
 io_uring/rsrc.h                |  7 ++++
 7 files changed, 56 insertions(+), 55 deletions(-)

-- 
2.40.0

