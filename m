Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F090732D4E6
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbhCDOGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbhCDOGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:06:24 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7EDC061760
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:05:44 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id n14so29817814iog.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pXzNuZcJYC8UZVQqjECxwfWmEsy112lNqTYe8e1q1Ag=;
        b=SZ5xD28Y1S/LyJnYnGQyKgLZ2vinBWSQSc13Iv+83xrKwRxWCWfscL2d0DrUNFFoY6
         W2cXp/3hsJfrkU47ArMAtICIm/CQ2NOj1fGVlXHP813njrZoVreqhdfuWxktjAWuGSXT
         HnC52hlfkftDDsPnCd43tZw+JP5Ik4ZiHbwBGR+tELVV1j0isB+22ccNkNPH9wm+vNEF
         kqK/OpQc9fpG14hiCkflsxvBwpM8jRELBPzC15kv/xzaV9V7NaWhn+U0WnxZ65EdGxE0
         fX2rgl7mPNnzKXm5tIfmig1MU1d4gPSMCVnaznMhhcNHEf20foovVyheq68OukKRjVsx
         W5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXzNuZcJYC8UZVQqjECxwfWmEsy112lNqTYe8e1q1Ag=;
        b=LditnGHrQjK81BqzBDoE9pPYrfjARo/m5OrMF9J+EcYhRKPQoNOLvs3g2X36zhnJCy
         yLnTroP2i5p9Yp7LvV8mTO5GD3juw5XwSGYZGIl4CBLi+2bjAofKUEjSMdUVlf0LuPHY
         PW5aLVPDYUaBcOG8UsaS07uNZvazzXW0DOcwYf1h8gbuwR73oHy89zUctvLJSX7SURY/
         O2bN6KwhpDIWbR4DW19jcgKazZ28PHNGE+ldvzH+zqF37875t9RdBUPZU4jsmBYcSbOx
         gN+8DS2dPx4ZP5EOYGLWnXc6ZzcagKv3ZxM2pLeWV7f/5D9V+setwQCnUfC558juhPoP
         k/RA==
X-Gm-Message-State: AOAM530yqmoD7F8ox/MGVJwv+8DPWFf+xVGizcgQSYPGLYOe9wPk4rer
        CLiru8FgQNizChf6y6cI3JIyBJUGWuxwrQ==
X-Google-Smtp-Source: ABdhPJz+VfbPWqE4081uGum2/Yq4CStQL1kgryYyIeZEUuUKZ3sEtiqabOChLwD/aImSrL2bMx81sA==
X-Received: by 2002:a02:7f8c:: with SMTP id r134mr4191957jac.95.1614866743543;
        Thu, 04 Mar 2021 06:05:43 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s16sm5136054ioe.44.2021.03.04.06.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 06:05:43 -0800 (PST)
Subject: Re: [PATCH 12/33] io_uring: signal worker thread unshare
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org
References: <20210304002700.374417-1-axboe@kernel.dk>
 <20210304002700.374417-13-axboe@kernel.dk>
 <32ca12f8-0ca0-d247-aefc-01d82d4f47eb@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08f49938-2128-6364-2d51-c0a7df9c8643@kernel.dk>
Date:   Thu, 4 Mar 2021 07:05:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <32ca12f8-0ca0-d247-aefc-01d82d4f47eb@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 5:15 AM, Stefan Metzmacher wrote:
> 
> Hi Jens,
> 
>> If the original task switches credentials or unshares any part of the
>> task state, then we should notify the io_uring workers to they can
>> re-fork as well. For credentials, this actually happens just fine for
>> the io-wq workers, as we grab and pass that down. For SQPOLL, we're
>> stuck with the original credentials, which means that it cannot be used
>> if the task does eg seteuid().
> 
> I fear that this will be very problematic for Samba's use of io_uring.
> 
> We change credentials very often, switching between the impersonated
> users and also root in order to run privileged sections.
> 
> Currently fd-based operations are not affected by the credential
> switches.
> 
> I guess any credential switch means that all pending io_uring requests
> get canceled, correct?
> 
> It also means the usage of IORING_REGISTER_PERSONALITY isn't useful
> any longer, as that requires a credential switch before (and most
> likely after) the io_uring_register() syscall.
> 
> As seteuid(), unshare() and similar syscalls are per thread instead of
> process in the kernel, the io_wq is also per userspace thread and not
> per io_ring_ctx, correct?
> 
> As I read the code any credential change in any userspace thread will
> cause the sq_thread to be stopped and restarted by the next
> io_uring_enter(), which means that the sq_thread may change its main
> credentials randomly overtime, depending on which userspace thread
> calls io_uring_enter() first. As unshare() applies only to the current
> task_struct I'm wondering if we only want to refork the sq_thread if
> the current task is the parent of the sq_thread.
> 
> I'm wondering if we better remove io_uring_unshare() from
> commit_creds() and always handle the creds explicitly as
> req->work.creds. io_init_req() then will req->work.creds from
> ctx->personality_idr or from current->cred. At the same time we'd
> readd ctx->creds = get_current_cred(); in io_uring_setup() and use
> these ctx->creds in the io_sq_thread again in order to make things
> sane again.
> 
> I'm also wondering if all this has an impact on
> IORING_SETUP_ATTACH_WQ, in particular I'm thinking of the case where
> the fd was transfered via SCM_RIGHTS or across fork(), when mm and
> files are not shared between the processes.
> 
> I think the IORING_FEAT_CUR_PERSONALITY section in io_uring_setup.2
> should also talk about what credentials are used in the
> IORING_SETUP_SQPOLL case.
> 
> The IORING_SETUP_SQPOLL section should also be more detailed regarding
> what state is used in particular in combination with
> IORING_SETUP_ATTACH_WQ. Wasn't the idea up to 5.11 that the sq_thread
> would capture the whole state at io_uring_setup()?
> 
> I think we need to maintain the overall behavior exposed to
> userspace...

Totally agree - I'll get to this a bit later, I think we have better
ways of handling it. For now I'll drop this patch so we have time to
rethink it.

-- 
Jens Axboe

