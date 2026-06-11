Return-Path: <io-uring+bounces-13675-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id SRt5MvrqKmqQzQMAu9opvQ
	(envelope-from <io-uring+bounces-13675-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 19:06:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B8D673D76
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 19:06:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=IH3lxTn9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13675-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13675-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D5B93324930
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 16:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3064533F361;
	Thu, 11 Jun 2026 16:58:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E740426D0C
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 16:58:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781197133; cv=none; b=pERwyswnItiU/E9wIp8UYtHSWW4cLDljMuM5qfOnSSE40SoqUcZkdXL/L0taFaAlswGHivXyJFjMIQK/L1g9mhTfSx6Jp9RXcPSjQo1qyN3kBIJU+ju2WVTR0bZnBL9lpNJcn7d3J7nBk0OD/XisVN7bR9IedQ/nenMaLVNdf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781197133; c=relaxed/simple;
	bh=7+N+XR8n82NQgE0BKCRAOFfFS+uIjqVtqIEXApzQpDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2qESZkyloTCHA7gOhsLLfra2epp5BVjbcAFDInXCXkGxobZlNLQYLg9gcIifrSocno2hwzpaMfv4u1S4q407SZEEDAaAJugFmgfMZ0eiPgSqsk2HLpjDsSOE086mhK/YB+ESMduGuu4qo3ofMzVUwpeYyQ20zzJ3QQ4rXDFZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=IH3lxTn9; arc=none smtp.client-ip=209.85.167.173
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-486b95fcdc7so55084b6e.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 09:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781197130; x=1781801930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=px+U5731UoYiwotPKwp0KMPWgrhg+5aggRQtm6ta0MM=;
        b=IH3lxTn9R6ouwH8UQVE1NUN1rWvfnn+Nmmz6tjPiMAhdfabLqDXxWXu1d53omMuh8c
         7I1PiEYtfOpDjsHuCZcUtQXdwSQttPswbgOJO/dCEDzm/geZrGFTe5QbU9iyd+mBLQny
         yIhv0TvSf1aJJcxCXJEAq5YD6TSYmtVlxZufEJiDbEyWWwW0TrhomJHXdiuow0dij4vj
         9QLhV6tU9+rTLJazbtcvNv/yz9Q3gr9fdNOuLnR/XYYU7zDbu1gsihY3cQBy5sxYqBwF
         KDYlBU77C0ngoi72zDWoZdBUMlj1OqrduhwMorDswZanTsLuWkftouylYKJxGJgo8Eu0
         yHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781197130; x=1781801930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=px+U5731UoYiwotPKwp0KMPWgrhg+5aggRQtm6ta0MM=;
        b=Fsswpuw1Mx+yTyM0pnnbjKbtpfs2Rg4g1I//zza4t6Fc7qojcw60a8dD/yb6kX6xLf
         Z3C/T5qsaZwsIkGuRyztZLVgEv3alcPWqtFUEw5hDdzZqP0InOH0E3wGIQENhFpXZl0v
         6gXqgLzYDvhVdB/RvUsrpU9HzLOBFDPNqnJn1nNjCO+HrzEFCPi8iCZO6dbyecj26Lnx
         csE2Q2FhESJLDNqBaI5hNB+1u9fpa55JsVr2/MIH5GdUQl3yqGo94cH9+QRw5mrNev8K
         Rc6M4gi44atzBMFB8/mfufkCSCOzOfgLEBwjI0ugeyVp1PDBV8UjXLFyBUMUayd138UQ
         CSUg==
X-Gm-Message-State: AOJu0YyCjth95+XQoA8FjhdfHbTLEeqgjJtiApcCR0hqcAp9u7ACS5Ag
	0Pg+me0JzBWXrSfmITa+/27LHug15BF5fkdkX8Rmo3WbZ4I4U7rhOk9dFLVkb9ChJb0=
X-Gm-Gg: Acq92OGYtMuwhO3ilMcidBhZAQdbbgHWDyshaYI5ysTNIic+nxWx8dPHYmp8tmQAP4D
	rijXj98BLiiU60BX0Nex4ewTJgFOdGAvNPBc+O35NjVPwCQvOdjaVAGc5YPZrsBP/nSNS+sG9CW
	N8cp1XyP786JoDrd0xXmuIw21TmsdUy2h5nQcDSaZeOsGP8G5Il/s07jQdkoxeQzvqWLfJxBsEK
	re/j9KOZyVnn4fnM2eokFsKob62/66p2T25nJdY4NPKlEVsGEDBp1UUCABU0/gwmN0tsbCjaeDn
	G3qb2/CVPxZGy2Ymix8YOOrDtn5+mz+s9xwhU3T3I4PjeRtcDxlRarYDkQB53e6kezbDp3MUqqC
	VfJdd6d9vFJGRRFgdCgnwcNQ9wIkRbcdlASBhNyiy8PExDwf4Zl/IoCUpwdYTwokScBw66hvqSE
	Am5gSBkwnv0uUZagWd4RlsSyTcxeiuj1jWBaYWyrMVjB0izbjcXaZtoZ9VibPd86tCONHrfl9yA
	GIhycTR
X-Received: by 2002:a05:6808:138a:b0:467:1458:2a8f with SMTP id 5614622812f47-4871a5c1c29mr2621757b6e.37.1781197129690;
        Thu, 11 Jun 2026 09:58:49 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4424466fe65sm1396530fac.6.2026.06.11.09.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 09:58:49 -0700 (PDT)
Message-ID: <30dcad79-6cdc-4659-8cd4-9debc03419ad@kernel.dk>
Date: Thu, 11 Jun 2026 10:58:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
References: <20260611160553.1486640-1-axboe@kernel.dk>
 <20260611160553.1486640-2-axboe@kernel.dk>
 <87ldcldnu3.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ldcldnu3.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13675-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 26B8D673D76

On 6/11/26 10:49 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Local task_work is currently using llists for managing the work,
>> but that's a LIFO type of list. This means that running this task_work
>> needs to reverse the list first, to ensure fairness in running the
>> queued items.
>>
>> Add a lockless FIFO queued, based on Dmitry Vyukov's intrusive MPSC
>> node-based queue algorithm, modified with an externally held consumer
>> cursor and conditional stub reinsertion. See comments in the header.
>>
>> Producers are wait-free: a push is a single xchg() on the queue tail,
>> which serializes concurrent producers and defines the FIFO order, plus
>> a store linking the node to its predecessor. There are no cmpxchg retry
>> loops, and pushing is safe from any context, including hardirq.
>>
>> The cost of linked list FIFO ordering is that a push publishes the node
>> in two steps - the xchg() makes it visible as the new tail before the
>> subsequent store links it into the chain that is reachable from the
>> head. A consumer hitting that window gets a NULL from mpscq_pop() while
>> mpscq_empty() reports false, and must retry later rather than treat the
>> queue as empty. The window is two instructions wide, but a producer can
>> get preempted inside it, so the consumer must not busy wait on it.
>>
>> The consumer side supports a single consumer at a time, with callers
>> providing their own serialization. A stub node, which also defines the
>> empty state (tail == stub), allows the consumer to detach the final
>> node without racing against producer link stores: that node is only
>> handed out once the stub has been cmpxchg'ed back in as the tail. This
>> also guarantees that the previous tail returned by mpscq_push() cannot
>> get freed before that push has linked it, making it always valid for
>> comparisons.
>>
>> The consumer cursor is deliberately not part of the queue struct - the
>> caller owns it and passes it to mpscq_pop(). This is done to separate
>> the consumer and producers cacheline.The cursor is written for
> 
> Interesting stuff!  The commit message is truncated here, though.

Huh yes indeed, wonder how that happened. Was doing some shuffling and
editing, probably messed it up.

>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/io_uring_types.h |  12 ++++
>>  io_uring/mpscq.h               | 121 +++++++++++++++++++++++++++++++++
> 
> There's nothing io_uring specific here.  Perhaps put in lib/ directly
> some a wider audience can review  and use?

I think keeping it local is fine, if someone else wants to use it, then
it should just get migrated to include/linux/ instead as it's all in
that header. Code is small enough that it doesn't warrant .c and
non-inlines for it.

For now, as there's one consumer of this, better to keep it local.

-- 
Jens Axboe

