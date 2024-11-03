Return-Path: <io-uring+bounces-4370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B789BA865
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB4B21C20C89
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 21:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0974218C005;
	Sun,  3 Nov 2024 21:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvmmAD8g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F918595E;
	Sun,  3 Nov 2024 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730670763; cv=none; b=UZzMd/TNFgh976euRqPR9tw/VoSPiPjhdkyC3WWpagg4ExyNPpqsMSBLxQlCegbk57hOA9jgPCx3ONToDcSDDmplK2ntVUEjF38SBgQMnX4xDEzqOFWXiCzBjQcVYYDomC5N9479TvmqREio1kOzJJrq3/etNCNTQQ6u69E0UUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730670763; c=relaxed/simple;
	bh=nyECkW67aDl7Tm0oGLC0oR2T4T7a8YfZ73MS91E8oj4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=W+YtVfbE/VflwPUdNr92Q5G2i7kjHgXW8s3TAxgWT2KAh5TM/mc7VQjfAugK7cvYgo9ZaQ4O5wSp8WbQcpr0kQMvwt8/ukq1CVx2x+E9NKEj6xn3wt0KK8ysj4DdJZ2nP5H0UC+lHhXD0LBcMthbXwsJuqeST0L8zNngGC2+sbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvmmAD8g; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37d8901cb98so2771671f8f.0;
        Sun, 03 Nov 2024 13:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730670761; x=1731275561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GJeT1hIDkdjnOCH2mldCOaopE7SdwmbF0UaxVe5+yq8=;
        b=kvmmAD8gxC7UGZ3SkMjlz9anYOmVBKknQd9Z/lqaVWFdpIQ0f2AoIB4iios8H6dXP0
         359KNCnPdoV93mClKyoFJyCT3uemUgLzkUvo4dIF78FId6qZyEWLLo75B/R+tJn+8teb
         M9wcz3hvYtpoJY8wCbqQpd1umh7bc676ZHaC6olbd+s1v0d+Zs2JcBT9T1aOLuj8lRw4
         iJe+UAQqfYyBD2HPISpRD5kMcKxcJV7RSdNKi88tE8OC3e1OacxrMPRw5jMKYYQu1hz3
         DSwG/fESPB9kESY+uf8ZzzjzeroFRwG6kfUcUlTsnf4k+WBttKf5pcOyKhkGztDi3Yx/
         0MMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730670761; x=1731275561;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GJeT1hIDkdjnOCH2mldCOaopE7SdwmbF0UaxVe5+yq8=;
        b=ISF4NL2NuYJAbppNXqkZIKmftt3tA2/cXS2TMLNVijQZm3DdmLCrELpckYkwQUGssK
         7ps+y2L+M+7QXbfgy8AnCGQtnxw/zOdH4aPqYVzeitBAmqpis1bpmktoXsrX+wiPqOg/
         pfDj0UIfMhU7029y9ymJCp5REj3ScvakCZ9GtMHMNHXqmJ8bRk9kaZtiBq3p1dTwzNaE
         IdLptMQkSNuB+AZ6Pqb6g5j0Za2ZR43efga9SZ92Tglp3nzoRoFZqxaqqBAFsrXQ280F
         sVZjs/HXSloVTXs5DVE6SaQU7DT+LvBOsrw3+E2XOJevlkEF3xP74lgAra5+usAkOyJN
         PdQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkeedW+1ytMq5EunwDoohcwA271hsYezUpceVYUN+WAk7MUOCwk3NGf8HnYsj91WrCIcF2YNw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3R6KsiS+MpGRn7pfvy27wDDyewRszKv8N4KF9VMetP/vcOpul
	+emIGq4kNqlNUw7m27T9OdXwbXCsQZ/Ys06pns1gvgGBUx/WCgi6
X-Google-Smtp-Source: AGHT+IHu0cmhmu0i2UvBXP6jOJUsW1mauYiYUIQbnizMrhHP1xcNEhb/X1jz7M7ga/dp2GIF1KXCmg==
X-Received: by 2002:a5d:47ac:0:b0:37c:fdc8:77ab with SMTP id ffacd0b85a97d-381c7973202mr8749569f8f.7.1730670760264;
        Sun, 03 Nov 2024 13:52:40 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113e51csm11529196f8f.79.2024.11.03.13.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 13:52:39 -0800 (PST)
Message-ID: <b6775ea0-7df8-4cea-b9f7-6f7c8dc2d819@gmail.com>
Date: Sun, 3 Nov 2024 21:52:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
From: Pavel Begunkov <asml.silence@gmail.com>
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-12-dw@davidwei.uk>
 <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
 <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
Content-Language: en-US
In-Reply-To: <af9a249a-1577-40fd-b1ba-be3737e86b18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 21:09, Pavel Begunkov wrote:
> On 11/1/24 20:06, Mina Almasry wrote:
> ...
>>> +__maybe_unused
>>> +static const struct memory_provider_ops io_uring_pp_zc_ops;
>>> +
>>> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
>>> +{
>>> +       struct net_iov_area *owner = net_iov_owner(niov);
>>> +
>>> +       return container_of(owner, struct io_zcrx_area, nia);
>>> +}
>>> +
>>
>> We discussed this before I disappeared on vacation but I'm not too
>> convinced to be honest, sorry.

To expand on this one, a few weeks ago I outlined how you can employ
the compiler and verify correctness, and I don't really see a way to
convince you unless you're willing to check your claim that it can
go wrong. Turning it the other way around, if you see a path where it
could go wrong, please do let me know, and it'll certainly get fixed,
but until then I don't believe it's anyhow a blocker for the series.

-- 
Pavel Begunkov

