Return-Path: <io-uring+bounces-9656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28571B49A48
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 21:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C9037B3209
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 19:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5466F2D3728;
	Mon,  8 Sep 2025 19:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Iyhhjxru"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3082D3231
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 19:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757360775; cv=none; b=bTzug5uKIkr7ZNOrczU1BWcofFFvoZx70tmpe+R0ZhRimhq5mpKQIOZ00Xvvpr02jaOVhzpwFmCHj00arxlyEOw4Wafeo94j5crQE+oDo/x9MY2uLwiIlQ24ekBjmco+jpNM9QOWjfRAGGZ45gaUqdD3yBqRAQVStWL/ETnb7Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757360775; c=relaxed/simple;
	bh=N69wDxrbi+fA5VqgbL8Sr7yDr1PhsL3cbCP913A1f0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6yzDV/xvCU2XsmvnfpMEYtUE0jILjZamxb/QP9E4zPx7loiIqqoUXIf9efXpk5uHGyD6RN7wgL+YJOITJ+CUooCyq0KIpH6RTJZTA6ghrcww2m9wExKo0lhztUYcxCjA9um30/MU2gxTPB/kwReChiVibqK2Wto6+71P5imQJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Iyhhjxru; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24498e93b8fso9515125ad.3
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 12:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757360772; x=1757965572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9driASAEmFmP3jFlHoCR+IRYlP6CAxxYklIzPlsusQ=;
        b=IyhhjxruxKzJWbDDF1uPQYyOYpyBbRogMc7Xmaq/yzTx/IYvzwP10Fztit3G92ei6O
         dMSBh6IUFlNR6giw8b46vpPvHP2V4DCr1UabeIECOSlYTxGoc4gFp0aFfwNjKDWY60EM
         v+idKqwvOGVoSldGmyXUC2TTLl6/Soh4G/9bE4gJkfl6J3doYVmHjWxdVR0XuiDnk9N+
         PXynUHPlkMhOmMSdsosunN35cDI63PtlrrFnJaFHSPgOQlMqL3vKyU/XZNd0bJYsFGrJ
         LqpK72SZN60+wByjeYDn3tO7hhpD+kNBpD1uEX6WdqcY8ZfRUxXQqdgEGRpPWfGu6mFc
         LOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757360772; x=1757965572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9driASAEmFmP3jFlHoCR+IRYlP6CAxxYklIzPlsusQ=;
        b=CEtlEsREoK4evsSs48OGfZIe3DLtLXjtoAHzws08VW3Z4tjEWB5jRH3m+4g+pvlZyM
         o0JvEWok16jphs1IBwxvUW4fvY8f5kShpqTjVvQ8HoQLXec7jEPrnOsteiD8UB6LNDtD
         II9MuVeU9GiIlGmofNPkEi4AHRW4SC3cz6bghHNcQMSGS58ioTusuVLWwe3o/O/X68gY
         i/BG77wsACznW/cqdOTQaxOQxk/4igRwggCl9R5AJ9/dXDpip0ATa6aSjATRYUb51tKp
         orUJpog3HYay+/VlOpXTMKTmJHQnMmZiadoEpUQBRuK9mCCj3goyzF5mOQwPLob6Cf22
         bDQg==
X-Forwarded-Encrypted: i=1; AJvYcCXO7ma/7sdMkAKdjsTIuhtP9Nbd0nfaaz5WYeMrW3/txNbysTZl/e40bhW9yW+VehPGjg7TpDf0wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/qKZZQ6URSJIKpM0nGfVaKyx5c4WNzOHYT0VGCHcPtuxoDX1k
	5s+X0mp2CKOujmIM/cfl8qF3wl9Q5pHONUIk+klBU2H1XH9vtl/9yKcUf2de++83CCXLqixbY+e
	Sg2t1J4h/fMs9iP3LoDV4zqfYmksoV/D9v4c4J3mEZQ==
X-Gm-Gg: ASbGncs90pAAs1rO3elBKF6x+/dzQl+VnQR5YxBSCaO0Ok/Bi5MNXLAq9xxA30AHe+P
	hYepXzWOLViyKWovxLLycyLvTgtLdgI8O5fIa1fRX5Xv0lzHCIdPa+TIZNHXSXOaQs3zwcfGPsK
	QgQtmZaHeX1ucyLZ63JFxMyD4iPAhRE6mXTFqk0PmTGKP2TPZVTIi57hy6wacUH7G38C50VeE5m
	2OUU113
X-Google-Smtp-Source: AGHT+IGThrKgpaZ2Jb+IxUr+u2cOUabVPTBAwo+RY7tux4h/Zk1WncO4NjXraMuphAlOZPqbrt4I+GCL5BfG+ELw2mM=
X-Received: by 2002:a17:902:f54d:b0:24c:e213:ca4a with SMTP id
 d9443c01a7336-2516ed66d7amr73266655ad.2.1757360771804; Mon, 08 Sep 2025
 12:46:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822125555.8620-1-sidong.yang@furiosa.ai> <20250822125555.8620-3-sidong.yang@furiosa.ai>
 <CADUfDZpsePAbEON_90frzrPCPBt-a=1sW2Q=i8BGS=+tZhudFA@mail.gmail.com>
 <aLbFiChBnTNLBAyV@sidongui-MacBookPro.local> <CADUfDZpPvj3R7kzWC9bQVV0iuCBOnKsNUFn=B3ivf7De5wCB8g@mail.gmail.com>
 <aLxFAamglufhUvq0@sidongui-MacBookPro.local>
