Return-Path: <io-uring+bounces-6819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDADA46BBF
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C4E216E193
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD67256C73;
	Wed, 26 Feb 2025 19:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JD6N9vLJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB2B2755FE
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599906; cv=none; b=hbrOjO0idnt4HWhvSq+8tkdGvDELDJpHWDr76ZGWoL7YdoJld+b/+mHvC5/INgm6eQIthVbIsBY5ctanGSAV1ibJ/Yzi9E0v7Bh0wOtdnJ5MKhy0btHx2QgvifeRAvAC96PC/R24VcOnmhQ7uyEvGXr4cEBRz8SoHKrIM4iGwp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599906; c=relaxed/simple;
	bh=gX9qu0BeQtR7XKFlFbgVhGUYL291Ng0kpopRBf1dZVo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=HlEYMfcoHlXYRC78crJS7ZQFzRKmxKErArVV+D7d2WsUN8nqHKItk/yq4qg7nt6q0SEMdlHZkU5qqYAG3atF5JOl9N8POZZHWB7wt2rALiFLFJw0JgQUXLt3nFubTHgbIPew45X4ZPjJfZnPjXrZ1cC3t3jmmL/BW34uUBz9dgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JD6N9vLJ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso1888335ab.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740599903; x=1741204703; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ndd7w08DJfKf6jnDYi/L8YoxxT3mLVwsG83pvOZOq9Y=;
        b=JD6N9vLJWEA5vArHi4D15ap7GpQV1h/tYqPDbTSIWnxkI/wLDMobWA6nX1bcVime/a
         cFP//XXeQzcsNNyTecCa+Tt7QEZlHK36TOE/xil6jpnJy4HXj2RlX/wFl7H22A2+L6fY
         5QO2PDQDUikiOK8bcZa+FKOZ7V0afoWY9s+KHtsxQvn44DvYA64H7fs7b/gui4lc5cDC
         1L0aX/+++osxdwSEYhBmiGrnfPY4BcxEtCvmzcXDK5r5Ge5oxaPPFvgKGG3+rz3LiBtK
         P0N/gZohNaUYnlJJFU60IN28mJEKiPXxu8OdRUEvbexqMLuQ7ubsBvRhXin8dyR7xp6X
         hVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740599903; x=1741204703;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ndd7w08DJfKf6jnDYi/L8YoxxT3mLVwsG83pvOZOq9Y=;
        b=s5ZPVwIs8ogpHLkO9/uYUDXcA7l4n+1Xwi4xEv6LOipyUjfp7GQ2KH3TFXpPZS6Fu6
         AjCGTsUg0qaagJKZXNL1FSl51FPjQ9gu/GsaF0uho3AGdFarznifgM5Hp9hlB8MGZ4ZP
         lkBYAYTkDrMWAGBJcPdnLRJH/mn4yJFajNxXhk9NoYZduiK/4gXT7F8AFA5hdIBjSR0J
         vSoV093UY9irImw+aNeFqZRY8R3wQ39jIJ+g/wn9thW1vliErSReu/G4UetGhLCIMwPN
         wXQJmRYvfULl7s7b7bT5RMeDbxDLt8Nqvr8P+YQi/9MYfJB0Ymh6sRmfNnSgDc7K1M/2
         ft5w==
X-Forwarded-Encrypted: i=1; AJvYcCVm78FaPClsuEqw8z9vK9sUxmCDM/vVsUtcve/YuK5acnrURvBufxZwxRrUq3ygOYzWSOgxulxHZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD1DUjxWd20pcfEzL74yvNhngr32ZXlVJ1bq2OcfuLtmM95vIg
	qvZG6fyepdmMSNipuvmsaJ/28D3M9Ui7aWrjN+OJG5o8yOAOu3I8PiWHEkIMOsc=
X-Gm-Gg: ASbGnctFTFRAOCgaj5CZv7JxakUpBenHHKObWvJkfnkjjjvZtZoEG6CgBdU3n3U/+bO
	HjNs7t0sLuLJKx4EK8fLyMvTwmucu1kEtjHqybm2w7brW9PInJyx/bqTxTFmgqeUmsh5hSYc9Tr
	FP5x953r+g/O/bD6v0KRHDfx71Cr2hfg9mQcAEs4744TmJc99HJHiMGRclVe/6JNCrTQFCON/Y5
	V3fFLxdrO9WVztnxOBynVEjmuYGxXPPkKBmIQR3zE9wSC782fow7cbkkCVto8ztXs4p+E7eTtSK
	ZhXqaQI9Op2JZ8xcOn9BfQ==
X-Google-Smtp-Source: AGHT+IGnsC039ohXWBjqBuO4K8YxxWd3QQUk7/Zi2UK4xWUHzax4sA2PzQVHkm4u4n7MbFbgw+t0qw==
X-Received: by 2002:a05:6e02:160f:b0:3d2:a637:d622 with SMTP id e9e14a558f8ab-3d3d1f4f176mr59581675ab.12.1740599903028;
        Wed, 26 Feb 2025 11:58:23 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d361ca3590sm9477085ab.45.2025.02.26.11.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 11:58:22 -0800 (PST)
Message-ID: <5f46cba6-0a11-457f-8591-732f709e7fea@kernel.dk>
Date: Wed, 26 Feb 2025 12:58:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 6/6] io_uring: cache nodes and mapped buffers
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-7-kbusch@meta.com>
 <83b85824-ddef-475e-ba83-b311f1a7b98f@kernel.dk>
 <e20b3f2f-9842-49a8-9f78-c469957e66f5@kernel.dk>
Content-Language: en-US
In-Reply-To: <e20b3f2f-9842-49a8-9f78-c469957e66f5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 12:43 PM, Jens Axboe wrote:
> Ignore this one, that was bogus. Trying to understand a crash in here.

Just to wrap this up, it's the combining of table and cache that's the
issue. The table can get torn down and freed while nodes are still
alive - which is fine, but not with this change, as there's then no
way to sanely put the cached entry.

-- 
Jens Axboe


