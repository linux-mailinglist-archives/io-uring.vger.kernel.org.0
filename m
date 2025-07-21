Return-Path: <io-uring+bounces-8761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A2FB0C735
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 17:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 626F27A336F
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 15:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AB42D8793;
	Mon, 21 Jul 2025 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HUW1xVUy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4B2DCC13
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753110286; cv=none; b=ty6trXSlNmfR1mBYfMVQV0Z/XRAg50YGriXz0QyJnEhutMsWCTfIpaAXLNDScckd0OOUZ1In3E4yZxfKwj0VBOwb+Eb3R3z3UFoQH7zi6kkJKPnUjQw2IqC5sel/wPTHkgBgooMi4t4IIPjyA2t8ORYBZR81uzMukEQykRSdv90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753110286; c=relaxed/simple;
	bh=tixhAVTruGjhh6AyMaRqhcxAHi0cSVcz3tj+sg7Q/tY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eGkQyCV/2xENwiapWvdPuv1hw/dD4xnByC4Ioua4r3XyOiHGAcIx3rUAae6hldmYcCVpLEnhV5mf1o20IGBv7EY9ceJ9tOg15PMn3OUtcxBqm5zqJX0HmShVk9767UwnbCW3uVnTw0qzyPpPV6fmgti0WDUjDx0mud23KIQhjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HUW1xVUy; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-235ef29524fso8380175ad.1
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 08:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1753110284; x=1753715084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UeaBSMK627UpClfBs39gvk2M76/e+MwuexRd0FIWTo=;
        b=HUW1xVUyF9ADTZKmyZ1+TPcThk2okDNaocY0WkWSKaW42GVGrgWOxnv/5e6CSrJpTs
         jzRp3APvPGE5Qkbhx7I8V1O52jf5bTP35zy5oj3TP2FqFUDgVob95b/69nWh1qTCjI/H
         aAOhiV56W4uWuqoudNp7QVlTF9AHbNkFAny/EK4VA1d/HJwtWW95RE72C99mHhR5g+tW
         sQ3XaHWoqTC0FSFU2PH+FlLUrSN774sTyD/RyK8EwQ7g/YYKwmoRh6DsPxIH3OQoaL0j
         CM6JTNeplMxSBXyXTEW62dB6H7zqNF8mZgLlk8CquiW6hrd2yCWKmcPLYp6yD4qALvfr
         DI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753110284; x=1753715084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UeaBSMK627UpClfBs39gvk2M76/e+MwuexRd0FIWTo=;
        b=DNw3f/ws9uB1kogII+SQa+/QsXedN2P030sgINpJITTVTyM2j2rKO1mZZGapanPVuy
         0f6Wz57HILhZrKCKPJeslB0dexBWiOAz6bFPY4GTQndrlxkUrlHemy4MvA28rWixkao2
         0Ey9eP/icjssVx+fDD49etpS4Mngbhgn1xsT4dvfh0OdIVRM2yHf+54JL6caGBUCOTaC
         a5XRayLpaQo78op6qAlYk0klWEz50/FbAbIsfNUuQtAnIJSzYoJnVM/E8SF3gNEIKtQ5
         FB2VCNZo54uJDtzOIrbnTyB2sC3GvQQS147vDtn9QtyDbFSv6SsG6/aMPpNCM7uSSmyS
         qW/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrF/+chC/T4U27LOLcgQC7t9I5CZwnySQzOZIgYVDieq4hx1ZS1RlMNNyoZGxti+YTuNc8UpoKgw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yym3y9X3bBurGja5OvRB4cxd0wSK1LZaJxS/yOR/EAyOWpY1AFw
	lDjH6sp/jgssI7Y7CJhNqCKmbmp5lsmM+dH4dUofoc08ITwjJzgAx1Dm9pfb5MQAKSdUptcMF6H
	uMCWbEwcAr7B0m+vdQ/gXj1nUMFuMy1afsjhHjqo6qw==
