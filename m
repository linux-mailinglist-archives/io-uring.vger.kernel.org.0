Return-Path: <io-uring+bounces-9555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AFEB42D42
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 01:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFC401B2720A
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 23:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B0F21771B;
	Wed,  3 Sep 2025 23:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iz3y9e2Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C3C32F775
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 23:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756941404; cv=none; b=K0XIDPgmaYRbQWfUPTbCq7OtL33DT0njnnYk67v6dDe2nr6kKbCaltHWvL/89qgXvP6rSgi26OtBVip326/qKhd95AogVXml2EdsTSz/6PP+AeY+3E/xKd3aSWdNEXMtf6VStFNsD4XfOknxI9BV3tNtxbVfbNyzuFnKDEkVrFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756941404; c=relaxed/simple;
	bh=pFx7XWcGl6utlmWhzJGmvbSQZ1HAvh4p4+RjC+57UmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zmta+MQcy+sQfFD45TbQJY1eYYvGEUSov8VtU5CnEY9g1T7+fLj3+GbXRuvnzMIhm8Md6Q2zGaAnbOaJmOElXp+TSP0O+TSgqcRtSC+w7MNvWZtY8Db3FGxaoAbjE8areTki8JcgiV01Y+oUOnrJaEny+zejbnjBhrzUnokFTzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iz3y9e2Y; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3f23f3fc686so3019595ab.2
        for <io-uring@vger.kernel.org>; Wed, 03 Sep 2025 16:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756941401; x=1757546201; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+KPINxE8NLcsO2+XZfNzopULJzjAwBxz5WLUo/LdzEw=;
        b=iz3y9e2YJ31NRNmT80QNw49auXg1RvsfX5AA2b/ga940YLPxeC2HkQaa3bmixXbMFR
         JRDQyf0MdCz3y+yEJawQTOV015+mjJktxbat6hnUtxzFZ0O+TOMqp3Vs+LzO2HgTbCSU
         1F2ED5awlJx80sFZgEnYba5/22ZiIdJprZRxJ8cXURgN7xYKkUiyd46/xvwED0CJJ48P
         ZedaI4nrqlt4PtrsP/L8IfMmCV8ZBQLxeTI7VMpWwKFsP9NkT8fc7eoYzdC3T88BVTW/
         2NQzUvi3feRRBh24SIKgz3srUiluoxrzq5hEQdxX6+eV5/DP799GmBzoz1qNekL5RzpY
         fh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756941401; x=1757546201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+KPINxE8NLcsO2+XZfNzopULJzjAwBxz5WLUo/LdzEw=;
        b=W6Q0GeZJ5E7/8D+mHRA4/MOufUYGTHmOC6VlQ4tCM1e5Ky9qn2JN3QQ0ddQbyegtBC
         9zolP5bSXSrIXWJ+FfsrKm6VrJLHtz+ZIFxfOdZNs/oiC9b1BB0mx3bfsNaFJ4iQpqsW
         r/1BYMgOItkZlQ2ITlC0S4KyZG7zVSNFWw3qb1CF65bbkJKz4Pv6MsomtnWQTPyrWWg+
         qePMjJbO99ZTJH4EkPie8WAk6E6d5XeJz+2JJbZGCYmTFryNysvT59G0AisKVm9k69vO
         Pc2sjitLvZ7gtfR01WqnV/5NSF5HZ3/wSh+EwD1yu5Qb3AAZrInc2G7BPkYiZOjy7BDi
         El6Q==
X-Gm-Message-State: AOJu0Yz3Ci5M/2XjQulCvjyjh79UcDQoI52mEcdrza5DxpViqHw8GbsP
	78lTVDiH0MM9BzmgSjVDXkRQSJ0czbTSf5+DuPUQWgre/lfSBB9G+5QeEKe3RWoEWiQ=
X-Gm-Gg: ASbGnctmCWi4fAlDYqZIwi0gujj1vAIkBYEhvfMhmoP7cHqHKL25ZsEWCKf0Nn4W6Gz
	EsKPwciKw03GldR/7ZEYuwVEe5zVCfvzYjyLQ5BU15nPyvzpX6NxhKH38iAtYjeQ+KvXyL//UuR
	g8KYZBzepjWW5txh1Eoyq+VSG6Fdn2RBLcPtA8Mejz5NRwAEYR+9GBzPICGTT143BvNwj2xxQ/A
	dO02LdflHuM4KeJxrSR6LRNZJ8w/FF0LeQ4B2X/Soo+gfX+EMzln/UA3OsHbMa2LP7RbaaMDWXF
	NFOuXl0xM8/Hxr8qUfCv7/LKcjHkfIJCaqe9J5kigP7k4SGlQHAETieLXM1xoG9PElBZ4Qinovj
	j18LiC2EsXrl5XPoQQQ==
X-Google-Smtp-Source: AGHT+IG01+W9C+jp8uuJ6RhPj6TWC9qjYtGqfBKyHCxLVVNZ/WZUlprqA6pmAZkb2nBGyflgs6jh9g==
X-Received: by 2002:a05:6e02:1aa6:b0:3ed:a76d:bce1 with SMTP id e9e14a558f8ab-3f3ffcac8a0mr233316755ab.7.1756941401095;
        Wed, 03 Sep 2025 16:16:41 -0700 (PDT)
Received: from [172.20.0.68] ([70.88.81.106])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f65c076d97sm18857345ab.19.2025.09.03.16.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 16:16:40 -0700 (PDT)
Message-ID: <51277999-41ec-45ad-a074-2352f46c882e@kernel.dk>
Date: Wed, 3 Sep 2025 17:16:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove WRITE_ONCE() in io_uring_create()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250902215144.1925256-1-csander@purestorage.com>
 <28b5e071-70f2-4f46-86af-11879be0f2a4@kernel.dk>
 <CADUfDZrpJuq7QH47XTBvCFsENm88WQGX2YYnEPHat_UD6nLC=A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrpJuq7QH47XTBvCFsENm88WQGX2YYnEPHat_UD6nLC=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/2/25 9:32 PM, Caleb Sander Mateos wrote:
> On Tue, Sep 2, 2025 at 6:20 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/2/25 3:51 PM, Caleb Sander Mateos wrote:
>>> There's no need to use WRITE_ONCE() to set ctx->submitter_task in
>>> io_uring_create() since no other thread can access the io_ring_ctx until
>>> a file descriptor is associated with it. So use a normal assignment
>>> instead of WRITE_ONCE().
>>
>> Would probably warrant a code comment to that effect, as just reading
>> the code would be slightly confusing after this.
> 
> Could you elaborate on why you find it confusing? I wouldn't expect to
> see WRITE_ONCE() or any other atomic operation used when initializing
> memory prior to it being made accessible from other threads. It looks
> like commit 8579538c89e3 ("io_uring/msg_ring: fix remote queue to
> disabled ring") added the WRITE_ONCE() both here and in
> io_register_enable_rings(). But it's only needed in
> io_register_enable_rings(), where the io_ring_ctx already has an
> associated file descriptor and may be accessed concurrently from
> multiple threads.

Just add simple comment saying something like "No need for a WRITE_ONCE()
here, as it's before the ring is visible/enabled". Otherwise I bet I'll
be fielding a patch for that in the future.

-- 
Jens Axboe


