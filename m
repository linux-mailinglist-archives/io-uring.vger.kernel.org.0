Return-Path: <io-uring+bounces-3373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CCC98DB60
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 16:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 131F1282943
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 14:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD841D26E2;
	Wed,  2 Oct 2024 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gq2HwgYe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCA41974F4;
	Wed,  2 Oct 2024 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879137; cv=none; b=lCAGxpIL+DW2/G7BSI08h/M3kqQxEcDTQ5vVKfa5ofqj5mPEY7YWHe1ccpXflu5yojo6CNPfI7qB10/FhABTvEky/kKA3bvRZdUp2B3r1hU2AgNKxyBPfNG3209fwq+J3swPyB4gR9+PLwFY6thaU3FZWK7zrsCwZ2l86Nc9NU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879137; c=relaxed/simple;
	bh=Mi6Y8fYW1SdsKPutfBdt+bZEFZSkGWP+Kc/xk5qu5hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C/L54d/NZ+gjoqi86Sb7y1EVLRmn1nFGyQWr3bzsPP9FmGEyrgnxzHqOUpo8yLbNAZ7Qy2u32EzICN2acPbvAFBT2xvxTsH56PScYXg+Czss9NWMNg25NbQXzQv0l+iQHm2nPhryQYbZy0zW2zG3YbDhjW2CEW7TI9G75ZlvVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gq2HwgYe; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7aa086b077so962235366b.0;
        Wed, 02 Oct 2024 07:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727879134; x=1728483934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Ffvu2nWYd/TtMPhyD4YwqAbLAjDY47YPXg3w4lrVDA=;
        b=gq2HwgYedW6djkB/8T4K7Van8xcM752Bh+7nZDcQ5R7Lgc4OuoBDrVFq/1BHKkJOuQ
         YbsnQRQjYGNRHYNNH/kekgvNkfr4lXYYk5LjpNZB2pgufKXXSmS7pFyQab/Jmam2luAp
         btcdW+43iTFnlSaObk5926Z1+8RPAuo3p0nqhwovkGMjUYx+ihPQRK/264GF9tJ4SXNq
         Tes5xm3U3UHV4bmIXiF8HoX5N5NOhZbZMqPNDmNdWcXcSEO4QB5liTMYt7+wo0BL8fWz
         Pzw0UVkLkbro+ATHYtvkjtNhcsVhaDfNbYrPtXQE4qSJnHbthbLKYc8dGqI7+3TnObCw
         0Gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727879134; x=1728483934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ffvu2nWYd/TtMPhyD4YwqAbLAjDY47YPXg3w4lrVDA=;
        b=VfhSyUThZaoYSbfHR2MqZPnkCUt49CTVU5qzLznOrpNiKWmXEOpkTwLla8mP+kNXBE
         Hbwb1yZMZOlfFOqYP5lm0lWrb7ELh5VV9lVaO0Y6Xw7f28FRNfBDz4ChJBmrZhVmE5YL
         RMhIQ5vsEUxuBj3943K/SIi9p/A9ha54WYoWr7tZp8l9y7mQ9ikp6fkDtYHW3OV/0lna
         D4sWKJ+y6AlnHUsA9i+t4aaYyuZD0h9yHRdAu8hRA5tSljMRQ5t0yVPR/ylPm9Jr+UTi
         EFx9R7Nf//doq15Zq9AVuls2RLcrCGL4xyPllKUDv16WfBFYW211DV4cX92fNxMElDp1
         vhGg==
X-Forwarded-Encrypted: i=1; AJvYcCUorVsY8MNmOlI1W2mn/jLxo3Qvlykw+wURp0x81TAMHHSgEtjU3hcuGsgydOfteTbZ8d/D1yT9cH/EGB0=@vger.kernel.org, AJvYcCVyrSnLo529TNcZutc21n1qEyGDX6ElgQ7b0VpZyzOSFKmJ820HtVVIgpIb4a5/ijdUwDSDWlrKfA==@vger.kernel.org, AJvYcCWp8UlRlq8wenLvomsqsgoicDBAnZVObFPmL03NVsPt6TzI1ya/B2Id99GrgOk6HXOa4V4ifEuivONxLY55Ng==@vger.kernel.org
X-Gm-Message-State: AOJu0YzL4FA78X/mFj+rZgBrjB0Bmg2K5RbngQeYNp0IX/U8Q64A7gm5
	CNMDr3QCOyquwzv5R0oGzk7LUhQQumOOR4Nu8rCVi8m8q3bHHu3J
X-Google-Smtp-Source: AGHT+IFvPj+ATYZr1BExZ+QKBSVAPTglcZEJzhHNqX4Kf54MmKEy7qHf5bA10I/1t1JMjnnnPOz7jw==
X-Received: by 2002:a17:907:7ba8:b0:a8a:6c5d:63b2 with SMTP id a640c23a62f3a-a98f8245134mr302970566b.18.1727879133514;
        Wed, 02 Oct 2024 07:25:33 -0700 (PDT)
Received: from [192.168.42.109] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c27c5b15sm870870366b.59.2024.10.02.07.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 07:25:33 -0700 (PDT)
Message-ID: <48c70b95-f0c9-44bc-8a3b-3010e8d682be@gmail.com>
Date: Wed, 2 Oct 2024 15:26:02 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] io_uring: enable per-io hinting capability
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, hare@suse.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240930181305.17286-1-joshi.k@samsung.com>
 <CGME20240930182103epcas5p4c9e91ca3cdf20e900b1425ae45fef81d@epcas5p4.samsung.com>
 <20240930181305.17286-4-joshi.k@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240930181305.17286-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 19:13, Kanchan Joshi wrote:
> With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
> all the subsequent writes on the file pass that hint value down.
> This can be limiting for large files (and for block device) as all the
> writes can be tagged with only one lifetime hint value.
> Concurrent writes (with different hint values) are hard to manage.
> Per-IO hinting solves that problem.
> 
> Allow userspace to pass additional metadata in the SQE.
> The type of passed metadata is expressed by a new field
> 
> 	__u16 meta_type;

The new layout looks nicer, but let me elaborate on the previous
comment. I don't believe we should be restricting to only one
attribute per IO. What if someone wants to pass a lifetime hint
together with integrity information?

Instead, we might need something more extensible like an ability
to pass a list / array of typed attributes / meta information / hints
etc. An example from networking I gave last time was control messages,
i.e. cmsg. In a basic oversimplified form the API from the user
perspective could look like:

struct meta_attr {
	u16 type;
	u64 data;
};

struct meta_attr attr[] = {{HINT, hint_value}, {INTEGRITY, ptr}};
sqe->meta_attrs = attr;
sqe->meta_nr = 2;

I'm pretty sure there will be a bunch of considerations people
will name the API should account for, like sizing the struct
so it can fit integrity bits or even making it variable sized.


> At this point one type META_TYPE_LIFETIME_HINT is supported.
> With this type, user can pass lifetime hint values in the new field
> 
> 	__u64 lifetime_val;
> 
> This accepts all lifetime hint values that are possible with
> F_SET_RW_HINT fcntl.
> 
> The write handlers (io_prep_rw, io_write) send the hint value to
> lower-layer using kiocb. This is good for upporting direct IO,
> but not when kiocb is not available (e.g., buffered IO).
> 
> When per-io hints are not passed, the per-inode hint values are set in
> the kiocb (as before). Otherwise, these take the precedence on per-inode
> hints.
-- 
Pavel Begunkov

