Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA853AD7E
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 21:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiFATbQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 15:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiFATbK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 15:31:10 -0400
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E3817CE62
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 12:28:47 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id be31so4368482lfb.10
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 12:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G7ZzUn9B48Q9pcoedcD+QVLsjxYKZ/e29+5MXyJu0UM=;
        b=WLZ+fNqOQ6MxGuwNMW13Xc0SslBSLkI3YM2Iog839KoGaqq+5XvpCdz7e2VKNw2Fmy
         ZLYTeLiadNkYnfp9ROZfY2Ntiy0iXdwWT8OoaX4Vbe8eWkAoUfFWGeBmeu/fuw8yvl7c
         6qxajQCEoUpyi5ZSzaMMbb3JqVrxCxpYzl0iU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G7ZzUn9B48Q9pcoedcD+QVLsjxYKZ/e29+5MXyJu0UM=;
        b=gFUgw9mKF+4YsPqMSOI/sbEOaaz4HKCfA2/PaahTtSHFSsFKRI2cHcUifFd8m2lHZG
         MErSa1kz72BMJ6MiGc7ZCS/Qz4vBlVUGI0LsF9NMIoExmBP8aAWys9tebEYZcb6DqGLI
         4Q4AyqvawNJmVE9jjqn4d7/yDeMx4Gh4bVzR0X+qIHxArTKlb8Qs3zYhy5CHtJ0bZynw
         sd7hG6tfajxd7/j3zdr69/X9+zaXo0eyXufaJvn7xXdbbZcPnffIj+ZHxBNkgY6igG5T
         DDbmP6i+R2uHTU1pSJUM1TcQYy/6747CvpfHjRcarLOdpJQTZnqVJhMFX8dNlw2YFxGp
         Pmzg==
X-Gm-Message-State: AOAM5307ColI1no0Hhd1x4rlKZvhPaqs7J8DQcbcCNNJYPLD2wFc7Kkz
        3KX05xIe5aP4a7NoMip4cxkwMKUuZCzOfjoM
X-Google-Smtp-Source: ABdhPJyZ8w2/G+r0EgXKj+svEr9JuMdXmVDQ/IYWQ1hc6NK4uNjrs2ExBI+UjyoZ7jUrCahiczN8yg==
X-Received: by 2002:a05:6402:524c:b0:42e:320:bfbc with SMTP id t12-20020a056402524c00b0042e0320bfbcmr1401617edd.65.1654111242376;
        Wed, 01 Jun 2022 12:20:42 -0700 (PDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id oq3-20020a170906cc8300b006fe921fcb2dsm998253ejb.49.2022.06.01.12.20.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 12:20:41 -0700 (PDT)
Received: by mail-wm1-f44.google.com with SMTP id c5-20020a1c3505000000b0038e37907b5bso3624521wma.0
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 12:20:41 -0700 (PDT)
X-Received: by 2002:a05:600c:4f0e:b0:397:6b94:7469 with SMTP id
 l14-20020a05600c4f0e00b003976b947469mr29967475wmq.145.1654111241328; Wed, 01
 Jun 2022 12:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk> <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk> <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org> <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
 <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
 <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk> <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
 <a59ba475-33fc-b91c-d006-b7d8cc6f964d@kernel.dk> <CAHk-=wg9jtV5JWxBudYgoL0GkiYPefuRu47d=L+7701kLWoQaA@mail.gmail.com>
 <ca0248b3-2080-3ea2-6a09-825d084ac005@kernel.dk>
In-Reply-To: <ca0248b3-2080-3ea2-6a09-825d084ac005@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jun 2022 12:20:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgyuXmicd2Jk80Y3-3jwXQgYGid2J1nm58c2yVrRxdjhw@mail.gmail.com>
Message-ID: <CAHk-=wgyuXmicd2Jk80Y3-3jwXQgYGid2J1nm58c2yVrRxdjhw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 1, 2022 at 12:10 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> I mean only for the IORING_OP_EPOLL_CTL opcode, which is the only epoll
> connection we have in there.

Ok, that removal sounds fine to me. Thanks.

             Linus
