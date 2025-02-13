Return-Path: <io-uring+bounces-6416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B092AA34AA3
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 237341763BE
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC901FF7B0;
	Thu, 13 Feb 2025 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="R+NY8fPL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A811547C5
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739464774; cv=none; b=NgYWoXho5vPMuJ3RRO0gf6VAJF6xrznF53AIq4LtGTaUHK9Tz32A42yv1f93SDDrfLtus+n0I7Zz7hMT0PrczerSoIfPd+dWSf9QDehew4u7iw5AGerVsU7S0v9WIbPSDe//97ifu7YlYnSkitTo9cSmHcxnJlWd+p4LU5folSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739464774; c=relaxed/simple;
	bh=/c+xQXIEjfqdXfi8p+zWWuEbr6GS7kc7G0TWN+ccNcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aaoDv0+6mjPYWJvChV4j0XAHdirBfdVNfigPt04W9sxxf13VGzDrMIZzvaqpElA84qDmUNp61J5i13IP5L8lKxmzHsQu5Ezhz1PNadtfitG2FR84piA0TQhxQTS3KUt27n0pZZn95VzitF79bdUOJUq3k9GiuSCr9u2F4/vWTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=R+NY8fPL; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fc29ac55b5so9472a91.2
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 08:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739464772; x=1740069572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50siCzq6EOPBQ6FbQnixSSYzFB25AeN4VOxEJ1gPWsw=;
        b=R+NY8fPLj9j2QK6QZDO0nLtpXAUEHW7mT6tqxV+xnjZDQtUryjKWM1x1GyIukKETrs
         27NeZqD//llg6YO+Kp3cdMRONcJaxsZVqrwwOgnE7pXHL5Fk1OpJGie3RhbgKnD1gDPA
         Ys+vo1CcVZVDnmroq7tBEb4cjxclbU8985zV+EVJDPicN3vYU9E+TytwzQo42tc+cg4S
         pJKEYrAgYa9Ywq3WoWReTJ6rvKnpdCW/9Jpw7OaRyYulJetXBH9zB0TDZyA5dePNosed
         +83G1fI3q1Y/IR5eg3svMY0qx2ImzfmOdTjlIKl9q50oVT0myVViW4n5HiikKlQKopNx
         Qdbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739464772; x=1740069572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50siCzq6EOPBQ6FbQnixSSYzFB25AeN4VOxEJ1gPWsw=;
        b=w08QKhsHGYqKBKjwHA/1QyYAwhwbUAxzmWZVy10sV1EQqWApQr/eWpRXGEbX8rY3he
         Zn2v/SR4CpOtudTNm8qVEfnol7AaCWF72kz9oViKiYnCPEk6m0K5pT9uXDhojwu9dMff
         nmbbHmJJZ0LZ/Of0UWGq1+RSnXx/wfnmiHSPbLUIHEc6jjeXXZoQpfo9KuP6QRBva8rJ
         P7RU4oDj2isp72r1in0lBiPqv5ioiHfM4atsiFjwNRFWS/4QH9vlOFM/4xJtx+4RMGFV
         NMT2Y/5OrZ5bf446PAJGqlwYxBCuTEKZQEvrP2YaKuR9OqTTaDIciyk6WdDeTKXqsUL7
         aPMg==
X-Gm-Message-State: AOJu0YwkrdP+jfbmAT6Wy6RN01n69tJuXJ+4bpO5gHDW+7cvswyK81a+
	dKPqiTotllT6LBUMuzO1JW5chgdDV/y91vQm6rsCBZYYMGVxUGq7AITzE67oXmDgcLEfHmxoRc4
	maifrdwqkbtxyROFqZCuhP1tvEyxlX2C90NYkuSnJbV2ROz2BzmI=
X-Gm-Gg: ASbGncv1YmBi3WmIjhCMzQWyKGssCyAj1oW+BGnp7BOG4F7YsXPllHoftxuuFUUiPeh
	C2mfNB4VIReoogFLSO0uup8LCjijD9XLTo47thSNRdVmqpMG6K/5tiX24E1+EG7NEjVXFVHU=
