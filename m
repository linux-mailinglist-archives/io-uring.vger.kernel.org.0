Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2941065B988
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjACDFX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbjACDFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:22 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCA7B7F8
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:21 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso11970951wmq.1
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R9k+hsjKjkEAf4dvvQgRVTM0D349t7NgtaXlCnH9lqg=;
        b=FVP1jbnav/S0dOa09gLHL8z9Do9Ipng/SBmFJsn9S79i3BAdMeDgSYznozgUpj03wv
         HWpDZJzEiBNAE7ngsWlXzbioW2YaLY1WTB5oOdG1uvJX2TkHrLQmd/vL7MA0sgNI25S0
         BOurmOKrWZd8DRaStmAB+9YX9QZvhtQPLB8pzhiNrcA/4Z/074VgaCfTQYWIrGAyGjV/
         MG65bq3ZVFRAIDXCwjxORstbXKizZBPkHBSC/P6U3tuibRkBlKJXt1YlUOJAjDLifN8a
         dpJQ88kF9OmN5/v7+qbIfDsiJLNTaieETo7NvDObSZMm9ylvFpNfRJGAnkGK0Kj7gwMy
         Cvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R9k+hsjKjkEAf4dvvQgRVTM0D349t7NgtaXlCnH9lqg=;
        b=ADojsBvbotPtFn09keodQN0a/u5bPNS8e6wUwl3jFvP8SMeKnWRyy91zguu2fA8pz5
         LwyqwPLOmizT2322uA85v1BPKWpCIfxJAVY9bEUW0czrm9ZDTL5JFX72thMkk/iQwnlT
         hkim7s4plcXN5tn5VjvsbQb7qIMQH3XZdIh5WOPGzUuPoVxhOs0O7Gu6e5h30xFK7TF0
         Fqx/Dajc9TT4UI/ml/2PPjDsbSZsrwqliWBe8fZqbgytK+L52qNbpV9PE2v20hX3oQsP
         8PtohXJ/qhSOQ6lmLLgvpBSgqSpXVYyLIMClWLiiYu3ObvpkjHqStXl+1rmF9Lw64doc
         byFw==
X-Gm-Message-State: AFqh2kqhFFJkJwBFt6ZAPp2TKHIhZZ9H6Uzp6nfWHVno2gC5rUuetiCb
        Zv4T7Rat/7qmlPfRxixxSDVTjUMGElE=
X-Google-Smtp-Source: AMrXdXsjzXWDvEbB9jn3HGPj5tpChGZj7Pe7QJeUaYfhLbWBu9xNxG3uwvRsm5xfUnVlcCRkEq3ayA==
X-Received: by 2002:a05:600c:1e10:b0:3d1:f496:e25f with SMTP id ay16-20020a05600c1e1000b003d1f496e25fmr32679803wmb.16.1672715120058;
        Mon, 02 Jan 2023 19:05:20 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 00/13] CQ waiting and wake up optimisations
Date:   Tue,  3 Jan 2023 03:03:51 +0000
Message-Id: <cover.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The series replaces waitqueues for CQ waiting with a custom waiting
loop and adds a couple more perf tweak around it. Benchmarking is done
for QD1 with simulated tw arrival right after we start waiting, it
gets us from 7.5 MIOPS to 9.2, which is +22%, or double the number for
the in-kernel io_uring overhead (i.e. without syscall and userspace).
That matches profiles, wake_up() _without_ wake_up_state() was taking
12-14% and prepare_to_wait_exclusive() was around 4-6%.

Another 15% reported in the v1 are not there as it got optimised in the
meanwhile by 52ea806ad9834 ("io_uring: finish waiting before flushing
overflow entries"). So, comparing to a couple of weeks ago the perf
of this test case should've jumped more than 30% end-to-end. (Again,
spend only half of cycles in io_uring kernel code).

1-8 are preparation patches, they might be taken right away. The rest
needs more comments and maybe a little brushing.

Pavel Begunkov (13):
  io_uring: rearrange defer list checks
  io_uring: don't iterate cq wait fast path
  io_uring: kill io_run_task_work_ctx
  io_uring: move defer tw task checks
  io_uring: parse check_cq out of wq waiting
  io_uring: mimimise io_cqring_wait_schedule
  io_uring: simplify io_has_work
  io_uring: set TASK_RUNNING right after schedule
  io_uring: separate wq for ring polling
  io_uring: add lazy poll_wq activation
  io_uring: wake up optimisations
  io_uring: waitqueue-less cq waiting
  io_uring: add io_req_local_work_add wake fast path

 include/linux/io_uring_types.h |   4 +
 io_uring/io_uring.c            | 194 +++++++++++++++++++++++----------
 io_uring/io_uring.h            |  35 +++---
 3 files changed, 155 insertions(+), 78 deletions(-)

-- 
2.38.1

