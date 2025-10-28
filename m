Return-Path: <io-uring+bounces-10277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34218C1738D
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 23:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8FE6404A90
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 22:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6D63587B2;
	Tue, 28 Oct 2025 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="08tz4mKz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C51357A48
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 22:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761691451; cv=none; b=QJH35x2Aff0uitV/m0dI3RAm7p7cPSeIxyzU5nDzN8WNejuw7cXgI3zBLXGoddw6ZyDqJkk3f3jKt5i9eAYlvwIT7AiQm5yvWALBeihVBnH7g8fnfkiue7MmaH4d1fkHweENmb4x+xZ/e2o9hGkNRswaHe8xi7EjelvIojyWJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761691451; c=relaxed/simple;
	bh=ZC42s0sqG+XopEJ3W+neysxRUCF8HUTzQ5v7byzQWkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RN0bfxyXGG7PNc7twi26Gn7+onuPU8qJA7t+2bEi56Gs82NECQ1IVe6sUtFCorLAXFgqO4HRIzaChkDMeorc6Yp41DGTIeHrYZsoddqp7mVNIPeqocTu5TFdGOwZqIOM1331O3p9ieMKLmnXZKU/k7HmQHWK60HxYjEU+1ql870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=08tz4mKz; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-290cd62acc3so73288105ad.2
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 15:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761691447; x=1762296247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gr4c5PhFuFTCwFZ5oEpEONV9tryVUpvmzCxp/gijmJQ=;
        b=08tz4mKzbpqjalo1bXtzS7lsl+KelVcnF9vctNyxLrPyVI6QiCuHyRBhuzN5+38NdD
         3pxi+HlR2bJPY0kY0Ly+VrJU08WYWSdy4WUxp0R8/XT1+BRCv0DpoU9+C3xIg8jpvp8I
         dRgnmtfV4DjJ8NogRivHbdfq3R6LiTdDNHNu/TDiNMpCq2PHxAg+WrSWzkHJHiv8cDsv
         vHRpMyOL+cjJAufRkh8t1v7tQk+ffIRX5Yv/XPEBGRhiTP9E3Cu7e4xuAVWnDJF3rT+N
         nfYEby6F12R+D/nBENaLJUOYzh0XWzL2l8q7X9V6WNyovWQCT/8Vse0kGu9+98alkqNK
         fPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761691447; x=1762296247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gr4c5PhFuFTCwFZ5oEpEONV9tryVUpvmzCxp/gijmJQ=;
        b=LTd0pCpZOFU5EqY+Go7UC2b2N0wpDEvYmdBghX16cWzmAC5aOM8cPFTuJtiixuJI5x
         9KynUa9eqeXw6jnchC71gH13wbvFLa39lrxq5b6KvR7JlVmveEDpRgUdaEqmSx8yLoPL
         ipBFRfO6oIfQ5PX0n4jS0EPWWxZHF67hCP7qvFXD8ITMvoRWKkKXAFJyB8ZLJfBl+LfW
         IocM2CLpUmGEDtPm2oKQzeTsE09Iy7wFdvC8QR5MYRAhqhz0y3Gp3sFutraFgWbNypMl
         JtT14CnFgPOKCCXGXQo8Ss5NzTgKlHPO4uzOWcvvmigRDQ9MovstF5UrCTf1fi5n5sVM
         FR2A==
X-Gm-Message-State: AOJu0YyeodQi/jHId5OJ/qYH/vjFKHEV6ppuyvZeLYYSWPA5AFFMlkW0
	L0DZMYU8+i91KjrFfoRj1hMN/VrBuXNYCgFYZTusTy6ur6XCTJxUClx4nE0eCeVSGgg=
X-Gm-Gg: ASbGnctdNwB11UYi5D7vQXcw47qGND+mY6okjs+A9nwRIuJ11LBZIXybJTQCC/N27hW
	RF0nZI/GIr09F9iSpA0o9oIBQoVHP57sUsj2DckebT7+3qHGPIpumKvhmGxRVaXfMe/bt/7fVF7
	JnSdqmHFC9D0AbXHEQ/mjcPxXdG0iYAoNxSO3YR2F/AJI2nBmM70HjWM0IjositieJS/6dHgWSL
	UflZBDzox03Clz8sULxIximt2bnQimnwEac4uF+cgv3VHsB5nLHSt5zJj94jbDMGmyL/pK1FXrl
	ZYK/8j8YpdCUDgOInrmdgVP8iWiGzUaUDv8cds5mSEZcP9Hk2BqjWFQd2v5ZeMH0v3R/pQYd9yv
	qlf2R8jyvmIxdCmY8OrJ9Q89XQ0bUpp80Oent66v+b1qn5knh/JLJAis2Pr4Dn6sgovQodUgWfT
	aA/3iEu8iJNy+Mv/KfUcqOR2Erpxgc23wq3xvXK5jSBS9XmpBaCeh6y3M9vu2nNTCi8EZu
X-Google-Smtp-Source: AGHT+IGZFixYwX+c/VJ6LPbwoPvmyYW36TMP0l8DFdCGjhUcafZt8t6LFZzrbwYAD65AXmpGb+EwjA==
X-Received: by 2002:a17:902:c40c:b0:294:e095:3d42 with SMTP id d9443c01a7336-294e0953f09mr4458105ad.18.1761691447300;
        Tue, 28 Oct 2025 15:44:07 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:c8f:b917:4342:fa09? ([2620:10d:c090:500::5:1375])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d4253dsm130275425ad.83.2025.10.28.15.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 15:44:07 -0700 (PDT)
Message-ID: <842b9023-1b86-455b-9aaa-20cdf0234c35@davidwei.uk>
Date: Tue, 28 Oct 2025 15:44:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v1] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20251028212639.2802158-1-dw@davidwei.uk>
 <20251028153820.414b3956@kernel.org>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20251028153820.414b3956@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-28 15:38, Jakub Kicinski wrote:
> On Tue, 28 Oct 2025 14:26:39 -0700 David Wei wrote:
>> netdev ops must be called under instance lock or rtnl_lock, but
>> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
>>
>> Fix this by taking the instance lock.
>>
>> Opted to do this by hand instead of netdev_get_by_index_lock(), which is
>> an older helper that doesn't take netdev tracker.
> 
> Fixes tag missing.

Sorry, will add, keep forgetting this...

> 
> netdev_get_by_index_lock() + netdev_hold() would be a better choice indeed.
> Just a reference doesn't hold off device shutdown.

Got it, I'll switch to this.

> 
> Is there a chance to reorder the io_zcrx_create_area() call, keep
> holding the lock and call __net_mp_open_rxq() ?

Yeah, I also thought about it, wasn't sure if it was appropriate to
extend the critical section. I'll do this in v2.

