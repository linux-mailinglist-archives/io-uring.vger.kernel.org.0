Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB1B2A8811
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 21:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgKEU1B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 15:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEU1A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 15:27:00 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA2BC0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 12:27:00 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id k21so3127664ioa.9
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 12:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7hU+/iN8KY4krvhRW3+B8ekBWzIjYhTP8ZJs/2BmNGo=;
        b=bR0fSiOYIYVXmE8TwYmOpaPK37mhtXTIyVy6aBqgjSihMRo2+qvY1AjRDyK5nOaqMr
         iSVFOKm6JYRdKSY+p/4nrj1F7pzktGFEu9Xr/lnfTIx66e3HXj9IQ3FUj4E3xx4JU+NL
         U0Q7yofZDsHkNk33UOa2jc50lKKj26g1Pd8b0+SJbnYsTqAsUGpJGEHLzeXAhax/dLxr
         uBghUjzw4Pwba3KnH+5Kd4ApTxdYByhXmAt5P6QfUZOUa49tjI1wbFkwxbqt2OIksFdr
         NaUcvdGOdvdgeuOMHQkuBRg8L7LnPeB/cvQuMhc6Qw3miVFWDnyqTi0C2JO5/+PZqtfq
         Ra8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7hU+/iN8KY4krvhRW3+B8ekBWzIjYhTP8ZJs/2BmNGo=;
        b=FBXDAuWDO2Ac+oc/M0WkfDymzOUd3XkWMcyFxK5ThA8Vl5IB3wErcDNptICoGegy7B
         uMcHLMaX3pOTp5R+zyT0A1gHG6p5kSTB37gUATBb+l/JGPL9j7HLTOaToJye72tAVeuX
         guiCh5g2FnUvz4dA3NoiJXCDTKPqFUG5MODfapHpVW0bzQtFqkWnzT56bYUSnodOqbde
         F0BOzvGdofgKWj9PmatAI86K/zHbjSUXcVNLcAv5WOOzYiWDQ8EXYoDjE+Kf11PAcJpw
         3kT2qCZ1WPWsM2KEHKnoY8KvJT1sp76ndK7va9It1Nc8k5qtOMKxwovAyY3DgGz08f/W
         jguA==
X-Gm-Message-State: AOAM530JhiYVmwf2G6S73ab8d/YPdphGzZITS9MJMIVpQ6V3+bzcoHMl
        py/H797SLBobJV74x6jDiYXR2K5VDmmemg==
X-Google-Smtp-Source: ABdhPJz+D285YWgOkHDOFmr63zrYbmeysS0u4MkooopO0aNixjcAKSxOG5Wy7gSt8jczuAMtBaM9DQ==
X-Received: by 2002:a5d:9284:: with SMTP id s4mr3193466iom.165.1604608019863;
        Thu, 05 Nov 2020 12:26:59 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h6sm1646956ils.14.2020.11.05.12.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 12:26:59 -0800 (PST)
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
Date:   Thu, 5 Nov 2020 13:26:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 1:04 PM, Pavel Begunkov wrote:
> On 05/11/2020 19:37, Jens Axboe wrote:
>> On 11/5/20 7:55 AM, Pavel Begunkov wrote:
>>> On 05/11/2020 14:22, Pavel Begunkov wrote:
>>>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>>> Hah, basically filename_parentat() returns back the passed in filename if not
>>> an error, so @oldname and @from are aliased, then in the end for retry path
>>> it does.
>>>
>>> ```
>>> put(from);
>>> goto retry;
>>> ```
>>>
>>> And continues to use oldname. The same for to/newname.
>>> Looks buggy to me, good catch!
>>
>> How about we just cleanup the return path? We should only put these names
>> when we're done, not for the retry path. Something ala the below - untested,
>> I'll double check, test, and see if it's sane.
> 
> Retry should work with a comment below because it uses @oldname
> knowing that it aliases to @from, which still have a refcount, but I
> don't like this implicit ref passing. If someone would change
> filename_parentat() to return a new filename, that would be a nasty
> bug.

Not a huge fan of how that works either, but I'm not in this to rewrite
namei.c...

> options I see
> 1. take a reference on old/newname in the beginning.
> 
> 2. don't return a filename from filename_parentat().
> struct filename *name = ...;
> int ret = filename_parentat(name, ...);
> // use @name
> 
> 3. (also ugly)
> retry:
> 	oldname = from; 

Not sure I follow - oldname == from, unless there's an error. Yes, this
depends on filename_parentat() returning oldname or IS_ERR(), but that's
how all the callers currently deal with it.

-- 
Jens Axboe

