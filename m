Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59F54E5224
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 13:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbiCWM3w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 08:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCWM3u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 08:29:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B21205E4
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:28:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so3560206pjo.1
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=3QUSlCPNSFDVUsCZtdpmCulnCj8TUzoY2eIV3HnCT0M=;
        b=LBQMfBJiYBYfw6DUrvzLTYlfzo8Q4RwhAqv+3URyzxaZxpwpg/e15/+kPJCfnuBVJV
         2pMKym5kQvbwjO2BJsUK90hcZE+hYPWMVq5fAYZdB1CL5XFmL1Ul2mikL+tjc4fbF2u0
         xFJHlraMuqp90qY5pkIH2Gxcz2CWM7yTxAO+PkL/KFVW51BpkQONwkrHOoDACwz3mWLQ
         l5tDie+c9D++2FdfmoSaqZV4QErbR7fis2PMt34FBiKDSbkXCErr+Qj+K/9xtU8NH8mf
         Tkp3XS7JNuoLsnOrWujpx6WmSRt8XfKes6mNJPeMaELgQqDoBW0e4WWRvnP1fe2jZ5q5
         Z+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=3QUSlCPNSFDVUsCZtdpmCulnCj8TUzoY2eIV3HnCT0M=;
        b=7UXOv6NiZDTWjSCekr5/fDl7zf2R8i/o8pWrkEX5QCbF8AUbZzFM3vUT7tK6WrZhIY
         1kOAijPxcKYSHZN5EibaY755KFXlDIbluiL76rg3IVtTUxdSg1uu2UZbb6SiBYlDspJw
         iDwiDWRNfcX42WZvxixpqK/vRUjjdxMzMI/U9l7zCNp5gPsb+KtepnlBlDXWxdfroHso
         rjacOi49/WUlALRfjFdnmZmK1G/0tK5oabfv0hShxOKO91HM66sv+vpMKJEgbE6Jeizo
         myDeWAum/Fw+85zGHgIkWhXn+P4PhD5IJWpAGvo3NJwr8I9xYyFUK2y/wDQGVzWZluX+
         IvAQ==
X-Gm-Message-State: AOAM531oEHwd1IYpC90yn9CFGqpGYRR9WdtVbb2fxikpEOlErpOd76KR
        yKl5nU/wMFkv7VxDCLv6Zm2nfA==
X-Google-Smtp-Source: ABdhPJxYTW2LDjYCz+Ew/pFmHXriKxWDWRbJWWSgcdiqTfdGsz+x+taloEyStPhqKqxQaubmasyHcg==
X-Received: by 2002:a17:90b:3907:b0:1c6:a16b:12e3 with SMTP id ob7-20020a17090b390700b001c6a16b12e3mr11219485pjb.157.1648038497176;
        Wed, 23 Mar 2022 05:28:17 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n52-20020a056a000d7400b004fad9132d73sm2416216pfv.129.2022.03.23.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:28:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <669d91dd881a4f7c86104b9414fa3d12477b2669.1648032632.git.asml.silence@gmail.com>
References: <669d91dd881a4f7c86104b9414fa3d12477b2669.1648032632.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: null deref in early failed ring destruction
Message-Id: <164803849637.11141.17827246402159702749.b4-ty@kernel.dk>
Date:   Wed, 23 Mar 2022 06:28:16 -0600
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

On Wed, 23 Mar 2022 11:14:54 +0000, Pavel Begunkov wrote:
> [  830.443583] Running test nop-all-sizes:
> [  830.551826] BUG: kernel NULL pointer dereference, address: 00000000000000c0
> [  830.551900] RIP: 0010:io_kill_timeouts+0xc5/0xf0
> [  830.551951] Call Trace:
> [  830.551958]  <TASK>
> [  830.551970]  io_ring_ctx_wait_and_kill+0xb0/0x117
> [  830.551975]  io_uring_setup.cold+0x4dc/0xb97
> [  830.551990]  __x64_sys_io_uring_setup+0x15/0x20
> [  830.552003]  do_syscall_64+0x3b/0x80
> [  830.552011]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Applied, thanks!

[1/1] io_uring: null deref in early failed ring destruction
      commit: 0c25be9a68eb6475fc934782a4be404f13a6e025

Best regards,
-- 
Jens Axboe


