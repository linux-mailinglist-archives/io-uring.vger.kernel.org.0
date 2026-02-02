Return-Path: <io-uring+bounces-12019-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Md1Eyu8gGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12019-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:00:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2952CDC76
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7ED70300C261
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 14:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB019372B2F;
	Mon,  2 Feb 2026 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WR2u/SWf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE59364EAF
	for <io-uring@vger.kernel.org>; Mon,  2 Feb 2026 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043934; cv=none; b=Dz1hBpUhRBgyshoQz/ePk44GM12UgLfttfKHkiY+wsUrkQggd7MxNnO2dkM/WZvMoHI5C20TnXi0oPDTFkKWatMY/z3yce3BKoEbWnYTr/T506ASPEAExpAQWhG9tgZ3wtejIZ4/HCQg1oj7asKjII1YAL+QS9aQ068t+GFQlLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043934; c=relaxed/simple;
	bh=E94seAHQMwNegLWsMmbnXYdh94jwQKEpI6XpSo5nqc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bUbugfSCRVCkauBtwqQ66eGBrLH87G5Lg9Vdwfp24vIFY5uFNXeSkjLGfjkSFshPQ7n8IKvduV3OLZ0aok2WOaV2Go+JDlwul8b/sli9WUweeacCS6B2scbeE7jk9SY9DNRQKMlHK6l2LQnKA/+6BcO6/KOzwvEXN/lNz4RqbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WR2u/SWf; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d193b01c10so1814554a34.3
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 06:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770043931; x=1770648731; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V4gLuY5Y57cQq4+OOEVjgP9kkY9Jsj+QHFveQowBo1c=;
        b=WR2u/SWfa8lXx0lABpF/dVrT00j5q7KxeuEJLcbKBnF+Gph2/SVXDQ0bxRrWOEg/dE
         +jJ6/bB4TuZjFnko1hWYtx6iOibJriYRyMSdOMaphVhB1rzPTrKqdMxFce1CCPzm0o9d
         Nq/Q4dG5M7BdOxWDdjD5fZs6CK5hBQPEjJ+Yq5ZsJrJRbCbZxlqKAgLPbfrafPJn7wug
         uvto8c7B6jTj6lIoCyTXaVqSazB1NIveyKrT5Uh8+OQFU2i3cdSNdENvMAuCC/DuY1Lk
         KwcZm9TEhZTkHiaa6AHqmeZuNNxGezo4lEJOnTF44/M9kK+4wYvWX031MRQskR0PZoAX
         AEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770043931; x=1770648731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4gLuY5Y57cQq4+OOEVjgP9kkY9Jsj+QHFveQowBo1c=;
        b=bemD2d2yKV39JOUbYRf/hVfT+gfmlEgAvLASumVcmZ2JY3gECyUOxMsjj6wpaRMYnc
         /tktiGBpRrsXOsucbwzn9u2TmLU8Qs6iedi7vDlZVWjKy6mH9fyFkxClkHvvQ8bjkuYy
         eFOga6OybgwxUFyD7BIS8N2DsFmiJiki2vSX6OMSPL2Gog7JbXpsk8LtEkzYlw3MeKp6
         zDhXhvYlORLQvdxKRwdDvuwod8WSSNQRGjrmXmGkDBJ7h8hs89CoCpjU59PiOYVn2hhq
         1iDoFUvBMqEy8qo7OgN/EzW8MEHeGXaNRODQginE8odNuQwULhTZKSxpRQ0DkkvGb9gU
         egDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeqV2H2VZ3K2UQY7JXyklC5VmJLciUSVKNuJXN9NPKQPRovJU78lER4AM4rRS8Vi8XWK+P6Iiidw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMUOqz1DJLH9Zrjn50i789abtQA1aDXpvlzcm0DIUaqzApCce5
	F9b7RfO7TcLh2dCJ+gOwX4q85PEzPD+Mutr/mHRTflR2dgi+QHrMLgyL9mcrWHaiQ8w=
X-Gm-Gg: AZuq6aJDkGNSuOm0PYYjvuQHhi/obi2EvlOWsK++EuirElhu5YMEBak0QGv9r1P+unU
	YPcP7DvwW90dliWTZGgr8aBlP2gVNT8ZsqsPelMAaR0C/fy5z631Dfv3Sy307wupn/B+OLlize9
	6NjJdjMIgzjLnlgq6vlR1miSfzFcYwA/Ma4ndt5dlHvJD/1inEwxXd3ePg3sG15r1IokqMKt1EH
	lZXoC18POzD9L4GSy6ZyWQ6Q2niYaeF5ouSQqzFEBWaWtB40MoBSxrB8jhCrmKo5D/WL4U415S/
	I2e2qWgxrfjY1Us3e5veL3+vpLiYFHK+lhdULw4KQAgDDLkrGaZbuczSFP2hTReohCpk4h1v+NU
	T+O9/J7sjVVNaIX0tjXczL2KguRJWJl8PSJrXK2FyVGusEIeukbkyRFsZCsCqst0dZWGIkdt7de
	MPfzxYnvVPJlnsK/1WIGDQ8ec0VgHwoRVa99Ogp50rv10liKkRXRUbm3zTHugWZAWGaFTxfA==
X-Received: by 2002:a05:6830:2aac:b0:7d1:a051:9c9c with SMTP id 46e09a7af769-7d1a5140bcdmr6054138a34.0.1770043931498;
        Mon, 02 Feb 2026 06:52:11 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c7cf4f0sm10473506a34.15.2026.02.02.06.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 06:52:10 -0800 (PST)
Message-ID: <25ecadef-7556-490c-a85f-4a4494dd029d@kernel.dk>
Date: Mon, 2 Feb 2026 07:52:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] io-wq: add exit-on-idle mode
To: Li Chen <me@linux.beauty>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260202143755.789114-1-me@linux.beauty>
 <20260202143755.789114-2-me@linux.beauty>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260202143755.789114-2-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12019-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[linux.beauty,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RSPAMD_URIBL_FAIL(0.00)[kernel-dk.20230601.gappssmtp.com:query timed out];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: F2952CDC76
X-Rspamd-Action: no action

On 2/2/26 7:37 AM, Li Chen wrote:
> io-wq uses an idle timeout to shrink the pool, but keeps the last worker
> around indefinitely to avoid churn.
> 
> For tasks that used io_uring for file I/O and then stop using io_uring,
> this can leave an iou-wrk-* thread behind even after all io_uring instances
> are gone. This is unnecessary overhead and also gets in the way of process
> checkpoint/restore.
> 
> Add an exit-on-idle mode that makes all io-wq workers exit as soon as they
> become idle, and provide io_wq_set_exit_on_idle() to toggle it.

Was going to say, rather than add a mode for this, why not just have the
idle single worker exit when the last ring is closed? But that is indeed
exactly what these two patches do. So I think this is fine, I just don't
think using the word "mode" for it is correct. "state" would be a lot
better - if we have all rings exited, then that's a state change in
terms of yeah let's just dump that idle worker.

With that in mind, I think these two patches look fine. I'll give them a
closer look. Could you perhaps write a test case for this?

-- 
Jens Axboe

