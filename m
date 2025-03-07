Return-Path: <io-uring+bounces-7019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 891BBA56EC5
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7B7A1891E7A
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D93623E35E;
	Fri,  7 Mar 2025 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="c0XBOpOB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EFE23ED66
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741367456; cv=none; b=j/2Xzs6GuTJ5a200LaQNiY73lF7EJNeH1JDwGO7Tk6JJw6o2vf40e0kYN/FHXn4HNLuaS1TI6j5Gqcz9f5rXjwBJhNcvLYtspxnVMXI2yLpXhAOAhWblMGMdrAVo0UU8Y8+Oc6cuOlYUoUvZxKn2f8ob9z0tyODLuw/yguNMZtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741367456; c=relaxed/simple;
	bh=jJyW6NsJ/fSAE1zbuWPjETJYimkoivGARb8bYKnhpsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJfW8nZABL0ZkKwORsVhNG7exPRpA35XMD4pFpQFOTlvvy/gV61gm2W0swwlH5yLvxGFT4JGeDc3LFMKo7+YjAryBnRX8C4OyoHDEvzkFBIiptyOJbnDCIUrB4Yazb8ynejaSaBejEcdo1fGK2gMBHKWI+7nH0+Vspzno4MnAcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=c0XBOpOB; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f74e6c6cbcso518394a91.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 09:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741367453; x=1741972253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZO2a9y09q8n8x+bulNZwymJHalHaUTtfP9FeKfIoYk=;
        b=c0XBOpOBmMhfgt2xbejYPdQzN2lnUI4lrS/AcQf6g4wqXQ1uKxHx6UMSbODcuwAPGJ
         iUIMdIyGhNtKeOJn/Ci3EM2vPChzqYU3MlWtsyPEYSEWOSfqi/rPmuMmoXjHIwshsbYl
         QFOiXgkLk+vF6cLv3hAqDBETUHeqLac/qm3gkCRqNvwC2kh6cbjd+FaxO3twS7eHtgTJ
         NSyw3eIg3QwM5IaKrZy5+WoIY3XSiNw/TaDMlmDwT8f5ct8iBqXtM5a2pa9a/4/2PehR
         Cwm3+sChuMipwwLSzXW6WcmXY+Wu1iHLTKmguXDCp9pP09KK8qYznGLKtV3O0N7zBBu4
         Om3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741367453; x=1741972253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZO2a9y09q8n8x+bulNZwymJHalHaUTtfP9FeKfIoYk=;
        b=seaf2SKgslQXcVSX5Y+T0/qHoW/fsYmJUaTrfZipExCGIueX58jKpyeG/cg6aMwrPl
         nlO+SRuHZ/+LvyteqbBBcglxTf0fSy/xdF7isV0exlJb5q0QBNz4aZD9vwarUqfeSzIe
         JKutxI/ZxidLPxmEIUF8RadaO7IxNhmnamgAX8hRoDwq2bbTXzByw2SO3Nd1VwJ50res
         hnBuXD/l4wF+mND8gO5H0omoOy7RRTPnBOsm5oJN8TatLWNUfmtXrMy14pIMljNQM/wb
         cpltskg2uV+Z+1QmIOppQ/zNVu+Nbu7tfaWN3ZZCGO/BqBmC/PE9xvsgwsdk/Y/3zLCe
         jSyQ==
X-Gm-Message-State: AOJu0YyIAle0rSTk668kwZNpabpoawxlKgt+0zDlNE5Q+AsVkNfvj068
	u66VHEvM6XZdxxB0KoVOaegeW5oz1i8drgrWiDQBYDZ+ubQodTArBYc5LDK9Mnca7MfavAII9pX
	dm9kUHl4JTzrys851zezrmeqUuP/49K7/m0wMRg==
X-Gm-Gg: ASbGncu9UC7K7rXZrxxsyyrZSaVDf8z+KkowbBTsHXh8xKUkWHeolO5prhRLrBiFebi
	ua2qgBeDps8HnywdIMArXZBh/vGrikEEu4tx+SSGdaD3D118tZYut7QL7oXXW1AcCHtWX2nPogs
	zeV2VLa7ALtcnea7j37fJQ3DZy
