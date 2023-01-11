Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B612666263
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 19:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjAKSAY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 13:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjAKSAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 13:00:23 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D086214038
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 10:00:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 17so17634871pll.0
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 10:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LTmq/ajXOScrb67c0ergqi3fHReWHTMsouiD7Lp1Ww4=;
        b=L6TOnhnyM5Ey44vkG0KrlKzkgCQfKNPrILTOaUn2e0jqwiZngwWpLOuV+pszHb+slL
         GHXDu8LEa4dGg5SyJ/WnbqBLH+b5wAwiWUj3sG235KjKQJ5UKmqmqPCUa5kAiauk3rxs
         Rg3F1r305BtTL5UhTiVLsHmjxWiFie7GGHfqamFtHKkkSsSuFuu3p453ZuhHmi9RkPw0
         Tb/H1bjHLmSG9ohYhVqAyfURjg6ZlTFf6K3tTeukQ1Mx7GgmN/9ihuyH8TV125vADDsh
         uuLYzm1l/yV1VcGK/etz8J5HI4iGRye71nqatbxDo7U2B/illkVT196rdXnFLswUy6nq
         0cWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTmq/ajXOScrb67c0ergqi3fHReWHTMsouiD7Lp1Ww4=;
        b=SAF8kx7EFrlGxRJLN1IxmCnBHect3BKYGGWGDk8bzKQreJVSN6pFffi1EsBGhd5d/i
         mSV62op3vH2R4fI8gXEyk2TFJt7PrLGilJtg9qmhjPPiSvSyVVoXvg0fZHRubfEv43fb
         HoEzfBOtKS7bQRNQ3bprgkVS79P0pq9Z/5Y8eOM8cEbC79z51YHfQaMy9cGCChDNEdv/
         I5JHya48e0e38UMaLlfOI7laQFyqA8qumfZ0LXONwGAqjUiUhc6NyMlLGFjs8EuZZPha
         2P9C7fAjgJZp8/Fgq5S6KeLMUpxwdor6FUDFRIgHp0b/cucwIx/vPV9KmuubcOy7+6sK
         ZB5g==
X-Gm-Message-State: AFqh2kqjv7pkDaLNGmKPmXu17VCAdvG5rnSa/FuFXjxz2mNRCBuMv+RD
        3dRYmiHqZtTqrwHdAoV2bEZZBtzZqCWduyxN
X-Google-Smtp-Source: AMrXdXvW10jowKOfwFKe3t8MGGSD0uydxQ7bGRjfKqCX1eVSkqQnH0onIATcSdeFQNkITXazA0HYcg==
X-Received: by 2002:a17:902:eb4d:b0:194:4c4f:e965 with SMTP id i13-20020a170902eb4d00b001944c4fe965mr666330pli.0.1673460021300;
        Wed, 11 Jan 2023 10:00:21 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b00174c0dd29f0sm10517842plg.144.2023.01.11.10.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:00:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 00/11] CQ waiting / task_work optimisations
Message-Id: <167346002056.137564.9207330077149864406.b4-ty@kernel.dk>
Date:   Wed, 11 Jan 2023 11:00:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-42927
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 09 Jan 2023 14:46:02 +0000, Pavel Begunkov wrote:
> For DEFER_TASKRUN rings replace CQ waitqueues with a custom implementation
> based on the fact that only one task may be waiting for completions. Also,
> improve deferred task running by removing one atomic in patch 11
> 
> Benchmarking QD1 with simulated tw arrival right after we start waiting:
> 7.5 MIOPS -> 9.3 (+23%), where half of CPU cycles goes to syscall overhead.
> 
> [...]

Applied, thanks!

[01/11] io_uring: move submitter_task out of cold cacheline
        commit: 8516c8b514839600b7e63090f2dce5b4d658fd68
[02/11] io_uring: refactor io_wake_function
        commit: 291f31bf963c0018a2b84a94388a0e7b535c3dae
[03/11] io_uring: don't set TASK_RUNNING in local tw runner
        commit: 5eb30c28823aed63946c9d2a222bf1158a3aecae
[04/11] io_uring: mark io_run_local_work static
        commit: 88d14c077c1a04555978c499acd12f5f55de51da
[05/11] io_uring: move io_run_local_work_locked
        commit: 78c37b460a63c866050d3e05d6d4bfddf654075e
[06/11] io_uring: separate wq for ring polling
        commit: 6b40f3c9a37b97e629a99a92d2c392d77ae20f60
[07/11] io_uring: add lazy poll_wq activation
        commit: e05f6f47bf8aed0e97d9ba1d52e2a10ea542609c
[08/11] io_uring: wake up optimisations
        commit: ef3ddc6ac629fc829ed6e08418e1c070332dde63
[09/11] io_uring: waitqueue-less cq waiting
        commit: 65ca9dd8ce5e3de42b100f0e7d2ae360e9b8d14e
[10/11] io_uring: add io_req_local_work_add wake fast path
        commit: 6cd16656e2ddc63ee7aae7c7f27edcab933a0e09
[11/11] io_uring: optimise deferred tw execution
        commit: 607947314b4c9f8c979f79c095da9156b41c82b8

Best regards,
-- 
Jens Axboe



