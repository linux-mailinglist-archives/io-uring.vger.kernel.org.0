Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4503E21CB54
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 22:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgGLUco (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 16:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbgGLUco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 16:32:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0BBC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 13:32:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o1so4555670plk.1
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 13:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/RUUpDripryhlIQErb5BlWHxredIBHW0RouNiFZpmj8=;
        b=2MnqoxIBOKd1TPSfnYrDBwCEfJAvBIzLbvciHkwogV09JSq5MZSroehXVZfpID9i/f
         GcwsnD/ueP2MC53zypStMuEB6eLtN1Uy+i0XZhwxwWmNzG2/YHIC2A1XIbTZU1SctRrh
         Io8ot9xYEXazo6JSDnHwkBVTwwlPtXqj40KfHRC/NmuzkkD22Uqingq+yDfmrpsdvSI2
         o1PfP5cd+fu7SpTzJSfJFUKzHW8nX2yMh2SjrNXDxHcnE4HlRbv66JIldeQCEcCfw7Jk
         +TrS2M2eWX3XBnppKqS6BiBcgFDZmVshULwtglp1do9fJeeGBaF6WTzS0T6VAYbxJQgJ
         +Q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/RUUpDripryhlIQErb5BlWHxredIBHW0RouNiFZpmj8=;
        b=oZQ46LMhYNvGElYgIVxn7PuLwvtWBSnH8LvgjbV0b+JHvvVgrbWNTjF0OF4eMPEtOw
         72GdiLx2iTFXNZ+FEAH+Rav2uEaoxOkWX5VFF/VQ10HnL3hCNzOqe1KwzRcfnc3gj2C7
         1tInYdIf8bmp80PdAOSCV3mozsPgxlNqBDigkmlTJdarGblfG9KQQrxrHjhW/HSyVMay
         uWzA9+dODNx082xzaWeAFmIuOf4SlFNCOIi4fYb2htnQ4Atbf/ixepgiTleAf8W0mONB
         jr4GQ74xrxNmIO4jwVa8ytt5KFWZhrJr/fw4xUxCP4vkt7IPUqI71fwRvK5Q/rAnm62c
         yssg==
X-Gm-Message-State: AOAM531DNw8CXt7QGSH5+QNHVkHZIS31EdDR+NUkrdXi/gRT9dhora4t
        HjZXYgOO9fm8PJP2hQRxAz7BA2uzIdRh1Q==
X-Google-Smtp-Source: ABdhPJxKkJ7PBOFFGbSzrVe0mzJMIztZYHTN1PID5VHvoaWPehM52hdRtwxKxidhgST7MogD/+9pPg==
X-Received: by 2002:a17:90a:e57:: with SMTP id p23mr16255868pja.164.1594585963556;
        Sun, 12 Jul 2020 13:32:43 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p12sm11264635pjz.44.2020.07.12.13.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 13:32:43 -0700 (PDT)
Subject: Re: [RFC 0/9] scrap 24 bytes from io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594546078.git.asml.silence@gmail.com>
 <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
 <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b3ee104-ee6b-7147-0677-bd0eb4efe76e@kernel.dk>
Date:   Sun, 12 Jul 2020 14:32:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/20 11:34 AM, Pavel Begunkov wrote:
> On 12/07/2020 18:59, Jens Axboe wrote:
>> On 7/12/20 3:41 AM, Pavel Begunkov wrote:
>>> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
>>> drawback is adding extra kmalloc in draining path, but that's a slow
>>> path, so meh. It also frees some space for the deferred completion path
>>> if would be needed in the future, but the main idea here is to shrink it
>>> to 3 cachelines in the end.
>>>
>>> I'm not happy yet with a few details, so that's not final, but it would
>>> be lovely to hear some feedback.
>>
>> I think it looks pretty good, most of the changes are straight forward.
>> Adding a completion entry that shares the submit space is a good idea,
>> and really helps bring it together.
>>
>> From a quick look, the only part I'm not super crazy about is patch #3.
> 
> Thanks!
> 
>> I'd probably rather use a generic list name and not unionize the tw
>> lists.
> 
> I don't care much, but without compiler's help always have troubles
> finding and distinguishing something as generic as "list".

To me, it's easier to verify that we're doing the right thing when they
use the same list member. Otherwise you have to cross reference two
different names, easier to shoot yourself in the foot that way. So I'd
prefer just retaining it as 'list' or something generic.

> BTW, I thought out how to bring it down to 3 cache lines, but that would
> require taking io_wq_work out of io_kiocb and kmalloc'ing it on demand.
> And there should also be a bunch of nice side effects like improving apoll.

How would this work with the current use of io_wq_work as storage for
whatever bits we're hanging on to? I guess it could work with a prep
series first more cleanly separating it, though I do feel like we've
been getting closer to that already.

Definitely always interested in shrinking io_kiocb, just need to keep
an eye out for the fast(er) paths not needing two allocations (and
frees) for a single request.

-- 
Jens Axboe

