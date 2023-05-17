Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413167069FD
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 15:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjEQNfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 09:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjEQNfV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 09:35:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4779F7AA2;
        Wed, 17 May 2023 06:34:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so1159922a12.1;
        Wed, 17 May 2023 06:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684330489; x=1686922489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nrtmfxt4yfxLY2UVAqI6rteBQZPnotIboHiGgYaz1iU=;
        b=dsLRMtC7bgsZ9K1/TGjOhMOvRp4l/usk0IYXRgra68RoVwo4q6Kas1pEZQBYoHuxYS
         1tJ+GUSs8vXwv6xvFD4JzT6hMQVKmE92CoWIeLsvuAJaL4D/Elvz7gKpy6d/jkVuhtGG
         LRnteuAfth65jcDVcCwxJkGAs27CxmI0TPJbpazDdkz5Y8rn2JrDttpPucpZATAxj/92
         rccfRGcgA5+L/RQB3UZ6aVNJ/xo0vjoyZ6rOZ+gKpPpT620vv62HaFpQQiNbOBkzy9aP
         YBUGOzPuV01tLvrco0NhNhiLjO45RyMBLU4iqkmFD0Cbb4UU0BnVOXMkSIEoFYbt8imc
         NeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684330489; x=1686922489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrtmfxt4yfxLY2UVAqI6rteBQZPnotIboHiGgYaz1iU=;
        b=U6KP5drT+/AA7wFP7SzAL932rATrgk1+ZPyZxQ1tqa28gFCO/7XPIgl+q8wxMjVC9o
         rZ3Dp1sPwQ6s/rwVOJU+IRH0MFHESHTUaGuBT9BN0nzXOzx7+dPJsEUipd5z4ckO5+Ls
         cg5PEneZnTAxZMs6I6zckSKTNFHduRURRKd5XUBVxOXQOf/1OQM7w+Yty6FrYI5e68dj
         MiL2S64o7kYzXYBnUITAsvmnitF5ASK4B9WBgt+/wdt0jCcIjtiLFn+Ss3ooNYYyo7aQ
         Qa19aZA9migRcEs3jQJ50kKFEqcXGSZC77B1QMBefea6kPuBIgN2w81E9Il1HFYElK2h
         GhsA==
X-Gm-Message-State: AC+VfDzD1iA6o4Y886I4HTQ+9oRynX1JfxEZUj22SKmHm4rStB9w6K2K
        /SSoCRV1+z/aIck87iFEUjI=
X-Google-Smtp-Source: ACHHUZ7R/6MPttfoUfKR851xnOzMlb10IKMLwWJUo9hUtBqu6sCpegg1ztBOfMzusmeC76ySqq66Wg==
X-Received: by 2002:a17:907:a412:b0:96a:863c:46a9 with SMTP id sg18-20020a170907a41200b0096a863c46a9mr19383357ejc.71.1684330488633;
        Wed, 17 May 2023 06:34:48 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:46a1])
        by smtp.gmail.com with ESMTPSA id jz24-20020a17090775f800b0096347ef816dsm12405450ejc.64.2023.05.17.06.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 06:34:48 -0700 (PDT)
Message-ID: <61787b53-3c16-8cdb-eaad-6c724315435b@gmail.com>
Date:   Wed, 17 May 2023 14:30:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        sagi@grimberg.me, joshi.k@samsung.com
References: <cover.1684154817.git.asml.silence@gmail.com>
 <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com>
 <20230517072314.GC27026@lst.de>
 <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
 <20230517123921.GA19835@lst.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230517123921.GA19835@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/23 13:39, Christoph Hellwig wrote:
> On Wed, May 17, 2023 at 01:32:53PM +0100, Pavel Begunkov wrote:
>> 1) ublk does secondary batching and so may produce multiple cqes,
>> that's not supported. I believe Ming sent patches removing it,
>> but I'd rather not deal with conflicts for now.
>>
>> 2) Some users may have dependencies b/w requests, i.e. a request
>> will only complete when another request's task_work is executed.
>>
>> 3) There might be use cases when you don't wont it to be delayed,
>> IO retries would be a good example. I wouldn't also use it for
>> control paths like ublk_ctrl_uring_cmd.
> 
> You speak a lot of some users and some cases when the only users
> are ublk and nvme, both of which would obviously benefit.
> 
> If you don't want conflicts wait for Ming to finish his work
> and then we can do this cleanly and without leaving dead code
> around.

Aside that you decided to ignore the third point, that's a
generic interface, not nvme specific, there are patches for
net cmds, someone even tried to use it for drm. How do you
think new users are supposed to appear if the only helper
doing the job can hang the userspace for their use case?
Well, then maybe it'll remain nvme/ublk specific with such
an approach.

It is clean, and it's not dead code, and we should not
remove the simpler and more straightforward helper.

-- 
Pavel Begunkov
