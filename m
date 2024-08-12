Return-Path: <io-uring+bounces-2725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9D794F857
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 22:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB7851F21A13
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EE2194A52;
	Mon, 12 Aug 2024 20:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zqrrYtWv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC861946C7
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 20:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723495252; cv=none; b=mSoWou3hbdYbY9y2wC1M+qk3xGuxyHpY7hYd8AzaXHY7wOe6bluyVNnMuIpHQjB9oQ/gX0vx0bm3SFqattuShdbOjnCoPaDwOoCeyLd3mAo2hKodQb1H5dkFiqDBKFOsxSS/PTtGLKHIuwRfkeMk+KI8i7uuOprnMyoJ15bJvps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723495252; c=relaxed/simple;
	bh=CNgmyOLCFukspXKWXbwdIho8IDPhHjh8HIeYsaDPLks=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=H8C8uGckJ6x78msMrNayb9HwD/tvk6HePrZzP8BAwQzlPdTKB7C/2RdA97cZq0mp/vnMeAbMedJUxP9h9Kcu/zCWo3+yovOpKOIA4Qo+NnamTFD9sb2KRmGR11JEcPKnfPfzVfy8nv1F48a+ASZ4G5LguplkRJwoga8Gl7Nkf6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zqrrYtWv; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fd8faa28fdso1163925ad.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 13:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723495249; x=1724100049; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CoWPHYbemgcA3L+FBSAQ9p+jix1098mDLV0YzF34GPY=;
        b=zqrrYtWvqFpRcNFnmduBR6iQYFq6uOV0E80VtMHqHQDjqqRJiKbnWGLZ7OMPJT0Zu+
         ywbwT0vx7ERYc+FWAe6oGdBbkiKjEmsHjjRNShpb8ymik4aJ9pHouhCx0MEizfxwQbJv
         jgFiUQ0QzlvXVQD5bZetoRZMFdhQfFTwNVgFEa73vI1cp4dFOqpW9VW1J2GIzApAvj+y
         q0oC46kZwcbxgCtg1VknQzCksalW7HLKJ3Byny9nySy9t97cLB0d2kWAsu5oFUAT+ZZe
         kCeJJQ+f/4SuHe9lij8Zvk1Kn7NchxRBFd7y2Y+nZ6hfJj1ibLF6aswmoRSKJVmys9p4
         g64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723495249; x=1724100049;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CoWPHYbemgcA3L+FBSAQ9p+jix1098mDLV0YzF34GPY=;
        b=lbLeMz7/vL+J0TSxTy3Cf+kcLliCV79WPtuPWMwEGLrEFgrX9JqP5EhIDCOQls1yWV
         SggGs5ydSbg95NF1jLGD4/JOnwBx5I/oSrQRx6vcYounYGifcpG01lzjv3ZceUc0XXxk
         b5WBNW1d1URV97QCM/UR/vvxjVXh5zT1Wcqz0/j92f6k4dSE1zINck9jej6hWX3iFnxm
         Do/0DmKb+BkAXdT0khvPhkGu9nrTJFxh/ZGbKJSOYqMA9uqvoBtDJEKeCAbMjxZbfT1p
         r7YkH0O6wDfCY/aWBi/pbajeyxRjH50nH+sxJANH9hLR79GUsy9U3n4LFg04aBDlS5rx
         FSbg==
X-Forwarded-Encrypted: i=1; AJvYcCU1Ma1X0/b0saCniCyR3ybcs5oPbIawt2N0IKxZm+S2QpzsjFjOqViKxLikK4iNC5QccSGTSYtaZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGNp1DfhSNETjcWY2mWMV3T5QwIMFPjac4RPgBzaY9bucU6wKH
	CxDJPQTa3Pt2gAsX1N7zwGvUyeNggSgnb0a+vB0yppkboT82uvy6fwd5+HB7vCc=
X-Google-Smtp-Source: AGHT+IH/WYz1IJjfxaPmBMvM81RkoeDaONRn3mPAwBOoalVtcmzn3oGn7jevkEThCdp4im0bc+LtNQ==
X-Received: by 2002:a17:902:d2cd:b0:1f7:3ed:e7b2 with SMTP id d9443c01a7336-201cd9383c9mr991925ad.0.1723495248940;
        Mon, 12 Aug 2024 13:40:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1bb23csm933005ad.208.2024.08.12.13.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 13:40:48 -0700 (PDT)
