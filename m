Return-Path: <io-uring+bounces-6818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83AF4A46B4A
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C30E168E5D
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E817324A062;
	Wed, 26 Feb 2025 19:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZlKg+EE8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E9243952
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 19:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599039; cv=none; b=s/CmzQdRzp2TFcgVxukSJj7FUGhpBBG5H2JPJbuUkzcUCuqZernlFnEYSD+Ap6HZZRttKMBgH2KBRgjCSVaXq2r6o0WTF/eHTctYkKzyiM5GPq10ZvsilafQpYC31FtIWLs+c02YStNmDzW2+kfSe4Hv4NxHQQSowxyN3wEYXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599039; c=relaxed/simple;
	bh=d+3Xa90kEP/tvphor+5LeyeLnqS9aMCkcfd5dDXJ66g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=r8hcfL/PQ3J+CoFIWh8HbvqR5e9Umwb5mVm/Kq1EVoPtWH4wckxR7vy+SLHmJG1pmmgFOCoogq67Q5E+amVCHzkG30bnk/RQJUXWO544iqatzPUdP6G5vAH2L7A41zRM0ldi75oYtiW6WFd/XSR4EVPvJW8y6WxGpl46ia7T0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZlKg+EE8; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-855fc51bdfcso42784939f.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740599037; x=1741203837; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sLDeLKPUoOShmf1w7pHGv7wy9rSrQDySNHUSOVnEJhk=;
        b=ZlKg+EE8N8eqYeH9wXrcfO5nSpCee8QIPpKMJYA3GoEXRMrlKObWkoXcUQY88Y1lIB
         yCQc8BTuWR20OxPElp6n0GncNvBbBpoNxasW87I+/YU0xv6VG9ld1X+DgP52f7ryeQya
         venVBsR4EJd9WScGKfkXm0cuiOMfFi7lSHdmpwnZUbBh2mgKiGsLeDAcKIuffh8L1hMT
         8FSXBAtpxq33orxmqMYZ3CS5vMMW2uArRyJP6Ay5iNf7JXjjGBIN7rtCc6WuddYVgb6w
         6lv+cLVB1gN7xqPd4J5iJ6ihBzlZh/2dej26lVzfWlmvsqLCVv47kNebad/YAz+nnwBj
         vA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740599037; x=1741203837;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sLDeLKPUoOShmf1w7pHGv7wy9rSrQDySNHUSOVnEJhk=;
        b=k6wmTk5O3IoIu2njJYyCoArdos48pLev9jfQtCes2Yz02P0SnNvFThIRShNMVleiT9
         rQgdhZ7yJ52jIdDPSSMRd8M77LII8wvccQoWglYYNO9y9fdfvJFPPvLFg7xQwKgiYn4d
         cGK/rlqEqJEqtcqU/CW+NezHi4V5CGfEPboFz66yzjL0mMs/oYYlzvs8+QPQs3Wr0+DD
         FiQYwtuVCOfcEi1o8zET+rpksj/x7YYA7pO+bh20DIVjurjCFd0/7OrMIOTrwu2r9x8n
         ji+AxKiyrSL3ZvtN2laxhZp9O/pKqZn5GS/2FWNE0ZP0WGnGeCC2mgH/w6TMM+rAnX05
         sQ/w==
X-Forwarded-Encrypted: i=1; AJvYcCVkazCBN7vn7d91fN5/1bseCyV8ptuLdxzHiOrfh9etUYk+x2pZQV/ptzxphcbeDflG5PhfQYVfDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM1tC1bvk2ngJ/TA7eqpnVNH4YKsWdHiUK6dzesSqtXCcvmW1R
	RROFaT5/2M3x9S/Smh72Er6/r3Vz086guMBAdQ0/4NApMkgS64q6K0QevnGqorI=
X-Gm-Gg: ASbGnct6a5LR0JgXs/2Xzg/dr+P9Zcd9gZ1u/F48q57ku7OQZErdsOcZ7bEsOui5lwz
	kxAmn01MnO+UTBYTVOx9KO5sJ+R2yv6Xf2mstSbpmbvmbf0lT2EkdpH4E2KaJyv1OKFEsCcKavO
	0cMCfzw4jZIVgJ+UKd4cNO2LU04Be4ewKakuH+8AbZKSkNoSyoFBizHIdNj4pYHhoF7dkVWqxJg
	cSK/sDaADoaGA/g4Hi9KdE1fQLWGwP9Mzu6WaEsEBxkqy3oecrm1g27fmx9qLqD6ECafpZ143pf
	dZ3PYQ6/muQ5cb9uFbeACg==
X-Google-Smtp-Source: AGHT+IEHXu4Adf4k7lWreSj75gITEDxxBueHs8E5ge9AqxuGDEfV9yiPcdGZf2s42AauL5pJO3vumQ==
X-Received: by 2002:a5e:8a0a:0:b0:856:290e:6399 with SMTP id ca18e2360f4ac-85870ec35fbmr60644539f.3.1740599037569;
        Wed, 26 Feb 2025 11:43:57 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-856209f8868sm86187539f.1.2025.02.26.11.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 11:43:56 -0800 (PST)
Message-ID: <e20b3f2f-9842-49a8-9f78-c469957e66f5@kernel.dk>
Date: Wed, 26 Feb 2025 12:43:56 -0700
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
Content-Language: en-US
In-Reply-To: <83b85824-ddef-475e-ba83-b311f1a7b98f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ignore this one, that was bogus. Trying to understand a crash in here.

-- 
Jens Axboe


