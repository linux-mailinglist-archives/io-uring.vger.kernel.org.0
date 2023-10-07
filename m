Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638917BC88D
	for <lists+io-uring@lfdr.de>; Sat,  7 Oct 2023 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbjJGPNZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Oct 2023 11:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbjJGPNY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Oct 2023 11:13:24 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D797B9
        for <io-uring@vger.kernel.org>; Sat,  7 Oct 2023 08:13:23 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5a4c073cc06so36070737b3.1
        for <io-uring@vger.kernel.org>; Sat, 07 Oct 2023 08:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1696691602; x=1697296402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgqAnIXXeH9mWDMXjQvN3wvgKO1Ce5NTzFzcD5NvWDo=;
        b=dobd+es8skvlgpTVlLPxuhz4H6WlTISbS/Igu38zNMv4he7tH/PZUjAK/As65w1yfQ
         LgQ/ELLJ6a/0qxJhG1wjiOS1ISQYq/XO1m/4yAoZXjANwWGY5dR0nl/iFoV6zN5pvjgv
         J6m9pNinuTElTumJuPCqVEyCSjMuryfIB2Hqh4pIyTRY9+ZI5+2VbJT2EV4Ub45aO5eD
         aN516TRaXwRDFKlSyY+00OoJ+xZYtXOQCKhN+ax4R/xKIN1dBSQRnVEh8JXCy4XUi++I
         TqkTWN2pWS0QcJZZKs45A+bCqwdqXm/9BQR+zyGv21xdur8tXZi1FkdRkCQb4cdChI7+
         9FAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696691602; x=1697296402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgqAnIXXeH9mWDMXjQvN3wvgKO1Ce5NTzFzcD5NvWDo=;
        b=TGs7LiUrYUpPQ8ummtjG95J0lkfkXfSAFEPntOTopTkJz/AoxoHX3HtLR1owDW+Tlp
         k/M6uJhjsSnBdvqQ9khtnkx0XB+a9CxxM9Hv/KL3leTSFgEHJPDdDMpLHQCiFbHK50FX
         kz9IWh372zh8/mA68JblKRLFF47a753l/sHM+IvzWMERupBoP/2XUCKFGO0WJuc4QBvE
         JPFZqd+zGOcjFly7ywr4vV4rOEUJPz/+2SzCGVvAdRJSIskcTxBiJftVk9UOKAjFKZcR
         vO83Nbi5MuE5ruJYirN1WYNCP3bACkss1BR8SJy6B2TVgPjY5zUZukSNFeHRjDTT/yl1
         9VJQ==
X-Gm-Message-State: AOJu0Yw19q3fYA9Z1fsJPdp9i+zk8zfsWOy9SsKRc+SxtIlAlU9vhajK
        TsqI5wYYLe40KTITn/CYMdmOtvqn1fTbJMCxhFuH
X-Google-Smtp-Source: AGHT+IGaHfz1m1aCEzDxNVMecmiG8/VmlYGquX07ej4nTF6+rNUWqNpyHTFkXvZRWC9wSpHZwU/4iieyDYA/Xr2RZ0k=
X-Received: by 2002:a25:1e43:0:b0:d4b:a962:76a3 with SMTP id
 e64-20020a251e43000000b00d4ba96276a3mr5418892ybe.29.1696691602664; Sat, 07
 Oct 2023 08:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
 <ab758860-e51e-409c-8353-6205fbe515dc@kernel.dk> <e0307260-c438-41d9-97ec-563e9932a60e@kernel.dk>
In-Reply-To: <e0307260-c438-41d9-97ec-563e9932a60e@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 7 Oct 2023 11:13:11 -0400
Message-ID: <CAHC9VhQ0z4wuH7R=KRcUTyZuRs7adYTiH5JjohJSz4d2-Jd9EQ@mail.gmail.com>
Subject: Re: audit: io_uring openat triggers audit reference count underflow
 in worker thread
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dan Clash <Dan.Clash@microsoft.com>,
        "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Oct 7, 2023 at 9:11=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/6/23 8:32 PM, Jens Axboe wrote:
> > On 10/6/23 2:09 PM, Dan Clash wrote:

...

> > I'm not fully aware of what audit is doing with struct filename outside
> > of needing it for the audit log. Rather than impose the atomic
> > references for everyone, would it be doable to simply dupe the struct
> > instead of grabbing the (non-atomic) reference to the existing one?
> >
> > If not, since there's no over/underflow handling right now, it'd
> > certainly be cheaper to use an atomic_t here rather than a full
> > refcount.
>
> After taking a closer look at this, I think the best course of action
> would be to make the struct filename refcnt and atomic_t. With audit in
> the picture, it's quite possible to have multiple threads manipulating
> the filename refcnt at the same time, which is obviously not currently
> safe.

Thanks Jens.

I personally would feel a bit better with the additional safety
provided by refount_t, but I agree that there is little chance of an
overflow/underflow in this case so the additional refcount_t checking
is not likely to be needed here.

For the record, this should only be an issue when audit is combined
with io_uring, prior to io_uring there wasn't an issue with multiple
threads attempting to cleanup the filename objects so we didn't have
to worry about racing on filename::refcnt updates.  However, for those
systems where both audit and io_uring are in use we definitely have a
problem and will need the upcoming fix from Dan to ensure the safety
of the system.

Thanks for spotting this Dan and doing the initial investigation into
the problem, if you run into any problems with the patch or need a
hand let me know, I'm happy to help.

> Dan, would you mind sending that as a patch? Include a link to your
> original email:
>
> Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584F1C=
9A@MW2PR2101MB1033.namprd21.prod.outlook.com/
>
> and a Fixes tag as well:
>
> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support =
to io_uring")
>
> and CC linux-fsdevel@vger.kernel.org and
> Christian Brauner <brauner@kernel.org> as well.

I'm going to CC Christian on this email just so he has a heads-up
about the problem and knows to expect a patch.

--
paul-moore.com
