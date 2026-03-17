Return-Path: <io-uring+bounces-12718-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABd2BP6quGkthAEAu9opvQ
	(envelope-from <io-uring+bounces-12718-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:14:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FAA22A27D8
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F7D8301809C
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 01:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C79C24A047;
	Tue, 17 Mar 2026 01:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QgNqWUWZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA8026F291
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773710058; cv=none; b=ZgV2xr39y9nNncbo+aEZqgjbNNJcQ1qjC5LNgCxTE5x4oQh9uPAcz5xEtE4OHuM/ogoYPQvMmbRerq4KoGq8dO64f6fWJKQdQzbiMm0vbuxIG+r6Qn660Fvbfp6ojAGZpRJYGHY10h8bF8snmjEH+yLjGUAQHjPxTz6LTaKdTbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773710058; c=relaxed/simple;
	bh=ziZWXByoKo6Yd2NaHlNfkieurX6IAiPjEf5cz29nXw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Oa715wmOL/gGcfbPHhJzmkcJKqtyci/nFoMfE9ZZns3fQa+0LpIA2HJtw37osHXYvmuheZHJtDYBYneX5+htyav/ik0OtAJUC5kXeMCSsGz4LgETEsJ7ksm6CH1OWtjBxQuv8sj/OJMxGG56MSIPOWyc1LEyTmVAt6i4QSOhrAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QgNqWUWZ; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-67bb17938d5so3707027eaf.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 18:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773710048; x=1774314848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ApY+DcR4ueL6DtN7vfUN/Fus1VcXxr3PHj2DS6SH14=;
        b=QgNqWUWZD4sCKa6AB/b+NEQE8O53DyQrLwzIktwvSZwIk1iy+ShJFT+rVAOx9TBt4F
         eMGl69T/Lz+g02XrutKS73r4j5cKbNekRsANzzwT8J2AKIXV1gvZur75vEZ5tyhih0+n
         M/43Y9gdAekRDd+ZRlJdeGO2Rl23K11Opg6RIewJ/GKV7oqMrgonhtVNp/J6gI5EEPst
         xG0nNMa1V2GX63G6sumTP6lSSJzZ1X3xc1WL4UB6oKVj7IU+3V6cCWpMD5c6To55n+Vr
         XrbD5mAH1v+QLKSvLyIzVnHe4iS/ZjvL9Z6I1hpdyfLgDlBZjppxPHG0KDBXD+OFZHjE
         uaag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773710048; x=1774314848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ApY+DcR4ueL6DtN7vfUN/Fus1VcXxr3PHj2DS6SH14=;
        b=X7UT/UQxwjK8H3Iy5xF04HKWTdF8UhzP+jVYDFIXduGRORZnrMjcHtqafm3kOrDKka
         IWfKt/7WFMnC5go8UhdNwg9z9JNaXEVVilts8154KygqWiaBV/u9+YjSkkpD1atCr/my
         T0LlYN97RSO64OxzBjLg21UvustWXHJ5k5+zBwBAohXYAGv7l5TeXo3KajOat+AlpVk4
         dh8NX4Ysd4HPqtcDM1uTQ6WP8nrw0B8Q0sNAZgl6IWSjBEogBIx7CoXvH3qFvfwPaG3p
         6JzKXEBoTcOGMqGKhaOoDkCzKNM7z54lT0lwSB1to2k0omV89h+2Kq1HV9CARLrM0iTs
         mP9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlbxonuf2itNuNm/1ZBU3kbjb392a4C3zKonadTnG9GDjZoTFADgoGjgPbc5VT3HsT2209Umt+/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWzqejN8KmKk5jSjOFALj10DxwP4qnBGj3R63Mg7vSivwucMIv
	XDAFtLH/pQzqXwHA9xqE8VsmHAbY7j95o4HmiYBz33eIQmKjTZtkuzfJnmZOEAJCaOs=
X-Gm-Gg: ATEYQzwsbpR9TR8y3QCDdhSJ2K7z7Kgev7hf7QRSbY6jfe8uOZjRHMZm1GTWUOYrDZQ
	iplTSgJ231vHm8mOiiGNlsvjE9kGNCqlxH90NhXw3YsNyMJywkeNFG+D3aqB0RIqcXV5uybsFQE
	ZpGkUKDX7ItjX9iJTyCP0NqlUVq3Q11wmrjnUuyJ9lMLhGfRnXNWhmlq4Khbe4YD3K1DtImyRKd
	ldaEqdxYuCzqPJFFQxkH41NIMh1yqS3LUXjmDYON/SLvsbOvbUjYWrl/MBCTbpXYjLtfid2NSZh
	LGCZhnJYDQh6VXT9Yrg7n+qs8+Fp29my5m3JPugRkopS9eQAtbPtn+3wSLQYznLhMYRNy+9Sr5u
	xcqi4Kd+o24wZPiKg0UKlHKNwmNT6/LMTGw0FBewOp4HKA9x0Srs/EkEqJF+2MLw50OVIDYBaI8
	6wNrS3qUd1+zEckJ+JcFBTvfjcv0OqWchgDvKmdCLsuv4inzWGPYss+ewVsSv8a9VmnUcU4kMsQ
	7IQSvwqRPdG6jWbpNZJ
X-Received: by 2002:a05:6820:1622:b0:67b:f611:605c with SMTP id 006d021491bc7-67bf6116680mr4916366eaf.9.1773710047812;
        Mon, 16 Mar 2026 18:14:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc93279c6sm9991696eaf.12.2026.03.16.18.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 18:14:07 -0700 (PDT)
Message-ID: <9844b90f-8c40-468d-875e-8a95197dde75@kernel.dk>
Date: Mon, 16 Mar 2026 19:14:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
 <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
 <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
 <6c0f631e-5015-4578-954a-07a1ca726b34@kernel.dk>
 <0fce925b-9148-4f83-92cb-19d164a7ea32@kernel.dk>
 <d8df1979-5534-4703-9e68-17b152d6595e@gmail.com>
 <be88cb1c-9e08-49dd-9671-1d3887918935@kernel.dk>
 <2cd52ebc-57d2-4407-a3d5-a46f57b90600@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2cd52ebc-57d2-4407-a3d5-a46f57b90600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12718-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5FAA22A27D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 5:08 PM, Pavel Begunkov wrote:
> On 3/16/26 22:31, Jens Axboe wrote:
>> On 3/16/26 4:24 PM, Pavel Begunkov wrote:
>>> On 3/16/26 18:40, Jens Axboe wrote:
>>>> On 3/16/26 9:16 AM, Jens Axboe wrote:
>>>>> On 3/16/26 8:44 AM, Pavel Begunkov wrote:
>>>>>> On 3/16/26 14:40, Pavel Begunkov wrote:
>>>>>>> On 3/16/26 14:28, Jens Axboe wrote:
>>>>>>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>>>>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>>>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>>>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>>>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>>>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>>>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>>>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>>>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>>>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>>>>>>> forever.
>>>>>>>>>>
>>>>>>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>>>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>>>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>>>>>>> discovers the remaining state.
>>>>>>>>>
>>>>>>>>> How often will iterate with no effect for normal execution (i.e.
>>>>>>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>>>>>>
>>>>>>>> That is my worry too. I spent a bit of time on it this morning to figure
>>>>>>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>>>>>>> commit in particular:
>>>>>>>>
>>>>>>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>>>>>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>>>>>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>>>>>>
>>>>>>>>        af_unix: Introduce SO_INQ.
>>>>>>>>
>>>>>>>> which is then not the first time I've had to fix fallout from that
>>>>>>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>>>>>>> missing events. Yes if both poll triggers are of the same type, eg
>>>>>>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>>>>>>> would anything else where you'd need separate handling for the trigger.
>>>>>>>
>>>>>>> Thinking more, I don't think the patch is correct either. Seems you
>>>>>>> expect the last recv to return 0, but let's say you have 2 refs and
>>>>>>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>>>>>>> fails. The 2nd recv call returns another 4K, and now you're in the
>>>>>>> same situation as before.
>>>>>>>
>>>>>>> You're trying to rely on a too specific behaviour. HUP handling should
>>>>>>> be better.
>>>>>>
>>>>>> Some variation on, if HUP'ed, it spins until the opcode give up.
>>>>>
>>>>> Took a quick look, and we don't even get a HUP, the hangup side
>>>>> ends up with a 0 mask. Which is less than useful... I'll keep
>>>>> digging.
>>>>
>>>> How about something like this? Will only retry if hup was seen, and
>>>> there are multiple refs. Avoids re-iterating for eg multiple POLLIN
>>>> wakes, which should be the common hot path if v & IO_POLL_REF_MASK != 1.
>>>> Keeps it local too.
>>>
>>> HUP handling is just a hack, it'd be best to avoid complicating
>>
>> It is, that's why I wasn't a huge fan of gating on that in the first
>> place!
>>
>>> the pool loop logic for that (and those continue do).
>>>
>>> io_poll_loop_retry() {
>>>      ...
>>>      atomic_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
>>> }
>>> if (req->cqe.res & (POLLHUP | POLLRDHUP))
>>>      io_poll_loop_retry();
>>>
>>>
>>> Can we isolate it like this? Nobody should care about extra
>>> atomics for this case.
>>
>> It's not the extra atomic, I agree it doesn't matter for this non-hot
>> case. It's more that setting the retry flag isn't enough, you need to
>> have it do another loop at that point. And if you just set that, then
>> it'll drop all refs and happily return and wait for the next poll
>> trigger that won't happen past HUP.
> 
> It was actually supposed to force it into another iteration, but
> I see what you're saying. I'll take a look at this part tomorrow

I mean, we can just reuse 'v' for this, and set IO_POLL_RETRY_FLAG.
There's no reason to set it in ->poll_refs as it's all local anyway.
Then that at least gets rid of the 'retry' variable.


diff --git a/io_uring/poll.c b/io_uring/poll.c
index aac4b3b881fb..f1a45e69b9af 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,18 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
 		__io_poll_execute(req, res);
 }
 
+static inline void io_poll_check_retry(struct io_kiocb *req, int *v)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return;
+	if (!(req->cqe.res & (POLLHUP | POLLRDHUP)))
+		return;
+	if (*v == 1)
+		return;
+	/* multiple refs and HUP, ensure we loop once more */
+	*v |= IO_POLL_RETRY_FLAG;
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -287,13 +299,15 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 			if (unlikely(!req->cqe.res)) {
 				/* Multishot armed need not reissue */
 				if (!(req->apoll_events & EPOLLONESHOT))
-					continue;
+					goto finish;
 				return IOU_POLL_REISSUE;
 			}
 		}
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
+		io_poll_check_retry(req, &v);
+
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 			__poll_t mask = mangle_poll(req->cqe.res &
@@ -317,12 +331,17 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		/* force the next iteration to vfs_poll() */
 		req->cqe.res = 0;
 
+		if (v & IO_POLL_RETRY_FLAG)
+			continue;
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
+finish:
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
+		if (!(atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK))
+			break;
+	} while (1);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;

-- 
Jens Axboe

