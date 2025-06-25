Return-Path: <io-uring+bounces-8493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A75FAE911A
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 00:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1EB87B003A
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 22:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4A225BF19;
	Wed, 25 Jun 2025 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Whd01pHm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928791E2307
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 22:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890993; cv=none; b=E7RCQIWrmvUULifPKok/1fCJ+7n92hcgtclQBXhaK+2aZ9bSbHzu0Q5hyn5XKKWXZKN7WOsldVKP4gdUbP9Wj0nNogrYOsxkrj5RRktIViv6PYzBUvAYGYaaZbQY4uHRwcdyCZKlqeiNOdN0fTOaHBsWyXKD/PxXsGLFTpQwSrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890993; c=relaxed/simple;
	bh=EgO+UpU6lP0mRfnpMVhQpV/irTgo/+AiAgMLz5BgA3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDpgD+u2Q5wVCPt5tL9X39+ohDDx/MXYj/XYvjSoYkF76KTEhNimfpoPbY+0qWdvLNUsKdJ8ddZiYxNaaszqUvB8dg7qb1VfQDsb6IqPm9DJo9MGg7ShTpcmNmdyVqC5HSCPdy2BzqhjqFsIUs5mKUqaJncwrmtKYzOpS/x0w8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Whd01pHm; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-af51596da56so306876a12.0
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 15:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750890991; x=1751495791; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKhqwFykWybKWKbhxA/cZcQ2alpWKBD3m9snmPZzMjY=;
        b=Whd01pHmJoAN2k4fvJTa3u2T2tf4KSa/EYNcSsuojelo7sGaLQKsH8EL4uxIvqE4kQ
         zYAZnPP6GjMRjXF/02BXHyPc0+iS1sPjUPpAu7Qw+zaGcEwvByWwbFxN1dWJLv3xRVWV
         x5IStAD1oYVecT7bLU2M+wUmzpV77Mu1zrBrFjAGOo0nSGGpYdqjngrEVIJwOn3+RFAX
         IK4urQ1ck4xYWOUmukzj3fnhaMTr9nRF0hRYDoDoJv/RdDYVFOD5k4T13MVyJYNz2Ngg
         YI1zIs9MVmtUTtUBAvjDBnPf9zOtyidp96ua+3kO1u6RdWgNTP9EBb4ALBcoW1QOyxjj
         Paow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890991; x=1751495791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKhqwFykWybKWKbhxA/cZcQ2alpWKBD3m9snmPZzMjY=;
        b=U26QRNitgv7sRMBITx9Ujae/j0rml9hh+CO8N/7Ik3loReqgiT0qrBO665BxxPfhQp
         uMObarwgrw+l0SRa3spaS9SBep/3XbNeQgzn/LNTVrWtZRtTTMSikNtykGROmaiL85zj
         TJfa9IrJHzHbSkbiLAjfJUgv3LEAvvPVi5+yVKc5tpCucvPq9sQFDdFHy6r31+6DUvw8
         1gLKyjUJ6HQzQRO29MPkTJ0ZAc0bM56a5me86Fruqeio70fc3mL1warbjvxOtxFbRMcL
         h1ECx/1m6E5y4dnQ6nlyJy2eqMggo730UjRk/qMxDdpxah/9kfCWsufS3zVLXkaaqTZT
         vFxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsH10/ADw3Bi8wYC0uaoFWV887djOJK619x6OVMESwxCoS2OoTmcq/P5JGo7z/WicT9v89M7fCLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyK9SZMH3TP+xct5OPqgz5Dr0dXStSWMf+A7hFEtkJjW4piZ34S
	B76EHiubouuA3lZAhU0HmqBBN8bPx2Cy0jHWO4ushAVuYbJFsD3bLHJ2UbW31NxHfEtxGh8DnUI
	YRDrW
X-Gm-Gg: ASbGnctZU7rffZGxZzSbpyCeO3WRjHQ95HeTbFet0r/wwL9OO7womD6bTNjvJblWLZe
	QCBoU697Rjlci3MgEi/Wicwn+N+ANB7jZSgs4YaN245BL26fl5Jg6nh6DqHZhygNxbIELs6f264
	h4O/njU7ZSF5+75X1M8NpysxmjnGRwnfNetbZjjDz6wF4MN1mKOKveMr9B6CPjQ5ncP/n5jXrzL
	rof0js88AVASZkAUN86z/mHE97/2YKqpHeJpwyTGQfh3gcbQHfwD/OBDcDXyLcqXIuQjAY/e0SE
	nFYAdkvygpu2wUoyDEGGLUuEmaxQ0nz1dTbs48XPc6T83hbHClv0L210Fw==
X-Google-Smtp-Source: AGHT+IHCEr8IOl/+zGFEjZVN/rndkf0HY9YdESSBaZcaKzBgGB0DwbLQsaF1aRrLw/1bdOef+LTpHg==
X-Received: by 2002:a17:90b:1c09:b0:311:f05b:869b with SMTP id 98e67ed59e1d1-315f269d826mr6581926a91.30.1750890990723;
        Wed, 25 Jun 2025 15:36:30 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8609973sm141282095ad.89.2025.06.25.15.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 15:36:30 -0700 (PDT)
Message-ID: <c79a3aff-6b39-4040-94ec-2c6bf925af67@kernel.dk>
Date: Wed, 25 Jun 2025 16:36:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] io_uring mm related abuses
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
 <d0929e59-ffe1-4de8-ad3b-2f81d6f24f3b@kernel.dk>
 <adfde1ba-68fa-4bcc-a657-86e0d311bdd2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <adfde1ba-68fa-4bcc-a657-86e0d311bdd2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 2:24 PM, Pavel Begunkov wrote:
> On 6/25/25 03:52, Jens Axboe wrote:
>> On 6/24/25 7:40 AM, Pavel Begunkov wrote:
>>> Patch 1 uses unpin_user_folio instead of the page variant.
>>> Patches 2-3 make sure io_uring doesn't make any assumptions
>>> about user pointer alignments.
>>>
>>> v2: change patch 1 tags
>>>      use folio_page_idx()
>>>
>>> Pavel Begunkov (3):
>>>    io_uring/rsrc: fix folio unpinning
>>>    io_uring/rsrc: don't rely on user vaddr alignment
>>>    io_uring: don't assume uaddr alignment in io_vec_fill_bvec
>>>
>>>   io_uring/rsrc.c | 27 ++++++++++++++++++++-------
>>>   io_uring/rsrc.h |  1 +
>>>   2 files changed, 21 insertions(+), 7 deletions(-)
>>
>> Hand applied, as this is against an older tree. Please check patch 1
>> in the current tree. Thanks!
> 
> Turned to be for-next from a couple of days ago. Patch 1
> looks the same, should be fine.

I don't always put current fixes in for-next, though I've tried to do it
consistently more recently. But it's conflicting with the error path
cleanup from about a week ago:

commit e1c75831f682eef0f68b35723437146ed86070b1 (tag: io_uring-6.16-20250619)
Author: Penglei Jiang <superman.xpt@gmail.com>
Date:   Tue Jun 17 09:56:44 2025 -0700

    io_uring: fix potential page leak in io_sqe_buffer_register()

and my hand-edit just put your hunk 2 of patch 1 into that cleanup path
too. Thanks for checking!

-- 
Jens Axboe

