Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA4832D176
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 12:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbhCDLCY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 06:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239331AbhCDLCV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 06:02:21 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA033C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 03:01:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id h98so27107225wrh.11
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 03:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjdz8WpGGWhjIOSZ1TFNSDrCUu+htoeU4z79Rhlf1z4=;
        b=IuzSIuS9g6qFONXKeW55E2wLFb+bzYIjDkRKt6O1UhE/WqVnLZVbcXHIAaULej2YF9
         KUmBCXwbxPTW7yQw+8bNq/JqtWTkdBqdG9LD1jAbYiLdVHqz1DRIsonhCP53uwbuBk13
         XssNlKj49yHuOeDj39GLQsNtCB4IBfu5ebT2KMDqVokpVQaWSdLqBezhIRv7sozuJLJq
         UedGqwqMPLJyQNTytvEcHBNGZfngQrS7ojr5TcxzISxu+Qr/ZDmHEEQF2Ac45djuow5C
         +hCb1qfFldnJghETG4O8dkNVxRvjtrOOToONUi4ZYYxsNPppI4xsWtNdR1ULjBRmum62
         V5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjdz8WpGGWhjIOSZ1TFNSDrCUu+htoeU4z79Rhlf1z4=;
        b=WgwiwWgYYsn0DbZ5d9bSKJRtzsT7BMFo6FNbrosS7ySnvgmJ8ucY9BXr2c3KeD6Q/u
         y0jTEfuTNS+XnlmW2npkYzsOVnM3J8EFPiuWuvEA667RKBg4gCLAJk1NRNEds4qTFTnh
         cmCGmJ76xnUvGw7LKJQdkIN8lL7QmAfYs6E3HqQyMaPYy3RHQXprNoPzdDdLZP0LKX1a
         VbRhXefh67kglS2t0JGBmYyXEs66g0DhY7dOrIyxMQlirzI2f7/z5bO/l2uUdI9LIP+j
         5wq3VhAqoVKwdlcPn7dFrtgsNngA4APcS1qgpJc4mgohSuZFHgyZe9MdPd8a0x6UiBOM
         7KfA==
X-Gm-Message-State: AOAM531sO8tW59V5ICfqLrO68nPRuFjt+yLdtabRkWLxwMwruelVeDBr
        bYppoRmNodIeioa3pCORIYMa7o3OL+iibIxUVbg=
X-Google-Smtp-Source: ABdhPJw09jvjtSlQCGIIOkypWNKovOI2rHUY1PIDoq89R6ltpK+7dErIDmB9kAf9NHvOsSyhhf1T2cCUSrfkMpLVjoI=
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr3340605wrz.407.1614855699360;
 Thu, 04 Mar 2021 03:01:39 -0800 (PST)
MIME-Version: 1.0
References: <20210302160734.99610-1-joshi.k@samsung.com> <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com> <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 4 Mar 2021 16:31:11 +0530
Message-ID: <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com>
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

On Thu, Mar 4, 2021 at 3:14 AM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> On 3/2/21 23:22, Kanchan Joshi wrote:
> > +     if (!ioucmd)
> > +             cptr = &c;
> > +     else {
> > +             /*for async - allocate cmd dynamically */
> > +             cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
> > +             if (!cptr)
> > +                     return -ENOMEM;
> > +     }
> > +
> > +     memset(cptr, 0, sizeof(c));
> Why not kzalloc and remove memset() ?

Yes sure. Ideally I want to get rid of the allocation cost. Perhaps
employing kmem_cache/mempool can help. Do you think there is a better
way?
