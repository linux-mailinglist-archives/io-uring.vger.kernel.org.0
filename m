Return-Path: <io-uring+bounces-2057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 866958D70FD
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 17:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34EE4282E71
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 15:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1020DB66F;
	Sat,  1 Jun 2024 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b="Pn6RQ94l"
X-Original-To: io-uring@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014BD13ACC
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717257111; cv=none; b=OE/Cgc8MSyQf78QfZFmYXt6RburtS0gqWmlTrVUcemtXYJnozizSEtQia62313erFd0nCFXEOc9+orIIWNC6hjYwd7j3BUxqW/yelKaoRYV6cBZ5qVHjeInsMcEkPEjfSqTIg6NS0UeboMdrLGi4KsT4q/J2bVTqa1VoKSYSybE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717257111; c=relaxed/simple;
	bh=dM7ViKGAc+uOkd3WcrhD9Fi7DS2YrcYV+le0IZlpzYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r3gZrDeC3fRIDxL87wI5u0kSE7H/XU4Ijlrz7b2KfcnumeZn5TgL9gsKCEBOHZLJAZIO1vhNI6i+7+4l7IFsfCaNdk58KMiHAKg3mYlJ+sZ3PLWTt5K200gF9ghP9giV6XJhTQxrgTN9QNxhYbBBpyUnxGrtFqMQYCgfMB+50Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net; spf=pass smtp.mailfrom=s.muenzel.net; dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b=Pn6RQ94l; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s.muenzel.net
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s.muenzel.net;
	s=default; t=1717257105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFcYYorS/2meGxirNoXlc1/EcCpTEQipgkqGI73UEfE=;
	b=Pn6RQ94l3i6oAg4zsBpVm34RlOnW1JCv0HKGpZeCFEAjs44sLx0o7B362HQP6ytvpT3KCf
	gz5AsZ5mRcrjAOR1EpCVshIykOBoblRankhQJIgzHMPpVtxO2H6o6JBqzXjr3Gdhc91l67
	KHthU3GMwmSZI9sSdyVmRMAPpFbJK4o=
X-Envelope-To: io-uring@vger.kernel.org
Message-ID: <8b08398d-a66d-42ad-a776-78b52d5231c4@s.muenzel.net>
Date: Sat, 1 Jun 2024 17:51:55 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: madvise/fadvise 32-bit length
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
 <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
 <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Stefan <source@s.muenzel.net>
In-Reply-To: <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 1/6/2024 17:35, Jens Axboe wrote:
> On 6/1/24 9:22 AM, Stefan wrote:
>> On 1/6/2024 17:05, Jens Axboe wrote:
>>> On 6/1/24 8:19 AM, Jens Axboe wrote:
>>>> On 6/1/24 3:43 AM, Stefan wrote:
>>>>> io_uring uses the __u32 len field in order to pass the length to
>>>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>>>> 64bit platforms.
>>>>>
>>>>> When using liburing, the length is silently truncated to 32bits (so
>>>>> 8GB length would become zero, which has a different meaning of "until
>>>>> the end of the file" for fadvise).
>>>>>
>>>>> If my understanding is correct, we could fix this by introducing new
>>>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>>>> of the length field for length.
>>>>
>>>> We probably just want to introduce a flag and ensure that older stable
>>>> kernels check it, and then use a 64-bit field for it when the flag is
>>>> set.
>>>
>>> I think this should do it on the kernel side, as we already check these
>>> fields and return -EINVAL as needed. Should also be trivial to backport.
>>> Totally untested... Might want a FEAT flag for this, or something where
>>> it's detectable, to make the liburing change straight forward.
>>>
>>>
>>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>>> index 7085804c513c..cb7b881665e5 100644
>>> --- a/io_uring/advise.c
>>> +++ b/io_uring/advise.c
>>> @@ -17,14 +17,14 @@
>>>    struct io_fadvise {
>>>        struct file            *file;
>>>        u64                offset;
>>> -    u32                len;
>>> +    u64                len;
>>>        u32                advice;
>>>    };
>>>      struct io_madvise {
>>>        struct file            *file;
>>>        u64                addr;
>>> -    u32                len;
>>> +    u64                len;
>>>        u32                advice;
>>>    };
>>>    @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>    #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>>>        struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>>>    -    if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>            return -EINVAL;
>>>          ma->addr = READ_ONCE(sqe->addr);
>>> -    ma->len = READ_ONCE(sqe->len);
>>> +    ma->len = READ_ONCE(sqe->off);
>>> +    if (!ma->len)
>>> +        ma->len = READ_ONCE(sqe->len);
>>>        ma->advice = READ_ONCE(sqe->fadvise_advice);
>>>        req->flags |= REQ_F_FORCE_ASYNC;
>>>        return 0;
>>> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>    {
>>>        struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>>>    -    if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>            return -EINVAL;
>>>          fa->offset = READ_ONCE(sqe->off);
>>> -    fa->len = READ_ONCE(sqe->len);
>>> +    fa->len = READ_ONCE(sqe->addr);
>>> +    if (!fa->len)
>>> +        fa->len = READ_ONCE(sqe->len);
>>>        fa->advice = READ_ONCE(sqe->fadvise_advice);
>>>        if (io_fadvise_force_async(fa))
>>>            req->flags |= REQ_F_FORCE_ASYNC;
>>>
>>
>>
>> If we want to have the length in the same field in both *ADVISE
>> operations, we can put a flag in splice_fd_in/optlen.
> 
> I don't think that part matters that much.
> 
>> Maybe the explicit flag is a bit clearer for users of the API
>> compared to the implicit flag when setting sqe->len to zero?
> 
> We could go either way. The unused fields returning -EINVAL if set right
> now can serve as the flag field - if you have it set, then that is your
> length. If not, then the old style is the length. That's the approach I
> took, rather than add an explicit flag to it. Existing users that would
> set the 64-bit length fields would get -EINVAL already. And since the
> normal flags field is already used for advice flags, I'd prefer just
> using the existing 64-bit zero fields for it rather than add a flag in
> an odd location. Would also make for an easier backport to stable.
> 
> But don't feel that strongly about that part.
> 
> Attached kernel patch with FEAT added, and liburing patch with 64
> versions added.
> 

Sounds good!
Do we want to do anything about the current (32-bit) functions in 
liburing? They silently truncate the user's values, so either marking 
them deprecated or changing the type of length in the arguments to a 
__u32 could help.

