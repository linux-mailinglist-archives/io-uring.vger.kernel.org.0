Return-Path: <io-uring+bounces-4318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14ECD9B9662
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D440B21ECE
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A93419F436;
	Fri,  1 Nov 2024 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yolU/bEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0831CC165
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730481551; cv=none; b=DlroxDGe0bewu/1jvpxtfggGT+TQPzCV11rhvYHJfzrkezKmGQx7PuBtarT6QY5bowZS2ndbNR5q+8ZTfoplkKtgVERoSY58Hmoq/+D9hTSsZ4kQX96pQlprAIWdeK4c2vPy4twXPhJEeqUp9dy0lBjg9cSKfv0npeREcK/f5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730481551; c=relaxed/simple;
	bh=Zh6j3zmRmKe7vpC9G9BBZG8+LTIT2DyWZG+8W9fB31A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mAj8NXcEktcGGgir6kKj3Ye5HmfOspK8+RKkN7/uqIe0JJdC5E9CnVOLOziLS6Oa3anx8PQXGc1lJZyx7pucYUu4Y2Xu6HSR7c5K/aynD71tiJBpWoBPH9xQLIAakUDg6ktQsbkrEPjnJE/LMRHRbIPQRxQcU3E7e92TBszl8f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yolU/bEW; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539e19d8c41so1604e87.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 10:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730481548; x=1731086348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qo/2YMOHMwTPuGWCnXenZjfRFbrGoozDJ26yYfohd/0=;
        b=yolU/bEWTOXO6/wWg8dia+1wYoCkXy8xNik1M7LYy73v6Ye1EUKCcJJO/RzzJ1HHwD
         fYhj+gxYLpw3OK3RwkpRMH+tHKdcPfEV4tDOS9229myJatOfjd8GSapwsmpXhMzc/AOx
         CJ6asBtsAOdkBl1gba4o0/eWGVwdvnY1+Vot+t1Upat4QXmslmZtzsAJUCD+yTITWJXy
         Y3+VqsrnvcJd/vUK6CkTrP6EAu1op2H7sadk0hBKb7000CIYbCSCDUbuwOxpJT6aoyEO
         Ox3KIR2hQi57m1oCoBNbpmcwLXlBY00tQ21pEdcG0g80l8Lchldra1Gau+q8zYWtJFz/
         ZHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730481548; x=1731086348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qo/2YMOHMwTPuGWCnXenZjfRFbrGoozDJ26yYfohd/0=;
        b=QD5hase86g00xZMM0LTnVImxJwYhviQ7eG6nVA2zxPeGT7dPeQkFD/GzIMS2gqRFro
         +QevJRaHZrn1pRNXRnvyTWwIgY+PrCNAxhpn4hyao1Jp2et98wjta/7jm7cUvJ76T5co
         koNsF7CPG44EQDTGf8dCmpRxeB9sIb6FeK5jQ6vbad+KKNSnUtmVUvcQ4vsUhjWLeZlI
         BrVLsMWp2/1EFx1p0nmQNplgH7vmZTC9Bz/zMy+QKW1QPtJgqqGCCzHUmolIv8KAyv+w
         WA9KjJMdmNd529+KJLT8phl/gGQ1SFPqOn+jCeLKhZ21X+a6yJupScsRaEKOKenL6C8F
         WIgw==
X-Forwarded-Encrypted: i=1; AJvYcCU97qAbcRk1zMNQt93z5fVCZCdYrV9nD+G2qFHP/3C5SBYfn71mPi7EXodCLKhYkF7XoqFuRHjjQg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe6+0sPk6MBcaySwZEM9zCKfilkTE7Wca+Jd1kl4QNhXuI70gJ
	blhjDpcyRbgvftprz2Tk3p/o0QSrJf9V695YfEQMyIusHL/V5bqX0gy/NUE/saCJUrEgLdf5KSK
	APQVCSkBBsSExsmsjv63S1WrlrHgPP7ncH1QxBJ+8qdrqAJSzAGvp
