Return-Path: <io-uring+bounces-13546-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mOCzIx87GGo1hggAu9opvQ
	(envelope-from <io-uring+bounces-13546-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 14:54:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0195F2502
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 14:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDDDE308B218
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 12:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273FB37B007;
	Thu, 28 May 2026 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="WFh5HIBU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF583EFFC8
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779972443; cv=none; b=hwO4fLoYsKgMNEsh2igo1QaI8ixJLn27PCVZpKSQi/NcUkw90tsL04wY062Q4s7y1eUaukDj916mUAJz0qVSNlMAt0jbStqw+S04cYryROyoXIC/JmI1JlVdRG+00k3nx9Btkr0MmV8+dR3RIXY075ReNkTLH9n9+0/uVx9EWak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779972443; c=relaxed/simple;
	bh=rlJ6IZTleaSV4ynsGiiv/xNT6dvVrFtp+E9/UhAzd60=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h90ZqXFJhlzWAwe+YOmf2qeP4+5A7XfDjz6LwXbm+aX9TEHHluJY0+XYt9DzeXVzw2vD6p77lmJ37bqeh8A7J5KnZIBVoHtMi4i4UaBp+Ec9msjmmLPBjhKZ3ju51xLA0a2ponqJC5Rv/sG1jXcRR1YmSeGr7Q+4ak6xbsSEk84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=WFh5HIBU; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43b7e186a0cso1880532fac.0
        for <io-uring@vger.kernel.org>; Thu, 28 May 2026 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779972440; x=1780577240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/zCb1mk47fudc1ZiKoDR5QYSbHkxRCJ6yfjOlHrX+vs=;
        b=WFh5HIBU6nqydIiEvx0J4zRmkAwB2bg5qj8krKgP0fE0h69zN4vz5a+sT/G5k3YWIq
         xdp71i4cV9sC6wW6RMKCfhAqvjhGnazVkc2JTYkLc6Tb4gmR/haDgWEV4I93O7yS5H08
         SjPbV7V+cGMZIHREUk8lCZRUSXMwQSyW27HYh8tp0jmOVtPKWPW5Jdx+Tc/ki5ezfG9b
         PXoLoDvME+Bmy/1gc5zaPDr+i2djq9bPd8OgcuzZaGac8dmunRaWkadEPFUNy4B/jOj5
         EMz/uMrfNBgrlyzGNGXFu4hkaFuImMPhy6osu2riJygDGt8HbnEz1PH/3Vo4dVcGzCcu
         kKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779972440; x=1780577240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zCb1mk47fudc1ZiKoDR5QYSbHkxRCJ6yfjOlHrX+vs=;
        b=Zqac/IXv7ROAvYYNJKyIrAM1RxCOVGovHMQJEDcYTfAjlH45LR7lX7ju5giics1Rv1
         k52R0Tx7v647t4LMT+492AJfvJsRv1a5hIlg9b+eQcHxunUNYCn8QKB3n43P1lmCoYBc
         IOBgXWqoStwQi346YSWRzPn4gRcBToNMQGliMNRZN/kfVyDcYVpfoEltmAPnKRX05WsH
         BOzu6SL7L7fueb4MnqGxA0O7vWIa13fz5xEl+la2jwjGz5Liu0/rzGNhSy6ojQ/64qnS
         nUdQFRpGMumcRq6YbXkYve3VRtXJttFUSBFqPE+M6qELAb6MeUNoNfxjW918UP65V0tv
         SoQw==
X-Forwarded-Encrypted: i=1; AFNElJ9YBO6ln37x8BefXXv8EaNdV+hti5Qi1X5RejYVLYfcZVYcukBacE/mySnZUvlRgzNEJiVQKSBXJA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1Dl2wLnqvAhkmvP2fPOcfzN7ysyJMjEDjcFIxLKvjJoyFHf4t
	ylIn2MOGp46dBIMo4L2QbBRKpi6II2000ra8TglsQI1bmspkVEc0Y2Tn85xQGywNxSk=
X-Gm-Gg: Acq92OEvrCVTPLzzEWoo8rJWZ+UOaHfBAus4LrGBFCoIP67veXfoLe5zYt6zHJgEuKf
	0vc/leI7tHUs+uaGqV0IiNYseHP/iWHsrPbjL7JkgP6oxnaLKmXcNFj/8LeMWuReSzDVbUqmohM
	TZeCxnXqMp0l52ju4ZWU6MVcHF2x2tXkdLvb39ex8x5KpAlGIwO8BNS5XT4zqifHWN9LcyMUJe6
	hiHnHEKqPsXs4eRphgJq1cBnEOnHWW9mr66185InTHDQF9b/4TjhHlRjlxNRLXGnGivArPUpOYX
	VLVm0zdPTYbPGzwjtYkcGlJFbf+TXkWS4RH/+3T5ygrXeovsoUM0ibo3RgkNTOAz8Ip0b2ItfFC
	mnALF57RdBLZwGVBflvD0PznGqe2eQeBqNFS/Mb2186MuAgU2NMgz7B1n4T5mHDxRTltZalamxX
	Keb2B4P46QisYTxRO7EG3g6PwYarPNa23dHV87QnnedcVo+aXmlABfh8bPHHeWEcDLgdD2pX5bG
	lhJvHPoFEZndvr8QCGl
X-Received: by 2002:a05:6870:14c4:b0:439:7835:136c with SMTP id 586e51a60fabf-43b5ad8ccb6mr15892082fac.23.1779972439704;
        Thu, 28 May 2026 05:47:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639fd7adsm19740646fac.14.2026.05.28.05.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 05:47:18 -0700 (PDT)
Message-ID: <c8301a62-8acf-4a59-9e3f-30805c358e29@kernel.dk>
Date: Thu, 28 May 2026 06:47:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] dm: limit target bio polling to one shot
To: Fengnan Chang <changfengnan@bytedance.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org, agk@redhat.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev
References: <20260513091349.2194-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260513091349.2194-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13546-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[bytedance.com,gmail.com,vger.kernel.org,redhat.com,kernel.org,lists.linux.dev];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: DB0195F2502
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/13/26 3:13 AM, Fengnan Chang wrote:
> dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
> The caller only knows about the dm queue, so it may decide to do a
> spinning poll if it thinks a single queue is being polled. Passing those
> flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
> queue from inside dm_poll_bio().
> 
> With io_uring IOPOLL on a dm-stripe target this can keep a task in
> 
>   dm_poll_bio() -> bio_poll() -> blk_mq_poll()
> 
> long enough to trigger an RCU CPU stall, before io_uring gets back to
> io_iopoll_check() and its need_resched() check.
> 
> Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
> bios. The caller can invoke dm_poll_bio() again if it wants to keep
> polling, and it also gets a chance to reap completions or reschedule
> between passes.

Looks good to me.

-- 
Jens Axboe


