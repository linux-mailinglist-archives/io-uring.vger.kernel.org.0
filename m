Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9425544B955
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 00:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKIX1U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 18:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhKIX1T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 18:27:19 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D810EC061766
        for <io-uring@vger.kernel.org>; Tue,  9 Nov 2021 15:24:32 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id j28so523835ila.1
        for <io-uring@vger.kernel.org>; Tue, 09 Nov 2021 15:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AaoatZyayFuinmUndTcOWSj3T2uLwGHcTSEK0zSn6qQ=;
        b=bTKXEG+/7wCt8GWogC9x57iF+C2lnGsmdxmTLs8YBayY6ONSyTu/4BNxvCiAEU6qKg
         rx+GWYUUhsMMlRIEAcdZM1LMgMozTtGcH5MV7m49U4K36e07gFcKdeJvhxXM8bcCy9PV
         gi7/ZOzli91pVaCrAdFjaUPlc/sP87700k/nLc+TH448lUMMul6jBrOwNM9nRdXnBr9x
         O+c1gFaxjVMRyVF7oCL7/+Y5Wxw4sYzIzgPGSeXWg77xa3Ch36Ii2CGP6e/NruVSWj9j
         Em22MQcVLEgVfActTJYR9lAnT3IiWQzt7PeVkOg4Et6U+8wxfZ9YNBCtPSTKLkTEnbQ9
         xUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AaoatZyayFuinmUndTcOWSj3T2uLwGHcTSEK0zSn6qQ=;
        b=oeoom3OvmfRi3VlUtxmX170kabHxO1IxpLTfxLoaWKxdnjWp1qUX9r9zwcIZ+F1yu+
         EWIFn71Tw7RsEhe57CMdlfEee+X3fMYGPI/6skv9mFHlpsdO7iMzIjR6lcVGeZgczJEf
         pbRfiDDcBSuFBQkO+qFTpFq9RgFOH+RCpVWVKBouoV0x54YKJo5lAqLxdyxDZz167hqK
         NTa8jreAxjxYJysiytSMbs1k5aFSzMWwWE0vj/A3H+EA6V78rCgZtJe7mZXWIfrvHJ14
         /CfaWl85LtZ87l9Ng2+y57rFhlT4l1B7HEgSOdnXq0pTX6ZXYl7Iu8PQsmbqnGMRV/Yq
         iBqw==
X-Gm-Message-State: AOAM531djf4n5JDBHpWRGBRjH9sjBMIgcBgpxfYk6vBuOPmhJOsJz86T
        5q41aAryw79LgUaQPJJauI/+y3PuGpLe+SMk
X-Google-Smtp-Source: ABdhPJzp9wNp0X16zpAwujYjUJ0HtaomjX38GrwBg9O4KCwyWiIuuVeMNzQbK5n8JNrOreq1LGjWEw==
X-Received: by 2002:a05:6e02:1e04:: with SMTP id g4mr8381002ila.187.1636500271999;
        Tue, 09 Nov 2021 15:24:31 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i15sm13260842ila.12.2021.11.09.15.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 15:24:31 -0800 (PST)
Subject: Re: uring regression - lost write request
To:     Daniel Black <daniel@mariadb.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
 <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
Date:   Tue, 9 Nov 2021 16:24:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/9/21 3:58 PM, Daniel Black wrote:
>> On Sat, Oct 30, 2021 at 6:30 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
>>> Were you able to pinpoint the issue?
> 
> While I have been unable to reproduce this on a single cpu, Marko can
> repeat a stall on a dual Broadwell chipset on kernels:
> 
> * 5.15.1 - https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1
> * 5.14.16 - https://packages.debian.org/sid/linux-image-5.14.0-4-amd64
> 
> Detailed observations:
> https://jira.mariadb.org/browse/MDEV-26674
> 
> The previous script has been adapted to use MariaDB-10.6 package and
> sysbench to demonstrate a workload, I've changed Marko's script to
> work with the distro packages and use innodb_use_native_aio=1.
> 
> MariaDB packages:
> 
> https://mariadb.org/download/?t=repo-config
> (needs a distro that has liburing userspace libraries as standard support)
> 
> Script:
> 
> https://jira.mariadb.org/secure/attachment/60358/Mariabench-MDEV-26674-io_uring-1
> 
> The state is achieved either when the sysbench prepare stalls, or the
> tps printed at 5 second intervals falls to 0.

Thanks, this is most useful! I'll take a look at this.

-- 
Jens Axboe

