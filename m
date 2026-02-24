Return-Path: <io-uring+bounces-12405-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6P7ZAj70nWk2SwQAu9opvQ
	(envelope-from <io-uring+bounces-12405-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 19:55:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D9F818B9A6
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 19:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F7CB30C3658
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 18:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1D42DA75A;
	Tue, 24 Feb 2026 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqEtMT1U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0527E054
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771959278; cv=pass; b=VKQFHR7z6CEWV1Dom9nTBuBJOsiZWN8yh3Ogy1zzPGb8wVuSXURrkfDYpFVPKqzCqANZb05nFWLXPTFpRTF/MWldN6xfYe4MfbvtGpaoqvu7M9CXdsa+NOJuCKERnDWueiqRMz3PTsKSsC+bFnkc1b6BkhhSv3iXRAKxv4IzNsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771959278; c=relaxed/simple;
	bh=7kYf38Y4iDvXs4qp/u1OTPuMQjxxHFTdTFxvoFrFL6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ahoPp+kZFIz6M0fEqJ+DGalymQm8KX0m8ZOPhPp3ToG/fESjIcBNUl5eWQiaQvmdHobEHZSAXkzCz7AGzAolk0+Xtph6OeAhcA+xXcW67oQ1ENTOVprtn89JkFowv/hEyUWo4vNFVkkoo+sxIR8l8UgSwwV1Emn8uThmiEXc5+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqEtMT1U; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48372efa020so47209325e9.2
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 10:54:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771959275; cv=none;
        d=google.com; s=arc-20240605;
        b=B5pbiWZd6QZPXOdabbiTIbM18JRSYuham4pXulkB+3z0EaVIRwzTlCysGxxthRrw8X
         e/kR6d6PqvaZcje6YrKpHibct2FysdQ9EuVI8yKH0G8vrt4hIAtYTtxwcmhMpoh56Ka9
         w3dFc9I7ZbDhmwVkRcLFbJ0x77HuvLkD/zWrxCiWztLEmXLSiWtn9zLxGpeknO49y8+q
         Di5FcYw5vVuFPNpDvRtsSWA9XZcYI9tClS6E6LYYwqNLu0WnzyqOEcG8XRPzPaiy/GMS
         FGS0nWDHMvbYB7gnf1p/EraN0K2ssigQjiIb+2fiuRWw8ZBPhigFe2Kees55h2HPuG76
         JssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Awv8DIrGI3H+149gY23xflspKap2W3xjFpbUA2/4mB8=;
        fh=aFeoUrsDWAgbeqymguiAZi9MlpQPCUhPf96aci+YuDo=;
        b=Xq3I7lXXUq/z49/iqlEwxE7H1ALrP8sXGuGQYIh+R1M9rXtOOyps3/2T6LNEMEuEu4
         nx79Hc4Sc8CqmbydcIgCpC6TKMIMIi171Hl4nuxN+ZCRaccwcWFIbI5bkTXPa/GFrAxF
         ZhmkL8Ypo6qPnAj5KL8tVNa9gFWi58WcyDcyId98C6sjbUw4blojCtxLGwEKx6e7Ikkc
         xhTeXZguFubv0VK1YqETE4HTuB2QobAKDJEPtLv4bIpFX8mYVNFpOnL+PjqklnwZyLsZ
         D6ffAwW3i3qOZ49jsKfuWo4iBdRIr8zO/oBuJNB6Wf6thi7k9h8FRbBQw5mkrDFKN+ua
         0DHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771959275; x=1772564075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Awv8DIrGI3H+149gY23xflspKap2W3xjFpbUA2/4mB8=;
        b=XqEtMT1UZogTul118yxGK82rSH+IerVaL7U3kCILbA1RhWmBhFFqG7cMyJjSb7SMSQ
         p00tl2CLmOxDqHshEmNEWFJm+CtIe8X2nTVdypIB59pw0+mNysZeoqcbHzlOAtwNOT4B
         7na4+1NXLRsiIkCCizzaWDnnB19hrI6RPe2PP+ABoFNIzVXivFWg1dz8l8F/QzgqmGPq
         cgr6JL3Ngl0YJ1d6m0ocnuv6vqNayzUOiZjXHTrNP7nIHRCF2FvZGutXtbnr7cvlOiya
         ZFiQn8snY09EBf7Z8ZaQIROcI57N+r+eJlGszk8n55tsoqRi50/Eq+jgPX16+F6f8IK9
         H6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771959275; x=1772564075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Awv8DIrGI3H+149gY23xflspKap2W3xjFpbUA2/4mB8=;
        b=K0pZjjZcHhdb+mb5G3aGtXzxvH8hfaosKKQ4J7t9N4V4tTei2LmnEbAsqHhi4vEnJA
         Q3jep0JHCKjJQrPuwA1Fs61Xrd4RBDMfkiIPLb2zgDNmEVJsL29k/gBTnLHc1T5RchuU
         BHATUhYi9sEEYIk5enbG3M3KN15DASu4GS/EbyVvvFkkbt//bM5rVGmZdS/fIFr/3mXc
         Wf4QgalJNrXEzFdKRM0pq04+m31Xm0rVEARfWPme/8oApBACGNma/xaqseTdY5/DBAHh
         jBIdToQkcBjkxUBMlJ7VroKhzYMIozmLvFV6pYyMndgD6nf0ESVInyH9zTQK+k9wS5gs
         Dq/w==
X-Forwarded-Encrypted: i=1; AJvYcCUTUawB/14LqyRrq4qXA3r48lrScvuTs+dPJ7EFlKA6CnzoBOVKX7RZC0zmKkLKSej5XcAywXjCoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfYqYgGyzF1QQFTB3HujHvnJXQCqvIX2OmEI5kvlpboY3P351g
	ZEOFofrAlWCFng2YCtk2lRufmpdWRJ1OZ+NL+rmwCuQwXOw+zgdwXlrDkotB0KxkrrcnliLVPYI
	vhtPcTlh5kffrbIjyp3fIil57jokUDLo=
X-Gm-Gg: AZuq6aLFfG8XdC5QgTelFILbZquw84QqNni/Rj8cAtW9hQGeeJHqgNGsiDpjNK37cjo
	Mn6IK0qE5/jMPMSNOA/2TURUOhnoQoXw6yB2QmivnbZOyfEny7+S/XYfu08Gi9tjHQHC3J0C5IX
	eEi+HVNhTctWPoxO4BWIdYVDIPuKNPSyPefZyRRyXGiLZzhVqd8ROjtkaEmkmzsGwfE2S0w+Fcv
	AuVVR/tYFPoP6THv+3Z8pu6N/4vVUSB6C6oGez4EYMxOqIm1rfFh1ZHzl75t9QfY4UTJvb1HkZY
	W9hcOfvOQ3gheQbzSc0Bxt2tCk+3bTyDM/9ENWbgNG11zfgyIoDFfTlmIqYQkAIsoiXi5RuyaAO
	y6Mm9MjF4
X-Received: by 2002:a05:600c:3516:b0:483:7783:5373 with SMTP id
 5b1f17b1804b1-483a963588bmr202767075e9.23.1771959274710; Tue, 24 Feb 2026
 10:54:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771850496.git.asml.silence@gmail.com> <9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk>
 <d808f483-3c0f-4323-8faa-0b7d49c539e3@gmail.com> <a7e1f667-04ba-4fe5-b21e-8c47e68213d3@kernel.dk>
 <b22117fa-84ba-4f9d-982a-bbaaae35eebd@gmail.com>
In-Reply-To: <b22117fa-84ba-4f9d-982a-bbaaae35eebd@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 24 Feb 2026 10:54:23 -0800
X-Gm-Features: AaiRm52xt7HwXOCplnwma6vUI16c-1jXs8eUh34rEsu8lfdznaOE6C0yI8ppUzM
Message-ID: <CAADnVQ+8VM8-G3X1UT8_t1tt5=62fxqknHPND40JNsQ51P_XVw@mail.gmail.com>
Subject: Re: [PATCH 0/3] extra io_uring BPF examples
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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
	TAGGED_FROM(0.00)[bounces-12405-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6D9F818B9A6
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 7:06=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/23/26 14:39, Jens Axboe wrote:
> > On 2/23/26 7:32 AM, Pavel Begunkov wrote:
> >> On 2/23/26 14:14, Jens Axboe wrote:
> >>> On 2/23/26 7:11 AM, Pavel Begunkov wrote:
> >>>> NOT FOR INCLUSION
> >>>>
> >>>> Alexei asked for extra more realistic examples. This this series is
> >>>> based on top of v9 of the io_uring BPF series and implemented as
> >>>> selftests. There could be more, but I stopped with 3 that should
> >>>> give an idea how it'll be used:
> >>>>
> >>>> 1. A QD=3D1 file copy program that show cases state machine handling=
.
> >>>>
> >>>> 2. A BPF program rate-limiting the number of inflight io_uring reque=
st.
> >>>>      That's a good example of what users asked for before but seemed=
 to
> >>>>      be too niche to be plumbed into the main io_uring path.
> >>>>
> >>>> 3. A toy example of how BPF can interact with registered buffers.
> >>>
> >>> Let's please keep examples in the liburing side, where they can be
> >>> with the documentation too.
> >>
> >> I got you a liburing example
> >>
> >> https://github.com/isilence/liburing/tree/bpf-ops-example
> >
> > Right, but that's just the nop thing, which isn't really interesting
> > outside of doing basic verification of yes indeed the kernel side works=
.
> >
> >> but need to sync with the selftest. I think I'll rather keep the rest
> >> into a separate repository instead of adding all helpers to liburing,
> >> which will inevitably do similar things but deviating in API and
> >> internal details. And it's simpler on dependency management instead
> >> of requiring libbpf / etc. for liburing. I wanted a space for
> >> misc io_uring bits that doesn't make sense to keep as core liburing
> >> anyway.
> >
> > liburing should have support and documentation. It's not that hard to
> > check for libbpf in configure and either build the support or not. Once
> > various feature support ends up being fragmented in the ecosystem THAT
> > is a mess for users, I'd much rather have it consolidated and deal with
> > it on the liburing side.
>
> What kind of support do you mean? Installation, removal, other BPF
> management is all on the libbpf side, e.g. skeleton open/load/etc.,
> and with it generating new structures for each of them, I'm not sure
> how to make it into some generic API whether it's liburing or not
> instead of making users to fill in the gaps, nor I think we should.
> As for figuring out right helpers and abstractions for BPF program
> writing, it'll be a gradual process, and I'd rather have it
> separately, it's not like I can reuse liburing for that.

The cp and ratelimiter examples make sense to me.
The 3rd one with xor kfunc is a conversation starter.

Since liburing already has "cp" in examples/
I have to agree with Jens that "cp" as bpf prog should be there as well.
Spreading the examples across github and kernel tree won't work well.
We learned this lesson with samples/bpf/ long ago.

