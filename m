Return-Path: <io-uring+bounces-9536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F09B3FD97
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 13:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACB1A1B2429E
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 11:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DF42F49EE;
	Tue,  2 Sep 2025 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="Fk7PXV/v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB927EFEF
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756811923; cv=none; b=E+wG1RPEefnfsM9huMMxmb5JHe9SKMESB20xkxEKPszhnlt6poPMNzzDSRHFWd6FM52ITgk5GKWrjOP8nes5vpZ9qejdtVu3JC4d+1gydzAaov6exDiSeft/2EAVbz9o2wackU21FsyaZ94cUPzBZ3jQvbGq9h5Z+bAVCU57afI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756811923; c=relaxed/simple;
	bh=gGRmi9BKNmESEIGIYdP+7B9F6iwTVze0fleAiVXwmco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtqRhEyfRnWsRAkmX3QDN1YPhQWnijWC8Wwu5zVLuzLczvHllZgWoCiSuGAf0KxV+cfZDs1n1uLIFurbC5Z/pMeTtEptrL2QyIe1SnbowH7PVKVpcRN2nhnOqys9yH5miouV35zLT3rVgp2l6i8si/hu2arACQE2k3p8uaia83M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=Fk7PXV/v; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7723f0924a3so3243097b3a.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 04:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1756811921; x=1757416721; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0nWMjohz4DV5AHDo374fac7S+dpBXMCA8tWWrP1vlQY=;
        b=Fk7PXV/v32yuwhr9INs8+JHQ3Oqp02NdzJUbhj55qZ0WolrgyfZ9WIdkdEw5KtFuwt
         cBxlXyP4BZMjcMzbkaZinfN3lNVI8JDs1gRZiSvpLr9jz3GAZAyMjoKSNEGPFmKuds7o
         yYhobuESqB5vjhrSS2MA6SJJ0+sLjkxLt4Vu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756811921; x=1757416721;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nWMjohz4DV5AHDo374fac7S+dpBXMCA8tWWrP1vlQY=;
        b=BDul7sVhAMW5xQ1yOeOdblCw2lXUukmUdWc3rWIGrjE1LqD8qEnGi3m17FawlzGuZQ
         zbFNqSzVYVWT1ZDlci3cKqmzIg0K7C3CAMu+CY43AWS4RerHoTbt856HhnLhpT866mFU
         XMUjhvDrpYolbQR/sCqmKWFJBZun09SmEeBRh8k3NL+9TTEhs3cGmFc0pJtm+eCWcoqS
         XUsCDSS5zuE+i0vAETd7LdU25FW1Jnu6SBBnPvzL2NtvGnRRLmPBX5zP1EVuUWLeA9WP
         5liuntyWEmgJxak18/HS8/U6wP4a2wlBX2V1A7yZrD4msrGgzxUUC3zCJEFlj6dw27ux
         +tOg==
X-Forwarded-Encrypted: i=1; AJvYcCWpRGRiQ9CNH/gLCfGkt3Jl3ZpqM+YRnlQiP5zPbwYmBZtd+9FHW2dpdMd+kmG4PmUBn/WToSoQsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLBmzsMe+ij3FzJ2imq7D+KyeEf0CyM/m4LBEEdW2gymqc098R
	Rr2DDmvfT+ITc/x9xIKNOpGHLxY4q9dRt2SZxfwRBE4n5zsX5wGpyuEWBbOMTlQsFl8=
X-Gm-Gg: ASbGncv5N824rR/+JQlkkDsfIBiyS/QF1opp//KRvjEUmvn/Hxb9uQBLwynvxrNbEGp
	s9trIdxyRqS/1DrOF7KKnoE8OL4UTS8sOQ7Vcx/ea0QQkUo6FKihdyfbqRSdK6l8prdQMJyYVyz
	lQYdF+dNQccvFB3BufUAkUqzQ73dJyOlXULvKCcugf5H7PTenKOXv6D5aT5Lnd9h0Cd9jV+Tw7g
	vN3BwHSxTAmoOyfNnAxoipFHuo8nOWxOAeijhyTbZ0JdGSJNRhp9sfA3gfBpfhOsRcOF+PCeOKD
	W5ajWKmyk85LFhAkeIsPxYFyofMfzfPA9+pKJjP7VoGyn0bZAur6eFXoIB0TJ4n4aJl+PHrKQae
	vqtNRhzjCyejtmrl1XGrghO2HGjxUqDzaMRPORl2PK/5wfMtH9rOzVkthXU451YZJ
X-Google-Smtp-Source: AGHT+IE+I2Gk8VSrnS6eFFPIKGMhJEZoHV5J500ITPlIHjfERnr0mfn/YxRU4ImwyNpSqSmp4jInyg==
X-Received: by 2002:a05:6a20:6a27:b0:246:17b:3577 with SMTP id adf61e73a8af0-246017b37d1mr908910637.58.1756811921381;
        Tue, 02 Sep 2025 04:18:41 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a26bc9csm13471707b3a.18.2025.09.02.04.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:18:41 -0700 (PDT)
Date: Tue, 2 Sep 2025 20:18:35 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/5] rust: miscdevice: Add `uring_cmd` support
Message-ID: <aLbSi5-a67i78BHl@sidongui-MacBookPro.local>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-5-sidong.yang@furiosa.ai>
 <CADUfDZoDvAp1yqFyB_SQiynqQfOQPkO_mnQ_pWAXpZJESecFFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZoDvAp1yqFyB_SQiynqQfOQPkO_mnQ_pWAXpZJESecFFw@mail.gmail.com>

