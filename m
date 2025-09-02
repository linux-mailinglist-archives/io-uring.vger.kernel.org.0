Return-Path: <io-uring+bounces-9537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F6AB408F6
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 17:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8ED81B27270
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 15:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0C82E092A;
	Tue,  2 Sep 2025 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Pe+im1Di"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B690D2DF14C
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827076; cv=none; b=myV4a4PuSu0UgXy3DSh3yS73bJxJfS+eKQr6SExxNhrCFgQKDMd5jipoIhikq/uIbgC07ShI4aewNh0DUZefCM1nwQX6NxKhre8LQul3UrKi/e2OZdiIWx0+xhWnKBhrrptITfid7pJGR+yQZSOO1d4tOieoaqcWVWbTHOg9Giw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827076; c=relaxed/simple;
	bh=jBj+N/EIx366pIxKlDVWGntYHrjdw8xEwfU0BWbWz4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TYMP9fEiV1/0o7OyhRaHoo+0W5P7IrPHxvvhigeoDBQi+JOZDpYoUTaVb+3IcqjNu25fiS64VH8CG+TfjL/pVM7o+F4mlUlnqvl4rSvRR5arIIicN2gfkf2XQc9MfNVYyg9j2e1i4x35kzxfQxX3tURu67QNUYH8jkAfg1GSITI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Pe+im1Di; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61d2c26963cso427125a12.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 08:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756827073; x=1757431873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcK0Vupw08S0kwUSmWzaPvW7Lg7imOqYDDKVTQ4jI1I=;
        b=Pe+im1DiWe7i/uYAhCn57MA78AE5pdkV/T5W8CNyYznFF4lM2iTebm/fPCo8TU3wJD
         cRz6Bpm4/7qhZQMnb4qJzF6fSVjMvriJ/eCh9WTLC+yLuYFRb4p6fqEU/WTdhJRsT42P
         5L91y+bcK6phuQUqVvznNwdqPMzoCBiO+S/VqP5ojBX7SzHJJc6Yk11e5dniwU3Eh/xe
         3M/m0//Cz3uFKVACs8b+xJegRHtC2kpJMmllnwRNutQCR+afAaINirmwvr5S68OmybPt
         L+7oxiFsLLltM/xEsakBO7F3Ez7bu2Shtlo3SWuJz+BPsW1PqAjJhyMGqIPPNK8H4GM3
         HRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756827073; x=1757431873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcK0Vupw08S0kwUSmWzaPvW7Lg7imOqYDDKVTQ4jI1I=;
        b=B2fUp/SecqOhrzQcvCmbOTjT1f4V8AOfSpRb75lFit6eHijAebLKuOZ/d/kG+mRPSK
         JYTvYtYu9grJ0IiBNEZfZEZnxO230bnaJYwHQOT2zbD8ztpJWSLh/JsoA9rnqogfWkbp
         zS72KfNIId9n167ObYy6rgokw45VI/L2F4fiWJPLg5DtcE+Km6QlRXNXuskDTihprWds
         eUCyy2wXyzt0D+nbGg6hVlEoXU4G+cgq2qIU46MoY+A7rRDoVzRq32JRh3H8D+4ZXND8
         y35kja8thAqdecbbrFVMJSKrFXQeKYXWa8FLAL+xZkF9TTAG3tgRs4HRwdVGmCWoGWhM
         n9Bg==
X-Forwarded-Encrypted: i=1; AJvYcCXjPRp7aCFgjeuvhYsMf9IvQV4t59+qsTq93ry00UgOMKeQ+edBzlkh3QKO6eqnvJg71IaGU8bmdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFUB6sR0i04IeJXQjuXt2fKQePxBhe8rL89xeJZGC+/mKFLGaX
	iqWqrVKfA+hj0WinV1ANr7LxRo5n1nEH8fSrx5fXvmBq77RCS03clyxjWPwMuE9fQ2tI/rfvQDi
	QOMq1ilsUFy0k2br43u506+Q6QKY9PsHuJxZ9hJpXUQ==
X-Gm-Gg: ASbGncu6txQDsbnrbEAvJMMBGND1zC1idbVHB02TQI56C//2HcYXixLR0Z8v7TVPLID
	YX4+1HXUpHEit5jcGGT2D0ihsE9ChLjkR+9eGsm1zh7+TMKQX9hgGz1DTNLOEbZv4xX8odbAQBA
	Yhg8ZAvvrdiZR8OvTzvmpwAXwagVVn3CSqCiNqPz9O+lBOs9ddsZXrO5G+xHI45Yg9qdlIOywdy
	3Upce4shZVyr/C+IP2/7aw=
X-Google-Smtp-Source: AGHT+IHfeh6Hqg2wuUr1T9ZIp5X19Sz1uiwreq0YZoqgSSMikAA7y1UBWPbvIhSjDISnUiui2xuROLxBU38/us5t+3Q=
X-Received: by 2002:a05:6402:35c5:b0:61c:879f:a62 with SMTP id
 4fb4d7f45d1cf-61d0d371418mr6643108a12.3.1756827072932; Tue, 02 Sep 2025
 08:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822125555.8620-1-sidong.yang@furiosa.ai> <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com> <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
In-Reply-To: <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 2 Sep 2025 08:31:00 -0700
X-Gm-Features: Ac12FXyLeKYXslC_9H_jnXi5qlR1DyFMS0jUeRzwyKLc83sHnrpgjFW25z8GvmY
Message-ID: <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 3:23=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai>=
 wrote:
>
> On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <sidong.yang@furios=
a.ai> wrote:
> > >
> > > The pdu field in io_uring_cmd may contain stale data when a request
> > > object is recycled from the slab cache. Accessing uninitialized or
> > > garbage memory can lead to undefined behavior in users of the pdu.
> > >
> > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > > each command starts from a well-defined state. This avoids exposing
> > > uninitialized memory and prevents potential misinterpretation of data
> > > from previous requests.
> > >
> > > No functional change is intended other than guaranteeing that pdu is
> > > always zero-initialized before use.
> > >
> > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > ---
> > >  io_uring/uring_cmd.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > index 053bac89b6c0..2492525d4e43 100644
> > > --- a/io_uring/uring_cmd.c
> > > +++ b/io_uring/uring_cmd.c
> > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
> > >         if (!ac)
> > >                 return -ENOMEM;
> > >         ioucmd->sqe =3D sqe;
> > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> >
> > Adding this overhead to every existing uring_cmd() implementation is
> > unfortunate. Could we instead track the initialized/uninitialized
> > state by using different types on the Rust side? The io_uring_cmd
> > could start as an IoUringCmd, where the PDU field is MaybeUninit,
> > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees the
> > PDU has been initialized.
>
> I've found a flag IORING_URING_CMD_REISSUE that we could initialize
> the pdu. In uring_cmd callback, we can fill zero when it's not reissued.
> But I don't know that we could call T::default() in miscdevice. If we
> make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
>
> How about assign a byte in pdu for checking initialized? In uring_cmd(),
> We could set a byte flag that it's not initialized. And we could return
> error that it's not initialized in read_pdu().

Could we do the zero-initialization (or T::default()) in
MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
isn't set (i.e. on the initial issue)? That way, we avoid any
performance penalty for the existing C uring_cmd() implementations.
I'm not quite sure what you mean by "assign a byte in pdu for checking
initialized".

Best,
Caleb

