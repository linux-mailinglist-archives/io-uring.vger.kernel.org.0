Return-Path: <io-uring+bounces-4616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC30F9C4B4B
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 01:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 857631F22F27
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 00:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEEF20110B;
	Tue, 12 Nov 2024 00:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UohowMi4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37CA2010E0;
	Tue, 12 Nov 2024 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731372823; cv=none; b=LvMcgff7ImLDepl9RIJv3NspUbgTJ5C1JkFB5oDlB8/gNPacwXVWSZ/kgkIZSBEFLmwGRekXjWK6Nuw5FBzMIpxkluYrOMfppKj0yoe+fKWhgp5lhrBzVjHmKCkxcoiqHj9CPtAwzUi7yUd7il/Jd8uQyOQS0e25Asv/551WTuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731372823; c=relaxed/simple;
	bh=HQy4wUOHoxxFsVpvWmr+RW+R0IUULbvXjkQL4Ta0L8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YjIiAgWEL3qjrPtGkbmNr/N5WfSKsnWMcglLJjH99ky+N76aYOWtRP3MI3NDCtNCyq7TS856aoWAsSxRapLqrm7SxY50M1C2kfwgMXbF7oZ9Y3CZLJlmFruSpKHLIp4bkVZw+rjwER38RNAV9Yn5iymqg0ecMDm592LOR3D1vfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UohowMi4; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4315c1c7392so44822685e9.1;
        Mon, 11 Nov 2024 16:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731372820; x=1731977620; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0aZxHehuFin5Xrs40VllxGZ7a3/ahEo9jXemQX9Fay0=;
        b=UohowMi4xlNExOQIesJZWov3ir2jf5h0StZpwu0JR4G3XX7bSy6YrWUUMHsz2Wkn4b
         T9/pC0UPPxzsSGos8kQ7FwPfR8v6ltelPvEWD9HGC9Ps9ipDZd6a7lWM0pB54Usna3qc
         ez/Mn0/i/7s8KqmYX8JigE4FJJLfx+XnS9lWIiX0UZYHTGbJtr9nOLRoO2FoZbi8vlCD
         0o8jO62REFpSl4SjuXBMclISmW+b60gYHvewTZKC5JNIe6Md63eQp6NmBeLSVgPrMh9U
         V3Qr1v2WQ//UsSl/zfimgf1W6R/fj7bih9yTnGevgSIHkAzT04WZf2kQTBe7c+l1izGN
         4B8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731372820; x=1731977620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0aZxHehuFin5Xrs40VllxGZ7a3/ahEo9jXemQX9Fay0=;
        b=HDhG2O5mOfkEsuL3JbeH7v7Khf6FGrzljcReUx2ZXXUUj+K37bVcw6U+JE4Upz6FFu
         Nuvg9Uj5YKjY5h35of6Axp8OeXREegl1lrbMRQQMgUHfZyPucH7mE8AFRzxzfJ/Cv7qZ
         3AA3LxREZJfF/eX8ti5CY6E1yPGhTeUed0MMHvmnnnclamU0sFRJnZqf25NdBPEctFFi
         ad66kEyEN2LQwXtrwSN4AcEUhjUCGOMW31H/TI+3L1cxwGzLHr7Rqi4vPQ1mbPFE40Uz
         LSO2R5neCcOaqMHlUg14+s6x3DZvGfrdv9+rKJGvKUkCt728NSCImanF1ZxtEm1clhxY
         iZow==
X-Forwarded-Encrypted: i=1; AJvYcCUfFu4eqQOEmGDxkRDIVDBSfPuJZ6YTtGz74VZj0g+2fbCLKKADu84ZVmpy6dbwsyTxs/viZg2l1jxhdQ==@vger.kernel.org, AJvYcCUoQSBodwd3oHlV1Q6jdRMQE9An+2W8VMJ9vfvb8RpKDYMlNT/TfIWuCy1YhHXAwcVYBxU1Cpm2ylztRSw=@vger.kernel.org, AJvYcCVhytddANT4bNV9Gf8MHqXX4FpfzBQR5vm4SHS0TtWgc/1+Se45S+q1XPKhCiOlMNtiQ94PBEiv+w==@vger.kernel.org, AJvYcCXOlr6cUqUQJQWPYp5cRT8P85ao+HrdPmfGwGB+r5w4DatojwbznjqjUAih8DEUCYXL6Ehgx7b5xx1wBcVJuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbcDgxP7GXZRFtLqf8TDhPagzRBftHCIhsPJp4uvWcaBqbZ+S8
	VSh9gRroy896AkNsNXRnswOResE8qAdKuVxj6vfHQK1SmW8mamq6
X-Google-Smtp-Source: AGHT+IGwHpsOMIYldPnZtYdi6bZCchFzKZKPBSbwlgWRj8qHSABPttz33F7Uj57ko9bJY5t4p4ocvw==
X-Received: by 2002:a05:600c:1d98:b0:42f:8229:a0a1 with SMTP id 5b1f17b1804b1-432b751dcb8mr122259075e9.33.1731372820008;
        Mon, 11 Nov 2024 16:53:40 -0800 (PST)
Received: from [192.168.42.75] ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381eda137dbsm13779210f8f.110.2024.11.11.16.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 16:53:39 -0800 (PST)
Message-ID: <72bb4c21-e597-497f-b54b-d09c6f753d13@gmail.com>
Date: Tue, 12 Nov 2024 00:54:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Anuj gupta <anuj1072538@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 martin.petersen@oracle.com, brauner@kernel.org, jack@suse.cz,
 viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241106121842.5004-1-anuj20.g@samsung.com>
 <CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com>
 <20241106121842.5004-7-anuj20.g@samsung.com> <20241107055542.GA2483@lst.de>
 <CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/7/24 07:26, Anuj gupta wrote:
> On Thu, Nov 7, 2024 at 11:25 AM Christoph Hellwig <hch@lst.de> wrote:
...
>>
>> struct io_uring_sqe_ext {
>>          /*
>>           * Reservered for please tell me what and why it is in the beginning
>>           * and not the end:
>>           */
>>          __u64   rsvd0[4];
> 
> This space is reserved for extended capabilities that might be added down
> the line. It was at the end in the earlier versions, but it is moved
> to the beginning
> now to maintain contiguity with the free space (18b) available in the first SQE,
> based on previous discussions [1].
> 
> [1] https://lore.kernel.org/linux-block/ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com/

I don't believe it helps much anything, placing a structure on the
border between SQEs also feels a bit odd.

-- 
Pavel Begunkov

