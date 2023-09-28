Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8515A7B1636
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjI1Il2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjI1Il0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:41:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D2F194
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:41:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-52f1ece3a76so3132898a12.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695890482; x=1696495282; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=epK406pCE7G22GM7XcjJWrCLpMcnL+S7vFi36SuHG2w=;
        b=JdnlsHjeM84fyU7LBVo1hrrEENLtQRb1iESeqysPZzyZDxIN8vqMxeEwK2QvI8Wwmf
         9RMwTOsBCxUgrWGCgXIRcuCJCFwXZMnyTjL6SRwHRgRpbvOZd2V29OMyhqq8GMV8410B
         YTGPfI6nmhAu6Fu8id9CZ4mNqJ02Am7GvlVCLLeXiuNWzEgTqRkFmzIdIEwJ+QmWD7fp
         nX0PWB1Z7tslUCj1eri9ioY+s7k8awAfv7Blsr2Hl+rwlobRnwrsNoPIkDRQGbv/dvDR
         vXey8Qo4a48rQq4j2RQjMnUpMrAtIRdtB7XEZiYY4dLN0UOrBsiodt4P/8wU59xc5/W9
         eaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695890482; x=1696495282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=epK406pCE7G22GM7XcjJWrCLpMcnL+S7vFi36SuHG2w=;
        b=M0s7H6A19OLaFwxQPJcIPdIJ1EUV8//y1Wib8kactctmJPdqJeJuiDzj4IU5MRBFxK
         vKwXlmP4gasaWUZSsv/hpymIB2+CWh4kT8/d+ugestcJMTAzcSw9jZGrnam1RBF4j22z
         T0jHw0AExSXr+KgUJV5kijVg2Ee+NyBFT/8WeNi5p1Z9SEZ36YOPZvFO5zQPIQtTdUjL
         2caOmznka6tHc3tSeuOH9tGB0sxC6CoiTURqYWkvHrvv9s4O2GLshMS1ypjTYZrY/ASr
         vaTkhlRTRlsVur0+yOY5PluEowV3p+O11/8/efJ/PIf3ag9dGpUsSOsVaUg42oxWbV7I
         zkxA==
X-Gm-Message-State: AOJu0YwEPcYGOiLJ3WC3mIsboHCl71pEWtNMlFnT9LHhhAXp0in3+Bmb
        ofNRwn4pVlHxhNoRe2K9f+BFQA==
X-Google-Smtp-Source: AGHT+IG2CPVzi/hevvWe+gav8pUakFxzkQgjT8vFSXc9eeUNFsBTMc4KEjzCpLfsY3OQwjCwiD1KfQ==
X-Received: by 2002:a17:906:105d:b0:9ae:5868:c8c9 with SMTP id j29-20020a170906105d00b009ae5868c8c9mr543149ejj.0.1695890482606;
        Thu, 28 Sep 2023 01:41:22 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id y16-20020a1709064b1000b0099b7276235esm10595662eju.93.2023.09.28.01.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 01:41:21 -0700 (PDT)
Message-ID: <29553ecc-3e5e-4c03-8dd0-0ea6fe88c32f@kernel.dk>
Date:   Thu, 28 Sep 2023 02:41:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Xiaobing Li <xiaobing.li@samsung.com>, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
 <CGME20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8@epcas5p2.samsung.com>
 <20230928022228.15770-4-xiaobing.li@samsung.com>
 <20230928080114.GC9829@noisy.programming.kicks-ass.net>
 <ZRU7UzMlx6lpuEHG@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZRU7UzMlx6lpuEHG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/23 2:37 AM, Matthew Wilcox wrote:
> On Thu, Sep 28, 2023 at 10:01:14AM +0200, Peter Zijlstra wrote:
>> Now, I see what you're trying to do, but who actually uses this data?
> 
> I ... don't.  There seems to be the notion that since we're polling, that
> shouldn't count against the runtime of the thread.  But the thread has
> chosen to poll!  It is doing something!  For one thing, it's preventing
> the CPU from entering an idle state.  It seems absolutely fair to
> accuont this poll time to the runtime of the thread.  Clearly i'm
> missing something.

For sure, it should be accounted as CPU time, as it is exactly that. You
could argue that if we needed to preempt this task for something else we
would do that (and the code does check that on every loop), but it's
still using CPU.

I can see maybe wanting to know how much of the total time the thread
spent doing ACTUAL work rather than just polling for new work, but
that's not really something the scheduler should be involved in and
should be purely an io_uring sqpoll stat of some sort if that is truly
interesting for an application.

-- 
Jens Axboe

