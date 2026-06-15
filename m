Return-Path: <io-uring+bounces-13741-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id m7buH/1zMGrNTAUAu9opvQ
	(envelope-from <io-uring+bounces-13741-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 23:51:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9F268A3A8
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 23:51:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=dd4aIHDF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13741-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13741-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3AEA301FCA6
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 21:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36AD2E7631;
	Mon, 15 Jun 2026 21:51:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDAD2D97AA
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 21:51:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781560314; cv=none; b=pDkr1kONH7vUix6caGM9IC/ecPKCb+8uaj0W8QQ0mWCgdEfe/T0CZvKraHRj/MU7F9j8eHhka+R/TGhqldGUdxE4/841owefzLlY9Hmj01HYsvpg5TXpfskS0QA3OhxJ4t9OF4UCx16zCUQgjPy71tnJP6JptJ0+xABEV5Ou41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781560314; c=relaxed/simple;
	bh=rKx0s6o+HChsVPzM3bG5QfaXvkHhJwf2rE+jMi6PiQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fpu88fO5kKIKXDsR6PVj2MMt0u+2tBVIeGCa6Qb2ADXGXijCKszBWXDbGDz3ZUoKzJcJIBbPgkPUI2+qdHcuOGgnJpIEM70rzfXRDyBNvh2eVUpjjmIvxia6CxuWH0bwpzwGH645nJluz3QH5tUJlUsaar8dEkWDc6tJj1K/1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dd4aIHDF; arc=none smtp.client-ip=209.85.210.51
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e6da33a561so3520267a34.3
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 14:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781560311; x=1782165111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mjk+SjoQr5B5qqNCDCZpoUN6Y9uoGFQcC6RyhKxqvZw=;
        b=dd4aIHDFZ2hTekEgzlmwdKSiQqaotyXZM/F+bLW9hTX8n0WX2MUMro8pQFhOnr4HRX
         3YbOT/prpTEnmsU20tJueSGGzf+EbjOQkXX9cE197PlzJEO59RnxiNzoUvGKxPjge/XP
         rFu2oBdjDqL/6aWT7xTIP+yFMBhOs539tVU2xj2Cb5t4zIp7sQQsXhBTe7biBIckn8x1
         PWSMYB0kr8VGFz/FqKzfDLcGPhRpL6TSJQzfuolbMr8E9caUucY1sPG4BgbHijdeNvZ6
         Khrxfr886zqCMkn96p6lAI55jzhdEhY8a7RW+Pau9SG61Yeoz/3jR5e/OfhXLEOtJhAG
         a9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781560311; x=1782165111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjk+SjoQr5B5qqNCDCZpoUN6Y9uoGFQcC6RyhKxqvZw=;
        b=NiB/M0eMpEMOPNMbfjgyLGd8Cv5W7WR1vAX4dmy1R6TYxTXiqGgRLCYqqqjWBpJs8C
         5btOjqg4WaWOa7vmVzwAb0Lz3C1nwnRRyoHO5VwaNgu55Esjt1jtrEDRnjU0MxTEidwf
         ZozFFWO3TERm/h6ipIE4HNjkvciIEjJyVMqhHIncy+jF0wCz+Ncty6fujFnKPobAdAcY
         MLLjqFdQuTdBzYqLJ7KVihTGM3pBE6g24Ik6Phznqeudjb3L6051045DJKJ9SXFneOjd
         LkrFlOLmD3w11Ewz9EMJoXEwIW1ODMZvnpd9ToofZgjX1lvJ0LKUmhIRfHi63QGNoWof
         NvoA==
X-Gm-Message-State: AOJu0YxZWEEFyMLw8LhRBqBqoxmPLsGH3CzEcXoBNlCx5EPN2DQnQreV
	qhXBNzQ20iH+JqdXRn5S7b5OcCncF3C9i1aZs8wQALckXg3S+LqV1G4y35y2dFvcTO+wWh+R/Ez
	IvNPEBPI=
X-Gm-Gg: Acq92OEMPPrkSqGXlnmwuzmcWGwlSKcmT7NBDzXZCK5L9dLiGx0mJlHdAA5VXq9saNP
	6/6/eJkzbvhxFqlkI+jewrT/6+nz+RgRUhjjtC1YRa5LT9SOMtHvffw8SDAAev1cLetV5M4D4MS
	F9unkEwgqk74RSGx4KK83OM6h68EaQhbKDbqeFmQIJWDgSzd9a6T9aQFlFHc1OaXdBmvoZuKBXf
	OHxDpACofogLCSkrSe5OqfXMdf8LY+i0Hh0pd1GNGKBOH993XVu+/58FSNynqw0pT5cVwC0ufry
	WauWl/0iwpoN8pSUl+8FAUDAPB2MKcK3EEqgPcjkzhsW8vBp/zF3qw2BwARBgd/EU5lSC7KcPm+
	F7uszmIhdgX7GfRmSunz/3NmsRc8zTMJ6FEcm4yr560CtqtBKIho7lWdnQCAOllW7plJscJZ7ZI
	Ig0S5xTtN4mxGDfWXpENCCGalaUEceEmuDE+D+Esoci3kKlmq2AjkoGNMkEknII4gMJJ3ejR8s1
	QZltCaw+g==
X-Received: by 2002:a05:6830:2543:b0:7e6:fdea:7ab1 with SMTP id 46e09a7af769-7e8fe06fc6bmr587135a34.8.1781560311277;
        Mon, 15 Jun 2026 14:51:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e7a3c2b08fsm4014858a34.8.2026.06.15.14.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 14:51:50 -0700 (PDT)
Message-ID: <fc026d36-8831-4ff0-9b54-0a742550e128@kernel.dk>
Date: Mon, 15 Jun 2026 15:51:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
References: <20260612025125.1690253-1-axboe@kernel.dk>
 <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
 <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk>
 <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
 <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk>
 <CADUfDZotc7tRWiYoDGu4nGdG=AR5wmZDyw8C1-Kp5BhxL=ZEmA@mail.gmail.com>
 <d0f05189-6192-46ca-9caf-2c71c07ddc4c@kernel.dk>
 <553cba4a-b4b1-4a2f-a484-4ef1d10b0c90@kernel.dk>
 <CADUfDZrKED1o-bEMF0hNN9R2q0Sq_OWWy8GhCwBw3w2fZJK_Bw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrKED1o-bEMF0hNN9R2q0Sq_OWWy8GhCwBw3w2fZJK_Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13741-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CF9F268A3A8

On 6/15/26 2:40 PM, Caleb Sander Mateos wrote:
>> @@ -34,10 +34,6 @@ void io_tctx_fallback_work(struct work_struct *work)
>>                                                   fallback_work);
>>         unsigned int count = 0;
>>
>> -       /* see tctx_task_work() - a set bit must always have a run coming */
>> -       clear_bit(0, &tctx->tw_pending);
>> -       smp_mb__after_atomic();
>> -
>>         /*
>>          * Run the entries directly. We're in PF_KTHRED context, hence
>>          * io_should_terminate_tw() is true and they will be marked as
>> @@ -101,6 +97,13 @@ void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries,
>>                                 io_poll_task_func, io_req_rw_complete,
>>                                 (struct io_tw_req){req}, ts);
>>                 (*count)++;
>> +               /*
>> +                * Break if most recent pop emptied the queue. This helps
>> +                * bound task_work run, and also protects the regular
>> +                * task_work addition.
>> +                */
>> +               if (mpscq_pop_emptied(&tctx->task_list, tctx->task_head))
>> +                       break;
> 
> I think we can now remove the "if (mpscq_empty(&tctx->task_list))
> break;" above? The queue must be nonempty initially, otherwise the
> task work wouldn't have been scheduled. And if the queue is empty
> after an attempted pop, the previous iteration of this loop must have
> successfully marked the queue as empty.

We could, but then we'd need to special case the SQPOLL side. I think
it's better if we just leave it somewhat defensive as-is, it's just a
single compare anyway, non-atomic.

-- 
Jens Axboe

