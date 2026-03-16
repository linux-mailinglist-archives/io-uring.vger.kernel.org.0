Return-Path: <io-uring+bounces-12695-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qANQGGUXuGl/YwEAu9opvQ
	(envelope-from <io-uring+bounces-12695-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:44:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6B8129B9BC
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63DC3301F9E2
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834F42D63E8;
	Mon, 16 Mar 2026 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+/BYN9G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB542BDC1B
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 14:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773672015; cv=none; b=nMlOGaFQmnVrbGVKIfegI35SHwNDILkIxMi0GEbzhwq1TrPKuvPgO03fuXGPbrzawa5Oh1UYbkJ9tfmHm4PCOvVy+CovKxiK48W/mKTgwlZV7VU14BcPEatgDOPSSiaCWPcif+s6G68CmYqXOigcqtuvYH2TsWr7r8DjeOc5+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773672015; c=relaxed/simple;
	bh=bUJgAosIB7xVgUkHBGSlPRc9s6+p6FRDlGv4JhiUhnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aWTkJHPJPE7sCEjXMS2fxNj5EnOZrysPAVFPuFqYFL0uoDSjU/ZbCOgGkkN91E+VFFMNw7QpxdwCEeHoOm/WngTzh/JCuH7jL3BrX6Vs9mxYlLweWlJxvIFbVPBkv86kyrMw3HRDYQ6uZaOOjF601TfXP4DR6EK/4ivC6uwcT2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+/BYN9G; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-482f454be5bso53294835e9.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 07:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773672012; x=1774276812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q2qwHO7FIed7nrLNLEnChbXvaJdVNNW6/LPdQmT9+XY=;
        b=B+/BYN9G8HMCrua00Ks/rpxZF+Xq03Inowv7FH0x+ijH+lantUmNWGHsPwNOfNCA7r
         tpV31V9Q5s5C4eD1mAhgODTMrAIo1u4FVePLo/YCr14Tw17RcdxCfIFIjSeNJ8BuOVDR
         OgjCRajNuSwjrE9dIo9t69W/4EAZuuVsVgoL61o/tEUxxM9DGzO1EbwlJjrrHWzHrMDq
         D4fhFyTWBGhFgltxDBFbIZrMEnFXP+AqbDeodWe6kmQ0gz89J+QGuob7RPlBuBNGqQl4
         HA59mZn5XV9mJ0hQC3FUcqXn6UPEkYOHFA/0KmdnFP2FWMxlqZvnzCXNs936qtKmAGSE
         s2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773672012; x=1774276812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q2qwHO7FIed7nrLNLEnChbXvaJdVNNW6/LPdQmT9+XY=;
        b=jEVweDTx+5yq8YW+mAe35eVC6XJb9+87TUVg+1r3tIMMEqKkJhuJhtd1aSDFnuLFep
         qhiFC9WQ3sExlxfx9QYmCO4NN0KOBqGOxnmt2VzMmStnaMpSuTHAyjD2MJHmpkcGLVEq
         84EMDeHxjFF5P7c57GwCqXUEvtz98y4xaS6MxYDT6TqEdl/5md2XDxY7gV73tKNrsD+J
         vm61aMwG3shgmdBIg56++EtBwHsbS6xt3XbNZQ8Y9PC7mtwWx8x3Hm8rrx6l5qLBcHil
         x05vgOTwdEUdpdo1iuJKmjbyKPPw25qrAUtAauF1LXJUYvsyen3kkdFGAAKE/tLU0W19
         msEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKZBhsvvxsUFVCsRtvlhPj34ODYo1yuXZv1wIgjs2nO0yAJpmBjZrWmlsTt4u8Be+UtkSjvUb3rA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyygXUNWVs6C0WneBQDUUqzQlaZS55zBrZajmMz2thhP7/m7gj
	9TFAnA1H4demF/NImUkwO52w4+02vUA9gMWnKrfX23oWfo/nHJTaJ1AkF2aSJA==
X-Gm-Gg: ATEYQzym8PFUon+RgvZGvYjJ96SDTons/Nym86Smj2NXC5zbXH5all9NLiQW3kQYq9W
	SDn6bhlfwuZf/+GbNH+z2v1iHFjmx01+yOSWACBcXunD2WEkMSTw7E2YnLo5KIuJdF8GDbr0Vb0
	0KJi7shbj2j6KJHry4WQc+xevDcYj0axIZhCzkJKGuwMiui5A1VKC8eAguFpqTXJLIiDJrnVf/M
	dc/KVAozcCqVDztROXutQy5AJfVLGhu6Oxp++kk4CZaqN453ODWmnWhYuphlXMuZvk94m4S+a3U
	D4ZMtb1gCmeqNnulihlyLWQpKCqn8CQ1i44P/+3tRrJ/PBZfrEMbJJDow3JvtHcbBrpdwmQpSSX
	Pb6WLUi2H2pMVJlMVohtC+T/W0fj6QBrHSbbvXMV9d8Sy4i48DQZCzSG6Y8yjXKOTgoGZQYEVmb
	kciecOHyY5tGFRPC1I0uE7vrDqdiahNQ1zWeSNAdmbRbCaHX4XjsgGz1xtRJNwWtTH1Bc3EBPL2
	Gx6PunYGE4SFiOtStFOAVBoy3lQlhUFelivtREFLiWnqriEvLQpl+1zbw==
X-Received: by 2002:a05:600c:1907:b0:485:50ac:b8cf with SMTP id 5b1f17b1804b1-48555a5689amr217296505e9.0.1773672012028;
        Mon, 16 Mar 2026 07:40:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a0ed])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66e3f8sm426703535e9.14.2026.03.16.07.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 07:40:11 -0700 (PDT)
Message-ID: <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
Date: Mon, 16 Mar 2026 14:40:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: francis <francis@brosseau.dev>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12695-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B6B8129B9BC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 14:28, Jens Axboe wrote:
> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>> On 3/15/26 16:19, Jens Axboe wrote:
>>> When a socket send and shutdown() happen back-to-back, both fire
>>> wake-ups before the receiver's task_work has a chance to run. The first
>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>> the first event was consumed. Since the shutdown is a persistent state
>>> change, no further wakeups will happen, and the multishot recv can hang
>>> forever.
>>>
>>> Fix this by only draining a single poll ref after io_poll_issue()
>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>> discovers the remaining state.
>>
>> How often will iterate with no effect for normal execution (i.e.
>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
> 
> That is my worry too. I spent a bit of time on it this morning to figure
> out why this is a new issue, and traced it down to 6.16..6.17, and this
> commit in particular:
> 
> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
> Author: Kuniyuki Iwashima <kuniyu@google.com>
> Date:   Wed Jul 2 22:35:18 2025 +0000
> 
>      af_unix: Introduce SO_INQ.
> 
> which is then not the first time I've had to fix fallout from that
> commit. Need to dig a bit deeper. That said, I do also worry a bit about
> missing events. Yes if both poll triggers are of the same type, eg
> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
> would anything else where you'd need separate handling for the trigger.

Thinking more, I don't think the patch is correct either. Seems you
expect the last recv to return 0, but let's say you have 2 refs and
8K in the rx queue. The first recv call gets 4K b/c some allocation
fails. The 2nd recv call returns another 4K, and now you're in the
same situation as before.

You're trying to rely on a too specific behaviour. HUP handling should
be better. Ideally, the opcode would handle it, e.g. zcrx doesn't have
the problem IIUC, but that might be harder to do.

-- 
Pavel Begunkov


