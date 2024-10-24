Return-Path: <io-uring+bounces-3965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31C1C9AE904
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C5FCB21065
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126EB1AF0D0;
	Thu, 24 Oct 2024 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvnj0zgO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65F61D63C5
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729780549; cv=none; b=c+MqnYcE23ssUQPk7cL47CqP9sxOuI1wE1kUWuGdV4ZeUwwJDqtsv1nyX/Cxn9c6wgNk/l73RPAoA8gMRrl7Nup71nb9KUXMPff3ByYMZw0ARQvSHAxaTk9afU7NbFgf7JMHHJyRJtcdfXMkkNP/c2AQSU9QVRIF+p6e1LhYRZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729780549; c=relaxed/simple;
	bh=dF6E2zYL8UgbpyUTKW6uhkZ3bZT23ZPnqmiemeZa3No=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YCk3JlZn6XhcKlk9eskGRVy1EoOFAPltLB8llhdRJ0F+vuJ/73pP8VFmgDyoV/AimfFHaiUBIqlD/sNVVVGfccD8Lcz0IFmB0d03ErvpEyOYwl7Pcn2BosGlaZgvzqCc02VrrK52Af2jv9mPV7vln/fXA02SW0KYblMgoez600E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvnj0zgO; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a1b71d7ffso145733266b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729780545; x=1730385345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pupVcfOe2UZo/zB7B5pmTZValF6Nji6CrhriMeUCosw=;
        b=bvnj0zgOR2ba4oYTBSVjeMx/W0nkC1IA3M1ImFF0Wu1fj0YCMMCv3QI+GNTzkWSPUA
         s4AplBz2RVNYM4buN/jL+IlkrwxDt+lnhrW08gKV9g9Del54PCp+HRnGbUsfZNLpX6kK
         uzHH+F6cCHiwnszjiukRbWqMI/ILpJ7faTcYRbIaJz1kGBqYwFODfae+j8KJlRHmpXnm
         nQx7c1TNDrNPjli/qQZ1J1NAouq1d7cLsjtJQ6ZEKvq32v3pMw/EuyQwbJnHYdZYnMJa
         rGG8hVmKBJe2d5DwUE9yXUGyWLbWrM9OwwCY7gwM8LLzePaiQGh3nEAiwnVB8Uvm/nXr
         pzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729780545; x=1730385345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pupVcfOe2UZo/zB7B5pmTZValF6Nji6CrhriMeUCosw=;
        b=BXsStHQzp3NGxDSSJ4agpMNnlILpq5xx6ZYVnfClXA+Zdl+38vtnbF69x8/gZBDA/f
         /GilTn9jTlIcQjmrwMc5es/U5Cr7zEuPg2DSyZkb+MzZUh/Orr80Npc87N0/UDEUZB2X
         /5KUfHoIqLR0UJBFmOs5ZMMlBqBtGmFQsvZ6Niy9sMRYNqZfgY+uwBZY59f0YrrvKbhi
         XBL0R6Uala/Q9Dkqmx5gO7ZGUGUTvcdO9fEQvx07LomH2jWZmgV/fwuOzEPY68NsLNKj
         x8ayuZMQjlagxm8rMvr9r8XdLNT5luu/6GgXQviO0Ehqay6KYUS4DVjrN0+LvU5F1G3B
         qojQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqOR5JMFovULWjG8hrf6z5lT5Y/B35vDaEXa7IsHdC78JQxCOiCzh3AUW0CTFgc4GI4f8IHDOaXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiFdIUIJlNbIF+Q6UDYc/a8KU383vceKIfKp5P5ZfjY+8LkDZ8
	Td0KhNhXazZrgtMWxAOXmvMhiuSN5K6okgKf7A5VypLo7RsZWOuDoLewpw==
X-Google-Smtp-Source: AGHT+IF5XHKHnShQm2FA4AktG0UdAD3iJdGE1/55/s2voqAOgvMhQOLPcQanLHRcpS/3qksBtdqqUQ==
X-Received: by 2002:a17:907:7b82:b0:a99:f92a:7a66 with SMTP id a640c23a62f3a-a9abf8a7fbemr602500866b.30.1729780544720;
        Thu, 24 Oct 2024 07:35:44 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9101f9ffsm627358966b.0.2024.10.24.07.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:35:44 -0700 (PDT)
Message-ID: <9e6ba7d3-22ae-4149-8eab-ed92a247ac61@gmail.com>
Date: Thu, 24 Oct 2024 15:36:19 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/7] Add support for provided registered buffers
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 17:07, Jens Axboe wrote:
> Hi,
> 
> Normally a request can take a provided buffer, which means "pick a
> buffer from group X and do IO to/from it", or it can use a registered
> buffer, which means "use the buffer at index Y and do IO to/from it".
> For things like O_DIRECT and network zero copy, registered buffers can
> be used to speedup the operation, as they avoid repeated
> get_user_pages() and page referencing calls for each IO operation.
> 
> Normal (non zero copy) send supports bundles, which is a way to pick
> multiple provided buffers at once and send them. send zero copy only
> supports registered buffers, and hence can only send a single buffer

That's not true, has never been, send[msg] zc work just fine with
normal (non-registered) buffers.

> at the time.

And that's covered by the posted series for vectored registered
buffers support.

> This patchset adds support for using a mix of provided and registered
> buffers, where the provided buffers merely provide an index into which
> registered buffers to use. This enables using provided buffers for
> send zc in general, but also bundles where multiple buffers are picked.
> This is done by changing how the provided buffers are intepreted.
> Normally a provided buffer has an address, length, and buffer ID
> associated with it. The address tells the kernel where the IO should
> occur. If both fixed and provided buffers are asked for, the provided
> buffer address field is instead an encoding of the registered buffer
> index and the offset within that buffer. With that in place, using a
> combination of the two can work.

What the series doesn't say is how it works with notifications and
what is the proposed user API in regard to it, it's the main if not
the only fundamental distinctive part of the SENDZC API.


> Patches 1-4 are just cleanup and prep, patch 5 adds the basic
> definition of what a fixed provided buffer looks like, patch 6 adds
> support for kbuf to map into a bvec directly, and finally patch 7
> adds support for send zero copy to use this mechanism.
> 
> More details available in the actual patches. Tested with kperf using
> zero copy RX and TX, easily reaching 100G speeds with a single thread
> doing 4k sends and receives.
> 
> Kernel tree here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=io_uring-sendzc-provided
> 
>   include/uapi/linux/io_uring.h |   8 ++
>   io_uring/kbuf.c               | 180 +++++++++++++++++++++++++++----
>   io_uring/kbuf.h               |   9 +-
>   io_uring/net.c                | 192 ++++++++++++++++++++++------------
>   io_uring/net.h                |  10 +-
>   io_uring/opdef.c              |   1 +
>   6 files changed, 309 insertions(+), 91 deletions(-)
> 

-- 
Pavel Begunkov

