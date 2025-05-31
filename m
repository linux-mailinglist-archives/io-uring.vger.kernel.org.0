Return-Path: <io-uring+bounces-8174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF9EAC9A8D
	for <lists+io-uring@lfdr.de>; Sat, 31 May 2025 12:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D5A03B0620
	for <lists+io-uring@lfdr.de>; Sat, 31 May 2025 10:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033FC235BE2;
	Sat, 31 May 2025 10:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maKDgCvi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4664320F081;
	Sat, 31 May 2025 10:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748687261; cv=none; b=DiAvzOr5FwnPXlevYzkXqikgrvEbYAm+4MPiQJ62qJzIzaR9z4oVO1BFkIjPRrZRFmA76X07vrAAVKl4HFmKvGS2kTWRpP7jk80cF/9dBv1VK5S2yw8A3kLVtSJ7Q7gFPyuPRBpt2rDpNOJ4KyliZXpZZR22G0sXy/PupX6JCIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748687261; c=relaxed/simple;
	bh=qLbEl+HELsNyJ3onNtP198Qwc3JGGySltJ1h9ocWi/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N5BonyDZDyEdtdxHe+P1uWJIxHl7mylzY3eYtL3OD1oe6uQncTSHzjKwLIR8PemwQ3N3OVEvQQs2un7IFE9sd/xqH1y7CB/jDPc/w0cRTJ39CNh544cfyMEyqkEuEZP/0mIRmdVBKCeJNcep7Iq8pYuWtOHDrfYyhgKXCVwoGnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=maKDgCvi; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6049431b0e9so4201598a12.0;
        Sat, 31 May 2025 03:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748687258; x=1749292058; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VQ3poRpVAbqg8lKnPKyCxlIgIfKo7fljzJSrqrBhuj8=;
        b=maKDgCvilsIaN5Q4PZLxED736iWKZWozaEaXnCWWNFKzmbhhZ63+aipAMbtJfTKpnO
         X749Pl6xwm9NasBhJNd9HHe9djuzE4Izw0Kz4tX8uoJX2UTyQeM3s8ffxE8x/CKmHsuL
         e1J2nq+5mGSzspj7PUfawBnzzmIdnxBXk6+mPb6B9zwFk5oaF3zCce6UZI5KSwZa1pk6
         Qk2lIJsCtBkIot7Af3Mktm5VgUeYl/VD6dzR7xSuVZO9eh9Y/FkxPNIchQ3HvHJmxXv7
         v2tU1TvK1lkswcG0ODULQtcoTDU/+gUaLJVDGBN1NJyRwa8fMGWyJUaFK64FSjSZJCsh
         7lAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748687258; x=1749292058;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQ3poRpVAbqg8lKnPKyCxlIgIfKo7fljzJSrqrBhuj8=;
        b=mSbtdjZceCQW4P8Ec0Cx01YymQea81LgFEDMvtiwwL0Dhs/0bD/fI12tG0bwhcG2+X
         82JMChDuqfFpjIdVzaJkYeVgycm76BxWrlMdVbemPmgnBn5Ed7aTL3IO8+OZPD83ykV4
         mXpzfrbZBsHpMarbBnZZBGElPOrXND0mGjvFwJFDZEXFZg255haeYljG4LFqqEdl3Dhk
         twsdAmS1S6W9AtQLD+iWoea56DUdcKCSzg64q33J+OlmNghZLlxpERBURqxD2sDMeIpe
         kWr7pE4m9Fu7dKUvGcsP6MuXhr6YHxdvZ6WOh/3HzfrkDtKHcVjaw4YfEAAudE6lvE5c
         opNA==
X-Gm-Message-State: AOJu0Yymb/uXwX8V152OHBUsnWXckmUHoC6bWKZpzxlJzhBG02mjEifn
	tDVw0hEQO2ylDRUcawDHl1Eb42oeQY7OVummbpUYVWyX1b6u2DvwVJKVfL70Xg==
X-Gm-Gg: ASbGncvAbNoyB3QiaV3hotjfPDL7H8bykYs+ss23UVjWlabFOX7B/cBsFr2R0uTZJpM
	tTDXxrsjCqmlAFI+NUkvwC4ogO+HAvbjz5l36UNut6mDNlgCTCQTE810A0OZNMk9K1sL8uBUwS2
	6k77I8syJ0NYnxY4JymCTZE+g/na4KDXvMqlrnM1Xld1p2zm8gYHpQoufVPn3irm3WORy7rhTKd
	Pc7fUE2MfOe4NGiKlz/A+SBD09Hl6Ervn72Ni8n4Ub/6eSS60DD0Ie8x29+ATIl0zu9ZyA3ZEh0
	LxB/YaUVx5ajZTP2Q/gLmW8NfiJtYQcCL0iZVYjFOufiW5CuVsocqYwQkmzjWTEvSHKlvRTu
X-Google-Smtp-Source: AGHT+IFRhfClv4Mv2yEjBEk1lhmHGZ+8qm6WGwQJnNzHl20De/LDe4sgl8q9a+h3rUkW2bno9AzIsQ==
X-Received: by 2002:a05:6402:35d5:b0:5f4:9017:c6a1 with SMTP id 4fb4d7f45d1cf-6057c62af81mr4896994a12.25.1748687257912;
        Sat, 31 May 2025 03:27:37 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.152])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60567169cdfsm3021465a12.70.2025.05.31.03.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 May 2025 03:27:36 -0700 (PDT)
Message-ID: <bf6aa4f9-7c6f-4e28-88c0-0e20c5e4a854@gmail.com>
Date: Sat, 31 May 2025 11:28:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring/poll: introduce io_arm_apoll()
To: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
 <8abeb8e2328e923515c63e43a1942802efabb3b1.1748607147.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8abeb8e2328e923515c63e43a1942802efabb3b1.1748607147.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 13:18, Pavel Begunkov wrote:
> In preparation to allowing commands to do file polling, add a helper
> that takes the desired poll event mask and arms it for polling. We won't
> be able to use io_arm_poll_handler() with IORING_OP_URING_CMD as it
> tries to infer the mask from the opcode data, and we can't unify it
> across all commands.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
... -		if (req->flags & REQ_F_CLEAR_POLLIN)
> -			mask &= ~EPOLLIN;
> -	} else {
> -		mask |= EPOLLOUT | EPOLLWRNORM;
> -	}
> -	if (def->poll_exclusive)
> -		mask |= EPOLLEXCLUSIVE;
> -
>   	apoll = io_req_alloc_apoll(req, issue_flags);
>   	if (!apoll)
>   		return IO_APOLL_ABORTED;
> @@ -712,6 +696,31 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>   	return IO_APOLL_OK;
>   }
>   
> +int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
> +{
> +	const struct io_issue_def *def = &io_issue_defs[req->opcode];
> +	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
> +
> +	if (!def->pollin && !def->pollout)
> +		return IO_APOLL_ABORTED;
> +	if (!io_file_can_poll(req))
> +		return IO_APOLL_ABORTED;
> +
> +	if (def->pollin) {
> +		mask |= EPOLLIN | EPOLLRDNORM;
> +
> +		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
> +		if (req->flags & REQ_F_CLEAR_POLLIN)
> +		mask &= ~EPOLLIN;

fwiw, I need to fix tabulation here

> +	} else {
> +		mask |= EPOLLOUT | EPOLLWRNORM;
> +	}
> +	if (def->poll_exclusive)
> +		mask |= EPOLLEXCLUSIVE;
> +
> +	return io_arm_apoll(req, issue_flags, mask);
> +}
-- 
Pavel Begunkov


