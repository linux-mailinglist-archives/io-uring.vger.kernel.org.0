Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820194A8B9B
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 19:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353463AbiBCS0o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 13:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353456AbiBCS0o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 13:26:44 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC54C061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 10:26:43 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id s18so6705273wrv.7
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 10:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWI0+x1zjRdNZd4hSHdWsF4M1u/QYwQfZKbKt9HgHN4=;
        b=CIZgAFLya2oubgyuO1IEyvirg9Km0oHON+oACRu7wZ/jCnd+q7F5JydvsOhv0qZAqV
         JkaddLV6bjn41QTYlWd3U6eTLuSnQpTQ8FPlp3DlMiuzfgiQVXE4s/pPcsCD526uSpyw
         TlbvcCjOC7PdH99QmZ0mwry+zRxJItoiKCO0yaCaIShoxWgTw/RtRsNKlmixi8qzHoXU
         2/CaEubGCNQg7lRtfipGA99TgzEt370fA5uhtX0bQMx8xIDYgsIxLPxcGn7aZOkYHZ4+
         4gNYpvQo7ROABvLeVnXihtVr2aCO4ra16Tjx6WStOA8p/hcmRVEROrKw+l1mnkh02LLJ
         cESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZWI0+x1zjRdNZd4hSHdWsF4M1u/QYwQfZKbKt9HgHN4=;
        b=QKk44PLy+yrUqWpeuuR6CqzVp+sZ3fyjqRXV8oitKiNMocW1XIAv9hQUVh+Dm1zJKh
         hq2w3Y22Cu4DN/Ej1rKMKrlyENwR5wdPyXUIYatk3SYftR3IHAJRYhFJGbZLWX75jpgc
         qVMWRjOdZh/uwYF36herMKTgri6dFNA/gZB9QstSaJ6XB1y7lPVh8djvdo4LwhnVnh19
         x90mJY6r13Qln4wJT0qczuAMKs9/zr7OWXiC18gzUn1Dg1zCdYGiCIJyR4eBLjYI0pi/
         Wm+2QcKwps49Sj5Dc4Qb9c1agklejBPmhVZKhWEoxx36xHxyDbM2LLB6u5IYuUqz7r8Z
         +h4A==
X-Gm-Message-State: AOAM533i6voADKKeKymlAKALNsec4H9epd2QHPv+pPJ3s+Tg6eV+omni
        h3fWtL+onYI8s8EBDA7xPoYEJg==
X-Google-Smtp-Source: ABdhPJzgY1E3Db9HP3QjZL8LbCqVu2j+/FSXE1GJbMCMq+V3z/8fHgHSWoPUpwF2xytTvVs5u6B33g==
X-Received: by 2002:adf:e846:: with SMTP id d6mr21729812wrn.539.1643912802404;
        Thu, 03 Feb 2022 10:26:42 -0800 (PST)
Received: from ?IPv6:2a02:6b6d:f804:0:28c2:5854:c832:e580? ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id bh19sm2088001wmb.1.2022.02.03.10.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:26:42 -0800 (PST)
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
Message-ID: <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
Date:   Thu, 3 Feb 2022 18:26:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 03/02/2022 17:56, Jens Axboe wrote:
> On 2/3/22 10:41 AM, Usama Arif wrote:
>> @@ -1726,13 +1732,24 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>>   	return &rings->cqes[tail & mask];
>>   }
>>   
>> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>>   {
>> -	if (likely(!ctx->cq_ev_fd))
>> -		return false;
>> +	struct io_ev_fd *ev_fd;
>> +
>> +	rcu_read_lock();
>> +	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
>> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
>> +
>> +	if (likely(!ev_fd))
>> +		goto out;
>>   	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>> -		return false;
>> -	return !ctx->eventfd_async || io_wq_current_is_worker();
>> +		goto out;
>> +
>> +	if (!ctx->eventfd_async || io_wq_current_is_worker())
>> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
>> +
>> +out:
>> +	rcu_read_unlock();
>>   }
> 
> Like Pavel pointed out, we still need the fast path (of not having an
> event fd registered at all) to just do the cheap check and not need rcu
> lock/unlock. Outside of that, I think this looks fine.
> 

Hmm, maybe i didn't understand you and Pavel correctly. Are you 
suggesting to do the below diff over patch 3? I dont think that would be 
correct, as it is possible that just after checking if ctx->io_ev_fd is 
present unregister can be called by another thread and set ctx->io_ev_fd 
to NULL that would cause a NULL pointer exception later? In the current 
patch, the check of whether ev_fd exists happens as the first thing 
after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25ed86533910..0cf282fba14d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1736,12 +1736,13 @@ static void io_eventfd_signal(struct io_ring_ctx 
*ctx)
  {
         struct io_ev_fd *ev_fd;

+       if (likely(!ctx->io_ev_fd))
+               return;
+
         rcu_read_lock();
         /* rcu_dereference ctx->io_ev_fd once and use it for both for 
checking and eventfd_signal */
         ev_fd = rcu_dereference(ctx->io_ev_fd);

-       if (likely(!ev_fd))
-               goto out;
         if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
                 goto out;




>>   static int io_eventfd_unregister(struct io_ring_ctx *ctx)
>>   {
>> -	if (ctx->cq_ev_fd) {
>> -		eventfd_ctx_put(ctx->cq_ev_fd);
>> -		ctx->cq_ev_fd = NULL;
>> -		return 0;
>> +	struct io_ev_fd *ev_fd;
>> +	int ret;
>> +
>> +	mutex_lock(&ctx->ev_fd_lock);
>> +	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock));
>> +	if (!ev_fd) {
>> +		ret = -ENXIO;
>> +		goto out;
>>   	}
>> +	synchronize_rcu();
>> +	eventfd_ctx_put(ev_fd->cq_ev_fd);
>> +	kfree(ev_fd);
>> +	rcu_assign_pointer(ctx->io_ev_fd, NULL);
>> +	ret = 0;
>>   
>> -	return -ENXIO;
>> +out:
>> +	mutex_unlock(&ctx->ev_fd_lock);
>> +	return ret;
>>   }
> 
> synchronize_rcu() can take a long time, and I think this is in the wrong
> spot. It should be on the register side, IFF we need to expedite the
> completion of a previous event fd unregistration. If we do it that way,
> at least it'll only happen if it's necessary. What do you think?
> 


How about the approach in v4? so switching back to call_rcu as in v2 and 
if ctx->io_ev_fd is NULL then we call rcu_barrier to make sure all rcu 
callbacks are finished and check for NULL again.

Thanks!
Usama
