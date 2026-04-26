Return-Path: <io-uring+bounces-13144-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id PAfYAux/7mnqugAAu9opvQ
	(envelope-from <io-uring+bounces-13144-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2026 23:13:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FDC46B345
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2026 23:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B68CE300F9D8
	for <lists+io-uring@lfdr.de>; Sun, 26 Apr 2026 21:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB902ED866;
	Sun, 26 Apr 2026 21:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PH1bxdkj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57D279903
	for <io-uring@vger.kernel.org>; Sun, 26 Apr 2026 21:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777237993; cv=none; b=nCCihIgShsel1p7KWCZwMg3knx1HNiYqGTg1wGHXqLDvmvT+2tDPrXgc2Cru5YWKyLTqck8C4q1n8YeKwGG1KI/DAOGhYZhtS7v8uAHiYLf6JatKu2w6HnW5ugBqPb6aS/X1ZTQujG9YCRLQ7YEqUF9C9UAKX0ZZYXv3H/RmM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777237993; c=relaxed/simple;
	bh=wsdfNcrZy93MbBDuIbxBX6cgUxvT0ZtMQSc98Ez9Xcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRafjQdHcufhVLkmDBjuS9QWPwg9vbZTAn0mCEvw0VOuqrAlgQBk3WdAVi6tJmQ1FZF788nPTBcpF+ett951FBWX8ecdPrxA1PKFTT46TpCj5Dg8qzpRdcaGSC4/tcpi57LzVXBTfeLGoUhzOiKB8Ebu4oXPlkvw6UHAGVWQt2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PH1bxdkj; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7de5badb627so1397131a34.0
        for <io-uring@vger.kernel.org>; Sun, 26 Apr 2026 14:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777237990; x=1777842790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FhjcvqjgkBH6Sxsal52sLzukZrbOB6Eq8B3GEhu1qbk=;
        b=PH1bxdkjDZWeYS6oxZbePF0jqABRZMowbFi80Igf9YfEFP9C4z4sJ4xkD/jLajtDxT
         AyWKXZv9bAnm1MWGF1DQojm0h3O1EBLIX23yTACroTE0nOsVALNRNv/V1tjWbceuRF2/
         F0e334bRYCHeAn1lR06MA7nyrVgBcgw+p/VbFPO1rWf5IgYWjqzmV+N6c9YJdt5u9gzP
         Q9Z2iH+W0IOnv3LDmbh8ktvk1wwkOKSedOAI9jOtbW76i4tT0IwQFQuwjDmjiRP1sdyx
         MuATeqMLLTRDBUVBveNO2mjUSmnADKBUpX7eFkKQfcLNg7Ii728BfEXab+Dp4OzcHuNT
         z5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777237990; x=1777842790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FhjcvqjgkBH6Sxsal52sLzukZrbOB6Eq8B3GEhu1qbk=;
        b=oEpBP+6HtxLz/Yf2G2HzHDxf0VS0fdL1qAUqQi1J+B7iQI3j3/WsS8P4wKEyxPTbIQ
         z8MAl28pat5fsrtwV9ZnL2FlDhdbbEwb9jJY/eZ0LTwdzySLXN/6sw3wIvdIocYq7GQj
         BadJ6ULuauMBP5pn0c9prPvm8JdSiE01kKU4q05KoJ0v4UbyO3JCks4FYmgELVYexp4X
         RbAOthUMbYtj/5rJ2vW3yFlXIyCqBVrWcbLIl7oXQm84QrNkffVOk0/tO8vxixpgA/BH
         6O5MOx+YTFNOVaoKRM/idYlTvUmNpWCCak6bkGm4xyPOS7BCPCJoBoEJsMdmyYkk4F54
         w/AQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Xz9z5q+nLHe3qs+IP4nP+pbTfHlPs8Fdv5Ux2A6Y9M6CtIoXiLg/Ht1pMiOnUAFfeVJvH4BiwLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxlpd04PJTp1cD3ZGGI/OrKg/QPHDqaqqf3ddRWeF1YWdwOFD
	X0BhajPbE+/yhsjS4zG2Okr+C3f+eiMJzgLqVrTvYiTXyV6qa8s//gj1YdavKQHhswkeSu+8DVT
	GHpN37nY=
X-Gm-Gg: AeBDietpSbEo+0khPCP2mPzxfrtMsATF+L+HIje4qoZJg0Y6sDejAnJ06+rQGwPA/y4
	ZUhFJ3Yyue+6vOF9CSWkfLSpWDJKaM037vA0UOnAqCkS2hABuY+rKdGsWsVJ7uP0Bc5BQV+wtgd
	qz8E40hbNE3tjS/o/z2O7Wt3Ql2/vMMJr6rUA+IWogpqGDrXqOwUoj0VuAzNhnUl1949df5aAPO
	Oh9KjYEfcIrpI+xKway3t6UTFAtp8AVpoh6yxuZ8Gyi5WoJFtih2/MBMKxNI4Bm5ZbJC8j+4fWK
	6CqnkU1g9D8kLz2UT6VnB7UjkrvNDwE9c/m0DPLSIWBctSZ08c/WTW5YeccKk2LgDjgUMJc9IPC
	pKpxV6fJygGn2aq8poAbU43mUHzzmWZlYs98NU93UYP4ghOlZfkEUtNIPSw0l5174yaqrlF3FXk
	yYJ11nH4WQL6tsu5Bla/fuA6yOMGCYpA23mCgEbDGid2RaTP51FCy9cE1u8BskXf/HKmvAj/+vF
	lnIyrPksoAgV45Iu67f
X-Received: by 2002:a05:6830:67ec:b0:7dd:e032:3cec with SMTP id 46e09a7af769-7dde03240ffmr12010923a34.21.1777237989848;
        Sun, 26 Apr 2026 14:13:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcdbef352bsm14859617a34.10.2026.04.26.14.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2026 14:13:09 -0700 (PDT)
Message-ID: <a47f672c-d204-433f-9815-9e6606fdec1f@kernel.dk>
Date: Sun, 26 Apr 2026 15:13:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring_prep_timeout() leading to an IO pressure close to 100
To: Fiona Ebner <f.ebner@proxmox.com>, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, surenb@google.com, peterz@infradead.org,
 io-uring@vger.kernel.org, Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <14bc6266-5bc9-4454-9518-d1016bfe417b@proxmox.com>
 <49a977f3-45da-41dd-9fd6-75fd6760a591@kernel.dk>
 <bec202bd-cf01-4423-b3f6-f551bf269c8f@proxmox.com>
 <563f9b5f-9649-4a98-9025-671af55f29d7@proxmox.com>
 <db7e6abb-677b-4b63-a028-d8fe0bec0277@proxmox.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <db7e6abb-677b-4b63-a028-d8fe0bec0277@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45FDC46B345
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13144-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]

