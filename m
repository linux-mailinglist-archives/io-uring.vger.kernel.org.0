Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469B26F53E0
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjECI7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 04:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjECI7J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 04:59:09 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5BB10D9
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 01:59:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so4500570a12.0
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 01:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bnoordhuis-nl.20221208.gappssmtp.com; s=20221208; t=1683104346; x=1685696346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ux34pWCAB0lVotTQYmI1d2chc29FjfJJACAo02VwJXM=;
        b=yfGle77zGo7C91j7NWMxAZdU2bqM5x/NTZ2zAcJE7ud+r86UdGt7fUVAtYz5qQPtsT
         S/CPbReUFFE8uptgXI7BKZHWaGf9Atj47UXPURsQHGqtfSd09MavfhJlgxHFbNuiXjgQ
         YHpzY8WV+oHQBRRVYvOXNquuHcWzfP2WeIvHHp/yLru6J+1m3RAXWemPiI9b1/KjTQzl
         mrKc3oXVXwMEWDa84vGSZpDXgAFTUVdadg4TumbBphKdmMlrjnLXCzxztoIPuDW+a1bx
         p3RJ1Hu7W1uBI/SfSXYsLHm8NC+wE1NxV3jU9fjLEVG00WCxpSGltmy1917sxhdL+eCj
         jEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683104346; x=1685696346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ux34pWCAB0lVotTQYmI1d2chc29FjfJJACAo02VwJXM=;
        b=bSCfdrXQESW5OsPSLW9d0EiNBMltBRpSgPlAHby3RevvzfncoKp/q/3RXpjTwIToPY
         m8RYql5A9ZA+Rh/ocLiGt+6Styc9mpkmK9R+l/YzhxDxyY9qcLEyuaIvpX9AD1lJhjTe
         YYWToqKafn91XrNmMYUIeGxf8hx4zl6r6h3Qvb0v6xA6GngE4AQJEbr3kBoSvl+x+KAy
         UpRKRepqOjO1tCzweF2coZ6BP8pKKZQRicjzqis3rR/jbTU3dmVWqUnJ4pXLtcCOVuSm
         HJAoTnMTVP8pJs6skYkWg5yAsxmaLwbdnpem5vV9fPYnLeU1j5mWjpZTFYKCQQSN4Kid
         4Y8A==
X-Gm-Message-State: AC+VfDz7fjqm0jNlWnjN5pH3phlhmaC0WceK98ZbMszjpOlhdRFJZGNb
        lq8ddF1g3HL0/+ndvVjls20GuDvniV5lKOi5qB8XL9ZmqPKX5jWh
X-Google-Smtp-Source: ACHHUZ5LjwlhHbiftEh5ej8y7d5gGMLjktBGPRzTwlUQA/NEqFx2H81o5aM8r3r8583J/WwRFTU1175xYNkSUV39ONM=
X-Received: by 2002:a17:906:fe47:b0:94f:2916:7d7 with SMTP id
 wz7-20020a170906fe4700b0094f291607d7mr1022541ejb.19.1683104345820; Wed, 03
 May 2023 01:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230501185240.352642-1-info@bnoordhuis.nl> <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
In-Reply-To: <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
From:   Ben Noordhuis <info@bnoordhuis.nl>
Date:   Wed, 3 May 2023 10:58:54 +0200
Message-ID: <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 2, 2023 at 2:51=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 5/1/23 19:52, Ben Noordhuis wrote:
> > Libuv recently started using it so there is at least one consumer now.
>
> It was rather deprecated because io_uring controlling epoll is a bad
> idea and should never be used. One reason is that it means libuv still
> uses epoll but not io_uring, and so the use of io_uring wouldn't seem
> to make much sense. You're welcome to prove me wrong on that, why libuv
> decided to use a deprecated API in the first place?
> Sorry, but the warning is going to stay and libuv should revert the use
> of epol_ctl requests.

Why use a deprecated API? Because it was only recently deprecated.
Distro kernels don't warn about it yet. I only found out because of
kernel source code spelunking.

Why combine io_uring and epoll? Libuv uses level-triggered I/O for
reasons (I can go into detail but they're not material) so it's very
profitable to batch epoll_ctl syscalls; it's the epoll_ctlv() syscall
people have been asking for since practically forever.

Why not switch to io_uring wholesale? Libuv can't drop support for
epoll because of old kernels, and io_uring isn't always clearly faster
than epoll in the first place.

As to the warning: according to the commit that introduced it, it was
added because no one was using IORING_OP_EPOLL_CTL. Well, now someone
is using it. Saying it's a bad API feels like post-hoc
rationalization. I kindly ask you merge this patch. I'd be happy to
keep an eye on io_uring/epoll.c if you're worried about maintenance
burden.
