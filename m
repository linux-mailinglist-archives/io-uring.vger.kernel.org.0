Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588AA44C697
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 19:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKJSEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 13:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhKJSEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 13:04:35 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFBAC061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 10:01:47 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id s14so3363510ilv.10
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 10:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oEzJJiHFWM5Q25Ic6vhipp19khMatwmxv64pMEfUho0=;
        b=c0N0SVnGHRvWrPGle2jKaNhWFsmOyLn4pK3vnGVrQdvq5vnvGtTjLfR/qVzJFc9OQy
         CI4IJoVukwG/IPW6NhBDpyWT83unxHJa39FOMWGvIJt5D9isMdFuHTlCIX+fOSyuf1Vy
         6q7NuNjOUUDG638v6MVNTnFTywBe4NhVo8tve7V0U1o0tH7BicBxSHaIiAciDEWBVvXL
         3P/XasMT2VgZredzPA3Vi7euEsysqZdiwpRdPIdpiTjBJmybeabf+NIi9xlliv/h2FQd
         YEDVnQdaVcOWtVw57O5J2k/LCBR7wNYFEP+Y6MkHLo4sfzaX8u+PJ60rZikhmdJO7XED
         lU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oEzJJiHFWM5Q25Ic6vhipp19khMatwmxv64pMEfUho0=;
        b=aD3VoJ1ptglV9sRhw7EOADM1ExEoi36vzo3qfHnXJvJ+1MfUwJw+DoHvk8Zsxe2std
         oJt8qEsCd2uL/YYCVhytazEE4CqorhwpnhbEHkiLzTpwTBYOHgWk3+Xe9SNBozqKIydP
         vTClETo4VX9TXZdlPVndtRQ95XTQpPZLviYeC4z2ekCCtO1fLJ01UpILEVlyIfMmRfX+
         ETb4au7/LHyjzwz70FEZ+F/3KHZqziEoj0qHx4353kRT9xjurCi2+yGoAnmt3JxIpsNF
         aoXxKr/nGquPqC2I7Y9nDy/JNqXUTxy6v5vTv7VCzvC79HDGnskcQKy6Xy09RLjzkzHq
         TVHA==
X-Gm-Message-State: AOAM5337iYrpk0KzKXUP4EEuMDqBbr67nDbAZNN2Fhd0Rpi+BtLmTBD/
        71KWEEHiOG1CjUaCiU07VuHvTRYqTsWFkCRk
X-Google-Smtp-Source: ABdhPJz2ZPZNmbDINSAwJySv0j0YfRDlhzeFQEdLuM9Frg99ehdXFzudNbjbGee8Btu586SeP79mtA==
X-Received: by 2002:a92:c8c6:: with SMTP id c6mr609640ilq.54.1636567306646;
        Wed, 10 Nov 2021 10:01:46 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f15sm366491ila.68.2021.11.10.10.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 10:01:46 -0800 (PST)
Subject: Re: uring regression - lost write request
From:   Jens Axboe <axboe@kernel.dk>
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
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
Message-ID: <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
Date:   Wed, 10 Nov 2021 11:01:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/9/21 4:24 PM, Jens Axboe wrote:
> On 11/9/21 3:58 PM, Daniel Black wrote:
>>> On Sat, Oct 30, 2021 at 6:30 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
>>>> Were you able to pinpoint the issue?
>>
>> While I have been unable to reproduce this on a single cpu, Marko can
>> repeat a stall on a dual Broadwell chipset on kernels:
>>
>> * 5.15.1 - https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1
>> * 5.14.16 - https://packages.debian.org/sid/linux-image-5.14.0-4-amd64
>>
>> Detailed observations:
>> https://jira.mariadb.org/browse/MDEV-26674
>>
>> The previous script has been adapted to use MariaDB-10.6 package and
>> sysbench to demonstrate a workload, I've changed Marko's script to
>> work with the distro packages and use innodb_use_native_aio=1.
>>
>> MariaDB packages:
>>
>> https://mariadb.org/download/?t=repo-config
>> (needs a distro that has liburing userspace libraries as standard support)
>>
>> Script:
>>
>> https://jira.mariadb.org/secure/attachment/60358/Mariabench-MDEV-26674-io_uring-1
>>
>> The state is achieved either when the sysbench prepare stalls, or the
>> tps printed at 5 second intervals falls to 0.
> 
> Thanks, this is most useful! I'll take a look at this.

Would it be possible to turn this into a full reproducer script?
Something that someone that knows nothing about mysqld/mariadb can just
run and have it reproduce. If I install the 10.6 packages from above,
then it doesn't seem to use io_uring or be linked against liburing.

The script also seems to assume that various things are setup
appropriately, like SRCTREE, MDIR, etc.

-- 
Jens Axboe

