Return-Path: <io-uring+bounces-8895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C687B1D27B
	for <lists+io-uring@lfdr.de>; Thu,  7 Aug 2025 08:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26C918C6517
	for <lists+io-uring@lfdr.de>; Thu,  7 Aug 2025 06:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2F11F0E2E;
	Thu,  7 Aug 2025 06:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="AAijQIdX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56DB4438B
	for <io-uring@vger.kernel.org>; Thu,  7 Aug 2025 06:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754548233; cv=none; b=r7ER6/Z6wxlB7xMB26gPaE8ML4ZjahZbaUYVWH1+VdhcGK72im8MjsLAPloeL9mAu8nOYOTuWLg7XJaByIlPZNX9AJACbQ6RtVA4EozZ2jwKuhc6ODZlS8YAj6mLJ9VDfcnH2XigPwTKSj4cg5++C31gd96cg5kVF7aAY4k7uFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754548233; c=relaxed/simple;
	bh=W4Ntc/RXCgzof9r/wW7PYUdE+EvS34VpqJHY8J5Ynjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IV1tkfoq5YPbipJ7OmnWwD30GRHW/r1PcB3+EhJjVUnooqezn9T9riRDS6WUOjJzLDzJ/Fu2oMRF/35JqFmm3659XfzKWcHgWZFH7cABS2bUU0Daw1mLt2rkoAibZXoA/HF65TU45yzKVyDzdr99FQvQpbhyTTvHFgjMZGoCTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=AAijQIdX; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31ec651c2a1so624087a91.0
        for <io-uring@vger.kernel.org>; Wed, 06 Aug 2025 23:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754548231; x=1755153031; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NHg/kg8wRYm35acAFO3iPCap79otzywrEHg5wfyd+eA=;
        b=AAijQIdXYywNmBPLsCeAtVg0GiPGyVqIHUuJN+DjHpXqA/txzuIaX3kPM7RulvG+gN
         KIP5Ru6n9CieTrGeky9uELtFXvBcG52EwNUJeVxlznRyrkhwmkr0ucvcWlAXnzmOqMWs
         5+bdpFEYqSK5DYEtPXZlEP8jm0nP+k8VF0iKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754548231; x=1755153031;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NHg/kg8wRYm35acAFO3iPCap79otzywrEHg5wfyd+eA=;
        b=iLyVV5sFUyldpYlo074Dr3I8TKdyjPrGURA7SpdKva8BkSTlyr9Gpn6P3E0Z5I5zS8
         zyhDmxFbLAvt2aTmBK1TM/kc5cMkc6dwWs0ekJ5be+nL+gHUPxef0FMOjPxkG3mRkt9B
         6s1lBuI32hsB5ZL+CmjuSNt7Sy3eGPR0OueOv+ejBgJI+s0waDg/0pELANU8V4rgg29M
         Y+O8ZKkdapjBXWZRtQVhJ4KyMUEhRSwKn4JSEZdILFyu0U4AZIcxmgvinFfC88Czk1ns
         YnuyYD+ZHXHajiIOsMibEKlGfT8o9o1pxE6ZtNQd0KIJbWgRAqGr1v39eThG7+MYbAVR
         de0w==
X-Forwarded-Encrypted: i=1; AJvYcCUeSyAqX/FOV06Gl4g+J4suJlgI2ytW3AWCp52+/4/mMaSNyVxZU3d0qrD8rsJo8HPceeNd5WOsgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcCGA6vXGx9mduaByYfcUDzNE4oYS/Ij5JfmK0MFUCDUyB+pAL
	xy+TkRahlxjsk5HZVa2P6HjRiWdCBElt4l0MHpJ/YibHsdB6znNRTX9uBlSoxjAZQzk=
X-Gm-Gg: ASbGncuHHDNeHA45yzrjhaB02FqwJO4nJpbD+ir9S41V5bxUJNoV5WLziJ1co5vL/mv
	gtvsVdWcjx72yGbxo9F0GnJe/fTp0ksgA9a8kioCpfpgYOH/h4HaHZlshF8WDUQ9F7KM0kOEPex
	OyvwRCrO5O6Gnb9cIjeDWLe0IjNxW6N54Kad1VvXyjoT2dGZVppKoO3NE6ZijNIZ+Iiz7K4veIG
	5K69wfdZfHX883avKQ6IoLBXEpuMjUoeDEg3aKSNKsSG2MBZuz4ZiMxsrbqi89YzxSqB6JQEcDy
	PILIOg7OFps21WmvjhS9V+dP5Aq1YgdAnXX4Npd2XumuKibE4sF1B+dzNyxL698PiklBMGIyElo
	gt0DQaRRWua2c0HTI7JhSAGrJBtTd1mZ2jDeAk2t0jk9TvxY0NM5DPr84
