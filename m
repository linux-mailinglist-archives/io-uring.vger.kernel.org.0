Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5265367F15D
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 23:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjA0WrQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 17:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjA0WrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 17:47:15 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97E588CEC
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:46:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso6068059pjb.4
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=niyqz/K5CU31qmYp0re26rzgWDGptmZo9A3vBPWvlao=;
        b=AtwTq/IPqa/El0AKmE64VTeedy5oX6BDv31cvPbQhj1UIs4oI9yz9zNYEiAy5uIgp2
         GJOY/YwvYpiODsLIsMZkr4uzr4V8Jv1o6EvFGgqV+GkUWcx8ZHC+eSGsXRPWXpuW0GIR
         9Am64smZ69APe4+wp1m5J1CL+xKUp9T9+C5dp2LzL9AXCdh79o+hchWWjVyotnTpcb/g
         GHc+biUfCud1Vm8fEAg9DBpO56qa348Lu00zODWeQOSpi8G9S6+qaFvgltNpY7F/ebyX
         3fTekHRWJbb4XqrRGOdYx7W/j7IwpPNVPD0hoU3WAzDfAuCh/cQS/LmzdtihCH8H16+X
         0nGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=niyqz/K5CU31qmYp0re26rzgWDGptmZo9A3vBPWvlao=;
        b=rjHwnC42EtIpPXy60i29OK5WUPE3uyqUVUUularaGvXPGK69/jdZHotZELMQzx9/Bn
         uIz5QGu9N64LRrScS/ewnBw1Ylq4M/4f/IMWCdLvzzXrEAtvRDz/spGxjo7XH42JVxGm
         PONIWc3H6NGRiVTnujtEuUZYvF82nn3sjFnkBbYWRsEBVrnLpXPjM2Tfz+Cu29MLqmaw
         8LRIkzshfo1fth8EKe/I5dNMgtoU4Y0a+vTMV0VJE+gjZFPhAn0r9aGIg19x6VbiZbgd
         UoIjp6uT5ogBaT/9zCxoTs5lv/dd12KsrQoz3Yt/K3zbWU3H6hCGdPzPJDIZcc7IQnEF
         JqXw==
X-Gm-Message-State: AFqh2krElWGCFRkc8HcSfyvcUPYIxu05WiOunp6f+yWBFzsRdgT0nZP4
        bb3QNZdkNmuPVY2PpNLL56b1xw==
X-Google-Smtp-Source: AMrXdXu35TH37NebANPn49PtseEAfXGCyWnrluC2tGjrOzbesGJXDQn9RBkDExFcV+imMwWeZukDyw==
X-Received: by 2002:a05:6a20:2d1f:b0:b9:478e:545b with SMTP id g31-20020a056a202d1f00b000b9478e545bmr9035600pzl.6.1674859615088;
        Fri, 27 Jan 2023 14:46:55 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h70-20020a628349000000b00574e84ed847sm1264205pfe.24.2023.01.27.14.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 14:46:54 -0800 (PST)
Message-ID: <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
Date:   Fri, 27 Jan 2023 15:46:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
 <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk>
 <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 3:38 PM, Paul Moore wrote:
> On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/27/23 12:42 PM, Paul Moore wrote:
>>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 1/27/23 10:23 AM, Richard Guy Briggs wrote:
>>>>> A couple of updates to the iouring ops audit bypass selections suggested in
>>>>> consultation with Steve Grubb.
>>>>>
>>>>> Richard Guy Briggs (2):
>>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
>>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
>>>>>
>>>>>  io_uring/opdef.c | 4 +++-
>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> Look fine to me - we should probably add stable to both of them, just
>>>> to keep things consistent across releases. I can queue them up for 6.3.
>>>
>>> Please hold off until I've had a chance to look them over ...
>>
>> I haven't taken anything yet, for things like this I always let it
>> simmer until people have had a chance to do so.
> 
> Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
> of different behaviors across subsystems and wanted to make sure we
> were on the same page.

Sounds fair. BTW, can we stop CC'ing closed lists on patch
submissions? Getting these:

Your message to Linux-audit awaits moderator approval

on every reply is really annoying.

-- 
Jens Axboe


