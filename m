Return-Path: <io-uring+bounces-11425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B44ACFAB36
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 20:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9FCB5305AF31
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 19:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EF92F7440;
	Tue,  6 Jan 2026 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZdw9btf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F252F12BA
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727960; cv=none; b=U5PLBboaS2PyFhdKrq56KGaC+93n7g/PTofsGeomo2DpylOYdd2ufttHF4/PuplJ8Uxm0ImNFH6PZLKfI89VvpdnG2CAD+2FgZGid2SG7NCHKa557jHliGi53YUH6QhVKe83AdX0KDdDN/3J+mFd5SY/SBIVZ2YeTLxRQtzsuj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727960; c=relaxed/simple;
	bh=eoBCBjo/KSoxejYCD1xX6+n5o2xGH1pTIUXqFKAPS2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lftT4BJxxAHzdE5/18HA3QXr5PRZ+6dhuPWfTiFvIoYrCgQXPa977v3kYW9fgEsH1Yq77PK1aVYQlYxG3ReSOPjcfGatBzdB8EMOd+Qt6EKPm4YPnFQOHWcLiVQBzJZoRIxdUECVBSH/vHHZaoWhUSkUsHSeFHtMZpSMg9/FAac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZdw9btf; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-431048c4068so83483f8f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Jan 2026 11:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767727956; x=1768332756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A5ExmjzRt11H31bMlKYOhViS+00PGFmBw8wszOB9k6Y=;
        b=nZdw9btfuv3XQUvIVfi/FzVIQK3dk7N+yTg60Els58NGPsP5awU6F3ho+N1Br7RfmQ
         fZOKw//NcKiVWtIxRGlh59PWq3z+67uid4TzjBchTVHhfWFMhQHyyCIem6hqp55W+PT1
         azX8P2mQELdF3C3g8UXxpQ15KKO5hzOvGpfA+AHTbjTJW9YOgqaMqO5fB252HDy79cKc
         dJzB38kohFI3dlIU79m2LkEKWYRtLfVdJcL5EeexmEy7wWUsf/+qOvMEWjTdI32MP5QB
         8ZJ75PG0RCyRljpP0PlnvpgDsblrOLHvpLxey4PgrAPmvc/yVW++uXaR8Bg2zLSDxCjo
         JgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767727956; x=1768332756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5ExmjzRt11H31bMlKYOhViS+00PGFmBw8wszOB9k6Y=;
        b=de9jOBl/1/RwGhrDvfp9Q9d9rgA/lUlnyqKMdcZQEr3/v+TpvjfIN2Ma5w1Jwf+5Ic
         0NV70BjiDYRcU+VRGAvvWm1qL1oQfoIaZ1OMWTG1+C2uDJK36F4P5mo7po896k3TSJt5
         LJw1FN99+njqEqDmS2UcK/kHxgK6hgywHCkpYYLwSynJuHm0F3OJWCVYVxdA3pHALVnN
         JTtqWWzv2Cq6sHpbmfLtUV69TboKYBVRh+M1rxZaJzHgbK24P+dyFoatvPDyywzm3wzg
         6s2XS1WzTzu+vSUER6tgmf/B8XkpIb5xJG2Ptz4/FpFJLr4ERy2F9szCqXEyEU1Lb+kj
         jF2g==
X-Forwarded-Encrypted: i=1; AJvYcCWqiSaP8v/pl2UPaiYzURWFBzV3I88vbDH3mcwfVHuAeAgPUb5RjO/0H7L9jJ2mW0o7ONiBj6xyLg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyD0Ta9zsMXRRoNxvmIpbB86jc2rbMgkhkgyA31hgorjMqH2DoF
	/ClWXKdEHIFWurhRRf5M/a2UWfPbhxm6zj4ePQfoSezUP2DIZeSANJtl
