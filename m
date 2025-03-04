Return-Path: <io-uring+bounces-6931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56EBDA4E0B8
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EDE63B3A2E
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 14:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A38273F9;
	Tue,  4 Mar 2025 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yqmq6+YU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F084E249E5
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097972; cv=none; b=d71A4++cGCuubR1iWlmhRhxgBl9/ge0AnvNn5G/BpAdysU6wBp0DH9c2AM7DeCJUmmyJuEBvGNNAUlXTkmsKObnG+t3ry2v94FNYqhp8yfADRpjFtCCfQLudZvHgYS+pisNIIIfLgS/XIK+5inzMOWw3Lj3PZXZ4qtSqnHdmbV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097972; c=relaxed/simple;
	bh=b0jSvBSYYtCQYPsiv50IabooFbiJx/XYyCZCorGnVgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mUCQllN+IxLT1RrdSBuMBIvMlNXlK6D0t0tlSKCIMSfT5m8ldM8eBZd6zALhXiuexL1t5MW6Dn9HeIYnH6WXNhoSVIjw2Wp23P99Y4YfWi1KnlRKNWDgfpS8v/qGE3+TQxfMGuWA8KqhG6u0Oud3P62rTynYHVOwrSktXVf0+KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yqmq6+YU; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abf5e1a6cd3so516391666b.2
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 06:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741097969; x=1741702769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lo0Q5BRfGD+PtFpLW33HM+7KkReOcly1dlugDnT8TNk=;
        b=Yqmq6+YUhaCV7xXejqtkUGBocT/ySmADP1Kr9/jlPlu8cUImWpX0wTNfh2yOZjMbHH
         J+PtpK7QMj8mykLdh6EwwCOZRKSEaa9MQStmcwfeRXMpkb2flPoEFFm1qks+xmPcZoFS
         dmlLAw0c/3k9fH2ubjHfcjxSKgvvE+7p3FN4WCWEM3E290kVut95TaEl+taf+bE7UggY
         rX4LMMyzZtC3K1Rw6v5MU1YP7SYyZaU2i/PSnuA0XMoLB7yx3BTdn+bqDbPH78ziTQxH
         0iMFxACKGqJlqTBn5w/zYCArOZgW6S3HMy3LNFyFmVKN5qHyoQ16+s9+kY+sSUd4rEfY
         jQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741097969; x=1741702769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lo0Q5BRfGD+PtFpLW33HM+7KkReOcly1dlugDnT8TNk=;
        b=HYpHDZxlxjR8yxRRb6915dc/yvNSZh16q2MJRCmYn1YC5QnJCY4U36sppe8E7cTqB0
         853jy0SGodszDKHH5zpC1HFREgPKh/bTc6due21FAgsK2wXv0As3cTBJyJ6XzHd0wU3X
         Hup6s0wUp7t6wFFAdLdTx2/HadwaSScaXoTS95qxChuosuIDhZ4qvSDhGVPNMsOpu6qE
         bJaMw3XpBFJ4R7WRN03ujxAh6V0C+kq/cw/tT5bwyuBCUZDT6fYZo10Ofy2Q0G0pj0g5
         dZwvK/yX6V2CQ38k2G9hpoeXDPcVy9lGJqAtK2K4DZpHDfSo051UD56ffe9TeG/xOYj/
         83xQ==
X-Gm-Message-State: AOJu0YwZF6ctiX9f0wf8qry5bDWu04FMYE3sE7PaCQwGTyaVZwombvLY
	4BnZfSVgJ5uQmiQ7rCkN8dKmurO98ctn+R0BKY7wc4bUcE3Rm0rH
X-Gm-Gg: ASbGncsFWxA1tHUSLoBkIZqTO/xhkxss5wj3/splJj/zZipbKLOaZePMOB2yPy9CQzF
	hDExKQ3MVF4XL0jd9UldvsRJcPX/Lu6hUcQD/9mijtj2RYZNWFYIWBy+y+0MfbQDn63DzshytDL
	fseI6zwuad6sRqPP5Bb4FwZq/PlCAkKb/mCdvt5aqBXboJtrmQM1lSKiq+1j1uPuwYwjbRxXVlL
	9csxAMOmRa9IJYZc+ZUMejrV96jJCHv0GRvSPjmeW6lzi9GrntA4/qvgzdB3NbylJMKxbs1dhJC
	VTcufDFYNdfd3O6kgkSUrmMCGXU16Cui5boOK4DI1xZ/6o1iWOV5Uhey75ftFTPnIc9L6ArbA7x
	oSA==
X-Google-Smtp-Source: AGHT+IEbbLsnAzFEhxqsdBWvbBXnVqcC1dSK/urihPvdf8NUpsqKNNeju1XL+BC8VjqkrWEnSGUc/w==
X-Received: by 2002:a17:907:3fa7:b0:abf:64f9:1fcb with SMTP id a640c23a62f3a-abf64f97986mr1305799766b.30.1741097968919;
        Tue, 04 Mar 2025 06:19:28 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abfa393dd6dsm323768666b.96.2025.03.04.06.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 06:19:28 -0800 (PST)
Message-ID: <f0490adc-ef8f-4409-a143-529555b96d26@gmail.com>
Date: Tue, 4 Mar 2025 14:20:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Add support for vectored registered buffers
To: Stefan Metzmacher <metze@samba.org>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <CADUfDZqrXsdnwT=W3HqaVUeegY0jee4G4YztancBfsNBXMKWOg@mail.gmail.com>
 <f5f1571e-d2b9-4675-9bc9-f5bc95fdff3f@samba.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f5f1571e-d2b9-4675-9bc9-f5bc95fdff3f@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/25 12:12, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>> Add registered buffer support for vectored io_uring operations. That
>>> allows to pass an iovec, all entries of which must belong to and
>>> point into the same registered buffer specified by sqe->buf_index.
>>>
>>> The series covers zerocopy sendmsg and reads / writes. Reads and
>>> writes are implemented as new opcodes, while zerocopy sendmsg
>>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>>
>>> Results are aligned to what one would expect from registered buffers:
>>>
>>> t/io_uring + nullblk, single segment 16K:
>>>    34 -> 46 GiB/s
>>> examples/send-zerocopy.c default send size (64KB):
>>>    82558 -> 123855 MB/s
>>
>> Thanks for implementing this, it's great to be able to combine these 2
>> optimizations! Though I suspect many applications will want to perform
>> vectorized I/O using iovecs that come from different registered
>> buffers (e.g. separate header and data allocations). Perhaps a future
>> improvement could allow a list of buffer indices to be specified.
> 
> I'm wondering about the same. And it's not completely
> clear to me what the value of iov_base is in this case,
> is it the offset into the buffer, or the real pointer address
> that must within the range of the registered buffer?

Same as with other registered buffer requests. It's a pointer into
the initial buffer you specified when registering it, which serves
to calculate the offset.

See the io_uring_register(2) man, addr and len are iov_base and
iov_len and there are multiple of them. You can call it confusing,
and I'd agree, but that's how it was done from the very beginning,
so staying consistent here.

https://github.com/axboe/liburing/blob/master/man/io_uring_register.2#L87

  
> It might also be very useful to have some vector elements pointing
> into one of the registered buffer, while others refer to non-registered
> buffers.

See the other reply.

-- 
Pavel Begunkov


