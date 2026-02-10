Return-Path: <io-uring+bounces-12132-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENJXDL+Rimk1MAAAu9opvQ
	(envelope-from <io-uring+bounces-12132-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 03:02:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8813011622D
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 03:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 824AD301184C
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 02:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD29D28934F;
	Tue, 10 Feb 2026 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nkdMyLeb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1B18C933
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 02:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770688942; cv=none; b=ANoaQT9cUl2dGh7N55TzhApgbCrKsuiet1BpZ7WG2nZ+4D4eWTF5sVIbM1fdFtSU9gLYHMDye5Nuj7veH3pdmlcRtv15zy/y1xpnU6B3+In+QqjHZuP2DcRiJQpAt/+41QpGyPGiIujmM3Y1RCB/0ZgGn5uQYN/GJzRrwf7W438=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770688942; c=relaxed/simple;
	bh=r0iiu5rwyMB6QLtbqGJBjUrULt31Ag/SApgdpjhUZi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s98v/UPEyuilZNSnoAj3ybbhfcW9PyYCYr1QdbsHASbaeaRn1hc7yEPRI7T9dBeS7F5Pgh5psYRkwIjHmnQYrlaNK46sPDQ9MiPfijESu4SCBnIYbuXhYnPUD/3CJqQkyR9n+8Jvtu6lZy6dfcRBRw3h6Vke24b/nSVMTIGDitM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nkdMyLeb; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45c838069e5so3472844b6e.0
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 18:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770688939; x=1771293739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GjQoOzcqzmJYA+DqiTFJOeT9fSVlSiC3IFA3ppg6RD8=;
        b=nkdMyLebCSEk07bGksGaUKBk1qTtCnrKLL/8l/KSs4xJDkgut0vTG7XQO5eVlQ4Wyq
         HqdRsJy9zRn56wx5mbi1Q0Yy9+pp4JHBAgf+Dfced3Mj2Oed4fjk6bEh9qXooY0zMDTT
         cvLOuhFPYm9yvPUsqlKJc/no0Estr0AAJjKyao/s3ow3Ndq7vKFtVURhJ5WqA8qo8a+K
         KGSm8vrclF542x3EsPczCz5nbBTF/usDE3JpqlD+wbwLBDt9mBEXw2nwpa6RtphO59Gz
         V/3rLjZSbJ01WZPzHIrU2mu/6lHNS5vGHUYNpsQyhjmj0gYRf80ed5Sjms1RnnsnCiYw
         e1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770688939; x=1771293739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GjQoOzcqzmJYA+DqiTFJOeT9fSVlSiC3IFA3ppg6RD8=;
        b=Niltz2H7Rx1gsHEDdHZJ687xz3FPRKAc4fLozLVm8Bpi24mekvaxyuxZDfuYxDuMX5
         phSnKUEgDZCr7tlf23/JiNSMojh+rGH8GRjgao9syEN3sN3Y4K+J6wWo4DSlmE11G8Dr
         FM3m82IyOE8K4Nv15/ID3TolWJLIT5V6d2Yp74qWrYYRzh/1FU0SB5OTeVTaumWzOKyo
         OS774RS1dstX1INcFWuuKEb2TIygV0JuqcBf6zoMkgdi4KGAtibQbKTfYBKZyw3iMqS5
         e0c46WujPI6aQtTWOQwx3iEZIUe5y/1D7lrCgyFU4Ykp1hjqb+ILoXQ9EhqvRVy5lerr
         SrZw==
X-Gm-Message-State: AOJu0YwUIzabTAJbYWS/FQXpnaG+lmeBy5LAjFSbIpIahwhSxTLydwcb
	zmQd+4ujrXxAmZOhvgyyTwkx1mGCub3NHU0+WslGLdQzR6DwYCkINDelZtLERoK40UW+KKANo9d
	xqLg7Y7A=
X-Gm-Gg: AZuq6aLqei+oXFklgzQX9Fy5RVTb8zcR7rf4oIc+RQNlccEXeiMKy8Uu65hKvtpvbUY
	U6haAPfOnCEjeA/Q2vtOh15IBIeRuN44yinzU/Wo5DegQMr1xeHpG02PXVqgLpB+YwQaoo4aXF0
	KKh2W8fbSUjE/Aa4KP8oEl3seVVimonOvtv6NQtPs39Vk9PxBQ68O78vQgYGpnSUFBhcObuGB5L
	fZuAcO8SS044b6vIyEFo9YH1T3qFkUViaHOkEuTzhynEukzUO1Ei6nF1RRREtWFXJFCdqUeO3Sc
	DszfkvyEQ0F9xNgLstMSCP++SqBwdDMJ3Z3F1nyq9X9bt/E/m71FmdhRXqydshpitxfJroSbzQF
	aCwd4EAoQtoN2Yrmgonp2HPS8UjWUlMJA2W+NOwBLCaLMSJyel/NWU2oLdqarnjHujVY5UVszoS
	KFJG7S6G31zEgtlXUNNhoMvwSWroS3B5byhV4M92hsH8EJBisnu9DHfvTdbK81uiIwntltvvm5z
	61ZBgJ+JJfuUKi8MPHG
X-Received: by 2002:a05:6808:1446:b0:45c:83dc:fab with SMTP id 5614622812f47-462fd051fc2mr7699785b6e.40.1770688939404;
        Mon, 09 Feb 2026 18:02:19 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d464785fcasm8408048a34.17.2026.02.09.18.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 18:02:18 -0800 (PST)
Message-ID: <bb055dac-8530-41ff-892f-31c704f22a8f@kernel.dk>
Date: Mon, 9 Feb 2026 19:02:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/tctx: prevent loop variable modification
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260209061919.425074-1-yangxiuwei@kylinos.cn>
 <63b52c5d-5c8c-4085-9d90-12374da974e3@kernel.dk>
 <20260210013143.1791381-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260210013143.1791381-1-yangxiuwei@kylinos.cn>
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
	TAGGED_FROM(0.00)[bounces-12132-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 8813011622D
X-Rspamd-Action: no action

On 2/9/26 6:31 PM, Yang Xiuwei wrote:
> On 2/9/26 5:42 AM, Jens Axboe wrote:
>> I think this is fine as a cleanup as it makes it more clear, but I fail
>> to see how you can ever have this cause an issue.
> 
> You're right - this isn't a bug fix. The current callers already validate
> bounds, so there's no actual issue.
> 
> My intention was code cleanup: avoiding loop variable modification in the
> loop body improves clarity by separating the logical index from the
> sanitized array index.
> 
> Sorry for the misleading commit message. Should I send a v2 framing it
> as a cleanup?

Please do, the existing commit message is actively misleading. If
something is a cleanup or style improvement, it should not be implying
that it's fixing a bug, let alone one that claims it can "cause infinite
loops".

-- 
Jens Axboe

