Return-Path: <io-uring+bounces-5613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B13F9FD616
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 17:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51F527A1385
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 16:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4137677F10;
	Fri, 27 Dec 2024 16:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fIshYV5H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B707B1F754F
	for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735318143; cv=none; b=VoZ12h/TsgJFDvqvdbW3Ktthmjjg00D5V4UPWbnimmva06l9UU77T9DIx9wY0JJD81uYWswtxzdkivR5eAzineRsKj0FbciQRTC4tm1MyWmNT5aaD9cZoHmvzTM/X+71zVbzlXixs6YT3cF8zSN9lm2WIeYoqDdlLh+qgtAkuWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735318143; c=relaxed/simple;
	bh=cUbRlrmJaDowA3+0e/GzX0odLxp4ii45ascWC52bCfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ibLrW4lHY1U78fQdAdifL/fd0yuoppaYEcwnKanZXvJBjsVdep5hbJQzaEsKg1Qwf/HQC5DJTids3QhuSt5FD4pPj5kZQ3zlmuyJiwJpjwnt6u3xEYigcFpifmwSWcVaYscIri2FUewLNbLBgjPWsg+6mQ9Y2kZ9vdrxoaCop98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fIshYV5H; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21675fd60feso118677965ad.2
        for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 08:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735318140; x=1735922940; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hOFVHWIUljpjD18W0hdwXZLMLgClsEXUtHSnNyv4bZM=;
        b=fIshYV5H5Hfo/FKeaG2doZnJUbb+Ugfo1LvasU0lnomJJsdsQAcnXxZRZi8+padBwX
         OweafVRkRInhpQEt9ka1+OQ63PmBl5WXklVydx5UDDfg8K5Ol5YoyG39v0TTKnZ89Y+z
         iXltqr6qwCSAvaBEP4oyPjeItdAyhY16lA5UAumXa50GABL6NFVFEKqP6hSAhaBEEQSL
         IqrtU/6KCyzVytcgadBWjEoo7dkAy1js/i9z+qQKPjV6rZurk4zlD48P2Ti1Edtwy1Qn
         d35Cosj7e2HoW0cPW69DO4J8deDHuqEzhYfU4nrKIIy4/RYU7uanwSbVcl4JKn63qkr7
         YEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735318140; x=1735922940;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOFVHWIUljpjD18W0hdwXZLMLgClsEXUtHSnNyv4bZM=;
        b=ZmGgjdQlMTqw4hT02TMC4ScBrrh7i2j/Oe3VTuF2BvnCz+uIuYYuBrLkPDNwEavc+c
         rWPpkMSsB3xSoY0wf5RbjPgoBzED11HHehGCNhnja+Sh7RlkBx6+XYpa3Eioasor4v9s
         zQBHC6zRYZzfjcFFH/zX9l3N7qyBzI+jMxuX5L5NuLcm8qfcQhxs+ebIFcsmXKfdCIMI
         YkF3UDCymU7w+FxDJP6MpCd227+WJSJsQHLZVHv2ddBJBr0iBmYTEwB4kWZiwPT4bcUZ
         eEhvQjOhfWZ7RCw3ahCIzyAs7YNZs388aNTjzntJHMjFvuNEtQR3IUufPfof+HhOZ5cf
         s0Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVqzvonElLGUL6TxOA7GdFOcmOygNSURjF1M4VSqkDC7TXv2jfwcGCr9ctSXiFWWstJMFL7f77Lxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZn3yv/lhatPQdrE2/3EsdwzudPG4ltOxLueLe/N0WXd503RAw
	0z1NH8LbHdF8slRHsXaNblmNygEf2fmeDmQ0e3dHza1GKuDObITJUmGpYMf8XDQ3aoxXkA72YDA
	N
X-Gm-Gg: ASbGncs00Ol+Hv8gYSneHIePwdzHt0ah5SQJucaHbXSPqx72/GoPdI6dpJGe6jB5Slz
	JLHTlWGkIE0LZFuxv2hScGIDQ8Mhxda4/Gc2HqYXnYCGJhw+TfA33KviCDnN1Z7Ux65Y4PJdgyU
	GT8uV4hAoGoH84lNlVSD6ANUWpqLy2lTFEMPXMy4nUobBIPho/X0C5fUXxLWs9TfXI89ohAMkQu
	vTHRyBCnGPOpnOYWGufTe82Pigfhv+WGGusgn2YN+fAWAfQA8T+kg==
X-Google-Smtp-Source: AGHT+IEmxFknk/Ao6JdtIasdWMlVJa37hoobmtWDdnGc3OsknWkChk/bTC9H4tGWspLzxIAmwxuQxg==
X-Received: by 2002:a05:6a21:3997:b0:1e0:c9a9:a950 with SMTP id adf61e73a8af0-1e5e081cb96mr44076885637.39.1735318140116;
        Fri, 27 Dec 2024 08:49:00 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8fb0d1sm14733525b3a.137.2024.12.27.08.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2024 08:48:59 -0800 (PST)
Message-ID: <98fc1d1e-2b39-4628-a209-a76407130f6c@kernel.dk>
Date: Fri, 27 Dec 2024 09:48:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [io_uring/rw] 8cf0c45999: fio.read_bw_MBps
 51.1% regression
To: kernel test robot <oliver.sang@intel.com>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, io-uring@vger.kernel.org
References: <202412271132.a09c3500-lkp@intel.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <202412271132.a09c3500-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/26/24 8:13 PM, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 51.1% regression of fio.read_bw_MBps on:
> 
> 
> commit: 8cf0c459993ee2911f4f01fba21b1987b102c887 ("io_uring/rw: Allocate async data through helper")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 8155b4ef3466f0e289e8fcc9e6e62f3f4dceeac2]

Took a quick look, and I think that patch forgets to clear ->bytes_done
when we don't have a free_iovec. That looks like a mistake, it should
always get cleared, it has no dependence on ->free_iovec.

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 75f70935ccf4..ca1b19d3d142 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -228,8 +228,8 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 		kasan_mempool_unpoison_object(rw->free_iovec,
 					      rw->free_iov_nr * sizeof(struct iovec));
 		req->flags |= REQ_F_NEED_CLEANUP;
-		rw->bytes_done = 0;
 	}
+	rw->bytes_done = 0;
 	return 0;
 }
 

-- 
Jens Axboe

