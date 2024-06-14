Return-Path: <io-uring+bounces-2218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A06D909249
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 20:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DE77B217FE
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF6D146D62;
	Fri, 14 Jun 2024 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HwsXTEZM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98C5179BC
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 18:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389790; cv=none; b=W796HfDE/dv7/jPoTy1Rw+4JztLr5LSSFPZYX71IMq1nD051MsVorPyvoqfQTJam+X2tBxIBpH3HvrqkNURHBW7peROY0WQ08mzGQO9eepRqUI/xH98n5era2uN1x8U4UVZL4Ws1JMsO0Jf2WS/kawCDQJyPqbtPegyJQyFT8Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389790; c=relaxed/simple;
	bh=tjvwY5CuHk8XSIJf6lrTcoxNmqGOljkHwB6AExBzVWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d8bs16ygLZD+3XZ0Xd6Cr5WelmK54xbq0Kt9NRFdSU013ac75S3F1egpAKMdRvSRs9be1q2TR98NOdQ7oR+kZxe7nnJx86rihayM3bbo1IgfTQfv2DO4wJpXHc4zfz8ln3ez1pp4lLasX82SXEnEYxF3BoGKdq+2xTWGvSvKY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HwsXTEZM; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6f0dc80ab9so404841166b.2
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 11:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1718389787; x=1718994587; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0BOyQ8/qVXZmTJkzdimdIYFLmLhiPdZXAlcMcg0IfHY=;
        b=HwsXTEZMo31OjVuu/YsKTEnMOGS3NMspLS7I77x5o9s6Di2myLkcEAXkobjE4MHqQC
         l4p56aIK+NUBEWltk2Jf9iXpAQeu7LcFq5tkje6O10s/WnwA+Yzfae0uiRWdNCgZ74dF
         +FWP8m+sBOmNT+f9t+UvunmHaVNR1UCFj8rxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718389787; x=1718994587;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0BOyQ8/qVXZmTJkzdimdIYFLmLhiPdZXAlcMcg0IfHY=;
        b=w8Y88NR5YPXldWva4TZX1CQYUNifMg1WJ689Z/KqdhAXGxHBwCYvMPsSujkRJvMf05
         SYv7XvLAMMqalq5OLGo8F654FPBnQNOlu+MsAKfU/562yPQ3JGICzbioThq9dYiypAKc
         EN7pqLIC1xuy+TdmuNjBBXIBFYqzyZx/mJGTdLBj5KdTpZfWrneib6zjKIBpA49mCVnt
         grN9HqSHuBDOfIpusLA4NnOU3NMgav2PrwoTWIroORTEGUS8QMY9o2SxjBgPg36aNtEK
         We3gm2xTv9s7sNMmnJvt7OPGErnI18tLOS5gWq/2oERKSya3tI7fYlMIlk7NFnBdtfO7
         jDPA==
X-Gm-Message-State: AOJu0YzgJFV1xLc+GJdsZinwKVxT5CDL2ueR/mltXNgXxU8TS/TIJPy7
	QV73vgtJh3Pzq3ceOSU4nIBJklJ7+F+cOzOmkpWU54ubupUtY3uoQbVsicjSbKfWYhLA6mVDqvP
	oaslFRA==
X-Google-Smtp-Source: AGHT+IGZUzx2tqnt+P/JxaeSk+n8ZpWgZIcBY9XIQVrkvxnUJw/DUTipfyaqt6JbKA41mhzexQBKBA==
X-Received: by 2002:a17:907:d504:b0:a6f:6960:5e16 with SMTP id a640c23a62f3a-a6f69605fb6mr158801766b.27.1718389786689;
        Fri, 14 Jun 2024 11:29:46 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ecdccdsm208856566b.127.2024.06.14.11.29.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 11:29:46 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6265d48ec3so360396266b.0
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 11:29:46 -0700 (PDT)
X-Received: by 2002:a17:906:c20c:b0:a6f:fbe:d3e8 with SMTP id
 a640c23a62f3a-a6f60dc1f15mr239506566b.54.1718389785705; Fri, 14 Jun 2024
 11:29:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
In-Reply-To: <ae3d160d-6886-47a3-9179-de6becf0af38@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jun 2024 11:29:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiMPR5nuVp416xpwFFBb_wcdg-eRDsGQpkDv91bQkMoTQ@mail.gmail.com>
Message-ID: <CAHk-=wiMPR5nuVp416xpwFFBb_wcdg-eRDsGQpkDv91bQkMoTQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.10-rc4
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Jun 2024 at 09:06, Jens Axboe <axboe@kernel.dk> wrote:
>
> - Ensure that the task state is correct before attempting to grab a
>   mutex

This code is horrid.

That code *also* does

                schedule();
                __set_current_state(TASK_RUNNING);

which makes no sense at all. If you just returned from schedule(), you
*will* be running.

The reason you need that

                        __set_current_state(TASK_RUNNING);

in the *other* place is the very fact that you didn't call schedule at
all after doing a

                prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);

So the bug was that the code had the __set_current_state() in exactly
the wrong place.

But the fix didn't remove the bogus one, so it all looks entirely like voodoo.

              Linus

