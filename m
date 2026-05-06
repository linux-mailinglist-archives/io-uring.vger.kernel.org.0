Return-Path: <io-uring+bounces-13246-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HssLawf+2kgWwMAu9opvQ
	(envelope-from <io-uring+bounces-13246-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 13:02:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF934D98FF
	for <lists+io-uring@lfdr.de>; Wed, 06 May 2026 13:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E7931300F77E
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2026 11:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E234219F1;
	Wed,  6 May 2026 11:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dWhRfzn1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC79368275
	for <io-uring@vger.kernel.org>; Wed,  6 May 2026 11:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778065318; cv=none; b=OXLQRhwqryU0h19JhdL0J9lywX5EIZANjSj91kJrus9qEclhi+ODpRS3cDKnqPpFjzX8L2LTArnzrWrIvFeMPrmBr1qdZGt+H9wgUnI67Dn0uK8ESH4c3AXDW3A9RKb64wHFUHtSvcIsS+lWvXtuBKlytS/MWZWsrtjOg2lEW2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778065318; c=relaxed/simple;
	bh=QG1ZBdT0d6HLzdao1fVHLBJjJ9Pap8KH1rfe6FL1JJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZtuoAPTcebkmbjUS16JwRSE6itVDu+V3EpDJ5KwCsDUQCM9q0JVKjb1HU5Tvf7umBPu6CblmTsxISCd0iev+J761XWXVw3GGUhnbTrNY/KBxtBJ+ATa9RNYRL2y7sPKKni5BmGrzJAkLM7a4j0hyCWstu23/4oa5DubnHZSmItE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dWhRfzn1; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d7e23defbso3573231f8f.0
        for <io-uring@vger.kernel.org>; Wed, 06 May 2026 04:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778065315; x=1778670115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=trYLINoZQm/dLTJf5GCAa3APTWLZ0M05GGlbxeelCB8=;
        b=dWhRfzn15vyefd2IlqLpeyacf+PExp36dRdsgIbwU1+HK/PuH6eywNbsfNlEFIsuRA
         i080v1FcPI4yveWZ/VI7E2lEorQtQjDmEIz3VJRqDiFXAkmw2clcUPt2k6xsiGunTJB1
         npgFCrxLRUkBU51dn0LYuG+vlbMnwxH4w5p6KENg2iGCYwAaNiG7bChI21mWMTxOd+0y
         itmy7bSv+pG8X86qWjKuR0mv/zkO03lpez0IXZHIQQhV0/BIXhpugKgC8jRkXtPbfxhM
         dgplF74jAVYKeYdMSytjoWzNUGgz9mHM6UvDgsb8rBhDS7UkyJ0ChCa6F3gvEmM++nwD
         PQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778065315; x=1778670115;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=trYLINoZQm/dLTJf5GCAa3APTWLZ0M05GGlbxeelCB8=;
        b=GD3xQlxM/4PaOhGS0jwLVSO3wEjS59SvTzCRE3nJAQqzHHjFMIdBPBS6n2cS4P3mOJ
         VP9VlTJzgRpY7yIS24CAEpyZ+yWNdXwQ/m9Ndwrxz+dfTTPWUeL57+SLgzypfAHimrje
         b2w5yq6cspMUv+cA4cbEJmM2SXj2ih1bKXx1Z572kd4aWeEXpLtYnadpU5qhFFbtwbhg
         vyAyJPJPj1IWXpxm4LDf8tIC+pDbH96MV0lCySqSz+C7PKdo35BW9BxRCON4OR6uowjz
         Ijwso3HHDPDjBGIRtGicrBCo+8Mqh+g+G/+E+Lr8RrTDWvOq3oDorYkISi7cmpBkZxlD
         RN6w==
X-Gm-Message-State: AOJu0YzcHq0UXNaWuaRc72xSE3D/0l5XdhyE5oOur/tEp/tNvTwjsjeC
	1LfR7C/gte1IRF3RRTDPLANJYNKK1TO+Wgs7A9DBnw5bAc+Ac1AVZp55KXxESI9AXmE=
X-Gm-Gg: AeBDietCL1AKzxHq1cK+2oJTlHZpZQxKsfnMSv56BBpATdR8rwpTwx0YUzSsuo9ejNj
	Q3AJuZx5Qpd1PzsDKQ+8mTL4VZoP+d3svp17RVWO7tb1HW32xPgeBO4cmzM6USU+mwoIu1aD9Gf
	qr6/ojv2iSajajrnbHm+6EZV6uEFMXpnUxTRKot61E9NIKgzWCGGxJ142nIA4WCjL0ir8wPBsuH
	COnbIvYDDQqRZIiBc++F3BA7OBQUZsrm48hkxjkOJHZ6+hnf9kgth7llH+KM8n69eT/RaMzcj6/
	w2Q/CyYr8vAlmNzrOeJzyA9wrdESSRt919+Sf7k/qMHnNqEc1uT9kD7YnToDIWZ/bb2TPQlZt+E
	2WKgRGnJoogCzPEYocYIbpYKlBKvOQdscE8z6+dfj9wRt3sWK8nd0/ESUJ4lEN0JT8sVrQLCPgR
	7fYRvmmW/KD1KuF+Erpbcrs2/V09QZ3R+NhYDeFcEoUwupya8BxErdpPhUHBZNw2S1dv8NBiocT
	31KBFdjpGF8Pso7CmcT
X-Received: by 2002:a05:6000:200e:b0:43d:7946:bae5 with SMTP id ffacd0b85a97d-4515da96794mr4957294f8f.42.1778065314993;
        Wed, 06 May 2026 04:01:54 -0700 (PDT)
Received: from [10.211.9.173] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-450524831cdsm12964172f8f.5.2026.05.06.04.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 04:01:54 -0700 (PDT)
Message-ID: <580d74dd-78da-40b3-a373-c27458bfcc9a@kernel.dk>
Date: Wed, 6 May 2026 05:01:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] io_uring: honour submitter's time namespace for ABS
 timeouts
