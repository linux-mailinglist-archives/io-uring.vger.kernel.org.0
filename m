Return-Path: <io-uring+bounces-12738-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOJzC1z/uWlBQQIAu9opvQ
	(envelope-from <io-uring+bounces-12738-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 02:26:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C19E2B4F13
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 02:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 211B9304F20B
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 01:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BEA423C4F3;
	Wed, 18 Mar 2026 01:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1jWhFq+c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01CBE55A
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 01:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773797209; cv=none; b=K3o72ubr4z5GIvhJENDErNvB27dyK9Hesy7KSqzcruFX6Pyl+Bkm4OQoPwK85ulnHn8Fwm1l5cFNXZy6hsHGSgvz3fWWaPgUnMci1ivv8kAxr5GGVkDMjJnFKCM+gpvuSaQu1qXimdi/QmnvHo7TIzfa53PgyMAyIFAapDnw53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773797209; c=relaxed/simple;
	bh=lws6mUjxOxt894KC8EDa+YmeqMZUPxAoxc5buAqlavw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdNHerHazEqaPYineH8B+4fg3k24QD3HZKZA5fuFaCe8jo4Cx1SzZToiTdfNxqhxI3cfsqVfP3V0D+E8XZfLRu9YdENfXtvC2McelK+hR1nbF8v1E3/sKqGJ8xrHFDzNcVKOaU/RL1V3WP7Nvqr125x5BjwuIdsS6ldHyQ/VRsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1jWhFq+c; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-46702742c99so3948576b6e.3
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 18:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773797206; x=1774402006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+wLngegFvX4b1A6M7gXF8x6LDEglu2szAu+mVlUeGgM=;
        b=1jWhFq+cVF1+B8ujcanJSEixAu3uy8eRNBbmLH/3dX/rif9OCW/Sj4Hw6806WYpgZw
         EPvKkc07HeSiv+2a+APiEHg0G+M6UuszAsZKt14HdJkqenKXtP/0nq7zc0o1VXdkOQ5/
         1sP5s+kE7ur9t8U6+oZqmPLgKfC2FgpC19OvV5dNANrWEo4DfzkCkkKTuKBpJBDkn0iV
         tIupwYLdWK0+5VrU97gZwFX6NVEq/eXiykR0dWoK2I6OnIPkkR5g+DoQhOVC8lCYuvSy
         v9NPF7sDrqlsjZGBxCyhqa3/hxbZd6Z/x78p3LZJA5Jsl0dwEUal2q2jiHLd5vQdQuGh
         XNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773797206; x=1774402006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+wLngegFvX4b1A6M7gXF8x6LDEglu2szAu+mVlUeGgM=;
        b=Q3Ti0Xmkm0En6LE5HzeeyaBtN5Uariw604IiPuZq3CSiFR1AqYAmnAtKIl6Xz9pdDj
         x8JGxDbr2TGtHd2bcL3YD34T9E0rHNj14lALXqypywkOoCDEljISIdyt2mOuu6VpS0bu
         PSNy4C2rPOHXqfV//QgjLdgNwBJWn/wfQHA2OTmaMPnVxQ8E+7COOTuzP3sGNPKj/5kW
         xB3YU6P2TNIkIXj124TOS29ig93szNUyg38IQflr1ipT3cp2lvHqr6hF1njR4MAvYckJ
         8qIUKbBs4pB7HCmf3XbZD8fHMYWyghM/dNCJBk9O+4Mu+QYmEgxgKjI/zeTkFHTZmHlp
         75Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUKggLCYBf6xHA2zHyVsS/5eEPdxHPa2LWAgLOhhSAHL4ZaSiZlfg5aDOm5cuSIzdkWwGZ+qTP/dQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx2aQQhZLX+Rb0l1YXvSfzRK6SqoB4ykVgRJp1201BzawUsUPC
	zriAq1dg/Q5LLD4JegisNQrQ0Ukf+Hj8sncyAyhMZ3OXVdGSRU0G/Jrofs+OiTaXM+A6jY13ra5
	By6zi7II=
X-Gm-Gg: ATEYQzxHokUtBMWQQSIbxv6yNnk0+ijE1xiWDQg/OmQvVf7BSn7Xhd364Kqg0WeM+tQ
	fDdQ0DC1nP8Tf/p4aqsLF59K9SBso0YoQS8AhkHumvn5zd33qXXrr55Ccz2YX6XW+3V7MdiO9ne
	/6OlFphE49pINYSSm4eaIUp3LLH5y1CpM+LwogbrCj0BX+ij6qFBg3t12+6y3ovfvPQ14GyJzn5
	f0y8ZbvXeEbA3/gDkklklMdy6P1190RN56Cs/TBjwn3eu2hawyP2i6Tg1NlRqk/PDTQSyk94Us5
	VKz2EHtvBEKz57mDMemp8MUtkgN3LOz3PAGxSSPRuQXGPwsRz5zTGJRkuPDOM8R6TPW64QVXXl4
	Dh2EmZWHDQ1OuMNJu7aJBItOkQzYDPA3aAbsrapS5HjuMjFAls4yWzkfxCNlsosteHmG4hDDv/s
	ERXPhGTuTJXL3nywaph1OOOc584EuPuFxHJ945HbWRVepOnEbT++m8eQOSI/vtzb3UtvWqZu2Ya
	MYRHq2nIKq0nBnXrPNA
X-Received: by 2002:a05:6808:1308:b0:467:880:7441 with SMTP id 5614622812f47-467ba105148mr976117b6e.18.1773797206154;
        Tue, 17 Mar 2026 18:26:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467baa8dc58sm800637b6e.12.2026.03.17.18.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 18:26:45 -0700 (PDT)
Message-ID: <d5f37010-dc05-4057-a913-84ec621c5ac9@kernel.dk>
Date: Tue, 17 Mar 2026 19:26:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
 <177369928494.700746.8101380068186003544.b4-ty@kernel.dk>
 <307e4126-91ed-4ca8-9eb0-3f24f1490aa8@kernel.dk>
 <CADUfDZp-Fq4TAdOcvjwSO4G3sZzekzVsyT_yMsoC9D-2=5aLyw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZp-Fq4TAdOcvjwSO4G3sZzekzVsyT_yMsoC9D-2=5aLyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12738-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 7C19E2B4F13
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/17/26 6:47 PM, Caleb Sander Mateos wrote:
> On Mon, Mar 16, 2026 at 6:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/16/26 4:14 PM, Jens Axboe wrote:
>>>
>>> On Mon, 02 Mar 2026 10:29:09 -0700, Caleb Sander Mateos wrote:
>>>> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
>>>> requests issued to it to support iopoll. This prevents, for example,
>>>> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
>>>> zero-copy buffer registrations are performed using a uring_cmd. There's
>>>> no technical reason why these non-iopoll uring_cmds can't be supported.
>>>> They will either complete synchronously or via an external mechanism
>>>> that calls io_uring_cmd_done(), io_uring_cmd_post_mshot_cqe32(), or
>>>> io_uring_mshot_cmd_post_cqe(), so they don't need to be polled.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/5] io_uring: add REQ_F_IOPOLL
>>>       commit: 9165dc4fa969b64c2d4396ee4e1546a719978dd1
>>> [2/5] io_uring: remove iopoll_queue from struct io_issue_def
>>>       commit: 7995be40deb3ab8b5df7bdf0621f33aa546aefa7
>>> [3/5] io_uring: count CQEs in io_iopoll_check()
>>>       commit: 3a5e96d47f7ea37fb6adf37882eec1521f8ca75e
>>> [4/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
>>>       commit: 23475637b0c47e5028817c9fd4dabe8f7409ca6c
>>> [5/5] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
>>>       commit: f144dbac4b177cfd026e417ab98da518ff3372cb
>>
>> Caleb, want to send the liburing tests and documentation updates too?
> 
> Sure. What type of file do you recommend using for non-iopoll
> uring_cmds? Most of them seem to have relatively specific hardware
> (e.g. blkdev_uring_cmd, nvme_dev_uring_cmd) or kernel configuration
> (e.g. ublk_ch_uring_cmd, io_mock_cmd) requirements, as well as
> requiring elevated permissions. Maybe io_uring_cmd_sock would be the
> most general?

Yep I think uring_cmd sock commands would be a good choice. Bonus points
if you write the test as such that we can easily plug in future commands
we allow with IOPOLL as well, as I would imagine we'd expand which we
allow going forward once vetted.

-- 
Jens Axboe


