Return-Path: <io-uring+bounces-12355-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCFMCNydmGmWKAMAu9opvQ
	(envelope-from <io-uring+bounces-12355-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 18:46:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E6E169D22
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 18:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DD4D30868E3
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 17:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AB935EDBA;
	Fri, 20 Feb 2026 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U6nvK8fu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5095E223702
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 17:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771609527; cv=pass; b=AlD6af9yyYptFBJwqdOAHyvBq96PuYeTcihO4niXuEXQifTj5A5Z6StNDMCzhNQ13WVdP5t/ch1RoilLMm385yyqNpAqkWbku8x6mw6AcSS3rfWrBSOwGzP2t8ffWAqt0gVy+JIviEmK8M3XknugAXII0umIF7eK0pXrE1dygkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771609527; c=relaxed/simple;
	bh=17osSV2Ybp3FZazgMVnr6OXGlcJHiy1r4+ZefyUIG3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EGc0w6fhPdm2G1MRgPPrMILy+z92wpzdfo70nN/nNqJXLC7Ue8qMX3CbANkciw4PJ5vR0JBopqJ7zFeCsjj047yShMIEDTROVp4LM8siXZkngU74Q9OiILVw62Jnp55FOYr7FEbe1D0TVQoz3NEIKpGUlZUKtf3kCLLPpI6JoE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U6nvK8fu; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-482f454be5bso31964825e9.0
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 09:45:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771609522; cv=none;
        d=google.com; s=arc-20240605;
        b=LXdyO9slFK650JFWaoz280k+n84LLFyXU9J3RC0n3j/UNOfAi8ZjFiLgonRCv/ZQa6
         zhw2jDV+l3i0BKNgg/09RSPi63XSpeJDkorGNhHQokXtwh0Ncy+WZsgumNc6ZQXOfCs7
         1/SRez5WVJzYwglqyORz4rxvYNJGIOZ7WqxMsqfFXU4U+A0VOFonsGxu9aThE1EM9dS0
         9ccgAxbm8Z7lqef2Xmip9WVrgNaO5/a/suAO1bghUSrxEFHvU/JqO+FFJZlwE6EwxmKh
         L8YLVSbkkgytylAOkZtOPwNz4Ns66Lddow55Ij++GUNm7tE4stKWmMnvZiULeXG6hLTR
         kQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=17osSV2Ybp3FZazgMVnr6OXGlcJHiy1r4+ZefyUIG3Q=;
        fh=/CN9mfTqvVu2uNAJ0wMLUcZBlSeaKHjQ1yN0L6YpXc0=;
        b=USoPP+WOW01WK26Ry/31rC8xGDG+bY5EfeVGN1AfcYbaTnTVieSn3i37Z+qELiBAVR
         VlikBjzheC3Wx0EZeazqmp+od8rV2M/YH8apfSmclyq6NgJq55d4p0v7eCWJ7enKItr3
         pLcc8phF8W4HXc0hKEOLNxh1nHlPMaSrR9RR45GQt9ApQwFijA6TqYIzgZO3or1ysBsZ
         /whgEeaahV9GUJ8uwGVXMD4mPQWmpf8h3fE6/Jq2/0pMDO6EHP50SOBHTOd8vSUSK3zB
         Ce5R53I9lclk41XcxVwU+f5GLCRwgtyO4R/6Cs7TFF//u7/Lo/GZIPWHlqIcRboCD/Wi
         RaAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771609522; x=1772214322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17osSV2Ybp3FZazgMVnr6OXGlcJHiy1r4+ZefyUIG3Q=;
        b=U6nvK8fuOXr+e4cG1Xbi8KhfCZ3M7j2xPDmC3U5S8p7bY/cwmWwKjxBk+OMDzU2G0j
         zGQ8/hIVjhCLqdXTY/Vs9cPTc5F0OfM1Rh6tRBVN4T3d7J1dx9KjASXMPGoKiTapZsyz
         Ygrx2UNpL6TG5nrV+wmaLzHn6y4fUHcaKzPuTetXE29UrMAZ4KTtk4Li0Yekvibog/Ty
         rWwggbdZPyGXmLpcp1yvg1kMF36NszQb3VidzYx92qVg7h2RXPu1jrV0YFBPSsoDcSXi
         Jv18kQt9mJ+fJFHXT0qhl718d2r3Z90wXZmfpqzwqeM6n1l+Bg2bWfhWw3dwrrQUh5QY
         HtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771609522; x=1772214322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=17osSV2Ybp3FZazgMVnr6OXGlcJHiy1r4+ZefyUIG3Q=;
        b=aVZAcDlDa6oaiglDDMqgs0YLq1gD1lCyUz9zMJ5Sl6AQwcdvAeW4Mh6ugrrqEyC0Nr
         3KxsUR76iYc3c88xriSwvZ74bKWtR3S9M5967jboePc6x8nxrWyy9bYqR0h50a3a0H63
         6cYh05HYNHGJyJXMuls+hpxN7nw+8OGQ1Qo/cyE9EWDRP9sgAjg6XiV6wBBxXK5qcJ7Y
         5p1eKs97sly63IgkZXaL0E+qpcTh1oeidrs+ay9Ru0RHH2Xzp6GjzHg6m7MG5+T5QO8o
         SAk5KgIchRr0osh5zJ6x5imt6cM6WjS3euckkE3eJDw5j7LeDjfISdL6JokqNVWsFtlX
         iOxA==
X-Gm-Message-State: AOJu0YyVf4KLXOUpqZLQthwX8e6jXx/oI+Z0jZMfRmrboTqzEzgav0EU
	CSI860r2Njek3QFbEq3qsXgkHPr8a5VYaurWqHI0fBqKNFj8f+SLirGQYnxq9kZNoLvj68Du2FV
	8epVLqU09wmOkzWbZLpR5IU5ftEJ6mCU=
X-Gm-Gg: AZuq6aI/eWVtAuTNYVdZjwur8vhtH3Hs/vRs5q/6ruIyGbuRFpwhsNwgdoCc0eJlrpB
	ejDpoNAnHZAFANVdnKiftS96VXdjcn0Okc23Zj9cItyE0qm7glZ73bwkp1JHgXqbzcNrvtJtD6i
	PocoKLbZTyCBxxHbvfQtnh7ySbhQDOFC4HJR4unfCH2qfRLe/sUasnYyJ6UtyPuOh3rkErF7ifJ
	jJmSvLZBqYYpGHudJsrQKWu8hHlJEqNydHwrf2O6brwdiJR2/kyQJ84KwsJG937Y00PfUOElMGz
	tvmRXgMl4DIIJHj7KeYdzF/sSLZhGPy3fHEyacewaijRh/tcQJguTxc9oYr1cgGkA5WD/kByweR
	N6PscyGUqe6CSUdcZJJvDBNpClg==
X-Received: by 2002:a05:600c:3b22:b0:477:9a61:fd06 with SMTP id
 5b1f17b1804b1-4839fe97501mr102528005e9.8.1771609522273; Fri, 20 Feb 2026
 09:45:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771327059.git.asml.silence@gmail.com> <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com> <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com>
In-Reply-To: <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 20 Feb 2026 09:45:11 -0800
X-Gm-Features: AaiRm52OfKCQJR5H9mRJjJZx21uNukzF7RXIa2wgJFPVKsoGW-XQ7s--_qWO_YI
Message-ID: <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12355-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alexeistarovoitov@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 78E6E169D22
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 3:41=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> I had such examples, but selftests is not the best place for that.
> It can use abstractions, and I want to make them reusable instead
> of people copy-pasting from selftests.

Sure, but please still post them as extra patches so it's easier
to see what's the end result.

Also please reply to that thread:
https://lore.kernel.org/bpf/CALTww28QMg=3DYXqKWpWLZrLO+xiqOe3LGyput8dx68-dn=
Qsxg=3Dg@mail.gmail.com/

It's not clear to me whether your io_uring+bpf setup will work
for Xiao's use case.
I don't think we need 2 ways of doing it.
In networking bpf is hooked at xdp, tc, socket levels,
but those are different abstractions.

