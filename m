Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20D114D57B
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 05:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgA3EFn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 23:05:43 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46714 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgA3EFm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 23:05:42 -0500
Received: by mail-lj1-f194.google.com with SMTP id x14so1703969ljd.13
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 20:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nn6sM1sfAnc8cwZKaEMBanBcpgX+8UMpM5ioF5rV1I=;
        b=s3komJqcZxSMfZMPsoj7C9Ml7gP3Yv/TmSd7EfGr0oJ1SsltAvcylQwTIQEFUAbQ/X
         3z/SbkWp+ViDFGk7mHNGckL4fR/Dw0gEa813GpS9CTN8ttYdiO1HScV2HOML7rWuxor2
         NoXQ4vMGog9/Kezq39t28KvBj2AgKAHi60ZnXyUxMB07qspSaJeMS/nYTkIqc88+GCZV
         oHSqEW2t9GTcMcJmoxtApn3Y+9d437QLZTptWf4jBaXXpt15kootRqDLX1IecAtN1htW
         aGmKieL5SMAOxoNtvdVGrpNdYj0mN0W2VmddEJ2RFHkNKYak8ncabIalOA+HAC5IdfmW
         vmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nn6sM1sfAnc8cwZKaEMBanBcpgX+8UMpM5ioF5rV1I=;
        b=fw954BWF83cY2OVnPyHlGDLJuPDfQ+Khuclq0EJUVNsbjJnyUVpd3SF8d9hYuPUkR+
         F0lSfSJ4x5BZ6c/x/4WkViicCKC4/nRX3YQeO6B+m/EDedQ7U/5wHD6u1BiMfHpij0ts
         GTsrV8ao/P6wBVMyiwHj4AB/TR53PXCNhFqYK9E8Q++y7tXKX+bwEigqydHH9cyKjuN+
         vsAcvJx/1fAPKkmqEoKJ2kBBDGe5flYQKSEKFWBH9G1dxrD4lchXQ04ASqEwgxRH7fJf
         39jk95neest76jDmaU9XkxLu1Y9sVFZHvE07hefmhfpzY/xANfIJZBtdUN5kxyodF4HP
         Qidg==
X-Gm-Message-State: APjAAAVhvNf35b1Y2oo4kMkZoBVwA69gfkCbencE8UAYAlOAf4/mQmnJ
        6TdlfZawrm7AyteH/Aau878TfhWLyXNPblUyqhdJxg==
X-Google-Smtp-Source: APXvYqw1gpFMZ0Uf5e1bV1CU4rj2S1RaTwAKno1u5IcylmsLrTcgYnNLaxplq+BBr1lUe4ONwOTB6eyG/MbHIrTQ2v8=
X-Received: by 2002:a2e:9052:: with SMTP id n18mr1434944ljg.251.1580357139333;
 Wed, 29 Jan 2020 20:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20200129192016.6407-1-glauber@scylladb.com> <a682d038-046a-4b72-b43c-60e3e559f9e2@kernel.dk>
 <CAD-J=zYCvw+tBRmS42w8X6rOc9zE+L7j5jpjDL-y0YqW6KyBAw@mail.gmail.com> <7ab7584b-303b-8a20-2081-1218ad6c49c0@kernel.dk>
In-Reply-To: <7ab7584b-303b-8a20-2081-1218ad6c49c0@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Wed, 29 Jan 2020 23:05:28 -0500
Message-ID: <CAD-J=zbBh7qUntdjz8xMcbz4aFES-Wws6f7YpH7HVe0hELDunQ@mail.gmail.com>
Subject: Re: [PATCH] add a helper function to verify io_uring functionality
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 29, 2020 at 9:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/29/20 5:42 PM, Glauber Costa wrote:
> >
> >
> > On Wed, Jan 29, 2020 at 3:55 PM Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>> wrote:
> >
> >     On 1/29/20 12:20 PM, Glauber Costa wrote:
> >     > It is common for an application using an ever-evolving interface to want
> >     > to inquire about the presence of certain functionality it plans to use.
> >     >
> >     > The boilerplate to do that is about always the same: find places that
> >     > have feature bits, match that with what we need, rinse, repeat.
> >     > Therefore it makes sense to move this to a library function.
> >     >
> >     > We have two places in which we can check for such features: the feature
> >     > flag returned by io_uring_init_params(), and the resulting array
> >     > returning from io_uring_probe.
> >     >
> >     > I tried my best to communicate as well as possible in the function
> >     > signature the fact that this is not supposed to test the availability
> >     > of io_uring (which is straightforward enough), but rather a minimum set
> >     > of requirements for usage.
> >
> >     I wonder if we should have a helper that returns the fully allocated
> >     io_uring_probe struct filled out by probing the kernel. My main worry
> >     here is that some applications will probe for various things, each of
> >     which will setup/teardown a ring, and do the query.
> >
> >     Maybe it'd be enough to potentially pass in a ring?
> >
> >
> > Passing the ring is definitely doable.
>
> I think it's important we have both, so that an app can query without
> having a ring setup. But if it does, we should have the option of using
> that ring.
>
> >     While this patch works with a sparse command opcode field, not sure it's
> >     the most natural way. If we do the above, maybe we can just have a
> >     is_this_op_supported() query, since it'd be cheap if we already have the
> >     probe struct filled out?
> >
> >
> > So the user will be the one calling io_register_probe?
>
> Not necessarily, I'm thinking something ala:
>
> struct io_uring_probe *p
>
> p = io_uring_get_probe();
> /* call helper functions using 'p' */
> free(p);

ok. That makes  sense.

Thanks.

>
> and have io_uring_get_probe_ring() that takes the ring, for example. All
> depends on what the helpers might be then, I think that's the important
> part. The rest is just infrastructure to support it.
>
> Something like that, hope that makes sense.
>
> >     Outside of this discussion, some style changes are needed:
> >
> >     - '*' goes next to the name, struct foo *ptr, not struct foo* ptr
> >     - Some lines over 80 chars
> >
> >
> > Thanks! If you ever feel trapped with the 80 char stuff come write
> > some c++ seastar code with us!
>
> Such a tempting sell, C++ AND long lines ;-)
>
> > It's my bad for forgetting, I actually had a last pass on the patch
> > removing the {} after 1-line ifs so that was fun too
>
> No worries.
>
> --
> Jens Axboe
>
