Return-Path: <io-uring+bounces-13738-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 2yxOADZbMGo8SAUAu9opvQ
	(envelope-from <io-uring+bounces-13738-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:06:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC61689AB0
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:06:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=mo3vglpu;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13738-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13738-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F3A630DA5F5
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 065D03AA4E1;
	Mon, 15 Jun 2026 20:04:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472838B12E
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 20:04:44 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553886; cv=none; b=dd3BUyyytIUT8njWknmBVD/OGEga08bY+gPiNZrJwPsNpYs6QagJwlr76MSL7KjSJ5an0K/U4zIKhYrA0zui5xc4qacoLEXw3+lS7/1AVpVBe8K4z2DRp6IdwupydOFYrYGcHAi6uM33PYWjS8VBpOudMOT14dNx8P6AuC94Ghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553886; c=relaxed/simple;
	bh=Xzk+iwepG2Nrs6WpcyxKLI3urmnKfzTm3YG8DDqpits=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=O9UMrwvbYIu2fzbFG58ddgV05goVewd+0pmRI3A2XJs0LB8AkusdpwMUy8dRzzuEomu0rCm2sPU+/hR9Jbhh4YMZ8u3bq6VV1jPqZ1C/yC3zlFVqZfs7VIDlcvtR42y5B5MVmyUhJ2Qcg50sC0GOVZD5TgvDHcjLc4zXnRRoBuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mo3vglpu; arc=none smtp.client-ip=209.85.161.48
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69e402b625fso2705325eaf.1
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781553884; x=1782158684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F5C65KhrCAIae9A6TxgPbXa+O4+KAIwu6YF6jVNuJDY=;
        b=mo3vglpurwtEyMe9Nkde7NvQY87T2/w87wT6YM5RtXxvUi8sJG3xFLfUvhE3Nvurnv
         NA+lyzkKfpIEq5HczV9CRt0Mgff6HDhNZ8rUuxbsZlGq7dlZ+3/PN7rbLwmcDjTwtum8
         FB3bUWGmv0p2ZQzijGAYLp6nNR8Ih8+3qah1fIFL33HLgpUar/yzdR144DQG1nwIpm4i
         7AK4HnuHm2TClb1zMrpqlLd+b4qmno3ENTQIPQ5Gn4CU3HMCqyV9jQyotyPBuegbfGoZ
         a+Ik97qPHUHu5FdiMXEfPiKGcxfxemJ/YTKKluTNFtdy6xRjhCYvpAHwn98JvAXEwN8t
         KCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781553884; x=1782158684;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F5C65KhrCAIae9A6TxgPbXa+O4+KAIwu6YF6jVNuJDY=;
        b=nWYz6iU5tFBfHOh/LHwetNlPn9uaPa2NPGkkg5YzIefcDTuEApOLNP5xHI+dTQYdTn
         cDGv3NbCXp/OGI6EBmvNKgT+hmwWMBUd8+LTe1JsXJ9pJRErxx7IVK/adyWnDOsjiKGq
         GgdsimIsmjKHSSwghzWJJ/hCqVNUkuIO1VjCxPWoIKj2MtVrpDtzfeq78NCHL4UM/tUW
         Bn5LvXmBnmClaE7pEi6/p0o3tJxAH5ibxGeHGOdIl9n2/luBxEPvy0SRI3MQLVp2tSFt
         AHw0iApIiJEe+Cnu7LKv8hhCQFh/A3OdloZ03FyoQC181/aMmBxX1et8PGqqNrLwJ6qG
         +xTA==
X-Gm-Message-State: AOJu0YyEh0GmMJngfGO0+QxYV3z9ZX3NOLoQ6EIo1xBfc9tZgEWUBtYt
	JIH8ziPAAuaStsa6rLIIPT9JAru0+A/IC2E+amUumhx3mrOSarjdzk7gIy50biGkBEU=
X-Gm-Gg: Acq92OFmJjCg+WFxoKRXrzzrSDB4NX2BkiHTOk1j5AO6psFwkFdExKhCGJ6mE7ZYxFE
	lnMVD9MXxLjgSkgIerKCnadrtX+NJfFSHqo4Pg2K2+hkYauYG/tLFRj098u0vefPq1GAO/c8xVD
	jIcYZbCYcxBaYSmq6zXKykz3TyFDWojMjI5UL68Wm3kcRpCtIrcxDU7eHC4ak9oR6RkfdoOlfJa
	tbFh1GtlAmn0O7oVv28aUseU8yHt4PxpcpYGXVxzVJvpaTq+Ujt8REfAcG+E9HHKr6DqOrASlVA
	Oyx2nlZzOL4Lj472U8QboqSOBTuhBVEBhUY3GbuYPa0RACaN8ySoP5WEUxrvPvMHzob62e4gGl0
	1NKzPS9NTtSJK6TAFlNViRqEbPQqF3WnH5NNuyLcn2+LJ9G+vNxj7ozXbDv4oTFN0hDDMJJl1nm
	y0QSmvYD5qENLyvt5MtnSUJvDZJrOSj3sWcWXk0olRi0O/YDTKNxL9G4rImGWPS+UgWqN/p4QmP
	H1cR3T1zN+4v5KCqeQ=
X-Received: by 2002:a05:6820:8187:b0:69d:ef3c:7e34 with SMTP id 006d021491bc7-6a0a40e2293mr561226eaf.0.1781553883681;
        Mon, 15 Jun 2026 13:04:43 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69f00ed975asm3499100eaf.10.2026.06.15.13.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 13:04:43 -0700 (PDT)
Message-ID: <553cba4a-b4b1-4a2f-a484-4ef1d10b0c90@kernel.dk>
Date: Mon, 15 Jun 2026 14:04:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
From: Jens Axboe <axboe@kernel.dk>
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
Content-Language: en-US
In-Reply-To: <d0f05189-6192-46ca-9caf-2c71c07ddc4c@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-13738-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2EC61689AB0

On 6/15/26 12:47 PM, Jens Axboe wrote:
> On 6/15/26 12:33 PM, Caleb Sander Mateos wrote:
>> On Sat, Jun 13, 2026 at 5:08?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 6/12/26 8:26 PM, Caleb Sander Mateos wrote:
>>>> On Fri, Jun 12, 2026 at 12:37?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
>>>>>>> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req)
>>>>>>>                 return;
>>>>>>>         }
>>>>>>>
>>>>>>> +       /* task_work must only be added once */
>>>>>>> +       if (test_and_set_bit(0, &tctx->tw_pending))
>>>>>>> +               return;
>>>>>>
>>>>>> Is tw_pending necessary? How come the task_work_add() exclusivity
>>>>>> isn't already provided by the mpscq_push() check above?
>>>>>
>>>>> It is, because the transition from empty -> not-empty no longer works
>>>>> for that, as the mpscq emtpies one-by-one rather than with a delete-all
>>>>> kind of primitive.
>>>>
>>>> Sorry, I'm still not following why the empty check doesn't suffice.
>>>> It's true that mpscq elements can be removed from the head one at a
>>>> time, but mpscq_push() will continue to return false until the
>>>> consumer pops all the elements and successfully sets tail back to
>>>> &stub. mpscq_push() will return true once when tail transitions away
>>>> from &stub, and then not again until the task work runs and sets tail
>>>> back to &stub.
>>>
>>> Let's say the task_work is currently running, a producer is adding more.
>>> It finds queue empty, re-adds the task_work. That part is fine, we can
>>> add the task_work while it's running as it has been detached already.
>>> The task_work keeps running and also prunes this new item. Producer adds
>>> another one, finds the queue empty, re-adds task_work. This one is not
>>> OK, the task_work was already re-added when it previously found it
>>> empty. Boom.
>>
>> Ah right, I forgot that mpscq_pop() can both return a popped node and
>> set the tail back to &stub. Maybe it would make sense for it to return
>> whether the queue has been marked empty and break out of
>> tctx_task_work_run() in that case instead of relying on a separate
>> call to mpscq_empty()? The atomic RMW for tw_pending every time the
>> queue transitions between empty and non-empty seems like it could be
>> quite expensive.
> 
> We could tweak it like that. I didn't look too closely as this is the
> !DEFER case and hence a lot less interesting, but if you want to send a
> patch my way I'd be happy to stage it on top.

