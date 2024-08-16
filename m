Return-Path: <io-uring+bounces-2810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8888955382
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 00:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52340B221EB
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9EC213FD84;
	Fri, 16 Aug 2024 22:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qpS0IU2q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D22413C80F
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723848583; cv=none; b=JdNc2NYRopntYDu4P1vdx0z3XUwcRsCsBrNHPnOGa3VJvbTZsx23tqGsFgWahz0TCh1/gNblF/fPBE3RF3ZLnkpAloQXVTqegJq7LU9VgWpQ2+3YCHcdEwuQXXUNsW72XLGnkrzmJNZQdEdAigSeHNtoILBtaQL2DLt1Uq5lPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723848583; c=relaxed/simple;
	bh=9F3MPvPHVPb6rLUF/m4XKKSZlfyCBVSWxVaaRkS/8xI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFSLeN4lP+8BYdGgee1JQ6wtJObK7AwxDsSuILk2pjlcHg/QJMrkepufv3YqJeyF9PaiIh8WOxC/hj4XvNSUVuLw3xhcFQ2CFAOtjfMMSd6nDejFzSvvOm3sokjVH3Znlqtmoon+Hj1WAhNqFBhsXGTyYlbI64f36ocntx03TfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qpS0IU2q; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d21b41907so120402b3a.3
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 15:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723848580; x=1724453380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f/8AqVzmwDzl8HK9geotXtaTP0muSKkJv88Yc9nWBs8=;
        b=qpS0IU2qpIqLIdez/tV8SS1rEYFWj1TI3Q/9log8hZxKYxS634MMKpL3oW2YkmUztl
         JD3abeEPavaYX3SL5YbJoDic//VepbjLGUha3f+V+WLDdSdH+GfqoPd6NXHyiMIOcJeR
         K3sLUqmkU8TXgs4TWhKhFcjZHgNu8rH6rxTuArY2VkpvJlVZ9JcNk2PriOUd3Ew5cgvE
         NmRomyiWvS2b3aQs1ZcrrcERyszyIoOW9F9xe7D39tMAXmtYkm4agvyEQTIYhMxtcODn
         4nfBByCsX8EuQH51NuaYW3o5Ij7t+N3ev6gF6OUgNQRfIYqXUlOR1dwNzlV8UVvCLF1s
         qDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723848580; x=1724453380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/8AqVzmwDzl8HK9geotXtaTP0muSKkJv88Yc9nWBs8=;
        b=HvrlHjRl+GqMtv0rxjO7mAb86qC7C/EFQWv5qzkb0SLxjV6GKTChlSpPgBNBvqrbUz
         66dA5ItYhHy9TP3JhW6yDxb2azNFwD02qwMV6vnS0FR8O3GDMSARZIw9vmMUdcBCJ/02
         1b2w0FsaMHOU5cHd5Y/siAkgdoYDSpZ/7HDjTxofgHyn6o4N/OnlS4+g/OkG0B19qISJ
         c3tkFaw09+ELCZE5hv8kVM0u0oB855dMexZK7c+Mz1tuCe8tKd8jlwUPwz42gQgrHy43
         mU4dG1HbTaSjk6HJZCBfMgbEXyR7P3+7w7z3ZJAfFLrpvjN8aPZtRpl2eGvrtoZ/nK8Z
         ye8g==
X-Forwarded-Encrypted: i=1; AJvYcCUV9d6gDM4O76ucdK0K/tziMungO4jH+6gQiRICE2G3S92Thl1tbIVk/AQxqRewZqLeTaNGFILE7g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNxDLwcwHvMw26wQ8quaFy+CsSQb7yVwP8L4eWKFktMEZPPl3o
	o8Cacc4MuXG/7z23/O6vGWHSf8qWn/9jmwRvFRjXGjUNw7wKpX9XEvkp+0eFX/Y=
X-Google-Smtp-Source: AGHT+IFEw2yYpi+aqGKEl6CGwYjVP1XIUL+ivqz4FomAEH6ft4s+ufL0MOtwVRYdfp+U6kX3kzFCTg==
X-Received: by 2002:a17:902:f545:b0:1fd:d7a7:a88d with SMTP id d9443c01a7336-202040c2460mr29653685ad.11.1723848580319;
        Fri, 16 Aug 2024 15:49:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20205a53767sm17768395ad.270.2024.08.16.15.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 15:49:39 -0700 (PDT)
Message-ID: <855569a6-d9ff-4cd0-a0e8-1edd518b3764@kernel.dk>
Date: Fri, 16 Aug 2024 16:49:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set
 in_iowait
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816223640.1140763-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240816223640.1140763-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/24 4:36 PM, David Wei wrote:
> io_uring sets current->in_iowait when waiting for completions, which
> achieves two things:
> 
> 1. Proper accounting of the time as iowait time
> 2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
> 
> For block IO this makes sense as high iowait can be indicative of
> issues. But for network IO especially recv, the recv side does not
> control when the completions happen.
> 
> Some user tooling attributes iowait time as CPU utilisation i.e. not
> idle, so high iowait time looks like high CPU util even though the task
> is not scheduled and the CPU is free to run other tasks. When doing
> network IO with e.g. the batch completion feature, the CPU may appear to
> have high utilisation.
> 
> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
> enter. If set, then current->in_iowait is not set. By default this flag
> is not set to maintain existing behaviour i.e. in_iowait is always set.
> This is to prevent waiting for completions being accounted as CPU
> utilisation.
> 
> Not setting in_iowait does mean that we also lose cpufreq optimisations
> above because in_iowait semantics couples 1 and 2 together. Eventually
> we will untangle the two so the optimisations can be enabled
> independently of the accounting.
> 
> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
> support. This will be used by liburing to check for this feature.

LGTM

-- 
Jens Axboe



