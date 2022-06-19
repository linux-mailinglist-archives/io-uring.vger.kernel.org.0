Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB03550A2E
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 13:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiFSL0o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 07:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiFSL0n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 07:26:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46CD5F67
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k22so4641751wrd.6
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKajsPu5iWDLP3Cw2nyhYSArnQD0d/Bi7b38M+S7j6M=;
        b=bv2XphlfyghOtC9CPIz9tLjWP8WsQkH6tucTJ15dlBha69LmK0vbFcwQalRfizcknI
         Wp1m8VD2+8j7NcK3VBy9UiSGcx05V/t0oRMlBrxLY99wC6oIqT9kjadtuGoRDYTguuvj
         Ied1bigK1RccoDFViJWrzaFcJ/V2yQWFMAwyG2fdINY3OtAu64YuSL1Ypo2HBwr1tnDE
         LKvlYK2rV6NO041RY+ETzC+J1WOSAHNTRxXd28cANHx4vR/2LHf9LzuFsKF5qJWNuwqg
         IaMNhmomZLkZxNasLLiIMqu5TWMPJVfzlNe1qKqQA6MG3Ppuc1WfJzSScoUuPfMdgXms
         FYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKajsPu5iWDLP3Cw2nyhYSArnQD0d/Bi7b38M+S7j6M=;
        b=AR1pCaYnvXXd2zimW06Di67FMkLU7rWz0KAk/iHL9f0T4ftcZA2Uh+AkEAfI/2U/jl
         r+P+CViAl9REfDCY8FWL/ahchAnCOPvrUICi4CW0OQJqOeXeFlcxAVev3mf0OcaEJoKc
         JYuANXTB5Ksenep8AkniGORE9f7v1k3Jq99rHB+QuhBbqbBT12M1oYg3ORjDegnzInlD
         Ud3MHtxcVnjQev4vRDZckg9dCmyh+AkcHDsKvQh8OFe6Tt+vxj4AGuZWs6oxjDfRjicw
         JBNehUZteL5iKnrco4SZGmjEmGC6mNTJ+2AovfalMtarwKux8/XHvJjfKQxeBPIvRzu/
         wufg==
X-Gm-Message-State: AJIora/gdWCcRTUHoB9PLJYEqdqQR3guVIvY+qS/LqoMi8PHn8YPb210
        RMoHajHta+dTKdUUItElRsqUHfrR7E0uVw==
X-Google-Smtp-Source: AGRyM1srdIw4QLPubrJg8buq9H1AOAT+08eRFyhO7qWcZ0g+6gDCSmvP3Iqmg8FIJAK7Sc32cAuidg==
X-Received: by 2002:a5d:4891:0:b0:21b:88c9:69ae with SMTP id g17-20020a5d4891000000b0021b88c969aemr5204631wrq.84.1655638001032;
        Sun, 19 Jun 2022 04:26:41 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y14-20020adfee0e000000b002119c1a03e4sm9921653wrn.31.2022.06.19.04.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 04:26:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/7] cqe posting cleanups
Date:   Sun, 19 Jun 2022 12:26:03 +0100
Message-Id: <cover.1655637157.git.asml.silence@gmail.com>
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

Apart from this patches removing some implicit assumptions, which we
had problems with before, and making code cleaner, they and especially
6-7 are also needed to push for synchronisation optimisations later, lile
[1] or removing spinlocking with SINGLE_ISSUER.

The downside is that we add additional lock/unlock into eventfd path,
but I don't think we care about it.

The series also exposes a minor issue with cancellations, which for some
reason calls io_kill_timeouts() and io_poll_remove_all() too many times on
task exit. That makes poll-cancel to timeout on sigalarm, though usually
is fine if given 3-5 sec instead of 1. We'll investigate it later.

[1] https://github.com/isilence/linux/commit/6224f58bf7b542e6aed1eed44ee6bd5b5f706437

Pavel Begunkov (7):
  io_uring: remove extra io_commit_cqring()
  io_uring: reshuffle io_uring/io_uring.h
  io_uring: move io_eventfd_signal()
  io_uring: hide eventfd assumptions in evenfd paths
  io_uring: remove ->flush_cqes optimisation
  io_uring: introduce locking helpers for CQE posting
  io_uring: add io_commit_cqring_flush()

 include/linux/io_uring_types.h |   2 +
 io_uring/io_uring.c            | 144 ++++++++++++++++-----------------
 io_uring/io_uring.h            | 108 ++++++++++++++-----------
 io_uring/rw.c                  |   5 +-
 io_uring/timeout.c             |   7 +-
 5 files changed, 133 insertions(+), 133 deletions(-)

-- 
2.36.1

