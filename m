Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C8D758D67
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 08:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjGSGEd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 02:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjGSGEc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 02:04:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106461BFC;
        Tue, 18 Jul 2023 23:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CF0760CFB;
        Wed, 19 Jul 2023 06:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4032DC433C8;
        Wed, 19 Jul 2023 06:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689746667;
        bh=qtff+jhbek/HyVQDlEy7SuLeEWoJ/yCblRZxa9O90T4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+3N3QPGYmpRCPY6cvzGcag/0ype2GgST2FDrgOeJsECt0KtdfH5N3ttaAjE2g4ty
         bc6SUfYoElbV7+tSh0ShQA9q6QbifHqdXRstBXC2YQ5ZHEVbmY1YAO4KpAje/fS1M6
         lNGTfqaLuaAbxOdtzwzvW79PkbnhqAWa+tY67YORbpNy0JZPdav9XV3W41B8MGhLwc
         OCR9G7QdTcujVapUJt2VyOYijVyj6pPHjG/zfp+NI8ZuQqtluNXaXyGGI8P0GoM2bM
         /W0WqAnYnnkWVO5SqyEjpc3wvhTwJhqJ0P8NwfVUgZRZrOO2CMqckQhTGrxt49ajv7
         GzPEjtLofpFLQ==
Date:   Wed, 19 Jul 2023 08:04:22 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v4 0/5] io_uring getdents
Message-ID: <20230719-sitzkissen-mehrverbrauch-612a4dfcdeb5@brauner>
References: <20230718132112.461218-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230718132112.461218-1-hao.xu@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 18, 2023 at 09:21:07PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This series introduce getdents64 to io_uring, the code logic is similar
> with the snychronized version's. It first try nowait issue, and offload
> it to io-wq threads if the first try fails.
> 
> Tested it with a liburing case:
> https://github.com/HowHsu/liburing/blob/getdents/test/getdents2.c
> 
> The test is controlled by the below script[2] which runs getdents2.t 100
> times and calulate the avg.
> The result show that io_uring version is about 3% faster:
> 
> python3 run_getdents.py
>     Average of sync: 0.1036849
>     Average of iouring: 0.1005568
> 
> (0.1036849-0.1005568)/0.1036849 = 3.017%
> 
> note:
> [1] the number of getdents call/request in io_uring and normal sync version
> are made sure to be same beforehand.
> 
> [2] run_getdents.py
> 
> ```python3
> 
> import subprocess
> 
> N = 100
> sum = 0.0
> args = ["/data/home/howeyxu/tmpdir", "sync"]
> 
> for i in range(N):
>     output = subprocess.check_output(["./liburing/test/getdents2.t"] + args)
>     sum += float(output)
> 
> average = sum / N
> print("Average of sync:", average)
> 
> sum = 0.0
> args = ["/data/home/howeyxu/tmpdir", "iouring"]
> 
> for i in range(N):
>     output = subprocess.check_output(["./liburing/test/getdents2.t"] + args)
>     sum += float(output)
> 
> average = sum / N
> print("Average of iouring:", average)
> 
> ```
> 
> v3->v4:

I'm out this week so will review next week.
