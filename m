Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D24440FACE
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 16:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhIQOx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 10:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbhIQOxM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 10:53:12 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E813C0613C1
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:51:38 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b6so10646329ilv.0
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qYOUgIYivOFmGx2uxETS1e+Nv6vF5uJFuxV4aYhjPF0=;
        b=cAcIFE4U183q38t4DE10zJT16cXRfxBBIeOTDD8RvkjkEhhtVyoibvFaB1JOjC8/NW
         QWWN2m4nbASc7/cBIGYKxa+F8nepk5fQWO5qbsnuq/9booLOvDooqOvMAvs2tMG/jvXY
         fa08MooOq1Prjd60Jsm1KgbQBzVA8eXRZ1/rclsg7kk7vAscO8tNIFNd+xj2H83DOGyQ
         QDDOI+DTSFXzudPAmVsb5LZpzRJoVzukqmjpJZsoN0PfsI45xcYUc0eI+WQOGjIPPGq1
         ZrhfbRr/R7US5rJqq2q0MF+4Mtggnpm4TL4nbrVENIz3CLjX2MzBEqkZuSxfZ/fbgps7
         Tv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qYOUgIYivOFmGx2uxETS1e+Nv6vF5uJFuxV4aYhjPF0=;
        b=moWNctguFkF2EvuvTtFyuriv0Im0cRVteIg1rCX8iKFk1LPUxlZmryVcOy//yPGYgY
         0I+LW91e3UWckHJ3GO8EKrBRVy8zP6xcBKVXBSFI9bGwAqpMuLzxL1P1Y9q2HOGygDb2
         +CJr/WqY5eeqE7sDg7UnG/Zz4epeHyJxL1b0IzHULgm+HfZOk5Bq5zo2eZqV8IDUz0iC
         3LbKMJAqZxgw7AdY62sWJUGQfdvlmlTNdoZ/UpvdOSzM+EH+phVAxf/DZuuStVOPbLbK
         ZEpN024H8DxKDuz09prSL3W1yyArL/Utq7MoHZ8HfDsewf07T/LpRdeWKqtEe7iOvJXO
         pJtg==
X-Gm-Message-State: AOAM532EzR2RWhOmuBjanoZ217sGDR+jaFLdGXLoeScavGUx1qS1z0dm
        5F5jyLI3aTnZ2uxMLg5tdZP8+vB8sPmlnDHU+XA=
X-Google-Smtp-Source: ABdhPJz7hOuz0SbReevN5y1eA8GQ3u08y22vTi4ocLeTCGuL6S6IChGmMfmlTV+9U8f4Vne8qlKegg==
X-Received: by 2002:a92:d30c:: with SMTP id x12mr8376187ila.245.1631890297355;
        Fri, 17 Sep 2021 07:51:37 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r11sm3885590ila.17.2021.09.17.07.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 07:51:36 -0700 (PDT)
Subject: Re: [GIT PULL] iov_iter retry fixes
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9460dc73-e471-d664-7610-a10812a4da24@kernel.dk>
 <YUSrFBzbgLTNcSfT@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <666928ce-f09f-b513-5f28-fca2eca9d433@kernel.dk>
Date:   Fri, 17 Sep 2021 08:51:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YUSrFBzbgLTNcSfT@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/17/21 8:49 AM, Al Viro wrote:
> On Fri, Sep 17, 2021 at 08:44:32AM -0600, Jens Axboe wrote:
>> Hi Linus,
>>
>> This adds a helper to save/restore iov_iter state, and modifies io_uring
>> to use it. After that is done, we can kill the iter->truncated addition
>> that we added for this release. The io_uring change is being overly
>> cautious with the save/restore/advance, but better safe than sorry and
>> we can always improve that and reduce the overhead if it proves to be of
>> concern. The only case to be worried about in this regard is huge IO,
>> where iteration can take a while to iterate segments.
>>
>> I spent some time writing test cases, and expanded the coverage quite a
>> bit from the last posting of this. liburing carries this regression test
>> case now:
>>
>> https://git.kernel.dk/cgit/liburing/tree/test/file-verify.c
>>
>> which exercises all of this. It now also supports provided buffers, and
>> explicitly tests for end-of-file/device truncation as well.
>>
>> On top of that, Pavel sanitized the IOPOLL retry path to follow the
>> exact same pattern as normal IO.
> 
> I can live with that; I do have problems with io-uring and its interactions
> with iov_iter, but those are mostly independent from the stuff you are
> doing here.

I actually think we can end up cleaning up some of those bits post this,
it'll definitely make it easier by having clean save/restore states.

-- 
Jens Axboe

