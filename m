Return-Path: <io-uring+bounces-2480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B677492C42A
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 21:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E78061C222C7
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 19:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40E9182A78;
	Tue,  9 Jul 2024 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYi8hbCM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C184182A74;
	Tue,  9 Jul 2024 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720554938; cv=none; b=U1yJRUWSU2ykYAbHk2sVq3lDMLaPzISkHCq/cb/eLjiHHoTSjmARHgy3WOFsISAcEsjITsXnPyt82KyyVa0UrZy+dCl44QqSznuUv4fNjm/2MvNwsJBEXkd3TC7gfW5P57/PtPuYrRbYjkbgS0daLDDxxFNV7yVYa+oB2b1BQ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720554938; c=relaxed/simple;
	bh=fX/KQ+mAl0LS1uvwZ5S2iSk6vGVLpLkxqGmAAdu8FJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPGEHdiAoTPjmzCkUKh9VfQnM+4/V0duG1uJ5GrsjLkwNCOJxsdNSbcQrDA0mhX6KB9fzq2OvE8n/UY9ck4AqTns3svDtVtMZ2UYR7xLCnUGV3H1ujrzEjA55YhMu939ctaIZcB4eV43lN0Tqyd1r7Sj75pDujIL8KjC/huW4RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYi8hbCM; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-36798779d75so4864006f8f.3;
        Tue, 09 Jul 2024 12:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720554935; x=1721159735; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tj8SXQ2T3v0Iau1Rc6pv6fU6a86nQKAkdshKGb1RYAY=;
        b=UYi8hbCMvA5lDAFSbgSv+0MRCPSuADFKiAw/0FR0bXVGG8LygoDrznTWlcAz9P7yzd
         njuk3OG9R8zvHKbgI5m29CB5ULLxYAew7llAJaSnyAqZ82FJCvmvbAfo7dvsHBL1v6/f
         PYx42onVwxrI/ZLhiNCwvE8tavbc05uHvKWXQO0f4Z+ueHUVhX64S2Tz49oIOJALdLqm
         Pi1geTD55SFcOric3s8O8TsIdnDHJdcGE8J1Zwk+6z/VzItgFhME/nWhh5ZTUtKwVXUT
         SQqndF1EgnPGxqe6FmPtF/XUe0p8p7xoMeM4lKNCiHRFuIRj+4JsNfCisz4VZ/U/ME9H
         6b5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720554935; x=1721159735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tj8SXQ2T3v0Iau1Rc6pv6fU6a86nQKAkdshKGb1RYAY=;
        b=s1fp6nPLuh8ip9d//4ezzdMbCNXu2akOttel9k6WMDmypP2s5f/bXMMOFAQ8io/x4N
         3jFqqNcAbB4SYxq3kAVu/FembDq9pjGqrmpcBHJFAYhrOdGdbBcEJsoQXQjoeBKaqJsz
         leXH9mprg7lUAX5Aav8RmGostQyvT9FOgCObl4oVLEbiZXo6GF0SNLF76bkPylt9mXt/
         6EWAnBeY3X4MPxuO1GdioGj9bwjqOSjpKTuGKqm1SWiCR1z2LxAyQk9ho1hFwnsBdGOI
         3z+bebbKUMCcEt4q9ICQHA2hd5bS5vZBcIH+N6MpB879Gq3THqMHt0ww9bzl9tzEI/9O
         Af9w==
X-Forwarded-Encrypted: i=1; AJvYcCWwo3Q8ebEsdfW71R0rgU84DXJsgTRCUJrW4Ba4s0LPurNk8ywm4NrolSDCA22IVa1HX6T2WY/5J116G7dR2K85sJ1RzBKAefhqLWQfktcUOc9gARN2Ba2Fa/79Whf6RgHaEZfJbvA=
X-Gm-Message-State: AOJu0YxmaOIe4ei/N6sbATqnGChyNZEv2ds0rjB+E0u6LVSqsQDjCZWE
	SJIFaKiXS3IEYaAyGmsqsfWlyZuzCknQuVDGafUnwpxOBiYu+/GZSGzx6A==
X-Google-Smtp-Source: AGHT+IGuTvXzsHmHxXkl4S3WCqh+kTVelQjxbW/kK1xkaXuhWYCJfRW9rmD5vFzeiqnd56AGP6+eKQ==
X-Received: by 2002:a05:6000:a8f:b0:366:f74f:abf0 with SMTP id ffacd0b85a97d-367cea67d3cmr3007527f8f.16.1720554935214;
        Tue, 09 Jul 2024 12:55:35 -0700 (PDT)
Received: from [192.168.42.222] ([148.252.145.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cde7e192sm3429120f8f.9.2024.07.09.12.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 12:55:34 -0700 (PDT)
Message-ID: <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
Date: Tue, 9 Jul 2024 20:55:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Tycho Andersen <tandersen@netflix.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 Julian Orth <ju.orth@gmail.com>, Peter Zijlstra <peterz@infradead.org>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org> <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240709193828.GC3892@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 20:38, Oleg Nesterov wrote:
> On 07/09, Pavel Begunkov wrote:
>>
>> On 7/9/24 20:07, Oleg Nesterov wrote:
>>> Hi Tejun,
>>>
>>> Thanks for looking at this, can you review this V2 patch from Pavel?
> 
> Just in case, I obviously meant our next (V2) patch
> 
> [PATCH v2 2/2] kernel: rerun task_work while freezing in get_signal()
> https://lore.kernel.org/all/149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com/
> 
>>> Well, I don't really understand what can snapshot/restore actually mean...
>>
>> CRIU, I assume. I'll try it ...
> 
> Than I think we can forget about task_works and this patch. CRIU dumps
> the tasks in TASK_TRACED state.

And would be hard to test, io_uring (the main source of task_work)
is not supported

(00.466022) Error (criu/proc_parse.c:477): Unknown shit 600 (anon_inode:[io_uring])
...
(00.467642) Unfreezing tasks into 1
(00.467656)     Unseizing 15488 into 1
(00.468149) Error (criu/cr-dump.c:2111): Dumping FAILED.


>> ... but I'm inclined to think the patch makes sense regardless,
>> we're replacing an infinite loop with wait-wake-execute-wait.
> 
> Agreed.

-- 
Pavel Begunkov

