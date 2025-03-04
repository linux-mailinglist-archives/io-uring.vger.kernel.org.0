Return-Path: <io-uring+bounces-6945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A12A4E7E7
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 18:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 383B517D9DE
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4260125525F;
	Tue,  4 Mar 2025 16:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJ6KMhuP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB8F20A5CB;
	Tue,  4 Mar 2025 16:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741106435; cv=none; b=kyzMyP1plp3A7c+/6wlu7VbSZhXilASY6mrFqnQyM4rAcGwFAGZC/TFfRBbjYs/5iM4r2i89+mXioVB4Soqjdt/nggRjs5xYkV8cNNa8sGQKqSo6il5zoOEA/4/yVLdY+ZnJtCgKXtVW2Ygb8j+oRNhXKWDA9KKqdUQFaXppLa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741106435; c=relaxed/simple;
	bh=2VDiqVcWiJkATlvJCckba4T5+jgOb0RQXaMZPFZlXZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXiS7bxcZefgJ5ldgW2TiRl4U2Dy6t/3DBL6HDxepvG3EqfdCM2b76LPjPlIPsiWhgTacdXGOhfnG31DTn+YKALuaMZ0lB7Jmc0XoTJ1f20ONe5nZx7O7zn6B6Irt4u42OIEya08Xbd5rFfYVaZKq/l8yYzdrkjtPXUkMo17tJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJ6KMhuP; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abf5f4e82caso559960366b.1;
        Tue, 04 Mar 2025 08:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741106431; x=1741711231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSsDnF4kIyj9adBSMmkWoIZqOQRbV5XA37b63dv1tgk=;
        b=fJ6KMhuPTgGH6InY57GvD+mTP01fZG39tho8k0HZC/Bg2fdsNiCk7SAG7Zoqct7ROU
         ZRb2r0kyzpTBOmVhqrJKOjbuJf9rc/rADbr+m0HJXr9e3HQoOpmitJGLUP3ZEoi9xZfB
         5oG1y/AWSwb8B47IIYy7oRjPV7kB/BLz6/qAPPWIr4ZVOf+1AeFjzvf9Jtvm62P56fRv
         /XeG4kSL0JXlY+QcCBsGo7SGzI3xsiPb4pfgsz8s7OcLMN0P1HvIPFJ9VujNRppz4zsQ
         HeRpD5TKhP48iFHgW2NiYKZJGNN5UdNvW82JD5zJ+u2V1meFRlguhBPubsOD1HbWnv9F
         rohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741106431; x=1741711231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSsDnF4kIyj9adBSMmkWoIZqOQRbV5XA37b63dv1tgk=;
        b=CLuxhLMBlxdYhI3yVWnN3RbjwFh9sAGR7iKazzfNtNI13SazuT6rLp3jw0L37TIWxF
         bgPVCFI420/rbOg2UFlL9UE8lgjzPwvhyOHWOpwk2RFH3feHfKe+rQ9M3LcGoQh53NJp
         OGRrGY8hC0CC32QMY1x2AG8fVJjtdqPdu+0qgxFbPkUWsLlHbWDV5StCVxoYR+tZnDlx
         QpMyq5VcFZ3Z76sEUYp+8owBpS++Z6DpUAbIh6JLIy01O0gIJUxtC3p8RIOIY8Z6PeIr
         NFj1jG4MkzLejxxe8W4tmrL7qAdBelC2eQ72fLTo1+Fje2JZ16OuB4KTfeAqmEVMV44P
         Ei6A==
X-Forwarded-Encrypted: i=1; AJvYcCVqijgfx8XkXgx5Qjzy+3pvYOsuAKqx6OUDyOVLttmsGHohwl9EKENODkx9e/Y0xZ542sLSHsjRfZTGPmv3kA==@vger.kernel.org, AJvYcCWHr9eDHDJIgJnZLk0qWYQLWMAOuXtWkEJIHuoTG8Nv0ySmWEbTo7RXTHwMvL6m5utK2l13kgKp4yoI@vger.kernel.org, AJvYcCX3UVMS+ATik1U9rlvTLjN4SsMYoE+0ew0sSF8zoa8KR5481FX1Ec3hZARa9/rGJn8iIRTKggE+KA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIS4DjyZoNEU4Kb7aXQmR8T9Xk9vnPmyWooA2vP8uukamQYLGs
	qbhHQX1Ir8AH6zhmgXYhWHijoGGoGr6jdOzOS+HavJ6kGPbDA6SQ
X-Gm-Gg: ASbGnctfxztJMspL2RRIjyyBSm+imEIov21PqV53gcq7jLlAcihEJwyoUBz+4v25G+R
	tYx0S+nCNabRObIHmO+yEI5JiP0fQQd//C9mfkFYxXM2UM3cCTwhRNYbpZF6GYCmKQzD6GIKEza
	pnTzWwzyTc+BvFnCvY7KQL08dXSZuoTxb+anxSLjxSV4h4qefMw7VYewIQZ9kVkHg9R2YMHX3DJ
	qDq2FK8MrkO8c1P553xfloobgxhSXm6JFHr2saSw5VJMgPhxNOGsiC6ty2O2xp61lAS4zv5/xIR
	E52qAqn5cO1DIcc62Jx8kGDbCZQvt0BvbMfD/ek84Yl/9hAowpQLp9IM7LOf/gVEV1cS1Wg6SZW
	sNg==
X-Google-Smtp-Source: AGHT+IEktvZVcrMLh6ypH/pDXZ8sSYq0tzUgSoxCiTC958uSo6KFBvRojG2eK8//s1waGVxdqzvbhA==
X-Received: by 2002:a17:906:c14c:b0:abf:6225:c91d with SMTP id a640c23a62f3a-abf6225d03emr1383476366b.34.1741106431128;
        Tue, 04 Mar 2025 08:40:31 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1e917b70asm199237566b.151.2025.03.04.08.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 08:40:30 -0800 (PST)
Message-ID: <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
Date: Tue, 4 Mar 2025 16:41:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z8clJ2XSaQhLeIo0@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 16:07, Christoph Hellwig wrote:
> On Tue, Mar 04, 2025 at 12:18:07PM +0000, Pavel Begunkov wrote:
>>   	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
>> -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>>   		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>>   
>> +		if (!is_sync_kiocb(dio->iocb) &&
>> +		    (dio->iocb->ki_flags & IOCB_NOWAIT))
>> +			return -EAGAIN;
> 
> Black magic without comments explaining it.

I can copy the comment from below if you wish.

>> +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
>> +		/*
>> +		 * This is nonblocking IO, and we might need to allocate
>> +		 * multiple bios. In this case, as we cannot guarantee that
>> +		 * one of the sub bios will not fail getting issued FOR NOWAIT
>> +		 * and as error results are coalesced across all of them, ask
>> +		 * for a retry of this from blocking context.
>> +		 */
>> +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
>> +					  BIO_MAX_VECS)
> 
> This is not very accurate in times of multi-page bvecs and large order
> folios all over.

bio_iov_vecs_to_alloc() can overestimate, i.e. the check might return
-EAGAIN in more cases than required but not the other way around,
that should be enough for a fix such as this patch. Or did I maybe
misunderstood you?

> I think you really need to byte the bullet and support for early returns
> from the non-blocking bio submission path.

Assuming you're suggesting to implement that, I can't say I'm excited by
the idea of reworking a non trivial chunk of block layer to fix a problem
and then porting it up to some 5.x, especially since it was already
attempted before by someone and ultimately got reverted.

-- 
Pavel Begunkov


