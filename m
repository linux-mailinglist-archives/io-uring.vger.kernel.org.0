Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DD4410BD8
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 16:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhISOSE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 10:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhISOSE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 10:18:04 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5EAC061574
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 07:16:39 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b6so15802677ilv.0
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 07:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ELGcubQzB4P2qf9EA02pbCLIk3Zpj0lpHEraJb8P4wA=;
        b=kZh4DB58uFPLiP2O2L3bIG56JptLA6s/3SnlaaP+qxE9p1dpduurbBEVUkKoY/A5qQ
         hnCU0epGnmnJsuIbskWbU7UAmewwhJHw1t4veUbx2sHZH7VTfR6mw0KF6WXa258D2UX1
         F2uoJLUFp9D7Lmsz9R57wKj9XztYqcRXj0vFd/wqq9wIVO3mm2BfO8Viu6dArxIK8unq
         6dquD/Tvv9QgFNQSkLSdRKXMXigaD5pXYyNCAHtS6ABQR69qchDokqE87KWLYugnCI5l
         myQHZg4fRtT5VVSacLB1YJrXgGsBwekF0+CfyUTb81s6HvpgO+8gbRMWORRYe0c0Qz5P
         GuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ELGcubQzB4P2qf9EA02pbCLIk3Zpj0lpHEraJb8P4wA=;
        b=Fb9GL4I31PkE7D/IQqvitgQ5XfJzmReeO16dv+vD54IpL2olLaOk7Sm5Y9eXPwQ1hk
         dgA+ixlIW3jeo+uUeXrBAA1NHiazdNIKCUEsuGNGXqwHo48YNKDWeXnNJUrT51rjchka
         62QzyoJf5g/DPoxAtJxfwtIJZ1ATuSZjRv0pJblXqYunYg/fn+fpvC7d7F3ezWr9+B/j
         30G/FOTOHddML+6cGsu9zLWHPjTmMTvCKdKKU48L0lejwExjZxNqzZtSFsFxm+4m+GJI
         dDSPS094BuGl/HniE31ckPIE+pcXNOHdC9gvoFxm44ubn+vXYJQFPSaePYjxhdEIaKZD
         1fyQ==
X-Gm-Message-State: AOAM531tAwBMRg7W0apKNuMtzZtPszYb0FKFQaiIiEDHnxvFpdlyDDrH
        ZFLX+68ZIorajWrKIpBWK3Cyhh4n+e+Erw==
X-Google-Smtp-Source: ABdhPJysUmeCWFKr0UdGn+xpGemtuE/HEHkBs9u4MQaq+MfkpsXi9Sj9/eEELySkL3KCCn+7HQjrhg==
X-Received: by 2002:a05:6e02:1ba3:: with SMTP id n3mr15232880ili.253.1632060998001;
        Sun, 19 Sep 2021 07:16:38 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o3sm2385231iou.20.2021.09.19.07.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 07:16:37 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Vito Caputo <vcaputo@pengaru.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
 <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
 <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
 <d0cbd186-b721-c7ca-f304-430e272a78f4@kernel.dk>
 <3df95a9f-7a5a-14bd-13e4-cef8a3f58dbd@kernel.dk>
 <20210919041546.bbs5u45pyythmwvj@shells.gnugeneration.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <819d1083-8304-ec27-343f-9d1954c999d2@kernel.dk>
Date:   Sun, 19 Sep 2021 08:16:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210919041546.bbs5u45pyythmwvj@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 10:15 PM, Vito Caputo wrote:
> On Sat, Sep 18, 2021 at 05:40:51PM -0600, Jens Axboe wrote:
>> On 9/18/21 5:37 PM, Jens Axboe wrote:
>>>> and it failed with the same as before...
>>>>
>>>> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7, 8,
>>>> 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
>>>> -1, -1, -1, -1,
>>>> -1, ...], 32768) = -1 EMFILE (Too many open files)
>>>>
>>>> if you want i can debug it for you tomorrow? (in london)
>>>
>>> Nah that's fine, I think it's just because you have other files opened
>>> too. We bump the cur limit _to_ 'nr', but that leaves no room for anyone
>>> else. Would be my guess. It works fine for the test case I ran here, but
>>> your case may be different. Does it work if you just make it:
>>>
>>> rlim.rlim_cur += nr;
>>>
>>> instead?
>>
>> Specifically, just something like the below incremental. If rlim_cur
>> _seems_ big enough, leave it alone. If not, add the amount we need to
>> cur. And don't do any error checking here, let's leave failure to the
>> kernel.
>>
>> diff --git a/src/register.c b/src/register.c
>> index bab42d0..7597ec1 100644
>> --- a/src/register.c
>> +++ b/src/register.c
>> @@ -126,9 +126,7 @@ static int bump_rlimit_nofile(unsigned nr)
>>  	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
>>  		return -errno;
>>  	if (rlim.rlim_cur < nr) {
>> -		if (nr > rlim.rlim_max)
>> -			return -EMFILE;
>> -		rlim.rlim_cur = nr;
>> +		rlim.rlim_cur += nr;
>>  		setrlimit(RLIMIT_NOFILE, &rlim);
>>  	}
>>  
>>
> 
> Perhaps it makes more sense to only incur the getrlimit() cost on the
> errno=EMFILE path?  As in bump the ulimit and retry the operation on
> failure, but when things are OK don't do any of this.

Yes, may as well. I've pushed a change that makes it incremental and
doesn't trigger it unless we hit EMFILE.

-- 
Jens Axboe

