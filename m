Return-Path: <io-uring+bounces-4440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8189BBEEE
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 21:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 004B81F235E2
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 20:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA581F585A;
	Mon,  4 Nov 2024 20:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U8TdI6Q1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C30F1F5855
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 20:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730752971; cv=none; b=WlXvK9XRfzotqZosGzzkXSVzNT9owxDIjHz43Azztq0s+7tksDgUnT3mxXWX1NEZQvhYnDj2zECYDxUojyfQkUZKY3fR5r98XGyM4GsjG8ov4pcfgaxcJ4Ge916rYYJYDMf4fS8Aex8/FEHU+B26GCYOJkTaBbK/YfUwcgU3ijk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730752971; c=relaxed/simple;
	bh=8PmX7RaIvjkEK+PQLtTGT3XGax8uE2k9vKPbrvJsjds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ig5WL4FjI6i4lHoDhqmsKlopnKDKmHuUjGm4qNLmMAl0J7GkfY9zji9a3UKGnjFm0+cr4bFkpNP63XEXDYHC36JWnNvHJldgwkwCIgsadcoFb0o/nY96nbdhwKR/nj2kWAOTsSjJ72GykMx/vt+XFBVTMDyJrnzE9hnj9zg2+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U8TdI6Q1; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-460a8d1a9b7so3581cf.1
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 12:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730752968; x=1731357768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PmX7RaIvjkEK+PQLtTGT3XGax8uE2k9vKPbrvJsjds=;
        b=U8TdI6Q1V6pU5frihgy14y9cc9g9vfJknVu6Eg4GojvnguAhoFkmucHVotqcoqcFvx
         9ZHBwBA+ts1KxQ6UdWuyjAurhpL7eYgzcvFDAcFrBPggbCwCwTnGVBpdScFJPi0Ud8F+
         a5kQvofijlZpyZVGeBaP7jMafzLHlunz76jDR2/A6LqbcOIcbVhlhJ1AGJF6ccodMObo
         soW5Q0ujnEXlGBI7K93++nq/uYlcH+LgZ1QPVOpWwpVDmrmkrPsDHrp9gEmNFuJVachw
         UHPEV+UTy6BAeADU6FPIdolGgGgeFQa8TNoiXmIZdwwltq/VI/4l2AfX2PFc/YgLn1/s
         Kpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730752968; x=1731357768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PmX7RaIvjkEK+PQLtTGT3XGax8uE2k9vKPbrvJsjds=;
        b=DB/n/gsFyAsjVPWLRL+fd0v9LjcU02dG3r2Dvuu1aG3nrsAnVlkdkNPSI5Ns3Pz1Xs
         oYbLwHA+4/Vq61y5gsbcNkWCslJD108PH6fjMC14xXxC82a5KuBL5kcl118zxbFon6WO
         pLMWhbum26Ll8oJ7ufcR7KZbZiYqc2V2AH3WnDgsfwMlgTNIa/zIQxfAFML7i4z8u1F5
         l66IsGToQDGH/XtLSlFrZGIQQsQC7aWhPdirva5SQl79N0lYWHYt6x79Q05aVVYRaDQ+
         IoMVbJ8roj1jWY8YAjfMIeJqa9E5+LUqWhcFL9nayWPMvok2U2d09PTYHPLW6M7goXV0
         SZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUICAdfSu9xPdLAk2jer8zW1xCx1OnotCFyq2O+zUWHcoNJm7v5WwDyq90pRgnUWaoBrBmGXTl3Bg==@vger.kernel.org
X-Gm-Message-State: AOJu0YykGmSG8elBnofyKKF0F7fJjUp6ZoRT/q9xmyxOzrConx/ohc6E
	8HXeMXxXfj6moNPQOrvW2dpl4vBfUz6rNsWgmAGsL3BJ32Tn3dLJ3whC4DR6r1hd4zKTMZebfZ9
	xBD7bbEOfS0x4LxUmRwvIPXPBqOrFj0IhmCaY
