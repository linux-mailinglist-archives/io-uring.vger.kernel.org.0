Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0553F3F5E
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhHVMrY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 08:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhHVMrX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 08:47:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1BEC061575
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:46:42 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g138so8772485wmg.4
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nkioH97NTs8VdlEwytwOaMAfH27gW3O5pGUJiyHE2mk=;
        b=NT5gO4vFy19+J6uoBEr3ADvHFsLZgsXePz5ko7FWSouAb4zPVSEipUC9dZSEw/ua/Z
         rd9csbQ0dlhgZsXy7iavVlCWiGcyhHKJ0T4jqutkANPisa3T+2EXr/marmUgnuFA1UW/
         eNOB+E/HRI1B9do7obKdhEekm123o9LBB7BgYZYBoiJOoyFiJ+VE21XBA00P0lm9i+4W
         jw30GCLsuu+q6FF1JVww3cnJYaZxW+lg+bDE4GfPWB2TtG18RiFekbS8ojaxGDS0h3ek
         jzqMvrATIGE5F+vKz4bzz7PjE6m7YL3dC8EwQnTt8yHxjZekM4FTYp3j0xNolg9C3SSs
         j4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nkioH97NTs8VdlEwytwOaMAfH27gW3O5pGUJiyHE2mk=;
        b=eBTgZfEzwURs5SHQZC3XMy6cTcPdBGbG8+LPlbOOVmii09LrfE/950ZWnTbTomcfrK
         Nu5lJv2KK/wZedUnpIAWrnbelOIz/LbqBNMCMJivSLyh25sZyYO03daI3jCjXc5nACZq
         +hTwH8rMRoijfqm00/tUMhORq/iRSqwjXSgXf1+zfGvuIxV6fRHtrz4T+2BI+/WnMToy
         OT9Kd0oMmLA5jZR1Q7lR3EKrW1lNCI7fzLELni260wsgmsRxq2o9nXM1ZOh4fTopZTST
         KwGOkfzhweCqZOfKi93zxzaUnYEZn6TBS3EkWYQxpO8BxxwlS4+EaLY34nz/hAmKjIEy
         tuow==
X-Gm-Message-State: AOAM531d06m5d9VpTP3b01zJRRwby/pSgMHQ0QsJtkReef4LBkJkR6mn
        Jju2OP4wOEqQw1vqnaTqOZ0a3iswoJM=
X-Google-Smtp-Source: ABdhPJy3UhxKoZVJfIT4WzZUlQh9AyuKP7ROjqRbxBYfvvGYWXhJLmrGYayfTRo8AZzTne+aGUeLww==
X-Received: by 2002:a05:600c:2f0f:: with SMTP id r15mr12190088wmn.29.1629636401052;
        Sun, 22 Aug 2021 05:46:41 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id v13sm5165159wrf.55.2021.08.22.05.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 05:46:40 -0700 (PDT)
Subject: Re: [PATCH liburing] tests; skip non-root sendmsg_fs_cve
To:     Ammar Faizi <ammarfaizi2@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d2fee3ad7d2516d2a154ff380b067ae58a694e61.1629633956.git.asml.silence@gmail.com>
 <CAFBCWQKZv=mNPYqx4FQDgNjjH=efaXO+gQ-=U_=rbJCbFJh6Dw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b13f39b5-3629-ae09-74ee-64e48bd68472@gmail.com>
Date:   Sun, 22 Aug 2021 13:46:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAFBCWQKZv=mNPYqx4FQDgNjjH=efaXO+gQ-=U_=rbJCbFJh6Dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/22/21 1:43 PM, Ammar Faizi wrote:
> On Sun, Aug 22, 2021 at 7:08 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> -               if (chroot(tmpdir)) {
>> +               r = chroot(tmpdir);
>> +               if (r) {
>> +                       if (r == -EPERM) {
>> +                               fprintf(stderr, "chroot not allowed, skip\n");
>> +                               return 0;
>> +                       }
> 
> Hey, it's the userspace API.
> 
> chroot, on success, zero is returned. On error, -1 is returned, and errno is
> set appropriately.

That was extremely silly indeed, thanks Ammar.

Curiously, it didn't fail because EPERM == 1

> Did you mean if (errno == EPERM)?
> Should #include <errno.h> as well.
> Sorry for the duplicate, forgot to switch to plain text.
> ---
> Ammar Faizi
> 

-- 
Pavel Begunkov
