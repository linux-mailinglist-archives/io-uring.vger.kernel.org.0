Return-Path: <io-uring+bounces-3017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ACBE96BFB0
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE0D81C24147
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E43E1DB93C;
	Wed,  4 Sep 2024 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdps6SmO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541C11DA317;
	Wed,  4 Sep 2024 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725458899; cv=none; b=cJbfBahlUX0hyhBZQmvJ7UhLwu2IFeOduTylOLKfrEhfUjpd8oJjJtq+qb3lgWv5G8ZrXwREZd3hyEss8ynXk+71A1lEUOyxNxOWn/vtMZ4JotX/YaoiVqSx6xBOlv9HAfGLyhM+ZYGu9mPccLUyXbDwCqPFIKxFVyCEfF+zhoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725458899; c=relaxed/simple;
	bh=TuFfSFXB3mOeMRu83p18mWmGeEZpEzUTyyyUn2eZFso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPNvZ6ETNLfpmmSVGSs4GHxPmgZhQiszOAiNo7pvGcdCjQyT8Ky1fU0Yk37/eC9D51OuZwi0AJUF3u2EBDfg7TKhomuMqGLy1YYKWHUA/Os3BFn5WNc/CUddcxKvLN5spr1jfX5nPGyuTiHbNsr9Sx/EBa/6KHIq7gpmIr5OFyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bdps6SmO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a86859e2fc0so753284166b.3;
        Wed, 04 Sep 2024 07:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725458895; x=1726063695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Vzg9NTfvw0pq61GqdD+2MdU5ejBvO4DrvV5LujxZ60=;
        b=bdps6SmOzHGF4jMo47b7xIB6lI4ZzFdR8XlvO9jEFW2lSgXhnNRqMQGINpiGnAfsCl
         lPYBWv5HukJT5YAhB3gETb5IHGm4bSVN45Z+QvaYsML6S73N1SMQdvS2bQnIHPOzg1y7
         BlOU52JgFz/ms9kKtyjUxYRYLssw4qHW3nAVangZuZzojl1jky2xNZeEYtuY9gsZeV3c
         bshLFTA/MCbcHBMPwo1IMsORDhp4eya2+iCYEE4WouMGKqSUO/Uxaf33OQcpVJlRo5Qf
         iQ1WxJ/HKHJteeBAiE5BmQPgdlyYcnIB4sW4PVSoXv4W9c0trmpUk5MtYEtvHT0IIfv/
         sh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725458895; x=1726063695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Vzg9NTfvw0pq61GqdD+2MdU5ejBvO4DrvV5LujxZ60=;
        b=L76efUXAPxzcTyGamDzSw0+OPO4rBOwYb7R1/4R3epFGbYD2TPS2D2AqSLJ1iUgHWi
         jTQuB734bylRDbFyiCvHTPzb1OGLAQilY5WIKTqhfAIsHX70+YQZFncTvxR7+sMditKK
         kT43r8igDyVY4F7Za03KzCygJeS8aSRZJPEYyRA2liEUvmATJryGHXHUj/DHgw6ius76
         +4KM0Y6RwBF8fnZ/Pp6m8G+TZ5+ZIt25nqWw/lfRXT48teuzC2WwM1KXvdvRcDWCJoSX
         kmXGguJGAZ2w3+WQb5qmBojpAXjTotsgMt3HgTvQbapmeyMJ5bjThyJtRc7Qgr2RNGJX
         Dhkg==
X-Forwarded-Encrypted: i=1; AJvYcCW6zBNa8zLoYGb2sLW+t16Aq1HS+HAAhplCfnWHO8l58sFmSUiag9ODAydnCe2tGW979WZZl+++zC+KRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyF+Ij8We2J0xU0Sklw+n0a45U/uNQTM8BYI1ZDsTOEBbEoFhqj
	S16eJdlmCv0tgYIHi95I5tsMqnWhlDLOb6FjjjW36jHDMR/oc5bn
X-Google-Smtp-Source: AGHT+IFHkxzA8+V6mMLDPA0dFW/6czPw92cnzbP7aNN0xEnuG0VygH5QgI54NmEhOeZFBBZ5S5U4Ng==
X-Received: by 2002:a17:907:2da5:b0:a86:9cff:6798 with SMTP id a640c23a62f3a-a8a32ed4b43mr369763366b.30.1725458894425;
        Wed, 04 Sep 2024 07:08:14 -0700 (PDT)
