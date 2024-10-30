Return-Path: <io-uring+bounces-4202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 319499B63E9
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D6F81C20DAD
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D274962C;
	Wed, 30 Oct 2024 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jk4/z+/c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B042B56B81
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294317; cv=none; b=i/q/dvvrEcQDolvZf/kROLGd+g6S9Sd1GridXksupgyffxNCAu+Vh0h0nSjUMLwUM16fj0SLWUnN2bXa2g3VU5KP1jEUfmxLD8MWp8HW4JcxWOqXpsQVMvd+9Lkp6kFtu7TNwR/joqRAwvkpdTI+AG9c7uD6o2Q1OPUHhOlT460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294317; c=relaxed/simple;
	bh=LIfyOYBgyE8jPsonsO08s5c9H+51CaQ9ZQOxZcP2fng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t+lb6fUYYFa207WWCNcUAtA5XjKRwVPfXotwxxW2lZ7BImNpd9U+OfbmRp3+gm9t3jYGfEZWw0uHR7Waxc3S/sbCIpiwBMAnUSviOhDKyOyITHZJr39R01++cQbP6Yxk7rqQMCG1fDDw779gCZrx8aJxhPXY2eH8w53IM0oI9p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jk4/z+/c; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83ab21c26e5so267102739f.1
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730294313; x=1730899113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JbPVVJaMvOc+4INW8+OHxJGLahkSjh9QTxtTCPjpo+c=;
        b=Jk4/z+/cRfqHc907PcOHn7u7TDRgFYIUiJ7fc+HXhMdU2fH/M96a9VkfwnE0JxwaTz
         P0jVJXkY0B3pdrTruAwykyN07ZRHVSbYK9Xb46oMS6X/kJrq9mizzHWKNJrL3RjRNlxT
         /bzC++3cfL+rh8EStahPrUQYGALeJQ6rPo5/nd2yAf3ZWXGouMImrQOvHsRLc78gnSGl
         fqzZRD84DcXwNeiUWiy/ZEYpsaC3qIXtDVq7ZNs39lGoGysgKXdmQ0F+K2eDHGPW7j7R
         a2WJ6rikBiTK4eoG3fn//6RWFBhxCfpE/A6G5ZeOpG6WmOt5bXgiAME4DBJ3c9ZEflMc
         2HkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730294313; x=1730899113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JbPVVJaMvOc+4INW8+OHxJGLahkSjh9QTxtTCPjpo+c=;
        b=lQJ3T0z+PBHUH7RC8VYD03fcWNZgJA2xuW3gyOAXVXT3gaXC0nO4Wk/V9qT+bjjE6u
         Mr8HtSBlqFB6x/dlaw0788uJEfzNoag4MbxtLny1AdjSEd1cVgPhYKwajDdfnASEC4Tr
         kBp8Rm8lXkjW9jV3LeyRHKNaDdj0gPI2g/VNJauEHHRFqeonNMxlcl9gCDdxE5WVk0C5
         LzcfP6HeDdL6wspqR/qYfs1HTT/4wpVfOrVTSmU1sUTSy0smn7m+ONcv76EojYn5K8Uq
         VbDuLLiDpeFSCcQXUNBXoJ2T+V1mgDymrz5J47IK+OKrOwdMUl2il4doo015TDSdLHhO
         hMEg==
X-Forwarded-Encrypted: i=1; AJvYcCU6txf+VDApiTI1cIwcRC2f7qCbANYHoGPVx1KNLRhH35zH3gCQs/aUg3xSGKNigTmd/ROw8ojh+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxbW8JhL/rRwMJxg2oWhgLwIgXfTqmwvdshuSQZStrchqJLrHr
	bsw4cDi5C1bar0sHJ1Ul3ZTtA+fwUP/wh/VqKewYJNwKmHIzBECJToAuFMjEIFkiLB31x9uwqvY
	d
X-Google-Smtp-Source: AGHT+IFeYkMmJiLQVWGLDQxAreKEJFM0zq4rMPkoENhZDxKn0gaCn/p0Z8uQAJ7bKgC1KZgSvkrurA==
X-Received: by 2002:a05:6602:2cd0:b0:83a:7a19:1de0 with SMTP id ca18e2360f4ac-83b1c5cd847mr1840162039f.14.1730294312634;
        Wed, 30 Oct 2024 06:18:32 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725ea578sm2901604173.21.2024.10.30.06.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 06:18:32 -0700 (PDT)
