Return-Path: <io-uring+bounces-13013-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GBNCeCP12kaPwgAu9opvQ
	(envelope-from <io-uring+bounces-13013-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 13:39:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1250D3C9B88
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 13:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 119143008081
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 11:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3600D3BC663;
	Thu,  9 Apr 2026 11:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="kHZQoepd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345833B95FF
	for <io-uring@vger.kernel.org>; Thu,  9 Apr 2026 11:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775734745; cv=none; b=lied5l8nI7pYOOFIrMpkeOVAHLayuv4tDV/KsuVqDe3wqlQZWfQX2rPEoPG6zR0RZIUmL7gICe5Rbs07bmuCjTsR7NDExqf9ZIjplUflKKjgLRHcFtoB4IDDXoGpoLPrGGIeeKer/B+iGj6K8YT9/9Z28YnCG2fMLa46HoOptX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775734745; c=relaxed/simple;
	bh=vJhX13d5HJAKk2YLCm6jkzFVwz5a3ZA0B0xtoCDtemc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9SpVS+lbf4ZPXAzIwNArbP2uIPvN6ivwC45Ri+ajZUQC7z2AjQg9e3uPB946JNg3iHTvFrsknXyhKG85pcj9uHTLIdojofDurxehMzRxjpy4dYMPY05XDgLvtMODpHVz3qHhN3vcKDX25vwUoKrc6MBGsd/A4NZykzU+tmBzbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=kHZQoepd; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-464ba2bb3aeso434123b6e.1
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2026 04:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775734742; x=1776339542; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DLN1OJWsfF6DIgl5KLiB++aVYwSL8sDzhK9gY/ZQcvA=;
        b=kHZQoepdt04CLZiEc/ONXOjd825qGPP1OK8Ca2bMj9CuZTRKrHKWP/X5jQoLbzXeSZ
         /ySn79lUiVHThp3W3jBQbBAdb87dP/Q4+A/oh/TM4VtQt1ZEn3rwK/KoUdPAoG59dH4h
         2+xXRsyPn8YYovVdwJ7qXuI6fS7IJrzI0/dd8wD2NMwv96XYRlcZzqVjhXRzVUQ3w+bH
         yT1ifYfLPp456eLdKkqnrHBYkp6f9FFCxA6aWkOdnK35MI6a8uB88dtucoX6QecEL5F4
         7x9c3qDHXX0FD2ybEZtIH4Dpl6JxUHBECGIflbJTsx/fLYsvYBES0uyjJ3cfcaDq2obl
         ncfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775734742; x=1776339542;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DLN1OJWsfF6DIgl5KLiB++aVYwSL8sDzhK9gY/ZQcvA=;
        b=UX3Bh5FPINQKbKqX01ynqh46Ab5yQOOU7o19KZeQBGHqn7pDyeBMEwF9FoKXUsPeWD
         yZP+h6yTeFjEeJg3DihxA+9xPx6s+k0fdz+Mz4i0Y3NJu/2O6O5xqvgz23Ot0Bhz4cJF
         MD6SjbMH/KqfEjYDnzvk9ePHFgOYBYWdPW0LcrqdhJoqruOzGGBy0UO1mPT5ju0zB91L
         zp4GG9uBsd8t9rT2g7WlZGJc5fo+h99ibKY5LY0XlDP60McWSaQmgyvtt3WrsaU8owno
         CTca32lJEL0ZLh/mnrvpkEiDoloIt1D2vVtnSiTZqHk9TGdwwMEUvdOFh+YKboG4gcGH
         rC3g==
X-Gm-Message-State: AOJu0YzVnflncU9am5kLK21ME2fBS3AJo3OUctiiREERzS6M7pN95yIA
	R6phacmjYA+OVrdEFlj34dKm+h0O52i1rFITNFLPlWJoUbdYYxp/Ktf6yoIzzlwjJGSabmYsbdA
	DiDpKhoM=
X-Gm-Gg: AeBDieuvhqtl+FkXGg1HOEN9UzYq+6pkM+gv+FOobrWxmjSI/AzNw5Wij2ClD0Pfvo2
	ifHrpIAte8FFjoLgZSjy7AbEcmSPHuvjzPqGRNY5nNiXKVytwYOW34xd1tYnptVy/jcALFJuxbJ
	SpvDR9zv+lqXGl+Vjqu1IToCFRis3oTE9s7e0vennSpTFO9TWKTY5clPXjt8Je45QuoWdqRH8NQ
	okoLKduT/iQGLLkESB1Zc17PQUI/UtOkVipn8EWupWdL6ZFgv7S5ry2zyW/fIezNSJxZ1vH9HcC
	CAwJ8Pe1Qmsv6pcLJ6i1zvEeTAgmDgBfFmuHHKMHPLuW+QPAL7LO4lrWrq9AgSvTtvIWVJIM+HB
	U9J+shVY0G7h6CqH84eYOLkO2U0uRyRQz0EQOdnXAXFZMp5esZC0WDl+uDBmXi7rp7ofs0+0YbZ
	ZcDmo+EJnmniyZHjKjb6gp6UrjFD1Ze2kYukF2C/GUchaarr66hZC0jV5SPhfvH0lKiqZWVNHkz
	r20FxHH/A==
X-Received: by 2002:a05:6808:3383:b0:466:f4cc:2b3c with SMTP id 5614622812f47-4772b190d1fmr1383088b6e.8.1775734741963;
        Thu, 09 Apr 2026 04:39:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46ef5bfe815sm11644185b6e.6.2026.04.09.04.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 04:39:01 -0700 (PDT)
Message-ID: <32e0991c-f294-43a7-888a-eadd03079a93@kernel.dk>
Date: Thu, 9 Apr 2026 05:39:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] io_uring: 13 remaining unprotected ctx->rings accesses
 after 61a11cf481272
