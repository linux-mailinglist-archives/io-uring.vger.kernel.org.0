Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF37D9BF2
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345911AbjJ0OqM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Oct 2023 10:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345991AbjJ0OqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Oct 2023 10:46:09 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E7CC4
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 07:46:03 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7a9447c828aso826939f.1
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 07:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698417963; x=1699022763; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w3WKPOInrEdvQkvpwxwv5Fja/uHzd3UARsSrjsxhvxA=;
        b=fnSQgawiwrFLxVRv9Qf/SuSoivMqsIsFZLGIPLxGVjKXUdjzKWsGUENpuXOsYw1xhw
         ODnMbfX1PJ8cA2Dc9fK6vaU3u0cdluF3LNdIIdeF4MPeukFvQv/OoHb3+5zY2HhVuYyk
         5lNEioCKlWkyrhXzD1i3W8nWzc3tIuzls1rJBXAyIvsLjw/zGhB/kzFlxYHkbYcu/Cbx
         y1+XhwA/tDr4EbSWPBIzGUgH+R27GvB56qgNDCt4MTVsQTvH+niGRZttxRUvcillztgg
         3qb03ePf06aiZ60+OtikUGJ9qciS/hPq6djq5V34JdHn3B54B/0t/98RrPCZg3jCXGs+
         bKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698417963; x=1699022763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w3WKPOInrEdvQkvpwxwv5Fja/uHzd3UARsSrjsxhvxA=;
        b=aQw0atomFcCpSn5JEnpDBCPjEwMt1+/UFi41Uv3mF8xB4rtKxYjtVsPyr/2XIVyTy6
         dBqIafiTgevLNOUFDLmtoJzDn/U5n3cCmkL2iLGqDRR9wPzp3hNszLPpSuHXJ/OgAfxI
         vNeH+ePkfLa4AhL5Nk2tsA7jgXRWjatwWceATOLvNjwKNRGIyJvi3zgYqqkERwOvj7Ln
         0unGHHBf8p7eljnpUs3bFGtuBm6ekNBkHj2CtbzcHL7Ay51PUTC2m4yuzTXQkGRqupu0
         LNgmMWv1w8Cw8DfnfqbDEsOkxKn4ZbgUi000PFrvEYiIDD/ZZ9lD4kf8Ps4tUtvWIpl1
         FfmA==
X-Gm-Message-State: AOJu0YzLeWcytIjpEpguqBMBtuhWqYcjp9c3p0TF4Cpyc3EMuSOuMTUc
        TDKe3XXuf7AR7NAIUkh1/FOKug==
X-Google-Smtp-Source: AGHT+IHmCzlqOlY3EomSO6T6RBCPoJ56NrwN0Ratf4Xmk5f2jtUUYWADjfWiLvNvMD7NWy9RJpRVLw==
X-Received: by 2002:a6b:500a:0:b0:792:6068:dcc8 with SMTP id e10-20020a6b500a000000b007926068dcc8mr3504618iob.2.1698417962713;
        Fri, 27 Oct 2023 07:46:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h5-20020a0566380f0500b00452a3ffe215sm439470jas.87.2023.10.27.07.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 07:46:01 -0700 (PDT)
Message-ID: <84a42959-e15f-4128-ae2f-df9650879556@kernel.dk>
Date:   Fri, 27 Oct 2023 08:46:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: task hung in ext4_fallocate #2
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Andres Freund <andres@anarazel.de>,
        Dave Chinner <david@fromorbit.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        =?UTF-8?Q?Ricardo_Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        gustavo.padovan@collabora.com, zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
 <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
 <20231025153135.kfnldzle3rglmfvp@awork3.anarazel.de>
 <b5578447-81f6-4207-b83d-812da7c981a5@kernel.dk>
 <20231025195539.GA2897448@mit.edu>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231025195539.GA2897448@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/23 1:55 PM, Theodore Ts'o wrote:
> On Wed, Oct 25, 2023 at 09:36:01AM -0600, Jens Axboe wrote:
>>
>> FWIW, I wrote a small test case which does seem to trigger it very fast,
>> as expected:
> 
> Great!  I was about to ask if we had an easy reproducer.  Any chance
> you can package this up as an test in xfstests?  Or would you like
> some help with that?

I think it's good to convert to a test case as-is, would just need to
loop X iterations or something rather than go forever. If you want to
run with it, please do!

-- 
Jens Axboe