Message-ID: <ee56b950-55c2-47a0-97e0-b781ec804106@kernel.dk>
Date: Wed, 30 Oct 2024 07:18:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk> <ZyGjID-17REc9X3e@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyGjID-17REc9X3e@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/24 9:08 PM, Ming Lei wrote:
> On Tue, Oct 29, 2024 at 08:43:39PM -0600, Jens Axboe wrote:
>> On 10/29/24 8:03 PM, Ming Lei wrote:
>>> On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
>>>> On 10/29/24 2:06 PM, Jens Axboe wrote:
>>>>> On 10/29/24 1:18 PM, Jens Axboe wrote:
>>>>>> Now, this implementation requires a user buffer, and as far as I'm told,
>>>>>> you currently have kernel buffers on the ublk side. There's absolutely
>>>>>> no reason why kernel buffers cannot work, we'd most likely just need to
>>>>>> add a IORING_RSRC_KBUFFER type to handle that. My question here is how
>>>>>> hard is this requirement? Reason I ask is that it's much simpler to work
>>>>>> with userspace buffers. Yes the current implementation maps them
>>>>>> everytime, we could certainly change that, however I don't see this
>>>>>> being an issue. It's really no different than O_DIRECT, and you only
>>>>>> need to map them once for a read + whatever number of writes you'd need
>>>>>> to do. If a 'tag' is provided for LOCAL_BUF, it'll post a CQE whenever
>>>>>> that buffer is unmapped. This is a notification for the application that
>>>>>> it's done using the buffer. For a pure kernel buffer, we'd either need
>>>>>> to be able to reference it (so that we KNOW it's not going away) and/or
>>>>>> have a callback associated with the buffer.
>>>>>
>>>>> Just to expand on this - if a kernel buffer is absolutely required, for
>>>>> example if you're inheriting pages from the page cache or other
>>>>> locations you cannot control, we would need to add something ala the
>>>>> below:
>>>>
>>>> Here's a more complete one, but utterly untested. But it does the same
>>>> thing, mapping a struct request, but it maps it to an io_rsrc_node which
>>>> in turn has an io_mapped_ubuf in it. Both BUFFER and KBUFFER use the
>>>> same type, only the destruction is different. Then the callback provided
>>>> needs to do something ala:
>>>>
>>>> struct io_mapped_ubuf *imu = node->buf;
>>>>
>>>> if (imu && refcount_dec_and_test(&imu->refs))
>>>> 	kvfree(imu);
>>>>
>>>> when it's done with the imu. Probably an rsrc helper should just be done
>>>> for that, but those are details.
>>>>
>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>> index 9621ba533b35..050868a4c9f1 100644
>>>> --- a/io_uring/rsrc.c
>>>> +++ b/io_uring/rsrc.c
>>>> @@ -8,6 +8,8 @@
>>>>  #include <linux/nospec.h>
>>>>  #include <linux/hugetlb.h>
>>>>  #include <linux/compat.h>
>>>> +#include <linux/bvec.h>
>>>> +#include <linux/blk-mq.h>
>>>>  #include <linux/io_uring.h>
>>>>  
>>>>  #include <uapi/linux/io_uring.h>
>>>> @@ -474,6 +476,9 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
>>>>  		if (node->buf)
>>>>  			io_buffer_unmap(node->ctx, node);
>>>>  		break;
>>>> +	case IORING_RSRC_KBUFFER:
>>>> +		node->kbuf_fn(node);
>>>> +		break;
>>>
>>> Here 'node' is freed later, and it may not work because ->imu is bound
>>> with node.
>>
>> Not sure why this matters? imu can be bound to any node (and has a
>> separate ref), but the node will remain for as long as the submission
>> runs. It has to, because the last reference is put when submission of
>> all requests in that series ends.
> 
> Fine, how is the imu found from OP? Not see related code to add the
> allocated node into submission_state or ctx->buf_table.

Just didn't do that, see the POC test patch I did for rw for just
grabbing the fixed one in io_submit_state. Really depends on how many
we'd need - if it's just 1 per submit, then whatever I had would work
and the OP just needs to know to look there.

> io_rsrc_node_lookup() needs to find the buffer any way, right?

That's for table lookup, for the POC there's just the one node hence
nothing really to lookup. It's either rsrc_empty_node, or a valid node.

>>> I think the reference should be in `node` which need to be live if any
>>> consumer OP isn't completed.
>>
>> That is how it works... io_req_assign_rsrc_node() will assign a node to
>> a request, which will be there until the request completes.
>>
>>>> +	node->buf = imu;
>>>> +	node->kbuf_fn = kbuf_fn;
>>>> +	return node;
>>>
>>> Also this function needs to register the buffer to table with one
>>> pre-defined buf index, then the following request can use it by
>>> the way of io_prep_rw_fixed().
>>
>> It should not register it with the table, the whole point is to keep
>> this node only per-submission discoverable. If you're grabbing random
>> request pages, then it very much is a bit finicky and needs to be of
>> limited scope.
> 
> There can be more than 1 buffer uses in single submission, can you share
> how OP finds the specific buffer with ->buf_index from submission state?
> This part is missed in your patch.

If we need more than one, then yeah we'd need an index rather than just
a single pointer. Doesn't really change the mechanics, you'd need to
provide an index like with ->buf_index.

It's not missed in the patch, it's really just a POC patch to show how
it can be done, by no means a done solution! But we can certainly get it
there.

>> Each request type would need to support it. For normal read/write, I'd
>> suggest just adding IORING_OP_READ_LOCAL and WRITE_LOCAL to do that.
>>
>>> If OP dependency can be avoided, I think this approach is fine,
>>> otherwise I still suggest sqe group. Not only performance, but
>>> application becomes too complicated.
>>
>> You could avoid the OP dependency with just a flag, if you really wanted
>> to. But I'm not sure it makes a lot of sense. And it's a hell of a lot
> 
> Yes, IO_LINK won't work for submitting multiple IOs concurrently, extra
> syscall makes application too complicated, and IO latency is increased.

It's really not a big deal to prepare-and-submit the dependencies
separately, but at the same time, I don't think it'd be a bad idea to
support eg 2 local buffers per submit. Or whatever we need there.

This is more from a usability point of view, because the rest of the
machinery is so much more expensive than a single extra syscall that the
latter is not goinbg to affect IO latencies at all.

-- 
Jens Axboe

