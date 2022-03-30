Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712774EBC94
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 10:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiC3IVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 04:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244350AbiC3IU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 04:20:56 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FD23121D
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 01:19:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dr20so39874989ejc.6
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 01:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pb8rc4LHPVXRF45q6Y/HA0FDcpsgWdrRhkyzNeOLHxI=;
        b=hMxR9tr3eiF29WJjn89DiiTlkXVbXxsieJNuInPomBEsdtmFP9bESHFFaToBZJ/rwT
         pM+NVBYzt0T3xlO4o2/sD++iWhR1FH6zDmIL6hLxsmSi7JAAt72Gce0ZtV+6FPZbs+lG
         QI5T+b863kT+f6e0VzFBLDxgTjkQAv0x0d+aE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pb8rc4LHPVXRF45q6Y/HA0FDcpsgWdrRhkyzNeOLHxI=;
        b=Z5d6nPWIvafOOLSNDKqTDE72FP1fs2U0coKGqxmbiH0YLo1DzeWoGXlBn80PRpb2Xu
         q3l1kw1hAozPMXVk3uh9fJ8NCFPtFN0orAjlXdY/oyHpGhT11L4SsIdN3MdXw2Q5/b2B
         pqxeHVrU+FwDMpAyIf6ZivRyY2mfCmNe8nOpcahSDdFR9C624EC8x0XZjGSP2ojMEeHt
         2qgUIChJhjATX4X5L1tnPv+8mu1RvIE/XnrRnNdzaUZdrN69kobzbFQmFjo9xv0E+Nnn
         QMGEikFd/a1faNxvyJZn8fmiSIpmCmHr295mKXZifYkhVD2viea3TvOzoCAjK413r85h
         SRow==
X-Gm-Message-State: AOAM533pEH9agA5nf/8jSMFwW8UZoSEIL5qSKzid3Oyphu5c6zxpj0OK
        sdFCTrNdhUR6iwvF9edlwjK7pHDuF5/xqVoJ86PWdVAGJx8=
X-Google-Smtp-Source: ABdhPJwM+3OjeVOZ4Zf15dUolvoMFuQLA/OMsKn1zj5rwTWIc7I12GndA3vOgZhoQW9Gq8VEV/4ExobEe4akDci1q5k=
X-Received: by 2002:a17:906:7948:b0:6da:64ed:178e with SMTP id
 l8-20020a170906794800b006da64ed178emr39588464ejo.523.1648628345183; Wed, 30
 Mar 2022 01:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk> <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
In-Reply-To: <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 30 Mar 2022 10:18:54 +0200
Message-ID: <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
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

On Tue, 29 Mar 2022 at 22:03, Jens Axboe <axboe@kernel.dk> wrote:

> Can you try and repull the branch? I rebased the top two, so reset to
> v5.17 first and then pull it.

This one works in all cases, except if there's a link flag on the
read.  In that case the read itself will succeed but following
requests on the link chain will fail with -ECANCELED.

> BTW, I would not recommend using DRAIN, it's very expensive compared to
> just a link. Particularly, using just a single link between the
> open+read makes sense, and should be efficient. Don't link between all
> of them, that's creating a more expensive dependency that doesn't make
> any sense for your use case either. Should they both work? Of course,
> and I think they will in the current branch. Merely stating that they
> make no sense other than as an exercise-the-logic test case.

Understood.   Once all of these cases work, it should be possible to
compare the performance of parallel vs. serial execution.

Thanks,
Miklos
