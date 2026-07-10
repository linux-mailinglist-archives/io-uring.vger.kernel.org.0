Return-Path: <io-uring+bounces-13927-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9dDyFffuUGrb8gIAu9opvQ
	(envelope-from <io-uring+bounces-13927-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2026 15:09:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D74273B174
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2026 15:09:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="vkHYI2r/";
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13927-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13927-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 691EE300734C
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2026 13:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9C442B324;
	Fri, 10 Jul 2026 13:03:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A5C1DB13A
	for <io-uring@vger.kernel.org>; Fri, 10 Jul 2026 13:03:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783688602; cv=none; b=iWkyu1trhMu31kWvGPa2SLtmDZd1d6jxJBBRDR9loofXOf2mYI+zzHoVncgmGHc0u0pnPHY28sx0dYzytCNbUO3LoW6/UDAu0ZFN3cBY0PUoOtZO5iJzS5fY5EhLUZ4gqra01+3SgnpDq2gk+eJ8yub2HG+is2HjfEkdrC6Vn4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783688602; c=relaxed/simple;
	bh=A5Ml02DRgrqpt0RhhLWCeNmYpxshEtOXGwmi0wKQ+J0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dvk/c03MsfIzNyw6g3KoMuIAxDdyNahHreRjMt4DfpjAfryemGVtMupbSI54uBqPV030SxJQk1x+yIdDysR+MgpWvs8V8Bhz5N8sHBy1Jch07JXsFMElDCJfKJmIh1h+mWDGPbyr0bkQ0Xs4CBBr7HuCN0ZmmCjwgZGunmflRVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vkHYI2r/; arc=none smtp.client-ip=209.85.161.45
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a1888969ddso545665eaf.3
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2026 06:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783688599; x=1784293399; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AXDUBu3394gYScWwI1t5FfFrD6OkXTPwEpvqTOElS9E=;
        b=vkHYI2r/uQm9fgPjVZkFbUXIM1b557BeD5Helybn0LA3sw212cV0omMAEqeGU2t9C7
         u1BBEwxHB4yHmLFis5F76ufSFaNF8TjP2HG/8RQWzCAoUSO1B9SuMooTE0fQwT12p5bM
         SYu1aZ1NlIkGcXgkMe0Ck0mOVfhH/uwWpisrQ0QWD4rGrD+TK1fM+pvR86BYuwe7OTP1
         uJbASdaqTN7g8Wti7xixUZ5B2k5M6zu2bEzRW4rxNIhJsxQI9ykdhCZopLy8CwRvtovt
         zxrYn22GuYPCFeQSzZPpscfUFsesPYoTGI/yLkNaCMDhGoVCz0E7EYBWn9KDE2b5qzLd
         jvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783688599; x=1784293399;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXDUBu3394gYScWwI1t5FfFrD6OkXTPwEpvqTOElS9E=;
        b=DK5YlcufNIBMSTrAztXm4yj+8j3FBwR9Pyr5oLVILjawrmsxxz/yl9giBLnTPFW803
         +SEagXshcSQJBDo7E394ekzWRjQipiXX9qD1warGcWGZHjPZ9HHBbED8EN4V622B74L0
         uOlaU0nwFP9OHCNQn1JpV0jkWpvuUz75xQAbeUo6z4pzAjgEczhFuXgoFTXPcVpApUia
         MP+qzH8MiasNCD0xVrn9r4kZHgsrvL9FYC4FSCwQs9yb6F9XgNCNkSDhEmfmD3uOxPbw
         0RZ3lRcKecQKKcYNNN5LSovz/mGWErWr4MFG1lkZ+u06j42tDqGrwm4lKolpeE3/RtZ0
         hfFw==
X-Gm-Message-State: AOJu0Yy2/wVmBxNgbkSAEzYKF50w2DcpfwRPYEnwiDxC4CXlt2ADcyWd
	tRyhq6Hz0WGcuMRhI1sNqn68XeOy/TgvENFZ9FhAMXsYfWagKYUtbvIqq1CkEQ8/fb8=
X-Gm-Gg: AfdE7cm1D32lbbFYWlCebvcSm6z79WRb2JMzbXlNWLEtiVBqZiJvkz8ZAU/KGEEcVAs
	gQ91+ujh+4oBCk/t7B4mK47ewEY1g0nV0t+GwTC0zuFwkS27IvUYv0/2HtHnwZTw5CL0HtkKtEu
	FPu2xmjd5/xZXmQWsB+XNicz1IWuftRoOqKgeKzAV76IeYWvIfEwk4gtpORy7m1d7jAiwDa2aTv
	TdkmtilxJIE4ta5gkEGktJVWZR7k5sM0QHrHuAKKc/VYhVdEi4twUjjEdBc+gYQ3rFZjHwlzuvg
	5J0ufQkolegY05DRkEc9+Rf1RLys9JrthYW5xI53pMQuefOtltW0kkZBm3pv67R97j5lBeL1TPt
	Vl7HBl+ADHXVIwuidMvfTegKz8ZtCawmshsEr7RoEp3ZEvHxniIaIcbNNcipNz3As/SmD14d8re
	r+o6Y2DfFnBGjVJ+3S+2giz8kUf6pYNKO1C8x82bXIIv20EeAzcUI5fkCo1sKj93pZOd8IZa0=
X-Received: by 2002:a05:6820:f00e:b0:6a3:93ee:17b1 with SMTP id 006d021491bc7-6a393ee2940mr543087eaf.4.1783688598637;
        Fri, 10 Jul 2026 06:03:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a38b9ccff2sm1527126eaf.3.2026.07.10.06.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2026 06:03:18 -0700 (PDT)
Message-ID: <7c885746-3787-4ca9-9cc7-6d37be60faf0@kernel.dk>
Date: Fri, 10 Jul 2026 07:03:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] io_uring: task-scoped restriction/BPF filter bypass via
 blind register path and R_DISABLED rings
