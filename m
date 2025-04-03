Return-Path: <io-uring+bounces-7381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A66A7B058
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 23:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EAB03BE0E5
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 21:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD011A2C11;
	Thu,  3 Apr 2025 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EP3SeADq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0941F872F
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 20:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743712007; cv=none; b=JKED80cSEwNrsmAKHxFdt2uf68ShnCCYoeX5dv6N5vif34CU9GCCntbz8xiAwGnBUd19q7WJk3rf9I3BAYDq39uyT/H0Kk602Pxa53gT1QP2X6ywR38jJ8YV3r/u08NGLDTGxZwO1R2e0KtFouNMF/Thn5jpla0ULuUBNVpf1jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743712007; c=relaxed/simple;
	bh=dUs3ikQdh9urwqoQfdHe4pEYmUGd5G3N6MeYGz4SS0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hi//l6j5hCQQhlHvG1TbA8FBCd+/jnlNtAp75g/p+zz4ErtSOjUIbBlQ7w/of6b7UBy4r10NDqkq2YwjyWJgMJbgKw7ML75idVBqLSxI4kUKwEpiXuxTxz/rAUktkRnJQqdEBmsEzHxXfaYWimeJ7hLoBKk+/OJmKrE4xNy7RO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EP3SeADq; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso10497775ab.0
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 13:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743712002; x=1744316802; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9yX5oMLVRLKCtHtM+a4BLeMyVq9i0SQTDEEgNqzkE24=;
        b=EP3SeADqbuz+aw5utz5ILZzo6bTywC/v3r/356O/fufuke785C2EwC80Vz+wssPIV+
         I1MVD4sd5TGRheNwCPA5qsMnDa3I8oCpChxV5Q1m6xNw4baeagYzMMBCIXJc/KsHdb3j
         nTp+BWF1T1fwI/FqRNogY+25Ofo61t32rR9bFm+xKF+IQ5+6hcaDJ0QB5xKgYl+7CXem
         6dPFwPLj87thYWLipD4RItNHLxCaW13yWgFywXyRs5+nTWq6lN1p6ErGH+mVMf9ejUjA
         MkGadT+iroH+MytRTq24vpu88Ny/UVgvafJtWqZfg6iZaUznrnPwkU+AcSUJaz7bIkXL
         xIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743712002; x=1744316802;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9yX5oMLVRLKCtHtM+a4BLeMyVq9i0SQTDEEgNqzkE24=;
        b=PzocEBP9zbUU+3VW4YfxWO0Xh03jsH8V/0zcRIruOEUwX4zwjeY5feBpU7Zxk4g98F
         iTHFuL3MqJfJ9B2SY4EY0cMvWHHrxAVmktmDbIt2yE1DEQ3w/O2/92as12X/3VkgurxK
         NJJRNgMb4J/zc7vVSrpH1R71ZjrP3D6HQk2rLJVnfxcJcLuzcR8wU40/5lmoNHGeQXSI
         psUyZA9neiY8S9LdszPZQ+w/n5gXK1MpR5PVI+qUr2UqaF8/Rn8CyLj03bVKOyqQkIxS
         lJU2iTGN7vQYo4zNbV/pjWZgvBPZEoFL8fka4dSAJRbj98sNyupIJMecVZ8YmUOHahmS
         R3Ug==
X-Gm-Message-State: AOJu0Yy/l7IYYgXhp6w5V1gAz6ZkpHHCFNdjpAElGnWdh9g62j2++txI
	0RK3lMMZty+BB4d9VRfsSPeBY8eodZLrD40LuoJdf0gxvLcMYfxMDlQMxdaiw4A1ji5hTlIGFtq
	P
X-Gm-Gg: ASbGncsluJP7t2yY67X6JcQPNyk81so0jO8U6e1+RXfra8+7X7WfgHK5IiqptjWqBtQ
	g7KQBefeIS7/KHX15UJQb0dx6v8ir8vtvi1aaQvt+dd5RxFhkbO56EnyFmjEf1MS5h5H+l7Okpb
	PHaYIQKQHCud1LfXSCvbPxxS3du85ae9kGkJoEeIhF1rR0WluQtQ8WTPLwkoTATO5LxRoyYA5Y/
	ZQ4kQ2UAP+cjKbB/EixlNx8sjJvMlCnWuehfPzrhX6bcD+vJ+oQujrzxD1adqwWZapWtKAaustW
	eCyIUfOVc1yjq/aq9RAx2jG5PSeWIvuOHbeL2wa/
X-Google-Smtp-Source: AGHT+IEBeuIOh1oqFqGYP0SFhZ1rgiR6eJW6xc8I/NaV9hYSutXgBsQuxXeUltzrgQOZ9D45Nqv64A==
X-Received: by 2002:a05:6e02:3108:b0:3d6:cbc5:a102 with SMTP id e9e14a558f8ab-3d6e3f1b250mr12069775ab.13.1743712001857;
        Thu, 03 Apr 2025 13:26:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c49cacsm461012173.40.2025.04.03.13.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 13:26:40 -0700 (PDT)
Message-ID: <94da2142-d7c1-46bb-bc35-05d0d1c28182@kernel.dk>
Date: Thu, 3 Apr 2025 14:26:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/sqpoll: Increase task_work submission batch size
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20250403195605.1221203-1-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250403195605.1221203-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/25 1:56 PM, Gabriel Krisman Bertazi wrote:
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index d037cc68e9d3..e58e4d2b3bde 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -20,7 +20,7 @@
>  #include "sqpoll.h"
>  
>  #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
> -#define IORING_TW_CAP_ENTRIES_VALUE	8
> +#define IORING_TW_CAP_ENTRIES_VALUE	1024

That's a huge bump! This should not be a submission side thing, it's
purely running the task work. For this test case, I'm assuming you don't
see any io-wq activity, and hence everything is done purely inline from
the SQPOLL thread? This confuses me a bit, as this should not be driving
the queue depth at all, as submissions would be done by
__io_sq_thread(). And that part only caps when there is more than a
single ctx in there, which your case would not have. IOW, it should
submit everything that's there and hence this change should not change
the submission/queueing side of things. It only really deals with
running the task_work that will post the completion.

Maybe we should just not submit more until we've depleted the tw list?

In any case, we can _probably_ make this 32 or something without
worrying too much about it, though I would like to fully understand why
it's slower. Maybe it's the getrusage() that we do for every loop? You
could try and disable that just to see if it makes a difference?

-- 
Jens Axboe

