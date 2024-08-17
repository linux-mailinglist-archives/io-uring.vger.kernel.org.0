Return-Path: <io-uring+bounces-2816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF4F955972
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 21:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFD7E1F21ABF
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 19:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE59C153;
	Sat, 17 Aug 2024 19:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L89gamtj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14322646;
	Sat, 17 Aug 2024 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723924086; cv=none; b=jO2eaaxcfNWp/Q6Nl0rPDGdwWQSK/eDJUJfqsnrWg3kRw0wplQ163u2TeAoQTzEur0FNWeoykUc0fHDah2fU/qzv+r0f2G8eh4vzxL8RJPjjyv6/7sUncIgipDjT7U+1xCul2xkd4VK1BgTMaf3r2niTLI1c7C5ofoL4dV25tKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723924086; c=relaxed/simple;
	bh=vZO3mhvZ2ondZ9T7LnLDQSxF7nfyF7lXwL8YGftue30=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YnYTJhCMmcjs6NlOmKNv55Ye0en1XN24G97LI3JBZwIFx5TdX0NNeKqDeE7KroqGDyhfzb8jA3udPyk4LCr94SKFQiPTEb52mGPVdV0uE/409Fd4M7+m7Tr5hWNJTnYdG+sOI4XhJWSVpQ00n1PnziR5b0kl2Usc9J6U79v8Mwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L89gamtj; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5bec7ee6f44so2429750a12.0;
        Sat, 17 Aug 2024 12:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723924083; x=1724528883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P7F1idPvQJ002gXpYyIsx4r7BGTTRszf/p+4knxZhCw=;
        b=L89gamtjDGm28gu+3hZc0xw4AfuY+EZu+y4RioVMy27HgGmIjCkQqnyKigUkJMi3q3
         Wfe6d9Rf+r4ekmL8YJSmYdT159zBp05Mhu7RiA9JtCdyhMYAv2fNilhsIV3FDhJNnfwG
         kSYq7q3L/PUgSy17PJEpkYaoA3QJKe4LjHi1rIHorZLs2M/5gd/PbQMzR110tMnCFqJF
         Rz1Phhw+EX+xNgGsRkOXW6HQUeTadP8EanPok7FbFztkg3rIqTXuksS/N5ScG2Ka5Slq
         kK2wroVq5+/PWPaI3koCNQxWtVyP0m1esXhI7PXW2aVtBSBmPGE8fWPf6+a6o9HHiMRm
         R9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723924083; x=1724528883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7F1idPvQJ002gXpYyIsx4r7BGTTRszf/p+4knxZhCw=;
        b=bEEql0ZLmT/mDWICG6U4RE7FuZdtEq2cjEeOl793NgJw4o9hw2WTDV3tiD0P5WR4yp
         AK0Fv/gWxDVLJ/cbl6HN3nFObPH7RpBGH/CK9mZbJ7sO0PBXgUDhGCJgI+fSBp2gFz3j
         5/ylDUOBp52qZPsoitmYD+T1KPgaqYXo+9BMrLDxngB3Zu129DvHuvxdCKaZjyGR1ke7
         hClg2p5AgHWAi9wWpl890v/12TZ7xOFMO8k339Y9GXgINURJJOgqlwq8iyX9zliuEU6D
         e69tBP4Xo+dGPvOrOYOhgkJjHK0LSxIMmiQuZvClvwVBszLvYad+gNM9FlnNqSuTEPwQ
         aDxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlFycUxcRkb+tUsyCacB/StD9Gpqz+XuGJGer8z5U2uMyuFC/XsVyiStxOh+TjrsE26k4pQR/z/CvYuNDiAosTrW4jjVrnyInj2skQVYttSOtv7URD3VUoCY6pQDff/IZ4RK0RlA==
X-Gm-Message-State: AOJu0YzbqTOOv5JBrriXKJpT49EIeJW7PYHYAm6qyEoNQcpvzVhqjaHI
	KjZ5aZJMDPRGUD/3n/MtNuAXT3nWy4KloCGbLiwzI5Vaq+BsswgB
