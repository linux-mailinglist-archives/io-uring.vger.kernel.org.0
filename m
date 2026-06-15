Return-Path: <io-uring+bounces-13734-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id YxqvMxg+MGpaQQUAu9opvQ
	(envelope-from <io-uring+bounces-13734-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:02:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E71689079
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:02:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=xd6jsN4a;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13734-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13734-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 636BD30DEF39
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9302BE035;
	Mon, 15 Jun 2026 18:00:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD632DEA94
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 18:00:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546413; cv=none; b=rBVWAe0NDMtMcObMxMv9XzttcCk4d5Aw9MQTxzvsOZ6igx6guuMnnTPLoLW0dQ8hKQMGsGnH/F0wa1R8tIN/19t4fpR+TPiEOJy5oO/GdFCaUPRevsqMZ1cKnsWtLfwTRuSiEw1RJ8Pa1uNzncvV06v/eUDdQTeWoZ5wUbb9olY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546413; c=relaxed/simple;
	bh=FhB5IKvETl9tr3uSXyaeUMbzIwn2x9HnxbzhzWXOdo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nz7xWOCWYUOTBfo02QK8tdeL7xH9yqMhAzUvzwHJVYfEEheMb+dkLW7m4E8j9JFkEd0pYF4vD5paIUpx3jaiiqfNDdL3GbItpWeFcYDeKQiIoOVBpNsIjsK7pMdPC3mqJhb8uCiX0gRbsPrpgyKM1kCVABPR4+ttZeT9P7mx8+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=xd6jsN4a; arc=none smtp.client-ip=209.85.210.53
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6b5c374e5so3726469a34.0
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 11:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781546410; x=1782151210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UOe01Yj2Vs0VmRC4WVK1SS5YvRC9kV92IGvBS34R49E=;
        b=xd6jsN4aWI03oopWSh4IlFMs9JYcoo/U+znqXwcAzJH3Pypac4w/oe5Ot4NxsnF0Tx
         3ba6QgLVIIKvu2oohrjWGuBPEMy/VEVUUSJKrWrr0w1Z/EPgr+VRjd/PVONBW2jmtMyq
         C2iK4+v7CeF1fWO+HDyfTBT4jbULq+yKkQzeXH33uUurK1kcE3rkqzDVNuLBnIaoMabj
         qhW03KHJAdgBS/nANXlrMCbENwBBFuxMe5fTRibuoygpJNNx7Gj/KsH2MXRLh8wR5y2s
         QpKRAGebDNKrVu9uAd6JvkJqNUuPOLymEbtG35FTiK0PkNCdNPoPTr9gdainEK6I5oCe
         RWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781546410; x=1782151210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOe01Yj2Vs0VmRC4WVK1SS5YvRC9kV92IGvBS34R49E=;
        b=cYwkAupyhxBWrAN7W08O4xpuHs9fRy58X/EkWKsNhJJgTf5eylgOqosBQI65AaxwwJ
         vBsuTSXHgkCljIo0BWLEW5vYcCe3ENpJ+Tu++iUBGrB4daRCy/pFU9RFWmlSzQaPmNlK
         KZx4Diwom1kpssHjh2Ibd2wF7h1BgyYPbNTom6Qegp72TAVoO2qZwNwQDQNT8zmzhRsL
         JptjjeYGPbV2H7TfAg0RTz/aelVBmL8HLn1KraUstbbu5mtIlGHHZWVk6RdXyriJ7s+E
         oD5QYvlpDOYH3MRFT1r7Y+/kkeJ5gAS5Fs+iOCNE79GrKVrpBahvzgZGguwBzuCpFI8f
         1bXQ==
X-Gm-Message-State: AOJu0Yx4I9561eOlEfxpaGSGsMeuc2w0iu0mSIWLNti9SLhlu9/wWA/J
	3XKQRNERGh4fuYtQ/vVaYf3/cX3HkdS2Bvci3zA1MQRdujqLCG2rKlFM8WuPHnYKSJmHdwvz5tO
	fqpmQt+g=
X-Gm-Gg: Acq92OFiSEJh8tH/FxkGWP+mkg8X8PTjyKjvSvEdJMfy+ylfJD7TI2X1lj97lV7KwOu
	cX4CcTzDGAuRdSmN0h5eHTCfJF3Ys2PvwP63l0SMtyhZI4wvoUVJDQ8FfK3cNP4dTFLEMst/zXP
	lRK8SL2veJVo29KG9ERRMWArs4APOuS8pOjEq6PXsYJ7n2xXx8Fq/b3B8FmSawoH3km84tI9rgs
	BTAdQQXh/uJs468shxcZJxcBZGYqkZWFb5/KW4OIO//XO862XlKniZV2F8gY55cSvtX/9AxVxVa
	ZDfwksB8Wq49uyrDo3IavyGqtsHXlNSCjGFV14d/PMMcth+v6vcRKaynp1slARIf3oeOQhzzTej
	WldsPXmDKXfOpJQiIPxteogqU12L83xZEpz/dzHgalXLsJI1Ogpnhhq3+JnM2PMRQr3U/kGiQLI
	/lTgtqXVxBXnatF7tvZHFt/aVicW6+Fc5fvyZgUezV5ndUYfev9tAfY6Fbl4FayUZgqX6AkLsIR
	XtAY9JX
X-Received: by 2002:a9d:62d5:0:b0:7dc:c501:afbd with SMTP id 46e09a7af769-7e8fc946394mr172600a34.10.1781546410218;
        Mon, 15 Jun 2026 11:00:10 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f6b8624sm4527230a34.16.2026.06.15.11.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 11:00:09 -0700 (PDT)
Message-ID: <e0e6a5da-054e-494b-aad8-be08f040750f@kernel.dk>
Date: Mon, 15 Jun 2026 12:00:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: switch local task_work to a mpscq
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
References: <20260611160553.1486640-1-axboe@kernel.dk>
 <20260611160553.1486640-3-axboe@kernel.dk>
 <CADUfDZrzwvY6UpBBhLj1JynuNf5bo140+LbMYDOvU13=od+nkQ@mail.gmail.com>
 <4be7a6db-44bc-4125-867e-9d22c2809f1c@kernel.dk>
 <CADUfDZr-MMYBaP-e+y9+xuRhuiunO2sBTUCmwZyd7AgT8sVtiQ@mail.gmail.com>
 <1af6602f-590e-4ca5-b034-b09b3f40a8d1@kernel.dk>
 <9232ba9e-2ea5-4ed2-9043-15190e0f5d0e@kernel.dk>
 <CADUfDZoEhdom7cqRfKhMkhhRc0vmRpzRR-AZXndMhLnLa9KqYg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoEhdom7cqRfKhMkhhRc0vmRpzRR-AZXndMhLnLa9KqYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13734-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 21E71689079

On 6/15/26 11:55 AM, Caleb Sander Mateos wrote:
> On Fri, Jun 12, 2026 at 8:11?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/12/26 6:21 AM, Jens Axboe wrote:
>>> On 6/11/26 11:24 PM, Caleb Sander Mateos wrote:
>>>> On Thu, Jun 11, 2026 at 7:23?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 6/11/26 7:14 PM, Caleb Sander Mateos wrote:
>>>>>> This is great stuff! I had also observed these hotspots on a ublk
>>>>>> workload. Since incoming ublk requests post task work to the ublk
>>>>>> server's io_urings and completed ublk requests post task work to the
>>>>>> client's io_urings, there is significant cross-CPU contention on the
>>>>>> task work queues.
>>>>>
>>>>> Glad you like it! Once I post v2 tomorrow, perhaps you can try and run
>>>>> some tests with and without and see how it does for you?
>>>>
>>>> Haven't tested v2 yet, but v1 shows a 4% IOPS improvement on a ublk
>>>> 4-KB read workload. The workload has 8 CPUs (unpaired hypertwins)
>>>> running fio with io_uring submitting I/O to the ublk devices and 32
>>>> ublk server CPUs (paired hypertwins) servicing the requests, achieving
>>>> around 4M IOPS. Both the client and server CPUs look completely busy.
>>>
>>> That's a pretty nice improvement! Would be curious to hear what v2 looks
>>> like.
> 
> Looks the same as v1, which makes sense as both the client and server
> are using IORING_SETUP_DEFER_TASKRUN.

OK, sounds good.

> I did observe fio seem to get stuck forever on one out of the 85 or so
> runs, though. I'm a little concerned there might be a missing wakeup.
> It was using the default iodepth_batch_complete_min=1 (waiting for
> io_uring completions) and IORING_SETUP_DEFER_TASKRUN.

There's a bug in v2 where it can get missed, the in-tree code should
have that fixed. It was the atomic_dec_and_test() and
atomic_try_cmpxchg() in io_req_local_work_add() racing.

>> And here's some more stuff on top you might find interesting. For a
>> 6 NVMe drive test, it drops my task work usage from top-of-profiles
>> to ~2%.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-tw-mpscq-batch
>>
>> The patches sit on top of the io_uring-tw-mpscq branch.
> 
> Yeah there are some interesting ideas there.
> 
> The ublk server isn't using UBLK_F_BATCH_IO, so it unfortunately
> wouldn't benefit from the task work batching for
> UBLK_U_IO_COMMIT_IO_CMDS. The batching would probably need to be
> scoped to the whole io_submit_sqes() in order to allow batching across
> the multiple UBLK_U_IO_COMMIT_AND_FETCH_REQ commands. I'm also not
> sure about the claim that __ublk_walk_cmd_buf() won't sleep;
> ublk_batch_commit_io() calls io_buffer_unregister_bvec(), which could
> sleep depending on the io_uring issue_flags.

It's very much just a POC series of things... I suspect to get the
benefit of it, we'd need a bit of refactoring and reworking first. It
was more to get the idea out/across, not going anywhere right now.

> The NVMe passthrough task work batching could definitely reduce
> contention on the task work queue. I'll run a perf test.

Thanks!

-- 
Jens Axboe

