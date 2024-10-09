Return-Path: <io-uring+bounces-3506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 951C499746D
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54D61289691
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBD11E3DC3;
	Wed,  9 Oct 2024 18:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y0/rcEq6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E301E3787
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497395; cv=none; b=JYgVEbspWr2qfF4NaVWroz31uFqlJrr7pQrFpFVTzKYvblVDgs6IXmZS082JcahqilmQb/ZxmWdb4QLCSENSRCaPaoQ1BQKrezhl+B/7nrlN6UPRI3h2h6qIdCfOreZdAPQznVfLkYFrJNo7h12wjG+H/pbl3rWZf9DuhdhDOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497395; c=relaxed/simple;
	bh=7ZckoosOJg5lt+fGLV3IgX3ru9jsNenyyZEteqixIhM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IBM3H5xS5mFiNd+qrJnoyjOaHZj3Y6niIdGew7MVpO7QF0H7Rh5V7sWihOwHWNc2VuvMHNtjH8JWYAISFI5JWRmabtcy95iYsNpojhoPjt04UbsJpoUQcQvDh66XiPjTVHgY0J0BGjy1gEd+3LfWUe9mX3NUy5/+ON5E58GIlXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y0/rcEq6; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-82ce603d8daso3029339f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728497393; x=1729102193; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E1jAV6Csa9b7Umapqy6D5mKXVweTDrHhQslvN6XHIrQ=;
        b=y0/rcEq6e4siVCu5f5DZ4jlQtLvi46IrysFYN+e0JwqUzNAHCi85Gi0WQn/Dh1XUWP
         iwqPVg9Yn20qqlmDiYIRVs2FY74E+isPRhUKA7ua6hQpxZfPHOJTBwztqkGg9yxqEKV8
         NmUFTJnZC91T6sLrg1nVoTmZrg+NjzhV7i52WWHdpWJRq9qA1t5QV/d/ljD4aYD4erhO
         Zyyv72qU064Kb8MYLLKipoucUbka/KG32r1rEWJL/OcezO7WY4ZeSFhTBg4wykr5LNfX
         uVBh4d9+DlA7iy/0ply4ewqE5w7tMvniLHGgosSwX6UI88SUe48PTvv2HJXtdsTI8rKo
         tLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497393; x=1729102193;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1jAV6Csa9b7Umapqy6D5mKXVweTDrHhQslvN6XHIrQ=;
        b=R50Z+re+Rbmoa7u24K9k8Xze+k+PyYjAtni2+JEUTEtj2ZmXGzwMjQopgJ1VEVplwj
         29XnC2YLERkli2T0NlqI8Wxpt+oQ1hoE6kz0kkDq8YvsaT+NfdE9vT/6GvX29Aiil6sr
         NBpvS/FBeDK+TvBJ8/ZAr+h27ducrYfIo0NUxJKnNxtT9NYN5ie9OMdLkt8u4o7TU7//
         SlBr4O7nPz9ughM/IcGxi2BaTjAMbKBm+UtW9GSTYHS+UHpJcjgXP3WuPMxYyow/ros3
         q27Y5TriwLFjolilcaPjwGVrV/aNLSar3boJc52+FDUbuEDzAtIqShvJ3W3jhONZwUoP
         jnWg==
X-Forwarded-Encrypted: i=1; AJvYcCWDnMf18fCX1dKMJeqrOanXrWjK6xH2zjsYFVEdjp7a3jk6YGVVg/YwsG/t44KZ0fCihoiV1N6EGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbTC9n4XmKp4P9z0Ajbjj8H6Q2/LtBaLujXQHr1h1wuXC+DI6L
	eF+GMfn6/Bn6HLu3eUXvw33PHerNmyUsRQIEKSqcvAfYzdzM8Zk5GvHEbbuk85M=
X-Google-Smtp-Source: AGHT+IF8Qe4fCL/c86CeDxV9U2SJmYSHr/HQ+Cny1xrRXaf9BAF7TwIpLEzpfWjU5vQjXxs0L2VV3w==
X-Received: by 2002:a05:6602:13c5:b0:82a:23b4:4c90 with SMTP id ca18e2360f4ac-8353d47bf54mr373507839f.1.1728497393420;
        Wed, 09 Oct 2024 11:09:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8354797ea3asm9909839f.24.2024.10.09.11.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:09:52 -0700 (PDT)
Message-ID: <36dc2b93-e519-4ff5-93b2-62a767ad0528@kernel.dk>
Date: Wed, 9 Oct 2024 12:09:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/15] io_uring/zcrx: add interface queue and refill
 queue
From: Jens Axboe <axboe@kernel.dk>
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-10-dw@davidwei.uk>
 <8075828d-74c8-4a0c-8505-45259181f6bb@kernel.dk>
Content-Language: en-US
In-Reply-To: <8075828d-74c8-4a0c-8505-45259181f6bb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 11:50 AM, Jens Axboe wrote:
>> +struct io_uring_zcrx_rqe {
>> +	__u64	off;
>> +	__u32	len;
>> +	__u32	__pad;
>> +};
>> +
>> +struct io_uring_zcrx_cqe {
>> +	__u64	off;
>> +	__u64	__pad;
>> +};
> 
> Would be nice to avoid padding for this one as it doubles its size. But
> at the same time, always nice to have padding for future proofing...

Ah nevermind, I see it mirrors the io_uring_cqe itself. Disregard.

-- 
Jens Axboe

