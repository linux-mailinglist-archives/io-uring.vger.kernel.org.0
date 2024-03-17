Return-Path: <io-uring+bounces-1051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8B787E04B
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DF201C20BC1
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7A633D2;
	Sun, 17 Mar 2024 21:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YdQJpWWZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8620B28
	for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 21:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710710691; cv=none; b=A0ZIJ/uaO7NVQ3z+UN9SXLcvqP8g5X9eJcCwbwMuY5JF0yLSd9YUlH0KP30I++6w8zKDOXkQq4at+Qd0nA1LmB/L7UBbe2ftrnHTq92vrKywpvp/xEJiEfxz5xKg9t9IQlkZ/jYrEaDneGhUxhyiAt7NBAhPuK69V1mJgmLBsLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710710691; c=relaxed/simple;
	bh=N8dgLP2SSfoppgJ+ojsdIcT6EYRo1CDrti+8OsjZ1FU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEvMPZJYMLQO4WzGFbkl6Y38zOfYiLdC2hlToGBF07hPPTesSKOwsdkUNmiGoWsSZ8JhwJ7s+dmjEAiTcP1pNhhzy5liygyX3BS3/67g1vSW/jC39bNoSn8mUGpOooCcPyiH9Oe88LC9iKV00zWNPiZybLfkGxo97OteAblgNQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YdQJpWWZ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so1296202b3a.0
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 14:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710710688; x=1711315488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ITHlsXPSOcvAY/NHzbO7gFv0vp0mY0cvSt7zE79jgwY=;
        b=YdQJpWWZoZygtLK6ARlcPBzKqlQ2YtuHphOQaf3xdMDiemNNLkimjuyHMrZ8u5AqZy
         bfRqQ/dRiyNav8xPeMugUPw7D72XoaCVrzFpkl0XfcGiXoQMsHi21dwLEFiC88ULmdPH
         1qcZcmPfnDxb6jn5vjyPOGeAOUTfqT6KTEJe34B4Hx3kauKYcSHGoXcqLR9IC23VLbsj
         TPmXIf6v8gYKtlVaZNB3RsJhEZ1PA2PC8Vmf+wJZalD78A4KBILiACq94obB3oKu2vBd
         SVpZRsRzG7KdWUA9q20EwAvQLZGMSgjEeSlU6sjh9R9pT9Z+dlDwKLi9aiGalZF+uPo+
         ILIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710710688; x=1711315488;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITHlsXPSOcvAY/NHzbO7gFv0vp0mY0cvSt7zE79jgwY=;
        b=IAo22Lvm97uFG5oVsnXwdI4ewGH9cAUia8vvCweUySV4iQovFBHOqJaOMNfG/IoOJa
         JBvnnyvUDpvBo2QIC7em3kPmBCzPjC7YnxH0ba3X3MiwxKeXvgvAiWe3Dz9FAc0ih0PG
         C049d93W/guAIv7fDedto1Lc3k6lmFrFOOh6w2h6/HLwriXivxUdEHXsW4DfonNYwZwy
         YE/tLa/Dlx/wkcGxdDlFin0A5D4DnRLW9qVNsZ2h54sdym9dgjmeFN2ShvtzeMhT2f1C
         2FK5rbEutrdUQpu1RANDnptFH1ucnGeMTAWDwK1cwFSsSga04yayzurEape0TrRZ9nzU
         hFEQ==
X-Gm-Message-State: AOJu0Yx50zB8iDI8Olv48ATgQFcqRlStSSywhuCvpe8AFgp0W8SBSdmf
	dQPwIQcfMq3NQXGi/23API4bt9153T3cNFvAS/MdImRn9sjQWBBMhKVEzpkaduk=
X-Google-Smtp-Source: AGHT+IGn6SA/cKwheB3ssPQt+qOlumGWkPFLNY5GYAt8HfY+6Q95wnZCn+8Md0OY9UPHO+8lilcYUQ==
X-Received: by 2002:a17:902:d2ce:b0:1df:fbc3:d130 with SMTP id n14-20020a170902d2ce00b001dffbc3d130mr5992381plc.1.1710710688209;
        Sun, 17 Mar 2024 14:24:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709027ec900b001db9c3d6506sm7811817plb.209.2024.03.17.14.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:24:47 -0700 (PDT)
Message-ID: <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
Date: Sun, 17 Mar 2024 15:24:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora> <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
 <ZfWk9Pp0zJ1i1JAE@fedora> <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 2:55 PM, Pavel Begunkov wrote:
> On 3/16/24 13:56, Ming Lei wrote:
>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>> On 3/16/24 11:52, Ming Lei wrote:
>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>
>> ...
>>
>>>> The following two error can be triggered with this patchset
>>>> when running some ublk stress test(io vs. deletion). And not see
>>>> such failures after reverting the 11 patches.
>>>
>>> I suppose it's with the fix from yesterday. How can I
>>> reproduce it, blktests?
>>
>> Yeah, it needs yesterday's fix.
>>
>> You may need to run this test multiple times for triggering the problem:
> 
> Thanks for all the testing. I've tried it, all ublk/generic tests hang
> in userspace waiting for CQEs but no complaints from the kernel.
> However, it seems the branch is buggy even without my patches, I
> consistently (5-15 minutes of running in a slow VM) hit page underflow
> by running liburing tests. Not sure what is that yet, but might also
> be the reason.

Hmm odd, there's nothing in there but your series and then the
io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
merge window -git cycle? Does it happen with io_uring-6.9 as well? I
haven't seen anything odd.

> I'll repost it with the locking fix for reference, would make more
> sense retesting ublk after figuring out what's up with the branch.

Yep if you repost it with the fix, I'll rebase for-6.10/io_uring.

-- 
Jens Axboe


