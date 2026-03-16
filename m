Return-Path: <io-uring+bounces-12699-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGKxKb9OuGlHbwEAu9opvQ
	(envelope-from <io-uring+bounces-12699-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 19:41:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 096EF29F255
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 19:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C227C3025A48
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 18:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F389B3E0231;
	Mon, 16 Mar 2026 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PHPjCXTG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1409A3DFC7A
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773686447; cv=none; b=l1xnudPUBAE0WOjmSRil+hgJOYTnzTuhcZWW3vBH7QE0gL0hdzSppI0V3ZmWKcj1zAOKs5smrvKzWoyPg9ifPLPt3bomHeWY2EcAWch+64dejtkU/wbKgdNZjyLuKFi3xkSfWDBzlqLS7QvolhYh4UkoWdwczgmCLm0G4dEWtrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773686447; c=relaxed/simple;
	bh=KjcLFVHtSt6G0DLVXbwWJgFK/HJvabRpb+1HkhP0nlA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GtAPo1kK+2PSxLIMAX7vKdyl7hgnh97yM0/0lR16MGtQipKypwtX26GpWnKMp8uN0Hlh++lQ93sU9K3bNsWHc1yr4wuSQyiXz+WukcyfxO7yEDd/OLXEIXs7xm93/etWISv5zwXjZhlG/7ZwLIqUrlJkd6w2JUrBsAi0/8famXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PHPjCXTG; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-41576c5c01cso3051551fac.3
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 11:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773686442; x=1774291242; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sQNPklb+pjPxNR3JRE18HCGZzSZKnk3uiQQhKadqP3E=;
        b=PHPjCXTGt+RqlmNzHzDC3jRgX/U5YsLK+zN0CopXlhN7ED/r1FfetcK+SL6lYAIoif
         lM+RYB55DYspeFM3KIU+ayhN6KLUoB41fJghMA6Wmv9DaBEZbQTI1LulR63xEWQimMsx
         lur4xZjZQaOhot9HT8rz7KoHodNRjv/Rr+2AYcM3b1SqipBVMtKYZq/7gbnTMiqAun5p
         MmODWzcaQwE4/5VoucUEumbRC7OSahYfPIwFWm/fBkgUDLBf3qbGTVHsV6KNmW/WllcH
         mOMo9j7lhYSJ2x/sNtoaqGuh9qa95eekYSS/djPulVUjJJ7c4eZ3iIP6pYF5FMk/43w4
         OaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773686442; x=1774291242;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQNPklb+pjPxNR3JRE18HCGZzSZKnk3uiQQhKadqP3E=;
        b=pJqAGXNxj8SRIRUM/H38bwR/WLM430eD3/qtGGfmzZ4tZNmqjXFBhbwWnohX32tRy9
         2HngBY2hMtrEyLW3NcYat24K/hsfXiMP5eo+VHqGlNxvaNbwE6YuYm1Fmr/hAj0+4Sth
         DrE1/rlyIqK95rEnU+F5l/f5hoo/h1v9TsbqSr6g3rq91eqBlKqOtPGoy/oB2OCQ/7cD
         QAkz/LLTPHYnC3YHekKVDVzRzX4BQsgc1DlyFirzIp0IPPJLVg0yu34PLdTyYgtf33yC
         1cOid5VhMDUjhIRTx7GJnN9usgx68tTUPBcZqBx2i/nt+/NCQMH3RaSVKlIep8J0jnV/
         HuuA==
X-Forwarded-Encrypted: i=1; AJvYcCUV1pUVr2hanYNmv070zVWe1vpJJpvMafT6yKEzZV/oXuhiJFwPIrxAwyHezT5JEpkMV6Fliscjuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwNcWKYQEYWnaXueI6pwTmJswxhdB/Zw/p/5R3A5UBH15OSQA+
	wXbyDTxg3+PGxUpexvPacP+VAaEiows75ji8TdGOPRmWlyqsNvB5olmrMmxWFjnqmY7IRMCw4lA
	0zf0IPTQ=
X-Gm-Gg: ATEYQzzKbzZ7+l8y8NfddjM7J5Wxlmz33btlYRF972Fpyr30kNXRY1OxS0oEK6+mhXd
	Ic6z+W1FveyiXDEMjDxv5eWRJtLa1mvAFfarEzfHeHeMrbpg7S7gjA+Bos6gffSW6n8ZqMSNZFF
	XyWFoF2xzOV/CnkUF5VMlWfSQ+rebH4HCkU7o2USQi2NnlFUvo9o7A0LQZa+elI8TYH9QTaSEha
	mk4oQ7EBWKjlRiwcEJP9TWItJcxPbZLME1q80IWMzo4XS41JmRCkSmhrK5J+BZYvrNP/DbnlX9S
	Z6E1icwe99dkHvKVqzRqs67gkrRUq3FTQkWHbKedVw3nkoqr5jpAK5/fpDrwq/l+SgsFSVov26g
	K1xRL8zIrBGFqweXuKapUAOibI/TjyV46Yg8NbEopKfq/75MRpvhGVhnh31+uTcKQl6I7EMN3ov
	T3+4lQ/TG23rKYmyDUKbVmbrn4yBmqtUZIT35Kxy9Ik8f9En1rhgQ1boihuD8Tht9eVziaBe6LB
	aFvgYn3NQ==
X-Received: by 2002:a05:6870:826a:b0:409:68f6:569b with SMTP id 586e51a60fabf-417b91c5d44mr9004790fac.12.1773686441741;
        Mon, 16 Mar 2026 11:40:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6c7885sm16094525fac.17.2026.03.16.11.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 11:40:41 -0700 (PDT)
Message-ID: <0fce925b-9148-4f83-92cb-19d164a7ea32@kernel.dk>
Date: Mon, 16 Mar 2026 12:40:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: francis <francis@brosseau.dev>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
 <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
 <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
 <6c0f631e-5015-4578-954a-07a1ca726b34@kernel.dk>
Content-Language: en-US
In-Reply-To: <6c0f631e-5015-4578-954a-07a1ca726b34@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12699-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 096EF29F255
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 9:16 AM, Jens Axboe wrote:
> On 3/16/26 8:44 AM, Pavel Begunkov wrote:
>> On 3/16/26 14:40, Pavel Begunkov wrote:
>>> On 3/16/26 14:28, Jens Axboe wrote:
>>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>>> forever.
>>>>>>
>>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>>> discovers the remaining state.
>>>>>
>>>>> How often will iterate with no effect for normal execution (i.e.
>>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>>
>>>> That is my worry too. I spent a bit of time on it this morning to figure
>>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>>> commit in particular:
>>>>
>>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>>
>>>>      af_unix: Introduce SO_INQ.
>>>>
>>>> which is then not the first time I've had to fix fallout from that
>>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>>> missing events. Yes if both poll triggers are of the same type, eg
>>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>>> would anything else where you'd need separate handling for the trigger.
>>>
>>> Thinking more, I don't think the patch is correct either. Seems you
>>> expect the last recv to return 0, but let's say you have 2 refs and
>>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>>> fails. The 2nd recv call returns another 4K, and now you're in the
>>> same situation as before.
>>>
>>> You're trying to rely on a too specific behaviour. HUP handling should
>>> be better.
>>
>> Some variation on, if HUP'ed, it spins until the opcode give up.
> 
> Took a quick look, and we don't even get a HUP, the hangup side
> ends up with a 0 mask. Which is less than useful... I'll keep
> digging.

How about something like this? Will only retry if hup was seen, and
there are multiple refs. Avoids re-iterating for eg multiple POLLIN
wakes, which should be the common hot path if v & IO_POLL_REF_MASK != 1.
Keeps it local too.

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b671b84657d9..bd79a04a2c59 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,16 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
 		__io_poll_execute(req, res);
 }
 
+static inline bool io_poll_loop_retry(struct io_kiocb *req, int v)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return false;
+	/* multiple refs and HUP, ensure we loop once more */
+	if (v != 1 && req->cqe.res & (POLLHUP | POLLRDHUP))
+		return true;
+	return false;
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -246,8 +256,9 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		return -ECANCELED;
 
 	do {
-		v = atomic_read(&req->poll_refs);
+		bool retry = false;
 
+		v = atomic_read(&req->poll_refs);
 		if (unlikely(v != 1)) {
 			/* tw should be the owner and so have some refs */
 			if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
@@ -287,13 +298,15 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
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
 
+		retry = io_poll_loop_retry(req, v);
+
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 			__poll_t mask = mangle_poll(req->cqe.res &
@@ -317,12 +330,17 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		/* force the next iteration to vfs_poll() */
 		req->cqe.res = 0;
 
+		if (retry)
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

