Return-Path: <io-uring+bounces-6508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2A6A3A456
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 054983A1CF5
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307E5191F99;
	Tue, 18 Feb 2025 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fnoMNCos"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB44D26FDB2
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899832; cv=none; b=LW3BOTxBnhU/aWx5pRzLJpdF3evQmrjeVyvAnjTTclRbUQ/ptRW3xptsq+IR6kvRQ1BK5Jc57j+ZvdYMCMhhRMGCOyVbfXaRDcjjFoEeqZsJnS4DM8Y1AvUrEQCYM9zRNokpMw6JE5IT6qE+IU2oxOmLAY7ubF4YX+MQe3r1A7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899832; c=relaxed/simple;
	bh=tnhiEW+b/C0jLye2G3bE2C+VT2RMXD0h5KXwq5vbYaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TulaXTO/437/n94qKK3JDi47prmjkYoYSrfHlhkphnPe+vELceEatzG3wP5Czfjq+VdLfkB4n2GfAtfJ+S4gxXKNHTKDDnuiGjphKJmWbJ28qxgN3/D4pDSMOPjPwtYzcIRRCFpMXYyn4ByBl9QmNX0vXE0mb0vKTQObDqVjDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fnoMNCos; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-220d601886fso77282075ad.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739899830; x=1740504630; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u4X+LmlG/QUyIHoKSwao3u0LN8ETx+U1K07ptUcL0cI=;
        b=fnoMNCosAJm4SrEugc9FWC3lf/DYt4YYne9rAn3qjC4tj9iFQBx7kmQEQE4AP4OuZv
         5LCvQFeLgsvwarLKBrG16vJCtO2OLA7pzzHGcwgr7eMUutYKpwyxLELF2v2EqjKjOCJX
         13vayFxTFEUTHXHY7OR7YHglS61GtJx/Yv3mzGaGfCatRm7f0qL01bzUKJKbQZRfBRgS
         8FbVS1+Ih6ubu/D3OQnyn1P+w5uH3+XXOTAvSm8g2iiVHR4OQpab2W9ia4b3tDAMjRnB
         lrzdJkJXL5CTy17jbGBDS3T7d1imtAx3UwxZFRmP6Hz+Jl91TgQ9O+NL20letPDLs7jv
         RCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899830; x=1740504630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u4X+LmlG/QUyIHoKSwao3u0LN8ETx+U1K07ptUcL0cI=;
        b=nzYw1o3cx76KUijk6t+7hFaOQ1ygvkTzI1DKkuNO/19gNFQi9btaQJIdE36sEkb9MF
         Gs89RdbxRYFJz3cmLZFKcsYI/zbDhvfb1iwr/l8l/3JabUtYNX4wSNNIVaXuT93Fzg1y
         UU+QxNHGIBMh12ZdhiVLQHUKtNMvP9Ic0w3ZSP0FBgjkKWfHuJyEaYnhmN9TDy68CeVg
         Hw9XtzBsMlxEcCc4cJ8zTiyl4DuXTaLSUDTZpxhOmel1ekrswmVkVtBpTOzqlP4RGF92
         vju/3s91yF6gQQqm+4svW7HhZFm9pDPaiaSphtHU0eMbDIeyhxkw4wF/kmOzdCUOt7V1
         N5PQ==
X-Forwarded-Encrypted: i=1; AJvYcCV883fljJ67KW5ji2FQrR2QmswCKqh+faGBIskuEjWsyMPmcBRa8TlUvdTvmpzWorhttbEp456HxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvBmKBB4NTIl+tqrbpLzDNlRx/jrdiVjh9N2tFcRrDRF77yEqo
	qgnIogvqQ4VxnfYhb3/XyPfjt1B8RU6ufujyh0VJa/bTfWMCjfGqKJkq/w8hGHM=
X-Gm-Gg: ASbGncsqPHDYFAYW0q3KKwiitMJ/h4TkILSc7vt34XthLD3N6MfVV8SUWSDmBtikQgA
	v8ns79k+hRpPS6UBa6ixSTmIkZLQaEbBibCPdLcPOKIKv0RsU/5BdfkxSaXBaHYxPbGIT7UbI7T
	tvMYGbqRTku3bGzFK43RjedpbYkSm+HOnQhnoPJb2xNDelnj1dvoP+0N8ehYQSR+5wyIZBclQ1W
	jRnf7eYG5hOfuuX3Wg/kUhZZU/Je+3xL3mxdeOjlngi11WNZKj0yxKObnfucy+LdQVbQ+pdm33l
	yPtXL5f51MWW/4cQZ/6rybcfK/tIJ9cDd34weWNjex0lcfb234w5gBXzfYM=
X-Google-Smtp-Source: AGHT+IHcIDc+1nwrbeuz7pAx8CQAqiKw9Vs/edf9Es5hotcLi/XhQOYe8gr3hlk7Hs+vso3779E5Gw==
X-Received: by 2002:a17:902:ea11:b0:21f:85d0:828 with SMTP id d9443c01a7336-221040bdb36mr228740115ad.41.1739899830056;
        Tue, 18 Feb 2025 09:30:30 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::7:d699])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545e39bsm92496825ad.124.2025.02.18.09.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:30:29 -0800 (PST)
Message-ID: <c1738f1a-3b43-43bd-8d21-e76c4db43c58@davidwei.uk>
Date: Tue, 18 Feb 2025 09:30:28 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 0/3] add basic zero copy receive support
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
 <98e2abcc-c5b4-40e9-942e-30b1a438e5ed@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <98e2abcc-c5b4-40e9-942e-30b1a438e5ed@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-18 09:01, Jens Axboe wrote:
> On 2/14/25 9:18 PM, David Wei wrote:
>> Add basic support for io_uring zero copy receive in liburing. Besides
>> the mandatory syncing of necessary liburing.h headers, add a thin
>> wrapper around the registration op and a unit test.
>>
>> Users still need to setup by hand e.g. mmap, setup the registration
>> structs, do the registration and then setup the refill queue struct
>> io_uring_zcrx_rq.
>>
>> In the future, I'll add code to hide the implementation details. But for
>> now, this unblocks the kernel selftest.
> 
> man pages coming for this too?
> 

I'm working on higher level abstractions so that users hopefully won't
need to call it directly. Could I defer manpages until these take shape?

