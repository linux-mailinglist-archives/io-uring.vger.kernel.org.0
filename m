Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F8D39A4F5
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 17:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFCPsU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 11:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCPsT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 11:48:19 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227C8C06174A
        for <io-uring@vger.kernel.org>; Thu,  3 Jun 2021 08:46:19 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d1so2960362ils.5
        for <io-uring@vger.kernel.org>; Thu, 03 Jun 2021 08:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8YcBVNckt87HVYyLs2knwYKQtGbIl14b368u5y324YQ=;
        b=setdzS9B3oPv5TR64ZzJpXvy218Ig4yMo8+Wy9C0kPdW1q8LGlAGFyXNxRnXbfvEhS
         +Bmr0XHw07v0DQTioERnt//X4juNuOp0fWuQ9eB9gPm4dhftvw68gqPLw+dGu+LTHi5b
         jp6RKvpfi94saetnUGvJrRoPpgAKA+xuqhnshGB+9sqbq83FqClV5BY59VEZxkR5tmIE
         H+bp7hroUyDn7yP6ALI7sugX6ZqrNN1pvJMc4ptXGDI9W0tlvbouIkmy+7ndm3P3sARk
         DuOWwJztAI5fFacGPug4ZQbNM3K1I/RoOjfjrt0uf63IoY0StEZ9iIZNONyVx1h5x1qH
         dSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8YcBVNckt87HVYyLs2knwYKQtGbIl14b368u5y324YQ=;
        b=mt5uEyJj9+/W6CXkSgrf9M+wefRM+XSElblevbxKB520MRLHqALtNqd6rP+krpNAHx
         fhaBp01+UPTVo3tXWobIcxL7tWieHffaUHv2aMMSbR7JSeBtQA/AjKs/l4xyPi4jrOq4
         hgKyNzLBFg5cL5jNCVR1kKA4HfZaILjFlfcpX/WTtZIbBOe1k/1ZcQITzEao6L/5sD8F
         v6XFuptLD2K13um91V2NAwASWnBU5Vbzlc18LyGtho4jmCZaEwCOsCNy/Ya6J/tlYWY2
         rR9MT81qQccS0iH496dwaEtdZGzE56Mx9WLkp89/4AJL9PCubdG85okWqKzOMUCYtXlv
         XU6g==
X-Gm-Message-State: AOAM532wmuPjP2uRchgMSKMweOpKV/ustwIlkjHdn1q9QvxczfNLJQQ+
        jTGmYBtDcJqPT3xmwrvMTcMqNw==
X-Google-Smtp-Source: ABdhPJw4z+lsn3Ie3mWZtiwjDbIktt/3jyiRQtJbj9iC7+2VghLkIgzAaWCsQonUtFffb6lfD4Edjw==
X-Received: by 2002:a92:3610:: with SMTP id d16mr42958ila.16.1622735178319;
        Thu, 03 Jun 2021 08:46:18 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p81sm1890651iod.0.2021.06.03.08.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 08:46:17 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Remove CONFIG_EXPERT
To:     Justin Forbes <jmforbes@linuxtx.org>,
        Justin Forbes <jforbes@redhat.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210526223445.317749-1-jforbes@fedoraproject.org>
 <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk>
 <CAFbkSA1G2ajKQg4eA947dv0Pcmyf-JQbkn8-jYnmUeMAEpfHtw@mail.gmail.com>
 <01c2a63f-23f6-2228-264d-6f3e581e647d@kernel.dk>
 <CAFbkSA2zt5QLBH0S8pcBROCaV3zSw_M-RvaQ-2yccCKgV-_2BQ@mail.gmail.com>
 <CAFxkdAqK+JyBysxYwUp8BAuQcjkdOpJ=kA_QNVJMTzGez10HVA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <73673ab9-9ec7-611f-b1f0-5394cd7a172c@kernel.dk>
Date:   Thu, 3 Jun 2021 09:46:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFxkdAqK+JyBysxYwUp8BAuQcjkdOpJ=kA_QNVJMTzGez10HVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 9:43 AM, Justin Forbes wrote:
> On Thu, May 27, 2021 at 11:01 AM Justin Forbes <jforbes@redhat.com> wrote:
>>
>> On Thu, May 27, 2021 at 9:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 5/27/21 8:12 AM, Justin Forbes wrote:
>>>> On Thu, May 27, 2021 at 8:43 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 5/26/21 4:34 PM, Justin M. Forbes wrote:
>>>>>> While IO_URING has been in fairly heavy development, it is hidden behind
>>>>>> CONFIG_EXPERT with a default of on.  It has been long enough now that I
>>>>>> think we should remove EXPERT and allow users and distros to decide how
>>>>>> they want this config option set without jumping through hoops.
>>>>>
>>>>> The whole point of EXPERT is to ensure that it doesn't get turned off
>>>>> "by accident". It's a core feature, and something that more and more
>>>>> apps or libraries are relying on. It's not something I intended to ever
>>>>> go away, just like it would never go away for eg futex or epoll support.
>>>>>
>>>>
>>>> I am not arguing with that, I don't expect it will go away. I
>>>> certainly do not have an issue with it defaulting to on, and I didn't
>>>> even submit this with intention to turn it off for default Fedora. I
>>>> do think that there are cases where people might not wish it turned on
>>>> at this point in time. Hiding it behind EXPERT makes it much more
>>>> difficult than it needs to be.  There are plenty of config options
>>>> that are largely expected default and not hidden behind EXPERT.
>>>
>>> Right there are, but not really core kernel features like the ones
>>> I mentioned. Hence my argument for why it's correct as-is and I
>>> don't think it should be changed.
>>>
>>
>> Honestly, this is fair, and I understand your concerns behind it. I
>> think my real issue is that there is no simple way to override one
>> EXPERT setting without having to set them all.  It would be nice if
>> expert were a "visible if" menu, setting defaults if not selected,
>> which allows direct override with a config file. Perhaps I will try to
>> fix this in kbuild.
>>
> 
> So it turns out that untangling this in kbuild is very difficult
> without getting very unexpected results. Given the audit and security
> discussions around io_uring lately, I am inclined to believe the
> proper action is still to remove 'if EXPERT'.

I'm still going to disagree with that. In terms of security, io_uring
is in a much better spot than it was in the past. Arguably it should have
been easier to turn off when it went in, but that ship has sailed a long
time ago and the need now isn't really there imho. The lack of audit
isn't new and is something that'll be solved for the next release.

-- 
Jens Axboe