On Mon, Sep 01, 2025 at 06:12:44PM -0700, Caleb Sander Mateos wrote:
> On Fri, Aug 22, 2025 at 5:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > This patch introduces support for `uring_cmd` to the `miscdevice`
> > framework. This is achieved by adding a new `uring_cmd` method to the
> > `MiscDevice` trait and wiring it up to the corresponding
> > `file_operations` entry.
> >
> > The `uring_cmd` function provides a mechanism for `io_uring` to issue
> > commands to a device driver.
> >
> > The new `uring_cmd` method takes the device, an `IoUringCmd` object,
> > and issue flags as arguments. The `IoUringCmd` object is a safe Rust
> > abstraction around the raw `io_uring_cmd` struct.
> >
> > To enable `uring_cmd` for a specific misc device, the `HAS_URING_CMD`
> > constant must be set to `true` in the `MiscDevice` implementation.
> >
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> >  rust/kernel/miscdevice.rs | 53 ++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 52 insertions(+), 1 deletion(-)
> >
> > diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
> > index 6373fe183b27..fcef579218ba 100644
> > --- a/rust/kernel/miscdevice.rs
> > +++ b/rust/kernel/miscdevice.rs
> > @@ -11,9 +11,10 @@
> >  use crate::{
> >      bindings,
> >      device::Device,
> > -    error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
> > +    error::{from_result, to_result, Error, Result, VTABLE_DEFAULT_ERROR},
> >      ffi::{c_int, c_long, c_uint, c_ulong},
> >      fs::File,
> > +    io_uring::IoUringCmd,
> >      mm::virt::VmaNew,
> >      prelude::*,
> >      seq_file::SeqFile,
> > @@ -180,6 +181,21 @@ fn show_fdinfo(
> >      ) {
> >          build_error!(VTABLE_DEFAULT_ERROR)
> >      }
> > +
> > +    /// Handler for uring_cmd.
> > +    ///
> > +    /// This function is invoked when userspace process submits an uring_cmd op
> > +    /// on io-uring submission queue. The `device` is borrowed instance defined
> > +    /// by `Ptr`. The `io_uring_cmd` would be used for get arguments cmd_op, sqe,
> > +    /// cmd_data. The `issue_flags` is the flags includes options for uring_cmd.
> > +    /// The options are listed in `kernel::io_uring::cmd_flags`.
> > +    fn uring_cmd(
> > +        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
> > +        _io_uring_cmd: Pin<&mut IoUringCmd>,
> 
> Passing the IoUringCmd by reference doesn't allow the uring_cmd()
> implementation to store it beyond the function return. That precludes
> any asynchronous uring_cmd() implementation, which is kind of the
> whole point of uring_cmd. I think uring_cmd() needs to transfer
> ownership of the IoUringCmd so the implementation can complete it
> asynchronously.

I didn't know that I can take IoUringCmd ownership and calling done(). 
In C implementation, is it safe to call `io_uring_cmd_done()` in any context?

> 
> Best,
> Caleb
> 
> > +        _issue_flags: u32,
> > +    ) -> Result<i32> {
> > +        build_error!(VTABLE_DEFAULT_ERROR)
> > +    }
> >  }
> >
> >  /// A vtable for the file operations of a Rust miscdevice.
> > @@ -337,6 +353,36 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
> >          T::show_fdinfo(device, m, file);
> >      }
> >
> > +    /// # Safety
> > +    ///
> > +    /// The caller must ensure that:
> > +    /// - The pointer `ioucmd` is not null and points to a valid `bindings::io_uring_cmd`.
> > +    unsafe extern "C" fn uring_cmd(
> > +        ioucmd: *mut bindings::io_uring_cmd,
> > +        issue_flags: ffi::c_uint,
> > +    ) -> c_int {
> > +        // SAFETY: `file` referenced by `ioucmd` is valid pointer. It's assigned in
> > +        // uring cmd preparation. So dereferencing is safe.
> > +        let raw_file = unsafe { (*ioucmd).file };
> > +
> > +        // SAFETY: `private_data` is guaranteed that it has valid pointer after
> > +        // this file opened. So dereferencing is safe.
> > +        let private = unsafe { (*raw_file).private_data }.cast();
> > +
> > +        // SAFETY: `ioucmd` is not null and points to valid memory `bindings::io_uring_cmd`
> > +        // and the memory pointed by `ioucmd` is valid and will not be moved or
> > +        // freed for the lifetime of returned value `ioucmd`
> > +        let ioucmd = unsafe { IoUringCmd::from_raw(ioucmd) };
> > +
> > +        // SAFETY: This call is safe because `private` is returned by
> > +        // `into_foreign` in [`open`]. And it's guaranteed
> > +        // that `from_foreign` is called by [`release`] after the end of
> > +        // the lifetime of `device`
> > +        let device = unsafe { <T::Ptr as ForeignOwnable>::borrow(private) };
> > +
> > +        from_result(|| T::uring_cmd(device, ioucmd, issue_flags))
> > +    }
> > +
> >      const VTABLE: bindings::file_operations = bindings::file_operations {
> >          open: Some(Self::open),
> >          release: Some(Self::release),
> > @@ -359,6 +405,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
> >          } else {
> >              None
> >          },
> > +        uring_cmd: if T::HAS_URING_CMD {
> > +            Some(Self::uring_cmd)
> > +        } else {
> > +            None
> > +        },
> >          // SAFETY: All zeros is a valid value for `bindings::file_operations`.
> >          ..unsafe { MaybeUninit::zeroed().assume_init() }
> >      };
> > --
> > 2.43.0
> >

