Return-Path: <io-uring+bounces-12556-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0M0BJOZiqGlauQAAu9opvQ
	(envelope-from <io-uring+bounces-12556-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 17:50:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 029DD204987
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 17:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9CF753125DA9
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 16:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B500336654B;
	Wed,  4 Mar 2026 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Aon4QGlN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E583367F3E
	for <io-uring@vger.kernel.org>; Wed,  4 Mar 2026 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641759; cv=none; b=pDuxaDCq5uPk+IEGzXGJTWNDFAmJ7DRiYDMhRpI686H0dp9pPpSAQPHRFvbQIWSshuYVeX1VLPMXYpS/6MI5AWGBW0jYFQfrSZA9fAF1JQbfWgTuuVeEc+9T53Y6QHrTcJIHB/76I3BK5O3YR58wDvogDXsTlskS23M5ahtUVwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641759; c=relaxed/simple;
	bh=ViIB3ZUka+cm+G4iKklUTITvb7PG+0M2Kii8KWLAzVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JGMWryUAEI16gRsdxoqX5ze0vWnXmynU8F/rX5r2N/1YhVl9j5vNpdCawppgJoZtSNFulwstHP4HPuzzIGwQkkjGSrWQ3JeqKdLIeRdb+ml3DvJ0clOIlkQhDLMzgWtmPSLrkuBhZ1LbuuO5pkrNp7oDO4RJ0fqXZqxSlM5kNJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Aon4QGlN; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-408778a8ec4so1293563fac.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2026 08:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772641756; x=1773246556; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P/5lhk6C8jE/PS2fAtX4oJhx14kIa3UNBGxkwqnfz2E=;
        b=Aon4QGlNcdV7jt762eL0TpKisfaeXyVLFH82ns+6auDeoj1os9fzW/dM035AgrIW4E
         lskgt4U0BVTxXAvPj0UJrdFYnCRej8zw2i9AD1vmEn/3O4CipEka5a/2/hWNGnTYiTmD
         cbm+1VtUcXzfxueob2a3eI92GevhOhffHHfplwXbzZD4K8BuQ+xSftH0wizKkIbbWRYR
         nRyn1/aK2ir48umzQbp3uqPtjS8BiBR8faiQTqiHqqwFlhlm2Onem0jO7FEOX7Fc9DLE
         1g2ENP2CTf/sm75VANWVCDqOCU+lyNOaninbfYWotIgAXDn4NhavwHnWHSv0E/4f6qxl
         nFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641756; x=1773246556;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P/5lhk6C8jE/PS2fAtX4oJhx14kIa3UNBGxkwqnfz2E=;
        b=Ev7xDjes1KU0THmtrSRcZvIwRP1I6bSewqj2GNVx6zEKLhY950YOatLPCtg/3v6AtN
         JwBl1OydwrjT/BKaD0mxbENATp17H5QRDEiutD3/ahQyKZkTCaXcYjp6fHEgR4lYc6yU
         n+F2NmZIDHAT8AY53hg/7nIY3/nLgaWXSAtXqaw6AKCAeDxm/4aiB9bkMy4VHN1XklT8
         hat+KTF3eBuTnHNMI3o+KU8j6RFF54fjh/OkI9Vw73QZFMmQvWxQeGLsMP69alJqKN0d
         E0ysnKuLr3qns/pqal9YUo1qC+6JMNWIQ+wiRmIpc4b58mh/F1Z7vIRXJTaD7zKS7myu
         ZR8A==
X-Forwarded-Encrypted: i=1; AJvYcCV+MCGtKd/z3QLR61rQ/LurCgMLfrRjTSF66XR6ZcgdFI27l7nM7FqwqLaSimZuwQ3dcApXCmCBAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEvXtJbtcYb40b9UHBFXpM/0kbYv7RnSTFqpkO6oQ0jZelthNk
	m3X4O/zrRsuQWnPH4kz9Pz1h1GMZCmUHPLTm/6hWDa/Gbad+tb5xv3vhnkR/kMmN1L0=
X-Gm-Gg: ATEYQzyct0aicHkLMog58ORoTsi22Xw3hYICr0FJBgrolBsQwS7igTm/3EbhJBiiu5/
	BJBXdbaXrshUzlREYrdXCbPqljWuW4aZdTHzSnzCHLOMvckoBu6/AYYxwf8hd9+Hv2RM5sIFWzw
	ZROGWlOC6leEcEvBe7oErSRAcXqU7fq1/En3ddfcp6gp3q+hLwldWXKi5j2jgZyD9Z3YIyKS18q
	crJ+n3g9HucoQ1BBkWEYi9pHbr5WfgD4EI0khwjgbYd+Oh6IpWfdAibu0pvfojMnNMpUQHqpoGX
	jeC3p9YfrfdRck6JHQryk2As3SRPn2MXhBSRS90SGg3Qj7VwbzpjDpeJn5vBlZZ04rDXKiVYGJJ
	+ou12XayqSH05X/pSJZeam5ZCtaGGgHMvTSia+BaGeKo7norMeHbEusqhLUr+02daD8a4lWHcXd
	ibJFvfUWaZsWjIEnRN1Y3ECWdipB4Dq/64gV9eJbf7vdfYqqnK/kaHrNb1o/tNLNtNHbrKm0bm5
	8KlyJcM09gtRUJqJ+ua
X-Received: by 2002:a05:6870:d68f:b0:409:5241:8abc with SMTP id 586e51a60fabf-416ab5fd865mr1373419fac.20.1772641756143;
        Wed, 04 Mar 2026 08:29:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf9b24dsm18350522fac.7.2026.03.04.08.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 08:29:15 -0800 (PST)
Message-ID: <a6591d03-3707-4f1c-b1fa-49f010f98d53@kernel.dk>
Date: Wed, 4 Mar 2026 09:29:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
To: Caleb Sander Mateos <csander@purestorage.com>,
 Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com> <aagKTanM5Az9UDsJ@fedora>
 <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 029DD204987
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12556-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:mid,purestorage.com:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 3/4/26 8:46 AM, Caleb Sander Mateos wrote:
> On Wed, Mar 4, 2026 at 2:33?AM Ming Lei <ming.lei@redhat.com> wrote:
>>
>> On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote:
>>> A subsequent commit will allow uring_cmds that don't use iopoll on
>>> IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted without
>>> setting the iopoll_completed flag for a request in iopoll_list or going
>>> through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command could
>>> call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
>>> io_iopoll_check() loop currently only counts completions posted in
>>> io_do_iopoll() when determining whether the min_events threshold has
>>> been met. It also exits early if there are any existing CQEs before
>>> polling, or if any CQEs are posted while running task work. CQEs posted
>>> via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counted
>>> against min_events.
>>>
>>> Explicitly check the available CQEs in each io_iopoll_check() loop
>>> iteration to account for CQEs posted in any fashion.
>>>
>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>> ---
>>>  io_uring/io_uring.c | 9 ++-------
>>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 46f39831d27c..b4625695bb3a 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
>>>               io_move_task_work_from_local(ctx);
>>>  }
>>>
>>>  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>>>  {
>>> -     unsigned int nr_events = 0;
>>>       unsigned long check_cq;
>>>
>>>       min_events = min(min_events, ctx->cq_entries);
>>>
>>>       lockdep_assert_held(&ctx->uring_lock);
>>> @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>>>                * the poll to the issued list. Otherwise we can spin here
>>>                * forever, while the workqueue is stuck trying to acquire the
>>>                * very same mutex.
>>>                */
>>>               if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
>>> -                     u32 tail = ctx->cached_cq_tail;
>>> -
>>>                       (void) io_run_local_work_locked(ctx, min_events);
>>>
>>>                       if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
>>>                               mutex_unlock(&ctx->uring_lock);
>>>                               io_run_task_work();
>>>                               mutex_lock(&ctx->uring_lock);
>>>                       }
>>>                       /* some requests don't go through iopoll_list */
>>> -                     if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
>>> +                     if (list_empty(&ctx->iopoll_list))
>>>                               break;
>>>               }
>>>               ret = io_do_iopoll(ctx, !min_events);
>>>               if (unlikely(ret < 0))
>>>                       return ret;
>>>
>>>               if (task_sigpending(current))
>>>                       return -EINTR;
>>>               if (need_resched())
>>>                       break;
>>> -
>>> -             nr_events += ret;
>>> -     } while (nr_events < min_events);
>>> +     } while (io_cqring_events(ctx) < min_events);
>>
>> Before entering the loop, if io_cqring_events() finds any queued CQE,
>> io_iopoll_check() returns immediately without polling.
>>
>> If the queued CQE is originated from non-iopoll uring_cmd, iopoll request
>> will not be polled, may this be one issue?
> 
> I also noticed that logic and thought it seemed odd. I would think
> we'd always want to wait for min_events CQEs (and iopoll once even if
> min_events is 0). Looks like Jens added the early return in commit
> a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs
> pending"), perhaps he can shed some light on it?

I don't  recall the bug in question, it's been a while... But it always
makes sense to return events that are ready, and skip polling. It should
only be done if there are no ready events to reap.

-- 
Jens Axboe

