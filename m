Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAF044D8C3
	for <lists+io-uring@lfdr.de>; Thu, 11 Nov 2021 15:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhKKPBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Nov 2021 10:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhKKPBG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Nov 2021 10:01:06 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E81C061203
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 06:58:17 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id m9so7329709iop.0
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 06:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xH4G5EWmEO3Cm+J1KziqMfm5OFh7gOaSK4pkTpUqJBc=;
        b=lCIJm2lhqKedI/BXtw1jG3ffeq/SJpMhHnEJ+j5h569Ghs8Q4b3CLLA4DaaeDo0FqE
         Ql/19nRV6VOLPWDAnM/AsHp2CbupkkHgyVQYGWBeqe6q9K6QFs4PTtp+sHCBR7w1Idjc
         vjF4cRjh6FuzwLoLSUhojsjSbHhNDCt6vMQa4NSKkLM7yOwscVQNz8wq5fm1BbSrWjSK
         v6TZpBG1wCYzSO0kZWAUsQlk6AlGKTA4+Bz5uoqLVFYCyFnnseJsWDg0yYitaZ6Gt3M9
         5VzEJwH0OM6eNPuaDXXjn9J+Oo6ZUCm9WivCvDrJlYexRRQzwHqudzvpQY1T8Hm55oIF
         IHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xH4G5EWmEO3Cm+J1KziqMfm5OFh7gOaSK4pkTpUqJBc=;
        b=xTT65MBa6vJAMWz7v3h39VjA8Be8qbJk0+7rIRBtWolzCF0Q0qPiQekrSsIwuyAJsV
         HUbWrsZyXCz12HzJYilIKXXVtIse1PIzx3EodCqn7GEbKU2e7wapULmZTAHSm9aFzlZV
         OCYc17Tw3OzLycK2jY8tGhHP81sZ1l3q3vSc1gDIlNf4LOKfw1y5x2+dUezxMjmatWjH
         P1qJF87qFGXovJhoqd3JzmQO7kZlk0l1SNS3MyWyKbfAgbp+GFDKMGc3JgJbHz0kb8Hr
         O3Qhvkf1ZJQ+m+eDMXk3tDfxXgjpAzVoPTl0hJyX2RUChx8HmrqE1jEYZq0oUrRQcQxn
         JHHw==
X-Gm-Message-State: AOAM532XPpDqmoVUH8zIJ3B6nlruH3mGvGFS5Bb8ydTLJu3B+bNpLlbe
        zuGOXH3PTyxCYsuuVtSMuWvkR3ZRyRBJdILW
X-Google-Smtp-Source: ABdhPJywJeyb/MW01D8GCBuzZTzHlqG3pVdHjDzUgDKx/23VQ3L2ju099dBQ+fUSgQ1FF8+3Qf9ntw==
X-Received: by 2002:a02:7105:: with SMTP id n5mr5789512jac.64.1636642697129;
        Thu, 11 Nov 2021 06:58:17 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c3sm2040663ili.33.2021.11.11.06.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 06:58:16 -0800 (PST)
Subject: Re: uring regression - lost write request
From:   Jens Axboe <axboe@kernel.dk>
To:     Daniel Black <daniel@mariadb.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
 <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
 <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
Message-ID: <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
Date:   Thu, 11 Nov 2021 07:58:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/21 7:30 AM, Jens Axboe wrote:
> On 11/10/21 11:52 PM, Daniel Black wrote:
>>> Would it be possible to turn this into a full reproducer script?
>>> Something that someone that knows nothing about mysqld/mariadb can just
>>> run and have it reproduce. If I install the 10.6 packages from above,
>>> then it doesn't seem to use io_uring or be linked against liburing.
>>
>> Sorry Jens.
>>
>> Hope containers are ok.
> 
> Don't think I have a way to run that, don't even know what podman is
> and nor does my distro. I'll google a bit and see if I can get this
> running.
> 
> I'm fine building from source and running from there, as long as I
> know what to do. Would that make it any easier? It definitely would
> for me :-)

The podman approach seemed to work, and I was able to run all three
steps. Didn't see any hangs. I'm going to try again dropping down
the innodb pool size (box only has 32G of RAM).

The storage can do a lot more than 5k IOPS, I'm going to try ramping
that up.

Does your reproducer box have multiple NUMA nodes, or is it a single
socket/nod box?

-- 
Jens Axboe

