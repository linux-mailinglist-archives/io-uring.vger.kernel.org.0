Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C565233ED11
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 10:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhCQJcr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 05:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhCQJcY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 05:32:24 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BA6C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 02:32:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id 61so1049462wrm.12
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 02:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckMFHbIAza0oRVDWFt01YA8LQDAieZmNLJNBqCZJrhs=;
        b=ReRH1LzoQsFbkj5XeL0BikRfqrBJxUxZ7ZfMzq0pmfQJNbCI88nn0qjyjyHWz+FlDH
         +o2mEMy87p8E+GptXa5pkKxYa+OcE+MT1vzEiArcmcaiFNLltEjV4PXVWfioAorPZskp
         5VlFdC3GKgFTyQr5Q6+N3T+X4WBxYxj28sqcHQQq3KkNBhh6a5Tqs2S2ykS7KV5i/7B2
         +VALfPsXfPDozi//B8cBhjhSncjqLE9LvV2FDjYRX6stkmr3hegbOOP3DQtl9BN5eSXH
         Z844XxtOGlFrEUV31jnQuigeN9ETuRfyL/+WC4DKw2XbqxiOMOydLBIIt/s1pTIO/GOt
         dDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckMFHbIAza0oRVDWFt01YA8LQDAieZmNLJNBqCZJrhs=;
        b=GyWMSFdV15zsKRk6XNIJK0sArfNPlxDpiLWZA28+bm8A7IUMTlAhyAvc7rqIL9e1jD
         XPuTpn2mHh0Rz0XOTAOkjcVsEQmLONGndX/u85MbKRc4dgqaBE0TkwE+TLw4w22axIzS
         dphQGEr8MadYkcPxqiuVwJecu6wZYoXPqCgeviDSTBcAni07wClgM0XWE/avSJrZNcCu
         u+WDRIJC/sq2MlUHAHcuZIKdRlqw5sb+Ii/tNVC9w6JL+q+0wpOYQ112xhse2nkg5TvK
         tPN0hn1y3HNR6PrkhztN3la3Gr/wVkrXmwxKuwcdWTDoi6PaYHt35xlm460/jUoCWsJf
         VFcg==
X-Gm-Message-State: AOAM5322+JCf5ZAYr1mA7PEOxteiJqQ/hvx4aUgh9MoHq4aI/LlH+gQn
        aUvESBPpn5QMzED2FT9WJ4FEfj5uRrP4HvqJSbjRR/Ze
X-Google-Smtp-Source: ABdhPJxOSK+7YazsLKF0GZI9RunQyJekGktJ84bICE4RIs8SHdn1QWin0P8W0AKObSyMIogKK8bucnlug1KnoeHvhIk=
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr3312761wrw.355.1615973531697;
 Wed, 17 Mar 2021 02:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210316140229epcas5p23d68a4c9694bbf7759b5901115a4309b@epcas5p2.samsung.com>
 <20210316140126.24900-1-joshi.k@samsung.com> <b5476c77-813a-6416-d317-38e8537b83cb@kernel.dk>
In-Reply-To: <b5476c77-813a-6416-d317-38e8537b83cb@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 17 Mar 2021 15:01:47 +0530
Message-ID: <CA+1E3rLOOaggA0p5wr5ndTWx42zjebCeEm5XzfOq7QcH6oP=wA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Async nvme passthrough over io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 16, 2021 at 9:31 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/16/21 8:01 AM, Kanchan Joshi wrote:
> > This series adds async passthrough capability for nvme block-dev over
> > iouring_cmd. The patches are on top of Jens uring-cmd branch:
> > https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3
> >
> > Application is expected to allocate passthrough command structure, set
> > it up traditionally, and pass its address via "block_uring_cmd->addr".
> > On completion, CQE is posted with completion-status after any ioctl
> > specific buffer/field update.
>
> Do you have a test app? I'd be curious to try and add support for this
> to t/io_uring from fio just to run some perf numbers.

Yes Jens. Need to do a couple of things to make it public, will post it today.
