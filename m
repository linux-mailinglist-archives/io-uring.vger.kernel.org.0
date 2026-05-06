Return-Path: <io-uring+bounces-13244-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6F3vKesF+2mbVQMAu9opvQ
	(envelope-from <io-uring+bounces-13244-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 11:12:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BDD4D864B
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 11:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2B6F83001183
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 09:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156523B8BBF;
	Wed,  6 May 2026 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZ8+FH0L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A03DC4B1
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778058356; cv=none; b=ouUWABcq07j0Hhtk9KGjutS2hJiBtIccin/aq/6rLI1xjGeM5La+COEG2WorHoKYyw2TcBb9RHa7+UDNY+RETEcNjfq3YZsjkdroGc4oEQvVirbWEsRp0v6O5HDYe0Pxr/r5kfIzrHny00PRcxxaNE8pieka/nfLkzuvD6VqQ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778058356; c=relaxed/simple;
	bh=wlzQ3zLH5IstKehZiZ0CWYTOn6BTkx0ALRr0iBYkz40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6rqKEFwM6oWX+KTWKrJvwO4goov8Z8SHsYtUlN5Dblnc04/IF8Ecsd7LIW1TxAIW+RV2nrDbN1/i4Q4y/5D035zWUq3/+lJcyYtY+GIVWi74zbR+4vVIIm4ttcN4ATVRmtHH4O5JZzjED1S3yI8HhmGg/1Fgno3wHy6CrBhOkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZ8+FH0L; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48d102471a4so28853865e9.2
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 02:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778058353; x=1778663153; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ZB9RilwFR5SteBplF/teYxItIDeEzXLv+5HmDUxIXc=;
        b=NZ8+FH0LuF0dMLxmdaZ1oIaryQcXGc58y7W+O/Tk6dgFyoqR3KE7PYBaLbaMivSVep
         LnV7RkNXzXFO7mpBL9Uh0DKySaKmW7rynQXXFDvDZnTEltC4yeXZZPJJ9CIPxO6LE54n
         wYl+BC475ykvm6PIuTCcCH6wZWbcds6ZKDFiALCWVkY06DfX/WTDyM6GkKHw2esXCVn6
         iT+OAA4zd6DPAq4x2JH5xW+fIdieUIsD4lVzaBTOc7enZsk6oWBAya8XdxsDAyw3mBbl
         IVH/JzU1M5syQFpZQ9KO8MGamjwbw2xLz/8HezhmQzXaQgHul4CKVS/xhx59fCYOH1Xb
         L2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778058353; x=1778663153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZB9RilwFR5SteBplF/teYxItIDeEzXLv+5HmDUxIXc=;
        b=aKd2poN3RZ/rqv6Y8NmXfpzdT2c9Q2My7WoB2++l1wGWhHl+tQT0hNvoRL8DEbzTuy
         vgn3sTrtOASDbG6ai+1BcMqHWYW51AvmrOxSJ/KRvznSJkFEzIYcmj71vm2aep9XzCFi
         kEST4G261TetbKEYVwumVooAbmv1dENp25zRQqHCDnzeliw6azlQeHZ7P8C2minUZMrc
         b2eBf4JY7+tS9wmb3CMue5Mwmvc9fpUrbq3n43uXzO290I6I4AsxrTZzXXL9Cz4lx0Dq
         NNdQVO0T5wTEh8wXsqBKMU//GBM3UWSMoKjeMOTl+ZJsCaxZAQVWDedU+q2Bjr5Eyj6H
         J4zg==
X-Gm-Message-State: AOJu0Yxxl5VEytorMZlJQM/NtWaSpurTOheG9Pk1l3tCbWLxooeELYET
	2ipN2AwdjXnF0lsNBm3+3LFcRpSIBq9BzUWRJAZw+uGPUI2bU9CYkArFxAUD+A==
X-Gm-Gg: AeBDievJ6ix89FsOHUj3PK2EqsaI+CH1Mj5wyC0/ehR/jfgTyH3vS7R0GRlJaFBgGU0
	CJY0nImZAnc4Xw+cp7x3dN4l9wvCthiY6Xm0V5YKsWc4Rwqwddf2wOefuUMDA4wippOwY/gtUS/
	A28RGdPvU0jB2F3/eQ7W6ko2BiPA0BNcjqOmNkZPS950nGMrjzLtXydDjpT2KhMnHHhrpqiMNXL
	AxmFE5ddqnuahXrlrhY6yOgWD43vSB3eBLg9idXufOfvgkdqHVWS/P5cDJ9r5DYi1Vg0UVip7Zr
	PePHpbhtdxlg0R0a7uhuTOD+oWVQKxuQqm1hXBeBDQeIxMqxIY+XoN45CSlCYRMnKGw/ct9loLa
	S2/YCJISWImGSI3wqqNRN971D1A3F0vnKOT+Yf6ZbcBw7vm1gmYdsSEWAnBnBAMRGZfrpFi8Jri
	3nzwQPYRbajmXG3Axg1Z9tlYxUAV/F1QixLbLmkPX5vOmw9mVY2uJHJTRC2zJcbPP696pYwjdAs
	dtWpvLNOc6ueRhVrl0yFwwmljWt7hRZgvcHUrmcBoGZqnpVkbHV
X-Received: by 2002:a05:600c:4f53:b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-48e51f44577mr44857185e9.22.1778058352858;
        Wed, 06 May 2026 02:05:52 -0700 (PDT)
Received: from [10.109.92.22] ([86.33.71.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-450524834eesm10595105f8f.4.2026.05.06.02.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 02:05:52 -0700 (PDT)
Message-ID: <c2d26c6e-c064-4e6d-a1e2-69e84b867ba8@gmail.com>
Date: Wed, 6 May 2026 10:05:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] io_uring: honour submitter's time namespace for ABS
 timeouts
To: Maoyi Xie <maoyixie.tju@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B0BDD4D864B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13244-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On 5/4/26 16:37, Maoyi Xie wrote:
> This series addresses two io_uring code paths that arm an ABS
> hrtimer from a timestamp supplied by the caller. Both paths skip
> the conversion from the submitter's time namespace view to host
> view via timens_ktime_to_host(). The clock is CLOCK_MONOTONIC by
> default, or optionally CLOCK_BOOTTIME.
> 
> All four other ABS timer interfaces already do this conversion:
> timer_settime(TIMER_ABSTIME), clock_nanosleep(TIMER_ABSTIME),
> alarm_timer_nsleep(TIMER_ABSTIME), and
> timerfd_settime(TFD_TIMER_ABSTIME).
> 
> Patch 1/2 (io_uring/timeout) covers IORING_OP_TIMEOUT and
> IORING_OP_LINK_TIMEOUT via io_parse_user_time(). It is essentially
> the draft Pavel posted on the original thread. I rebased it on
> io_uring-7.1 and verified end to end.
> 
> Patch 2/2 (io_uring/wait) covers the IORING_ENTER_ABS_TIMER path
> in io_uring_enter(). That path parses ext_arg->ts inline rather
> than going through io_parse_user_time(). Patch 1/2 therefore does
> not cover it.
> 
> Per Pavel and Jens's discussion on the original thread, the two
> sites use two direct timens_ktime_to_host() call sites rather
> than a shared helper. Patch 1/2 also splits the existing
> io_timeout_get_clock() into a flags only io_flags_to_clock(), so
> io_parse_user_time() can resolve the clock without a
> struct io_timeout_data.
> 
> SQPOLL is automatically covered. The SQPOLL kernel thread is
> created via create_io_thread() with CLONE_THREAD and no CLONE_NEW*
> flag. copy_namespaces() therefore shares the submitter's nsproxy
> by reference. timens_ktime_to_host() through "current" sees the
> submitter's time_ns when called from the SQPOLL kthread. PoCs for
> both paths confirm this.

At a quick glance, both look good. I think you had an isolated
reproducer, are you sending it as a liburing test? Would be
greatly appreciated.

-- 
Pavel Begunkov


