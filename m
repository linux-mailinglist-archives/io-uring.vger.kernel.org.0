Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD0A65DBCC
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbjADSFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 13:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbjADSFT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 13:05:19 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25D237502
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 10:05:14 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id q190so18397488iod.10
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 10:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJ16atabBJmvo4EAQ9XkQBMy0p6Ld+fZ02FYH4kZt90=;
        b=dfSMAkXNPaWwgMja/ROn0zWvL+U6zg58jKR+TYyvt+qWuvYVlbBoZUXKtffUeGNjIX
         HcZmiyQBqp5hd4DpilO7r7IIJJ1GCP3EXOYrlb5YqvI3y8IZIZbqXntHcwjrBD2zHIkh
         nr9VF26zysWnPk43r+OHQmZm1GO2Uf0QiIVxeNI1uUrbCp3naZlMD2Yh6ySHk1CUXWFW
         nI/i8wHr8MzLcffWdC4L+QKJ8JZCsndCqOD1qs8SYyEsXaZrp45Xrx+F8XQ1aJMV+90y
         AUyiR5gQJYozez2r45ZLMhWlS82i01j8U8Uty5RybaoYMnpIX5RyNQPmXGFIdlF2ZFTf
         /lNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJ16atabBJmvo4EAQ9XkQBMy0p6Ld+fZ02FYH4kZt90=;
        b=QPVFzwzHNj0W0kF2SVj9dTRpppHIbdGiOizzlohn/+4fG3/r4b2RsLchkmY3Hhf+NB
         fWrpBz29OlUg12dusNoZv2gfG/TByITq8j4/n8zxUayG9RejukJnoxq2sbJx3wCrjr0Y
         ZW4aYY0ySTieKZjKtLnzSU+621PgPyJ5WLl4DiXHrzKlhUBbM7nw1m6/TEfoRz4K35Ue
         NW0tEgt+40MeUFqSV83SqeQOsD5yf15bBWjthzAcQ/e65gwsFUEh5FAmPkYAgUuMnd/F
         1w4cKHwN6as0vSJC2MZQm5ZUXSwsjTD4dVI6gS9pcAlwut/wgorxS+7wZUwj4aOVEh3o
         ywYA==
X-Gm-Message-State: AFqh2kr4G+eybXYBigChBaN3DBkDX5R+tL0dOGLbBFlQUzTfmOQ7Yjla
        syKiQ9WRM4GSp3jijQqONgqEBQ==
X-Google-Smtp-Source: AMrXdXscS5LUQSFSlg5ZtdUkbjTwFMRRKuWv/noOKQYY8nqL+6cvRbpyCFMDCblLemQZ5DDDuBKbXw==
X-Received: by 2002:a5d:990e:0:b0:6df:128f:ca12 with SMTP id x14-20020a5d990e000000b006df128fca12mr5886179iol.1.1672855514185;
        Wed, 04 Jan 2023 10:05:14 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h13-20020a056602130d00b006cab79c4214sm6904465iov.46.2023.01.04.10.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 10:05:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
Subject: Re: (subset) [RFC v2 00/13] CQ waiting and wake up optimisations
Message-Id: <167285551322.71557.18019203197828529220.b4-ty@kernel.dk>
Date:   Wed, 04 Jan 2023 11:05:13 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-7ab1d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 03 Jan 2023 03:03:51 +0000, Pavel Begunkov wrote:
> The series replaces waitqueues for CQ waiting with a custom waiting
> loop and adds a couple more perf tweak around it. Benchmarking is done
> for QD1 with simulated tw arrival right after we start waiting, it
> gets us from 7.5 MIOPS to 9.2, which is +22%, or double the number for
> the in-kernel io_uring overhead (i.e. without syscall and userspace).
> That matches profiles, wake_up() _without_ wake_up_state() was taking
> 12-14% and prepare_to_wait_exclusive() was around 4-6%.
> 
> [...]

Applied, thanks!

[01/13] io_uring: rearrange defer list checks
        commit: 9617404e5d86e9cfb2da4ac2b17e99a72836bf69
[02/13] io_uring: don't iterate cq wait fast path
        commit: 1329dc7e79da3570f6591d9997bd2fe3a7d17ca6
[03/13] io_uring: kill io_run_task_work_ctx
        commit: 90b8457304e25a137c1b8c89f7cae276b79d3273
[04/13] io_uring: move defer tw task checks
        commit: 1345a6b381b4d39b15a1e34c0a78be2ee2e452c6
[05/13] io_uring: parse check_cq out of wq waiting
        commit: b5be9ebe91246b67d4b0dee37e3071d73ba69119
[06/13] io_uring: mimimise io_cqring_wait_schedule
        commit: de254b5029fa37c4e0a6a16743fa2271fa524fc7
[07/13] io_uring: simplify io_has_work
        commit: 26736d171ec54487de677f09d682d144489957fa
[08/13] io_uring: set TASK_RUNNING right after schedule
        commit: 8214ccccf64f1335b34b98ed7deb2c6c29969c49

Best regards,
-- 
Jens Axboe