X-Google-Smtp-Source: AGHT+IFyhmlc2YddIOuQEtwwCm37dwdpwh/ZM6p9/UE2n0ZuCrgqX9U0YOdGYYTtZz7OZP7SEVvq+A==
X-Received: by 2002:a17:90b:586d:b0:31f:1757:f9f8 with SMTP id 98e67ed59e1d1-321675202f4mr5934157a91.22.1754548231043;
        Wed, 06 Aug 2025 23:30:31 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63f33e58sm21352178a91.33.2025.08.06.23.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 23:30:30 -0700 (PDT)
Date: Thu, 7 Aug 2025 15:30:25 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] samples: rust: rust_misc_device: add
 uring_cmd example
Message-ID: <aJRIAUwlIJkJ9jxV@sidongui-MacBookPro.local>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-5-sidong.yang@furiosa.ai>
 <B650673C-E2C8-4382-A86D-CD44840F5B21@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B650673C-E2C8-4382-A86D-CD44840F5B21@collabora.com>

On Fri, Aug 01, 2025 at 11:11:44AM -0300, Daniel Almeida wrote:
> Hi Sidong,
> 
> > On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > This patch makes rust_misc_device handle uring_cmd. Command ops are like
> > ioctl that set or get values in simple way.
> > 
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> > samples/rust/rust_misc_device.rs | 34 ++++++++++++++++++++++++++++++++
> > 1 file changed, 34 insertions(+)
> > 
> > diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
> > index c881fd6dbd08..1044bde86e8d 100644
> > --- a/samples/rust/rust_misc_device.rs
> > +++ b/samples/rust/rust_misc_device.rs
> > @@ -101,6 +101,7 @@
> >     c_str,
> >     device::Device,
> >     fs::File,
> > +    io_uring::IoUringCmd,
> >     ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
> >     miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
> >     new_mutex,
> > @@ -114,6 +115,9 @@
> > const RUST_MISC_DEV_GET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x81);
> > const RUST_MISC_DEV_SET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x82);
> > 
> > +const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x83);
> > +const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x84);
> > +
> > module! {
> >     type: RustMiscDeviceModule,
> >     name: "rust_misc_device",
> > @@ -190,6 +194,36 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
> > 
> >         Ok(0)
> >     }
> > +
> > +    fn uring_cmd(
> > +        me: Pin<&RustMiscDevice>,
> 
> "me" ?

ioctl() uses the args name with "me".

> 
> > +        io_uring_cmd: Pin<&mut IoUringCmd>,
> > +        _issue_flags: u32,
> > +    ) -> Result<i32> {
> > +        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
> > +
> > +        let cmd = io_uring_cmd.cmd_op();
> > +        let cmd_data = io_uring_cmd.sqe().cmd_data().as_ptr() as *const usize;
> > +
> > +        // SAFETY: `cmd_data` is guaranteed to be a valid pointer to the command data
> > +        // within the SQE structure.
> 
> This is what core::ptr::read_volatile says:
> 
> Safety
> Behavior is undefined if any of the following conditions are violated:
>     o src must be valid for reads.
>     o src must be properly aligned.
>     o src must point to a properly initialized value of type T.
> 
> You must prove that the pre-conditions above are fulfilled here.

Okay, I would describe pre-conditions.
> 
> > +        // FIXME: switch to read_once() when it's available.
> > +        let addr = unsafe { core::ptr::read_volatile(cmd_data) };
> 
> So drivers have to write "unsafe" directly? It isn´t forbidden, but
> we should try our best to avoid it.

I don't know it's the best way to use &[u8] `cmd_data` in driver. The driver should
cast the `cmd_data` to user structure i32 in this time. is there any safe way
to provide safe interface for user driver?

> 
> > +
> > +        match cmd {
> > +            RUST_MISC_DEV_URING_CMD_SET_VALUE => {
> > +                me.set_value(UserSlice::new(addr, 8).reader())?;
> > +            }
> > +            RUST_MISC_DEV_URING_CMD_GET_VALUE => {
> > +                me.get_value(UserSlice::new(addr, 8).writer())?;
> > +            }
> > +            _ => {
> > +                dev_err!(me.dev, "-> uring_cmd not recognised: {}\n", cmd);
> > +                return Err(ENOTTY);
> > +            }
> > +        }
> > +        Ok(0)
> > +    }
> > }
> > 
> 
> Who calls this function?

This function would be called in io_uring subsystem. In detail, there is caller
io_uring_cmd() in io_uring/uring_cmd.c. When io_uring subsystem noticed that
submission queue entry which has uring cmd op pushed to submission queue, it
would be submitted and actually calls this function.

> 
> > #[pinned_drop]
> > -- 
> > 2.43.0
> > 
> > 
> 
> - Daniel
> 

