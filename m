Return-Path: <io-uring+bounces-7183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDCDA6C45D
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BDE13A2392
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A2822FE0E;
	Fri, 21 Mar 2025 20:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZaMse/B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4A4137C37;
	Fri, 21 Mar 2025 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742589462; cv=none; b=SaZOLADdFwC7a3alq85w1zrMBbGbl0GmTQo8j3t3z847zUiCaziIk06/lp44AWVl4fN/Au8b86433ds3gS7ysoQyKb6bqgV8IGYGv1loe12LhnDILEL6zHiP0YrH9mWj+TR/8mCvyHfDEQQof0Zu3Sqc0LE8URNCfT8NIInzcTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742589462; c=relaxed/simple;
	bh=tJOpnxkfpmrbKVWSvg6H5393McsiTMC1u/e8djEou/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8EyIZTeGEgaWZqE3Kdvu0DYM3Hi1pqU+4Qgit78d4EYK+KD9BjpJIQ+c9oJZ1qxd0NB+a3yM8+m0gqF1nlclDiFXyItQgvotkPzWamIriKpEPNLSud33R59asMI4iVZwaNfIPsLZVqeMH7Toc32+pMb6b1Co9l37lZPhsYbJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZaMse/B; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-abbb12bea54so188837266b.0;
        Fri, 21 Mar 2025 13:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742589459; x=1743194259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8di2+5db+G/faMtWmD76yKgofncq+owzXn388GWGPKs=;
        b=OZaMse/BmWVY+YxSlDJqCOyLo+1o4WFW+PsWdcxBGU8ehnCJ7jfM8uB+5Qiseyjhxl
         OOiFb5vd7v9vzDziFNm3rsCQMVeS7Moxfq/++SQ9pU7cKSzuLfS3Eef/5NXGHFip8LMm
         Ul+DQXVbiurPKjaPzee7tXYtdeJZM6UmkB6mhQRBp0iotz2g+beN2CsEuhV0ycj2E905
         JFbGsoQSTP78GlNN6Klx6/wEQ15F5jEyByLWIYrQ6P/tBPF0OWCQpkO1TPwLPjx9H0qc
         KOHBTuruaCEj4XcUtnY21jeQvNyuAQoiGG7kUfYWUVma3pBwWVibEq69c0+s4RUwezrU
         xPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742589459; x=1743194259;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8di2+5db+G/faMtWmD76yKgofncq+owzXn388GWGPKs=;
        b=afrGDbP/uwyhDsxuQatPM5oYxtCh27nALAdVzwQ1jg2CddtYfn/q0hdQLog26FQJDx
         0kmwJedJvYBh/+xaakKPRvypvlV/3KzkMhoXz6UKgtps5YXt2tCTFUdWFQ6vQVSWxvwj
         PeZE4Xfgxxztz9ivxk0mZwPgQj9q/04i0pSIJhwtzFx8qFgCKR70N9qBcqBQ6EnOVCEv
         vj5/TbC9WbzuMBHVpn9K4Yu9U0DRAoItqAhc6B7K1GsO1tuJQvKTKgpdJnFlrk1XXZ4x
         XD/X6KS3o+c/ItnZs7dV8BFpyvhITFHNpItONQpI/NCnnvhwOurnobfnHWMP0RvYqXsJ
         VL0A==
X-Forwarded-Encrypted: i=1; AJvYcCXJikBsX/lwa3Wg91hT5xbhKqLZf+v82CoJQis/rL7GcELqhCpXQv6HM7J3VWqxookDpSuzQvurww==@vger.kernel.org, AJvYcCXKyJqWJmDzW3fT3bMvGgCDdvTW+ir2Mh1GOqB6zABXriYhZz3glbHTHu0mQ9yoPzbDalVGK2ms7b73akrl@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy7Q5fVKtbpiJEDiroE9DvLBr8VM6cYSEnhjdXCZPSE+sBKXcr
	3HEou6o7y4tnt5QYqXNEC4gXmxcWswGKmM2PnMh+pvCtyHJYLtDf
X-Gm-Gg: ASbGncsOWjDu6wtQLPSwHrdIopQJ6Rf/BDCW7cjkI9YCSyx4wG+I8luYv+uFdte77r2
	4rEE0vIcu3hkX2zzUUneFhcjNQC5VHZDKdbbJPupHOC2FOdO6XSFlhA3QnoNh8xjaPrOvSnFEsL
	f61DYJPk6F1J756VRlCC4rvfw2q9h3DTdyQoeccWDk6VamTdO97GneT12mpY3Lo2GNcW68d5+DZ
	chq2XLyP4qzhC5FJABOFu6JwK40egkS3MihhXpYsDM14EyEcxdbPeaA0vn9DzfWOOq1MWFQDThq
	ejATMWhqWJJNaDg5TzPhzxwjwKeHX7jz8CXIuxmEAKPlGZUfEoeogA==
X-Google-Smtp-Source: AGHT+IHrRiJ1iTW0Z48ukRmGGb6XVNgOoztXQYwBBfo+m+iTY3JPOOIta58QVGB1CkULhOEnWBIKNw==
X-Received: by 2002:a17:907:c5c9:b0:ac4:76e:cdc1 with SMTP id a640c23a62f3a-ac4076eda87mr70308966b.21.1742589459101;
        Fri, 21 Mar 2025 13:37:39 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8d3d2dsm211581666b.60.2025.03.21.13.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:37:38 -0700 (PDT)
Message-ID: <ee6c175c-d5b7-4a1f-97b3-4ff6166c5c73@gmail.com>
Date: Fri, 21 Mar 2025 20:38:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring/net: only import send_zc buffer once
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250321184819.3847386-1-csander@purestorage.com>
 <20250321184819.3847386-2-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250321184819.3847386-2-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/25 18:48, Caleb Sander Mateos wrote:
> io_send_zc() guards its call to io_send_zc_import() with if (!done_io)
> in an attempt to avoid calling it redundantly on the same req. However,
> if the initial non-blocking issue returns -EAGAIN, done_io will stay 0.
> This causes the subsequent issue to unnecessarily re-import the buffer.
> 
> Add an explicit flag "imported" to io_sr_msg to track if its buffer has
> already been imported. Clear the flag in io_send_zc_prep(). Call
> io_send_zc_import() and set the flag in io_send_zc() if it is unset.

lgtm. Maybe there is a way to put it into req->flags and combine
with REQ_F_IMPORT_BUFFER, but likely just an idea for the future.

-- 
Pavel Begunkov


