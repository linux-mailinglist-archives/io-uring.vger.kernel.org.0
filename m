Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FAB4D85B0
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiCNNH4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 09:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiCNNHy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 09:07:54 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B9DDF7D;
        Mon, 14 Mar 2022 06:06:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e6so20397575lfc.1;
        Mon, 14 Mar 2022 06:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BOlO6xEd5yx0VwcP8XWEvIq5tVmdflWzEZnP6Ir9Ujc=;
        b=eg5+VRwSBYiF1RlBhiqx8YBZfrTp8tDo2CBqIiHVxbW/cy7mI9mctOY5WA6nmA1sIU
         F52i8oNVLQ3VQHNOQ42PKTdDBtczLN7iHpElSmgiuhn7yu33HCY8LNHjSp5CQI5IRT4O
         hEPFfRJpfwJkbuCzQeDkkDseOxtWW/UtmW1Kud3IcO+kyNOWIPfJS3dS9EwfwQVHi9RL
         Rx9zDZ61EsdOMjPWC2CEULkoVP6ZRQRb0HWHRXq4M0H8rW6qtFairBPqk+9x0UFWOcWW
         fDHBFCuuW4enFi5mEKHF26oTEJ/lDz/+88pLprKNzBV5abucsFvpuH/ZPm/gxvQLA2KO
         414A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BOlO6xEd5yx0VwcP8XWEvIq5tVmdflWzEZnP6Ir9Ujc=;
        b=fd4qiqhFXE+dyAltx75Z50mIcHv5wY5Oc7EnvMjbae5bKSeMWaayDvnspOnfjC3s4l
         dXEMN5oG+yUUez304i4JEUuK+xR0cPAE2SQQ2lieaxGffPdkdO6vxYCk1iLvXtaCptVY
         X0hPoWh7pEIu1KtaEMKMoInZ7//k3jKXy1Pe5BFOw9pVWI3FPGEYjzzkKpVI5S2Hob1i
         dcyyLzxL4QS5Bv6RRzmn/OZ22Pi+iAz43wvVM4nfBm3ylsIH6ZpN2XUy2BEJ6Iw+VLZz
         1sH0e0/oqKgfCP9tydAcMDrsXsnh/jm1I8mefbLvggssb4IvDwmiqeglYUJfKs/YFlMa
         ysxQ==
X-Gm-Message-State: AOAM530GGEwey92JyGDJVaHvcpeNFahya7FbVi46f/xHPjf0dsG5dap3
        eW2pZR3tn/0Q6iT1JrUSj9KSMKAv0KfK3qQIo+c=
X-Google-Smtp-Source: ABdhPJyKsx6rDrIjB2kvaUMha+gSykJsyREiIENgJXnLx/p7Ae+DAKriux6QPaRucljomwqpUfAhuVOouegoMHfpJXo=
X-Received: by 2002:a05:6512:2353:b0:448:92cd:d1fb with SMTP id
 p19-20020a056512235300b0044892cdd1fbmr3524447lfu.355.1647263201992; Mon, 14
 Mar 2022 06:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c@epcas5p1.samsung.com>
 <20220308152105.309618-9-joshi.k@samsung.com> <20220311064321.GC17232@lst.de>
In-Reply-To: <20220311064321.GC17232@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 14 Mar 2022 18:36:17 +0530
Message-ID: <CA+1E3rKnsdap7wb4RqO7HCBq8hxjF48k9NydMRAKht43xnhB9A@mail.gmail.com>
Subject: Re: [PATCH 08/17] nvme: enable passthrough with fixed-buffer
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

On Fri, Mar 11, 2022 at 12:13 PM Christoph Hellwig <hch@lst.de> wrote:
>
> > +int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
> > +                  u64 ubuf, unsigned long len, gfp_t gfp_mask,
> > +                  struct io_uring_cmd *ioucmd)
>
> Looking at this a bit more, I don't think this is a good interface or
> works at all for that matter.
>
> > +{
> > +     struct iov_iter iter;
> > +     size_t iter_count, nr_segs;
> > +     struct bio *bio;
> > +     int ret;
> > +
> > +     /*
> > +      * Talk to io_uring to obtain BVEC iterator for the buffer.
> > +      * And use that iterator to form bio/request.
> > +      */
> > +     ret = io_uring_cmd_import_fixed(ubuf, len, rq_data_dir(rq), &iter,
> > +                     ioucmd);
>
> Instead of pulling the io-uring dependency into blk-map.c we could just
> pass the iter to a helper function and have that as the block layer
> abstraction if we really want one.  But:
>
> > +     if (unlikely(ret < 0))
> > +             return ret;
> > +     iter_count = iov_iter_count(&iter);
> > +     nr_segs = iter.nr_segs;
> > +
> > +     if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
> > +             return -EINVAL;
> > +     if (nr_segs > queue_max_segments(q))
> > +             return -EINVAL;
> > +     /* no iovecs to alloc, as we already have a BVEC iterator */
> > +     bio = bio_alloc(gfp_mask, 0);
> > +     if (!bio)
> > +             return -ENOMEM;
> > +
> > +     ret = bio_iov_iter_get_pages(bio, &iter);
>
> I can't see how this works at all.   block drivers have a lot more
> requirements than just total size and number of segments.  Very typical
> is a limit on the size of each sector, and for nvme we also have the
> weird virtual boundary for the PRPs.  None of that is being checked here.
> You really need to use bio_add_pc_page or open code the equivalent checks
> for passthrough I/O.

Indeed, I'm missing those checks. Will fix up.

> > +             if (likely(nvme_is_fixedb_passthru(ioucmd)))
> > +                     ret = blk_rq_map_user_fixedb(q, req, ubuffer, bufflen,
> > +                                     GFP_KERNEL, ioucmd);
>
> And I'm also really worried about only supporting fixed buffers.  Fixed
> buffers are a really nice benchmarketing feature, but without supporting
> arbitrary buffers this is rather useless in real life.

Sorry, I did not get your point on arbitrary buffers.
The goal has been to match/surpass io_uring's block-io peak perf, so
pre-mapped buffers had to be added.

-- 
Kanchan
