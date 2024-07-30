Return-Path: <io-uring+bounces-2598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7587094103D
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 13:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 310322821BB
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 11:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD53A18FDD7;
	Tue, 30 Jul 2024 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrElaXxN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE818EFE0
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 11:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722337692; cv=none; b=CIw2IazVjkNT9f4RlWlsN1asuM1H+mQF4Sv7PylV/rje24qxZVIG7HSVuWmnYBnusW98q/OgAteldFqAcGRW9RNCfuDMdjqnkJEKjfFm/QRyht9Cc/LhtxxlyRWOhIGA/x6qOQThEnzHZPSjokBAKQpUhs0EY1sdcK3926RFOBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722337692; c=relaxed/simple;
	bh=yg7/Ma8QeBcAZaIcrIaTvWGDwPWlI9g0KP+EYdHg+vg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GSVFtTtusHnr9/6lpEcSI51BF/7Ceu+H39hX1XHaMmfhrYSH3wuz2dn1C24/r3f6Ekfu1GcAc5V1fsACOydECalm6nTltT07cNe5vw9saIJqwk69cajme80L5R33b5PnFJK/Vmz815HRMJjzLzTdlYh1ktk3byIihUDt35Y/+oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrElaXxN; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3685afd0c56so2095985f8f.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 04:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722337689; x=1722942489; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NWVOq7R4VQflhc2aMBEeKJOjX2DAQZWRdDwSSzg3C8U=;
        b=GrElaXxNlFJ2eq3blFA5rSu6+fjDFmMr1ypZlh8oo/OKNSF/VE6TwbHngpZPs88MR/
         rE0grRdhyxdXOELAk2D/9rI2duZpQRQecArfIQbOWEVSOEbZo2ETMiBZPCKESMgTCVKj
         C1yyncVW5WkeImHZJzX8/4gyh/aIOddJSdpOYm2V6RIWdiMJ4VnkBfnq+LoN9xdA5aEk
         OyDsB8nwKEgtqQ9JxDECjY1O2mJmQ3aBPMS1n094IhFyHj6JX+ufSMnGMO0qs+VA6f52
         3aGqF7uuGqfvDlAbBky3NKcftPII6e7DD9uFnq7yn1tNyWj6YAtk8YvG2ZG4qErLWfUS
         toJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722337689; x=1722942489;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NWVOq7R4VQflhc2aMBEeKJOjX2DAQZWRdDwSSzg3C8U=;
        b=kGCQUEViG666Ual6ipH2v4sN9TzmrACy1xol1TJL2PtZeG3wcutPFvmk42IU+VIu/0
         bRiANBj+qtJkt3jZbx2ip3PIIrUb4X19usCVOxBJP220+a/LMtMdwYT83bM/fM8xONJs
         paxyrVBCQegQgN4Lz8AJI9oD74a6LNR231BfvDAYZTn7eAw914FYgheeP8NPt82+YbhC
         psoHrB4BVLsDHRnuzfEWTFOv2ZcJJurE30boBYYlF6N6YTASk2MwaL7FekOmFbilgNUy
         90w4ecdkuZuD9a3H849qQyuGS5E6HMs0ruU1SpEoiRP+382z514AQf5rRYoRTvoLp5RJ
         tSgw==
X-Forwarded-Encrypted: i=1; AJvYcCWh4xfblyByCyJnNZLIgA1StybuzXdU5I3EUvZ8HOMW9pu9vqks8e6ioljAWxs+ZGYcVHVTNtp6zmqv6574mFtyVThkIq+WQVs=
X-Gm-Message-State: AOJu0YzT1ISU9uBBM3OZZeyD7WHflCsrORIwee7gb/Jh3+YaC+wQ5qGK
	r5HcRIWoJ4JkYztD0ArnRC48ZJBgNlBVN88WJCWSZH1gvmVx1ealLzixsw==
X-Google-Smtp-Source: AGHT+IGve6NVrHWL2h5AcQGUbZ0KNirg+3vX7ZyUR1qIGPF+ANUPM76U2Wujj5TleAidk4fLD5cGMQ==
X-Received: by 2002:a5d:5888:0:b0:368:4e86:14cc with SMTP id ffacd0b85a97d-36b5cefd6aemr10207222f8f.10.1722337689035;
        Tue, 30 Jul 2024 04:08:09 -0700 (PDT)
Received: from [192.168.42.104] (82-132-222-76.dab.02.net. [82.132.222.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367fc6adsm14381807f8f.51.2024.07.30.04.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 04:08:08 -0700 (PDT)
Message-ID: <f10f8c6b-5858-42ac-a784-d09de2b2d886@gmail.com>
Date: Tue, 30 Jul 2024 12:08:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: keep multishot request NAPI timeout fresh
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <0fe61a019ec61e5708cd117cb42ed0dab95e1617.1722294646.git.olivier@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0fe61a019ec61e5708cd117cb42ed0dab95e1617.1722294646.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 00:03, Olivier Langlois wrote:
> this refresh statement was originally present in the original patch:
> https://lore.kernel.org/netdev/20221121191437.996297-2-shr@devkernel.io/
> 
> it has been removed with no explanation in v6:
> https://lore.kernel.org/netdev/20230201222254.744422-2-shr@devkernel.io/
> 
> it is important to make the refresh for multishot request because if no
> new requests using the same NAPI device are added to the ring, the entry
> will become stall and be removed silently and the unsuspecting user will
> not know that his ring made busy polling for only 60 seconds.

we probably need a new update helper in the future, but good
enough for now.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Should also have:

Fixes: 8d0c12a80cdeb ("io-uring: add napi busy poll support")
Cc: stable@vger.kernel.org


> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   io_uring/poll.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 0a8e02944689..1f63b60e85e7 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -347,6 +347,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>   		v &= IO_POLL_REF_MASK;
>   	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
>   
> +	io_napi_add(req);
>   	return IOU_POLL_NO_ACTION;
>   }
>   

-- 
Pavel Begunkov