I took a look, and yes I think it actually comes out nicer this way.
Good suggestion! It also helps cap the number of task_work items run,
which is a nice side effect. What do you think?

Needs a commit message obviously.

commit 572a1fb6d0f25b706ff044fcf141827f49db2ec0
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Jun 15 13:43:16 2026 -0600

    io_uring: get rid of tw_pending for !DEFER task work
    
    Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6415a3353ee0..87151a5b62c1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -149,8 +149,6 @@ struct io_uring_task {
 
 	struct { /* task_work */
 		struct mpscq		task_list;
-		/* BIT(0) guards adding tw only once */
-		unsigned long		tw_pending;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
index c801384c6a0a..f910526766fd 100644
--- a/io_uring/mpscq.h
+++ b/io_uring/mpscq.h
@@ -122,4 +122,13 @@ static inline struct llist_node *mpscq_pop(struct mpscq *q,
 	return NULL;
 }
 
+/*
+ * Returns true if the most recent mpscq_pop() that returned a node also
+ * emptied the queue. Consumer must be serialized.
+ */
+static inline bool mpscq_pop_emptied(struct mpscq *q, struct llist_node *head)
+{
+	return head == &q->stub;
+}
+
 #endif /* IOU_MPSCQ_H */
diff --git a/io_uring/tw.c b/io_uring/tw.c
index e74372233f40..f2ce806b01a1 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -34,10 +34,6 @@ void io_tctx_fallback_work(struct work_struct *work)
 						  fallback_work);
 	unsigned int count = 0;
 
-	/* see tctx_task_work() - a set bit must always have a run coming */
-	clear_bit(0, &tctx->tw_pending);
-	smp_mb__after_atomic();
-
 	/*
 	 * Run the entries directly. We're in PF_KTHRED context, hence
 	 * io_should_terminate_tw() is true and they will be marked as
@@ -101,6 +97,13 @@ void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries,
 				io_poll_task_func, io_req_rw_complete,
 				(struct io_tw_req){req}, ts);
 		(*count)++;
+		/*
+		 * Break if most recent pop emptied the queue. This helps
+		 * bound task_work run, and also protects the regular
+		 * task_work addition.
+		 */
+		if (mpscq_pop_emptied(&tctx->task_list, tctx->task_head))
+			break;
 		if (unlikely(need_resched())) {
 			ctx_flush_and_put(ctx, ts);
 			ctx = NULL;
@@ -127,8 +130,6 @@ void tctx_task_work(struct callback_head *cb)
 	unsigned int count = 0;
 
 	tctx = container_of(cb, struct io_uring_task, task_work);
-	clear_bit(0, &tctx->tw_pending);
-	smp_mb__after_atomic();
 	tctx_task_work_run(tctx, UINT_MAX, &count);
 }
 
@@ -206,7 +207,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->tctx;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	/* task_work already pending, we're done */
+	/* tw run already pending, nothing else to do */
 	if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
 		return;
 
@@ -223,10 +224,6 @@ void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	/* task_work must only be added once */
-	if (test_and_set_bit(0, &tctx->tw_pending))
-		return;
-
 	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
 		return;
 

-- 
Jens Axboe

