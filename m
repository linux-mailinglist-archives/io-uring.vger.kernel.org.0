Return-Path: <io-uring+bounces-1426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D4589AAF7
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 14:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C82B0B21BA6
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 12:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1452E83C;
	Sat,  6 Apr 2024 12:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VjutCexH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB49364A0
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 12:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712408242; cv=none; b=aAvoITfFJQyjOwWfDdWVF/YiqNVA/wlmU37hzYNw8Q/yX1HYyT2XRnWE7XNRTswy3aBfO4kb3BPxmSiisTbo5q44PQFrNq+iz3j3eHZGFq8wQYgNn8ASxVV/koMjruKuW3GfEQwQ4LBQ1ywk1sYRvmfAu00S+QmF73xounFs2ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712408242; c=relaxed/simple;
	bh=Kv4q7f/X4AQLJAhG0RPMQbSIJm8Yb9+EzmA98ZucV78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kVP4YTlrdpUTtEmo7W8UI6QvOaQxNVoGuqQ9i7CEBD8TKpl+NTIes93JwUgCRKGo/xpxChW3pbrc8xHUM6YRr/35ZU9CK6KcvSPOuuKu62oAsQ4a/YKJ8mr+NyUrvmW6lNAWFDBKwWI3eQeZD64p9PsfQztsd4F4gERnsbBRsL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VjutCexH; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2a2fbbd6cd6so574688a91.1
        for <io-uring@vger.kernel.org>; Sat, 06 Apr 2024 05:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712408239; x=1713013039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=537qvItoY3UGYqOS3jCUDS+kO++g3qfbuMvkGGvCbBM=;
        b=VjutCexHTVZp8VOeJ0dH3JmQ6VCoLmNSXyJXAAZEVCI8xfh1uTXFLi7t5t3WqTv8tB
         ZRThFAAZbyocC3SWqoZ/3LnK2N5jy7Kr1823Ow6A+HbCl2J8uQ4TMQtQsZwPdftqXZBc
         txhDntE+a1BVwKxU1HHQ4JMbfAMxWRVrfz3drMYl7MU1j4BYTajOdp5Tpd4mNNfA3dp3
         Aguda6BwR3/DhC+SUhnkPTuvqNS36T95AczoA3O8dUAcQO7h0K8lRwT5y1KgU1fpYH1Y
         +E2GLOLgSHcVdmqBVgy+zTDf630K6Z2lz1+C3ymFb0Sbs8q3vYgQ6ZBUxPE5ULroqzOZ
         0aAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712408239; x=1713013039;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=537qvItoY3UGYqOS3jCUDS+kO++g3qfbuMvkGGvCbBM=;
        b=HC2XtzdKTqsMWoZ+W5jx3uHVYdP599pXoFgCUQfh5EZ2eddMF/UTigU3pzGyuORoHY
         8vFKNw324+L57TQSLeZeoXRN+3ZNSvGm6yVkvoCGGFUxKTcu6BZ2GvyG0Lsm/F1bhNxE
         elNe/9lRqNNzpiHojLXEv9j6vK+Zm1e3gxjvNh+AYF1oA4DA/Ok43iuc3dU6+8AEpAIp
         FcZbY7ou3JNBZ6JxA1Kh8klxvgQ0QvVUcRCN57zuURt8NDczWBnrQ+XDuePFQcXz0mYt
         0MYX9AWFcAryW5Dof5jb7+Uoo6/p9jy3dKVrrDIarxOgHHylkzUDlUfR866Dr+vAHvti
         Rp/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUIMAqNP+LgMGX08rrwjTkCwAt8VrrEHzVvsgNZiVqcZBLafQgj93/av1LY0UVKVkpAlioG79QTYrIQ5p9iPtcC44dbruHe5qc=
X-Gm-Message-State: AOJu0YzgmTYx5bzyg2f/UOYBM0qtK6Pwcgzsf4Kvf+me0fUiQKdyCpcU
	lBcoMZSj1O1RPMwP2NJtTXXkJcAX05BrpHGR8q6oJAlrCrLVT0VCU9xelDdlwtY=
X-Google-Smtp-Source: AGHT+IEqT7Tkjacniw0+XTRNTqhcnsdo8xhVwZArYWkR+Sgi1CgfWmt2tN85SfC5H58AlGu2EV9RBA==
X-Received: by 2002:a05:6a20:7f96:b0:1a3:c621:da8d with SMTP id d22-20020a056a207f9600b001a3c621da8dmr5040588pzj.1.1712408239480;
        Sat, 06 Apr 2024 05:57:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 63-20020a630242000000b005eb4d24e809sm3158037pgc.34.2024.04.06.05.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Apr 2024 05:57:18 -0700 (PDT)
Message-ID: <b46a5c6f-4bdf-4fbf-bd85-183692ed6453@kernel.dk>
Date: Sat, 6 Apr 2024 06:57:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Fix io_cqring_wait() not restoring sigmask on
 get_timespec64() failure
Content-Language: en-US
To: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240405125551.237142-1-izbyshev@ispras.ru>
 <b2e8a3e7-a181-42cd-8963-e407a0aa46c6@kernel.dk>
 <cefb820ec1805169d18b3109c47408f5@ispras.ru>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cefb820ec1805169d18b3109c47408f5@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/6/24 5:12 AM, Alexey Izbyshev wrote:
> On 2024-04-06 05:06, Jens Axboe wrote:
>> On 4/5/24 6:55 AM, Alexey Izbyshev wrote:
>>> This bug was introduced in commit 950e79dd7313 ("io_uring: minor
>>> io_cqring_wait() optimization"), which was made in preparation for
>>> adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
>>> got reverted in cb3182167325 ("Revert "io_uring: Add support for
>>> napi_busy_poll""), so simply undo the former as well.
>>
>> Thanks - ironically I had to hand apply this one, as some of the
>> commits you mention above are not in the base you used for the
>> patch...
> 
> I used v6.8 as the base, and all three commits mentioned above are
> there. However, the patch indeed doesn't apply to the current tip
> because of post-v6.8 changes, sorry for that!

Not a problem, but it does highlight that this will certainly throw a
reject once stable tries to pick it up. Just something to keep an eye
on.

-- 
Jens Axboe


