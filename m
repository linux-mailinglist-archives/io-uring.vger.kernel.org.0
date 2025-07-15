Return-Path: <io-uring+bounces-8679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8F0B055CA
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 11:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27967561FF5
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 09:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C5E2D542F;
	Tue, 15 Jul 2025 09:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAhkiQ1P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDA92D3A7D
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 09:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752570299; cv=none; b=MF8tRRjg2Q451h03bpxe8LNNiK0boBzUBH8SIWF8Xs+o50avaDU6iz5KdqWSfkURqlEnhk0p8Q86KpPlk1XnSY8dUbU+VGog98ME6l7nLmokt08gHnVkQ342Fn2uymElyAOOFuB8pcGuxbMnEi3mYHqnDXOiTgOZA+QgyQhPOfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752570299; c=relaxed/simple;
	bh=0u6wtuo5Ax0hLpCZ1uEw1YZT5pk5Poy/gDmxIy6VNrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DjiUS/HtP3tT05i+3M6YqAmSE/lpxzKKrK8akNB0DZi/ZRc5L6ZUBlC1jfMIws14ydTSMwW4ijlyv7S7wE9mVNpm61AOZ4yRx+vU2LNxKJiD0s2RhVZO7QK6zTg6ziTe50zS/KquYmOmRPlo+9z33E66GQiZ2FgtIaOQmt6ReZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fAhkiQ1P; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-60bfcada295so8072789a12.1
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 02:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752570296; x=1753175096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q8hPoCei1zjB4ZQBoq2ORv7XYY9v7i1ZLNtyWBH5kS8=;
        b=fAhkiQ1PQPWmUXphbrZohzJKPwudn8BGMlfsf+G1pJ9l7pxv3DDmrBAg+IUgtJwq83
         X9ZhRr39ZcqxlSX3+0bV3aHxrgdIGw5kg6xgba4S87cWUtCB8vmiyBm3HA+9PyHn+umI
         np3mUZD4TgJ5Nx/uso9GKPKrKNBfbJdGb3i8JNPtLbxo+szDBs1zhJ+IC8mf4Em6Aat4
         h6A0/pz8SgtJV+7LrxH4bEQlthPSqA0GpwwfFOswA0MlFEAudKAEV3AkTVNQfAUYJBsS
         uCKHLUgbK6Zv2SsLFFmFXrViHdAneF9dpr4ip/IBPA3byAmyP0PhQrCMoFyjodoNkHw1
         5/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752570296; x=1753175096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8hPoCei1zjB4ZQBoq2ORv7XYY9v7i1ZLNtyWBH5kS8=;
        b=PRAu+rIRRCisYNFBGFvgyddNE7Z4gHDk6EVnd/dVsALGdsRrDliYd9UjPwKEkFPBuA
         UpPt0uA+d8L1kqDOAuumPmomWaIzgW6a9GSWPJn+sDS9r16x5Z18P7nQgye6YxHlepPX
         SdoJE5eRkePE7lHTugbDXAK8xs49D0EwyHcP7vqc8wK3R3I1oio4H2BMnwCXUZL7t0Qk
         X3fnvu8PjdDPJ7pei+65QWzd9eGrAQo/w/BD6Yj8m9sflmoXl54MQAcIg1/xK3F13LEn
         42LNEvOaRnN0jadnQlCELK4NrrNFTyrHhGSAteEuViyNWHvYhIqvwo3VafZfW4D6kDGq
         darQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY61DAWcIOhpCbENyJKZye7FWBPEkhvCeeOiGO2hzh7XZy+Nl8KL5uBlZi1d8XmKzvUrPFhsMGgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWqSw+TG2Vj7hXYKwbEpEpIFedEaFl1tAvwXeaxd70zvPsrApv
	e1A+cpvVYxOOkAtcqmFLZTBpBGQ4sFz4vzEY5uPnKpPXhXsbl58P3FrsYgWn6g==
