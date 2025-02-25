Return-Path: <io-uring+bounces-6744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98017A441BD
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 631443ADB38
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCC3269CEB;
	Tue, 25 Feb 2025 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfIWmTS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8C12676C8;
	Tue, 25 Feb 2025 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491968; cv=none; b=neXG2zp6fCNtidqz9udQjHB+y5f5YttGwyFzqw0KOYwCZ8qFQxwXmu3FQHeQffk89/XnHYGurxX1xHDGnYTslGg+tVzKhEOrZ/xg9Ly+DfFiyZ8l7vqH6ncBTeSIebr+q6C/xS9zSU24/cI8aQ77eGlKzSzTQn0KZji6Oil7umk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491968; c=relaxed/simple;
	bh=45QP3a1auX2JnehwthIAfoRSxbVt3FASUCf/nt1GM0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N+IDhvjnVviOdQ9ZZHUw7zkP8lFGeEZP2k0wY40lboGJlvZIWmNbloSxVtckZ0lnOQoksApoOo7aT0/QsPveAJDKCh7oMnqLuCEq1BvRnpEZdYzC7dDLuyPRQFbOm8V+3Pw37zv/IxT66ov1mEZWsEIpAd1aU8Eay+sFEQ6tOKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfIWmTS8; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e04f87584dso8494475a12.3;
        Tue, 25 Feb 2025 05:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740491965; x=1741096765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=95TxQ7cGlE0J7PaGWaN1F3rVAmIHV9QlKvddRq6I7QE=;
        b=JfIWmTS8KqRud6nkF7nx+9/FzNT3PxoOrPzH/J9khY7rv7OtXpW4f8AcVlrV30Cg6y
         MLlqfTev9rZDtHntRWJjz3hkB1S60Lu93D5GlBg/7wlPTjuX5cNlwXHIse7XSi0FsAKP
         c4j5HM96HQwWcV1UONWHV3p3iU59GNotXEK0H49Z1/r7UYxk2MBLkVkzkxk6oGTIAf6/
         zr/kahq98w9y9dFeuABuXmo3Y85OV+dhZ0EhLDK5TRFp0KjT0fImP2I+5vmim9/RdyXn
         WJwGbG2Hc7DXi1ncTkAZBxu9/f+T0rf8X/J32ieePCtPHGqCsVPs2ZFEI99SAHF7JP8q
         inrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740491965; x=1741096765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=95TxQ7cGlE0J7PaGWaN1F3rVAmIHV9QlKvddRq6I7QE=;
        b=iWSguz8eUHU4MK9j28bdaPh/bznXw/YLNvlrEHC3PmqYJBCbIOf0rfIqgTtCoiJ3Pw
         nC5FfLw2OPP291VYU4OqPqq322225Bq1tTDX43uPWqnqnbqcbb0RYM+GQvWFsj4fdnW9
         y3h/3WXX+DOhSQoWTO8Yd+DOHabHZPKsQzOV2oFafUWeru8N4eBM9q9pwo4Sj3gLJHIp
         emMX3FvqdG6WQKnQxge7hiHkKPx7+aMnIO/xNSnYc3IBGc/eIltO35GG6Oc4BUgHwB33
         1k3YLDG5jhXhmBjxsduZWjUWOG10CbB3EU6Kimu4KVuD6HyaCXnJXyYZeNXAkw21WMnm
         AMsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3BV5JPFvgJ6EENXBaIA2Vdr/f0Ux+Pwbn+aGwMSV4VEfV0kYW4Q/S6IAvv4CHEPth/FtkjGf97A==@vger.kernel.org, AJvYcCX5tLpKVPVnoYlqWpiAOupNSUfBMMs6bSaJX5d9nL3KPfLFgnx2XxRL7svSedcTfQJ8XwInyBrdbShFH6s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr0s1tNnU5pM/Mw+FTUiNUGmhJX3AlLGnnxGeUNzR24IasoqiU
	o6wP0gJXU9g9Coykjh3Z43XGcl/ZDz99sYcsvWlW7zvMVGRfyOSy
X-Gm-Gg: ASbGnctI4gyV4q73EcyOKQ+C15C/x0xpxQ1T5xKr/WvDOwX5ekylH8gzy0eDxy3Q+uS
	4Dv0nunkveYgc0m1NCIcGog6Vm4pgjJ1wkzOnqj64ig92mNqGvOjlGRVYYOSE2GeXTo7V58pEVy
	y3Lw0Rjr4yBmKYwSxq8t9jcwcObZKb3FqBbf/E/scaTrNGy+or9DjmRhyguddd1/8Q1YYZUm+QV
	03xPrS/o5s2LJHQRAT0T50iwY2Ana5iHvbS0Oo+oCutbDLtyTs0+9G1lC0RvzwY9OC43lfdiVqH
	vp20748yNjoxELKP8qDNCvCQGCjpqa6VGDFQg1tmGTj2LktxFkS1pXIXDUM=
X-Google-Smtp-Source: AGHT+IF3QH2cuFjEPHQR69wWryDGkjEDdOrNrN6Esfkjbyd/DTvYqT3Lngr5WueWGTx2OOFWHd/zDw==
X-Received: by 2002:a17:907:770a:b0:aa6:832b:8d76 with SMTP id a640c23a62f3a-abc099f0e42mr1687461866b.12.1740491965377;
        Tue, 25 Feb 2025 05:59:25 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1d552e7sm147258566b.48.2025.02.25.05.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:59:24 -0800 (PST)
Message-ID: <67cf1bf2-9338-4d02-a1ad-db25d3eaed3f@gmail.com>
Date: Tue, 25 Feb 2025 14:00:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 07/11] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-8-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-8-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
...
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index f814526982c36..e0c6ed3aef5b5 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -9,6 +9,7 @@
...
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
> +			    void (*release)(void *), unsigned int index,
> +			    unsigned int issue_flags)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct req_iterator rq_iter;
> +	struct io_mapped_ubuf *imu;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv, *bvec;
> +	u16 nr_bvecs;
> +	int ret = 0;
> +
> +

nit: extra new line

> +	io_ring_submit_lock(ctx, issue_flags);
> +	if (index >= data->nr) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +	index = array_index_nospec(index, data->nr);
> +
> +	if (data->nodes[index] ) {

nit: extra space

> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
...
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index f0e9080599646..64bf35667cf9c 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -20,6 +20,11 @@ struct io_rsrc_node {
>   	};
>   };
>   
> +enum {
> +	IO_IMU_READABLE		= 1 << 0,
> +	IO_IMU_WRITEABLE	= 1 << 1,

1 << READ, 1 << WRITE

And let's add BUILD_BUG_ON that they fit into u8.

-- 
Pavel Begunkov


