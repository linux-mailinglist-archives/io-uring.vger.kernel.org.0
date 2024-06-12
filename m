Return-Path: <io-uring+bounces-2176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C13819052A5
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 14:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5505A2827DE
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 12:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1B916FF59;
	Wed, 12 Jun 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuWKReO1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7721316FF55;
	Wed, 12 Jun 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718195945; cv=none; b=o30bkns5ARNEma2CkE3/X7/oV7XeLpPfhz11eJi5AkaeNRqcwyTTPdXFKuVRXeenXjzJ471ZIOL6Dtl6bNkyxmugz3HPk9tSKieWW+ubUmACxdTFKUepj0rV8iq1UTTABT5L+64BDCu3rnrFUyV+1MORxuO3ZIcozxTpVh9Fyd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718195945; c=relaxed/simple;
	bh=VKfSUGiDu92C4bG/uJuMnOL/fobT2EuCm8Me5sLXLoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KU7ToBM1jKyIxzywP495hTu/P7A6yAMRUOpMRZNCFt8bIeEzp6xhmNckFdC17252LVjdIpGjfk+DKD0LD6THcsd0OuOhGwGJ3PqmjAFKq0en9BjWOp8kY0JfPEJI2txRqj8sGtLIDEG5euogKaJ7mYgJI5ULPMemg4akg5cijmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuWKReO1; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-579fa270e53so3583043a12.3;
        Wed, 12 Jun 2024 05:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718195942; x=1718800742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JHwQg7Oa67ELlkM6pw48Wo/WbXctSEVPQv0P9z7DLi4=;
        b=SuWKReO13EaCM/90YjAvbptKdH292Kj7f2skafp4y8GKxE88K6/UvhEW4KQ87OdjPU
         cG5bszJeB6XCtn+qZ8rCM884sQfHrDSH9LXNVdNTjyEB9iJPpgZGIGHjH05TcVL4kTL1
         46Kf5vA9uqU8Dzs2LbfUi/puwMoD83xXPZQH26jVrXDxIWsCmko62ns/G8UAULJwguII
         SoWif2dOxAPmlMHuTFvd8nEXmTHJVPkMrUuLznf4zS3YR+D2nTuhYmxiXj6qERCPp+Fv
         x7iPTD19JijSssqcaloGYhY0domEDIZmcOzOSpDZlfB/UV5Vj1rkBMy+QbRpVO9l5iJY
         VPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718195942; x=1718800742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JHwQg7Oa67ELlkM6pw48Wo/WbXctSEVPQv0P9z7DLi4=;
        b=HTK+kI/4ymzlKbzOWBBbwVbgT0+jYctMY3goR+s0/T/lCjQ16ZmAUy14GYR4trtStl
         oS7yOSAt+OCgXixZZkcdQJLcvBeVBtZVtPc+UdsxoPik4WyjRttD9wrCndfm5ptDCthe
         6h7pEdmY8+gIy2V+tdnB6qiQqM4VgCHSlBJ8KLbzD2bop0I4fnyxtIPC8gvWA2KcxVHu
         G76M4/RkUKTnxv0G86XqXyBg8gkqFZlNXhU59MvRHnAjL6VDwLOcUXcdSajLUIFfLh4r
         7zjL1W+grZcWywUv+2KR4ve1e+EeFqJgvHO135sLRdhZBxZbvlVpKcGzAiEvDMj2nzYU
         dNTg==
X-Forwarded-Encrypted: i=1; AJvYcCVph9q0/zRJgHB+EXpNyqGcAdQV1GYZsKxVbuUaila+sDTgxqwenIOxPwuSA8+TEemIx2Ve6NLmNu+pxEAu5itoNAjarsmCBqneUel+ehpGJN35tpw+YSd62EkBKhCkpyNwix/9RCs=
X-Gm-Message-State: AOJu0YzHLnVg05o4bQuU+kai+hjZ63rYeADbmzprtxaq/Yn0JXLaWQiq
	YHegvo80AOJT8wy112EsLHWQE79kgY7nL1WjeX1/rBwil04GZHzA
X-Google-Smtp-Source: AGHT+IGL9+cY7YQ0uE2oDLytePlPbT55kWA4o1t/reIYnmnOE3IT4a+/jYpC2PIOwARQfPxhjwJ/ow==
X-Received: by 2002:a50:d4d7:0:b0:57c:5fd7:ff50 with SMTP id 4fb4d7f45d1cf-57caaac66e0mr1511098a12.35.1718195941430;
        Wed, 12 Jun 2024 05:39:01 -0700 (PDT)
Received: from [192.168.42.244] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57c9f32f079sm1865179a12.88.2024.06.12.05.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 05:39:01 -0700 (PDT)
Message-ID: <b270ec7b-1c5b-47c5-b590-4f1f0276d462@gmail.com>
Date: Wed, 12 Jun 2024 13:39:09 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in io_rsrc_ref_quiesce
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CADZouDSJRVEHUK1dMQF-guuDh_EcMJE55uLYRR23M0a0gvkd=w@mail.gmail.com>
 <e0c76f8a-68c1-472c-a2f9-2e1557be26ff@gmail.com>
 <CADZouDRNKYB6ryGF+0HP5aJECUxApq4az6WNAYvjPs703mnDWA@mail.gmail.com>
 <CADZouDRrFiP+Zs-=hkFVNQhZNKCMpneaRHuXLVS_zDXkkr8CoA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDRrFiP+Zs-=hkFVNQhZNKCMpneaRHuXLVS_zDXkkr8CoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/24 07:53, chase xd wrote:
> Thanks for the reply, “xdchase” is ok for the credit.

They require a real name though, and "xdchase" doesn't seem
to qualify.


> chase xd <sl1589472800@gmail.com> 于2024年6月12日周三 08:38写道：
>>
>> Thanks for the reply, “xdchase” is ok.
>>
>> On Wed, Jun 12, 2024 at 03:13 Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 6/7/24 18:11, chase xd wrote:
>>>> Dear Linux kernel maintainers,
>>>>
>>>> Syzkaller reports this previously unknown bug on Linux
>>>> 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
>>>> silently or unintendedly fixed in the latest version.
>>>
>>> Thanks for reports, this one looks legit. I'll fix
>>> it up. Do you have a name I can put as "reported-by"?
>>>
>>>
>>> --
>>> Pavel Begunkov

-- 
Pavel Begunkov