To: asaf meizner <asafmeizner@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAEshK0=S+19B1LbamBaNOKTQyw+98QFBjHs04sByu_JL2QOBAw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAEshK0=S+19B1LbamBaNOKTQyw+98QFBjHs04sByu_JL2QOBAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13013-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 1250D3C9B88
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/9/26 3:14 AM, asaf meizner wrote:
> Hi Jens,
> 
> Commit 61a11cf481272 ("io_uring: protect remaining lockless ctx->rings
> accesses with RCU") introduced RCU protection for ctx->rings during
> ring resize, but at least 13 dereferences were not converted. The
> most concerning is fdinfo.c:63 which reads ctx->rings with no lock
> and no RCU protection at all.
> 
> Unprotected accesses found:
> 
>   io_uring/fdinfo.c:63
>     struct io_rings *r = ctx->rings;
>     (no lock, no RCU ? TOCTOU with concurrent resize)
> 
>   io_uring/tw.c:41, 253, 291, 326
>     atomic_andnot/atomic_or on ctx->rings->sq_flags
>     (lines 249-253 have a comment justifying no RCU for
>     !DEFER_TASKRUN, but lines 41 and 291 have no such comment
>     and appear to be in contexts where resize could race)
> 
>   io_uring/sqpoll.c:380, 407, 421
>     atomic_or/atomic_andnot on ctx->rings->sq_flags
>     (under sqd->lock, but resize takes uring_lock ? different locks)
> 
>   io_uring/io_uring.c:574, 647, 690, 1985, 1986
>     CQ overflow flags and sq_dropped counter
> 
> The fdinfo case is the clearest bug: a read of
> /proc/<pid>/fdinfo/<fd> concurrent with
> IORING_REGISTER_RESIZE_RINGS can dereference a stale ctx->rings
> pointer after the old rings are freed via RCU. This is a UAF read
> that could leak kernel heap data.

The "clearest bug" isn't a bug at all. What you are seemingly missing
here is that rings can't go away if inside ->uring_lock OR
->completion_lock, which is actually documented in io_get_rings().

> The sqpoll case is also concerning because sqd->lock and uring_lock
> are different locks, so the SQPOLL thread can see a stale pointer
> during resize.

And you are also missing that ring resizing isn't supported for SQPOLL,
it's a DEFER_TASKRUN only feature.

-- 
Jens Axboe

