Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFDA21D182
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgGMITZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 04:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGMITY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 04:19:24 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988E1C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 01:19:24 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ga4so15474004ejb.11
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 01:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FBC6tnEKKXyThx6a9eVIgSnRN3wb13o5O8Ym1EQ5vuE=;
        b=tmD2NH9VwA4jmEMh4A1MkwY0PLdTrwJgXaYB1y7xYdxL1CLECsx/XQAiThXjv+fkCr
         iNhG42S2igFzlMPVluL+4QUHbOYZl8D3Ek9IWkiY3hHhy7RQhYCiBs8s6vBOImHSQ+AA
         H9KDmkU66173F+lpoWCkpAz2Zt63xYITAyfKM5XJMOVNxIu1nqat5hnGQDTjuFxdqB5w
         OFt7bYXBO959LfGNyAlsgDVxW2jNgd9ahYfPIE2zQWI78K3xH4B1Q2SZkMy2TftWJ8Yk
         MyJmEFE2Ot8lSshBhWwrWXdaDDAxkKNZhCeWdezuF1e1EmozSulJ9hfKCLHbAnqx18SF
         eCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FBC6tnEKKXyThx6a9eVIgSnRN3wb13o5O8Ym1EQ5vuE=;
        b=Z6phN7ZLvviIMoEvWnuM9E8s3wk/JEm87owO7e42QBK36xjmLW/PkGune6t2FUFe/F
         DBsJJMnL8ZdZ12SrLshUXgrY7RGDIKkS3+nSdd7VzUS2brM02dHEX5PeyZyR0Np7i+TI
         CGulcjMdZ5jgTdoitqOBj9qDhsn/g/O1WMwtAASVQhWojsd1dED4F8TVtimZzw1dUaRs
         nIFnrw5Yh947c9CdRDe4X19L8e0n/sDkMNGUo3mfbPbMyOwjztyl82XXr8fH8+0lO3hB
         AzVHzg/oSIc8TjB793Boj74d5FxjuwDTsrhTD1b3Q6eS++gftqZxJ/PtPG4k8XsWCmOo
         OKSQ==
X-Gm-Message-State: AOAM531kTHLr1S09Q5QffdkoSbcn/lYnCitJ+XMrchdFNRiyBYbyo0Ax
        nB2gdnYlynPTQqeF6CXzo/uiXnVU
X-Google-Smtp-Source: ABdhPJwTxe4jPifnTA8DA/5SKiYGUkj1ZIsdWZ9HmVzvADJNKdC1oLTIsr70n0LIVK8/3wFiyNGmCA==
X-Received: by 2002:a17:906:7247:: with SMTP id n7mr72816825ejk.105.1594628362917;
        Mon, 13 Jul 2020 01:19:22 -0700 (PDT)
Received: from [192.168.43.17] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id aq25sm9329133ejc.11.2020.07.13.01.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 01:19:22 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594546078.git.asml.silence@gmail.com>
 <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
 <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
 <3b3ee104-ee6b-7147-0677-bd0eb4efe76e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC 0/9] scrap 24 bytes from io_kiocb
Message-ID: <755ed6b1-ad23-ea48-6b15-1e7e358c1975@gmail.com>
Date:   Mon, 13 Jul 2020 11:17:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3b3ee104-ee6b-7147-0677-bd0eb4efe76e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/07/2020 23:32, Jens Axboe wrote:
> On 7/12/20 11:34 AM, Pavel Begunkov wrote:
>> On 12/07/2020 18:59, Jens Axboe wrote:
>>> On 7/12/20 3:41 AM, Pavel Begunkov wrote:
>>>> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
>>>> drawback is adding extra kmalloc in draining path, but that's a slow
>>>> path, so meh. It also frees some space for the deferred completion path
>>>> if would be needed in the future, but the main idea here is to shrink it
>>>> to 3 cachelines in the end.
>>>>
>>>> I'm not happy yet with a few details, so that's not final, but it would
>>>> be lovely to hear some feedback.
>>>
>>> I think it looks pretty good, most of the changes are straight forward.
>>> Adding a completion entry that shares the submit space is a good idea,
>>> and really helps bring it together.
>>>
>>> From a quick look, the only part I'm not super crazy about is patch #3.
>>
>> Thanks!
>>
>>> I'd probably rather use a generic list name and not unionize the tw
>>> lists.
>>
>> I don't care much, but without compiler's help always have troubles
>> finding and distinguishing something as generic as "list".
> 
> To me, it's easier to verify that we're doing the right thing when they
> use the same list member. Otherwise you have to cross reference two
> different names, easier to shoot yourself in the foot that way. So I'd
> prefer just retaining it as 'list' or something generic.

If you don't have objections, I'll just leave it "inflight_entry". This
one is easy to grep.

>> BTW, I thought out how to bring it down to 3 cache lines, but that would
>> require taking io_wq_work out of io_kiocb and kmalloc'ing it on demand.
>> And there should also be a bunch of nice side effects like improving apoll.
> 
> How would this work with the current use of io_wq_work as storage for
> whatever bits we're hanging on to? I guess it could work with a prep
> series first more cleanly separating it, though I do feel like we've
> been getting closer to that already.

It's definitely not a single patch. I'm going to prepare a series for
discussion later, and then we'll see whether it worths it.


> Definitely always interested in shrinking io_kiocb, just need to keep
> an eye out for the fast(er) paths not needing two allocations (and
> frees) for a single request.

-- 
Pavel Begunkov
