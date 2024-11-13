Return-Path: <io-uring+bounces-4661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C76F9C7BF7
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 726C6B26160
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 19:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FC01FDF92;
	Wed, 13 Nov 2024 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mp4oeYeN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6D1202647
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 19:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524720; cv=none; b=ipKV3QJyAngqiPy0FOBFuZoW17R8Q6K0HpT3mcAuxavy3EkTTJ4OKVzVMg6P/y0IYxaHsd+N1C2y+i/vpjwjv86pkJQHC8ejIndtw03715i3apA+7UMyhoEMNAyt0Ax8BrYT8HGhK4oL+OBJpNOV3G2qDJJYA99ZFG36q2oF5VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524720; c=relaxed/simple;
	bh=vMd+aHFymQRaieFOgY6PI/o9FZajNVmFTMmwzzSIehg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bW3KBOQBCF+THnpl0k+8vVF4UcqbhWvmP2tLwYBbJzkGXo14rNmlvu46UvbFD09eXVCrxIiEiiXtk3xcRVYaRdt5Twb5H0k68ZtDEIfkw4VbS8SSPlc4TJh3bEICvKV0s5rc4n24wAYZGRkkfs1cbnyRJ/l2foeUKC00GVsFc/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mp4oeYeN; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-288661760d3so3301965fac.3
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 11:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731524718; x=1732129518; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5d6zxdFkPsU+sD0oXkQof2KZyod3gas1uEecLduAVek=;
        b=mp4oeYeN7VufePwex6UCVzdxm2WamYYiFLWp1Ik/5Uu9oVdeqALH5M9z50Zs0ECFMS
         GfJF3rbgFflTygPtYcNgjwnE/iBGvK5hsPvMXnNqUhBrhLuoaskjwIQ9kppExJnm2Fva
         y6YPgPnoaDw2sKGfXpGNEyn3Cjg1ElZxLw4fnNX0bxd0IT1XlGx9ZjejLmpjntRTB8y6
         uEGJEPq4srvaXWxZL6Ln0pZw+FUjRr/lVtCSP6l4+5gZv2f8av87RH+TLXWuSokB9IfP
         pTXUu3JVQbwrQpdQYno1Ci0aYXhN/KabMwXy8KrGfLh8gb+VATjSKC4oUoqtACpBxu8p
         mL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731524718; x=1732129518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5d6zxdFkPsU+sD0oXkQof2KZyod3gas1uEecLduAVek=;
        b=Y3Erh82dhEjAq2qxYrsQ7SQOj2/RlXAIQKZ7zc6kRt60A2WKd/l5BLMVwLvdK8kaxu
         nSLFNGYRK0doq1417lVvbI6Ocnjx5d19nRCo+ywdmHdiprjR9C9uJMVq+43t6iqfuMnt
         ooJbnZyHWZKNi04v+QBJZhELP4DJCQe2gCIEH3dVpARodRbk1CjZJ9mF2hF/kMzrM2AQ
         RbKXbZLqj49CY1ASfbJUBW+dAqdpCdHY6ApLgRLOJxNM1fWIpxBghtzGrvkGL+J5fqUG
         QBWy86+V5Pt9Jc3LzSKr+aDkaPAPpHTeFPcOIFNpv/Qeu0IHSlmtwmD/Rqqk674WDkL2
         XCIw==
X-Forwarded-Encrypted: i=1; AJvYcCVwTz/9/p6BEtv2/t8chqHQS0d1ZW4V7bDGkYGu2HqCNJcs6H0DYxujOYGH4ma9tzoTFLBCBeT6lQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIAvnNUNBCAr7XUWs9wAMCHxWXlCPn0Wf2LZXS/n+PV41GOudq
	JAGqyDR8vQ1W/j6uH22QjjswWcfHgKZRIKjqNvZmChNirb7BLCGq16/YysNR4JI=
X-Google-Smtp-Source: AGHT+IEqEfISzu+U6ZtkcyQQ168T1b3zcTYcdZM+b6/RCKr3qC5Y1tU76M7H+wd+oi8YKkF3o4FBcw==
X-Received: by 2002:a05:6871:6c9a:b0:295:f651:da2e with SMTP id 586e51a60fabf-295f652881dmr2201325fac.21.1731524717878;
        Wed, 13 Nov 2024 11:05:17 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a5fe673a1sm865837a34.3.2024.11.13.11.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 11:05:17 -0800 (PST)
Message-ID: <c09728ae-1a53-4b6d-8407-07c18fc27e50@kernel.dk>
Date: Wed, 13 Nov 2024 12:05:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] virtio_blk: reverse request order in virtio_queue_rqs
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-block@vger.kernel.org, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-3-hch@lst.de> <ZzT4CHjrmD5mW2we@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZzT4CHjrmD5mW2we@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 12:03 PM, Keith Busch wrote:
> On Wed, Nov 13, 2024 at 04:20:42PM +0100, Christoph Hellwig wrote:
>> in rotational devices.  Fix this by rewriting nvme_queue_rqs so that it
> 
> You copied this commit message from the previous one for the nvme
> driver. This message should say "virtio_queue_rqs".

I fixed it up. As well as the annoying "two spaces after a period", that
should just go away.

-- 
Jens Axboe