X-Gm-Gg: AY/fxX7aiTpJXwmRu8TAHb2uPUe/npiTsuMLvYfFy7Sg9RImnEF2XGiY0cCoC6RiNGX
	SJVEK7ERLEfwVAQV9BDO6Vx84g66SFT5ei/9uZo1pgbgp0VB7ge+qynkaJ/7g4cpk9TAq4W1tvg
	8+Y6NZvuYzYRq1ri46IXecYaNhF7wJ5lJA66l7rOfPAjmk+3P8Wufu7l6pDKxy61UAOspurO5VH
	+uRoAnSb8LqPT0j6WNW10GIWRyloA0nJ5WdhG150ZnTiha9lMNBnA09fDWC+X00l/MANVy4OkLo
	vrH1n6pbxX2AM9RnCfDUa8eR5Zw2avbuMCMCcLVxz23XFy4ibCRfXnrtI5C0HP0gYGnUQHYshzN
	YuzmKqXF1F3ZIu5fPQMf976d+eov3ct9p1LqzfdfuIuAIwnigLM4huHGZBnPKqWtSLtEe+8f5op
	atPt+Z4e3CCM1otVVEtzMigRZPXow92YQ8O8ULhBtB1uKa0WsVRAawLXBSy0WUExfxcfIBtuJvm
	N0SI+3yOLCsYP5RxAokVnuiN/H0M+q9z/HSl5kVqenLnHqLUOuLcd0C1nNPJ2EU
X-Google-Smtp-Source: AGHT+IFIh4UFL5ktKvizijTqM9ls5ooe70zcSXJi12HfQ2Im3m/BSeK/gwa0FGVa9q2qDIVhMmmdpg==
X-Received: by 2002:a05:6000:3104:b0:431:cf0:2e8b with SMTP id ffacd0b85a97d-432c3778e47mr273696f8f.29.1767727956009;
        Tue, 06 Jan 2026 11:32:36 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e6784sm5933503f8f.19.2026.01.06.11.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 11:32:35 -0800 (PST)
Message-ID: <275fdece-d056-4960-a068-870237949774@gmail.com>
Date: Tue, 6 Jan 2026 19:32:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 10/11] io_uring/rsrc: add dmabuf-backed buffer
 registeration
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 David Wei <dw@davidwei.uk>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <b38f2c3af8c03ee4fc5f67f97b4412ecd8588924.1763725388.git.asml.silence@gmail.com>
 <aVnGja6w4e_tgZjK@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aVnGja6w4e_tgZjK@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/26 01:46, Ming Lei wrote:
> On Sun, Nov 23, 2025 at 10:51:30PM +0000, Pavel Begunkov wrote:
>> Add an ability to register a dmabuf backed io_uring buffer. It also
>> needs know which device to use for attachment, for that it takes
>> target_fd and extracts the device through the new file op. Unlike normal
>> buffers, it also retains the target file so that any imports from
>> ineligible requests can be rejected in next patches.
>>
>> Suggested-by: Vishal Verma <vishal1.verma@intel.com>
>> Suggested-by: David Wei <dw@davidwei.uk>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
...
>> +	dmabuf = dma_buf_get(rb->dmabuf_fd);
>> +	if (IS_ERR(dmabuf)) {
>> +		ret = PTR_ERR(dmabuf);
>> +		dmabuf = NULL;
>> +		goto err;
>> +	}
>> +
>> +	params.dmabuf = dmabuf;
>> +	params.dir = DMA_BIDIRECTIONAL;
>> +	token = dma_token_create(target_file, &params);
>> +	if (IS_ERR(token)) {
>> +		ret = PTR_ERR(token);
>> +		goto err;
>> +	}
>> +
> 
> This way looks less flexible, for example, the same dma-buf may be used
> on IOs to multiple disks, then it needs to be registered for each target
> file.

It can probably be done without associating with a specific subsystem /
file on registration, but that has a runtime tracking cost; and I don't
think it's better. There is also a question of sharing b/w files when
it can be shared, e.g. files of the same filesystem, but I'm leaving it
for follow up work, it's not needed for nvme, and using one of the files
for registration should be reasonable.

-- 
Pavel Begunkov


