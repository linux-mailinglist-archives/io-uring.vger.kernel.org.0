Return-Path: <io-uring+bounces-6977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEDCA55A5D
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 00:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B97B71765D1
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 23:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E122627CB3C;
	Thu,  6 Mar 2025 23:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CYrlsbyh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6971161320
	for <io-uring@vger.kernel.org>; Thu,  6 Mar 2025 22:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302001; cv=none; b=aJXe5qs3cQIpnhUGgF9wHVffxxbYXk5i1IHmmDWHIj3n56KupDJ8SxRP+bvGRCCKtjW64fhwL2uWv99PxdiX7iAJp2gqARkaOuhhTWoG8F2nu2nFl/FPDyZE3pb09xuu5+82+7mw+cie8KyOJFAzPtkNIPXcChRZsdYj2jY6zxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302001; c=relaxed/simple;
	bh=EJLsEhd/J/9JCDrNi89lkcPB7tQYfrWekndLhrhpS48=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lDDJCOOUmzsTeVsQt+YCO7QHG5+1+MsMpE/sgXmycTo1D8wxnJx6ndSh5TvKQwFHYqYfdMASi3mtZpgARV+Y42JeRWb6Vi5/Nq0QQgMKwQ0JYw7VcNZXpK7Md5utsQZbDqjpnKj6gF3UYkF3JZMDX3ya/sWvXX3yfGZEMPd1Xxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CYrlsbyh; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85afd2b9106so83042339f.0
        for <io-uring@vger.kernel.org>; Thu, 06 Mar 2025 14:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741301997; x=1741906797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fxo3LiiQNTKlQcr4Ji/p1iFEjZ7lz5XbTu3S3aDyRJI=;
        b=CYrlsbyhyzhYGJlGzDQVh/U89Ki13XNZb3NFiygf2UqCA9DAeA1mt9KrAzo9EJEEet
         UdzjsNXhv8r+FrmktI/UvP3ggFZK3p4SzKb3UesHHVOWCBniYlLvmO2DZ9vjqeTGULK5
         YLzPeITffvwlpXXCV2vHdSn6B0HLCeZYMqh/8jmI89Cfa9vRitd/i4QyRwuuuDwDIU5U
         VZP2HTBiYqbZpzUaFRPISwiruKJrVccwnnepk0mF2U36vtlNOfMIvMiDcZJVclG2D/sP
         UsbogX+C3HFzm3H7lrh1FZLx/nElzBKQ6ds9jfKftTRdUI2pqyBUgWO3tT35JXb6M0Za
         9F2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741301997; x=1741906797;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fxo3LiiQNTKlQcr4Ji/p1iFEjZ7lz5XbTu3S3aDyRJI=;
        b=dH+FQm3V8wnDOM8iC0bYnvIeGcJS1STRChQDVp/r0BUtY0RbuPRtqAYwOw66s2GQzg
         RL5o9h0TLuB2gj01dJd29jrKhPOmdwV+vdtZRsqGldntEjVHvXYSvelWI9UO/hOnGamW
         vXbuYii4c71GTwXu1tmNMfcjITcSe9+iy8UUeGU26eMdFMnwdHwq/cZ1vzBpURjaxQm0
         K4xwdJynikMwm01US47glxYSIWBsHjx9hmC3gyF/WsF3nu92gyTPCb0U15gDJ8+cGu7D
         TatlhzhEmkWQBhwz6BxmOsIICOgl7SFd6uD27RSjQCknUqCcmfVgi/O4XWQTH4frmvHx
         gTrQ==
X-Gm-Message-State: AOJu0YwvHMGwHRg2W7oTRxRtfoEeyelOvs4myWCu8ugemsriH8LlxUvB
	wQETCTjc9dcovKCx5/QWaTxEFm2dtDMXh9wjcFeGnXGYiHfnq1i2oDY2kS0sT7sqBDYp3bA/I6p
	c
