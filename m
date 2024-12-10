Return-Path: <io-uring+bounces-5386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B5B9EA6E2
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EF1C16819C
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF12522258B;
	Tue, 10 Dec 2024 04:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKAocXLj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BBF1D7E4C;
	Tue, 10 Dec 2024 04:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803364; cv=none; b=rLDwMyxDw+FUxgAaJUvm/8EleUQlc8npRoPWnb5rLCuzhK9Ib6W9z/ccQtq4rlaBN4WD8X3E8z8xliy/iFlByVD7LdAvlRrdq2MrcB9MgRN91xCbvkA8OyreK3gmJJOyunshLsNWyN1u6iWD5dWKG1FhGjeU3xlssqwUO+2Youk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803364; c=relaxed/simple;
	bh=Sx871PiLb0idIGmMJFPactKyI3butziq31u4oN3XmEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JbiBfoTwg2i0V4BzODcqjhGOxztBpbzdEov2C1qg1sCdQuTyxGrRQIS4mQ3S5iYb+TosfgKSlPtOlTlSoUqZojpi5Ngd1sk3zp3pwxd/MJZKfTzHOiREnN16u9CdHKerdEDiZ+g9SjMerdJuRcqgyvOk88/JzWdtps1secE7O+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKAocXLj; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3862b364538so2092000f8f.1;
        Mon, 09 Dec 2024 20:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733803360; x=1734408160; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MNwXowCkLmUhdCdMCcbLIBuj3MVAtIxlJMqopvFpVDo=;
        b=GKAocXLjw8tbim+zlvRtGzz2HDujlUHzxMs1JvCmZ0DqMZTNkY16Wk9XsC9JHA6DF4
         2SNt2BBw4vKImSEB59ucHMu30MX66lfzbrliTAabXpCe2MjP5sVbGLgDuKoRfvA2eaXm
         8632Zf+vEZRvDh1xIkmNzTmq71DbqcfVXEC2QnDsPv6vAHMBiBZWxjumGk35vpXwChEX
         +tRY9qFX2pkTMTRxIMWXQwMTn03zrrYblX/O7TWbDa8j+gDgmEvqpSTFmkOZAPl43IJh
         1dj6OM0ZgWX5mzAs2Po177j1ZHE1kQr4nMoYfmrImEgZhonA8SGu5DP9gvjah2uYjhLO
         ocpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733803360; x=1734408160;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNwXowCkLmUhdCdMCcbLIBuj3MVAtIxlJMqopvFpVDo=;
        b=Kg28MWZITOGN3MKM3Vp+24bBwEwy384ZikZamxc90m+BxWzZhMaSS0gnB21ihe+rLL
         Uo4FoBJ9uypzJFXRbo6XPiijHQaJd6baIL/Fmw1i8a7tn1dhTl/wKm3fq5OVqunhE+yK
         rds4HxL2ZkLFXNaG2FRe4Oub0gREQ9y0YaHM74cCmjCZCUR7TMiz/J9LxTFFpBrH9ouX
         AZOb/oubuF8WFTcszW++nVsslqy+DDsuLiXg6GzndkATjGMmbA6m9dGMDt+U9rL1myWc
         mIaURN8SBjHrnXZJH0Y/ONP2IFg/mKg+hNq5SEoHtgm50/NyKLa7at4OrkzxPiBJTlCc
         L46g==
X-Forwarded-Encrypted: i=1; AJvYcCXhfGsoNcEKQARgtX1JGwZ1FzkM9XqDi4hLNUzYXm0qVsX4R6k/wL1y0x/zoJBZiKR4FK48d/g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2JM/xYWOmzVK36GryEtIp8kmeRYUJrEqYJu1CZd8yarZHjXCY
	OPeduQIfDvVr3pmuYADd6gV/upDO3tJEtQDO30jzme3Gk0RKLl7i
X-Gm-Gg: ASbGncsSfErQfKr1wB5TmW9VAr3hax2VnB1BRX0zUALqfAPrq/Tsv9os5WNKbnnPZHH
	hQ8ArFdPfbZmS9PoC772/eWxODbqw7+oNtGPp5DE/kC6I4ooc+DiuMNLSnNF739o/S0zikfGZMv
	kM3ZZRH+qXnsM5Ae0q5Cba9XVHkn9MIYZqLOZanr7jslRgACrxk9SOx/vLNDm145SFf2ZDFa0NO
	vU5tPs8kXxX0dToNcGqDFI/orK8eF/nfSrwPsXzPpdqemDrlKDqtxN/cLTJg/M=
X-Google-Smtp-Source: AGHT+IEYjHEKgbz/NXNWpGuMS09JG3a4HiXrgDUTXYQxmK1i+M1s03RHpv8A4ju7a2ZGrT6NueJH0A==
X-Received: by 2002:a05:6000:18a3:b0:386:2e53:445c with SMTP id ffacd0b85a97d-386469d35c8mr1064416f8f.22.1733803360348;
        Mon, 09 Dec 2024 20:02:40 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434f7676d45sm64448625e9.33.2024.12.09.20.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 20:02:39 -0800 (PST)
Message-ID: <9debb3d5-d1a2-434e-b188-0e1a9d5c0ad3@gmail.com>
Date: Tue, 10 Dec 2024 04:03:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 09/17] io_uring/zcrx: add interface queue and
 refill queue
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-10-dw@davidwei.uk>
 <20241209194920.3bc07355@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209194920.3bc07355@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 03:49, Jakub Kicinski wrote:
> On Wed,  4 Dec 2024 09:21:48 -0800 David Wei wrote:
>> +	depends on INET
> 
> Interesting, why INET? Just curious, in theory there shouldn't
> be anything IP related in ZC.

Because of direct calls to tcp_read_sock(). With more protocols
should be turned into a callback (or sharing it with splice).

-- 
Pavel Begunkov


