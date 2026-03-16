Return-Path: <io-uring+bounces-12714-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MCRvD/aUuGnTgAEAu9opvQ
	(envelope-from <io-uring+bounces-12714-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:40:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4FF2A20A4
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED1B83069D16
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867CE372670;
	Mon, 16 Mar 2026 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Lg23Cqaa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302C236C0D3
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 23:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704379; cv=pass; b=V6vzXncPwnFC2PwxfTSwnQgiUtXJceXSKS+iB43EBOlJcWkXerfaj8IISc1SWMPYutlqC32yS2YxlbCIxBq6bsW9gTgwUj8q4ywLGWG+AsbuHtZ7CKBuBjLEZsVA92LEz9aY1YsFWVJgEatpU20K1qK/ct+jU2xDDUQoX2r+WRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704379; c=relaxed/simple;
	bh=uYGLExfRlc+HhkeAMFc6Z5ahTLHpCCJvxZ5oLlDo24o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o8m5uTpKdajbLQ/vHy+6CVIB8qmEKBiFCPp/OjyzWRZvNvWu5NwdB82qHyqL9rR/39PnD0m+9sUfHJZZEVpVCgzsTj89o1Qa9wSBsxBRVcTI7XqSi9Ifsb38iMzkVNWo4djrS1MGDZKu9XU2Fzf5swznFICyn4MN1OiNwROKHN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Lg23Cqaa; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40efb4bceb6so645022fac.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 16:39:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773704376; cv=none;
        d=google.com; s=arc-20240605;
        b=ONP6z6XWtfvbYiiwceE4tbpf1tc2gesQ9cwleEnMwgiPkp5Y13U9I560Bw48Rts7yr
         Re5CrunnbPpOLgBxpnNhj+7a1E6g3pAqjV6+Ne8P5Iy8YcgAYPFPbkoKkk3kjcmKLPdq
         zCT7lWU4pGDVKxceaBGtfrneykJ6gYMKoJuDF1napDP3JGSK5P+yyKs6aCdhpPvlTHKO
         MioCwNQMdALiCLR5UI7srZt/oHY0cir8W273sNRgGz0xCr+JYcpYQenQY5wpK1vkrrVS
         YmyaSsBc3LZCJ2YcINkfQt0TibXJX1rUGglBSP71eW8y4ewS8d0T8f49Q2t37DWfJpR8
         fSoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pX3IZwbQWIREe0cd2yZ6WTCN0aV+1yG3Zml24cd+TQU=;
        fh=a7CAxks0nINXOPhcWYfFKITS2NqclO90fUeqMFGzFaQ=;
        b=MDEgzhzL/V2/qduRFktBgvh/lUrQykqgdY6phQcHI+3e8vcKcYscMHXhFN3JLC65wu
         345hCDKq5tw25kP3fk/qLPOTfoDP2dtE8YpStLsQORgSrd23UhKK5tFSrLdJfKw4G3po
         DMO8s81G9gCfYBxpmV6wduMdd2P5+9kGucFEVBngiUzPs3EahyifOlo0IqeO0XvgkL2G
         /u/JGQXjLnWjW2Gzb0Pg3nW0NVtAsV2hto2ty3ljCqr4SKx5T+8e4bTBvAW0DOudxtRJ
         yiyvBGyAyZ+JvWf2z2RubJJfaprGVoyKEzW4hZOv+ipDZ/mGatf5qjUbc5/WGhcsykDJ
         rz/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773704376; x=1774309176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pX3IZwbQWIREe0cd2yZ6WTCN0aV+1yG3Zml24cd+TQU=;
        b=Lg23CqaaDt7yLuubORT5QM6Bb7G/4wzqZ+liDPvYH+pKjvK9aX+QEHUlPUZYsmc0GA
         hBfFDnj9o5kFlcuOe2a/9sRYtKBy+0J3PEakdGplEV9il7XI3EjCFaHmW1AHUWP1hfcr
         34Wcq0ZXudkXoN3BxsZlh5v3rTAkeDd+C6CjBHkugcc5NjIsLy1OD3paDtUzc1aei7fu
         p795KXIj9+Z9DpinXLigrKMFu8L9ujVNyA5HrD0zoHBk4MxcpvD9GdPXZOE5pR5slwB9
         aSqE3spc3vPEnTr6YrIpmo6Ft4tOO8MNwBMe6HKVFgANukpDb4nF09DePcgRpt7DUsBU
         ZWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773704376; x=1774309176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pX3IZwbQWIREe0cd2yZ6WTCN0aV+1yG3Zml24cd+TQU=;
        b=Y2VLsVVgAmMTkGWLXTXLG10x7H2Esmo0un05kM+C3LsS2XRHdjD7DQ8QPNhfg3lfbt
         L7ntr5AdBDHPk0e1W1YZKMx+41kyH9tQX7JEvZSLbSnGybEaw8DchbrjR+3XjygaFRg3
         xaLXbu73Nea95mQAJHUAyxiu41rd447dE/JjR4s/Q3Uo719asOe7rL9j+z+RqVrXryJ7
         TA/YCzKHP8kUhGY5OK4kayfrXcAmzxkjSXUOYhUyR1jDmDtHOrFScMePdrUFKA4gZkum
         zj+Ws5FE8b5WTUu4bjNsEN7v0sv5dWBCAOnPoJ7lz7sNeULMiL7Pe0dZ1b6F6Nq2C9S1
         /4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHkmt8lelCap+ZOzrnJt+vDnr7Xj1C0ew7h9lJnNugpPitviEj8J+NmPlFcDx4LfNbkUevTZrWrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlbaYfxiKR7DfBgTEyZeC8OMOIAGK6qHghVtuTbPMRGtdHrJHs
	PyXI7ntB6yEE/KPRoEIaAmDDtriM7bJqT9ow2ksQv2aLIT1GB972IJFYy416Y2wETodVDtJz+Ie
	KBIzgfeLtptNRakQ/W6yE3DtLuyEtOsowUbVkQkQJGQ==
X-Gm-Gg: ATEYQzwawFWwfWSfPhJyZhvHNyaaoSOAQ3DcWXbdIHxA44tnHi54QERI/PeW7XOU8MQ
	io0ctHJ+QBUwyJU1WlmrZBZhtMV8DQC+0rZWMBGC7uGnHjpXt+u7KzE1RQu18chBKEjXq+esKf2
	MFCdeEbmAcplEyRf2pKesBtrWqt2pCH+3CiJ50tepdtMkf9/vX7KsnVuPM9eaiei++MTnjdMWM7
	ecyXYloFHTZwpaAnPEwHk6ExCQNusUvm8O6lQKnQE5CWuGEug+QtU8BwLA8ZAUMPQUtC4Lzo+rz
	UwqwRvkF
X-Received: by 2002:a05:6808:1809:b0:467:17f3:68b6 with SMTP id
 5614622812f47-46757672b91mr6527707b6e.8.1773704376036; Mon, 16 Mar 2026
 16:39:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com> <aagKTanM5Az9UDsJ@fedora>
 <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com>
 <a6591d03-3707-4f1c-b1fa-49f010f98d53@kernel.dk> <CADUfDZp0shyZ5FqfEcwbi0tHXOFqwqZKRvwQW=heR-yvaOaw0Q@mail.gmail.com>
 <aauO72ocnZRhJkiA@fedora> <7dfb5a9b-9af2-4463-b9a1-0eb680fd6c47@kernel.dk>
In-Reply-To: <7dfb5a9b-9af2-4463-b9a1-0eb680fd6c47@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 16 Mar 2026 16:39:25 -0700
X-Gm-Features: AaiRm50nhenZoBbLC8Sk9TzZIBg4dRriB4JHlfVxfFsnUKJQpFv4BSA4wVnHWLg
Message-ID: <CADUfDZpJjncxh1URmNkAsuhBjapFY3-MRfDas8rfBiyh8Hi3GQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12714-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: DD4FF2A20A4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 16, 2026 at 3:11=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/6/26 7:35 PM, Ming Lei wrote:
> > On Fri, Mar 06, 2026 at 05:38:15PM -0800, Caleb Sander Mateos wrote:
> >> On Wed, Mar 4, 2026 at 8:29?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 3/4/26 8:46 AM, Caleb Sander Mateos wrote:
> >>>> On Wed, Mar 4, 2026 at 2:33?AM Ming Lei <ming.lei@redhat.com> wrote:
> >>>>>
> >>>>> On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote=
:
> >>>>>> A subsequent commit will allow uring_cmds that don't use iopoll on
> >>>>>> IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted wit=
hout
> >>>>>> setting the iopoll_completed flag for a request in iopoll_list or =
going
> >>>>>> through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command =
could
> >>>>>> call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
> >>>>>> io_iopoll_check() loop currently only counts completions posted in
> >>>>>> io_do_iopoll() when determining whether the min_events threshold h=
as
> >>>>>> been met. It also exits early if there are any existing CQEs befor=
e
> >>>>>> polling, or if any CQEs are posted while running task work. CQEs p=
osted
> >>>>>> via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be cou=
nted
> >>>>>> against min_events.
> >>>>>>
> >>>>>> Explicitly check the available CQEs in each io_iopoll_check() loop
> >>>>>> iteration to account for CQEs posted in any fashion.
> >>>>>>
> >>>>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> >>>>>> ---
> >>>>>>  io_uring/io_uring.c | 9 ++-------
> >>>>>>  1 file changed, 2 insertions(+), 7 deletions(-)
> >>>>>>
> >>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>>>>> index 46f39831d27c..b4625695bb3a 100644
> >>>>>> --- a/io_uring/io_uring.c
> >>>>>> +++ b/io_uring/io_uring.c
> >>>>>> @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(stru=
ct io_ring_ctx *ctx)
> >>>>>>               io_move_task_work_from_local(ctx);
> >>>>>>  }
> >>>>>>
> >>>>>>  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int =
min_events)
> >>>>>>  {
> >>>>>> -     unsigned int nr_events =3D 0;
> >>>>>>       unsigned long check_cq;
> >>>>>>
> >>>>>>       min_events =3D min(min_events, ctx->cq_entries);
> >>>>>>
> >>>>>>       lockdep_assert_held(&ctx->uring_lock);
> >>>>>> @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_=
ctx *ctx, unsigned int min_events)
> >>>>>>                * the poll to the issued list. Otherwise we can spi=
n here
> >>>>>>                * forever, while the workqueue is stuck trying to a=
cquire the
> >>>>>>                * very same mutex.
> >>>>>>                */
> >>>>>>               if (list_empty(&ctx->iopoll_list) || io_task_work_pe=
nding(ctx)) {
> >>>>>> -                     u32 tail =3D ctx->cached_cq_tail;
> >>>>>> -
> >>>>>>                       (void) io_run_local_work_locked(ctx, min_eve=
nts);
> >>>>>>
> >>>>>>                       if (task_work_pending(current) || list_empty=
(&ctx->iopoll_list)) {
> >>>>>>                               mutex_unlock(&ctx->uring_lock);
> >>>>>>                               io_run_task_work();
> >>>>>>                               mutex_lock(&ctx->uring_lock);
> >>>>>>                       }
> >>>>>>                       /* some requests don't go through iopoll_lis=
t */
> >>>>>> -                     if (tail !=3D ctx->cached_cq_tail || list_em=
pty(&ctx->iopoll_list))
> >>>>>> +                     if (list_empty(&ctx->iopoll_list))
> >>>>>>                               break;
> >>>>>>               }
> >>>>>>               ret =3D io_do_iopoll(ctx, !min_events);
> >>>>>>               if (unlikely(ret < 0))
> >>>>>>                       return ret;
> >>>>>>
> >>>>>>               if (task_sigpending(current))
> >>>>>>                       return -EINTR;
> >>>>>>               if (need_resched())
> >>>>>>                       break;
> >>>>>> -
> >>>>>> -             nr_events +=3D ret;
> >>>>>> -     } while (nr_events < min_events);
> >>>>>> +     } while (io_cqring_events(ctx) < min_events);
> >>>>>
> >>>>> Before entering the loop, if io_cqring_events() finds any queued CQ=
E,
> >>>>> io_iopoll_check() returns immediately without polling.
> >>>>>
> >>>>> If the queued CQE is originated from non-iopoll uring_cmd, iopoll r=
equest
> >>>>> will not be polled, may this be one issue?
> >>>>
> >>>> I also noticed that logic and thought it seemed odd. I would think
> >>>> we'd always want to wait for min_events CQEs (and iopoll once even i=
f
> >>>> min_events is 0). Looks like Jens added the early return in commit
> >>>> a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs
> >>>> pending"), perhaps he can shed some light on it?
> >>>
> >>> I don't  recall the bug in question, it's been a while... But it alwa=
ys
> >>> makes sense to return events that are ready, and skip polling. It sho=
uld
> >>> only be done if there are no ready events to reap.
> >>
> >> Ming, are you okay with preserving that behavior in this patch then? I
> >> guess there's a potential fairness concern where REQ_F_IOPOLL requests
> >> may not be polled for some time if non-REQ_F_IOPOLL requests continue
> >> to frequently post CQEs.
> >
> > IMO, the fairness may not a big deal given userspace should keep pollin=
g
> > if the iopoll IO isn't done.
>
> I think so.
>
> > But forget to mention, if non-iopoll CQE is posted and ->cq_flush becom=
es
> > true, io_submit_flush_completions() may not get chance to run in case o=
f
> > the early return.
> >
> > Maybe something like below is needed:
> >
> > @@ -1556,8 +1556,10 @@ static int io_iopoll_check(struct io_ring_ctx *c=
tx, unsigned int min_events)
> >          * If we do, we can potentially be spinning for commands that
> >          * already triggered a CQE (eg in error).
> >          */
> > -       if (io_cqring_events(ctx))
> > +       if (io_cqring_events(ctx)) {
> > +               io_submit_flush_completions(ctx);
> >                 return 0;
> > +       }
>
> We should probably experiment with this a bit, I don't think it's a
> showstopper for merging this.

I don't think it's an issue currently. Any path that posts CQEs
(synchronously during submit, from task work, or iopoll) already calls
io_submit_flush_completions()/__io_submit_flush_completions(). In
other words, there's no way to reach this io_cqring_events() branch
without the CQEs having already been flushed. If a new path were added
in the future that could post CQEs outside of those contexts, it would
of course need to ensure io_submit_flush_completions() is called after
posting the CQEs.

>
> Caleb, I think we can stage this for 7.1 and see how it goes.

Sounds good, thank you.

--Caleb

