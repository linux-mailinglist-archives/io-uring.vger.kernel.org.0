Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1E332D140
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 11:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbhCDK5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 05:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239110AbhCDK4v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 05:56:51 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0270C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 02:56:10 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e23so7606437wmh.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 02:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Zx3mVbBGO/ltzSq4EWhn1tzp/kggwYcL9Ay/uYDpR0=;
        b=f5iit4SlEbzOINEygGhb1lvyimtovEWNG1veqKtkPLOQEYVLh28Rnn5wRteGbiQaos
         +BWyKvTaZ/Zzkf9lsyx43ui8UDUFgZL52HlQxOXkI+FD4wL2zVDFKSdpexR64S7/uQJY
         osUd9bgZBycBkeoRSWpO8CJhLqPbyPxrGjNTw5DXBzDqGT8G31ZJqMx7MBr0Rn9kRDSO
         /CDUkPXIR6xd0jSg3yOiI0HglwqugOJjihvv06h2XFxwoiSjXnh8nCneMFgHZErcTqYb
         KsUVPOaOdSj3LgzIl6uVgAvCD9sjavg3VEbFDo2ZRA7mOfIWI55zwHJotG45Er6H6z9O
         HaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Zx3mVbBGO/ltzSq4EWhn1tzp/kggwYcL9Ay/uYDpR0=;
        b=AFIgh9CRyG0B7z2OIcujXAs/2R+NOHhrRHxHaSNiqLRi53t9KNzTrZ6Fhok+5HYcKU
         cLUI/mz1qnxIrNPJFbjvt1dDvko6uGgXXYAi1F/y5DTOQYmmL2Bs8cy6txNZAgDovKhi
         Tgh4xqu/xjccYsek9cls9YRl6lhWgj4YTB8hUtOsbQOfQSEAf5jR92KrKVYMZQqiAPQc
         YiuXPxc9nBBMko1IVdIEfF6WlllkGOYehxCIjlTLvl/LiPY+ipvJd7+OpCh/28SJ4eB5
         fpOp1J5SaUenbaSaSPHYzzLL99jcTQEsWaNfG9GH0cS6erOt4CUEA9xcy+9ZvUyu9kM9
         8Kuw==
X-Gm-Message-State: AOAM532M6YDkSLDN1gsRHva/qJ8kuz5K96Elb9o266bV7ekuAMS7sOrW
        top+YyNmw/RoewcejSduCBjgkonTh6zv3W3rf2g=
X-Google-Smtp-Source: ABdhPJwLOl6wlqdJiG1KynLq50DWRdOIcAXNG6M8eJ2ixliHBGpelVu1zo8IjxoK+8GuYlX7En9tSFapP1Gz1iQ8cVA=
X-Received: by 2002:a1c:4d09:: with SMTP id o9mr3294240wmh.15.1614855369547;
 Thu, 04 Mar 2021 02:56:09 -0800 (PST)
MIME-Version: 1.0
References: <20210302160734.99610-1-joshi.k@samsung.com> <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com> <BYAPR04MB4965E07D8D106CE6565DFB7386989@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB4965E07D8D106CE6565DFB7386989@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 4 Mar 2021 16:25:41 +0530
Message-ID: <CA+1E3rJZWkOw+ZfDGduQhdhTh+=JVe5CcFEZtfQ1Jmq6mKhbSA@mail.gmail.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 4, 2021 at 12:22 AM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> On 3/2/21 23:22, Kanchan Joshi wrote:
> > +     switch (bcmd->ioctl_cmd) {
> > +     case NVME_IOCTL_IO_CMD:
> > +             ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
> > +             break;
> > +     default:
> > +             ret = -ENOTTY;
> > +     }
> Switch for one case ? why not use if else ?

Indeed, I should have used that. I had started off with more than one,
and retracted later.
