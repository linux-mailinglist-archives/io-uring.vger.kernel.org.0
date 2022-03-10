Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7040F4D46CB
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 13:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241980AbiCJM0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 07:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiCJM0a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 07:26:30 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEF4148665;
        Thu, 10 Mar 2022 04:25:29 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id q5so7426496ljb.11;
        Thu, 10 Mar 2022 04:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5+S/19T7z8CqGJz5OOOtlJzN3mZfdNMJ1w7/PO7Phfo=;
        b=nk+hj7MWuNgvAdNzdtNd0A6lvaKaHdkrpdRyvFi/F2c/bBXMOB8M701YRllaDH9Wvx
         +Tb+/eUbI+ukdykKaWWDDrgKeuoEUjq/eZ9SEcevo2tfDRht4CVXcDEGBnYf+TuIXmSj
         eyzKE/PcjKx2SuqxKqHK6AGpoKLtjonkXc7NjULd2qCWbOywtgdWla2nasjfcJG+xcJ3
         m2tzOh4XC1zi4YO/fe4NJ4kPU3al8dOJN/ylDqRMbXwRCNF0NVTNz3O6UN/nrNWYeF5J
         yhIrolM2pNKobaZ7OyNw/RxpvHQNLPecNi5i9embbAU3QhZ+aLLum+4etw/AO6NBS6qf
         48nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5+S/19T7z8CqGJz5OOOtlJzN3mZfdNMJ1w7/PO7Phfo=;
        b=xuYl5uo7p2YsL4AD9Hd/32oNywp35QD8zU1ZqgvRVQutrFRrMl5+DfBjq4LOlfpz2B
         Z4nwX8BLlsZGE9Nk8GPqESD64IsBQkkuyvj3mFjYTyrEG0OvvyfxjZVz2o84TLt7Cb+O
         kYw9unjXVDQjjO4VtEk8WGOk6Ys1jx5WvyjDRErUdIBINcN7FFKXgoAGcQQXgH+wT5la
         KnixR5k7mlxlXCUQZxcJUflYnrASGb01tqbt1tU8nEKqXoqIkmGRX+QDXHo+341h3DmD
         rL25ybIWOjwZa9LqV5zQGbjXoHhH8PSD5MC2O3CU1k6UUgycNWS7+wJ9MP4c7ptXLRAY
         V8BA==
X-Gm-Message-State: AOAM533stf2NDPZNtliz1We1ZIySlJ9Wk0zPoiTfQRrmSWB+gboUJu+n
        +uDVwAAafa7Hp+TpGAusN2glYXZPhPeOW76T1kJEFBO9GeY=
X-Google-Smtp-Source: ABdhPJzsG6bp2WM29pnDrFfkLztteUacWjOolraWs5IwAxOIBsy7dmQHWUuyglX9BAPiJLNIBiwnRBUE+lYZxUkRT4w=
X-Received: by 2002:a05:651c:b07:b0:247:e06d:8943 with SMTP id
 b7-20020a05651c0b0700b00247e06d8943mr2736349ljr.426.1646915127520; Thu, 10
 Mar 2022 04:25:27 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f@epcas5p3.samsung.com>
 <20220308152105.309618-12-joshi.k@samsung.com> <20220310083503.GE26614@lst.de>
In-Reply-To: <20220310083503.GE26614@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 10 Mar 2022 17:55:02 +0530
Message-ID: <CA+1E3rLF7D4jThUPZYbxpXs9LLdQ7Ek=Qy+rXZE=xgwBcLoaWQ@mail.gmail.com>
Subject: Re: [PATCH 11/17] block: factor out helper for bio allocation from cache
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 10, 2022 at 2:05 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Mar 08, 2022 at 08:50:59PM +0530, Kanchan Joshi wrote:
> > +struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
> > +                         struct bio_set *bs)
> > +{
> > +     if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE))
> > +             return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
> > +
> > +     return bio_from_cache(nr_vecs, bs);
> > +}
> >  EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
>
> If we go down this route we might want to just kill the bio_alloc_kiocb
> wrapper.

Fine, will kill that in v2.
