Return-Path: <io-uring+bounces-13388-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wESbFGPrCmqR9QQAu9opvQ
	(envelope-from <io-uring+bounces-13388-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:35:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CA41F56AC90
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8123E308E4ED
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 10:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0103ED5A5;
	Mon, 18 May 2026 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJQ4iM0Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA163EAC71
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 10:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779100208; cv=none; b=gSrvnU84Nayy6FACGHzbCwqSv6RWLIrzpgQlE3iAludwr0mVdOePbAMoi8p9ueZpKSv1oS1gsw2PQzVTp/36ddAvpQxQWpWPWLE6CPmUBk+s2GILRJ8er33YtsGgGeYSt4jUM/ByqqFmNT4ZqXB3M5lvGwaJ7mJiXEdiyYV6urg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779100208; c=relaxed/simple;
	bh=FbvAJUBaJSoNOddpm6KcOlO9qRGB7h6zbd7g73ujdLc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Fnj/o+RltH+f2/JlMp/tydgdShC1SdF7kDpfM/KLiYt1BGP6IbAsyruztgG/60sLWTxsoQ4ueHQPB90sDaQByydIu1FyvI7oFiE4Nby1y8s25aLytEhGj2sOvIqgk5wOp9XTZ8w1vje5DBYR5WWsYYAJDLdNdgL1djNNOobXu1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJQ4iM0Y; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45e6a4d0be0so704333f8f.1
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 03:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779100196; x=1779704996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yBM/MqSlhfscJgewJTDJnR/WZOfF3ZaH9qUvK+mYr0I=;
        b=AJQ4iM0Y3atulw0PqPF8op4PRnWpRVYOty/GNjhKqmtpas6RAxpBy+PRn9KMn1Wno2
         qjZPw+EhhE0hOFeMi5Jmm2umUnXHc9uHE6Sc4jCIy8Ms4gDmWbAja3yDgp1f0sakvIzo
         mND0MAlV95AGumFfzHSvL6fn/HmzZMpLelmMNL/OqSMvfJdhoE33lGksAXwRGKhpz9y3
         MUxmm5rukKAQCGvtg3KEsHI7vG7ayeRK0NXm2lTRYxEUjs5WhyITg3Gsh7qemErQcLpo
         H/MeM/3buitXkpHJfEHCNh+4Lx9a+L/jbz0S914lIrMYWChf5levhxDB0NWAD/C8QyT9
         dHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779100196; x=1779704996;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBM/MqSlhfscJgewJTDJnR/WZOfF3ZaH9qUvK+mYr0I=;
        b=SakAdLNnbQhUp2kF+Q01/yAZCw7/pi3os8p2GYfg3HMqVdYWEQVQDmwiAtSCV305un
         jrEaKoRCu7f3xxiOth9dcX2kXYhB48igZF+WLcTsnePu4SrAwkJvml1xppufAikcJJ4+
         d8A741nOBQUCTKJurtb3rrCQLZFmxHo3vadGslXY9eCjxruiq31YRMCmQbrUlELyzIHY
         zMLB4Wqemr0JgTGcLTBsoCx7//BEat37JS5RJUM29e31gqF0cDOkaq5sXcih9GrkPTea
         xCUZjJ0/5jD9dD6NQQNSHho69SsFRlFGkSy+qJn/Bx3Y3WA2sxRQrpjc2LBF0DysCAV0
         ySvQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XzFKUoLfI61LNyiig27fTLpCzB2QXIyapPZyDVh3UMLacjX8cHLTJRgIiyGkCd0aJSinxosoPMA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjDDdS2/Mmq/fPifp21XUIUNvf3qW1xR9P9pAvQXNpjj7pnsQK
	wSi3m+bRBfbuJS4P5wMSQMXKbeaBu2VNhoSzFI/Vng90KB7DnLHJV54V
X-Gm-Gg: Acq92OHQjzHsTbK0aW08srAXkOt1M+wD5HkPeRdQxXx1XqpKVCYBJi3JkrGvMjsYdI7
	hZoBx4TjRUtXHuVgM/93KETBpbyy6GRUD+ei1qRdBZjuvW6rcQZg2w8kiqe3gHv73JYt7UIo2bo
	PStkaa8vyhX6A/ILZV1bQT49QyjDaJntHqx1QNP9Rjh5IHEvJoowhc+tXKOXx7dOu/w/RjCfEWo
	YAwyD8yDlgd9T06pYyiBhMQ1+RicW2ipNDuYS4cZQx6sM4+zb0we+OwgmFz3EomNOHza+zo9Ruf
	T6MBUFtRDQNny7xhLLx7blqAAZxJNifrb2q9XZ1DeGuL9xoA3CVRSe/9ZFD6mWiStBfov/0UM1m
	vFtSqyjHXMIj7k2/JrfavsSEgts8EWR4ql0BYHD4R4PaJHhUYWq7xpp6XT0ljyvVijiaUojvqYK
	OlM05F4VkGM401F3j43rECpKGGC/aCRRi/gNFEz5w7d66nxSAoPZkDEHt9SIQjkCObbbVdV/ch7
	0dToi7u5f3fZO2LUpGfHJT6ujq9iQZ9Cx8jWel3B4CoNuEFzpQsxD7+Mlg=
X-Received: by 2002:a5d:5885:0:b0:43c:f7e5:817b with SMTP id ffacd0b85a97d-45e5c5cc2b5mr22613508f8f.19.1779100196106;
        Mon, 18 May 2026 03:29:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:ec20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm36537426f8f.34.2026.05.18.03.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 03:29:55 -0700 (PDT)
Message-ID: <24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
Date: Mon, 18 May 2026 11:29:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v3 04/10] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <646ecd6fde8d9e146cb051efb514deb27ce3883e.1777475843.git.asml.silence@gmail.com>
 <20260513081929.GD5477@lst.de>
