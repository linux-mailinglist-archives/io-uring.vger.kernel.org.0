Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44FE47D325
	for <lists+io-uring@lfdr.de>; Wed, 22 Dec 2021 14:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhLVNrE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 08:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbhLVNrD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 08:47:03 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE814C061574;
        Wed, 22 Dec 2021 05:47:02 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id i12so1626094wmq.4;
        Wed, 22 Dec 2021 05:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxvMlF+l51oDklf4EWdV5hXzMGWV02iTMeiu5UDuE14=;
        b=EqwnjVMY7HMk9vmwXPlECKQbKBxQ1TmHzuOg9dZYm38j3qn958X3+M1Lsm73knrJN8
         gPqRxOj/t/X0hnbQrQzvxwDlOtOIzRn0NsHQF2cOMikt6I1aybrCWrJRNUc91wW/Ruer
         R0q17uz4oBfLyWR3W9I95XBcT0sHWigqYiMC+GPmCVawoSUXJdA7OxboIlEeR1eDkxkt
         AuXbjq8h3m4jsheXsDmFu5j5B0Hf1WGZl5L5R5e9xRQ4SFAWKgHTKw+eq29tyN+31iqK
         BjpSCDJoTc5rCPfgMtSAe9oOfiokMXuNKCCxINdNM1QAYxFepXoZogVo7koypWnJNx0D
         jykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxvMlF+l51oDklf4EWdV5hXzMGWV02iTMeiu5UDuE14=;
        b=mZ7BbpdSngvs++yy0UM6bA0DxBeiSAod1SL6uqe7KZZxyd9NK7acggYj+rVHpi6l0M
         vt2o48vzPN4tm4jLEOq55mX+Syy3RHQKjJnCHS+isdTaUjOZhKvqqeVHf377z8E8kH1r
         uKwS1rrXEmQNNtX2IZayCj7ec8qCHJxvnpgGDNcaXaz5bm6tYpYuvtq2Oyf5mHTfsi2h
         MjxkWlH3tTbZdWiweYAvDKh87Mb4Bn8HsybjX43oCZgtd3varbFWpGVcbXXG0dRFop9T
         eafk1JFIC2+BexbqVD5ODlZaRJWDVy8udEkLL4us51hOihy8d2FSXPAl5Rxi53sqj6OH
         fjyA==
X-Gm-Message-State: AOAM531PoJqjtM4kNmRQGo2HijbgauWqbmn2YzpZ4l+6v3QsA27DA4c2
        i5P9n/H1utMxNgrkH/5UkOAPc0BgHSB6C31MqBg=
X-Google-Smtp-Source: ABdhPJxkxIwRoqvckjEUCYcJLdJLYPj3QuiYAWIBmMn64kvOBURss2n9lxMGdsbdDXeake/d5KlX0U843vkNazgqp0c=
X-Received: by 2002:a1c:f213:: with SMTP id s19mr1042698wmc.0.1640180821187;
 Wed, 22 Dec 2021 05:47:01 -0800 (PST)
MIME-Version: 1.0
References: <2da62822fd56414d9893b89e160ed05c@kioxia.com>
In-Reply-To: <2da62822fd56414d9893b89e160ed05c@kioxia.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 22 Dec 2021 19:16:35 +0530
Message-ID: <CA+1E3r+kmGcAsN-1F4W02+qrF7MJ1fqbRWnOfNAqNAapg=E4qw@mail.gmail.com>
Subject: Re: [RFC 02/13] nvme: wire-up support for async-passthru on
To:     Clay Mayers <Clay.Mayers@kioxia.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "javier@javigon.com" <javier@javigon.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 22, 2021 at 2:46 AM Clay Mayers <Clay.Mayers@kioxia.com> wrote:
>
> Message-ID: <20211220141734.12206-3-joshi.k@samsung.com>
>
> On 12/20/21 19:47:23 +0530, Kanchan Joshi wrote:
> > Introduce handlers for fops->async_cmd(), implementing async passthru on
> > char device (including the multipath one).
> > The handlers supports NVME_IOCTL_IO64_CMD.
> >
> I commented on these two issues below in more detail at
> https://github.com/joshkan/nvme-uring-pt/issues

That is on general/existing nvme ioctl (and not specific to this
series). You might want to open up a discussion in the nvme mailing
list.

> > +static void nvme_setup_uring_cmd_data(struct request *rq,
> > +             struct io_uring_cmd *ioucmd, void *meta,
> > +             void __user *meta_buffer, u32 meta_len, bool write) {
> > +     struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
> > +
> > +     /* to free bio on completion, as req->bio will be null at that time */
> > +     cmd->bio = rq->bio;
> > +     /* meta update is required only for read requests */
> > +     if (meta && !write) {
> > +             cmd->meta = meta;
> > +             cmd->meta_buffer = meta_buffer;
> > +             cmd->meta_len = meta_len;
> > +     } else {
> > +             cmd->meta = NULL;
> I believe that not saving meta in cmd->meta will leak it when it's a write.

Indeed. Will fix that up.

> But nvme_pt_task_cb also needs to change to copy to user when
> cmd->meta_buffer is set instead of cmd->meta.
>
> > +
> > +int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd,
> > +             enum io_uring_cmd_flags flags)
> > +{
> > +     struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
> > +                     struct nvme_ns, cdev);
> > +
> > +     return nvme_ns_async_ioctl(ns, ioucmd); }
> > +
> The uring cmd flags are not being passed to nvme_ns_async_ioctl - what if
> IO_URING_F_NONBLOCK Is set?  When it is, I think the nvme_alloc_request()
> call in nvme_submit_user_cmd() needs to pass in BLK_MQ_REQ_NOWAIT as
> the flags parameter or move to another thread.  Our proto-type does the former
> requiring user mode to retry on -EWOULDBLOCK and -EBUSY.

Right, this part is not handled. Need to get that sorted in the next
version. Thanks.



-- 
Joshi
