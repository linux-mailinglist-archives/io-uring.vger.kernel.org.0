Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFC74EC4F1
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 14:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiC3MxS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 08:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345404AbiC3Mw6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 08:52:58 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2884173F74
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:51:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bq8so27356130ejb.10
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w1dZb6gHTz2s4S2NYwPL2UJOK8TAiDmrooWECgf0MNQ=;
        b=cR0ldw0SGzzjqV325e1v+EnpwOYIgyMQMD/RMS7s20e/3oFhJhSI/MnavWA0rbaKja
         avKsfPrpqPSxx8oeImJQLnv+n4HRDpAG9iw2tWcSYfiIIfTIhHdph8xLU/Puk1nGXTu7
         eQfqDqQR4B9iWgox40eRdRLARhI79vDByv+1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w1dZb6gHTz2s4S2NYwPL2UJOK8TAiDmrooWECgf0MNQ=;
        b=kcVwL8eBG7J4/KQZf1mJmVpznQKM4Yt4Qoh6fXsX+HwQSQItH/Y7hxhCwQxBk4DWnq
         r9taphAAdZtZT9eiNaxCNP7jOoG44/C32LbKClwDxX4+sZMWd9fK5oUjUpZy2x9+VWGR
         yb6UIMlFw5tym4NhlCD0GYKA6x2gSst0S4cU+DU4l5FxwLQVwj8AAU+m52R8Ghgx7q8a
         e19vZuWclxc1Y6QDjtO0qDPV2Kl2LbZ7f5/21mrS9tzCT1FVJ/WeWdlwIEjrDmB3RgfM
         MZk7F21+ZLQgEKpcb0pvaYvbyqEZba4lAA7hOVHR8s4OiRp94oe+YAZBCCoOajRKyrLe
         DePA==
X-Gm-Message-State: AOAM5335jhtoY15FidjzToyvmW1w+9tliHdMKHeOgJFlTj+jCl6OX8+B
        0A3GDys7YkHbvv9VkR8nU3CPT9zLmanZeAqqRh2j/g==
X-Google-Smtp-Source: ABdhPJygA+Xsabs5SWBNQVxkRMoGsOpeBs556VazEfS7AlamicDbveXEDbVjVUf1JWrrNmV+VYcxpZk1M29rRdD9/OE=
X-Received: by 2002:a17:907:96a6:b0:6e3:9c1b:f403 with SMTP id
 hd38-20020a17090796a600b006e39c1bf403mr3913912ejc.524.1648644672412; Wed, 30
 Mar 2022 05:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk> <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk> <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk> <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
In-Reply-To: <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 30 Mar 2022 14:51:01 +0200
Message-ID: <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 30 Mar 2022 at 14:49, Jens Axboe <axboe@kernel.dk> wrote:

> IOSQE_IO_LINK means "wait until this request SUCCESSFULLY completes
> before starting the next one". You can't reliably use a link from an eg
> read, if you don't know how much data it read. If you don't care about
> success, then use IOSQE_IO_HARDLINK. That is semantically like a link,
> but it doesn't break on an unexpected result.
>
> If you're using LINK from the read _and_ the read returns less than you
> asked for, IOSQE_IO_LINK will break the chain as that is an unexpected
> result.

Ah, okay.

Thanks,
Miklos
