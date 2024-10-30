Return-Path: <io-uring+bounces-4183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 911639B5A09
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 03:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03CC4B21C0B
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D0BC19340C;
	Wed, 30 Oct 2024 02:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VkaCGFgu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FA7192584
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 02:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730256227; cv=none; b=b/BZ0rWL/HFXi2Ws/2QA+p1oON7J5NDVK2bBSnPS5Uwj9y148pDyw3H9Kchnz4Kq75ye0s7ZynVmvBJH/8D+g0epsOD/znxhS9sCo5xu6HHwEHeUBbRU/I2XncCtIo9pcVVwQzCK8Hotq3eQhAkGB93AvFaWgnzP+gR+8vAiVpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730256227; c=relaxed/simple;
	bh=kFK+Diecn+LlDq0kBLTA34Ge++IxZdeF6dU77hEwCN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hd+aiqDSvm7lVavyCfvzZATsjSpHEImTEYHB7GDjN0nC0osX3gsYmigMCC2QOPABoV7q6coyyyka4b7EGMRlvuUk+KE939WoXutIYlxMZskAvmABfttvL0m+b4T4ZSqIOfJJjTJx99LLre0UaPFf96qP8LlWBfTHD0T5n1ZhqeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VkaCGFgu; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3e5f9712991so3227830b6e.2
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 19:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730256222; x=1730861022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tbu/7f4XGJH7kRxX5UUBoPwHGO8jCVhKIql78bZVpkA=;
        b=VkaCGFgubk5cIMnVljiZE4Vn1qGMSthyphGsfZdw1kwJCewwZp9cmej/EbFKbm7/v/
         4PzZJX2dgRckoJqhMAFQ6mq9roJOYp4gFDg/6tQrGpJO7/MUmqb1ea6JJI5KDK+P1vNa
         bP5Hq131MM/nw58Umvyi5ovVehPnaeW4onSMXjxw70NDFstTYOek9Fgcn94uZWJXg523
         h2VeYK0Idjz+uh5jhf8MOqt9NpR6ZeSEBvepd/J2VeRSxWPZqxAbKxpVvr9Hw/iSvCCa
         08rnBfMHbrXB2D1gcvpgsQuyuNYlKofI+5zO7O8iKqDEGktVRuIOmp74ZzX3HcmsaI3t
         H4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730256222; x=1730861022;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tbu/7f4XGJH7kRxX5UUBoPwHGO8jCVhKIql78bZVpkA=;
        b=HDoCB8RUxrTl7bS7ubRxhL32T67n2Ekw3fCcf5uKYT1xiv+UmQLZe0E4m9vRVlQBcj
         f/iQa6nR/xhC4AzuE/EFGXBXugSMZ7xVSF9IYxU1Al50O2tZwJRB8/AFNAXrTbfqg+9C
         n+fmFI1pie7FFiNvJfvnS5HXZEb3hJFSfaciHzNbnubsLQkb0zKw5DeDXui8lOA1oUVn
         cB4/MgyrGhFapflIlnquOulRwOabmUDdmbz2a9LPIDymuG2orQc4qYvLJSnXdK75pE+G
         GC7ygcaLG4NyTM7WoRt/olpI6Hsls9t22NTDt2t+NMr3RbcHiu40QdnEbvQ/FE9ktfyB
         nZOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKeFMDkeCqHDsJExz6yN/OnyMnOT+GDS6cOed0TZ8ZjH2Klv7eLH36zg7MqpS653pjzZt+8IgMDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yya5LaWNP/5qteeO+uQQ0i2R/90cURJykXePwLCrmM+/Rb8BDjW
	G3w2++wYQyMnvtjEJ0bwGcAH211WGTC3QnCr4Y0/+KZk3n9lTPJ/EtuHJTE4iBA=
