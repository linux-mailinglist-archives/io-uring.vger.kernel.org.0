Return-Path: <io-uring+bounces-8753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1D0B0BC11
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 07:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEF401896AEC
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 05:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BFF1F2B90;
	Mon, 21 Jul 2025 05:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="EqG9bz1o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D981DFDE
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 05:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753076574; cv=none; b=m9HaU9iU3Y1C5L40QjvgaAZsS/LiviAq/p2rmQ+PQ7/9x+c34fWgDsGkICn5GW4blxMemLKuIocpjY26LkUZkjve1R2H1/9jUzATRR1V51H5JAmwTmhWrnBcjucLQYLipWykXPcR9NRlIzXZ7NGx/GL3Y+qWQg3zxyEYYcuMjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753076574; c=relaxed/simple;
	bh=JrKcpk3Qj3IVMgAVLgxJUQFX8REPMADjoTMxMUlt74E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUM6vpdLDBahQftt+omING7Vg7cPo6jb3zI/ZkAvJPqGpotwdCsEqtyUdshqfckoWnDmrNdij+hD6r8wlHrj5WtWMQhkODmbnRZpCi5XFL8BNspa+NcN3lbWIlrp22P67tczGwmhZ6vy20M4O1ADMbhnFj08qUb+frDPIx93HC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=EqG9bz1o; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-234f17910d8so33980715ad.3
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 22:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753076573; x=1753681373; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OINyTmS0kTaq+9cL6TTezFQf3vvpNluR/qiFYj4mJCI=;
        b=EqG9bz1oWKHBTxcFcsD2oIKa6R7rBT5gGBsj0YVI+vYbhosis5JTTyEsUeKSp7m/Lc
         eAoHwq+DVxTDNeff8ka8tHYm8P6d+AXusbecLyzKlKJ1PZNfRHueLs97lLU/bRXFwCBe
         /DH6rcQnfreNL4KgDnHF/xcqo73Vn1KByd/o4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753076573; x=1753681373;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OINyTmS0kTaq+9cL6TTezFQf3vvpNluR/qiFYj4mJCI=;
        b=EytMT/W7DuwH8SN/miuSLK5lExzC/n7+YNZEM4VXakKF+ws3NDTwFXNZ76L/8XR/se
         OMqlK14FQLCuJy4cJpEYJircvLHSWS//uHPtmuanKGEggvTRhawwvXYE37gIZPpTiLg/
         a2tYqyY6TKmEv24bm8e+kKTESTkq0bJrJQEjSjZ9hDv4Cf8gOrZ3VsogOod4bwiV3vCv
         0/vlElay333RFf6AxpYU6GTYIDxDLL7sMIGSfea0LX+NeEa+u3RJr934jygfr4j2oCow
         uamgRIPtGVxiHdyxWZnNcuseXjGW8tPtiDFE9iI8Ac917l0trrPKcoeHsfIgmu+6xhiA
         n/yg==
X-Forwarded-Encrypted: i=1; AJvYcCUK1ULE8uNrT9Z/fqMard0bnVgb23dvD3ppJj4TH0ntne/6b8X5fFCmMdIKX4Z17xuS4KQ5yBSUyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfZt+gplf/KFWvBXwOx6w98oK7ZCB3j851LKR91z9YLfCyspfL
	BJSvYw0JLRSPp0Zjk+G8TyJrunBZLLXkop3SRypDVPelX6W4Jc25lUM/63N069tW/B8=
X-Gm-Gg: ASbGncsgw2w36YqwJS3iAhRy7GuwSArqmYZDGQFhC1gI8yIBAvXE4LafgdfwmFmhq0p
	1DuUpvBWCyzPVw/VoEYXv1ANYjBp/1Vf/OBffmVj74q7FOXBH+suDmN/hP4vb/dlFPdFu2FLldj
	yGPDn4IngTqF2DUuRhtI9vaj5HUh93m4JW8bmgK+TNnZgzRvgK+Kb9IDkPTs5oe063eW9hUcEkZ
	LbyRgHGqQguLYW6PlwtCPAPiQRvsUFDFhiDmCR+oSVamxgvWVKql8mG8Gp2UkEJtx5WfMME8FGM
	2Bzk+N/GtCz8jWO8XEgAmzjEns/cE29mxyKEjaWPj0uH+xDCNepm3HkMkApI0SgetrPUyUVrUwv
	KISTbDpOTkKMwejZM90+HSNnN6/ZcYOPjA+5SJJuvplmGo3CWyDhlLg==
