Return-Path: <io-uring+bounces-2894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB56A95B5EF
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 15:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548401F23B7F
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 13:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56031C9432;
	Thu, 22 Aug 2024 13:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsK2d/au"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037731C93C1;
	Thu, 22 Aug 2024 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724332015; cv=none; b=kNEUMvzRWRV5QS4zNz4r/Z3ltIOXd9rXK/XoT1bd9CI21C1hmCo+3+iaj+SgeNvVTYF21oR//4bsh3fXBqPYLo4H7t32ihoOIsRByQVPa0wjwQDE4l36cHzhZC245vSAVw6aWbKSwHFayJtDbdV2pkTTWyPgdGlMPQTpKy2EBSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724332015; c=relaxed/simple;
	bh=tB1XrxwYV2PEtWu+TRxSIDVazif+aWdEy7r8gpNX6YY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j0UUrLuJYAE5mbdjOdFNwMfu3NTSzvARYbEtHZptIvNw/uXq4EL+OtxX7XijMQLLaERad9TPFuTAwBYqkxxdhZgqa/oMhkf3/VkBF5Hxx4H47tE2tSYTkM3H7FWEEbl5OIB2dXtmgabh01ZMSACsi8G3tRMFtCtj4I0IcXlh0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FsK2d/au; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8695cc91c8so65503766b.3;
        Thu, 22 Aug 2024 06:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724332012; x=1724936812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JY6WD/cdLiYuTThhGylTjTMuiY5wE2mMjm5oQKT0gq0=;
        b=FsK2d/aukousFzv/kUoLl+1N9Fr0I2sBG9WIVGrNW7InsAu/n4klXYxojOfegVixlE
         GTCD6+f3D2cGlpptEdLWACgGaMW5xbKywHzpYXq9JBRjz7lEWmOzcyYGUKE6KYz6XaqP
         n59M0QesvR6Bwz+96s+FwVR5ci/u/DoSKtmRD655xZ7OnukXZnS7WQDMgW3bEKAeOlR9
         gPYY5TcbVzTWVxFfGuTEfO5/bbuIw5kO6fEM6t7HcuhBQ1R/NhxySAdgu9fTniSkpRvz
         rOnX4k/vK0i8sF19hnYHKhxDG5n5BxWF5hLZivlSR6+0gV1lYvz6JFqxrfLF7+Hjnwoo
         DBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724332012; x=1724936812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JY6WD/cdLiYuTThhGylTjTMuiY5wE2mMjm5oQKT0gq0=;
        b=eZMLv4tlqvPXY/9wY7Q3RpBY+ly30XEFdP1AgmNB629nBhiiMGUM3OXTFC677qhuQC
         d4LS6N4o2E2yK+etHKR52036c0YSZuI115hX+gU67LG0BVhaKMEdcDi6QCubeGJ//fYl
         miNurEz91zXydTmxJzy6c9qL5GhDi2scUghHbuZ6luu7xmccRjKZLQ/qyy347LecgnJT
         J+ohAyMttLvzqPJXY0Lb4t24ky8sIZeOJ3u9re4kqhGTnX1H/ZzKI4d0ObSHQrLyt5Db
         sCs6fgkhIhIIicE5dDARCmCMdCls5TtXCaH+DMi/nDlrZx9tUit4IgwbhE0nJmg8klbX
         oRoA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ2lzmaiHfk1iRd0lH9yrZdiGr9KdSi6k/NBc+HMfmPrBiIxe26K9pszQd12yhkqsE+hpzeACuoAI+5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvFYEhI/SJgZZpzoyru0M/aYmL2Y9XzfvYxg7CeDLyoLj15tQs
	QsflRHUD97obEBJ229SCKrH6Hd/0pfRwVnpqYx116LrOAAMh8wE9d02JXA==
X-Google-Smtp-Source: AGHT+IHyui9FV1zbhnVYWjCICzl8/4W4vLQP4cDkVJaCJwV36cV+fodq9sVe/ysFJ0Feghsq34W3LA==
X-Received: by 2002:a17:906:eec4:b0:a7a:3928:3529 with SMTP id a640c23a62f3a-a866f110c45mr457228366b.13.1724332011466;
        Thu, 22 Aug 2024 06:06:51 -0700 (PDT)
