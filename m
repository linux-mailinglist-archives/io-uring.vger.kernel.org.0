Return-Path: <io-uring+bounces-1100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3C487E99A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 13:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 226B91C212F6
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 12:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B73B2FE0F;
	Mon, 18 Mar 2024 12:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dV19/1eF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B9E2EAE6;
	Mon, 18 Mar 2024 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710766449; cv=none; b=m/BH5B0U2laj9BHWcGbdebBhNuKsWG2rK+xf7D3fNt0h9pI+zPYUvOCzAVCbR1TL5bzU/DTXsjZDpixxAniwKJwa6I1TC6/ApfjKRXbXxJTJWK9M46uLoG4ZjsA94LMMw6ZJgeap1IyKZubhobeL5Rjy5LncfaGAkvOvDmaBCn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710766449; c=relaxed/simple;
	bh=I6CekvyfilkWrjsiTxEp+MC47fMF6SzWsBnv8kfBqa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fu3S0QDWZOf3yRsAQd61exINQEE7kFO+uD/fCQzJRuG21X/+tq6W7BbkntvKVUd4uNNkiiJFh73Y5yVcOTv3TV/fzKR7kYSHPOvlOgL1LdP4txutc4xOG2lxVIWx9eqADgck+L0P8/SdXikfFOgkLiZ22DebLL4V9Zgq28LoWAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dV19/1eF; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56b84b2c8c8so445185a12.1;
        Mon, 18 Mar 2024 05:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710766446; x=1711371246; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KOb4sV67qE3Vr/DL9bumOjnuZDP6H6RIoj2joUq6fu8=;
        b=dV19/1eFKJCNFEBGCfw4iOTblV/Wk0QFHpvRQVo7UaeK+1jJlHN2uegHCQ8wpd+kev
         6RphBFqre3W7gfHCxAnosV6YYXpbn1Wnbki4t3SOBKeWjDhhHORWKEsbEil37bMujoOj
         Chn0wfWkjUWxC+8AkZdMxyAceNm5wzWQOPNQGzYRQwvqssKcF8f1m2aSFaKjc9//u+ux
         1uOL7Dfb0hQwLXnTJ4uuJX5ss41KORgjvZ6gk5/ddMDjnwIHJnwozAWyrckpTgjpNiho
         LvMDpht20l1pr1LwlVCbMBc8uF5zaurOLxTQEcXIcxzEMBwhOORra86VHeiWwmVg5zn6
         60qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710766446; x=1711371246;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOb4sV67qE3Vr/DL9bumOjnuZDP6H6RIoj2joUq6fu8=;
        b=gRcen4ZPSmacWjU6TZHfHYEBQWTUkkHg1X4bI6/hD0SLgRdXHc0oNli9naA47lNgxP
         /ZjxQfXTFRd6SAqRQEhQAI/JaryoHl9bvVt5XSBDwN5z/RbWfkieTlonHzLQJ+dqbVK6
         2QGD/T24qysrFB8TYEgcIubb2rFEr4izWeRvHEs3fjR+K664jf9SWIcOOunBEY30r+2P
         de/PzMRys6CfIkZ+ToOwwHPUzTx/Ltt/uxTy3BeTk4RL81DgcySqsOWXJZKQS/MVoVQb
         GI3olq31PpS4Z+WQ0QY663mP2sGC4OB3oFeWS3Tjg4JO7YIT2My+VZa469hz9l1cxdmW
         46JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhb/4bBl0q8/ZHwog3HkFGWFxTG4cYPxId+QgqRCeSdc+DY5Q+0bV5nOZIaJirzt2Z3TkbMXUV70a0c72j9zc2CB6M40i73L9wnvA=
X-Gm-Message-State: AOJu0YxsMQE8d8NpKetQJiaYfRuHxnlH6iGq/9NuvsIOjVzT7WEA5ahk
	8Dj6tLjcLzrfwxRVE60sn4WNStfob6hkkYMBxj6m6cNyfFgK+KQx
X-Google-Smtp-Source: AGHT+IGfT85ukna1VOzCDw1p5yOuHdVftbZj0uBO/ZYVC5Pljrt3N7BqPBxRddnZT8OzC7hL9h5xzw==
X-Received: by 2002:a05:6402:1f4c:b0:568:b46c:c4ba with SMTP id 12-20020a0564021f4c00b00568b46cc4bamr5850373edz.30.1710766446115;
        Mon, 18 Mar 2024 05:54:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:429a])
        by smtp.gmail.com with ESMTPSA id u11-20020a056402110b00b00568d60cfbccsm1449520edv.42.2024.03.18.05.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 05:54:05 -0700 (PDT)
Message-ID: <61b29658-e6a9-449f-a850-1881af1ecbee@gmail.com>
Date: Mon, 18 Mar 2024 12:52:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/14] ublk: don't hard code IO_URING_F_UNLOCKED
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <a3928d3de14d2569efc2edd7fb654a4795ae7f86.1710720150.git.asml.silence@gmail.com>
 <Zff4ShMEcL1WKZ1Q@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zff4ShMEcL1WKZ1Q@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 08:16, Ming Lei wrote:
> On Mon, Mar 18, 2024 at 12:41:50AM +0000, Pavel Begunkov wrote:
>> uring_cmd implementations should not try to guess issue_flags, just use
>> a newly added io_uring_cmd_complete(). We're loosing an optimisation in
>> the cancellation path in ublk_uring_cmd_cancel_fn(), but the assumption
>> is that we don't care that much about it.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Link: https://lore.kernel.org/r/2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   drivers/block/ublk_drv.c | 18 ++++++++----------
>>   1 file changed, 8 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>> index bea3d5cf8a83..97dceecadab2 100644
>> --- a/drivers/block/ublk_drv.c
>> +++ b/drivers/block/ublk_drv.c
>> @@ -1417,8 +1417,7 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
>>   	return true;
>>   }
>>   
>> -static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>> -		unsigned int issue_flags)
>> +static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
>>   {
>>   	bool done;
>>   
>> @@ -1432,15 +1431,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>   	spin_unlock(&ubq->cancel_lock);
>>   
>>   	if (!done)
>> -		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
>> +		io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
>>   }
>>   
>>   /*
>>    * The ublk char device won't be closed when calling cancel fn, so both
>>    * ublk device and queue are guaranteed to be live
>>    */
>> -static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>> -		unsigned int issue_flags)
>> +static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd)
>>   {
>>   	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
>>   	struct ublk_queue *ubq = pdu->ubq;
>> @@ -1464,7 +1462,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>   
>>   	io = &ubq->ios[pdu->tag];
>>   	WARN_ON_ONCE(io->cmd != cmd);
>> -	ublk_cancel_cmd(ubq, io, issue_flags);
>> +	ublk_cancel_cmd(ubq, io);
> 
> .cancel_fn is always called with .uring_lock held, so this 'issue_flags' can't
> be removed, otherwise double task run is caused because .cancel_fn
> can be called multiple times if the request stays in ctx->cancelable_uring_cmd.

I see, that's exactly why I was asking whether it can be deferred
to tw. Let me see if I can get by without that patch, but honestly
it's a horrible abuse of the ring state. Any ideas how that can be
cleaned up?

-- 
Pavel Begunkov

