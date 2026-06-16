Return-Path: <io-uring+bounces-13750-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id PXo5KiRqMWokiwUAu9opvQ
	(envelope-from <io-uring+bounces-13750-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 17:22:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F32F4690F7B
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 17:22:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=SKTa1SKu;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13750-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13750-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C44731CCC19
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 15:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A8E43C05C;
	Tue, 16 Jun 2026 15:15:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75D43DA2C
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 15:15:39 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622941; cv=pass; b=JCrWxKD6bvWflTsYAJyc0paKHKUfQ0wtHihRSGBWFH4fhxsIOMtfxsJKYT3zuwDHNwH4BCT1X2oD+eoVL2f+guVuha7Kjx3WVdJp0FCqzjXastHiMs0igEsIVslpz9Y5fNDMSMkGU1KaRqBOygviQDNVXPLoXPOy9T8LTB9AVaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622941; c=relaxed/simple;
	bh=/ix2D+fsTM+4TwedNe9z9hDyU0TUOVMKrtdEeY/Vybc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oPJEJtmHhz0iARJlYi4rI3BpFmXt4/++Oz2GW9w4k2Ry7vht5ve4hq27NFLqCkFhwpbE1lBmgE+dkeSM4HfTPx7b6Lj0XuEZMosJRJAvSsL+IDPwe2iUQuVRJvW+Lel1zCPpKYGqRBOsqjms/5U2yfJrRMaoMFu8NA5KzdWPpdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SKTa1SKu; arc=pass smtp.client-ip=209.85.210.48
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6d7263025so900753a34.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 08:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781622938; cv=none;
        d=google.com; s=arc-20240605;
        b=JXOWhE4/VI7SlF4CoUg/lRCIo17wi2zVvO22UNfZZ0GyLM8RSBhG1+9r6uLnlU6AFD
         ILpjvhHD5p5OoTU4PXi8tJLkleIoQls9QKyxQImSMMFNqi1HOpzUZFIgfulOlHLMJmPN
         pK7rN4FmPmrHbeXXyr4KKvd8kkwNrDCkh32NS0ODz3RiRm3VMgD3jTYe0nbzIw58q9+K
         Bb0bTcpAcBCvU1eBJ7GYie7MdX0Jz+5vB9lrrqUAJwHj0Ez5Btq4VN0OTgCwPPWlBQ6d
         tQTOOwi7oS3QxLm5kcHF7uwBcO4wO/Yz15T9VycA2XGdfWt73aMt5chgn2ePh3px/vw4
         7CiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rd66yi9t2yXzKphJAjKWBegQuTAPcHJUaUhA7v+8Lsw=;
        fh=THtEAWxJDgPQ25tM6yiGCOtDvkVXCTcLQyE4VGd9v7k=;
        b=EVglXjE26PrePch1i3aMAIfKWPpAN62QqLEC8tBmIRoICjJ0i290H6aTzMlgu1cR/N
         3v1v9tTENjFC4YfccEgMM1Gp7+9CUHFY7g5CW1yjgtG7d0WumX9bJ/f2JadvRDheCyHp
         o6co1UASjBb/psNEfDIDZMJBv1uJARQYJm7EpgDNYOiy18N+HBWfQ79RgeId03NMRAEd
         +3BRJ5iEgaVM+GnbeaEaiv/C+DeT6oOpBmOLMiiafHidclsRVAF0dSkDM0WBamRCV1zq
         5eanuUPPrMEoA+/GwiPeyk/67rkdR+pAr2DcTqdtB8mO6joprQKqEUb3V/lUa5YhPqIg
         L7YA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781622938; x=1782227738; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rd66yi9t2yXzKphJAjKWBegQuTAPcHJUaUhA7v+8Lsw=;
        b=SKTa1SKupIkMpY7q3GPmgzjFxr44aDfMXy1N8KLn12lQSsY3/pa8jJPr/a2Ox7F+W7
         nEsj7Lpf3n+R3n4rVe1VyBZfGATUmpyXGeFLZgl6Xho45UOX8EcVPE7IIswaWBab7akM
         GkFyOzc06SQDIRkxHnIkuB3TBgasxuhao9lUPq0QPYqjo+0UU6Dha47SdJeVG5XBmC0Q
         qPTIZfgv0V5IOnpZQ3A8fbAL0odIDqehX02ZOtWML1sw+Nr8bTJiHBwcFxcmqoP0dYmW
         qAdQOJwBGKL79GS77dcy/fNfml7E2VBjijTeRTlc8JRV8JV/ysu5Umkzwh4ZxZwoWeZq
         AIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781622938; x=1782227738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rd66yi9t2yXzKphJAjKWBegQuTAPcHJUaUhA7v+8Lsw=;
        b=SIFqGcjrpQOO38jWXqc9kIawCtIBbUIN4eVTiA8L+hm8egxQxQGSkAo8JJJ717iwtK
         lrb0ohrDuEg9MMBgvP6+f4mVN4ymSjvcK+T+c/3RDBrAQTf9FycycsPfkQOaucNlQEKW
         A06saIT2kC36DiuYakT4XoBw6KVP+xhiPYWyer1efsNFaSgFdhadic728Ft9lmitOhRt
         6eL6OtxVJr3U99KDm5QBQHP8mkBsf2p5K/1h1xJDjJUX/qSw4OPjUM9TwsagINWAbCu+
         4VSuxHlaknjRBcF+oM5mzlynbSTAo9HhK3seEJQ1UofoBhONU5LThfSzApS2o8hYkucb
         kq6Q==
X-Gm-Message-State: AOJu0Ywz2/7vK86p9zTZGpjiUCNRjTCPjI6rGVZPZqSaC6bP4RZsB/qE
	LiAFoY4tC11Xy9Kcywvi4vFD/FpW+LuXu4U92tZvxD4xppP1dzyuJBxy1gdm8VP+klBaSw5Mijd
	lXeNxLF7bnntor/fm829YM2F56L7f8GuHY+lSDyn4GMpOq4uxe+cMs4eOXw==
X-Gm-Gg: Acq92OECrFKtRKittYxj4zNRJCxwcQoJBlAvWVmY6NihxQXHegaffm1XXupqa2f6MEU
	1Hdo0VPPrcFqdJkYwFlYwXtIOf4rGGoci6C9Irjh1BtXWl5qXHZNBdzdh9YwkscLAcrgF/TLMWP
	Sbv5j+bk+pR559Qd/0QFkA1g+zfm7MpluWySesCje7XKH6sGBKzVf6lN9X9nQnVW5jLopcgtmea
	orEtm2MPxvx/+lUR7G9u4omLHKyDgERFmcJe3G9ZErZKFXr4SfymwRVxpQQ9wxYk3QjA82VVzN0
	udYS4e8=
X-Received: by 2002:a05:6830:490c:b0:7db:cf33:844d with SMTP id
 46e09a7af769-7e90b3aff8dmr45472a34.3.1781622938347; Tue, 16 Jun 2026 08:15:38
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0600ea2a-9a60-49e6-aeba-3bbab4b9d3d2@kernel.dk>
In-Reply-To: <0600ea2a-9a60-49e6-aeba-3bbab4b9d3d2@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 16 Jun 2026 08:15:27 -0700
X-Gm-Features: AVVi8CcFV2IBTK0EtYEw7baZnkmFGicj9YqsJ26rn1QU50SIvKVWScaUO6A1mdI
Message-ID: <CADUfDZp5N1_LV8ujM9Hp=Bno=tARr4ZRAHqh1aRA2d1TNj5mZA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: get rid of tw_pending for !DEFER task work
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13750-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,purestorage.com:dkim,purestorage.com:email,purestorage.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F32F4690F7B

On Tue, Jun 16, 2026 at 5:20=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> The normal task_work path used a tw_pending bit to ensure the callback
> was only added once: the mpscq drains incrementally, so a single
> tctx_task_work() run can take the queue through empty -> non-empty
> several times, and each transition would otherwise re-add the already
> pending callback_head. This corrupts the task_work list, and is what
> tw_pending protects again.
>
> This can go away, if we stop running the task_work as soon as the queue
> empties.
>
> Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

>
> ---
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 6415a3353ee0..87151a5b62c1 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -149,8 +149,6 @@ struct io_uring_task {
>
>         struct { /* task_work */
>                 struct mpscq            task_list;
> -               /* BIT(0) guards adding tw only once */
> -               unsigned long           tw_pending;
>                 struct callback_head    task_work;
>         } ____cacheline_aligned_in_smp;
>  };
> diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
> index c801384c6a0a..f910526766fd 100644
> --- a/io_uring/mpscq.h
> +++ b/io_uring/mpscq.h
> @@ -122,4 +122,13 @@ static inline struct llist_node *mpscq_pop(struct mp=
scq *q,
>         return NULL;
>  }
>
> +/*
> + * Returns true if the most recent mpscq_pop() that returned a node also
> + * emptied the queue. Consumer must be serialized.
> + */
> +static inline bool mpscq_pop_emptied(struct mpscq *q, struct llist_node =
*head)
> +{
> +       return head =3D=3D &q->stub;
> +}
> +
>  #endif /* IOU_MPSCQ_H */
> diff --git a/io_uring/tw.c b/io_uring/tw.c
> index e74372233f40..f2ce806b01a1 100644
> --- a/io_uring/tw.c
> +++ b/io_uring/tw.c
> @@ -34,10 +34,6 @@ void io_tctx_fallback_work(struct work_struct *work)
>                                                   fallback_work);
>         unsigned int count =3D 0;
>
> -       /* see tctx_task_work() - a set bit must always have a run coming=
 */
