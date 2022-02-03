Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31884A8CC1
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 20:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353873AbiBCTyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 14:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiBCTyv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 14:54:51 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955EEC06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 11:54:51 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l67-20020a1c2546000000b00353951c3f62so1934736wml.5
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 11:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y44zptoyBQLAujhlZ/MuHON8Wbn4y7Zbk/lQZP1hyec=;
        b=VY6v/pP1cou2w5F5yWyeGXyNYDBFwUJHw5rvDGwXo8eOGxJISSl3CzmFWJXDWLPH1k
         VTGef0F5JqLZcJ0Aj66c5C7UMn6k1Ua299eOXLcThLrhyioQ0J2TmrhMfJoclXCJrbK/
         Yb1WoMJo4Eo5qXPREw6QD/iBATIRpawjctMw8VACR7MiqwhPirNifiq4XCMe585L/J1e
         ujd7MznJxOHUb3QD0EXs+pGfjxNcJdypoKlLMduTMhb3Lw3+Ov9vt/yeYmcSYkA7ZCx9
         cuaPDtvf9Wj+5Rfxw3PZNnei/9T95l7rZ0xWMHHQ1SGLreIqwuh5BJpKeC83+ODU+trn
         wc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y44zptoyBQLAujhlZ/MuHON8Wbn4y7Zbk/lQZP1hyec=;
        b=VMlo3ZiijMjtbZ8bqDtrcczD+wVUs3MjsFV+F6IKTEYks6vGmCYX7mKs5N7WNdz6xA
         dgf6uA/dvYmTUvejbUQ196MbaQ5EFbWYNzS78eOELQ0disPGKJU/LPfpVNUtw30b3Uay
         1wPdnB+oL9n035p3reoIho/QXRgG2JFdTMNFtGO87fPszPNQqnjZXG1d3QtAllJT7mOk
         LaVhFCNGqcOVkNh5g2szHHLymTXg4+ZB9Y4pY/xIDKS3V9kvXKexIJ60PNtYBCV8P7vh
         xPLhQFhTsFUr7zLLM/7aprGIm8p2m/aZuVG6EDciwH2m7Jqzmh/xIi5GKs/zK2AIAGRM
         2pfA==
X-Gm-Message-State: AOAM532T+tYgR+bf9lChcTMYCbRoU41Vl4LBA4WnG6raB5ys3wqqbabw
        v2gs4qx2uQkumvtPdgHLXFrtGQ==
X-Google-Smtp-Source: ABdhPJzn1wjMX04IDeNTXWw9f3MKI1fNhQ3TxwQB7SQpqXjB9VQYl3Nple9nXCiVW1wOTp0dISodww==
X-Received: by 2002:a05:600c:27ca:: with SMTP id l10mr11824958wmb.105.1643918090174;
        Thu, 03 Feb 2022 11:54:50 -0800 (PST)
Received: from ?IPv6:2a02:6b6d:f804:0:28c2:5854:c832:e580? ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id i94sm20657913wri.21.2022.02.03.11.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 11:54:49 -0800 (PST)
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
 <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
 <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
 <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
Message-ID: <fc97036f-26a3-afb1-180f-30aa89d3cc01@bytedance.com>
Date:   Thu, 3 Feb 2022 19:54:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 03/02/2022 19:06, Jens Axboe wrote:
> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>> On 2/3/22 18:29, Jens Axboe wrote:
>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>
>>> They are cheap, but they are still noticeable at high requests/sec
>>> rates. So would be best to avoid them.
>>>
>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>> notification if it races with registering an eventfd descriptor. But
>>> that's not really a concern, as if you register with inflight IO
>>> pending, then that always exists just depending on timing. The only
>>> thing I care about here is that it's always _safe_. Hence something ala
>>> what you did below is totally fine, as we're re-evaluating under rcu
>>> protection.
>>
>> Indeed, the patch doesn't have any formal guarantees for propagation
>> to already inflight requests, so this extra unsynchronised check
>> doesn't change anything.
>>
>> I'm still more сurious why we need RCU and extra complexity when
>> apparently there is no use case for that. If it's only about
>> initial initialisation, then as I described there is a much
>> simpler approach.
> 
> Would be nice if we could get rid of the quiesce code in general, but I
> haven't done a check to see what'd be missing after this...
> 

I had checked! I had posted below in in reply to v1 
(https://lore.kernel.org/io-uring/02fb0bc3-fc38-b8f0-3067-edd2a525ef29@gmail.com/T/#m5ac7867ac61d86fe62c099be793ffe5a9a334976), 
but i think it got missed! Copy-pasting here for reference:

"
I see that if we remove ring quiesce from the the above 3 opcodes, then
only IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS is
left for ring quiesce. I just had a quick look at those, and from what i
see we might not need to enter ring quiesce in
IORING_REGISTER_ENABLE_RINGS as the ring is already disabled at that point?
And for IORING_REGISTER_RESTRICTIONS if we do a similar approach to
IORING_REGISTER_EVENTFD, i.e. wrap ctx->restrictions inside an RCU
protected data structure, use spin_lock to prevent multiple
io_register_restrictions calls at the same time, and use read_rcu_lock
in io_check_restriction, then we can remove ring quiesce from
io_uring_register altogether?

My usecase only uses IORING_REGISTER_EVENTFD, but i think entering ring
quiesce costs similar in other opcodes. If the above sounds reasonable,
please let me know and i can send patches for removing ring quiesce for
io_uring_register.
"

Let me know if above makes sense, i can add patches on top of the 
current patchset, or we can do it after they get merged.

As for why, quiesce state is very expensive. its making 
io_uring_register the most expensive syscall in my usecase (~15ms) 
compared to ~0.1ms now with RCU, which is why i started investigating 
this. And this patchset avoids ring quiesce for 3 of the opcodes, so it 
would generally be quite helpful if someone does registers and 
unregisters eventfd multiple times.

Thanks,
Usama
