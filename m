Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0B32E69C
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 11:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEKpW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 05:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhCEKpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 05:45:11 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C46BC061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 02:45:10 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so5815050wma.0
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 02:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NZwS2J3Ocb1h5Ffe7xElWH2+RmHLKydk8E116ZIyoA0=;
        b=gZX++oMxiVwkzJUXmGCRBa8tJYvOaRsVETmtpxqGDtnmA+20uvbE0RWXTjr7Oqw0ec
         l3DGVj38N4BRsQ/AIlMWgs6TROcI4hvhP63jiNu2R8jbkVC9DjHNqmv/olWC9Ntei51s
         n6i6HbbWe9aiY8T5+W5xd6CsaZ/bt2AiD65Ls7TGucl1w2XYE3Xfil/EdpmL53qvLhrM
         uh9Y4NME5dC8nTHXR/jU71iLLEs3l4Ye+JvDlzWbXRNoFJWA1Np5AtucyqIleZWCKBZy
         Yod6fYQPc+bntuVy+NvFojzc5SQjaeNqK7foxFusH+ho08VX3K6fjaBCTFDliBcM+7Ya
         2+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZwS2J3Ocb1h5Ffe7xElWH2+RmHLKydk8E116ZIyoA0=;
        b=PqRjpYKAIjIpS95AxIKuhZ+Fjmea4dsVXdlzWfNx3yaDsqQXUDu6Twcgc4zcs4sdPX
         QbpDW7FejhFjHmUlsZW2mrBpHXTqT2UX2Aptf3smhLfslQtWJItvY4azuIhNRLcNZYo5
         5sgVahWe9gumWpl33lryeEsi0igkwF2QdPj+FSvZEU5054lbo0MMNvvJesFAqYgeln/G
         FfUSaloqK/tXk8X/fpneJeYyTQ1q/oW82nSTigkZsOhlZfRF/CMsIzblicVVhAVl9jmT
         mpjgqVnT/0vRSHTelJ7S2UQHsbZj7bdYNyZYGQ3NklHYsGgdOGEae2H47uArXQRcRDgk
         dfzQ==
X-Gm-Message-State: AOAM531LTe72Js32F3Ft6gTon/WgRHKAmNR3ukforQMiR4rwiDE8KjC1
        IYCtePWra+x8pS3F8n2lLAVmtoErcbUY2SBzC+XOr9WC30E=
X-Google-Smtp-Source: ABdhPJxUgd6mpZ9+slf42a6EXjG/w+QEsJH+sbRku7AyAEVdoJIKBIe6d69e3LLGn/HGEd9djPPUJHuDlGSh6ZZWa2M=
X-Received: by 2002:a1c:4d09:: with SMTP id o9mr8162928wmh.15.1614941109143;
 Fri, 05 Mar 2021 02:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20210302160734.99610-1-joshi.k@samsung.com> <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com> <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
 <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com> <20210305024133.GD32558@redsun51.ssa.fujisawa.hgst.com>
In-Reply-To: <20210305024133.GD32558@redsun51.ssa.fujisawa.hgst.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 5 Mar 2021 16:14:43 +0530
Message-ID: <CA+1E3rL=xWPERkPuxAOrwg2ie3e=f8=f8r_pCVFca_BNTtvE=g@mail.gmail.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
To:     Keith Busch <kbusch@kernel.org>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 5, 2021 at 8:11 AM Keith Busch <kbusch@kernel.org> wrote:
>
> On Thu, Mar 04, 2021 at 04:31:11PM +0530, Kanchan Joshi wrote:
> > On Thu, Mar 4, 2021 at 3:14 AM Chaitanya Kulkarni
> > <Chaitanya.Kulkarni@wdc.com> wrote:
> > >
> > > On 3/2/21 23:22, Kanchan Joshi wrote:
> > > > +     if (!ioucmd)
> > > > +             cptr = &c;
> > > > +     else {
> > > > +             /*for async - allocate cmd dynamically */
> > > > +             cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
> > > > +             if (!cptr)
> > > > +                     return -ENOMEM;
> > > > +     }
> > > > +
> > > > +     memset(cptr, 0, sizeof(c));
> > > Why not kzalloc and remove memset() ?
> >
> > Yes sure. Ideally I want to get rid of the allocation cost. Perhaps
> > employing kmem_cache/mempool can help. Do you think there is a better
> > way?
>
> I'll need to think on this to consider if the memory cost is worth it
> (8b to 64b), but you could replace nvme_request's 'struct nvme_command'
> pointer with the struct itself and not have to allocate anything per IO.
> An added bonus is that sync and async handling become more the same.

Indeed, thanks for this. I will fold that change as a prep in the next version.
