Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBDE1567A6
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 21:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHUFU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 15:05:20 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41684 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgBHUFT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 15:05:19 -0500
Received: by mail-pl1-f194.google.com with SMTP id t14so1156136plr.8
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 12:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kA8b2t9h/f0Kj4PG5myE4Vc7nvgaz/kpOlQHpQ/Wwwk=;
        b=D/hIn5b9BMIiuaWOpaiuh+fH8gBCVo31S7b7oLE9SAndJ1S7krfuOlRbUVc3iOlc+0
         Yb3NKdnhO4et1BY9q7Xi8WeZlK1/2XC8i1S7/K23Pd1fFm0AvQfmBpUj3Ss8FTv9Pa/j
         lZvjR/Z7REjDTWme0kW3nt7w7ug7MCOLSrbYmnwM+De0qDD6BlODt3xyqXVX/cd52QxY
         fQCuuicQhuwdExzfwGBPVOb/uVCbgwwLYgP3NDJEFV0TYy3lh0dNN04jVniU9NOwPAh2
         uPGLWO3me9BksryfflAL9VEgAoTWgo3mM3N44Y9Q4sEag5p2mwkeHRrN8qKVgSQOZauy
         Iijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kA8b2t9h/f0Kj4PG5myE4Vc7nvgaz/kpOlQHpQ/Wwwk=;
        b=Tqb7lPRhr7RQBB9lIxRTXQk9WF3D9iT72OHzEr2iznKdo0Tu22JNXGUyJqpJP2BwOj
         7YVwXbn7Sx+n7HJNezAMDu1O+S/BjM/rH5Z0VN6Xm8NbiWe25y0g8yvoWnRN6it54cJK
         94xS2AptXSkTn5R1xLrEUid8Z/vF5T/aDm1ItWJm75XXt3sKNlxQeT/va7P9OnSpZZ9L
         OXdKHzYYNtgasFNtgu1U7V4Et+lyU2BmEyu1Xjv0nHZsNcO/T5GEdi1j9fcMkQ4eowG8
         QTiJ5UsT3a5CdPebYypGXpbIlF+daCCAjHm+7fz/x6Wj9x3IDWisjCuiqS/UZxqTCYPF
         GORQ==
X-Gm-Message-State: APjAAAWqWBXlG4JoUwO56yFqZdu2UXOEsZhnzqK98xRXcb+xI4zgFu+R
        f5+4O/L2npW7Ln5JgnsglXQGvlYdQYs=
X-Google-Smtp-Source: APXvYqzrlD8VzpaiMuIMdMznyHqi0xzfw8Abkt2vkhK7zFqyF1oLLR1j/asKZkFUA8fO2vcHUv6LEQ==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr5432998plo.220.1581192317522;
        Sat, 08 Feb 2020 12:05:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g8sm7123765pfh.43.2020.02.08.12.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 12:05:17 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Allow relative lookups
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200207155039.12819-1-axboe@kernel.dk>
 <36ca4e5a-9ac9-2bc6-a2e6-f3e2667463c9@samba.org>
 <74c1e465-d18c-85f1-dd7d-1f6a7177f5a2@kernel.dk>
 <1f8f18a5-f37a-c11b-3e72-716de4c580f7@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <266cdea9-5a63-adab-a441-d3f1c4cb23d1@kernel.dk>
Date:   Sat, 8 Feb 2020 13:05:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1f8f18a5-f37a-c11b-3e72-716de4c580f7@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 3:56 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>> Am 07.02.20 um 16:50 schrieb Jens Axboe:
>>>> Due to an oversight on my part, AT_FDCWD lookups only work when the
>>>> lookup can be done inline, not async. This patchset rectifies that,
>>>> aiming for 5.6 for this one as it would be a shame to have openat etc
>>>> without that.
>>>>
>>>> Just 3 small simple patches - grab the task ->fs, add io-wq suppor for
>>>> passing it in and setting it, and finally add a ->needs_fs to the opcode
>>>> table list of requirements for openat/openat2/statx.
>>>>
>>>> Last patch just ensures we allow AT_FDCWD.
>>>
>>> Thanks! But IOSQE_FIXED_FILE is still not supported and not rejected at
>>> the same time, correct?
>>
>> That's in a separate patch:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=5e159663813f0b7837342426cfb68185b6609359
> 
> Do we handle the error path correct?
> As far as I can see io_req_set_file() is called before
> io_{statx,openat,openat2}_prep() and req->file is already filled.
> Maybe a generic way would be better using io_op_defs[op].allow_fixed_file.

Worst case, as far as I can tell, is that we'll think it's a valid
descriptor (because the both the fixed index and fd are valid) and we'll
still error in the prep. Only concern would be that maybe we should make
this an -EBADF return, which would be 100% consistent between them (and
with other cases). I'll make that change.

> In the long run we may want to add support for openat2 with
> IOSQE_FIXED_FILE, then Samba could register the share root directory as
> fixed file and it could be used for all openat2 calls.
> But for now it's fine to just reject it...

It's not impossible to support, it's just that it requires changes
outside of io_uring to do so. So for now it'll just not be possible, I'm
afraid.

-- 
Jens Axboe

