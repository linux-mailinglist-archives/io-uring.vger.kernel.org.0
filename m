Return-Path: <io-uring+bounces-3197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB96979E09
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65FD0B23373
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 09:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73113149C7B;
	Mon, 16 Sep 2024 09:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NJWJ0CEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0C814D2A3
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 09:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477865; cv=none; b=iOtLMkfGVvqlPpmEP0PgAJVSG7vBZVmXrK5McJRRR+VkQmjapiQUHrt9B/7lIbBi1t4N+hRmvL/1SHRbWY87Fo8dlpzwCaNy3raPl6iPNT3zQdempMkxftwA8jSw+og24LI+XZG1lwWF2zDf2sMKOoWQa4YkKQ2ftQk4nQG0W/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477865; c=relaxed/simple;
	bh=oKv1j2zjEgbUuEBo8uTbPvQcbqaTBQ0Tfje6V1vCbLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lAR1xYMkYrfjElZiik9Iqde2ESbgyzz1SQTw8e5Pj5tkzn9aHEwDgiw+xGBNrNxiP7XyPB30mPjKQpRDHo3l378Z76xgURJ0Og7o51NyoNHsur5rWszp8xSDHPdXl4cASROqkWh+OPJnivWmEhgJZlDVQDDCwXApDVtAOrOsN4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NJWJ0CEW; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-710e1a48130so683123a34.1
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 02:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726477863; x=1727082663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iB0iLT/8TvTmHJn9WRSQVtiSgNMjO9zWYPE4mvQ/O/U=;
        b=NJWJ0CEWJkAq8ZiYiSBJ6ilnb5FZ+245p+QWlvNKDt8OFBZWA28XO38qzlZXsVtSXv
         z0S8yL1CK5gdIxmbU6Tfx135GFOXZpI+lWu525yUZc6wbi8EN3K2p/TV5P3wPbSQg2di
         RZqOkBfpwUss2GwQcd+XzbpLbOqOSe1vj5kK64CSR0M9OQQW47Wvd3DVc7wCMIGR74Mg
         F6GNsgD73/edbezEinsQRNENZFkEAFtESYfuUSG9YF0RuP2mCGqjQe7qkIXnkt5jIUaF
         rzQqO3NjzYcQS18D8yeHpJY2bJ8fRAzyxy0KixFTQMP5YmG1/bfI6MbSpLHh7zdxJdkm
         u84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726477863; x=1727082663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB0iLT/8TvTmHJn9WRSQVtiSgNMjO9zWYPE4mvQ/O/U=;
        b=NIebm5RWSCnwtLhH/fqFSekmVD8HQTcIvrgjYTtTN3Ys7P9nHN7l2bb4b1UD4bVbhe
         OJdUSeMMIyGFZ0TYrT9/jp/Kdf8bzxvgfC7PPF++iiK6/guidaL5dG3bMa5rU0xYp6bI
         ZruOOU8SfxFgjOD1ngUMWoDXilgnCNcY18swoffL+y6qud+oW1xcq6jcnpXnttMvWjM6
         E1Edy4Sphsef7riAEcxFOBLWzv8ruUj1CISsF2e1KEiu3JhCfX+ZCk0zIr9FqFMDn2PR
         U3Nx4VDhjG5jvQ4ZI9X/hc3iX5yt32uRhTyRFISUWkzOJYbzUQAiI5bc71XJ9llE9M9e
         tRZA==
X-Forwarded-Encrypted: i=1; AJvYcCWE4fkoT4xvdaEpHH4tPVPrLs0Ow/0/Pdf26lgWb7ACdog2etqq3yFRbFz4NU9Z1cvWGi3q/afKUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUtl+AmWDDOTKDuKH2xUucEBRVmu29q/l+LIiN5h5tCIyDBi1f
	V3czBK+ikYCOloUr/bX6rdH9eaJArNI6pKMOvWg/VuFwHA61RqVQR67ravPxUTM=
X-Google-Smtp-Source: AGHT+IG18RdOm0vbAKJkm4n4+MaSSOZH1X3lKxpugiFqOkoBdF4w8BZj/FNu0e6PRg7IZRuZ22LDlg==
X-Received: by 2002:a05:6830:2113:b0:710:bffc:a28e with SMTP id 46e09a7af769-71116c0d855mr5273746a34.19.1726477862747;
        Mon, 16 Sep 2024 02:11:02 -0700 (PDT)
Received: from ?IPV6:2600:380:6345:6937:6815:e2a7:e82c:fd22? ([2600:380:6345:6937:6815:e2a7:e82c:fd22])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71239eccdf4sm1026813a34.36.2024.09.16.02.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 02:11:02 -0700 (PDT)
Message-ID: <da3f34b8-220c-4951-835e-a9036e79f47f@kernel.dk>
Date: Mon, 16 Sep 2024 03:10:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [axboe-block:for-6.12/io_uring] [io_uring/sqpoll] f011c9cf04:
 BUG:KASAN:slab-out-of-bounds_in_io_sq_offload_create
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>,
 "oliver.sang@intel.com" <oliver.sang@intel.com>
Cc: "oe-lkp@lists.linux.dev" <oe-lkp@lists.linux.dev>,
 "lkp@intel.com" <lkp@intel.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <202409161632.cbeeca0d-lkp@intel.com>
 <59e44de9-8194-4817-b910-0de89fea1452@kernel.dk>
 <1c5f77a9253ac3a56a1e00f7b588d86d447a54c5.camel@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1c5f77a9253ac3a56a1e00f7b588d86d447a54c5.camel@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/24 3:09 AM, MOESSBAUER, Felix wrote:
> Thanks for fixing. While we are at it, I noticed that putting the
> cpumask on the stack is discouraged. We should better allocate it like
> in my other patches. Shall I send a fixup patch?

Yes probably not a bad idea, some systems configure with a large number
of possible CPUs.

-- 
Jens Axboe

