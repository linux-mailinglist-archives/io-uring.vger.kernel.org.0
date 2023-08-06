Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7520977161A
	for <lists+io-uring@lfdr.de>; Sun,  6 Aug 2023 18:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjHFQlT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Aug 2023 12:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjHFQlR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Aug 2023 12:41:17 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2930A10CC
        for <io-uring@vger.kernel.org>; Sun,  6 Aug 2023 09:41:14 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so289115a12.0
        for <io-uring@vger.kernel.org>; Sun, 06 Aug 2023 09:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691340073; x=1691944873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vnl3tBw3YI1niJ5TydLVcO6YxwztzFA4jbV40tVanFY=;
        b=hh1zmX7NwxNZeOk99/85QYp6A6gNzoRJA6BoOUqiuIv51NGU0009x+CnUCHjWA5oBL
         IyAZskuQyWj1tLZLI955AnGzmdfpwrGEtnC4kMtaav798hsW95tOJNi14FulJ5oOooV+
         q5Z32wFlGQkP7jqNkwE4bGQ+WqmqkttGYhlAlabG9hULO7nBNK3nB9GjdUyHBqqz/hP7
         LadFfeyKS4pDY4NYYYZGqVL9U8+Wbbx8uznKViieVNt7ayyFngQNMjurZVn5vr0L81cX
         Y1amK1L7Uap0yJV54tr9qWQ6WRH4o5uYFhWar7o145uUpWnVhzWoSSd1Sx4Ni5palK8Y
         2GYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691340073; x=1691944873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vnl3tBw3YI1niJ5TydLVcO6YxwztzFA4jbV40tVanFY=;
        b=CnyNOGLTbTQn4wAK/nVYeJTJqqS165wQI/EKhS9Ma73/8ukv2cBkVmsL4E9vyJtDiM
         qvyfOiMp3tEFsyKLesRN1r3jDn8keqqa15dR9cFmXhJIMuhcebYrpUSF1Od1HF3GZ70q
         4GuCm1jA7Idsnja7QJz9zvpVhqoGixylqBwJE7fO1n3TXrOFGMaarTXt5PNvXtnCN2A5
         VrBM5ia6ZL+pbTWOxtIALEadr3gk3AJp5gLXXIKDdgaMlWwqOlqy2XlfODx0TyoA9Hvs
         LEcLv4JhhAdUXVKFljS86SDfJL2bHOt8Z5CMpXDEBJF/+jamzReR7sEjTMDk3R6sX17o
         8bRg==
X-Gm-Message-State: ABy/qLagUv364j2eQJyDnlkH1ifcv3ulblmlZ/d2HByXYQ/HY04Pkk2u
        mr5EW2WN9oasyQKVkg6TpnuF+A==
X-Google-Smtp-Source: APBJJlHaJrhRit6lB72vyAi4XrYgFZt7u5QYVx4Pdd5tsa9Hkz7FagEU0t5nMFfGozR08NMf60pZrw==
X-Received: by 2002:a17:90a:faf:b0:268:abc:83d5 with SMTP id 44-20020a17090a0faf00b002680abc83d5mr21967439pjz.4.1691340073398;
        Sun, 06 Aug 2023 09:41:13 -0700 (PDT)
Received: from [172.20.1.218] (071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id bf22-20020a17090b0b1600b00263987a50fcsm7198103pjb.22.2023.08.06.09.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Aug 2023 09:41:12 -0700 (PDT)
Message-ID: <3fab7978-3dca-a6a8-a908-e9f7d8100dda@kernel.dk>
Date:   Sun, 6 Aug 2023 10:41:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v2 2/2] io_uring: correct check for O_TMPFILE
Content-Language: en-US
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20230806-resolve_cached-o_tmpfile-v2-0-058bff24fb16@cyphar.com>
 <20230806-resolve_cached-o_tmpfile-v2-2-058bff24fb16@cyphar.com>
 <41b5f092-5422-e461-b9bf-3a5a04c0b9e2@kernel.dk>
 <20230806.063800-dusky.orc.woody.spectrum-98W6qtUkFLgk@cyphar.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230806.063800-dusky.orc.woody.spectrum-98W6qtUkFLgk@cyphar.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/23 12:42?AM, Aleksa Sarai wrote:
> On 2023-08-05, Jens Axboe <axboe@kernel.dk> wrote:
>> On 8/5/23 4:48?PM, Aleksa Sarai wrote:
>>> O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
>>> check for whether RESOLVE_CACHED can be used would incorrectly think
>>> that O_DIRECTORY could not be used with RESOLVE_CACHED.
>>>
>>> Cc: stable@vger.kernel.org # v5.12+
>>> Fixes: 3a81fd02045c ("io_uring: enable LOOKUP_CACHED path resolution for filename lookups")
>>> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
>>> ---
>>>  io_uring/openclose.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
>>> index 10ca57f5bd24..a029c230119f 100644
>>> --- a/io_uring/openclose.c
>>> +++ b/io_uring/openclose.c
>>> @@ -35,9 +35,9 @@ static bool io_openat_force_async(struct io_open *open)
>>>  {
>>>  	/*
>>>  	 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
>>> -	 * it'll always -EAGAIN
>>> +	 * it'll always -EAGAIN.
>>
>> Please don't make this change, it just detracts from the actual change.
>> And if we are making changes in there, why not change O_TMPFILE as well
>> since this is what the change is about?
> 
> Userspace can't pass just __O_TMPFILE, so to me "__O_TMPFILE open"
> sounds strange. The intention is to detect open(O_TMPFILE), it just so
> happens that the correct check is __O_TMPFILE.

Right, but it's confusing now as the comment refers to O_TMPFILE but
__O_TMPFILE is being used. I'd include a comment in there on why it's
__O_TMPFILE and not O_TMPFILE, that's the interesting bit. As it stands,
you'd read the comment and look at the code and need to figure that on
your own. Hence it deserves a comment.

-- 
Jens Axboe

