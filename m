Return-Path: <io-uring+bounces-11000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5390CCB2859
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 10:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2EA9530050AC
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 09:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275F2E573;
	Wed, 10 Dec 2025 09:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lJ1JrMDZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BB921D3CC
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 09:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765358360; cv=none; b=hqSdPeJUpORbVXMaJkOytFRu8CPw59DRH5SnEv6qIP5Bi5gv0CeqO19NFSAbJxajRS/NA0SPW5doM1bGf7pP7RR/Rux+Zl3qtH6yFZBIRd/jQurRHPmqikGeu5lsdpjTW8ryXNyFJzj9bUcXQxGyvEA+s+zO6ibL3n7C/cNGj9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765358360; c=relaxed/simple;
	bh=GpwHb+O7rgYfFuNpbx1gKS2FppVHYMwpEXvosYBUhQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZJBzGA+YLw/PxwgQ4+wxWu36YrYMgtmoGPDA4ACn/eBOAsc1ZbFdkq1zQTQPt2ePittxvWD61hQ//g9z/RvRB5ODf9HRfk39r8b6E7dw99tgBwuxpAloUe3qCkJ+4AQ3NQk1MZVfgpDX1tLj5a4rJis4wU0mQhgEGzkXJM7L/YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lJ1JrMDZ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bdb6f9561f9so6230953a12.3
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 01:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765358356; x=1765963156; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/hF8VWePrSemvntp8SrA2/CjZQVIj5VcYnub550tIE8=;
        b=lJ1JrMDZZoDfczs1PR8J1n0mSgBIXzmZ+fPQoHlB4FVQ9QMdwWEQIJEamCamdjnFXC
         OGUnLfY2vEieWgdzA7oBAnBPevs56xd1Qmph/02ra6I1GGBZnHt1zr88Ya9pHGdWKrcm
         ag7IQhgnS1mqHTI+JAm99hJvJmyJQPpGmJX1yqXyW5nD+F69GT+UUbdKFc1YJraCAs//
         DMDCur3PDS+kxwSbkonciN2q7mL7Y42IQGRGmw4sfnHWDIDpDk2EyxnBLd7QYOLuQHr2
         OuIYv57Z2L0rzbwNUrX/iEuidu4Tp7mACJdSFNHOpq0rOK5aXItprLQPQhi1naSah47C
         UK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765358356; x=1765963156;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/hF8VWePrSemvntp8SrA2/CjZQVIj5VcYnub550tIE8=;
        b=fWER0hsZd/6GirXR9u4/p/CcO7j6sv4+gZrbQgz5ucDyWUG9zC2t12NRp53my5PKzV
         cgnfBCCtFGmTAMKRoWZs1bscyQ0StyqqHDvKooMvVkl1pZ3RPgH+WBbSkBxfwzIfVKhu
         Ny5+QSfj1Ww4VC4sSvXV94kXRrE2c+0y3vGZk0EwJDcLN3uy1OLq1l+iwEd9fEOWLGQQ
         JVzRzgyGWDXr9eOQ0clMIrE5GEwzTtYxLNvej1CzJa7QOi8HRJyoXTeeccqd/M9pRLno
         lj5QFsRIVHGil7tbcK3YGzfmsP2FSxcJm+nfayzKJi6zLXVPBWKjjZkimOcJjzuhFpwM
         2wyw==
X-Forwarded-Encrypted: i=1; AJvYcCW/LSZTEOUqHrgiZSa9XLMt0SPqoHHw4cleIEt83n4hmU1hTS+GGPYiFHTQB1pVqR3ZpwIgtm9NGg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5Fg0gAeNJHmrdIq8JpjxQJfoC2ibOHUWxMf9rFLvjljft1iRs
	+naRAz5F9cztyKCf8zgj+JHqiihqYptf+4bvYch8BIRtgq/tLxINQBhXWLCYnVLl25k=
X-Gm-Gg: AY/fxX6+Df3DtvlcKqDY2LkNdD3oA46bagbGZNN8/ksXGIu9EYRLK8WE5b12eMwTO0D
	ixPjxws753DbWz2lSm3S9hOls7PsjtiDmjlw8LIqIDzYXm5+ZRza5t7evHeSx5A0+k/pJXjE2HE
	O2mksYfYN7evUGuppxTH2nG26wJdBusuaHO3k1+2u6gWQMldNEjA106eyKHIufcJ9hYD5sbv9NJ
	lEOa4XCFWNfYf/grucTVrrygOBY4ugobO3ssLLhZH8cP5oXwM7bX3kne91oFTVe8NZVnswT+cI9
	f+RlnGiSl7z1R5B/LO12WG/6SMveuYRFwim/k9trBfc3jZpiKr5zK7Xr548O261WTKiq/I3xFmt
	gCBQrgmuf3uIqKbGgw6GGFTplahFvj9JOvLrTG6URG3yHuGZYQ/NgJ4d/oH1T59D5wWcK4hC5ul
	XtzUqhJYGbmwoDJtfYi9fVcY8GWftPWKbF8l34vnv6M2KHneD2bQ==
X-Google-Smtp-Source: AGHT+IE2urvd+MJtlCsMUFyQ+NNnFsyTKRA7ERLKFjNYo3upbCHDC2h/CaFjMz2WRi0YIPfKGxuwug==
X-Received: by 2002:a05:7301:9f0c:b0:2a4:3593:9692 with SMTP id 5a478bee46e88-2ac05451663mr1553067eec.15.1765358355872;
        Wed, 10 Dec 2025 01:19:15 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7552defsm78869697c88.2.2025.12.10.01.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 01:19:15 -0800 (PST)
Message-ID: <f363a7f5-1355-4dde-85b5-a51024b2ad5b@kernel.dk>
Date: Wed, 10 Dec 2025 02:19:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] blk-mq: delete task running check in
 blk_hctx_poll
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-2-changfengnan@bytedance.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251210085501.84261-2-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/25 1:55 AM, Fengnan Chang wrote:
> In blk_hctx_poll, it always check task is running or not, and return 1
> if task is running, it's not reasonable for current caller, especially
> io_uring, which is always running and cause BLK_POLL_ONESHOT is set.
> 
> It looks like there has been this judgment for historical reasons, and
> in very early versions of this function the user would set the process
> state to TASK_UNINTERRUPTIBLE.
> 
> Signed-off-by: Diangang Li <lidiangang@bytedance.com>
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>  block/blk-mq.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0b8b72194003..b0eb90c50afb 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -5172,8 +5172,6 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
>  
>  		if (signal_pending_state(state, current))
>  			__set_current_state(TASK_RUNNING);
> -		if (task_is_running(current))
> -			return 1;
>  
>  		if (ret < 0 || (flags & BLK_POLL_ONESHOT))
>  			break;

Heh yes, this is completely a leftover part from when polled IO was
purely synchronous and the completion would wake it. Similarly, the
__set_current_state(TASK_RUNNING) a bit further down needs to die as
well.

I'll check your patch 2 tomorrow. Not loving the complete switch from
the singly linked list to the double linked, that's going to slow down
both addition and iteration of the req freelist. So I think something
needs to change there, but haven't really gone deep with it yet.

-- 
Jens Axboe

