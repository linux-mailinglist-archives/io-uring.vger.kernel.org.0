Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E5C4A9158
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355610AbiBCX7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiBCX7x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:59:53 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1042C061714;
        Thu,  3 Feb 2022 15:59:52 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id l25so8066082wrb.13;
        Thu, 03 Feb 2022 15:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=afuSNRd50NvHbTYLHnAlRIduTNCsve7ayRH5tY8MsU4=;
        b=RInccEFNgVaGqBWM2z3bVT9HE5fMBbG4Y4U2v4bYnPz+OIJO8ah+yVii+EPHmCfFO4
         7wxBPD0G2TcYtroM9f3YObGAeQjQe8H9UxNb784z4Fu6IyJ18ENz7kT6r4Ji6obizsTo
         /MWwCtZS3clUlAq58ymFk45X3XqNYUUJU6N0hEbRPkUUIHtb1jAuhifz6cgWxw4GdUZ9
         lYYmVz+gkSh+sUogwG3coQzvQYnxqtmnGQrqOwGlRd9LlOXAG/QmVtH4DQZmoWkaFfsn
         yCg+GDkV3hjLAL/kjmSdC/HXHJsPYgg2FE0M/TwVXIVtzeqbbbxGK1xQmgbOo4WZTlNb
         1pTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=afuSNRd50NvHbTYLHnAlRIduTNCsve7ayRH5tY8MsU4=;
        b=lnm6UBQb0pmkzQ3oIEOO1Bl2kHswlcHGtNDroqt3X0cM34mR8YZVYjC6CKfuWdroaD
         nmoLGewsukDDB7uSfMJpg/5im9fb1LhiH8kuqfeLW53v1BP0HfYwwfQGJTkds7lxSh+U
         u0wiwV6lV0HjA5Zx0Yk8jyOj07okX2uWGx1l+rtQPER0yWwcJlxX1nQPl2zDyMUjn3jx
         Sq2/BFpSvcCQ1dZWxXIH+DNxrURGo8X4/QJjAbf6mmenvNsDdRDvC/lY6fXeRgXA9+mj
         fzGlpVLVnNsh6TmlGsT8BxZZ/lKq4o24vBGvT0x9PcKn6rTjuNCXSI1g12xvDxgEND+B
         vX7w==
X-Gm-Message-State: AOAM530mpQSkRTSGgyYN82UNcax1/f87K/9AIzFpVToCPKnN6RLP118o
        pZ0K+LytWVHkq06cs/JIndI=
X-Google-Smtp-Source: ABdhPJw/BOBzUSO/DXPvXZHvQLKniqOxzoCoE8qWqO1zf+k/xmJ/DFy2sJXCdc8FT2zJVJnD/0+RbA==
X-Received: by 2002:a5d:47c5:: with SMTP id o5mr256726wrc.666.1643932791556;
        Thu, 03 Feb 2022 15:59:51 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id n11sm3389735wms.3.2022.02.03.15.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 15:59:51 -0800 (PST)
Message-ID: <cc66a5aa-b9b4-8085-f6f7-02009b391389@gmail.com>
Date:   Thu, 3 Feb 2022 23:54:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 2/4] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <20220203233439.845408-3-usama.arif@bytedance.com>
 <03ee875d-03fd-d538-7a03-7cbde98d5b78@gmail.com>
In-Reply-To: <03ee875d-03fd-d538-7a03-7cbde98d5b78@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 23:46, Pavel Begunkov wrote:
> On 2/3/22 23:34, Usama Arif wrote:
>> This is done by creating a new RCU data structure (io_ev_fd) as part of
>> io_ring_ctx that holds the eventfd_ctx.
>>
>> The function io_eventfd_signal is executed under rcu_read_lock with a
>> single rcu_dereference to io_ev_fd so that if another thread unregisters
>> the eventfd while io_eventfd_signal is still being executed, the
>> eventfd_signal for which io_eventfd_signal was called completes
>> successfully.
>>
>> The process of registering/unregistering eventfd is done under a lock
>> so multiple threads don't enter a race condition while
>> registering/unregistering eventfd.
>>
>> With the above approach ring quiesce can be avoided which is much more
>> expensive then using RCU lock. On the system tested, io_uring_reigster with
>> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
>> before with ring quiesce.
>>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   fs/io_uring.c | 116 ++++++++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 93 insertions(+), 23 deletions(-)
>>
[...]
>> +
>> +static void io_eventfd_put(struct rcu_head *rcu)
>> +{
>> +    struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
>> +    struct io_ring_ctx *ctx = ev_fd->ctx;
>> +
>> +    eventfd_ctx_put(ev_fd->cq_ev_fd);
>> +    kfree(ev_fd);
>> +    rcu_assign_pointer(ctx->io_ev_fd, NULL);
>>   }
> 
> Emm, it happens after the grace period, so you have a gap where a
> request may read a freed eventfd... What I think you wanted to do
> is more like below:
> 
> 
> io_eventfd_put() {
>      evfd = ...;
>      eventfd_ctx_put(evfd->evfd);
>      kfree(io_ev_fd);
> }
> 
> register() {

s/register/unregister/

>      mutex_lock();
>      ev_fd = rcu_deref();
>      if (ev_fd) {
>          rcu_assign_pointer(ctx->evfd, NULL);
>          call_rcu(&ev_fd->evfd, io_eventfd_put);
>      }
>      mutex_unlock();
> }
> 
> 
> Note, there's no need in ->unregistering. I also doubt you need
> ->ev_fd_lock, how about just using already taken ->uring_lock?

-- 
Pavel Begunkov
