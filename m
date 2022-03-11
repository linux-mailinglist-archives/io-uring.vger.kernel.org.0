Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3145C4D6A9A
	for <lists+io-uring@lfdr.de>; Sat, 12 Mar 2022 00:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiCKWrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 17:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiCKWqr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 17:46:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2452DBB9D;
        Fri, 11 Mar 2022 14:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xrkMsT6XPANqLk5GgYC5BUODbPJFQSrD5uKd2h8hjI0=; b=o8WKllppkLb2BIVSD+J4aLbTwv
        5gndsfeuUbWil76bV48Bod+g3Z5FKYD8Md3X7HpaRu39sq8Skg1QymZXtK9BLncxzpiY8UgM0li1s
        pZuv9prfNIM9TegktC/YEVt7l2Dq/yttoxdX1XntcxnmNy4Ma6fIZGadRlHp0LKSrkFN9IHVbPn4s
        XOH7C5FhCMqu3TWY8rAEv3sOJeOAzuriUSFCH4jr0drJrWuHh7OZ0LlDhnnqLiT+E9TKvSwvE+8X+
        As5LQIFAdh+nBqeoIYFKxkFyYJnfd+jOdq1kzigY6IFY58pyMCjlzEsXtsU7HvOTMkxDqGcxf1F5c
        WMD02f6g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSmOw-000GrH-B8; Fri, 11 Mar 2022 21:02:18 +0000
Date:   Fri, 11 Mar 2022 13:02:18 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-security-module@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        a.manzanares@samsung.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <Yiu42rLif7FSwrjP@bombadil.infradead.org>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com>
 <YiuNZ7+KUjLtuYkr@bombadil.infradead.org>
 <CAHC9VhTnpO6LyaYWDTjJAy_ztGw+qqf-YS0W7S-djyZVnydVHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTnpO6LyaYWDTjJAy_ztGw+qqf-YS0W7S-djyZVnydVHg@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 11, 2022 at 01:53:03PM -0500, Paul Moore wrote:
> On Fri, Mar 11, 2022 at 12:56 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Tue, Mar 08, 2022 at 08:50:53PM +0530, Kanchan Joshi wrote:
> > > diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> > > index 5c9cd9695519..1df270b47af5 100644
> > > --- a/drivers/nvme/host/ioctl.c
> > > +++ b/drivers/nvme/host/ioctl.c
> > > @@ -369,6 +469,33 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > >       return __nvme_ioctl(ns, cmd, (void __user *)arg);
> > >  }
> > >
> > > +static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
> > > +{
> > > +     int ret;
> > > +
> > > +     BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
> > > +
> > > +     switch (ioucmd->cmd_op) {
> > > +     case NVME_IOCTL_IO64_CMD:
> > > +             ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
> > > +             break;
> > > +     default:
> > > +             ret = -ENOTTY;
> > > +     }
> > > +
> > > +     if (ret >= 0)
> > > +             ret = -EIOCBQUEUED;
> > > +     return ret;
> > > +}
> >
> > And here I think we'll need something like this:
> 
> If we can promise that we will have a LSM hook for all of the
> file_operations::async_cmd implementations that are security relevant
> we could skip the LSM passthrough hook at the io_uring layer.

There is no way to ensure this unless perhaps we cake that into
the API somehow... Or have a registration system for setting the
respctive file ops / LSM.

> It
> would potentially make life easier in that we don't have to worry
> about putting the passthrough op in the right context, but risks
> missing a LSM hook control point (it will happen at some point and
> *boom* CVE).

Precicely my concern. So we either open code this and ask folks
to do this or I think we do a registration and require both ops
and the the LSM hook at registration.

I think this should be enough information to get Kanchan rolling
on the LSM side.

  Luis
