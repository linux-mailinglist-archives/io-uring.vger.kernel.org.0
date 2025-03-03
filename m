Return-Path: <io-uring+bounces-6920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2244A4CF5E
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 00:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71A3C172D8D
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 23:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435F12376E6;
	Mon,  3 Mar 2025 23:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ODek/7AC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442621F5608
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 23:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741045044; cv=none; b=RLRpR4pXGt4XJpUp2TXfVczcDZLGWbF2VhZyrmeq3KGNco9cyvFtUtSKDx2vm8b7fL/Z7i9d71E9BbedPn/xT8Yht4XIsdJZ5AnBwLPwdB3lamVV5tdbTrXCc4Goamw+7rX//unKOwRBVVbp6ESez/r5UFWe+x8BaXb7KrOabRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741045044; c=relaxed/simple;
	bh=9aeHtt5ACIkJYsUUWzaN3/hBApzcpiHGdT8ieRSudEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=li109Wt0pu66pKaiseRI0AcRIBaubqRz9IGpIgEZUzD3uhbDU0/JcKm2pxoNBu3tUUIVo0Nu0USlJ2qaFZBM2WXF3TGg7T3QWPqfm0YIEYCPrELdHzHDgXZ0hA85RGBwbTnOdeyiNhoa7JyvthfJngYUrbEzdmsPCUoVxZuW/t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ODek/7AC; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fe851fa123so1224117a91.0
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 15:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741045041; x=1741649841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+o0uqqZo8iB5/uogABeet8fiklATMBv5vCFcdA/m5go=;
        b=ODek/7ACJk/7WeUxs6isRffiIB0l32e1/pYLhatYBaUpbObgsVKFVBP3ucHU5Pk0ql
         Wpiic6zDtCzkG5fH8r82X1dbmeCrNicCv5Ub+QR7+MwcWUp8FOHzyjq/hZ1FNYIGfpGT
         IUGQi3Xvy7qo+ukAZfNXtYBVX5XVUzYYPg2+wXWZj0x0MBDElwAA8oW1bnLfOfjB2rgk
         UeWrw1uGFU1sUjrDsIt1+wY+j+bFEZvLsah00cKd40xtRhVWi9/aj0Piqtc5relfR8oW
         KobIr11Y7RjYae9USgkyBl2Is3elIEe9111Vsa814XSI/CM5iDlHO646GBDQiTAp7d7f
         JKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741045041; x=1741649841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+o0uqqZo8iB5/uogABeet8fiklATMBv5vCFcdA/m5go=;
        b=C6/tGttmle+wKe/+3eQQS3bxQa9p3da8ApNcsvaasf+JBxrCC8EQvbMUTp82CYDua7
         e0kkRAteNxwWxd4mLBqrXg0x4pgfwWDJYq7cUCBUQahWMX8GWVG90/lvLMW/EoTO1AZm
         ivPHdibKpmaMRFeOyZstXToBGMeQUzdIz5Pp206FqZGoW0ER88+/5OvDQALa4oAFazkA
         7eI2NtMo61r1iZLnbZGv8Fa+mucxy38LiZbsZhboTJJ/JJq/nUR4Nbf7uAp1az8/YUI1
         yOKdeOWt1DsP13J9oqWgjjyztV1CG3EPyXlgCZ97X60awaCq3dbosatMIu97aS/qWd+C
         akNQ==
X-Gm-Message-State: AOJu0Yw0nAZ8TfCoK/Id9P19wjTNiTd+F9FbiOGk+jiyJzvgHqonq7ps
	pSqh+HUbBS4UJOwKg4yYZKsovd/B/hBO1sfEtn+pkked54dMlToyJ579uTLt9qPKvFpdpmUfXcF
	tfhf+iipafTsvGiF99PHqrjxNf1q6bQtoKv12PQ==
X-Gm-Gg: ASbGncuOHH/D4Nkni52wmzY55snrB6XsmgTMkAfZWDuxqDvy9WukN5nNuQj+GQ1WKEc
	TiOyx7mHlB+0J9v4uSaNZD4M1JOoCB6K+wB99vOhQlcplzDgq0Ilacm8coQ6qVHlv5u6rIEwFXr
	XMq/naE7ijc3WYianHZCPvuP6N
X-Google-Smtp-Source: AGHT+IGi3Dxsw2V0B4Do3mOT04xLQEqCigVVuZeEtpGj7iikrusXLcis7ZB3aHKS9y9QBNFWHZ3LBfQDCk9a+eQwzR8=
X-Received: by 2002:a17:90b:4c51:b0:2ee:cbc9:d50b with SMTP id
 98e67ed59e1d1-2ff35306befmr360915a91.4.1741045041569; Mon, 03 Mar 2025
 15:37:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com> <d0bd00d88da98bf236d92a9a45eeb69db2d3bbaf.1741014186.git.asml.silence@gmail.com>
