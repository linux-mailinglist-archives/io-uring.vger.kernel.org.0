Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B94717996C
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 21:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDUAJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 15:00:09 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36800 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgCDUAJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 15:00:09 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so3823094iog.3
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 12:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H/xKp/HPM+VmlYXpi9gZMIwT8DQdAbp89Q3flfwKpwo=;
        b=CkwG2xJt8ElDLAegfrFpmphbcdqm+UshyGQ8ca+IOjXR6KHypRCfVV/asP4iUisEST
         mmbb2/ZU9LZno7cc3e0/ugrJBrvPJtvBt2asrJy2+05iDGxO8kcJp/Bs36MRNFg5tE6p
         NuipXuNGqehiVJLCQpyHM/vOHQZNGyFW5Aab+BdkbbKbw51lYdAP5kUqjR6pwCAvX+yo
         LOKbsXr8JCMG1JXlT3Zrjf3JZuYRlXyRwDMSTPjzcMVgRcdmmLVzRp+krI2HrZvbHzRo
         8RijyER/gX8P8x0RUe2XbFJ7+2mLKGclrQ/56hT2TYBDdTI+cDD92n0q35HbhLV9UEF9
         1HCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H/xKp/HPM+VmlYXpi9gZMIwT8DQdAbp89Q3flfwKpwo=;
        b=Oj+q8I/eL89R2tqlyjbD8wOdDWVy7gm/QgQOGtdhVJytF8GAaYQ3qVrmt1ktGg/M/f
         XorJzpck70RrOBE26jqzXHqTNtO/tBk7nZC7iimNgDVXTH09wSQNf0oMSnrsYv0QvCCe
         5lMhlbzU1TfTKThRMreJBrSrUdWN57/etBWBaFpd/nrX6YJ5eoGnB8bp74B1KqKJTXD0
         gMZyArJxZrAPnHMBuY7nuQhblRhRplG6kvB3MwxXKujODJN+IwUas9EGGc9gNWUoZH3j
         eLsefSe2zm7NehyTrJnkSxw2K9kqZZnqTZPTV4oX4WDsEhNL8w3/2AgG9gxyKWnDJGhQ
         dwdg==
X-Gm-Message-State: ANhLgQ22dlPnjFJWRSoxYsi3OH5A/mezfgk4AVFnhO3lf3+uRRHC+XBj
        XKG7I62ieeqZukNfDMfG3UimBA==
X-Google-Smtp-Source: ADFU+vuQPh3aEaJg4grxxQK00mhCcWBX3mc6K4LyBl183P5M6a8OAGx96EIh5zoLPo3ZEx1JwVMS5A==
X-Received: by 2002:a02:3b4a:: with SMTP id i10mr4325967jaf.131.1583352007072;
        Wed, 04 Mar 2020 12:00:07 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u15sm5843885iog.15.2020.03.04.12.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 12:00:06 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] Support selectable file descriptors
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304190341.GB16251@localhost>
 <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
 <20200304195642.GB16527@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed5c490f-4faf-afc7-bfab-d58aed061fc6@kernel.dk>
Date:   Wed, 4 Mar 2020 13:00:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304195642.GB16527@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 12:56 PM, Josh Triplett wrote:
> On Wed, Mar 04, 2020 at 12:10:08PM -0700, Jens Axboe wrote:
>> On 3/4/20 12:03 PM, Josh Triplett wrote:
>>> On Wed, Mar 04, 2020 at 11:00:10AM -0700, Jens Axboe wrote:
>>>> One of the fabled features with chains has long been the desire to
>>>> support things like:
>>>>
>>>> <open fileX><read from fileX><close fileX>
>>>>
>>>> in a single chain. This currently doesn't work, since the read/close
>>>> depends on what file descriptor we get on open.
>>>>
>>>> The original attempt at solving this provided a means to pass
>>>> descriptors between chains in a link, this version takes a different
>>>> route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
>>>> what fd value we're going to get out of open (or accept). With that in
>>>> place, we don't need to do any magic to make this work. The above chain
>>>> then becomes:
>>>>
>>>> <open fileX with fd Y><read from fd Y><close fd Y>
>>>>
>>>> which is a lot more useful, and allows any sort of weird chains without
>>>> needing to nest "last open" file descriptors.
>>>>
>>>> Updated the test program to use this approach:
>>>>
>>>> https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select
>>>>
>>>> which forces the use of fd==89 for the open, and then uses that for the
>>>> read and close.
>>>>
>>>> Outside of this adaptation, fixed a few bugs and cleaned things up.
>>>
>>> I posted one comment about an issue in patch 6.
>>>
>>> Patches 2-5 look great; for those:
>>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>>
>>> Thanks for picking this up and running with it!
>>
>> Thanks for doing the prep work! I think it turned out that much better
>> for it.
>>
>> Are you going to post your series for general review? I just stole
>> your 1 patch that was needed for me.
> 
> Since your patch series depends on mine, please feel free to run with
> the series. Would you mind adding my patch 1 and 3 at the end of your
> series? You need patch 1 to make this more usable for userspace, and
> patch 3 would allow for an OP_PIPE which I'd love to have.

Let me add patch 1 to the top of the stack, for the pipe part that
probably should be taken in separately. But not a huge deal to me,
as long as we can get it reviewed.

I'll post the series broader soon.

> Do you plan to submit this during the next merge window?

Maybe? In terms of timing, I think we're well within the opportunity
to do so, at least.

-- 
Jens Axboe