Received: from [192.168.42.32] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c044ddc3e4sm898651a12.13.2024.08.22.06.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 06:06:51 -0700 (PDT)
Message-ID: <c39469f3-2b9c-493b-9cd6-94ae9a4994b8@gmail.com>
Date: Thu, 22 Aug 2024 14:07:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] block: implement async discard as io_uring cmd
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1724297388.git.asml.silence@gmail.com>
 <e39a9aabe503bbd7f2b7454327d3e6a6620deccf.1724297388.git.asml.silence@gmail.com>
 <Zsbe1mIYMd9uf8cq@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zsbe1mIYMd9uf8cq@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 07:46, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 04:35:55AM +0100, Pavel Begunkov wrote:
>> io_uring allows to implement custom file specific operations via
>> fops->uring_cmd callback. Use it to wire up asynchronous discard
>> commands. Normally, first it tries to do a non-blocking issue, and if
>> fails we'd retry from a blocking context by returning -EAGAIN to
>> core io_uring.
>>
>> Note, unlike ioctl(BLKDISCARD) with stronger guarantees against races,
>> we only do a best effort attempt to invalidate page cache, and it can
>> race with any writes and reads and leave page cache stale. It's the
>> same kind of races we allow to direct writes.
> 
> Can you please write up a man page for this that clear documents the
> expecvted semantics?

Do we have it documented anywhere how O_DIRECT writes interact
with page cache, so I can refer to it?

  
>> +static void bio_cmd_end(struct bio *bio)
> 
> This is really weird function name.  blk_cmd_end_io or
> blk_cmd_bio_end_io would be the usual choices.

Will change with other cosmetics.


>> +	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
>> +					    GFP_KERNEL))) {
> 
> GFP_KERNEL can often will block.  You'll probably want a GFP_NOWAIT
> allocation here for the nowait case.

I can change it for clarity, but I don't think it's much of a concern
since the read/write path and pretty sure a bunch of other places never
cared about it. It does the main thing, propagating it down e.g. for
tag allocation.


>> +		if (nowait) {
>> +			/*
>> +			 * Don't allow multi-bio non-blocking submissions as
>> +			 * subsequent bios may fail but we won't get direct
>> +			 * feedback about that. Normally, the caller should
>> +			 * retry from a blocking context.
>> +			 */
>> +			if (unlikely(nr_sects)) {
>> +				bio_put(bio);
>> +				return -EAGAIN;
>> +			}
>> +			bio->bi_opf |= REQ_NOWAIT;
>> +		}
> 
> And this really looks weird.  It first allocates a bio, potentially

That's what the write path does.

> blocking, and then gives up?  I think you're much better off with
> something like:

I'd rather avoid calling bio_discard_limit() an extra time, it does
too much stuff inside, when the expected case is a single bio and
for multi-bio that overhead would really matter.

Maybe I should uniline blk_alloc_discard_bio() and dedup it with
write zeroes, I'll see if can be done after other write zeroes
changes.

> 
> 	if (nowait) {
> 		if (nr_sects > bio_discard_limit(bdev, sector))
> 			return -EAGAIN;
> 		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
> 						    GFP_NOWAIT);
> 		if (!bio)
> 			return -EAGAIN
> 		bio->bi_opf |= REQ_NOWAIT;
> 		goto submit;
> 	}
> 
> 	/* submission loop here */
> 
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index 753971770733..0016e38ed33c 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -208,6 +208,8 @@ struct fsxattr {
>>    * (see uapi/linux/blkzoned.h)
>>    */
>>   
>> +#define BLOCK_URING_CMD_DISCARD			0
> 
> Is fs.h the reight place for this?

Arguable, but I can move it to io_uring, makes things simpler
for me.

> Curious:  how to we deal with conflicting uring cmds on different
> device and how do we probe for them?  The NVMe uring_cmds
> use the ioctl-style _IO* encoding which at least helps a bit with
> that and which seem like a good idea.  Maybe someone needs to write
> up a few lose rules on uring commands?

My concern is that we're sacrificing compiler optimisations
(well, jump tables are disabled IIRC) for something that doesn't even
guarantee uniqueness. I'd like to see some degree of reflection,
like user querying a file class in terms of what operations it
supports, but that's beyond the scope of the series.

-- 
Pavel Begunkov

