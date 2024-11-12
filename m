Return-Path: <io-uring+bounces-4617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 390F79C4B4D
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 01:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDD1D2842B3
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 00:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DB8201271;
	Tue, 12 Nov 2024 00:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggvgGYhH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AE41F80CB;
	Tue, 12 Nov 2024 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731372832; cv=none; b=mReAXicHeZuDMKPJSvwe32iq6vAY9xtjCbLXnJIKO/XdtEPj9A3AvLgqjyI4hxTvl+hiCEEtto7mjJy7oqLFljowtPn3nyGvO8Lk0eqX0+KUsU5dnJ1j8lJ8/I4BYE0H+O4rUHWmZXnQiOz8EXU10r7PzoicKg/VP3xziptE3Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731372832; c=relaxed/simple;
	bh=PQuNSkREgOMtR3zEtJkiQiQTb8dQcMy7wmSmmDZXtWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXQRdCJte53HHWeqGpbafqOSBi8qTunZ/mhpV0hJs0tqkiIYrYH5j/EEuApHBZziU2bL3KBdy8RjI+lgP/JIkv5+VHZbFMXUAdq8EV3twlIQ30j7juEalSuTyuvmPWCZps6rBo6GxQSluwvAvt9YgP5wvfxruG9LHU9Sc1gIUZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ggvgGYhH; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4315c1c7392so44823705e9.1;
        Mon, 11 Nov 2024 16:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731372829; x=1731977629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ze3l2pViJF1Ke3GJwQHCrNz3T2sv8K+NO5ktGTWIZ3E=;
        b=ggvgGYhHpDYTkXQqj3pJ9iuDy89jTvMeKdQN8OvyPvYHglghKTrZzfQpj30LnzGiQ7
         m+3/USxmM8/UZPZsB+fK5oFdt29/WYV1F+8ak2WJnCVQM5ByMe5Ubvr309ohPQKArDco
         KpOu60aEaOyk0a6Iqc6q6b+4asq6D72mA7iM7XrP9aYwcI2WRNfUsop+h3pV6gNnJbmH
         BJeVqaP9KNkq+2utrzq1cqQLqFxUTlCQp5HYnJjaHs+sR3bSyWRzQQOzTkz1YgiqZi91
         YaFe1oyKA2WxNZa1c9t7olYvwnMDWT/ozbpHayQdxqR62xetpbIOtZyYcVSZ/2IOB/y5
         00sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731372829; x=1731977629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ze3l2pViJF1Ke3GJwQHCrNz3T2sv8K+NO5ktGTWIZ3E=;
        b=S5c1picT6fFTQpPi/dO7zuAP5UVbZQPibmIxjfYmA3GOIOjLPhDt75DHcZdhgZm9rW
         m7MuejmSQWD2/qLR7+ah/wbwi1/9qn5EU6H3Bp2ms6k1tjCyA2kurwuR6AiZPwHmFpJl
         up0ARf7KKeFHnT0bB7nlvNL34lESXpB3fK/W62vJA9Hsd2s0qddDpLd0FeMQqydGOsDP
         wocglC5NhcX5PTWH6VwFjdYI/5FXCbkDKbQyIXoGQk/6c+vZOaE1SbCCqMPXBfYHv3fg
         pHB8UU+b7V27Np23NgIZUqZTPPKgZIw0FxfkgMWchFmUST5LtXcX9f6EMjUZQWvtDYGp
         dV7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUh7eRRuaY7HuXbmwJsvgZQRCEXDtntq1pYM0lB7Sdcej1dDjXP56P4Ce9J6MbJ0y6tuRFk0UUBuQ==@vger.kernel.org, AJvYcCWLQ5LzZIm0NB/efqofKT97j+RzcR1U9tLabJvLonKBijU35z1ZBzSGPZDKWLZQAz/VWpOfUDYozkfAJpg=@vger.kernel.org, AJvYcCWyVgQvgCwde5lctyB3oX8kc59R53IIDjYP28hutfuK1GDF5rjy+6JiJyCfzcfQg7wimBdCuwGFodS84iDpPA==@vger.kernel.org, AJvYcCXjLyabPMgE0KyUpvSu+pjjrpsn17WPR6c+g+S9YG5VlFaZ2aQz3+Vuw0hB7Cb/iIpQMoW5UOGdPm9Rpg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwB6gFp8YSu72rmylG2SYBnoZ3yvXLF4hgdtd8lsJ09S1NYEkJp
	hoKwrrvdbhan4nGzzXt/YN/3WFGCjViGedWkHcuJfCiKaO7zlnOv
