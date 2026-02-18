Return-Path: <io-uring+bounces-12319-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KaaFhEzlmktcAIAu9opvQ
	(envelope-from <io-uring+bounces-12319-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 22:45:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8473C15A5F8
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 22:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2947F3001383
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 21:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859C52D1931;
	Wed, 18 Feb 2026 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljz3iNBF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C92271A6D
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771451147; cv=pass; b=rZY3NOwJc41kgj99SIHoz4kJBvtxOrsfcNiSFmUDHQjeSDV2bNqgLaCM4vDgJVFRDtPYfUeyZVdHIKuKDVYNR1/JCE+rb+UGCu+AzeFQkeYDnsVRFuwRzUNZ/uqGeC3sAR/z3YG00uP2ZUBbHFgHL7rAaM2C5G+YyC3fg4zkbzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771451147; c=relaxed/simple;
	bh=ZXbgpQ8wkEkPZiRHRywmKyGx3K6jkL/pJwHYSJzgVUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hKOIo4QFmpRC2kW1VQcC+8GXCV4AnXjjNjggLy8+LFz/c54J1abBpqAFTMTyVocJBbS+tz729sAvgWKZIOxjy4OslR1pYJKlaKl7uhjLv8jKqN/u7f3aFd3l+VCBVbbWZMPkufa0n0RhD3p1ZcZRAAvx+nXgfwQi6evhNbMy+j4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ljz3iNBF; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-502a789834fso1664271cf.2
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 13:45:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771451145; cv=none;
        d=google.com; s=arc-20240605;
        b=XDFGi5fdzjBlUmXoJOvwb/Y5XSc/IF0TLiYaS65V89hY0cYIcszCFDoAUBUENfTITn
         kMOlxh4a2th1PWbjaszH/vypRLujNPDESRp/nHnhwvdNqYcKp+SlVZ8+WOQegpdnKOqr
         d6SEfbJ+SLdOHcGbbL1/hLgv/ekuJqyqdYWQvzxlQonoZDbdVn1AhIHpWqUvLba/J5p1
         dSQrBHKI6X5omlrHQ7e5jvhATbK3q1bb8uDAsvZ8QKOEWMH3q+RXG+LZ6/sC15YFUeaG
         2l09SVyDIiVWTG/3X4mC+UV8DmYokINjXiQqjKG6MxvXr74EF650YJFkz6UreRlTcaPk
         fvcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZXbgpQ8wkEkPZiRHRywmKyGx3K6jkL/pJwHYSJzgVUQ=;
        fh=WPSLnQUdh/RxtbrGEHhAEJaprr4Kb7P9p7rPcZC/ZWo=;
        b=aILiwRfAdRgGcHrVS6m1nYk8W6tq5tFn+bh65H49dQ955NLTqqwbqPqO6jz56rkbS8
         JfVvtAEuGLTT4MbYosafRP2+MeQF0RF7uDh84JdYswvzM2EwdXz2+DbIxRn8hCLqUVG1
         fGu3F/bCXtjuOTskWJlNLZ/dR3d87mxPWBEZgeOBiYEBTzL2kuGnR4521TbDyHzAPjgt
         L78tUAFiLE8LlV8fsw3WCjEd0Deb+MUP+DlEImU34lgQJ3MpNHumVAt6eGNDU53AHLL5
         5J5KXAPgSEOrvPVEYVxkhLjSYspF6nKxCzV8auB08Jmnb5TSTr1A9wa+Eswpp2gU8eff
         UU/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771451145; x=1772055945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXbgpQ8wkEkPZiRHRywmKyGx3K6jkL/pJwHYSJzgVUQ=;
        b=ljz3iNBFn+r8F6c9jl2HDsAQRjYKRnmWOXFglQwKeE8igg1Eq4cF7ilz6ID+E1fBaU
         NyqoSZd+CPVevwJw328RSQAaZF677eptnXrwr8POLja0CyTGIcWuEmWrOwdk7C/mQ35h
         N6bY1JQSLp7VnVUCe4pNYCqoiryBOUF4egVM0EMksFCIbldOCK4GvfNPDiO2/LJKRi/R
         7R1O36136ycOuwq7Uz34UrWtmjxAoJ25ngpfmZeuobWCKNUSRLEWIIOwKITR72zaToSB
         ZhbeM/VvPa00okEgOxMPSXDVfNYsE3R3qpkQjtuD5syqvQ9jYxQs0LkAyaw2eHY4S0Ok
         kiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771451145; x=1772055945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZXbgpQ8wkEkPZiRHRywmKyGx3K6jkL/pJwHYSJzgVUQ=;
        b=acVPyyrAeyCpNelnUsRVwI6uwf9rdca4Eq4Ta7jFlSyXpjrd2JsYhLs1aMA0JxjR06
         huygG8diuBGiEzPiZ40sbwvUPmTOMswSSumeOiscUcsF6vcpUIxDFnAXyHNkIMLTeZxP
         WnWsi7PbdvZfFO7oLDpangh2R7Omd5MFWMiaSHyebIhLBEYuyF2ORvmynOZME7ltmJbq
         GPwpWhs6iH0tPFA4vOgbWn0o1e6GJS9zURB/9jnsIwrixA/6UYJiu5HxqbHWKjonoiii
         XYoMidYoUM5Q2FTLM7o1uqxWMWa3DTfRdpRroId9q1spcU6D/YFSGosR4WAIkxRvWcpH
         qfTg==
X-Forwarded-Encrypted: i=1; AJvYcCWw+3b0EFQZhoQlvM2IrqtfH83LdrU1shy24PKSH8XhloY8A4SslWrcMruEgDQlzXkUkmKb8S1xMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDcjqfTPbR0QATS49nYl/I3C2uFQBRCoxH1gL4S8ZUzYDK4HpX
	yKkRCocN2lIe5IiG+HIsBQ/6vB9O3sGGQpbp3nRu1jEl2Lk89+aCT6yMHqNYQEE/zBbAcfv6W07
	SsrdHdrMsmM16cTJQFR22jaOViF57F/A=
X-Gm-Gg: AZuq6aIChvp4kI36RbzBQpntPpCM9WyjdgedOYhu1uO+PmNlmFdZymTD9yq6LOH02qJ
	qTsv2MAJAIsi52QPAIQ9sXuQB5wdMvco2PpAs1KYFUhwQZ1ED8Ne8YDzp91INDVgtXIzoPAFDm2
	JWrtQNZzONBQzU1KUih4TSCbXSI8c4zA/nZiKC5SqatqSpsJdeMos9SZ5s4Dr42oTjeSoThjj1C
	4RLj7rT1hsiErs7+tW6DkX+ZMHJoLUOS2nOGVotEOgiB4glHdnbhomWFIfzpLMImiir1fsyNdC9
	T7zRoSrtkpm4sjix+1UGpA==
X-Received: by 2002:ac8:5a8a:0:b0:506:1cdb:8b9 with SMTP id
 d75a77b69052e-506a6a373b6mr234590951cf.23.1771451145203; Wed, 18 Feb 2026
 13:45:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 18 Feb 2026 13:45:34 -0800
X-Gm-Features: AaiRm50EPvQ_xI6dP5GcZICg8pXZIm06kkfzQ5XDIYKvFwwA6OD6J73RKQF1daY
Message-ID: <CAJnrk1arKMUjZp0128B6WwhJHi-sxkAFfHYgjDeC=vHjgihmBg@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] io_uring: add kernel-managed buffer rings
To: axboe@kernel.dk, io-uring@vger.kernel.org
Cc: csander@purestorage.com, bernd@bsbernd.com, hch@infradead.org, 
	asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12319-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 8473C15A5F8
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 6:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Currently, io_uring buffer rings require the application to allocate and
> manage the backing buffers. This series introduces buffer rings, where
> the kernel allocates and manages the buffers on behalf of the application=
.
>
> This is split out from the fuse over io_uring series in [1], which needs =
the
> kernel to own and manage buffers shared between the fuse server and the
> kernel.
>
> This series is on top of commit 73cf88d775b1f55 in the for-next branch in
> Jens' io-uring tree. The corresponding liburing changes are in [2] and wi=
ll
> be submitted after the changes in this patchset are accepted.
>
> There was a discussion on v1 about having kernel-managed buffer rings go
> through a user-provided registered memory region. This changes proposed i=
n
> this patchset add a simple straightforward interface where the kernel
> allocates the buffers and the buffers are tied to the lifecycle of the ri=
ng,
> which suffices for the majority of use cases. If/when in the future it is
> useful for the buffers to be backed by a prior user registered mem region
> (eg for PMD optimization gains), the changes in this patchset do not prec=
lude
> support for that from being added.
>
> The link to the fuse commits that use the changes in this series is in [3=
].
>
> Thanks,
> Joanne

I'm going to update v2 with another version, as per the conversation
in this thread [1].

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260210002852.1394504-1-joannelk=
oong@gmail.com/T/#t

