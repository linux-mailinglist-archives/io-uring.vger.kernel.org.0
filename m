Return-Path: <io-uring+bounces-11540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E885ED06353
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 22:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9514A3010A81
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 21:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136CB3328F7;
	Thu,  8 Jan 2026 21:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KrDAQ7Wg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FEB50097C
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 21:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767906576; cv=none; b=iZgcayBKs/CsP76PbUl9uXuuJYa23XGZ5TKol7Z8AkSJBREP3qX17hz6fP7wvSKPH7bk4495/pg14Y08SdeAKPyzWzHvaAgxZiCA9ET0K0H3nbygVYn/FXnXVr2jr+vxjXoRtKdFs9SyzEqZ0BFd4wM6CmiDt2mrJzg6Rxyvw7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767906576; c=relaxed/simple;
	bh=r2Zn5rDhgmznXysDzd71ddQjoYVPIvx/TD6jmmvJ3ko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vF1+Q/3yPrLoVMX3XOosxIIb5I5ePTu15hcmBhIPzJ7S0elaEDtnUiTXZU3lUS/Yh9bdTdpa/OooGbYAk3iv0mLgv3qA0SkfcusuciU1ExzLvpCBY37gAMjieVQvTaXl9CCsQuOheDW7mjTcNrrM9ziTK4SOJtjIKA+mQfLfUmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KrDAQ7Wg; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-121a15dacd1so286278c88.1
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 13:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767906574; x=1768511374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l32sfxaQYx7HwL0yJhv52El4V7H01MIwAo5l1s6aKA0=;
        b=KrDAQ7Wg+uCtagcLpVgcJ3HemkEX/HDQ0s42tKt/ThFt+H3vRClTyHyVtaGPJ/lcKT
         0dzRvl3h+FH/75SvwvqU1gJjkFHSJX36StuSKj/ykyDwY+jM/nlrEVNEDsHJUd7u+o2i
         FJv/9ToYQ6tANpBXj5HQH+gm6hLHoRAUyBwqlZlO3qTvbyuzYbGOKFeA0cpqchn34Gco
         09uuGNtjU1bLnoRtqqys6Z6i6gg9z9LSwHPMBfnhMnY5F2fAutFcWKnW3vXaRpMAAHgv
         n2aMfGR8eNtr2hIDyucH/uvRWFrm8Fl/7MKxbzvNQbJuIak3AwXfRJOS+F9kvDQHOh5R
         CcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767906574; x=1768511374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l32sfxaQYx7HwL0yJhv52El4V7H01MIwAo5l1s6aKA0=;
        b=d/iz5Umq0JQgHgod0m8rw+GoyojK53mIN/xIeCxThL0fN6K51qmNtwufjkEYmJ4/tC
         FFzqQ40SODBtCF3HvdGh1Yv5X+DBOMknpghcbJ8M58+DjyW/qil2TfDqY6OQHsLCLKBt
         jvS5Ax2CCxC/9AQCKGldpeCX/fkNRvXz4Ykt4yixKY84LwcWohHrj39zXLIh/vlQJTp0
         IJfkrS7MLLZ1GypU+uVDns46UxuC6tuzgbKuR5NdX04N+af80888dvnOKC+TSzM97+Lo
         pyqBoMQ493Wdzr+OYiq1ffR50tQEVLdjCIQYKL4DOUI9328jH3X6aTPB0cjnqK72yST+
         tAOA==
X-Forwarded-Encrypted: i=1; AJvYcCUxp5Gmw4tBHFpZq5dwdkgM3F7PbHqYSkWfyW0iQRjrd61NwS/bg0zDzqxYGgS4Dw7thLIV/ZQupw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyf0YdVVZBU+TN7Gy7tdCdtxP6dcxdW7W3W2dl6MNnlOiQY7Wl
	asl2Mu5/aWjVhCz+EzT2AmBhLKJEHdUiud+uQgXkUwLX5gevt7np4JbmtNKUn0ziWXv5HL6uBQJ
	UDv05hiqeXyw1Tq4DMqP1GcwEI6elckn3kBmLllQGHg==
