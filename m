Return-Path: <io-uring+bounces-3512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBFE99750A
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B04F22829B5
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04F91DEFE8;
	Wed,  9 Oct 2024 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2utqZMP4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C001552FC
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728499389; cv=none; b=ILoDzRkRnVDmIrk6FX2UYcRURzVj+Z14BsRWmlJxg9pjHbm5DF8nf5uYlUZjy9cG9Tn3hyK0LyDNsXbIxwMjuBD9j+Qcnf/sG7rJZ6HoravpVx9ohUWLDQySSJD4L9riKiavyM96LJQXGti3sFH7KYWwbOlZI4v0KvflHyhRFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728499389; c=relaxed/simple;
	bh=uqoQY38QSNa6+MetnfiZCqQI8xCnb+JUbpiMmLteWpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a6K1aeTbC8XVudxZRuyfoQ/dD+62Uax6ncGusdQcH2Yn6mAvsD35kla6P4OwN/PHrckbHU1NzuH5R3e/F/m2IqOTUMcujYhGCulCMAXngtg6/ZtuEU4ngwD51nbvlZm0S9XY2Y0Ijz/LxPuMEU2THZVV102W3/+9+D42lkdFfrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2utqZMP4; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-8354851fbfaso4501239f.3
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728499387; x=1729104187; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DDrLyszh3QiLpBb/FHkROgkSbJe0WPYFhs+2qee4GlY=;
        b=2utqZMP4UXP/EMx1qK8tbvyUph/EOQiUOEPFZEY3LAhpwPVIncsEPgyO9++4nascT1
         Z3m4TbwPPCfC29rr6uedtviIDtXzaSwUDihTSVMdUPDVgpSrfTxS4LL04mYjLqSvTjA5
         4OojkwdiwMVpPq6sxi5kopCv7QyEP1I1DCYZmuZjNke9j0mtMROpUIbFDRp3fkkR/SVb
         MfZT+MZEavCdQ72JJ9OfvnFfOVLiaDRa6OeX3fC+G2VNEYdTZYa4gWmt9/9mPQDND6Jl
         DKXpI3MNFaAsiQe4/AaiicMFgVpzXoFQGb0R73hQRygIm+XhYPZBgAVDwE2kWKO+S3Xw
         pxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728499387; x=1729104187;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DDrLyszh3QiLpBb/FHkROgkSbJe0WPYFhs+2qee4GlY=;
        b=Pxdnvb12In2Gm30uU3I4nyp6L6Lt6st+D8JLVLb8AydYzJTqr+DxhlGSQWbIN4S+sh
         Govo5ssfo8flXy3Z/QN/WMrn6Oyvo6xWZ4ACL+04v+ntORHhiLG5HDLRDyuBUWMupGVN
         5OAeziaazIKMfTEq39bdEV+WzdxgsLqkder5TK5pGjG+UjkOyCnu1VafxNu6GdpAjhdw
         vOAZGgyD3vY0BbGy5wWsEE/BfN+Zfvdhtl2Mo/8BS6+JZnFgAOmuWorL+/PwJt1ONLK0
         YGM+9iKAeH2yk5Ik0MTXkfgpCYWlXbt2THYRw2yf2cujF15OGMVXxN9A5nC2SAS1EHac
         TSSw==
X-Forwarded-Encrypted: i=1; AJvYcCW+nJ6pau2/jgCYEuIBBtwZLEC5YvH1DR3IEYrCFzgIYos0K1WRhJAJKLp1+Z4TrMICkfgmP3tQxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKjolmVNPUHwac8MxIhIAZMDwXD0eMEqsPWf4wn2460dBNHvSq
	e1ukzy+dfpG1qTrySZXk1WiOMMn6T7ottJrj/4jaHjiyJhLCv9oNUuIB9WB/+ruHRf44B+inlCU
	NmCs=
X-Google-Smtp-Source: AGHT+IG/1LSItPTG6fe5iYNj3SE4Bx3h1Po66WhWLZpqyjSMqWbUSzm2FReiwg+trdW8W+5QjXLa+A==
X-Received: by 2002:a05:6602:13d3:b0:82a:a403:f0df with SMTP id ca18e2360f4ac-83547b4fd10mr99811039f.2.1728499387525;
        Wed, 09 Oct 2024 11:43:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db8aca8b9bsm1269902173.72.2024.10.09.11.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:43:07 -0700 (PDT)
Message-ID: <5f8eb69a-3190-49f5-80d6-f5fce246e7b2@kernel.dk>
Date: Wed, 9 Oct 2024 12:43:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/15] io_uring/zcrx: throttle receive requests
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-16-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007221603.1703699-16-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 4:16 PM, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> io_zc_rx_tcp_recvmsg() continues until it fails or there is nothing to
> receive. If the other side sends fast enough, we might get stuck in
> io_zc_rx_tcp_recvmsg() producing more and more CQEs but not letting the
> user to handle them leading to unbound latencies.
> 
> Break out of it based on an arbitrarily chosen limit, the upper layer
> will either return to userspace or requeue the request.

Probably prudent, and hand wavy limits are just fine as all we really
care about is breaking out.

Looks fine to me.

-- 
Jens Axboe

