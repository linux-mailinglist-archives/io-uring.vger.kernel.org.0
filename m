Return-Path: <io-uring+bounces-2730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0649C94F92C
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 23:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38E341C222EA
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 21:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC065195B18;
	Mon, 12 Aug 2024 21:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GV++TVge"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A02195808
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 21:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499509; cv=none; b=ma0grwfJDzLoWlJcaNyApmf3DWXdSUD0wlDyV5eR5bIFENBpYz6cR7WXiZvsgXp8Ju6eKG1E2SUa+m/pJHByg38pdTi0SJPJ2VEHngB+kZDbKi9TqY94nYVryIMXc4a6PrvamqbblGzD+laddl7OPROpMb4F/o8+kteaPJaSE+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499509; c=relaxed/simple;
	bh=TdhNOHOfth6uVL1kEg2gnpH35tuHlTbwxFdH6W4vrck=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TYhffVxoqRq9iaGvIJRg9HgMuFJboiMdpN08FMr9HRaPFJDyPopDqVhVJdjpMRrGgzW0Yy7U6SPZuZVIvpHmfxaMYha7sd3gsdfOcSb3F2+6+RVWv0Rdk427Jzmq/paXyIgWegXTHDV9gaVrymmKK0I1PkY4+yC+p+pzXz5tfaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GV++TVge; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-81f8d55c087so14633339f.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 14:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723499506; x=1724104306; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JiFFUiWpi+hh7PlsaYo7T7n0xUaKOQj+E8xvlR/wsmM=;
        b=GV++TVgerRhNwIFKIgYXg8+Oh4XCZ5kCQpFVjn8Gd/Z09TaHtrO8OF5CdIND1hJjDW
         F07o3jdf3cnnb8QDqJe6e9V3d9ub0IFUmbBWRbszBe9dSLNnmZYfRwg8JLXfda9cBB8u
         1tiVB2Y+4LJJnSceaGtQHqZdAAosgzg3W1pqmzjC6ugoYYDS+AsyyDEGUx0G6QLOJc/I
         6b9I/gdwR/4YBqXMOfJ6I1bPHlRrDXLI9oLJVZd3bt9SXUlChmbEctw1BMj2xMQr2lSY
         gU92BPsUPyubsp8tznDNT/zsV0flzNKeY+O3IVEx4eH7jlY5DbOG2UVIF1dkFGxZWfd+
         cUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723499506; x=1724104306;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JiFFUiWpi+hh7PlsaYo7T7n0xUaKOQj+E8xvlR/wsmM=;
        b=uCvlDLIQ5ztQAznaqrGNHOc3csX4r5cu9/Uq5R93Y5ZKxzqHrQ1rC+yw5G+hlYrqCw
         DjWccrCI85BLroeraqtAnIQ5OFtitZZC7O18FmaP9qERXzJxPo/HP5oRlgzM9ULO8rY6
         dLAjaj0oMYEV3CYyMAjmMtcubSIbBmM+EAahN8HSipbxBCtofaq6upFMpMgDjxrEKx19
         nDLTGusg0N5PXGS30Y7kypNZK1CnGKxZykVeg17w9HSa5HWyr4IBwS/id8UO0yfmF4/l
         FsdRFGn8KRaBJGV13kFCDwCE9h5j+lVzqp7DHS51n8DKExk3CEzbkFQKJNViDCVNH0Hl
         qQQw==
X-Forwarded-Encrypted: i=1; AJvYcCWGkU277TvujJ+NW9n8icuHSFgYSXG1qOz9Uomph9vJIUTg674qSL3sWF13IkQdtuT8ithbMYDE6D/kYQXcjKVTm1wGHo0L6Uk=
X-Gm-Message-State: AOJu0YxbM3yp6yJtBk9AV0HFMfMv4/AsKKZvPDnr7ObBkZWAFWAUatZQ
	yNX5YvrOF6dSOWlopIyn7JAs4Ta7pKZYxIWYyUZhNjAI9mntDitZP+1yL89sDgQ=
X-Google-Smtp-Source: AGHT+IEujbuNO2dDKruiVAVbO3+GDLdMsLeJme1xR2hwyAAkk2ywUHAPu+Y5bQhXCmv01yiEZANjcA==
X-Received: by 2002:a05:6e02:1fcf:b0:39a:eac8:9be8 with SMTP id e9e14a558f8ab-39c4a627705mr3553665ab.1.1723499506236;
        Mon, 12 Aug 2024 14:51:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e587b832sm4481848b3a.32.2024.08.12.14.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 14:51:45 -0700 (PDT)
Message-ID: <b3f138e2-1502-4414-916f-a3844bda1489@kernel.dk>
Date: Mon, 12 Aug 2024 15:51:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: do the sqpoll napi busy poll outside the
 submission block
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <44a520930ff8ad2445fc6b5adddb71e464df0e65.1722727456.git.olivier@trillion01.com>
 <402e9573-2616-4cd9-8566-e7d99fe1ab53@kernel.dk>
 <c1a333db6bce30ac770a590f80f3d26e945c5065.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c1a333db6bce30ac770a590f80f3d26e945c5065.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 3:50 PM, Olivier Langlois wrote:
> On Mon, 2024-08-12 at 14:31 -0600, Jens Axboe wrote:
>> On 7/30/24 3:10 PM, Olivier Langlois wrote:
>>> diff --git a/io_uring/napi.h b/io_uring/napi.h
>>> index 88f1c21d5548..5506c6af1ff5 100644
>>> --- a/io_uring/napi.h
>>> +++ b/io_uring/napi.h
>>> @@ -101,4 +101,13 @@ static inline int
>>> io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>>>  }
>>>  #endif /* CONFIG_NET_RX_BUSY_POLL */
>>>  
>>> +static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
>>> +{
>>> +	int ret = 0;
>>> +
>>> +	if (io_napi(ctx))
>>> +		ret = io_napi_sqpoll_busy_poll(ctx);
>>> +	return ret;
>>> +}
>>> +
>>
>> static inline int io_do_sqpoll_napi(struct io_ring_ctx *ctx)
>> {
>> 	if (io_napi(ctx))
>> 		return io_napi_sqpoll_busy_poll(ctx);
>> 	return 0;
>> }
>>
>> is a less convoluted way of doing the same.
> 
> I agree. but if I am to produce a 3rd version. How about even not
> returning anything at all since the caller ignores the return value?
> 
> I was hesitating about doing this but I did figure that a reviewer
> would point it out if it was the right thing to do...

Oh yeah, just kill the return value - in fact, just kill the whole
helper then, it's pointless at that point. Just have the caller check
for io_napi() and call io_napi_sqpoll_busy_poll(), it's only that one
spot anyway.

-- 
Jens Axboe