X-Google-Smtp-Source: AGHT+IEaLXngZtnn2GE/G7jxR54btJIS5eFp0HANpImtRL4HhJ3IYHZHvPGjJ2y61s7N1/X3R+wGSy5nqp1yOUqBJCI=
X-Received: by 2002:a17:90a:c16:b0:2fb:f9de:94ac with SMTP id
 98e67ed59e1d1-2fbf9de99c3mr3816492a91.7.1739464771815; Thu, 13 Feb 2025
 08:39:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4e4dcdf3-f060-4118-911d-5b492cef8f8f@kernel.dk>
In-Reply-To: <4e4dcdf3-f060-4118-911d-5b492cef8f8f@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 13 Feb 2025 08:39:20 -0800
X-Gm-Features: AWEUYZm7khsZ0ABaEl02Y34ahpwep2ol8s_fN-sWg0r217zUiLU5H6kwoPcM0iY
Message-ID: <CADUfDZoqVAOeAKCHw2z-Er9_CY6d536wL41KUKu5uqDCjw52aw@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring/uring_cmd: unconditionally copy SQEs at prep time
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 8:30=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> This isn't generally necessary, but conditions have been observed where
> SQE data is accessed from the original SQE after prep has been done and
> outside of the initial issue. Opcode prep handlers must ensure that any
> SQE related data is stable beyond the prep phase, but uring_cmd is a bit
> special in how it handles the SQE which makes it susceptible to reading
> stale data. If the application has reused the SQE before the original
> completes, then that can lead to data corruption.
>
> Down the line we can relax this again once uring_cmd has been sanitized
> a bit, and avoid unnecessarily copying the SQE.
>
> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> V2:
> - Pass in SQE for copy, and drop helper for copy

v2 looks good to me. You might add "Fixes: 5eff57fa9f3a", since we
know it fixes the potential SQE corruption in the link and drain
cases.

>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8af7780407b7..e6701b7aa147 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -165,15 +165,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, =
ssize_t ret, u64 res2,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>
> -static void io_uring_cmd_cache_sqes(struct io_kiocb *req)
> -{
> -       struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> -       struct io_uring_cmd_data *cache =3D req->async_data;
> -
> -       memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
> -       ioucmd->sqe =3D cache->sqes;
> -}
> -
>  static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>                                    const struct io_uring_sqe *sqe)
>  {
> @@ -185,10 +176,15 @@ static int io_uring_cmd_prep_setup(struct io_kiocb =
*req,
>                 return -ENOMEM;
>         cache->op_data =3D NULL;
>
> -       ioucmd->sqe =3D sqe;
> -       /* defer memcpy until we need it */
> -       if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
> -               io_uring_cmd_cache_sqes(req);
> +       /*
> +        * Unconditionally cache the SQE for now - this is only needed fo=
r
> +        * requests that go async, but prep handlers must ensure that any
> +        * sqe data is stable beyond prep. Since uring_cmd is special in
> +        * that it doesn't read in per-op data, play it safe and ensure t=
hat
> +        * any SQE data is stable beyond prep. This can later get relaxed=
.
> +        */
> +       memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
> +       ioucmd->sqe =3D cache->sqes;
>         return 0;
>  }
>
> @@ -251,16 +247,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int =
issue_flags)
>         }
>
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
> -       if (ret =3D=3D -EAGAIN) {
> -               struct io_uring_cmd_data *cache =3D req->async_data;
> -
> -               if (ioucmd->sqe !=3D cache->sqes)
> -                       io_uring_cmd_cache_sqes(req);
> -               return -EAGAIN;
> -       } else if (ret =3D=3D -EIOCBQUEUED) {
> -               return -EIOCBQUEUED;
> -       }
> -
> +       if (ret =3D=3D -EAGAIN || ret =3D=3D -EIOCBQUEUED)
> +               return ret;
>         if (ret < 0)
>                 req_set_fail(req);
>         io_req_uring_cleanup(req, issue_flags);
>
> --
> Jens Axboe
>

