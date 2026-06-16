Return-Path: <io-uring+bounces-13748-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id dRLtEV1hMWpCiQUAu9opvQ
	(envelope-from <io-uring+bounces-13748-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 16:44:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D4B690A21
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 16:44:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ci6YFW4R;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13748-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13748-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 491D7301A099
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABA1361651;
	Tue, 16 Jun 2026 14:44:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8A53ADB97
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 14:44:39 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781621082; cv=pass; b=f9Y1r4nfjS3l0Asq4bO2zf+iwXkAKpAaQRNKsm/IbLJgn7KHBUjPWkm5LRhseZxxXolANo2BgsgWeMC+1wlaU9C2wUo/inMyPc/WZLuK7P1LAIIy1RlbHQ8rXRUTWbNNy9V7xA8i7mITl6ZJ9I5aKdKSsQhjqmxGltPTevHOaN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781621082; c=relaxed/simple;
	bh=wHrZ6fPWOZ0i0yXKik+cPHgx++GeQmn/m/DjkVpM7Qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eaj5zCM+/mwR2J7crGUtFhPfSqPWnXiI9Sz7fA5iuAJhIHFRpzqg508RuuG4jJFrOAUVRVPzk09aoCAyvx/q+RWTg4FLZU5HotR6Lzp/+T8/sL6A22jhx2su0mow97W955CUKGn4TDtbfxMfdW7YK94lsM3taxDkDQHjh1hE0TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ci6YFW4R; arc=pass smtp.client-ip=209.85.210.180
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8423f626a65so2273610b3a.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 07:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781621078; cv=none;
        d=google.com; s=arc-20240605;
        b=FO+nAwJqhDycrZ5n5vewoy7DpEbFbqV/JgIGBeIcXleSGHn1N0ywlmclRThte4Ridc
         oF7+410cPHmg8+HWKzB235QWWzVAvakH/I8onCm0SNhfz8EP/NTDwkSukbJDXdoiteXX
         rGfUNb+d5RtIEM1uM1PC3aeSOdO+E3+6Kfes7IatTqBS9mX+3B5zlwvlPCUfryAGqWGY
         Xrqy5rpal4rnucONhvp3Fya+yJjOiWQU+1cfLaUlYDFBR2/Qtc9B0tcvfmZ2SnzlAAbn
         4quNDfpWSJXUHJPIB49+AW9qqRVPKpoHNbMx31L1DzI1LpAd9vF0gr5t1yfDENO7oCCn
         L/cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QNC0SjJqQRn1itxqERFkMBzByU6tmd5VEXoBKFn+c2I=;
        fh=u9k7EBlA80YpozHeiGyoDNJVsOPOfTwOOg6d3f+ouPA=;
        b=kGtEzMrHJyTOjfwwIi52Pr2bK1zqbYQYoVVBLliH9rs6nmC70DEwfPb+/ey69wIEhF
         7nC2eNy8TecI7wjh4K9SQO6uqClRhz2UOPWWMNja08oMwHVmIQTU1yVRjI0ux+fWcPPv
         MJLnUdZ3m9Tj/q0hsSvKCO0pM/jti/PE6fkWjsOantu8vb6EbM0oCI1kJ/z2t5V4Zd2X
         p5MZJbi0b8oG1e/OTgiTmfZdptKxzp93WIF2ETjMhIDwgq2DObyvdXEjIAbSP6MQIZTN
         yr/HM3yU1YKl3dB0dC6T1fbxiUZfSXt8GW4vY+DbPKHk+Q318zek9+7OOoRo4QWtM2iM
         4j8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1781621078; x=1782225878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNC0SjJqQRn1itxqERFkMBzByU6tmd5VEXoBKFn+c2I=;
        b=ci6YFW4Ry3dfeT4aYE+fQATP3Hy7W8isy/9Ox8d+W1AdfyDofNX70VrnIyo9e2++8t
         9ak8njyoFmZXZJskbzpF1Qt6tSKZOedCccic/gbukWqkvN1+JVdggTU99gb3/0aVN3o4
         stu5Lby0osL40FspDT+IQwzdGOJviGIzTDOF2cIP6LosoqPdKkVQBIreUGxeaXlhTmh+
         dOG7m7RzWmQ1Aw25/W5teS57mHDe/NZEnN4YpJpcehENIzlnWcoQ9IoFrdCpkA/BMVLD
         A9b4l97qkxc03TM88qsTkBzzgJr0Yhqwh+GygP7bBBUBdkru4J8pVUWwA4qyEMnohV95
         xVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781621078; x=1782225878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QNC0SjJqQRn1itxqERFkMBzByU6tmd5VEXoBKFn+c2I=;
        b=pQbnHNsTj3q7vFmkDkJ25N3GCyQPVSC6uE6JPQHgSKvM2t0DusU1Wz4JdTnLNZ4g0f
         7UBVHJijSaOQ6dP1+RWCVOXGm8LAyfh2+CbEDlJeLS398aFk16Le/I3lh3zwZc9CCwwt
         PPYfp45v14GghL1qw+zMrBwNsH7N6BWkXDUel5OnaciT+U/4QjPBX9lP9vub1821cp47
         bhqLD7L6/78NEy4opooUhQ6PRycckVcsqO3HNBtujmc2aNdwaAplO6tMkMf1ZqjkmnHp
         qhxZIkonu6inKlahFe7OTAjxH/1MTqzP5oIPr+6NvEfiAzhB5Q2khZol6lVoWT8UV3sj
         2K+A==
X-Gm-Message-State: AOJu0YxyAroZt4A7k+ZnWVfM45aa+bkG4cAFlcG/13qwZocdXdLtAUCu
	QRPkl31UEQVXKFzl6qdWnBg0+iPG0c0VxgJgIKX/9MBRFi91q5baTFSqwxousgvYBDkYTZhxgk+
	dUSgozVYh3jC0xXZvWblj5cqvev9OyIcx1q7L9efhhaa8l03K/7a70Q==
X-Gm-Gg: Acq92OF7a/4WW9NX+0lrEovLwWYnYMFI77GF8jw27gfrrAI7GuPyyKBjkcCwOXdZd8K
	kspjGZX5ezz+kIj3eX902Qgw1k2EUWQ7/E/ByPCuvqsh3tKWmEKWwgU5z0jNdyoiQ3lWu0Wl5y1
	3tgFpDyvHHmfo3NHbrG1WojPnD5TAusajc6rai1+OlU/SujndDV/KtkF7nOqH0vy9x3OMpbPTVs
	wBNR/l+b5C87z1dyBj25qSvgkPh/CErWSkk2hkrXe0W1B3T/Tb07zZiQwZWhmIvzVsn7BAb8zBW
	gkr0yRI=
X-Received: by 2002:a05:6a00:3a15:b0:842:6fec:12aa with SMTP id
 d2e1a72fcca58-845152ad0b0mr3725820b3a.8.1781621078261; Tue, 16 Jun 2026
 07:44:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616123632.3209545-1-rrobaina@redhat.com>
In-Reply-To: <20260616123632.3209545-1-rrobaina@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 16 Jun 2026 10:44:26 -0400
X-Gm-Features: AVVi8CdSnuF4imw1cdlhz0nuDX7YNuUKfvNPtvBjvgUWcwOgMiUs4CNwcIESkPI
Message-ID: <CAHC9VhRXT8aJViv02GAKe15m8fECXM9BK9rjE3QpVuxcXphHxw@mail.gmail.com>
Subject: Re: [PATCH] io_uring, audit: don't log IORING_OP_RECV_ZC
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, 
	sgrubb@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[paul-moore.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[paul-moore.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:rrobaina@redhat.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:sgrubb@redhat.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[paul@paul-moore.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13748-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[paul@paul-moore.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[paul-moore.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,paul-moore.com:dkim,paul-moore.com:email,paul-moore.com:url,paul-moore.com:from_mime,mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D9D4B690A21

On Tue, Jun 16, 2026 at 8:36=E2=80=AFAM Ricardo Robaina <rrobaina@redhat.co=
m> wrote:
>
> IORING_OP_RECV_ZC is a read operation. Audit only tracks file/socket
> creation ...

That's not strictly correct, audit tracks more than just socket
creation.  Connection events and connection-less writes are also of
interest.

> ... not subsequent reads. Set audit_skip to align with
> audit-userspace uringop_table.h.

While the logic above is correct, IORING_OP_RECV_ZC should be
"audit_skip", the reasoning is backwards: the audit userspace io_uring
table is dependent on the kernel, not the other way around (for what
should be obvious reasons).

Acked-by: Paul Moore <paul@paul-moore.com>

> Fixes: 11ed914bbf94 ("io_uring/zcrx: add io_recvzc request")
> Suggested-by: Steve Grubb <sgrubb@redhat.com>
> Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
> ---
>  io_uring/opdef.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index c3ef52b70811..fef134a21113 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -519,6 +519,7 @@ const struct io_issue_def io_issue_defs[] =3D {
>  #endif
>         },
>         [IORING_OP_RECV_ZC] =3D {
> +               .audit_skip             =3D 1,
>                 .needs_file             =3D 1,
>                 .unbound_nonreg_file    =3D 1,
>                 .pollin                 =3D 1,
> --
> 2.53.0

--=20
paul-moore.com

