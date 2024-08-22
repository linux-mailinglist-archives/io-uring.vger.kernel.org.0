Return-Path: <io-uring+bounces-2895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 336E095B601
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 15:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5DD1285238
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 13:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85E71C9DE6;
	Thu, 22 Aug 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRQtPJTr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED41C9DD7;
	Thu, 22 Aug 2024 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724332123; cv=none; b=uOW03EafV45x8LYqjUjRMNdZQd2ZHKCHMiGXx0ZcErs91BRvWwwwRZpzdLwRf3PcWuPpsrOCI0PGdTOLX/NqHfllwfqKYe37g4cc9+bo2lL7aZnF9UvReA1rkP55fh0C5lJDdHOhQDNh7aVFoB6o1TE+VgD+l1u4frFj+pJijjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724332123; c=relaxed/simple;
	bh=qmNqu6ae8ARraFZaQxP22e+UfQbynK394nji+qy0BAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LmZ7S+S51RBN5Rahnc1l3EpPpjNe8nLIx9OilCRidFd1PD0Mbgwf3k0R7w0dvAva//fzjyBk4rELp8tb3I1pfk35fUOxImhnxxt28h8wAdCDsVDu9XzN0UotBIn6GJaNS0IedjjvJiyc9CDRr1bD4CVATxQbFlpgl+FRUgpVL+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRQtPJTr; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8666734767so98879466b.1;
        Thu, 22 Aug 2024 06:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724332120; x=1724936920; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dl+Hsm8zibvc7WrumbZdWV/OSVlPFvlVPjSvuxKRlb0=;
        b=NRQtPJTrK7ovOW1A3eYHzRhetOXlprhZ4LV8W6M0mInxLbszt+2fa1+BY6/UYOr8yB
         rlZ6r8vIFI0y9Usx4uRCG2WGHGmAVzHc+by4xHyu/SB+3ymE69I/EuMWDFRgjX7I0cnu
         9w+JlS3g8UHEu/tIGPAXG3PQOQf7w58+4/oXLLswIqYGQR1cUKlgNf4LPuGPk27RieLl
         3Pt0YMjeTJAqfRH4UjJbZSgNSgbRQGaGaoOUyTo/7OE+0BYrWTHasV09TzmatHAWMefz
         zv+OW6A4LGYGXrZrxs0R/cbLGYeGs4lRi0lKl6MKHSHiwZuSao+eTUBVGX4+KECECjs9
         dK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724332120; x=1724936920;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dl+Hsm8zibvc7WrumbZdWV/OSVlPFvlVPjSvuxKRlb0=;
        b=u5gctDq8xPiqtkBsCE8O7TVB7Ew4wSOXl2/AUEMPYvjEyk7SdQFLGgQttjdW8OSfer
         FREPhXexFusNEALqCUtLV2on/oet2xxCKHSoIRF1oEDa0wF9CdwYddml5jSWGroyJ8Po
         kPL5MjEaaQbc5eQ+pXDevJLfvf14U16Vg8yOgpSozrxFwxuBfC/Wxf9NId7PBiWV1dxW
         IOLXqYP/DOfb2x3G3qmi/hjUFyCVT50Blquj5MZp/UJEufLZaKbS6BVW1uPIDxrQgeoU
         EhB4YmfGV2DciKHiHo3D7czMOEqL8SabK3j9WjGkcKRf5HB9nxM33LsUJafJKr894PFH
         TuNg==
X-Forwarded-Encrypted: i=1; AJvYcCVgkAQ/c5WUvGZ8kgKTMfDDqM6TvIvKKG6l7cGhpycy1d8kbUgMCo0wJZn0GCbYbZc3AX2bLpT5Udt/Hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjX8Cq6j2Z0j8pFlbaRDDudlFFVii+GEGfOsB/5lgmenxphjJJ
	Z0eC5/LyR2N3oqge7+T+/DYmENTMCd8bXPDm2/eW9T5rjhKxgx0xo3jfLw==
X-Google-Smtp-Source: AGHT+IFhOWmaj/+dvpn8QW8FqpNKUG4zL5yX1NIC/SrZU7nd40LcEHlt/jfOHgQhcw8E5s5ffGox+Q==
X-Received: by 2002:a17:907:986:b0:a86:85eb:bddb with SMTP id a640c23a62f3a-a8685ebcd68mr255418566b.52.1724332120131;
        Thu, 22 Aug 2024 06:08:40 -0700 (PDT)
Received: from [192.168.42.32] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f436bd5sm117966966b.119.2024.08.22.06.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 06:08:39 -0700 (PDT)
Message-ID: <523aed7d-6c19-4fce-9a25-b13163a43917@gmail.com>
Date: Thu, 22 Aug 2024 14:09:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] block: implement async wire write zeroes
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1724297388.git.asml.silence@gmail.com>
 <09c5ef75c04c17ee2fd551da50fc9aae3bfce50a.1724297388.git.asml.silence@gmail.com>
 <ZsbfwKgdLZKVHOMD@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZsbfwKgdLZKVHOMD@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 07:50, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 04:35:56AM +0100, Pavel Begunkov wrote:
>> Add another io_uring cmd for block layer implementing asynchronous write
>> zeroes. It reuses helpers we've added for async discards, and inherits
>> the code structure as well as all considerations in regards to page
>> cache races.
> 
> Most comments from discard apply here as well.
> 
>> +static int blkdev_queue_cmd(struct io_uring_cmd *cmd, struct block_device *bdev,
>> +			    uint64_t start, uint64_t len, sector_t limit,
>> +			    blk_opf_t opf)
> 
> This feels a little over generic as it doesn't just queue any random
> command.
> 
>> +static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
>> +				   struct block_device *bdev,
>> +				   uint64_t start, uint64_t len, bool nowait)
>> +{
>> +	blk_opf_t opf = REQ_OP_WRITE_ZEROES | REQ_NOUNMAP;
>> +
>> +	if (nowait)
>> +		opf |= REQ_NOWAIT;
>> +	return blkdev_queue_cmd(cmd, bdev, start, len,
>> +				bdev_write_zeroes_sectors(bdev), opf);
> 
> So no support for fallback to Write of zero page here?  That's probably
> the case where the async offload is needed most.

Fair enough, but I believe it's more reasonable to have a separate
cmd for it instead of silently falling back.

-- 
Pavel Begunkov

