Return-Path: <io-uring+bounces-10252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF38C11F3A
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 00:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4922E3AA414
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9D92E62B4;
	Mon, 27 Oct 2025 23:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O0ZnotQy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44363272816
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 23:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761606962; cv=none; b=qFaxeFVFpIYIlaVLuAJWnNl1JEdViNx55n4Y9tSwYgw7JXhEa2ije9JqPUpqMRx0FRcEx/N4vO0ja0vbxwwuxSz0RGihyJM4YMjBtQoqfYAcjdbzYOwMKxUzJUBfpN90+8cbKintKfzq+alChZAmzRDrun10vRwwVPozxX7g2ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761606962; c=relaxed/simple;
	bh=gAIfAw7FHE4QOWioFeSg3uxKwCyW3lrxDjN8vVbJM3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkJCp7Ayhc/rMgwqFTEft66eEMM+O3JS+xDJp6PZaJhlLAckzNIILYdqBrrMWwEmv0aZkAaK06+VQZxBWRWBQjL2RzzT5xuDpU3Uzk4pmfjCDbZ/LhBB6awWKr3X854buRhc4k3ALjFh3GLpJepqyd0mzixO8FYOdCpRJTPBqCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O0ZnotQy; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-93e9b5bafa5so200270039f.3
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 16:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761606959; x=1762211759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aoD5NoTKv8/h43qgG+wn3ax3ZabESD7UDlfS92Jz2nE=;
        b=O0ZnotQyZaU4jOM8fXo8wUQSY+vEfTLyNTZNl1G+TpHGVdExTBxxkAyxU9S79SSM2C
         9s4+7hBE6e94EaRObu5S21nRrXYDznDxDi3NBL3V3ckPApIdfLeACr7urr58bM7rEe5L
         hpzeyRiPumtTm8lm+Rlb4OrQDAXkAmbAIQqYaApC/vn4O8KaU9F25S4rhRx+aW622Qb+
         9txSzCTn7JoY45tvZ4NCXgNR+OPBV9WHrhlUF4txDGu73lFMQvZSDUID3poWVruttpAC
         sa0ZxYj9/GYNZwoCWT8uzPVIiXDvyf9n620Fz0fRu6ygKQf9k2HKhzrS2mZEPTdpGfr7
         cSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761606959; x=1762211759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aoD5NoTKv8/h43qgG+wn3ax3ZabESD7UDlfS92Jz2nE=;
        b=FJ4InOSWrPCOArUSq73tDS0Ade9rflnCx2hUyqZ6rN6l7SI3sHVnaKJkGR9Uslo5ud
         eDpvXjte83amNcRmVU4URX84F6tVk5qOs5hj7xqnP3OFwtwnP1nQLX7RBiiBlNGABT0/
         3W3+iiAqlM++m+uOIxYBApzW1mFmOMm2K/MNwEdFbL1IC2K7FnFvWED4an8Ak29KK8OD
         /Q4uUumnsYdKOkwue/5rpOOlCu/kZ4MY/mcqMbGaD4bhTDlURZGWDXdBvYHj+O/qamp8
         j7T0ibYP95fRsgDgZ0N4knM19cklMsTRLP0x0nSCxQZVY0qD7bFKJNhVvGqf4Tlwzp0M
         QpeA==
X-Forwarded-Encrypted: i=1; AJvYcCXLyVEU1DSx5MKpku+6dYhpYvb2OWztMGISD4VQN8xM4mVtxM57UJgLf7LJ82/scm2hGXk3Osk1Nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyVryJizoK0aCbFYGOdmLUjsoprQhHcschE2nT29o3uulzOb9W
	9W0Qmao717nkKq/J1V3QJWKjEjfU6kr7SIB1O/C/2HiFi3v2v02LrmLBUh+v+FzBhHc=
X-Gm-Gg: ASbGncv/QYTOxnyjOIUjHP52ce/AIdpkpWDJuzVJREMM7ru7FaJgb8eNGLIe1CQ4NIQ
	RdrDJMZzKsIt4lZPZaqWBVSgqBKYr76zXoVoMliMMf0s0gMb/LQvW2wAfwtvnvVSvkJBn8lJ6n4
	MAQ5YPyG4lPiw/HU1u7Mvcc6jdWjOS/8LNtYhZkzEBjFz1mMK29f1rFQ5iOs8yavkVccU1D/nQc
	r/NPB/+v+aAz2/GdgIHqSsZgWmHDN0iprzxJCUdKSYrXno8dvNIJk4oMrXNkHMtus1/Bvg/Pxrl
	9JdR4rFbMo5o5iEMHYMYPp5eEm/RxrXwnFwIjgcrPY/9unEZM6KishPndeA34IOi8TLoQrhGiku
	x5/jPk1WcdP69leC6zCYjm0V1YTQ5DhZwl+hoKlaDoFypJ5O2fdu6ukeEd07VZx6WM9ZBSWKWaZ
	TrP0pmuJ7v
X-Google-Smtp-Source: AGHT+IG8O/Rb5KDQPc+EVLzhz2IMYxYomee+7BaBo23iEOee6MwFM+DtI01ybszd0dn4gfVQ5tQfkA==
X-Received: by 2002:a05:6e02:2486:b0:42d:8b1c:5710 with SMTP id e9e14a558f8ab-4320f5fd34emr27167935ab.0.1761606959246;
        Mon, 27 Oct 2025 16:15:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f67dcb51sm35024605ab.7.2025.10.27.16.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:15:57 -0700 (PDT)
Message-ID: <e6fd5269-d6c0-4925-912a-7967313d991c@kernel.dk>
Date: Mon, 27 Oct 2025 17:15:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node
 (5)
To: Keith Busch <kbusch@kernel.org>
Cc: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
 <d0cd8a65-b565-4275-b87d-51d10e88069f@kernel.dk>
 <aP_48DOFFdm4kB7Q@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aP_48DOFFdm4kB7Q@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/25 4:57 PM, Keith Busch wrote:
> On Mon, Oct 27, 2025 at 04:04:05PM -0600, Jens Axboe wrote:
>>
>> commit 1cba30bf9fdd6c982708f3587f609a30c370d889
>> Author: Keith Busch <kbusch@kernel.org>
>> Date:   Thu Oct 16 11:09:38 2025 -0700
>>
>>     io_uring: add support for IORING_SETUP_SQE_MIXED
>>
>> leaves fdinfo open up to being broken. Before, we had:
>>
>> sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
>>
>> as a cap for the loop, now you just have:
>>
>> while (sq_head < sq_tail) {
>>
>> which seems like a bad idea. It's also missing an sq_head increment if
>> we hit this condition:
> 
> This would have to mean the application did an invalid head ring-wrap,
> right?

Right, it's a malicious use case. But you always have to be able to deal
with those, it's not like broken hardware in that sense.

> Regardless, I messed up and the wrong thing will happen here in
> that case as well as the one you mentioned.

Yep I think so too, was more interested in your opinion on the patch :-)

-- 
Jens Axboe

