Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA7953AC7A
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347215AbiFASJZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 14:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiFASJY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 14:09:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D96A076
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 11:09:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd25so3294283edb.3
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CzbH7yICGZIm+U4q29ju3SFNiy/MszOsB+ixiEcwYOc=;
        b=FSwoMm7ljUMv51RIxlqe4AR+VE3lAqrDsaA3iLoni06hLxNTPhABiZ/CXfoyv6oRN5
         QVP8az6x6JMtnqzpPT+8UifqJVLhBdQ1rjyJFGJyHtVHo1KZIeJBdqTxpovOLAjZrn8M
         oSrwb0uwubq2WvJoqItNd3VJxEJZM019NgaCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzbH7yICGZIm+U4q29ju3SFNiy/MszOsB+ixiEcwYOc=;
        b=bceDkL7MgRaTniM0BTPrIPRi3/UVAsIDC0oOFhp9pquo0MpuqmRAWsRpkRlSe4V01p
         mcHlagEJadxDkEAV70TlYK3yX9YyIkK4IJl7XRJi54jWSl7A9Zu6//cfvGCcCvpbMMQy
         eYYK1UbE09maPr8V/NaT6YDJj2lewfnJ2c3qVQ8zMh40gyax07uO3poaHU1ctRNJr13U
         YW6wV58JAJPZzzU3OiiVJ/NHhfjY8/bN2OVnR+tPOQ+UvsN5wmkJYi+Igc6WXvAfBtnZ
         z/sYykJOHmQsnF7gR16oJdMNiOEOABp8allKd1mt07K0PcMmD/12Qu3d1NSuIrZPesOI
         M1Sg==
X-Gm-Message-State: AOAM531VmtTkAKS9UnpjZv45NlPS2FccHINY+riyiZguKdILQlOqYKT9
        cpxpo6mVmYMO9VYSmdUKICLxq5kSLTnYsF0K
X-Google-Smtp-Source: ABdhPJw4CFQw+RGShLzOYLfY21NNL9iYiOezy1EUxIXMlTgZmiRptZ62wzTWfdFs/bGSqOfRktu62Q==
X-Received: by 2002:aa7:da56:0:b0:42d:d632:e8e6 with SMTP id w22-20020aa7da56000000b0042dd632e8e6mr1107116eds.56.1654106961650;
        Wed, 01 Jun 2022 11:09:21 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709061c0900b006fec27575f1sm955888ejg.123.2022.06.01.11.09.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 11:09:20 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id f7-20020a1c3807000000b0039c1a10507fso1534846wma.1
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:09:20 -0700 (PDT)
X-Received: by 2002:a1c:7207:0:b0:397:66ee:9d71 with SMTP id
 n7-20020a1c7207000000b0039766ee9d71mr606705wmc.8.1654106960066; Wed, 01 Jun
 2022 11:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk> <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk> <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org> <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
In-Reply-To: <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jun 2022 11:09:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
Message-ID: <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>,
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

On Tue, May 31, 2022 at 11:59 PM Olivier Langlois
<olivier@trillion01.com> wrote:
>
> Again, the io_uring napi busy_poll integration is strongly inspired
> from epoll implementation which caches a single napi_id.

Note that since epoll is the worst possible implementation of a
horribly bad idea, and one of the things I would really want people to
kill off, that "it's designed based on epoll" is about the worst
possible explanation fo anything at all.

Epoll is the CVS of kernel interfaces: look at it, cry, run away, and
try to avoid making that mistake ever again.

I'm looking forward to the day when we can just delete all epoll code,
but io_uring may be a making that even worse, in how it has then
exposed epoll as an io_uring operation. That was probably a *HORRIBLE*
mistake.

(For the two prime issues with epoll: epoll recursion and the
completely invalid expectations of what an "edge" in the edge
triggering is. But there are other mistakes in there, with the
lifetime of the epoll waitqueues having been nasty problems several
times, because of how it doesn't follow any of the normal poll()
rules, and made a mockery of any sane interfaces).

            Linus