In-Reply-To: <aLxFAamglufhUvq0@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 8 Sep 2025 12:45:58 -0700
X-Gm-Features: Ac12FXwNfDS_Qqj870v2sNtiyiKyRUxgf6ydh_1JzHPqlof9837yRmLCR8lKXvE
Message-ID: <CADUfDZruwQyOcAeOXkXMLX+_HgOBeYdHUmgnJdT5pGQEmXt9+g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 6, 2025 at 7:28=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai>=
 wrote:
>
> On Tue, Sep 02, 2025 at 08:31:00AM -0700, Caleb Sander Mateos wrote:
> > On Tue, Sep 2, 2025 at 3:23=E2=80=AFAM Sidong Yang <sidong.yang@furiosa=
.ai> wrote:
> > >
> > > On Mon, Sep 01, 2025 at 05:34:28PM -0700, Caleb Sander Mateos wrote:
> > > > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <sidong.yang@fu=
riosa.ai> wrote:
> > > > >
> > > > > The pdu field in io_uring_cmd may contain stale data when a reque=
st
> > > > > object is recycled from the slab cache. Accessing uninitialized o=
r
> > > > > garbage memory can lead to undefined behavior in users of the pdu=
.
> > > > >
> > > > > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so th=
at
> > > > > each command starts from a well-defined state. This avoids exposi=
ng
> > > > > uninitialized memory and prevents potential misinterpretation of =
data
> > > > > from previous requests.
> > > > >
> > > > > No functional change is intended other than guaranteeing that pdu=
 is
> > > > > always zero-initialized before use.
> > > > >
> > > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > > ---
> > > > >  io_uring/uring_cmd.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > >
> > > > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > > > index 053bac89b6c0..2492525d4e43 100644
> > > > > --- a/io_uring/uring_cmd.c
> > > > > +++ b/io_uring/uring_cmd.c
> > > > > @@ -203,6 +203,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, c=
onst struct io_uring_sqe *sqe)
> > > > >         if (!ac)
> > > > >                 return -ENOMEM;
> > > > >         ioucmd->sqe =3D sqe;
> > > > > +       memset(&ioucmd->pdu, 0, sizeof(ioucmd->pdu));
> > > >
> > > > Adding this overhead to every existing uring_cmd() implementation i=
s
> > > > unfortunate. Could we instead track the initialized/uninitialized
> > > > state by using different types on the Rust side? The io_uring_cmd
> > > > could start as an IoUringCmd, where the PDU field is MaybeUninit,
> > > > write_pdu<T>() could return a new IoUringCmdPdu<T> that guarantees =
the
> > > > PDU has been initialized.
> > >
> > > I've found a flag IORING_URING_CMD_REISSUE that we could initialize
> > > the pdu. In uring_cmd callback, we can fill zero when it's not reissu=
ed.
> > > But I don't know that we could call T::default() in miscdevice. If we
> > > make IoUringCmdPdu<T>, MiscDevice also should be MiscDevice<T>.
> > >
> > > How about assign a byte in pdu for checking initialized? In uring_cmd=
(),
> > > We could set a byte flag that it's not initialized. And we could retu=
rn
> > > error that it's not initialized in read_pdu().
> >
> > Could we do the zero-initialization (or T::default()) in
> > MiscdeviceVTable::uring_cmd() if the IORING_URING_CMD_REISSUE flag
> > isn't set (i.e. on the initial issue)? That way, we avoid any
> > performance penalty for the existing C uring_cmd() implementations.
> > I'm not quite sure what you mean by "assign a byte in pdu for checking
> > initialized".
>
> Sure, we could fill zero when it's the first time uring_cmd called with
> checking the flag. I would remove this commit for next version. I also
> suggests that we would provide the method that read_pdu() and write_pdu()=
.
> In read_pdu() I want to check write_pdu() is called before. So along the
> 20 bytes for pdu, maybe we could use a bytes for the flag that pdu is
> initialized?

Not sure what you mean about "20 bytes for pdu".
It seems like it would be preferable to enforce that write_pdu() has
been called before read_pdu() using the Rust type system instead of a
runtime check. I was thinking a signature like fn write_pdu(cmd:
IoUringCmd, value: T) -> IoUringCmdPdu<T>. Do you feel there's a
reason that wouldn't work and a runtime check would be necessary?

>
> But maybe I would introduce a new struct that has Pin<&mut IoUringCmd> an=
d
> issue_flags. How about some additional field for pdu is initialized like =
below?
>
> struct IoUringCmdArgs {
>   ioucmd: Pin<&mut IoUringCmd>,
>   issue_flags: u32,
>   pdu_initialized: bool,
> }

One other thing I realized is that issue_flags should come from the
*current* context rather than the context the uring_cmd() callback was
called in. For example, if io_uring_cmd_done() is called from task
work context, issue_flags should match the issue_flags passed to the
io_uring_cmd_tw_t callback, not the issue_flags originally passed to
the uring_cmd() callback. So it probably makes more sense to decouple
issue_flags from the (owned) IoUringCmd. I think you could pass it by
reference (&IssueFlags) or with a phantom reference lifetime
(IssueFlags<'_>) to the Rust uring_cmd() and task work callbacks to
ensure it can't be used after those callbacks have returned.

Best,
Caleb

