Return-Path: <io-uring+bounces-13220-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QPhaJm43+GlPrgIAu9opvQ
	(envelope-from <io-uring+bounces-13220-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 08:06:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D397E4B8C0D
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 08:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D148300735B
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 06:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9092236E0;
	Mon,  4 May 2026 06:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="B8MGQQsA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3548D1EEA3C
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 06:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777874796; cv=none; b=uwqswPowsSrMFZIGs6/PzUL1vLZdiyHy7WXDHaS6irQQeHVNsOJUCSW+66eHGdZH/Pz+vn8+kPGPWrAE4ffi/RECuaz1ICo8aKw9jDtvPzqoaBgNgZJJPFf1tvgboIrp/vYLhXNDNVaaOxJr6SL7vxVfAfBlwqbwANjAbZUlFjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777874796; c=relaxed/simple;
	bh=kbHoB9C+D2GQnydHnIzp4LqU9LidIbrPHCrPxtTdyc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U/Mjh45Pl6yqdJ1bMEp1T+BLyjAqSdQef9lstOmEBze8q13Swlcj/3W9Jxp04irKZAWVvgbHkN2tZxhFPaBk0jb4A98bJJPqc2BwZtcJOLc5w7FCUQMILz3YgShZxLLbz9UPGd83GGe1Mg9C6xnev1eRDTmT4ZfkcYNFgNywMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=B8MGQQsA; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-44dd5cb0f81so278894f8f.0
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 23:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777874793; x=1778479593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vexHEjpsGwv7RjQ+ZQ7Gpo1ZgY4PcGih8daCe2nrVyU=;
        b=B8MGQQsA1hCEur8sWE8I8AOS0R0r26CJxwRbauPuQslkYLvTZHjS1jazbpJoiLy0n7
         O3gUz3SVVZcNGN9LI0B8pSCJ9d5XgyXuX7NrDmYqCTfohbENs/yKoxkU2S/vE7D3+O/b
         7cso+0tegD3RIVLvGmsEzjsR0I0+npbcjanWT1USq/fOELbpfzV6AerI2rYFWY0B3Vyn
         yssbEhAjburdOaKgfoLuNoWH1ypVz/f2lMrcCJDpTmgcGr5+jcwz9MRk3CUdVNirwOYY
         8l0xyakrmPiK4sp/Hkd+KJcMIEodRL57YQRovcWB1WF8BoA/tF5I0/RLw9i7Z7ssLfpG
         tKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777874793; x=1778479593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vexHEjpsGwv7RjQ+ZQ7Gpo1ZgY4PcGih8daCe2nrVyU=;
        b=sRwWn0mZw/Do24pgndvx3Un/YHXF+yiwsthNxQbbKPVSHF3Ukl0VIhChkxVVn4iO4y
         Ce8fZuYUSHHi3o/2xFLz0ogePb/aCEaR+bBORoklHUbEuIPNS0CmjFflkgpmP2WAlsBe
         Seg23arNQN2Enj5MM5CA+ioNC+G73agovebLa49YBQWZZrS0TfwT0Bm7DkPHjEU5cVoP
         iZhVn/tLv4+SaUQObxjAnWC1i+2Nd/EEievAmHmGV3ehB/RytG2ykzHI+PYgWgPk8cym
         lecj07Vty3I3f5SQpCh2XWdJ3e/C5VYvRdtaKJz9kSlAU++54fW1gVr6EK9EqUvvBw5y
         R7kg==
X-Forwarded-Encrypted: i=1; AFNElJ8/6GCqCAZLqgo1QdUzbdPbjaLUG47rbmmwm1NPFjTnwSsUAFpfP0r1bAQM9PaiVX5M0FIPPOM+Sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkeuANwaLB+zKoNxRkYjWvCQ6AyQ8I3X8E+4iZqu1BJ6WbMzA4
	Bjm151tDNpEEHSmENGH1gBRJ9964Qg7MaeWJEL8V+sSoK4trvx+kAaetB7IYiT7JCtE=
X-Gm-Gg: AeBDiet1h1EQeRTCl76i7xntVAHkvSx7y7BMe7GlkZw0DeAGnO8gRfVvhWmAlzjsFbv
	aZVLFS2Be5u2+goeQNtvSHGNipmGqp73rSxeXf40nyYWYv65vJkodpILWcEJBKUyDIEeV7h2K5T
	dK+HT0gZ7jSKizHsYfu0Okuoq1cAkLt1PSyIvdXuSbplTzrL+bQXdJ7bz6d063KZipgq3/NRwXW
	CiJmTZJXGpz2WzP2i0aJp/jT1NJADy+cxgW3M3CZBtV5DObrVaf5uCQ7kMMnl75yf7G9HaVlKTI
	oK8iCp0EnlgQIKJRIx58t676IfFJ1kYsBd6XNepF2p9lawKocxkCQa9HeYq6YDURzgsN9jWxqXM
	l3p1wzd0Kld8D8JSxTfP1X6RTLhUzOwG0Osmcr0a3FWY3mOfROJhgpFFSGliWuVqLrdbfIQwwZs
	nFIcR1hZMHpy+qZh3NHt8SoILNJ3097PGPXzUYXp2aAoiwUFWz8B23e/U1e40jJEvOIy7e29Klr
	sonoIH67QsnUURo9dUj
X-Received: by 2002:a05:600c:620a:b0:488:aa33:dc8f with SMTP id 5b1f17b1804b1-48a970171bamr125119845e9.0.1777874792488;
        Sun, 03 May 2026 23:06:32 -0700 (PDT)
Received: from [10.211.8.175] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a81ed6bafsm531948635e9.2.2026.05.03.23.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 23:06:31 -0700 (PDT)
Message-ID: <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
Date: Mon, 4 May 2026 00:06:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
To: Xie Maoyi <maoyi.xie@ntu.edu.sg>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D397E4B8C0D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[ntu.edu.sg,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13220-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

On 5/3/26 9:12 AM, Xie Maoyi wrote:
> On <5/2/26>, Maoyi Xie wrote (correcting my own earlier reply):
>> Under SQPOLL, the parse path runs in the SQPOLL kernel thread. That
>> thread is in the initial time namespace. So timens_ktime_to_host()
>> through "current" silently misses the offset for SQPOLL submitters.
> 
> Apologies, that paragraph in my previous reply was wrong. I have
> tested it.
> 
> Vanilla v7.0, SQPOLL ring inside a fresh CLONE_NEWTIME with a -10s
> monotonic offset, ABS deadline = now + 1s:
> 
>     [child] SQPOLL TIMEOUT_ABS elapsed=1 ms (bug fires immediately)
> 
> Same kernel with your conversion logic applied:
> 
>     [child] SQPOLL TIMEOUT_ABS elapsed=1000 ms (offset honoured)
> 
> The reason is in create_io_thread(). It is called with CLONE_THREAD
> and no CLONE_NEW* flag. copy_namespaces() therefore shares the
> submitter's nsproxy by reference rather than allocating a fresh one.
> Inside the SQPOLL kthread current->nsproxy->time_ns is the submitter's
> time_ns. timens_ktime_to_host() resolves correctly. So the SQPOLL
> follow-up I floated is unnecessary, your draft covers both paths.
> 
> While verifying SQPOLL, I also noticed io_uring/wait.c around lines
> 230-234. The IORING_ENTER_ABS_TIMER path on io_uring_enter() parses
> ext_arg->ts inline rather than going through io_parse_user_time, so it
> does not pick up your fix. Same shape of bug, separate code path. PoC
> on vanilla shows elapsed = 1 ms, patched shows ~1000 ms. I can send
> the small follow-up patch for that path as a separate thread once your
> IORING_OP_TIMEOUT side has landed, or fold it into the same series.
> Whichever you prefer.

Might make sense to refactor a helper that does the time translation,
and then patch 1 would basically be Pavel's fix and patch 2 would be
sorting out the io_cqring_wait() translation as well. Both should be
able to use the refactored helper.

-- 
Jens Axboe

