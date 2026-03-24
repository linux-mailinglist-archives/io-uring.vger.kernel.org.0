Return-Path: <io-uring+bounces-12833-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DwdBGPVwmllmgQAu9opvQ
	(envelope-from <io-uring+bounces-12833-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:18:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B13B31A9F4
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 013AD3100010
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 18:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8DC3A2556;
	Tue, 24 Mar 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEkKSmre"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6C038910A
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376003; cv=pass; b=IRHoMJP9CjUPICqwLlACxcrHNYZc0bAR0bxqSqqgoJgG0uBWd9XB2n+G1z4o2QkNunce9OSgIB08sG9OwR0VSNXXuzRsuSf8l+YmMLJo2R2fJZptku9e8Mfx6xGdhpo6NHxKlOW9+k7MI38A1aSsJRnLHntZvcXEWwmPCHzEDJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376003; c=relaxed/simple;
	bh=yTdSx3xT0agswAWjhx12XZmAouabmsOO7e/xa+DZYus=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7nWvqxcgnfOPPk4ybKUxaFx6J6DfoewNdPMmh62+ExAAMFlcHPAt9qoInVO9Zo0MOSorlffwn59lGIu5ZqNnS6ESj3xoyB0Wfg9QmVuUsGHkIj4XokjH9KZukcdFqZXCpLR6tzL/XEnM+pb4Q09LiuAKuaRXy1E7L/HT67Wn2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dEkKSmre; arc=pass smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43b527ac5d0so2228851f8f.2
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 11:13:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774375999; cv=none;
        d=google.com; s=arc-20240605;
        b=e6FVGOyk3kGqPzAh/6paMRHMm6ns+3pCHAqgC+iTafV4xA0LyIXinsA8HCTnCDeqUC
         YSf5VuECm1RDHYuFrBSC9j7JFuWYPjhbL3hC1NFrsoLw7/dbQu1cgTBuLXZwZShu1aBa
         camQU86sAmoZMq9Z3jbRv22+mPG/E6DGSYnHtxzLsAH9YLYIuptOdEaFuitRiaS2QX/z
         yLPfafs07TbtnApqGN+FEIMoecCcwQUvNMYM5EGfkzrQaEPevQW8FTsxX5uz7ArzAOIm
         mhqqeqIblIvS7/2gkcoNPnLEjqaCPwFLJL9lAkuXGrxVfddAaa5kSyAca/F2mBfFeGtP
         LtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5BHJ+9H0zJen4hoAZ+dWfUps121hCImfHZ6lUraKFZc=;
        fh=mvcFM2grb6oIJf2rs+YqRhBB+7CAhI3GWxHowyr3TbY=;
        b=Y0m3m1OgJ3YSukmKXvAbdpIPh5h/larKrx9vZqQ13DjHP3QHCO3bWzRFiNc+QWhhdo
         dmPv8fmlQTLIPs0t8EQED0S/95wK22jEFZkgVwSzRFuoSEX08Kg1+3bBU+mBrFzdAnwe
         5DKUFx8RUa8sexfvaZtxaHyW+LppNgWS/QFshpNNHhO+00CgoxbhQ7qX0lMxyXPfQphW
         73j+OfhNH6EHc4E4gueYbZAlSyjrG2IeCI9jr9OFQu3C5QAfXOo1zOS/jq2aYDTbXmlD
         Rb/pr/x4cLsozfZG03SJNiqBwSCkBaLIaDYD1jYl83lSTtEG87N/q0kieNZz7aQAng3D
         vloQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774375999; x=1774980799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BHJ+9H0zJen4hoAZ+dWfUps121hCImfHZ6lUraKFZc=;
        b=dEkKSmre5Y64X/RLVLhMMz1Ssq6Fex0HnGwiCMtjb2EDC+elrZR8conPqnQkex4nb7
         2ynOrjS1oMTOdIMhtw+oeaTDfJcHCZ/xomI080St55K677ztebZiqm4Dp+ClaGJZgWLP
         62heHD3DAFUdl7/NiSjAJV+/54fkYBN7sU1Z0YCDZGYrgHDV+bAjJ2QRqLxiTvJBGZzx
         yAPuG9DhbzbqEJcQbrT8UeWr6U28RICT1srIbsVG7drrW7oeTP34hkDEAsCDvKFJ0+T6
         wU0qgIN4m6Vg++M0tzH4SerL+xyGXer+KqE3nkB0+T54JQrcVY04XHW4Ca+7tIVsVpMU
         UoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774375999; x=1774980799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5BHJ+9H0zJen4hoAZ+dWfUps121hCImfHZ6lUraKFZc=;
        b=Dn0v1xSmtb+tkpjre4sfeskuduCnG6EyUdayAL+wKrKwG8ruDjSI0Ot/jgMzYPZYj0
         UFJuuT9JGAZZO0JlOvihKYMmgg8sQzvzrbHWjzAq61zc2R2AvAVAqHKVIZFdZNzk7tLr
         GHYRhohxK7ppYyoUJpZveBUFROJeGi0lSGWaEIF9lFF70d7ELmN+igqH8cO6doR0uq/u
         +LM/PIfr0arkwu4fRaDy6SCxtjpXXI1/fJYVCoYHaAUg4bpXmE0C3Amq2Nm8KqrJfvI/
         4arU3Avs3sqj/Vedwi2IrZ90CdNYiYLp9ty/TsaCYtGdGoMY3cQrksbOBDvFK7QogRhI
         oztg==
X-Forwarded-Encrypted: i=1; AJvYcCXj1wL3vGjG27aObx/UM5IqQRxSD7hCyflGH3KJPuMvy5MXyRXLk0kSJVySsOK2rSJC1kwn5i1Dzw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7ICEf0oF3sgGwIX3gypywZgZdAn8W0vyJhZQtVm8FW22zRMIl
	Iw0hvuCpkJQ00KTFI1bpU+BtIV8pxbh9/u8vy8evq+sSicmXkxVQOUhooyQbSR0l3q3SK/TRpV1
	rdl581Rt18GyM5i19i9mxBrDDYcRPTF8=
X-Gm-Gg: ATEYQzxR+jOREHZKUGFFeiwCWQgEDNl4qNXI6+vsEItnKhsxjEFWws/RTjuzkoNsYGD
	bI/pbMytvNq1IiWnbJZXwXKci85UUGgpMKnQa/fsxQTTst9ezr0ZeKp/a7pEXfTj5vHWOxeM+Aa
	PThYEXXJdO2EjyliLqZp/WQTNIb16K8tAx2hKE56I/IXjXnrs6MMmsKXMoU1h7tnqdPZw4fSr8h
	rwjHik+xYZAsWtrKVUqcttBVU51jI1/yC97WLp2T86GvPXc81O8WewuavQEN8z+XTLDeLYyc46h
	kZJD5AhJZMtps1tV
X-Received: by 2002:a05:6000:2681:b0:43b:43d3:62ac with SMTP id
 ffacd0b85a97d-43b889c857bmr676810f8f.18.1774375999199; Tue, 24 Mar 2026
 11:13:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324001007.1144471-1-joannelkoong@gmail.com> <20260324001007.1144471-3-joannelkoong@gmail.com>
In-Reply-To: <20260324001007.1144471-3-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 24 Mar 2026 11:13:07 -0700
X-Gm-Features: AQROBzBT1hIGBHswcD4Q8tTv6Xt851c49Mi6Qhb5vRg_AQl7CLigbbxGUNJhg3U
Message-ID: <CAJnrk1a-yhr=MkuOBruySaxi52dVazW3GOer=uHpOZRtoKiiEQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] io_uring/rsrc: split io_buffer_register_request() logic
To: axboe@kernel.dk
Cc: csander@purestorage.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12833-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 6B13B31A9F4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 23, 2026 at 5:10=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Split the main initialization logic in io_buffer_register_request() into
> a helper function.
>
> This is a preparatory patch for supporting kernel-populated buffers in
> fuse io-uring, which will be reusing this logic.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/rsrc.c | 84 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 51 insertions(+), 33 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 7579f6992a25..1902ab7941ac 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -924,64 +924,82 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
>         return ret;
>  }
>
> -int io_buffer_register_request(struct io_uring_cmd *cmd, struct request =
*rq,
> -                              void (*release)(void *), unsigned int inde=
x,
> -                              unsigned int issue_flags)
> +static struct io_mapped_ubuf *io_kernel_buffer_init(struct io_ring_ctx *=
ctx,
> +                                                   unsigned int nr_bvecs=
,
> +                                                   unsigned int total_by=
tes,
> +                                                   u8 dir,
> +                                                   void (*release)(void =
*),
> +                                                   void *priv,
> +                                                   unsigned int index)
>  {
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
> -       struct req_iterator rq_iter;
>         struct io_mapped_ubuf *imu;
>         struct io_rsrc_node *node;
> -       struct bio_vec bv;
> -       unsigned int nr_bvecs =3D 0;
> -       int ret =3D 0;
>
> -       io_ring_submit_lock(ctx, issue_flags);
> -       if (index >=3D data->nr) {
> -               ret =3D -EINVAL;
> -               goto unlock;
> -       }
> +       if (index >=3D data->nr)
> +               return ERR_PTR(-EINVAL);
>         index =3D array_index_nospec(index, data->nr);
>
> -       if (data->nodes[index]) {
> -               ret =3D -EBUSY;
> -               goto unlock;
> -       }
> +       if (data->nodes[index])
> +               return ERR_PTR(-EBUSY);
>
>         node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> -       if (!node) {
> -               ret =3D -ENOMEM;
> -               goto unlock;
> -       }
> +       if (!node)
> +               return ERR_PTR(-ENOMEM);
>
> -       /*
> -        * blk_rq_nr_phys_segments() may overestimate the number of bvecs
> -        * but avoids needing to iterate over the bvecs
> -        */
> -       imu =3D io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
> +       imu =3D io_alloc_imu(ctx, nr_bvecs);
>         if (!imu) {
>                 kfree(node);
> -               ret =3D -ENOMEM;
> -               goto unlock;
> +               return ERR_PTR(-ENOMEM);
>         }
>
>         imu->ubuf =3D 0;
> -       imu->len =3D blk_rq_bytes(rq);
> +       imu->len =3D total_bytes;
>         imu->acct_pages =3D 0;
>         imu->folio_shift =3D PAGE_SHIFT;
> +       imu->nr_bvecs =3D nr_bvecs;
>         refcount_set(&imu->refs, 1);
>         imu->release =3D release;
> -       imu->priv =3D rq;
> +       imu->priv =3D priv;
> +       imu->dir =3D 1 << dir;

I'm going to update this line to take a bitmasked dir directly so that
callers can set both dest and source if needed. I'll send out v2 with
this change.

Thanks,
Joanne

>         imu->flags =3D IO_REGBUF_F_KBUF;
> -       imu->dir =3D 1 << rq_data_dir(rq);
>
> +       node->buf =3D imu;
> +       data->nodes[index] =3D node;
> +
> +       return imu;
> +}
> +

