Return-Path: <io-uring+bounces-3175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB50976EBF
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9F231F24DA5
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7447DA61;
	Thu, 12 Sep 2024 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1Kfvyknd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9E13D531
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726158746; cv=none; b=d0B7wWBwp4PHJTcvuHhRgHDeV2f6apYcuZ7DWqfweUcE+W9I4YxIJRK+1V8N71YyYIasBoOVeHkOzQPevHwYd/aITrZ+gXIgQGJCDdID0EAUYZpgUzHDsvhYSxsoDPxPmwAJgcGpphltgYkaeGaMdH8Ookj9386G94hKq8TP0CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726158746; c=relaxed/simple;
	bh=MfDF3SiuMKkG+5hM/6Q5aptXlnElA0+ixSirbEWJyyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cAtpOGpu7XX4vVfh3llkl+wiA5WwRIY1DD07G2siC/YtATNfxygk9cr87lL2gYXIeE0DPOe8wjYje3+32k+NH81PTRSLP8Iib/ewJZbdTru+wsRSsaOPp+jFRuMb4R3P4yljWNyWgyKvM51qAX0a/g+YVRBQpfIDjTBx+5TLPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1Kfvyknd; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82ce1cd202cso55310339f.0
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726158742; x=1726763542; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3urj8tePJutWd/IrbdvsFovEyTtE2721b7veYUpgRCc=;
        b=1Kfvykndhj8jDQ1DJTy82hgqj8tl6dXVRG3+whmxhhozld91z+eyk8Jhx9RGRiYCYR
         dc8NajjXSANLFzutB1fcKS7nSpgrfHVdTfY+C1caAHmOrDjcWqhh8yUG02EwZ+HW40Uh
         sR7xw+xEd1Uap8zwfgEG9ymmD0mv0RdGmp4zZXcYb/KYgdZvjdFv/PKW+Zln2gUAaIpf
         RsBCE4/NaH55qA6kYBBo/RAz2EjkHoniNvUhL/F/xKh29MzWAVNbAgJ4lV8BaRlpkIxr
         WCbKbTHYpDKzZsD6+vIlTgrtS0zeqRXhTo8D8uGm1OzjwnLBiSeWlZPQGUwcwFDLXjTQ
         l5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726158742; x=1726763542;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3urj8tePJutWd/IrbdvsFovEyTtE2721b7veYUpgRCc=;
        b=R2mEI66bea+p+JSAse38CK7zKVzPFzSA9oRYmjFSGmp25yzujXqFBZrzSCY9UCF0UF
         O5O0c0ZwRqpKU04kDRGVea3GgO3t/JVhZkD2L0xfV+EqunSCH0qV2PduVddOABUqFXry
         XW3yXx0gzx3RBjNfout+B9VWPZ9a7KGd6sFe0Pfl3hFvuzZ5SfqLQecWyJpeRuPpixU1
         DEWzz8271ENqzzlq3yRQLwOcvD7sDI0Htcxhk2xgeTP85cux0rKbx6yQv7Xzpf5XJIYq
         i4D9meJwAD1aoarMrOU3aZo4+mP+YlVOScqfMWgd5dnJID0RKginALJtyaISb79saYij
         zOxA==
X-Gm-Message-State: AOJu0Yw5A49MiQEm1tGSP+6b5bayZvHhwy/3dtBcvvMbddCq+oyn5jUT
	/78s15zRFqeuPTbWNWex6bzGWenyuAGiW90Yj4cK0WnPKwgDh1FVxHd7cTexS2xFFIpWodEO6kl
	g
X-Google-Smtp-Source: AGHT+IF5GUUBvcN/9IQWpyuBohIoLZhgni30cLRBwBi9s2pQziYqYiYvVShYoXxMqJMmlwI53g9KSw==
X-Received: by 2002:a05:6602:3407:b0:82c:e4e1:2e99 with SMTP id ca18e2360f4ac-82d1f958b32mr349774839f.11.1726158742335;
        Thu, 12 Sep 2024 09:32:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f56d1b2sm683188173.38.2024.09.12.09.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:32:21 -0700 (PDT)
Message-ID: <38a79cd5-2534-4614-bead-e77a087fefb2@kernel.dk>
Date: Thu, 12 Sep 2024 10:32:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
To: Pavel Begunkov <asml.silence@gmail.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Conrad Meyer <conradmeyer@meta.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
 <ZuK1OlmycUeN3S7d@infradead.org>
 <707bc959-53f0-45c9-9898-59b0ccbf216a@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <707bc959-53f0-45c9-9898-59b0ccbf216a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/24 10:25 AM, Pavel Begunkov wrote:
>> an entirely different command leading to applications breaking when
>> just using the command and the hardware doesn't support it.
>>
>> Nacked-by: Christoph Hellwig <hch@lst.de>
>>
>> to this incomplete API that will just create incompatbilities.
> 
> That's fine, I'd rather take your nack than humouring the idea
> of having a worse api than it could be.

How about we just drop 6-8 for now, and just focus on getting the actual
main discard operation in? That's (by far) the most important anyway,
and we can always add the write-zeroes bit later.

-- 
Jens Axboe

