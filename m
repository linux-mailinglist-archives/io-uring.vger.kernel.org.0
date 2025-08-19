Return-Path: <io-uring+bounces-9060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B87F1B2C689
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 16:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873201BC3B87
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 14:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6881C1FE47B;
	Tue, 19 Aug 2025 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TZRU67e8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEDF1FBEB1
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612088; cv=none; b=ne2iP5T7Bj5dmCzBU0tGacpwPclWlnwCOKKsA7nfDH5T9oxO8wMHQn/Y1mEJQR3MQc3yCvW93jzZkUYE3Wah/VMVj8rhcvUlxRxj9mAHi9II6a0fGTzE7BQyuVsFjRRgFcoWv4+6w7FZan1lH/n1TgI9GWTdCmsunpReCrZK7BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612088; c=relaxed/simple;
	bh=ZvmDx+19YiW6ApEhkn8IjPBT+5vALOBGanq1lGRBsjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZFzxr2vpFwnl1QeIzrPuTmbimfakNP2OTnyFud3/ZhXyUTbR+ESvH/fpcei6GnMy4xT9m/LzrmFtHJX6VV84ClRO4QUBUAhgwDpFc31VGnzhq7cILV+zbjWJT4e1gdu/j91lZwDpV8Z7D5iYWWm6Ycwe8M7FsxQgIagPGcWp1ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TZRU67e8; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-74381efd643so1186785a34.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 07:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755612083; x=1756216883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3SVjqSbHzQHXrWcU76qQJScDBOjypj5Vmrxo4dvsB3Y=;
        b=TZRU67e8fgHhLlPvNZ1XEMGOzUJdaUyKwmzy18KOvCnEud1uxBW3bP6IJBEe+CuvBz
         pBnsE8it1xio/ZjxJ2lDC2pWO08Xqn98edGuVtGwry0cAT6ntZAHqnPBKFMebGfye5v8
         xTP76nkevB+ZkfCcZYfoJSpV/DmTAY1ul2pAKJv9zHBigKzevGlM3WUFKvb5RvoRGEqL
         bZ5CmC/uXgBH2pRrzuZd+8QEpmzuftmVbPHDFJTdB69FxY/Szj1oEIjXmkFILYnWevjG
         d677sMxgeH0Iq4vrAqHFINp6Nz1Mw/Uszfnotsilvc1UC3FGrs/JysW8WSIUM0oMdQFA
         idXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755612083; x=1756216883;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3SVjqSbHzQHXrWcU76qQJScDBOjypj5Vmrxo4dvsB3Y=;
        b=oz7C4nHOy2eseX0NhiQaz6KA7GKVRuRve3unEICjpMhaKtOH27uu9CMgviKg+l6OtY
         ZN2Aj6DKm7lvQfp4mfoRLIRdY+n/oOvmpwvUL2h7A93bKRiRH7dYVXxz7WC/obJQhKJK
         Uc60WlHoHaXn0GEiwJGLKn7/pedvW+vpkY4BVA/7pBWVnmL8hCghCFR74jajmAA2Ji52
         copsdXYVxiSuueSp6b7sVmDaktGt30BqubmP18cwEkJdISspJOc7koxSvtmtcC613Bna
         1gR1pg0qFJUMOTSzJaDHD4SrS5mB8jYKoZEMgXBuMsfcBXB+QZCl/NA4C0OuCfrvx1kr
         yqiA==
X-Gm-Message-State: AOJu0Yy4bcYdrNW58xzzVF48RZwfBph2tOhkcZE+/d0hrPGAVJvc4py1
	TQ41h8lkivYugN9jpZ24+kIuXdKhWoRpQ+6nNjvd8A0GgU+iec8ww85fhZLTsPXq8IJn8iNvUr/
	klNc8
X-Gm-Gg: ASbGncv8SToWBVmgmxDZxyeo8x/HhuhfgZP0WAlASGJBc/Plkrscl25MRrJPOIk/nrd
	aasuO/n01V4xW4PUfvJj8GsbDy6wmIX3LEpR3/JualZAma7SVNV8+GMVmgAtiVFOfml/U7I/sTY
	WueSj32FYyw3mcutYr/tfbECsGTZsdQ+ce2DkKycgy0tkI6wZ8mNoOSaJH6ZbP9UuUnRowLjr4g
	N7EJiHZLhC8NOsjBIn+Wxi4ZLxgtZshok/f2TwYIaaKGz/ytCspmP9+kev8GrUSev2DWyPiFs+l
	t9jW2/5234fJrjrdd/tvA12K6VNU67H8viEVsmDVKYq9wY7OWXCEpycslETRhgO8COZkzCCxkts
	IohpLhPLd9ANHAwZBvpM=
X-Google-Smtp-Source: AGHT+IGohBNq78XlyfYLHZaVuxQTsRaISeF9Qb365tkS7FSMVTKLqRZ2TswZhaj+ce5+XjLWREzwcA==
X-Received: by 2002:a05:6871:5226:b0:310:b49d:4f09 with SMTP id 586e51a60fabf-3110bc9bce8mr1732053fac.0.1755612081298;
        Tue, 19 Aug 2025 07:01:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b411bsm3314438173.28.2025.08.19.07.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 07:01:20 -0700 (PDT)
Message-ID: <91bc3fdf-880d-4b71-94b3-ac72ca0f3640@kernel.dk>
Date: Tue, 19 Aug 2025 08:01:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
References: <20250810025024.1659190-1-ming.lei@redhat.com>
 <393638fa-566a-4210-9f7e-79061de43bb4@kernel.dk> <aKRd05_pzVwhPfxI@fedora>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <aKRd05_pzVwhPfxI@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 5:19 AM, Ming Lei wrote:
>>> @@ -251,6 +264,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>  	}
>>>  
>>>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>> +	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
>>> +		if (ret >= 0)
>>> +			return IOU_ISSUE_SKIP_COMPLETE;
>>> +		io_kbuf_recycle(req, issue_flags);
>>> +	}
>>>  	if (ret == -EAGAIN) {
>>>  		ioucmd->flags |= IORING_URING_CMD_REISSUE;
>>>  		return ret;
>>
>> Missing recycle for -EAGAIN?
> 
> io_kbuf_recycle() is done above if `ret < 0`

Inside the multishot case. I don't see anywhere where it's forbidden to
use IOSQE_BUFFER_SELECT without having multishot set? Either that needs
to be explicit for now, or the recycling should happen generically.
Probably the former I would suspect.

-- 
Jens Axboe

