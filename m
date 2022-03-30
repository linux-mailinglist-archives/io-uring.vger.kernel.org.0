Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2B4EC4D7
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 14:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345731AbiC3MrR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345736AbiC3MrJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 08:47:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBC981670
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:44:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r23so24296871edb.0
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJNKHDqiOPSujwD3chakJ54bylhMI1CCMP04+R0nARQ=;
        b=jcE/yxy/LNGORy91ERVceQcp8a8JltRHHsjzLNNtQ19dcXHlKD9KZhAVEay6XLO2og
         I83Uqap1FEGjwjG5yveewpBNdoGO7aF8TO51zLCrhPnpE06GNy8qv2rB6xCGG6CHfxsw
         X9ApX6AnvuI0KsZVR6XVM1cNfHbwc8vzMqquU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJNKHDqiOPSujwD3chakJ54bylhMI1CCMP04+R0nARQ=;
        b=UwBoQqYEv8l4Z5IK/jsuwfYzJWmzQi4VyYWcByVIl5X3N8sVzy6qK78RFxjCIq3MQT
         0EF3K0C5rUFW2j96y4sjfwXyEX9LFuUShUilkpHSJwpJNE0FNJYIymN2NzthKeD4BP55
         d4F7GIXCr2jMxfn03aMkwmbxGU54ZX0I3IoEHzkYasqwSL2ZyRxZE0MX9iJjEg6raRW8
         E9EchjIbRdVmwcML2Llw4Tx8ORaicGH4XbTVUiuu7572v5o57cUZdTsn4rrHvYG9BLPN
         6G4a0jL2Img0Pp/WKynmk5YO8BVO6bZhcmENvPVsti405JLKgdgjgRbLiycw64fxCChu
         XN9Q==
X-Gm-Message-State: AOAM530XcEGwW9jwu+I3cv6HteoAIVpnMRbqzGPZnYrvdY6ckAgH+cXf
        2s9DnNXQ79m93R6+qct/kOJnTbn2/m0szI7O63LhUvoUg9s=
X-Google-Smtp-Source: ABdhPJwAYTFUG6WRBNjdyY270ZQWromo9XPjEBYVmiJOodYTHuRETnfNN4Vu6SqpVta9yiXwhY9+FsArmWo7DfHdfYI=
X-Received: by 2002:a50:fe07:0:b0:419:323:baee with SMTP id
 f7-20020a50fe07000000b004190323baeemr10159248edt.221.1648644246157; Wed, 30
 Mar 2022 05:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk> <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk> <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
In-Reply-To: <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 30 Mar 2022 14:43:54 +0200
Message-ID: <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
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

On Wed, 30 Mar 2022 at 14:35, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/30/22 2:18 AM, Miklos Szeredi wrote:
> > On Tue, 29 Mar 2022 at 22:03, Jens Axboe <axboe@kernel.dk> wrote:
> >
> >> Can you try and repull the branch? I rebased the top two, so reset to
> >> v5.17 first and then pull it.
> >
> > This one works in all cases, except if there's a link flag on the
> > read.  In that case the read itself will succeed but following
> > requests on the link chain will fail with -ECANCELED.
>
> That sounds like you're asking for more data than what is being read,
> in which case the link should correctly break and cancel the rest.
> That's expected behavior, a short read is not a successful read in that
> regard.

Sorry, I don't get it.  Does the link flag has other meaning than
"wait until this request completes before starting the next"?

Thanks,
Miklos
