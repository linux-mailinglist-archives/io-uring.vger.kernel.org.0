Return-Path: <io-uring+bounces-8762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B55B0C7F3
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 17:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8032C543C39
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 15:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644E52D0C7E;
	Mon, 21 Jul 2025 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="iyV6C5jg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE31F1522
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753112834; cv=none; b=IjhiHtjItXfJ/QV0YiaV5V9fanXJLXbsDSa5vsO8HTqdncF19Szj93csObuCiNm+4K+f/8SLtu9VVlL7sAbM14xcqC3i8aV0hoSXgMAQvoudiNNmTxeCc+o2Hw4T5Qbne34/y4RU1nJVDJtE09zUxbM14YaGU1tizAOMZhseufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753112834; c=relaxed/simple;
	bh=QQS9xogwiIOS4OZu8i5Ne9mxh5QFZyBWebFjLODqKw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhKroNbylKNSPDgc46tQ1BAi3FYtzkpq7aYB+BnmiU7TzhEBhfpgJF0PA8TkDMVu8DIBddQSyXEccOe71heYEUNyUiBulmC2hyGlC2Jl+ISPOiq4Z2sSJz9p/NR4/tm+XL/W4Q2z7PEl9GjOp5c2Fm3eSC8mQMBLgvy0xAEPxQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=iyV6C5jg; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-747c2cc3419so3485716b3a.2
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 08:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753112832; x=1753717632; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Kbalk0v+f1Kj5hQvtKuSuXwZzUw4S9n4gHS9UNwPK2U=;
        b=iyV6C5jgI0pUMokVQdCU/H5Kec/1LXYsZqV7uGS64Vh2Y96FJKmKiKERryQhlfYj/N
         NWJ8B9NP09kNQ3snsahNNxjFB1aqyL1yAOZTwRmn3QJlhNBOA+Bdolh9+BfdzbXed0WS
         LEajZQM6x9huzWkaTxSaZoNGcXf3HPxONIJ2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753112832; x=1753717632;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kbalk0v+f1Kj5hQvtKuSuXwZzUw4S9n4gHS9UNwPK2U=;
        b=i6WzRrClEVEZBFmtehDvqWFITLcBVCrRBFFGPoOrgfGo/3cImbyfCDy5jJQIZPfCuc
         8tDg84vxbrIo5YdgACLp1ofJN2h+CbJ4GLNJTJ3aoNjhRbsDE6/Z88o/WxUNxY6dTij2
         gHcZlDg1fSDNcbMiVX90ABYdneXExXWuPFvEu00rkbB30010v12H3eUPiRxL8a2XQWuy
         Ac6g3TTZqoKV9xUD0FnykTYMI+2myRR3iz3+bV5UuxLw1NjXAlnAPhUOR7ifJZNAexIv
         TBwTwNrIM06ZMcsAhrvam4O7anb2t6G2ebXh0KfROJIVsuKYB+oHWjnaDuEOFzG4Bgb/
         Cijg==
X-Forwarded-Encrypted: i=1; AJvYcCVazz8Tk0qy7diNqzBZADu/+VirqjbCFLrdGHDro1k5yOOKfwA0EIZ3YNA7denLml/gf+jnqgGSvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxW7LuPvwG4dzSB9C/BXe2QHMeC//VuFPzYqsc5Xm50tBSJEmY0
	HGgY9Fr61cSU74UQ8PUIl+AGaplcL8Q7la1ZBxAeH2tP5tOvC5oJcPFbey/dLfCpv7Q=
X-Gm-Gg: ASbGncsAGCwPuAbTpg6CAS/mXz6/caJDgdZuPKtfwDayhqf1ZA1z1nZsnZpdlAfT1bS
	ONYtoYghWYsmROXrLnw0k83rP5oKzJ8pyiGOK5D/JbBg1CXdaRJ0olYgyE0iqURIy0YdEQId6O2
	WaHel550cNX/kC6LFATJbe0ogPxeHMRbTBLfqv1MEozIcON+A2MgUCWJT4ZH/1OcRy2ofx4lLfr
	CZyPGo0ve5370U0wQVrG7iJ87Gv7bAQsyQJG68Y2x2QxJwl5J4lDc0vHxzSTu33r7zZViSIKMMv
	hmuARu32DwFR5dcWsJEaT8Z8dXiORmWP789XEAFkQoqTwobLQXBGaBHsS6g1aK0YvfnW+ByMU5O
	iK/PB3P3qQjp2Cncw5r73DEHUx1bBDVQSKdifiZsKBwI+6MDactxC4w==
