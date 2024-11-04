Return-Path: <io-uring+bounces-4408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDFA9BB8FA
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FCB41F214A0
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1221BD017;
	Mon,  4 Nov 2024 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSmtG189"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CDF13C827;
	Mon,  4 Nov 2024 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730734045; cv=none; b=k8F8XeHeIjhudMK4TEFn6OQlYUcAeCbVWGBjwcf8+NNxrCMDh3gGfZi5FxMm6dDT9fq9UHTzfi8V51BwX4YsYi45wey4dBEkM43O+sdSrE2vLMhdYdV9BzKP8c7SqEKc5Zvk36yeW/ZLZKw4ggUD/T7Wi3+Dl5b8UyWkX60b960=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730734045; c=relaxed/simple;
	bh=ABkOGAxYh33x4pB/P8hkjpt0ostBfsV+EVzZaB42JQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GRya1EjzgnQvSGKyXWstmA80prNT+P5G0lKLOWbf360NAkiDbE4Vlkin8BwJPbL92uLiNrnPavxFHhjFtubVjcPZdS4933gj1tlbrlRK+xAV4hstwErHT5W/aQTeS/k1FfoXeuPlvVZyWoG3+WglSbFzvUrypywVxjhs+w1XflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSmtG189; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f72c913aso7021026e87.1;
        Mon, 04 Nov 2024 07:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730734042; x=1731338842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wBc8MhRAga/PRE3uqsjAvOcxPfTXDoiIRNPdWwfAYtM=;
        b=FSmtG189pNoy2LcTwqPJDQI/NxDuwQ8LqQI6b0Y8HUApdrYGL1g6Zy/w9tg/AobNsD
         vM1+yspa47UwB55J37rTOdo6RO+G9NhDCxsuCdODJCeCr/G30rbj9ytbFs00mj5qFZdH
         sd/DodfB103QQ4nSLHafDe/6UDAF57kYtNTWtqFD3kTjicqxGzAwHRPMnrZqtIQK0DbZ
         2+Zlz7rIw+VA2vLY63WOkI7w4riKE6bdmY7YcD/jjhSQTa5YX+pItPB0V9vvEML4iFXa
         Zebg5hs9xzU5gWH5Sfb2IiPD6lEs4KZEVK0vhLiPadCMWhLnILsd/36+SfdGHcHO/4Qx
         /3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730734042; x=1731338842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBc8MhRAga/PRE3uqsjAvOcxPfTXDoiIRNPdWwfAYtM=;
        b=kl2jrWtC7c5VQtBwFFsjWciz97QR4DkM+v/Yx5MpBg2RSoTKQy6ge9hYpNs4pK9ONR
         uEULylQMv7UmqKfBU/ec7NF9QLXShOLV5TGHYRYco9bR61qetA6A6vG5qjYG9wER/z/W
         cJLi4P7KOMZ+dJ7WYUoTP7hxlpZ0jppfvNXm5//aFSZjwJyMcKVwHxkmONv2Z1w/DOmi
         pW0fnOm41R8piJG/x0WbC++y8RpoiA0/P4g9DbBXf6JJ2Cl5Lrm09EBkx99prHCdHCwT
         sP18o+UTPMuGzJi36gisdkQu4smS3O8wa6SlAb+lg9/hKgUHHljHw3hrqI4uJFMT+kry
         3syA==
X-Forwarded-Encrypted: i=1; AJvYcCUHGSL0ygXYV7rYQthxTt6nrgHEkGkvqRivGL5BUPWbPWuwRH229+jrDzE8ZcZO04NprgHtGsWJ9Wah@vger.kernel.org, AJvYcCUY87dkvQE6k+rJAGQr1LcK8wojvJLX5MtKbOjwiBjWxm9AfcGGRu2ejBjqzdaYgAj0jQ8e0u4cAA==@vger.kernel.org, AJvYcCVXNsgWmBpoMYMqITbd5qeeaftg0LoP8YM+ZFND59pRbPC9OQXIb4YGCA3+byZtEbqN+hJ2SFdTdpB49PgF@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8KgPNvvQ33j4NrMIICYN12j78S7s4km5Exca7GC+GqVfc1MZB
	JlGI4GrhlTwSKXJSKQRsbBc+k/v7xv84grorJjh20EpZJpHuyQhs
X-Google-Smtp-Source: AGHT+IGA3BEQTes3tMpYQ6/xmqYch1bEKU2RjeYHJmy10NLPEKDEoI2+mykiOpN2RN3sZEnud9HyPQ==
X-Received: by 2002:a05:6512:3b0f:b0:539:fc42:e5ee with SMTP id 2adb3069b0e04-53b348e3390mr15131423e87.29.1730734041519;
        Mon, 04 Nov 2024 07:27:21 -0800 (PST)
