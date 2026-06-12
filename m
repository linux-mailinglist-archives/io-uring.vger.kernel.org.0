Return-Path: <io-uring+bounces-13696-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9ZaNLOT6K2rFIwQAu9opvQ
	(envelope-from <io-uring+bounces-13696-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 14:26:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 06705679597
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 14:26:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=fUnf8mx3;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13696-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13696-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3D373386B31
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 12:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DB1395DAA;
	Fri, 12 Jun 2026 12:23:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA6A3BED2B
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 12:23:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267010; cv=none; b=s1cwsoHGqt64zyVJSVq+7SMi/jjgUs/6vrWn2qFYGd2lWZ2Imtt/tyE6VGTS37Au1gbPB2IdaAKVrt2hQa+2NRtyP8k4IH/Iav7FuqctczCiDQ7pVqZU+DzdXI+zdlUfF3C5soqJ4NF9FJ/M6wEfTTJBlIJhfK1oiaP+pDtZzNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267010; c=relaxed/simple;
	bh=B5SBFPzx/OAdaTOu3F34JT5amwlKqegxKiSsp4LKCoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiDtK306dbIyad8iOG06Ce4WUMSbWRbqcptEaXLrOWUuyy72+Sa7DHELv+uxicRN9DvaTlCwV8646o/Fk3omtITeWY+EarjlExrQHJH2F/L7T0RqgzBnlfD9t0aJz0QKpQ9g56+oj83y1bjynRtjxKCYd0JMhpVGtRyLd7TIu48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=fUnf8mx3; arc=none smtp.client-ip=209.85.210.52
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6d14aaef8so410803a34.3
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781267003; x=1781871803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eXCa9IqVpElkcDoGdHVrGJb6jaTD6kWAzdJ2svWsZho=;
        b=fUnf8mx3x+7rrFlw1MLyLdat79zf9NegpfCgB+5wGOkLqFGCIEtmZn/6rcqFSmbfHE
         BHHuVvTr/xidUK9kMDWlDD5MYgenBXjWviQq08v/m39uPDRSbijwsIYN8Nssbr4P6zjM
         Y5sTQKpNK+e28WDlkwJ0RSGZWCTpyzvu7iJcIlkHsjKuneZI4A6eWBmjQV4lB1WG6gqS
         Fdz/QtkFjhvf4QVHMXulu/J+6gB4CIHf3aymS/kU4kxH7RCf8p0cwiqOvraKTjGd9MbQ
         VGINYVU+SYnDWrXa9WLlRxnI53sBeCssJWeK136I6sK3cLvvnvoB1qE/GIU8wCVytYrw
         oWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781267003; x=1781871803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXCa9IqVpElkcDoGdHVrGJb6jaTD6kWAzdJ2svWsZho=;
        b=laLw7hoXmfIvSMSfbIlffxV6v9q0QTjGpIAwYCmT0cGyy03Odq/515us3kmb/KMttu
         fWSiEXwzNgRZKQVT6EGDsj1EpHDlFau/m7SwyrIyBKYvi9vuvfjPfaZ/aiJugE+PkQKQ
         qHZ7o9riqIKCrbBvGFXEiCDgPTTpQmM8yA+jH90jkXxYz/Uzr7rr0oWWhmccQ/3KNlYM
         x17Z6IJRN+puwzjCn+TT4soL14st8jNMZV2kvk+Zts4zkI0pw+8hJ6v2k+fZMlglTnS8
         vOifZafzdPtIrAkWQKmPNz4nGsJwVwDXkccVgGSCJWdBaOide53fwFYZFyJd5DmWJXRK
         aSYw==
X-Gm-Message-State: AOJu0YwU9PAdS84HtfYvJLxyNY8GXWblkaORcPA/WJZshn591z5LAr3+
	JpS65n8eEQG4xuZdWeicm0Hz1QxRmHOMwgDsqku/btkK32NKd5tIeoltnwWll5fZeKI=
X-Gm-Gg: Acq92OEbU/aQCBrbHijR3egDhM56UW3F755Kv93JOSJqYF4EYQzanUio/IiP3NzYyC1
	JHLQWjL31O2Q3kIRDS9y4rr/N9hKO/DiDh+MN31EPIKKMRsxg3NdVa+eSs++eLwHDOkClYdJSHS
	IVRofU0v4sNTQ0t5+oxJ3zjrtCwmfBiSd1QWBFw7ucI0Zcs9o0Aeb4vVNdWAMyc9RmAkEZs4yKn
	AcfYP/Cv74dsAefR3auHYkdnXRSZtU+7hUN8bcNOuXuMZXgdyD/4t4QT8kKGyz+JceO8OyZsOey
	Gu1v0G+XXw228s3uWAJgyG3nl7NUbAK1fsnechKfGkNqy1AhSDnpCifO3PVKhRClf2EbO8S7qMf
	CeLHQJd8PeTXjFLvw6KP7hUVPXsWvB6mcHupzyxTmVRPo4zYAWWaJpQY2UT6ETgfM/EuqB5ELGP
	H2io2m9+pFlV04I5x/RuyNOK20n7IVIUKCePmmCnwYOjrCvSa989DLtPyalYwR08hXdsGe2M5iI
	KIeNU86qA==
X-Received: by 2002:a05:6830:828d:b0:7d7:4fc7:21a with SMTP id 46e09a7af769-7e7847174b8mr1509630a34.13.1781267003178;
        Fri, 12 Jun 2026 05:23:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e7815088edsm1850795a34.11.2026.06.12.05.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:23:22 -0700 (PDT)
Message-ID: <8769c471-67c3-49f7-be38-ab108ba998f1@kernel.dk>
Date: Fri, 12 Jun 2026 06:23:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] io_uring: switch local task_work to a mpscq
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
References: <20260612025125.1690253-1-axboe@kernel.dk>
 <20260612025125.1690253-4-axboe@kernel.dk>
 <CADUfDZrTmc_yBU0o_wMwAKZNcEDaFvKxFxzbzg78=OLU114JiA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrTmc_yBU0o_wMwAKZNcEDaFvKxFxzbzg78=OLU114JiA@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-13696-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 06705679597

