Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064394F5787
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 10:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiDFHFf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 03:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358451AbiDFGPb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 02:15:31 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EAF497CCB
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 22:20:40 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-deb9295679so1794689fac.6
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 22:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l9+/yCBOkTtbp5l+BKTxdkzgNWz3+13PB5ObVpgIN9E=;
        b=I7Izv+wp6ICDb7mI38AwuHhe5dwXif0rfGr2Hjv999l3tq946mdQCUX5KDMy4GBm1d
         R2R4NrMcXrZSImZBvZj0Kq0ufHsMuiMGSkvm41mS8GL7aPJUE7ffi+VlRJte3B7gEzol
         VM6NNi9Tnu3MelDu6ixUrnDKREHSy7jj1V167N7majhuSd+ogSb5O6Pj+clwWf5qYV2T
         RGKWSXX+oF8XfN5riAnfTWiYnzX2mP8afPBKfmdQK+5ZjjMxvC/9OkCrOjCl/HJc7PM1
         M63y3OI6/eh8DtaXftYnx9d9/QaI2AzYAfkLwh2nWLIyb4nLRDuXbVGDXGJfOPGi2xl3
         vIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l9+/yCBOkTtbp5l+BKTxdkzgNWz3+13PB5ObVpgIN9E=;
        b=GPnbm3uj64GEsr7olO272rqvaWc6It8X6uVEUl6dw9oWFH4Zo8WTXLkMwlmTL7dRS+
         FPWc6duHpjc+tYVk8y44ZfyjhvVIKX7RTotC1PZl13XEkIs26dv6fZEyyHen93iCgl+3
         HdBttw489FG84vMKJPgGpKOAQBLuaYEZu5jkmJRYxpdY8MagB+vtgvYE/2SPxjEdswrD
         OZT8jKlxgRHflPQozO0c9SSokEOFx4x5XnsEfKihr5A82zskDl/ACbE6fLvi6maTJmnp
         TkYFYJhvuXablZdz4P9S0EFNoRJio+iY7b06Ki2CVOI3Rk8UKbJtreiBMybKQabutKKz
         iZbA==
X-Gm-Message-State: AOAM5329IIR3nZovZljTuoTdIYsrOh27SrxcdniUXOH84vwxASllOgsw
        R1fdslR47DfQfNVqMDSMyJmhGQOrA+BT/QTQHAI=
X-Google-Smtp-Source: ABdhPJw0/I69tdKuJDxigBoP3AuSaTFMWHsdn/qNZukJRBdrFbQrK5Om31iXu3Aez6v38D8oDQ1TQV860NcC4Y6Gz0U=
X-Received: by 2002:a05:6870:d18b:b0:d9:f452:be90 with SMTP id
 a11-20020a056870d18b00b000d9f452be90mr3118492oac.15.1649222439368; Tue, 05
 Apr 2022 22:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com>
 <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de>
 <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com>
 <20220405060224.GE23698@lst.de> <CA+1E3rJXrUnmc08Zy3yO=0mGJv1q0CaJez4eUDnTpaJcSh_1FQ@mail.gmail.com>
In-Reply-To: <CA+1E3rJXrUnmc08Zy3yO=0mGJv1q0CaJez4eUDnTpaJcSh_1FQ@mail.gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 6 Apr 2022 10:50:14 +0530
Message-ID: <CA+1E3rK3EzyNVwPEuR3tJfRGvScwwrDhxAc9zs=a5XMc9trpmg@mail.gmail.com>
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

> > Also I think we'll want admin command passthrough on /dev/nvmeX as
> > well, but I'm fine solving the other items first.

Sure, will add that in the second round. Should be fairly simple as we
can reuse io-command work anyway.

> > > > +static int nvme_ioctl_finish_metadata(struct bio *bio, int ret,
> > > > +               void __user *meta_ubuf)
> > > > +{
> > > > +       struct bio_integrity_payload *bip = bio_integrity(bio);
> > > > +
> > > > +       if (bip) {
> > > > +               void *meta = bvec_virt(bip->bip_vec);
> > > > +
> > > > +               if (!ret && bio_op(bio) == REQ_OP_DRV_IN &&
> > > > +                   copy_to_user(meta_ubuf, meta, bip->bip_vec->bv_len))
> > > > +                       ret = -EFAULT;
> > >
> > > Maybe it is better to move the check "bio_op(bio) != REQ_OP_DRV_IN" outside.
> > > Because this can be common, and for that we can avoid entering into
> > > the function call itself (i.e. nvme_ioctl_finish_metadata).
> >
> > Function calls are pretty cheap, but I'll see what we can do.  I'll try
> > to come up with a prep series to refactor the passthrough support for
> > easier adding of the io_uring in the next days.
>
> In that case we will base the newer version on its top.
But if it saves some cycles for you, and also the travel from nvme to
linux-block tree - I can carry that refactoring as a prep patch in
this series. Your call.