X-Gm-Gg: ASbGncuRd5Tpy/GKAx7JpvgKlEucabrG96E0uQOxh4XjbZya4mcImYDsQQ0tKHROdUT
	N0Ws8DmkzvVssy2QQmO3lWO0S1W84jwQFZIagC3C4MRAAzuu5TIErLi7k7CorI1BxE7hR91bcCU
	wj6pYtWQb19NUxMnsXXsGnrDpWU1yOr2rm1v9uAbv7Uu34aCNeynlQZJuiWlQZ/6mPFY7iyZ9av
	5+BCxhj
X-Google-Smtp-Source: AGHT+IGQMsgTs+h38VNGeRp4OBs+iEwP7qVfnWaLEldl4Pisqq0+Oumy4EvlY7bd6zpZuTRjL+n+yLcQ2tpBpDLshOQ=
X-Received: by 2002:a17:903:2341:b0:235:ee04:dd2e with SMTP id
 d9443c01a7336-23e24f8ba34mr122336685ad.10.1753110284195; Mon, 21 Jul 2025
 08:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai> <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
In-Reply-To: <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 21 Jul 2025 11:04:31 -0400
X-Gm-Features: Ac12FXyA6cLU8jmVhtv4LQWdrgKU4vzK4eqWcW4K2Iw9UXja1c9Q4CXydQeOCro
Message-ID: <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 1:23=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> On Sun, Jul 20, 2025 at 03:10:28PM -0400, Caleb Sander Mateos wrote:
> > On Sat, Jul 19, 2025 at 10:34=E2=80=AFAM Sidong Yang <sidong.yang@furio=
sa.ai> wrote:
> > >
> > > This patch introduces rust abstraction for io-uring sqe, cmd. IoUring=
Sqe
> > > abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
> > > abstraction for io_uring_cmd. From this, user can get cmd_op, flags,
> > > pdu and also sqe.
> > >
> > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > ---
> > >  rust/kernel/io_uring.rs | 114 ++++++++++++++++++++++++++++++++++++++=
++
> > >  rust/kernel/lib.rs      |   1 +
> > >  2 files changed, 115 insertions(+)
> > >  create mode 100644 rust/kernel/io_uring.rs
> > >
> > > diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> > > new file mode 100644
> > > index 000000000000..7843effbedb4
> > > --- /dev/null
> > > +++ b/rust/kernel/io_uring.rs
> > > @@ -0,0 +1,114 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +// Copyright (C) 2025 Furiosa AI.
> > > +
> > > +//! Files and file descriptors.
> > > +//!
> > > +//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linu=
x/io_uring/cmd.h) and
> > > +//! [`include/linux/file.h`](srctree/include/linux/file.h)
> > > +
> > > +use core::mem::MaybeUninit;
> > > +
> > > +use crate::{fs::File, types::Opaque};
> > > +
> > > +pub mod flags {
> > > +    pub const COMPLETE_DEFER: i32 =3D bindings::io_uring_cmd_flags_I=
O_URING_F_COMPLETE_DEFER;
> > > +    pub const UNLOCKED: i32 =3D bindings::io_uring_cmd_flags_IO_URIN=
G_F_UNLOCKED;
> > > +
> > > +    pub const MULTISHOT: i32 =3D bindings::io_uring_cmd_flags_IO_URI=
NG_F_MULTISHOT;
> > > +    pub const IOWQ: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_=
IOWQ;
> > > +    pub const NONBLOCK: i32 =3D bindings::io_uring_cmd_flags_IO_URIN=
G_F_NONBLOCK;
> > > +
> > > +    pub const SQE128: i32 =3D bindings::io_uring_cmd_flags_IO_URING_=
F_SQE128;
> > > +    pub const CQE32: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F=
_CQE32;
> > > +    pub const IOPOLL: i32 =3D bindings::io_uring_cmd_flags_IO_URING_=
F_IOPOLL;
> > > +
> > > +    pub const CANCEL: i32 =3D bindings::io_uring_cmd_flags_IO_URING_=
F_CANCEL;
> > > +    pub const COMPAT: i32 =3D bindings::io_uring_cmd_flags_IO_URING_=
F_COMPAT;
> > > +    pub const TASK_DEAD: i32 =3D bindings::io_uring_cmd_flags_IO_URI=
NG_F_TASK_DEAD;
> > > +}
> > > +
> > > +#[repr(transparent)]
> > > +pub struct IoUringCmd {
> > > +    inner: Opaque<bindings::io_uring_cmd>,
> > > +}
> > > +
> > > +impl IoUringCmd {
> > > +    /// Returns the cmd_op with associated with the io_uring_cmd.
> > > +    #[inline]
> > > +    pub fn cmd_op(&self) -> u32 {
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        unsafe { (*self.inner.get()).cmd_op }
> > > +    }
> > > +
> > > +    /// Returns the flags with associated with the io_uring_cmd.
> > > +    #[inline]
> > > +    pub fn flags(&self) -> u32 {
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        unsafe { (*self.inner.get()).flags }
> > > +    }
> > > +
> > > +    /// Returns the ref pdu for free use.
> > > +    #[inline]
> > > +    pub fn pdu(&mut self) -> MaybeUninit<&mut [u8; 32]> {
> >
> > Should be &mut MaybeUninit, right? It's the bytes that may be
> > uninitialized, not the reference.
>
> Yes, it should be &mut MaybeUninit.
> >
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        unsafe { MaybeUninit::new(&mut (*self.inner.get()).pdu) }
> > > +    }
> > > +
> > > +    /// Constructs a new `struct io_uring_cmd` wrapper from a file d=
escriptor.
> >
> > Why "from a file descriptor"?
> >
> > Also, missing a comment documenting the safety preconditions?
>
> Yes, it's a mistake in comment and also ptr should be NonNull.
> >
> > > +    #[inline]
> > > +    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_cmd) -=
> &'a IoUringCmd {
> >
> > Could take NonNull instead of a raw pointer.
> >
> > > +        // SAFETY: The caller guarantees that the pointer is not dan=
gling and stays valid for the
> > > +        // duration of 'a. The cast is okay because `File` is `repr(=
transparent)`.
> >
> > "File" -> "IoUringCmd"?
> >
> > > +        unsafe { &*ptr.cast() }
> > > +    }
> > > +
> > > +    // Returns the file that referenced by uring cmd self.
> >
> > I had a hard time parsing this comment. How about "Returns a reference
> > to the uring cmd's file object"?
>
> Agreed. thanks.
> >
> > > +    #[inline]
> > > +    pub fn file<'a>(&'a self) -> &'a File {
> >
> > Could elide the lifetime.
>
> Thanks, I didn't know about this.
> >
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        let file =3D unsafe { (*self.inner.get()).file };
> > > +        unsafe { File::from_raw_file(file) }
> >
> > Missing a SAFETY comment for File::from_raw_file()? I would expect
> > something about io_uring_cmd's file field storing a non-null pointer
> > to a struct file on which a reference is held for the duration of the
> > uring cmd.
>
> Yes, I missed. thanks.
> >
> > > +    }
> > > +
> > > +    // Returns the sqe  that referenced by uring cmd self.
> >
> > "Returns a reference to the uring cmd's SQE"?
>
> Agreed, thanks.
> >
> > > +    #[inline]
> > > +    pub fn sqe(&self) -> &IoUringSqe {
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        let ptr =3D unsafe { (*self.inner.get()).sqe };
> >
> > "ptr" isn't very descriptive. How about "sqe"?
>
> Sounds good.
> >
> > > +        unsafe { IoUringSqe::from_raw(ptr) }
> >
> > Similar, missing SAFETY comment for IoUringSqe::from_raw()?
>
> Thanks. I missed.
> >
> > > +    }
> > > +
> > > +    // Called by consumers of io_uring_cmd, if they originally retur=
ned -EIOCBQUEUED upon receiving the command
> > > +    #[inline]
> > > +    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {
> >
> > I don't think it's safe to move io_uring_cmd. io_uring_cmd_done(), for
> > example, calls cmd_to_io_kiocb() to turn struct io_uring_cmd *ioucmd
> > into struct io_kiocb *req via a pointer cast. And struct io_kiocb's
> > definitely need to be pinned in memory. For example,
> > io_req_normal_work_add() inserts the struct io_kiocb into a linked
> > list. Probably some sort of pinning is necessary for IoUringCmd.
>
> Understood, Normally the users wouldn't create IoUringCmd than use borrow=
ed cmd
> in uring_cmd() callback. How about change to &mut self and also uring_cmd=
 provides
> &mut IoUringCmd for arg.

I'm still a little worried about exposing &mut IoUringCmd without
pinning. It would allow swapping the fields of two IoUringCmd's (and
therefore struct io_uring_cmd's), for example. If a struct
io_uring_cmd belongs to a struct io_kiocb linked into task_list,
swapping it with another struct io_uring_cmd would result in
io_uring_cmd_work() being invoked on the wrong struct io_uring_cmd.
Maybe it would be okay if IoUringCmd had an invariant that the struct
io_uring_cmd is not on the task work list. But I would feel safer with
using Pin<&mut IoUringCmd>. I don't have much experience with Rust in
the kernel, though, so I would welcome other opinions.

Best,
Caleb

>
> >
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        unsafe {
> > > +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2,=
 issue_flags);
> > > +        }
> > > +    }
> > > +}
> > > +
> > > +#[repr(transparent)]
> > > +pub struct IoUringSqe {
> > > +    inner: Opaque<bindings::io_uring_sqe>,
> > > +}
> > > +
> > > +impl<'a> IoUringSqe {
> > > +    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {
> > > +        // SAFETY: The call guarantees that the pointer is not dangl=
ing and stays valid
> > > +        unsafe {
> > > +            let cmd =3D (*self.inner.get()).__bindgen_anon_6.cmd.as_=
ref();
> > > +            core::slice::from_raw_parts(cmd.as_ptr() as *const Opaqu=
e<u8>, 8)
> >
> > Why 8? Should be 16 bytes for a 64-byte SQE and 80 bytes for a
> > 128-byte SQE, right?
>
> Yes, it should be 16 bytes or 80 bytes. I'll fix this.
>
> >
> > > +        }
> > > +    }
> > > +
> > > +    #[inline]
> > > +    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'=
a IoUringSqe {
> >
> > Take NonNull here too?
>
> Yes, Thanks.
> >
> > > +        // SAFETY: The caller guarantees that the pointer is not dan=
gling and stays valid for the
> > > +        // duration of 'a. The cast is okay because `File` is `repr(=
transparent)`.
> > > +        //
> > > +        // INVARIANT: The caller guarantees that there are no proble=
matic `fdget_pos` calls.
> >
> > Why "File" and "fdget_pos"?
>
> It's a bad mistake. thanks!
>
> Thank you so much for deatiled review!
>
> Thanks,
> Sidong
> >
> > Best,
> > Caleb
> >
> > > +        unsafe { &*ptr.cast() }
> > > +    }
> > > +}
> > > diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> > > index 6b4774b2b1c3..fb310e78d51d 100644
> > > --- a/rust/kernel/lib.rs
> > > +++ b/rust/kernel/lib.rs
> > > @@ -80,6 +80,7 @@
> > >  pub mod fs;
> > >  pub mod init;
> > >  pub mod io;
> > > +pub mod io_uring;
> > >  pub mod ioctl;
> > >  pub mod jump_label;
> > >  #[cfg(CONFIG_KUNIT)]
> > > --
> > > 2.43.0
> > >
> > >

