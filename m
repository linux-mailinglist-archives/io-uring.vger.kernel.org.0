Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772B133FF1C
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhCRFzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhCRFzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 01:55:03 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DD6C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 22:55:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v4so4165956wrp.13
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 22:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6XYWNN/vIflygnMc5hEvr+N00R83qDR2mYo4MniNC8=;
        b=gkqbo2CiuQrZvvW5KR5wLQTKAn/vsKPDhqZjYIkwe2rf56gCXhsuh9HJKyB/stX/rd
         oblOZIBovjfg5g52FNlJ24hR75R2+FQvY5Cyee9dsnk6lvhwS0JrC/2qnipSySfV2Wi+
         yaPLFqVpXjgrWtUVw/qtsmFKbDfQb11bDaAWGDnElmCWJny+DP1wTVJj8jTtifVs82FE
         O3Ii/Sg3IERh+pqCwDhjkZIgNKv+NDtUDCtis2AA/RIAqhizX1blehJYY4PXN05zV8M2
         tYxqClmrFe7SjgjtZ/p55GWIpvRunb3R1GJZVvx+Ny6+Z21K/gPyAIwugoOHCQmLN7W8
         ryBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6XYWNN/vIflygnMc5hEvr+N00R83qDR2mYo4MniNC8=;
        b=MRaqRUTQXhpuqbNQD0yJh58oQ74EmxRPchWtadOclimqWgjtaQk3iMvWalI9deKcM4
         4SRMn7U2jF+1tPt5RhL3O7HoNAHBelhx6bbjFN7DO5Zw11GI+jbjuk0kaZs64x3h47yp
         RQhitIAuCEGUf9LeYqGmXpQuS18KD5xPrWsI/iRT1eyKHV60T0o7RpZaF6D+VNno32le
         7Db4Ezq2LWgpEHZtVQj0mgASNSO4E/IlTtMwF7tyDsB3bUPUYIfnDYWzehPQ6TtZ2Uyv
         ocbKMU+56PDzV1WcSLKsJNi9MJEZYWu42G1bVAXzFtqPWDhbP8C2LnKHUG00h313mhaB
         YfAQ==
X-Gm-Message-State: AOAM532GEFY0krojTpyQ5G63VVmuBrP2WqRJSYhezyCi5zykytpr4IZY
        oa7DRuFdtA+m0BGsJI/jB5kc497C22mmAAwurSzxIMT+liw=
X-Google-Smtp-Source: ABdhPJwAXTDwYV7+sxnSjT+09aPVYfqmr5rmS14GFNtNwcRevMBRfdutxo5z461O6eMvTC4ERbNm1DwCGRBqClyXZiU=
X-Received: by 2002:a5d:5906:: with SMTP id v6mr7867438wrd.137.1616046902176;
 Wed, 17 Mar 2021 22:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com>
 <20210316140126.24900-4-joshi.k@samsung.com> <20210317085258.GA19580@lst.de>
In-Reply-To: <20210317085258.GA19580@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 18 Mar 2021 11:24:34 +0530
Message-ID: <CA+1E3rJ62b8aRBnZzsQAUD2pZVrFAWUwd1jnS_mts=x9=fzt-w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
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

On Wed, Mar 17, 2021 at 2:24 PM Christoph Hellwig <hch@lst.de> wrote:
>
> > +/*
> > + * This is carved within the block_uring_cmd, to avoid dynamic allocation.
> > + * Care should be taken not to grow this beyond what is available.
> > + */
> > +struct uring_cmd_data {
> > +     union {
> > +             struct bio *bio;
> > +             u64 result; /* nvme cmd result */
> > +     };
> > +     void *meta; /* kernel-resident buffer */
> > +     int status; /* nvme cmd status */
> > +};
> > +
> > +inline u64 *ucmd_data_addr(struct io_uring_cmd *ioucmd)
> > +{
> > +     return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused[0]);
> > +}
>
> The whole typing is a mess, but this mostly goes back to the series
> you're basing this on.  Jens, can you send out the series so that
> we can do a proper review?
>
> IMHO struct io_uring_cmd needs to stay private in io-uring.c, and
> the method needs to get the file and the untyped payload in form
> of a void * separately.  and block_uring_cmd should be private to
> the example ioctl, not exposed to drivers implementing their own
> schemes.
>
> > +void ioucmd_task_cb(struct io_uring_cmd *ioucmd)
>
> This should be mark static and have a much more descriptive name
> including a nvme_ prefix.

