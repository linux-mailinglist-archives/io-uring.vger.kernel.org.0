Return-Path: <io-uring+bounces-13821-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bcVGMm25OmpKFAgAu9opvQ
	(envelope-from <io-uring+bounces-13821-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 18:50:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC5F6B8DEA
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 18:50:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=google.com header.s=20251104 header.b=XDAwBPka;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13821-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13821-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D04B530071CD
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 16:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6014C2877DE;
	Tue, 23 Jun 2026 16:46:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E165478D
	for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 16:46:55 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782233217; cv=pass; b=cKiSHiC9NjFzwUKrFfUNLIdGBtN837B2FuoC1/a+3xY8j0QosNBlpXOl/WHKHiTu646kZ8uNGOkHm4UBcEO/wcyj+KakR6eZfR9i0UfjTiItG4QPcRu1qjqBUoHu/VXLwx3Vna0FZvehjFNdlTKUpXeKptxgG7Iky0jsVZ7dRaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782233217; c=relaxed/simple;
	bh=areJfWrdpnpY5/IcGNuJH44mjD30lQ5P2b5QuszYnrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bL3ZI92eaI6g7NcZpNb6Ei4VBRRo6kr2KZ6EhFvTCOS8kTMwsNzCbADZK6Xdk4ZDmHVlHpLHFd98ODbVIz4ZmMyOHivtUZvdOjpuKDOaWFtSNPgkR3gjZ3nL8YDGLg4yYZ9wvIY8FUpkiR7gzxERK5xK28U+f9wU34QQH66tSlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XDAwBPka; arc=pass smtp.client-ip=209.85.208.53
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-695a3842230so84a12.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 09:46:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782233214; cv=none;
        d=google.com; s=arc-20260327;
        b=IxsHyEzd/SBSKrZ/AoJttpnCoG+xKfw8zWMkULeKDhxF1BUsha33jkTlfS1TKYWwUd
         zb0SKRDBF+pTKsTrspl2Y7/QRF4+t4I/AYFwnLPj0G7CH2yWWRMrz9JimHHK2zZu/oJr
         dQI8ccehPf/kyXKtGIzrRFJ8KYI6I6KWZMK+BHIveZUOsL+fxATCDYUCHBqbhOZOb9wa
         hfGbAINVKGFwN3X/wfagrPOIsfX35BupyDbDRMjK5sFLBOeGU0Ix2Omt+9J/+hqYtynk
         jkWnNdTFZ8YucFVLj75TPGQj555V2ALjg9DDJp2etllAlTYXRFD5+HNt0HMbJs5u1zU6
         01Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=areJfWrdpnpY5/IcGNuJH44mjD30lQ5P2b5QuszYnrY=;
        fh=cxiKEPG9SyFMB3knvMuAnpRT8OyEN5XCoxtm8gNDVAI=;
        b=Wfep03vnDjGU2puXEvFGYk9Ezv8j14ka59b9Ad/r5gzGQ6Vot3wHa/ZhMCZm2uHIQm
         MmGgoTmn20W1MO5HLBEquMuEWltljB3YX7T+/cmODv+6pJjjIs6BztPKbLA4ayG+C1pB
         /ZLPPuhdBh/M3GPR10DIzi7js73nAc2eRwack/kQj7Vg/989r9g0j05tzBgSeBclkCA9
         y148tvCOyEdN/mAqoDAJiJoxCmUm0mTKNNPe/BF/B5lIajxhpg2731YMvG5SYwyJCwlR
         EE6W4lInO/swbqJC36+rkb675twRNbZC9a/kuDIAWDRR6W3DbfjmKJHIJbHrcj1GVYpM
         IRHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782233214; x=1782838014; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=areJfWrdpnpY5/IcGNuJH44mjD30lQ5P2b5QuszYnrY=;
        b=XDAwBPkay4gjzBA6dQpNnLJHGaAxHx0nQ4FmZlooMfkpWMtXFHdIG5xFLkhjv62auQ
         ak6c3aISnELD2iV2J78qNeSWLd/3eJzkE5V0b9GNqe4cg5y3QKQnVkvsDspEMHjaatgX
         Zm8IiBiL/YF5khIchHplWVB5S3qpXyiAI1XronYuc4JhwMk9EhW/vWObMCiG8EcL+dzU
         N+3KmpJeZVEUmq69AdiHjxppqJozw3sh+CvZ10Qsk8YtIW5t2x08blS8/j3bHu+9vT2b
         64UZltMLF0pwdxO8vy7Ax6gzUZEvZqLgGvFXzW7/caKLD+7JNKyVA+EoNhTYSF/RtWQQ
         TFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782233214; x=1782838014;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=areJfWrdpnpY5/IcGNuJH44mjD30lQ5P2b5QuszYnrY=;
        b=SfT0EuWiVDyCkLRUwAbj4YdwWa/3n6+G4BTXoeu2ys8UYGQKZMJXdDpsoAOcF8NZ4E
         jBco6Q5Z9aXw2baOo4CEmAZaVsr5/ceUkOz9ewNT6cuoNfBZhdyZeZ1+r8L6Uy7E9ab0
         iN45X9/oeFADsg5yDJZnWzO+gEV8jnJv/7SMwbRLlLNz7vE4vqXMkwlxwzOc5oT4suXm
         B/RZx3vaQKMMIrEDdQtqglcJPa2+YWlCq692eAp6wqAGRiI3N/ELNvNGvFpapSSCmCx4
         Qqj9pM3P1S2Xd9atDKHYZmKLQ8pUMIMSxqeO12ATG7FVvSbq2tr9diXPEjIlf05JoKzU
         Mhag==
X-Gm-Message-State: AOJu0YxBnZ/rezr3vz5aGzRq4kl0HposTdCSDjQDpXPgTbnvI8NlCteH
	KokU+Fv/dKE8ywD8VQLKDVt5x3GoeXoRzxEq1iDNE5GauXiBOaaGiO2pfufNfSgubhJCYyaPmGX
	VBXic/fmmvlW7v4oeYFPpLsLBzBkk2HXpZyfi4yab
X-Gm-Gg: AfdE7cngWjvrmwB9DQIRjNA+T9hATnFWSNsqhJyxDZ68Huc3KWGvLhbc9tfT1GxqtWD
	1Q3syrwva6rgOTjifu3VVxtlcWPoCrit8UueBhHBFQFlgDAvjR6dKBWtWOosjGfj1mSNurvpnRl
	oWe7cWJOxq3ssfZfCwMkWr1qFBLMoYOa/0lR1p+mKzPfIdY/ymmSO/D456Yt2YawE6WhTCsYfmJ
	BpmUVbqvxf0aOWgymD9eZrFRz0WrGCmS3DSGJEuLs5rlJ37qEi2P5X2tiEETYJxyKCEgxqyTIEt
	VdeN1WYyjt8eTIH53GdylqsgCkZ3BsRSyi4+Mw8FLDjJhB8Bcw9Cdq08Mg==
X-Received: by 2002:aa7:cd56:0:b0:68a:7046:e64 with SMTP id
 4fb4d7f45d1cf-697daf25203mr52456a12.3.1782233213855; Tue, 23 Jun 2026
 09:46:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+fCnZeE6-8NFXjguJJKc_=UuF-Puw8BdtiFcUhOd23y9pAKOw@mail.gmail.com>
 <20260526164948.831543-2-robert@fmmr.tech> <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
In-Reply-To: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 23 Jun 2026 18:46:17 +0200
X-Gm-Features: AVVi8CcspybaASU3bRclza7ez5lFqZXOwKYrwdZpg77N-X76PhCE6UVStmVsGLY
Message-ID: <CAG48ez0uaaoxjT21yekJ+J8aUiDJ1o-eOx0vHx_zBmLR69EqOg@mail.gmail.com>
Subject: Re: [PATCH v3] io_uring: annotate remote tasks for kcoverage
To: robert@fmmr.tech
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13821-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:robert@fmmr.tech,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:dvyukov@google.com,m:andreyknvl@gmail.com,m:kasan-dev@googlegroups.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,google.com,gmail.com,googlegroups.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,fmmr.tech:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2AC5F6B8DEA

On Tue, Jun 23, 2026 at 6:37=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> On Tue, May 26, 2026 at 6:49=E2=80=AFPM Robert Femmer <robert@fmmr.tech> =
wrote:
> > Fuzzers use coverage information to guide generation of test cases
> > towards new or interesting code paths. Syzkaller, specifically, makes
> > use kcoverage (CONFIG_KCOV). Coverage information is not collected for
> > kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop=
.
> > This patch annotates io-uring's work queue and sqpoll tasks.
>
> I think this is a useful change overall.
>
> @maintainers: For context, this should have no impact on normal builds
> - "struct kcov_common_handle_id" is zero-sized in normal builds, and
> all the helpers used here are empty inline functions.

(That was supposed to be "are empty inline functions in normal
builds". I should've re-read this before hitting send...)

> > Depends-on: 20260430-kcov-refactor-common-handle-v1-1-23a0c7a0ba38@goog=
le.com

(This landed in mainline in the current merge window.)

