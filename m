Return-Path: <io-uring+bounces-3321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C5D989912
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 03:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58CC81F2123C
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 01:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D5B163;
	Mon, 30 Sep 2024 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2N2/pkO4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17BB22301
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 01:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727661493; cv=none; b=eMtu29zO0L7GRu+QdFA04TQnGMQ+PJroDjCESWxxGh/FqYIDOFs88XUyqbe5JFM0ehx6zOUrnnrflKlyMLLCTAA0/Xe6O7U82QTVoSYfdj5BJxXItlmmvD/eMGyX2lDgsHrP+tCfGDCOyyoSu8sVchJBICj28eSupjygBUgfjes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727661493; c=relaxed/simple;
	bh=w2KFwUgJePA7vZ/vv00BGqELtnoErd+lDSVXcSEJBn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L4gjBjSfL2kg8pG/CNCiM3ptpBqZPrzL8Qq5+8XH2E3AQQAGU6Hrl6mg45hYsQG05v6vme32o1nogKw0nVnpBo9DvLiz2zi3dCBO7/ekdFhN8KIpsNOfImg2lNuwoaPkC/5KclZIkxzp0iYsWiLs1eWEx/V5BkBb7qpHFRbOuKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2N2/pkO4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20b0b2528d8so41944105ad.2
        for <io-uring@vger.kernel.org>; Sun, 29 Sep 2024 18:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727661489; x=1728266289; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LhZMubrKj24mwM8lOh1PoffYDPqPpfavh55XpysKQsg=;
        b=2N2/pkO4EurnXCk+fpweNmQevLZtrhKHgojrM7lPVMwJDDuUKGToz48He3j7YhEcoZ
         2VfkTAyi6R3p9QBEK5V0Hn0aAUnSha48NruD/trM5nQxGrSFPfajlii87XSj9Nx+kk/D
         asOtb8qoqSEWWcWrVAEhDnO7OELBOEOHG6+gIIXjok4zEcJSPYxJtP6h/F6Y6sOliVW4
         HFD+j0zzYA1a7g5olczRIrqI7UUL+skscllYeC8vmdU6bvKtPn1h9vM9sb1HgD/ePDdD
         Ule96as2B6WLXj3I1rKCMYQluuOJM1MEqBjcifF8pHoAEzpapYUz85Nfyn1fQuHPpzqc
         2amQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727661489; x=1728266289;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LhZMubrKj24mwM8lOh1PoffYDPqPpfavh55XpysKQsg=;
        b=J71mfFzCJR+7+xuAA4WShXZ+Y+pDopcsLnqqxZDmBKNp2/OdLQ6c/QaMJDalOdO2oB
         RMqg50vvpNnqVIvfmH38t09llWHgsXLRhram7vcMg5rckNHvv3jdRd5NkJtZM0M2a7Vw
         5p4heFXOd85COJLyDjl5DGGZKntjRGlZENJ66Bp+eTz5DTRHxS9dufWhitn5H/Da6GWt
         plY4cZhKIjrLZQx5EAHaTJQTbpJeYLMnpjOZ8uhZA8PK1XBn7ILr6If68itShxrJndI7
         fD0RtGomQsKll01FSJPnoh5wwin4HKAFyCq7mq4fuQVpeHL6C0Yny2xUL+SpQBFj4zUE
         5okQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzyb7pdhE4DnfIUnb48q4dkStSAoJQKKkMiFYWyzj2a5/ocbd9TGUge+sKFv7iFn5vdLqXp6VUNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWVKXlddHvB3l1yG8uHNk5IEcVVbXnQlPEiC+nNbA7I1wJJfjv
	5upBqAP7IJDyXL24885AzWG8y85eACpzjHrtW97STRE7ByRNoSppGn0tpN9COro=
X-Google-Smtp-Source: AGHT+IFqtNWV0JcbXD9xeAq0dKdNc949KYclzYOaIevcMR0yQ9FN7pfVl0dXCpVprfLIPcKFlvivtw==
X-Received: by 2002:a17:902:d50c:b0:20b:8341:d547 with SMTP id d9443c01a7336-20b8341d7fbmr37394925ad.26.1727661488745;
        Sun, 29 Sep 2024 18:58:08 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e0dd6bsm44803055ad.120.2024.09.29.18.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Sep 2024 18:58:07 -0700 (PDT)
Message-ID: <8457d4bf-e7ee-4cc8-a69c-c82212c85f5b@kernel.dk>
Date: Sun, 29 Sep 2024 19:58:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: fix a multishot termination case for recv
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <fc717e5e-7801-4718-941a-77a44513f47f@kernel.dk>
 <2ddaef0b-0def-4886-ade6-8fedd7a0965f@kernel.dk>
 <0542e045-e5ee-41d3-b44f-5b6f9657f90a@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0542e045-e5ee-41d3-b44f-5b6f9657f90a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/29/24 1:25 PM, Pavel Begunkov wrote:
> On 9/28/24 13:40, Jens Axboe wrote:
>> On 9/28/24 6:18 AM, Jens Axboe wrote:
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index f10f5a22d66a..18507658a921 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -1133,6 +1133,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>       int ret, min_ret = 0;
>>>       bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>       size_t len = sr->len;
>>> +    bool mshot_finished;
>>>         if (!(req->flags & REQ_F_POLLED) &&
>>>           (sr->flags & IORING_RECVSEND_POLL_FIRST))
>>> @@ -1187,6 +1188,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>           req_set_fail(req);
>>>       }
>>>   +    mshot_finished = ret <= 0;
>>>       if (ret > 0)
>>>           ret += sr->done_io;
>>>       else if (sr->done_io)
>>> @@ -1194,7 +1196,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>       else
>>>           io_kbuf_recycle(req, issue_flags);
>>>   -    if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
>>> +    if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
>>>           goto retry_multishot;
>>>         return ret;
>>
>> On second thought, I don't think we can get into this situation -
>> sr->done_io is only ever used for recv if we had to retry after getting
>> some data. And that only happens if MSG_WAITALL is set, which is not
>> legal for multishot and will result in -EINVAL. So don't quite see how
>> we can run into this issue. But I could be missing something...
>>
>> Comments?
> 
> I noticed the chunk months ago, it's definitely a sloppy one, but I
> deemed it not to be an actual problem after trying to exploit it at
> the moment.

Yes, might not be a bad idea to still do the tweak. Not because we can
_currently_ hit it, but because it could be possible in the future and
just get overlooked.

Thanks for confirming :-)

-- 
Jens Axboe

