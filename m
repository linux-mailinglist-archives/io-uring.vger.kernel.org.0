Return-Path: <io-uring+bounces-11701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7F3D1F522
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FDED303256F
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 14:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D022C08CC;
	Wed, 14 Jan 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3PJaQVz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6852127FD49
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768399851; cv=none; b=HIZZAUAqn8vWiXL0issLw0uHHGvOFPd8NoZ2rRxaOnTwAGlKxNqnq84H5hOOb/FX66mQ9W33VXhU1s0EeTCXJjaO5i9efl74yfixPd1Gq/pe4ruRit0dDIL3iiJaEMwMSQDTWaQSvvLEHLpXTZ+srX/NyrPR7mBO8o4Nq1fR7Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768399851; c=relaxed/simple;
	bh=Oy1GZamcfU8TANNFsTUowkejXjT/VdSeCqXNdBr9wrk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WfNJMT5XGiRfut12vx6MDZSWMCEg4u0rT4uHY8mWdTT+y8yKIChF6mYTYfFC+f8UJkYyzv+/Hgazv2g6FDqxSNOe+xBRRuqEZzJo+5dtr7tu0r/Ox5jDrkYABS0FaWirGQsn08IRsy3+1sBpnxTO8a6yYAtRNehgpmgjF8UlQIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R3PJaQVz; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso40098055e9.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 06:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768399848; x=1769004648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NKfIzZKRSGITbimksthd5BqfCrGlQFZ9/UOQGthq6w8=;
        b=R3PJaQVzdrJUVM00B9+fLhS/MidmZxJNjnWmnQvMgbK804LN7Id38AQygH3eSizqJr
         6drFcmf3DQzodriFKNCzlp/w6mT3bUJvPI2q3TTrAgWkqrTGwwhDklZzC3LML7VbJMRy
         hPUeRPrv8gzYlOieJk6xZPY1NSjmr8qwEyU0JVOboo4gUr9auyz2A5J/Tm2HdeukWj9l
         YSCl5iTD2KJ4Jg1m97WJ/tWrNVDy/e4vEdk2XAUtUl4EAJAhGwopONUjHPDx+vtHyoOr
         5xn98WZJikvEPJRejtTHCj4mtW+PWXmNeAUwXfGZyINZS1gokKEfIFpUjLlmTSmTIjp1
         Z9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768399848; x=1769004648;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKfIzZKRSGITbimksthd5BqfCrGlQFZ9/UOQGthq6w8=;
        b=f1DYPBM+4jVYixOH30deojQZGJ6+pnN8DsukWvMOLADEgrOw4obrbn/FsWAH5w1aGK
         06CXrH0DBTHdMs0TmmY6eZeAd1Yh4Gc30dvz4F7Yjux0gMs9tHctqeVOshMu3cMaoT2G
         6WJ5Q0ot1shroc8nLzgblRrrgswavp+MBfRNqtRsUGFOvvBXHQYSfbapTbYZqyUO4aO8
         oRfZ8SfsUKzUEutx1gAjAdwZ0rhNH15Bml8SaFC5k2YF3n5O7Voc4Z52OUhQq82/b0wq
         5heZlTTZ2/EMEFp7Ai2p+B/5US3ZhegdYrm97tmKUSXPlGu7bWkFuvKnpDNHeIhHXVSY
         cACQ==
X-Gm-Message-State: AOJu0Yx8y1z/tKE0ViGf0Xrzf6N6L1z7xT3G7IV0G4dAywROJBEdzJqd
	RLOD5+ltF0ChxOyoFKCdQ9tBoD1wyzvH9lEf4aGuqgbx3gPvoJ2+wwMp
