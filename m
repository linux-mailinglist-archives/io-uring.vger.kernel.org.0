Return-Path: <io-uring+bounces-8754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0604FB0BC14
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 07:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFAC93B9A95
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 05:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDA31DF75A;
	Mon, 21 Jul 2025 05:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="alce6hbV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5DB1BD035
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 05:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753076749; cv=none; b=FU0TZR396maRewaN75uljNL+ROozDfEug5EFsQ+djmQ6yb8eOmAIv3/IHwkE5raz5Ec5T4MQoWqlc6w52mRckV/T7SDaKBhe6lHQulqD7jL1ZZxssFUvZH6FzabQwlUOEzIvkHdxJoOtL9HmgN7Fwg38r+K7WdHz/p54xCMf9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753076749; c=relaxed/simple;
	bh=dhHkGM4HOFFI97fX7h+8fak0kAldA+FYKGT9ABTfj+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctMBM7gteuNCU8euiMVUlb8HjRn78pPTu4sBo9hyTpMTuKbvBJtmnhfkt77WnEvXmumLr17sZpf2adtGhvAILzWkKAH3tq/5OVAOHtwJ6nFIELevL1OFx9rrkbFNMZEDDJqTtglCdn6Wwq6rUy8UCuNTlp0kIFXr7XFoVY7aqI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=alce6hbV; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-748d982e92cso2596859b3a.1
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 22:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753076747; x=1753681547; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Villbo2O3xbSxL7XAkPoEJ4g9IjLoflfkAnI89yF/Y8=;
        b=alce6hbVxZIsnLlNaqV/jMqKXlRVnl2l13Nk3DSceKWPtwsuRTHfXi05RT91Pf/U8L
         iedrYDOR4wKvhqZNz5Fm6wKLwOiY3f2Eo5iukll3O9xk8oTBJCv4r3DJv2tG86UXP3JU
         lw8qhaSqchHYIXKw9OM+hl0LCg8d2c+P+FmXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753076747; x=1753681547;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Villbo2O3xbSxL7XAkPoEJ4g9IjLoflfkAnI89yF/Y8=;
        b=XME7+hZRsjCojiLPZ3WndmJoWJD+iiGYUEXZnCvkpBqDvROW655TMMdrDc/1Ypp+iI
         XCZm3+QstGnUy0seb85eZMRiyE/2NYlXN8cjbPhojI71QLIHtiwXx8gof4cQHDWMfY8B
         njTRm2LEmy82APtvw4RWjdVTZ5jVcx+v9wLkZ6TrRXmiyqxdvllc6qT3Dqx8xJBmUe/I
         WFoTO9EGupZvl8s00SXkYoMZqLfil7LO/QS9U9GPzJgWgeya0vIA7omUx1lFy1wsRdFF
         xlGdzAuFzEYtAzEn3a4Fg8OWNsPFet8JiTx90/xN/kMKff007DonWbYHPuTkk/B5O//a
         Shcw==
X-Forwarded-Encrypted: i=1; AJvYcCVpl6ETiQ8FCcErq3h99NdjBLqIOM4JZPaVHHFvj8OPXGFTh4/kBEasKkYabQPgb0CJVq/lNnshNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YznnJy/RygIG07RA5JRSeTmkNYOLFMiJCnD3uswXVZ73lO7raAm
	ZiRYuG4BF/92Xih/fuB3bSbV4RBww5dm3ynTuhDSRwQWEJWbwR8AWRsYvJL+XjiO67kgGE42UNc
	ZYfNa
X-Gm-Gg: ASbGnctwlpD94D9qObkxdz1Sd/Ifpq/0D0YWzT74b871a8MB05keQ7NhoAkmrZI3vgu
	9IPif03sItowgU6YKwEOjYHf21DDT8qPpbKTtZZg5u2CrKfUvM64xnssStGB5RbCAseKX62AzId
	hmN8xS95Gd+34Dv6Z7Ziu7wZmWQI4MLXqMEal8dz11o68bYWnGbTc45VXwDoVgrVFIEYxSgBeAm
	P3igpVx2JXWh58cvGbrymegAvfSWRCw+E9F4gToIK5CuHtUFuDcNOpDM0xwtbBT0ANPlfBS9z2s
	/NxCz+E84gRwZgS3GXbclhUZBaTlxlWPFgUTYKCQLbPlMCMXy5oYHIUhzPLiboQvIBoEXaNJgu2
	jeFcXTOjDpF8FwBJ8Y7ex22bLhK5i26cBN28kHDi09mMq7bO1VHAkvQ==