Content-Language: en-US
In-Reply-To: <20260513081929.GD5477@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CA41F56AC90
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	TAGGED_FROM(0.00)[bounces-13388-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 5/13/26 09:19, Christoph Hellwig wrote:
>> +	if (!bio_flagged(bio_src, BIO_DMABUF_MAP)) {
>> +		bio->bi_io_vec = bio_src->bi_io_vec;
>> +	} else {
>> +		bio->dmabuf_map = bio_src->dmabuf_map;
>> +		bio_set_flag(bio, BIO_DMABUF_MAP);
>> +	}
> 
> This is backwards, please avoid pointless negations:

I can flip it, but compilers tend to prefer the true branch. E.g. this

if (cond) A; else B;
C;

can get compiled into:

jmpcc cond B
A: ...
C:
return;
B: ...
jmp C;
  

> 
> 	if (bio_flagged(bio_src, BIO_DMABUF_MAP)) {
> 		bio->dmabuf_map = bio_src->dmabuf_map;
> 		bio_set_flag(bio, BIO_DMABUF_MAP);
> 	} else {
> 		bio->bi_io_vec = bio_src->bi_io_vec;
> 	}
> 
>> +	if (bio_flagged(bio, BIO_DMABUF_MAP)) {
>> +		nsegs = 1;
>> +
>> +		if ((bio->bi_iter.bi_bvec_done & lim->dma_alignment) ||
>> +		    (bio->bi_iter.bi_size & len_align_mask))
>> +			return -EINVAL;
>> +		if (bio->bi_iter.bi_size > max_bytes) {
>> +			bytes = max_bytes;
>> +			goto split;
>> +		}
> 
> Please add a comment explaining why nsegs is always 1 here.



> 
>> @@ -424,7 +424,8 @@ static inline struct bio *__bio_split_to_limits(struct bio *bio,
>>   	switch (bio_op(bio)) {
>>   	case REQ_OP_READ:
>>   	case REQ_OP_WRITE:
>> -		if (bio_may_need_split(bio, lim))
>> +		if (bio_may_need_split(bio, lim) ||
>> +		    bio_flagged(bio, BIO_DMABUF_MAP))
>>   			return bio_split_rw(bio, lim, nr_segs);
> 
> The BIO_DMABUF_MAP check should go into bio_may_need_split.

Ok
>> +static inline void bio_advance_iter_dmabuf_map(struct bvec_iter *iter,
>> +					       unsigned int bytes)
>> +{
>> +	iter->bi_bvec_done += bytes;
>> +	iter->bi_size -= bytes;
>> +}
>> +
>>   static inline void bio_advance_iter(const struct bio *bio,
>>   				    struct bvec_iter *iter, unsigned int bytes)
>>   {
>>   	iter->bi_sector += bytes >> 9;
>>   
>> -	if (bio_no_advance_iter(bio))
>> +	if (bio_no_advance_iter(bio)) {
>>   		iter->bi_size -= bytes;
>> -	else
>> +	} else if (bio_flagged(bio, BIO_DMABUF_MAP)) {
>> +		bio_advance_iter_dmabuf_map(iter, bytes);
> 
> This is a bit of a mess.  You're using bi_bvec_done for something that
> is not bvec_done, which makes the naming very confusing.  That is even
> more confusing than the existing usage, which isn't great.  Also we
> add yet another conditional to heavily inlined code.  I'd suggest
> the following:
> 
>   - add a prep patch to rename bi_bvec_done to bi_offset, as even for
>     the existing usage it is the offset into the current bio_vec as
>     much as it is the count of byes done, as those must be the same
>     and it is used both ways
>   - add a prep patch to also increase bi_offset for bio_no_advance_iter.
>     It is not actually use there, but incrementing it is harmless and
>     this will avoid a new special case
>   - please also documet this new usage in the commet in struct bvec_iter.
>   - then just add the dma buf mapping to the bio_no_advance_iter condition

I'll take a look

>   - figure out what to do about dm_bio_rewind_iter, which pokes into these
>     things that really should be block layer internal

Need to check what that is, but doesn't implement the interface and
is not supposed to ever see the dmabuf iterator.

>>   }
>> @@ -391,7 +403,7 @@ static inline void bio_wouldblock_error(struct bio *bio)
>>    */
>>   static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
>>   {
>> -	if (iov_iter_is_bvec(iter))
>> +	if (iov_iter_is_bvec(iter) || iov_iter_is_dmabuf_map(iter))
>>   		return 0;
>>   	return iov_iter_npages(iter, max_segs);
>>   }
> 
> Please update the comment for this helper.
> 
>> @@ -322,6 +327,7 @@ enum {
>>   	BIO_REMAPPED,
>>   	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>>   	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
>> +	BIO_DMABUF_MAP, /* Using premmaped dma buffers */
> 
> Shouldn't this be a REQ_ flag as we should never mix and match bios with
> and without this flag in a single request?

Do you mean adding both and propagating it from bio to req? submit_bio()
takes a bio, so we still need to set it there before it reaches blk-mq.
And there might be bio-based drivers using it in the future.

-- 
Pavel Begunkov


