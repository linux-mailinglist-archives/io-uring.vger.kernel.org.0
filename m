Return-Path: <io-uring+bounces-8655-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BADB02B82
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 16:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 915953BD44A
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 14:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3583E2797AA;
	Sat, 12 Jul 2025 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yjbns99P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A282F5E
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752331705; cv=none; b=EGs9X1Eb6O7p4kgsOpfLqAOxpOjgJPx+mtNLKlVk8Beb8GKS71FTZLbDrJJsCOtKrZ9D6KWga+NPtnIdqRztBXGQOBewx27trxKNH6aD4P3DkpNnZHwrvnHX2yq3v+fMdxuV58t9ZaFlV6NsEbYGFQH6gIuOoZEF7dbLmOJKGtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752331705; c=relaxed/simple;
	bh=OCfzFUjvBmR61MJD23FtuWHnorV9paLrlpwWz4WUdX4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=kUh4gVhHbdcDV2cmRNIcub8Nn+YOnV29y0OZ9rsm0h9Q/re8IHZYCSclef1no6PGSOqUyocDlQ61kftM3hNetuAi8rU1eDR1KY5wQHTfLs5FI+2Ma/6rHrlUG4hq2jwgS9NoSkjkd5pH4g45xTkZhnFU0fqwj/jcULWrhGCUfRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yjbns99P; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6099d89a19cso5728204a12.2
        for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 07:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752331702; x=1752936502; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPoZxbDy5IVQotYuPkeOzmCyJqMmSLd7VlZAVspm1to=;
        b=Yjbns99P9J+XZXPS3jUyx+8nDX+mpxlW3HI7KXWz0fStdWPEewwtMH+FUKMKSAdQnb
         NucAlbeJg0afIZ5EdVi6MKYL9S79PlGZI8mZt8YkuBFaFBQczCi6Ogj8wUuXk+YrgqfG
         Q1D7SYNBNUEKEsO4Z9W+7ZPWD258gwjMR0mk4laIu9/LSUhr8YNj7n/s+xQyPJdYUPtW
         aWmCPu/Wj6ux9vlJ0S9ClKdrwFQIuiyXJzNRG9rGvqRrunXyc4KU3i3hisDZP+Hh9MDf
         b2Cxpy4Q8HvwaAiOO4Ouo7uTI7mgDgCaIfj9VYxsRuI97vFc5YyYMLCrsHhAjMZK1Wmx
         HGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752331702; x=1752936502;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jPoZxbDy5IVQotYuPkeOzmCyJqMmSLd7VlZAVspm1to=;
        b=KAYFp5ZXfgqXAxtHTTDBWyLeiQtZUQGY3zluUo9fa0eGaGe6FaVRA5TK4U7H0bTAQU
         ybGyWP2MZlN2ijQ+lcuNnOOl+jVdKV1lm0klQJYPNg7yGuqc3I3TxkVnjIc4cJfkA6JN
         5F97xckfvNfMPxDthlp5tBvchNpJOtQhsF61HoFGS7Xy8xeSYFgz8fooDupfxJtVtmR6
         YbsGKJgvH786vkB3197TOavg9NALEZc2Ue2VgbvtPePBcaVB8n2xMi91We8GviGtVhUv
         VvBiztf+dTt6oEr9L8lRu9dVdLSqt0s/vZLeHez6/gIwjFuK+g7nm4IEvNJfEf6NQY4l
         LQ8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRJBl6gIgsowJAQDemWzmgOP+KnR3VQhqj0TwnwFIDQocGb2ZSTBng64HV0KZC535/Ww0Gsc2Cog==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+2AFy6CHzHqJjzFd4CMNCyjrpsxumlZkBT6K3tK/cVr7yrk7y
	IIEmCoGyuek63GI8DxihgeeesGjRyidyQiEXXCGvK5tyx1pgQ2aImqT9eE7QqA==
X-Gm-Gg: ASbGncvwyoXg1RQPcJ9mNU+7syrgEJbwDxX5tc1eRABO7RuuVaXcuHxZ917nk1upwOs
	ISeLtR+K7Tqo0uR+4pqCyNvf6hTnPW2WIyHGi3Yw/KKzC7drLpabjrUNbLZcsOlw2ntxseL5JeH
	/aFXz2GWzUCV0RCOnHbePDDVdlSFVjRSTf0uzoQJE2nnpWcWPVgmyxnvUuC4UQZPv7Wl95dtRKO
	JSdKawE2Z3lzBZq7dn1fms64YS56W72JfQUz993S7TVN+wxZRdMCNGryp7svN18O7r+k/+Mmk5u
	voQTvzxpZvL4gEkgtWlEl0yJrjBWUmW9eE5uJQaejq6T76AIE/W2x39bhjurrGJo+0yCGgVbuJ/
	fiAL/tkZYPg2X5m2Q+Ij2TE0uwq3GVxmpMU8=
X-Google-Smtp-Source: AGHT+IEfL619SyC1+cdaGsmUocbRTAVJxu/dIdY3si+OjEqI13EXjoTZU2/B+PVos8GkKWowCPQq8Q==
X-Received: by 2002:a17:906:c154:b0:ae0:dfa5:3520 with SMTP id a640c23a62f3a-ae6fcbc353fmr777254266b.31.1752331701556;
        Sat, 12 Jul 2025 07:48:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:b2ad])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e82df56esm494896066b.156.2025.07.12.07.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 07:48:20 -0700 (PDT)
Message-ID: <1aaef260-08a2-4fd1-9ded-b1b189a2bbe4@gmail.com>
Date: Sat, 12 Jul 2025 15:49:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: add IORING_CQE_F_POLLED flag
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-4-axboe@kernel.dk>
 <7541b1b5-9d0d-474a-a7d9-bbfe107fdcf1@gmail.com>
Content-Language: en-US
In-Reply-To: <7541b1b5-9d0d-474a-a7d9-bbfe107fdcf1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/12/25 12:34, Pavel Begunkov wrote:
> On 7/12/25 00:59, Jens Axboe wrote:
> ...>       /*
>>        * If multishot has already posted deferred completions, ensure that
>>        * those are flushed first before posting this one. If not, CQEs
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index dc17162e7af1..d837e02d26b2 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -235,6 +235,8 @@ static inline void req_set_fail(struct io_kiocb *req)
>>   static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
>>   {
>> +    if (req->flags & REQ_F_POLL_WAKE)
>> +        cflags |= IORING_CQE_F_POLLED;
> 
> Can you avoid introducing this new uapi (and overhead) for requests that
> don't care about it please? It's useless for multishots, and the only
> real potential use case is send requests.

Another thought, I think the userspace can already easily infer
information similar to what this flag gives. E.g. peek at CQEs
right after submission and mark the inverse of the flag. The
actual impl can be made nicer than that.

-- 
Pavel Begunkov


