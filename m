Return-Path: <io-uring+bounces-13453-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHxFL6ugDWq10QUAu9opvQ
	(envelope-from <io-uring+bounces-13453-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:53:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A71F58CFB8
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 68C8430454FC
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 11:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 526C233B6F9;
	Wed, 20 May 2026 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ZSlSpqyn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F04370AE7
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779277248; cv=none; b=X8H7nrtejx6R3mC9qxwavV5CdQsb/WhTAz9ivrOW4IPm9YTRoJNYa2ff8ONodczNWivZU1cxKIsN5g6wy+i4EHf8NoFTOyQkailw+BFO1TCylLEkCSObeRgZG3RELQOpJwbVNHMJMxrAno63UyY9ifBECWBRCS2MXY+5fBicU3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779277248; c=relaxed/simple;
	bh=JVqcVqCzRl9FvRzvlut3UkWVQD+LeFl5vwBVEalGw3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BwZllMWmzrIlYF4OA1yeBH31ufAgJA3KiV2pXSLqqVKFXO/iQUDmGdArFmaZwia8Wt9/71DwL1JdCzEutRgoabKAo7j9Hv550jqCESmurWPxqJ3/x7WanOTMtbyzIFhnOGhfsjkJjg+Vnasa1ogyFI49A3/ovMrDsdFxXaqFzno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ZSlSpqyn; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43a1004f686so1828068fac.1
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 04:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779277245; x=1779882045; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJL6AQSMLl9+u0hYFPLf47FKOchRWlEKMHwFoxDMDoA=;
        b=ZSlSpqynBnDIqQFJ5fBVRn/OaRjzBZpLRY5ISytFYL+SA0ZkM72P4jCoEkFltWKUTL
         h8WXX3L6YuYrUu9XiejdDpg8XQOfuTJ9aEHWVsJNuMdveCUUNSYexVkR37ANyqrj6903
         CYDiXa8c2tcYDdyUtHj8p1gwP9J8EETI5o41NRXNlsykfl8IpLK9gDq2efoTFyD9z2Yn
         1Qed+9CF8b88ME348j1TBHhUwOac8rMQLpQS6rw/WcdHWGpabO3SR8zAybxfyXl6Mb6+
         lGc2P+NAx1Cv22D17+kV1+snBSimnH3qzSg+nY17jLjE5R4rRPR080NSa4FnJFISg68B
         l6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779277245; x=1779882045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJL6AQSMLl9+u0hYFPLf47FKOchRWlEKMHwFoxDMDoA=;
        b=hS7rTBnrkuizclX/4UIiQ6BUaGWq061XJuyVlJGY26+hBKyq/7hUs1Rp8pMbjbTiSR
         p4cQrvIQ8M0ncrLeMSgQtHJPyjlKOtUafnRRQiDFrlPNmKfs9WIi+Mp+WEJ6oVWTF9/2
         pnSJQr1xbVkVvQGTtciDaAT9ZK+8ce/vmB9lyYp+JMizG83BlAfGYsLo0RGdhXYOZQmS
         L8rkh7NnM8ak83hFQD8VzVssULQvEdf0qBcTqQo4IFtmwQVpcZVJqogixzhwxil5KHXu
         4lYDucFpZbOJ3BBxMO/+Yyp87jNKqDJCyFyH0Wa0VDDbRxBwcC+/S4kMmt1W2uusZC3r
         7XfA==
X-Forwarded-Encrypted: i=1; AFNElJ+OOwznN+H9iEbpEEGtFZi7rkRN71F6L5i70WuqczjXT2DxrIJwS/uupDqtVm1FhMoa8L9vpEzCTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLZMaG3NuuPiUE9ZBcRCiq0DrO69Df3o/xsNFpbDW0mkiye3fF
	7VyjZWLM8Xdzz2Azvha7XXOrOxtV+09TKkeXSQfqUrU4B81pMMwlWCV7wUIqgUvzNzs=
X-Gm-Gg: Acq92OF2XWhLzOhgIg+5HEiZU/WFjQvMEigRRD/luyl66gWN0s4lWn1MGzPI+M5IWph
	A7HqFkE/ftE2subpXHlYG6m7EmH9VmXjO0rl3aF+Zz6ysOil+2Gi6zThZfQD+5TrHWkRnFL9sk5
	p+42HVbH4mSW4IogBqyiFQhtar3xRXPhExeAf4Saq7cTGEzkm5SfQqiUmoF4jz5xUFyvQnOd9lN
	+rumt+R6DZ27D7QeyrUcJA81HUOOsctrxqOwdvb4K/oem6QqXjvtxjlFpmGuUecWxoE3/pl/Lef
	xJyIQvcbGlM4lb9myMmZD2tElO+KUmH07moTeTPmfOKMvNu+TO/dw1FsKf3GRuOSQgiv+4wGUy9
	/933Wi+lf+9rZ7FadAbYfwIot4/adjHHKPdfp/8FoYRZr4R1Bs6Qq3Y5AZAK7oDsd0CqtOmKrfx
	F9C+n8NuJrwXIX64vfgnu6EMUzifbbnlnJuHLlS/QsbTTsMjfngsXpSVkA4sFfNoMA58dBrdW0n
	OgJTdkFAw==
X-Received: by 2002:a05:6870:c443:10b0:43a:d1ec:55d2 with SMTP id 586e51a60fabf-43ad1ecb9c3mr3693924fac.36.1779277244904;
        Wed, 20 May 2026 04:40:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43a957639b2sm9692661fac.14.2026.05.20.04.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 04:40:42 -0700 (PDT)
Message-ID: <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
Date: Wed, 20 May 2026 05:40:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Maoyi Xie <maoyi.xie@ntu.edu.sg>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260520111944.3424570-26-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,ntu.edu.sg,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13453-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 5A71F58CFB8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/20/26 5:18 AM, Sasha Levin wrote:
> From: Maoyi Xie <maoyixie.tju@gmail.com>
> 
> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
> 
> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
> timespec from the caller via ext_arg->ts. It arms an ABS mode
> hrtimer in __io_cqring_wait_schedule(). The conversion path in
> io_uring/wait.c parses ext_arg->ts inline rather than going
> through io_parse_user_time(). It therefore does not pick up the
> time namespace conversion added by the previous patch.

Once again - If you auto-pick this one, please also do the other one in
the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
do just one of them.

-- 
Jens Axboe

