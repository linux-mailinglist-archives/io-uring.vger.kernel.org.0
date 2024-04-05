Return-Path: <io-uring+bounces-1409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFFC899DD9
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 15:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4DF1C214A3
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 13:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9C416D32D;
	Fri,  5 Apr 2024 13:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PG0UrNNs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58F812E5B;
	Fri,  5 Apr 2024 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712322070; cv=none; b=THwbPnV+GCiAW5h1uMHurh+8VxRqGqMYB32xvBw2EWaFSnQgM15y6SC1VklShG3Duu8W2iWGyRoi9Htq0FrKBtE6Nxk/1xijoxR0pEDQuHVwy1vVoWkLCsPFmZMSdsa2+Acm5ZD8GNd04LtOdRVl5v+QSvjGDREXyDbWFGepRE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712322070; c=relaxed/simple;
	bh=YJjJlpzvj2uxvu1IoSI6mcOLJx5rK4qWeNXOjT7Z3rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSiPbIn/sAFB0v4ez7Keo3a/uk0ILAHcEDNZ9uQ7wFV2hundO6xlUvjeZa6xYneAHK78Rekfe5dHnkW8DkzNIRQ9LgsHmJpANFA5IJKx3xwNGPlcF6oHf11sQRiZXFGeQR4yAvFEMJ+Z5JMpubv5I0TODHONlNXUszFzVF+CgN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PG0UrNNs; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a46ea03c2a5so367785066b.1;
        Fri, 05 Apr 2024 06:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712322067; x=1712926867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6EhxJU6AmPMJUb0rbbwJX02/QxE9CvtNuAXYPepR4nI=;
        b=PG0UrNNse83Ggt5TIr3/KRI56Qe8+5Dpy+Hy0JDNiHZdYhSZus2GJ2mYZDsE+itQz3
         vX0BdaVr3MfCRlvUwX+cPP/KuKccaZ3VKDGTSRnvrpK7zjZhoh+aoNcqiOenQMe3wMj+
         F43QXBHsc5KIVP2mU2n9aBEIU8jokclr7OexYROMANUjf/8DgsHxYsHWQtwA3zHAvnPn
         DsEYkT/EKYIy35Zh/eTYolbxc+cGUy7kedP2vElktRBaSFD7caOZKEu/TPn6QtISGExW
         GGWCsPdQ0bkdhIY69Q5g4yYs9OabABqNMtUgRaVV+DnLT6Vt6zeyWrilrWH6dblxOikO
         0Oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712322067; x=1712926867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6EhxJU6AmPMJUb0rbbwJX02/QxE9CvtNuAXYPepR4nI=;
        b=BpeET0TwPD1YULV1GG3knUEUMQ+YpTKx6eFztUsKeOvqYki77onID/9Sv20MwxsypQ
         MZUc8fpk1pI7SlaVy51ZuxhcShdd19kjk0Kn0A2LLm0WApC9Ov+ORkSFpYoZKeKSYIdR
         GonR8HAWca9p8T06JZhEtWc7YygpARvjbOFXRSctIoOCrG6b6oT0JO8BmlO63Ln8JL0Y
         t4J9gUhO5pDmA9VfVXZBK5KLFBLsXCJ8OturdRGA4jBu3OFi3BfUDnFYDvFW2DsTALWr
         cn9ITUECRgycZkIE5/f9pVR6Q6vLWI8CPpCL0pVicunz/I6NLev325QGIQsyruUpzGeK
         n9/A==
X-Forwarded-Encrypted: i=1; AJvYcCVOZoxpXovLZ1K2Q914Xjl3R1GNHu48U1FHSn6+5oSg/bKialUXHKxOCnwZ64rJ1fVM2fl+8l4tIIh7M5bC8xzkdhCbcwbnVDyyJnWRY6OrEYPxM0x4m2e1FFiV/5wJUDp1dGbaUkp5GZDSqpTDdZ9qGaYcPFmI6Pp7BbkfLl2sddi5o67O
X-Gm-Message-State: AOJu0YzH9qbhTVXczXazBebATeU9MxNwF+HoE5es4sZbTPHXP1Awd722
	hJSUzrG5b+cdDc5IKKtIuciguMxmQz70hq396A0dty0riuyJtHZ4RZlXOlUl
X-Google-Smtp-Source: AGHT+IEZtv93Er+f7fXJTh4vjB2CuAU6dhEVVGKjUJq4Jv9JVv4wtP0ZuhQTBJSLWKsCsCjw71VxCQ==
X-Received: by 2002:a17:906:4a44:b0:a51:9575:bd3a with SMTP id a4-20020a1709064a4400b00a519575bd3amr1167948ejv.38.1712322066954;
        Fri, 05 Apr 2024 06:01:06 -0700 (PDT)
Received: from [192.168.42.78] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id hx12-20020a170906846c00b00a51a9eccf2asm456248ejc.125.2024.04.05.06.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 06:01:06 -0700 (PDT)
Message-ID: <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com>
Date: Fri, 5 Apr 2024 14:01:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring
 zerocopy
To: Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, shuah@kernel.org, leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1712268605.git.ozlinuxc@gmail.com>
 <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/24 23:17, Oliver Crumrine wrote:
> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
> specifically disabled REQ_F_CQE_SKIP, as (at least from my
> understanding) the userspace program wouldn't receive the
> IORING_CQE_F_MORE flag in the result value.

No. IORING_CQE_F_MORE means there will be another CQE from this
request, so a single CQE without IORING_CQE_F_MORE is trivially
fine.

The problem is the semantics, because by suppressing the first
CQE you're loosing the result value. You might rely on WAITALL
as other sends and "fail" (in terms of io_uring) the request
in case of a partial send posting 2 CQEs, but that's not a great
way and it's getting userspace complicated pretty easily.

In short, it was left out for later because there is a
better way to implement it, but it should be done carefully


> To fix this, instead of keeping track of how many CQEs have been
> received, and subtracting notifs from that, programs can keep track of

That's a benchmark way of doing it, more realistically
it'd be more like

event_loop() {
	cqe = wait_cqe();
	struct req *r = (struct req *)cqe->user_data;
	r->callback(r, cqe);
}

send_zc_callback(req, cqe) {
	if (cqe->flags & F_MORE) {
		// don't free the req
		// we should wait for another CQE
		...
	}
}

> how many SQEs they have issued, and if a CQE is returned with an error,
> they can simply subtract from how many notifs they expect to receive.

The design specifically untangles those two notions, i.e. there can
be a notification even when the main CQE fails (ret<0). It's safer
this way, even though AFAIK relying on errors would be fine with
current users (TCP/UDP).


> Signed-off-by: Oliver Crumrine <ozlinuxc@gmail.com>
> ---
>   io_uring/net.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 1e7665ff6ef7..822f49809b68 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1044,9 +1044,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   
>   	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>   		return -EINVAL;
> -	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
> -	if (req->flags & REQ_F_CQE_SKIP)
> -		return -EINVAL;
>   
>   	notif = zc->notif = io_alloc_notif(ctx);
>   	if (!notif)
> @@ -1342,7 +1339,8 @@ void io_sendrecv_fail(struct io_kiocb *req)
>   		req->cqe.res = sr->done_io;
>   
>   	if ((req->flags & REQ_F_NEED_CLEANUP) &&
> -	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
> +	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC) &&
> +	    !(req->flags & REQ_F_CQE_SKIP))
>   		req->cqe.flags |= IORING_CQE_F_MORE;
>   }
>   

-- 
Pavel Begunkov

