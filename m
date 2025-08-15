Return-Path: <io-uring+bounces-8972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2F5B27E7E
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 12:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28F001B64A22
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 10:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 656252FC86E;
	Fri, 15 Aug 2025 10:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i57ytt/V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD0021FF5D;
	Fri, 15 Aug 2025 10:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755254446; cv=none; b=WAEke12Swdl1oohjWt6Nydl8+JPwV5CHMIGAdPrc5VOIsZiVIRYDoBHf2XegWA2DwmvJxY8lR/Yo2f/Uq6ktMXCGuTAv6cM6vFFysj2baNaode9OW06yypa2FLkrcE9x2O3Lkq9JxDgbSeHL8ICXBr9/EACd7why+fQaEozls4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755254446; c=relaxed/simple;
	bh=T2zmVJzu63dIJxj/InbZiHhVIQ76K9RRNnQS9NdUg6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q11eYRk4fKlCz7P8XNBK77oo2za+ZnL0MgoR+urquyasdWibccQF941YmvTOO3xQSZDCLFfrno8uZ6ZIva58qhadFkXXU+z2QeM3r2SZ2pVsuFUYX31TvVVxyVKHsaQj8OYoapzcvhztPBQEWZPM3HcnkcJxwVVNTS1yo5KbiTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i57ytt/V; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6188b656159so3016261a12.1;
        Fri, 15 Aug 2025 03:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755254443; x=1755859243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6saLdyCKyWgYTitSChnqlSV/HwqtSRKtrlc/BKwH1uI=;
        b=i57ytt/Vw8aiZKmJdDEEQSBwQE8Zqyg/lx7adk70ut8tRz1DP1MCqjUMgjpLyYt/6K
         4UCwe/09jSd4jrvZf0IUNHyGIktFTHvJB+367SwTv3i2lOrTS8OmbdFVvyRCn22YhUdm
         G3aZ4XorcWTVz41kL3YavONjJjw9J8/EQ+D0cOja3hsZwPAUQYjnXKJvZx8Q8mszEwgB
         //dHJfl8Mu4eC44l5RK6Xd6l89TNgq2WRfXOUlT8C9eHlzGf4U+JJ7/rcXrDR+gzUURj
         i5hS4/px1Zdi2W/VNSMJHt98Lm0RQYfkpYa87aoaKuEnueA0xm6LHa5hpDwiiCwPU6G3
         6qDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755254443; x=1755859243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6saLdyCKyWgYTitSChnqlSV/HwqtSRKtrlc/BKwH1uI=;
        b=oCURSa2wwMwM9wtZHw4qedBOiMYDPM2yG+/as9lYEuoZcT35+zxEYqTNefbQNN5zJm
         QR2YMp2y4Cg97ceNEFxxXDEMRgOELNXbbWVKBknUyrZD+YFa753dQdDeoh+7onlg5bQU
         JM2Q2C5u/ajObvuVcv5M31iolqNJ9wOQ5rTohFFwakLzfFHMQJ00fvZj6u87XRhJ5SVW
         kbE9UDV6eQbD1CLw/RqAmtfeiI0FsEyBWF7DpymVxLdo7JEZfotMSh71pRnziSA3hm9r
         1Z695cWAsQoZ0DRtWI/cH6Z6lrrMayMm7BdCx6Hq1PClMQTG1HGq46WgURZeYntLmEVR
         3CkA==
X-Forwarded-Encrypted: i=1; AJvYcCXk2cXbUfDVPRaRlR4bdIhnmCv1PXvv9v8sZA9Qq61lqmPnKeU+EanzHCjCpJzjZlzQIsyMz8lQiVVt@vger.kernel.org, AJvYcCXu95VMmtUiEKy6gVF3+4OrC9YL6/JUjkf/nKVNUFH99wstDIsiiSSn6ekS73XzZOUI6OKAtIwATa9GGdRP@vger.kernel.org
X-Gm-Message-State: AOJu0Yygg2NlVL1nAv/pugx5k3u+SZNyizJF9VpKrUMhhIL2Fb9CLWtR
	lGscWmAL1jFg0uorfrwm6ew17DBNiqrEh+ACUhJJqDuuLLLVLMIrXgsEeFKLEW8R89Xl85VWR39
	5wRdFxfvwgSAis/3pJHlNAK8M9Aoduac=
