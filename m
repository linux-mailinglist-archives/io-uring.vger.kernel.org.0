Return-Path: <io-uring+bounces-12161-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHVRHkCfjGmPrgAAu9opvQ
	(envelope-from <io-uring+bounces-12161-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:24:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 271D91259B5
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7EBBC3005A94
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D461D274B3B;
	Wed, 11 Feb 2026 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FuAT9i56"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493002D781F
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823456; cv=none; b=rR7EquYZVSsxFLRvDSOmXRnZHwf3kiINNa+Nrnz/ImhCWwJkqVY4n2Sy5ymkU1nRM4O/1MEg1+e0h6AiAM5nPRwiM3niSFzLP1pZaYt76mjeWDr4m+iuJvm16YDDlDxtjTUjhv6DSk0vCBcTUE1yKDfIk+RjEwVg1Q1PW7WKHIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823456; c=relaxed/simple;
	bh=JS7ohpi1RwHa77bCw2mOVDcnTq8a7HMj063FECOPl98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yq2xz2hJEnFALx+Rxs+8d8kfB1tu1qNOsbUy5iYOdt4UETgSa6sgvHthtVaQ+sv+uUBUNP7Sc1XoerrtumpdWmV1Efz8FMmr8GsZ/qpQVJpX9mwpbxSHj8pZ4cGIfl+FXaTeTl+oaOQC2wRyb0dJu3KeKccmI6AZzpJr7zOA31I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FuAT9i56; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-668fdb244c4so1928930eaf.0
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770823454; x=1771428254; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rbv7ZWpqWnVcv/zNcFe4HRudUWSEnWJCsMiCHlnLvJI=;
        b=FuAT9i56S5xeHocqQkvMqtjGAIypSmGTJqkdHs7FpCGoOQ2s9V9vX+Khz1ulf/4LVe
         BJdBrVepCvkL2Mgk8Q3b7OJ/v5L7lcpGprQMfVjRM9G1KPXtGTz9od43hAmDHNcMeLNS
         S08Uv5Dv/TAR+Mis4QPZEODnoo/AqrM1m0vIkLAH1zHQZjagaGRi3H8ahtFjpURuPnI6
         ILTv0hE0R2avMhzI8cbq14Xq1ChzBB77Y95D7nAYP7+Xlh5J+goQH1fQhOE6W435VMG1
         lMoLNNiRds1xvp/Sq4v0+5oseU8BWdbg47+fuwyNzXHsHnKOwNoip+gabmJ3PWh4//nU
         hh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823454; x=1771428254;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rbv7ZWpqWnVcv/zNcFe4HRudUWSEnWJCsMiCHlnLvJI=;
        b=cJGb/nZCJLttBsQ3D+MELDk11CSz4Goaqn67eEM6YOTo/oxajt7jmueXuXqZfh7lu8
         Lx5RP27lWGF1Jnu84XXNCLw0AX4L62aVeUjHqKY/Za6fVkuxxOf+ejQo/lgVbCRWQeZ1
         /48ft0AhZjLvLF0aLAnLcm74iOnezEYZWHxZI1YAUbDRnH2z5racedt752tlh3ZOkR6F
         tg40Nz74v7vBNwVFc22WfILZkReZZ0Bgd445ySCK34IGwkdfCXHYYrsfgjLCkboprWF7
         THdjsXAXRFg15AMx9mUtA1/faZdgsoImNFxfvKReClJaV0LghWFva5nIqfGF6XvZGojE
         uQSA==
X-Forwarded-Encrypted: i=1; AJvYcCXUHjaNIKd1ORuEFx8FI+Y7g6u3kxGZWUaM0ZXGc+ADProyNrEqZiKjkeypQ5qaXn2z64D+FoadXA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoGWkD9Me0s5/YTkivjXAA1huyv6KWAk2jb2kj61KWTbi8g6sr
	8ZqrLjqKaTZEPBGmFYhQ7fPNFXFMVzp9lPWmmtG4zbsk8D5TYSEt33SA21GxUbm7Zm4=
X-Gm-Gg: AZuq6aIkhe05X2anIwHpj+A1Jtlh6ZOJXPGwdNa/JRRb3/GFUeON8SZay8oIb8QM/P1
	32jNGeyoy8OW1+u089B2cMI+qJMNDSp1nl3G/i2DUd+7jqsz8wTq/JZv3elB5lzN43OTVykSCGH
	f3c3uW6g19DG4OnuNdeWsb2C/eiMfNfcmWJM+AN+p18w95NTa1262wikvLVq5hQkrlIOIk3j+Zz
	9UbH4phN0GWipBQ/qLAevvFQa9BRstgCmabZp1htqxrHHfqpi3RckBQvQf1QtsuB+vVJkvRyhbC
	VGPQ2kVEMqcRt49vMnYo0BujQNkFH5CqJpbzOEnVnsd2m2LumTrx5tdtRa9iCG9rM3MTZmfhqvb
	HCYL0N29VXH2cTNNZVspKGCI7lRDnWK93Wgiw/kLkvZJYfpqKKGZkwNMa+ph1/MyMvtAK09etjL
	OFsm1fmVJ7myMKzee7oImEoF0LwQKST36hvw2J0ulXfxTkLSFZtZzLnlzJTeJ85iSsMVDx6GLgV
	EkJBytczw==
X-Received: by 2002:a05:6820:1524:b0:662:b608:d5ae with SMTP id 006d021491bc7-6743daa47b0mr1243856eaf.57.1770823454131;
        Wed, 11 Feb 2026 07:24:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67475dc40d0sm1021335eaf.13.2026.02.11.07.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 07:24:13 -0800 (PST)
Message-ID: <90c1f09e-9334-4036-a6be-ad7d2f91bfc7@kernel.dk>
Date: Wed, 11 Feb 2026 08:24:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 v5 0/5] BPF controlled io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770818588.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1770818588.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12161-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 271D91259B5
X-Rspamd-Action: no action

