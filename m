Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8261BE781
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 21:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgD2Tiw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 15:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726524AbgD2Tiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 15:38:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB98DC03C1AE
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 12:38:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z1so1575468pfn.3
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C2oJ0SyPs9HEb0owzBNwN39TC6SNjJLXtZcIz6tubRU=;
        b=duZ+Zb2Olh7ioAOUdTN46hkMTY/jWcfTsHrE7BFfMAxEYwkLojVJ9KXlq6+pWOiibz
         8XAEnyCbRqlfly/rPFoZHZecv5MfNeFYdVWFjLGPas4ru6HZRNBolocHHEjU8QEhNZ7m
         WHGD3rMISfMbwtQPPze9k42jfMX79rYcps3IQKtH+WhRQ7fquAOnmotTq9x87k/I0Vhx
         rg68XNI6dJaIRTKvqjQyxNV6WIlvxlgsPu32zbNV9tC3zlR8o3nhTSpd3w+Ps/6VzXub
         jho8XTYO0pmG8sPnmJpqFHYV5YaN9TFzLDE1ojX26JYQ31ucXWFTWVki5EZYfHOl7yiG
         mojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C2oJ0SyPs9HEb0owzBNwN39TC6SNjJLXtZcIz6tubRU=;
        b=UJtFbqw/mgulDBZLtZdV6kYew0EAhE5l0VIIgIrK8eDfav7XLgJ6lj0Hpj06uFuapv
         tG4SbS5tpGXkMO5C0xxxNu5QPWcExOGzPbUIYTb/rX3L7YIfa83Y1VRVHTa5Ln6mgYus
         xB86dmChk6ddLeg0GtT11XQxPXeO3lhb2QQf5FXbHqWRvRxXF9YLVoVTYt+CZx5/ZCpI
         HfSZ2lrrmfRiDkzVIss73dOM2CO4R+1J21IsSNcMnsU0HwA5mlOO4e93YHsz5cfPfNMi
         KBWR1hEzPaPp+rEIpWzZhgsUwTue2xQCa3qbMc3ss8Dn6dvrW7xALhfkFQFVm9vM1yKe
         gNuA==
X-Gm-Message-State: AGi0PuZjVSVkhGtBzfT1WF2vWMxMpj3YgHW27hl4iGWu9MOY0PQyGPm9
        1iK1gb4BiXMfB2Q7jGbVpBXqaKMk55fVag==
X-Google-Smtp-Source: APiQypLOAlGrLpFwk9hQozq0pfMNb5gb4FgaHRauhuzjdRqiO7anjhn/RBYyvjkuVaHjFDlsOicrrw==
X-Received: by 2002:a62:3812:: with SMTP id f18mr35356258pfa.173.1588189131124;
        Wed, 29 Apr 2020 12:38:51 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s145sm1622433pgs.57.2020.04.29.12.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:38:50 -0700 (PDT)
Subject: Re: Build 0.6 version fail on musl libc
To:     =?UTF-8?Q?Milan_P=2e_Stani=c4=87?= <mps@arvanta.net>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org
References: <20200428192956.GA32615@arya.arvanta.net>
 <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
 <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
 <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
 <20200429193315.GA31807@arya.arvanta.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4f9df512-75a6-e4ca-4f06-21857ac44afb@kernel.dk>
Date:   Wed, 29 Apr 2020 13:38:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429193315.GA31807@arya.arvanta.net>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/20 1:33 PM, Milan P. Stanić wrote:
> On Wed, 2020-04-29 at 10:14, Jens Axboe wrote:
>> On 4/29/20 9:29 AM, Jens Axboe wrote:
>>> On 4/29/20 9:26 AM, Christoph Hellwig wrote:
>>>> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
>>>>>
>>>>> Not sure what the best fix is there, for 32-bit, your change will truncate
>>>>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
>>>>> case for me, maybe musl is different if it just has a nasty define for
>>>>> them.
>>>>>
>>>>> Maybe best to just make them uint64_t or something like that.
>>>>
>>>> The proper LFS type would be off64_t.
>>>
>>> Is it available anywhere? Because I don't have it.
>>
>> There seems to be better luck with __off64_t, but I don't even know
>> how widespread that is... Going to give it a go, we'll see.
> 
> AFAIK, __off64_t is glibc specific, defined in /usr/include/fcntl.h:
> ------
> # ifndef __USE_FILE_OFFSET64
> typedef __off_t off_t;
> # else
> typedef __off64_t off_t;
> # endif
> ------
> 
> So, this will not work on musl based Linux system, git commit id
> b5096098c62adb19dbf4a39b480909766c9026e7 should be reverted. But you
> know better what to do.
> 
> I come with another quick and dirty patch attached to this mail but
> again  I think it is not proper solution, just playing to find (maybe)
> 'good enough' workaround.

Let's just use uint64_t.

-- 
Jens Axboe

