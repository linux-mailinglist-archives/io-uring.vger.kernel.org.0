Return-Path: <io-uring+bounces-13227-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKxFINFu+GnkugIAu9opvQ
	(envelope-from <io-uring+bounces-13227-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 12:02:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CFC4BB617
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 12:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C01F30065C8
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 10:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31114375F8B;
	Mon,  4 May 2026 10:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="oCKYdR1n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1980E365A1D
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 10:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777888974; cv=none; b=O6Q8GgHEY4hLCaFVbGuVvdlEwWZYwjYarycRHLdTYt5sKRNvolPsMt+hNW0K5y0cWH17zF75dJUqTdhmTYZnqZmJvgN+Rfmw2QBbSdD4oqFfCkFc79lnRcztebtsbX5LRAdVROhPiAhq2Mbte+sgjdWlbbPL9jVcfy7H57JXcOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777888974; c=relaxed/simple;
	bh=yTnRoT8/gtQjN2YFeyJd42bDte0cAIPr9a5XzGIEZZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYffW7wuAjhnM4nbgvoEU1iSxkq2G3MTBts3Aqaa9Qj9gw5zSfMxVpu12T45lsr71CvHKEduoPNUbVa63mYxXLXjxEtAStNO3Kidkih3K/E/9WhseX5foYIasCYo2iLOwG3TS9XHlHRRrrt0hx6ka8+o/zl1W6dklJAY6dwTKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=oCKYdR1n; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso31642965e9.2
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 03:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777888970; x=1778493770; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mipNGf7zERnFzoc2aGvUG8Q2gFM+M1wRRQUhPAJmgco=;
        b=oCKYdR1nOEiXUTTx5hhlyczfQX6ebU0rXzNnGTkTX8pe8U5fQEwfucjRo7C9tOjxvg
         FoMhuLjD4Dt5xmrAevq+vyoa0d5mpguNRjlmsfv32muemEL/YQvkHq5+wskhSqF+NFN4
         9Qb/uRaPSq2yeIaQwXF12v7P0H9p2vWY5Ig+QBILmsQRxiu3hVZlU/FtzIvwb1GHxJlc
         eTuujAhgVse5uvTR1ucBV/EX8Mru09MzosXCgBRE5GGCmSdJPEFUSdH6xpn6kMHfP0Kr
         J1y3++Pcyh90SYtc9xXSn5LWMekZmVJq8mlHWmtuFATdWrTr89uvMDuHykZIQsThxjNu
         ZLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777888970; x=1778493770;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mipNGf7zERnFzoc2aGvUG8Q2gFM+M1wRRQUhPAJmgco=;
        b=o9VUFC+7yxtdpZnW/iHXL4tK1Ua0sMqmpomAk7/ltpD/oB47uISFnaZfYkyUVLy3ER
         uFSYr0qGvMUhu3sVj50p2XCkrfHiulQcxXvF09JuQ6rIEcKf/o6n6bzhF2kXzeyIkv5e
         frqpkbvKj6RbgyJ5IuNUuSYb3zvBvxdNJYfNXoLQeAZoCaO+8OAdj84/ijYzsx+kkkkT
         s62S/xEpY9FEA2/2grrTuVcWuEbL6ESssbxFEpEGTujBMt08QTh8s9R1LK1L1VscDHME
         GSkS5dYFKDbsKW/yzM7NjrZ2z8Rx/2AR7m6MCTLF/zLm39P8CBwC6X8h4ixLRRBsD5GR
         vkYw==
X-Forwarded-Encrypted: i=1; AFNElJ/xyDNrprrPdTHrYSnNJ96a9SLUc+DLwWbZyd3Tkl7dbSZlSE6BCzxUJjYLJB8zpDiYCLNE7GrPhg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFJ5O41lBi6SApyDQIGggrPz4dOTbolOWKJzgpbjmlLoFNNex6
	zPET+Id2YraCzpcbtsMfsvU7upYl99Sq48S1y53NnRsrdh/HjpGLDE8j8GrxcVT8ykw=
X-Gm-Gg: AeBDietZcHTx5i30XxQD+xh8bHryAw/mgHTiF5QczoSdEvWnhGZoNhgkmgIzvK4haP6
	VW13KfGIlPf+Ihz+gvBu1BySiqpTGg6jIFd+nDMat+MJNYyNIsDd6RoxpCRuVSsz5Ayhn263Vzy
	p5yJ1AZwRKSwv13lL+jSF9M3P63ns7piaQWx90QBa09Vhn8eAAaRQoO0HoyB8LmvY3q+BeehR83
	LW3gn6DtXo5Pl3blL9xYp4r5Devve/0gNdVf6ILqC5CpoP2k2zEIw8FXOImlxxzUm4yCKaWRRIG
	razTDLEtYE8haDgK61EFOVudPiog3kGyICJFWxTq3K63OuTF5yyt4tjH+hYQAp6bAAD+zYMWfnE
	u0vAhDmZRLwAKZwV7Y1PNVtepEyrJ94tjqgqcN157ZQeNcFE3lld/qbcnK5jKifrFSemQLURdAz
	kVSz2HacqOEWRK1SxAMHqFqDfOcK8Ch7v5IM8ZX50QwaWoYfyiHOmoX2/oKAiIHz5qv9+AAwB00
	6M2D8ezh+MPXBW0moBv
X-Received: by 2002:a05:600c:8b0e:b0:485:ae14:8191 with SMTP id 5b1f17b1804b1-48a9852d122mr138512425e9.5.1777888970407;
        Mon, 04 May 2026 03:02:50 -0700 (PDT)
Received: from [10.211.9.114] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8ef52854sm24846687f8f.12.2026.05.04.03.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 03:02:49 -0700 (PDT)
Message-ID: <6f8e0462-33ea-4b14-a211-c01e9629b558@kernel.dk>
Date: Mon, 4 May 2026 04:02:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
To: Pavel Begunkov <asml.silence@gmail.com>, Xie Maoyi <maoyi.xie@ntu.edu.sg>
Cc: Andrei Vagin <avagin@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <aa9ea9e9-dbf3-41b9-874c-1638f454c2d1@kernel.dk>
 <988f7486-0353-4239-badc-6c0dc9b3abd7@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <988f7486-0353-4239-badc-6c0dc9b3abd7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 15CFC4BB617
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,ntu.edu.sg];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13227-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]

On 5/4/26 1:48 AM, Pavel Begunkov wrote:
> On 5/4/26 07:06, Jens Axboe wrote:
>>> While verifying SQPOLL, I also noticed io_uring/wait.c around lines
>>> 230-234. The IORING_ENTER_ABS_TIMER path on io_uring_enter() parses
>>> ext_arg->ts inline rather than going through io_parse_user_time, so it
>>> does not pick up your fix. Same shape of bug, separate code path. PoC
>>> on vanilla shows elapsed = 1 ms, patched shows ~1000 ms. I can send
>>> the small follow-up patch for that path as a separate thread once your
>>> IORING_OP_TIMEOUT side has landed, or fold it into the same series.
>>> Whichever you prefer.
> 
> Yeah, I noticed that as well
> 
>> Might make sense to refactor a helper that does the time translation,
>> and then patch 1 would basically be Pavel's fix and patch 2 would be
>> sorting out the io_cqring_wait() translation as well. Both should be
>> able to use the refactored helper.
> 
> Unless there is some more unification b/w cq wait and timeout requests,
> it'll very likely be cleaner to have two timens_ktime_to_host() call
> sites, but I haven't taken a look

That'd be fine too.

-- 
Jens Axboe


