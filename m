Return-Path: <io-uring+bounces-12696-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qD8WIKAYuGn/YwEAu9opvQ
	(envelope-from <io-uring+bounces-12696-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:50:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CE429BB05
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA3A5301F48B
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACCD1EA84;
	Mon, 16 Mar 2026 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SVi3G6dV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FB12D8399
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773672295; cv=none; b=jWYfUo368niXv5jcHym3xKl1xS0Jk5JmoxQ5ivOY24Vvw/A7sc/Lgc+XTZQZQbleo2nEk9kEXpnxMQY4EhOyByDEd38fEZhCFcT2qXoaoEFsIEs1qELKzn0Ko4Yr4fszRQHA4a438Ba1YGczXkb8oZThAT4SHrIH7gOKZvVOqTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773672295; c=relaxed/simple;
	bh=4P4vfYrbjl5IQ0K1dMEPQzschL7CEQ2GG/wHAsAPmKk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZxRAn3pVSFUEkjBOyVavSUcYcVALAFRZ5IJvwSaNPJeES9o4l65Suur19R34tAiclvt7aHY8qv1FP3nKVELc1hQW9BhjlD7Iaf6a6qA2cXGbogn975KerBC7xsD3t8C7KjPnjLkrjQZrR6hhmxyTjfRDaLkWvROPutdp2LCJkGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SVi3G6dV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso41085665e9.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 07:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773672292; x=1774277092; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bzWMNYjQSCDAliEFKvt/BneznTJd0exghzeU+wY4ZNI=;
        b=SVi3G6dVdmstJ7VkieRrWA/LTX4zCwZlXOm1eqURG0ARujUX7WJYNnE087DHH9oPcd
         HzNPc3AnghMh/U71xsf3Wh9mBHQXwbfNf2Ow4Yx+PxEDBjf8HnaFEikAKJpBKOocS5mX
         8W0O4t+V9GmCnFaCl08GcPGJH0XY+nKqjMlimuVvcgegd3ibYd1uCLIxObdWetkGfhvK
         JoPgas0OIg4JzARmr54rz1vkKWZQ7SslUDivRZ64a1sxpqgwoLwJI5IDpRw9MwoP8+jw
         zBFdy/qBSl05eN1ivNT1YIs91nc1dh/KKKSMcq/AjwwhDGwX7xJImGq63SkYPr24eNx4
         OPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773672292; x=1774277092;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzWMNYjQSCDAliEFKvt/BneznTJd0exghzeU+wY4ZNI=;
        b=R3nOGVJztKZ1BaMy0GVLc5A7BUIpAaD7Wu9HViLfjQYaOrOh5JkY/WjI+yyu2o0kBy
         ZaXmeHvwe1LvYFb8wqNLvAjxcEVwYIQqbHML9lxeMulZtf0/Qj1JWecLANIdravrMkJg
         dg+Ln5kuK8KCc23mIHMhY6frEkcyjIoJqImEhXoFvu+DV2k2JlPkUOj+BADDVMqCwDUZ
         PqBZwhGR+zc3GIQWGseHDDNDAqp2SNCI5T7nfDIae1kzbjG+3l/Kza9DX1t5MYWPr8E6
         UYSp2VUulplS/XVB6SwZU/AUFnI6/gItjLyIfRVmiA1n9m1vc+pAEwPT8J2BeY5ZqfKA
         QoGA==
X-Forwarded-Encrypted: i=1; AJvYcCWXjveimlZc9xtDMEh3f0ghQWzOYLXm1hfx/ILmXnwtfsopIOgsvqB0G4h/48t2RZ90b69axbbLxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmwuC45Km90bBA7XuLQiEOQyzLlOJHiFDIoWxipbBIIgujD7Za
	D5AFH/raFw25wbjtiDsTmnuCkGzWY8CR5xxmtg3O2OCIEDTFsee3Q6mg
X-Gm-Gg: ATEYQzwTh0FefnwkKRPXHgSrlAnQgL58kntJFtMz2Chbv88mtEcSwRT05DDKb+Cjy/w
	ZQ1nCA+DurJzxfd8vlI77gnp1Rx0snPzF1B8Qv6fQe/TdZOGkhI+FgE+5wpdFyXOa2sJ1t83tCb
	BoBA+JvyidXIzskB1Y2OVDGYAOqO5ZJ6OGUcqpfsk9iHOgGitTyFv3wLOEu1cFFfN/jFrVfbH51
	a1l64GKzLg2f/GGcV6s2VoPtbymx0roriJ5xerJUdoMJGXnn8rqW8bhF/XVFOgjqgANmYTAL6Hn
	un53otV2W03ec3jzlI92sOQUiRmyk/UXQ/Q1HJ55OoQVRGF7eqQuyVmyTI6gbMES89y1Wly5ccJ
	Yr1NicXfYZvOLx4RwL7H1oRHc9pZCmSgf0lrBiTtCU/X6+EfVPsStpHH0oLWYD2Jiag+aAD9J2+
	owgXja6HPQoN8RcxFbh2R8RZ5Q3DMBNfperBoh3hS8XwC3/HPiLQiMy9CI/eepncdRJEFKY0KRi
	7x8dfiFipHBRnseLVwpuohjAYeqy+Vy6eMPB2U6DwveDYpDsQYs1ubuLQ==
X-Received: by 2002:a05:600c:4f54:b0:480:690e:f14a with SMTP id 5b1f17b1804b1-485566f9258mr226826015e9.14.1773672291431;
        Mon, 16 Mar 2026 07:44:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a0ed])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe20c473sm45497175f8f.24.2026.03.16.07.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 07:44:50 -0700 (PDT)
