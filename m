Return-Path: <io-uring+bounces-13129-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ExEErJB6WkmWwIAu9opvQ
	(envelope-from <io-uring+bounces-13129-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 23:46:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4376244B19A
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 23:46:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6C1DC300B8E3
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 21:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB02D39F172;
	Wed, 22 Apr 2026 21:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="yTdPxSJw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03D39B484
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776894378; cv=none; b=kemJ+zACTJqukMYvEpmUrUcvSbz49vhDgomlgi5jkFNia6qv96Vmol5036YzZo0oPeOUG50ckrySvpVvxfL3/Hgy/fSgc/0PrzhJWnwsCWORHCYLvkys6SaBYAalsyLEo7RmERS++HTqAJ0SG5ejCgfEqCCP5M9BCUCXncyDvHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776894378; c=relaxed/simple;
	bh=mDI7Vjyn+MmdI5Ki7u3cVQG4QQJJEz7okKKV7f5Zjl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gOiDqVh7UdKXumclGx7gf6eg1YaDwnpr9I1ag1ryR7vjq9kPTw3V+TMOHUwAEARa0luSKi1n5K38/rUUngGz1bNirPXtzO9CvXgYFk/4xikHEFXib4FC4pSu/H827PitR7EjvS64MK/sDjrmzTsxHSKgK9jsYV+mL4nZsjPWyKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=yTdPxSJw; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7dcd89701acso1790778a34.1
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 14:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776894376; x=1777499176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=juHtPyL8wYmJtBKQBCsxkudJRJvHy1FTueInpPwYCfI=;
        b=yTdPxSJwfc0thXGvISfLvg5UOpUh9E00tyywV4euqJeB0D2yVKqfP0cTLnN38X8uh9
         c+H78yugiGkehh02pwKzuvwjBM1emXAz49HCuVPeoimx5eZVnn9wBWnN4q+ye1Htbhyp
         lwL1YcPjHkFULJU8ypE11P2uhOySDEo/6MfgELOrcs5muZaCtFmNYzCDZvCekhQyXi7S
         DBx1JUAnnX5/6YhiqYZpp/yO36Uja3AR0Hs6kTTiURGXYEnc5IdKbdVrPFE4LXSIf5dL
         yKpUfcjDzVYRn6NOBz4YgRPKXIetramsecsb9wrr9wpgP+QKuZThz5rLIkBmbmHfpV1A
         s0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776894376; x=1777499176;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=juHtPyL8wYmJtBKQBCsxkudJRJvHy1FTueInpPwYCfI=;
        b=j7Vi1UiELBXMrEcixeF54y957NrNgc+VOltcSYP7Im2OX4sBzA8YW22xkpfAQThkqx
         lYV05HiBI96mabhS1X3Rtomm8dIwaKst988XG+PhpUHG+IckdEWbIMlpXLkw86veRHcA
         kjVK6sTvvc1zeO1jORkevZuXmgoSW++vQiilrJ1qc6/ebWRm0TT/mtFES38SSRYtStxN
         L3Bq8cMZbkhk4mZLPCiV5hWa9KYYDzExd3IdOeNyIFEip3oOizFN0lJDMj/8jdYDLAYS
         N4E2bfPVo7DLaEb0jYeZP0+40VqEBhdkOd4zXC+xHqQpKW053WXn1JJIwoMI8zaZRNYA
         e42w==
X-Gm-Message-State: AOJu0YxKIOEwdsm0s5z39kZ0tAuQdJ4aSOu1tQgVhHOhaYStUP8GkD0f
	wi2S2fwd/TGQ8ZX+cOG3UbaFnVOkm1J5RsgQJ/zeLc7lnUkXa2pexeGYSRTsKOWLnFE=
X-Gm-Gg: AeBDievgPFIGrKHwzf2xMC65RHZeMCdAHYSfeiziMaUQxOsU+uV6wuMLB3x7b6dDVI7
	HsnpcQleL0vbMxncSJf0RI4qeAivkcOMVJCA18eHXHeovPvwAw+/D2M5t7H2S0u4oSi2JBfTvvr
	HKvXqmx1V8MOoWANyvNEF7vxhiNTuvgdHEBL90R0r/CvJg2qrtMQaXtkfUsbRtTrP2da5UbUicL
	64/va4mYECukHYgtsMW2DZL/pS6XnULoXZ7aMNq9sori4IGBajJ5lU4UcZL//dZA5J0kyUZQBjo
	St92VlKsJxqj0aRfuCOhUgc/DKtxDELe/oggju/UyTNzY71eX7t+gdnTkSvkV3QHh+RUjZlVlMJ
	UNSG/cRugPWWVB6sY389OA2/GmprIwyIuQJmoduQivhGHQ5JuPaKctJEFM6U1gJTKxzto1eUUuN
	3dW/lIr9gAwiSgncf1uhIXHNsnVIPFsvcgBBmmRwwX790z1mOdPYboA0E737EFv9oS5ctKRoPTt
	K6ysh9yNX9T0fou7o4=
X-Received: by 2002:a05:6830:dc7:b0:7d9:7209:4378 with SMTP id 46e09a7af769-7dc951c7513mr14266727a34.17.1776894375664;
        Wed, 22 Apr 2026 14:46:15 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc975b057bsm16345408a34.20.2026.04.22.14.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 14:46:14 -0700 (PDT)
Message-ID: <3296879f-4650-47f0-9186-f5482a598239@kernel.dk>
Date: Wed, 22 Apr 2026 15:46:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix missing submitter_task ownership check in
 bpf_io_reg()
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Ali Raza <elirazamumtaz@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <20260422-master-v1-1-e82f47558345@gmail.com>
 <87eck6ofo8.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87eck6ofo8.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13129-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FREEMAIL_TO(0.00)[suse.de,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[104.64.211.4:from];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[100.90.174.1:received,96.43.243.2:received,209.85.210.45:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 4376244B19A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/22/26 3:20 PM, Gabriel Krisman Bertazi wrote:
> Ali Raza <elirazamumtaz@gmail.com> writes:
> 
>> bpf_io_reg() installs a BPF struct_ops loop_step on any io_uring ring
>> the caller holds a file descriptor for.  io_uring_ctx_get_file() only
>> validates that the fd resolves to an io_uring file; it does not verify
>> the caller has authority over the ring's submitter_task.
>>
>> A parallel path in io_uring_register() already enforces this:
>>
>>     if (ctx->submitter_task && ctx->submitter_task != current)
>>         return -EEXIST;  /* register.c:733 */
> 
> How is this a protection?  I thought ctx->submitter_task is about
> IORING_SETUP_SINGLE_ISSUER. there is no permission or capability over
> it against other processes.
> 
>> Without the equivalent check in bpf_io_reg(), a local user with
>> CAP_PERFMON can exploit IORING_SETUP_R_DISABLED -- which defers
> 
> I'd argue this is a non-issue.  If you have CAP_PERFMON, you are able to
> mess with the process in many ways beyond this.  Otherwise, how a
> process would be able to get the fd in the first place?

It is a non-issue. It relies entirely on an unrealistic scenarior. Yes
if you have a privileged task that can take over a non-privileged ring
fd, yes than you can do bad things. News at 11...

-- 
Jens Axboe

