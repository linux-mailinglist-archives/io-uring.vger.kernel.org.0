Return-Path: <io-uring+bounces-12555-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNgrA3xWqGlutQAAu9opvQ
	(envelope-from <io-uring+bounces-12555-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 16:57:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA82203768
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 16:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DFD2347ADBF
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 15:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608C834BA21;
	Wed,  4 Mar 2026 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZKFENL+n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E3F349AF1
	for <io-uring@vger.kernel.org>; Wed,  4 Mar 2026 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772639193; cv=pass; b=P/d//6UpHi4/W9Siwn5t2gdrcFm0syvwC6gIqwQ+HZTEPryDq4Ac0tikP5nHYlKtDIWisetwvLUFhE5yEo4dEzK69LZiTL6NgcELvPTSoAbPzyGnWygzYDk4AFyQe4R7/5Wi92onqkhfk+EmmZUI+NJiDBTv2/JlXeT7cuDpfoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772639193; c=relaxed/simple;
	bh=Cc8dP185zw+Oi6jCGxNO+NlesPmnrnNmtpq/WfyG6X0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FQp010ZBeKdY+iL4Y3mG4+8GgKCE+K/4ErJonDs6t8XAYcCDL5HXyRfKp0kw58LEHcBG6LwvDraeCUxWX93dx9JS7giaDbP6HepV1JlhqdxNi+Wk43Z0XNxc5ot4LjZ85Zs/HgVoVhUO/Cw8obONdWcZntku/DV3zbnVOt/2l6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZKFENL+n; arc=pass smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-415d7461fa5so303443fac.2
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2026 07:46:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772639190; cv=none;
        d=google.com; s=arc-20240605;
        b=FFYnd422qyNx1qZ1sN3cYcYFl+nIb+C7N1BQG35mCYedx+htG7wt2XnTADBN8DW+4d
         CZLCbdO0CH6hsZSgAAHLodu9WouOdTK9JTcVw7a0n3EIolXTmozgxYjeWbuWykrn9sQQ
         +qTiNzJ6tmV73Qv6Yf3lfhCDefG2nS5wQIAk0ztlbHIX/A8zzoKbYbT2k72IH6UVTljs
         AWLPcf1XocfGppXLKjwp001QOnw0OHj3oAhESCEAn/TC4fvmf/S/W2QezFiwRirDmuW7
         NUt2mHpMux6y0/yKOFZ7qsqPMBl2aeR9STof8ZuKc9Vl8+HjPfaDAQPodey6iglLUzGt
         yoUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GkCO8U87PDd2xBX9rOr4mr02NCqf1DfsiPflHAiOeWk=;
        fh=vhLPNldhbR6aT7mm2rUlTGuJrculO2UfZMjCdxCSzig=;
        b=J7AjQ99UTLvmfABAd57FXmqo1OCTa1N0N+TIrm3WWpudwbRhQgJF7CbdPiA8nyMQKw
         9IUE9mmf3kDrMZaARlMq4Het+QDQq82KtMrU/6vMZJIafj6G9TvcvoaIEBixaguZjbT1
         jF7ayJ/MjkWhe+YLFMFAN2Pm3BLHe58kmWovtdxSt3JytM7AYCCesWKzaH0DiQjHDeSI
         TYEM7Wj1F64QtlI/j/j5rnd15+8BafDQ6k5KYXWkVIG6BGg9p3btySRRJrbqhA31R7T+
         uiqmpd9z7i7EGF1fx7eC1Yk1n501WPj1vUSP3DjNIBABI1xQ1Z2jXMc91QLvLczeK4uL
         5+fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772639190; x=1773243990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GkCO8U87PDd2xBX9rOr4mr02NCqf1DfsiPflHAiOeWk=;
        b=ZKFENL+nWQkdmVxz/txYdmXvVTryPZsF5yY8TSNJfum48gL9+/zvSLLy9gJJ8mm6a0
         Wq+SLa1fwM3BdwKULr3yJTbL8zuEg8p8LbDS++6xblyU28DRspgFUHHozVt3uwMp+ztg
         0/E2dmjACh4ZGnXaZrHWTSeOzgZm/YGEKdxcLdqZI3O61dO4BJynDPgOCUNiM5MCzC5e
         zCc+8WqTbe4qNPgrGhHqjfpSVZ9pEk7HUnD3LVZVXWEAoUfaxHDAanat0zRK3lsoV7lg
         n+1uppwPEqLMqb+2wW0VHC6+6CBHFm1AQHB3921txv7bud2yOAkyvP5vOvRqwHMKlncW
         MfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772639190; x=1773243990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GkCO8U87PDd2xBX9rOr4mr02NCqf1DfsiPflHAiOeWk=;
        b=PtK/rgSMoexAL9ZoEqxnccJxOJsW/9bizpgHosW133Q+gQNvD4ryLgoXsm1x0qg/My
         ryBp18u+iP5Cxu1BB73mjIr7X7wPKKQ0h9nZoAFtDCbAQQGuHxpWfxcyRgr30CgGBzVN
         84NXYH3jVCnZ/o1IpaAPVM9vMnjNfR09lQRD6NHTwf6RCWS3rVcJguyqx5FDWbi9N7lq
         eSWyIxKC5X3MGakQDvH1tgpvYNGvrkL3ZtVbeNaj2SqY7BLE+D5YRXUYC/JpXwS0MzWo
         aW5Lr97Euv0rnfKLnCFm6mqFw/QerFS+RakvZhJB8MRPuSTcYAnKnzY6QLdYcbphNG7g
         dcOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxgUHk2uz/OVZmS22Nt/i1cNMvRpdIRaBjhpNHFeZRB5NmdpQfp1u936FXSZzQ+2L9RPcNSx+Tpg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWCDs5T3eVIyBhwQIM/E6YiOOAjNvQXfUcetncZvJR72dhpnDy
	rfWXkhfOq62ppxo15x0CPfEQTgsQXp+bH5hInf/zWjTFjqfzgDMDpLclgiacuF0MjbdOlwtL3tN
	xemDs5crxMk+r1yyLgm3X/KBqSEc2AH69GCSeebOn5/YPlPQAFtyoK60=
X-Gm-Gg: ATEYQzzEht5iCopkaobKw5/F8QqLgE8hXH4JoIKyMYtCueLn6soGDcq7CJ4BBk0Bm06
	0SdmuvtEaTuXLAL5J5kH7mmpJGugGvDFPNuZM/NyS2FyZcOnIst+ldcPDpOghxQbnu0I2OHvWf3
	RtA9a/LjeMyyUztKdDITkKRQDbyCbvk7zceaGgm+sT2gKbTr7ks56GvMWFwdzODmSy1P1RFNHiI
	yJvSY+zugZj/uPlapoEJIVHHZno3Tqd8+kbLnXzomtgKP87N7OE32XTCdwX2+0yu9y1Pccz36kV
	7doiWnsNQRiKCH7JJw==
X-Received: by 2002:a4a:ba01:0:b0:66a:84ca:1fa3 with SMTP id
 006d021491bc7-67b176e5dafmr714951eaf.1.1772639190574; Wed, 04 Mar 2026
 07:46:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com> <aagKTanM5Az9UDsJ@fedora>
In-Reply-To: <aagKTanM5Az9UDsJ@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 4 Mar 2026 07:46:18 -0800
X-Gm-Features: AaiRm50ME6wzDjhP0yhHyM4MRN0Z72HKTGXLDU8_-qryiqs1Sm0543HVZG0MCFU
Message-ID: <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6FA82203768
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12555-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,purestorage.com:dkim,purestorage.com:email]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 2:33=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote:
> > A subsequent commit will allow uring_cmds that don't use iopoll on
> > IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted without
> > setting the iopoll_completed flag for a request in iopoll_list or going
> > through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command could
> > call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
> > io_iopoll_check() loop currently only counts completions posted in
> > io_do_iopoll() when determining whether the min_events threshold has
> > been met. It also exits early if there are any existing CQEs before
> > polling, or if any CQEs are posted while running task work. CQEs posted
> > via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counted
> > against min_events.
> >
> > Explicitly check the available CQEs in each io_iopoll_check() loop
> > iteration to account for CQEs posted in any fashion.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >  io_uring/io_uring.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 46f39831d27c..b4625695bb3a 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct io=
_ring_ctx *ctx)
> >               io_move_task_work_from_local(ctx);
> >  }
> >
> >  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_e=
vents)
> >  {
> > -     unsigned int nr_events =3D 0;
> >       unsigned long check_cq;
> >
> >       min_events =3D min(min_events, ctx->cq_entries);
> >
> >       lockdep_assert_held(&ctx->uring_lock);
> > @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx *=
ctx, unsigned int min_events)
> >                * the poll to the issued list. Otherwise we can spin her=
e
> >                * forever, while the workqueue is stuck trying to acquir=
e the
> >                * very same mutex.
> >                */
> >               if (list_empty(&ctx->iopoll_list) || io_task_work_pending=
(ctx)) {
> > -                     u32 tail =3D ctx->cached_cq_tail;
> > -
> >                       (void) io_run_local_work_locked(ctx, min_events);
> >
> >                       if (task_work_pending(current) || list_empty(&ctx=
->iopoll_list)) {
> >                               mutex_unlock(&ctx->uring_lock);
> >                               io_run_task_work();
> >                               mutex_lock(&ctx->uring_lock);
> >                       }
> >                       /* some requests don't go through iopoll_list */
> > -                     if (tail !=3D ctx->cached_cq_tail || list_empty(&=
ctx->iopoll_list))
> > +                     if (list_empty(&ctx->iopoll_list))
> >                               break;
> >               }
> >               ret =3D io_do_iopoll(ctx, !min_events);
> >               if (unlikely(ret < 0))
> >                       return ret;
> >
> >               if (task_sigpending(current))
> >                       return -EINTR;
> >               if (need_resched())
> >                       break;
> > -
> > -             nr_events +=3D ret;
> > -     } while (nr_events < min_events);
> > +     } while (io_cqring_events(ctx) < min_events);
>
> Before entering the loop, if io_cqring_events() finds any queued CQE,
> io_iopoll_check() returns immediately without polling.
>
> If the queued CQE is originated from non-iopoll uring_cmd, iopoll request
> will not be polled, may this be one issue?

I also noticed that logic and thought it seemed odd. I would think
we'd always want to wait for min_events CQEs (and iopoll once even if
min_events is 0). Looks like Jens added the early return in commit
a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs
pending"), perhaps he can shed some light on it?

Thanks,
Caleb