X-Google-Smtp-Source: AGHT+IHEIpnXcrRPN5zkYwxFdL1ytmZoMZColZFF7mXnPFaYG1Vl1ZQXKAGibgma53NedCRehZabng==
X-Received: by 2002:a05:6a21:b98:b0:22c:5ade:f9dd with SMTP id adf61e73a8af0-2391ca90aa8mr18678435637.42.1753112831591;
        Mon, 21 Jul 2025 08:47:11 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ff991b1sm5391013a12.56.2025.07.21.08.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 08:47:11 -0700 (PDT)
Date: Tue, 22 Jul 2025 00:47:05 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
Message-ID: <aH5g-Q_hu6neI5em@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-3-sidong.yang@furiosa.ai>
 <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
 <aH3OsKD6l18pLG92@sidongui-MacBookPro.local>
 <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrLKrf6evTXQ03cJ1W4kj0gxsF9Bopu+i2SjkBObXKnMA@mail.gmail.com>

On Mon, Jul 21, 2025 at 11:04:31AM -0400, Caleb Sander Mateos wrote:
> On Mon, Jul 21, 2025 at 1:23 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > On Sun, Jul 20, 2025 at 03:10:28PM -0400, Caleb Sander Mateos wrote:
> > > On Sat, Jul 19, 2025 at 10:34 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > >
> > > > This patch introduces rust abstraction for io-uring sqe, cmd. IoUringSqe
> > > > abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
> > > > abstraction for io_uring_cmd. From this, user can get cmd_op, flags,
> > > > pdu and also sqe.
> > > >
> > > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > > ---
> > > >  rust/kernel/io_uring.rs | 114 ++++++++++++++++++++++++++++++++++++++++
> > > >  rust/kernel/lib.rs      |   1 +
> > > >  2 files changed, 115 insertions(+)
> > > >  create mode 100644 rust/kernel/io_uring.rs
> > > >
> > > > diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> > > > new file mode 100644
> > > > index 000000000000..7843effbedb4
> > > > --- /dev/null
> > > > +++ b/rust/kernel/io_uring.rs
> > > > @@ -0,0 +1,114 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +
> > > > +// Copyright (C) 2025 Furiosa AI.
> > > > +
> > > > +//! Files and file descriptors.
> > > > +//!
> > > > +//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
> > > > +//! [`include/linux/file.h`](srctree/include/linux/file.h)
> > > > +
> > > > +use core::mem::MaybeUninit;
> > > > +
> > > > +use crate::{fs::File, types::Opaque};
> > > > +
> > > > +pub mod flags {
> > > > +    pub const COMPLETE_DEFER: i32 = bindings::io_uring_cmd_flags_IO_URING_F_COMPLETE_DEFER;
> > > > +    pub const UNLOCKED: i32 = bindings::io_uring_cmd_flags_IO_URING_F_UNLOCKED;
> > > > +
> > > > +    pub const MULTISHOT: i32 = bindings::io_uring_cmd_flags_IO_URING_F_MULTISHOT;
> > > > +    pub const IOWQ: i32 = bindings::io_uring_cmd_flags_IO_URING_F_IOWQ;
> > > > +    pub const NONBLOCK: i32 = bindings::io_uring_cmd_flags_IO_URING_F_NONBLOCK;
> > > > +
> > > > +    pub const SQE128: i32 = bindings::io_uring_cmd_flags_IO_URING_F_SQE128;
> > > > +    pub const CQE32: i32 = bindings::io_uring_cmd_flags_IO_URING_F_CQE32;
> > > > +    pub const IOPOLL: i32 = bindings::io_uring_cmd_flags_IO_URING_F_IOPOLL;
> > > > +
> > > > +    pub const CANCEL: i32 = bindings::io_uring_cmd_flags_IO_URING_F_CANCEL;
> > > > +    pub const COMPAT: i32 = bindings::io_uring_cmd_flags_IO_URING_F_COMPAT;
> > > > +    pub const TASK_DEAD: i32 = bindings::io_uring_cmd_flags_IO_URING_F_TASK_DEAD;
> > > > +}
> > > > +
> > > > +#[repr(transparent)]
> > > > +pub struct IoUringCmd {
> > > > +    inner: Opaque<bindings::io_uring_cmd>,
> > > > +}
> > > > +
> > > > +impl IoUringCmd {
> > > > +    /// Returns the cmd_op with associated with the io_uring_cmd.
> > > > +    #[inline]
> > > > +    pub fn cmd_op(&self) -> u32 {
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        unsafe { (*self.inner.get()).cmd_op }
> > > > +    }
> > > > +
> > > > +    /// Returns the flags with associated with the io_uring_cmd.
> > > > +    #[inline]
> > > > +    pub fn flags(&self) -> u32 {
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        unsafe { (*self.inner.get()).flags }
> > > > +    }
> > > > +
> > > > +    /// Returns the ref pdu for free use.
> > > > +    #[inline]
> > > > +    pub fn pdu(&mut self) -> MaybeUninit<&mut [u8; 32]> {
> > >
> > > Should be &mut MaybeUninit, right? It's the bytes that may be
> > > uninitialized, not the reference.
> >
> > Yes, it should be &mut MaybeUninit.
> > >
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        unsafe { MaybeUninit::new(&mut (*self.inner.get()).pdu) }
> > > > +    }
> > > > +
> > > > +    /// Constructs a new `struct io_uring_cmd` wrapper from a file descriptor.
> > >
> > > Why "from a file descriptor"?
> > >
> > > Also, missing a comment documenting the safety preconditions?
> >
> > Yes, it's a mistake in comment and also ptr should be NonNull.
> > >
> > > > +    #[inline]
> > > > +    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_cmd) -> &'a IoUringCmd {
> > >
> > > Could take NonNull instead of a raw pointer.
> > >
> > > > +        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
> > > > +        // duration of 'a. The cast is okay because `File` is `repr(transparent)`.
> > >
> > > "File" -> "IoUringCmd"?
> > >
> > > > +        unsafe { &*ptr.cast() }
> > > > +    }
> > > > +
> > > > +    // Returns the file that referenced by uring cmd self.
> > >
> > > I had a hard time parsing this comment. How about "Returns a reference
> > > to the uring cmd's file object"?
> >
> > Agreed. thanks.
> > >
> > > > +    #[inline]
> > > > +    pub fn file<'a>(&'a self) -> &'a File {
> > >
> > > Could elide the lifetime.
> >
> > Thanks, I didn't know about this.
> > >
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        let file = unsafe { (*self.inner.get()).file };
> > > > +        unsafe { File::from_raw_file(file) }
> > >
> > > Missing a SAFETY comment for File::from_raw_file()? I would expect
> > > something about io_uring_cmd's file field storing a non-null pointer
> > > to a struct file on which a reference is held for the duration of the
> > > uring cmd.
> >
> > Yes, I missed. thanks.
> > >
> > > > +    }
> > > > +
> > > > +    // Returns the sqe  that referenced by uring cmd self.
> > >
> > > "Returns a reference to the uring cmd's SQE"?
> >
> > Agreed, thanks.
> > >
> > > > +    #[inline]
> > > > +    pub fn sqe(&self) -> &IoUringSqe {
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        let ptr = unsafe { (*self.inner.get()).sqe };
> > >
> > > "ptr" isn't very descriptive. How about "sqe"?
> >
> > Sounds good.
> > >
> > > > +        unsafe { IoUringSqe::from_raw(ptr) }
> > >
> > > Similar, missing SAFETY comment for IoUringSqe::from_raw()?
> >
> > Thanks. I missed.
A> > >
> > > > +    }
> > > > +
> > > > +    // Called by consumers of io_uring_cmd, if they originally returned -EIOCBQUEUED upon receiving the command
> > > > +    #[inline]
> > > > +    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {
> > >
> > > I don't think it's safe to move io_uring_cmd. io_uring_cmd_done(), for
> > > example, calls cmd_to_io_kiocb() to turn struct io_uring_cmd *ioucmd
> > > into struct io_kiocb *req via a pointer cast. And struct io_kiocb's
> > > definitely need to be pinned in memory. For example,
> > > io_req_normal_work_add() inserts the struct io_kiocb into a linked
> > > list. Probably some sort of pinning is necessary for IoUringCmd.
> >
> > Understood, Normally the users wouldn't create IoUringCmd than use borrowed cmd
> > in uring_cmd() callback. How about change to &mut self and also uring_cmd provides
> > &mut IoUringCmd for arg.
> 
> I'm still a little worried about exposing &mut IoUringCmd without
> pinning. It would allow swapping the fields of two IoUringCmd's (and
> therefore struct io_uring_cmd's), for example. If a struct
> io_uring_cmd belongs to a struct io_kiocb linked into task_list,
> swapping it with another struct io_uring_cmd would result in
> io_uring_cmd_work() being invoked on the wrong struct io_uring_cmd.
> Maybe it would be okay if IoUringCmd had an invariant that the struct
> io_uring_cmd is not on the task work list. But I would feel safer with
> using Pin<&mut IoUringCmd>. I don't have much experience with Rust in
> the kernel, though, so I would welcome other opinions.

I've thought about this deeply. You're right. exposing &mut without
pinning make it unsafe. User also can make *mut and memmove to anywhere
without unsafe block. It's safest to get NonNull from from_raw and it
returns Pin<&mut IoUringCmd>. from_raw() name is weird. it should be
from_nonnnull()? Also, done() would get Pin<&mut Self>.

Thanks,
Sidong
> 
> Best,
> Caleb
> 
> >
> > >
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        unsafe {
> > > > +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, issue_flags);
> > > > +        }
> > > > +    }
> > > > +}
> > > > +
> > > > +#[repr(transparent)]
> > > > +pub struct IoUringSqe {
> > > > +    inner: Opaque<bindings::io_uring_sqe>,
> > > > +}
> > > > +
> > > > +impl<'a> IoUringSqe {
> > > > +    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {
> > > > +        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
> > > > +        unsafe {
> > > > +            let cmd = (*self.inner.get()).__bindgen_anon_6.cmd.as_ref();
> > > > +            core::slice::from_raw_parts(cmd.as_ptr() as *const Opaque<u8>, 8)
> > >
> > > Why 8? Should be 16 bytes for a 64-byte SQE and 80 bytes for a
> > > 128-byte SQE, right?
> >
> > Yes, it should be 16 bytes or 80 bytes. I'll fix this.
> >
> > >
> > > > +        }
> > > > +    }
> > > > +
> > > > +    #[inline]
> > > > +    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'a IoUringSqe {
> > >
> > > Take NonNull here too?
> >
> > Yes, Thanks.
> > >
> > > > +        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
> > > > +        // duration of 'a. The cast is okay because `File` is `repr(transparent)`.
> > > > +        //
> > > > +        // INVARIANT: The caller guarantees that there are no problematic `fdget_pos` calls.
> > >
> > > Why "File" and "fdget_pos"?
> >
> > It's a bad mistake. thanks!
> >
> > Thank you so much for deatiled review!
> >
> > Thanks,
> > Sidong
> > >
> > > Best,
> > > Caleb
> > >
> > > > +        unsafe { &*ptr.cast() }
> > > > +    }
> > > > +}
> > > > diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> > > > index 6b4774b2b1c3..fb310e78d51d 100644
> > > > --- a/rust/kernel/lib.rs
> > > > +++ b/rust/kernel/lib.rs
> > > > @@ -80,6 +80,7 @@
> > > >  pub mod fs;
> > > >  pub mod init;
> > > >  pub mod io;
> > > > +pub mod io_uring;
> > > >  pub mod ioctl;
> > > >  pub mod jump_label;
> > > >  #[cfg(CONFIG_KUNIT)]
> > > > --
> > > > 2.43.0
> > > >
> > > >

