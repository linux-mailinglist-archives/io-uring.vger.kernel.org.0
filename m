Return-Path: <io-uring+bounces-9539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95489B409D1
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 17:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C4211B63EDA
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 15:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC4533438D;
	Tue,  2 Sep 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bjzMHiUo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1515334386
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756828447; cv=none; b=clHDV3Y34p3UY1tF3a1lPVUA/G38lZcKtQ1mZ9qu75n4y9byvY6tWIWeawaoiRwjDmB8I8WTy6UrMklu5LG3cEWApW7BQVpFiXWCge68p5MN9nAwuyWJ2mEMd7FETAz78kMS7FYSPlQRg2PXO4p+K2Y1HozGqrJtx7/wEey87d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756828447; c=relaxed/simple;
	bh=Phpjjzej2saJsjDk6+uFFR4cadxcNKgzK4r1gcCZxMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=saHJtx0CgvGgZq3onJWqyeHgyEUXLiAHTeyS4Yt14xasM4AHkXeCz5CpQV1zSCt/Kpx84+kXspqh6jD1X+PNayvD7AIRaZpD+qhI2A8XBAA17OyyK/UGU8NDkheEBDG30K82m1jfZwVcW4ma5dus0rnpC64t0WGUqo2pfuXQbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bjzMHiUo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24b132bd90dso2073255ad.0
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756828445; x=1757433245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glkrp5zHlTMARGO+3DOaDAvVK3fEgiovpkxY+a+HGYU=;
        b=bjzMHiUobd/8Zu1CFso7fr/PJZaMxxifNPoqM2h9Cmp3JwGf5D1g5+Ud5ht5moxSY+
         R5YzoG0S/M9ymqYshdEbnrbyTJsIsITccUk3DKBi16FUfRTGbdY4lQEZjm4nwYplkNe8
         Kyx+5KrjqdUmr5LVznJ+mZ3l4dy07pHfFWwQBcLHPKvQR7zv7HDtqufaC8jxs/UtsUBE
         erDv+P+CXEPxkzD2nulWV4z+EUHlFI03kIWx9Xv2NngeK8O05ZXY7+2Fm3Lj3EyhFp4N
         U8XAVXT7Zb9Cl6D1lY3m5E1McAYSUJuZocyGXic8P/aO/xioLTphvTdKtQXdMt92pXPm
         udTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828445; x=1757433245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glkrp5zHlTMARGO+3DOaDAvVK3fEgiovpkxY+a+HGYU=;
        b=Cb6rXLBbZ8bmmj8xz6HnAqfBlptXvtpQI2R25/W7w7r9ZpWarr+NnK7EJrFxxXs4Wh
         jq0oN9/zyw54bsB0t/qEWEk86hJnGV1mjMsk0BGMp/JXEyJfZlgmih978qc/7p/ceYYZ
         NU2l4KyPtvxdKsCJhyjMld7bw4meL5+/6TMphooxG2+VACptFxjHPCINaycuWQ5CjEKq
         XgEcMl5qPNYDDsP5x4ETFLt8oi1zAkH0NcmK3OifUV4GE1SCsf32FEEFhGjEBzTUlgQx
         7C0SbIr9FytddOf2hlleLE/rmVpg3QpeZNMuOmh/4xHyM/bvmJ8bW+O8py/XpNsePnKy
         TeRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgmCvs5fB+YvumjT5JNEMsCbg4XmzfTUlD7XTX7hrLCBP+nUWsFeyIkLXTVUc46gtc+78vXyR+9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtjXTWP3+00wIWoO7MVBAMr/uq0lccD1n6lnaztKbaJ9vClupV
	5xRCuq8gLbmKrtZCEp6uz8rQvB/+aAuTrUHuQNzSfI9mT+4E0BXdTvyWO4SXngRgahA2DNB8NzG
	+t5DHMC7n/OcQOwyGVwwtN3LBmFO9WW6hPp4K8OzdQg==
X-Gm-Gg: ASbGncvzBEua/LnIdNeQoQWlCcxxT4vLr+64m7nrza+bvfvOoPlSz/qalA/pWpwhLmc
	wY8MILogIJVGAsfl8g1xXL1Ye0KP8dII5ySmL+1TeREc7pFlHlUqdK5fGhdTo0Un0Bvs+mxHWrb
	q8F41xaFbb8TsmOKr6F72sgcuCLfHNno6GTQ1oN/saD+t3/ZeP1NkJRVqoG0FVe+s0c1AGSlHEp
	MYUnHF5xWAdw3Uhmok+v3E=