On 2/11/26 7:32 AM, Pavel Begunkov wrote:
> This series introduces a way to override the standard io_uring_enter
> syscall execution with an extendible event loop, which can be controlled
> by BPF via new io_uring struct_ops or from within the kernel.
> 
> There are multiple use cases I want to cover with this:
> 
> - Syscall avoidance. Instead of returning to the userspace for
>   CQE processing, a part of the logic can be moved into BPF to
>   avoid excessive number of syscalls.
> 
> - Access to in-kernel io_uring resources. For example, there are
>   registered buffers that can't be directly accessed by the userspace,
>   however we can give BPF the ability to peek at them. It can be used
>   to take a look at in-buffer app level headers to decide what to do
>   with data next and issuing IO using it.
> 
> - Smarter request ordering and linking. Request links are pretty
>   limited and inflexible as they can't pass information from one
>   request to another. With BPF we can peek at CQEs and memory and
>   compile a subsequent request.
> 
> - Feature semi-deprecation. It can be used to simplify handling
>   of deprecated features by moving it into the callback out core
>   io_uring. For example, it should be trivial to simulate
>   IOSQE_IO_DRAIN. Another target could be request linking logic.
> 
> - It can serve as a base for custom algorithms and fine tuning.
>   Often, it'd be impractical to introduce a generic feature because
>   it's either niche or requires a lot of configuration. For example,
>   there is support min-wait, however BPF can help to further fine tune
>   it by doing it in multiple steps with different number of CQEs /
>   timeouts. Another feature people were asking about is allowing
>   to over queue SQEs but make the kernel to maintain a given QD.
> 
> - Smarter polling. Napi polling is performed only once per syscall
>   and then it switches to waiting. We can do smarter and intermix
>   polling with waiting using the hook.
> 
> It might need more specialised kfuncs in the future, but the core
> functionality is implemented with just two simple functions. One
> returns region memory, which gives BPF access to CQ/SQ/etc. And
> the second is for submitting requests. It's also given a structure
> as an argument, which is used to pass waiting parameters.
> 
> It showed good numbers in a test that sequentially executes N nop
> requests, where BPF was more than twice as fast than a 2-nop
> request link implementation.
> 
> I've got ideas on how the user space part while writing toy programs,
> mostly about simplifying life to BPF writers, but I want to turn it
> into something more cohesive before posting.

This looks nifty. Do you have a repo on the liburing side with some
examples to play with?

Nit on some of the new files added, not all of them have SPDX headers.

-- 
Jens Axboe

