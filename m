Return-Path: <io-uring+bounces-8747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DBFB0B7E4
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 21:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13D673AE599
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 19:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9161921CC60;
	Sun, 20 Jul 2025 19:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HBBtFakw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842A1F3FE2
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 19:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753038642; cv=none; b=eSUcWv6PiIytCyiO4pBwDDCEpJDTKizmzkcMi2+YVVHTDHWLlbU9PmVGuInBtxL9awuY5Y/y5YmfpZ1LQof3hcAiU7WWKUz/6hSmnCLj/7apuysivvhYfd1P90KuAC9uK/kUE/BbwR5nzK/LfzrqaG4Hws1xirKfNsWTzwaD22A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753038642; c=relaxed/simple;
	bh=JOvx3nh9mFDiLNBPYVwlUAlSvRSi4qYNxWKVj/fNYEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XkImBtSmey4GXyI0nwlD/aizmMyqMe33oWz0VwSlYlfknvNWhtJZMDWiN5cZo3PWEomksdgpDK/FXHYcrb5XKtaq4qSebyLMZcSa8n7EvcqL7UC5e3sf2YgG1xFZ4uHxKReBhBwjZfdU6zrMalHIga84HuPzcgNar2zzyKUGTcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HBBtFakw; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3138e64fc73so996680a91.2
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 12:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1753038640; x=1753643440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PmJl5FG+nYbKChQjlQ85TAcYbUyzcNej5BFeiW0cAQ8=;
        b=HBBtFakwCzbl8SkKbpbRNLwgq4+fVQ9IPkdHh5pqVoKFohlKXI1yvePPt6HY+JGKeL
         G6J/v7AlncDzbat6n8mbzuq2Cc5qXJevASZWCJkawwNljFBuY3Gdf36VXevVi9lyVAYP
         uss+fgw9Amyzh6k+q6h4p1vVpXjv+hkQs4Tl4JjK6UWmZFZPUsr89GGOFnOiUxrmPebZ
         PsJiDBBJSUJymrLYX2LXLtd+48RzN275SIZu6HocREPeuwUgMbVfTXh8lfWCHP7n/pfP
         jYIHwfV84j2dy7oa6fNN8YsMp8rO9fSt3sqdusMwqxkAFKDZ+uCvZWl5nhhNZMaxnEdp
         cb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753038640; x=1753643440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PmJl5FG+nYbKChQjlQ85TAcYbUyzcNej5BFeiW0cAQ8=;
        b=KujnROBm8TLUFhbtTm5ngIaY0lSvEjT3sMU5VOxwuNhD2HfaJDhucbCibYXVXxXjvC
         w19FarYeEmVV+jezsgOjXkX7nq6EGnpGfTtilIDrxKO8tpeWe6uxTfi3fV0xWSF3aiHz
         y/+jXetR8Ukg4DQu6vZGaJBlANzyTb1mC/urMTjAKGFKu0wZ8RPECcEOBbPSmvUveRkg
         rmkm/q9VVJzKEBa6atpsASR/Yi6wpblMUeMliCAv9Sm973R9OjdqVO+tUzZ++SK5BIzQ
         86u8QOaf+0WzOt/IJQrl+BPXYIbThBgoy+B9KNdbS05LvbLEEvarhTwA8NSiUUyb3b7r
         HBfw==
X-Forwarded-Encrypted: i=1; AJvYcCURqIERcBsqDOdDm8EBXr73izaiT/JC2LTeOX3nnwkeSKqxPPxvVgqFSdSq6I0hGWagYI4TVuUeSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlZL4JsVVAndiIrxJ008dzBssGmt1V7q0KN+lyZrVx7Gxs86H2
	eRcmBfh46NlmG58390o0dkqcO3O47UG7pHCnoyTyex/LCMvaYEikGY36fy7uugg9+Vp8aUig3FY
	IZPyrwWAaHMIjkZw/VrmXYuoybWMPK25mS3fTzZrCWw==