X-Google-Smtp-Source: AGHT+IGo7hz0BxRWV5G1YH7hZvvr/9XeTFH7fJAa8NDYd3gLSzScxGKzPO2jMdun1EGK4NyLE1jjAIqh2/FqtYN8eps=
X-Received: by 2002:a17:902:db0e:b0:24a:fbe2:b88e with SMTP id
 d9443c01a7336-24afbe2bb85mr35011445ad.1.1756828444780; Tue, 02 Sep 2025
 08:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822125555.8620-1-sidong.yang@furiosa.ai> <20250822125555.8620-5-sidong.yang@furiosa.ai>
 <CADUfDZoDvAp1yqFyB_SQiynqQfOQPkO_mnQ_pWAXpZJESecFFw@mail.gmail.com> <aLbSi5-a67i78BHl@sidongui-MacBookPro.local>
In-Reply-To: <aLbSi5-a67i78BHl@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 2 Sep 2025 08:53:53 -0700
X-Gm-Features: Ac12FXyB8pbvzfSRoQFUjtPUW2OqS8AXMTk_z5NcDibqacuoXAPawZgi6AKUSj8
Message-ID: <CADUfDZqwgT_dpObEcnhSymk=VX7c_=13yFByyxM6Wf-W3+Wg-w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/5] rust: miscdevice: Add `uring_cmd` support
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 4:18=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai>=
 wrote:
>
> On Mon, Sep 01, 2025 at 06:12:44PM -0700, Caleb Sander Mateos wrote:
> > On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <sidong.yang@furios=
a.ai> wrote:
> > >
> > > This patch introduces support for `uring_cmd` to the `miscdevice`
> > > framework. This is achieved by adding a new `uring_cmd` method to the
> > > `MiscDevice` trait and wiring it up to the corresponding
> > > `file_operations` entry.
> > >
> > > The `uring_cmd` function provides a mechanism for `io_uring` to issue
> > > commands to a device driver.
> > >
> > > The new `uring_cmd` method takes the device, an `IoUringCmd` object,
> > > and issue flags as arguments. The `IoUringCmd` object is a safe Rust
> > > abstraction around the raw `io_uring_cmd` struct.
> > >
> > > To enable `uring_cmd` for a specific misc device, the `HAS_URING_CMD`
> > > constant must be set to `true` in the `MiscDevice` implementation.
> > >
> > > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > > ---
> > >  rust/kernel/miscdevice.rs | 53 +++++++++++++++++++++++++++++++++++++=
+-
> > >  1 file changed, 52 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
> > > index 6373fe183b27..fcef579218ba 100644
> > > --- a/rust/kernel/miscdevice.rs
> > > +++ b/rust/kernel/miscdevice.rs
> > > @@ -11,9 +11,10 @@
> > >  use crate::{
> > >      bindings,
> > >      device::Device,
> > > -    error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
> > > +    error::{from_result, to_result, Error, Result, VTABLE_DEFAULT_ER=
ROR},
> > >      ffi::{c_int, c_long, c_uint, c_ulong},
> > >      fs::File,
> > > +    io_uring::IoUringCmd,
> > >      mm::virt::VmaNew,
> > >      prelude::*,
> > >      seq_file::SeqFile,
> > > @@ -180,6 +181,21 @@ fn show_fdinfo(
> > >      ) {
> > >          build_error!(VTABLE_DEFAULT_ERROR)
> > >      }
> > > +
> > > +    /// Handler for uring_cmd.
> > > +    ///
> > > +    /// This function is invoked when userspace process submits an u=
ring_cmd op
> > > +    /// on io-uring submission queue. The `device` is borrowed insta=
nce defined
> > > +    /// by `Ptr`. The `io_uring_cmd` would be used for get arguments=
 cmd_op, sqe,
> > > +    /// cmd_data. The `issue_flags` is the flags includes options fo=
r uring_cmd.
> > > +    /// The options are listed in `kernel::io_uring::cmd_flags`.
> > > +    fn uring_cmd(
> > > +        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
> > > +        _io_uring_cmd: Pin<&mut IoUringCmd>,
> >
> > Passing the IoUringCmd by reference doesn't allow the uring_cmd()
> > implementation to store it beyond the function return. That precludes
> > any asynchronous uring_cmd() implementation, which is kind of the
> > whole point of uring_cmd. I think uring_cmd() needs to transfer
> > ownership of the IoUringCmd so the implementation can complete it
> > asynchronously.
>
> I didn't know that I can take IoUringCmd ownership and calling done().
> In C implementation, is it safe to call `io_uring_cmd_done()` in any cont=
ext?

It depends on the issue_flags. If IO_URING_F_UNLOCKED is set, it can
be called from any context. But if IO_URING_F_UNLOCKED is not set, it
needs to be called with the io_ring_ctx's uring_lock held. That
generally requires it to either be called during uring_cmd() or from a
task work callback. In either case, issue_flags needs to match what
was passed to uring_cmd() or the task work callback.
You can look at NVMe passthru as an example. It calls
io_uring_cmd_done() from nvme_uring_task_cb(), which is a task work
callback scheduled with io_uring_cmd_do_in_task_lazy() in
nvme_uring_cmd_end_io().

Best,
Caleb

