Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F60E5916C0
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiHLVhq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 17:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiHLVhq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 17:37:46 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC76E9F1BE
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:37:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b16so2819857edd.4
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6AjamB/CT6k3zZN2iR0IHgYz9GvamMqXD/IQYECnac8=;
        b=C5lU9Pag1/XjwDO6+EX48jVC4pKZ0mIphl1XsqEIgxlgC5F+IYtSAasgRpCBVJ/zGJ
         qCXov6ISA12ZfFIZW8ELbI5UL9ALQ05DhhCY35Ilbr1mQQKtn1gM9eobOT1h2KJTIUXk
         wWyuQ4Qaz/QybF9B6FXq2uvdTRjA4jjgazlGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6AjamB/CT6k3zZN2iR0IHgYz9GvamMqXD/IQYECnac8=;
        b=IMGGaDL9tcUzI2JhMa1U/Iabt+lCGc8ZQKgJ6LkAwA7/WBokETA7OCLMWzTDaNHCCf
         6OEBrd3mjzuy21LrBwkECFq4XkrG1t2Oom1LRzMIMkoLDgvj+trkuYs0PxYdsIFO8XZ3
         X8VXES4arpDJOi7zC3KyqwLPTUGE+pRbW+YGhA3OBUCC1lgGrGe5z1rfTYmgghK2ernP
         q7mEmtAriMw803Vg4bLgeQksHEV7ltvbK0yC166zs0dGsoR9fYwko94hPbR9ZcxPjUYz
         QAmjIz3nF6jN1m/tZNW9h0NlfIyPoaKVNsksaHB69G0AMiLLZWtCyr6ElaNBWtqvo3HU
         0VWA==
X-Gm-Message-State: ACgBeo2PohRcPqsrdFK30pWx8vQMF6KTkwEFOkY5snM4Oo8DtnKeewA1
        rJEIxggdTIpxEKEF3YO4L6g5LIT1dW5mkNG3
X-Google-Smtp-Source: AA6agR6TZUgwglxbAZvHOGr/E3hhJD6LzL++tgEcceY4mNDG6vuI+p7LF8j981XHwEHfNazW9yni+A==
X-Received: by 2002:a50:fb99:0:b0:43c:d008:d4f9 with SMTP id e25-20020a50fb99000000b0043cd008d4f9mr5193573edq.13.1660340263186;
        Fri, 12 Aug 2022 14:37:43 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id lb2-20020a170907784200b0072f441a04a6sm1213408ejc.5.2022.08.12.14.37.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 14:37:42 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id p10so2421035wru.8
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:37:42 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr2903970wri.442.1660340262056; Fri, 12
 Aug 2022 14:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk> <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
In-Reply-To: <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 14:37:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiRCNGJNYCAMsGw8Ow08QatHRg0Ri+AjWhGB6F0ccKBMQ@mail.gmail.com>
Message-ID: <CAHk-=wiRCNGJNYCAMsGw8Ow08QatHRg0Ri+AjWhGB6F0ccKBMQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 2:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> I re-did an allmodconfig, and also built on arm64,

Note, while I now do build on my arm64 setup a couple of times daily,
this was just the regular x86-64 allmodconfig.

> and I have to say I'm  puzzled with what you are seeing.
> Updated to latest master as well, nothing.

I've done "git clean" on my tree and re-did the merge, and will see if
it goes away.

I *do* have things like the gcc plugins enabled, and I could imagine
that randstruct might possibly make structures have different sizes.
And those kinds of things get reset by "git clean" when it generates a
new seed..

              Linus
