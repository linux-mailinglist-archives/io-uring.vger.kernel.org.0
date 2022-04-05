Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9604F51D2
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 04:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345072AbiDFCVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 22:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457470AbiDEQDQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 12:03:16 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E031399
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 08:50:09 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-de3ca1efbaso14812711fac.9
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 08:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUttHdvINpe5sVhWObI5vLGtPLNGhZcWSqGwgeAO4mE=;
        b=qj9doXvWuOFIaHhB/lpA9JrLUjyYVB8c8gFdTvzSHt0jLW1387lWVvGH2dvNVwqeZj
         qC1372+vgjT0U1CZ82ZkGR33s6RLxhvpRJWIvDVB4cULFhGxYaD5ucAn45Vs915PztCa
         bGEkAZ1/Y96zbHwvuPSTfCvuBCqWRnqWr60V7wrP8N6YMNLLdPSeRMLTbv9CjlFlWKWZ
         nuwb9tS5k5cpdDzewQaxniExFQV9GWpJ9Xd3vCHZyX7E6z+R4zBPk8mxAHJBPlJ82k4P
         aNKch2pKombMdNEqfZOdonb387OTkOLF//3iKmeHGfgzNen5jy2z8Lp2CzqokwNbdKBI
         buMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUttHdvINpe5sVhWObI5vLGtPLNGhZcWSqGwgeAO4mE=;
        b=1ITj89aTXFniJ5XG8tHOHEmSVM5u2WIzz0q4xaqHWCWoXqTEa4du1EwqN2zQHjmR1C
         6+YEk5phiqdlcsCDHbBE0CQr9nEiIEkH5Gei3TQZ5jw4+r+IZ2UDdnBduSuIrAkjiEZ8
         zMb8I9prxMH2dFIw0C9FhAZs9OBY9Uzz9MCglZTS3QlEJL5+gvSzNdaIEkNES4U4Ixss
         q/ghoDMJ+RMamNPBppZdZlrMaJJKGfRDa1GEb6W+fLyJbWOZfwM20FPoAu0m1UVu1eMC
         GP5GWHF11svnD9vb/34TnhIlcVVAwbQyxcJCOH5XGeIKCrGm/Cdw7Tg16N9H6RDKLxog
         1HJA==
X-Gm-Message-State: AOAM531I1ryE6m+TjCVCkcXUmaoPrp0IHyLDn3f3d1T7P4HP3eax1suy
        tV9GLniMZgfOY3mdrsBh6jc34RcC/El5/Pu/mo0=
X-Google-Smtp-Source: ABdhPJzP1wb3PsOcO9yDICUnJCahvxJb3BLsH5WxSrw8IQTqclqb+WJrKOKneWX0DaAUU7SGiWugYRW7oAcNoKNyP+k=
X-Received: by 2002:a05:6870:d18b:b0:d9:f452:be90 with SMTP id
 a11-20020a056870d18b00b000d9f452be90mr1844465oac.15.1649173809200; Tue, 05
 Apr 2022 08:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com>
 <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de>
 <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com> <20220405060224.GE23698@lst.de>
In-Reply-To: <20220405060224.GE23698@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 5 Apr 2022 21:19:43 +0530
Message-ID: <CA+1E3rJXrUnmc08Zy3yO=0mGJv1q0CaJez4eUDnTpaJcSh_1FQ@mail.gmail.com>
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on char-device.
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
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

On Tue, Apr 5, 2022 at 11:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Apr 04, 2022 at 07:55:05PM +0530, Kanchan Joshi wrote:
> > > Something like this (untested) patch should help to separate
> > > the much better:
> >
> > It does, thanks. But the only thing is - it would be good to support
> > vectored-passthru too (i.e. NVME_IOCTL_IO64_CMD_VEC) for this path.
> > For the new opcode "NVME_URING_CMD_IO" , either we can change the
> > cmd-structure or flag-based handling so that vectored-io is supported.
> > Or we introduce NVME_URING_CMD_IO_VEC also for that.
> > Which one do you prefer?
>
> I agree vectored I/O support is useful.
>
> Do we even need to support the non-vectored case?
Would be good to have, I suppose.
Helps keeping it simple when user-space wants to use a single-buffer
(otherwise it must carry psuedo iovec for that too).

> Also I think we'll want admin command passthrough on /dev/nvmeX as
> well, but I'm fine solving the other items first.
>
> > > +static int nvme_ioctl_finish_metadata(struct bio *bio, int ret,
> > > +               void __user *meta_ubuf)
> > > +{
> > > +       struct bio_integrity_payload *bip = bio_integrity(bio);
> > > +
> > > +       if (bip) {
> > > +               void *meta = bvec_virt(bip->bip_vec);
> > > +
> > > +               if (!ret && bio_op(bio) == REQ_OP_DRV_IN &&
> > > +                   copy_to_user(meta_ubuf, meta, bip->bip_vec->bv_len))
> > > +                       ret = -EFAULT;
> >
> > Maybe it is better to move the check "bio_op(bio) != REQ_OP_DRV_IN" outside.
> > Because this can be common, and for that we can avoid entering into
> > the function call itself (i.e. nvme_ioctl_finish_metadata).
>
> Function calls are pretty cheap, but I'll see what we can do.  I'll try
> to come up with a prep series to refactor the passthrough support for
> easier adding of the io_uring in the next days.

In that case we will base the newer version on its top.