X-Gm-Gg: AY/fxX4p6k61vFir4jWkjYIoL+7rOBcxYL3sCXYbQ5Z45UNkKPlWa8U6z5c+fXZJyRR
	NihWzFRBq+LOEEei2xMU2xqxXYdZBXwHpME1dMXTEphk4etFVuL6f/cltIaofj1xBmVYN9gNq6X
	LH+0TX0IgGg2RJC2SKJSrjAx0Pk7P6/0w6HTJY9sg7YoSEoMFDcD1JVWCf3p0hyxxJ/Jrc6LlaM
	wIvl+5GVTuBVQJvN9mp6BD4TnmuLPz+3LbV8CSIjN5QNDoDy/P5PSdXYk1b/fUopxDNomly
X-Google-Smtp-Source: AGHT+IGLSO8qM78JDwvs6pRB77Vr4srcQDB8fAfKcBSQzO7NatF2/x6gHVKNcHHzHOZ4eL1CR+klMQF9vwD2CYtOmr4=
X-Received: by 2002:a05:7022:2217:b0:11e:3e9:3e9b with SMTP id
 a92af1059eb24-121f8b60647mr3467529c88.6.1767906573413; Thu, 08 Jan 2026
 13:09:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-24-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-24-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 13:09:22 -0800
X-Gm-Features: AQt7F2qDtxHhMN1toWQImy--O_0Kfj3wGn-7AHn6cD_XHI5MFAZzwfo_WDSsiDQ
Message-ID: <CADUfDZoph-=on3E3sis0eLy_Fm7kUGShRUc89-0V1OjMHNLLAQ@mail.gmail.com>
Subject: Re: [PATCH v3 23/25] io_uring/rsrc: add io_buffer_register_bvec()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add io_buffer_register_bvec() for registering a bvec array.
>
> This is a preparatory patch for fuse-over-io-uring zero-copy.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 12 ++++++++++++
>  io_uring/rsrc.c              | 27 +++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 06e4cfadb344..f5094eb1206a 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -106,6 +106,9 @@ int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *i=
oucmd,
>  int io_buffer_register_request(struct io_uring_cmd *cmd, struct request =
*rq,
>                                void (*release)(void *), unsigned int inde=
x,
>                                unsigned int issue_flags);
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct bio_vec *bv=
s,

Could take const struct bio_vec *? Might also be helpful to document
that this internally makes a copy of the bio_vec array, so the memory
bvs points to can be deallocated as soon as io_buffer_register_bvec()
returns.

> +                           unsigned int nr_bvecs, unsigned int total_byt=
es,
> +                           u8 dir, unsigned int index, unsigned int issu=
e_flags);
>  int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
>                          unsigned int issue_flags);
>  #else
> @@ -199,6 +202,15 @@ static inline int io_buffer_register_request(struct =
io_uring_cmd *cmd,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> +                                         struct bio_vec *bvs,
> +                                         unsigned int nr_bvecs,
> +                                         unsigned int total_bytes, u8 di=
r,
> +                                         unsigned int index,
> +                                         unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
>  static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
>                                        unsigned int index,
>                                        unsigned int issue_flags)
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 5a708cecba4a..32126c06f4c9 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1020,6 +1020,33 @@ int io_buffer_register_request(struct io_uring_cmd=
 *cmd, struct request *rq,
>  }
>  EXPORT_SYMBOL_GPL(io_buffer_register_request);
>
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct bio_vec *bv=
s,
> +                           unsigned int nr_bvecs, unsigned int total_byt=
es,
> +                           u8 dir, unsigned int index,
> +                           unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       struct io_mapped_ubuf *imu;
> +       struct bio_vec *bvec;
> +       int i;

unsigned?

Other than that,
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +       imu =3D io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, dir, NU=
LL,
> +                                   NULL, index);
> +       if (IS_ERR(imu)) {
> +               io_ring_submit_unlock(ctx, issue_flags);
> +               return PTR_ERR(imu);
> +       }
> +
> +       bvec =3D imu->bvec;
> +       for (i =3D 0; i < nr_bvecs; i++)
> +               bvec[i] =3D bvs[i];
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +
>  int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
>                          unsigned int issue_flags)
>  {
> --
> 2.47.3
>