On 6/11/26 9:20 PM, Caleb Sander Mateos wrote:
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 85e12b4884a5..9df5584ec3b1 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -351,6 +351,14 @@ struct io_ring_ctx {
>>                  */
>>                 atomic_t                cancel_seq;
>>
>> +               /*
>> +                * Consumer cursor for ->work_list, protected by ->uring_lock.
>> +                * Deliberately kept away from the producer side of the queue,
>> +                * as it's written for every popped entry, and the producer
>> +                * cacheline is contended enough as it is.
>> +                */
>> +               struct llist_node       *work_head;
> 
> Looks like this field has padding both before (next to atomic_t) and
> after (next to bool). Probably doesn't matter currently, as the outer
> struct is cache-aligned and has 16 bytes of padding at the end, but
> could save 8 bytes of padding by reordering next to an existing
> 8-byte-aligned field.

Indeed - I'll still move it, then we don't have to hunt holes later.

>> +       /*
>> +        * No one is waiting (IO_CQ_WAKE_INIT), or this cycle's wake up has
>> +        * already been issued (zero or negative, see below).
>> +        */
>>         nr_wait = atomic_read(&ctx->cq_wait_nr);
>> -       /* not enough or no one is waiting */
>> -       if (nr_tw < nr_wait)
>> +       if (nr_wait <= 0)
>>                 return;
>> -       /* the previous add has already woken it up */
>> -       if (nr_tw_prev >= nr_wait)
>> +       if (flags & IOU_F_TWQ_LAZY_WAKE) {
>> +               /*
>> +                * ->cq_wait_nr counts down the number of lazy adds, once it
>> +                * hits zero we're good to wake the waiter.
>> +                */
>> +               if (!atomic_dec_and_test(&ctx->cq_wait_nr))
>> +                       return;
> 
> It's possible that another task work wakes up the task before this one
> reaches the atomic_dec_and_test(), right? If the submitter task begins
> a new wait in between, this could decrement cq_wait_nr even though the
> queued task work has already been processed after the previous wakeup.
> I guess that's okay; in the worse case, the waiter will be woken
> prematurely.

That's correct, if the race is particularly unlucky, it could wake
early. I think that's fine, that's worth living with, and should be rare
enough to not really matter. It's not a lost wake, which would have been
a real problem.

I'll add a comment.

>> diff --git a/io_uring/wait.h b/io_uring/wait.h
>> index a4274b137f81..6d494297e1ce 100644
>> --- a/io_uring/wait.h
>> +++ b/io_uring/wait.h
>> @@ -5,12 +5,14 @@
>>  #include <linux/io_uring_types.h>
>>
>>  /*
>> - * No waiters. It's larger than any valid value of the tw counter
>> - * so that tests against ->cq_wait_nr would fail and skip wake_up().
>> + * ->cq_wait_nr is armed with the number of lazy task_work adds the waiter
>> + * still needs, and counted down by the add side, with the add reaching zero
>> + * issuing the (single) wake up for this wait cycle. Zero and below means no
>> + * wake up is to be issued: IO_CQ_WAKE_INIT when no task is waiting (also
>> + * what a forced wake up resets it to when claiming one), zero once the
>> + * countdown has fired.
>>   */
>>  #define IO_CQ_WAKE_INIT                (-1U)
> 
> Since cq_wait_nr is now used as a signed value, would it make sense to
> drop the U here?

Indeed, I'll fix that too.

-- 
Jens Axboe