Received: from [192.168.42.8] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988feb61fsm828174566b.10.2024.09.04.07.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 07:08:13 -0700 (PDT)
Message-ID: <574578e0-ed5c-488e-b4f7-71da59651fc9@gmail.com>
Date: Wed, 4 Sep 2024 15:08:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] block: implement async discard as io_uring cmd
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dchinner@redhat.com
References: <cover.1724297388.git.asml.silence@gmail.com>
 <e39a9aabe503bbd7f2b7454327d3e6a6620deccf.1724297388.git.asml.silence@gmail.com>
 <Zsbe1mIYMd9uf8cq@infradead.org>
 <c39469f3-2b9c-493b-9cd6-94ae9a4994b8@gmail.com>
 <Zsh5kZrcL-D7sjyB@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zsh5kZrcL-D7sjyB@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/23/24 12:59, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 02:07:16PM +0100, Pavel Begunkov wrote:
>>>> Note, unlike ioctl(BLKDISCARD) with stronger guarantees against races,
>>>> we only do a best effort attempt to invalidate page cache, and it can
>>>> race with any writes and reads and leave page cache stale. It's the
>>>> same kind of races we allow to direct writes.
>>>
>>> Can you please write up a man page for this that clear documents the
>>> expecvted semantics?
>>
>> Do we have it documented anywhere how O_DIRECT writes interact
>> with page cache, so I can refer to it?
> 
> I can't find a good writeup.  Adding Dave as he tends to do long
> emails on topic like this so he might have one hiding somewhere.
> 
>>> GFP_KERNEL can often will block.  You'll probably want a GFP_NOWAIT
>>> allocation here for the nowait case.
>>
>> I can change it for clarity, but I don't think it's much of a concern
>> since the read/write path and pretty sure a bunch of other places never
>> cared about it. It does the main thing, propagating it down e.g. for
>> tag allocation.
> 
> True, we're only doing the nowait allocation for larger data
> structures.  Which is a bit odd indeed.

That's widespread, last time I looked into it no amount of patching
saved io_uring and tasks being killed by the oom reaper under memory
pressure.

>> I'd rather avoid calling bio_discard_limit() an extra time, it does
>> too much stuff inside, when the expected case is a single bio and
>> for multi-bio that overhead would really matter.
> 
> Compared to a memory allocation it's not really doing all the much.
> In the long run we really should move splitting discard bios down
> the stack like we do for normal I/O anyway.
> 
>> Maybe I should uniline blk_alloc_discard_bio() and dedup it with
> 
> uniline?  I read that as unіnline, but as it's not inline I don't
> understand what you mean either.

"Hand code" if you wish, but you can just ignore it


>>>> +#define BLOCK_URING_CMD_DISCARD			0
>>>
>>> Is fs.h the reight place for this?
>>
>> Arguable, but I can move it to io_uring, makes things simpler
>> for me.
> 
> I would have expected a uapi/linux/blkdev.h for it (and I'm kinda
> surprised we don't have that yet).

I think that would be overkill, we don't need it for just these
commands, and it's only adds pain with probing the header with
autotools or so. If there is a future vision for it I'd say we
can drop a patch on top.

>>> Curious:  how to we deal with conflicting uring cmds on different
>>> device and how do we probe for them?  The NVMe uring_cmds
>>> use the ioctl-style _IO* encoding which at least helps a bit with
>>> that and which seem like a good idea.  Maybe someone needs to write
>>> up a few lose rules on uring commands?
>>
>> My concern is that we're sacrificing compiler optimisations
>> (well, jump tables are disabled IIRC) for something that doesn't even
>> guarantee uniqueness. I'd like to see some degree of reflection,
>> like user querying a file class in terms of what operations it
>> supports, but that's beyond the scope of the series.
> 
> We can't guaranteed uniqueness, but between the class, the direction,
> and the argument size we get a pretty good one.  There is a reason
> pretty much all ioctls added in the last 25 years are using this scheme.

which is likely because some people insisted on it and not because
the scheme is so great that everyone became acolytes. Not to mention
only 256 possible "types" and the endless mess of sharing them and
trying to find a range to use. I'll convert to have less headache,
but either way we're just propagating the problem into the future.

-- 
Pavel Begunkov