X-Google-Smtp-Source: AGHT+IFUVUK6qkClKAF7WZOshF2ErH+fD4E7lxm5DovPekHz1U5qqyaeOww9M5SA2fLd7fbp0Ylvqw==
X-Received: by 2002:a05:6a00:2ea6:b0:74e:a9ba:55f with SMTP id d2e1a72fcca58-756ea8c31f7mr25241718b3a.20.1753076746713;
        Sun, 20 Jul 2025 22:45:46 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759cb774da4sm5044116b3a.122.2025.07.20.22.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jul 2025 22:45:46 -0700 (PDT)
Date: Mon, 21 Jul 2025 14:45:41 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 4/4] samples: rust: rust_misc_device: add uring_cmd
 example
Message-ID: <aH3UBei_VL25P0PK@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <20250719143358.22363-5-sidong.yang@furiosa.ai>
 <CADUfDZqv_KEhUaS58CuZDPB8PvcigxBFDJSPY_Kq9WFViug4+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqv_KEhUaS58CuZDPB8PvcigxBFDJSPY_Kq9WFViug4+w@mail.gmail.com>

On Sun, Jul 20, 2025 at 04:21:00PM -0400, Caleb Sander Mateos wrote:
> On Sat, Jul 19, 2025 at 10:35 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > This patch makes rust_misc_device handle uring_cmd. Command ops are like
> > ioctl that set or get values in simple way.
> >
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> >  samples/rust/rust_misc_device.rs | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
> > diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
> > index c881fd6dbd08..cd0e578231d2 100644
> > --- a/samples/rust/rust_misc_device.rs
> > +++ b/samples/rust/rust_misc_device.rs
> > @@ -101,6 +101,7 @@
> >      c_str,
> >      device::Device,
> >      fs::File,
> > +    io_uring::IoUringCmd,
> >      ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
> >      miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
> >      new_mutex,
> > @@ -114,6 +115,9 @@
> >  const RUST_MISC_DEV_GET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x81);
> >  const RUST_MISC_DEV_SET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x82);
> >
> > +const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 = 0x83;
> > +const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 = 0x84;
> 
> In real uring_cmd() implementations, the cmd_op values are assigned
> using the _IO* macros, same as for ioctls. But I suppose that's not
> strictly required for the sample driver.

Okay, I'll use same _IO* pattern with ioctl.
> 
> > +
> >  module! {
> >      type: RustMiscDeviceModule,
> >      name: "rust_misc_device",
> > @@ -190,6 +194,32 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
> >
> >          Ok(0)
> >      }
> > +
> > +    fn uring_cmd(
> > +        me: Pin<&RustMiscDevice>,
> > +        _file: &File,
> > +        io_uring_cmd: &IoUringCmd,
> > +        _issue_flags: u32,
> > +    ) -> Result<isize> {
> > +        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
> > +        let cmd = io_uring_cmd.cmd_op();
> > +        let cmd_data = io_uring_cmd.sqe().cmd_data().as_ptr() as *const usize;
> > +        let addr = unsafe { *cmd_data };
> 
> The io_uring_sqe is user-mapped memory, so this load needs to be
> atomic. In C, the uring_cmd() implementation would use READ_ONCE().
> Sounds like Rust code is currently using read_volatile() (with a FIXME
> comment to switch to read_once() once that's available).

Yes, I've missed this. read_volatile with comment would be good.

Thanks,
Sidong
> 
> Best,
> Caleb
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
> >  }
> >
> >  #[pinned_drop]
> > --
> > 2.43.0
> >
> >

