Return-Path: <io-uring+bounces-13629-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ei/AEVPlJWpHNQIAu9opvQ
	(envelope-from <io-uring+bounces-13629-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:40:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DB2651B9B
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:40:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=wmsw11r+;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13629-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13629-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C3A030134B1
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 21:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE91282F00;
	Sun,  7 Jun 2026 21:39:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C67332906
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 21:39:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780868383; cv=none; b=QL7nnJveM1i2v5OhiNdwlqzQZoyoFEIfvPzf3VM0oJJsFw7NX/vw3Kn6Vh690iMYV3IGc+MpG0YMh2xKNcwNbJ2dwAMC+uLbX1nXrpKW3k065R8iASvlAny+79fiLKR6uc9V4S9pEYgZ88tHywI1M5eUxMblEilleXEk9cTuwEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780868383; c=relaxed/simple;
	bh=QIBCxdfGH5a381y2uE0KZdFtmZ10vasRcocdv7ZOCQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbgBMifEXvqN7LZY3PHCfvezMWORdhyTXlSwR4pLGSiZnt3iCbOCmAf9Y7X1shS8FJ4mDUbmOOsklS1NhE58ep+9vHAzPIfOkdKwbJoTXfDrWsnnzTFNXOYVOxmSqorkmtGuk6IDZvWkX0zF5duyG6btTq7/WuBa5vmqeoXxrhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wmsw11r+; arc=none smtp.client-ip=209.85.161.46
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e4a083687so2145459eaf.3
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 14:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780868380; x=1781473180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VH54pI/I5/wPbyZRtGdpre0DZhODWZ+Lda9KAUJofKY=;
        b=wmsw11r+eyZfiHslYrYgHty8Y/MisYNMkGALSy+2cvzLNjE+i06Wh5SfK4XGRAoBmw
         D3TGHlK6YJ/3hb8EqodYriQbpMCShQ3SqhFxBRzhTBc66KbMVpQVB9Ez1BaN0s0od1aK
         LXaL6NTRiIBzFuzgTXs9dLbc5ef0a49E1efxIWuocC0WSHaRr8drwvu0k8HjkhU8JQe4
         d9IiEfHK/XI12Yl55OHSkF/twLyw4DvHv+1+cvyIRHQlfgJ4Iv655lG6kk7XG0xLaxif
         z15JFq8fsj5Rdc18rDhXLuMG2QTYRwfgYYcLxHZmMfuDDNlbPnmzCPQiUAKHWOMSs01Q
         1iQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780868380; x=1781473180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VH54pI/I5/wPbyZRtGdpre0DZhODWZ+Lda9KAUJofKY=;
        b=HJXecQ5gsHXhpVEsJN87zagOcfSlerdkbjQhsfy1Kv8YKlFFWH3C7ZHAmy5/nuzckx
         0IDSz5uwTsXaAYVOuS4DURdZ/xkwdGvavTdv4DUKFZQBfEvAJroaQMLi+V8/yETTkjhX
         GbNNpJ1wPzPWXi4rt5hDKNwmV/K8/Jarnoh4mij4G8AzAro8H+ncsfFm/hhDNZE48dRM
         qj5LxkgBEi1A080j8xjhgnmc/3oQA9QeNd6KXbs+mVgrNxt31APT1jcrWndy8RjbAQQa
         XeJrdM61U2TcQvvczrsSrGTGAaMNFFZcooy4lRG0laqSC7tcvsgxki/yiDl6EDROTYvq
         3n+w==
X-Gm-Message-State: AOJu0Yxd47rjhU5KZ+NuQDsmLE/Qm3hj7SA5y+aNneZlqVCQvlJNm8F0
	JE4oa7K4xHMc38MDDo7nVgwRFjf+BT65zsxE+wjDgpXuexf1c5as+Qw/eFwSPiM9zQZLGWYIR1Y
	vgAZO
X-Gm-Gg: Acq92OGAjhvMLoP8g82kQWII8iXReHh+oou9moU01Qzn6m6q5sX3ATwVUbYAfz8863Y
	fwyLaLjegvpyghZMZ0qUIR6qyS2K4NRjPuPadqHqyiGb8FLjm1jV5kG3NBsX5gS+9UqmLl+ihO8
	KA29kJ3oRUIJi9PH8C/PzAxJeLFjX6QC7tT65HMGgB4n/Y+FSiMSMI4fI9H5kpbj6WtuzcDp5Vp
	mXUbu9naJ7YFvMiML/jc8zLsmxrEdTG0GJa5Ig9j3/2VmHhdwJK8Xohm5JDmWd/IfOmNp1rb228
	Iwe/qgXsMFj/69Fls2zyPiTCqEiGzl2iUMFYezFpxyYiNEtQymZ/8OGrsm3vB3PXKGLhkAilmpG
	LpKA/8N75DAA0PYHsw7tclqKWNhdljZFHgsjpUODjMTCeIXd/MgYSghN6YEH2VxcV5/TTqEquPu
	x66MUCV/uhuP7yOy5SrodYJqpl3/K3ANXdNTClNuzL9cHntnPDm5Vcs66saPqd/yHMrSRtCPKMJ
	RjFVXIprxpXQU0SRm22WgCBJleNb3s=
X-Received: by 2002:a4a:ec4b:0:b0:69d:f749:7d91 with SMTP id 006d021491bc7-69e68b08009mr6846407eaf.7.1780868380322;
        Sun, 07 Jun 2026 14:39:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e464743f8sm9392229eaf.15.2026.06.07.14.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 14:39:39 -0700 (PDT)
Message-ID: <1fd2ea63-c128-4641-9565-dbafd97de612@kernel.dk>
Date: Sun, 7 Jun 2026 15:39:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink
 non-INC pbuf ring len and affect later READ operations
To: Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>, federico.brasili@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
 <nyakundi-confirm-recvsend-bundle-20260607@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <nyakundi-confirm-recvsend-bundle-20260607@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13629-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:nyariboemmanuel8@gmail.com,m:federico.brasili@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:federicobrasili@gmail.com,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:from_mime,kernel.dk:mid,vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 94DB2651B9B

On 6/7/26 3:22 PM, Nyakundi Emmanuel wrote:
> On Sun, 7 Jun 2026, Federico Brasili wrote:
>> I found a reproducible io_uring provided-buffer ring issue on Ubuntu
>> kernel 7.0.0-22-generic.
>>
>> A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
>> ring can persistently shrink the user-visible buffer descriptor length.
> 
> Confirmed reproducible on:
> 
>   Linux archlinux 7.0.11-arch1-1 #1 SMP PREEMPT_DYNAMIC
>   Tue, 02 Jun 2026 18:26:58 +0000 x86_64
>   Arch Linux (rolling)
> 
> Output from your reproducer, run unprivileged:
> 
>   [INIT] entry0 len=4096 bid=0 entry1 len=4096 bid=1 tail=2
>   [STEP1] poison empty socket: BUNDLE len=1 expect -EAGAIN but entry0 len may truncate
>   [CQE1] res=-11 flags=0x0 user=0x1111
>   [AFTER1] entry0 len=1 entry1 len=4096 tail=2 changed_buf0=0 changed_buf1=0 guard_before=0 guard_after=0
>   [STEP2] wrote pipe bytes=4096, now IORING_OP_READ len=4096 after recv-BUNDLE poisoning
>   [CQE_READ] res=1 flags=0x1 user=0x6666
>   [AFTER_READ] entry0 len=1 entry1 len=4096 tail=2 changed_buf0=1 changed_buf1=0 guard_before=0 guard_after=0
>   [STEP3] wrote second pipe chunk bytes=4096, second IORING_OP_READ len=4096 without republish
>   [CQE_READ2] res=4096 flags=0x10001 user=0x7777
>   [AFTER_READ2] entry0 len=1 entry1 len=4096 tail=2 changed_buf0=1 changed_buf1=4096 guard_before=0 guard_after=0
> 
> entry0.len persistently corrupted 4096 -> 1 after -EAGAIN RECV_BUNDLE.
> Subsequent IORING_OP_READ consumed the poisoned length as reported.
> 
> This confirms the issue is not Ubuntu-specific and reproduces on a
> stock upstream-tracking kernel.

Which is entirely expected, it's just a generic kernel bug and I doubt
that ubuntu is shipping any specific patches here that aren't already
in stable or upstream.

-- 
Jens Axboe


