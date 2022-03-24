Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472B84E6805
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 18:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346885AbiCXRrU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbiCXRrU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 13:47:20 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B7CB2473;
        Thu, 24 Mar 2022 10:45:47 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id bn33so7191023ljb.6;
        Thu, 24 Mar 2022 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XjdOGRorC0nLuKT+vnf4KghH4qK564bOF026m1uq2LM=;
        b=qn5ODB5qgGzbNY6LyHQ1PpJ+e8WZnGb3VIdgWKJ4RWs7GjUS5wjCq7s+T4SpWzyyRz
         X5Kv8cFbzPU1ALMGYa5T8WOKpm0YB33F4W56+qyixcVsxniuEIBj//m/DJEJnq38UrXs
         Eza/doKWtG2viDJxbE93l6gb1wq/dqhYes8nQfFolowATEmhocCTqet3SrVAaIdCgFVH
         ET9VDmte4nWETFRNYj9+ixpoXev6v5YAd2bMDMRF8A28SoDBtTRjFTNaR+7uOkgyQ58r
         1JGivxE8gPTnFFm7NcbScjnOreo9c7fXFQrtZpcYtCUtAjcjyHiZpx6ghM0sQ8Nfvvx0
         iMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XjdOGRorC0nLuKT+vnf4KghH4qK564bOF026m1uq2LM=;
        b=RCCHIx6CvWna5WLhhuYwj+cbgQf2byARXA2bJVXPNb/KupEDYU0TPuvY5reQNm5Wrm
         dOusxIJ2IlwAQqPFQ7+uiMipndGogzzxwfvqOwM22EDQHwBhlpzGH34a5ujIEw1RIeA3
         8+/wImD9c8kNkp1QZfCUkc9QdDIV7R5kO1rm8UwhPW/3RdPp3iq/7RTdPboMegkm+/iq
         mR5WKYUoFrikvgJoyAhqWCiq9ASOZzd0TTurJZutA8rGXGDTriKckwWJ9TmLc6zDqGGZ
         fyZ6udvfcSL/BL2vu0lh4GgwA3VKENemWh7WyeT+cBqysdTuAdmMCWOT8yvewG4R5Fj3
         lOiA==
X-Gm-Message-State: AOAM531B49aXZ3YBDK2KG0yYhql4mCKtddViUG+RLjLEmN9e4HuZGgs6
        WOGpig55QJPITda0l5vJwrEcWtilVj+18SUv64c=
X-Google-Smtp-Source: ABdhPJz0+kF30iUk1IKjKuHkn6OMlOdoGxgUwTrEvzpunKZL2D1zUDJ7ekei/or9tWttmHRiMEUXp+orM938M0EQA9Q=
X-Received: by 2002:a2e:90d6:0:b0:246:e44:bcf6 with SMTP id
 o22-20020a2e90d6000000b002460e44bcf6mr4820564ljg.501.1648143946143; Thu, 24
 Mar 2022 10:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f@epcas5p3.samsung.com>
 <20220308152105.309618-12-joshi.k@samsung.com> <20220310083503.GE26614@lst.de>
 <CA+1E3rLF7D4jThUPZYbxpXs9LLdQ7Ek=Qy+rXZE=xgwBcLoaWQ@mail.gmail.com> <20220324063011.GA12660@lst.de>
In-Reply-To: <20220324063011.GA12660@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 24 Mar 2022 23:15:20 +0530
Message-ID: <CA+1E3rJAK9fPuS6g_po_vpvde_LpOjkuoU=E5h=v9rnHhc3+mw@mail.gmail.com>
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

On Thu, Mar 24, 2022 at 12:00 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Mar 10, 2022 at 05:55:02PM +0530, Kanchan Joshi wrote:
> > On Thu, Mar 10, 2022 at 2:05 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > On Tue, Mar 08, 2022 at 08:50:59PM +0530, Kanchan Joshi wrote:
> > > > +struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
> > > > +                         struct bio_set *bs)
> > > > +{
> > > > +     if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE))
> > > > +             return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
> > > > +
> > > > +     return bio_from_cache(nr_vecs, bs);
> > > > +}
> > > >  EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
> > >
> > > If we go down this route we might want to just kill the bio_alloc_kiocb
> > > wrapper.
> >
> > Fine, will kill that in v2.
>
> As a headsup,  Mike Snitzer has been doing something similar in the
>
> "block/dm: use BIOSET_PERCPU_CACHE from bio_alloc_bioset"
>
> series.

Thanks, that can be reused here too. But to enable this feature - we
need to move to a bioset from bio_kmalloc in nvme, and you did not
seem fine with that.