X-Gm-Gg: ASbGncsj5QjIVF+XrE24Iil7vBQpSzOXN8QzrMwkWu/IQ5RufkXlzGMvT2ovm6nPc3Z
	693gWo8eV3cVAlAPYgJeV2zgiUDlgc94iCmpqtyMzsrjQOwOwoYJs0aXGcqa6wBwKXwftU7gqKt
	thbputBbjD+mocOCriNAZVfgLUYef5bg+Kul+RC1Th/jz0wrxmJIUtD8VEWJA62yFQFodcLd6OK
	Wf7Vw==
X-Google-Smtp-Source: AGHT+IGOGQVTZCwO/q58veRX4aZbzscVmWPDj+vfdXysc1G6WzI8O5zaqzuKd24XlOjO18sEzec0XfqkiPOIck3ILc8=
X-Received: by 2002:a17:90b:5483:b0:311:e9a6:332e with SMTP id
 98e67ed59e1d1-31c9e60a04dmr11530858a91.0.1753038639935; Sun, 20 Jul 2025
 12:10:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai> <20250719143358.22363-3-sidong.yang@furiosa.ai>
In-Reply-To: <20250719143358.22363-3-sidong.yang@furiosa.ai>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 20 Jul 2025 15:10:28 -0400
X-Gm-Features: Ac12FXyeTtvN7WKo8iZgnjOkCeidkzCzy-MFx0hny4yYfEzWm8YJLSVMr542AjI
Message-ID: <CADUfDZoBrnDpnTOxiDq6pBkctJ3NDJq7Wcqm2pUu_ooqMy8yyw@mail.gmail.com>
Subject: Re: [PATCH 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 10:34=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.a=
i> wrote:
>
> This patch introduces rust abstraction for io-uring sqe, cmd. IoUringSqe
> abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
> abstraction for io_uring_cmd. From this, user can get cmd_op, flags,
> pdu and also sqe.
>
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  rust/kernel/io_uring.rs | 114 ++++++++++++++++++++++++++++++++++++++++
>  rust/kernel/lib.rs      |   1 +
>  2 files changed, 115 insertions(+)
>  create mode 100644 rust/kernel/io_uring.rs
>
> diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> new file mode 100644
> index 000000000000..7843effbedb4
> --- /dev/null
> +++ b/rust/kernel/io_uring.rs
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +// Copyright (C) 2025 Furiosa AI.
> +
> +//! Files and file descriptors.
> +//!
> +//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io=
_uring/cmd.h) and
> +//! [`include/linux/file.h`](srctree/include/linux/file.h)
> +
> +use core::mem::MaybeUninit;
> +
> +use crate::{fs::File, types::Opaque};
> +
> +pub mod flags {
> +    pub const COMPLETE_DEFER: i32 =3D bindings::io_uring_cmd_flags_IO_UR=
ING_F_COMPLETE_DEFER;
> +    pub const UNLOCKED: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_=
UNLOCKED;
> +
> +    pub const MULTISHOT: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F=
_MULTISHOT;
> +    pub const IOWQ: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_IOWQ=
;
> +    pub const NONBLOCK: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_=
NONBLOCK;
> +
> +    pub const SQE128: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_SQ=
E128;
> +    pub const CQE32: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_CQE=
32;
> +    pub const IOPOLL: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_IO=
POLL;
> +
> +    pub const CANCEL: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_CA=
NCEL;
> +    pub const COMPAT: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F_CO=
MPAT;
> +    pub const TASK_DEAD: i32 =3D bindings::io_uring_cmd_flags_IO_URING_F=
_TASK_DEAD;
> +}
> +
> +#[repr(transparent)]
> +pub struct IoUringCmd {
> +    inner: Opaque<bindings::io_uring_cmd>,
> +}
> +
> +impl IoUringCmd {
> +    /// Returns the cmd_op with associated with the io_uring_cmd.
> +    #[inline]
> +    pub fn cmd_op(&self) -> u32 {
> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        unsafe { (*self.inner.get()).cmd_op }
> +    }
> +
> +    /// Returns the flags with associated with the io_uring_cmd.
> +    #[inline]
> +    pub fn flags(&self) -> u32 {
> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        unsafe { (*self.inner.get()).flags }
> +    }
> +
> +    /// Returns the ref pdu for free use.
> +    #[inline]
> +    pub fn pdu(&mut self) -> MaybeUninit<&mut [u8; 32]> {

Should be &mut MaybeUninit, right? It's the bytes that may be
uninitialized, not the reference.

> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        unsafe { MaybeUninit::new(&mut (*self.inner.get()).pdu) }
> +    }
> +
> +    /// Constructs a new `struct io_uring_cmd` wrapper from a file descr=
iptor.

Why "from a file descriptor"?

Also, missing a comment documenting the safety preconditions?

> +    #[inline]
> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_cmd) -> &'=
a IoUringCmd {

Could take NonNull instead of a raw pointer.

> +        // SAFETY: The caller guarantees that the pointer is not danglin=
g and stays valid for the
> +        // duration of 'a. The cast is okay because `File` is `repr(tran=
sparent)`.

"File" -> "IoUringCmd"?

> +        unsafe { &*ptr.cast() }
> +    }
> +
> +    // Returns the file that referenced by uring cmd self.

I had a hard time parsing this comment. How about "Returns a reference
to the uring cmd's file object"?

> +    #[inline]
> +    pub fn file<'a>(&'a self) -> &'a File {

Could elide the lifetime.

> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        let file =3D unsafe { (*self.inner.get()).file };
> +        unsafe { File::from_raw_file(file) }

Missing a SAFETY comment for File::from_raw_file()? I would expect
something about io_uring_cmd's file field storing a non-null pointer
to a struct file on which a reference is held for the duration of the
uring cmd.

> +    }
> +
> +    // Returns the sqe  that referenced by uring cmd self.

"Returns a reference to the uring cmd's SQE"?

> +    #[inline]
> +    pub fn sqe(&self) -> &IoUringSqe {
> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        let ptr =3D unsafe { (*self.inner.get()).sqe };

"ptr" isn't very descriptive. How about "sqe"?

> +        unsafe { IoUringSqe::from_raw(ptr) }

Similar, missing SAFETY comment for IoUringSqe::from_raw()?

> +    }
> +
> +    // Called by consumers of io_uring_cmd, if they originally returned =
-EIOCBQUEUED upon receiving the command
> +    #[inline]
> +    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {

I don't think it's safe to move io_uring_cmd. io_uring_cmd_done(), for
example, calls cmd_to_io_kiocb() to turn struct io_uring_cmd *ioucmd
into struct io_kiocb *req via a pointer cast. And struct io_kiocb's
definitely need to be pinned in memory. For example,
io_req_normal_work_add() inserts the struct io_kiocb into a linked
list. Probably some sort of pinning is necessary for IoUringCmd.

> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        unsafe {
> +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, iss=
ue_flags);
> +        }
> +    }
> +}
> +
> +#[repr(transparent)]
> +pub struct IoUringSqe {
> +    inner: Opaque<bindings::io_uring_sqe>,
> +}
> +
> +impl<'a> IoUringSqe {
> +    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {
> +        // SAFETY: The call guarantees that the pointer is not dangling =
and stays valid
> +        unsafe {
> +            let cmd =3D (*self.inner.get()).__bindgen_anon_6.cmd.as_ref(=
);
> +            core::slice::from_raw_parts(cmd.as_ptr() as *const Opaque<u8=
>, 8)

Why 8? Should be 16 bytes for a 64-byte SQE and 80 bytes for a
128-byte SQE, right?

> +        }
> +    }
> +
> +    #[inline]
> +    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'a Io=
UringSqe {

Take NonNull here too?

> +        // SAFETY: The caller guarantees that the pointer is not danglin=
g and stays valid for the
> +        // duration of 'a. The cast is okay because `File` is `repr(tran=
sparent)`.
> +        //
> +        // INVARIANT: The caller guarantees that there are no problemati=
c `fdget_pos` calls.

Why "File" and "fdget_pos"?

Best,
Caleb

> +        unsafe { &*ptr.cast() }
> +    }
> +}
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 6b4774b2b1c3..fb310e78d51d 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -80,6 +80,7 @@
>  pub mod fs;
>  pub mod init;
>  pub mod io;
> +pub mod io_uring;
>  pub mod ioctl;
>  pub mod jump_label;
>  #[cfg(CONFIG_KUNIT)]
> --
> 2.43.0
>
>

