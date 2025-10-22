Return-Path: <io-uring+bounces-10098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA2DBFBAAA
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9D4784E5DC9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 11:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A36933DEF8;
	Wed, 22 Oct 2025 11:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WnqcW51w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B058330D23
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 11:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761133055; cv=none; b=lMxAfUiY//RSqVQP5/oBtNJdHp6mH1giyfuWhGpoWWpSEu3tOXhgez5We7KXPcLP90SGMnQOMym7ylxKlZ0VHiVqhyFTself+ufYpzcCV8PCb3kFCLWvY+Wi8QRWCD+81tJqVMNA4jjSKSh3qYn8U3bvOFhXKTcoS2orz2YvWyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761133055; c=relaxed/simple;
	bh=FG/sqVsd+Fkf+vzSHEKocUTNSQsoT3V83aU84GAKYY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pCAv/H7i8lv1q4h2TXhZX8IPPtLvdsrIikXkYZiuA2mdNHAufKP2WECFu4xMi4eyT9hlyPpmKOF+jXMw812u3pIwUox0uJdTt+YRPclM3joGlsk5QdXbFEpKxpd5xNbgq2YPinRC74U1shfMdifBFYPgw/hKwuQHXDhmCJ2FT1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WnqcW51w; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47114a40161so25624115e9.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 04:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761133052; x=1761737852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0FtzE1rGRbv5DLLs6IdqszbOo09k06GGLQDtP8qxuLo=;
        b=WnqcW51weQjU3Gms5L0SW1ZFHWG+92KccPkiO40aEri/GJwAudkF8Um6MwChdcpyse
         8/8LuAkj65yHcdzQoRu9d3swlL2bDbl4iWk8UpIYdBo6PPn5zvhR7YUu3lRgTGSe638Q
         c75CbpMuMegPz2F5YqTOB4xTbxOhsE3094pggEsB5zuP9Bs1lBsjxAPcLh6wCsHwkdHe
         9FKJUOppNWQLfBVp5irZ2FZE35N++Zi7usoQ79Gury3+kr38Cz+rectEPHUygxmG3v3S
         TkNlEbFUCQbNax1EU0vNTy111DThxkdlSmyJrJM6Gt5VjFSXK/Jnlm4YLy9OoH7DD/P+
         O5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761133052; x=1761737852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FtzE1rGRbv5DLLs6IdqszbOo09k06GGLQDtP8qxuLo=;
        b=aUDCeEPGPtIjRqlXxbkO7jPbcwvIL6fcNHKsEKrfhe/ACE+cmTcDAp5QfaBaIquq9j
         +6IdMmap6Xj6svB1/zCUpTb8LCh+FtuomXijcK0XlVKMZVG3VU1DEPHVw9I2v2d7YmB1
         +3pLHa/NaEI4TwrZrApUpqsWquxV4YHYN2hFKqKQnXPuqOlDgL7wNanJg4WNTmlfPxRx
         PZLnSRm+RmKRXQC2DWPMBNQxDP9s7Noetva1YE21QUeSw+5pqvoSeD/7h4sbEgndLD91
         nTy/ZjZPCq3iSSUzhv3ev5XeU3fvvcq1gRgkg6wLN3hYBxgrry3qNBfs0zC3A02LOMGG
         Y+6w==
X-Forwarded-Encrypted: i=1; AJvYcCWBah34TfThQVhIj4x4WIv3WKx/DsMympUsCJ+oSloS+bpTBWaqoW8BeFdwD6thNdgHxjBk4Nj9rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUwTHnksm1p/Jeq0EAWjNo6nskVCvWRQMCdSrlGY79q1kTtvde
	vMhM3lSl4CF/VOt1GVT0yDbNHm/TNonZ/onSRPZ9nH2aKwIlIDq9DEYp
X-Gm-Gg: ASbGncsJuZir+VHBrKQKrBLKXCxvBB7DdcHUxI0kRGIQ+j+6Utt4Ni1XsWiUEt6Yx/P
	Xqma4eV4ctsN3eJUU8hCc9hWs2dT9U7eNCcl4uwiBDNySU15eblL2hGLaDdTZUvxJu+fX+EhGy5
	/v8y186YELISJuVyAPQSHJFJM53salm+jBw8RUwwJNtax/9/N15XVJ1dzq2oNQgOCpcGtPUpvNA
	r7cOjo3Ds9lQYUOwHPlBo0ZVmzKaYLkN468J/XW3C2X+Ca+WVoCCJfVN+M+p35D8q8CsB71r0mh
	nm0mmMdv85Iub8GtR/NnTG5doLTDjpe4KeJTD8SDxX8Gkm6lOdILe0FX/p1Bdoxxv1WecbEIBWR
	8nD0W3eqiYNeKJuVvQXmGaHwrm0WTqLUIIxWssmQ8bq2x5RZvMEZBn7lha8sj1p+qkuyPxt6GYd
	2caxm1+N8vqwNJgeofrjthG30FJDL3p8Oo5cuj+DH3MD8=
X-Google-Smtp-Source: AGHT+IF1K9hk2a0iyyh3ud+8OPJTCJbS/H5dwBoY8Q+Fhh4l8AUQ8L0NbvpOr/KEqwF+bTLI+BK+gg==
X-Received: by 2002:a05:600c:3104:b0:46e:1fb9:5497 with SMTP id 5b1f17b1804b1-471178a5c6emr144735275e9.18.1761133051582;
        Wed, 22 Oct 2025 04:37:31 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b576])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494ac30b4sm36090325e9.2.2025.10.22.04.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 04:37:30 -0700 (PDT)
Message-ID: <60d18b98-6a25-4db7-a4c6-0c86d6c4f787@gmail.com>
Date: Wed, 22 Oct 2025 12:38:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
References: <20251021202944.3877502-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251021202944.3877502-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 21:29, David Wei wrote:
> Same as [1] but also with netdev@ as an additional mailing list.
> io_uring zero copy receive is of particular interest to netdev
> participants too, given its tight integration to netdev core.

David, I can guess why you sent it, but it doesn't address the bigger
problem on the networking side. Specifically, why patches were blocked
due to a rule that had not been voiced before and remained blocked even
after pointing this out? And why accusations against me with the same
circumstances, which I equate to defamation, were left as is without
any retraction? To avoid miscommunication, those are questions to Jakub
and specifically about the v3 of the large buffer patchset without
starting a discussion here on later revisions.

Without that cleared, considering that compliance with the new rule
was tried and lead to no results, this behaviour can only be accounted
to malice, and it's hard to see what cooperation is there to be had as
there is no indication Jakub is going to stop maliciously blocking
my work.

In general, if I'm as a patch submitter asked to follow rules, it's
only natural to assume there is a process and rules maintainers keep to
as well. And I'd believe that includes unbiased treatment and technical
merit rather than decision based on mood of the day.

-- 
Pavel Begunkov


