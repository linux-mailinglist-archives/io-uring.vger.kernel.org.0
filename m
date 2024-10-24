Return-Path: <io-uring+bounces-3985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8EF9AEB64
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3FD01F217AC
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03ED51E1311;
	Thu, 24 Oct 2024 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hS1OdpPv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3208158A31
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785979; cv=none; b=GhM6ZZC/sNL90GOFBhhqQCo3KJuTxeO0t4wBGQWs5AI40Wcfc7eOzLreb9hgSBycQ1/oZN5pV8tnxDJviTh8aV3tdBVA02nYrU+2nqO4ZyeoRf9S3ltUo4jhxJSkRTzB19uxybS/EG+EY4mKgn8zs4eyqTTQTMPdK9V+TKiY6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785979; c=relaxed/simple;
	bh=djG48BVyhTnPsdfqI5yX+V2IGYSAK00boAoQ1IZvUmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QL96EmyMwqeojye0bKYq1J5ReWRMLcvUN1ryTFZntHnGuyXM728YcPYu0sddcRFP4mdouqMswnfToLJFwgNRuVNbwGgav39+sUD8ljiuwbBcm8MpYdmHS+UIt/lT4GFVgaaO+LTM3V2sw9ZWLN5zBiUhxyWcWR9axra0juheh1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hS1OdpPv; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a16b310f5so156266466b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729785976; x=1730390776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FRjMLH0iZKS/uVG9Tp3CrUxFBIXDpjjYnBfhpGLu9Pw=;
        b=hS1OdpPvLsMOjIketZYvzOyeOQxTlmfFbE7xcMbQTk6vl25Srkdlfy7e3BtjfZJqdW
         ytBlkXbp7137+hZfqeVXqgdxQrBcUviWsNpdRqL1uIxzza5WdVmIuiJpFX2LnqiYpdRg
         pDgCNUKYELHcsCNoK0n2G2zCDMD9GTj5qE5L6PRKLf+0cvxm9EYbG1PvC2GRE8MUPxJq
         19j25nra1lW/klQHxKvHBXZXgHNhsy+DbE9jtmTbHlYa0G9VhQj0IsZ2IwDd2Xoy8jkT
         pRcUIGLQkl8XNSa/0nrSJbkVZ+p0pn0LVnoVgpA1IkWR0fieqkNUHn/UnkryOtpr9BVg
         ARiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729785976; x=1730390776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRjMLH0iZKS/uVG9Tp3CrUxFBIXDpjjYnBfhpGLu9Pw=;
        b=ruptwAjR6sBDXBuF3mjNNrH8NEnCTTmHQBzvtQcz9G6EqhgqBs6LW0h4ppYbgQn/td
         /Lprlr/anv4ogOkIW0r7PoqDBJwgf/TLxW8c1rhsEGpiABKtjmgTs5Twl309ObbzdpAk
         6hh5sRbFHa1WJuINFWPd9Y27JMkdzzmrjEOAFZGqOZUXVgdwsBim/DpsTCqE6FxYP+ue
         SHQ5llPcD3dmP6iOH2uh2PM1LgmpzAuEXk/gvolYn2ydx06SuD0VOhgZhKPJIFwJQG46
         pP0mGwt2UFnhVu3FXdZWlsE9y4QG43/CKM/28qLU//7fmLgAPoe2c/+jSjApA9HNTRKA
         ofaw==
X-Forwarded-Encrypted: i=1; AJvYcCVhaQTPMiuLEmeX8wb8XdZxpk9H2xn//Z7zPV88h9jpdUk6eY6oTAaUxX/olhxU+Vxjn74olwYTJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBc8+YTip/3vCcqAvgDHlbI8UAYnUDYHdPTNLECqdZhWUW/7o5
	Q1bBuZjYfdzAgMsujOTU4UPt1tsOaWqPhzD/LNXwvRozlmR6VPFmoJHpqQ==
X-Google-Smtp-Source: AGHT+IEMY5JiYiki9/B4oIF50R8XzLtrZwl4F2dIfBUnFsw2Md72I0EGf6MYENp3K/qZKFxIcph8OA==
X-Received: by 2002:a17:907:72ca:b0:a99:f861:ebd with SMTP id a640c23a62f3a-a9abf890c03mr666705366b.14.1729785975722;
        Thu, 24 Oct 2024 09:06:15 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9157221asm633767566b.161.2024.10.24.09.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 09:06:15 -0700 (PDT)
