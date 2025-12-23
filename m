Return-Path: <io-uring+bounces-11297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA915CDA192
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 18:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AB18B301C669
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 17:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A7F346A05;
	Tue, 23 Dec 2025 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mRAmXBM9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f65.google.com (mail-oa1-f65.google.com [209.85.160.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED22D130C
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766510834; cv=none; b=K7OjBZyMMFQiPxj/XF9sSo0ZBut60esnfDfcFYRz9hU56MOJtV4diATchbFWYni+RGTUn2jOD/2DPHEtF9qtdYbZ4tOfa/z5uOAKxjbLSgLJPONJpdL24v/mVz7kdYqenVpSlGjFIZwHA/1OonOhY2le37YvlPP5E0HYrH1kAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766510834; c=relaxed/simple;
	bh=yttDIrgg+02oIIr+PIUIZlbzSGuLr/Vu9z5IHJLAXSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYOP7dVPcwgyCI2p+6yLNsVSIgV+9pFNZuq25SpadlzaZcCWBzz6/wrwpIUBPfv+VO0IziCssB40LYZYjUgoKynuAJR9wFgL42ho8xBDqj6ue+kZhLQfPvtJw96HQ39xjgakhE5aYlCPHT6NEnseTvFdm5RDOmFfaU2gfEYv1cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mRAmXBM9; arc=none smtp.client-ip=209.85.160.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f65.google.com with SMTP id 586e51a60fabf-3ed151e8fc3so3480701fac.2
        for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 09:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766510830; x=1767115630; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qFhafrsdejRa6EWjNRaHZBiKaCrmsHauuS+DXkLWytE=;
        b=mRAmXBM9bDtkGbzLtE4G5p7HVyxcQcHv/venBPRot+r0SrJQHqGZiktY4irXxtPxZA
         biQ1+eMyYAUg8y//l73HObMR1EKamJpnKZytUyUvxqLuC5Qt5W2NW2RoALNemFV3bdMx
         hYDhIPyzUJRoFLFrTWfeWKAs3Fg5qJPXXLH5ZkNygWWhNx52gJHydNfHxsgsne5278rP
         P+njVbCGKQOI0uY3GxJcXKnK5Xyv3nlHctnR+ve1EGB4cUecJujxo3SMoV5pLg6PJpz2
         1a4z9ffRV9df9Vjjt2zuYQlYGrzBiex+mlB21fI4W5xd66Gp/FY0Jew+uHLzhNbO2Qjd
         8Ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766510830; x=1767115630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFhafrsdejRa6EWjNRaHZBiKaCrmsHauuS+DXkLWytE=;
        b=sSmiI3OSJZx8/ldD1Rc2zN/sDldcXK6y1r/NdjB5Q2iDgzxGpFr/6RVTXdqPjl5gkO
         FDT+hLVlpY2Czap94UTtksWp6uY4V+pPqf3raIG1KCJS4Af0zD+5theGKJtxfnkg1btD
         S+u7b/UO4Yb1UanQu03g7TXjII5WecNtqkFDhwYck4TSb72qyEL3oY/iNIMpdIHyD8Ms
         YixMvsRolZgdomvPeA4etHg3RZl5x/XU68oEPT8261Sa27FFVI/uGjq2PUPH59DMM++B
         Ama6HVwGlDibzxSUM10v2V02kDoeN/uhC37L3mFH5Pn9ts5GO41RUp5nZd60WHZtrOi9
         PuOg==
X-Gm-Message-State: AOJu0Ywg7BqhgQuWJufFNpPGTbxU5pz1vLDx3XokGNcI6rfIC/9+YpQN
	DCKQ3fdJtg6W1aqzkMvXzGrr2KpVVm028FF87DgA7pNQISRBxqA9SSkmuLO1IKgL7vc=
X-Gm-Gg: AY/fxX76o8eC7oi6mC6X2Zxorr4k9ozq9/bRd6rN4lYnQrmZjUKuhhYkYuEKAaZMCEh
	XatT6wZIo4/OaEL/OOui/SNSEJoBJV1Z4e+jk9GJcySpeS1y2dkl5NWUTun7ona8QJrdIR+aLHg
	geaPZnpOTBsa7lElMcFfdhJ2gSJli0qh2qYfhmsVJq1kVr5KQJBf8vrmNYSJ3D5i29XssVXSULF
	n4yYmdoopHHsk5eMeMTOo6gMopjse4QCta5t1Zq0WwMzS4o6WyweF61M0hRi/4Pyr2jh90LpzoW
	6H95Xc/vq5h/ZWWd6npYdr/6Fbnpp+34HubYtFtaZjg3OhtXUNwtjNu3jzfocMQGsAxychmpr7h
	P1wxVyPQNVHJXcKYj5F2J4nT+RZJfA5bpOhvv1+6ecLx4BpiE3Wi8YF1DxNbOD1BE/Pqq7BOth0
	bVGSCJo2XZR3zRnptkTwE=
X-Google-Smtp-Source: AGHT+IGnwcfEJJ1Py+8TXk7YYntExpDoFTFTndV/4+3eg1BLJyqo1sm/tza9QzEyR/isURmLTd7SHw==
X-Received: by 2002:a05:6870:2422:b0:3d3:cac:30d1 with SMTP id 586e51a60fabf-3fda533b4dfmr7321345fac.0.1766510830251;
        Tue, 23 Dec 2025 09:27:10 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaab620b8sm8786754fac.14.2025.12.23.09.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Dec 2025 09:27:09 -0800 (PST)
Message-ID: <0f83a7fb-0d1d-40d1-8281-2f6d53270895@kernel.dk>
Date: Tue, 23 Dec 2025 10:27:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 netdev <netdev@vger.kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Julian Orth <ju.orth@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>
References: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
 <willemdebruijn.kernel.18e89ba05fbac@gmail.com>
 <fe9dbb70-c345-41b2-96d6-2788e2510886@kernel.dk>
 <willemdebruijn.kernel.1996d0172c2e@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <willemdebruijn.kernel.1996d0172c2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/25 1:08 PM, Willem de Bruijn wrote:
> [PATCH net v2] assuming this is intended to go through the net tree.
> 
> Jens Axboe wrote:
>> On 12/19/25 12:02 PM, Willem de Bruijn wrote:
>>> Jens Axboe wrote:
>>>> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
>>>> posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
>>>> incorrect, as ->msg_get_inq is just the caller asking for the remainder
>>>> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
>>>> original commit states that this is done to make sockets
>>>> io_uring-friendly", but it's actually incorrect as io_uring doesn't use
>>>> cmsg headers internally at all, and it's actively wrong as this means
>>>> that cmsg's are always posted if someone does recvmsg via io_uring.
>>>>
>>>> Fix that up by only posting a cmsg if u->recvmsg_inq is set.
>>>>
>>>> Additionally, mirror how TCP handles inquiry handling in that it should
>>>> only be done for a successful return. This makes the logic for the two
>>>> identical.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
>>>> Reported-by: Julian Orth <ju.orth@gmail.com>
>>>> Link: https://github.com/axboe/liburing/issues/1509
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> ---
>>>>
>>>> V2:
>>>> - Unify logic with tcp
>>>> - Squash the two patches into one
>>>>
>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>> index 55cdebfa0da0..a7ca74653d94 100644
>>>> --- a/net/unix/af_unix.c
>>>> +++ b/net/unix/af_unix.c
>>>> @@ -2904,6 +2904,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>  	unsigned int last_len;
>>>>  	struct unix_sock *u;
>>>>  	int copied = 0;
>>>> +	bool do_cmsg;
>>>>  	int err = 0;
>>>>  	long timeo;
>>>>  	int target;
>>>> @@ -2929,6 +2930,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>  
>>>>  	u = unix_sk(sk);
>>>>  
>>>> +	do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>> +	if (do_cmsg)
>>>> +		msg->msg_get_inq = 1;
>>>
>>> I would avoid overwriting user written fields if it's easy to do so.
>>>
>>> In this case it probably is harmless. But we've learned the hard way
>>> that applications can even get confused by recvmsg setting msg_flags.
>>> I've seen multiple reports of applications failing to scrub that field
>>> inbetween calls.
>>>
>>> Also just more similar to tcp:
>>>
>>>        do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>        if ((do_cmsg || msg->msg_get_inq) && (copied ?: err) >= 0) {
>>
>> I think you need to look closer, because this is actually what the tcp
>> path does:
>>
>> if (tp->recvmsg_inq) {
>> 	[...]
>> 	msg->msg_get_inq = 1;
>> }
> 
> I indeed missed that TCP does the same. Ack. Indeed consistency was what I asked for.
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>

Can someone get this applied, please?

-- 
Jens Axboe