X-Google-Smtp-Source: AGHT+IFw5TRU8DXRxJ5NBkxZyX/iIK1apOTrkd5oKyOdp1pxmdF1/nuS4AkYfKPo2bD5SMNV1qrDPg==
X-Received: by 2002:a17:907:86a7:b0:a7a:ab8a:384 with SMTP id a640c23a62f3a-a8392a4940bmr372925066b.64.1723924083000;
        Sat, 17 Aug 2024 12:48:03 -0700 (PDT)
Received: from [192.168.8.113] ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83839356c9sm439835766b.120.2024.08.17.12.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2024 12:48:02 -0700 (PDT)
Message-ID: <80d4150e-a4fe-4c05-be23-4ceebd40d7fd@gmail.com>
Date: Sat, 17 Aug 2024 20:48:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 0/8] io_uring: support sqe group and provide group kbuf
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20240808162503.345913-1-ming.lei@redhat.com>
 <CAFj5m9L3FGhdFw61K9-iLWs=ak3OGmunEKC6Fs=SPYDVfcPAVg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAFj5m9L3FGhdFw61K9-iLWs=ak3OGmunEKC6Fs=SPYDVfcPAVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/17/24 05:16, Ming Lei wrote:
> On Fri, Aug 9, 2024 at 12:25 AM Ming Lei <ming.lei@redhat.com> wrote:
>>
>> Hello,
>>
>> The 1st 3 patches are cleanup, and prepare for adding sqe group.
>>
>> The 4th patch supports generic sqe group which is like link chain, but
>> allows each sqe in group to be issued in parallel and the group shares
>> same IO_LINK & IO_DRAIN boundary, so N:M dependency can be supported with
>> sqe group & io link together. sqe group changes nothing on
>> IOSQE_IO_LINK.
>>
>> The 5th patch supports one variant of sqe group: allow members to depend
>> on group leader, so that kernel resource lifetime can be aligned with
>> group leader or group, then any kernel resource can be shared in this
>> sqe group, and can be used in generic device zero copy.
>>
>> The 6th & 7th patches supports providing sqe group buffer via the sqe
>> group variant.
>>
>> The 8th patch supports ublk zero copy based on io_uring providing sqe
>> group buffer.
>>
>> Tests:
>>
>> 1) pass liburing test
>> - make runtests
>>
>> 2) write/pass two sqe group test cases:
>>
>> https://github.com/axboe/liburing/compare/master...ming1:liburing:sqe_group_v2
>>
>> - covers related sqe flags combination and linking groups, both nop and
>> one multi-destination file copy.
>>
>> - cover failure handling test: fail leader IO or member IO in both single
>>    group and linked groups, which is done in each sqe flags combination
>>    test
>>
>> 3) ublksrv zero copy:
>>
>> ublksrv userspace implements zero copy by sqe group & provide group
>> kbuf:
>>
>>          git clone https://github.com/ublk-org/ublksrv.git -b group-provide-buf_v2
>>          make test T=loop/009:nbd/061    #ublk zc tests
>>
>> When running 64KB/512KB block size test on ublk-loop('ublk add -t loop --buffered_io -f $backing'),
>> it is observed that perf is doubled.
>>
>> Any comments are welcome!
>>
>> V5:
>>          - follow Pavel's suggestion to minimize change on io_uring fast code
>>            path: sqe group code is called in by single 'if (unlikely())' from
>>            both issue & completion code path
>>
>>          - simplify & re-write group request completion
>>                  avoid to touch io-wq code by completing group leader via tw
>>                  directly, just like ->task_complete
>>
>>                  re-write group member & leader completion handling, one
>>                  simplification is always to free leader via the last member
>>
>>                  simplify queueing group members, not support issuing leader
>>                  and members in parallel
>>
>>          - fail the whole group if IO_*LINK & IO_DRAIN is set on group
>>            members, and test code to cover this change
>>
>>          - misc cleanup
> 
> Hi Pavel,
> 
> V5 should address all your comments on V4, so care to take a look?

I will, didn't forget about it, but thanks for the reminder.

-- 
Pavel Begunkov

