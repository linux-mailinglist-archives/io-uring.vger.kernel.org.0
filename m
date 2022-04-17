Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29745047C8
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 14:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiDQM5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 08:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiDQM5J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 08:57:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AAC326FF
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 05:54:33 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n18so10465257plg.5
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 05:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=8yGP9A6TXDe0gE8hex3e5uPUeUznAEHYrR6n0spy4KQ=;
        b=1TpWix6ramuO7Mphrdv0mdxSN9Z4z9FdFbGkFPENKrMmNHzkQCgVQP7heSpqjPywkF
         +S7YAn5sgbWkaXe1W19FX7NvrTJumLFejL+HIHHZgCNpx1iwmJg4G4OLc53gWPLwJvgs
         kbP3iGqwGeEXNhDrOMSo8T8mt5xkufQpGhPniyUAT7uOQEugIpgHh/cXIxIxGjtvClhC
         V1PyVlYBvCT9e0CbPPc9mavTJA/LOGoecD6AZlC0wEsak/HW+al2COW8QRQU8ips0sac
         PAxe/iit6GvyIAyixvVlVK6dV5x+fcTtNiuqIfYrXA37F/P6Pc1YpYEqGl2070xEURnZ
         r1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=8yGP9A6TXDe0gE8hex3e5uPUeUznAEHYrR6n0spy4KQ=;
        b=N1wwCSCu6QUQNqoZprPUSh0Ilm/hO9ShUsaXfGRfrcMSMvMvi3XsBXpDRWJQEDZQXI
         KhvsWCLBHqJXeDlmrqnf/pswtcewQoqP6zhrFJAbpMzbNaGCCdFVSDwfRPneOmef6IQd
         grCzPSH1AvZr/znG2Rb3y35DuweFWsxYletoPt4Eye/z9qvoy6xkG0+gV8lM4YmMydZb
         aS3q8KptVKCCidquitYBwv1AJG+m2W9DRdD7CnAcLEkSJJBUXgxSj0vSTE1xzyYgcv0F
         xZMII+jwY/iShd1cGMdCBc9usDOWN0TikXyCFe2r8a9D0h/VkSaVszyn4erLAIprr0Ng
         jLKQ==
X-Gm-Message-State: AOAM531VNw1jfSOtQvuTov9frqmyokHfyEJTBTLyrd0gPESQ8AWnkk33
        j5Q5mRxvVYdLIQOdxb63tMTeMlPPS8q8Z8qe
X-Google-Smtp-Source: ABdhPJzAjaozGKxr/wIdebfAPmq5+1pzEu2xO5lFxvTajCm4N9eElY0PaatUKmNzw6N7EdYbRYFQeQ==
X-Received: by 2002:a17:90b:3c01:b0:1d0:3c19:e1eb with SMTP id pb1-20020a17090b3c0100b001d03c19e1ebmr13879738pjb.48.1650200072807;
        Sun, 17 Apr 2022 05:54:32 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v27-20020aa799db000000b00509fbf03c91sm8665218pfi.171.2022.04.17.05.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 05:54:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <5072fc8693fbfd595f89e5d4305bfcfd5d2f0a64.1650186611.git.asml.silence@gmail.com>
References: <5072fc8693fbfd595f89e5d4305bfcfd5d2f0a64.1650186611.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: fix leaks on IOPOLL and CQE_SKIP
Message-Id: <165020007118.8177.8238194933142878483.b4-ty@kernel.dk>
Date:   Sun, 17 Apr 2022 06:54:31 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 17 Apr 2022 10:10:34 +0100, Pavel Begunkov wrote:
> If all completed requests in io_do_iopoll() were marked with
> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
> io_free_batch_list() leaking memory and resources.
> 
> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
> return the value greater than the real one, but iopolling will deal with
> it and the userspace will re-iopoll if needed. In anyway, I don't think
> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
      commit: c0713540f6d55c53dca65baaead55a5a8b20552d

Best regards,
-- 
Jens Axboe


