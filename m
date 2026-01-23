Return-Path: <io-uring+bounces-11903-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMsuFI7hc2lgzQAAu9opvQ
	(envelope-from <io-uring+bounces-11903-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 22:01:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7867ACF9
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 22:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 220293019064
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 21:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDC427B4E1;
	Fri, 23 Jan 2026 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IpbgwB/7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D93D288535
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 21:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769202034; cv=none; b=D3I9/YsGEAbfZw19kraTy0TLdeNOkOlVjyE/TdmGeP2J3l2LSSRpRk8X3FBzXMTSfUJwq/PQX+nYcitVTtuU0RMh45e8opdLe+aih7ssiBhWnbMCxh0r8cbelJJEIL1RpINJMFuBD5FYqPGcxzQ9zGd6WQRjSeKARXLgHciP4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769202034; c=relaxed/simple;
	bh=WocWzWYPVlyXRG0+AUiGnY1fD9Q6IKhT1UHtVJhorM0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=PxV5h/x7C8yPs5d4oin00ui+WrrFk7oLy7Q98tbtA7D8hAhJxioQCFrngMKQ8f6hOTpXRdmWR+mPF5paAiBulPIDHRcyFx8Q3tZCk0Z2Nxjt2j/IbIxxB5o21+OM6OVCs046+8YN/cDjCP6akQ1/ysAECL7fxbEal+ICEUicoRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IpbgwB/7; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7cfdd3146deso1099255a34.2
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 13:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769202030; x=1769806830; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnRXS+wuCcqcoaCg3nb3M6FWVkgS4pzU+HIK5G7zmKY=;
        b=IpbgwB/78Zhb00S6AAO9ywP7dl4YcMP/XUBGByiytHGOEeUhaP/VASArsFaTQ++Q5f
         KA3AeKhtXBsWh3QNuj2r6xejEXw3JYf9PvxY+PEY1bDWsLohDTUWh3pChs72UM4nnYCI
         33fdbX/GQKNszrO0hoSxOuSbl1hOjeWOfTLJcl6YUtUB0mznQ2gmyE0O/ClZiCR61SFp
         fhOZSL+wWn3rdAqL1g2b/jdYK6swCgyAWaR2Y259DtfeCXzdxe3+jkJqFLlgtBOme560
         zo/eIUOowMjsPQ/pKc32aDi3iW9EeYoQugUrJCMzGmN54L+mj/0DQd9l2PxJiIQd9O2C
         1dLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769202030; x=1769806830;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rnRXS+wuCcqcoaCg3nb3M6FWVkgS4pzU+HIK5G7zmKY=;
        b=QDxxp0sJr7EkSHW8vYmKNvAldb8NXT9gQu31s/GIApoCjgjBkTrikkIXsocb0eE/3r
         CdPXz6l2QO2ciG8KKnfZjPjNyot/ronguUmLRs9spnx/bAOFhHaqJ2H3s3mc3rSpkjPZ
         WKgS2iL1WGheaPRHqL0ay7I5tMyNI3Z5ccxq2dmnF4LHYu4YnVKRWnVxUrO5uRYY311J
         G65ReneYFFntXCxm1j31C2hfbncBRDnXAE/Geu41TE/e+TF6qKI4iihKJdIsrdtHvijU
         z3Kr7XAOy1dPBxo07pSThXYiTBkXb7DM9uLkPdFeMOwSlvSOq4/h6UdOoz5365Se/Kro
         qNBA==
X-Gm-Message-State: AOJu0YxRrWRXwUgvLsaNcwf+IBUq26bB12fLMh96LHF1cJSIq4SwKX0v
	vvJ8vfOFnBDt1kz55PNhiDILxISfd2uDRKx5sPXXWBaLztuYQoD4Li7EhvehMGoZl7sJOwgUeBb
	cLNpx0eA=
X-Gm-Gg: AZuq6aILetVYHOjwyHOFgYpmO0nW18BoLzG8LRE0uQ0B/NW3U3X9WMOA9ND+AY4Fs9i
	0GOwtWxcoeyHJAgu2ofjqKGKg4ei5KZd+reRo3rsqSggVcAMPuW0tUCN0V28hstKLt4SZ1uEaka
	l2rksH8af7xey/VTaJGnjv03M/5HpHhiG9B57UK8jiUPy8mlxsHpmP3bta0ozxnDkN0GPRUtmd0
	8nW+2t6eOt0yCDhommUMogRIm3X4IwHgD0CWDyvqVJCrHnVkYjOMbCZCoQUpec2cCTrhSyHtamr
	gSeYQwCaCW4XoGFrLRfl5I7vwtwj7CMTqw1ucGTdVYPeKNkJwVl4xpi7usaxbwZijD5n0iC7ByO
	yvyvtArXQAVI+h+RtCg5ZxvTmfJEuAD0vRYz3q72Bo4bYOvgAGfonbUD9Kt1ybrVk9JymMl8KkY
	R2wZR6C4/D96SPrbfiDSSA2hHwULfu18JAIQ25yRYM6sBTP4zWjadsfxjLLqb/XiUiNA2dLKLEw
	YyVv8Q=
X-Received: by 2002:a05:6830:3817:b0:7c7:2df4:faa3 with SMTP id 46e09a7af769-7d15a63c9d8mr2067787a34.33.1769202030305;
        Fri, 23 Jan 2026 13:00:30 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b35f607sm2556959a34.11.2026.01.23.13.00.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 13:00:29 -0800 (PST)
Message-ID: <ca34d302-6a65-4188-85e1-f731cc713aca@kernel.dk>
Date: Fri, 23 Jan 2026 14:00:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/io-wq: handle !sysctl_hung_task_timeout_secs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-11903-lists,io-uring=lfdr.de];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.972];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fb.com:email]
X-Rspamd-Queue-Id: AD7867ACF9
X-Rspamd-Action: no action

If the hung_task_timeout sysctl is set to 0, then we'll end up busy
looping inside io_wq_exit_workers() after an earlier commit switched to
using wait_for_completion_timeout(). Use the maximum schedule timeout
value for that case.

Fixes: 1f293098a313 ("io_uring/io-wq: don't trigger hung task for syzbot craziness")
Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index aaf1dfc21763..3b55feb620d9 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1340,6 +1340,8 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	 * up waiting more than IO_URING_EXIT_WAIT_MAX.
 	 */
 	timeout = sysctl_hung_task_timeout_secs * HZ / 2;
+	if (!timeout)
+		timeout = MAX_SCHEDULE_TIMEOUT;
 	warn_timeout = jiffies + IO_URING_EXIT_WAIT_MAX;
 	do {
 		if (wait_for_completion_timeout(&wq->worker_done, timeout))

-- 
Jens Axboe


