Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31066600419
	for <lists+io-uring@lfdr.de>; Mon, 17 Oct 2022 01:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJPXI5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 19:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJPXIz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 19:08:55 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D685027FF0
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 16:08:54 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id o22so5723617qkl.8
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 16:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTItkGpcJFcQMiIoUClmMnkSaCR621YqnGPsJuywZ4E=;
        b=IRkpjaprCFGI5Xe8F2EO8Rs1I/xI+Vwx7CQ0Cav5o45ztNQ+HlFj+3lto+qqZTIxPQ
         piowHQUPj4S62CcUagCjPNBZEh3oHXrxkQTQQfuzYP+6DM64THrNNZHxA43/mdiGJ1BC
         oALp6ZzZvpaXVJZ2CSJjXlU5DBnqYmKVKPgOKfCufnZAfvJrN+o5rfcPiIHad3Ba+5ww
         NuMBgpXyojGsYZ7zkLAVVxwOxTSuhHQ77zPssLE3bhCzZ1DiFcKSRPjFujGmxNNRfjiK
         XcdvV+xxjiKkkB/XZ2s+3y2xZWQFynVm00xiFC1vUhDfMpuwdwY7UPV5rAUadHBSiiKQ
         3FIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mTItkGpcJFcQMiIoUClmMnkSaCR621YqnGPsJuywZ4E=;
        b=a1syABuc+NSKPmwohq3A5yMEI8VGGHnyJlN5Dni1TtDO5F901cdRb7+fvZ3lof2GKv
         dORelWNlml7YOOr7wUw5Ewsp/iB2uf86nibPg3g9JF/bOCW4Zjzosd/W6l6b+mQMyDju
         9i7sxAGIOb851rTnu3shAQfX6noJDkj+5ZMVu65QqRWfZg0n1Ke+mtHOhJ0NNkfJMlu4
         PY5nI7T+uv+/H3Hh45fuCYFVEvhfLibCBPCZAPdcXNGhcCFJTcbZsyimEN6eXKoR9Ajz
         zSNItHaILNbUSLOfPwJYC3MVTdnbrZPuLnql8DugVjCWVk1H033BE3T4DwvIRaDmhXvr
         o+QA==
X-Gm-Message-State: ACrzQf22H4a7uCsscRN99BjizRBTC0QXy7pts4zN3J5Ust5zYFD+qQxu
        L9J23mmQc2liDdTUyh0RET5/tENOB/JgHWW4
X-Google-Smtp-Source: AMsMyM53oYnTy8TS9tHB++pCwCiPVrZ+Csp92kzAiUSlN4AOTb6HURvE2KWem0hf+SAllO9fe6IeJg==
X-Received: by 2002:ae9:ed42:0:b0:6ee:a214:a560 with SMTP id c63-20020ae9ed42000000b006eea214a560mr5936305qkg.528.1665961733971;
        Sun, 16 Oct 2022 16:08:53 -0700 (PDT)
Received: from [127.0.0.1] ([8.46.73.120])
        by smtp.gmail.com with ESMTPSA id j6-20020a05620a288600b006ced196a73fsm8029937qkp.135.2022.10.16.16.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 16:08:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1665891182.git.asml.silence@gmail.com>
References: <cover.1665891182.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/4] random io_uring cleanups
Message-Id: <166596173110.5701.10874734669023751358.b4-ty@kernel.dk>
Date:   Sun, 16 Oct 2022 17:08:51 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 16 Oct 2022 21:30:47 +0100, Pavel Begunkov wrote:
> A small cleanup series partly following up after recent fixes.
> 
> Pavel Begunkov (4):
>   io_uring: remove FFS_SCM
>   io_uring: kill hot path fixed file bitmap debug checks
>   io_uring: reuse io_alloc_req()
>   io_uring: don't iopoll from io_ring_ctx_wait_and_kill()
> 
> [...]

Applied, thanks!

[1/4] io_uring: remove FFS_SCM
      commit: 38eddb2c75fb99b9cd78445094ca0e1bda08d102
[2/4] io_uring: kill hot path fixed file bitmap debug checks
      commit: 4d5059512d283dab7372d282c2fbd43c7f5a2456
[3/4] io_uring: reuse io_alloc_req()
      commit: 34f0bc427e94065e7f828e70690f8fe1e01b3a9d
[4/4] io_uring: don't iopoll from io_ring_ctx_wait_and_kill()
      commit: 02bac94bd8efd75f615ac7515dd2def75b43e5b9

Best regards,
-- 
Jens Axboe


