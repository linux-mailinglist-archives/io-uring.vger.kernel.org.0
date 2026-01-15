Return-Path: <io-uring+bounces-11751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 763C2D28A83
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 22:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A0E3302515D
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 21:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF39231DDBF;
	Thu, 15 Jan 2026 21:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dNjtS9jn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16032E9749
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 21:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511325; cv=none; b=A8KPkkv0z7wBraJwNKWiVVlzBzhAZOTJ/r3fnY6xmjfioam96yp/fb4M3Yl8M0NUWss+0VtM9DZ925FX08Y8+fbxgb44TIxonOQ3wNeUTx2jLX5vUJ7bJzfmLzscmzt4guOd83ytXmuk4VxVjyv2GKxJZL7idbb5tH5YkwJxO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511325; c=relaxed/simple;
	bh=QQPfnceqep166lihSMqPNrSk/9CscKSFEJYHfn6vmdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d21oiJFhZHZRD0OS3Jm0jQkx3LCABKsiJS0gcxbl8QPC1sjqthfXCAn4feRQHCQU1Qn+XnuUW3PYvjfmqh/oDx5K++Jg6GwOlMplRIqo6UABjTFz90XV1TsiTYIXQvFgAwnfPVuE7JurSgOwBpPry119SYziksjsAA3LNjKetag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dNjtS9jn; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40423f8c5faso914815fac.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 13:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768511323; x=1769116123; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YFLt68HuKovIGHFo77PHb2ZzXJPomnXcJal99zZE178=;
        b=dNjtS9jnMonCT/y4J+nQvM6HFxhPwpdTkEH9H1o9f5kgV2zfMXOCMnfq+Wbae+yTn8
         rkF1d5nNnaxWSvIXEy3vktI1f8UkomjInzZOV+eav/jPgpSi/rVaG+nZBofcmeOoO/Kh
         JDtfkxrw7pa/ycIY7e6zRUnQNVzWpnpARP+hK4uoviXIigd22ohM181aEttaoNI8k5qp
         wC795nuLh73BIUbXtoMLqDE0xlMVF8K454FZ6mTHtdBpWM31X7r1g/IMLvob7gwjzpp5
         K8DhfUSWZq1k5Pv3AQCRZfnPibJJ9qTkNqZICyVCDUXWaKHMzNdiAL/s2WBDP7uwuNcu
         ctqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511323; x=1769116123;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YFLt68HuKovIGHFo77PHb2ZzXJPomnXcJal99zZE178=;
        b=Q2gqtKCsEUgyi167iDYKngjB97QhSzaaxb1lCoveE+ki6ncdGjQFHg9sntoBHYKu9s
         Zlv26WImCSj9R26WciU2SXIN3njgG/RwdETLxHdLzW9ovKAiOekuJFND0Nmmp0yGBMwV
         qI7M/PRwKtqB3lyF9lv2hVfpWbK3/1lb6Md/n/Mg3p7j0AxCHTODs8qBoPXWrxAp/5ka
         kHAT46Wy9UP/2Yn4lbnSto8KI3VYwMW/J/VhzPBEF/KEDhEeNSXSmG/iUn9JAKla/OU6
         6T+6K3dqK4wD7HngmamrqZjQ7g9JO/PbD+nXJtHESFmaSb01uyUte1pWrxdTQL/0+ANZ
         Q5OA==
X-Forwarded-Encrypted: i=1; AJvYcCUUuSK53ODHiClY+fA/3uVMJ1QUDJjjPyNEVXLFpdTRxoCSvQLyjtnzoq8ovvJERWyvOsBCmYreaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDgDNLmq9ezsSWUt3E09Ou36yYyJBjWlkGQQF+0hz3qayVDLao
	GERSbo9/JsflnCAulrnhj/afdoYRMxoNuh+akx2Zda2OhImIgYo+ne2b/XtL1fBLnKS9fXQIPqr
	mfLPh
