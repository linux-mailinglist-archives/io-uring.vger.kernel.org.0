Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2A9557A24
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 14:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiFWMRY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 08:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiFWMRW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 08:17:22 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C339134BB7
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 05:17:21 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i10so23925340wrc.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 05:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=wf6765jcJvwg5an7EmkMd0N1xd6oylTjMskx24tMnTg=;
        b=VAhVOvqL5RaPvHo3Gk5dvDfJHIAijZJ0+Q8fCTQ97LjOmcLjpcCs7i1vFzwJVDm9ZU
         ExhPGGJGvgmFr6B3fsUtcX0TIBipB6vYyt8+z7uAjRL8+OBLcOeWv1BwGs+Ag044zoYC
         fhpvWutMpqDuW+CCYJeqvIXbFFM85JdD15g51ePz5s8kfTChzVcVlvZA4AuHLw+ux5K1
         WkDaG7uJgzMj1PV3pRqA7H+dO80YJdarFpruu6+BXsZRPQRG1Jf8X8m+THiTWfejgSX+
         IRltFbiFlsxFw7U1LY1jzyqnlgCloPpOahX/GYjVuUZua9MeOnXE3JAuchnPJjl1FX1X
         XHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wf6765jcJvwg5an7EmkMd0N1xd6oylTjMskx24tMnTg=;
        b=Ub7qGMSvKqQsxvWVK5XP0H70jKIeqXHsTvMxiIJZjhVEAoe8MDBFhcW8hcLdLatQ4Q
         +93lH0itUt99+Ea7k5nGQf+Ml1Mqvli26j5As896EIyDMPJv4qnO0Yf/4xPIZrZVNjCP
         NQOGMwQwE5BJw57sUhk75GGpiZiYMwmxTNgtc4/LmbGFSuz3dS6/eHHOgLjsg7jvT1re
         L609PUNZYPLvd9mX0gfVBWIirT9/KO0FXNCW4ZIT54tZsEcTiIr4/zVKTackdyNmlr0l
         uqMGrTo9PbMS3AsGkQBViMFqenMmNXoGIUyouSY4gELeubG4FDwHu0nDBGq+JDpvjuzn
         Jjhw==
X-Gm-Message-State: AJIora9x6CB9RSBVpkaoH3lOqvF+0JZ6APow8mqu/FKkiE96eAy3sX+g
        tDer1S+3sF5gjiD1TAs632mU0bHlVhpmn3VS
X-Google-Smtp-Source: AGRyM1vm+YPrJnXBTrNn1mUvM7CPsALnxpQ/sCYgve9pJSONyOuvnIoCr58HzeDhtkw0Jpd7jaM2Wg==
X-Received: by 2002:a5d:558c:0:b0:21b:92c8:bc8b with SMTP id i12-20020a5d558c000000b0021b92c8bc8bmr7817421wrv.634.1655986640291;
        Thu, 23 Jun 2022 05:17:20 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m12-20020adfe0cc000000b0021ba645581bsm3148593wri.81.2022.06.23.05.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 05:17:19 -0700 (PDT)
Message-ID: <db6cc4f7-a1a4-1ea4-6f44-d8decef63fc7@gmail.com>
Date:   Thu, 23 Jun 2022 13:16:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 5/6] io_uring: refactor poll arm error handling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655976119.git.asml.silence@gmail.com>
 <6dd4786bca9a3d1609f85865936349cac08ac8e0.1655976119.git.asml.silence@gmail.com>
 <814e42a9-82ce-b845-8b7e-d8cedefe9c39@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <814e42a9-82ce-b845-8b7e-d8cedefe9c39@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/22 13:09, Jens Axboe wrote:
> On 6/23/22 3:34 AM, Pavel Begunkov wrote:
>> __io_arm_poll_handler() errors parsing is a horror, in case it failed it
>> returns 0 and the caller is expected to look at ipt.error, which already
>> led us to a number of problems before.
>>
>> When it returns a valid mask, leave it as it's not, i.e. return 1 and
>> store the mask in ipt.result_mask. In case of a failure that can be
>> handled inline return an error code (negative value), and return 0 if
>> __io_arm_poll_handler() took ownership of the request and will complete
>> it.
> 
> Haven't looked at it yet, but this causes a consistent failure of one of
> the poll based test cases:
> 
> axboe@m1pro-kvm ~/g/liburing (master)> test/poll-v-poll.t
> do_fd_test: res 2a/1 differ
> fd test IN failed

Ok, worked fine on the previous 5.20 rebase for me. Could've screwed
while rebasing today as I couldn't test because io_uring/5.20 is failing.
Let me respin once it's fixed.

-- 
Pavel Begunkov