X-Google-Smtp-Source: AGHT+IFWZMjEEadusv8NnjB1t7QOZGyChl5178Y7kISe0t9XXXD0H5DjFostsowDbyKOjpHQQvVUgJDK+MLk9A4CDkg=
X-Received: by 2002:a17:90b:3b83:b0:2ff:4a6d:b359 with SMTP id
 98e67ed59e1d1-2ff8f90bacfmr204948a91.7.1741367453432; Fri, 07 Mar 2025
 09:10:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741364284.git.asml.silence@gmail.com> <60182eae68ff13f31d158e08abc351205d59c929.1741364284.git.asml.silence@gmail.com>
In-Reply-To: <60182eae68ff13f31d158e08abc351205d59c929.1741364284.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 7 Mar 2025 09:10:41 -0800
X-Gm-Features: AQ5f1JoI_-BHJYW5BwWNjjnFqrOB14hXP5d9WZ_WTdjSclQ1t3svQwYZ2Zt-NkQ
Message-ID: <CADUfDZpzxCDR8g7iP=3wSRMJW6q3fACEgLFvYYHHG_yDd=ht=A@mail.gmail.com>
Subject: Re: [PATCH liburing 1/4] Add vectored registered buffer req init helpers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 8:22=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  src/include/liburing.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index d162d0e6..e71551ed 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -556,6 +556,16 @@ IOURINGINLINE void io_uring_prep_read_fixed(struct i=
o_uring_sqe *sqe, int fd,
>         sqe->buf_index =3D (__u16) buf_index;
>  }
>
> +IOURINGINLINE void io_uring_prep_readv_fixed(struct io_uring_sqe *sqe, i=
nt fd,
> +                                            const struct iovec *iovecs,
> +                                            unsigned nr_vecs, __u64 offs=
et,
> +                                            int flags, int buf_index)
> +{
> +       io_uring_prep_readv2(sqe, fd, iovecs, nr_vecs, offset, flags);
> +       sqe->opcode =3D IORING_OP_WRITE_FIXED;

Presumably should be IORING_OP_READV_FIXED? You'll probably need to
copy the UAPI header changes to liburing.

> +       sqe->buf_index =3D (__u16)buf_index;
> +}
> +
>  IOURINGINLINE void io_uring_prep_writev(struct io_uring_sqe *sqe, int fd=
,
>                                         const struct iovec *iovecs,
>                                         unsigned nr_vecs, __u64 offset)
> @@ -580,6 +590,16 @@ IOURINGINLINE void io_uring_prep_write_fixed(struct =
io_uring_sqe *sqe, int fd,
>         sqe->buf_index =3D (__u16) buf_index;
>  }
>
> +IOURINGINLINE void io_uring_prep_writev2_fixed(struct io_uring_sqe *sqe,=
 int fd,
> +                                      const struct iovec *iovecs,
> +                                      unsigned nr_vecs, __u64 offset,
> +                                      int flags, int buf_index)
> +{
> +       io_uring_prep_writev2(sqe, fd, iovecs, nr_vecs, offset, flags);
> +       sqe->opcode =3D IORING_OP_WRITE_FIXED;

IORING_OP_WRITEV_FIXED?

Best,
Caleb

> +       sqe->buf_index =3D (__u16)buf_index;
> +}
> +
>  IOURINGINLINE void io_uring_prep_recvmsg(struct io_uring_sqe *sqe, int f=
d,
>                                          struct msghdr *msg, unsigned fla=
gs)
>  {
> @@ -964,6 +984,17 @@ IOURINGINLINE void io_uring_prep_sendmsg_zc(struct i=
o_uring_sqe *sqe, int fd,
>         sqe->opcode =3D IORING_OP_SENDMSG_ZC;
>  }
>
> +IOURINGINLINE void io_uring_prep_sendmsg_zc_fixed(struct io_uring_sqe *s=
qe,
> +                                               int fd,
> +                                               const struct msghdr *msg,
> +                                               unsigned flags,
> +                                               unsigned buf_index)
> +{
> +       io_uring_prep_sendmsg_zc(sqe, fd, msg, flags);
> +       sqe->ioprio |=3D IORING_RECVSEND_FIXED_BUF;
> +       sqe->buf_index =3D buf_index;
> +}
> +
>  IOURINGINLINE void io_uring_prep_recv(struct io_uring_sqe *sqe, int sock=
fd,
>                                       void *buf, size_t len, int flags)
>  {
> --
> 2.48.1
>
>

