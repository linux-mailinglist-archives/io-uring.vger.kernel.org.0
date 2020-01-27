Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2F14A9CB
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 19:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA0S2l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 13:28:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726004AbgA0S2k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 13:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580149719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3mbZcV8yWaTIA/hbNkPjAEycEkSir2saWg6RR3kS4nA=;
        b=Xxiqjro9wXLEIsBCeglqf6WgnPaGDAABf3m21d6du44iB80ksV6Vz8XT+CkWWMNngQfXet
        ev5vjT/G8Z9plBLZcyCmQ0C/2fFvdTkHYyO8HWTXf8M9IsT3sAkMCPfy8qUHIQrOJW0Icf
        mOel91LKWcX8Zt1j3Ya3yxatPTtMnqw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-vta6sbxDOv-FVEwCsZeYPw-1; Mon, 27 Jan 2020 13:28:37 -0500
X-MC-Unique: vta6sbxDOv-FVEwCsZeYPw-1
Received: by mail-wr1-f69.google.com with SMTP id f15so6632608wrr.2
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 10:28:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mbZcV8yWaTIA/hbNkPjAEycEkSir2saWg6RR3kS4nA=;
        b=fl65XDeYToHK31kpoh5GbZIJk1HkLr9aKFCAMJcBv0in3WoHxvRdt2NV1Bdf71Nnhx
         wEQw+ZCTlO9snwIy0uzYy+ifLQaqS+KWhlPwg4luXuvm0jMWyTM+R2Bc4FcdK5oVLt/1
         tJcnt2X6Zi+h6FM9dwfE3XEcRQJNPknKBKX3IM7yjbCtPTy6q5lDFuoTP+eanJBA7E92
         RLcgNWw3WMMg6KoDv+FNicjesBmOTrWWm7AnFGAfh2lZaMKCRSPPIcbRACqlTavzB7vp
         /3u94DonYQDG84jW/t4LdvM4Jy1XMQ6Xmj0xB+pbP2sq7oz+NlbI6BTgJ/vwaqyUsrWx
         7P+w==
X-Gm-Message-State: APjAAAWb6JAx594GssWb/yif3P9ND+x9oYCNGTyda2jQC3D/ysIrJ8Rz
        kBr+irnn3yi9dQAvfAzESsyfyHwJL+IEp/SKz7JLKlQMvIMzkb93FVVNJplE85OwIdI1UK3WKxF
        mMGtpqtbIuWeMJEOTPsA=
X-Received: by 2002:adf:f802:: with SMTP id s2mr24664205wrp.201.1580149715505;
        Mon, 27 Jan 2020 10:28:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxljkmgJFrEsrK67bdzBVCvvZYAffQfauHWWhtfrHKAHuMm7FaRUGU2gtvbM7bw0rJ21gT52A==
X-Received: by 2002:adf:f802:: with SMTP id s2mr24664178wrp.201.1580149715279;
        Mon, 27 Jan 2020 10:28:35 -0800 (PST)
Received: from steredhat ([80.188.125.198])
        by smtp.gmail.com with ESMTPSA id t10sm10472778wmi.40.2020.01.27.10.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 10:28:34 -0800 (PST)
Date:   Mon, 27 Jan 2020 19:28:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH liburing 0/1] test: add epoll test case
Message-ID: <20200127182832.hashyy6wi75ca4cg@steredhat>
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <d409ad33-2122-9500-51f4-37e9748f1d73@kernel.dk>
 <20200127180028.f7s5xhhizii3dsnr@steredhat>
 <52df8d77-1cb4-b8d5-d03d-5a8cabaeddb6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52df8d77-1cb4-b8d5-d03d-5a8cabaeddb6@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 27, 2020 at 11:07:41AM -0700, Jens Axboe wrote:
> On 1/27/20 11:00 AM, Stefano Garzarella wrote:
> > On Mon, Jan 27, 2020 at 09:26:41AM -0700, Jens Axboe wrote:
> >> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
> >>> Hi Jens,
> >>> I wrote the test case for epoll.
> >>>
> >>> Since it fails also without sqpoll (Linux 5.4.13-201.fc31.x86_64),
> >>> can you take a look to understand if the test is wrong?
> >>>
> >>> Tomorrow I'll travel, but on Wednesday I'll try this test with the patch
> >>> that I sent and also with the upstream kernel.
> >>
> >> I'll take a look, but your patches are coming through garbled and don't
> >> apply.
> > 
> > Weird, I'm using git-publish as usual. I tried to download the patch
> > received from the ML, and I tried to reapply and it seams to work here.
> > 
> > Which kind of issue do you have? (just to fix my setup)
> 
> First I grabbed it from email, and I get the usual =3D (instead of =)
> and =20 instead of a space. Longer lines also broken up, with an = at
> the end.
> 
> Then I grabbed it from the lore io-uring archive, but it was the exact
> same thing.

I saw! I'll try to fix my setup.
The strange thing is that my git (v2.24.1) is able to apply that
malformed patch!

> 
> > Anyway I pushed my tree here:
> >     https://github.com/stefano-garzarella/liburing.git epoll
> 
> As per other email, I think you're having some coordination issues
> with the reaping and submitting side being separated. If the reaper
> isn't keeping up, you'll get the -EBUSY problem I saw. I'm assuming
> that's the failure case you are also seeing, you didn't actually
> mention how it fails for you?

My fault, I sent more information on the issue that I'm seeing.

Thanks,
Stefano

