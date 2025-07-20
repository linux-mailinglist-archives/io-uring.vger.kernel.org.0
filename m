Return-Path: <io-uring+bounces-8750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE99B0B820
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 22:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66431786C6
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 20:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656F6223DCC;
	Sun, 20 Jul 2025 20:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OsMS6MzU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E88198E9B
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 20:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753042114; cv=none; b=fKToi7a6vhLZINWfQupma1sCW42dun1V0IPmklAzPOs829eVkVGeKs9PrO9TKvYGSAOD1nrqY6pWCUCYq2TZ6FNHxFus45CZNAMjF9sI7hHVV39y/D3foj2D47KXsJslvwR3bwpDEohnOh5nO88dcL/vkqnKCrndl+ILXy/aIUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753042114; c=relaxed/simple;
	bh=J/7Fc/QpzUgpXO7zmJ/OT95lQ2BAuYRUnREhDO+LsAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j7OaitmyyWZ+PwCFs5+XaweTBwkOCzoSrhSdnXo1j2XAyE5luWPZFMD8Cj0aXqNdqr7Tp164FARGeY9PJjuO+QZZUmqMdYz5UIKX19iWjMlOT85P5cmtSLZOSqFUhpcy6Kh6nb+erUFq2xZJhfyYxz1lwaeOU1x6IDdOfSGxhc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OsMS6MzU; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-313862d48e7so482966a91.1
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 13:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1753042111; x=1753646911; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FaUug9j/ES4fbNfuO+z+Ul6c6g1fwo4/5ELhjBw/6Z0=;
        b=OsMS6MzUFDSSxJm217x2QswfdO+bkE4ISZnkYYeTg9/V6X7knd4O6NAbLl296/yXQY
         BqXVHM0wi/PMqcb2SWCzgJvdhg9wfQoUCUBBq5tbcmKi+uS8ZXR7x7Eae7WF9nLQJMSg
         u5Zk8HWJU/OgiRq1BEgpdaSNQ5AGY4DYMZ5TJXATsJ/A6yash1aKLGenkht6Ifgjh9Y6
         1Xe7eOOfUtPZFclowhV5ydZFcvhi4nj7iwJnbpNJiPE8BD77cdmk2rJ7fgY/z3VyJpgB
         ug9wC18tkbQF5jXRa5dSzo02xZ4jfAbbjRkMhL5St9J5OYg6nrtNqRLog8tCs4ZzBCTs
         uSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753042111; x=1753646911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FaUug9j/ES4fbNfuO+z+Ul6c6g1fwo4/5ELhjBw/6Z0=;
        b=iX+owFCxqPMwf4Mgn5DFqtlwfpb+/+G6pxbLwnq8tgWzoqW8v7QjRrazH54PfmuF3O
         YZ8s6gYyYPpOqcegnVH84xayKPVKSWCwtlSREGgmPjUqcn0iV8hGRBtuWm7HUMBR6tmN
         uOCD5tGx53gV75p7m1JANTlKcDzLzij/VudYThoN/XO2EBwciRDsR2GYa88sSodbAVSG
         TywuujSQfUcVyRqonV+6Fefy0JJyrpnCPS8yD3aL0lzB5b8ym3u74bVAboq+gm1Hua0Y
         wGim3Tso2OHT0tVP3GI607p2oYOZIPu599w7di/4JZH2B9POy1qsToq9BeiFxu4vaYer
         tntw==
X-Forwarded-Encrypted: i=1; AJvYcCWX0M7K5mAD0+4VcJRW/L+1lrpxtcqa2XsN0XmaQV732/yhExa6p3LJlnjTOF+QFYQqEZPzhqWEnw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6HC8cmj1JjmSHp7eHRMPNPpkSqpmCydI/FL0/AfTAU7trwTLu
	wzzcwg/616lRDXPxS/vFa6KE9wDMiihgg7EPhfJEoqfluEjnIEtlzpzUCTkXTuCBndA0a3cQcbR
	vtF0KudGPKCFXsSYBEJ1eg4zxd3zLAebHbQPNRrxj9w==
X-Gm-Gg: ASbGncu2yAI57H+SpwDaYxbN3oec+yypZSru92pSGbHWv/HSPKdubCQNZUaUrgk7QEG
	0nz4fDgoHcvxFerG6gg6+hMzMuM8UEk2egJ+Mwm6Ue5a61BAUKyz1S38yH4x9gA4klN39Xzk2kX
	4jncpD304giw4DP5G1CDo4LQ68nQ1xkdAyLC5zcnAox+xk97AnL09k2wm+fd7sdtuUmnZbkJGSA
	fWbZQ==