In-Reply-To: <d0bd00d88da98bf236d92a9a45eeb69db2d3bbaf.1741014186.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 15:37:10 -0800
X-Gm-Features: AQ5f1JrFoxTWUHwuMkf-nZmCr8jORBSidwZe70L0933QJw_9rXl_EN9RQmia3AQ
Message-ID: <CADUfDZoZMY1RXg-qVmnoN6=Vprp8tFZtLET-7zwZUv6uhpS4aQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] io_uring/rw: defer reg buf vec import
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 7:52=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Import registered buffers for vectored reads and writes later at issue
> time as we now do for other fixed ops.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  3 +++
>  io_uring/rw.c                  | 36 +++++++++++++++++++++++++++++-----
>  2 files changed, 34 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index b770a2b12da6..d36fccda754b 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -502,6 +502,7 @@ enum {
>         REQ_F_BUFFERS_COMMIT_BIT,
>         REQ_F_BUF_NODE_BIT,
>         REQ_F_HAS_METADATA_BIT,
> +       REQ_F_IMPORT_BUFFER_BIT,
>
>         /* not a real bit, just to check we're not overflowing the space =
*/
>         __REQ_F_LAST_BIT,
> @@ -584,6 +585,8 @@ enum {
>         REQ_F_BUF_NODE          =3D IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
>         /* request has read/write metadata assigned */
>         REQ_F_HAS_METADATA      =3D IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
> +       /* resolve padded iovec to registered buffers */
> +       REQ_F_IMPORT_BUFFER     =3D IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
>  };
>
>  typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw)=
;
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 4c4229f41aaa..33a7ab2a8664 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -381,6 +381,24 @@ int io_prep_write_fixed(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
>         return __io_prep_rw(req, sqe, ITER_SOURCE);
>  }
>
> +static int io_rw_import_reg_vec(struct io_kiocb *req,
> +                               struct io_async_rw *io,
> +                               int ddir, unsigned int issue_flags)
> +{
> +       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> +       unsigned uvec_segs =3D rw->len;
> +       unsigned iovec_off =3D io->vec.nr - uvec_segs;
> +       int ret;
> +
> +       ret =3D io_import_reg_vec(ddir, &io->iter, req, &io->vec,
> +                               uvec_segs, iovec_off, issue_flags);
> +       if (unlikely(ret))
> +               return ret;
> +       iov_iter_save_state(&io->iter, &io->iter_state);
> +       req->flags &=3D ~REQ_F_IMPORT_BUFFER;
> +       return 0;
> +}
> +
>  static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
>  {
>         struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> @@ -406,10 +424,8 @@ static int io_rw_prep_reg_vec(struct io_kiocb *req, =
int ddir)
>         if (IS_ERR(res))
>                 return PTR_ERR(res);
>
> -       ret =3D io_import_reg_vec(ddir, &io->iter, req, &io->vec,
> -                               uvec_segs, iovec_off, 0);
> -       iov_iter_save_state(&io->iter, &io->iter_state);
> -       return ret;
> +       req->flags |=3D REQ_F_IMPORT_BUFFER;
> +       return 0;

Looks like ddir is now unused in this function?

Best,
Caleb


>  }
>
>  int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe)
> @@ -906,7 +922,11 @@ static int __io_read(struct io_kiocb *req, unsigned =
int issue_flags)
>         ssize_t ret;
>         loff_t *ppos;
>
> -       if (io_do_buffer_select(req)) {
> +       if (req->flags & REQ_F_IMPORT_BUFFER) {
> +               ret =3D io_rw_import_reg_vec(req, io, ITER_DEST, issue_fl=
ags);
> +               if (unlikely(ret))
> +                       return ret;
> +       } else if (io_do_buffer_select(req)) {
>                 ret =3D io_import_rw_buffer(ITER_DEST, req, io, issue_fla=
gs);
>                 if (unlikely(ret < 0))
>                         return ret;
> @@ -1117,6 +1137,12 @@ int io_write(struct io_kiocb *req, unsigned int is=
sue_flags)
>         ssize_t ret, ret2;
>         loff_t *ppos;
>
> +       if (req->flags & REQ_F_IMPORT_BUFFER) {
> +               ret =3D io_rw_import_reg_vec(req, io, ITER_SOURCE, issue_=
flags);
> +               if (unlikely(ret))
> +                       return ret;
> +       }
> +
>         ret =3D io_rw_init_file(req, FMODE_WRITE, WRITE);
>         if (unlikely(ret))
>                 return ret;
> --
> 2.48.1
>
>

