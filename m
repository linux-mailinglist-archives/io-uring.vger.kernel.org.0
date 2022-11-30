Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E2663DCB1
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 19:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiK3SHe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 13:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiK3SH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 13:07:26 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640277463E
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 10:07:25 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id b2so12839593iof.12
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 10:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VBuj+XyUGo2hPGeYMqHu9EA8J/GArKmB1X5X852NLrQ=;
        b=oDxHisFs9B+++m5a+n/mlWNuZzooHhY6ZyzulNTnWb5bdS0FIt0DxaSD9T4JG+Yruj
         l0bKKQ/sOeGdBCkZtR8PJXALRHm8BJdBdXSmdRR48tAMXxpVcgxuDokEzCGqK5Lp7Yta
         4toRUYAQfNtMU/CAI/1PhNDXaYuR35axtmuceKCDk42ZJO9AeKsURvVe7I+a7JSqiSKO
         w937RDRIEY/SNbwqSUOR27GkSh3wFvJoWdpH/F5Q+uOGtGTBmJc9+zodaVNGCYhiFA54
         1f0v8/08AHw3d6+QNb6Eg7tEOpS08a2QslrZdqO/gKVw+L/7dmOtHyNYGNhu3Z0nfDDi
         /ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBuj+XyUGo2hPGeYMqHu9EA8J/GArKmB1X5X852NLrQ=;
        b=s6hRgsAgNWg4KLbEgaVwqNwPmqXJRejlH6Jktki+Uet5yK0zSDfbf8sgQ77C5Q6atY
         UdlQ14PCn5lEKfYJLO33n0pKFaRJsnpNLQDavEBZrHPnEK7NWcqT71YFsigxgjhhYyIg
         sq5T7EHw7UF8nL6W8Db1Bp1VoyOEt7TTD8nbcauqCpm68CkvnJZ9xOP7XC85/uSAd8hD
         wT7l27sNye7cIuqDTUi1zPuiTM2Io14TdALA3/inOmspiOBtckcmrM7YbrBSPiEYGdry
         Ht8T88iRWTKok4ZqeUX3ou5ypwCN/BIzxHji41L00fgNuWLoIzA79W/laa9aNXccbNzd
         e6oQ==
X-Gm-Message-State: ANoB5pl7POm7xK60x7gX/WBg7kx4yS5tKjEh3SnuYxsvBynBzUt6n0hA
        jIgzUAzeFoSSPsKQse4OovovAoOpzl4DLBWG
X-Google-Smtp-Source: AA0mqf4x78joQK3cWKCDic/IWGezW1SOht/JlY8NVM7i5P15O3ZN/Er+ARRjCTF9gL35Y6zgJJbuPA==
X-Received: by 2002:a02:6662:0:b0:363:69a0:837f with SMTP id l34-20020a026662000000b0036369a0837fmr22748098jaf.57.1669831644648;
        Wed, 30 Nov 2022 10:07:24 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a17-20020a056638059100b00389e336e92fsm788477jar.75.2022.11.30.10.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 10:07:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/9] poll & rsrc quiesce improvements
Message-Id: <166983164398.206330.11704530812963500010.b4-ty@kernel.dk>
Date:   Wed, 30 Nov 2022 11:07:23 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d377f
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 30 Nov 2022 15:21:50 +0000, Pavel Begunkov wrote:
> A bunch of random patches cleaning up poll and doing some
> preparation for future work.
> 
> Pavel Begunkov (9):
>   io_uring: kill io_poll_issue's PF_EXITING check
>   io_uring: carve io_poll_check_events fast path
>   io_uring: remove ctx variable in io_poll_check_events
>   io_uring: imporve poll warning handling
>   io_uring: combine poll tw handlers
>   io_uring: don't raw spin unlock to match cq_lock
>   io_uring: improve rsrc quiesce refs checks
>   io_uring: don't reinstall quiesce node for each tw
>   io_uring: reshuffle issue_flags
> 
> [...]

Applied, thanks!

[1/9] io_uring: kill io_poll_issue's PF_EXITING check
      commit: f6f7f903e78dddcb1e1552b896e0e3e9c14c17ae
[2/9] io_uring: carve io_poll_check_events fast path
      commit: 9805fa2d94993e16efd0e1adbd2b54d8d1fe2f9f
[3/9] io_uring: remove ctx variable in io_poll_check_events
      commit: 047b6aef0966f9863e1940b57c256ebbb465a6b5
[4/9] io_uring: imporve poll warning handling
      commit: c3bfb57ea7011e0c04e4b7f28cb357a551b1efb9
[5/9] io_uring: combine poll tw handlers
      commit: 443e57550670234f1bd34983b3c577edcf2eeef5
[6/9] io_uring: don't raw spin unlock to match cq_lock
      commit: 618d653a345a477aaae307a0455900eb8789e952
[7/9] io_uring: improve rsrc quiesce refs checks
      commit: 0ced756f6412123b01cd72e5741d9dd6ae5f1dd5
[8/9] io_uring: don't reinstall quiesce node for each tw
      commit: 77e3202a21967e7de5b4412c0534f2e34e175227
[9/9] io_uring: reshuffle issue_flags
      commit: 7500194a630b11236761df35fef300009d7d3f6f

Best regards,
-- 
Jens Axboe


