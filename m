Return-Path: <io-uring+bounces-12872-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6L+pKzWRxWlG/QQAu9opvQ
	(envelope-from <io-uring+bounces-12872-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 21:04:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E2D33B386
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 21:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FDA43061462
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C126815530C;
	Thu, 26 Mar 2026 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SnlBiCnl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5747024BBFD
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774555222; cv=pass; b=YqMHm5asmg/gqoSBlNTLlNHY7i3PbJEADhrrXwqTcw43HZdk9GdthlMM14IY8Cu9uITjiK2jWJd77+s4H2KDuFDHT64h8uZG3t4y8GxKEkCwEY1ULFy05iNb4t2xPM3YYobobtDUKGjQCBEoV9ksj+MjQBgKU9Ey7HaOBYl43/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774555222; c=relaxed/simple;
	bh=sAvbtxCyY1rtegUGgvklekEfShw+EdSi9nbkkTLqtko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EuyvxWRIjZcH5C+YP9tqT8ZkTVJ+YaZVN+OPHebiy/iWp0t/lfJkfBr+5BRyeQcyNow4D7qYM6hvWDRLY9QVjGc5CC0fzuElLkudoI9kaT7j+QQSRgPRNxWNGvcx0WRAWZK8iiXlyuzSpioI/Vb3iRWS9PPcKjOjrMiC2cwqLcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SnlBiCnl; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66a8242c1d8so2934a12.0
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 13:00:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774555219; cv=none;
        d=google.com; s=arc-20240605;
        b=V8vFKWtWShRWgasg4Nsrt+viCMpgkWJTbYQiokiA1zpA4y7LjKAIyU+eVU1LfkjVD0
         PAqF95n7WlMr5VFJd+Ukig4u8ZjXaII5AasVpdbyZjOJcEnKBuRhXL66vmBS/Nkcj8yl
         N1T2ns3BMws7u6/8hdGmEKzHquPMKigXOOwQ4dxQ14JWbkrYUzfSVML0B2HboK5o7ODr
         Hl83GDwUOx0kqjDwJl5NOgpZXSIKvRldUkw7soaRoLeUaILg+13dt0OnUleN5LFDyIdv
         l+fGiLkkssnMN+tgs07meJFoYxpADL1qGRRK3GaPrR8DClX/XJiEwbzdiGK4oDgEnDqD
         Ql5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sAvbtxCyY1rtegUGgvklekEfShw+EdSi9nbkkTLqtko=;
        fh=rkiCFmasqW3F2tf221x7TOpTtaruZ7rB8mhzhdsMDw8=;
        b=c4YJP/+xFWBaRHIZqm61n5WZj+zplcgA+yFMNgYEhG8dBkIxv85/pXtNtM1bB3uxSC
         N3joh3zoIq65O0YqWNcI/BTJ0SoezdF9tUdsCydn7R0tOWkioUMsn8xxZNkvuI/HhW6P
         HiO7q4IVNtJwyBOe5wMxJmrz9edctn/K7VKWZ2nW2m2rWFKxGNWkEnypz0lJR1Y502Ee
         ntiCC0l0hNj0F1VPmHuNe6cfTlc5pCSjDQKTNK9wl9jyRr9niAyau67R4xbJWEq+Ovoa
         LEtwyY2uNdSVVpyHqiCcB6CLEMiuVDCg+AEdKJ2bHw26XvFzk5yPXL/AEL3EQo49O5Oo
         ljWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774555219; x=1775160019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAvbtxCyY1rtegUGgvklekEfShw+EdSi9nbkkTLqtko=;
        b=SnlBiCnlWf1y1FlN2uhARD8/EYVDfxRgL+IBgHpviHG6+a9kDVhyzbWuazTxF8v1A6
         0GW58jNe2uPMkj0KA1GYxXjtH4o7DbEWfIEA79+gj2P6wIrlJmhOiak+OuktiwDBZe16
         OlDZ8oaXnRb1TipejE/kjC7bi4qio4zBYwsi1QDBEyo6PEYWEeP2rOYjVtTYK2xnANog
         IGBQczJwaSWM/I/y6ylQwgbX+f2Ok7kJKZFzqp7xZoMQJJvaH6KaZFpsigGjGB9KJF1B
         LVsSroWrXZ/xA35wl+58xBTr30fqF8G7aun+Q/1imDeNjnNFPGe4LQEdUDYGtmH7QqVK
         W2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774555219; x=1775160019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sAvbtxCyY1rtegUGgvklekEfShw+EdSi9nbkkTLqtko=;
        b=rgIY48L7s/TO+p3DtYh5XhyDUDSz/dbyM7CYt6S495attsKuOOEAUbG6vn3aArIBC2
         nXL56Gh5ZeSYill10PChg/rKALOHT2nGoGJfpeHxF17vqqYzZXeaCbzCd9Z2VCfIOqT4
         MSmWG1isrOZK/IwRbvjtFAWE6whaeHqGX5ELxPpjuM79u5Up+AEzQ2zaIjQ7gdB4XPZM
         SBK6hd1UCz4T+kMfgKYGsMZSuI1HtGA9iTv9/UMn6qhUdwP4ZckF6xb+Q8MTH+N1kJQ0
         hhW69yhX4XVZOnn8QjlGLlEg1+ff1ovfFsmkRCfB9N41YdOjefWmpYjp/92oPH5dmdMQ
         UhAg==
X-Forwarded-Encrypted: i=1; AJvYcCWl8KllqDEiUmel1s+FESKocuTKbagIVjWHR37dM5YX7TmHv2qxLGCU2qR2TXatwHTPKjwn76RJgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvT4VbJ0AunWab74L++ii5JN/ZpMV/GQCs129yzRoGEt6H4HrF
	Sd+n8Fe5CeTb4hG5rZ8hI6EM1MY9G1d8k21vb63cJpDGA8fzdzpWyXM4dia+M5H4qZkCes6kygR
	DGOIhrMspYNWsZJNT5qGlwZAj6R4x3wotsdtarfLN
X-Gm-Gg: ATEYQzwKdSIGwJGKkPGKlnhFQ3UJ9KwGIrWq6EwSXYO1qN2Nko1hxnnp1HkUTee7ZQl
	EXzgTiQIhGgIKYtD4Y/wMVblWFiYrzcnIT0Or+vciq0sdTydBQ4YjcRSFYZpLXOcTQowrjXS+m8
	szurQ9dO6KBAe0k3lpfD1wwjyGBL42vRwTzDHG9BquEmSwnopYUD2QJteBuBfDKJhxdF3yq0nxZ
	m0e7kp7Pz4cOjDeRY2nBOTEm0PI4llb+DvrEkWm5WDYh5p/gyjgHZ59K6umg/LE6tElOU2QBfmS
	LA2ONeNHQlBKiJz8j5m6DtdfdcdBKyS0dR8u
X-Received: by 2002:a05:6402:4613:b0:665:7112:ee03 with SMTP id
 4fb4d7f45d1cf-66b19dcc282mr12264a12.14.1774555219028; Thu, 26 Mar 2026
 13:00:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
 <CAG48ez0H_Z-NQvfOeczECz_sO=MzVDvu+8m+msB55rcAPfQOgQ@mail.gmail.com> <CAJnrk1aTnoDwDVdgYrcN3tHm-_j79GKYY=8q_Lu=xi8=Cxi4bg@mail.gmail.com>
In-Reply-To: <CAJnrk1aTnoDwDVdgYrcN3tHm-_j79GKYY=8q_Lu=xi8=Cxi4bg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 26 Mar 2026 20:59:42 +0100
X-Gm-Features: AQROBzCGjXCNQQerS2w1DtLW2jwJku1pDgE-yVJzRKpzcPByNNh6dNrnifnY7GU
Message-ID: <CAG48ez2o=OzSjuPYm44gCDrG_tqzXC3=PCJHXCBVJyYmemtzsw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	bernd@bsbernd.com, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12872-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 10E2D33B386
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi!

On Thu, Mar 26, 2026 at 8:55=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
> On Thu, Mar 26, 2026 at 12:33=E2=80=AFPM Jann Horn <jannh@google.com> wro=
te:
> > Am I missing something that prevents normal io_uring operations from
> > grabbing IOBL_KERNEL_MANAGED buffers and accessing the wrong union
> > member?
>
> Hi Jann,
>
> I am going to be submitting the changes for kernel-managed pbufring
> compatibility with normal (non-fuse) io-uring requests as part of a
> separate patchset. You're right that there is a functional gap right
> now where trying to use kernel-managed pbuf rings fails with errors.
> In those patches, an iter_kvec will be constructed for
> IOBL_KERNEL_MANAGED rings instead of an iter_ubuf. I'm intending to
> submit that patchset upstream in time for the 7.1 merge window before
> it closes in mid-April.

Ah, thanks for the explanation. Please CC me on that patchset, I'd be
interested in taking a look at how that will be implemented.

Thanks,
Jann

