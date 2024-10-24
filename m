Return-Path: <io-uring+bounces-3976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 766B49AEA6E
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DB4C1F23E12
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0125E1EF943;
	Thu, 24 Oct 2024 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIBpaoKr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2151EF0A0
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783717; cv=none; b=mUg7f3JrgSWGid/Hgscc5//ekqBY2squ9HKZHWCpnvyQME7GWoI3d4+0tGvzSlKlefyo4EkXS9wU1Gqdwf2db1wDKBkI8ZdkxL+opvrFIeXQf8Mo3NDdJCoHn8XQdb6uLjgQGdqX06ytS2OVVorFHkzL5NUtFT/gweWDrMD22n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783717; c=relaxed/simple;
	bh=B3qkbB52oPf5JZnZBf+JdNUDx/CGSPeGwYOzVrvbUOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u9Ik8IgDgTSdJyM5ml9Kw/a7vyUukvPS0YWLWptucMFulUfyWAu8trjGbytscotq3KkY3YfquMv0L7zmlybzZ19U4hP1LGJL2cg2llWe/R0osUh64gdaBKkI40N0KGj7N6grR0mzxbCZ78Z5MNxZ1jb7+CL2p6U8PfWtbAhzPGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIBpaoKr; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f2b95775so1226832e87.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729783714; x=1730388514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kmd7QA3sDyP11x7nl88K53NuwLuY++1O1d1jqMgaX1c=;
        b=XIBpaoKrzP3i3OmHLk52jXSV8ad6Qo2cBn7pNfTUdc+TaKWMiksefTIFBBT7k0fM0E
         gwFOMWgKukDbt3dEFxACGdX6jHJCqfuuSGeA9A0rIClwo5fmyDoXs7rkvKPmabxxm6dm
         EPsNYPO1blkRgq02XPeBbegRTxJy52WdwTlx3atYn38pZsEB+9ZfehyIMmcCBTYKoyuk
         l2qpggyPHbMGL/Z8jDTfT23DOd54kzhPT/gyM6xrp2M2q1odtoj5yrXBxokhsqZAil5I
         LkQlmI6YYvoXSHIQK1zCtzg4F4vD3MgfvBDbJKM57pu4thFlMfw185v85AnbVRjV2EKi
         WpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729783714; x=1730388514;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kmd7QA3sDyP11x7nl88K53NuwLuY++1O1d1jqMgaX1c=;
        b=VrbWV/yxSWwkK4ftYJeHIaA5ox+jKqThtGyUJoBYaXsKmwYeKV84DyJpe3ZJ26wOUM
         vw3lxDOjJie1CSfUf49ZPO999VI885WfWdxiLvLBxY1689UeHQWyTTpNLEaSaaihiOHU
         LVwJCs6xbrBUHC0vMRxorr8s4gh08YIj7aEWD5Y+LAol7eN3PExL+OgZob6d91DjmItt
         zAhCMEmQAfiRVyN0Fv/FZ0WcIYWL+IvbzCOVRsD1uODbK01aCT+6YzpSN0G4Iwh8fMFy
         6okX/5g3QjSmu5RivXgZAeFZ8A1JBE/QfcMRi1Pt6aUYTGcP2d9cUVbE6uII2o3Rfzqc
         XGAQ==
X-Forwarded-Encrypted: i=1; AJvYcCURUnHwwTJkHM26CN3EfJ1t8hGO/1HcatqO9jCsE4T0/wHCTmbI6jO4rkjiSAB/KJkGcfhbEuKuUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxhiDtcBfGqRwYM+5xxnVtat5z4TPYIYVaI/yiHrntOgAVktIs
	4Vxyg08ABCdiZMYwnkArzI+6eXR8eMUqTNKe3yMJtX3d89U5vZtV
X-Google-Smtp-Source: AGHT+IE+4zzP2nNCLZq3u9JMH2LtCnmOoUso8tq+H+5t4EVFmCEqGVXK6k2wcenN3LkoiC0g+sAlxg==
X-Received: by 2002:a05:6512:2345:b0:539:e0a4:1ec0 with SMTP id 2adb3069b0e04-53b1a34cbcbmr6824058e87.29.1729783713678;
        Thu, 24 Oct 2024 08:28:33 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91559951sm629359666b.106.2024.10.24.08.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:28:33 -0700 (PDT)
Message-ID: <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
Date: Thu, 24 Oct 2024 16:29:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 14:52, Jens Axboe wrote:
> On 10/22/24 8:38 PM, Pavel Begunkov wrote:
>> Allow registered buffers to be used with zerocopy sendmsg, where the
>> passed iovec becomes a scatter list into the registered buffer
>> specified by sqe->buf_index. See patches 3 and 4 for more details.
>>
>> To get performance out of it, it'll need a bit more work on top for
>> optimising allocations and cleaning up send setups. We can also
>> implement it for non zerocopy variants and reads/writes in the future.
>>
>> Tested by enabling it in test/send-zerocopy.c, which checks payloads,
>> and exercises lots of corner cases, especially around send sizes,
>> offsets and non aligned registered buffers.
> 
> Just for the edification of the list readers, Pavel and I discussed this
> a bit last night. There's a decent amount of overlap with the send zc
> provided + registered buffers work that I did last week, but haven't
> posted yet. It's here;
> 
> https://git.kernel.dk/cgit/linux/log/?h=io_uring-sendzc-provided
> 
> in terms of needing and using both bvec and iovec in the array, and
> having the suitable caching for the arrays rather than needing a full
> alloc + free every time.

And as I mentioned, that can be well done in-place (in the same
array) as one option.

> The send zc part can map into bvecs upfront and hence don't need the
> iovec array storage at the same time, which this one does as the sendmsg
> zc opcode needs to import an iovec. But perhaps there's a way to still
> unify the storage and retain the caching, without needing to come up
> with something new.

I looked through. The first problem is that your thing consuming
entries from the ring, with iovecs it'd need to be reading it
from the user one by one. Considering allocations in your helpers,
that would turn it into a bunch of copy_from_user, and it might
just easier and cleaner to copy the entire iovec.

And you just made one towards delaying the imu resolution, which
is conceptually the right thing to do because of the mess with
links, just like it is with fixed files. That's why it need to
copy the iovec at the prep stage and resolve at the issue time.

> Just a brief summary of the out-of-band discussion.

-- 
Pavel Begunkov