X-Google-Smtp-Source: AGHT+IHtO0lcTnjLg7RoB8oempV8RRmalCV8Gc4fgDN+BPSBAehU6IhbE6a83mK5rPASvrdvcGJqIg==
X-Received: by 2002:a17:902:e949:b0:237:d734:5642 with SMTP id d9443c01a7336-23e3b84f73emr154394105ad.41.1753076572632;
        Sun, 20 Jul 2025 22:42:52 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6ef82esm49929675ad.209.2025.07.20.22.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jul 2025 22:42:52 -0700 (PDT)
Date: Mon, 21 Jul 2025 14:42:47 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/4] rust: miscdevice: add uring_cmd() for MiscDevice
 trait
Message-ID: <aH3TVzxTlTUaDQXp@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-4-sidong.yang@furiosa.ai>
 <CADUfDZpmD-WfVsrzNOt6T6132M+EHCGtRcnQH7p0z2f3f6dBvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpmD-WfVsrzNOt6T6132M+EHCGtRcnQH7p0z2f3f6dBvw@mail.gmail.com>

On Sun, Jul 20, 2025 at 04:08:19PM -0400, Caleb Sander Mateos wrote:
> On Sat, Jul 19, 2025 at 10:35 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > This patch adds uring_cmd() function for MiscDevice trait and its
> > callback implementation. It uses IoUringCmd that io_uring_cmd rust
> > abstraction.
> >
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> >  rust/kernel/miscdevice.rs | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
> > index 288f40e79906..5255faf27934 100644
> > --- a/rust/kernel/miscdevice.rs
> > +++ b/rust/kernel/miscdevice.rs
> > @@ -14,6 +14,7 @@
> >      error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
> >      ffi::{c_int, c_long, c_uint, c_ulong},
> >      fs::File,
> > +    io_uring::IoUringCmd,
> >      mm::virt::VmaNew,
> >      prelude::*,
> >      seq_file::SeqFile,
> > @@ -175,6 +176,15 @@ fn show_fdinfo(
> >      ) {
> >          build_error!(VTABLE_DEFAULT_ERROR)
> >      }
> > +
> > +    fn uring_cmd(
> > +        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
> > +        _file: &File,
> > +        _io_uring_cmd: &IoUringCmd,
> > +        issue_flags: u32,
> > +    ) -> Result<isize> {
> 
> Would i32 make more sense as the return value, since that's what
> io_uring_cqe actually stores?

Agreed. thanks.
> 
> > +        build_error!(VTABLE_DEFAULT_ERROR)
> > +    }
> >  }
> >
> >  /// A vtable for the file operations of a Rust miscdevice.
> > @@ -332,6 +342,25 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
> >          T::show_fdinfo(device, m, file);
> >      }
> >
> > +    unsafe extern "C" fn uring_cmd(
> > +        ioucmd: *mut bindings::io_uring_cmd,
> > +        issue_flags: ffi::c_uint,
> > +    ) -> ffi::c_int {
> > +        // SAFETY: The file is valid for the duration of this call.
> > +        let ioucmd = unsafe { IoUringCmd::from_raw(ioucmd) };
> > +        let file = ioucmd.file();
> > +
> > +        // SAFETY: The file is valid for the duration of this call.
> > +        let private = unsafe { (*file.as_ptr()).private_data }.cast();
> > +        // SAFETY: Ioctl calls can borrow the private data of the file.
> 
> "Ioctl" -> "uring cmd"?

Thanks it's a bad mistake.

Thanks,
Sidong
> 
> Best,
> Caleb
> 
> > +        let device = unsafe { <T::Ptr as ForeignOwnable>::borrow(private) };
> > +
> > +        match T::uring_cmd(device, file, ioucmd, issue_flags) {
> > +            Ok(ret) => ret as ffi::c_int,
> > +            Err(err) => err.to_errno() as ffi::c_int,
> > +        }
> > +    }
> > +
> >      const VTABLE: bindings::file_operations = bindings::file_operations {
> >          open: Some(Self::open),
> >          release: Some(Self::release),
> > @@ -354,6 +383,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
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
> >