X-Gm-Gg: ASbGncv5t6t3Wk60X647A+tQaUyPiRU3sgDhYSF068sMTp5gzEUtBoW5yPa/hbxCsh8
	jShRvBdSKIXzwTHvcyIR/r9bvNYQQxzpV2iXpF6p7Cl1u6dxzlrUS5Fe0EhMGZQ==
X-Google-Smtp-Source: AGHT+IF8KEUvR6ShAUb62i2/hqb5tzvwP5sN5/CtADH1jCZKF0LNCkaZFCUAEApze4pgZOCwJIvye90AtkCSSZu6lIQ=
X-Received: by 2002:ac8:5884:0:b0:461:6b1a:26ae with SMTP id
 d75a77b69052e-462e50c958emr761261cf.29.1730752968300; Mon, 04 Nov 2024
 12:42:48 -0800 (PST)
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
 <6acf95a6-2ddc-4eee-a6e1-257ac8d41285@gmail.com> <CAHS8izNXOSGCAT6zvwTOpW7uomuA5L7EwuVD75gyeh2pmqyE2w@mail.gmail.com>
 <58046d4d-4dff-42c2-ae89-a69c2b43e295@gmail.com> <CAHS8izO6aBdHkN5QF8Z57qGwop3+XObd5T6P8VnMdyT=FUDO1A@mail.gmail.com>
 <2771e23a-2f4b-43c7-9d2a-3fa6aad26d53@gmail.com>
In-Reply-To: <2771e23a-2f4b-43c7-9d2a-3fa6aad26d53@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 4 Nov 2024 12:42:36 -0800
Message-ID: <CAHS8izNvrUx1cEFFAEdY-AsrVh3ttX6WtAc9NHEXfyw3bKBnDg@mail.gmail.com>
Subject: Re: [PATCH v1 06/15] net: page_pool: add ->scrub mem provider callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 2:38=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> On 11/1/24 19:24, Mina Almasry wrote:
> > On Fri, Nov 1, 2024 at 11:34=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> ...
> >>> Huh, interesting. For devmem TCP we bind a region of memory to the
> >>> queue once, and after that we can create N connections all reusing th=
e
> >>> same memory region. Is that not the case for io_uring? There are no
> >>
> >> Hmm, I think we already discussed the same question before. Yes, it
> >> does indeed support arbitrary number of connections. For what I was
> >> saying above, the devmem TCP analogy would be attaching buffers to the
> >> netlink socket instead of a tcp socket (that new xarray you added) whe=
n
> >> you give it to user space. Then, you can close the connection after a
> >> receive and the buffer you've got would still be alive.
> >>
> >
> > Ah, I see. You're making a tradeoff here. You leave the buffers alive
> > after each connection so the userspace can still use them if it wishes
> > but they are of course unavailable for other connections.
> >
> > But in our case (and I'm guessing yours) the process that will set up
> > the io_uring memory provider/RSS/flow steering will be a different
> > process from the one that sends/receive data, no? Because the former
> > requires CAP_NET_ADMIN privileges while the latter will not. If they
> > are 2 different processes, what happens when the latter process doing
> > the send/receive crashes? Does the memory stay unavailable until the
> > CAP_NET_ADMIN process exits? Wouldn't it be better to tie the lifetime
> > of the buffers of the connection? Sure, the buffers will become
>
> That's the tradeoff google is willing to do in the framework,
> which is fine, but it's not without cost, e.g. you need to
> store/erase into the xarray, and it's a design choice in other
> aspects, like you can't release the page pool if the socket you
> got a buffer from is still alive but the net_iov hasn't been
> returned.
>
> > unavailable after the connection is closed, but at least you don't
> > 'leak' memory on send/receive process crashes.
> >
> > Unless of course you're saying that only CAP_NET_ADMIN processes will
>
> The user can pass io_uring instance itself
>

Thanks, but sorry, my point still stands. If the CAP_NET_ADMIN passes
the io_uring instance to the process doing the send/receive, then the
latter process crashes, do the io_uring netmems leak until the
page_pool is destroyed? Or are they cleaned up because the io_uring
instance is destroyed with the process crashing, and the io_uring will
destroy the page_pool on exit?

--=20
Thanks,
Mina

