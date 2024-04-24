Return-Path: <io-uring+bounces-1621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 628E18B0D86
	for <lists+io-uring@lfdr.de>; Wed, 24 Apr 2024 17:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 865CE1C215C8
	for <lists+io-uring@lfdr.de>; Wed, 24 Apr 2024 15:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4331115E5D3;
	Wed, 24 Apr 2024 15:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ON0JH0GO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ADA15ECC1
	for <io-uring@vger.kernel.org>; Wed, 24 Apr 2024 15:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713971071; cv=none; b=rUi/wfTBJ3RTtdp8RQy7Y/K90/elp2byqS/akW9I63EmZV0tRw+3g5kgkztxIXN+8KJJVsXdfXcdJVMh/DPcqykRhrA0vhMOuKhPPEmDEGPGnTGJWgUV62maokGxLW6LA1eCtvzDwba+wysr5pjHOH3tO+JD9LPj9l57yY72Ba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713971071; c=relaxed/simple;
	bh=ugnTXnvAKYKYE9fep2hONtal25lQuDZVPAnHrXv04fU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZX4iHtd0kTT2iq+1IlDSGz+d0fMts2jI9dvDJw2UIqScD/DTCLd7IE1t5j3WjkW1dnBMNRC/msJ5g16s9h4iCF9W8eeZCqiXztf97Ornddl0TOcz6M35Uca+d5kv6og/Ydj0/tE3QrNtuBjLFVf+wlEiQfOJL8Fgs5vT+xUDGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ON0JH0GO; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5872b74c44so302241266b.3
        for <io-uring@vger.kernel.org>; Wed, 24 Apr 2024 08:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713971067; x=1714575867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B7mzvMIfKjIqrEQcZpXGmiTXa3cWZvCzM6UNN8rUW/E=;
        b=ON0JH0GOO4fT7nd7B7T/9hZQL8QMxMzWZDKcgX+sIZT5CF3+Obx0gk7WXnT5/jJLMp
         tWEueMsUILaFuP899hjHSKaM7TRiQDMRBg77OTN2t8xSlw8lVqJF9Ujwr7Gpxx8Fgi3N
         j40O8HaTEGu7JSwMoQN02yHevVJane1UHnVN7Fo/8zcjKVNkfU61zoodiNrpr37u1OcP
         SzEW7Ft1QkK+kMR8Y8+PH72eJpnf604hc2/suhvyf9pWZRZ5D2Pke19KPw8+VFbgqKR7
         S2JkXJ0EF0P8pM86rBeHXUPQb4nFyJN+Y9JCq2y6moN/UadefeZ7rViFR1VPLU3PGoqj
         TDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713971067; x=1714575867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B7mzvMIfKjIqrEQcZpXGmiTXa3cWZvCzM6UNN8rUW/E=;
        b=F4tFb/GekBo2PRk80vc4Ui59kaCleBNdQHiXqMZdXx9TwhhDmyrjbJ+ZzFQtoE4cvP
         4J7cahkwLsIEBIvqxeEJCvn7vywXiuAt8/HSjh6tYKFXYgePOardpByiwi9Cpa3IAwUn
         374WvvOuMklvu7xesCPu24tt+X0+vefDfkuMYdLoYZn3KkHMGiwAZvqVcespbOBE5kRh
         MKUCMr4Nm2hyuvv51/DpsX0Xa3h7YTDutKHs9WLthTAZVFbAMF/Gp/x1jlpytA8rh7zQ
         gk0475wN1SCCCiOy6FS71tsSmV3JcJjPJVQVQKdlA79LU/QzteCLiXIYQuCfffrBhH7b
         Bynw==
X-Gm-Message-State: AOJu0YwK8307HCApRrYgBBPxyDS/ZxwKOLXrWgR+odBUaCbgT8bn0pVA
	ap2DlrltKvajaqYoX/guTsjnh+9PBdKoVZRip49Bfx6Nn3APA98grfpR3g==
X-Google-Smtp-Source: AGHT+IFeSgw1aPl8cku6VOYHCvhcRqzGQBZaQhZJQ5uJt3ZBEtu4fp2qAEN6g39WRUcmYRNLiR65vg==
X-Received: by 2002:a17:906:4bd0:b0:a58:9707:133 with SMTP id x16-20020a1709064bd000b00a5897070133mr1047524ejv.40.1713971067085;
        Wed, 24 Apr 2024 08:04:27 -0700 (PDT)
Received: from [192.168.42.35] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id og14-20020a1709071dce00b00a55ac4c4550sm4609371ejc.211.2024.04.24.08.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 08:04:26 -0700 (PDT)
Message-ID: <53894e1d-d249-464e-ba21-5cb3106c39db@gmail.com>
Date: Wed, 24 Apr 2024 16:04:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: ensure retry isn't lost for write
To: Jens Axboe <axboe@kernel.dk>, Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org, anuj1072538@gmail.com
References: <CGME20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947@epcas5p4.samsung.com>
 <20240422133517.2588-1-anuj20.g@samsung.com>
 <be81e7b5-06b4-463e-85cf-acee80c452d4@gmail.com>
 <58d1a95d-066d-4620-950a-fdd70780afad@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <58d1a95d-066d-4620-950a-fdd70780afad@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/24 14:36, Jens Axboe wrote:
> On 4/23/24 8:00 AM, Pavel Begunkov wrote:
>> On 4/22/24 14:35, Anuj Gupta wrote:
>>> In case of write, the iov_iter gets updated before retry kicks in.
>>> Restore the iov_iter before retrying. It can be reproduced by issuing
>>> a write greater than device limit.
>>>
>>> Fixes: df604d2ad480 (io_uring/rw: ensure retry condition isn't lost)
>>>
>>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>> ---
>>>    io_uring/rw.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>> index 4fed829fe97c..9fadb29ec34f 100644
>>> --- a/io_uring/rw.c
>>> +++ b/io_uring/rw.c
>>> @@ -1035,8 +1035,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>>>        else
>>>            ret2 = -EINVAL;
>>>    -    if (req->flags & REQ_F_REISSUE)
>>> +    if (req->flags & REQ_F_REISSUE) {
>>> +        iov_iter_restore(&io->iter, &io->iter_state);
>>>            return IOU_ISSUE_SKIP_COMPLETE;
>>
>> That's races with resubmission of the request, if it can happen from
>> io-wq that'd corrupt the iter. Nor I believe that the fix that this
>> patch fixes is correct, see
>>
>> https://lore.kernel.org/linux-block/Zh505790%2FoufXqMn@fedora/T/#mb24d3dca84eb2d83878ea218cb0efaae34c9f026
>>
>> Jens, I'd suggest to revert "io_uring/rw: ensure retry condition
>> isn't lost". I don't think we can sanely reissue from the callback
>> unless there are better ownership rules over kiocb and iter, e.g.
>> never touch the iter after calling the kiocb's callback.
> 
> It is a problem, but I don't believe it's a new one. If we revert the
> existing fix, then we'll have to deal with the failure to end the IO due
> to the (now) missing same thread group check, though. Which should be

My bad, I meant reverting the patch that removed thread group checks
together with its fixes.

> doable, but would be nice to get this cleaned and cleared up once and
> for all.

It's not like I'm in love with that chunk of code, if anything the
group check was quite feeble and quite, but replacing it with sth
clean but buggy is questionable...
Do you think it was broken before? Because I don't see any simple
way to fix it without propagating reissue back to io_read/write.

-- 
Pavel Begunkov

