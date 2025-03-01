Return-Path: <io-uring+bounces-6889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2354A4A804
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 041EA3A6B39
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB981E49F;
	Sat,  1 Mar 2025 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M4/5VZ5B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED3023C9
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795792; cv=none; b=BApnLKDyz2Y1WBzXmeJLJmC2FVcWmPHd9WtF1rTdYow4n1vFYOuVNIAyM+xA2ZV2LaRG5UJoF9MIPFMYnqtOEv0iDUZJmgGHFMZxG0yH3hZG3Nqgj6wCjgxRArUBFfDFv+PhgfGfe4Qp4pAsCq+IJs0C/QmMrDisiM5NSkFbiDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795792; c=relaxed/simple;
	bh=dN7+jbLvdrjoCYACNXJOboSenKJHSzfm8DdHlgv5eZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A68xjnpcne6S42cB5pJyL6eGpgNK/4HobO4Py70Xv59VjakyZ1MfHobT4FK5FVRBxMAPsnBps2I7YeaaC12lkpyChlJz1M4BI53J7Y8AendbRKqCvSScoN4afyrN/Ya/fT8CX0rA8KrzljIX4MlqUKiXrJyLl/gVK5DLgmiELxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M4/5VZ5B; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e549b0f8d57so2406585276.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795790; x=1741400590; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3D2yUW+yXVZtZOlbSSXTDdpZguZmzr8vchGBhO965wE=;
        b=M4/5VZ5BdQ24KHJufBzAW6ar0figzzxTaDowflwt4U18FOUcwsdLZ7ffBQDXsHHpWM
         UXzVW8HHdQuiFKWcdqaGUy1qdxXgUoLdEESONrA5TsDVgjJjM1fEuBr+rRlwHdZRbPqd
         QIYT1pkSI7miYAu6KjqAAYgt9TTF6uEZlFUY1fH+UBn5gvKRhj9QmmdfK6GIy7lj4gRK
         xeEKLcpSVB2IEmxgGHiWQAQU8y/wYgvpnmNoomFS9J2NT5LUiS2/LMqtWVcfBTRsBMua
         DFWYAbu+9q7v9W6QbmmpSqub23SGcG8Gagvmf4hrgmQUIMnssk9CVJxKf2mXJI3hxMVr
         2cKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795790; x=1741400590;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3D2yUW+yXVZtZOlbSSXTDdpZguZmzr8vchGBhO965wE=;
        b=ck7a9WFaNtTVC0aXwDWRDY2VSmW6Xnp4wSCxMrPiJQhR9+Wm2XmajxM9b2xHVSWfDA
         Qf+pTHxdx3WApXjZpb8+KlLIybmbtVwiRtRBNEEgwwgVVPjnnBnDZWT5x7431zd+fTtO
         Tk+F4l4EqQDkUEGJy5PIGuDxmijzcJ+hCiBhRaNyIHhLd+7g7qNJVELKnEpvwv7MBkj9
         5qvCUJcaVzmdPpZxjwsjSW34Woi+Q5Gn5DViz7VIMpPeRJDw+Xz/YqT7FP4lzlryuQ57
         t1XTAJVOUwWYNKIZLGMM9XugpsirwWFKdWDZ6baZAkJV0zPQ6//1cbQoGSmjQTpQDnaW
         UXMw==
X-Gm-Message-State: AOJu0YzYsMKBrhP6E1briL6/h9jGu/lJ22wu5E6UKDkj3HtwUZvxfFZL
	l1Nt1fQomDuoLm/bc/vJ+NXivuE358TN01gK4ImV2r5KfKmILeD1Nom3vPKeGcs=
X-Gm-Gg: ASbGncsuSNXEidTZRDNJy0uWPHJAp7SVBuAOE2IS1q+c/frkaBCFH5hXnD9+JRZsQrU
	PoVyw58pk9OmKWrLDBkHfZhZM6m1mbHr/FGhpSMkNxP+Ehi9nqa4jUzMqqhHRdvfM45gQevHky2
	aXwKHj0zN+ZNbDQPLAhB3LU1cGDQVAF45bOM4cYY9eOkYJDVUxP+NfxMGQ1foCw+c5R4u9uY3Ht
	uaVK1lnLENauc11T4qmKT3MQ1xP6iN977jPkgGaGxO5//I4ZUT63VdSmzm37ckP3B24fKWe7vNs
	0bEhVWwTqYcQ0lC4JgO0yY8cb4LeMUSwxqG4GSRFA6bU
X-Google-Smtp-Source: AGHT+IEQd7OduGMWpWQcg+VgSc9gz9FauvM9ADdGsZN+Br4JB6r2A4KMSGBo1Ww+P+YbAJSnRG/Ecw==
X-Received: by 2002:a05:6902:114f:b0:e57:f8cd:f0a4 with SMTP id 3f1490d57ef6-e60b2f3eab7mr6108309276.34.1740795790027;
        Fri, 28 Feb 2025 18:23:10 -0800 (PST)
Received: from [192.168.21.25] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e60b557d2f7sm777899276.1.2025.02.28.18.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:23:09 -0800 (PST)
Message-ID: <7d64216e-4bf8-4557-b8a8-7285f161a2a7@kernel.dk>
Date: Fri, 28 Feb 2025 19:23:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring/rsrc: call io_free_node() on
 io_sqe_buffer_register() failure
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250228235916.670437-1-csander@purestorage.com>
 <20250228235916.670437-3-csander@purestorage.com>
 <f74d6e16-29fb-4a9a-a6aa-9a7170c683ba@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f74d6e16-29fb-4a9a-a6aa-9a7170c683ba@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/25 6:31 PM, Pavel Begunkov wrote:
> On 2/28/25 23:59, Caleb Sander Mateos wrote:
>> io_sqe_buffer_register() currently calls io_put_rsrc_node() if it fails
>> to fully set up the io_rsrc_node. io_put_rsrc_node() is more involved
>> than necessary, since we already know the reference count will reach 0
>> and no io_mapped_ubuf has been attached to the node yet.
>>
>> So just call io_free_node() to release the node's memory. This also
>> avoids the need to temporarily set the node's buf pointer to NULL.
>>
>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>> ---
>>   io_uring/rsrc.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 748a09cfaeaa..398c6f427bcc 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -780,11 +780,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>           return NULL;
>>         node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
>>       if (!node)
>>           return ERR_PTR(-ENOMEM);
>> -    node->buf = NULL;
> 
> It's better to have it zeroed than set to a freed / invalid
> value, it's a slow path.

Agree, let's leave the clear, I don't like passing uninitialized memory
around.

-- 
Jens Axboe