X-Gm-Gg: ASbGncueFXzuoILTJPyxbcuBOActUbGwjHfwcuM67ClISjGVO9QX2C5gNRNspSJfdgO
	nI20ogJ2cEzIyzJ1SMH0e/iHiUc+KlCVZ6K5oKM3MgWxVA3ODdNd/HQYKAZ5+hg==
X-Google-Smtp-Source: AGHT+IGPWCrNF9e9S4qb8Uu0LyJZ3I95IZhRugf+DI0dHUdTrVLjFXj5MYjXBD6A3dXD1LmYrZBRsfamFy01Y/yjQF4=
X-Received: by 2002:ac2:46d0:0:b0:52e:934c:1cc0 with SMTP id
 2adb3069b0e04-53c7bb91201mr595151e87.7.1730481547380; Fri, 01 Nov 2024
 10:19:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-7-dw@davidwei.uk>
 <CAHS8izPFp_Q1OngcwZDQeo=YD+nnA9vyVqhuaT--+uREEkfujQ@mail.gmail.com>
 <9f1897b3-0cea-4822-8e33-a4cab278b2ac@gmail.com> <CAHS8izOxsLc82jX=b3cwEctASerQabKR=Kqqio2Rs7hVkDHL4A@mail.gmail.com>
 <5d7925ed-91bf-4c78-8b70-598ae9ab3885@davidwei.uk> <CAHS8izNt8pfBwGnRNWphN4vJJ=1yJX=++-RmGVHrVOvy59=13Q@mail.gmail.com>
 <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com>
