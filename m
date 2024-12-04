Return-Path: <io-uring+bounces-5237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA359E4493
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9167EB2AFDE
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280231A8F74;
	Wed,  4 Dec 2024 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMEbfYYA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C81E1A8F76;
	Wed,  4 Dec 2024 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733338724; cv=none; b=CDVJHWIt5wkray28eakRYnKOYpvzmlN3oGjxi9We5+CHOvtO0or1b4S+LqRW4xNc16LxShgp1lha9Q7QHm2QbyLy/syT6fT9hSp79l8Gty4snTUwg+QoP619MmviHS9/uAIu3Pnd9yPxqLlgBlvUIrKSJBgF5r9T3RtfdgZBXYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733338724; c=relaxed/simple;
	bh=huN4Cw1QheplR6PlW65YlwFGApsbNogiicDY2c+kuyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hm6A0vBFmBAxBsIbwOedw2CQm0hw6Q+rbcAaIFSB0F6Mn6MeFXWwNcV6mR7aX6+L6dBOt4rqSY/iyzPwUz13k1Jq713ery4JHyMd9ttelGkB/n40FycHtg+ePSsAFIHmG2MS8SD8h67GMtBQEGhIDZh64zWKJhbNQH3QWL0WHJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mMEbfYYA; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d0cd8a0e91so31996a12.3;
        Wed, 04 Dec 2024 10:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733338720; x=1733943520; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+acUKc1gmJkftQGWaeIg2xjMp0m4rStQk1RIHhFeK7M=;
        b=mMEbfYYARTkOEySj2g7TgvaqrAcSTepv9U+U2WkTN4ZP6DRFNQ4SXw6XBNxHSIrY1r
         GER7tY2a6yrupkuSxPq2DaCllUyROJmBjZq+wBKXDBHHJvAsCyjd7DP7DvHsub5R+Hke
         4nD8xftD+5q5ZoFnn1jxQRCKdgiv1GQCkDBfdTv5z4f+7XSqbStC9HqC8Rdy1PLQReeM
         8PwgL1cfOHjOTlR1bts2/6T0Y3QwxPaDk/7sgiKnZK3tVDrnNlHP4c0FftZ8tfsBZhhl
         tHZTLygr2cK53KceOy5c0UPnu7v8+cEgvde+23OV3j9pw5keNHvWgZwsPY3mo5JEpQqQ
         r2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733338720; x=1733943520;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+acUKc1gmJkftQGWaeIg2xjMp0m4rStQk1RIHhFeK7M=;
        b=uPDw/spS0EzQNwZr28YFpDc71UPaJTsjdBPBloCEBA4D6wre/VRUl4n7JSZdSfO0k8
         FwDXiTxwAkW7G22w+jlJkYc/PX0dtyLFFH9p4ovZllNu9dUMNQs+/PUuAe/o6U3EwCwS
         wy3LRd0Wf3hepNj0C9wmPIQsP5SqButpibuth7IhKq5ON9/C/EF1mi59wuRaRL/mDIHq
         vVvx+LUBM7O95WwyM857KNlxD2GjdgbN0sCxaSqFz01ZBFRIb3WYaKytqPagOqvDpkVz
         t0NEnwqrux32FQtDLJYwkDJY8cof80VKfWzJHUYc204Vw6hJUOc5qdbOXpR809sMuoIm
         HprA==
X-Forwarded-Encrypted: i=1; AJvYcCV7YeGP+e7tL+Dd9JQox7iriCNydM7Qain7k1A4BOHhHFwr0qiBFUPKq8bY2jjWrOgJmYAKgwQI@vger.kernel.org, AJvYcCVIF/1ijI9Mfufil7TVPljmiM7JB5qJQ2LtcaZdy76CGQiayI170UEoi8pwrMAjlXFsCNtJie/oIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMGh8xK1htPMohRXnyZBLuAgQXr2UPlyPhGowezXw0iIAA7FjZ
	nxzueyGieNMv27B155qy9fvqykELGHbA9/yk9yfMPOIt+GKWbuAV
X-Gm-Gg: ASbGncsAYOvMg5MYq+PVRbiX9eNueD9BxtyuvwB8Yv56AIDtbST+iZU3a+blJLSDWY5
	TJJTGMgshnclWSupYEfEauBM6PHLCprgX4MEnrochLQhsjzjEjbkWIW94ysf7rUpl7UubIxP67h
	YYvnBy/VTgJUCGYmnf9Yd0TIZ6W7OPANJyED4Y1Afk/jQFlusSPG1AjXJIZ0c5GVodjryv13lO3
	wX5zp5Y94LaVC4uxZS3cGW+693Assj4eEVakLlfiwaGzADjrqod7n2xYYK7Dg==
X-Google-Smtp-Source: AGHT+IGi0cZAMiCjuWGwMA3dx7xBX3Kr+qPeTNyx2k96P+UBvcSiEU4eMMJIijBIYx0z2t8TOHLTWQ==
X-Received: by 2002:a17:906:310a:b0:aa5:48b1:d282 with SMTP id a640c23a62f3a-aa5f7ee66d4mr664142966b.37.1733338719442;
        Wed, 04 Dec 2024 10:58:39 -0800 (PST)
Received: from [192.168.42.131] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d0f6cf4bbesm3319608a12.43.2024.12.04.10.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 10:58:38 -0800 (PST)
Message-ID: <41da1af6-edf0-4c8c-ad72-4f51f1056da3@gmail.com>
Date: Wed, 4 Dec 2024 18:59:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 00/17] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/24 17:21, David Wei wrote:
> This patchset adds support for zero copy rx into userspace pages using
> io_uring, eliminating a kernel to user copy.
> We configure a page pool that a driver uses to fill a hw rx queue to
> hand out user pages instead of kernel pages. Any data that ends up
> hitting this hw rx queue will thus be dma'd into userspace memory
> directly, without needing to be bounced through kernel memory. 'Reading'
> data out of a socket instead becomes a _notification_ mechanism, where
> the kernel tells userspace where the data is. The overall approach is
> similar to the devmem TCP proposal.
> 
> This relies on hw header/data split, flow steering and RSS to ensure
> packet headers remain in kernel memory and only desired flows hit a hw
> rx queue configured for zero copy. Configuring this is outside of the
> scope of this patchset.
> 
> We share netdev core infra with devmem TCP. The main difference is that
> io_uring is used for the uAPI and the lifetime of all objects are bound
> to an io_uring instance. Data is 'read' using a new io_uring request
> type. When done, data is returned via a new shared refill queue. A zero
> copy page pool refills a hw rx queue from this refill queue directly. Of
> course, the lifetime of these data buffers are managed by io_uring
> rather than the networking stack, with different refcounting rules.
> 
> This patchset is the first step adding basic zero copy support. We will
> extend this iteratively with new features e.g. dynamically allocated
> zero copy areas, THP support, dmabuf support, improved copy fallback,
> general optimisations and more.
> 
> In terms of netdev support, we're first targeting Broadcom bnxt. Patches
> aren't included since Taehee Yoo has already sent a more comprehensive
> patchset adding support in [1]. Google gve should already support this,
> and Mellanox mlx5 support is WIP pending driver changes.

It misses some changes and has unaddressed concerns from Jakub,
so that should rather be an RFC.

-- 
Pavel Begunkov


