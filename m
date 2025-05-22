Return-Path: <io-uring+bounces-8087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80608AC10B1
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 18:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C1ED16B74C
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 16:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65577299942;
	Thu, 22 May 2025 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wl7VUFNh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9803A80B
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747929965; cv=none; b=qwrenqlRqz6K/bKxlyEhavXebEa+aSeQ5jtHp5i/QN157bgBCdy1cCvGNMOab7MoEF9+UD+FZbwmEIvenQP/m+bqABvJ1kOUOoIAhpPX6FTlePEMP5zOS4p/s17oXzefKy13hO8eSVtDoVPTh1IJMWpLIxS19NP2bJY4FYS6YS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747929965; c=relaxed/simple;
	bh=mjZRQNAAXvKXZ0Y9oGTe0tkLz7aKgyt5oxY3ykDF35I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=sHy+rIlj+RFDNuEK3kDzAZHSAYpj/S9wT3G98DnJG9Qy6nAnDnOWcnus4Cmvwc6rDdECh4ZMcfftI2H1lQwBcwSPE1A+v+1SEYZJULBib9GdiEKQhYwEqH4FVGmZm+pP4QZyC4gKe8AQjmm0nfLpPtnm1S8Cendv9StysjzM/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wl7VUFNh; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so37472715ab.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 09:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747929961; x=1748534761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0U9FxUnjw0vXFh3LhyHdxIJuCH5551jQ4gVapY3/Kzg=;
        b=wl7VUFNhQ/0hiAKxjyLXPEl98QXlo+AqjniUIf3O14PWGbBOOeSXHQVaZMJT/FvgWV
         dghutf2ilDGy6UU7Y8UobRdvv7jiVWyh4PkydcKpBUYr+3XRZOEXcwvxPC8pzurVxlQv
         z7jtYu0YwfsmMdUkyvyd/DhgH82EmgUvT17ylngJx2xYGQgRhQfRWEB2eqi1Hn04UwGD
         JmVvYR4U4Jqw/f0L6rfgG+ktTwUpZmibMHad3I6JByx7ZU0rdEwZcBz5yayZqrI6svdF
         xWeUrkid3B3fqNlP8XaSVh8BxttGZ+7UZbhtaRszcSwPyQ9YQUjRpkV0iUQZcFtORpRL
         +cnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747929961; x=1748534761;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0U9FxUnjw0vXFh3LhyHdxIJuCH5551jQ4gVapY3/Kzg=;
        b=LBYtqy8aGL/HSar07LESwbtYcf38b9DXp0mUx0HDS72+kQlbxfkyGWbX65AvmhNEiS
         PaqS6m5rvz+VQ4ozDAE5lp8tFA5NzkWDthF8EJCgGblmT05KIP6LRSJmIACwbRbuOVmi
         1Oth2mQI8smr9/gumTGt1TqbI7Pml5WUGx4cIt72gdPFC1VBk8oh8UVEe1nXga1Vtuv7
         Som4s2w9KELXI47Ozi6xNw9UQGEmO+PFf3CuZYSy8IVZp92pOaGOv2hbnfPd4GsTl4W6
         LD5mK7P6Jspy3DlbQMBemNPivxYew8SDOEWu+JTvBL5jtWRcfRmkDdpaWCgoxuEghKQP
         GV0A==
X-Forwarded-Encrypted: i=1; AJvYcCUWtq4P3XNdeHY353iwxwSbiCfzQlyww5qw7+mTmn6dHTwCcuOzjhniYfEC6PpwNMP6lry4cRP75g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIrIHw+8A06W1l1GWmtD6Qh2yjN0MlbdEkO495raox9Lfcy8A0
	f3RgHf9wY1zzIyDb98fFAbyiLqS9Idqll4arlXoT1sVNnb7S+W2DtGLeDeC856667Xc=
X-Gm-Gg: ASbGnctvC/5PpjmmF+65Bo5Ff+SKt2YCFKxgDvKWL5yQZwWWiURqapvZt2RxIOMOa/n
	i50srOV8XaMCVbgPxOY2J+ox9DI11fxqYm5LMVL17YoeeLp1sF32M6uP4ap+m0TIy7WQYxtIHQh
	bSF0nn2sErbTYy21uSX93t4KVmA31llN58SiyRTIJNOVqgjVIktVSCnFZ5EjrgDXrSQBqjLnBCL
	q65l8z9yzH3uOxDCkfhqPMr3GCgAZ5QZHWse//I0ybrdt+y9/p7i5hmhAU10fMWE16gMX9cPgDm
	FTbaNPvlvBGTlvR/f+KVDrzDFmOrBr8VldAeWr3JrHfRACLu7aVx
X-Google-Smtp-Source: AGHT+IGZBRIcPqU2CSrk4akaRcyXCmpVVqUmQa6UPPZWUdn3FlgYspHriP2sBxUxFJ7afLrkhp6PDQ==
X-Received: by 2002:a05:6e02:214b:b0:3dc:8746:962b with SMTP id e9e14a558f8ab-3dc8746970fmr65156055ab.15.1747929961516;
        Thu, 22 May 2025 09:06:01 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c7b2sm3243083173.89.2025.05.22.09.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 09:06:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
 Ming Lei <ming.lei@redhat.com>
Cc: Uday Shankar <ushankar@purestorage.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
In-Reply-To: <20250522152043.399824-1-ming.lei@redhat.com>
References: <20250522152043.399824-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2 0/2] ublk: run auto buf unregister on same
 io_ring_ctx with register
Message-Id: <174792996064.1177358.11375945979582071142.b4-ty@kernel.dk>
Date: Thu, 22 May 2025 10:06:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 22 May 2025 23:20:38 +0800, Ming Lei wrote:
> The 1st patch adds helper io_uring_cmd_ctx_handle().
> 
> The 2nd one use the added helper to run auto-buf-unreg on the same
> io_uring_ctx with the register one.
> 
> Thanks,
> Ming
> 
> [...]

Applied, thanks!

[1/2] io_uring: add helper io_uring_cmd_ctx_handle()
      commit: 3a91f28fab43f093c72312148288d125ae160c2d
[2/2] ublk: run auto buf unregisgering in same io_ring_ctx with registering
      commit: 914e0dc5082a335ea5e7d905e99e1a1cde001369

Best regards,
-- 
Jens Axboe




