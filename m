Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD493E095B
	for <lists+io-uring@lfdr.de>; Wed,  4 Aug 2021 22:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbhHDU2t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Aug 2021 16:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbhHDU2s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Aug 2021 16:28:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA068C0613D5
        for <io-uring@vger.kernel.org>; Wed,  4 Aug 2021 13:28:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so10507154pjb.3
        for <io-uring@vger.kernel.org>; Wed, 04 Aug 2021 13:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NU/Nomke/c8+5NesI11I6iS7WzNZOU0IkqvK5YogwZ0=;
        b=iT5WHsZ+Xo7EfqutBTgFGxQR2YT2dgblbS0Uaf0IRmfld2eJNg4bHlYmRf1sF6UVe/
         v5NjwEwjHv/6391LV304TJd8DKNk/3PHMW4HIZF1wSeGyNvSqesIGV8Dv8Vw1CC5ccSB
         yViS9jgedzBfE6bx1mxMsFk76f3dIhcIH3vwDdZH2BoyKzTrw75knCx1gf+6v00fZ3+F
         QjJhTjJTXvf1BApsGSUumSNHOl6Vb03ZeqwpjulXzmjzKGbeTQ7SMjxgRwHt5bKS8bh7
         Uf1BzZZcVIjNTpGNQifIxJrcUudR4zp/WS6lX8N6g7RFndjpzR7pApIs2WX6DmNlm+8w
         syjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NU/Nomke/c8+5NesI11I6iS7WzNZOU0IkqvK5YogwZ0=;
        b=T7OCy40eoeUHLWHa3/CesTRe+UVLm+HWMvN7oRlKvSddjVRMhWSUCRf+dZWRHhrfE7
         R+jmxZlb1gTMgRISkKSZBJtOXJN41rYRQT/MKXpMbAnTD25uOCS+SCQffjC0aJ0G0mZS
         /JnMzWCjtjxR+FPxHjyg++sEjmP7ENZJ6S+M4B5mdMmYCbp4cAu1QIz3jQ0mzQL0B9WF
         /lp4MRkM2fWt1wP29J8nP80uxyhBlU4XHm/kxDHXrw3xlAQuwtUNUgW2AIyA80FglAue
         xIhaeVl9LADpyUR0oXGwkyQLMVllfM0M4yHN8wok5T9qDZr9bGWe9D1XiDNMeW9S5zFC
         9Uxg==
X-Gm-Message-State: AOAM533fz1IWxbadNwXX0ZqHXyfj9hfkJh7v/2ViHaWpUzmXMW3Qop/Q
        /xVNzrYO+dW/wye8rAVNhtc=
X-Google-Smtp-Source: ABdhPJyrBq/95upHXZA//NwGUNyM6fR9C0pofLoiHXJh19FGMEyOXZklQ3V+qS0tFsm607mAyHhDYA==
X-Received: by 2002:a17:90a:940d:: with SMTP id r13mr11818583pjo.124.1628108914244;
        Wed, 04 Aug 2021 13:28:34 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id d2sm4626532pgk.57.2021.08.04.13.28.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Aug 2021 13:28:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v2] io-wq: fix race between worker exiting and activating
 free worker
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <f4f81bd0-a897-4409-f09a-a768b5a3c6c5@kernel.dk>
Date:   Wed, 4 Aug 2021 13:28:31 -0700
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A23EAB11-FCD2-40BA-AB0E-B721080974AF@gmail.com>
References: <f4f81bd0-a897-4409-f09a-a768b5a3c6c5@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On Aug 4, 2021, at 1:00 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> Nadav correctly reports that we have a race between a worker exiting,
> and new work being queued. This can lead to work being queued behind
> an existing worker that could be sleeping on an event before it can
> run to completion, and hence introducing potential big latency gaps
> if we hit this race condition:
>=20
> cpu0                                    cpu1
> ----                                    ----
>                                        io_wqe_worker()
>                                        schedule_timeout()
>                                         // timed out
> io_wqe_enqueue()
> io_wqe_wake_worker()
> // work_flags & IO_WQ_WORK_CONCURRENT
> io_wqe_activate_free_worker()
>                                         io_worker_exit()
>=20
> Fix this by having the exiting worker go through the normal decrement
> of a running worker, which will spawn a new one if needed.
>=20
> The free worker activation is modified to only return success if we
> were able to find a sleeping worker - if not, we keep looking through
> the list. If we fail, we create a new worker as per usual.
>=20
> Cc: stable@vger.kernel.org
> Link: =
https://lore.kernel.org/io-uring/BFF746C0-FEDE-4646-A253-3021C57C26C9@gmai=
l.com/
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>


Tested-by: Nadav Amit <nadav.amit@gmail.com>

Thanks!