In-Reply-To: <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 10:18:54 -0700
Message-ID: <CAHS8izNXOSGCAT6zvwTOpW7uomuA5L7EwuVD75gyeh2pmqyE2w@mail.gmail.com>
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2024 at 10:42=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 10/14/24 23:58, Mina Almasry wrote:
> > On Sun, Oct 13, 2024 at 8:25=E2=80=AFPM David Wei <dw@davidwei.uk> wrot=
e:
> >>
> >> On 2024-10-10 10:54, Mina Almasry wrote:
> >>> On Wed, Oct 9, 2024 at 2:58=E2=80=AFPM Pavel Begunkov <asml.silence@g=
mail.com> wrote:
> >>>>
> >>>> On 10/9/24 22:00, Mina Almasry wrote:
> >>>>> On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> w=
rote:
> >>>>>>
> >>>>>> From: Pavel Begunkov <asml.silence@gmail.com>
> >>>>>>
> >>>>>> page pool is now waiting for all ppiovs to return before destroyin=
g
> >>>>>> itself, and for that to happen the memory provider might need to p=
ush
> >>>>>> some buffers, flush caches and so on.
> >>>>>>
> >>>>>> todo: we'll try to get by without it before the final release
> >>>>>>
> >>>>>
> >>>>> Is the intention to drop this todo and stick with this patch, or to
> >>>>> move ahead with this patch?
> >>>>
> >>>> Heh, I overlooked this todo. The plan is to actually leave it
> >>>> as is, it's by far the simplest way and doesn't really gets
> >>>> into anyone's way as it's a slow path.
> >>>>
> >>>>> To be honest, I think I read in a follow up patch that you want to
> >>>>> unref all the memory on page_pool_destory, which is not how the
> >>>>> page_pool is used today. Tdoay page_pool_destroy does not reclaim
> >>>>> memory. Changing that may be OK.
> >>>>
> >>>> It doesn't because it can't (not breaking anything), which is a
> >>>> problem as the page pool might never get destroyed. io_uring
> >>>> doesn't change that, a buffer can't be reclaimed while anything
> >>>> in the kernel stack holds it. It's only when it's given to the
> >>>> user we can force it back out of there.
> >>
> >> The page pool will definitely be destroyed, the call to
> >> netdev_rx_queue_restart() with mp_ops/mp_priv set to null and netdev
> >> core will ensure that.
> >>
> >>>>
> >>>> And it has to happen one way or another, we can't trust the
> >>>> user to put buffers back, it's just devmem does that by temporarily
> >>>> attaching the lifetime of such buffers to a socket.
> >>>>
> >>>
> >>> (noob question) does io_uring not have a socket equivalent that you
> >>> can tie the lifetime of the buffers to? I'm thinking there must be
>
> You can say it is bound to io_uring / io_uring's object
> representing the queue.
>
> >>> one, because in your patches IIRC you have the fill queues and the
> >>> memory you bind from the userspace, there should be something that
> >>> tells you that the userspace has exited/crashed and it's time to now
> >>> destroy the fill queue and unbind the memory, right?
> >>>
> >>> I'm thinking you may want to bind the lifetime of the buffers to that=
,
> >>> instead of the lifetime of the pool. The pool will not be destroyed
> >>> until the next driver/reset reconfiguration happens, right? That coul=
d
> >>> be long long after the userspace has stopped using the memory.
>
> io_uring will reset the queue if it dies / requested to release
> the queue.
>
> >> Yes, there are io_uring objects e.g. interface queue that hold
> >> everything together. IIRC page pool destroy doesn't unref but it waits
> >> for all pages that are handed out to skbs to be returned. So for us,
> >> below might work:
> >>
> >> 1. Call netdev_rx_queue_restart() which allocates a new pp for the rx
> >>     queue and tries to free the old pp
> >> 2. At this point we're guaranteed that any packets hitting this rx que=
ue
> >>     will not go to user pages from our memory provider
>
> It's reasonable to assume that the driver will start destroying
> the page pool, but I wouldn't rely on it when it comes to the
> kernel state correctness, i.e. not crashing the kernel. It's a bit
> fragile, drivers always tend to do all kinds of interesting stuff,
> I'd rather deal with a loud io_uring / page pool leak in case of
> some weirdness. And that means we can't really guarantee the above
> and need to care about not racing with allocations.
>
> >> 3. Assume userspace is gone (either crash or gracefully terminating),
> >>     unref the uref for all pages, same as what scrub() is doing today
> >> 4. Any pages that are still in skb frags will get freed when the socke=
ts
> >>     etc are closed
>
> And we need to prevent from requests receiving netmem that are
> already pushed to sockets.
>
> >> 5. Rely on the pp delay release to eventually terminate and clean up
> >>
> >> Let me know what you think Pavel.
>
> I think it's reasonable to leave it as is for now, I don't believe
> anyone cares much about a simple slow path memory provider-only
> callback. And we can always kill it later on if we find a good way
> to synchronise pieces, which will be more apparent when we add some
> more registration dynamism on top, when/if this patchset is merged.
>
> In short, let's resend the series with the callback, see if
> maintainers have a strong opinion, and otherwise I'd say it
> should be fine as is.
>
> > Something roughly along those lines sounds more reasonable to me.
> >
> > The critical point is as I said above, if you free the memory only
> > when the pp is destroyed, then the memory lives from 1 io_uring ZC
> > instance to the next. The next instance will see a reduced address
> > space because the previously destroyed io_uring ZC connection did not
> > free the memory. You could have users in production opening thousands
> > of io_uring ZC connections between rxq resets, and not cleaning up
> > those connections. In that case I think eventually they'll run out of
> > memory as the memory leaks until it's cleaned up with a pp destroy
> > (driver reset?).
>
> Not sure what giving memory from one io_uring zc instance to
> another means. And it's perfectly valid to receive a buffer, close
> the socket and only after use the data, it logically belongs to
> the user, not the socket. It's only bound to io_uring zcrx/queue
> object for clean up purposes if io_uring goes down, it's different
> from devmem TCP.
>

(responding here because I'm looking at the latest iteration after
vacation, but the discussion is here)

Huh, interesting. For devmem TCP we bind a region of memory to the
queue once, and after that we can create N connections all reusing the
same memory region. Is that not the case for io_uring? There are no
docs or selftest with the series to show sample code using this, but
the cover letter mentions that RSS + flow steering needs to be
configured for io ZC to work. The configuration of flow steering
implies that the user is responsible for initiating the connection. If
the user is initiating 1 connection then they can initiate many
without reconfiguring the memory binding, right?

When the user initiates the second connection, any pages not cleaned
up from the previous connection (because we're waiting for the scrub
callback to be hit), will be occupied when they should not be, right?

--
Thanks,
Mina

