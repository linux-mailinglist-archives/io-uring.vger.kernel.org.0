Return-Path: <io-uring+bounces-6089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6ED2A1A651
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2C82160A07
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B098E20F971;
	Thu, 23 Jan 2025 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lRp+jkFM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4E738B
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644093; cv=none; b=t8Q5Fl5EhWT+G4TE6WWx79KtSHASErKAOpYcrZBkIRKbW8BGJtWfCeovE89GaSYjxjQRDgI85cLzGxsrGOGP16Rob6wKCvOW+Nbsm5aS4waXvEyZYSjpFZG+tEcwB8sp1o9ctxO161ATswCpe1CYlx1x7qB1V+bWdyo6A/5T3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644093; c=relaxed/simple;
	bh=EmNUwxsBJCSBRFvUm4Zy5VX/NdgaiY67itb6+NXkFew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GW5uGbNorSqyv4QP6Q4PdIsWTD3gY6QlE9xMaSsNEa1koVH18SZVxp//UCXIv0j9I5puNb/B+2V9sevyytNJCS80XrenEriEYg6aYQJOndtMGX5MzNPejtZEtK5gdyTRtV1rRi7Wg1c1vfjQSX0LTMpwR2AdgRZb8X4nXLm6RAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lRp+jkFM; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844ce6d0716so74821239f.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737644091; x=1738248891; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6LJeCpa8Z2zsu5IlzJvJk5sgD6fURtN53DJtBN/8z4g=;
        b=lRp+jkFMIeLr7qxAL2NtLBCgniSJijse5zjqqRmqg1AtdJ2hjfMYQ78PpQCqPgnHJT
         NQXjlX1pF4ebNjD3iIeAV6ZZdkMtJKipPCOTBOMv0R96316EpIN6gb8IMh6O8I24hO0E
         oKyQBmwNiI7G5BzYptc6UPUC1190dxskvs4qS+FCHgBK5fQChzLHV0E5Anwsc4Ku9vMG
         n2mjy0/DmbAL6QzUb1ck/1JtnURay0n2gVDm8cHZxUdLe252wkbtqnDgV0sOMRUF2+yW
         QbtqVdtzRJd09zsEfZxNG8X9Hs5bzTsdWAQaTObKXeehiCqkNYczvPT6RGJJXU2i1209
         bpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644091; x=1738248891;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6LJeCpa8Z2zsu5IlzJvJk5sgD6fURtN53DJtBN/8z4g=;
        b=j4zhWfkGLKFC7Lfp0w/IHJjVzCrGF+bpy2ixE1WwGkagc+NHRJJNCIUnJ7s5dfbreE
         /oxY4bI45gORCtJgmAXnf9pg1y34h57TZPmlKKPC+J2xu4GXTrLfVXRoX8IkerIWoOb/
         a/4IMClHK7W4KEU9HwL0r7LdF12HRFKafL0CE2u02GiFkBV90/9hBehm3ZIdjMdvyaWU
         aOuPNyXrHNeZjr7W19pKvGBWyuuW4H4UAupl+kX/WYf9jHcEYsNWMwJOBE/8mJooez7c
         K4DtWyqxnDy7IOWxjkG8Qx7x7++NZ1XduTchYr/aJDmgrc7k6kD/+svSJ487hA3Lx4KK
         GCXg==
X-Forwarded-Encrypted: i=1; AJvYcCVyKP9itKnzcYVoYpSgSVkWSacxCtQ2HZaGdBnhl2IcmSs2d2SE07A2igRVCxq/Xz8MT0JpF1l/Gg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0EulkQIIULCyMy+foCc+EVs4ut5kStO7Gg46yz7EyS6KHS/wS
	Nu9dRoi77QwFpUc4uBsLsgvJVWOMd1h3RlqjWftCA6p5J+lHvgiG/jhpt0uCD0w=
X-Gm-Gg: ASbGncvdnz3GzM45/qrKO0+Fdz1fP4pxmTurcrFA6nmJtHgEs4Ae+UvoRZ50tzPxXWL
	EWxTzE7O/7W2lr/SauCsUAkbNMUnRPyWe5le8+bI1ucazKprLTHONrRKFrl5BFVS35l8GmwrjGr
	BAGC6Kc4xVuCVOPvTkW3MC7DcZTdCY5rFkSMv0MxfmhH0hy1AB2bG1ltaYObgQutr/Oz3wJEJ7i
	X35zJ7jQkgh8eOpanmojHak4hNmmJX5At3PPv9w4S0N9YY+VzIFi7ZIKQuduAw8hiBHDs9BE0D6
X-Google-Smtp-Source: AGHT+IH/h8j8H7lhoMMUrqzZlOnIdyQlW/ZllSk1c3YxcotoM3L081+AcYu/H2JwQmaZ9HpHci2GFw==
X-Received: by 2002:a92:ca47:0:b0:3ce:867c:f51b with SMTP id e9e14a558f8ab-3cf7447e655mr203072645ab.14.1737644090757;
        Thu, 23 Jan 2025 06:54:50 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71aad85csm42327395ab.31.2025.01.23.06.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:54:50 -0800 (PST)
Message-ID: <702a82a5-f503-4c48-8f8a-8d2833c17b98@kernel.dk>
Date: Thu, 23 Jan 2025 07:54:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: get rid of alloc cache init_once handling
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-3-axboe@kernel.dk>
 <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 7:27 AM, Pavel Begunkov wrote:
> On 1/23/25 14:21, Jens Axboe wrote:
>> init_once is called when an object doesn't come from the cache, and
>> hence needs initial clearing of certain members. While the whole
>> struct could get cleared by memset() in that case, a few of the cache
>> members are large enough that this may cause unnecessary overhead if
>> the caches used aren't large enough to satisfy the workload. For those
>> cases, some churn of kmalloc+kfree is to be expected.
>>
>> Ensure that the 3 users that need clearing put the members they need
>> cleared at the start of the struct, and place an empty placeholder
>> 'init' member so that the cache initialization knows how much to
>> clear.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/linux/io_uring/cmd.h   |  3 ++-
>>   include/linux/io_uring_types.h |  3 ++-
>>   io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
>>   io_uring/futex.c               |  4 ++--
>>   io_uring/io_uring.c            | 13 ++++++++-----
>>   io_uring/io_uring.h            |  5 ++---
>>   io_uring/net.c                 | 11 +----------
>>   io_uring/net.h                 |  7 +++++--
>>   io_uring/poll.c                |  2 +-
>>   io_uring/rw.c                  | 10 +---------
>>   io_uring/rw.h                  |  5 ++++-
>>   io_uring/uring_cmd.c           | 10 +---------
>>   12 files changed, 50 insertions(+), 53 deletions(-)
>>
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index a3ce553413de..8d7746d9fd23 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -19,8 +19,9 @@ struct io_uring_cmd {
>>   };
>>     struct io_uring_cmd_data {
>> -    struct io_uring_sqe    sqes[2];
>>       void            *op_data;
>> +    int            init[0];
> 
> What do you think about using struct_group instead?

That's a good idea, better than the magic empty variable. I'll make that
change for v2, thanks!

-- 
Jens Axboe

