Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6999F6BBE16
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 21:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCOUoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 16:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjCOUoF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 16:44:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6A660424
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 13:44:03 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id t129so8376628iof.12
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 13:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678913042; x=1681505042;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVbNewAl7WWQFUh8x7OTgNmK/vzQ9xLJ0WJgN2KttLs=;
        b=xJX9LGUwOvMWE7joYraKjr2s0OzNFpuSrdXTgEIbalYG3hqkIUWuQFTer8vqf6Q47F
         W55qjVyK1A5rsJW5ZV8HuUmjCTj/CPYcxopnhw0qWTiWB+gvy1akH9Y1pTARcDWYM77j
         XouegIgBBMf7Glbk5eWBhyQoGZSGBFhFwt8oziIEvD2G6IxprMC3Kdh3Bs04r0+8p9fl
         7C04+p4FP526BGLw+JH+We3mbtGTTquhftCtCCR7qk1kvbp5wzxiDNn80f6rq0hZqoJi
         fJt8/hMeCei4u4nzcxsLgioxxlOF2yFokdMHhpEc3uAs83O5oQAg3rj2xCVoP9AUAD4j
         DPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913042; x=1681505042;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVbNewAl7WWQFUh8x7OTgNmK/vzQ9xLJ0WJgN2KttLs=;
        b=LtvqoF9vBBY1tHaO5X4E4wsSwvkx22HcnMxvn4pkqTjI5yM2S1abYiaSbSRwgF2hqZ
         FoBvqDgbacwaXaI2gvcJCgp+wrD1ThwkEKww3mo1yibPtAYCBbyWmuQ03T1fvZmbxOso
         6A1QSvZXQPGtXXE78iNcWYKMrQmRECM/2n0bBzqWWERzbuvxKir28zA0fo+R2Ep7k8dI
         jEeclVfz+bdTSb8sFjHWkGn6Lrc+QJUz6pQGIDMJgmIW/MHBv/745inEKe6p24xmYEgQ
         US7SY6/r6xKq1vrKUlXHDfKmCH4/IyOY9PP7eiziSo43gQluNFvh4NNLMBN2IjFg3pyl
         uv1Q==
X-Gm-Message-State: AO0yUKUFGKuDj23yL9lyFEvJzEYthzfOefoGzodQz4brIC79UcCwyv0/
        Xg7D0z2OwvT26sN7sWf4nUmDs2EN4cCEG6kvIuY/vA==
X-Google-Smtp-Source: AK7set9LtBdTc4/XsJuNiuOKLjpH7H3YT2JgHVR8skcSmqPXD1A5qP0Mk2LMrGia7Hcd1cBsnFTpYQ==
X-Received: by 2002:a6b:6e08:0:b0:74e:8718:a174 with SMTP id d8-20020a6b6e08000000b0074e8718a174mr2501465ioh.1.1678913042658;
        Wed, 15 Mar 2023 13:44:02 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c21-20020a02a615000000b0040618ad53aesm835924jam.31.2023.03.15.13.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 13:44:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Breno Leitao <leitao@debian.org>
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
In-Reply-To: <20230310201107.4020580-1-leitao@debian.org>
References: <20230310201107.4020580-1-leitao@debian.org>
Subject: Re: [PATCH] io_uring: One wqe per wq
Message-Id: <167891304198.106283.16674521434746961243.b4-ty@kernel.dk>
Date:   Wed, 15 Mar 2023 14:44:01 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 10 Mar 2023 12:11:07 -0800, Breno Leitao wrote:
> Right now io_wq allocates one io_wqe per NUMA node.  As io_wq is now
> bound to a task, the task basically uses only the NUMA local io_wqe, and
> almost never changes NUMA nodes, thus, the other wqes are mostly
> unused.
> 
> Allocate just one io_wqe embedded into io_wq, and uses all possible cpus
> (cpu_possible_mask) in the io_wqe->cpumask.
> 
> [...]

Applied, thanks!

[1/1] io_uring: One wqe per wq
      commit: c122b27ea454f5f8ed3066964c67e9aea4e11fc8

Best regards,
-- 
Jens Axboe