Message-ID: <c1499122-9444-4ef9-908a-84e290d450d2@gmail.com>
Date: Mon, 16 Mar 2026 14:44:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: fix multishot recv missing EOF on wakeup
 race
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: francis <francis@brosseau.dev>
References: <8688cc4e-8619-4392-8d5c-93c554d70c34@kernel.dk>
 <2e2d6e81-bf95-47bf-9c70-1b2f8b63cfbc@gmail.com>
 <876c9e94-0782-4561-8ae3-0cfed18ee375@kernel.dk>
 <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
Content-Language: en-US
In-Reply-To: <3b6769f8-4b44-47ee-a308-6f7e23304c8a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12696-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D7CE429BB05
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 14:40, Pavel Begunkov wrote:
> On 3/16/26 14:28, Jens Axboe wrote:
>> On 3/16/26 8:17 AM, Pavel Begunkov wrote:
>>> On 3/15/26 16:19, Jens Axboe wrote:
>>>> When a socket send and shutdown() happen back-to-back, both fire
>>>> wake-ups before the receiver's task_work has a chance to run. The first
>>>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>>>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>>>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>>>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>>>> the first event was consumed. Since the shutdown is a persistent state
>>>> change, no further wakeups will happen, and the multishot recv can hang
>>>> forever.
>>>>
>>>> Fix this by only draining a single poll ref after io_poll_issue()
>>>> returns IOU_RETRY for the APOLL_MULTISHOT path. If additional wakes
>>>> raced in (poll_refs was > 1), the loop iterates again, vfs_poll()
>>>> discovers the remaining state.
>>>
>>> How often will iterate with no effect for normal execution (i.e.
>>> no shutdown)? And how costly it'll be? Why not handle HUP instead?
>>
>> That is my worry too. I spent a bit of time on it this morning to figure
>> out why this is a new issue, and traced it down to 6.16..6.17, and this
>> commit in particular:
>>
>> commit df30285b3670bf52e1e5512e4d4482bec5e93c16
>> Author: Kuniyuki Iwashima <kuniyu@google.com>
>> Date:   Wed Jul 2 22:35:18 2025 +0000
>>
>>      af_unix: Introduce SO_INQ.
>>
>> which is then not the first time I've had to fix fallout from that
>> commit. Need to dig a bit deeper. That said, I do also worry a bit about
>> missing events. Yes if both poll triggers are of the same type, eg
>> POLLIN, then we don't need to iterate again. IN + HUP is problematic, as
>> would anything else where you'd need separate handling for the trigger.
> 
> Thinking more, I don't think the patch is correct either. Seems you
> expect the last recv to return 0, but let's say you have 2 refs and
> 8K in the rx queue. The first recv call gets 4K b/c some allocation
> fails. The 2nd recv call returns another 4K, and now you're in the
> same situation as before.
> 
> You're trying to rely on a too specific behaviour. HUP handling should
> be better.

Some variation on, if HUP'ed, it spins until the opcode give up.

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b671b84657d9..3944deb55234 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -43,7 +43,8 @@ struct io_poll_table {
  
  #define IO_POLL_CANCEL_FLAG	BIT(31)
  #define IO_POLL_RETRY_FLAG	BIT(30)
-#define IO_POLL_REF_MASK	GENMASK(29, 0)
+#define IO_POLL_HUP_FLAG	BIT(29)
+#define IO_POLL_REF_MASK	GENMASK(28, 0)
  
  /*
   * We usually have 1-2 refs taken, 128 is more than enough and we want to
@@ -272,6 +273,8 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
  				atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
  				v &= ~IO_POLL_RETRY_FLAG;
  			}
+			if (v & IO_POLL_HUP_FLAG)
+				atomic_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
  		}
  
  		/* the mask was stashed in __io_poll_execute */
@@ -390,6 +393,14 @@ static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
  	return 1;
  }
  
+static void io_handle_hup(struct io_kiocb *req, struct io_poll *poll)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return;
+	if (poll->events & (POLLIN|EPOLLRDNORM))
+		atomic_or(IO_POLL_HUP_FLAG, &req->poll_refs);
+}
+
  static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
  			void *key)
  {
@@ -397,8 +408,12 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
  	struct io_poll *poll = container_of(wait, struct io_poll, wait);
  	__poll_t mask = key_to_poll(key);
  
-	if (unlikely(mask & POLLFREE))
-		return io_pollfree_wake(req, poll);
+	if (unlikely(mask & (POLLFREE|POLLHUP))) {
+		if (mask & POLLFREE)
+			return io_pollfree_wake(req, poll);
+		if (mask & POLLHUP)
+			io_handle_hup(req, poll);
+	}
  
  	/* for instances that support it check for an event match first */
  	if (mask && !(mask & (poll->events & ~IO_ASYNC_POLL_COMMON)))

-- 
Pavel Begunkov


