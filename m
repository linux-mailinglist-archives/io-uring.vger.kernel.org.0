Return-Path: <io-uring+bounces-13311-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOGDIXdtBGprIQIAu9opvQ
	(envelope-from <io-uring+bounces-13311-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 14:24:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2091E532FFD
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 14:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 06D29303791E
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 12:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E7C40DFD9;
	Wed, 13 May 2026 12:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpAy2lzX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D12370D6F
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 12:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675057; cv=pass; b=K/xLY2fWgPTputgTZoppfvh/fypCe3AXUHUm8aDMgNMhVsnZ8kl2zVmbSP1JjvqGRzKde3VeQpLOyIg7RD7FYzXVTBYgifdmR2WrGnwdqVdWEpkH1PPpQzkgxT0hLjrsQuuHv5pEdKwT7W93GIyzGPTFPF32MOV2tJGAhUPLb9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675057; c=relaxed/simple;
	bh=xPI/Y8H0phETsM0Ctj3difOyharfe6lt5mTMKXGL0UM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YY4viep1eCLPExcHiFxzKJSNQLCoFpyK5EHrXq9KSZ57qblvWRqlX+rfYjaS6j/ckvj38WajgVCSq8u7u2eiNdeXvgxRR1+WbUE7Tryy3BGgwiWNmGPkOB2GuNOmVDBEDUzFUgP5D6xmrgCUDsG4NeVX9cuWTORpeQdiOCS3+yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JpAy2lzX; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44b052142e1so3765423f8f.1
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 05:24:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778675054; cv=none;
        d=google.com; s=arc-20240605;
        b=iP1VZq84ts+zzvL/DyIbP2YEEq90jRL8fuNUQTKYTrMEkOojSSasLLGx0Fn1XC57sk
         Qs6yLR5DF1QOd+UDW+dkct9cOr4bQNiPqUkCtEDsg6wUNpG6KhK1cWR6x15CW42cUQym
         4L89JJXyDYACVrdIKpk6P9usfQUFcpb8dV+dmfequ4liDX6cWBx1ys352NG2xt0foGch
         501K6ZoK1OTI2UL8TOZqlLYAlA/1gb4JdIhdjzMoKFE+V4CtG2jS9Fc88q5zuHWhcNj2
         tIVfhgabcf4LjemRkvC863RBUrMLDwg78MdRyX6bvNLHKmoEmdKCm1VcJVvsmrg1sU1j
         SrrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xPI/Y8H0phETsM0Ctj3difOyharfe6lt5mTMKXGL0UM=;
        fh=yH0xKWXLua1AIUy8cl6QMwfu9D4VGY8b6y2eWq905AY=;
        b=M/7CS36/N7xnDWulg1ylH03Q9PeTIKMIBAjCuvioShjnx9eh+2fYASWqdUOgzw9Og1
         dDJT3fa0GAw3+QjxoFFlDPWB3cKQ6NJ/iRYOu4+T16TVXT/cwdcpXDhDosPwPglGvjdl
         kW0y3VEchBgOh69v/BqCCyXcqxZziMzQIrtdWCHx7JrNZhAA8Iow+hw+U5HVJFJ4yiPR
         VUjRixiYoSTlFN3NqI99OoFEWDp7e9VLrmEz2sJ0PAcCw9fDPWFjPvHNBJPfWrW3lj9O
         G4RH0Y+RkljAxf80kIbz6Zzl29ZAnhKOhK9spR92ENQxsMcHGniN4uAAnCJCFu8/+8hs
         EucQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778675054; x=1779279854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPI/Y8H0phETsM0Ctj3difOyharfe6lt5mTMKXGL0UM=;
        b=JpAy2lzXb2Fqti2HMrv/SZqBJjaNCKMVXMGt1luJkJjjcoZhGBBZa9+laVHqlyzQ1T
         KVwokWURM3Xt6tVQVrVPWzjUEGBXg+EQuN+LNIWIR+s8TeJ+4yV2ac9fqQoh2tqnQwaa
         zfVCzkaLwSKwtc6auJuoaqNgDV98mFLajA/yQIl4T+vpB9hNk0WYf8Xt5qObPYSgBkKv
         Z8HXglwK0r8KO8TwIJOHGwMU9Nb8K3EcDkoEbDfJVtyqNyqaoFjbP8eiyd+Ke1WjYKS1
         X5eb01ml1pR+imBIzWnkHJUIC31MAek0toS037sr7ajecl4PFSNGI1++h2wmLQh70mSQ
         i86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675054; x=1779279854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xPI/Y8H0phETsM0Ctj3difOyharfe6lt5mTMKXGL0UM=;
        b=Uae2lvTr7taoIEqiwxueZNsdT3ofXaxj3yktYTDORTi7JrypP7pBLOuuDUOe3J8VHF
         HzDjLb/PNtGcHoyuKBHkwKuik18yn6AJUUWvm7XxAxZOTt9qm2+tDVo8DAieqToMYNN0
         48L4od/7d4aJPDdZKPOgqlHPTfIFcK3NYCF/1LmWB43PYfJed6UCxpXoeDsFwuWDK4j2
         Jtk0Z5IbEQ3uOExpX3EJ10gSn2V0wpsdvBPgyc3XPQpI9tlor0DeKHH0/SoDkunuqlzH
         N5PmACK+QtrKoxYSyEO49YiLGs36cHvcYrF4rk6V/giYWhzYUludGWO1tJh/pXjnwaQ1
         tBeg==
X-Gm-Message-State: AOJu0YzOURu5czxz6Qyzc/Ny2P2mt6vj9Ou5Xv+lJyfTRw79ap9JJn40
	YYNQCqlyH24YcmAoWw9rg1zfXciWaGPNhejedUjCBxg3rn+EQkiuY9v+ZG4aLuKp4fZFVdIKZfM
	tOC2sqAXCAob+t4z//G/CSH6K2QSFjNwkeFdD
X-Gm-Gg: Acq92OHQtzJ908R7sdMoThiJUBlL0HkeHDxfrcCJGftf7yeoLX0IdkGzTkorf+m2XZd
	E+jR7RnhDkmeK2EmLPV2QsYcQqgPmhtVpJRbxMyi+4+TB4CpC91E9Mbd3/ZkqPZMl4SnGu/daw4
	TqU46bxiaSYn6+mRXId/dhluTNqRZN35few3zfZ239dWOTiRgRhay9MNCztWFUoBAmaHBnoakvP
	gzq272EivaJ/YZgFcoi8xaOCxkD9iK8VQNsQ5dv0H4M/Bzj95xQIe/XdNKIpYcPQkygKSB9/cho
	ZnRR3n53TQqN/50qbSO7USHKDH7VeY7SpBz1ip0i+A==
X-Received: by 2002:a5d:5f49:0:b0:44f:d9f8:bb9f with SMTP id
 ffacd0b85a97d-45c5a1a60e0mr5076726f8f.43.1778675054042; Wed, 13 May 2026
 05:24:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512110242.26219-1-auxcorelabs@gmail.com> <add165a5-769f-4053-8ef4-27424cfb8a5c@kernel.dk>
In-Reply-To: <add165a5-769f-4053-8ef4-27424cfb8a5c@kernel.dk>
From: auxcore labs <auxcorelabs@gmail.com>
Date: Wed, 13 May 2026 17:54:03 +0530
X-Gm-Features: AVHnY4KKBq24b42VFuAyp4kNWa9D7hCiJsAYcgsJJxfiQx1tqgPpcrrUE2bu_So
Message-ID: <CABnvZUnk7Z_ggqqWHRw0hepqufhHv8DtZxzP=EVN37vKkNdXOQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring/net: allow filtering on IORING_OP_CONNECT
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2091E532FFD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13311-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[auxcorelabs@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Action: no action

Yes -- just sent: "[PATCH liburing] tests: add cBPF filter tests for
IORING_OP_CONNECT"

Regards,
Shouvik


On Tue, May 12, 2026 at 9:04=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/12/26 5:02 AM, Shouvik Kar wrote:
> > This adds custom filtering for IORING_OP_CONNECT, where the target
> > family is always exposed, and (for AF_INET / AF_INET6) port and
> > address are exposed. port and v4_addr are in network byte order so
> > filter authors can compare against on-wire constants.
> >
> > Skip population unless addr_len covers the populated fields, to
> > avoid leaking stale io_async_msghdr data on short connects.
>
> Looks pretty straight forward to me. Do you have a liburing test
> case for this too?
>
> --
> Jens Axboe

