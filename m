Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D7865F014
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 16:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjAEP2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 10:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbjAEP2k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 10:28:40 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A4A4EC8F
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 07:28:39 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id u8so13531905ilg.0
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 07:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oj7iLjnWkH5gDwAnrfgqJ4cCUNF3FzurlF6mG1ute80=;
        b=zG9No1euWZZVOTvxMUHs2FoJSkwI8f7FUwkWgDfEkTe0C4N1AVO7EMJnwLd+ounwV6
         jNWCe2D1CPdB0TiUSedIyA09pAXAPlkw2STC9Mar+zDrzhSgs084hMmL6VsRathmUpWh
         5VT1LJwRMsmS+7DrqXHJouelcnqwLFYv1icXkhiFlTwS/t959UHEv4tCoCFe94SUcOkW
         F1dIZawkjFkehs8aNEhhsT0W4M53qPilbZ6e831Gc3o7spZt+hN3RPFVGC8dhRxi2+Ic
         zqZye7NAsBc4XTTw+dRSPWByGZuKCHY8bY93gkWMmVFS7DWkOl7DdZDbNfbEsBbuxE8O
         4ytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oj7iLjnWkH5gDwAnrfgqJ4cCUNF3FzurlF6mG1ute80=;
        b=lKCPkZ5MsVcgSKH+sp9kOIQdlbRPZzCBWheDrE/acd0LeMQmkUV7YIkhyjapEzu17x
         dgIeojKi5c+khW0EVRf2Nk4vYeak+WyxteQeqUsshZ8Fdyasb68vnGKTAu+G/8X4qZGE
         WNBagJBAodSVnGZOgq5TH4prXS10Jq2/yhgJYNJa4CYrpO7j6BXXzDfRNBy4yqwNcukr
         6XU2PlmVt9zQbRTAlKgSBPNzTqp+aUIybYPTfjfjNmWmePwRi27/iOXk68tTuzRWYaNF
         BvrNJfKyprF6EUvUYHPIhaiTCOXlPN3T2FD5BVSgTLSsJcpZglIMrGcd49ZUTfwBgJGR
         hXig==
X-Gm-Message-State: AFqh2kq2e2K7TuXVlFasYQlPW/gBPRHgrR5V0BcqV7h+gWk3sKDXnY8u
        UQz9HyskNmyuVd0yqdIEdm7//6ZS+Kl1vnEZ
X-Google-Smtp-Source: AMrXdXtgx2fkbZPXpAT5y4DlpGi0nhsdzRGfVUqnYHnp8enlJdB3ygh2WHynUwcILtEuYd/noHUTkg==
X-Received: by 2002:a05:6e02:d0d:b0:303:d8:f309 with SMTP id g13-20020a056e020d0d00b0030300d8f309mr6447047ilj.2.1672932518675;
        Thu, 05 Jan 2023 07:28:38 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f23-20020a02a117000000b00363cce75bffsm11508148jag.151.2023.01.05.07.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 07:28:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
Subject: Re: [PATCHSET REBASE 00/10] cq wait refactoring rebase
Message-Id: <167293251803.7799.9514250702866509424.b4-ty@kernel.dk>
Date:   Thu, 05 Jan 2023 08:28:38 -0700
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


On Thu, 05 Jan 2023 11:22:19 +0000, Pavel Begunkov wrote:
> Rebase of 6.3, i.e. recent CQ waiting refactoring series on top of
> just sent 6.2 patch ("io_uring: fix CQ waiting timeout handling").
> 
> Apart from that there are 2 more patches on top, 9/10 squeezes
> an extra 1% of perf for one of my tests.
> 
> Pavel Begunkov (10):
>   io_uring: rearrange defer list checks
>   io_uring: don't iterate cq wait fast path
>   io_uring: kill io_run_task_work_ctx
>   io_uring: move defer tw task checks
>   io_uring: parse check_cq out of wq waiting
>   io_uring: mimimise io_cqring_wait_schedule
>   io_uring: simplify io_has_work
>   io_uring: set TASK_RUNNING right after schedule
>   io_uring: optimise non-timeout waiting
>   io_uring: keep timeout in io_wait_queue
> 
> [...]

Applied, thanks!

[01/10] io_uring: rearrange defer list checks
        commit: d6d505fb8cafd1d78ca438fcd2d9a460c9695a1a
[02/10] io_uring: don't iterate cq wait fast path
        commit: ba5636ba85eb7b01bcbb03b8855ec444f78779ed
[03/10] io_uring: kill io_run_task_work_ctx
        commit: a95f8ea66f4804c9faeb51bf496008d09d43bf41
[04/10] io_uring: move defer tw task checks
        commit: 07ef9bf92577095d2e6612b010267f6bd5139936
[05/10] io_uring: parse check_cq out of wq waiting
        commit: 4a42b391367e7df55f8fd5f7a4e42cdf796ef36a
[06/10] io_uring: mimimise io_cqring_wait_schedule
        commit: 4fbb75ef0d9ed027d098394227596d91c59e246a
[07/10] io_uring: simplify io_has_work
        commit: 8d1f973f5025d62f88a9b3e4406c74c857ef49de
[08/10] io_uring: set TASK_RUNNING right after schedule
        commit: 2fc7bfa59e195d2a1fed638a35dde7ab794f0178
[09/10] io_uring: optimise non-timeout waiting
        commit: dc53cdbd5a63ef78c1acc34b2fda535bbcffd5c5
[10/10] io_uring: keep timeout in io_wait_queue
        commit: a367ffbe03a6da8d97f5f8057114bada90ccaea8

Best regards,
-- 
Jens Axboe


