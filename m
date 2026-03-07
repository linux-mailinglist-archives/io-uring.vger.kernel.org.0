Return-Path: <io-uring+bounces-12580-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHeFHK6Bq2mwdgEAu9opvQ
	(envelope-from <io-uring+bounces-12580-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 07 Mar 2026 02:38:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE2D229686
	for <lists+io-uring@lfdr.de>; Sat, 07 Mar 2026 02:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D7E83024C9C
	for <lists+io-uring@lfdr.de>; Sat,  7 Mar 2026 01:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D812EB87B;
	Sat,  7 Mar 2026 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Mu5/zIKl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770342DC772
	for <io-uring@vger.kernel.org>; Sat,  7 Mar 2026 01:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847509; cv=pass; b=pkg4YSsOVO11FP8rxmEv4OsVkREDkaEbOBr0p61NWZLaqY1oiSG7IDReh6XVW+MUGbaAltU1kCLOm7fns8ToTNYKi1jYoIVyEUXg+T6FafXfMjXSXJr2td4EsLLwDOU91/lffkD3/BQcfG/vUaEa9rEzDy2OTijMGueuuCuqOPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847509; c=relaxed/simple;
	bh=Ijawp+qr5tzmHJWieGSJkh9DBVbbAcehmSL76Go0bcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ThAlBzwQef/ADcqoxN8EOa1vRYM+MmbzFgTIvb7v3+MX6fWWUtll/r9FinSd6fWZYZ29xWXtX57L6oNxmFu+50ZuQ95CxUmZnKcrawQGLH+8R3olXKJbhp8A00xkcvuh8gtgd5oJ1Fqwt8LH+2LEYATOehefc2iMh2XFS5LUCq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Mu5/zIKl; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6779875efa2so639364eaf.1
        for <io-uring@vger.kernel.org>; Fri, 06 Mar 2026 17:38:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772847506; cv=none;
        d=google.com; s=arc-20240605;
        b=Mz8jmCSrVHFIELUelFQeFfDGSNt9ITncx7V9dOGb30G8g80yQZaN13YNYHAofDqlE8
         niCzpQBrw8j4olegxglxIxC/1RqOQp2+ihjSuWK7zGJaHKue5mLgjxJZGbND7tMGy7tY
         wQUzDB5GsmI+ivO/TQVUr+zjjZb1f2TkyFxX7isy7fNCS48+i22A0BJ3AKKHHRwHyS4M
         78Ep3ghdRI+PgNf+n8orEjB2CmytMCsjB29Z9APMO4K0qV2xeOa8a5HNr44EBUTfjvVY
         GPOjsHpA8cbqU9TN3WyBcmMsHlwpoPxLcIdD+Zjbe20RDw1CIoUg7ox0ekIpSWkXSuUL
         1QvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XVr4Mu9HxXeAvAZT+n+MNzB0B1nXnQUrPhRWUN3nixs=;
        fh=8qa4AaZtFPYCNyPObVkSelyOdYCTI9igu48jDUCm7og=;
        b=LGvun63dYefJTqzKWq9ksjNK6wqPCRRlSAjnUQlRF8xfYGiNKLJGaVwhDbqRi+05rV
         pWEzpEGu335HDEUprPUBnEfbP9peOZjK7/fGQnLMzoX0qfq/AnF9WsiXS4S58QJc0ElK
         ST7GaswOrdamue8STXMeSASYewJl7DpsLIC5oVo2Vqv8XMj9XHNDfeHmWXB8fLQQtNkH
         pJYQfWlsy+ZtKPQZ/TPDa9zxp4bFa7kVJ6AAPo0sjhuSn1Cn7owFspe6DHP4AUf0Ezkm
         VFeVub7vW5Zi13r7xr+6SD3r2wygN93Ig4SdEnrF6NmiWgNsyY8VhaNUuOsGUNvghE5K
         fBUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772847506; x=1773452306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XVr4Mu9HxXeAvAZT+n+MNzB0B1nXnQUrPhRWUN3nixs=;
        b=Mu5/zIKljrVuQLGi44sOxn04h/PVf5FMi1inv7HYbTuV22weapGCDryIqr1fMFYNHV
         sgqpNGmVdpQ5LDr04ubji1Q4k7uSmWUWRxQxcYafM1Bkf9K/88yao96FhQj11iz0ut+W
         6X2M1rHjhIQDO7W4EoH1XDk3yOnLjV5DYPcizaSFYQR23zSRjmaK/bUf9xW2L2tzpioA
         OhCbBBkg+2t1BrxDDtYroDbi4I/KFwnavqzfR88kbkZsBK5jEJwLox9WBVwtaM+jNMZk
         YKr0GH3ApiFzQ9bDmcM8PHVIJcKB0cSFxtMDmRW3prZsAo9odU+ehuWol6K8DU6RKAC8
         hyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772847506; x=1773452306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XVr4Mu9HxXeAvAZT+n+MNzB0B1nXnQUrPhRWUN3nixs=;
        b=TE09+iS71qBgwoGFgOgL3zHAf66s+lvqIYSxW0rl2U7yqOJs8CF7vP3Ur7BVotdBlM
         G2BOrffPCjm1U9kFShTAOdw3EiborvPzbKdmnEOLiW86I7uciTkOoCyhfwBws6DQt4Z9
         y9Cw+emFr+DHOODZ8AixqzLOQ3C4yfU2qJSrtyh+DxOg+/kCeTesXhUzKJWP/qaEQTKo
         YpYxQG1rhCrKL5IHS2HDHvb8emsWm3ZGBy4J4/Ci/mjLHqIh/XbDseiapnckNhfIhDG5
         381oGLipLLTA9/7PuA8qeye1i76On+bTLr38NLPRVWz1zZDhh+6/gtJDdUav3lOwP61e
         M2NQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7yoNdxOtg24WyZZ1/gyo88rxcAzR4c4cXNQ1NRAyX8Bx1X3svUsU7QNgXT4itrWIDbFSTwlxU5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTtTkHxFarTpbDip8RgHr2rXCiKgu6n5Sn7E+9D6K371Z5qvBk
	v/e5Alotq9JD6Y3Aw1CTeL90RFFFbK/g1vSiXlB00ub/6do9ECEeE9HTTshwjl+HOmrNOPR26dn
	D4tMNSMrEm6bQiAYl0DDCmAo+MfDJHUX+8kor7lhCEg==
X-Gm-Gg: ATEYQzyTiN2CBBc6MN2zkdTeEDiUFwR77PlsCK90oFeMJOxjGDqsTlzbzK/g1lkFH4w
	lvsBfhElba/kck0kBn2kTOlAnHkOX6WKi1nBWxeierYX9uIKOSU/4gCbx9H4Lwzo/+3hmalHx6V
	b7+JkrZpGRRQeUZCqXYItCtImSIkPs0y7CdOS62nMmb3Koi7hSVckQDn0UHintcIJSB+n/z+dWA
	3MAZhPKnig9iScgbQ3RKefIFuPS5mBvjMQdIT+6V1LxmON/CA6tEPi2j30ZGXqHrCppMDeGitwU
	cpbidfeX
X-Received: by 2002:a05:6820:3302:b0:67a:1cf1:a413 with SMTP id
 006d021491bc7-67b9bb6e5d1mr1266737eaf.0.1772847506363; Fri, 06 Mar 2026
 17:38:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com> <aagKTanM5Az9UDsJ@fedora>
 <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com> <a6591d03-3707-4f1c-b1fa-49f010f98d53@kernel.dk>
In-Reply-To: <a6591d03-3707-4f1c-b1fa-49f010f98d53@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Mar 2026 17:38:15 -0800
X-Gm-Features: AaiRm53Xogk7L6yD1Xoposf2XIZMV_wPnho43LlH5PzUQLffjxfNhTFbldlbwNA
Message-ID: <CADUfDZp0shyZ5FqfEcwbi0tHXOFqwqZKRvwQW=heR-yvaOaw0Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EAE2D229686
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12580-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.959];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,purestorage.com:dkim,purestorage.com:email,kernel.dk:email,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 8:29=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/4/26 8:46 AM, Caleb Sander Mateos wrote:
> > On Wed, Mar 4, 2026 at 2:33?AM Ming Lei <ming.lei@redhat.com> wrote:
> >>
> >> On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote:
> >>> A subsequent commit will allow uring_cmds that don't use iopoll on
> >>> IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted withou=
t
> >>> setting the iopoll_completed flag for a request in iopoll_list or goi=
ng
> >>> through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command cou=
ld
> >>> call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
> >>> io_iopoll_check() loop currently only counts completions posted in
> >>> io_do_iopoll() when determining whether the min_events threshold has
> >>> been met. It also exits early if there are any existing CQEs before
> >>> polling, or if any CQEs are posted while running task work. CQEs post=
ed
> >>> via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counte=
d
> >>> against min_events.
> >>>
> >>> Explicitly check the available CQEs in each io_iopoll_check() loop
> >>> iteration to account for CQEs posted in any fashion.
> >>>
> >>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> >>> ---
> >>>  io_uring/io_uring.c | 9 ++-------
> >>>  1 file changed, 2 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>> index 46f39831d27c..b4625695bb3a 100644
> >>> --- a/io_uring/io_uring.c
> >>> +++ b/io_uring/io_uring.c
> >>> @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct =
io_ring_ctx *ctx)
> >>>               io_move_task_work_from_local(ctx);
> >>>  }
> >>>
> >>>  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min=
_events)
> >>>  {
> >>> -     unsigned int nr_events =3D 0;
> >>>       unsigned long check_cq;
> >>>
> >>>       min_events =3D min(min_events, ctx->cq_entries);
> >>>
> >>>       lockdep_assert_held(&ctx->uring_lock);
> >>> @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx=
 *ctx, unsigned int min_events)
