Return-Path: <io-uring+bounces-3542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB8B9978D2
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 01:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61F98280D92
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A62AD18E348;
	Wed,  9 Oct 2024 23:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTg1ugVr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCAE28F5;
	Wed,  9 Oct 2024 23:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728515118; cv=none; b=pc5X0pCwpvPNxf4IFcmVvEcayp/voaKv4EYlkr3zcXoprS+aGvqjRNmpezeKwzpCYl/8HHek4W/sU/9nM2gwFs792NWY2ufFY77fMPwVJqx5md1fj0SotMiafVowC3WXniMQhx5rL0CAjSf8AMkDwwLaG3g7Q8H3yZ/KQWj3Y7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728515118; c=relaxed/simple;
	bh=GVbu5W+EoawWiX9oP+c1hgIFjoj79O9cSV+IVre9ICw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRtCanmQY5BPfeVZ0dUAPL5MvkR04nstVygDEoqTvk3pBx93okxUq3jwd0mNM1umklrLiiPSmEQMZ1wmzrI5dXcfSqRdzj+NHNuAoZjOA9y7ycaKTQsCB8J8EaY0vKUTbZY7w/h5gqJPsx6jhi17wGsyIOiC8vz2IOxQRoL2YrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTg1ugVr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d4821e6b4so127109f8f.3;
        Wed, 09 Oct 2024 16:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728515115; x=1729119915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mwO/+TkrUmFpJirky8YHe7AeRiTCNVN59wiu+n2wTB8=;
        b=jTg1ugVrjUB+YF+ExlACHSFgcI3bD/k53a+huezi/0ncMBQJTi8WOiZzKL6ShbtX8t
         gCtgkKbBwzOLEhHr6iqt43mUjGcyWKcUiexw847X5m0SrkXMK7h8IvImRYm7WRSuh86e
         xwp8zaBn5SgvjfUg9E20yqErveTnj0Xw1gGncqJFzA/E3GGb601yFWk7h6Y6PFSErzYX
         XzizbB95e4mY0mzt5EnqBsiig8rSpVnQyYCkEQvz5Sp/l17xMgCFpb2nT5oqRPQRXOZH
         8D/z+Pl5pokFOC3ppblOuSGR1fD87VUbj6BqMMQc8K/fZkvC80LX3AYaji7LkEr7ggYZ
         o79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728515115; x=1729119915;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwO/+TkrUmFpJirky8YHe7AeRiTCNVN59wiu+n2wTB8=;
        b=KX9xL9ggH9KUHievikDTBnFMqvEV9sHrH+KIiPPTY73TFuapReeg1FjvDX/l6ktJB8
         7VQS70cdp51vyeTdFFAX20fk/WV30Cczc63bCzc/QQTycVSCy/8UO69s3NlypZzTgJex
         4EObZKdMhcOX6lh+ZjdxeUqgT50a29GVVarkzmyX7zsmtP78wLP0GGU2iokEW7umot/7
         FY4mwdXGqjRsEC8c/BwOCkfIjW5MouotkALxsMluN40GpG9Ri2FnGKYNCDermirQgv6w
         O6Z39uzGPhbql6vzvmx3cyLob6EqEe8/JyCb+EiCwucAoMAbqfAMcYEPxgpLY43xdmZD
         X/Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXPoNagg54jPfyjrytyZw+qwCw3Fx0T5tThUt2bv029BsndQNWTwkP77Q8/Brw/tWq1vFMgZL8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe6dsjZOxMgcn+Yvrc0qHznT3/Y35O9IHj512IXNS0CamsEzPx
	/u175YvZ3eC81qt3dSbHQRgtIitq9aDscTSv/UtmFTfER1Teu8/h
X-Google-Smtp-Source: AGHT+IGZkF+9qK+nZq7Hek9nP5VIf7zawyzbqSxZ09H4CR5hlE8riLheVAH8/2g58P14EwWZm/URuA==
X-Received: by 2002:a05:6000:109:b0:37c:cdb6:6a9e with SMTP id ffacd0b85a97d-37d3a9b5242mr2834900f8f.9.1728515115067;
        Wed, 09 Oct 2024 16:05:15 -0700 (PDT)
Received: from [192.168.42.9] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6cf960sm7142f8f.63.2024.10.09.16.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 16:05:14 -0700 (PDT)
Message-ID: <f872e215-25af-4663-a18e-659803cc1ea6@gmail.com>
Date: Thu, 10 Oct 2024 00:05:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
To: Stanislav Fomichev <stfomichev@gmail.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk> <ZwVWrAeKsVj5gbXY@mini-arch>
 <6b57fb43-1271-4487-9342-5f82c972b9c5@davidwei.uk>
 <Zwavm2w30YAdoFsB@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zwavm2w30YAdoFsB@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 17:30, Stanislav Fomichev wrote:
> On 10/08, David Wei wrote:
>> On 2024-10-08 08:58, Stanislav Fomichev wrote:
>>> On 10/07, David Wei wrote:
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> There are scenarios in which the zerocopy path might get a normal
>>>> in-kernel buffer, it could be a mis-steered packet or simply the linear
>>>> part of an skb. Another use case is to allow the driver to allocate
>>>> kernel pages when it's out of zc buffers, which makes it more resilient
>>>> to spikes in load and allow the user to choose the balance between the
>>>> amount of memory provided and performance.
>>>
>>> Tangential: should there be some clear way for the users to discover that
>>> (some counter of some entry on cq about copy fallback)?
>>>
>>> Or the expectation is that somebody will run bpftrace to diagnose
>>> (supposedly) poor ZC performance when it falls back to copy?
>>
>> Yeah there definitely needs to be a way to notify the user that copy
>> fallback happened. Right now I'm relying on bpftrace hooking into
>> io_zcrx_copy_chunk(). Doing it per cqe (which is emitted per frag) is
>> too much. I can think of two other options:
>>
>> 1. Send a final cqe at the end of a number of frag cqes with a count of
>>     the number of copies.
>> 2. Register a secondary area just for handling copies.
>>
>> Other suggestions are also very welcome.
> 
> SG, thanks. Up to you and Pavel on the mechanism and whether to follow
> up separately. Maybe even move this fallback (this patch) into that separate
> series as well? Will be easier to review/accept the rest.

I think it's fine to leave it? It shouldn't be particularly
interesting to the net folks to review, and without it any skb
with the linear part would break it, but perhaps it's not such
a concern for bnxt.

-- 
Pavel Begunkov

