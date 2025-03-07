Return-Path: <io-uring+bounces-6980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E282A56A18
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DA5C18977C2
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 14:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5418D21ADCE;
	Fri,  7 Mar 2025 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HfFW06y6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEDA21ABDB
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741356902; cv=none; b=hxOrFXD2rryjOb+D/UTRUhNv7IW4fGUgJzffM6Yeo2Cq/rC+gFb/jrqWBqAkHGb8mEVUugG2OxR4kvODitUYtXnrZhFRym1SSdWH2CxPR776Jg1PY15M9Cg6TnFIIl3jm3PUhErGfSem1Phgl/hNvXxoZJeht7zHQylTYmw65Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741356902; c=relaxed/simple;
	bh=4Uhgc6O+T9dfxMEe0wjQiUtPcRq7XCozQz5hs+YGX1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OscWhqWhjrmYVf1b231Ao3PmkJisg73M0uBkoetJmVi3Sa/k8gFmMf3mNiqS+WQ81ijp6T7UeVH2jo7UqYIRKl/bYzdRRyVeDDTJdwcLB3u6SPjve3IL66xAuMYUiF7Mqavl4N0YVpeEajUoxH/24T/2Oa8krpJlwTAoheVAd0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HfFW06y6; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-856295d1f6cso129680339f.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 06:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741356897; x=1741961697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5F/OYRZoS0Oz1xckYqahvqPNiZBl8siTxkM+CYHut90=;
        b=HfFW06y6Jajf0xocs/GMhhTSBB9EtMQhZ8i0yLgSJNpj9BsR8maGDoDwGIYGprh+9p
         llMAABi9JIzzBPCh3Nq0skE0ZHcS1gc5ovc/c1vz86VefdljVQyKj3TwiQzRAkxa1xqn
         b+UWebSdrkM80Od7FS2iQRbS/FW2BZEv2UbSiWqcm7AQGtj6HABY18OFWQVHwKPq9fNI
         VpG2+d0TuW2Dhy+Sg8Zh5eodQEIe08M/IJE7RwNMpPjHzelpzKKbQv55GbkIxUWiqEis
         BPRdvf+I1RC7/xcQJvC9MqTBPR8anyDJV3lhHgiowQL3irury5zyom6/XB1hYoQupSHc
         SgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741356897; x=1741961697;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5F/OYRZoS0Oz1xckYqahvqPNiZBl8siTxkM+CYHut90=;
        b=TqGuyuWuiY3GkxOXNU3BGAxZ160Tgiq1+ihyA/GXLFDBeF52iO9MXLA5grMkjyomzD
         dO4WJWeQMYkPyTc/taFiAhmkF2yQtVfbO/CoouJBUl2iQYMPqFbCAU/WOjAnZsjM1F52
         6Z5a9d0ORHSVXbZ+DHr4moBG6XPubyq7+eaEQrgLbfiBNeFZ3nmZ1yWVvdRarXRRiv7r
         MlOLm0pXTk5vwaYEbIZ323wR8ujJ2SYB6a6tVlUUixbo706DBYtFC/1SbiyipmO/Q4BY
         Zq6PITPN/iVKgJo7LLUHR8NRIFGA8qKPWZzp9UIxcdavmOjksK9fpPmTAzlazzjP2Gya
         1xIw==
X-Forwarded-Encrypted: i=1; AJvYcCWe/84n0LD2dO+enoBPRcdabRRQyqwLZu02ual5UGxamINWJZKpwFu0jVPXpUQIaUSzeCNtwZAJeA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHDTZoHrDB6nFifFuYbSnm0p6VOxc9Gr55mc1CTgFAZP+8zVh6
	PVONXXtpkFceSxHeRDc6TUKJbka4sd+353yldXx3HvOv3Js5MZ5jjV+uwDFJCzWP8e7zU/QSmUx
	6
