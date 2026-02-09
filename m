Return-Path: <io-uring+bounces-12107-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EP1RMgYQimlrGAAAu9opvQ
	(envelope-from <io-uring+bounces-12107-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 17:49:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 31094112A7D
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 17:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3387A305CF61
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 16:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CA72BDC3D;
	Mon,  9 Feb 2026 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LvSHDX8o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E3138551A
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 16:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770655510; cv=pass; b=nj9ilYoyMmsIuIVOvV7y/crSB56WBoUiN5GXBvUo61GOLHFofWgoGbD7R7UNmdnsMv0kFTjIKw+koCRv9VBjVBpLF5aujhswNgFN6dkNpznE8EJzTJZ/CUIx1D/hOb1yYbnOAYdpDw/V6IMBok3O/UX6BJN7rpZq3wHYER/3tOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770655510; c=relaxed/simple;
	bh=NLuP7V8X79OluKIx6oafiK3RQDF8K2hnOhb6Neyk0EQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dHwjuF6qqHY5nPQmT8tVqlrDhlrxSveWR9fb2K1mgsGhzMoOOo98lvJkX6YapUp/ZtCk1IBG8JYu7Vc5YZww/oWwD4dsQMsla+/EZEyyF1KuQBOrY5UPCYoxaHDi+LXQ8f4QZeHsjiP7B0AOJS09AaSQegcMTEFLRClcPeCPKqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LvSHDX8o; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-650854d9853so809761a12.0
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 08:45:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770655508; cv=none;
        d=google.com; s=arc-20240605;
        b=hWkJZHUcpmwnWYNHYNCc5LJoH6CV7vE5bE8R+QzQUaobXt0CmvTimDXm4W0xNsrcnt
         0jDaTElCm0YvyGMKQSD9INSR7WlrXPO5s9J37kvVG7M2+tzJ3ddZKYBahUPYAvu4+ekD
         GBM9fHGt9fLT/i+i2VnRsXfghKOwot+/RhWJpmrLT32H1cfcz99tGN0sqrwK3d3mDKMY
         7O5gIAJZ2DbYw0C823J1hjMFdunKoEOoNZGvY71xLzhDUNT/J0JZtLlx1ynslf14NcNs
         /iaqnbRUn1ENDE38onPHiM/ubr4a7FENTr4S1vEVLKsenjWrFA66war/IEDMU5HxcBAd
         Y6lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M7z+sj56oWDvL4ykhPYrOEL/+syNOUfWoMGHCFeZvr4=;
        fh=UEwM/kEVsUfnwgxlJKzHxO4kpx5y5QUBgiZNmqm4+qo=;
        b=krKdUPCSviUiTdSmFPH0GrPk7z0aoY8M7qsOlBg0zAxjp2n8tZ/t5wQrzGJs8T7fzx
         9qNc/AZWy+107OHGd8DvW71+Ox7nphzDWQ3UX97h92K9eYIO8BEYuY5GLDjRjQXXCgfU
         5UEZ6TPpGFSCPK3NyDYOj9BFvF/GwqwzBHQg8LEHUKFTBsL9UmnMdLmf97XyQypdlgsr
         A1WIuU4wvVIIJYKtJJUtGAcmAu46ZDD7NMOaJeEKVBKutiYq/gOdJYrbQ2SZ8+zmoG/9
         FcpCRKb8r4QMHreQudEaD3QGrQlItnyRCu6NYjki7xSHtz+7MHxOVLOKC4/9Un4FXBWt
         35BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1770655508; x=1771260308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7z+sj56oWDvL4ykhPYrOEL/+syNOUfWoMGHCFeZvr4=;
        b=LvSHDX8o5rXAjddis4mBwlWpyOKCI3mV5azyW1wYMQbHa7fPEWiXLVV1r/TsVYAeeH
         o3uvOdCPQlV90WPdggZcb0BmXzvF98ffFFraBTjtdii33/sazKS9WD4+xmOIejUGiPAQ
         EzXV7+40CmUSBEOTYd4j6LLco6iSFxI2iMuzscN7YvmBG2Ew5FMXnl0cr+rJywTjBDHo
         3Qtzlqd1SHnLeK4JEXIqlO3EMYtUbVoCBT/eaZrcg/8YqbfpaObxdMvwCGXVLrl9nYfY
         IHPw7EzwTlFVcCuW7ImFMJyKj+hZi7VehjI2W5T+pUo2rno1zJb0oYFjjBmFh8RJFkjG
         Iwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770655508; x=1771260308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M7z+sj56oWDvL4ykhPYrOEL/+syNOUfWoMGHCFeZvr4=;
        b=eDeoYDUifPa3lrhSLdeINz8jpavl4E6A5klb582N5Bsah67UeFVx8p633kyACTIvCA
         qrvHg7P/S+jMA3l62ChdDDpuMv8mpSdta+hFjTSvwakMEncCeSNtejdocJJ0wdbxEkPm
         cvTjN1aUlBCy3zsQjhHPAPAY6G2KRaoUBlC3p3d8faIGq639sOOq+XXj/E1UVpKRxbvD
         CzonryLkyJ1tROmXeOjtFW7O6pphymx8E+6nLeeyjm+AvOfXsewB7OxQGe2ytsUm58fb
         wfioWfzSOPrRFHw04hiJ6TBdY/zOSnxAozAy0Mc3aVEfKF3h6RhAtP4JEpdGGyk6wHm4
         4AJQ==
X-Gm-Message-State: AOJu0YxVpjAppKIPNCCHYP4bX7LxltuUoXDYN1ErU69eYiGlMOCJhxbj
	B5sIiKsKZ3wTeLrm2sqxRmEcRfCcGVCaDhDEaIvKGNGqRKcGMQwa1Byc54SNrtgWQZzb95ciPvP
	sgQxK14icpogJTszXf3tPRW2XLBYJz25wl4BGf6B2oOrLx27gya24
X-Gm-Gg: AZuq6aLuqNtKIagSdJC40z+U0BoWx0LtFCzVlfRyhnwZusP+BcYr4T5+D/Rgi8TWxWU
	1s/s8UtWTT7rLyn9naXa9VDp/l+j1wD4CHh+mdAysTK9Did818cP69wNedaGAXI/4AaSNfl2Y6j
	QiiCs1DBo1NErn70poNDN4x45X3cKL5qQnZkt53zUnMR5CSfI5m/FsrpjB8XAALpyc0aFTpW1Om
	vVLTKj/NjGfAwxwCi8WuRiIXVUN5H0HlJJoZYJF80qOIyxiwootWEwXqMeVCPj1Xj+0Ohni
X-Received: by 2002:a05:6402:4404:b0:658:dc6:6d08 with SMTP id
 4fb4d7f45d1cf-659841827e0mr3871194a12.7.1770655508348; Mon, 09 Feb 2026
 08:45:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b2fa5a88797fc54bc365f88f4884a845b0a16530.1770646345.git.asml.silence@gmail.com>
In-Reply-To: <b2fa5a88797fc54bc365f88f4884a845b0a16530.1770646345.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Feb 2026 08:44:57 -0800
X-Gm-Features: AZwV_Qjq4HFd1QOU2GWrUf9Aioji9kMMY8-cgJKpxn_IMDLvp89ZydznvzZDCuE
Message-ID: <CADUfDZqJzVKEnoNWd5F0NAK6oKaUB3beJQ65WfKwmnXcGU5TWg@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: replace reg buffer bit field with flags
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12107-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 31094112A7D
X-Rspamd-Action: no action

On Mon, Feb 9, 2026 at 6:33=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> I'll need a flag in the registered buffer struct for dmabuf work, and
> it'll be more convenient to have a flags field rather than bit fields,
> especially for io_mapped_ubuf initialisation.
>
> We might want to add more flags in the future as well. For example, it
> might be useful for debugging and potentially optimisations to split out
> a flag indicating the shape of the buffer to gate iov_iter_advance()
> walks vs bit/mask arithmetics. It can also be combined with the
> direction mask field.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/rsrc.c | 12 ++++++------
>  io_uring/rsrc.h |  6 +++++-
>  io_uring/rw.c   |  3 ++-
>  3 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 95ce553fff8d..05f00bdb02d7 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -828,7 +828,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>         imu->folio_shift =3D PAGE_SHIFT;
>         imu->release =3D io_release_ubuf;
>         imu->priv =3D imu;
> -       imu->is_kbuf =3D false;
> +       imu->flags =3D 0;
>         imu->dir =3D IO_IMU_DEST | IO_IMU_SOURCE;
>         if (coalesced)
>                 imu->folio_shift =3D data.folio_shift;
> @@ -985,7 +985,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
>         refcount_set(&imu->refs, 1);
>         imu->release =3D release;
>         imu->priv =3D rq;
> -       imu->is_kbuf =3D true;
> +       imu->flags =3D IO_REGBUF_F_KBUF;
>         imu->dir =3D 1 << rq_data_dir(rq);
>
>         rq_for_each_bvec(bv, rq, rq_iter)
> @@ -1020,7 +1020,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *=
cmd, unsigned int index,
>                 ret =3D -EINVAL;
>                 goto unlock;
>         }
> -       if (!node->buf->is_kbuf) {
> +       if (!(node->buf->flags & IO_REGBUF_F_KBUF)) {
>                 ret =3D -EBUSY;
>                 goto unlock;
>         }
> @@ -1076,7 +1076,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
>
>         offset =3D buf_addr - imu->ubuf;
>
> -       if (imu->is_kbuf)
> +       if (imu->flags & IO_REGBUF_F_KBUF)
>                 return io_import_kbuf(ddir, iter, imu, len, offset);
>
>         /*
> @@ -1496,7 +1496,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *it=
er,
>         iovec_off =3D vec->nr - nr_iovs;
>         iov =3D vec->iovec + iovec_off;
>
> -       if (imu->is_kbuf) {
> +       if (imu->flags & IO_REGBUF_F_KBUF) {
>                 int ret =3D io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs=
);
>
>                 if (unlikely(ret))
> @@ -1534,7 +1534,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *it=
er,
>                 req->flags |=3D REQ_F_NEED_CLEANUP;
>         }
>
> -       if (imu->is_kbuf)
> +       if (imu->flags & IO_REGBUF_F_KBUF)
>                 return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iov=
s, vec);
>
>         return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 4a5db2ad1af2..cff0f8834c35 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -28,6 +28,10 @@ enum {
>         IO_IMU_SOURCE   =3D 1 << ITER_SOURCE,
>  };
>
> +enum {
> +       IO_REGBUF_F_KBUF                =3D 1,

1 << 0 if this is intended to be extended with more flag bits in the future=
?

Best,
Caleb

> +};
> +
>  struct io_mapped_ubuf {
>         u64             ubuf;
>         unsigned int    len;
> @@ -37,7 +41,7 @@ struct io_mapped_ubuf {
>         unsigned long   acct_pages;
>         void            (*release)(void *);
>         void            *priv;
> -       bool            is_kbuf;
> +       u8              flags;
>         u8              dir;
>         struct bio_vec  bvec[] __counted_by(nr_bvecs);
>  };
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index d10386f56d49..b3971171c342 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -702,7 +702,8 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *r=
w, struct iov_iter *iter)
>         if ((kiocb->ki_flags & IOCB_NOWAIT) &&
>             !(kiocb->ki_filp->f_flags & O_NONBLOCK))
>                 return -EAGAIN;
> -       if ((req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf)
> +       if ((req->flags & REQ_F_BUF_NODE) &&
> +            (req->buf_node->buf->flags & IO_REGBUF_F_KBUF))
>                 return -EFAULT;
>
>         ppos =3D io_kiocb_ppos(kiocb);
> --
> 2.52.0
>
>

