Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD28750BAE
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjGLPDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 11:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbjGLPC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 11:02:57 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A881BE3
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 08:02:54 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-780c89d1998so64418539f.1
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689174174; x=1689778974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TLQm5bobYRpvRd6WmBwN9aG08JplzkH4U4TwT6lX9AA=;
        b=EkT4ReaRuKGlEkv2BvV/PQcOWBlBRYoID8Jgux9TIRlY0ZdGLEmNA3+mAdZNEkD/r6
         bD8+IRyRk6623ZjBwTpDxIwG6+0yRoCFap6pYBSjNHZ/baJGi2LQ16r+18+xDxi9Ljve
         6o1UXRxoe/mgm0ESbrVQdDgkXl3NjRnjUtZIlnO6klraBP0YPwgtWP7eP1HidIchDXEB
         nB85A+CjnBZuelW5n7W02UPgKXBa8G/4gwaJ/jQPdwUgiOhkwV7FN+jLu/0ARV/gc+6H
         P8rhufl3S1CqM9QMjpbZ1HApJnxemUn97vFlYuj8OPq2FaFVwxD2mMxPA5Kcf1QhM76o
         UnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689174174; x=1689778974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLQm5bobYRpvRd6WmBwN9aG08JplzkH4U4TwT6lX9AA=;
        b=Gr+e+JIGV1N85/PNnG0yqx046WALVmDfnHEdxy9L3DDs3ZDpInaL7jx9NJOl4ocj8T
         86Tq9ElTKhXmls4FvQv/EKh5cP5vGVZOC4DyPfePZO6DsKpdt619MpvwxQhJ/U0hqhHR
         GGgZCsl+inevnXc5iZV3n9RLtcoctxCaUM/JnCX6kH4I9yrYEySC6lS3PK0AOXlcfyA4
         TGHkpMk1VDrhzcxRG+neqzkKCUlcHOCPjgnYqdNK3k+Eb8YyZSGiuyLEug8syzb7lDLO
         qtfCbRdvS/GaYTmz5t3FmmvvKS5ttNOKyHTnLZNEwFK0BG4bV97g2MKEJk+PWj4HYmqu
         qijw==
X-Gm-Message-State: ABy/qLbXzCFXsJqyD1N7Ea2lVd7+ju0rzHU8a6evgE37rX3xKOz9vBBN
        Lm9D33ST2pfxBsOhN9X4IBO9IyK4Qdl+SrCKkBw=
X-Google-Smtp-Source: APBJJlFoiUJhUSnTet5H0/b2xbd/nDOd7gz6e1zOW/UFPsD8hfAydY/3/iufmlmQ1GqL5+pdCKtZjg==
X-Received: by 2002:a05:6602:1493:b0:783:6e76:6bc7 with SMTP id a19-20020a056602149300b007836e766bc7mr24743458iow.2.1689174174097;
        Wed, 12 Jul 2023 08:02:54 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a6b660d000000b00786fe5039b8sm1361190ioc.46.2023.07.12.08.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 08:02:53 -0700 (PDT)
Message-ID: <3e2ba7d7-0431-7558-2ece-89ce266f7792@kernel.dk>
Date:   Wed, 12 Jul 2023 09:02:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/7] futex: factor out the futex wake handling
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-3-axboe@kernel.dk>
 <20230712085803.GD3100107@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230712085803.GD3100107@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/23 2:58?AM, Peter Zijlstra wrote:
> On Tue, Jul 11, 2023 at 06:47:00PM -0600, Jens Axboe wrote:
>> In preparation for having another waker that isn't futex_wake_mark(),
>> add a wake handler in futex_q. No extra data is associated with the
>> handler outside of struct futex_q itself. futex_wake_mark() is defined as
>> the standard wakeup helper, now set through futex_q_init like other
>> defaults.
> 
> Urgh... so if I understand things right, you're going to replace this
> with a custom wake function that does *NOT* put the task on the wake_q.
> 
> The wake_q will thus be empty and the task does not get woken up. I'm
> presuming someone gets a notification instead somewhere somehow.

Right. The custom wake function is responsible for waking the task, if
that is what needs to happen. On the io_uring side, the callback would
queue work for the original task to post a completion event, which would
then also wake it up obviously.

> I might've been nice to mention some of this somewhere ...

I'll expand the commit message a bit, it is a bit light.

-- 
Jens Axboe

