Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10502389A97
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 02:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhETAfd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 20:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETAfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 20:35:32 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DDAC061574
        for <io-uring@vger.kernel.org>; Wed, 19 May 2021 17:34:10 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s19so8839544pfe.8
        for <io-uring@vger.kernel.org>; Wed, 19 May 2021 17:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=emobrien-com.20150623.gappssmtp.com; s=20150623;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tJdiX0FoHEbBUWgZACceZXshysZeArcrKSG80fCd0kM=;
        b=nNY+HQPE6TMQPM4rifp4yNi2hsdfR8hBn6MTkA7+7Og2TYxJlv7S4M++SbQwM1kjiC
         HiiErgB5c9R8Vvut5J1vgzvnaWaFMkHIytmPgXMTFLCsjAXect3jbFhdmOaYAZXrw4Iw
         J8dKcUY/QBo+2IK0PE9E47niz74Uyn4K917pNbnOs4bUgKqvOcXJD0iwe+/LzAGwkP2s
         mz+9TcG73xH4QTn+5iO1ZP9XVIQyWaJlkuFIj5EQQvrgMv11GA3ohExx8GtWOHyQ3h+D
         r+NV0wew9u5/dGtxgv/Oh0YppBCys7fm1HdZDEjlgMQ+Jecp/cQrumaA9ARQMQI4dwxP
         /crg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tJdiX0FoHEbBUWgZACceZXshysZeArcrKSG80fCd0kM=;
        b=LrBkJ8jhUNAGFRxPSLgydry9rdEy7Wjl1A8COtXioDZUxlPapSCGksTsjgviLOu/MG
         SO2TsuC7BV7/nVi5UDeTmbilMrrzCzU6KSFlAoIs9EARler6+ydZLTd54Il6E2URmSpE
         tfTn780kANN+UTyDwtO7NKBxBOtik1OThvi69IkgQ1oBwkJgCvhTJYlzLiMsKwO/RCZF
         Wmeeoibxv6hoK5ivefcYvdbRDiEWWleJr3iW4JTU5nA+K9rQjQn2j9mXqIjQUx16vext
         mOg8NYitoHqULMgHl5bVNl/Um7xxq6kal6lrJ7XGZlgG9qEO1Fa8H4GPBjDgM3v7mVyU
         0/2g==
X-Gm-Message-State: AOAM530C23IRdyrP3Tt+KPqLutZhl3Ny+RPsYOsX2UjKdl58m60z7Cqf
        68kkKwqFFu21qXMqAZnFf9hMDe0ZOBGlCg==
X-Google-Smtp-Source: ABdhPJwxKlosOVmR6GOPLBp3nC4CWHdQn1dpH0NfrH1rfKmLVnlBHk8Kb1TTmKlwKbmyELvuYelTYg==
X-Received: by 2002:a63:79c3:: with SMTP id u186mr1797406pgc.203.1621470849420;
        Wed, 19 May 2021 17:34:09 -0700 (PDT)
Received: from [59.191.218.23] (dyn-59-191-218-23.its.monash.edu.au. [59.191.218.23])
        by smtp.gmail.com with ESMTPSA id e16sm73006pfj.188.2021.05.19.17.34.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 17:34:09 -0700 (PDT)
Subject: Re: Confusion regarding the use of OP_TIMEOUT
References: <24207f62-fa0b-a52a-fa06-a39b4e208dd6@emobrien.com>
To:     io-uring@vger.kernel.org
From:   Alex O'Brien <alex@emobrien.com>
X-Forwarded-Message-Id: <24207f62-fa0b-a52a-fa06-a39b4e208dd6@emobrien.com>
Message-ID: <711e8634-05ae-8c67-4663-378716c1153f@emobrien.com>
Date:   Thu, 20 May 2021 10:34:06 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <24207f62-fa0b-a52a-fa06-a39b4e208dd6@emobrien.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/21 10:19 AM, Drew DeVault wrote:
> On Wed May 19, 2021 at 8:18 PM EDT, Alex O'Brien wrote:
>> On 5/20/21 5:51 AM, Drew DeVault wrote:
>>> Hi folks! I'm trying to use IO_TIMEOUT to insert a pause in the middle
>>> of my SQ. I set the off (desired number of events to wait for) to zero,
>>> which according to the docs just makes it behave like a timer.
>>>
>>> Essentially, I want the following:
>>>
>>> [operations...]
>>> OP_TIMEOUT
>>> [operations...]
>>>
>>> To be well-ordered, so that the second batch executes after the first.
>>> To accomplish this, I've tried to submit the first operation of the
>>> second batch with IO_DRAIN, which causes the CQE to be delayed, but
>>> ultimately it fails with EINTR instead of just waiting to execute.
>>>
>>> I understand that the primary motivator for OP_TIMEOUT is to provide a
>>> timeout functionality for other CQEs. Is my use-case not accomodated by
>>> io_uring?
>>
>> Have you tried setting `IO_DRAIN` on the timeout operation itself?
> 
> Tried it just now. Does not appear to change the results.
> 

Hm. Sorry, that was my one concrete idea. (I do think that's more what
you want, since it should guarantee that the timeout only starts after
the first batch completes). Maybe there's some weirdness due to the fact
that OP_TIMEOUT actually returns -ETIME on expiration, rather than
"succeeding", though I don't actually know how IO_DRAIN behaves in the
presence of preceding failures.

-- 
- Alex O'Brien
<alex@emobrien.com>
