Return-Path: <io-uring+bounces-567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C37684C327
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 04:34:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B13621F287FD
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 03:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A446C12E47;
	Wed,  7 Feb 2024 03:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4yUMsDV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7F112B95
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 03:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707276866; cv=none; b=g97JJ2764q5Olj8oInv4lTBgLFMs1O8/z/wAd4yU/j4yJgHOn3lfcJE5WoAQEY81wpc82XpGlXjsfFyf/70jPlto4ee+Z/zMRjdTxqClllW74bBx6UKYMfDPyEhZTcXHj90bmpnRwGiYv5a9OYe5VK0WVOLv08KXDlG8Ff9OCok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707276866; c=relaxed/simple;
	bh=HDlILBoxDDs23E2exrZYBTitTjxUSh0TBFN2G+wz6mE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IGcwcpDBL2S/VC+o5l9LmQzAOrDJiOAD7++ChnhwiW1XTjStD+JRxsupB//vzLccXoCpzMqhuO8p1uLRpj8oCiSrMdpHScau1IRxCkK6WE7rhLpL1mYhILTvoud64Hzti3WaDgPE3UC7wpaGgmsBCu35DW/WNBDxpAAsRkRwRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4yUMsDV; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6818aa07d81so1319386d6.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 19:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707276864; x=1707881664; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7kesFfbc6WRTzRs+LJZVj+C4yP6FqqWTYyaOfRw3xwo=;
        b=b4yUMsDVDo5jBRvrojw7pbrLojHx5XcczvP9iOkOOhMF2v0gNywTDTMZKDJWu0lrDr
         E6yq4hf0b6t7nqTpk9njDZzQjeUoLokTDc2j+Um6iRGsvi8xPy0uncceoo//8cXkfXZ1
         sWVLLt8gJsSz5Oq80uhO2WvzHY621JBsNdEsVobjCWlYCl9bBgxTftpDZt2JUAMVjwZ8
         rEuMQFQEYcy7v1I0WPBAMxb/IDUbe5gzpwzVe2qQ+IY1RYRx7n6zWzTfTgA+KbQo8r3+
         NBVPQcG5+MeXBlDlYaBnzh1jDdf5nuwpNmoMi1CZQAMD5vt1kVFmwA4/L6ISiuBpO4ir
         4JuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707276864; x=1707881664;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kesFfbc6WRTzRs+LJZVj+C4yP6FqqWTYyaOfRw3xwo=;
        b=Vw5tmwnvMOqVqoHY1w9ComiYMwCkypWZzsAm+/ewQi8wUH4IcxZSDQNETvMUW61upH
         h7RCHRkYG1J+MTtVUXOVzOVTyXXtLpPYCYa42RtbUUiMrk0/myE6VNbv1Pk/B9qCpt7R
         gZv1zMVt2eqtTHJKmABP6v0CowK5uMOS7sO0MYA9/QdkQb4V9sI8PVNaZvlKfaUKf6Ea
         xiBb8Wntvb2NAm8EC2a1BMaGEw8aOZSYad8J86HEGsa4Ajf3h1/5JAcl3bsskxVgL77K
         DmFwAWrvdtr2hrxTVHvXTu0+B+VArbUduk+TaRF8gpDOwCXthkoURy48rAe70edTn47m
         Id+A==
X-Forwarded-Encrypted: i=1; AJvYcCW7VivsXkkh0SRpGsoqduss62C/sbcOqdfic8+iy1TogVXQiXlJytTmBIsC0JSbU2qXK0+6vbcK8HnRB/7X6/n3Wfdgm9BrScQ=
X-Gm-Message-State: AOJu0YzW4rPlqiR2BOJO3idg/8Qy/YwncoJ5Butp4t7VOThHva1hhMGz
	PnGefEYtPqZ8Obhl93zMS95okQJDzZnCM4xg9QogfoyAZymWOvrtwdo0zuol
X-Google-Smtp-Source: AGHT+IGzoaKzDN5SRl0BAXT0syUkHe0i/THnGN7Vlx8T/JLuExpjsq0L1EZxioy8IYRRo455PMd6SA==
X-Received: by 2002:a05:6214:2a82:b0:68c:9323:91d6 with SMTP id jr2-20020a0562142a8200b0068c932391d6mr4465640qvb.65.1707276863727;
        Tue, 06 Feb 2024 19:34:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUlBSGHEyLbNYmEcLDwtgvOStBwhOT1oNIk8yUXsW/itiUValNX4RqSZZSFPAp+XVdfqm3N5fglnP2ebl3+FtF13jeXxO4JODE=
Received: from [192.168.8.100] ([85.255.236.54])
        by smtp.gmail.com with ESMTPSA id ph30-20020a0562144a5e00b0068c6dd9af10sm167186qvb.64.2024.02.06.19.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 19:34:23 -0800 (PST)
Message-ID: <aead9829-8b5c-43a8-be5a-a89e3ecf2308@gmail.com>
Date: Wed, 7 Feb 2024 03:33:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: add io_file_can_poll() helper
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-3-axboe@kernel.dk>
 <a0dce2ae-a41b-4fbb-961c-db69d8f1f17f@gmail.com>
 <b7ef8fd0-de12-4e5e-bb8c-bfa06b2ec723@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b7ef8fd0-de12-4e5e-bb8c-bfa06b2ec723@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/24 02:15, Jens Axboe wrote:
> On 2/6/24 5:57 PM, Pavel Begunkov wrote:
>> On 2/6/24 16:22, Jens Axboe wrote:
>>> This adds a flag to avoid dipping dereferencing file and then f_op
>>> to figure out if the file has a poll handler defined or not. We
>>> generally call this at least twice for networked workloads.
>>
>> Sends are not using poll every time. For recv, we touch it
>> in io_arm_poll_handler(), which is done only once, and so
>> ammortised to 0 for multishots.
> 
> Correct
> 
>> Looking at the patch, the second time we might care about is
>> in io_ring_buffer_select(), but I'd argue that it shouldn't
>> be there in the first place. It's fragile, and I don't see
>> why selected buffers would care specifically about polling
>> but not asking more generally "can it go true async"? For
>> reads you might want to also test FMODE_BUF_RASYNC.
> 
> That is indeed the second case that is hit, and I don't think we can
> easily get around that which is the reason for the hint.
> 
>> Also note that when called from recv we already know that
>> it's pollable, it might be much easier to pass it in as an
>> argument.
> 
> I did think about that, but I don't see a clean way to do it. We could
> potentially do it as an issue flag, but that seems kind of ugly to me.
> Open to suggestions!

I'd argue passing it as an argument is much much cleaner
and more robust design wise, those leaked abstractions are
always fragile and unreliable. And now there is an argument
that it's even faster because for recv you can just pass "true".
IOW, I'd prefer here potentially a slightly uglier but safer
code.

Surely it'd have been be great to move this "eject buffer"
thing out of the selection func and let the caller decide,
but I haven't stared at the code for long enough to say
anything concrete.

-- 
Pavel Begunkov

