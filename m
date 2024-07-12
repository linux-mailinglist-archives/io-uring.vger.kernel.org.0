Return-Path: <io-uring+bounces-2503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7215B92FDAC
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 17:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16D94282F1D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 15:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6525C172769;
	Fri, 12 Jul 2024 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3MwJCgJk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A1417107F
	for <io-uring@vger.kernel.org>; Fri, 12 Jul 2024 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798580; cv=none; b=Z4EDJ5gfTmkoD1oGomRay37NKFcZl69PQKQRbSJXiNzXk4B5qvqSwlcUid9k6neSyUmZMHrb8f8n+iQD1fka/RKOpFL7nH8ukUDLfJfq6Z1mohuFZf7jW9cwQH3dlHrtKYik2wZtUwEYIX2qqjOuI7+IEFV813EdMJUzo0w3n5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798580; c=relaxed/simple;
	bh=MCtH3P50xp2nnh0gZUKPf4o5ijUZiWwCgPJWQJ9S8/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O845XRx1TTWi/u25Wq3ULHEUW6RvC7BTbD/GNjCmFkJbwXTkfIb2hQnxMRZN4mMzxXhRzHTnxpaROxJi57iJP5Ql68zJJbHAVcK/hyjZd814Yb3UYPV8oOYiqVIfo906BEkeBnQwzkuFdBL7bz0/Nf/XrkptwMpWORg3Z+lZSb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3MwJCgJk; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52a559e4429so343003e87.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jul 2024 08:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720798576; x=1721403376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DRyZ58jOU7H6kqYORxE2/vf+lOQEWkJQcldFASKjpoc=;
        b=3MwJCgJkDWeSQM3dffXHHE8wQTxUoyhlfs1JnH29XalYpWsx7RJrR2KJ4QXC5++ds/
         gLKcwGW0o4YHo2CEkvRSyXf1oVb9pgFAPy3WQTmE84muXkMj5AuaoDHY3OkaoPdZTFC4
         qIAuDg+jvy+ILUilDrBs9TGM7Q0bbktK5DHbtJTUcmEm17l0aVlcQkRN+AxzG8llBc5/
         9OjV91pMZtE+JRdryXW4GWqlWAtq56DJ2s8rucetZzd/GxzN3f/G2is4nFrz/b57GGjg
         efKs8eH9plYsgKx7ueucfHGkLCMliknisseu4ATrOOqRT8PIcajmvRul8LsEz+x16GVS
         4PCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720798576; x=1721403376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRyZ58jOU7H6kqYORxE2/vf+lOQEWkJQcldFASKjpoc=;
        b=p8tBmnIhoWHBbi9Bj5PtVtxHpteEgeGGUMoRnlHboEgwOcq14YEol9uwdn51QguIYg
         +r7Dssq86E8y9+GhaX91B+nhV0eV71R+rTeRZZWg6erWq8/zi8Ns4zeVM0HwKyuNcw55
         QdMzCZRWBFX+u/NnAslJTlkT8tIZMb+Wv/YU96akFiRVzS3FlWORBhxRLFq4owPs1zNJ
         9fj02UoEjyB/O3KxNWvX5J6rilbibdoe0CnIAh3b3yexJoq/xZXqp0HmMzMXR7IxhgY0
         BVfCoMqI+4vfuRkN4ycZHiUGLjUmyBuGGbJeEvM98Bt/a22rqOpKDj4EOlDHPbboOu5V
         YQ6A==
X-Forwarded-Encrypted: i=1; AJvYcCVoFpoEQPEXetWnZNzQfagK6FTsO/ziqDfC3NgNVM/LJafbaTjpHYDmpzsSVLRUyQUu+wgx6McZeHQzVtPivWb698BhDrw5uXk=
X-Gm-Message-State: AOJu0Yzni9DYmNHR/46uut5tqwD1H9zh3U6Y6lkfpg1iUmBV5bno3DqA
	YLFL3oNrM6vM9/G4mHpPiaCnaiS7gm65XfGP/blhSDkYPhvAIW36cOVHtcLRAnY=
X-Google-Smtp-Source: AGHT+IHmk30L59FFeHzj+62DGQULlJO9iDauejLpl9pE/XyYcaIoaohiw2xz1r+M+vA0EYq8RLdwEw==
X-Received: by 2002:a05:6512:2025:b0:52e:7bb4:942d with SMTP id 2adb3069b0e04-52ec3e61964mr2561765e87.1.1720798575624;
        Fri, 12 Jul 2024 08:36:15 -0700 (PDT)
Received: from ?IPV6:2a02:aa7:464b:1644:8658:b4b7:14ae:6340? ([2a02:aa7:464b:1644:8658:b4b7:14ae:6340])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52eb906ca43sm1328148e87.241.2024.07.12.08.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 08:36:14 -0700 (PDT)
Message-ID: <db1816bc-c3f4-41c0-8946-f8d4a260216a@kernel.dk>
Date: Fri, 12 Jul 2024 09:36:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: Avoid polling configuration errors
To: hexue <xue01.he@samsung.com>, hch@infradead.org
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <ZpC9HxJnokkbjKAO@infradead.org>
 <CGME20240712065750epcas5p2149131922a27554e6a40313e5c73699e@epcas5p2.samsung.com>
 <20240712065745.808422-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240712065745.808422-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/12/24 12:57 AM, hexue wrote:
>> This is wrong for multiple reasons.  One is that we can't simply poke
>> into block device internals like this in a higher layer like io_uring.
>> Second blkdev_get_no_open is in no way available for use outside the
>> block layer.  The fact that the even exist as separate helpers that
>> aren't entirely hidden is a decade old layering violation in blk-cgroup.
> 
> Got it, thanks.
> 
>> If you want to advertize this properly we'll need a flag in struct
>> file or something similar.
> 
> Thanks, I will try to do this.

My stance is still the same - why add all of this junk just to detect a
misuse of polled IO? It doesn't make sense to me, it's the very
definition of "doctor it hurts when I do this" - don't do it.

So unless this has _zero_ overhead or extra code, which obviously isn't
possible, or extraordinary arguments exists for why this should be
added, I don't see this going anywhere.

-- 
Jens Axboe


