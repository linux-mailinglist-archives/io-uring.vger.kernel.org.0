Return-Path: <io-uring+bounces-7868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D41AACA7C
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA02C3BE21F
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A60283686;
	Tue,  6 May 2025 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b1rD50nT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55ED280A29
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547771; cv=none; b=tI/gEvTokMA5w1Ab8mfBfFzEhf6P59NaKklP+C+9UMlVC9j6zQHTHaUHD/b2xjyVzSJhi45WXuX3xbOc/nRPtLKQ23ZUdbZBXlEYg6w/2P7HCYDVOrywoiT3J8HXfy3xmIunBA4j6cIFttXXyFU2WN5ZXD330Xqs2TFBzqgRwBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547771; c=relaxed/simple;
	bh=tjQDQwK7zXpD9sBX1qXUoTMEh2KscsKOgZKCOjKCVLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWwisEKSNCR501JYeB2rvfaQ/+n1klOIvn4nLytkuA+WoFptWWtEr2AFW9JvV6b6lRdVEKkQneh91fsfFO8GQxbnWEmdxl4igFOJ8GSKTNv3ztpSS1/sCNijl1CTZvFyf3wOTuqbEfhJXq5MOSUIT9B+KFO8j4NC0oofziC5SXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b1rD50nT; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2aeada833so5137666b.0
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 09:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746547768; x=1747152568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KW3JiidczA0CZBFWj0VeVlg/hVaGsX7mg0OzSWkj6sk=;
        b=b1rD50nTZmpoZlic0tlgHcLYr2SFQIy/l2EU16Q2ORhVzD2qpG/Uz6w2hhIqEuoL8s
         btCKa4PtbTGbFYWHdlo3FTfKUY+inGBK1AfDqe1Rc10/fG1s5g9wiiI7SDWILD1FibsJ
         lHHqRlL1CgMcraE4rZPuMnfmNKMDU6abFEvqKBi2Oe96iY7XP92p+KGppbd1MjVmm8Ln
         vfuIYV5ZnJr8SXvjmswm3jBMnram1IWuRWO+Y8EWBo+ccHLodE5Jop2pbAy5adVD2U6C
         pRat9Sok+v3+mFbj+sz/8e6c54qTJx7C3ifB1bZLJWj7LcvWz4NC6BGLy8E+NnXthMdw
         rQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746547768; x=1747152568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KW3JiidczA0CZBFWj0VeVlg/hVaGsX7mg0OzSWkj6sk=;
        b=qKTdKdDKC95WjcecrtnQYDs+685y4rl4HtO7HbslrGhIz6k6HuKFsnv8y4zwzlb9An
         NeQjmW8YQ8/h5uCjG3xawjKWiR7MwhBVdLxwD7alqaZOo1AS7GRBZjt+HrE39E520e0D
         wut6TtFyPxeJacVMZNQvk4RsnkY2CyCDoPVF8rDxVwOxw9oWFAqLo7bgOJNt3Rk4XDAl
         kRX+03FN+IbM+8kqa35I+F5O2CQmE+41gfIfGW4RjemFiMu1mnqv9xvL5xq4sgItPg86
         sSjXzH5xTCTI4qeF42pDkGcLV7zTYx10hqPVU4rIufurOaVBmqc+piyAs4tViRdvIFxL
         TRsA==
X-Gm-Message-State: AOJu0YywOgPr6WTOKsJX/4Vwp0nt08KNGJvDBrt5gClWe+UWNV+hSEla
	cEDNBYgRM24ej0mEtNhi3lRpD/Ydh7w2M7hkD2G0XXNkoWblpIWRoTvryQ==
X-Gm-Gg: ASbGncu7Twkp2v1hXCsKpooXL9/nVhdqXe6YVf3VP0/TnVqG6VSgRZ+vQqxyabfzJbs
	E31iEw5NxzCSVshs1wt1T2KTx5xWV+RTMHerpUj/1PVHTRWLVcG8xHhK07/eUYgRqO8bWMDBc5Z
	iB6d0JeoVquPKCmlk7ZGqotj2ymbvpll9qbbNm4ocJX0eHHgZLqbCyaanJA0BhS6xwP/2U/MrUn
	Mdj99QvbNKe8ISfqp0osdlaot12BwFyc8h9js9cQzi1KbuurjcZnuQ9DTpbftoYCgzX834CDzC5
	s8oW54xuF6muYSA+sXzUaIXV1RwryaGzR+CFsb1tB6NoqkRH+Pu/4RfYweXb9JNewn/Rqym9pg=
	=
X-Google-Smtp-Source: AGHT+IGgDZI3WBiTFCR3c7wVE/Ls5+hHC0DMZm38uMbvpiZbsNEayXbqylcZDpbFYVvGipbORE9Bow==
X-Received: by 2002:a17:907:3f20:b0:acb:37ae:619c with SMTP id a640c23a62f3a-ad1e7cc4d2fmr28725366b.15.1746547767437;
        Tue, 06 May 2025 09:09:27 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4f70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad18e2d7a88sm669670466b.36.2025.05.06.09.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 09:09:26 -0700 (PDT)
Message-ID: <e6e7f396-9eb2-4990-927b-d4256494e669@gmail.com>
Date: Tue, 6 May 2025 17:10:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix builds without dmabuf
To: io-uring@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
References: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/6/25 17:08, Pavel Begunkov wrote:
> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
> `io_release_dmabuf':
> zcrx.c:(.text+0x1c): undefined reference to `dma_buf_unmap_attachment_unlocked'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x30): undefined
> reference to `dma_buf_detach'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x40): undefined
> reference to `dma_buf_put'
> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
> `io_register_zcrx_ifq':
> zcrx.c:(.text+0x15cc): undefined reference to `dma_buf_get'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x15e8): undefined
> reference to `dma_buf_attach'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x1604): undefined
> reference to `dma_buf_map_attachment_unlocked'
> make[2]: *** [scripts/Makefile.vmlinux:91: vmlinux] Error 1
> make[1]: *** [/home/alchark/linux/Makefile:1242: vmlinux] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> There are no definitions for dma-buf functions without
> CONFIG_DMA_SHARED_BUFFER, make sure we don't try to link to them
> if dma-bufs are not enabled.

Jens, you'd probably want to squash it into a42c735833315bbe7a54
("io_uring/zcrx: dmabuf backed zerocopy receive")

-- 
Pavel Begunkov