X-Google-Smtp-Source: AGHT+IGna9iUt3J8mXKEaSfJjm1ETFyEqPEXQtmUBmJo9CHCdyYp6cDelNLDp1VvLwkoahPDR7+CwA==
X-Received: by 2002:a05:6808:144f:b0:3e6:27f1:d756 with SMTP id 5614622812f47-3e63823ebacmr11947065b6e.2.1730256222079;
        Tue, 29 Oct 2024 19:43:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7edc8661098sm8310333a12.8.2024.10.29.19.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 19:43:41 -0700 (PDT)
Message-ID: <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
Date: Tue, 29 Oct 2024 20:43:39 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyGT3h5jNsKB0mrZ@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/24 8:03 PM, Ming Lei wrote:
> On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
>> On 10/29/24 2:06 PM, Jens Axboe wrote:
>>> On 10/29/24 1:18 PM, Jens Axboe wrote:
>>>> Now, this implementation requires a user buffer, and as far as I'm told,
>>>> you currently have kernel buffers on the ublk side. There's absolutely
>>>> no reason why kernel buffers cannot work, we'd most likely just need to
>>>> add a IORING_RSRC_KBUFFER type to handle that. My question here is how
>>>> hard is this requirement? Reason I ask is that it's much simpler to work
>>>> with userspace buffers. Yes the current implementation maps them
>>>> everytime, we could certainly change that, however I don't see this
>>>> being an issue. It's really no different than O_DIRECT, and you only
>>>> need to map them once for a read + whatever number of writes you'd need
>>>> to do. If a 'tag' is provided for LOCAL_BUF, it'll post a CQE whenever
>>>> that buffer is unmapped. This is a notification for the application that
>>>> it's done using the buffer. For a pure kernel buffer, we'd either need
>>>> to be able to reference it (so that we KNOW it's not going away) and/or
>>>> have a callback associated with the buffer.
>>>
>>> Just to expand on this - if a kernel buffer is absolutely required, for
>>> example if you're inheriting pages from the page cache or other
>>> locations you cannot control, we would need to add something ala the
>>> below:
>>
>> Here's a more complete one, but utterly untested. But it does the same
>> thing, mapping a struct request, but it maps it to an io_rsrc_node which
>> in turn has an io_mapped_ubuf in it. Both BUFFER and KBUFFER use the
>> same type, only the destruction is different. Then the callback provided
>> needs to do something ala:
>>
>> struct io_mapped_ubuf *imu = node->buf;
>>
>> if (imu && refcount_dec_and_test(&imu->refs))
>> 	kvfree(imu);
>>
>> when it's done with the imu. Probably an rsrc helper should just be done
>> for that, but those are details.
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 9621ba533b35..050868a4c9f1 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -8,6 +8,8 @@
>>  #include <linux/nospec.h>
>>  #include <linux/hugetlb.h>
>>  #include <linux/compat.h>
>> +#include <linux/bvec.h>
>> +#include <linux/blk-mq.h>
>>  #include <linux/io_uring.h>
>>  
>>  #include <uapi/linux/io_uring.h>
>> @@ -474,6 +476,9 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
>>  		if (node->buf)
>>  			io_buffer_unmap(node->ctx, node);
>>  		break;
>> +	case IORING_RSRC_KBUFFER:
>> +		node->kbuf_fn(node);
>> +		break;
> 
> Here 'node' is freed later, and it may not work because ->imu is bound
> with node.

Not sure why this matters? imu can be bound to any node (and has a
separate ref), but the node will remain for as long as the submission
runs. It has to, because the last reference is put when submission of
all requests in that series ends.

>> @@ -1070,6 +1075,65 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>>  	return ret;
>>  }
>>  
>> +struct io_rsrc_node *io_rsrc_map_request(struct io_ring_ctx *ctx,
>> +					 struct request *req,
>> +					 void (*kbuf_fn)(struct io_rsrc_node *))
>> +{
>> +	struct io_mapped_ubuf *imu = NULL;
>> +	struct io_rsrc_node *node = NULL;
>> +	struct req_iterator rq_iter;
>> +	unsigned int offset;
>> +	struct bio_vec bv;
>> +	int nr_bvecs;
>> +
>> +	if (!bio_has_data(req->bio))
>> +		goto out;
>> +
>> +	nr_bvecs = 0;
>> +	rq_for_each_bvec(bv, req, rq_iter)
>> +		nr_bvecs++;
>> +	if (!nr_bvecs)
>> +		goto out;
>> +
>> +	node = io_rsrc_node_alloc(ctx, IORING_RSRC_KBUFFER);
>> +	if (!node)
>> +		goto out;
>> +	node->buf = NULL;
>> +
>> +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_NOIO);
>> +	if (!imu)
>> +		goto out;
>> +
>> +	imu->ubuf = 0;
>> +	imu->len = 0;
>> +	if (req->bio != req->biotail) {
>> +		int idx = 0;
>> +
>> +		offset = 0;
>> +		rq_for_each_bvec(bv, req, rq_iter) {
>> +			imu->bvec[idx++] = bv;
>> +			imu->len += bv.bv_len;
>> +		}
>> +	} else {
>> +		struct bio *bio = req->bio;
>> +
>> +		offset = bio->bi_iter.bi_bvec_done;
>> +		imu->bvec[0] = *__bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>> +		imu->len = imu->bvec[0].bv_len;
>> +	}
>> +	imu->nr_bvecs = nr_bvecs;
>> +	imu->folio_shift = PAGE_SHIFT;
>> +	refcount_set(&imu->refs, 1);
> 
> One big problem is how to initialize the reference count, because this
> buffer need to be used in the following more than one request. Without
> one perfect counter, the buffer won't be freed in the exact time without
> extra OP.