X-Gm-Gg: ASbGncus68+wL+jG+CaR/xX738lIk93RSsUpRMVAiM76mL4S+zb2Lak6TQJqoyVgMaE
	6WDFLTxjnUcLylj2my60q2BX6U/FR1LLd3UxNvSY0V4msBCsIwel2Fl1VO64oKYoSJOIKNzG08a
	JEI4SaEKjVEToj5hKKs6QaqAGUgg7aRRnsW4GRtTHEym0G43QWgfmI4JGLEQf0KsBKzK2hl1Lj2
	6gcAI2EXDoR/6zs/b7S8zPDZCQyhGAQtorD+Akh131kfsSakV0XKD8/+nqX6VJDeueRz/UogFvN
	JZdOPk/P7t3iNbn9pj894XJ6lh7mU5cG81vSiJd0cSg0ZQjq1Ay4aeHq4qhxq5km06F4vOMgAin
	+5LIjphpgUicqTZkAcujfrJftW97ARgqGFVA=
X-Google-Smtp-Source: AGHT+IGrmJC2D1bVWbaRTNbAkyJyUGWPPb3jlOZhyV9N7NOw5Qj2cATqcpXVpPUDONaqYheN97UsJA==
X-Received: by 2002:a17:907:3f14:b0:ae3:90cc:37b3 with SMTP id a640c23a62f3a-ae6fca51aaemr1680732166b.17.1752570295640;
        Tue, 15 Jul 2025 02:04:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:a4c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7c09dfdsm960544466b.0.2025.07.15.02.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 02:04:54 -0700 (PDT)
Message-ID: <bf0de1c6-64e6-4a4a-b741-3fab0576339f@gmail.com>
Date: Tue, 15 Jul 2025 10:06:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
 <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
 <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
 <7432e60c-c34d-4929-b665-432b6d410b5b@kernel.dk>
 <3b7eb60d-9555-4fa4-a9b8-5605abd3988b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3b7eb60d-9555-4fa4-a9b8-5605abd3988b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/25 21:45, Jens Axboe wrote:
> On 7/14/25 11:51 AM, Jens Axboe wrote:
>> On 7/14/25 9:30 AM, Pavel Begunkov wrote:
>>> On 7/14/25 15:56, Jens Axboe wrote:
>>>> On 7/14/25 4:59 AM, Pavel Begunkov wrote:
>>>>> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>>> is a little dirty hack that
>>>>> 1) wrongfully assumes that POLLERR equals to a failed request, which
>>>>> breaks all POLLERR users, e.g. all error queue recv interfaces.
>>>>> 2) deviates the connection request behaviour from connect(2), and
>>>>> 3) racy and solved at a wrong level.
>>>>>
>>>>> Nothing can be done with 2) now, and 3) is beyond the scope of the
>>>>> patch. At least solve 1) by moving the hack out of generic poll handling
>>>>> into io_connect().
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>    io_uring/net.c  | 4 +++-
>>>>>    io_uring/poll.c | 2 --
>>>>>    2 files changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>> index 43a43522f406..e2213e4d9420 100644
>>>>> --- a/io_uring/net.c
>>>>> +++ b/io_uring/net.c
>>>>> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>      int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>>>>    {
>>>>> +    struct poll_table_struct pt = { ._key = EPOLLERR };
>>>>>        struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>>>>>        struct io_async_msghdr *io = req->async_data;
>>>>>        unsigned file_flags;
>>>>>        int ret;
>>>>>        bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>>>    -    if (unlikely(req->flags & REQ_F_FAIL)) {
>>>>> +    ret = vfs_poll(req->file, &pt) & req->apoll_events;
>>>>> +    if (ret & EPOLLERR) {
>>>>>            ret = -ECONNRESET;
>>>>>            goto out;
>>>>
>>>> Is this req->apoll_events masking necessary or useful?
>>>
>>> good point, shouldn't be here
>>
>> Do you want to send a v2?
> 
> Actually I think it can be improved/fixed further. If POLLIN is set, we

How is it related to POLLIN?

> should let it go through. And there should not be a need to call
> vfs_poll() unless ->in_progress is already set. Something ala:

In any case, v1 doesn't seem to work, so needs to be done differently.

-- 
Pavel Begunkov


