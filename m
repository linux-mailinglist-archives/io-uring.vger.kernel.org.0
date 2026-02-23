Return-Path: <io-uring+bounces-12387-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFmzGBRxnGmcGAQAu9opvQ
	(envelope-from <io-uring+bounces-12387-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 16:24:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0357D178AD9
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 16:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3FFBF30244C9
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B508288C22;
	Mon, 23 Feb 2026 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DoMj/FZe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F991C01
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771860242; cv=pass; b=DBTFmEtkxXkjn03cVg+xjCUH9/xwfbQlgnUIYKDQW4+dKtgYuOeIbOTYAeUTNwbltoSPeG2DLZw2r3MkQKIFSISzyS6XzHephlVwSjOZjzDpAybLPptF7YgMwSSFuZIjRT0cdgpvs3zvtWBeZhF/MYsyRESbxp7uiiIJjHIk/sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771860242; c=relaxed/simple;
	bh=raBCTCTSUvLUeIlNEor6xXIRdPMmDF/sZcB/wk9N3R8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EsNNDky4ypVu7/w9SFhxoz2ySlUnypVATaABEivtwuLbg+Ik3MOVBoyTUq3WiSzTL5zQiAdaWOI3XrTMkejdnnrSdW25e1BL3CHimOF7Dx0CD94Ik796imoPUN5erUC5s9Bq4l1ufmur16Sx5ZkOBIWQ6Xd7yYAUdSIBvw5MxK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DoMj/FZe; arc=pass smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-409470ad5bbso1474162fac.0
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 07:23:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771860239; cv=none;
        d=google.com; s=arc-20240605;
        b=IgBNwvpVG8tYwtQd5m2KcqNAu4xR1+hQMvP2rKru2Sz5sd/fFEfgXXwE3RgVJCL9cJ
         SoZiNgqWzdfJQQ1eAhSU9VwQZcPliDa5+mAQLKqg+qU4zdvzW2gzp1zh649hK9K0z236
         y5ySwgV2IdYs0bSIIM26Gy7+AtmGjnTNNwn7Kx4Qvehs6zDvOum2PLLi2zG5pw1g0wvP
         WzG+6/qkNcsOtydCm7U3op57DWOKSoTTnRO19WJibEm4usxcAZqdx5QE1/Vsbgr4jMCl
         C0dHTWnSDMuNw4TuTXUu6t5lpjGZtcD/5xTIKXl1lQ3z49PsNdMSJliCcpQaKLpfdQmJ
         KrkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iylOjxhh1Hwuz0sxmdpj0jfJrR+KFpeX3OYRYpW8HoI=;
        fh=8ChyaQHV/MQiJCsSYUSVzKi3LR9SISXhTypGs2e34vA=;
        b=J7jzE8OSqeUU20/gwZGkhzs6+XA9I1ISklc4lA2SxpZ+5ffByCVv3FMioqNpHFPSHj
         qzRSXoBl7tuOpaGL3RSaEp3EC32Rj9BmK5xEVA7dOp7P36m/0zEot3iXQzxim834CScb
         eOxTfKEjJQ1pD5+ocU8fdpc7xQavMPQ04w0Hwc6yhYrUqw5yu5/JKXyMjVYlwT/Z/B+c
         7+GAJrVE541MGXYI9Bx97ma8zxQ0YLRYyHgZIJmctP6K4+LrkuXzKTgEI0sMO6dDEcfg
         v9g+VBGKNL1COMHUYb91/IojmijSNRO1bS4kpD6JKHADkfeb3E0lwZVPD2k4/946Ggs8
         lATw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771860239; x=1772465039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iylOjxhh1Hwuz0sxmdpj0jfJrR+KFpeX3OYRYpW8HoI=;
        b=DoMj/FZe/5Sc4GpED5qJnCWTtjdn9TRio4Jk7F7DXWSoLquKLzREnyNJqIafQtC4kx
         yBV8eRmY+bQSC5aNqxAFOrX6EZA4KKSCgnnMCFRRuSg8uXPhLU6WR/GZpkYI48jb/MZA
         LouJ4RDDKcS3sSKpJUxgCbHDRI3gV/aWkBdZx3RUE+f7OWtIulu1McB0W3eCOifmS1FL
         fWF7MLhQ2eDPrgH0Oh8+iUaJLsa9cZbdE33NrdR383PJ/3wJS3/tiDeX8/twqJwYUPrD
         cJfoi6scMVTDTrrj8AVEkpRBgbNolgsWQCNArRdfFiQWI2yB5skBus56ICywQcUh98nC
         5zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771860239; x=1772465039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iylOjxhh1Hwuz0sxmdpj0jfJrR+KFpeX3OYRYpW8HoI=;
        b=FcbT+wvbgtme5Vi3yNER2rfXM3kPFvIMVUAlzlpUNdeWFC8vUzsiZ3iYZYA96oxsI9
         EbC8Kk52oH0Vo6TRNnr/DfFh7O1yQb1jIz33upL7KHjXmrWJYP+NXlJ/EWYVxD1j2K/8
         WimBFRYUan8Ln+irhdy9HH4IJuyeZ+dPIazmFGqbkzOOYJXH/aiaoN2y12fz2qvNJZly
         qXynU+195zR2k5SBh0aC8mHs6oXRpXX8BMjkoYqgJBdJZ4b+THMwaoqg7SuU1EGLITJY
         2XrMoPs3K90wbR7uj+DPmSm8yHCJ9aQ8txlSN2v5bv6nL3edw1GHk+x+eWWbIVw74HgP
         L1rA==
X-Forwarded-Encrypted: i=1; AJvYcCUsTPD+AyHcJjoZd0ChCtVzN8/B9rj6EjJ+yvE3sFNviJ/K5w4Hcb1btHN5z0xGWnLSjERSVqHdNg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz4TtLEkY+Pn9izm5Qgk5lyF8b4gyyoTokQeaTLJf+cD22Kzko
	c4pJ3hpgdo6YDOtEG0JsPmm9VQztJqkQYnDd+GqrcOMLCH2BDRXETS8ZXsuJztKRffsQTXcFYJm
	e6+aGJDx2u/OUy6BHL3lW4WVUlmCJBSg=
X-Gm-Gg: ATEYQzz859s/XMkY/DjcG5ppHQrawDRaob1VW1bkKgLYkZZ117zHoL8POcO1A0u1Kbj
	yb9SINyPPDjh6WsA+kKMEKvkGLVpJn6+NmknfqxV/O4BZSwYvAkjJ2UAaArQOMYhj9Bzh5OZrM6
	89AJ8w1t+29KYLzTIkX6PRcPS2C1ryoGi4KdtsE0TNkFI0z13zaIY9GXA7HhfetM3VlQTa3J9dy
	iN+wFCiczqeNZmW+eWYNmM/ZNOUnGPZC6fTnJJg7fd+K9TYzgTiHJnXNdjeqDlTJ+B2uMQPsKtd
	9ibeE5XMgQ0SMIcdTpeROBJ6f3UO6rSSMcZ0L8/H
X-Received: by 2002:a05:6870:a0b3:b0:409:a408:ba30 with SMTP id
 586e51a60fabf-4157abdb0a6mr3985399fac.7.1771860238780; Mon, 23 Feb 2026
 07:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771327059.git.asml.silence@gmail.com> <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
 <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com> <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
 <591a7f0e-7b78-42f1-9486-163249f5e306@gmail.com>
In-Reply-To: <591a7f0e-7b78-42f1-9486-163249f5e306@gmail.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 23 Feb 2026 23:23:47 +0800
X-Gm-Features: AaiRm50mSl1h_4NN3vEpL1z8e_BPvhdUzWbq4PkZ6YA8PpW16DDFp2UnmKcYZ60
Message-ID: <CACVXFVPx5AcC9y9xVPCaahDeumNGm4TSkkfhsJ8w+wmW52JQ4w@mail.gmail.com>
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, io-uring <io-uring@vger.kernel.org>, 
	bpf <bpf@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12387-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0357D178AD9
X-Rspamd-Action: no action

On Sat, Feb 21, 2026 at 6:35=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/20/26 17:45, Alexei Starovoitov wrote:
> > On Fri, Feb 20, 2026 at 3:41=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >>
> >> I had such examples, but selftests is not the best place for that.
> >> It can use abstractions, and I want to make them reusable instead
> >> of people copy-pasting from selftests.
> >
> > Sure, but please still post them as extra patches so it's easier
> > to see what's the end result.
> >
> > Also please reply to that thread:
> > https://lore.kernel.org/bpf/CALTww28QMg=3DYXqKWpWLZrLO+xiqOe3LGyput8dx6=
8-dnQsxg=3Dg@mail.gmail.com/
> >
> > It's not clear to me whether your io_uring+bpf setup will work
> > for Xiao's use case.
> > I don't think we need 2 ways of doing it.
>
> We discussed this with Ming on the list before, that's one of the use
> cases I target as well, there is no reason why it shouldn't work. The
> difference is that this approach gives a flexible framework for
> extensibility and covers a good bunch of other needs, which is exactly
> the reason I moved from a BPF opcode approach, while Ming's proposal is
> more specific but argued to be a way easier to plug into ublk servers.
> If you ask me, we need a solution that covers a broader spectrum of
> use cases, but I guess it all can be argued in either way.

One big drawback of  Pavel's approach is that it needs a totally
different userspace
implementation for using BPF, which is just hard to use in existing
io_uring applications.

But BPF opcode approach is seamless with existing io_uring applications, be=
cause
it simply uses existing io_uring interface.

Thanks,
Ming Lei

