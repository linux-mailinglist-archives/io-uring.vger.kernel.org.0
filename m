Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0753ACCA
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 20:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiFAS2X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 14:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiFAS2V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 14:28:21 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E07F5DA10
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 11:28:20 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 25so3085803edw.8
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPM4MKJpXN9pL+rvxqojLTpYDWHVCDUZ3KK5EWpNZkY=;
        b=fWEwOWGDYOzZSfpZrXjlZWWtV1CGM7lC7juUmAdtI4ZJQRJConmtNpJRSTwTv0bdK3
         a6/4fGToWOSZIJo7zhXSO1XKZptScpGrMcUQlPFQPtiyQlrY9MlXBvX11mfYKKwtlIaq
         BKwGjc9O6YOCoOBMkciNjcxoa0JVZNdHbcCa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPM4MKJpXN9pL+rvxqojLTpYDWHVCDUZ3KK5EWpNZkY=;
        b=xyL8UTZNKke8WaawWCKx5h5KeDBQKtO40N9lRrhl3/f/tO/s3Ug2rUSiVOSJp+crfo
         5ZM7Uel3a2R51+4b5tAPivjthXywWS1kb9jOG4MWwWdpnhQLlqPgFL5b+kDnALTy1hxM
         b/W1UmNfOAOEvKeZoqCwPZ5x3q5rUXudMiKkzvtjt29y2yGxswOqudShKrWooiw70KO0
         Zo87a53I/GwWf/0l1GHLwZ44Y24iqlIuo2msq6/rI2sHxOrKBQHWHfJFMTlKc1zHlUh5
         OpDP+SJ3AbtkzBJjT+jX3dqEVg5wLSEA88+4cl2K9hNueqTjZjW9ArKPu3FzaChCncsG
         mSkg==
X-Gm-Message-State: AOAM5313sxdoFV8CCQU7xGnsatRtC7P+MrhesYCwo+SySJ8ul2pTfU1W
        Sp4Xer9lw0o+HxGBz2IIUaAA5oijNlAAPkRu
X-Google-Smtp-Source: ABdhPJzxEg51C/bqSeZlEFN4hlQjneNmNjcGkOtXPWXsxOjC2e27sx4h6lLbOCtihlIIAG3XPKYFsQ==
X-Received: by 2002:a05:6402:1941:b0:413:2822:9c8 with SMTP id f1-20020a056402194100b00413282209c8mr1191578edz.13.1654108098730;
        Wed, 01 Jun 2022 11:28:18 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id wc15-20020a170907124f00b006fee27d471csm954530ejb.150.2022.06.01.11.28.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 11:28:18 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id r9-20020a1c4409000000b00397345f2c6fso3522790wma.4
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:28:17 -0700 (PDT)
X-Received: by 2002:a05:600c:4f0e:b0:397:6b94:7469 with SMTP id
 l14-20020a05600c4f0e00b003976b947469mr29803062wmq.145.1654108097469; Wed, 01
 Jun 2022 11:28:17 -0700 (PDT)
MIME-Version: 1.0
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk> <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk> <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org> <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
 <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com> <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk>
In-Reply-To: <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jun 2022 11:28:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
Message-ID: <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
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

On Wed, Jun 1, 2022 at 11:21 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Of the added opcodes in io_uring, that one I'm actually certain never
> ended up getting used. I see no reason why we can't just deprecate it
> and eventually just wire it up to io_eopnotsupp().
>
> IOW, that won't be the one holding us back killing epoll.

That really would be lovely.

I think io_uring at least in theory might have the potential to _help_
kill epoll, since I suspect a lot of epoll users might well prefer
io_uring instead.

I say "in theory", because it does require that io_uring itself
doesn't keep any of the epoll code alive, but also because we've seen
over and over that people just don't migrate to newer interfaces
because it's just too much work and the old ones still work..

Of course, we haven't exactly helped things - right now the whole
EPOLL thing is "default y" and behind a EXPERT define, so people
aren't even asked if they want it. Because it used to be one of those
things everybody enabled because it was new and shiny and cool.

And sadly, there are a few things that epoll really shines at, so I
suspect that will never really change ;(

                  Linus
