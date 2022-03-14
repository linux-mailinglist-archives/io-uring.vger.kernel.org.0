Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5334D85C0
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 14:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbiCNNLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241460AbiCNNLR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 09:11:17 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F211D0DE;
        Mon, 14 Mar 2022 06:10:04 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h11so21821050ljb.2;
        Mon, 14 Mar 2022 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMdQruxukN7xczRg3+vAgQmSYHLw/uLRbeJd/4syR58=;
        b=XKObeHOAEnAi5szMWcuxy6hbm6P5lMl58rcXpLysUh3Zs333P41+/w9w4CIS/yYEPS
         6FyZWgEMnZCAFdAWamB50WH6HDKh2UrQuRhYssI2r8YMp+uHrk8r/KRPUEB9/hcAeOhk
         6g+589fJuf/StdGXTDh5qXWB6Do2HhEf9UgvwRPUiYZ79x/wCGzEyinlj5g9uMPtbYti
         bVflhgMSaelokJOsgVIKbdOwdaORu68H12OWckf2pNsN6DRjR3/ALtRmy7TqG0ePERp8
         FzGmY7nezB9TC/9kwGfaIxrZKqBJ8DmQTR4Z3hUi7hLLLi71UMDHX4RcoGAG2ssoIDzM
         kpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMdQruxukN7xczRg3+vAgQmSYHLw/uLRbeJd/4syR58=;
        b=RdG2E4V6GUXXgasPbRmxNUfrfUS56XdM2TXkNr77NAUZN6t5XmS9YesLJhwrmD+qyr
         4c6+QMz2D/LBaLvt+h3hYhsPpL9BDEA4/yyMa+tXSRfNL7KtOvCRlHVajz3R0fx/MHAH
         w6fmN9I9lnmznIsvTBdq6s2Geep2q3Q1we818EnaeeratK9LS7xGOcOEt6vyVIfCNXxE
         caJd/HkhYRy3DpcZX+hZJ30LFF3QGJkO3Vyf+SQigMFPk4thOupjFshuhT98lajGEYWF
         yBzbjUEqQHBRrKu+KfSOc3gat2FPf+hOgOxb+/Gy5qWW1u+lLAWGhE9Y0LaPY0W5/42k
         Byiw==
X-Gm-Message-State: AOAM530h3Pv2Gk4F22HvrxV9NVwA7Wy4dEoqXrswjVm73n+O2jAaLsNR
        REeEjh6/mL3Dx8y3O+bx9tpTg3/3mbO6WQ8pRxc=
X-Google-Smtp-Source: ABdhPJw1JcRokQe60GlwSImervGGE6MV8GniXt1BZxf+h7qeLDo5laRHUUleD/fkGbbNSp9VwAivyabaAaylx/wqv0k=
X-Received: by 2002:a2e:80cf:0:b0:247:f28d:b04e with SMTP id
 r15-20020a2e80cf000000b00247f28db04emr14585255ljg.528.1647263402899; Mon, 14
 Mar 2022 06:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c@epcas5p1.samsung.com>
 <20220308152105.309618-9-joshi.k@samsung.com> <Yi8ynSFjllfuj4NB@T590>
In-Reply-To: <Yi8ynSFjllfuj4NB@T590>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 14 Mar 2022 18:39:38 +0530
Message-ID: <CA+1E3rK0-CXoCvE+5cKD_Vx=17b5A=HRhPrTeYtd4MeFKEAUrw@mail.gmail.com>
Subject: Re: [PATCH 08/17] nvme: enable passthrough with fixed-buffer
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
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

On Mon, Mar 14, 2022 at 5:49 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Tue, Mar 08, 2022 at 08:50:56PM +0530, Kanchan Joshi wrote:
> > From: Anuj Gupta <anuj20.g@samsung.com>
> >
> > Add support to carry out passthrough command with pre-mapped buffers.
> >
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > ---
> >  block/blk-map.c           | 45 +++++++++++++++++++++++++++++++++++++++
> >  drivers/nvme/host/ioctl.c | 27 ++++++++++++++---------
> >  include/linux/blk-mq.h    |  2 ++
> >  3 files changed, 64 insertions(+), 10 deletions(-)
> >
> > diff --git a/block/blk-map.c b/block/blk-map.c
> > index 4526adde0156..027e8216e313 100644
> > --- a/block/blk-map.c
> > +++ b/block/blk-map.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/bio.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/uio.h>
> > +#include <linux/io_uring.h>
> >
> >  #include "blk.h"
> >
> > @@ -577,6 +578,50 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
> >  }
> >  EXPORT_SYMBOL(blk_rq_map_user);
> >
> > +/* Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough. */
> > +int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
> > +                  u64 ubuf, unsigned long len, gfp_t gfp_mask,
> > +                  struct io_uring_cmd *ioucmd)
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
> Here bio_iov_iter_get_pages() may not work as expected since the code
> needs to check queue limit before adding page to bio and we don't run
> split for passthrough bio. __bio_iov_append_get_pages() may be generalized
> for covering this case.

Yes. That may just be the right thing to do. Thanks for the suggestion.


-- 
Kanchan