> >>>                * the poll to the issued list. Otherwise we can spin h=
ere
> >>>                * forever, while the workqueue is stuck trying to acqu=
ire the
> >>>                * very same mutex.
> >>>                */
> >>>               if (list_empty(&ctx->iopoll_list) || io_task_work_pendi=
ng(ctx)) {
> >>> -                     u32 tail =3D ctx->cached_cq_tail;
> >>> -
> >>>                       (void) io_run_local_work_locked(ctx, min_events=
);
> >>>
> >>>                       if (task_work_pending(current) || list_empty(&c=
tx->iopoll_list)) {
> >>>                               mutex_unlock(&ctx->uring_lock);
> >>>                               io_run_task_work();
> >>>                               mutex_lock(&ctx->uring_lock);
> >>>                       }
> >>>                       /* some requests don't go through iopoll_list *=
/
> >>> -                     if (tail !=3D ctx->cached_cq_tail || list_empty=
(&ctx->iopoll_list))
> >>> +                     if (list_empty(&ctx->iopoll_list))
> >>>                               break;
> >>>               }
> >>>               ret =3D io_do_iopoll(ctx, !min_events);
> >>>               if (unlikely(ret < 0))
> >>>                       return ret;
> >>>
> >>>               if (task_sigpending(current))
> >>>                       return -EINTR;
> >>>               if (need_resched())
> >>>                       break;
> >>> -
> >>> -             nr_events +=3D ret;
> >>> -     } while (nr_events < min_events);
> >>> +     } while (io_cqring_events(ctx) < min_events);
> >>
> >> Before entering the loop, if io_cqring_events() finds any queued CQE,
> >> io_iopoll_check() returns immediately without polling.
> >>
> >> If the queued CQE is originated from non-iopoll uring_cmd, iopoll requ=
est
> >> will not be polled, may this be one issue?
> >
> > I also noticed that logic and thought it seemed odd. I would think
> > we'd always want to wait for min_events CQEs (and iopoll once even if
> > min_events is 0). Looks like Jens added the early return in commit
> > a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs
> > pending"), perhaps he can shed some light on it?
>
> I don't  recall the bug in question, it's been a while... But it always
> makes sense to return events that are ready, and skip polling. It should
> only be done if there are no ready events to reap.

Ming, are you okay with preserving that behavior in this patch then? I
guess there's a potential fairness concern where REQ_F_IOPOLL requests
may not be polled for some time if non-REQ_F_IOPOLL requests continue
to frequently post CQEs.

Jens, any thoughts on this series? Is it ready to merge?

Thanks,
Caleb