X-Gm-Gg: ASbGncthVluSaBW/S89xgFuuvybVviq+2irzuiWY05eU5pfDdlX/vCNeXjQRwgmP+Bi
	YKYckPggWdkXSrAiWWOUjmFL3n9V7MlemTKdJHAaU1ULHo7r4Fonqku684aK7CFm459dmvtmsLA
	/peKVLf/LoI1OhL5FW1vbCXNZmYxLs8OosSuouxqgQQZnUjasBiwS/Zx+c6vs2/JcLq/sTMu4jM
	ggpkCI=
X-Google-Smtp-Source: AGHT+IHr1mQiEi5hGc8LoTPvGoLdd5QVhL+mSQ6I7Z+WHas2N2JwqHmxzeClECMUR7o+kDNlLieag+nrqU2AUyIwDLQ=
X-Received: by 2002:a05:6402:274c:b0:618:28c3:aee0 with SMTP id
 4fb4d7f45d1cf-618b0514affmr1311507a12.8.1755254442790; Fri, 15 Aug 2025
 03:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com> <20250814235431.995876-3-tahbertschinger@gmail.com>
In-Reply-To: <20250814235431.995876-3-tahbertschinger@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 12:40:31 +0200
X-Gm-Features: Ac12FXwxDqoYDV52a6isgUjTEqvFVvz0jiyF8Xvn6aAFtsGWkEQS--xwOQ3NvtQ
Message-ID: <CAOQ4uxhAOFyei+7GqR3L9WHp4SqhC7oVpwW9eDpxe1o7mDzjoQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 1:51=E2=80=AFAM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> Add support for name_to_handle_at(2) to io_uring.
>
> Like openat*(), this tries to do a non-blocking lookup first and resorts
> to async lookup when that fails.
>
> This uses sqe->addr for the path, ->addr2 for the file handle which is
> filled in by the kernel, and ->addr3 for the mouint_id which is filled
> in by the kernel.
>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/opdef.c              |  7 ++++++
>  io_uring/openclose.c          | 43 +++++++++++++++++++++++++++++++++++
>  io_uring/openclose.h          |  3 +++
>  4 files changed, 54 insertions(+)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
> index 6957dc539d83..596bae788b48 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -289,6 +289,7 @@ enum io_uring_op {
>         IORING_OP_READV_FIXED,
>         IORING_OP_WRITEV_FIXED,
>         IORING_OP_PIPE,
> +       IORING_OP_NAME_TO_HANDLE_AT,
>
>         /* this goes last, obviously */
>         IORING_OP_LAST,
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 9568785810d9..ff2672bbd583 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -574,6 +574,10 @@ const struct io_issue_def io_issue_defs[] =3D {
>                 .prep                   =3D io_pipe_prep,
>                 .issue                  =3D io_pipe,
>         },
> +       [IORING_OP_NAME_TO_HANDLE_AT] =3D {
> +               .prep                   =3D io_name_to_handle_at_prep,
> +               .issue                  =3D io_name_to_handle_at,
> +       },
>  };
>
>  const struct io_cold_def io_cold_defs[] =3D {
> @@ -824,6 +828,9 @@ const struct io_cold_def io_cold_defs[] =3D {
>         [IORING_OP_PIPE] =3D {
>                 .name                   =3D "PIPE",
>         },
> +       [IORING_OP_NAME_TO_HANDLE_AT] =3D {
> +               .name                   =3D "NAME_TO_HANDLE_AT",
> +       },
>  };
>
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index d70700e5cef8..f15a9307f811 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -27,6 +27,15 @@ struct io_open {
>         unsigned long                   nofile;
>  };
>
> +struct io_name_to_handle {
> +       struct file                     *file;
> +       int                             dfd;
> +       int                             open_flag;

These are not open_flags, there are handle_flags
(e.g. AT_HANDLE_FID)

> +       struct file_handle __user       *ufh;
> +       char __user                     *path;
> +       void __user                     *mount_id;
> +};
> +
>  struct io_close {
>         struct file                     *file;
>         int                             fd;
> @@ -187,6 +196,40 @@ void io_open_cleanup(struct io_kiocb *req)
>                 putname(open->filename);
>  }
>
> +int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_urin=
g_sqe *sqe)
> +{
> +       struct io_name_to_handle *nh =3D io_kiocb_to_cmd(req, struct io_n=
ame_to_handle);
> +
> +       nh->dfd =3D READ_ONCE(sqe->fd);
> +       nh->open_flag =3D READ_ONCE(sqe->open_flags);

Please also create union member sqe->handle_flags
or name_to_handle_flags.

Thanks,
Amir.

