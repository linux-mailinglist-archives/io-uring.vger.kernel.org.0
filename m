Return-Path: <io-uring+bounces-13749-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Z9yKBAhiMWpgiQUAu9opvQ
	(envelope-from <io-uring+bounces-13749-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 16:47:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBEC690A81
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 16:47:35 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FqSyegQ0;
	dkim=pass header.d=redhat.com header.s=google header.b=OJBUOMyj;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13749-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13749-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D10F8301E56D
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23A43BED08;
	Tue, 16 Jun 2026 14:47:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A90D3BFAEA
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 14:47:32 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781621253; cv=pass; b=GwjA8D6vMFtObJ+abVnlSeVn6L0mfso+VzLcmt/ahiuqmkUNijnJcJxag+yejwDVvdRIHAfUdvn4fZLrNp6YWNeX9H/YYrJgE5QhGszmd8sJr4lmQ/ErKBKXdsQDnbCAMD0kHPnGACfU518v6UvHbIFP/GC8ebt8IKv2ux0akrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781621253; c=relaxed/simple;
	bh=/1sHD3/vzJESxfr2r6Yer6o1Wz7JF2iUgyJ6rUhBIrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZZr6+hQbNohKGo/Nt3MxQvQ/TKfsd5VTuMQL80puN0TRZOU7dwxv0u1E4uSJMj+H2YrGP3kTnERCSfz1yzlqjZTEndo3yEI7rbS61Meb8tzLWxVjKg0AVn1rl5EmiTG/G7dyRWofBjZY5asZWmWNOIYb8XUAvT+sfFUFHYGUqf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqSyegQ0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJBUOMyj; arc=pass smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781621251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=icGgkMu92P1m8z9FxlIKr61RYcU/vWh5RpOxRZBZ0Vk=;
	b=FqSyegQ0s3/VGHasozQd9RAX6ppZW8fuLud8B12sxlikfRPy935ZnIufYrfmkBYn5wAX1L
	kdfZvfdaF1XMUTYBlStJ5XGMNDMvib5qMT6ga9Qun/8vmK7oSDUxNPanlPpFZrVAriVlik
	OkTD5od9Ws52rmcjRwV87EiKNu02JeE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-jAtSRZmnO8SqpnGCRMh3gA-1; Tue, 16 Jun 2026 10:47:30 -0400
X-MC-Unique: jAtSRZmnO8SqpnGCRMh3gA-1
X-Mimecast-MFC-AGG-ID: jAtSRZmnO8SqpnGCRMh3gA_1781621249
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-bebacba844bso427205366b.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 07:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781621249; cv=none;
        d=google.com; s=arc-20240605;
        b=HfaOXDX/1t0oba0GB+iTfZ5u4DlIIDM2DBULxmE/z9u/IKVYodIYCwQI7WNzVMaG1M
         cRM+hpZkbTS3AK3t8QojlixIxcOmtyt2vKLM0BIKMO4w0bSXqdWW1yvJKp294q9ocoXA
         maJi3IcUUz4fm7SA776mB48UyjcnXH6g2iorPimHTbX36yUu7KdFyy5r5JBc3J9XZG5Q
         Jb9svfiAlJC1iGRhMLeK6c5qaG3pBxBUj9Z++Uqo9vA0S+INJIjae0Z+NIpFVdOR3OI6
         5u9K4Ym+x00GMbqdsMGhHmqA13UfoZiF3wI+KSJ7b3iBRI8oVva267CTlH32BxZKF0M8
         EZLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=icGgkMu92P1m8z9FxlIKr61RYcU/vWh5RpOxRZBZ0Vk=;
        fh=uSmU18gOf8eZN2D972hAmuQM5I3kpIKk1T8Mc7BkYN8=;
        b=BWHIgtrLPBpACzb6EvBFsSq2LdioObuFAVBUZSG2W4s/NgCUM0qtEl7CA7fjBn++RG
         N3783VgVsBKv8tCFoI1421Ing6/H1vuLY39qAXYrMi3WTvlWZeeKaWKmDd72whqj8q6D
         2JfPxPvfelZnzMFtwWubhumO51U5WJs3JhjZlaxZSWhi4eGLOw1lUv52RCfXjtsrJapQ
         V+xXf568p124ZEJY8qH0N1q5bkZycDI+EpBFy/DOztfywrc0hi9spXWqPcciSPFisnIC
         gB/YNgRrgO94tGGC+Gexo5o1odBB48zKsaG/mJc1WPpbBnbk0wfClyVqqku+uG/TmR1k
         mJBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781621249; x=1782226049; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icGgkMu92P1m8z9FxlIKr61RYcU/vWh5RpOxRZBZ0Vk=;
        b=OJBUOMyjeYXiFXr6Qa2oupg0hCdGycN1Smlyhn2RkRnmPzxEe3sLzxN+limiHwIx+d
         OKlsVGkN5fsLZZoakIX9tTWSYe4qJh9eRO9A3XOEG7R3a8HH8SkiQ75jHKrlVRxzhms3
         R6QDB4YBfqrwfKuEYkP5UKhJ72K9Z46AqZ8AtR8lm+wyqb4biEJsnsKMPsjEFy/YO5f0
         Maip+iSmUdZYLMlITJqyIIWpEZhEONEHXzAPpEDDXFI4EI3Pkbvbiek4JpIEWgqAUX/m
         pEZmBCLRxe76N2Rg+aIeNS7uwFqmvvCpfAHdd3oXVtSjF7yV9m2jxOzcursOv9kOfsIn
         hKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781621249; x=1782226049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=icGgkMu92P1m8z9FxlIKr61RYcU/vWh5RpOxRZBZ0Vk=;
        b=mzJvLehpvDR7Lz32ANeAgYeuHt+cajJVRz9kSIbtXSuaDYrvOrT/MRb4nAmehSnYcU
         bUdRMSYfsC+xyS9F+T4ZiC0ZRU1d/MVrBV3L606DGlynSb+C3xeVWzzoiP5Ap3IhaWDo
         gTdK+riRM4olJVv9wKrWn3dmZXR+G6od1d4bppsW02DUY/y0eUpEsyhGKZdbrBngS2th
         VxC20P3sogzyhUGFQpuzrMTTA15RYC/cdtJiq3pdO/OEmptpoCEA0/Tn5Q0I5mikcM5/
         aEmjIaEsNnKa8xHKlWFzzS6MGlsB7vO5Dheyg1CBKWr2mIzMRD9rAGuiue7Qv34mSw/1
         g0Ug==
X-Gm-Message-State: AOJu0YyUAkRneE8BoFhZ0ADZHbwwajyScqP2x05WebjueW+4aGx27e4x
	MAk1ipTE0aBkxPNSEvoWYMh3pkApCRRYj+jCCR8sd1E429KVyHD+kIBi2wVqLJmUFwXlenypIel
	h5p1aCA4WT/VGChW6VkS2kwNMJpsy4symu9zMq13zDrW5pavzeJhR7dqQkymgMrXhQzqmk5xdeH
	dgracG4Hn0H0NuqsO2LNl5HcHpLbr4n+tnJ/w=
X-Gm-Gg: Acq92OHLbA3byIozOYkLHYz/wnnT303Np3NpyI1jFqlecUq0qhQNyT5hdKNHmgjcikp
	USmb7hfA/2SbwcVWXUU2+AIRrrRUJhfZdsRzol8FDOIp4UVoXCWOKsleAhFcG/KG5dkymo031oI
	5MnSJq//Pi3KgndRbpPWMs9ZFA9TIFiMAW2wVM1WlK2Qc/E8VfMugX/qD2uX/nmL2LI6PDa+rWc
	Vx+d1Q3LNaAcSyJZKklaAyNkFsBeNDtJg7SeGLul9HVGf6z2lNXGe0aS4rx6JIVoW5QlM1xMD6d
	+AOonr7KEZRkkRbE0OvY0v8X
X-Received: by 2002:a17:907:2e02:b0:bed:709f:639f with SMTP id a640c23a62f3a-c043cdcea6dmr161677766b.15.1781621248795;
        Tue, 16 Jun 2026 07:47:28 -0700 (PDT)
X-Received: by 2002:a17:907:2e02:b0:bed:709f:639f with SMTP id
 a640c23a62f3a-c043cdcea6dmr161676666b.15.1781621248409; Tue, 16 Jun 2026
 07:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616123632.3209545-1-rrobaina@redhat.com> <CAHC9VhRXT8aJViv02GAKe15m8fECXM9BK9rjE3QpVuxcXphHxw@mail.gmail.com>
In-Reply-To: <CAHC9VhRXT8aJViv02GAKe15m8fECXM9BK9rjE3QpVuxcXphHxw@mail.gmail.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Tue, 16 Jun 2026 11:47:16 -0300
X-Gm-Features: AVVi8CenNXVi_U5VffFg0bSwUQcHNOV7kkTgFsmsZhqMGksRekuWTHmA5IOc16E
Message-ID: <CAABTaaDURc908ahcf_E4bmdX-Lo1En42oZGvJUGS=o17ESN_dA@mail.gmail.com>
Subject: Re: [PATCH] io_uring, audit: don't log IORING_OP_RECV_ZC
To: Paul Moore <paul@paul-moore.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, 
	sgrubb@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13749-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:paul@paul-moore.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:sgrubb@redhat.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[rrobaina@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rrobaina@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8CBEC690A81

On Tue, Jun 16, 2026 at 11:44=E2=80=AFAM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Tue, Jun 16, 2026 at 8:36=E2=80=AFAM Ricardo Robaina <rrobaina@redhat.=
com> wrote:
> >
> > IORING_OP_RECV_ZC is a read operation. Audit only tracks file/socket
> > creation ...
>
> That's not strictly correct, audit tracks more than just socket
> creation.  Connection events and connection-less writes are also of
> interest.
>
> > ... not subsequent reads. Set audit_skip to align with
> > audit-userspace uringop_table.h.
>
> While the logic above is correct, IORING_OP_RECV_ZC should be
> "audit_skip", the reasoning is backwards: the audit userspace io_uring
> table is dependent on the kernel, not the other way around (for what
> should be obvious reasons).
>
> Acked-by: Paul Moore <paul@paul-moore.com>
>
> > Fixes: 11ed914bbf94 ("io_uring/zcrx: add io_recvzc request")
> > Suggested-by: Steve Grubb <sgrubb@redhat.com>
> > Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
> > ---
> >  io_uring/opdef.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > index c3ef52b70811..fef134a21113 100644
> > --- a/io_uring/opdef.c
> > +++ b/io_uring/opdef.c
> > @@ -519,6 +519,7 @@ const struct io_issue_def io_issue_defs[] =3D {
> >  #endif
> >         },
> >         [IORING_OP_RECV_ZC] =3D {
> > +               .audit_skip             =3D 1,
> >                 .needs_file             =3D 1,
> >                 .unbound_nonreg_file    =3D 1,
> >                 .pollin                 =3D 1,
> > --
> > 2.53.0
>
> --
> paul-moore.com
>

Thanks for reviewing the patch and the clarification, Paul!

-Ricardo