X-Google-Smtp-Source: AGHT+IEzTmgD8p4pr9Tfl5/Taoe4sD4F6Nle8HtVc5uEQ8POQMmqP9OC6lKvh4Ws583yP1jesyveQ6kid0S8/J/BHAg=
X-Received: by 2002:a17:90b:2b50:b0:314:2d38:3e4d with SMTP id
 98e67ed59e1d1-31c9e77383cmr9996215a91.3.1753042110780; Sun, 20 Jul 2025
 13:08:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai> <20250719143358.22363-4-sidong.yang@furiosa.ai>
In-Reply-To: <20250719143358.22363-4-sidong.yang@furiosa.ai>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 20 Jul 2025 16:08:19 -0400
X-Gm-Features: Ac12FXxOPo-pFYT0-B55olhKbNgyH3no8Zup6CAghCTc0O_WDe6kK1cfGWsTteo
Message-ID: <CADUfDZpmD-WfVsrzNOt6T6132M+EHCGtRcnQH7p0z2f3f6dBvw@mail.gmail.com>
Subject: Re: [PATCH 3/4] rust: miscdevice: add uring_cmd() for MiscDevice trait
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 10:35=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.a=
i> wrote:
>
> This patch adds uring_cmd() function for MiscDevice trait and its
> callback implementation. It uses IoUringCmd that io_uring_cmd rust
> abstraction.
>
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  rust/kernel/miscdevice.rs | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
> index 288f40e79906..5255faf27934 100644
> --- a/rust/kernel/miscdevice.rs
> +++ b/rust/kernel/miscdevice.rs
> @@ -14,6 +14,7 @@
>      error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
>      ffi::{c_int, c_long, c_uint, c_ulong},
>      fs::File,
> +    io_uring::IoUringCmd,
>      mm::virt::VmaNew,
>      prelude::*,
>      seq_file::SeqFile,
> @@ -175,6 +176,15 @@ fn show_fdinfo(
>      ) {
>          build_error!(VTABLE_DEFAULT_ERROR)
>      }
> +
> +    fn uring_cmd(
> +        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
> +        _file: &File,
> +        _io_uring_cmd: &IoUringCmd,
> +        issue_flags: u32,
> +    ) -> Result<isize> {

Would i32 make more sense as the return value, since that's what
io_uring_cqe actually stores?

> +        build_error!(VTABLE_DEFAULT_ERROR)
> +    }
>  }
>
>  /// A vtable for the file operations of a Rust miscdevice.
> @@ -332,6 +342,25 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
>          T::show_fdinfo(device, m, file);
>      }
>
> +    unsafe extern "C" fn uring_cmd(
> +        ioucmd: *mut bindings::io_uring_cmd,
> +        issue_flags: ffi::c_uint,
> +    ) -> ffi::c_int {
> +        // SAFETY: The file is valid for the duration of this call.
> +        let ioucmd =3D unsafe { IoUringCmd::from_raw(ioucmd) };
> +        let file =3D ioucmd.file();
> +
> +        // SAFETY: The file is valid for the duration of this call.
> +        let private =3D unsafe { (*file.as_ptr()).private_data }.cast();
> +        // SAFETY: Ioctl calls can borrow the private data of the file.

"Ioctl" -> "uring cmd"?

Best,
Caleb

> +        let device =3D unsafe { <T::Ptr as ForeignOwnable>::borrow(priva=
te) };
> +
> +        match T::uring_cmd(device, file, ioucmd, issue_flags) {
> +            Ok(ret) =3D> ret as ffi::c_int,
> +            Err(err) =3D> err.to_errno() as ffi::c_int,
> +        }
> +    }
> +
>      const VTABLE: bindings::file_operations =3D bindings::file_operation=
s {
>          open: Some(Self::open),
>          release: Some(Self::release),
> @@ -354,6 +383,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
>          } else {
>              None
>          },
> +        uring_cmd: if T::HAS_URING_CMD {
> +            Some(Self::uring_cmd)
> +        } else {
> +            None
> +        },
>          // SAFETY: All zeros is a valid value for `bindings::file_operat=
ions`.
>          ..unsafe { MaybeUninit::zeroed().assume_init() }
>      };
> --
> 2.43.0
>
>