To: inging gpt <inginggpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADP9gEjyKFtb5LbZnrFDNUWONMos7TtTeUGL6hW_FEaTe3D=Cg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADP9gEjyKFtb5LbZnrFDNUWONMos7TtTeUGL6hW_FEaTe3D=Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13927-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:inginggpt@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9D74273B174

> === Bug 1 (strongest): blind register path skips all restriction checks ===
> 
> io_uring_register_blind() (register.c:1001) dispatches
> IORING_REGISTER_SEND_MSG_RING directly without consulting the sqe_op
> allowlist, BPF opcode filter, or register_op allowlist. The blind path
> has zero restriction checks.
> 
> A task that installs a restriction denying IORING_OP_MSG_RING can bypass
> it by calling io_uring_register(-1, IORING_REGISTER_SEND_MSG_RING, ...)
> instead of submitting an SQE. The message is delivered to the target
> ring ? the forbidden MSG_RING operation executes. No restriction
> configuration can prevent this.
> 
> Root cause: the submit path (io_uring.c:1792/1893) checks
> ctx->restrictions.sqe_op and ctx->bpf_filters, but the blind register
> path reaches io_uring_sync_msg_ring() without building an io_kiocb,
> so neither check fires. The register_op allowlist (register.c:767) is
> only checked in __io_uring_register() which requires fd != -1 ? the
> blind path bypasses it entirely.

This is nonsense, they are two different things - one is an sqe op, the
other is a register op. The filter supports both, you just only set 1.

> === Bug 2: register_op allowlist bypassed via R_DISABLED ===
> 
> The register_op allowlist check (register.c:767) gates on
> !(ctx->flags & IORING_SETUP_R_DISABLED):
> 
>   if ((ctx->int_flags & IO_RING_F_REG_RESTRICTED) &&
>       !(ctx->flags & IORING_SETUP_R_DISABLED)) {
>       if (!test_bit(opcode, ctx->restrictions.register_op))
>           return -EACCES;
>   }
> 
> For ring-scoped restrictions, R_DISABLED is a transient setup window
> that ENABLE_RINGS closes. But for task-scoped restrictions cloned at
> ring creation, the sandboxed task controls R_DISABLED and can simply
> never call ENABLE_RINGS, leaving the register_op allowlist permanently
> unenforced while still issuing register opcodes.

This seems like a minor oversight, send a patch for it. If you can LLM
your way through producing all of this stuff, at least have the courtesy
to also LLM your way to a patch.

Ignored the rest, because it's also just fluffy LLM garbage.

-- 
Jens Axboe

