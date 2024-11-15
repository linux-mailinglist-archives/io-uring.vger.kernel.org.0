Return-Path: <io-uring+bounces-4735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBE59CF32D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 346BF283E7F
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335261D6DA1;
	Fri, 15 Nov 2024 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vBAo++Yz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA1E1D63C3
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731692703; cv=none; b=q2aTuzWzNU+OYrdndOA9YSMO7EZQ/scuXZEsGTqjalVvmqbO9Wpjt96e8hHC+0VZECB6gzO3iV23jx9rrLw4drRt8J1viVrokNLgi/SinhwUBPLlAo05o5XgPtHkLsJukFxA4rtvJRu71Rt7b4Cf6NPHsm/YQJHPMmzZBBW6cCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731692703; c=relaxed/simple;
	bh=xqENlfIbZ6oxYGPT3ENwgUPz7q+WvgG+QMg5G0GrWJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hv+ERfXFYjiLL1VSIoZ+FtkM+xkBsirWuL9KbbLCX7B+QQjs0Z0ZJUS00skXMDjKh98xN04750XSzOztyPebRi6o3P2GaoldD/6WXpgL4ItyLQDu7JEzWSiX1LPNmad3AMgfWQThb+x1HISM0O1EnIEFZgrMotxtk9kZppSUkpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vBAo++Yz; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e60e57a322so1150464b6e.3
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 09:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731692700; x=1732297500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GX5wJ6oLxec3STDa1FVtfsmqMbzKtWScheytSQkT1U8=;
        b=vBAo++Yzi2hDov/7+u0KWx6DifVjZDKRweV1NSDXXlfOAglgIZwxXj8Rttz1OgbpNH
         Qwy58xHUTEXJurOnc4tY67CioMNZwfjT5HmY8Hw9ZZVumaUGZBeQuFS+ZP9sA6kGemql
         OJ15Mn4WEJORwJVSLTSr3vsoxRDw0p1g4tCxTya+pmQ3mqNOD9G25XXad6gcOVyTKNav
         T0sSk7AvxB3OQb9wjU0ybdXXfTKkwsdY7AD9uFx2Y8wZNwgoH1FJdr74/lBpCDOl2NLu
         Y9Q5h9pIIq6hzvGgHk992fqL4SeA+QdUUEqxwCQk/IlG2wP0TWAmwSwtdOX8hs/81Jtw
         qIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731692700; x=1732297500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GX5wJ6oLxec3STDa1FVtfsmqMbzKtWScheytSQkT1U8=;
        b=Kp/fN4zpma+8wRUq0rORASCyPiXqpCnFDlsiojMZzC41Kr7cdrZXSIC/3mi7UC9rk+
         HXx/WH0ZLOlJ8MZgQkhTFMKKs9niQyhrw5c4clpfTsd6mgzZoSir7CNcxitx3PsBiGno
         TZfJ32g1nhsJEZ8oVMsMbmhI+haFJhQTi2gyRD/J+Il6lOOgx4/ffYVY7LuLQWJEoV8K
         ahGE1H+0pO0umdILuM8qzetFdRtZg/1IeWkjwZplJH9C8xD1gaRuieN3O1a1D3Izuuo/
         z8gI80XLVkAR0hzMeaqcIgwoh22wr4ee3VtU9awcm0/vP/uNaY61FhCPsJWnrOhlHH5B
         fYTg==
X-Forwarded-Encrypted: i=1; AJvYcCXoYi9T2DuvArNJ+Ous1L8BJvzf0GFBJ2sBEexDfb06uQhpNobtMJZegzCk8GJBwLK81GHbDt5trQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyartUN7XKtmD0GZ03HR1F2TvCaP9Ce/b5UoU/ZJV2K8zxvsGoE
	79MG4I4uFxMD2SdIr6UT64mLhARsGZ899QIC8azU5hQ6hRA4XpSiwqty+P5daFg=
X-Google-Smtp-Source: AGHT+IE7u0RxmsRL3LQWgWu6xddXzAE9XDdBJ1jPG6HxqNvh9lsaMK0XyjGjnH4cynjuaCDt1FSOiA==
X-Received: by 2002:a05:6808:4401:b0:3e7:c366:d17f with SMTP id 5614622812f47-3e7c366d358mr1389370b6e.38.1731692700454;
        Fri, 15 Nov 2024 09:45:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd12fbasm661744b6e.21.2024.11.15.09.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 09:44:59 -0800 (PST)
Message-ID: <97b3061c-430d-4fc0-9b62-ab830010568e@kernel.dk>
Date: Fri, 15 Nov 2024 10:44:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de>
 <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
 <20241114151921.GA28206@lst.de>
 <f945c1fc-2206-45fe-8e83-ebe332a84cb5@gmail.com>
 <20241115171205.GA23990@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241115171205.GA23990@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/24 10:12 AM, Christoph Hellwig wrote:
> On Fri, Nov 15, 2024 at 04:40:58PM +0000, Pavel Begunkov wrote:
>>> So?  If we have a strong enough requirement for something else we
>>> can triviall add another opcode.  Maybe we should just add different
>>> opcodes for read/write with metadata so that folks don't freak out
>>> about this?
>>
>> IMHO, PI is not so special to have a special opcode for it unlike
>> some more generic read/write with meta / attributes, but that one
>> would have same questions.
> 
> Well, apparently is one the hand hand not general enough that you
> don't want to give it SQE128 space, but you also don't want to give
> it an opcode.
> 
> Maybe we just need make it uring_cmd to get out of these conflicting
> requirements.

Let's please lay off the hyperbole here, uring_cmd would be a terrible
way to do this. We're working through the flags requirements. Obviously
this is now missing 6.13, but there's no reason why it's not on track to
make 6.14 in a saner way.

-- 
Jens Axboe

