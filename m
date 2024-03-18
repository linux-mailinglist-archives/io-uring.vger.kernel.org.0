Return-Path: <io-uring+bounces-1078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DCA87E1E2
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 02:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D47BB23537
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B0A1E862;
	Mon, 18 Mar 2024 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HizMpIAc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA261E864
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710726283; cv=none; b=StTYvpeUIP5jpS1Jk48UUzZDvzA85ufx8jCqU7tVq6wttnpm/9HOG4dUd0lijYz5MvTTsvvD2BM4W/e5tzjgyIQJqvxP9GaESnU6b1SUo8z07CGjBCKcFFuUVaM/w/Kash2LZfj+p9Txj/cBRc2w9HJJ3czGWgv3wYol9IT0yjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710726283; c=relaxed/simple;
	bh=rtA8ZUTIJYaC6R1zalhcSpBER873U0eff7rcVHja1go=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eMKX8fxsydWinr4Vy9mIrD6NRegCn6rJXpVGYiFgy8lq1ul0Ok0LLh9zM1WIGcZluoP9bz3OGtxczfl5pFmtFU8nxStY+JgSQqDk+u+NkZTAcfIYh9O4BVocYp1t7YdiKRfpFBs+6is0CYONin1zSybOhPgE7dv3fZKa7TtvbqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HizMpIAc; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5cfcf509fbdso468589a12.1
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 18:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710726280; x=1711331080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=erQIF4gtsdJ33BKlPp1h5bCJ8dKeX6YK7T5I6H13fWo=;
        b=HizMpIAcX8AZ1BmZ8K4mhVaWM8gKM/Md1cu5m5WgVQnleDgDwcNx1jhWzmmZkCoQPO
         4vlVQacFQsbtSSlgLrV22nC29UlRypE9bNAv1uY/4hNdDIpbMrlq1N0x3LPui3IJL2Kc
         0pK9E3TRwg0VZn0Fa0hCubbc+WE7PSJCNemC1sExHlDKF4RkXU1ZKiriBteLlGNk+uWs
         mHYK1PvBSjMeqboIxxGt3dBCYct2kuRAJqoPmxtYHPRrC92jiEJfqhUD/xOry1hDgIqQ
         Jzdr7JQH9AZArvgWZZFJX9wqDg/hjL4xuYm31tGDJXbaP/KAj3iGnr7XWcyfcz2dst8O
         ewkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710726280; x=1711331080;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=erQIF4gtsdJ33BKlPp1h5bCJ8dKeX6YK7T5I6H13fWo=;
        b=pIBzZchE8BTaNV2apBsb+tFttW/4ibUCQV2lvoaE8B9M7CHQPvIL88wk4WPTpV7WXa
         QIZSyxf4rBvXsg0uHLIQA5nTRNL+MuIoHXAGo/8P2K/11yITXNjXa4+WyT4RYbT5ZChG
         4ncRu8KnWaukD4O700N19wlnWrGMwF0Kn8naF7em1wdr6d8acNswaKOmAn9HYJzJUIp3
         mckUjrE17TFl7JK77MMSWQX7LVTCx8eDTnyJyIAqjTGkZ5ZtL0CB5CN362+0o/3VdhSo
         B9VkvzKoeXGrBLnc0D8orxPSDgDN3ec48CuayG0SyEx/9be7QHUwTwv6zeEYAs5C689p
         nvzg==
X-Forwarded-Encrypted: i=1; AJvYcCX6iLn0nqHua8ZN/FpU+wdubpoAxLiqlZajcOXgzs18u0C0CJTYtqT0Rkp8/zbxISLGwVre00FV7YS5K8K1ODkBIF/uJ53WHHg=
X-Gm-Message-State: AOJu0YxEc6dK45E+pLasj7QnGhgw/G9E4ldozvD7ylOtOJL3y8UUaurn
	w2u8N78Dz+w6PFWAq/QgCe6gTEvgDJ9bsCDlBphMctBd6F3S63g4omQWwqpz/P4=
X-Google-Smtp-Source: AGHT+IGYtF/52nUBWbGRvZ/0/ZqpOO3sJ8L6+HBbH55XFAGEH8QGl6Ea3MxrgapKqWQj1qwB1Uo4Gg==
X-Received: by 2002:a17:902:d4d0:b0:1de:e8ce:9d7a with SMTP id o16-20020a170902d4d000b001dee8ce9d7amr11208296plg.5.1710726280019;
        Sun, 17 Mar 2024 18:44:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id o19-20020a170902e29300b001dd8d298693sm7921870plc.23.2024.03.17.18.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 18:44:39 -0700 (PDT)
Message-ID: <6d0d7b97-e0cc-473b-b9ca-5cf5f2c52973@kernel.dk>
Date: Sun, 17 Mar 2024 19:44:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <ZfWk9Pp0zJ1i1JAE@fedora>
 <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
 <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
 <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
 <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
 <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
 <2091c056-d5ed-44e3-a163-b95680cece27@gmail.com>
 <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
 <4c47f80f-df74-4b27-b1e7-ce30d5c959f9@kernel.dk>
 <4320d059-0308-42c3-b01f-18107885ffbd@kernel.dk> <ZfeHmNtoTo9nvTaV@fedora>
 <1e05aee5-4166-4e5d-9b76-94e1d833ab17@kernel.dk>
In-Reply-To: <1e05aee5-4166-4e5d-9b76-94e1d833ab17@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 7:34 PM, Jens Axboe wrote:
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index a2cb8da3cc33..f1d3c5e065e9 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3242,6 +3242,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>>  	ret |= io_kill_timeouts(ctx, task, cancel_all);
>>>  	if (task)
>>>  		ret |= io_run_task_work() > 0;
>>> +	else if (ret)
>>> +		flush_delayed_work(&ctx->fallback_work);
>>>  	return ret;
>>>  }
>>
>> Still can trigger the warning with above patch:
>>
>> [  446.275975] ------------[ cut here ]------------
>> [  446.276340] WARNING: CPU: 8 PID: 731 at kernel/fork.c:969 __put_task_struct+0x10c/0x180
> 
> And this is running that test case you referenced? I'll take a look, as
> it seems related to the poll kill rather than the other patchset.

I can reproduce with that test too, and it triggers with v2 of the
patchset on top of io_uring-6.9, with and without that poll patch. Which
makes sense, as I doubt you're doing any poll or timeouts in there.

Pavel, passing that one to you then :)

-- 
Jens Axboe


