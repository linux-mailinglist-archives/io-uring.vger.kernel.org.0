Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF7A4A91A3
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 01:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356249AbiBDA30 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 19:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356245AbiBDA30 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 19:29:26 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5871C061714;
        Thu,  3 Feb 2022 16:29:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l25so8164002wrb.13;
        Thu, 03 Feb 2022 16:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0Gp0TETqAe/mWjaH/+OeSXO8U5mVmXl/S1CjtO3ewhc=;
        b=qrZbBCW/HSA0A04DmdQ87wF/0W6/RG8wz3/T5sLVU6tyHsVZ60rdwnQFPMQMgHBrMU
         8yfpDMCczIYjX04Eyu9uzRBlBpggwr8esOqbd64s0AE+e1j+tUSjq0v19jr8QrkdezZO
         KXTBGCSdAAx8jHo/5oDTXNvF5Dy/1c/Cr+WgeCPGL6XlxZYVvo5thftNyw6FUUaDorHA
         mPjzq8GvKIMMd5e9aeumXqBwzSYVCAdhlyv1J0m5fRx+VNYsRyfXzm127FDVFURPr8ip
         48sicXUb3TAvRdbq7urjd4CC1Rmv+2sOcIuPYtoyF76dDrBSLYBDhol0dg4UXs0RuLXc
         7/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0Gp0TETqAe/mWjaH/+OeSXO8U5mVmXl/S1CjtO3ewhc=;
        b=vb+tpIaplJTdhBP+ci0GfL1vJ7rKLmnaYLoB1SFC8k3T4myArtQ5fAfqZfrx4kuBv7
         Q3Rv3n+8HxhQfTcwWqMK+/qnBEg9mtm2yklIsJM9y7PngxuAAPUfaNI6d75+wPPHRFZm
         IzcUc+ZEhedIiavsZsjA6pufja/m2IS1XDOJZTSaHoWiFPeZ67mpSfLsTmap2azc6U3X
         peA5BeCMkWRGC3TCPPYwPX+b71SNkre7DDw4GdSNlHtoJI2ZdzOukhEPaTfuRSQE7Zx1
         bVPiX5Qb7EY3CyMTeFTfo+4cdNQTRHKT34IaIKZoY+UNM2uGXAkZSjTMnFFeEQREm7O1
         SPQA==
X-Gm-Message-State: AOAM531kwyG7sECIvDGPiabK/euCDJOhYqaQWceI2PZwBONHVvl7piY8
        T3ydStjl4dlRiJKC+j4jEVBfwfvacG0=
X-Google-Smtp-Source: ABdhPJy/iHlMc2QhX+4qBtgKajhqLA0jntBxoMu/QgNN/J3LM2fwBAvK2u9e1ugHe5KGVERV9X1Uxg==
X-Received: by 2002:a5d:64c2:: with SMTP id f2mr309157wri.429.1643934564379;
        Thu, 03 Feb 2022 16:29:24 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id y7sm273033wrr.74.2022.02.03.16.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:29:24 -0800 (PST)
Message-ID: <cdd132f8-cb38-df11-f140-7aa03226b68b@gmail.com>
Date:   Fri, 4 Feb 2022 00:24:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 0/4] io_uring: remove ring quiesce in io_uring_register
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <16997265-18fa-64db-32e2-4af7f4dc3e4c@gmail.com>
 <c2f05b78-1f81-32f9-79df-06d35d9dbc7a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c2f05b78-1f81-32f9-79df-06d35d9dbc7a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/22 00:15, Jens Axboe wrote:
> On 2/3/22 5:02 PM, Pavel Begunkov wrote:
>> On 2/3/22 23:34, Usama Arif wrote:
>>> For opcodes relating to registering/unregistering eventfds, this is done by
>>> creating a new RCU data structure (io_ev_fd) as part of io_ring_ctx that
>>> holds the eventfd_ctx, with reads to the structure protected by
>>> rcu_read_lock and writes (register/unregister calls) protected by a mutex.
>>>
>>> With the above approach ring quiesce can be avoided which is much more
>>> expensive then using RCU lock. On the system tested, io_uring_reigster with
>>> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
>>> before with ring quiesce.
>>>
>>> The second patch creates the RCU protected data structure and removes ring
>>> quiesce for IORING_REGISTER_EVENTFD and IORING_UNREGISTER_EVENTFD.
>>>
>>> The third patch builds on top of the second patch and removes ring quiesce
>>> for IORING_REGISTER_EVENTFD_ASYNC.
>>>
>>> The fourth patch completely removes ring quiesce from io_uring_register,
>>> as IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS dont need
>>> them.
>>
>> Let me leave it just for history: I strongly dislike it considering
>> there is no one who uses or going to use it.
> 
> Are you referring to the 4th patch? Or the patchset as a whole? Not clear
> to me, because eventfd registration is most certainly used by folks
> today.

I refer to optimising eventfd unregister with no users of it, which
lead to the RCU approach.

1/4 is good, taking ENABLE_RINGS and RESTRICTIONS out of quiesce is
also great. 4/4 per se is not a problem, even if I'd need to revert
it later.

>> Even more, I can't find a single user of io_uring_unregister_eventfd()
>> in liburing tests, so most probably the paths are not tested at all.
> 
> That's definitely a general issue, not related to this patchset.
> Something that most certainly should get added! Ring exit will use the
> same unregister path for eventfd, however, so it does get exercised from
> there with existing tests too.

io_ring_ctx_free()
  -> io_eventfd_unregister()

It's called after full quiesce in io_ring_exit_work() + even more
extra sync, so not completely

> 
> But for this change, we definitely need a test that exercises both
> register and unregister, trying to trigger something funky there.
> 

-- 
Pavel Begunkov