Message-ID: <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
Date: Thu, 24 Oct 2024 17:06:50 +0100
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
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 16:45, Jens Axboe wrote:
> On 10/24/24 9:29 AM, Pavel Begunkov wrote:
>> On 10/23/24 14:52, Jens Axboe wrote:
>>> On 10/22/24 8:38 PM, Pavel Begunkov wrote:
>>>> Allow registered buffers to be used with zerocopy sendmsg, where the
>>>> passed iovec becomes a scatter list into the registered buffer
>>>> specified by sqe->buf_index. See patches 3 and 4 for more details.
>>>>
>>>> To get performance out of it, it'll need a bit more work on top for
>>>> optimising allocations and cleaning up send setups. We can also
>>>> implement it for non zerocopy variants and reads/writes in the future.
>>>>
>>>> Tested by enabling it in test/send-zerocopy.c, which checks payloads,
>>>> and exercises lots of corner cases, especially around send sizes,
>>>> offsets and non aligned registered buffers.
>>>
>>> Just for the edification of the list readers, Pavel and I discussed this
>>> a bit last night. There's a decent amount of overlap with the send zc
>>> provided + registered buffers work that I did last week, but haven't
>>> posted yet. It's here;
>>>
>>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-sendzc-provided
>>>
>>> in terms of needing and using both bvec and iovec in the array, and
>>> having the suitable caching for the arrays rather than needing a full
>>> alloc + free every time.
>>
>> And as I mentioned, that can be well done in-place (in the same
>> array) as one option.
> 
> And that would be the way to do it, like I mentioned as well, that is
> how my first iteration of the above did it too. But since this one just
> needs to end up with an array of bvec, it was pointless for my series to
> do the iovec import and only then turn it into bvecs.
> 
> So somewhat orthogonal, as the use cases aren't exactly the same. One
> deals with iovecs out of necessity, the other one only previously did as
> a matter of convenience to reuse existing iovec based helpers.
> 
>>> The send zc part can map into bvecs upfront and hence don't need the
>>> iovec array storage at the same time, which this one does as the sendmsg
>>> zc opcode needs to import an iovec. But perhaps there's a way to still
>>> unify the storage and retain the caching, without needing to come up
>>> with something new.
>>
>> I looked through. The first problem is that your thing consuming
>> entries from the ring, with iovecs it'd need to be reading it
>> from the user one by one. Considering allocations in your helpers,
>> that would turn it into a bunch of copy_from_user, and it might
>> just easier and cleaner to copy the entire iovec.
> 
> I think for you case, incremental import would be the way to go. Eg
> something ala:
> 
> if (!user_access_begin(user_iovec, nr_vecs * sizeof(*user_iovec)))
> 	return -EFAULT;

Is it even legal? I don't know how it's implemented specifically
but I assume there can be any kind of magic, e.g. intercepting
page faults. I'd definitely prefer to avoid anything but the simplest
handling like read from/write to memory, e.g. no allocations.

> 
> bv = kmsg->bvec;
> for_each_iov {
> 	struct iovec iov;
> 
> 	unsafe_get_user(iov.iov_base, &user_iovec->iov_base, foo);
> 	unsafe_get_user(iov.iov_len, &user_iovec->iov_len, foo);
> 
> 	import_to_bvec(bv, &iov);
> 
> 	user_iovec++;
> 	bv++;
> }
> 
> if it can be done at prep time, because then there's no need to store
> the iovec at all, it's already stable, just in bvecs. And this avoids
> overlapping iovec/bvec memory, and it avoids doing two iterations for
> import. Purely a poc, just tossing out ideas.
> 
> But I haven't looked too closely at your series yet. In any case,
> whatever ends up working for you, will most likely be find for the
> bundled zerocopy send (non-vectored) as well, and I can just put it on
> top of that.
> 
>> And you just made one towards delaying the imu resolution, which
>> is conceptually the right thing to do because of the mess with
>> links, just like it is with fixed files. That's why it need to
>> copy the iovec at the prep stage and resolve at the issue time.
> 
> Indeed, prep time is certainly the place to do it. And the above
> incremental import should work fine then, as we won't care abot
> user_iovec being stable being prep.

Seems like you're agreeing but then stating the opposite, there
is some confusion. I'm saying that IMHO the right API wise way
is resolving an imu at issue time, just like it's done for fixed
files, and what your recent series did for send zc.

-- 
Pavel Begunkov

