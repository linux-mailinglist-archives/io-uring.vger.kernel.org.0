Return-Path: <io-uring+bounces-8751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4F2B0B824
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 22:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED729178955
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 20:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938F9224AFB;
	Sun, 20 Jul 2025 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bRz4bSWC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD271D27B6
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 20:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753042875; cv=none; b=F+39NzYEB/X15sAhYIuScigX1o3V0M34LHSyLOkCPe1qwZR/t8syyPaLjQ0/UXfEmt07FnrbnTcRoJGWviJ4lhbPnzlq4xXX//YyS/rgPKNv04mNspwJOVmezRKCR4m9kGHziEfATHtDeFAlmWx990STW/GgHmwQCntXEmuMrok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753042875; c=relaxed/simple;
	bh=i3OpDp6GUcBgyD7nVFA8rvtMwYwGqH2Ruhus24O6PMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ud+Pvxx0zvLHfprcj/7ws2WywCpfNATZttxWQnt8kvZs5mMau/H62mBI3AQciRHWrM2Z1fI0x1f3oJLTA4NbcICeI89TUw14ppFh0/XmKloG077P2/1v6cxs5HXIWLModO5MdNfbx5KKvVVwK22idnGzAZWYonbX6owiq4DWraE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bRz4bSWC; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31308f52248so559499a91.2
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 13:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1753042873; x=1753647673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgQF+os2zt2fS8ZD9Pne7S+zqukANXwnLxzYWaaxPso=;
        b=bRz4bSWCPEuiQOTpFjJevbjlXEAGW88ptuzqAlU/7wxjffaxopVGZwY1+JnjUqPQJ+
         LgNfVp+F5EjGVPAfxCc/HbFjhDrMClkLARamxgHK2a+8KNNlPzArNfc6F9Hu02GKKJL+
         YJD1R3nDLIVR2rubH3GmdzL+tvFMQxVL8GhIPV8gyIkHVY0aNGj5W2dPcX5mBgpBwcn0
         /hbvU+mMqDB7aIhBTSVYRN2+A8U4ykENmktFREa7oxqoeyRQSKUA8O3TkmyTIO2J80Nf
         muUssel6yh/1xcZHRpv9UjnhKpT3UdD/bzDY+plLVuKUc1tyK1CzIowlQVbHKJdvGIgx
         YkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753042873; x=1753647673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vgQF+os2zt2fS8ZD9Pne7S+zqukANXwnLxzYWaaxPso=;
        b=OrktI35ip/veQydfuoGn5Df/sOsCo/r0gG0A2MLE+3sAm7FtMPFbOIDbCRJubNsYph
         FtSDlkmDLH8sUxeaWR0ncrSTj8n3w1hbT7bO46i2AA7mP952JSG3WWvWmy/U0sG37CdX
         aDF0Sf5XcaedWMAiy19RbUSj70T18kCC8fasqg7acaWkJncJQtsl+qONW3sqYReooo/R
         40SsecL+ZbhNo3QI7/b6Y7kQjqAEFBCvvuN+Ut0aEWo573K8U159MWkSoptK4h3Xrc+h
         /p+m79CM9WidmDh17+jhh/X8qgA+ONqXMuEuT1f5BHjf+WFSSKv2JjNB4goN/L5pSPxI
         k0ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp5SBGJtxk5OeXVQupkbGNTBLbKKT0FDD/7OCfb62hl52U0SOkapxWkiHBGHTWpqNG1CG7xMW/2A==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywno/WMI+NDl+lPzMwt5yp2AfW1/oH8hXntfcvPnuA4n+bre9q+
	i+yF/lK52Ty/NbCU2idvShUufoJz4juD/qh+f0gTBiwT3Sf4WNPOKi5hYrxierN+9qzs6OxnsyD
	I29dZ0zkAgLHhYjrZt1t2KZdVH9fs3+8gx+qDLLos5Q==
X-Gm-Gg: ASbGnctNRxr2e4pwH553VZqRI4QYsZuTlGqhzHO+U6gIVnHvNclgab8rvzkL3LyAPI1
	HaVjB8yWmJ9NVLq2B9bVqJP7jfF9uXng79AEDtAR2kfC+hToNWE5+n4pxhnu42K94+XlK3nA6C0
	B5u0cmONqWZcwwHpmViQf91/a4sV9wTj92dyxMbYzFUFzymqV3zyN+Nog6SmrUBQOLJRZeIDe5+
	PlwfQ==