Each request that uses the node, will grab a reference to the node. The
node holds a reference to the buffer. So at least as the above works,
the buf will be put when submission ends, as that puts the node and
subsequently the one reference the imu has by default. It'll outlast any
of the requests that use it during submission, and there cannot be any
other users of it as it isn't discoverable outside of that.

> I think the reference should be in `node` which need to be live if any
> consumer OP isn't completed.

That is how it works... io_req_assign_rsrc_node() will assign a node to
a request, which will be there until the request completes.

>> +	node->buf = imu;
>> +	node->kbuf_fn = kbuf_fn;
>> +	return node;
> 
> Also this function needs to register the buffer to table with one
> pre-defined buf index, then the following request can use it by
> the way of io_prep_rw_fixed().

It should not register it with the table, the whole point is to keep
this node only per-submission discoverable. If you're grabbing random
request pages, then it very much is a bit finicky and needs to be of
limited scope.

Each request type would need to support it. For normal read/write, I'd
suggest just adding IORING_OP_READ_LOCAL and WRITE_LOCAL to do that.

> If OP dependency can be avoided, I think this approach is fine,
> otherwise I still suggest sqe group. Not only performance, but
> application becomes too complicated.

You could avoid the OP dependency with just a flag, if you really wanted
to. But I'm not sure it makes a lot of sense. And it's a hell of a lot
simpler than the sqe group scheme, which I'm a bit worried about as it's
a bit complicated in how deep it needs to go in the code. This one
stands alone, so I'd strongly encourage we pursue this a bit further and
iron out the kinks. Maybe it won't work in the end, I don't know, but it
seems pretty promising and it's soooo much simpler.

> We also we need to provide ->prep() callback for uring_cmd driver, so
> that io_rsrc_map_request() can be called by driver in ->prep(),
> meantime `io_ring_ctx` and `io_rsrc_node` need to be visible for driver.
> What do you think of these kind of changes?

io_ring_ctx is already visible in the normal system headers,
io_rsrc_node we certainly could make visible. That's not a big deal. It
makes a lot more sense to export than some of the other stuff we have in
there! As long as it's all nicely handled by helpers, then we'd be fine.

-- 
Jens Axboe