> -       clear_bit(0, &tctx->tw_pending);
> -       smp_mb__after_atomic();
> -
>         /*
>          * Run the entries directly. We're in PF_KTHRED context, hence
>          * io_should_terminate_tw() is true and they will be marked as
> @@ -101,6 +97,13 @@ void tctx_task_work_run(struct io_uring_task *tctx, u=
nsigned int max_entries,
>                                 io_poll_task_func, io_req_rw_complete,
>                                 (struct io_tw_req){req}, ts);
>                 (*count)++;
> +               /*
> +                * Break if most recent pop emptied the queue. This helps
> +                * bound task_work run, and also protects the regular
> +                * task_work addition.
> +                */
> +               if (mpscq_pop_emptied(&tctx->task_list, tctx->task_head))
> +                       break;
>                 if (unlikely(need_resched())) {
>                         ctx_flush_and_put(ctx, ts);
>                         ctx =3D NULL;
> @@ -127,8 +130,6 @@ void tctx_task_work(struct callback_head *cb)
>         unsigned int count =3D 0;
>
>         tctx =3D container_of(cb, struct io_uring_task, task_work);
> -       clear_bit(0, &tctx->tw_pending);
> -       smp_mb__after_atomic();
>         tctx_task_work_run(tctx, UINT_MAX, &count);
>  }
>
> @@ -206,7 +207,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
>         struct io_uring_task *tctx =3D req->tctx;
>         struct io_ring_ctx *ctx =3D req->ctx;
>
> -       /* task_work already pending, we're done */
> +       /* tw run already pending, nothing else to do */
>         if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
>                 return;
>
> @@ -223,10 +224,6 @@ void io_req_normal_work_add(struct io_kiocb *req)
>                 return;
>         }
>
> -       /* task_work must only be added once */
> -       if (test_and_set_bit(0, &tctx->tw_pending))
> -               return;
> -
>         if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->noti=
fy_method)))
>                 return;
>
> --
> Jens Axboe
>

