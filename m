Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0375869153F
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 01:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBJAP6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 19:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBJAP5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 19:15:57 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0CE5DC3F
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 16:15:56 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id iz19so3426289plb.13
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 16:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1675988155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tNPbNYoCct7d8eWLCTkz69o5QdTPIXkMuLL30IOxMRg=;
        b=f/XkvHql8tA6g9Cwp0u4jf8f7Qc7FIeFETTNtvSG78+1PpDL1dUGRltWrU0WGseC2f
         mDxL9UuS7jf0nQ5VXmX2WYUeMJX2fbUos36ISufxoZKygSb6hJZzBjnoRRV7OxXVyxyS
         M7zeWiG1IjpRvcHqDAm4O6OD4wpBHUKty7+4YHhYQ9TeLCBGbO00pUEPxKPHnPLEq5Tj
         5yGd2jb/pIPponyzOm4vV8cOYitmD2Fb4fV30wo+wSI1bm5PFh6GSuqtZx8L2cGpMFxk
         qZ3MZJjgdq+ZhZsCQ5d34PmZeyi/8LfyVoIiJWWmJP2zmz8z6rvUXdqqhXhq/AGNhx/v
         nqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1675988155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tNPbNYoCct7d8eWLCTkz69o5QdTPIXkMuLL30IOxMRg=;
        b=68+HM86JdUJcjoBAymq0N7YtTxvWcm+20woxI/aQ+ucuNy74L9rZJKLedzZsYp8MLn
         +Dnei5lYFEVllMh7aptgfU8Ci9GfmfzObVs15ZMvJKmqs5WOcPPNG/barEzZAER1DdXE
         rNv4AGtM1h1nX6qDGCG5mTnBPv73hk4QDBTjxDwJQZTBEBQHE+HbnRT3Lf0JxOhbi/ZM
         FOEsvm8S8EaXwIaNX6PE4vfF+yT8wwAYlVuA7qKgyJEbcby7x0UPa9qQJbtmssHkLFs+
         Z6pSZSPYEfucj9bwSa2XB7I90X/CwgUr3RdusC/o5YNpY4+N3W7KOYCmUvIKgtDSOfDM
         NlBw==
X-Gm-Message-State: AO0yUKVw5LbXagIuKesGM6oFx72EhMHRidgm7dDE7asDTK6PH+Y8awmR
        vPMkQom55dTXG1bgexJrwL9NIA==
X-Google-Smtp-Source: AK7set9i4GZy425eJQ60VEHt8ZyiMscBINILO96QjW9OdkxX3UWegtHHMx/XPbkaa3kfxkBKfne7wA==
X-Received: by 2002:a17:903:32c3:b0:199:4362:93f6 with SMTP id i3-20020a17090332c300b00199436293f6mr9399565plr.4.1675988155556;
        Thu, 09 Feb 2023 16:15:55 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jj5-20020a170903048500b00198d5c7cafasm2109067plb.156.2023.02.09.16.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 16:15:55 -0800 (PST)
Message-ID: <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
Date:   Thu, 9 Feb 2023 17:15:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Content-Language: en-US
To:     Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca>
 <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <13293926.uLZWGnKmhe@x2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/23 3:54 PM, Steve Grubb wrote:
> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>>> On 2023-02-01 16:18, Paul Moore wrote:
>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com> 
> wrote:
>>>>> fadvise and madvise both provide hints for caching or access pattern
>>>>> for file and memory respectively.  Skip them.
>>>>
>>>> You forgot to update the first sentence in the commit description :/
>>>
>>> I didn't forget.  I updated that sentence to reflect the fact that the
>>> two should be treated similarly rather than differently.
>>
>> Ooookay.  Can we at least agree that the commit description should be
>> rephrased to make it clear that the patch only adjusts madvise?  Right
>> now I read the commit description and it sounds like you are adjusting
>> the behavior for both fadvise and madvise in this patch, which is not
>> true.
>>
>>>> I'm still looking for some type of statement that you've done some
>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
>>>> up calling into the LSM, see my previous emails on this.  I need more
>>>> than "Steve told me to do this".
>>>>
>>>> I basically just want to see that some care and thought has gone into
>>>> this patch to verify it is correct and good.
>>>
>>> Steve suggested I look into a number of iouring ops.  I looked at the
>>> description code and agreed that it wasn't necessary to audit madvise.
>>> The rationale for fadvise was detemined to have been conflated with
>>> fallocate and subsequently dropped.  Steve also suggested a number of
>>> others and after investigation I decided that their current state was
>>> correct.  *getxattr you've advised against, so it was dropped.  It
>>> appears fewer modifications were necessary than originally suspected.
>>
>> My concern is that three of the four changes you initially proposed
>> were rejected, which gives me pause about the fourth.  You mention
>> that based on your reading of madvise's description you feel auditing
>> isn't necessary - and you may be right - but based on our experience
>> so far with this patchset I would like to hear that you have properly
>> investigated all of the madvise code paths, and I would like that in
>> the commit description.
> 
> I think you're being unnecessarily hard on this. Yes, the commit message 
> might be touched up. But madvise is advisory in nature. It is not security 
> relevant. And a grep through the security directory doesn't turn up any 
> hooks.

Agree, it's getting a bit anal... FWIW, patch looks fine to me.

-- 
Jens Axboe


