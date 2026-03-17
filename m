Return-Path: <io-uring+bounces-12720-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SBm5MCOwuGl5hwEAu9opvQ
	(envelope-from <io-uring+bounces-12720-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:36:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F25E52A2943
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 02:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9974A300CE71
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 01:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232FF22FE0E;
	Tue, 17 Mar 2026 01:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NCggiKxE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71AE33E348
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 01:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773711393; cv=none; b=Oj6Sk5zKkFWPWmpeGr8VE7awMqOA2CYo02HKlcRGqwPQ281C3bStEvikThWQVRw8rOGWXvoRsJsZnQF5mhHTAEHmsyjM+IQTorw5mXW/RQid5+9uqsbboLHSgTf1ivQfl2naVFOjg146dSDFzG8OMYJeTcfOeFJlZAbCUTPjm00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773711393; c=relaxed/simple;
	bh=vA+SyqVpqCa4jq+X9hi/c3NfjER2CDU/0QfzrE8Z+7k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=V4cfug9pYx+Ko8w8+Zy61xVlXGuMOC0LrHClNK2tXuUi8Y8Dq5jJnc1Jln9PE+mTWXpjqrrrVddR6AJjnUSpmN3yL2MGmtZbd/JlF6D7gI+V+hBrbrcgOhH9dnD8AwvvD/lUCHe1FG/3Tzyu3c7C7XW6b2Y8tipBIbP7ixqMMRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NCggiKxE; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4be94eeacso5938525a34.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 18:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773711390; x=1774316190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbFSv5rkfMyUHfhhp1rn9q9kGdtAdyFlPKL1Kbjogd0=;
        b=NCggiKxEwgNGAyqr2ELfFcQEBhdZDmkQohsCkN4IskC/8uJOsLpeSIGjmfOO3dH/bN
         XkI0J9KMGjaaGhG+WW2KCVgIiCUrgk9gk/Sraps/u55MVOgZskV76RnwMe8vXY/EI92w
         bXoZItdR7vAXpLwqBB03SI6cDLfNdshpGbQtVDg1DFqR5IG5oudHDhJNJGaxkpx+EYQq
         qqQ97N6X6a5Xeh/839Zd+pTePMxC/vvbOsYvW9RVWXBHfwatRCCimtTsUCca7IhqBti3
         +NA38AKULsBbOU7rXXzXMdAwD2du9YoT6IulQHvzJb93WJPAgjlW2jZaAi9DZZth6lgd
         wwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773711390; x=1774316190;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbFSv5rkfMyUHfhhp1rn9q9kGdtAdyFlPKL1Kbjogd0=;
        b=VwNEJXdX3f8Ihgn5mW3FoDTYfnDKsaU3PPaup9XACVap5XfpEaTTPqgZe+Mh6EVBS8
         shSjfjMe4+6seeuB/5GfH2yx33uPc/bOuxEpbxTilJbdq7N0teKFcrPjP7c9lXBfq5cR
         CgCmuwLmWoFV/GVw3lHeDvRNYSl/ekIlk5CQ/K5mXCTh0RDNSY0bT6OzBXEQkCrjzxBS
         /N4jrRCnGx29AqK4nEpmxrD00UeyYStxjxNlI+CjUVpj5U3e+le/y4SlqMCMTuhKdClv
         6rdC8k98WcdPTFowOKmg8VnyPcKGxrJ+YD5qbFMMN6XQEDhPq7FfhVFfHQJqOYPp+zIi
         x0Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUCRZdzj5J+PC5Wy0zKKkMEzm0gyrKeYlcyUE3M0pOAF6KnbRwKdNYZHbXfnRsK/3aBzPVO5ooTmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyYiO6OnHT6SXK7kj+7FzdRL5y/Wkmm1bNgS7Sy89F6ZpeW5Fi
	6tZ8C4rQsMCuru6L9j02uygRxPfHH0NqLKnd+S9s17JYSFZnpkN41kp7cwF5TmDGEWsNY2i52bq
	S/lal1AE=
X-Gm-Gg: ATEYQzwGD+rNvRULdGdQ2N8+O+iWIx62rrOHIoGwuo1DhDpo3Mq0NvE0OFjVWNCdjCB
	AfehtaOuYLFlOwtTxNdUmtHvzphn8dW3NS9Axv/0W5OtC6n7Gj8JKKdEsGsVcUmsq33VkE7n7o0
	jgQ9sv/43u44WECpcb16CZldDMZfNf5CnA7BcBQLJEW37N+MIyMJoDgO+JiWAA3vQf3khi56chO
	yOcgZzRj4Vpx8azexMZ6U1e/sxq438z61E+wsOaNVXMUOPbjIFhIdNpzGrTYmVkojUMdP4LBU99
	LOo8OSf0LywW35p0mf/vvcvOMPhkOLksadE5lF/cv8MNtxfAqdyllmstjrS9ZdekfT+BDqZIvul
	j73rj64usrIoTGc8hHuoBk76zYX+Z5F63jpR8Ap/MUp8Vmz1lNaJu7s0zAH/UgIcnCVq0jqT2fq
	fBRvG4qRi33I8tbZHoGzaD1/vufpztpHavEIJhWp4tuaMv3tdJGf6NGVMcaXaoRUZujsW0OrOV7
	dA346ibUA==
X-Received: by 2002:a05:6830:81d2:b0:7d7:433e:49dc with SMTP id 46e09a7af769-7d7825f37d0mr9505926a34.31.1773711389715;
        Mon, 16 Mar 2026 18:36:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ac8ce73sm14704979a34.11.2026.03.16.18.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 18:36:28 -0700 (PDT)
Message-ID: <b44be21f-54d2-4bd4-856e-1a0f470e99c0@kernel.dk>
Date: Mon, 16 Mar 2026 19:36:28 -0600
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
 <9844b90f-8c40-468d-875e-8a95197dde75@kernel.dk>
Content-Language: en-US
In-Reply-To: <9844b90f-8c40-468d-875e-8a95197dde75@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12720-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F25E52A2943
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 7:14 PM, Jens Axboe wrote:
> On 3/16/26 5:08 PM, Pavel Begunkov wrote:
>> On 3/16/26 22:31, Jens Axboe wrote:
>>> On 3/16/26 4:24 PM, Pavel Begunkov wrote:
>>>> On 3/16/26 18:40, Jens Axboe wrote:
>>>>> On 3/16/26 9:16 AM, Jens Axboe wrote:
>>>>>> On 3/16/26 8:44 AM, Pavel Begunkov wrote:
>>>>>>> On 3/16/26 14:40, Pavel Begunkov wrote:
>>>>>>>> On 3/16/26 14:28, Jens Axboe wrote:
>>>>>>>>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>>>>>>>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>>>>>>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>>>>>>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>>>>>>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>>>>>>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>>>>>>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>>>>>>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>>>>>>>>> the first event was consumed. Since the shutdown is a persistent state
>>>>>>>>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>>>>>>>>> forever.
>>>>>>>>>>>
>>>>>>>>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>>>>>>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>>>>>>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>>>>>>>>> discovers the remaining state.
>>>>>>>>>>
>>>>>>>>>> How often will iterate with no effect for normal execution (i.e.
>>>>>>>>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>>>>>>>>
>>>>>>>>> That is my worry too. I spent a bit of time on it this morning to figure
>>>>>>>>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>>>>>>>>> commit in particular:
>>>>>>>>>
>>>>>>>>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>>>>>>>>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>>>>>>>>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>>>>>>>>
>>>>>>>>>        af_unix: Introduce SO_INQ.
>>>>>>>>>
>>>>>>>>> which is then not the first time I've had to fix fallout from that
>>>>>>>>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>>>>>>>>> missing events. Yes if both poll triggers are of the same type, eg
>>>>>>>>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>>>>>>>>> would anything else where you'd need separate handling for the trigger.
>>>>>>>>
>>>>>>>> Thinking more, I don't think the patch is correct either. Seems you
>>>>>>>> expect the last recv to return 0, but let's say you have 2 refs and
>>>>>>>> 8K in the rx queue. The first recv call gets 4K b/c some allocation
>>>>>>>> fails. The 2nd recv call returns another 4K, and now you're in the
>>>>>>>> same situation as before.
>>>>>>>>
>>>>>>>> You're trying to rely on a too specific behaviour. HUP handling should
>>>>>>>> be better.
>>>>>>>
>>>>>>> Some variation on, if HUP'ed, it spins until the opcode give up.
>>>>>>
>>>>>> Took a quick look, and we don't even get a HUP, the hangup side
>>>>>> ends up with a 0 mask. Which is less than useful... I'll keep
>>>>>> digging.
>>>>>
>>>>> How about something like this? Will only retry if hup was seen, and
>>>>> there are multiple refs. Avoids re-iterating for eg multiple POLLIN
>>>>> wakes, which should be the common hot path if v & IO_POLL_REF_MASK != 1.
>>>>> Keeps it local too.
>>>>
>>>> HUP handling is just a hack, it'd be best to avoid complicating
>>>
>>> It is, that's why I wasn't a huge fan of gating on that in the first
>>> place!
>>>
>>>> the pool loop logic for that (and those continue do).
>>>>
>>>> io_poll_loop_retry() {
>>>>      ...
>>>>      atomic_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
>>>> }
>>>> if (req->cqe.res & (POLLHUP | POLLRDHUP))
>>>>      io_poll_loop_retry();
>>>>
>>>>
>>>> Can we isolate it like this? Nobody should care about extra
>>>> atomics for this case.
>>>
>>> It's not the extra atomic, I agree it doesn't matter for this non-hot
>>> case. It's more that setting the retry flag isn't enough, you need to
>>> have it do another loop at that point. And if you just set that, then
>>> it'll drop all refs and happily return and wait for the next poll
>>> trigger that won't happen past HUP.
>>
>> It was actually supposed to force it into another iteration, but
>> I see what you're saying. I'll take a look at this part tomorrow
> 
> I mean, we can just reuse 'v' for this, and set IO_POLL_RETRY_FLAG.
> There's no reason to set it in ->poll_refs as it's all local anyway.
> Then that at least gets rid of the 'retry' variable.

This is as clean/simple as I can get it, less text too for this one.

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aac4b3b881fb..06183cf60201 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,22 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
 		__io_poll_execute(req, res);
 }
 
+static inline void io_poll_check_retry(struct io_kiocb *req, int *v)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return;
+	if (!(req->cqe.res & (POLLHUP | POLLRDHUP)))
+		return;
+	/*
+	 * Release all references, retry if someone tried to restart
+	 * task_work while we were executing it.
+	 */
+	*v &= IO_POLL_REF_MASK;
+
+	/* multiple refs and HUP, ensure we loop once more */
+	(*v)--;
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -294,6 +310,8 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
+		io_poll_check_retry(req, &v);
+
 		/* multishot, just fill a CQE and proceed */
 		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 			__poll_t mask = mangle_poll(req->cqe.res &
@@ -316,12 +334,6 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 
 		/* force the next iteration to vfs_poll() */
 		req->cqe.res = 0;
-
-		/*
-		 * Release all references, retry if someone tried to restart
-		 * task_work while we were executing it.
-		 */
-		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
 	io_napi_add(req);

-- 
Jens Axboe

