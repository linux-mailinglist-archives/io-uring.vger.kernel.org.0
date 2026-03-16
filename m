Return-Path: <io-uring+bounces-12694-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LCeHPkTuGk7YwEAu9opvQ
	(envelope-from <io-uring+bounces-12694-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:30:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D743329B667
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1D7983029C0C
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61884280331;
	Mon, 16 Mar 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DUA8ylGr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700E282F29
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773671336; cv=none; b=kGMGpCVQ1DvcAo+cMjm/2Xsqlqul0Y/GekTlGkZq2RAhHjLMNLWcd1A9VuOrqaRSM9cBBVQDqH0tikPxCP0C4biYw3hqC9/X93/Rl1dg/vpc6F2nX9ZZT/x8KOY18ILL0IvFp2QoVRZNrbIhAMig/fql3W7wCT2do0bwOwio9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773671336; c=relaxed/simple;
	bh=G6kCpzZKiKJUnHd1s7HM/Nr1GPWfto7LimDWafZ+HI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fILHPFqBxm5sjdqCvtCC4Iu8/DI+t7z6KumQfGbfURdWSpZpeOTmIN4CLw+nZW10S3va3mlAyqoh1HwBtqVXPbYix+gj6w/6Y5j2+qlQxV62INY8nw+5uu5aeFmtXKkqG9ORFpLZQe6zQ07G1RNrOcQZXUfwbNuNYghwyrID3pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DUA8ylGr; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40ede943bf0so2560604fac.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 07:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773671332; x=1774276132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ERLh5JAPpnyYKWFUV+VSgX/9b2NegZKArho4zLyMkkg=;
        b=DUA8ylGr452kjX2av23J04HH0csK9YlVZv9qJa+R5kc8DjRW6VVS4gXROs+vHFzhTl
         e7a9W8N4MJCTB04SleIm6ZB7oY11SiUuPaUTwtmd15JctKtNXMjrgCUUtpU0fvwrjBj/
         OcUVFShsRVpn0qZuu6VakMstT+CWI1eDifR04iZJUeBBpxqR4LgV5LenyOiFf2v6NZ14
         vNqEhsCpxR0P24ZU4m+qjG3bqHRbPb58rMEB1W3yq82bGf6P65QxyESVdEn2rg178IAN
         pyOtkukv1DahOQXZw4T+OWzMGbbwm2aSqq2U6sC7LCRFheJWgXwZ5Vs6hvjPOg0wD5HS
         srng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773671332; x=1774276132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERLh5JAPpnyYKWFUV+VSgX/9b2NegZKArho4zLyMkkg=;
        b=jP/0/joWKxVGd6Y6jwHhsQH7pJ+6L7kckIQdhc8Dd3UkP8MQ5a5yRflyOZRYrQxap6
         RVv5St4QO6wzCIQKxtgiily7BJUToOwn1l5maKiFJ/hCYrszMwYmJbdpBx6eGCqURuQJ
         NWYhwGiqzVoUyD5sgGwZA0wrJhPf7kJm54v78HPmA5r12PuUzwsh6tH6Dszue2kLgzT5
         XOYkoJF4kyJS4ANVj3VI0qRntnKAq0OgMOtgqWcyiinvXbNW8k8/Mc8N8W5ZH1+Xfu0G
         +WWkipUQdS76b0owUmdq7NbkJ6wozy/rfA5p5lJC8Va7gsf/6QdQw9+Rj0VUxkIEVTsf
         3Ibw==
X-Forwarded-Encrypted: i=1; AJvYcCU/Hszvbmu+CZPH8I8v2aNjITEzB/XFeAUsMFnqzPzAZPQJPAawoPAwVbGTKVs4iCvwG3sLwdOcBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3U3BgXBUG9Oxnn2uGSQFMNqs9ok1n9dLIl1XffE8ZrDMq5E7k
	CCtf2kUlQSDcpjMdGgvbK7g3l1w2D+ZOmCq2l1mjxNy5QsG6d7otEzeEQXsJpg8eJmQ6/zB8Hlj
	TuuNofhU=
X-Gm-Gg: ATEYQzwewf7SMTtehhdaStzPeWX+nJIhU7PmT99J/Cb3DhFvhUDz5uz8W2xUlaqPqk/
	MSgqaAdCEN+j2Fia6xmY0TJpR4o1kWX3tDQuhrwVecnRBUKD+r1y3bDZDP9v6S2H42iURF1+yZ6
	yrJzCArI7WgAIwtUXjwzENffOUrgK6E5fB8KrNZYIq48SB2TcUJJ+H50V4RCwyoyYSrBubF10Jf
	wzqWVnqQrs5a0UMfrWKGDJWP72rbs4QrGVRR8PXE91KFq/2QOFxib0BF36B2joWYoBk0OT1V/um
	LrGQWXEYrMCTdT6ixDo+52BGboEnSZHX012fRT+16ycuIp/zCIj/+bN+E9IBBSwo6JqcoXguO/6
	aH3tlKL1cUZk1eecX1ysoYu8Mb1JkBXFhLSw72UURLk3LI1JgzNu6k918ggrKJTKjR7VeLa9MCI
	zAOkSzo8ogR7T+X9Rl6mmeWwCv0tHRyARjini9uQMqp73LONtSzwFOr6Pag6WiAHtQ5UGCdC754
	BdaN1KIlw==
X-Received: by 2002:a05:6870:6c02:b0:417:1a5d:7ab8 with SMTP id 586e51a60fabf-417b946e89cmr8484621fac.37.1773671332614;
        Mon, 16 Mar 2026 07:28:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177de88106sm16226181fac.0.2026.03.16.07.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 07:28:52 -0700 (PDT)
Message-ID: <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
Date: Mon, 16 Mar 2026 08:28:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: francis <francis@brosseau.dev>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12694-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: D743329B667
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 8:17 AM, Pavel Begunkov wrote:
> On 3/15/26 16:19, Jens Axboe wrote:
>> When a socket send and shutdown() happen back-to-back, both fire
>> wake-ups before the receiver's task_work has a chance to run. The first
>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>> the first event was consumed. Since the shutdown is a persistent state
>> change, no further wakeups will happen, and the multishot recv can hang
>> forever.
>>
>> Fix this by only draining a single poll ref after io_poll_issue()
>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>> discovers the remaining state.
> 
> How often will iterate with no effect for normal execution (i.e.
> no shutdown)? And how costly it'll be? Why not handle HUP instead?

That is my worry too. I spent a bit of time on it this morning to figure
out why this is a new issue, and traced it down to 6.16..6.17, and this
commit in particular:

commit df30285b3670bf52e1e5512e4d4482bec5e93c16
Author: Kuniyuki Iwashima <kuniyu@google.com>
Date:   Wed Jul 2 22:35:18 2025 +0000

    af_unix: Introduce SO_INQ.

which is then not the first time I've had to fix fallout from that
commit. Need to dig a bit deeper. That said, I do also worry a bit about
missing events. Yes if both poll triggers are of the same type, eg
POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
would anything else where you'd need separate handling for the trigger.

-- 
Jens Axboe

