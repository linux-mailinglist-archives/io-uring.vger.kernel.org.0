Return-Path: <io-uring+bounces-5164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 873EE9DF712
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 21:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C349281893
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 20:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37491D8E1E;
	Sun,  1 Dec 2024 20:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SwJotehU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3B1D7E4F
	for <io-uring@vger.kernel.org>; Sun,  1 Dec 2024 20:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733084630; cv=none; b=D4HMp71AkrOPcb4AkLKzA2+55QbYOrIrinVNUv04dayHGWKiLqadWQezWSQcTc+riU8QY48vrq2BaVDG9vr9bTtd1A2NcFx772kJscnml9OMD7diTb9O84Ky8G9f/g4nDF3ajcn175nG0Mb3EYit06RkpmiqIBpJ/sm96CwJQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733084630; c=relaxed/simple;
	bh=4xGNzN9Wp70Q9GgcCs1b92wuOYHLnPfSc5E75h7FS04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JBA0z7J7gfCN4Lyec67mS+Fo79k4Qu+t8Yhr9+KIanuBiyqLU4To8z8R36l8pCf3AO0UYJUq6sqdpvf5YwQ5WEgaDXiPGjWjNSmaEnkz+yEiC2ZKBxcPspL9x1HZkos/GuZQL30uL5heuC+4nFyI9v+cNM2ukXbWW92jGFB9DSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SwJotehU; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d0bde80b4bso2854715a12.2
        for <io-uring@vger.kernel.org>; Sun, 01 Dec 2024 12:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733084627; x=1733689427; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N0PBRuUNrVMG3jWkuVgZ+alnShpvbiX+xpV3R8jGwMw=;
        b=SwJotehUo7tgTiDD3jJ6uEyXPyF0+fo2O0fv5nx0TvQp3LH4IOXDHDdxlDrlTsSq3M
         FZocGm3vD5cXk9uu3iMTpOl3w+Q/QDnOr2VSaHX2qJW/6+7FHGOr03YKQ6Jq/xQ96cHM
         lvb68nEI0gIH/pfPJ5zJcBxrfli/AJLjb/RSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733084627; x=1733689427;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0PBRuUNrVMG3jWkuVgZ+alnShpvbiX+xpV3R8jGwMw=;
        b=K2Xc4NHSyxu+AfQ+tQ0ixbxQdLMUI5IpITTROanB7Zb+tQxOQ0CJ/YpvUWYLYGmnGJ
         3Ksr7oHzYdU+dkeKJSQKuMfsK6mqEeLhhnS1PjXoS/3RpPfF3nihuLxOOym7sUo3F/Z5
         3Ggo6924LwpTLDqRAw1s/0JYCsMdUg9RoHyJt1jgH+zp1lO7LTNx98zgU0/apB7b5M38
         GRePIw2r8VXS2oDiANysKCwKq/AdovpOo4YgdMex/Uwm9NuH+WzcCXEYDcyEnrVAsV5/
         n6ZgwM1K4Zg7IgBU4OUt3pCGU91LMVq/TCdidJHyuXR1rjOoy36GCXOXPsXJDk5bfKxE
         cUxA==
X-Forwarded-Encrypted: i=1; AJvYcCWjEju0Ts6UxSu3P78IzCle9T0C0nOfY9rz1ltoVEOcGxQu+Dvt6S8QkNOa0p/k8PaqOcZzJTExqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNQjb0H7U1WD5xjDpbtpjRtG5siFrUazPevg73hOWSW6/LfLM9
	oqS1+WD/JyiBMXjJB5/w2+fOXGiyMb8k51kDhao/Hcy/Wh6adBRPYS8Vt1nivOxAuuNECXxdfa1
	HzZubYg==
X-Gm-Gg: ASbGncvlOgc8h1qUdcrZLlFZVgmEE+A7wSQhxITjQD//ziaUYyXVCy8zK8qg+y29kVv
	eD3D1cNIpP4tPmqO30r0pTtgOylNJKSvGeya4fQ4MQp/4l2Ha5KqoXAHcjYr9r6VVXunkXc4KX8
	027LyfNsby9sKdz71kpjSWRDRYSCL2TaDaTke6iQUWNxiiqU46UUIbTlbpXqkqC64Gnum3MT1kQ
	DeQwoIFDLeTPXeDnWgfFTpYOIgw4/qGRJ2de9sf4HAZmXwh0T2ezuZM6vNf1B1bg+n04NG9DaJU
	8p4Uyp0B7LKpDtGpICvX8M2D
X-Google-Smtp-Source: AGHT+IEhQPbGeqFHyPG0k2PPlVcq9TGFssHRPL1wBpeBlpVd3ilJRNW9yeCMQlixx/T7ANeNJe36lg==
X-Received: by 2002:a05:6402:5179:b0:5d0:e826:f10a with SMTP id 4fb4d7f45d1cf-5d0e826f2dbmr2459250a12.6.1733084626786;
        Sun, 01 Dec 2024 12:23:46 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d0d6283633sm1335018a12.69.2024.12.01.12.23.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2024 12:23:44 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso599061966b.1
        for <io-uring@vger.kernel.org>; Sun, 01 Dec 2024 12:23:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWZS8utlCuj/dv8p8vboxFYvo4ZdEeNwt0G8C26T9i0N0enYV2YWj0AV80f2yauVbEAmOiHISbd5w==@vger.kernel.org
X-Received: by 2002:a17:906:3090:b0:aa5:1585:ef33 with SMTP id
 a640c23a62f3a-aa580f1ae0emr1684398666b.23.1733084623092; Sun, 01 Dec 2024
 12:23:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130044909.work.541-kees@kernel.org> <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>
In-Reply-To: <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Dec 2024 12:23:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiGWbU-MpmrXnHdqey5kDkyXnPxQ-ZsGVGBkZQ5d5g0mw@mail.gmail.com>
Message-ID: <CAHk-=wiGWbU-MpmrXnHdqey5kDkyXnPxQ-ZsGVGBkZQ5d5g0mw@mail.gmail.com>
Subject: Re: [PATCH] exec: Make sure task->comm is always NUL-terminated
To: Kees Cook <kees@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chen Yu <yu.c.chen@intel.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 23:15, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And yes, we could make the word-at-a-time case also know about masking
> the last word, but it's kind of annoying and depends on byte ordering.

Actually, it turned out to be really trivial to do. It does depend on
byte order, but not in a very complex way.

Also, doing the memory accesses with READ_ONCE() might be good for
clarity, but it makes gcc have conniptions and makes the code
generation noticeably worse.

I'm not sure why, but gcc stops doing address generation in the memory
instruction for volatile accesses. I've seen that before, but
completely forgot about how odd the code generation becomes.

This actually generates quite good code - apart from the later
'memset()' by strscpy_pad().  Kind of sad, since the word-at-a-time
code by 'strscpy()' actually handles comm[] really well (the buffer is
a nice multiple of the word length), and extending it to padding would
be trivial.

The whole sized_strscpy_pad() macro is in fact all kinds of stupid. It does

        __wrote = sized_strscpy(__dst, __src, __count);
        if (__wrote >= 0 && __wrote < __count)

and that '__wrote' name is actively misleading, and the "__wrote <
__count" test is pointless.

The underlying sized_strscpy() function doesn't return how many
characters it wrote, it returns the length of the resulting string (or
error if it truncated it), so the return value is *always* smaller
than __count.

That's the whole point of the function, after all.

Oh well. I'll just commit my strscpy() improvement as a fix.

And I'll think about how to do the "pad" version better too. Just because.

                Linus

