Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA36379E3
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 14:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiKXNZL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 08:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKXNZL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 08:25:11 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78ED8EB46
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:25:09 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso5184466pjt.0
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTuZD1zhaQgPtH6ABGZHAVqqZ895k/czCwRBZ6kQb+s=;
        b=XOEelMiOQyf97Ji8rXVURetzE4gkmEqCM0Pc7T+vQF4bGJaPNmpyAOgiuNsPsI20cJ
         Zkc63xQ25DGtMCtpvF14eUjX2NUnkIo+Y76a3a3KKD8cqKpw2xdiabsJ+XHrzrIo9FX0
         pL7ERYLnraeWuFe+4AY9J7Z0CyZn+QqiZVd5qDyEKmulN9TOuCNhPCyK4Lq1UC1JmIkJ
         ww8Eshfu++cWpyCUEQv6kwLwjDq+puYohWx/zWn8N2UcqA1to0kqOfJznSUw3P9z3hV/
         206RQhnB1xSj5M26M0qbIX7xEnx0DUbBDoWyitI/w02hmhpyjZqq7MOTNJvsU3aQN4xy
         vhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTuZD1zhaQgPtH6ABGZHAVqqZ895k/czCwRBZ6kQb+s=;
        b=dbSWbpAnx43iWoK2DAN4VwBvEEeAFYZFnOOd+aMjcGSmhMZ3pt6zLVMvsteoygzc6E
         lhQm4tq2YRuV6Ald8IDrcswZQvogy6Y+IkfzHqnSzwZHpcpGuazA0YWDmdGKJRRBk4oH
         mDCs90G5uTN5YC9tMJwbdiJb1WnHteWJ3fK8CffVBfS9iMb/r8YwM6rZq2ffCD5H49UY
         K8y82+c3VjE1FA0COJ+3tS9jCeivM36vAdFkDEQdFY0LskDqr20bxl7JqyOa1pixdIHz
         T4ws4ogXtahrvYyOfDZHhIUNsdxqsEQsj0L00FwnDWy1DEFvSTwgv+fo6S+1X6OR6Mr5
         uwog==
X-Gm-Message-State: ANoB5pn6ibld1B2fnQJ1pSpfGC3a6NE+zZqsZffUKqoh78iu7pT9vhgk
        RP5pAiDwufveORuF2qLDb5zg9g==
X-Google-Smtp-Source: AA0mqf4JlM4E8UNDOGBwJx7U+cormhbJOzuZIiyxiKWlGnwUrTdtLrX7dYmKtd4AdMdGzpGxnod4fQ==
X-Received: by 2002:a17:902:e849:b0:188:ff96:a7df with SMTP id t9-20020a170902e84900b00188ff96a7dfmr14521390plg.38.1669296309283;
        Thu, 24 Nov 2022 05:25:09 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902a38800b0018912c37c8fsm1278130pla.129.2022.11.24.05.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 05:25:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
Subject: Re: [PATCH for-next v3 0/9] io_uring: batch multishot completions
Message-Id: <166929630828.50735.17664587654563028601.b4-ty@kernel.dk>
Date:   Thu, 24 Nov 2022 06:25:08 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 24 Nov 2022 01:35:50 -0800, Dylan Yudaken wrote:
> Multishot completions currently all go through io_post_aux_cqe which will
> do a lock/unlock pair of the completion spinlock, and also possibly signal
> an eventfd if registered. This can slow down applications that use these
> features.
> 
> This series allows the posted completions to be batched using the same
> IO_URING_F_COMPLETE_DEFER as exists for non multishot completions. A
> critical property of this is that all multishot completions must be
> flushed to the CQ ring before the non-multishot completion (say an error)
> or else ordering will break. This implies that if some completions were
> deferred, then the rest must also be to keep that ordering. In order to do
> this the first few patches move all the completion code into a simpler
> path that defers completions when possible.
> 
> [...]

Applied, thanks!

[1/9] io_uring: io_req_complete_post should defer if available
      commit: 8fa737e0de7d3c4dc3d7cb9a9d9a6362d872c3f3
[2/9] io_uring: always lock in io_apoll_task_func
      commit: ca23d244ec99cc1a7a1c91f6a25bb074ea00bff1
[3/9] io_uring: defer all io_req_complete_failed
      commit: d62208d1e2d73d9949c7c58518fbd915eacad102
[4/9] io_uring: allow defer completion for aux posted cqes
      commit: 8e003ae8505a7bb728cb158198ca88912818da70
[5/9] io_uring: add io_aux_cqe which allows deferred completion
      commit: 9101a50761cf126399014cbfa518804c75c64157
[6/9] io_uring: make io_fill_cqe_aux static
      commit: 84eca39b41bc03372d647db83319ec0f6c230cda
[7/9] io_uring: add lockdep assertion in io_fill_cqe_aux
      commit: 3827133217eb3cdcb3824b22a31b76bf106a2ae3
[8/9] io_uring: remove overflow param from io_post_aux_cqe
      commit: 48ca51e666ed91f75a548a460faa60d08cfd3af6
[9/9] io_uring: allow multishot polled reqs to defer completion
      commit: 41d52216bb00504be5cf08e2d5ec8a41d16d9a67

Best regards,
-- 
Jens Axboe