Yes. Will change.

> > +     /* handle meta update */
> > +     if (ucd->meta) {
> > +             void __user *umeta = nvme_to_user_ptr(ptcmd->metadata);
> > +
> > +             if (!ucd->status)
> > +                     if (copy_to_user(umeta, ucd->meta, ptcmd->metadata_len))
> > +                             ucd->status = -EFAULT;
> > +             kfree(ucd->meta);
> > +     }
> > +     /* handle result update */
> > +     if (put_user(ucd->result, (u32 __user *)&ptcmd->result))
>
> The comments aren't very useful, and the cast here is a warning sign.
> Why do you need it?

Will do away with cast and comments.

> > +             ucd->status = -EFAULT;
> > +     io_uring_cmd_done(ioucmd, ucd->status);
>
> Shouldn't the io-uring core take care of this io_uring_cmd_done
> call?

At some point we (driver) need to tell the io_uring that command is
over, and return the status to it so that uring can update CQE.
This call "io_uring_cmd_done" does just that.

> > +void nvme_end_async_pt(struct request *req, blk_status_t err)
>
> static?

Indeed. Will change.

> > +{
> > +     struct io_uring_cmd *ioucmd;
> > +     struct uring_cmd_data *ucd;
> > +     struct bio *bio;
> > +     int ret;
> > +
> > +     ioucmd = req->end_io_data;
> > +     ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
> > +     /* extract bio before reusing the same field for status */
> > +     bio = ucd->bio;
> > +
> > +     if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
> > +             ucd->status = -EINTR;
> > +     else
> > +             ucd->status = nvme_req(req)->status;
> > +     ucd->result = le64_to_cpu(nvme_req(req)->result.u64);
> > +
> > +     /* this takes care of setting up task-work */
> > +     ret = uring_cmd_complete_in_task(ioucmd, ioucmd_task_cb);
> > +     if (ret < 0)
> > +             kfree(ucd->meta);
> > +
> > +     /* unmap pages, free bio, nvme command and request */
> > +     blk_rq_unmap_user(bio);
> > +     blk_mq_free_request(req);
>
> How can we free the request here if the data is only copied out in
> a task_work?

Things that we want to use in task_work (command status and result)
are alive in "ucd" (which is carved inside uring_cmd itself, and will
not be reclaimed until we tell io_uring that command is over).
The meta buffer is separate, and it is also alive via ucd->meta. It
will be freed only in task-work.
bio/request/pages cleanup do not have to wait till task-work.

> >  static int nvme_submit_user_cmd(struct request_queue *q,
> >               struct nvme_command *cmd, void __user *ubuffer,
> >               unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
> > -             u32 meta_seed, u64 *result, unsigned timeout)
> > +             u32 meta_seed, u64 *result, unsigned int timeout,
> > +             struct io_uring_cmd *ioucmd)
> >  {
> >       bool write = nvme_is_write(cmd);
> >       struct nvme_ns *ns = q->queuedata;
> > @@ -1179,6 +1278,20 @@ static int nvme_submit_user_cmd(struct request_queue *q,
> >                       req->cmd_flags |= REQ_INTEGRITY;
> >               }
> >       }
> > +     if (ioucmd) { /* async handling */
>
> nvme_submit_user_cmd already is a mess.  Please split this out into
> a separate function.  Maybe the logic to map the user buffers can be
> split into a little shared helper.

Ok. I will look at refactoring the way you mentioned.

> > +int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
> > +             enum io_uring_cmd_flags flags)
>
> Another comment on the original infrastructure:  this really needs to
> be a block_device_operations method taking a struct block_device instead
> of being tied into blk-mq.
>
> > +EXPORT_SYMBOL_GPL(nvme_uring_cmd);
>
> I don't think this shoud be exported.

It is needed to populate the callback in PCI transport. Not right?


Thanks for the detailed review.
-- 
Kanchan
