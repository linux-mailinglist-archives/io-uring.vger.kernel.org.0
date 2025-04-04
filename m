Return-Path: <io-uring+bounces-7410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E94C8A7C61E
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 00:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3A503BC850
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 22:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FEA1465A1;
	Fri,  4 Apr 2025 22:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0s+Ewqo7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E81A13CA9C
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804067; cv=none; b=CgQkB2XNfYb9Tu/7TDb+tYSXqmMiy2l0UbzbQQOWJ08iedZyL39+RHV3/BeEA0p/kgtcb/CSAi7Hm0HdJK51G/ha3LHSADK+u8IdNhLw9Sm6V85QbOQ1665OrSnatXKzjS3MXd/EnWnDyKCrdzAegR36DwCtBXBAiMS+PtmCl08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804067; c=relaxed/simple;
	bh=p3lcfYXr5W2oi11LEVAz+y4j+OFt8NRKaOORdR59m9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Dy7lh0vr6Cdono0FU/SABM0iFhq4r600650+UQexWxy9jzzMIkHhvkj7fTYBZks5Tg9uZNxQa2By57PM4W8SVJZFekoLiWR+scgRwHgyExGtacoxMnH0THhoVdBFdJRqVWsqrBqwGQBZsDvboZUy/Vjg4wM8Y0ixwS0y4yW+148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0s+Ewqo7; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85dd470597fso80030239f.2
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743804061; x=1744408861; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HrAntusGgLvJSmelDrM6T1SWwVtmIi1whnAcEYiAbaE=;
        b=0s+Ewqo7PcodbEmHwBn/50oO5TDYTYL6Mc7cBIhA75YqLqv8lOZFKhx+th3jVReNTB
         /TndvpS5a8ZutuhQHamWxTE7AMeVKNEpfI04i3ayn8RsDAfzVyO9NOziLmD6N4kKFClB
         mPLBLxPKm5SySIZbz9eEYOgd5hCluTpS4TIS6oBiMpCPmF3lI4yerHVZUTHkRP7Kgvzv
         NDCmkR42cfBtWxTDUpCpN43mYjvgJ0DYcBTXYGCoSdtCBYFkX2nhjZMFAMh5CsxTglYX
         XhpOMRUcIOIIHo6q5j5sNF7Yx2PH0iteak9xX/cjY3g/KEg3u9OnfWtKMqnqvpL4SX3R
         yb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804061; x=1744408861;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HrAntusGgLvJSmelDrM6T1SWwVtmIi1whnAcEYiAbaE=;
        b=EgZZ9C5QIp0laQQfRuM/93fjJwtBDIMbwDTvySLVDe7WRfGdm2rJb7bctHFFv7TTj4
         UEaM+620KmYOy0P3ov6sk75aJqv5acCyZAggdygsADNb24uDALtl6mLiYjFB66m1LYi0
         92jNBcFvw7yGUWjVJiV06U1b6QjuX/XJZIN/Z7q6zJy5060q8AO4dcEffiqnAAnMBM0V
         1Corf1ro+oYqZYg/uJEJA2sGH8fUJBgPJS9vvgamhilpnF0EOUIiApcks7PIfMx/CgDu
         p6ZGO9wf18+K/mZBBMeU7lXWr1dZsLw6vn0YNdMvLc/fVcAX2HrH3InssHOiKLGdGNOz
         HlZg==
X-Forwarded-Encrypted: i=1; AJvYcCXnG9JIrLUBpHKeYYbe7ODoN9OZseD8yASgZIKjolYocizdl/dOosmX0cQxO5ySp7Naqhx4EdBoVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOOB5Ohon3ywmg2ySghrn7fM8SVXzZWclAnsEDwathcSDqohWv
	YczQfw7VuLFC4qi8TQ1dGz6Bf1ZwMp1gBg8/0uLFNU6sFkCjTfJToezVIQ+QCRk=
X-Gm-Gg: ASbGncuY8+DEfJrlKyA7FKzDLJjvCki95hTs2nU6kR5ktK/9BegYMYETh6/oapbFMEC
	+HaCwlOQHdF3yM9Uhfp8yRiiXHXqQoIa24N10VOP5Jai72E1MdV7qaxLaN7paupQ9SylkC83POC
	5jGlSMnuO9YHaU3PWxeVPXX9lZe1sqY53T1C4s4Y/v6prvumZ53XNv2wLZfVn9qo8FT6BeE20R+
	gX8IVuzZSd/aM/qlwl1GK4jblJK18v8bpNe15pwMLlFThJsmuBGxhWYZVAbCuDFQpn88TPASO5z
	nZLPkecMJiW1CuDva7RubC3NFraPTpUlwmw0m6MfsA==
X-Google-Smtp-Source: AGHT+IFPxBohqz/2lAHCcq0/kzT02uOyVi1k949z4sDeiIgHqLdzcto9DBTt9LT+QqKmpNvtGxFifg==
X-Received: by 2002:a05:6602:3e84:b0:85b:41cc:f709 with SMTP id ca18e2360f4ac-8611c3f5521mr617911939f.14.1743804060904;
        Fri, 04 Apr 2025 15:01:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5d53d0dsm1000057173.135.2025.04.04.15.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 15:01:00 -0700 (PDT)
Message-ID: <3783abbf-2585-48fb-b04b-9206ade7f22d@kernel.dk>
Date: Fri, 4 Apr 2025 16:00:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring: reuse buffer updates for registration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1743783348.git.asml.silence@gmail.com>
 <8996ffd533db8bd12c84cdc2ccef1fddbbb3da27.1743783348.git.asml.silence@gmail.com>
 <1f12d9bc-b20f-4228-af96-a5c885f255ee@kernel.dk>
 <609ff085-34a2-4b3d-a984-57ab2f9fcad6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <609ff085-34a2-4b3d-a984-57ab2f9fcad6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/4/25 3:38 PM, Pavel Begunkov wrote:
> On 4/4/25 17:38, Jens Axboe wrote:
>> On 4/4/25 10:22 AM, Pavel Begunkov wrote:
>>> @@ -316,17 +318,26 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>>>               err = PTR_ERR(node);
>>>               break;
>>>           }
>>> -        i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
>>> -        io_reset_rsrc_node(ctx, &ctx->buf_table, i);
>>> -        ctx->buf_table.nodes[i] = node;
>>> +        i = array_index_nospec(up->offset + done, buf_table->nr);
>>> +        io_reset_rsrc_node(ctx, buf_table, i);
>>> +        buf_table->nodes[i] = node;
>>>           if (ctx->compat)
>>>               user_data += sizeof(struct compat_iovec);
>>>           else
>>>               user_data += sizeof(struct iovec);
>>>       }
>>> +    if (last_error)
>>> +        *last_error = err;
>>>       return done ? done : err;
>>>   }
>>>   +static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>>> +                   struct io_uring_rsrc_update2 *up,
>>> +                   unsigned int nr_args)
>>> +{
>>> +    return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, NULL);
>>> +}
>>
>> Minor style preference, but just do:
>>
>>     unsigned last_err;
>>     return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, &last_err);
>>
>> and skip that last_error could be conditionally set?
> 
> I can't say I see how that's better though

I think so though, it makes the store unconditional and there's no risk
of anything forgetting that last_error is sometimes valid, sometimes
not. The last part is the most annoying to me, it's just more fragile
imho.

-- 
Jens Axboe

