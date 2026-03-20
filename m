Return-Path: <io-uring+bounces-12768-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MM9EB9OTvWnY+wIAu9opvQ
	(envelope-from <io-uring+bounces-12768-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:37:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 764A42DF860
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44C5531EF40B
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15123E9F62;
	Fri, 20 Mar 2026 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdZZxyyO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A43E8672
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774031377; cv=pass; b=EGRZmgNNveSZ3K+SVvb+hzX/2Obmqnu4Ioen2vLLiuX1IeySE1mD0gipAbL5UNB9htmrTs3IZSXQxOafrKOfn48SWsOzQTwXXy6cxADhjxZq1xiE4qJ7zmlOR1MgPGcWjOmpE5iS4uo2lGT1DhqvLEcI0nCO1u4NHDtf9sVhoMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774031377; c=relaxed/simple;
	bh=/d9CAG4irRfTp7JM5rC9OCHh9qdnnn6d45w3n+HEqp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D/1aAfzt+kchMWY9/aay/48e83Z1bg6tKu2tmdsRFc8GZPHQQydpm7cmnWSnkgXSt2OejUUGp3cD6pA3nW4IFeJ/EK2//ixtsj03vYNYCtWS/svpcVHukYcHqAHnf9/OWr7mhh6fNBRfn2A/krSzB+JMHO0mdduUJ4w8KKLCMss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdZZxyyO; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-668d70fabc4so1747579a12.1
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 11:29:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774031375; cv=none;
        d=google.com; s=arc-20240605;
        b=Yyl4X+g0inEEUC+G+JZGhNACsA2gp3oguwhTfPHOff4mlsQNRWNosPYrK5AHHddHfO
         cqlCkImigobL0fCMLhUC1FaAHyWy8E4i2P8QMdaRudfXWHu9kXmOexPtPiJNlL4/hk18
         f1JbXdVjSNlUHDflEItql1yQbfg/mBjcDhRiXG0Uh+DXBU1yyQY5gEegcQk10w0HuJ9C
         mBaDFaQ7Ho8K3paV0N/v1AkaFzcSGSN4CAGi1eF347JmDd5pf/Wxx+Yx+kLT+3B6Ck2B
         n/CXwlMFtYQBXQYRew996EnyVxkLO/+Ten8RNkHBLH4G3TFp4B+Xuk5A4Cf2wnttF48c
         wosw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/d9CAG4irRfTp7JM5rC9OCHh9qdnnn6d45w3n+HEqp4=;
        fh=y7/dQhR4gePJe0YQgx3Bl2it6pbcXKvgOmqCjrpRNNM=;
        b=WIm2FaBQwTb+QpYdhRzdBxvCil+PIvzZvsru36M1DE45RlfEc5bP0Ux07PkFVzTYCY
         ehkeyW8TXyRHKStLmrNojfjXYM+DPsBeZi8vW6BwM8owXkJgXdY/eQ4/J4DVHogKGzGS
         +QY+SvyzJu9iw32XoCWOuizsoPEcC7X+TaYd6pGUGWPvYEjfR9RYILUc0aeGYfhMpfEX
         ovTpcWFxEYL5/9PErNFOjocR+6QNaw6TyMCFjKhSL9ZT3lFY6TzSPP/4rToo0lML795L
         vWW1u342x11YIo1yDS4lBxCoB+g8KceRe/+UU3P3xKbHlXS8pIOzcYN83X3iLt8i2MYU
         tpLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774031375; x=1774636175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/d9CAG4irRfTp7JM5rC9OCHh9qdnnn6d45w3n+HEqp4=;
        b=ZdZZxyyOu41uHKeis1TgRfOPKX0xpHzzEHHHR3S8Ahny+/yFXWzvbtcpAXzSAJf5xe
         UfqfNcQWGUdmQpsDxjb6kkC52qxp46b4VYPk9rachfHcbNvGBwHF4xdlwEpUSauv1bUZ
         KpWZJRMZ+dmws9k/OBOILIOhao30KrwqI8K7KGIb+HaLNZK2dDjB9EtiM0lIF+rGl4iA
         3BS6gK1V77UAN2laCBJdILgvSWVA3GpUDrzHgFFyZemO6KgJbRJtR+5s3mA7GoT7QW4Z
         dKs1ca8rkZlgz/Ds85qmsLYmKS7kjBXwBd6x/8RsKl3yi1LvuN/kZYmMzuIFtIgaumBi
         toNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031375; x=1774636175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/d9CAG4irRfTp7JM5rC9OCHh9qdnnn6d45w3n+HEqp4=;
        b=sahQTHqjv0DaLhkCUKhi9b/VQVX7Oq5ZsqVo97VDko+N2ywXsBXqWE9tkN64WGoPOP
         bG6E3Cx1rnNtN2qw3rFWvarPnE/2xkLDO1PMATu+PNunRuK9qh9kgDgL8J+rkpff1Keu
         oLjqjSxcJtQ7BiRiI89HyxHQU/nraqjbNmV0wkwcWM7QWVPOoViBoMJQa6OmHm6KAJZ4
         Pb5F3wDobLHVXnImVYomeYXd6pxabr/38JTrZ0M7G6qbvLLZX5zc+lIls3xi+fWrtnOJ
         PIoB87jXIGMZ5KQR59r8EqA0pAjpnJ3ZNBInpR0Mx5ucXNHhUjaNtcLd6AHIFOzIU6eB
         pwWA==
X-Forwarded-Encrypted: i=1; AJvYcCWH4qagBfWc3p6fNCKFAcAIyN4fVWteJEKKFoerpwKyKZsi+eI2zsuf9LPe2+Jw1/zK4Kk2TLTawA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBP99Zznt6plC9BNZftwTICahf5CzwttRuV2wkhj8Ut22dlEs5
	IWUgtPzJedINNteogqt8nj66+gpmRimSWuIS4u0ha5CNH3Njqk70vz2Wa2VwdiEXG5ao5GzfX8b
	KBCzfot0ESVleZ/Ky4j6K1jDLvPUMdMILKm5QwJMYdQ==
X-Gm-Gg: ATEYQzwwS2HynDJGJPudcqAU6j7gkxFTWtSYX0sJSsZPOm5RDUYOXHiQFp5f/nQhZ36
	ON1G4780lAzMOSyVL11NePljCq60LVrVbQxunEXKMOUk76JjVBz+OxpEo0AjZK20NswugtoX3dx
	YZj5wJCB90BaF+wO1bCoxvoGWEvIG7Gu787M03LxuDgfsaVJfaCW1VanH2Mvyfw6ZmjAvohRf41
	AdPphN6rQuEVIWvrNOglHX9dQWU+F6BCz0lnA56adXVYb12SdGeY4v2CxqupjSzGiLcSX/HtrYe
	N9Agiw==
X-Received: by 2002:a17:906:1553:b0:b97:fbea:a618 with SMTP id
 a640c23a62f3a-b982f37d293mr272282466b.32.1774031374614; Fri, 20 Mar 2026
 11:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310154933.2500971-1-daniele.di.proietto@gmail.com>
 <c29a339d-67c5-4e8a-a1c9-2388aa9f28d5@kernel.dk> <CAExiqTKBFeyxE4nwSxd3muOuZkP5YDSoweYwns4wb64w8efPVQ@mail.gmail.com>
 <086190ca-1c34-448f-a565-aa41f671971f@gmail.com>
In-Reply-To: <086190ca-1c34-448f-a565-aa41f671971f@gmail.com>
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
Date: Fri, 20 Mar 2026 18:29:22 +0000
X-Gm-Features: AaiRm52uq0aQREJPP-51LI4c5BhnrnlTWgYfGoFCXiifoeMhEK3hAabozluYQIE
Message-ID: <CAExiqT+6BZR1+LCZPfYiQuK6cos-MLtS7qbRCRn5L-dgoWpRzw@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Add IORING_OP_DUP
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12768-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.980];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 764A42DF860
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 11, 2026 at 11:30=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 3/10/26 18:42, Daniele Di Proietto wrote:
> > On Tue, Mar 10, 2026 at 4:24=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wr=
ote:
> >>
> >> On 3/10/26 9:49 AM, Daniele Di Proietto wrote:
> >>> The new operation is like dup3(). The source file can be a regular fi=
le
> >>> descriptor or a direct descriptor. The destination is a regular file
> >>> descriptor.
> >>>
> >>> The direct descriptor variant is useful to move a descriptor to an fd
> >>> and close the existing fd with a single acquisition of the `struct
> >>> files_struct` `file_lock`. Combined with IORING_OP_ACCEPT or
> >>> IORING_OP_OPENAT2 with direct descriptors, it can reduce lock content=
ion
> >>> for multithreaded applications.
> >>
> >> Overall comment - how does this interact with direct descriptors? Feel=
s
> >> like this should support both, rather than just normal file descriptor=
s.
> >
> > As implemented, the operation supports:
> > 1. src: direct, dst: normal (this is the use case I mostly care about)
> > 2. src: normal, dst: normal ()
> >
> > I can extend it to also support
> > 3. src: direct, dst: direct
> > 4, src: normal, dst: direct
> >
> > I can use IOSQE_FIXED_FILE to pick the source and I guess I can use a
> > bit in dup_flags (something like IORING_DUP_DIRECT) to decide whether
> > the destination is a direct descriptor or normal.
> >
> > Does that make sense?
>
> Let's not try to reuse IOSQE_FIXED_FILE for that. We may want to
> operate with io_uring's filetable entries and not just files you get
> from there. Two separate IORING_DUP_* flags should be better. And
> you can extract a helper function out of
>
> io_uring/splice.c::io_splice_get_file()

Done, thanks!

>
> It might also be better to make it a part of IORING_OP_FILES_UPDATE
> instead of wasting another opcode, and liburing can provide a
> prep_dup helper for convenience.

I decided to keep IORING_OP_DUP because IORING_OP_FILES_UPDATE seems
designed for multiple file updates, while this only supports one. Let
me know, thanks!
>
> --
> Pavel Begunkov
>

