Return-Path: <io-uring+bounces-3415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1F89903B2
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A32C1C21360
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 13:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A366715CD58;
	Fri,  4 Oct 2024 13:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbIukUkH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACEA156872;
	Fri,  4 Oct 2024 13:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728047866; cv=none; b=mI0VvBN1GpRBUjFQb+0hzD3fsRTpC7++wxe7XmGfqIP3m7itJ3u4SKRSzvUCtI6cVvRUGj/Ur2AuC/uTvNVublIQdXt9+cNj8PzUAARHopBRyBDeIfTX84sPzhx6T26dDjDu1+t0iXBwleKP5syuWTozdmQbEoT3dWncWhpBYLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728047866; c=relaxed/simple;
	bh=WHKnN32Pe2DhvGdAFMSHxyfMwJ8co7XmMknpVTg1sHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnlcG7oAMhc814NI/7XQQY05bqUIRgToRFelGqv6JY+4sLDb/FU0UQvi4xO5mecpwp9/8AWqTgVU09WQY5emv3GieutFMT44dl/jSVgFDJ0mJSgmILuBpQhBf8NUpsQaIY7ErCUachsslaFJDKU0Jh47eHyiFUtJQ2CskBcme3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LbIukUkH; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42cbbb1727eso21475945e9.2;
        Fri, 04 Oct 2024 06:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728047863; x=1728652663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EP7ewQG/vBLMLg2WRG9XuTdzd48wbPPN6UpOMrmi6UY=;
        b=LbIukUkHhmWZApevyxUSsS/jIzlvl2lP11QyomIXP/M2NpI9ftZM6/lwEP5iSHwhgd
         bSYPoULCuo12Iad+/JQDZUCVB6rCCOPsLyEmZQkZSwxUobmUf7dYGnfBo/f+qabBiF6F
         1tOmK0qWgXYvf2kneC2f8wugTlEP30CEt4AbPRGg6FdQxs84B85tClIODPMYxJ/MVNt7
         60SresroerpvD9kLb0djEbZYu9EzC7aygld/ZHwl0UfJOsWvrq8gd4SQ7EYhhn58y+by
         BmINYeUtimGHUS+454iypRzJ1FXa6HfJzpKJbj3miUK5eQbjkCejWDtYca1w8aQMXMkw
         KFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728047863; x=1728652663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EP7ewQG/vBLMLg2WRG9XuTdzd48wbPPN6UpOMrmi6UY=;
        b=TqKe/wzfYzIobWasUzAuzs4BZeUrHRzakSYFAPU2AARKluoWZRQUSyaiRaqfAb0s5R
         NInVFZY9SaMRNCfAwIzFKtJLIajR3puksSo7BlaJDWVvX190RsmV7dj6zgo2dnUQV9th
         A7a51beJVhvHBDFiQ4xG6vPG6popHUmH0Gdm7iwI6lWj3NYgAe7T3qnAWf+PFE1V3O+K
         sGtpd8V99LmhuTFABv6D9ynginU+UoL7JeLsjl973gGPdl8+8FhiBv7UJbUMY5L5SAG9
         YEQLfDvuzhYAShZYJrtkufrQNSLcxaiOckYgb65ixalOzEUeEARpa6S8BATmHLgZwyUw
         /S+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZq8TgEaUQrxSBvCOvllzuiVVlluKHv6ajs0uCMV6Xu+iIsl2PD1pmMeio974j0+hnUjW06u0Bnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCJiINUsRz1Ku2JGuREk6Lhus4/yTp9qSFkKCCVnqvhn68l3wP
	yH8KTq+Ah9XPeFiEGCUXRLxIPWvk10BX4+67cD0T43goVza+O3mn
X-Google-Smtp-Source: AGHT+IHLdjD1chhBEqT7Z6CJzV8NqCWrmBn1AalwxRxhrAQlFVuQUNB2Gs1NBQgdj9XlTBqrOaE/oQ==
X-Received: by 2002:a05:600c:198c:b0:42c:bdb0:c61e with SMTP id 5b1f17b1804b1-42f85aae2damr21212005e9.13.1728047862855;
        Fri, 04 Oct 2024 06:17:42 -0700 (PDT)
Received: from [192.168.42.155] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b1d826sm15474155e9.26.2024.10.04.06.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 06:17:42 -0700 (PDT)
Message-ID: <36b88a5a-1209-4db3-8514-0f1e1828f7e1@gmail.com>
Date: Fri, 4 Oct 2024 14:18:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 5/8] io_uring: support sqe group with members depending
 on leader
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-6-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240912104933.1875409-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 11:49, Ming Lei wrote:
> IOSQE_SQE_GROUP just starts to queue members after the leader is completed,
> which way is just for simplifying implementation, and this behavior is never
> part of UAPI, and it may be relaxed and members can be queued concurrently
> with leader in future.
> 
> However, some resource can't cross OPs, such as kernel buffer, otherwise
> the buffer may be leaked easily in case that any OP failure or application
> panic.
> 
> Add flag REQ_F_SQE_GROUP_DEP for allowing members to depend on group leader
> explicitly, so that group members won't be queued until the leader request is
> completed, the kernel resource lifetime can be aligned with group leader

That's the current and only behaviour, we don't need an extra flag
for that. We can add it back later when anything changes.

> or group, one typical use case is to support zero copy for device internal
> buffer.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/io_uring_types.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 11c6726abbb9..793d5a26d9b8 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -472,6 +472,7 @@ enum {
>   	REQ_F_BL_NO_RECYCLE_BIT,
>   	REQ_F_BUFFERS_COMMIT_BIT,
>   	REQ_F_SQE_GROUP_LEADER_BIT,
> +	REQ_F_SQE_GROUP_DEP_BIT,
>   
>   	/* not a real bit, just to check we're not overflowing the space */
>   	__REQ_F_LAST_BIT,
> @@ -554,6 +555,8 @@ enum {
>   	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
>   	/* sqe group lead */
>   	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
> +	/* sqe group with members depending on leader */
> +	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
>   };
>   
>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);

-- 
Pavel Begunkov

