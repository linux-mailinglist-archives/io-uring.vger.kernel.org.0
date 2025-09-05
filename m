Return-Path: <io-uring+bounces-9597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5F3B46004
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA459A454FF
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 17:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF04835CED5;
	Fri,  5 Sep 2025 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHuo4QmT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA6F2F7AA4
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 17:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757093079; cv=none; b=dL4SKp5u55NaQXjvFnm9grGUgxLLGIX4ayz7bSF4DwZ3CeDa+FUvhrsqlTPTvAepSeLVwMtJbZIS2FLZjspE8+pt/6yXac8wX8Mpa5UrVuev+1VSJOgN4PiIh8hQS7E1x1ug6/5FrcAG3R6DPmPBmybhBvOSt9ApnSu9zvNlV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757093079; c=relaxed/simple;
	bh=OfYKVnMkszh29qi9BY4EJ/L6TXAXUARbdoIeqq75QBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A/xbOMBYG3vkaEIYavpHHjAC+GsmbVEHbtxNm542v7nxCPw3uS46SP0tL6bEzKlMrJ5Ci/T/TzO12VSaJbcazySELtTdZh/w1clBTIcqgyQvRqYJ7o+oH7L8HQf/gxD0BMh7BNDCQeFymLh+VBWMPSvnbhOcZwzhl8QuI2Sj29A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHuo4QmT; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b04271cfc3eso319976966b.3
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 10:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757093075; x=1757697875; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cLgXP0nUuKPljGYi8/jWyq52SSymo18ITef/UKlDP9M=;
        b=RHuo4QmTkWgGnqYSE1DQ6fiRz49238FOn8YfsKJBxcpaDI4SbA3j6TpXUJlnkZ3fLr
         UjkRfqTQttI31DexwfOWuTKG0d5TsqJBAWcU8Rh1Ms7FfZJ+eXfR+OckI/mJdvl7aSuw
         /G3ixmbOmUXs214mErdFyfKdnQVa7371YI3x0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757093075; x=1757697875;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cLgXP0nUuKPljGYi8/jWyq52SSymo18ITef/UKlDP9M=;
        b=rNljsFN6AuLTlFPSuoSJSvxCndI22bNQznY/q0cDKWLM51MNTdM1IaQk+HWqa02tiM
         0moN49ujmiL7+yauzYfx+DeWCbQ7/Rd+g2d8k564TCtt/ILPGpQyVbG5z0kk6PO0Y5zR
         Td5e6GhNIpZPO+M0haMFXKcAZoEJSeutogwv7uXAVUOACY6V3FfQ+YYmkCbpj2Grb1up
         jlAEhEV8rPBdXGRI/E2leq97a8kOqAF15exNDpAfRLZgAjEf0tc8dA3fvwY7a2+f0TF5
         fxkB9f1XzZSxz4RUzXrzXDmVo/QCh+X/9F2+UvHQ08WFrlA7sqoZ7a6Rn+SCxFV9t0oc
         +khQ==
X-Gm-Message-State: AOJu0YwfuiEzd9gTe94pSDCBMelilCCvEdF+Kw3L6Cu7S2nD68+bKjdn
	537U6H2HrtUqBQ2+86ZtHOXxRRpzCXhTpJ23T/d56xlM4sohvpbT4nLYcCdVg88xjYZ+gtAIAE6
	YhJuGqUQ=
X-Gm-Gg: ASbGncvbEyGD1PVsWhau5VelufMnJ3D1ZyBWJfNpCpLP6vhD8uyJuAAut2qDmg1QB+D
	weJ3AQgKWfk8YMibv2zZcgM7QsractRfzN0SiYESz2VDsu9JwXxVnWeldrfVr5AkOl0SqTgmUD/
	PCNps3FVqMh3aObHuXGJ/65MMVZDDOip6xO4g4nFqZ/h4X6fh8bjkBl1vJVrR+K03eE52HZ+o6c
	508+5AC1A6svdZjtiAB4TXNMeXXP/OiJQ+aHW5rKQ/GYBCIoce54ZdOjVUU7V+W1reKwOs0Q9zc
	Z3NKv8j79bpZ/73Aw+WYSnOSEkFbSC3lRlv3pfgi9yHK/eWL4B0MKV9R+PLts7N1wNH+FBULgzE
	QT1KF6U6w51Z0w3FS5rXGmbLss058jmdfKp0EI4F9ZLeIgRw1kUyfq8npNFVhb9AAWTHOkPYQ
X-Google-Smtp-Source: AGHT+IEAS26joLb+EpT9iwAQqoDB1RVa5j6MclYq/EVXgldjXmvldcrDerUeWpVb5zqXYJx7TVnqBQ==
X-Received: by 2002:a17:907:724e:b0:b04:5200:5ebe with SMTP id a640c23a62f3a-b0452006a0dmr1599058266b.54.1757093075219;
        Fri, 05 Sep 2025 10:24:35 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff0971379esm1781236266b.102.2025.09.05.10.24.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 10:24:34 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b043a33b060so391405766b.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 10:24:34 -0700 (PDT)
X-Received: by 2002:a17:906:694a:b0:b04:25ae:6c76 with SMTP id
 a640c23a62f3a-b0425ae7255mr1542901366b.47.1757093073940; Fri, 05 Sep 2025
 10:24:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
In-Reply-To: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Sep 2025 10:24:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
X-Gm-Features: Ac12FXyoV4y7c9v5tBanggkhIakvIPB9VzULgYlJT5puVDpl0ZhN5Ti4f9cT19g
Message-ID: <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Sept 2025 at 04:18, Jens Axboe <axboe@kernel.dk> wrote:
>
> Just a single fix for an issue with the resource node rewrite that
> happened a few releases ago. Please pull!

I've pulled this, but the commentary is strange, and the patch makes
no sense to me, so I unpulled it again.

Yes, it changes things from kvmalloc_array() to kvcalloc(). Fine.

And yes, kvcalloc() clearly clears the resulting allocation. Also fine.

But even in the old version, it used __GFP_ZERO.

In fact, afaik the *ONLY* difference between kvcalloc() and
kvmalloc_array() array is that kvcalloc() adds the __GFP_ZERO to the
flags argument:

   #define kvcalloc_node_noprof(_n,_s,_f,_node)  \
      kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)

so afaik, this doesn't actually fix anything at all.

And dammit, this commit has that promising "Link:" argument that I
hoped would explain why this pointless commit exists, but AS ALWAYS
that link only wasted my time by pointing to the same damn information
that was already there.

I was hoping that it would point to some oops report or something that
would explain why my initial reaction was wrong.

Stop this garbage already. Stop adding pointless Link arguments that
waste people's time.

Add the link if it has *ADDITIONAL* information.

Dammit, I really hate those pointless links. I love seeing *useful*
links, but 99% of the links I actually see just point to stupid
useless garbage, and it *ONLY* wastes my time. AGAIN.

So I have not pulled this, I'm annoyed by having to even look at this,
and if you actually expect me to pull this I want a real explanation
and not a useless link.

Yes, I'm grumpy. I feel like my main job - really my only job - is to
try to make sense of pull requests, and that's why I absolutely detest
these things that are automatically added and only make my job harder.

I'm cc'ing Konstantin again, because this is a prime example of why
that automation HURTS, and he was arguing in favor of that sh*t just
last week.

Can we please stop this automated idiocy?

             Linus

