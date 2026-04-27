Return-Path: <io-uring+bounces-13146-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGjVKsUl72lE8AAAu9opvQ
	(envelope-from <io-uring+bounces-13146-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 11:00:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0C346F7DC
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 11:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40BB1306B126
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 08:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBDA37C0F6;
	Mon, 27 Apr 2026 08:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pqy3ZDz1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748433537FF
	for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280161; cv=none; b=rnDl7T10mSntfRtX/noWb1Eflp/ViZtw1hY5od4dtpfTV3DyQlv6wut4iLepAMgig0kpHTzWZbxN1nR0gj+IlSOKVLNElwl52SqfJuNBQclceEBiANZKXhNtZX1SJEcB4uYBAhOzEgk2XE2WdGt8txhoUWs/FGtb5ZKKznrMF9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280161; c=relaxed/simple;
	bh=nSyNAYP9VF/vH2DSSAUwmYJlU6QfNhzTTn25r5ShNpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cIGBErkofXQyZsUcsnAPleFjT+bwgC2KNRb3OI3Xp31p35RQW+AnzyK/DKGG4ZqDpOpfXQFDjwT0sxvSvdVMGwlUuQyzsWR8xT5AdZJ3qohinVNK07Z0nllAuAiBnskofKKcQaLxjuXQ/Ds5Mx8XYLSA/Jumvea5xsCYnBpMoeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pqy3ZDz1; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso51375435e9.3
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 01:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777280159; x=1777884959; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gg8xcE5nVzUCLwlpOgMSnuz5hEr/6m+rEcYGBUox7Sc=;
        b=Pqy3ZDz1tTR/rf+VytVOaA6RPcjXIe33Qh/JhNFS5gRt8z44ExeSONgjfycO92+tHx
         hnVv3K48lGvo/gnrVk/t1+BmIKatXrVd2MEko20CZxecm/i3MMr3ejHbntqP2024TgYn
         xvP3lSS+Lmxd7IjADHxmNiAEt/0zEeXKfAxtnqNqzO4HNX5vzgFaJos2jY/DpV/+PeT8
         P5SRX/cAf25frpEx0Ofiinc/WZ2O1ifpNvBfr/gN5hI/i9Uc0WGnBSsNyslbXOOOPNiU
         aKZs9+Hi3hdBRx2r4roWEXUfCzYf5BVpJPdG+2Zyo7K+nqmhRQm146+Hd2a4Y0LCAKR3
         ChyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777280159; x=1777884959;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gg8xcE5nVzUCLwlpOgMSnuz5hEr/6m+rEcYGBUox7Sc=;
        b=KO56EOH1LYbGlL327FBphiWnL5ZwwMOvTyrIUvFouZkR60xt5urcay4fbCTTMzbxFu
         ZoVTfL6OYdV7qp8VzSYzuz4Vsb6UI9lx7F6NA5okKJpjlwUn/fTu4p6QEzUSQp+NZzeC
         GWTjx2PuxvRLiys46ISu64th/Ix26ZC8djuIR2awBHpi476LwvNckvjSiliknHrZ2p0C
         jL29RK7Br/xzMbPk9+BWk1OHYof0oGAf4bXK/EBmEi2ElyqA3oy5rfRuUNzs28wnP+gE
         YWFa0tcSF2Sukg28WEOFcY3p4pjcVnCFehwYxAHhG7SJzlVLCXpGmhoPzOqGOyWrqDyE
         Gg+A==
X-Forwarded-Encrypted: i=1; AFNElJ+v5a9XEIDmxWCvyvozwkM2rI56O1NAFr7IfTt8T+VOhYnjkUu9X4cbqqlWnrx9E84O86rLOYJMVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0a0iy9diS1ouU4doAokqU6vM4Pxsm5ct3YeSdeM8Vs11dbgJZ
	pc1t1EOT3iHDg7wykFovjdZuXz91OUO0wArCKbHL26WFtY0Z7V8lqOY4
X-Gm-Gg: AeBDieuANB7ptdZeJLiIwEtH9uBLeiyH6kAH7HRv0jGX+DL/gqidj3keF44L/Mjb3DL
	QFP5C4c8+c7g0nLP7If0ziOeyTBjyD3R2FGAcz+D8Il73T58v1hjbuVv+16O2GnJjc5X1DharE3
	lkSh5h/Z5hKDpHo+QhBhIZS2/ecCjIdlcqHJEja+yWUBy0Vj2FpeP4S5rM/51qDYAAEgSRjbZAk
	azePz13xclVfAXvj1ninG7wxq5n2NlVk3WrIlXrIGeI6A1xnCK9NobQ4CeF0hARee2j5Bb+plCe
	BHaY9j0nu5URW89AgVprZ2FjZxedHQYPfDJ/eaAWPif4K7ssM570bihS1PNkPCHVUtfzMV6Ua1H
	AiN1P8HnxK1jL0tvyesx1PuEdRZpuFJXEXRVDqyYJosOfvUuBVGKTclPszYoYvuP+WjiQrw3GeP
	CdCL+zp9Sk3QrW4sfdixdGLZlxMqNQzZ/YhnBrXT9OQjt9u7v5tWTyJQbK4i8LXr+Wxx0iIwCo1
	ni948HMzws8tIuXjfxh6cvP2Ow0a1QpyVWKnO9BOHrFmLgBBQ2c7e16+XR6zRMIO3bDzR8=
X-Received: by 2002:a05:600c:19d3:b0:489:1ae1:4eb9 with SMTP id 5b1f17b1804b1-4891ae14f23mr447767705e9.28.1777280158625;
        Mon, 27 Apr 2026 01:55:58 -0700 (PDT)
Received: from [10.30.6.33] (93-47-80-68.ip112.fastwebnet.it. [93.47.80.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a7b4sm73703654f8f.22.2026.04.27.01.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 01:55:58 -0700 (PDT)
Message-ID: <12c2bec8-ffb9-4b01-8bea-819c6ec77c5e@gmail.com>
Date: Mon, 27 Apr 2026 09:55:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix missing submitter_task ownership check in
 bpf_io_reg()
To: Ali Raza <elirazamumtaz@gmail.com>
Cc: axboe@kernel.dk, bpf@vger.kernel.org, io-uring@vger.kernel.org,
 krisman@suse.de, linux-kernel@vger.kernel.org
References: <e49d1391-b06f-4d60-98ff-0f034f2ed9e9@gmail.com>
 <20260423084024.31721-1-elirazamumtaz@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260423084024.31721-1-elirazamumtaz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E0C346F7DC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13146-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On 4/23/26 09:40, Ali Raza wrote:
> On 4/22/26 10:20 PM, Gabriel Krisman Bertazi wrote:
>> How is this a protection?  I thought ctx->submitter_task is about
>> IORING_SETUP_SINGLE_ISSUER. there is no permission or capability over
>> it against other processes.
> 
> You are correct.  submitter_task is a SINGLE_ISSUER mechanism, not a
> cross-process security boundary.  The "parallel path" framing in the
> commit message was inaccurate.
> 
> The code confirms it - submitter_task is only assigned under
> IORING_SETUP_SINGLE_ISSUER, either at ring creation [1]:
> 
>      if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
>          && !(ctx->flags & IORING_SETUP_R_DISABLED))
>          ctx->submitter_task = get_task_struct(current);
> 
> or deferred to IORING_REGISTER_ENABLE_RINGS [2]:
> 
>      if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
>          ctx->submitter_task = get_task_struct(current);
> 
> The check at [3] I cited returns -EEXIST to prevent a second process from
> registering on a SINGLE_ISSUER ring - it has the effect of blocking
> cross-process access but that is not its purpose.
> 
> The commit message's Requires: line was also incomplete:
> IORING_SETUP_R_DISABLED is a prerequisite but was omitted.  Without
> R_DISABLED, submitter_task is assigned to the ring creator immediately
> at [1], so the attacker who creates the ring already satisfies
> submitter_task == current - no timing window exists and the attack is
> impossible regardless of whether the check is present.
> 
>> I'd argue this is a non-issue.  If you have CAP_PERFMON, you are able to
>> mess with the process in many ways beyond this.  Otherwise, how a
>> process would be able to get the fd in the first place?
> 
> On CAP_PERFMON I'd push back slightly: it is narrow (BPF program loading,
> perf monitoring) and does not grant ptrace, arbitrary file write, or
> process control.  The BPF struct_ops path is specifically what
> CAP_PERFMON enables here, not a general process manipulation capability.
> 
> But the fd acquisition question is the real barrier, and on that point
> you, Jens, and Pavel are all correct.  As Pavel noted, any application
> that accepts a ring fd from an untrusted source and calls ENABLE_RINGS on
> it is already catastrophically broken - the BPF vector is just one of
> many things an attacker could do in that scenario.  There is no realistic
> path to get a privileged process into that state without it already being
> compromised by other means.
> 
> The fix itself closes a genuine asymmetry - bpf_io_reg() is the only

Not a fix, submitter_task was not made to be a security mechanism in
the first place.

> registration path without this guard. I can resubmit with an elaborated
> commit message, if Pavel thinks it's worth applying.

That might be fine to add. I omitted it because it happens off the bpf
syscall path and not through the io_uring registration syscall, i.e. it'll
break if bpf folks decide to defer registration to a worker thread
for some reason. It's of low probability to be a problem, so it might
be okay.

If you're rebasing, don't forget to use the latest branch and look
up how it checks ctx->flags around submitter task.

-- 
Pavel Begunkov


