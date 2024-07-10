Return-Path: <io-uring+bounces-2494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F52992D8F7
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 21:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08E9FB25DD4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C58198832;
	Wed, 10 Jul 2024 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BsfJjx+r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49203196D81;
	Wed, 10 Jul 2024 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720639221; cv=none; b=PEGbyiya6tGfsxRHnzIsF/LCKcmr2uxN4X+KQ+6SXljwb1I5S+5P8FZ/SfPmtHrOrcISWgjKiRVUJJqPUEMUpb7RkR5PUPzDiMIIrfGyqFDMxKNv3udtBk/18rm7xEttHWXm+CYq/qtMr14kDK+HFkjpBWlc1SBCNnoodTCFMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720639221; c=relaxed/simple;
	bh=MT+DMfwVnEwEm04D4v9//hGZ7/bWoIBi2kLO0cJfX4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9fd1Fdzpo7SraVd8FkGKHl4r6LrOwZtWFo9dmaF09pha8oCYv+HGJB3tbwglS335dvHhjP54BqgJjrV/aBKkoxNGxEmppa4g/osQQejYQntMYlrPL1Lg4Gh6/u0MDIRVQl2wmy5AYy7nGffdTtlbJ/zv9I8bBqsVF4ThZn66Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BsfJjx+r; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-25d6dd59170so67642fac.0;
        Wed, 10 Jul 2024 12:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720639219; x=1721244019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJW2PSws80liF34aPoNqh2+jwq3S+80kREZcSQdzjyc=;
        b=BsfJjx+rtrew4542SRvr7djymdZ+GkuKQeSb4LCVpQPVIxn4+7khFt2O3GncsVXOMf
         /zE+upyGzq4ZUXPjsP94QBBxjkkjeodj8NnCLcBvv9Kr7cW7tIFgaRJlb3Xci7kj/ehy
         /TCL04nb39WN2P64lNX3djz+SSW3QkYT3sXTNjCIvhkHazWG6i5h1pyBlVV5dRtXcvDf
         WyPQaMnSlKKqBiVZXN9gjlJTRvFvh9DFAgWqNwzbN2+00FjdDi4OeY/q+cn0iGWN+kDi
         wk758qY6XjKc1hfGkHzxzoYA1MnXJ8R0oJc95Pt019toy0/cN5P9CSRx6x/0ceMkLc/f
         E1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720639219; x=1721244019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJW2PSws80liF34aPoNqh2+jwq3S+80kREZcSQdzjyc=;
        b=rSiEZfSCgKDS7Z9nGftzEJgCHkbDJ/5d0VgrXRsM0tnvy0mS8olEUAwUAl8epN9CBr
         JBrd1AIJFDuybY2jhOaP94CotCcdjSlxCb4VZro4fug7buN9+FPBuCBuf6D00G+w6XZf
         vRfNBB7wx2e7s+Z9zUk6BOX5P4z05N3cniXf30R1vwf2Gu9owW/OZZCik0eZscnJX9ub
         BfxyDRSQjFSh6fSpqkuMoRve+i5YQq9HuN/oDwNM0yH1nz49Q+qqDNoR1U3HAzBSTCUL
         OnJms5Eb2EMlFAqhuqW1kCIFL6QPs5zcz0SyKHnxH/4LsJ2fK3Qwzy9bvHJ9UyRpS6tV
         hAJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVI36XGRgBDo0F7WsQOwvfrmB7P7NZjQbfMKpMP4+Bn0yAwZY0bAW2p4+L1wAtEQKuf89UEbHDBdJ4H6kpT8XCJX965wgNf/LHur51+83hiwNxSdp3e1+kEuc5+9XSIZTIGshMC7l8=
X-Gm-Message-State: AOJu0YysZmFreWEXasIeMcN8vRpfg2uys4renUM2U+dbX4pvksDWrvJM
	KOoNNQH5HKQ8pwvSsEKeZQ5Cz5iwvt0g1qqF22/4coUBYDT8pBPA5ulXWQ==
X-Google-Smtp-Source: AGHT+IEQgPcyLOIKxvAwdLsV8UZZnZSas0gYSQw3piiYDb6IR8/OwZFwqgmmGZQyHYy3+5vBHSc7Sg==
X-Received: by 2002:a05:6871:3a2a:b0:25c:c73a:dce3 with SMTP id 586e51a60fabf-25eaec6e04amr5099835fac.54.1720639219142;
        Wed, 10 Jul 2024 12:20:19 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b439ec692sm4154811b3a.213.2024.07.10.12.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 12:20:18 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 Jul 2024 09:20:17 -1000
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <Zo7e8RQQfG7U5fuT@slm.duckdns.org>
References: <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
 <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
 <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
 <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
 <20240710191015.GC9228@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710191015.GC9228@redhat.com>

Hello,

On Wed, Jul 10, 2024 at 09:10:16PM +0200, Oleg Nesterov wrote:
...
> If nothing else. CRIU needs to attach and make this task TASK_TRACED, right?

Yeah, AFAIK, that's the only way to implement check-pointing for now.

> And once the target task is traced, it won't react to task_work_add(TWA_SIGNAL).

I don't know how task_work is being used but the requirement would be that
if a cgroup is frozen, task_works shouldn't be making state changes which
can't safely be replayed (e.g. by restarting the frozen syscalls). If
anything task_works do can just be reproduced by restarting the currently
in-flight and frozen syscalls, it should be okay to leave them running.
Otherwise, it'd be better to freeze them together. As this thing is kinda
difficult to reason about, it'd probably be easier to just freeze them
together if we can.

Thanks.

-- 
tejun

