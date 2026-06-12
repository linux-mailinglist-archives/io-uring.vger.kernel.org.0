Return-Path: <io-uring+bounces-13683-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id o5AgHEByK2oQ9wMAu9opvQ
	(envelope-from <io-uring+bounces-13683-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:43:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B80DA676505
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:43:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=Zr+Vt5Dt;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13683-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13683-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DD6032A5735
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E673905E4;
	Fri, 12 Jun 2026 02:41:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7B238D52
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:41:27 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232089; cv=pass; b=IJqpKGpQszi8i85EIjhZ8rHc5RUN4v3aNcMuYQzX1vBXmrVPbbIYLpoGUc7Bf9P1Onyb+cQLnDfWa+J5flUHEWxWLk1yngAWuXx5rebURDqxsGjelZp6xjlPRUm2RxSJXkD4GWCfhufaFNyHhfoVUO0ptvfmxBQs73BUNQgavbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232089; c=relaxed/simple;
	bh=WqidCJr2lIPmxQBmCOLZYsEBZHGBvk5rpJr5ZGFwcmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jCYazKYvDuUuS469ffcNXie2OJeK4xDGaqE/07lbx5YYsazD0Y8LYlle1/jHD2ABiBLKv18RWTyp1ANJZNq6SStWuDUG/V6DXfLHABI9Ks5tCyOH2hmCYU+TVA2LCct59ThSpRkojSxj1xobseARGSF94afL2xIoOQJaIKtZyco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Zr+Vt5Dt; arc=pass smtp.client-ip=209.85.210.54
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e5f63ab07cso82657a34.1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:41:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781232086; cv=none;
        d=google.com; s=arc-20240605;
        b=CzEqTprfTBW9/co+vuCtggnAB8ZbFB7mYGtH/Raqy57ZtB20sYvsMrev0pVwyKPwNE
         5Ine0z5Dnz1YU4AYpEtZtAyIij5KX665XBSzojQW6BEWXV3/9kjMqXD9Hpg1zE3wI6Cv
         DWSM5AGdQl2Wi7XoR+3ybyvGk2+pm29ZwtsKtiY40sv1ra/3i9qAwhnREdqVslVhWFAX
         1Cv8A9zJisMI/PcnlsLX0al8nAFaiZx9nLFuQO2AaUqAJU0u9WhbQ5R5mhHLxOM+rOqA
         gCFtpc6BdfHVp7h1O7PxGYsM7z9eGMKjJ1JB0NglLh3E9pL3kboQKpZ4KDW7MagksDtu
         i4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UjJhGNYPddgFfl+swxRM9DPcHT+nrLqByLgrHCaOyGs=;
        fh=8SanVj4MV0LZcXSROTGCY35wrAI3fk+fJGDl/3jrlWo=;
        b=SFd+snK7m0P/OOaNJFlu//VIy/s9j/CG74hDpXPWBeiOBQTxxcbxQ3L3hsGdDfV49n
         LSQDu/y5eI1lFX2DtbDwRYutngXmU/QaBHQZSUn+MJh0Hn75dCk43HPnav9Q3RjibETr
         CmJR4jQrbje4FZGzqFGoR3F0cbsd29m+hLWyZI+in561PXLZF7HmldT/oERilE9//iQK
         Zw5MrpwA6EOPfW0lvuFG0ULiMO9eW7/x3xbcBNz+xbDnvG2ULxsu5YUGxSbSEjnHaJcq
         jsm7+bNBYSf/nzCp9MbhwIYPf3+rppWvKWwzBGOR3F0n0RQlUTnfUA5OqLZDu3zUP4+D
         dtXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781232086; x=1781836886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjJhGNYPddgFfl+swxRM9DPcHT+nrLqByLgrHCaOyGs=;
        b=Zr+Vt5Dt59cBvUWFd+GUAukGoYJnLUCKxSfHWMzFoR4Mf3kn1l6ADR8b2h1CTJQooU
         GmNSQ9Xeuem9309oePINBhxvtadqPK1mY7RUe7y5IZqHfzOvi+Qdbn4V1+qYTRRFBFaS
         DC3e1970C0LjLRIOpbXjumvgScPSakOc7r7ZRTqA4fKHwjsUmGC7pMcexpAcwQOqRfd4
         j9AdqDCtROvedL7ye/D+Go8B8/NvHtTOMyuo+9XAsjoXTTi8ed11MkN2nke+veL8hFN8
         MNO9gzP5DeH8AQS2gWXGM2hB1G/HlJL74XXBn+iHfarCO1nwgFImLEE6jdAJscRFo7ea
         rFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232086; x=1781836886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UjJhGNYPddgFfl+swxRM9DPcHT+nrLqByLgrHCaOyGs=;
        b=kBZN9t9LQOg0UQXUVRs3zK3310Ypyje6iIrIFQ/fNyVBRS03I0gTLw1OmAK/LQ8gEa
         Axr4vilXot4Iu68E1I9y9kEVAAVfmh4gCyyinex+7n+TtRIo7o+lA4ftPSXdSCyY0o7U
         zMvK0UWI9aGYo90dZEZjr18cr1odufnrKNymid4g5OlRWuZxCUBjfNhf0RdTISL7jEwu
         f6fTe2rfB40wYJn3oTE5Z132ejHR9nKeS1MBVD1teICmJQJXNZgpRsFec1Cju7GaJyJL
         hgCLrgI4LaWbuKASxbh++jZ62nmV8pVpDJd7eZAfJjEzgQdfD0S8DKdyqeszgY2mgTKj
         Twtg==
X-Gm-Message-State: AOJu0Yyla/0jQDDLpVsBGlhQVHlZm71/aghWlSqHQc0g0KlOZsrhtS38
	sx6zYTbBg9SJ6+tWG4Zr2WYfyotlhcZ2XRb3XcGmA3m+W44YpxCkSzkO5f1bb90CRJen5qzs1xq
	MtTWwK7YIYO1Zp4pd1al6Nsfge3CImSWfwJNMvAcHLw==
X-Gm-Gg: Acq92OFGssIJ4F4WgblAErjejwuDVfkKtekpo9UtkR1P2O7BbHfzZf0EY3JGIDqCrT3
	iFfMLRl41kn3A6KApyqDBzaq9uz/Wa0qfkJdceLTrhdWEO2oksFlD+21FOrNa/ZWk7er1tc9NMK
	C3yuPrT0KhPHjiTwGKx34kl08DzQ5sQizwwF5QitE5zfdYuVDGhVnuxI29WAzZVmJOeu+dTaY4a
	VZBC6N+A8zO3MtVwc069m29y47LUVpbAQ0+Hsckj3cAlUgSIJyIu7I65flwMylG++nb7B0gSAkc
	XcvFo2ax
X-Received: by 2002:a05:6830:700f:b0:7db:dc9e:f17e with SMTP id
 46e09a7af769-7e7847bb4b5mr313150a34.5.1781232086517; Thu, 11 Jun 2026
 19:41:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611160553.1486640-1-axboe@kernel.dk> <20260611160553.1486640-2-axboe@kernel.dk>
 <CADUfDZpQuB=TsQT2aZFkwhsHBhXQnzowPJQa4Fs6z+PA558qcw@mail.gmail.com> <85660b71-05ce-4a60-a34b-277851e74c1b@kernel.dk>
In-Reply-To: <85660b71-05ce-4a60-a34b-277851e74c1b@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Jun 2026 19:41:15 -0700
X-Gm-Features: AVVi8CfwdtniGXgAZYcFfMfZlcVpI2F-uRW6N25brwdygxT3jSBNmDIkSvM_hR0
Message-ID: <CADUfDZop=3BS7iBvg4Gnj+pRsy1hS63vosuyeqxm1-t-2mj55Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13683-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,mail.gmail.com:mid,purestorage.com:dkim,purestorage.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B80DA676505

On Thu, Jun 11, 2026 at 7:21=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/11/26 7:13 PM, Caleb Sander Mateos wrote:
> >> + * Push a node onto the queue. Safe against concurrent pushes from an=
y context,
> >> + * and against the (single) consumer. Returns the previous tail node,=
 which is
> >> + * &q->stub if and only if the queue was empty before this push.
> >> + */
> >> +static inline struct llist_node *mpscq_push(struct mpscq *q,
> >> +                                           struct llist_node *node)
> >
> > It seems odd to return the previous tail node. The pointer can't be
> > dereferenced, as the node could be popped and freed at any point. The
> > return value is only compared against &stub  to determine whether the
> > queue was empty. Seems like the interface would be simpler and avoid
> > leaking implementation details by just returning whether the queue was
> > empty before the push.
>
> That's not a bad idea, I'll take a look at that. I have a v2 of the
> series which converts the non-defer task_work as well, so need to send
> that out. Will do so tomorrow.
>
> >> +{
> >> +       struct llist_node *prev;
> >> +
> >> +       node->next =3D NULL;
> >> +       /*
> >> +        * xchg() implies a full barrier, so the initialization of the
> >> +        * entry (including ->next above) is visible before the node c=
an
> >> +        * be reached, either via ->tail or via ->next chasing from th=
e
> >> +        * head once the store below has linked it.
> >> +        */
> >> +       prev =3D xchg(&q->tail, node);
> >> +       WRITE_ONCE(prev->next, node);
> >
> > I think this needs to be a release-order store and the READ_ONCE()s in
> > mpscq_pop() need to be acquire-order loads. Since mpscq_pop() doesn't
> > necessarily load q->tail, there's no happens-before relationship
> > between pushing a node and popping it.
>
> Don't think that's necessary. The xchg() is fully ordered and hence acts
> as smp_mb() on both sides =E2=80=94 so every init store propagates before=
 the
> link store. A release on the link store would only add ordering for
> stores issued between the xchg and the link, but we have none of those.
>
> For the consumer, every dereference of a node should be
> address-dependent on the READ_ONCE() that observed it.
> Address dependencies from marked loads are honored everywhere, for
> example alpha even has a read barrier there.

I'm not too familiar with the Linux kernel memory model, you're
probably right :)

Best,
Caleb

>
> >> +       return prev;
> >> +}
> >> +
> >> +/*
> >> + * Pop the oldest node off the queue, or return NULL if no node is av=
ailable.
> >> + * NULL is returned both when the queue is empty and when a producer =
has
> >> + * published a node via ->tail but hasn't linked it yet; use mpscq_em=
pty() to
> >> + * tell the two apart. Single consumer only, with headp being the con=
sumer
> >> + * cursor that mpscq_init() set up.
> >> + */
> >> +static inline struct llist_node *mpscq_pop(struct mpscq *q,
> >> +                                          struct llist_node **headp)
> >> +{
> >> +       struct llist_node *head =3D *headp;
> >> +       struct llist_node *next =3D READ_ONCE(head->next);
> >> +
> >> +       if (head =3D=3D &q->stub) {
> >> +               if (!next)
> >> +                       return NULL;
> >> +               *headp =3D next;
> >> +               head =3D next;
> >> +               next =3D READ_ONCE(head->next);
> >> +       }
> >
> > I would find it a bit clearer to avoid using "next" to refer to the
> > actual head in the stub case:
> >
> > struct llist_node *head =3D *headp, *next;
> > if (head =3D=3D &q->stub) {
> >         head =3D READ_ONCE(head->next);
> >         if (!head)
> >                 return NULL;
> >        *headp =3D head;
> > }
> > next =3D READ_ONCE(head->next);
>
> I'll see if I can make that part look neater, I agree with you here.
>
> >> +       if (next) {
> >> +               *headp =3D next;
> >> +               return head;
> >> +       }
> >> +       /*
> >> +        * 'head' is the last linked node, it can only be handed out o=
nce the
> >> +        * stub has taken its place as the tail. If the cmpxchg fails,=
 a
> >> +        * producer has made a new node the tail but hasn't linked it =
to 'head'
> >
> > nit: "but hasn't linked 'head' to it" since the pointer goes from head
> > to the new tail?
>
> Good catch, yes it should read from head to new tail.
>
> >> +        * yet - bail and let the caller retry.
> >> +        */
> >> +       q->stub.next =3D NULL;
> >> +       if (try_cmpxchg(&q->tail, &head, &q->stub)) {
> >> +               *headp =3D &q->stub;
> >> +               return head;
> >> +       }
> >> +       return NULL;
> >
> > An early return if the try_cmpxchg() fails would reduce indentation of
> > the successful path.
>
> I deliberately wrote it that way, reads better to me...
>
> --
> Jens Axboe

