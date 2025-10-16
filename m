Return-Path: <io-uring+bounces-10030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8645ABE3372
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 14:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 744A44E40D4
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 12:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD3930648C;
	Thu, 16 Oct 2025 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JisimJC1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B002741AB
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 12:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760616199; cv=none; b=sg0Bb5XAFzowFL59hyYKIXzXluVZbQyAkvR56+ChMVrT+KoPQgYUDGgejWbONeXSqyCxvCYfqP3DgYjCpIlBplRCG2tQsRvhBANLgFn7U6MmEj1N+5804UJEDmXp9jok/deG1ya3V18jsST8lpA4dHH6lbZ2vlV6HUfNjgjv524=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760616199; c=relaxed/simple;
	bh=eDZamdAOxw3ripsohBhl5KUHUKZbPdaP4jSAboY9ooI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mM7nSh+rXIyNr6vvQP9F+JLromD6vr7E9uiKLVmlYhlJAFz+P0DLGVkL8lfB+fmfyM535/PTgsM+khPwOZrOHD7GuRiPModyDlObhl9sclDsXr8LPhqQ/tL2dM1LjpRrHGSbFTV6UOqSebdrWWtAm446zmUxJX4GP4D6MGeOkk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JisimJC1; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e542196c7so12032275e9.0
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 05:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760616196; x=1761220996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aZ4HJ8z1QXzdgsCOxMcBJSYTClmsw1M/fNm3K5bLu0Q=;
        b=JisimJC1RiXPnXSk1WwSryaam9NSIdw5w6yPsiw4Mt2s+a7X4POkKd7p6H4IMO99tE
         Xr7SGzuv7s7np9VU6eAfDgS8ERyKCmK5yftrAXkzXTPgW+h45ikDVqYbL2gYYqf7N+Ak
         qE89UJthDW0k6BkrsdyMEzjHsTlgfeyt3Lk3t99r1C0b3THu6/SOl2w985bDtek8slRg
         CZAEgIJCHKAbm+7cntyBfGVzdfvepvgoc7PwG8cp8PALSShtWStTZCcFc2yXPVXmfxNu
         SCXt0jbHGQ6BRPDN8pfrYi3MJOctHIrf0HlkuT2ZV7e2pb/GAX9MeogPgaQC/YcPzAYn
         667w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760616196; x=1761220996;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZ4HJ8z1QXzdgsCOxMcBJSYTClmsw1M/fNm3K5bLu0Q=;
        b=Hx2Yz1X+ValNHOM6+mqvVSjw10B+2yYQur5igbdHHDETLWJ2HaAOK/XfLM2fgI4l42
         PX8HnRqfCc0/+r405cbhLCh4OO4ivvTbDm9n6OQyAHw9qXD2K7AFS6EWUoCowLW/vmEc
         LYEIEvzH0lx33a+tsk25RDxPz/fX1kXJo+ADl7Wi6mtjXwGBiHSWLq5uKkiMq6IsWXk5
         XRLlGgADSWu7wimwxPinutuRzYOTS3hJ+QIUfN+YiTukg3ti9PUN4+HxdaJ8DSQT79DV
         QXlRPJIG1TEFpfXyBDaIqIQ/Hd0XAs6hkz0IVsKPh9uryT8vlV+ySBxAv6GGhf7Nk1ED
         z95A==
X-Forwarded-Encrypted: i=1; AJvYcCWQh57cJgUk/s5wrKGO6AAne9ohvWXhRwSbRY+T2CEN24N+j6O4FCgF2VqlNFr68X9MbiXrG4B6bQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzio318B289S23Jj3Ew75ujdplljNuFKqcQQt0B0/9gM+a/TXM4
	EewbMP0DdxdV5Gk7Y0plHXPdjia/CgE5pS4tI4a+Fq/bos4E1AH8pw8VhfThGQ==
X-Gm-Gg: ASbGncv8TtsK5Isz7EZLdZGv67G0+iBXQFPKpOprYALCgyormgcWFP/J/M8TBXTyWd3
	dQLNsNRTXFALcebD7wDfkzJuNqa7dU+zYN4qOrvy1w9fRlux7Hfj52FrXGupDicD39ZPHqctNH1
	vnx409VpI0sJSDV8Nke9+31oHppvTBEM6QRRvCiQedkz+c7/bFmZaAlhtNSIW+00Rtb9nOF+o2G
	jONutNCAkTAvkg5AdZ4wFkLj7Ety3GlNC/rliT6snQ+qRLxPnOt8WWGPls/rCjMuq7l48szyOR/
	gpvZ1hr8GJ5C+6UG7RakMsXGfRnztRY4xtq4+GHYToB9iSFnmLxPqPGV5pgWdTa3upTBddtDzhm
	W7YbH4+De6aDGHVqvyr5VjpJuOXzc2WpaQct9NqLtcXStNIuI9jBxxEt+x5Rza+qvA7J4jGOI4x
	eO0phdmcJ8k30no1xh2XG9sU3LD3ulwfO2goJpUdk8vZc=
X-Google-Smtp-Source: AGHT+IEUZW75AqVbYJQuyxDRFeC7pvhXdznQCPal+ZYKEsn72/yieJlBl+NHmYd2BltHbsIeCOt9Tw==
X-Received: by 2002:a05:600c:4fc9:b0:46e:711c:efe9 with SMTP id 5b1f17b1804b1-47109b274cbmr26345405e9.13.1760616195542;
        Thu, 16 Oct 2025 05:03:15 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm35086455e9.3.2025.10.16.05.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 05:03:14 -0700 (PDT)
Message-ID: <28a8fdc0-2693-4ff1-bcb3-2b8f67e7b794@gmail.com>
Date: Thu, 16 Oct 2025 13:04:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add IORING_SETUP_NO_SQTHREAD_STATS flag to
 disable sqthread stats collection
To: Fengnan Chang <changfengnan@bytedance.com>, axboe@kernel.dk,
 xiaobing.li@samsung.com, io-uring@vger.kernel.org
Cc: Diangang Li <lidiangang@bytedance.com>
References: <20251016114519.57780-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251016114519.57780-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 12:45, Fengnan Chang wrote:
> introduces a new flag IORING_SETUP_NO_SQTHREAD_STATS that allows
> user to disable the collection of statistics in the sqthread.
> When this flag is set, the getrusage() calls in the sqthread are
> skipped, which can provide a small performance improvement in high
> IOPS workloads.

It was added for dynamically adjusting SQPOLL timeouts, at least that
what the author said, but then there is only the fdinfo to access it,
which is slow and unreliable, and no follow up to expose it in a
better way. To be honest, I have serious doubts it has ever been used,
and I'd be tempted to completely remove it out of the kernel. Fdinfo
format wasn't really stable for io_uring and we can leave it printing
some made up values like 100% util.

If it's there for outside monitoring, that should be done with bpf,
with maybe additional tracepoints.

-- 
Pavel Begunkov


