Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED572605581
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 04:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiJTC0p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 22:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiJTC0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 22:26:38 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28031C2F16
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 19:26:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u6so1494359plq.12
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 19:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zH/lcm6LmIXvgGP1ltmqCC3mJjw/Vvw4xUY5ydYPviw=;
        b=ilEEMWRnUl3o49fNEPGwCo+yy7Lklg/mWQuFr9uNU+Od4sCkzxROw6s2pk9C1PUpz0
         UGFE1VKwiHehojbJTf4JiS+G1x+G2qZcptiODeMpQtG083R/1hxG2H3tfhrWvMMpBN5W
         J8p+RBvYpnA5Ow2Jq1w37xhs7q2I7H/Oeyo8UpfJjA2g/Up6Hd/u+9t27wkUWeQ1z4+N
         woqEO97+2DawOh0kbE+IvRNboPgGKHtdQJb1zp2WcHtZakh9z4eoL11u+D2THcoNY3hQ
         C6EAU9hDeXHJBwoE5ac3D77ZpP/LauDjQpgmQhafl9gCpP93vrVejX8XrvmyiR0x718k
         jcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zH/lcm6LmIXvgGP1ltmqCC3mJjw/Vvw4xUY5ydYPviw=;
        b=BWmEwWEqul9yeUpngch9120GPo6dlI5z8XeC/heI0I2S7YYYWqt/CiJ2RQankHZ1/h
         Rn3Wodkbet5gEJqwLKGdTKVkLT5gU23q+zboQBNY21dVYb5fZp3Nonay/xPDj8bcTqs8
         qYFAbTRYVIkn9HU1nNupIudLYPN9oLxFdsZLD/CrsLZa+krkav23BW7OOwWYKBPlia6K
         XVFEE5GV8ByR50kQc/wk1hxFMQup0CJrV0vi+xN/ttUDb7q96HBVYJ4/aMGE9acvZgCW
         kw3A/8AC+uB7/1sPav1D7LRISc6AOre+CDsL40g57F2evaoDrmEkSQlOgnX0ecxKPet5
         LSgg==
X-Gm-Message-State: ACrzQf3nGA7ugIzOwsBI5N46JV2z4D6X8UIPVD5lzPJ9nfAGaZ8kO9ij
        xBpBlR4yTyOEY1V5ABDyq6MNKS9Sp8iOnqYe
X-Google-Smtp-Source: AMsMyM7c8RTmfI+75QrXdZQGyYNNXuzZYsJrOTCHFJN7lC6X/4vpOGOmoZtTK1Kh0qp/J3bexjiSUA==
X-Received: by 2002:a17:90a:8c8e:b0:202:883b:2644 with SMTP id b14-20020a17090a8c8e00b00202883b2644mr48398722pjo.89.1666232791147;
        Wed, 19 Oct 2022 19:26:31 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n190-20020a6227c7000000b00565cf8c52c8sm12435892pfn.174.2022.10.19.19.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 19:26:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Rafael Mendonca <rafaelmendsr@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221020014710.902201-1-rafaelmendsr@gmail.com>
References: <20221020014710.902201-1-rafaelmendsr@gmail.com>
Subject: Re: [PATCH] io-wq: Fix memory leak in worker creation
Message-Id: <166623279015.153364.8618304798678076215.b4-ty@kernel.dk>
Date:   Wed, 19 Oct 2022 19:26:30 -0700
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

On Wed, 19 Oct 2022 22:47:09 -0300, Rafael Mendonca wrote:
> If the CPU mask allocation for a node fails, then the memory allocated for
> the 'io_wqe' struct of the current node doesn't get freed on the error
> handling path, since it has not yet been added to the 'wqes' array.
> 
> This was spotted when fuzzing v6.1-rc1 with Syzkaller:
> BUG: memory leak
> unreferenced object 0xffff8880093d5000 (size 1024):
>   comm "syz-executor.2", pid 7701, jiffies 4295048595 (age 13.900s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000cb463369>] __kmem_cache_alloc_node+0x18e/0x720
>     [<00000000147a3f9c>] kmalloc_node_trace+0x2a/0x130
>     [<000000004e107011>] io_wq_create+0x7b9/0xdc0
>     [<00000000c38b2018>] io_uring_alloc_task_context+0x31e/0x59d
>     [<00000000867399da>] __io_uring_add_tctx_node.cold+0x19/0x1ba
>     [<000000007e0e7a79>] io_uring_setup.cold+0x1b80/0x1dce
>     [<00000000b545e9f6>] __x64_sys_io_uring_setup+0x5d/0x80
>     [<000000008a8a7508>] do_syscall_64+0x5d/0x90
>     [<000000004ac08bec>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Applied, thanks!

[1/1] io-wq: Fix memory leak in worker creation
      commit: 839a0c962971a5a95515c1637aede8a4fbc6547f

Best regards,
-- 
Jens Axboe


