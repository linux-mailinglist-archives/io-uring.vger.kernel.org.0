Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391D71F323E
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 04:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgFICO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 22:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbgFICO5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 22:14:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3005C03E969
        for <io-uring@vger.kernel.org>; Mon,  8 Jun 2020 19:14:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a45so502459pje.1
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2020 19:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PvviHI/SRuYzxo2oLi7rY36Y1+NY73E3MfIOAPl6mqA=;
        b=dSB88R2G7btEfc0odcP1j1qnivJq+/2smScoxj7Y4++mQQ48SaCCSDhJPR7FDCrrm8
         Y2rP3/JLOG2biW8BxZRcmpc8zGH0sF2mBAuPyCnR6Qsr5AIzIq2zrMnM7AR1DtrKd9oo
         LyEOKlxbWoCWYt8bTCjq0eLZSjiRrXvGGpQs87aIeTf+AGevRHFlkDoQeOFJ5fcQLzBQ
         88FOqhZS4APCrqqgcEQ7zDlvrRSl5w0K1pWYO7jWVVZN8a7xIjnOU7/8G+DYs0n2ngNM
         rdzTmDTwZB9giGXnjpkUrSOQZWN8HGmdyXbbZx/8jyOjzPJVYFRJyk3PsEq2bxdXCOUJ
         zJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PvviHI/SRuYzxo2oLi7rY36Y1+NY73E3MfIOAPl6mqA=;
        b=NeR+BjeDqtScWkkercNdekxmzohZKOqKsDiEKfhJuqfuP3cS9biyH64DpG0LXU3hGM
         E762h+HFb1PLvYt+cpdNMwDTLXVN6e2Fxb2NDs4e2GV98i5mQPdqXN6DnSgRmkILyKpg
         e8SpIH0DBdDPAqmSEuwwJ4R73hlw0wfCAPLfh5LtX2V/dCinpjmYXD7T1vi7Fwrq9Mho
         NBFbt4RWXcWn8h4R6h2v1fQJooJOcU5beHTtpaGz/QmUMDzzCtGilxVBb0ZeShduaiF9
         7Dqbl/UIzNYtUOk3nLl6LEM/Z28Ma2mgZ4cf/+A0C74wdFZzfRds5whbkYSR1NQlokfa
         65+Q==
X-Gm-Message-State: AOAM532fXBJ1eUnyYHK8OffwrRSHf+Ofe055p8JAcg0ar0m54eNTnK0p
        mUFVIosSyQNNMw/bQwaGYZnXbnHFZsuXvw==
X-Google-Smtp-Source: ABdhPJxXNPlUs1FLcNcq848VwL6Wfj6b2wLXm8e7cOdsGNSVOUgIlZXAls9reniG9haztgRUTJ2hUg==
X-Received: by 2002:a17:90a:eac8:: with SMTP id ev8mr2161175pjb.80.1591668894103;
        Mon, 08 Jun 2020 19:14:54 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r9sm8112543pfq.31.2020.06.08.19.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 19:14:52 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Clay Harris <bugs@claycon.org>
Cc:     io-uring@vger.kernel.org
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
 <4e72f006-418d-91bc-1d6f-c15bce360575@kernel.dk>
 <20200609014014.6njp6fkjrcwrdqbt@ps29521.dreamhostps.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0cf0596b-4b5c-ddbe-75fa-7914fa995828@kernel.dk>
Date:   Mon, 8 Jun 2020 20:14:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609014014.6njp6fkjrcwrdqbt@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/20 7:40 PM, Clay Harris wrote:
> On Mon, Jun 08 2020 at 14:19:56 -0600, Jens Axboe quoth thus:
> 
>> On 6/8/20 5:21 AM, Clay Harris wrote:
>>> On Sun, May 31 2020 at 08:46:03 -0600, Jens Axboe quoth thus:
>>>
>>>> On 5/31/20 6:47 AM, Clay Harris wrote:
>>>>> Tested on kernel 5.6.14
>>>>>
>>>>> $ ./closetest closetest.c
>>>>>
>>>>> path closetest.c open on fd 3 with O_RDONLY
>>>>>  ---- io_uring close(3)
>>>>>  ---- ordinary close(3)
>>>>> ordinary close(3) failed, errno 9: Bad file descriptor
>>>>>
>>>>>
>>>>> $ ./closetest closetest.c opath
>>>>>
>>>>> path closetest.c open on fd 3 with O_PATH
>>>>>  ---- io_uring close(3)
>>>>> io_uring close() failed, errno 9: Bad file descriptor
>>>>>  ---- ordinary close(3)
>>>>> ordinary close(3) returned 0
>>>>
>>>> Can you include the test case, please? Should be an easy fix, but no
>>>> point rewriting a test case if I can avoid it...
>>>
>>> Sure.  Here's a cleaned-up test program.
>>> https://claycon.org/software/io_uring/tests/close_opath.c
>>
>> Thanks for sending this - but it's GPL v3, I can't take that. I'll
>> probably just add an O_PATH test case to the existing open-close test
>> cases.
> 
> I didn't realize that would be an issue.
> I'll change it.  Would you prefer GPL 2, or should I just delete the
> license line altogether?

It's not a huge deal, but at the same time I see no reason to add GPL
v3 unless I absolutely have to (and I don't). So yeah, if you could
just post with MIT (like the other test programs), then that'd be
preferable.

-- 
Jens Axboe

