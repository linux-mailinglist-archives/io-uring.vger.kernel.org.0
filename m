Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9929B4D293D
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 08:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiCIHE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 02:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiCIHE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 02:04:59 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B231E02EC;
        Tue,  8 Mar 2022 23:04:01 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id bt26so2103956lfb.3;
        Tue, 08 Mar 2022 23:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kC1honlpPqbd0U19UJ9XJiEx07PrOqmIT4xgwjmDqYg=;
        b=Knzq25TFwbkPITtv1ULPzaKty7jBithqFlOsAvow2l/wAuKTTUEE0S3N0j5qpidCIg
         izQAm/jZ1wt2Uxaox/LfySimB9y9lUIvTh2EN519keNpXM9TXfgTUR1yQPr87uFCA9vo
         YWnoTlzOURUvo/HioIA4CXjQLwcpof8QBCiF+TFYkW5Ur0g/gYqxG6cjwVNVa1ltLRlw
         B6YHi2wSB5N3cAKDPJOXvnoECyU17Y6XPa1LhJXmt3f4pDUX/i1s4Nk00KUS0fWzLuz3
         56Ism2Fn5Y5FOHGqDC27gY/T9AiBiSwlK+KvcvKByANLjtV7NaMIMPJdZ5vC+rfv6mQJ
         Fwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kC1honlpPqbd0U19UJ9XJiEx07PrOqmIT4xgwjmDqYg=;
        b=weq6g/Nx50g9Rn0uZlYlM7Nyqz3/JJZNwezCqi3fElFpvsvTlYitdyZJqIFKxeP4n0
         VCWFk+e8mh+u1bDVRZ34yF5lf1SK3oDnH8bGzWUtvIA3HH8N0lwCKiZmk9Cs5taLINBd
         SZ44dVeumkVCd2CyeYshU4K9s0eQzvitEWHxc2O2FhqEzXNHifkaTe8bnBXMNihCH7yD
         j2UQG+67Z+noxEx1nK3tl1qzbpUedHBN/YSnQBnPORCaI1Z5rOSatpLv5pQTz37cQCYL
         JRUBOlhCG1TR/t+T3W9kKvlq4QsCgyTnPzEkHpQkKF2oqPevPftOT7q1big9FV0ZYvFZ
         Wm+g==
X-Gm-Message-State: AOAM533/uhN9b7f6sa+LWFGypG3H+l6nC3qK3sNwwyokdDD/EXKjAU4D
        mu8savwgAkasqzTEmIWeh++Saf+PLXe9CQgncd0=
X-Google-Smtp-Source: ABdhPJxiZsMxro7KEvH5gOFU6sYzzt0XHyhxDRv99yW+yYyLcHrIK88FJIeNr54w++1JqViFN/NVfgMOg9rH0RyjPZ0=
X-Received: by 2002:a05:6512:1111:b0:439:6328:c168 with SMTP id
 l17-20020a056512111100b004396328c168mr13012310lfg.650.1646809439303; Tue, 08
 Mar 2022 23:03:59 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152720epcas5p19653942458e160714444942ddb8b8579@epcas5p1.samsung.com>
 <20220308152105.309618-14-joshi.k@samsung.com> <20220308170857.GA3501708@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20220308170857.GA3501708@dhcp-10-100-145-180.wdc.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 9 Mar 2022 12:33:33 +0530
Message-ID: <CA+1E3rLEJ49jp678Us1C3ux2iu4KWT9FF+iMjY5_Ug2MAU1q7w@mail.gmail.com>
Subject: Re: [PATCH 13/17] nvme: allow user passthrough commands to poll
To:     Keith Busch <kbusch@kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
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

On Tue, Mar 8, 2022 at 10:39 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Tue, Mar 08, 2022 at 08:51:01PM +0530, Kanchan Joshi wrote:
> >       if (copy_from_user(&io, uio, sizeof(io)))
> >               return -EFAULT;
> > -     if (io.flags)
> > -             return -EINVAL;
> > +     if (io.flags & NVME_HIPRI)
> > +             rq_flags |= REQ_POLLED;
>
> I'm pretty sure we can repurpose this previously reserved field for this
> kind of special handling without an issue now, but we should continue
> returning EINVAL if any unknown flags are set. I have no idea what, if
> any, new flags may be defined later, so we shouldn't let a future
> application think an older driver honored something we are not handling.

Would it be better if we don't try to pass NVME_HIPRI by any means
(flags or rsvd1/rsvd2), and that means not enabling sync-polling and
killing this patch.
We have another flag "IO_URING_F_UCMD_POLLED" in ioucmd->flags, and we
can use that instead to enable only the async polling. What do you
think?