X-Gm-Gg: ASbGncuSths3zevXdlMXTFRHSoJd8R/+gHP+J0ayaQMnNtI5N0wI4BKEVFrGsDIVtCn
	gMnK8wNh31xXADoAn46JgJKRPovKZJU3V/4pEiqpuCzHwG9C2ky7zQTPb5/tdG0Wl0tgH2zjErw
	7TRoNtJE9olDopFE+59DjXkG12l20c6AQUd1oY3ztx9pN5mdYx3CCzP4V9kjawHuDAsbLHIg9nV
	JK43vVb2vQKo6IC2B4tbAaN4noS+ymfXvvqFMXeRC1xXBkG/6eHcgYpK9ny8czOnaP+9YbuPgZf
	hEeTXsxM9AI3Ka35JhOThhQ1iey6uStP0kkMe/hYMA==
X-Google-Smtp-Source: AGHT+IFmXnyluTmOuYfPv3Nx2/SHzGXxXTxS5SENeOe6m06rRcuyZSn2zgkr3gKu18V6jOPtzyb70g==
X-Received: by 2002:a05:6602:720d:b0:85a:ec03:b12c with SMTP id ca18e2360f4ac-85b1d069c54mr202144439f.13.1741301997194;
        Thu, 06 Mar 2025 14:59:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b119cfdf5sm48421639f.26.2025.03.06.14.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 14:59:56 -0800 (PST)
Message-ID: <2bf0657e-aa48-449c-b78b-df209839a28a@kernel.dk>
Date: Thu, 6 Mar 2025 15:59:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Add support for vectored registered buffers
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Andres Freund <andres@anarazel.de>
References: <cover.1741102644.git.asml.silence@gmail.com>
 <174126247411.11491.2089976822738509043.b4-ty@kernel.dk>
 <32fb7fd4-3e70-45d6-afd2-fae07ed66b1f@kernel.dk>
Content-Language: en-US
In-Reply-To: <32fb7fd4-3e70-45d6-afd2-fae07ed66b1f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/25 5:10 AM, Jens Axboe wrote:
> On 3/6/25 5:01 AM, Jens Axboe wrote:
>>
>> On Tue, 04 Mar 2025 15:40:21 +0000, Pavel Begunkov wrote:
>>> Add registered buffer support for vectored io_uring operations. That
>>> allows to pass an iovec, all entries of which must belong to and
>>> point into the same registered buffer specified by sqe->buf_index.
>>>
>>> The series covers zerocopy sendmsg and reads / writes. Reads and
>>> writes are implemented as new opcodes, while zerocopy sendmsg
>>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/9] io_uring: introduce struct iou_vec
>>       commit: 32fd3277b4ae0f5e6f3a306b464f9b031e2408a8
>> [2/9] io_uring: add infra for importing vectored reg buffers
>>       commit: 1a3339cbca2225dbcdc1f4da2b25ab83da818f1d
>> [3/9] io_uring/rw: implement vectored registered rw
>>       commit: 7965e1cd6199cf9c87fa02e904cbc50c45c7310f
>> [4/9] io_uring/rw: defer reg buf vec import
>>       commit: 5f0a1f815dad9490db822013a2f1feba3371f4d1
>> [5/9] io_uring/net: combine msghdr copy
>>       commit: bc007e0aea60926b75b6a459ad8cf7ac357fb290
>> [6/9] io_uring/net: pull vec alloc out of msghdr import
>>       commit: 8ff671f394f97e31bc6c1acec9ebbdb108177df9
>> [7/9] io_uring/net: convert to struct iou_vec
>>       commit: 57b309177530bf99e59da21d1b1888ac4024072a
>> [8/9] io_uring/net: implement vectored reg bufs for zctx
>>       commit: 6836bdad87cb83e96df0702d02d264224b0ffd2d
>> [9/9] io_uring: cap cached iovec/bvec size
>>       commit: 0be2ba0a44e3670ac3f9eecd674341d77767288d
> 
> Note: the vectored fixed read/write opcodes got renumbered, as they
> didn't sit on top of the epoll wait patches. Just a heads up, in terms
> of the liburing side.
> 
> I'll get the basic epoll wait bits pushed up to liburing as well.

And one more note: this breaks 32-bit compiles due to a bad assumption
on iovec vs bio_vec sizing, so I've dropped it for now. Hopefully we can
get a v3 into the 6.15 branch.

-- 
Jens Axboe