Message-ID: <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
Date: Mon, 12 Aug 2024 14:40:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 2:15 PM, Olivier Langlois wrote:
> On Mon, 2024-08-12 at 12:11 -0600, Jens Axboe wrote:
>> On 8/12/24 12:10 PM, Jens Axboe wrote:
>>> On 8/11/24 7:00 PM, Olivier Langlois wrote:
>>>> On Sun, 2024-08-11 at 20:34 -0400, Olivier Langlois wrote:
>>>>> io_napi_entry() has 2 calling sites. One of them is unlikely to
>>>>> find
>>>>> an
>>>>> entry and if it does, the timeout should arguable not be
>>>>> updated.
>>>>>
>>>>> The other io_napi_entry() calling site is overwriting the
>>>>> update made
>>>>> by io_napi_entry() so the io_napi_entry() timeout value update
>>>>> has no
>>>>> or
>>>>> little value and therefore is removed.
>>>>>
>>>>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>>>>> ---
>>>>>  io_uring/napi.c | 1 -
>>>>>  1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/io_uring/napi.c b/io_uring/napi.c
>>>>> index 73c4159e8405..1de1d4d62925 100644
>>>>> --- a/io_uring/napi.c
>>>>> +++ b/io_uring/napi.c
>>>>> @@ -26,7 +26,6 @@ static struct io_napi_entry
>>>>> *io_napi_hash_find(struct hlist_head *hash_list,
>>>>>  	hlist_for_each_entry_rcu(e, hash_list, node) {
>>>>>  		if (e->napi_id != napi_id)
>>>>>  			continue;
>>>>> -		e->timeout = jiffies + NAPI_TIMEOUT;
>>>>>  		return e;
>>>>>  	}
>>>>>  
>>>> I am commenting my own patch because I found something curious
>>>> that I
>>>> was not sure about when I was reviewing the code.
>>>>
>>>> Should the remaining e->timeout assignation be wrapped with a
>>>> WRITE_ONCE() macro to ensure an atomic store?
>>>
>>> I think that makes sense to do as lookup can be within rcu, and
>>> hence we have nothing serializing it. Not for torn writes, but to
>>> ensure that the memory sanitizer doesn't complain. I can just make
>>> this change while applying, or send a v2.
>>
>> As a separate patch I mean, not a v2. That part can wait until 6.12.
>>
> ok. np. I'll look into it soon.
> 
> In the meantime, I have detected few suspicious things in the napi
> code.
> 
> I am reporting them here to have few extra eye balls looking at them to
> be sure that everything is fine or not.
> 
> 1. in __io_napi_remove_stale(),
> 
> is it ok to use hash_for_each() instead of hash_for_each_safe()?
> 
> it might be ok because it is a hash_del_rcu() and not a simple
> hash_del() but I have little experience with possible RCU shortcuts so
> I am unsure on this one...

Should use hash_for_each_rcu(), and I think for good measure, we sould
just keep it inside the RCU region. Then we know for a fact that the
deletion doesn't run.

> 2. in io_napi_free()
> 
> list_del(&e->list); is not called. Can the only reason be that
> io_napi_free() is called as part of the ring destruction so it is an
> optimization to not clear the list since it is not expected to be
> reused?
> 
> would calling INIT_LIST_HEAD() before exiting as an extra precaution to
> make the function is future proof in case it is reused in another
> context than the ring destruction be a good idea?

I think that's just an oversight, and doesn't matter since it's all
going away anyway. But it would be prudent to delete it regardless!

> 3. I am surprised to notice that in __io_napi_do_busy_loop(),
> list_for_each_entry_rcu() is called to traverse the list but the
> regular methods list_del() and list_add_tail() are called to update the
> list instead of their RCU variant.

Should all just use rcu variants.

Here's a mashup of the changes. Would be great if you can test - I'll do
some too, but always good with more than one person testing as it tends
to hit more cases.


diff --git a/io_uring/napi.c b/io_uring/napi.c
index d0cf694d0172..6251111a7e1f 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -81,7 +81,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
-	list_add_tail(&e->list, &ctx->napi_list);
+	list_add_tail_rcu(&e->list, &ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
 }
 
@@ -91,9 +91,9 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
-	hash_for_each(ctx->napi_ht, i, e, node) {
+	hash_for_each_rcu(ctx->napi_ht, i, e, node) {
 		if (time_after(jiffies, e->timeout)) {
-			list_del(&e->list);
+			list_del_rcu(&e->list);
 			hash_del_rcu(&e->node);
 			kfree_rcu(e, rcu);
 		}
@@ -174,9 +174,8 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 	do {
 		is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
 	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_arg);
-	rcu_read_unlock();
-
 	io_napi_remove_stale(ctx, is_stale);
+	rcu_read_unlock();
 }
 
 /*
@@ -209,6 +208,7 @@ void io_napi_free(struct io_ring_ctx *ctx)
 	spin_lock(&ctx->napi_lock);
 	hash_for_each(ctx->napi_ht, i, e, node) {
 		hash_del_rcu(&e->node);
+		list_del_rcu(&e->list);
 		kfree_rcu(e, rcu);
 	}
 	spin_unlock(&ctx->napi_lock);
@@ -309,9 +309,8 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 
 	rcu_read_lock();
 	is_stale = __io_napi_do_busy_loop(ctx, NULL);
-	rcu_read_unlock();
-
 	io_napi_remove_stale(ctx, is_stale);
+	rcu_read_unlock();
 	return 1;
 }
 

-- 
Jens Axboe


