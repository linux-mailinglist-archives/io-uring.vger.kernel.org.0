Return-Path: <io-uring+bounces-12915-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGOLAJ4vzWn7aQYAu9opvQ
	(envelope-from <io-uring+bounces-12915-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 16:45:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9ADE37C5F9
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 16:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 243B530CA180
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 14:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F82A275AEB;
	Wed,  1 Apr 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q/wY5tIK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6DC274B43
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054036; cv=none; b=NnmP1X5AnMOhUAtn3113mrZnQgzyDQuyA4vlUdXkRxwP161naF7xUpcgOMoPy5G6H91BpjT+GcY75v5u2UEjnMJsJL67GPsf/Wje5fqceRBFh/PThUwImL5m9oiXRoR8MVN458p5XZkGdjGo8tUssU6HXZo5PK6Xqx9VAo814c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054036; c=relaxed/simple;
	bh=qexqpOPKxgIcCuhWKuXwg1YQOJu4FJgqaX4EPvy4SmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dl6mo91aUjjrVVbHkiFxWI6FPgf9P37ROZUZQ8knlEsHLzZkf6wDovoOsDSN4/2Lnf1KZE0YJ8JQ+mk+LpZ57fp4hNlqRRWQFLeB1ZVy/PTkBLy1XPMLiRcDWJyZS9sW4CE9wSYZWJ5Jew0chyvhDQscfao/4GD/jzcaaCZnL74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q/wY5tIK; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4648447e29bso2328904b6e.0
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 07:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775054033; x=1775658833; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AfPVfaHGR7GZ221OXA4cU0hYbt16p4SK+bSdGxn2yIo=;
        b=Q/wY5tIK6k1jC5AUZdB3FCqfh+306Kd5Kp3UNgbOFqCgVF6lZUuB7ZkwMwuDuWzq0O
         NX6mGxf0ekorl41lJmfbcLJGGp/XzDZlZ3NsFMnLpBwath+bPC6upKmpeDmaIb2ortQd
         lKVZRKsiZuDKDYNVjhz1ptlfeGlD7kP3N/ETTrHTaqLKSc8O2rAjd9f9+ezGh1VQ2Diy
         VKGOAQBJqPBZLxRk7QkWgz6fgN8eHjACyfwUzlFAz4eILilF2JYO+PjarR2AISikuJiC
         ZAuqnO1X/6KAzM0aBBEUID7F74MEQytH++PH9cuPSmqSXkfYqL3DsYwiBh5rOh61tpW0
         EPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775054033; x=1775658833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AfPVfaHGR7GZ221OXA4cU0hYbt16p4SK+bSdGxn2yIo=;
        b=ClW9f7iLxvIb1G0qK2MZAvQxVB3zyQm+9qsGBn4TfbXFt8OH62OjEgzK2QDJ6Ol3YP
         2RDSBlaJ7GyVRFljvSt8kp1p3WNB26156LngFzlhRawakiCz7qdSiZ8ksmJ8McxUbqpg
         akyO6sUb5PZOyZjXvV6CqTmjzTwR+i1Am/Of7ABUa3XCVJiemTj4NsEq46WQwxA3H7XX
         76S+fKwAzCsYobjra3qdVY9EBeOB0b/I3pAIutJ6FSBOg+OoVd+dU0Zy6BUf6wEA5An1
         b/cL8uOPlwNl7xAJNtQfpAXuoVIaw8NLkZ5mdvlQKlYr/D8A04TOeTz5R+QBUJmJuFmP
         lOMA==
X-Forwarded-Encrypted: i=1; AJvYcCX0wAn0Uwz+T1tm3UNkYuwQwpWjv8JJ2O9DsWxfVtZ2LQTGaj+QmVq9jCh9q1Zxl6PTUXcXf4dy/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFCt0kwgURZbhBaJBg//Y/71uF17r4NQLVFBs8azDC0602tVj5
	/mnqeGbVeYicgJPX6kGL9e7H7nxE2Zokl8X2oapJykmlRysU8fq3cqjgZXkX3CpmyQU=
X-Gm-Gg: ATEYQzy8C6SK2BJhnuxFzMQXTS6DtSr4vQJodNGc1+rE2uOh+QLvcYi+8LltDcCTXtr
	/Z2JRNs8HWHpluUfYW+FE8YpS8T9oc75Uqdb5TkCydgz3wmFkSqQi/rpWgAgq4AmX4p9+GG2nae
	hxOZYwgIRzOnmCAs55g4qXywNzcCpWVaNZsGoKrOWA61RJMQW0R3f8saNzC/hX1/8l1OxRm0EIH
	OQlm2KVd+zNvkRTLJLspXhDUqGxYF0LGlOhaROAjkA85SqYEU67iC1g1/qCKrjBf9bxfstjgCKY
	4rEihR3kDU7HWVW8XSYkhCdT9V98WIeePJJksxuHmSRe0k8bgXMf61anD+LghwKODbE2b9u37mf
	dP9dLYHgEjxKnzreIkQGDMOvB1Zhmncbedbiifc6zJjC2LyHAMHjQiooLAEVyw/0fQyJ0hVER1O
	4RlkshrU0Jwu1wucFNbHVPZOa1s3ech4zAdgBN4grXrW5JcPfDfgJSoVCFigFtOjRwUO+9oKOJF
	8PA6Lc8
X-Received: by 2002:a05:6808:11c5:b0:45e:a592:5903 with SMTP id 5614622812f47-46ae0115083mr1837308b6e.32.1775054032785;
        Wed, 01 Apr 2026 07:33:52 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba7184e08sm5165a34.10.2026.04.01.07.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 07:33:52 -0700 (PDT)
Message-ID: <41b94c57-41e9-4273-8a58-3bf6498dde18@kernel.dk>
Date: Wed, 1 Apr 2026 08:33:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: protect remaining lockless ctx->rings
 accesses with RCU
To: junxi qian <qjx1298677004@gmail.com>, io-uring@vger.kernel.org
Cc: lkp@intel.com
References: <2915e619-06ec-414b-9458-92745c76e6f1@kernel.dk>
 <CAAkLyHTws=36DYYf3df=qrbM8a_WY2zAX0amKZutadpaWQuAbQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAkLyHTws=36DYYf3df=qrbM8a_WY2zAX0amKZutadpaWQuAbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12915-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: B9ADE37C5F9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/31/26 11:24 PM, junxi qian wrote:
> Hi Jens,
> 
> The kernel test robot reported sparse warnings on your commit (9d0a7bda72c5):
> 
> io_uring/wait.c:309:49: sparse: cast removes address space '__rcu' of expression
> io_uring/wait.c:319:16: sparse: cast removes address space '__rcu' of expression
> io_uring/wait.c:319:54: sparse: cast removes address space '__rcu' of expression
> 
> The issue is that wait.c lines 309 and 319 access ctx->rings_rcu directly
> without going through rcu_dereference(), which sparse flags as an __rcu
> address space violation.
> 
> The fix would be to replace the raw ctx->rings_rcu dereferences with
> io_get_rings(ctx), e.g.:
> 
> READ_ONCE(ctx->rings_rcu->cq.tail)
> 
> READ_ONCE(io_get_rings(ctx)->cq.tail)
> 
> Apologies for not catching this during my review of v2.

Indeed, might just fold that in. It's just a sparse complaint, but might
as well get it sorted before it goes upstream.

-- 
Jens Axboe