On 4/24/26 9:42 AM, Fiona Ebner wrote:
> Hi Jens,
> 
> Am 02.04.26 um 2:30 PM schrieb Fiona Ebner:
>> Am 02.04.26 um 11:12 AM schrieb Fiona Ebner:
>>> Am 01.04.26 um 5:02 PM schrieb Jens Axboe:
>>>> On 4/1/26 8:59 AM, Fiona Ebner wrote:
>>>>> I'm currently investigating an issue with QEMU causing an IO pressure
>>>>> value of nearly 100 when io_uring is used for the event loop of a QEMU
>>>>> iothread (which is the case since QEMU 10.2 if io_uring is enabled
>>>>> during configuration and available).
>>>>
>>>> It's not "IO pressure", it's the useless iowait metric...
>>>
>>> But it is reported as IO pressure by the kernel, i.e. /proc/pressure/io
>>> (and for a cgroup, /sys/fs/cgroup/foo.slice/bar.scope/io.pressure).
>>>
>>>>> The cause seems to be the io_uring_prep_timeout() call that is used for
>>>>> blocking wait. I attached a minimal reproducer below, which exposes the
>>>>> issue [0].
>>>>>
>>>>> This was observed on a kernel based on 7.0-rc6 as well as 6.17.13. I
>>>>> haven't investigated what happens inside the kernel yet, so I don't know
>>>>> if it is an accounting issue or within io_uring.
>>>>>
>>>>> Let me know if you need more information or if I should test something
>>>>> specific.
>>>>
>>>> If you won't want it, just turn it off with io_uring_set_iowait().
>>>
>>> QEMU does submit actual IO request on the same ring and I suppose iowait
>>> should still be used for those?
>>>
>>> Maybe setting the IORING_ENTER_NO_IOWAIT flag if only the timeout
>>> request is being submitted and no actual IO requests is an option? But
>>> even then, if a request is submitted later via another thread, iowait
>>> for that new request won't be accounted for, right?
>>>
>>> Is there a way to say "I don't want IO wait for timeout submissions"?
>>> Wouldn't that even make sense by default?
>>
>> Turns out, that in my QEMU instances, the branch doing the
>> io_uring_prep_timeout() call is not actually taken, so while the issue
>> could arise like that too, it's different in this practical case.
>>
>> What I'm actually seeing is io_uring_submit_and_wait() being called with
>> wait_nr=1 while there is nothing else going on. So a more accurate
>> reproducer for the scenario is attached below [0]. Note that it does not
>> happen without sumbitting+completing a single request first. 
> 
> I started digging in the kernel now and am wondering whether the number
> of inflight requests is correctly tracked? Does current_pending_io()
> need to consider tctx->cached_refs?
> 
> In __io_cqring_wait_schedule(), there is
> 
>> 	if (ext_arg->iowait && current_pending_io())
>> 		current->in_iowait = 1;
> 
> and current_pending_io() is
> 
>> static bool current_pending_io(void)
>> {
>> 	struct io_uring_task *tctx = current->io_uring;
>>
>> 	if (!tctx)
>> 		return false;
>> 	return percpu_counter_read_positive(&tctx->inflight);
>> }
> 
> so okay, we get iowait when tctx->inflight is positive. Looking at where
> that variable is modified, I found
> 
>> void io_task_refs_refill(struct io_uring_task *tctx)
>> {
>> 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
>>
>> 	percpu_counter_add(&tctx->inflight, refill);
>> 	refcount_add(refill, &current->usage);
>> 	tctx->cached_refs += refill;
>> }

> as well as io_put_task() and io_uring_drop_tctx_refs().

Indeed! Care to send a patch for this? That's definitely a bug. The
existing test case didn't hit this as it only tests with an actual
request pending, and never after refs have been cached.

Thanks for looking into this.

-- 
Jens Axboe

