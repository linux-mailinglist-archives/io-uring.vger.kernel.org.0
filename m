Return-Path: <io-uring+bounces-4809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F549D1DF1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 03:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA60282720
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BDC28E3F;
	Tue, 19 Nov 2024 02:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pBH3ldPj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497C1E56A
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 02:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731981917; cv=none; b=taLg6zn2M3lKk9ZVnY9aC0NmJFSukWJCWTd8IDxIVtXARCOtJoJTGzmAsMeWfueybIVO4FHWhGTtZXVZQBLBIgxEUa7oZ/48rUSLa+3VB5GHvf20jbP1hug08FlYqnMmlTa5EWOZ5EkVwm+eTHFFBkpItHdC0QG7Khn4QjXvey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731981917; c=relaxed/simple;
	bh=LmgD4EDr0FTLqqK9XaD5BT5Z6Q4O09mMiDxVmhM11B0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OGc2/F+dTR7bslalAPyoyklqM/0/XXdAJ6nYIqi7mZphAAkYgJB1ISGbdXQHB6FozEEZxVr9BC3N/HLOwuqcbvAItvPUTV9gFpzP3uIgLj44TvdUlf1JQOo+PyhC7cxtOraxMol28bRHh0IdjucliAP+ChlcE5NuxzZj7IVJFT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pBH3ldPj; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21207f0d949so22481685ad.2
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 18:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731981914; x=1732586714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WcWYkuw/dHleRAQ13JfTYO9vRdxnJUNHSEXK98JCGFw=;
        b=pBH3ldPjBuULkuUq3nb+2AEj2tBFJuZ5rPUH4+/DGqYucwDeU6UFh5sfM3FC8wdX9E
         b+EzXL6b1LQhxqSNA8NS+rvExkzPHc9hFuia1iAyqIgFXVagMj1SxnhNfYIN9tt82AA/
         Li33Vf+BQJ0/NEKtJJTXu0LmXMKzF3U/SsZ6vgNEWpMqWUXCXTXj4v9U6sqLuIiO6Zsd
         eBCa2Zy6xVNjRxIJd5AFBXY/TyEQ+aXgmemjNNvDuU76Flj7DOTkye0CbAuQZ6S8O24R
         wpTda4jiaUQMSanQHRgEKmGCCax5IsVGpl9BLkGjbUkQ53DfLFEN+yDpcf13g/UbY4W8
         djtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731981914; x=1732586714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcWYkuw/dHleRAQ13JfTYO9vRdxnJUNHSEXK98JCGFw=;
        b=ZBIpWoRs47t9lcS+EPA7xZ1RJfI4/chFg95dyp9zApZakkiN1YF0UGoC8V1f/QWB4o
         gtB0ILNutkOH0AVd2vdxX4diQXk8QF+ngrFyaBRmB4PlJwmWYXlDFokCPoQ9GPpKTB7U
         UVM7FITAFh/3rbsF5MIY5s/ARCTP1u3NguP3CN1s4kFqAz0m23Yhvp6HHgHTf1QKBv4F
         Yktub7tiLOYiE+8W7qllcQjtoLRDXdq1r1jctPh+i7rQzOauIvTdsQkxpOnxsa5FPEov
         +Qy1j+Oo/N/2hmmdqgFArYsNsicJrwrpiZ5CwXOG07dFLTCik/x0L4+JyyIUjDElOhH6
         XS+w==
X-Gm-Message-State: AOJu0YymrCVZWC3n525f1gpHKhZ8uEw5LBxUaq332UgoGTixj0zyJ/vR
	0cb22Rmxp5xTi5xCaGeFpOUgV9ArnzfjXTxa20KqWsk1+hbNaeSF0gBRgCp3V41F408CfyyHEA6
	HdM8=
X-Google-Smtp-Source: AGHT+IFVGyVkGdBEOMW7k4qEsJarDKR91xDsplLor2zMQTKi7wMPIDX2xIjtrWEmT0TGZ2ZYb3iFPA==
X-Received: by 2002:a17:903:32c8:b0:20c:9062:fb88 with SMTP id d9443c01a7336-211d0d6f59bmr222965765ad.1.1731981914307;
        Mon, 18 Nov 2024 18:05:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0ec7f36sm64097215ad.85.2024.11.18.18.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 18:05:13 -0800 (PST)
Message-ID: <96b28c66-53c5-4c98-97e4-b2236fae69b5@kernel.dk>
Date: Mon, 18 Nov 2024 19:05:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] Clean up alloc_cache allocations
To: Gabriel Krisman Bertazi <krisman@suse.de>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org
References: <20241119012224.1698238-1-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241119012224.1698238-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 6:22 PM, Gabriel Krisman Bertazi wrote:
> Jens, Pavel,
> 
> The allocation paths that use alloc_cache duplicate the same code
> pattern, sometimes in a quite convoluted way.  This series cleans up
> that code by folding the allocation into the cache code itself, making
> it just an allocator function, and keeping the cache policy invisible to
> callers.  A bigger justification for doing this, beyond code simplicity,
> is that it makes it trivial to test the impact of disabling the cache
> and using slab directly, which I've used for slab improvement
> experiments.  I think this is one step forward in the direction
> eventually lifting the alloc_cache into a proper magazine layer in slab
> out of io_uring.

Nice!

Patchset looks good, from a quick look, even from just a cleanup
perspective. We're obviously inside the merge window right now, so it's
a 6.14 target at this point. I'll take some timer to review it a bit
closer later this week.

> It survived liburing testsuite, and when microbenchmarking the
> read-write path with mmtests and fio, I didn't observe any significant
> performance variation (there was actually a 2% gain, but that was
> within the variance of the test runs, making it not signficant and
> surely test noise).
> 
> I'm specifically interested, and happy to do so, if there are specific
> benchmarks you'd like me to run it against.

In general, running the liburing test suite with various types of files
and devices and with KASAN and LOCKDEP turned on is a good test of not
having messed something up, in a big way at least. But maybe you already
ran that too?

-- 
Jens Axboe

