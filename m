Return-Path: <io-uring+bounces-6743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC84A44190
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 880CF1883193
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 13:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E41426D5C3;
	Tue, 25 Feb 2025 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V99u8oDa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53452267AE5;
	Tue, 25 Feb 2025 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491768; cv=none; b=oMP6wJixJ1TB+W8b8dO4LJ5prh57tyBmav4qzwcRoxonAY1uL9q8UnWHwGsLKV9WAnb4/mX5BHlsUxT1Ba/GjKu+1VmWB2ZMQl4TK6E961MPgtCM2YHf98ly0TmYHZjmNbAKO3eJKclZ1AtHOObfMVg/jKaLrPh3GHLCd2EUCN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491768; c=relaxed/simple;
	bh=DiLY1ms2hpUfmBnGN1pyxMuMPM2d9o1sORXwIXmzmo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKSdfapvkqzTaHlQWPRIXVMKkK1WDVTIDR7Abo20K7UZelQwJalOrGWKtSzB9e95nDl5kb+W0dVUyW8nDDIT/m60yHrC+pWF+GaWog7F9LDDnOaZFVPwD/RDIUhYxJS+tMkfnC65CxPli47l6j4JkHVnpdhwjejtM70vc6KjLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V99u8oDa; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e0505275b7so9014883a12.3;
        Tue, 25 Feb 2025 05:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740491765; x=1741096565; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gH1W2eZ1e+/3isrHjCzghMR+GkcDtBcMh63rzvVg7Uk=;
        b=V99u8oDaqLVgEAT3kVHKJUwXLxChmnZ8w5O3Lbr+fda2D9WyDIU5mMZ/ddoXKCpsHh
         9jcfx0Lc9M2hXZwE3FmrX7rLdN2aKGGS8r3zP1aMHqcV5/KZsoLwnJQjxNtQsxO/ez6G
         DGmtZnuNaHxIo/cWNk/CUj0C9+hUbNvA8PeNbpdECNGS/JzOlV8D7KI7jNZGrx359/MW
         k8DNzyluYtcxWeS75WSqyD6ItBJaE1yQ7jwBrIUzlRlyocqY3iQfp2xjT3al7ScG6A8b
         ysXVksFTnms8wG1F/dnlgnBah1UOkuARp96fJsjzMuQ8kUKXAqb3wBlzBY5TjvgN5ziq
         BylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740491765; x=1741096565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gH1W2eZ1e+/3isrHjCzghMR+GkcDtBcMh63rzvVg7Uk=;
        b=EID1vpkKXXcUJKf4iAQjaU2uf3Sezwn18P26cQgPFSOMCDTFQmET1/rAFsQg40cJ0X
         M7EPq8kKbV+HIjxV88NhOvmzOWXulft8/F3ZRw9YbTtJXEOFvGY45DX37rN/ByFPgbnz
         MZfGlWYjW74KZWrb2DqmY01hPLY5PylgbifZ+MndTx91UXGdzNFKXu+uMA+fuVLEElEB
         sBNc4yxvBeVGbvHJu++V6meV/Dyg2DV6tkl35yarZV3QbysGB2ZBWEsF1ghIhWB+dJyG
         mPWdzjYm8QohpMT49V5IXhusEBeNKNYtsyQQ2a0FYL3ROiU7zpRqRce6C8ULIZFQgNo3
         Dy5A==
X-Forwarded-Encrypted: i=1; AJvYcCWFW8k7RGOOmxsG0IAQjvWZOd+/PkHC/nNfafhPKPawe5siPQsFBT7BxF6G1dhsftskiC3bJhJE2RASIKg=@vger.kernel.org, AJvYcCWK1OxXNk4MvEK2XbUZ8/Rl+66Tzh0PHZt7qV7OJORsEA2Mc/WmVi0xz7Let/9qh/jLa+/mjvDy5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnAyWPC00zbycInPxkbu+PYHucFjZsqC4fACWN8qS+BPx0dTyK
	1DJGJgmQU88hrzD+CpZ9xIacatTcGp/Xv5HplIhvpoE59jx1IdgI
X-Gm-Gg: ASbGnctRN62kTEgBOuyxjYOWLAEj2lKZyLuLMq6MOweTo2X13k6lBtaEB1xLhYj+q7d
	Srrwqb+pJCyWpAEhtIesax45hzBwd744UO0GT1pHLsovrx7xpFd0u4VStb+G7ZSPb+GnNVSXYsc
	pQoZ7kcAcaT18qLR7y5J2kVCZd2I1QG5O3LiMzi0uvlzZtzj1jdCvqPl5r96drNZ6q8RS9ODDny
	ioUlwXilI7lz4qFH1F8cp88vZjdamzhZSEeanlZfqWaw+hkWtEqSJo/wIprUziEP0H00uWt+j+V
	uaq08MI4wHcHuY4qsU28poAw5oikuuIk06Fj693iIXiTQbLtfzIl2PBwSKc=
X-Google-Smtp-Source: AGHT+IGuFev6KPwevZfjqaRBsxFc+AV7VrLQBs8rmxDWp5+72Od1TGI9seqF9RQppNl4s2tM2c7M4g==
X-Received: by 2002:a17:907:3d9f:b0:abb:eaf2:51c0 with SMTP id a640c23a62f3a-abc09c2954dmr1756624866b.56.1740491765429;
        Tue, 25 Feb 2025 05:56:05 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cdc56bsm145830866b.37.2025.02.25.05.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:56:04 -0800 (PST)
Message-ID: <81c3e298-42ca-4388-a31a-dfdd9734a638@gmail.com>
Date: Tue, 25 Feb 2025 13:57:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 06/11] io_uring/rw: move fixed buffer import to issue
 path
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-7-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-7-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Registered buffers may depend on a linked command, which makes the prep
> path too early to import. Move to the issue path when the node is
> actually needed like all the other users of fixed buffers.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   io_uring/opdef.c |  8 ++++----
>   io_uring/rw.c    | 43 ++++++++++++++++++++++++++-----------------
>   io_uring/rw.h    |  4 ++--
>   3 files changed, 32 insertions(+), 23 deletions(-)
> 
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 9344534780a02..5369ae33b5ad9 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -104,8 +104,8 @@ const struct io_issue_def io_issue_defs[] = {
>   		.iopoll			= 1,
>   		.iopoll_queue		= 1,
>   		.async_size		= sizeof(struct io_async_rw),
> -		.prep			= io_prep_read_fixed,
> -		.issue			= io_read,
> +		.prep			= io_prep_read,

io_prep_read_fixed() -> io_init_rw_fixed() -> io_prep_rw(do_import=false)
after:
io_prep_read() -> io_prep_rw(do_import=true)

This change flips do_import. I'd say, let's just remove the importing
bits from io_prep_rw_fixed(), and should be good for now.

Apart from that:

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