X-Google-Smtp-Source: AGHT+IEWxc8ZXBpGnuH7BtjlkjbLy1+k0TfoVszqQadn+Lip/Uf9JIC2KIrML2pi3hIF+AZtqdaq/0v/JpXSmKvLfhg=
X-Received: by 2002:a17:90b:5610:b0:312:1ae9:1537 with SMTP id
 98e67ed59e1d1-31c9e6048aamr12302789a91.0.1753042872549; Sun, 20 Jul 2025
 13:21:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai> <20250719143358.22363-5-sidong.yang@furiosa.ai>
In-Reply-To: <20250719143358.22363-5-sidong.yang@furiosa.ai>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 20 Jul 2025 16:21:00 -0400
X-Gm-Features: Ac12FXyNBpWr6ecWxgZNuFpVIAdDVVSKNB1T_-1vERAcvQs9WnfiPq_xSp5xYWw
Message-ID: <CADUfDZqv_KEhUaS58CuZDPB8PvcigxBFDJSPY_Kq9WFViug4+w@mail.gmail.com>
Subject: Re: [PATCH 4/4] samples: rust: rust_misc_device: add uring_cmd example
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 10:35=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.a=
i> wrote:
>
> This patch makes rust_misc_device handle uring_cmd. Command ops are like
> ioctl that set or get values in simple way.
>
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  samples/rust/rust_misc_device.rs | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_de=
vice.rs
> index c881fd6dbd08..cd0e578231d2 100644
> --- a/samples/rust/rust_misc_device.rs
> +++ b/samples/rust/rust_misc_device.rs
> @@ -101,6 +101,7 @@
>      c_str,
>      device::Device,
>      fs::File,
> +    io_uring::IoUringCmd,
>      ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
>      miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
>      new_mutex,
> @@ -114,6 +115,9 @@
>  const RUST_MISC_DEV_GET_VALUE: u32 =3D _IOR::<i32>('|' as u32, 0x81);
>  const RUST_MISC_DEV_SET_VALUE: u32 =3D _IOW::<i32>('|' as u32, 0x82);
>
> +const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 =3D 0x83;
> +const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 =3D 0x84;

In real uring_cmd() implementations, the cmd_op values are assigned
using the _IO* macros, same as for ioctls. But I suppose that's not
strictly required for the sample driver.

> +
>  module! {
>      type: RustMiscDeviceModule,
>      name: "rust_misc_device",
> @@ -190,6 +194,32 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd=
: u32, arg: usize) -> Result
>
>          Ok(0)
>      }
> +
> +    fn uring_cmd(
> +        me: Pin<&RustMiscDevice>,
> +        _file: &File,
> +        io_uring_cmd: &IoUringCmd,
> +        _issue_flags: u32,
> +    ) -> Result<isize> {
> +        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
> +        let cmd =3D io_uring_cmd.cmd_op();
> +        let cmd_data =3D io_uring_cmd.sqe().cmd_data().as_ptr() as *cons=
t usize;
> +        let addr =3D unsafe { *cmd_data };

The io_uring_sqe is user-mapped memory, so this load needs to be
atomic. In C, the uring_cmd() implementation would use READ_ONCE().
Sounds like Rust code is currently using read_volatile() (with a FIXME
comment to switch to read_once() once that's available).

Best,
Caleb

> +
> +        match cmd {
> +            RUST_MISC_DEV_URING_CMD_SET_VALUE =3D> {
> +                me.set_value(UserSlice::new(addr, 8).reader())?;
> +            }
> +            RUST_MISC_DEV_URING_CMD_GET_VALUE =3D> {
> +                me.get_value(UserSlice::new(addr, 8).writer())?;
> +            }
> +            _ =3D> {
> +                dev_err!(me.dev, "-> uring_cmd not recognised: {}\n", cm=
d);
> +                return Err(ENOTTY);
> +            }
> +        }
> +        Ok(0)
> +    }
>  }
>
>  #[pinned_drop]
> --
> 2.43.0
>
>