To: Pavel Begunkov <asml.silence@gmail.com>,
 Maoyi Xie <maoyixie.tju@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
 <c2d26c6e-c064-4e6d-a1e2-69e84b867ba8@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c2d26c6e-c064-4e6d-a1e2-69e84b867ba8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5FF934D98FF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13246-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]

On 5/6/26 3:05 AM, Pavel Begunkov wrote:
> On 5/4/26 16:37, Maoyi Xie wrote:
>> This series addresses two io_uring code paths that arm an ABS
>> hrtimer from a timestamp supplied by the caller. Both paths skip
>> the conversion from the submitter's time namespace view to host
>> view via timens_ktime_to_host(). The clock is CLOCK_MONOTONIC by
>> default, or optionally CLOCK_BOOTTIME.
>>
>> All four other ABS timer interfaces already do this conversion:
>> timer_settime(TIMER_ABSTIME), clock_nanosleep(TIMER_ABSTIME),
>> alarm_timer_nsleep(TIMER_ABSTIME), and
>> timerfd_settime(TFD_TIMER_ABSTIME).
>>
>> Patch 1/2 (io_uring/timeout) covers IORING_OP_TIMEOUT and
>> IORING_OP_LINK_TIMEOUT via io_parse_user_time(). It is essentially
>> the draft Pavel posted on the original thread. I rebased it on
>> io_uring-7.1 and verified end to end.
>>
>> Patch 2/2 (io_uring/wait) covers the IORING_ENTER_ABS_TIMER path
>> in io_uring_enter(). That path parses ext_arg->ts inline rather
>> than going through io_parse_user_time(). Patch 1/2 therefore does
>> not cover it.
>>
>> Per Pavel and Jens's discussion on the original thread, the two
>> sites use two direct timens_ktime_to_host() call sites rather
>> than a shared helper. Patch 1/2 also splits the existing
>> io_timeout_get_clock() into a flags only io_flags_to_clock(), so
>> io_parse_user_time() can resolve the clock without a
>> struct io_timeout_data.
>>
>> SQPOLL is automatically covered. The SQPOLL kernel thread is
>> created via create_io_thread() with CLONE_THREAD and no CLONE_NEW*
>> flag. copy_namespaces() therefore shares the submitter's nsproxy
>> by reference. timens_ktime_to_host() through "current" sees the
>> submitter's time_ns when called from the SQPOLL kthread. PoCs for
>> both paths confirm this.
> 
> At a quick glance, both look good. I think you had an isolated
> reproducer, are you sending it as a liburing test? Would be
> greatly appreciated.

+1 Yes please, test case for liburing would be great!

-- 
Jens Axboe