X-Gm-Gg: AY/fxX4GlsfvTk6Oy21mvNYcB6m3llEo3ZHeb/P3E3keEyNg/kVX6AGRbGwqEVU1FBW
	lItZlD899f2vYXilehrJsJtzVrHBBq56Q0WTAaTU4BeAgO55uijicVcEO0ULDZuUqk/8fnR2Ozh
	H6cmVxYhEOzb3VZhtLe3Q6TRysDLwLWwgVc1FdriVKX9YNOxuf6qxh+6Cv8o1lXzZyw340FiSUU
	HOWOEt7TUhsk/OtRySc6hCL9WrdzRVAHm1QKGxbS2BJIWdY+fUyB1oiiMtSsDxi3T/4QXXqu4Wx
	OKUuIDq5wd5ZdoyC87zpL6ATTYXf0axd3i9vzgXOcY8BkIGl7sIy7hkLdqvPMWzLrcpcgVuvg36
	Q6C+yrRKAp8x47640su/NuHTQbqfKEt9/jvRl1gUs343O904rIx4xUeXPgaq1s2Hpui/asUz0ze
	U8Mc1isSu7P3JfwC1NuUQt9GRLyv8SynFSEf30HsezrJSsGBmw8D0Eb4fe4tX3E1NC228fCwxW0
	4yoBk9px8vsc2l1xpw2yLGcNgSUdhPpgIUfdOn4faVgOC0=
X-Received: by 2002:a05:600c:8b2f:b0:479:3a86:dc1e with SMTP id 5b1f17b1804b1-47ee4840941mr27664555e9.36.1768399847547;
        Wed, 14 Jan 2026 06:10:47 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b3cc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e17aasm50733148f8f.15.2026.01.14.06.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 06:10:46 -0800 (PST)
Message-ID: <0adb508f-480d-4bfc-b861-3cf42e87bee1@gmail.com>
Date: Wed, 14 Jan 2026 14:10:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass via compound
 page accounting
From: Pavel Begunkov <asml.silence@gmail.com>
To: Yuhao Jiang <danisjiang@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251218025947.36115-1-danisjiang@gmail.com>
 <CAHYQsXQzAWhpwzqSTGxvWgNXq_=g4V_nsmRGnYeKPumGgAmyXw@mail.gmail.com>
 <afe7d084-a254-46a3-889b-a136dc8f4fbd@gmail.com>
Content-Language: en-US
In-Reply-To: <afe7d084-a254-46a3-889b-a136dc8f4fbd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/13/26 19:44, Pavel Begunkov wrote:
> On 1/9/26 03:02, Yuhao Jiang wrote:
>> Hi Jens, Pavel, and all,
>>
>> Just a gentle follow-up on this patch below.
>> Please let me know if there are any concerns or if changes are needed.
> 
> I'm pretty this will break with buffer sharing / cloning. I'd
> be tempted to remove all this cross buffer accounting logic
> and overestimate it, the current accounting is not sane.
> Otherwise, it'll likely need some proxy object shared b/w
> buffers or some other overly overcomplicated solution

Another way would be to double account cloned buffers and then
have your patch, which combines overaccounting with the ugliness
of full buffer table walks.

>> On Wed, Dec 17, 2025 at 9:00 PM Yuhao Jiang <danisjiang@gmail.com> wrote:
>>>
>>> When multiple registered buffers share the same compound page, only the
>>> first buffer accounts for the memory via io_buffer_account_pin(). The
>>> subsequent buffers skip accounting since headpage_already_acct() returns
>>> true.
>>>
>>> When the first buffer is unregistered, the accounting is decremented,
>>> but the compound page remains pinned by the remaining buffers. This
>>> creates a state where pinned memory is not properly accounted against
>>> RLIMIT_MEMLOCK.
>>>
>>> On systems with HugeTLB pages pre-allocated, an unprivileged user can
>>> exploit this to pin memory beyond RLIMIT_MEMLOCK by cycling buffer
>>> registrations. The bypass amount is proportional to the number of
>>> available huge pages, potentially allowing gigabytes of memory to be
>>> pinned while the kernel accounting shows near-zero.
>>>
>>> Fix this by recalculating the actual pages to unaccount when unmapping
>>> a buffer. For regular pages, always unaccount. For compound pages, only
>>> unaccount if no other registered buffer references the same compound
>>> page. This ensures the accounting persists until the last buffer
>>> referencing the compound page is released.
>>>
>>> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
>>> Fixes: 57bebf807e2a ("io_uring/rsrc: optimise registered huge pages")
> 
> That's not the right commit, the accounting is ancient, should
> get blamed somewhere around first commits that added registered
> buffers.

Turns it came just a bit later:

commit de2939388be564836b06f0f06b3787bdedaed822
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Sep 17 16:19:16 2020 -0600

     io_uring: improve registered buffer accounting for huge pages

-- 
Pavel Begunkov


