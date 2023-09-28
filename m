Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FAF7B15F3
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 10:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjI1IX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 04:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjI1IX2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 04:23:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DBFB7
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:23:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-52f1ece3a76so3126734a12.0
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 01:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695889404; x=1696494204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XjyoWJ1tpx/uEpVSCmTksL+kF4CTyeGA4CWSET/lKz0=;
        b=HWmtgcdSxPUB9k4SIG12WzfmaNU8HpGSTDY3s+X0Q1j70bpT4Z4JxDiDkSubkPUiYJ
         oCL+NF6PG0RDW4JadTdiw6BquWCWa6zYpzbr1pW/wBEXFcJgaKGfvVKaLUleo0fou88T
         tBoj57jIvFMH+1JcRFB/1ifT0UOjxsS2qu+DI0qNJjj/06M81ydWRdb20DC9/0u0fnC7
         YlCBnE3No5SdTU8ip9F34TePtGbMLlXsqpzkB9NnPY4KDkn7YtEXmS2j396VPLSlSSWs
         KHP3BGFKHPzXf+hWoRZfl4wmuqbZt0uZxH3qVla/dKRrioQCLb/owysuUtg4kq46oe8f
         Yw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695889404; x=1696494204;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XjyoWJ1tpx/uEpVSCmTksL+kF4CTyeGA4CWSET/lKz0=;
        b=n6leaQknT+FTsHE47NS5ad5coXs4zCHzVut7W+Rb9lbDj4wFJNAbqxjs1nU0UQC0SW
         546lsqZHCDjvkMeZplEuX0wik1JzqVUgn10WyG4dbQtQ0Mm19P5hEciWXTLCuU8tWppd
         GIhPr0+2EccRCidgW406AiO4nLjGQRBOFSBQOfOj076TPagEOKaeCbKW6hQ+2Hxtda/Q
         jNIpFNRbYkczii5DkSacb0HlxBDVdvTmprDZjVLzZK/whhZroX3YTzdS9iIpxmDCvYO1
         6FMiQ7zHtW6xYKPOc852+Esqx01swUdRaJSHXiB4qgdRCi4zCNucA482PxpGYg00+ysm
         +Kxg==
X-Gm-Message-State: AOJu0Yz8fZn4ZE70wtX0gA5FdWTji6RtcuKcDdDFPqv3jfBvhEU4+Tsu
        JnyW4FfZU04OLaLY6A+9iqcm8w==
X-Google-Smtp-Source: AGHT+IGkSxoPxgcGj0zywDnIp2o/7chIx7WOK8WG2TawfeZFzulDbE/nRCSrGAnc9oYFDg3kZAzQuA==
X-Received: by 2002:a05:6402:2808:b0:523:f69:9a0d with SMTP id h8-20020a056402280800b005230f699a0dmr583570ede.4.1695889404485;
        Thu, 28 Sep 2023 01:23:24 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id p17-20020aa7d311000000b00532bec5f768sm9345793edq.95.2023.09.28.01.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 01:23:23 -0700 (PDT)
Message-ID: <84dd8b92-0b1a-4632-8e1f-33e4724e503a@kernel.dk>
Date:   Thu, 28 Sep 2023 02:23:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq
 threads.
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Xiaobing Li <xiaobing.li@samsung.com>
Cc:     mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, kun.dou@samsung.com,
        peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com
References: <20230928022228.15770-1-xiaobing.li@samsung.com>
 <CGME20230928023015epcas5p273b3eaebf3759790c278b03c7f0341c8@epcas5p2.samsung.com>
 <20230928022228.15770-4-xiaobing.li@samsung.com>
 <20230928080114.GC9829@noisy.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230928080114.GC9829@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/23 2:01 AM, Peter Zijlstra wrote:
> All of this is quite insane, but the above is actually broken. You're
> using wall-time to measure runtime of a preemptible thread.

Would have to agree with that... wall-time specifics aside, this whole
thing seems to attempt to solve an issue quite the wrong way around.

> Now, I see what you're trying to do, but who actually uses this data?

This is the important question - and if you need this data, then why not
just account it in sqpoll itself and have some way to export it? Let's
please not implicate the core kernel bits for that.

-- 
Jens Axboe

