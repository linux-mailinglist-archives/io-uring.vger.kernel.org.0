Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148F74A9171
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 01:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351538AbiBDAHQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 19:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356136AbiBDAHP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 19:07:15 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C65C061714;
        Thu,  3 Feb 2022 16:07:15 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id f17so8194589wrx.1;
        Thu, 03 Feb 2022 16:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lhrAEkJ0ha6r16GapGp350L1+fU0nb2Un6BQK+QMH/0=;
        b=K6VHZVaqPFXYdcJdYYxz6O2kH9XLpaJ9QS25PTkPEsm+yWirMVTPyX+K1f+79fC3WC
         SHp4rowWDyEA1XYYcfEiY0FaQdolL6wpnaIC0BE6chrHussV4863rzfJJOdjX3q1irVg
         DOOCDfNuM9/FZrF0P38fTk/FAx+Qo9iKdXTcnohpwNlkXRmBxc1K6jg0zl1hfT/ZMw0X
         bcXh0LjScbmoDTKRp/VJErctG3MNs3xPQps9tJpVlh6R3K++n7xyu4l09XVWCk9iIfgg
         NyAFErjTd4YlPtbMU/mlMeqkkLiu0lD+wDglFB2uXQVNQy7kiJqw4AUAFL2ENfRdTRGd
         7CAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lhrAEkJ0ha6r16GapGp350L1+fU0nb2Un6BQK+QMH/0=;
        b=f8Qh6aO4iyPq3R4t7VADHf8xonUwnW1j3D8tOadzXk6c6vL+vArrjiWNxm7fB9almq
         PfhQeeT47c+OMC/gVONW3ukPjnCnPg/ZgHR4GtIk9gApAVNMWhDA89pTZcePMsTMSSSQ
         NqA55aFrKRyfmcshEIL+6brxucJ0vqP6eVXvTLKVDZg1G6lY8v4nvQ7jOt+aej/BEYLe
         GqbbLOzHjg0HKWf7EF34ZU+Fr7SVoZJNeMcZBq7TdiZvSvFxN2Wxz4B+arWzH2TVHrC1
         m4mLCAeqcv8XfPoy/QOZ3gSxYmcSnn0Zs2PkO7i9biI1cDP3DUJ7UwrWz4QRGONJ+2Jo
         X3sQ==
X-Gm-Message-State: AOAM533aqZinXdHIby3fw3gorzSKApwRVbOob/AP9DSmA5u8faW7urWg
        9n9WmmkBmKFHsew++7fTQVrLBSk95Uo=
X-Google-Smtp-Source: ABdhPJyhsS35D9GO2nC1VlcDm/MBMGOAdRDRMV0bGtNFxiFvEmA0P2T4yYraMH5EBOla4r5ygSMVdw==
X-Received: by 2002:adf:ce0c:: with SMTP id p12mr253323wrn.491.1643933233732;
        Thu, 03 Feb 2022 16:07:13 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id p13sm228338wrx.86.2022.02.03.16.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:07:13 -0800 (PST)
Message-ID: <16997265-18fa-64db-32e2-4af7f4dc3e4c@gmail.com>
Date:   Fri, 4 Feb 2022 00:02:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 0/4] io_uring: remove ring quiesce in io_uring_register
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220203233439.845408-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 23:34, Usama Arif wrote:
> For opcodes relating to registering/unregistering eventfds, this is done by
> creating a new RCU data structure (io_ev_fd) as part of io_ring_ctx that
> holds the eventfd_ctx, with reads to the structure protected by
> rcu_read_lock and writes (register/unregister calls) protected by a mutex.
> 
> With the above approach ring quiesce can be avoided which is much more
> expensive then using RCU lock. On the system tested, io_uring_reigster with
> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
> before with ring quiesce.
> 
> The second patch creates the RCU protected data structure and removes ring
> quiesce for IORING_REGISTER_EVENTFD and IORING_UNREGISTER_EVENTFD.
> 
> The third patch builds on top of the second patch and removes ring quiesce
> for IORING_REGISTER_EVENTFD_ASYNC.
> 
> The fourth patch completely removes ring quiesce from io_uring_register,
> as IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS dont need
> them.

Let me leave it just for history: I strongly dislike it considering
there is no one who uses or going to use it. Even more, I can't find a
single user of io_uring_unregister_eventfd() in liburing tests, so most
probably the paths are not tested at all.



> ---
> v4->v5:
> - Remove ring quiesce completely from io_uring_register (Pavel Begunkov)
> - Replaced rcu_barrier with unregistering flag (Jens Axboe)
> - Created a faster check for ctx->io_ev_fd in io_eventfd_signal and cleaned up
> io_eventfd_unregister (Jens Axboe)
> 
> v3->v4:
> - Switch back to call_rcu and use rcu_barrier incase io_eventfd_register fails
> to make sure all rcu callbacks have finished.
> 
> v2->v3:
> - Switched to using synchronize_rcu from call_rcu in io_eventfd_unregister.
> 
> v1->v2:
> - Added patch to remove eventfd from tracepoint (Patch 1) (Jens Axboe)
> - Made the code of io_should_trigger_evfd as part of io_eventfd_signal (Jens Axboe)
> 
> Usama Arif (4):
>    io_uring: remove trace for eventfd
>    io_uring: avoid ring quiesce while registering/unregistering eventfd
>    io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC
>    io_uring: remove ring quiesce for io_uring_register
> 
>   fs/io_uring.c                   | 202 ++++++++++++++++----------------
>   include/trace/events/io_uring.h |  13 +-
>   2 files changed, 107 insertions(+), 108 deletions(-)
> 

-- 
Pavel Begunkov
