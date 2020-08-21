Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E861924CB79
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 05:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHUDmf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 23:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgHUDme (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 23:42:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7E0C061385
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 20:42:33 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so237562pjb.2
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 20:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MbPPwO/lu0/21Hp1yV4tOeorUhqZA3lzugzxFTUnq88=;
        b=eky+tYKr+tXQJOOAjx8zJmzMiSDVKeLr2qgXpOwc0Zq+iTniQVzVWvnwurMMGIEDQV
         BaRNxbnrHCiaXTA15cAqj6L1asAiyxOrxdckGgkLK8+3GOpTHTB2d+NN0OrF8Rd7QRAa
         1KObBe/smmUx0j2ibyGA/ADffYv53OND31hTFL+7YA8riE0f1LgWcyOuUVRREqFNJe8a
         uB7rIYbcfCQHHz+Eys28Hk8CTPHZ9caF+lHRK8xWrCZMSaSkufuHryjNeE5YS54pEuJI
         mPQ/pVPMQ2H7zBpo0zPoqLMwSZ/Jrf9eHbg1qF9OSwMorKMF0IVfbZ+137zeEFDBrkQA
         EesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MbPPwO/lu0/21Hp1yV4tOeorUhqZA3lzugzxFTUnq88=;
        b=reh1MbBOuA7FBhH6/RCtspPkRbE9gyADt5v2rF5nPuCALyHB8ZTLAURu02Qxp97E5R
         UpLG00pXgFef0rxKJlCqC6V4ZSp4GCwi96CBiA1tLXuBDZdQmhb7BP5GoZzPzpg3/nkJ
         hZUA+ZqjVLfG2uPynfMHrHN5uM2iFRXuyo3Id/Oun61MyBqxz7UsUfnSlyMvUp2cyZfM
         WBk+BSbeYXT58cTIAH0na2r7ynMICH8ucI790t3OGcb71vRFmGjLekrD2j5qaWxIxdzA
         8A6KeyVOtrstTplyRjJlFDUOFsav5tpYnqiCt/QexEGJ2oim/bxoA5kJO3i13aQF3nvT
         aKWw==
X-Gm-Message-State: AOAM5331iPXVzq2e+/9HRg4cE+682USxi2SKUNbewMlYcmgcmaYoLrBm
        CrueROdNq0aO+J6DCqNYv6xciQ==
X-Google-Smtp-Source: ABdhPJwwxb2xLK9+ID9iSqTmwartiaGN8gLLeA/Rvr06LgskevBSncd8OErZW+VFSOae8p2VoCBrbQ==
X-Received: by 2002:a17:902:b20d:: with SMTP id t13mr805274plr.312.1597981353357;
        Thu, 20 Aug 2020 20:42:33 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d1sm342425pjs.17.2020.08.20.20.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 20:42:32 -0700 (PDT)
Subject: Re: Poll ring behavior broken by
 f0c5c54945ae92a00cdbb43bdf3abaeab6bd3a23
To:     Glauber Costa <glauber.costa@datadoghq.com>
Cc:     io-uring@vger.kernel.org, xiaoguang.wang@linux.alibaba.com
References: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
 <8d8870de-909a-d05d-51a5-238f5c59764d@kernel.dk>
 <CAMdqtNWVRrej-57v+rXhStPzLBh7kuocPpzJ0R--A3AcG36YAQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f509999-bfe3-c99b-6e82-dc604865ce9e@kernel.dk>
Date:   Thu, 20 Aug 2020 21:42:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMdqtNWVRrej-57v+rXhStPzLBh7kuocPpzJ0R--A3AcG36YAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/20 8:24 PM, Glauber Costa wrote:
> On Thu, Aug 20, 2020 at 9:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/20/20 6:46 PM, Glauber Costa wrote:
>>> I have just noticed that the commit in $subject broke the behavior I
>>> introduced in
>>> bf3aeb3dbbd7f41369ebcceb887cc081ffff7b75
>>>
>>> In this commit, I have explained why and when it does make sense to
>>> enter the ring if there are no sqes to submit.
>>>
>>> I guess one could argue that in that case one could call the system
>>> call directly, but it is nice that the application didn't have to
>>> worry about that, had to take no conditionals, and could just rely on
>>> io_uring_submit as an entry point.
>>>
>>> Since the author is the first to say in the patch that the patch may
>>> not be needed, my opinion is that not only it is not needed but in
>>> fact broke applications that relied on previous behavior on the poll
>>> ring.
>>>
>>> Can we please revert?
>>
>> Yeah let's just revert it for now. Any chance you can turn this into
>> a test case for liburing? Would help us not break this in the future.
> 
> would be my pleasure.
> 
> Biggest issue is that poll mode really only works with ext4 and xfs as
> far as I know. That may mean it won't get as much coverage, but maybe
> that's not relevant.

And raw nvme too, of course. But I'd say coverage is pretty decent with
those two, in reality that's most likely what people would use for
polling anyway. So not too concerned about that, and it'll hit multiple
items in my test suite.

I reverted the change manually, it didn't revert cleanly. Please test
current -git, thanks!

-- 
Jens Axboe

