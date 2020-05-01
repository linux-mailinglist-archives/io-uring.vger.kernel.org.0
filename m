Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484FB1C1706
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgEAN4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 09:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731068AbgEAN4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 09:56:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A098BC061A0C;
        Fri,  1 May 2020 06:56:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x18so11635013wrq.2;
        Fri, 01 May 2020 06:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nVy6xVot467fPGKE+CAQW0mY5W07tHJIflXllKQNc3U=;
        b=dYmdtZAbMUJvRYiDUSQjMFgQ1LE22fvTB6mFi+HS5/w6KzFiQZFOcKNB6xq2IEJ5z/
         uLvDF5mHwlRwVnG4Z8FnFsoepLsqdhkFbM0YNJXkbX88HXxtJAhceLm0b3aRNXv+neXg
         gg7CQBh4Ovt1KvAWlhnyIvyJbhtb06jNLi89HmQ33GARVYAAg+JmeHQ7VHmAhdt3UYhE
         taqrbRXbzT4s+oqCgI0SdRLZlxQvtTeapGhFNDatOmNZPZHRgc3JKq/3U4x9Ym6nVDCp
         froucC8dFgY3ZTAQDtFF/KRCCHRgDYtvPhan6+tIzaSQBuz/4kRmYLtvEgSaSCN0CUAP
         FKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nVy6xVot467fPGKE+CAQW0mY5W07tHJIflXllKQNc3U=;
        b=iGiwoSCfeJh4crq4c9g0QK/6RtzdDvQgPYwAZkYdo8C3wGiHRFX7aKrPJ96QFd7f0S
         70BfOOvVweGDMpgqLjdBT6vjz/sGN7MIg0dBj21vLh6jagD8r5I4npctjTzSWKubcxOH
         HxFeQOHVe/+P/cod3wV95NGyWEUte8Vx08hAqUAZ+zfbbbT0WGxROq/3nGxI29rhabfo
         dvH5tufur/NqSFvAEt9TPjeG5460XgUWiCZE0eFPTUtXEzHlXzzVFHZ2NPb3ncUqkCf3
         xXUvhwPw0LdwF1cQzsyrPVT2Bmh1jra2d1SmVLjGcG9+N9sZiWe3AxXmC9q1gHcnOBwh
         IiwQ==
X-Gm-Message-State: AGi0PuayfQRagFF20BORFfuQklGH6zRTF2Zj0sAT8XnLAAjwIJxrwhfv
        LcyQcEcf/PfjWgnRhZyjXtEViV5G
X-Google-Smtp-Source: APiQypLsurQNBd883OVsybu+wf1TevPtBNuM8uJYTQzu0JmXa0cJUtEVX+zEfzp9N8S9sxfkHtt7dw==
X-Received: by 2002:adf:8b45:: with SMTP id v5mr4675831wra.175.1588341380110;
        Fri, 01 May 2020 06:56:20 -0700 (PDT)
Received: from [192.168.43.135] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id s11sm4508609wrp.79.2020.05.01.06.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 06:56:19 -0700 (PDT)
Subject: Re: [PATCH 0/5] timeout fixes
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1588253029.git.asml.silence@gmail.com>
 <8665e87d-98f8-5973-d11a-03cca3fdf66f@gmail.com>
 <8d9b5e06-4100-c49a-c9ca-0efc389edaf3@gmail.com>
 <c7aefe37-d740-5324-905f-1b095cfb4ea7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <64a20810-851d-21b4-cf33-d624aee06ce8@gmail.com>
Date:   Fri, 1 May 2020 16:55:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c7aefe37-d740-5324-905f-1b095cfb4ea7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/05/2020 07:26, Jens Axboe wrote:
> On 5/1/20 3:38 AM, Pavel Begunkov wrote:
>> On 01/05/2020 11:21, Pavel Begunkov wrote:
>>> On 30/04/2020 22:31, Pavel Begunkov wrote:
>>>> [1,2] are small random patches.
>>>> [3,4] are the last 2 timeout patches, but with 1 var renamed.
>>>> [5] fixes a timeout problem related to batched CQ commits. From
>>>> what I see, this should be the last fixing timeouts.
>>>
>>> Something gone wrong with testing or rebasing. Never mind this.
>>
>> io_uring-5.7 hangs the first test in link_timeout.c. I'll debug it today,
>> but by any chance, does anyone happen to know something?
> 

Yeah, just found the culprit myself

> That's not your stuff, see:
> 
> https://lore.kernel.org/linux-fsdevel/269ef3a5-e30f-ceeb-5f5e-58563e7c5367@kernel.dk/T/#ma61d47f59eaaa7f04ae686c117fab69c957e0d7d
> 
> which then just turned into a modification to a patch in io_uring-5.7
> instead. Just force rebase that branch and it should work fine.

Got it, thanks

-- 
Pavel Begunkov