X-Google-Smtp-Source: AGHT+IHK2R7O39rPlG6hNltnOdR+XHDxAnsH0twtPY40zT6Pf5flUZXqdiOD1gkb9VOabYgYNTuldA==
X-Received: by 2002:a05:6000:410a:b0:381:f5a7:9baa with SMTP id ffacd0b85a97d-381f5a79bc3mr8812654f8f.0.1731372828800;
        Mon, 11 Nov 2024 16:53:48 -0800 (PST)
Received: from [192.168.42.75] ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381eda0411csm13818107f8f.95.2024.11.11.16.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 16:53:48 -0800 (PST)
Message-ID: <86029316-4c73-46fa-8a02-a34103d6c60b@gmail.com>
Date: Tue, 12 Nov 2024 00:54:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
 anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20241030180112.4635-1-joshi.k@samsung.com>
 <CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
 <20241030180112.4635-7-joshi.k@samsung.com>
 <ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
 <914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>
 <ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com>
 <b11cc81d-08b7-437d-85b4-083b84389ff1@gmail.com>
 <47ce9a55-b6fd-47f8-9707-b530f2ea7df5@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <47ce9a55-b6fd-47f8-9707-b530f2ea7df5@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/24 17:41, Kanchan Joshi wrote:
> On 11/7/2024 10:53 PM, Pavel Begunkov wrote:
> 
>>>> 1. SQE128 makes it big for all requests, intermixing with requests that
>>>> don't need additional space wastes space. SQE128 is fine to use but at
>>>> the same time we should be mindful about it and try to avoid enabling it
>>>> if feasible.
>>>
>>> Right. And initial versions of this series did not use SQE128. But as we
>>> moved towards passing more comprehensive PI information, first SQE was
>>> not enough. And we thought to make use of SQE128 rather than taking
>>> copy_from_user cost.
>>
>> Do we have any data how expensive it is? I don't think I've ever
>> tried to profile it. And where the overhead comes from? speculation
>> prevention?
> 
> We did measure this for nvme passthru commands in past (and that was the
> motivation for building SQE128). Perf profile showed about 3% overhead
> for copy [*].

Interesting. Sounds like the 3% is not accounting spec barriers,
and then I'm a bit curious how much of it comes from the generic
memcpy what could've been several 64 bit reads. But regardless
let's assume it is expensive.

>> If it's indeed costly, we can add sth to io_uring like pre-mapping
>> memory to optimise it, which would be useful in other places as
>> well.
> 
> But why to operate as if SQE128 does not exist?
> Reads/Writes, at this point, are clearly not using aboud 20b in first
> SQE and entire second SQE. Not using second SQE at all does not seem
> like the best way to protect it from being used by future users.

You missed the point, if you take another look at the rest of my
reply I even mentioned that SQE128 could be used as an optimisation
and the only mode for this patchset, but the API has to be nicely
extendable with more attributes in the future.

You can't fit everything into SQE128. Even if we grow the SQE size
further, it's one size for all requests, mixing requests would mean
initilising entire SQE256/512/... for all requests, even for those
that don't need it. It might be reasonable for some applications
but not for a generic case.

I know you care about having that particular integrity feature,
but it'd be bad for io_uring to lock into a suboptimal API and
special-casing PI implementation. Let's shift a discussion about
details to the other sub-thread.

> Pre-mapping maybe better for opcodes for which copy_for_user has already
> been done. For something new (like this), why to start in a suboptimal
> way, and later, put the burden of taking hoops on userspace to get to
> the same level where it can get by simply passing a flag at the time of
> ring setup.

-- 
Pavel Begunkov