X-Gm-Gg: ASbGnctQoH7b/tlzXlvSkNlZRPAmp95dbrccf6Obo5vEyC+TZ90t/Yjn9I2RHnfNZBb
	xAuqZTt+inf8wUewP2gJXCy3LEdlp1yn1gGTyKOQAu4joYVxHLjcKBt4MLTeOc9N+TOKIA+Zdyy
	VTgY6HPVZXCI7o67TTHz/o1p0v22PAVL6eVnKv2pb83tFYgvof9cZX+PR4LOm95/HRPbPKVm4MJ
	21uqnM1TpUHPz/MXXNEVouFLQRdvaJSrJ7E6l3+pomq8M3gNQjmhaEgl7a1FvIwjyh9E8DK6l9M
	H7S2s28zieaSyH82tr8dw/DG4K7R3oZyvl8h8Ab+
X-Google-Smtp-Source: AGHT+IEXaC1eb1IYUFi+MB3HkvPslYAaj8r8bwpYrkVsyletZQtPs4d1u6GTtJy/e6lZEmCwWPi7Lg==
X-Received: by 2002:a05:6602:3982:b0:855:9d17:b050 with SMTP id ca18e2360f4ac-85b1d053152mr473964839f.9.1741356897495;
        Fri, 07 Mar 2025 06:14:57 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b11a9f298sm79782739f.41.2025.03.07.06.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 06:14:56 -0800 (PST)
Message-ID: <78bba5e5-2f4b-4dad-bea6-d535e8031e2f@kernel.dk>
Date: Fri, 7 Mar 2025 07:14:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] io_uring: add infra for importing vectored reg
 buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Andres Freund <andres@anarazel.de>
References: <cover.1741102644.git.asml.silence@gmail.com>
 <b054a88092767f7767f8447e7a5bdab15fcc0759.1741102644.git.asml.silence@gmail.com>
 <75fb61af-0ace-4e2d-ae4d-66573c4a63b8@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <75fb61af-0ace-4e2d-ae4d-66573c4a63b8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/7/25 7:07 AM, Pavel Begunkov wrote:
> On 3/4/25 15:40, Pavel Begunkov wrote:
>> Add io_import_reg_vec(), which will be responsible for importing
>> vectored registered buffers. iovecs are overlapped with the resulting
>> bvec in memory, which is why the iovec is expected to be padded in
>> iou_vec.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
> ...
>> +int io_import_reg_vec(int ddir, struct iov_iter *iter,
>> +            struct io_kiocb *req, struct iou_vec *vec,
>> +            unsigned nr_iovs, unsigned iovec_off,
>> +            unsigned issue_flags)
>> +{
>> +    struct io_rsrc_node *node;
>> +    struct io_mapped_ubuf *imu;
>> +    struct iovec *iov;
>> +    unsigned nr_segs;
>> +
>> +    node = io_find_buf_node(req, issue_flags);
>> +    if (!node)
>> +        return -EFAULT;
>> +    imu = node->buf;
>> +    if (imu->is_kbuf)
>> +        return -EOPNOTSUPP;
>> +    if (!(imu->dir & (1 << ddir)))
>> +        return -EFAULT;
>> +
>> +    iov = vec->iovec + iovec_off;
>> +    nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
> 
> if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
>     size_t entry_sz = sizeof(struct iovec);
>     size_t bvec_bytes = nr_segs * sizeof(struct bio_vec);
>     size_t iovec_off = (bvec_bytes + entry_sz - 1) / entry_sz;
> 
>     nr_segs += iovec_off;
> }
> 
> How about fixing it up like this for now? Instead of overlapping
> bvec with iovec, it'd put them back to back and waste some memory
> on 32bit.
> 
> I can try to make it a bit tighter, remove the if and let
> the compiler to optimise it into no-op for x64, or allocate
> max(bvec, iovec) * nr and see where it leads. But in either
> way IMHO it's better to be left until I get more time.

I think that looks reasonable. Nobody cares about this for 32-bit,
outside of needing to work obviously.

-- 
Jens Axboe