X-Gm-Gg: AY/fxX4syfPYFD15IQ9gtGieGg3DZRsW89aa+F/fbGufV1baexL3wxCjGe68lxc5iLG
	+04LBlWiYIPC3YKfn8WvrjVlDENV6y3GQ1uaKQryvWYqTDSRn11QUsav196PnrMROfvWIb6y3Sx
	ZUB3Ti9I+02mdFhpjvEb68gdHaiQCBItRV5NjuKigxxeoQMGqdfA2yLk+aeuDuRyaJtJUqk0YVf
	zo44MbND5CG8ivttonQ+c/4IJLIjBfm6rAT2lmEnjcKAc4EEXbKoy2PA7x8gw4rrS8qXbgGrn8e
	1CtcfL1zW6I1giuS0VPm0AQYTRtyDd6YNnB8MqGeCW0CZbscxLQg6RsJvmU5uA/2fPKyM/pIm4f
	8WQ3S7S+n61ccn4TehFVU3aXfVwSpfqS8FtbL4/ojvy+ru6+z9wAOmIiEYku8pBupDKv4jS9wZQ
	G7q1ZsBu4=
X-Received: by 2002:a05:6871:693:b0:3f5:d159:7ef3 with SMTP id 586e51a60fabf-4044c157d20mr471232fac.9.1768511322698;
        Thu, 15 Jan 2026 13:08:42 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd5cf99sm446706fac.17.2026.01.15.13.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 13:08:41 -0800 (PST)
Message-ID: <eafcaf17-dc4b-4f59-b120-7efcf93048f3@kernel.dk>
Date: Thu, 15 Jan 2026 14:08:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring: add support for BPF filtering for opcode
 restrictions
To: Jonathan Corbet <corbet@lwn.net>, io-uring@vger.kernel.org
References: <20260115165244.1037465-1-axboe@kernel.dk>
 <20260115165244.1037465-3-axboe@kernel.dk> <874iomskkh.fsf@trenco.lwn.net>
 <9c57ec11-bd72-4caf-8c4b-b46c84f67ef3@kernel.dk>
 <87h5smr3hi.fsf@trenco.lwn.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87h5smr3hi.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 2:05 PM, Jonathan Corbet wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 1/15/26 1:11 PM, Jonathan Corbet wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> This adds support for loading BPF programs with io_uring, which can
>>>> restrict the opcodes performed. Unlike IORING_REGISTER_RESTRICTIONS,
>>>> using BPF programs allow fine grained control over both the opcode
>>>> in question, as well as other data associated with the request.
>>>> Initially only IORING_OP_SOCKET is supported.
>>>
>>> A minor nit...
>>>
>>> [...]
>>>
>>>> +/*
>>>> + * Run registered filters for a given opcode. Return of 0 means that the
>>>> + * request should be allowed.
>>>> + */
>>>> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
>>>> +{
>>>
>>> That comment seems to contradict the actual logic in this function, as
>>> well as the example BPF program in the cover letter.  So
>>> s/allowed/blocked/?
>>
>> Are you talking about __io_uring_run_bpf_filters() or the filters
>> themselves? For the former, 0 does indeed mean "yep let it rip", for the
>> filters it's 0/1 where 0 is deny and 1 is allow. I should probably make
>> the comment more explicit on that front...
> 
> Ah, yes, I got confused between the two, sorry for the noise.

It's useful, I expanded the comment now:

/*                                                                              
 * Run registered filters for a given opcode. For filters, a return of 0 denies 
 * execution of the request, a return of 1 allows it. If any filter for an      
 * opcode returns 0, filter processing is stopped, and the request is denied.   
 * This also stops the processing of filters.                                   
 *                                                                              
 * __io_uring_run_bpf_filters() returns 0 on success, allow running the         
 * request, and -EACCES when a request is denied.                               
 */ 

I am making one more change in this patch though - to deny by default.
If restrictions are registered with BPF, we should probably have the
same logic as the classic restrictions, where if an opcode isn't
explicitly enabled, it is denied. That makes it easier to future proof a
filter set. I do want to do that without needing a dummy BPF program
attached to each one, however...

-- 
Jens Axboe

