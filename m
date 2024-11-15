Return-Path: <io-uring+bounces-4715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6229CDE9D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 13:49:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD0601F20FC0
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 12:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BCD1BBBD3;
	Fri, 15 Nov 2024 12:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TqiUZMdU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FD018950A
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731674975; cv=none; b=jmlzFP6bMGT9njJm406uaLf3gIPXeSGb7zVg53S4qMRacC7HDqLVCG9xUSnvzNOLQa/AJgRHyMf9rcXaQRHNetBYMmfR/JEHKyWEJHQ0fHDDbmiXQw89pT7PHkND2mdj8RdXCCnvjNbzUJ9y1coJA4HHOITcP4fCXPdjmlc14F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731674975; c=relaxed/simple;
	bh=+UYApFnT9UM37KTNXTpn2LxWwTjTgga79QdwKc3PiHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZfuolPLzq30uIQGq7i0sV9pJAAy9EKESEZn3YDK7RySMRSllgVaxHfwtUEPHjfUKfIwbbHYlWu5l9r4kxeGmgKyXNrKUz5RhIwF26HNuWetKGoP2VYYXANtSN4XUgHDznY1ckM0Lbkr7z+bpqqqflWadDBsHExKgH5jMmLvA2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TqiUZMdU; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2118dfe6042so14274545ad.2
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 04:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731674971; x=1732279771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jwJVxt+nzxze2SmN7f33ZKdyuGZOFXgYv9MV7GcQNWA=;
        b=TqiUZMdU4ZCtD+Rg1MV3fYw7A7G/8hDEubDD97mUD8VFIMvJpydHoc1OqQaVck50Ti
         CIiMbK+SDUVDVj2SwkSWFtjoDKCAgJpg8uBMlU5BU3xZN6FMrudyvBNCWsN4obfPGnq/
         TOOeogimHm5AqC3mtEGY5u0/v3sFvXFhoQafjtYPlLgtHMT3kxzIvrbcFRwoRAp1waq5
         x9sfzXGq/cRH331GYb9ImrvO4Nf3jfx4+n2Di5vpTP6M/ziQ/GZbQpUPPcDnwAPlL4Gs
         MsajxHhYC643k55cu0f46zcQuL/GjIhJ7Goes03JVpB//MPXvfBq+oI3B7GSeKwH/7jk
         W3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731674971; x=1732279771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwJVxt+nzxze2SmN7f33ZKdyuGZOFXgYv9MV7GcQNWA=;
        b=xJOzb6Gp9zJ2rRoE9nZEwYCKadnYmsKYsMAW/HF6ZhTU67m/MGo7h+3p1yNuCIQQgm
         TbSaIwT5MC6xbmQ4BsZkCuKDnFFUq6gZaugrMUYuM/QwUK0TIQpUO0pBUtF8H2eRAW+X
         9WUjCdnTLmlAylG0jaXymsekcRovhsEj5G4UrvzFiqS/OybNJLj2KPQHS+uy7T1aXq4B
         SxH4jujFSDaOwyOIjzB7T0sG/FctQaVzrdqGnJgLJVGaS2uaELZ6MeVVd9kp6cHfbjMm
         026HGWUfkgpmZxAil0krxgfx2lQSGFvFK60nwma+dYiS9iOcoDSJRJa+/vnJIOSW7amP
         xWUA==
X-Forwarded-Encrypted: i=1; AJvYcCX0QjqkZdvwaXVUPJ+i0tfc9w0DRt32PUsakKJ3W6RO4e7YDhLPQHrX1pDvRbzEvrmWXj7GTLfsUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3dqGktgeVmRknblJycksmSJqzVqomcw4HSGGeh5R06lqv8yfA
	HlRzktNI0HWUG3bJKqcR8Er0B8UsVSO4GkglU6TDPe0N01Z/nzfvR20dUPSBMoM=
X-Google-Smtp-Source: AGHT+IHLsm4F8XGgt+dNqMlncEMHZaB6TNbve2F3AL5DPq8Q+6a6Bwd0d1gK0LzJt/GKxZcrS9AoKQ==
X-Received: by 2002:a17:902:e74c:b0:20f:b5d1:8805 with SMTP id d9443c01a7336-211d0ca73admr34323225ad.0.1731674971420;
        Fri, 15 Nov 2024 04:49:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34609sm11080105ad.121.2024.11.15.04.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 04:49:30 -0800 (PST)
Message-ID: <9f646b56-ebbf-4f2d-bceb-6ce1deb5d515@kernel.dk>
Date: Fri, 15 Nov 2024 05:49:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] block: add a rq_list type
To: Nathan Chancellor <nathan@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-5-hch@lst.de> <20241114201103.GA2036469@thelio-3990X>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241114201103.GA2036469@thelio-3990X>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/24 1:11 PM, Nathan Chancellor wrote:
> Hi Christoph,
> 
> On Wed, Nov 13, 2024 at 04:20:44PM +0100, Christoph Hellwig wrote:
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 65f37ae70712..ce8b65503ff0 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1006,6 +1006,11 @@ extern void blk_put_queue(struct request_queue *);
>>  void blk_mark_disk_dead(struct gendisk *disk);
>>  
>>  #ifdef CONFIG_BLOCK
>> +struct rq_list {
>> +	struct request *head;
>> +	struct request *tail;
>> +};
>> +
>>  /*
>>   * blk_plug permits building a queue of related requests by holding the I/O
>>   * fragments for a short period. This allows merging of sequential requests
>> @@ -1018,10 +1023,10 @@ void blk_mark_disk_dead(struct gendisk *disk);
>>   * blk_flush_plug() is called.
>>   */
>>  struct blk_plug {
>> -	struct request *mq_list; /* blk-mq requests */
>> +	struct rq_list mq_list; /* blk-mq requests */
>>  
>>  	/* if ios_left is > 1, we can batch tag/rq allocations */
>> -	struct request *cached_rq;
>> +	struct rq_list cached_rqs;
>>  	u64 cur_ktime;
>>  	unsigned short nr_ios;
>>  
>> @@ -1683,7 +1688,7 @@ int bdev_thaw(struct block_device *bdev);
>>  void bdev_fput(struct file *bdev_file);
>>  
>>  struct io_comp_batch {
>> -	struct request *req_list;
>> +	struct rq_list req_list;
> 
> This change as commit a3396b99990d ("block: add a rq_list type") in
> next-20241114 causes errors when CONFIG_BLOCK is disabled because the
> definition of 'struct rq_list' is under CONFIG_BLOCK. Should it be moved
> out?
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 00212e96261a..a1fd0ddce5cf 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1006,12 +1006,12 @@ extern void blk_put_queue(struct request_queue *);
>  
>  void blk_mark_disk_dead(struct gendisk *disk);
>  
> -#ifdef CONFIG_BLOCK
>  struct rq_list {
>  	struct request *head;
>  	struct request *tail;
>  };
>  
> +#ifdef CONFIG_BLOCK
>  /*
>   * blk_plug permits building a queue of related requests by holding the I/O
>   * fragments for a short period. This allows merging of sequential requests
> 

Fix looks fine, but I can't apply a patch that hasn't been signed off.
Please send one, or I'll just have to sort it out manually as we're
really close to this code shipping.


-- 
Jens Axboe


