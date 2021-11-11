Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB8844D92A
	for <lists+io-uring@lfdr.de>; Thu, 11 Nov 2021 16:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhKKPcQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Nov 2021 10:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhKKPcQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Nov 2021 10:32:16 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3580FC061767
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 07:29:27 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id s14so6168945ilv.10
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 07:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=35qRn/OYPUJHH5CnrB4SgQrDbeFgtmytq6XvjDmd4eY=;
        b=tTTFxgb1+xl2w9G0Qtylk7wTpC3t5q6xFWXhp15IYPBi9hHyiF81L65FYWdfpRJo7O
         vw9UQtyzunnpVgNJPQrDOXRzdFwXoLEpyKr2wOj5p8lKCRRKUYBrgGBLKcpX5EqB+YkF
         D4zeXEkkEw1ttPfWtfL8imBzwzJfstYxO6kI4tOS9zNJ4lXRqL5pRAfMlZ9PLaXyyoFm
         PuhI0xFAMzDbJvSz4sjJn1VGWupVUsDQCaNzRVvgnaJlg2ezxAtP2CQC5sCU+oTpBUZ7
         Y/ATW991USZ8LbS3JRj2i1X7/s+yXiwwsPz8qXM+fqTDkRl9oI33vs0XAa6+27XqEgDk
         weNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=35qRn/OYPUJHH5CnrB4SgQrDbeFgtmytq6XvjDmd4eY=;
        b=mn4ltvgUqtO8TOyA5HgdNZCdIPSkx0csKrReRPFuyUaAX6SXVHd9P+NpUahpNWUv4V
         uIULOFPdKALDg8z2qSGA/rS7V9xlQ0DM3jRjS6SyxaElv2rJ7sTmQnxWma7WceIwbFA8
         SXRL34I3LlBL7UhbguhHGDDV9/QQAwkanCrqIiWTqjnMcmGzqdZrzOXbCGMbunCL64tY
         zNaOynHTtHkNn462PgMBkcuMrOAaZ+gR2agHdGjuz7KKLrgUBVE/bZE4qCLrrexUUoTV
         sc9V8yXmx9Qo1+S5rUfofYuTHIvKxw65rf+yErH+bFQuuIDC1tJnFx5jh9ZEvRU/sVt8
         nBuQ==
X-Gm-Message-State: AOAM530EZ7yWxkJaWff1KdEhRQewcaVkUFCe+MCbBxSnBjXyAFV0Ykct
        N99niJcXzupT/OsyTrUBsdxkwFAlO+DolJoW
X-Google-Smtp-Source: ABdhPJwAxBSrnBqUzHa84TzUbfjF0jjOQBMGhhpYEL116oornfDKCY6yhJ9v/opo+5uMSr72yyJ/zA==
X-Received: by 2002:a05:6e02:20e2:: with SMTP id q2mr4887185ilv.33.1636644566294;
        Thu, 11 Nov 2021 07:29:26 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y6sm2372270ilu.38.2021.11.11.07.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 07:29:25 -0800 (PST)
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
 <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
Message-ID: <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk>
Date:   Thu, 11 Nov 2021 08:29:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/21 7:58 AM, Jens Axboe wrote:
> On 11/11/21 7:30 AM, Jens Axboe wrote:
>> On 11/10/21 11:52 PM, Daniel Black wrote:
>>>> Would it be possible to turn this into a full reproducer script?
>>>> Something that someone that knows nothing about mysqld/mariadb can just
>>>> run and have it reproduce. If I install the 10.6 packages from above,
>>>> then it doesn't seem to use io_uring or be linked against liburing.
>>>
>>> Sorry Jens.
>>>
>>> Hope containers are ok.
>>
>> Don't think I have a way to run that, don't even know what podman is
>> and nor does my distro. I'll google a bit and see if I can get this
>> running.
>>
>> I'm fine building from source and running from there, as long as I
>> know what to do. Would that make it any easier? It definitely would
>> for me :-)
> 
> The podman approach seemed to work, and I was able to run all three
> steps. Didn't see any hangs. I'm going to try again dropping down
> the innodb pool size (box only has 32G of RAM).
> 
> The storage can do a lot more than 5k IOPS, I'm going to try ramping
> that up.
> 
> Does your reproducer box have multiple NUMA nodes, or is it a single
> socket/nod box?

Doesn't seem to reproduce for me on current -git. What file system are
you using?

-- 
Jens Axboe

