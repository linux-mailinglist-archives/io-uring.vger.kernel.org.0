Return-Path: <io-uring+bounces-12704-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBtRKOGAuGltfAEAu9opvQ
	(envelope-from <io-uring+bounces-12704-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:14:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF272A15A1
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5285530DA841
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B706371CE4;
	Mon, 16 Mar 2026 22:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xO0ch5ma"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CEE139D
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 22:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699089; cv=none; b=bg2i0pkDADMdkY+W3BzMDoJWPME00XwIUGtj53zsc6mY32JODnMTH2YzGjNZv/D2aw2ad4G3UiibcIYxvGuvDRkmNE1u+HnObZruGtlgCnZ+zldUkZ1D/JByb8rzGjYWvQ2BPkPP3r2utuq4poNmgWHrjgvFht6CKH7rmq+TUDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699089; c=relaxed/simple;
	bh=nJOilR8qSyWZZzgS1PCd/nuXq0Qh5RcuYaeD4l0HmZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TytsSC831TZiE4rLMoQiSTgF7gtGV1AmxQUxHoeCh55Cym5VtIOoDWg0mhidVz4j2RiUy/MSo2Osj10YdN0ZirKZfX4HYL8rt5Ze0Y51H3Tt0b39w+gHKU426lga2mMnhVVWdIFvG1X18jLz0cryCygOkNr6niAV9FbQLmgdpZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xO0ch5ma; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4043b909ed4so3202058fac.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773699085; x=1774303885; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNqYWrRFGodaMOG+fMFfMLFfzEQ/Hrz19UG5a14j8/I=;
        b=xO0ch5maDRLXh01I2MkihfZcE/ihTiDkSALF2duxReStIph3vv28J+VwAfWWnj0L2G
         wWYTBPYRPQmX3nnm0Ym65X943U06dbA4ynV4lYYrn2LZIDL9UXgr6uimHgyxF3AzN2xj
         SAKEFGLFc1eS83VFs7yeO+5AmHQtBnFvpls4LlciEh7Kp+FrzeQenhd70+9l7FQNDzp8
         33fgEqj3PB68qZJ4+HnL44dQ3KAdyJcjN8JiKrxTKJmWsH1WEp2nnEStDvIs9ROMkYID
         Se+9YJYhsI0VXpMfMxZeVH9psfutZnAJUoE5xh/Dza9qQSLkXHPT/LZ3gKz4sde68U7D
         s0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699085; x=1774303885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNqYWrRFGodaMOG+fMFfMLFfzEQ/Hrz19UG5a14j8/I=;
        b=ESmeQ2A428dKqNiV36y6IASiWyM/BHiagQpd3jOSAzAR22AgSZwmNZ1AT93heapr4X
         c5khp7dBAQqqVwz7DBSZtpK4G6i8c/PIfcLAA0qk38+UbnuJsWX7GC5J3RM2n37xD6C/
         I7C+gCHne3If6XM2yMvt34tb6KKgDisN+qvcuDXi6tATsHuWpJQanZ0t7EdePfx3IGSx
         ZNhoOZCRnjvfolyjLUCIR54HGcGRViPWQ/OH0mxoCnqb/yzUr427HP34Bv/Nn3L3lYEQ
         7tcCuoodDrcOFey+yjFrCKuh7+AnB6RxrIreFAJdvaGsowAmSp0LsPRZ16GTt7GYPb/x
         koVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwouIzs8NhviNqv22WUc8q7CBOEG8Dyg7MI/Gu7HIqjanx+ZcIsfugRXuk6rLARQ6EIE5yHgEeBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgrXNmuxNmeyRkS300S7r88ZGmmDI7jClbp8OhRzk2Bg6UHGl2
	uHd325CoTwBdzTs5X6oO/DSISeHZP2m5KIFbawAlIMbK92L8MF8d7ucZ3JI9nMBHIBc=
X-Gm-Gg: ATEYQzyw/KvWahpfx4lbzH39/VdN+rIue40p0sk6nObtbEt4HQ8xyiKIKDI/3z/k7iE
	9GQ6ynaGX2gf16LSqEWLhg00/hZt2kHMCU3b11nhPZhWVNYCuF+PCGVqpwTHIsK5V9Lt7XDhAJ5
	DGQ0AQllbEFtoF0ftddO7Zb25igqFVGLm3nzKZwYJrafG6h+NGkwGxJP6AUJFC9MYequFRNZttK
	Tj5+ceTUQjRbHhkKVdn+ilQkeoSeY0L/47e1XjtWK7r0uaVT6myeO2+Hhx8EhYNw5bMuZJb2FS5
	VrbTUGR67qAlgo1zvyKvK+QY5m6lAq6/fG8OsONdgzlNALOg2N6z1ddkXA91i6/D3aQxkNG/F2z
	lmU1/wjyXjRQL0D9LGoeKsIcMO4nDHNssPNNeK2S7GWAKhnWRYgDKDacQkoajU1mPx55j/1+Yn7
	1U2rU22f2Y3ggSb7yQPJYr84hYxP3dX1eS4xbhIwG557DZx/U502wLJ6lLh6e340yCXlJzJhl/d
	h86y3fAaQ==
X-Received: by 2002:a05:6870:63aa:b0:417:1726:9076 with SMTP id 586e51a60fabf-417b93c709cmr8308716fac.29.1773699084609;
        Mon, 16 Mar 2026 15:11:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6e82cdsm18056067fac.18.2026.03.16.15.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 15:11:24 -0700 (PDT)
Message-ID: <7dfb5a9b-9af2-4463-b9a1-0eb680fd6c47@kernel.dk>
Date: Mon, 16 Mar 2026 16:11:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
To: Ming Lei <ming.lei@redhat.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com> <aagKTanM5Az9UDsJ@fedora>
 <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com>
 <a6591d03-3707-4f1c-b1fa-49f010f98d53@kernel.dk>
 <CADUfDZp0shyZ5FqfEcwbi0tHXOFqwqZKRvwQW=heR-yvaOaw0Q@mail.gmail.com>
 <aauO72ocnZRhJkiA@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aauO72ocnZRhJkiA@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12704-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: EDF272A15A1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/6/26 7:35 PM, Ming Lei wrote:
> On Fri, Mar 06, 2026 at 05:38:15PM -0800, Caleb Sander Mateos wrote:
>> On Wed, Mar 4, 2026 at 8:29?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 3/4/26 8:46 AM, Caleb Sander Mateos wrote:
>>>> On Wed, Mar 4, 2026 at 2:33?AM Ming Lei <ming.lei@redhat.com> wrote:
>>>>>
>>>>> On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote:
>>>>>> A subsequent commit will allow uring_cmds that don't use iopoll on
>>>>>> IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted without
>>>>>> setting the iopoll_completed flag for a request in iopoll_list or going
>>>>>> through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command could
>>>>>> call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
>>>>>> io_iopoll_check() loop currently only counts completions posted in
>>>>>> io_do_iopoll() when determining whether the min_events threshold has
>>>>>> been met. It also exits early if there are any existing CQEs before
>>>>>> polling, or if any CQEs are posted while running task work. CQEs posted
>>>>>> via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counted
>>>>>> against min_events.
>>>>>>
>>>>>> Explicitly check the available CQEs in each io_iopoll_check() loop
>>>>>> iteration to account for CQEs posted in any fashion.
>>>>>>
>>>>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>>>>> ---
>>>>>>  io_uring/io_uring.c | 9 ++-------
>>>>>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index 46f39831d27c..b4625695bb3a 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>>>> @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
>>>>>>               io_move_task_work_from_local(ctx);
>>>>>>  }
>>>>>>
>>>>>>  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>>>>>>  {
>>>>>> -     unsigned int nr_events = 0;
>>>>>>       unsigned long check_cq;
>>>>>>
>>>>>>       min_events = min(min_events, ctx->cq_entries);
>>>>>>
>>>>>>       lockdep_assert_held(&ctx->uring_lock);
>>>>>> @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>>>>>>                * the poll to the issued list. Otherwise we can spin here
>>>>>>                * forever, while the workqueue is stuck trying to acquire the
>>>>>>                * very same mutex.
>>>>>>                */
>>>>>>               if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
>>>>>> -                     u32 tail = ctx->cached_cq_tail;
>>>>>> -
>>>>>>                       (void) io_run_local_work_locked(ctx, min_events);
>>>>>>
>>>>>>                       if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
>>>>>>                               mutex_unlock(&ctx->uring_lock);
>>>>>>                               io_run_task_work();
>>>>>>                               mutex_lock(&ctx->uring_lock);
>>>>>>                       }
>>>>>>                       /* some requests don't go through iopoll_list */
>>>>>> -                     if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
>>>>>> +                     if (list_empty(&ctx->iopoll_list))
>>>>>>                               break;
>>>>>>               }
>>>>>>               ret = io_do_iopoll(ctx, !min_events);
>>>>>>               if (unlikely(ret < 0))
>>>>>>                       return ret;
>>>>>>
>>>>>>               if (task_sigpending(current))
>>>>>>                       return -EINTR;
>>>>>>               if (need_resched())
>>>>>>                       break;
>>>>>> -
>>>>>> -             nr_events += ret;
>>>>>> -     } while (nr_events < min_events);
>>>>>> +     } while (io_cqring_events(ctx) < min_events);
>>>>>
>>>>> Before entering the loop, if io_cqring_events() finds any queued CQE,
>>>>> io_iopoll_check() returns immediately without polling.
>>>>>
>>>>> If the queued CQE is originated from non-iopoll uring_cmd, iopoll request
>>>>> will not be polled, may this be one issue?
>>>>
>>>> I also noticed that logic and thought it seemed odd. I would think
>>>> we'd always want to wait for min_events CQEs (and iopoll once even if
>>>> min_events is 0). Looks like Jens added the early return in commit
>>>> a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs
>>>> pending"), perhaps he can shed some light on it?
>>>
>>> I don't  recall the bug in question, it's been a while... But it always
>>> makes sense to return events that are ready, and skip polling. It should
>>> only be done if there are no ready events to reap.
>>
>> Ming, are you okay with preserving that behavior in this patch then? I
>> guess there's a potential fairness concern where REQ_F_IOPOLL requests
>> may not be polled for some time if non-REQ_F_IOPOLL requests continue
>> to frequently post CQEs.
> 
> IMO, the fairness may not a big deal given userspace should keep polling
> if the iopoll IO isn't done.

I think so.

> But forget to mention, if non-iopoll CQE is posted and ->cq_flush becomes
> true, io_submit_flush_completions() may not get chance to run in case of
> the early return. 
> 
> Maybe something like below is needed:
> 
> @@ -1556,8 +1556,10 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
>          * If we do, we can potentially be spinning for commands that
>          * already triggered a CQE (eg in error).
>          */
> -       if (io_cqring_events(ctx))
> +       if (io_cqring_events(ctx)) {
> +               io_submit_flush_completions(ctx);
>                 return 0;
> +       }

We should probably experiment with this a bit, I don't think it's a
showstopper for merging this.

Caleb, I think we can stage this for 7.1 and see how it goes.

-- 
Jens Axboe