Received: from [192.168.42.239] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564941e1sm563371166b.43.2024.11.04.07.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 07:27:21 -0800 (PST)
Message-ID: <965a473d-596a-4cf4-8ec2-a8626c4c73f6@gmail.com>
Date: Mon, 4 Nov 2024 15:27:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6728b077.050a0220.35b515.01ba.GAE@google.com>
 <13da163a-d088-4b4d-8ad1-dbf609b03228@gmail.com>
 <b29d2635-d640-4b8e-ad43-1aa25c20d7c8@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b29d2635-d640-4b8e-ad43-1aa25c20d7c8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 15:08, Jens Axboe wrote:
> On 11/4/24 6:13 AM, Pavel Begunkov wrote:
>> On 11/4/24 11:31, syzbot wrote:
>>> syzbot has bisected this issue to:
>>>
>>> commit 3f1a546444738b21a8c312a4b49dc168b65c8706
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Sat Oct 26 01:27:39 2024 +0000
>>>
>>>       io_uring/rsrc: get rid of per-ring io_rsrc_node list
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15aaa1f7980000
>>> start commit:   c88416ba074a Add linux-next specific files for 20241101
>>> git tree:       linux-next
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17aaa1f7980000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13aaa1f7980000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=704b6be2ac2f205f
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e333341d3d985e5173b2
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ec06a7980000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c04740580000
>>>
>>> Reported-by: syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com
>>> Fixes: 3f1a54644473 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
>>>
>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>
>> Previously all puts were done by requests, which in case of an exiting
>> ring were fallback'ed to normal tw. Now, the unregister path posts CQEs,
>> while the original task is still alive. Should be fine in general because
>> at this point there could be no requests posting in parallel and all
>> is synchronised, so it's a false positive, but we need to change the assert
>> or something else.
> 
> Maybe something ala the below? Also changes these triggers to be
> _once(), no point spamming them.
> 
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 00409505bf07..7792ed91469b 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -137,10 +137,11 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
>   		 * Not from an SQE, as those cannot be submitted, but via
>   		 * updating tagged resources.
>   		 */
> -		if (ctx->submitter_task->flags & PF_EXITING)
> -			lockdep_assert(current_work());
> +		if (ctx->submitter_task->flags & PF_EXITING ||
> +		    percpu_ref_is_dying(&ctx->refs))

io_move_task_work_from_local() executes requests with a normal
task_work of a possible alive task, which which will the check.

I was thinking to kill the extra step as it doesn't make sense,
git garbage digging shows the patch below, but I don't remember
if it has ever been tested.


commit 65560732da185c85f472e9c94e6b8ff147fc4b96
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Jun 7 13:13:06 2024 +0100

     io_uring: skip normal tw with DEFER_TASKRUN
     
     DEFER_TASKRUN execution first falls back to normal task_work and only
     then, when the task is dying, to workers. It's cleaner to remove the
     middle step and use workers as the only fallback. It also detaches
     DEFER_TASKRUN and normal task_work handling from each other.
     
     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9789cf8c68c1..d9e3661ff93d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1111,9 +1111,8 @@ static inline struct llist_node *io_llist_xchg(struct llist_head *head,
  	return xchg(&head->first, new);
  }
  
-static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
  {
-	struct llist_node *node = llist_del_all(&tctx->task_list);
  	struct io_ring_ctx *last_ctx = NULL;
  	struct io_kiocb *req;
  
@@ -1139,6 +1138,13 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
  	}
  }
  
+static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+{
+	struct llist_node *node = llist_del_all(&tctx->task_list);
+
+	__io_fallback_tw(node, sync);
+}
+
  struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
  				      unsigned int max_entries,
  				      unsigned int *count)
@@ -1287,13 +1293,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
  	struct llist_node *node;
  
  	node = llist_del_all(&ctx->work_llist);
-	while (node) {
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
-
-		node = node->next;
-		io_req_normal_work_add(req);
-	}
+	__io_fallback_tw(node, false);
  }
  
  static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e46d13e8a215..bc0a800b5ae7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -128,7 +128,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
  		 * Not from an SQE, as those cannot be submitted, but via
  		 * updating tagged resources.
  		 */
-		if (ctx->submitter_task->flags & PF_EXITING)
+		if (percpu_ref_is_dying(&ctx->refs))
  			lockdep_assert(current_work());
  		else
  			lockdep_assert(current == ctx->submitter_task);

-- 
Pavel Begunkov

