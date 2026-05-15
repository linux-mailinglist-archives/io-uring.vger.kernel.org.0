Return-Path: <io-uring+bounces-13358-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BZBOUYwB2p3sgIAu9opvQ
	(envelope-from <io-uring+bounces-13358-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:40:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB590551947
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 880C43053F17
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245843939C9;
	Fri, 15 May 2026 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="oedLu+mL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AA7320A37
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778855158; cv=none; b=AlLfAADXEBGRLgg47A1QEeI4eqScNbeBZ4yo9OkFUPSCJgz6X6GPw6yUjJ7/0JaHMI3zLVAPiS7ec4hVYQ5iTUJ3JmgCdtTqR6dNdaVcPyHKUEceEY7bapFxrxNE7mvMi1zA7oTuIKrdJG0rRrtrH2ngjj0ZVUVSGDTbpRn3AME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778855158; c=relaxed/simple;
	bh=29Y0wYJExC+tDsgdL+FXy2jussQ8NgPmHuSQLuRlfwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDz24ml0/tvl+KhV4h5I5+bvXlZLAGljkyw1WZcTfeM5/SpfGhGj5WtbhH3wT32jA96DsPjhMRIwOgzWMuHCj/u6E+MGGUno/l3UG3GI6wZWZcVggkCto7Kx50KdMKnTQ1f7OTxO046ecMUD29c+HFLkzp2gsehBAJ3anNMKVkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=oedLu+mL; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-47cbd444fd0so6110865b6e.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778855156; x=1779459956; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rBE4jEe0xrfGICHOnYQSGqa6swCPVXLwhT/By4Uo0xc=;
        b=oedLu+mL9oixPVHBywotKYkDIA3fwAIOlJYFKud0RTZtJ/a/9qOzhciZe9xVN6djIS
         XlkLQKxf9QkMQByiin1ehq/wDJkZ5SARcrQzyWqaWvcr3riDM//T2mUzcAgGqb8TX2WZ
         PAh4Dbb1W+Z2JR6GmKH1MbPVZdtioktDeavHvQW4q4gXInBAxdTUxuvIJOGZZMizKyVQ
         yqszOE97IFDaXuEwJwTMNtDAbh7GjkQa9DFTI+m3NPQJPbURLwwUGfQ8sMyZlJkzcpLK
         uOQt/L192+OuuvNYtBlfJcDA/yxtKEmn3e8rvJXfoKkJcxPmPSF/a0MpSZ6HR/pl8P+s
         3sNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778855156; x=1779459956;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBE4jEe0xrfGICHOnYQSGqa6swCPVXLwhT/By4Uo0xc=;
        b=MmqEbf+ZUxg898anRGo1M5lqSp2kwxe4wMRpW2s7ShU5diJJMs/WjfKElcztnHyUNh
         la6qQ4ZfdNkcagl1tS3lf17V4DYCtF1OH5oQcAtE2hYm6vmgKJ1CZOz+TuIhetKAlD8U
         g91w3A/sFEEEmJL2zZDNGbedIGcDQi6/jYLCGGFh31374gtbLYudrotuhQjipWO3Q31g
         Q/6u3rbKheBMqKNvmRqUepdnYrm90uN5TMiXirVM/rLmPVFmw/9+jNahsg28C7HmaT2J
         lSG49paY1yi596ud6+PA7E3OexU96bm/WNknOhd4510VoGpiZtD4idEdMejAueZRIY0Q
         SEDw==
X-Forwarded-Encrypted: i=1; AFNElJ8SHJndXp0uz7KCuWhxNh3SJuk7J8Yn/JqeorUWDnkJKdlgiQ2MXzCCLTcCPePQw5YHtlXYkTRkzg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yynt/OkBM2jzOy2oLOlPSsGiX3CWIDzYH29fuU2TqyFwMCJPZKX
	ODahpwM1/oTnkLKTjs37eM/vThCetnOdZ6IzJH4zE3WohhyfQ2sWS6ci6LoFQOos8Ao=
X-Gm-Gg: Acq92OH+9wEsh6A5t+HyFpCuoLuhxh2EQ+WXF1NXxW5dbis08ifh4j/r8OAMl6SL0Fw
	Io1QpI/vzbLa3Wo+SrpgbR5ddzSn34TtYrQC9lBcdMe+eaTxQkhLMdAtFmSJiIxP87ZHwc3UeNb
	8FJur7ESr68MDLTnsmZIOmXe/3mM+YllO/ZpEiunUknjMMIz4nHIaM9kpPMAvDqoS9h+k8qe6SC
	DjYNuHHydj6jgoaQq1KFRUVhKTLf5BEg4jnIJohKhNPSwvhPmTd7GtAFuQq80VGmF7lSOcxWCEf
	6l0D0CoAro5XRgQ3nbW7NLxsWxp9t0hvLQJp1W/7PRS9V1m1DuNeFd+1mN1PNyYClg8K1v4wQKA
	iTFegFEbzf68Fkexw2HGeZijnXHaBpQgi+IsoBaAyrsSXIp/0KsvLMOujV9GfR3MuoRZUzxEhal
	uG/BXCXDenCeo1QJYQEWLTyENkcv+Yn+50eqa4z4K2CNFUBKlMgNvo1HOZ3uWF8M+PDtEyl4OPE
	ik6FUwA
X-Received: by 2002:a05:6808:4484:b0:455:f0e4:4f89 with SMTP id 5614622812f47-482e55c5d73mr2438433b6e.3.1778855155629;
        Fri, 15 May 2026 07:25:55 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55b507cbesm1404344a34.0.2026.05.15.07.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:25:53 -0700 (PDT)
Message-ID: <e6e5d079-25f2-419c-a992-5651ecae26bb@kernel.dk>
Date: Fri, 15 May 2026 08:25:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] io_uring: Use trace_call__##name() at guarded
 tracepoint call sites
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, io-uring@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <20260515135903.2238731-1-vineeth@bitbyteword.org>
 <20260515100448.715589f6@gandalf.local.home>
 <49e77605-6227-426e-8103-329474bf88f9@kernel.dk>
 <CAO7JXPg+MJXF8smC9qXs93YziJT_amQwWKVW38L7F5XdS9-SaA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO7JXPg+MJXF8smC9qXs93YziJT_amQwWKVW38L7F5XdS9-SaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EB590551947
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13358-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/15/26 8:14 AM, Vineeth Remanan Pillai wrote:
> Thanks Jen :-). I can probably send a follow-up email directly to the
> maintainers to prune this part, similar to what Jen did. I guess one
> more version might feel like spam.

Jens...

-- 
Jens Axboe

