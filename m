Return-Path: <io-uring+bounces-936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F96787B42B
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 23:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BE06B21196
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3946059163;
	Wed, 13 Mar 2024 22:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e+o2+pIg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B18853E07
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 22:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367689; cv=none; b=hXKx8L5MLjW7nfxiTaUb1EOZRdNGEe3guIdTBOZLN7p9YFJYJ9KOh/CYs5v+hhbAKRdnLnXUQl1Q/Xf7jBIY11c+R0T5arhLaPyQxhOusYGxjywVjvBueBGLEswuMZhadmPpIyBJdFO16SRBiXIWAth68be5/QnwbLklV3NKeJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367689; c=relaxed/simple;
	bh=pNqEJWFHOxTJh8fp1Q3R3MUMu1TxckIeqryIRTAD+Jg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=egoHNc6spI8G2oSMdFTkaFXTHxLGvkTRtzpqNEDHUvtBlJIRM5djZQFxTxMDalrzFjyIbE3X8xkL06BGXntdY2YwNmH9vTxC6PghceUHbNieXnZgkvmcXC4Aah0dJKz3aB4RRb7LI13zkrjoxSOjyNDYCfUurGhxV4kkQIjqp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e+o2+pIg; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-366427fa029so588365ab.0
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 15:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710367685; x=1710972485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1k75RI2tv68DHcMK1Nm+Q8VMv7UCgRm59xNluNBu87k=;
        b=e+o2+pIgvw5rOm1m5GXkyohxAyUvb1JYRXuPV82xUVppQoxtt2wULHGgueyAhxuaY2
         fv+UliaLN5reqkrqZnJfTTClnRI1Hn0FJuPas9B+eLGYpudpaphNCdOfZRkCVHKirAA6
         Z5rO8LyCLCk2b5SLZOtORAqnEFCMisx/E2/YyoZRFO1656ot1nvx//570U6x6id/kAtq
         ESme+pxlp1/zpSx2FKFZFeZZTjL1fh0MZfhxuomUpEwNLAtitL1YMoZ/vJrK8KXQEsuz
         id40reJjiSajL4AU78Rinwn8DRdT+1WiZHLcpDWVkIUvnq0JsGtzCn7dTH8nz3ePKe9y
         RpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710367685; x=1710972485;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1k75RI2tv68DHcMK1Nm+Q8VMv7UCgRm59xNluNBu87k=;
        b=DPt/xIWvQbafjZJpKG+ABH7c9O6qj0DWv7gRXI8irOC6+bnVrI7onh38TDfBrOCaQ+
         ZqMQbSlNyjmgQaSCltonFV5Kd1rqnQnp4CxCXctupyHOQbVYeG/cmFQGT1NB+3tCStIu
         RvAWTgbiV+9vq6wX1asNroXTGWGmGi5O0eq9JlIOiFEe2ZqeDapv0H+rpMDpvQpLqZlI
         y6ifaFv3Btpbzy5FN1X7Q5LlPgqluy0SoI4zape/9I4jJwSEAH7XQ6u/NU7XtEa5qfbM
         0oDgb5pl0E7X0xmShccNmDVi2T8E53vpaub/cHoUA2gZurrLK6oP2NuIVd+9flQkwKud
         Ar5g==
X-Gm-Message-State: AOJu0YxcPQATayWrDYPpPU23i44R6/hKv2TgSZvxI6lmfKvxNEHoI+W6
	u1VL8yzfcrJvPl1qzsPKrSOalIXXcOcUM1bqWjGDhX0rddQ5T1P4N6cn4/zha4zKQAzHq3G6fVD
	y
X-Google-Smtp-Source: AGHT+IF3rddUtozZWOimN+sFM4FD/38aGfbtKkPxU3iHPor5rp4TJcerEQAy7rrKhjnncmckEW2r4A==
X-Received: by 2002:a05:6e02:218f:b0:366:3766:6c48 with SMTP id j15-20020a056e02218f00b0036637666c48mr3261707ila.1.1710367685394;
        Wed, 13 Mar 2024 15:08:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u4-20020a92d1c4000000b00364f32170c8sm65933ilg.1.2024.03.13.15.08.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 15:08:04 -0700 (PDT)
Message-ID: <7e351f7a-3761-45a8-8b8c-91774082d277@kernel.dk>
Date: Wed, 13 Mar 2024 16:08:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix upper bits poll updating
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
References: <14abef4b-c217-4ec1-93d6-9c0950e972b9@kernel.dk>
In-Reply-To: <14abef4b-c217-4ec1-93d6-9c0950e972b9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/24 3:26 PM, Jens Axboe wrote:
> If IORING_POLL_UPDATE_EVENTS is used to updated the mask of a pending
> poll request, then we mask off the bottom 16 bits and mask in the new
> ones. But this prevents updating higher entry bits, which wasn't the
> intent.
> 
> Rather than play masking games, simply overwrite the existing poll
> entry mask with the new one.

This can't work, some of the upper flags will decide state. So just
disregard this one!

-- 
Jens Axboe


