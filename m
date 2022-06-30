Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B890562317
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiF3T1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 15:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiF3T1U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 15:27:20 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA57A377FF
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 12:27:19 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id 9so38446ill.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 12:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bayf2HDl1Jki7C3Ocgvyte2ZIeOtJDGJJ9I66cZiZaE=;
        b=qZdo1H2JY7BuGfGZUKd2Ftt50kt253kcS536yl2Bp/yI8INQ+sDPeNY6mhlGggfR3/
         E4R0asYNefGskej6aLzw8F8H01ujqix8oPrlRkS98yudaAjijvYwAv0ldp82nLfsugih
         BL3hkLbtV22ptybcdoWdky+5+w+tbY81B/Y+Xz9DJmnl0JOo41fXlXCUUhdUOtrDR+sj
         o8ssnHBX8IDlvITeH8mgQyCfFW2IYmcZMk+vAO6HTBRS2OEYtNAj51rY6+ScoJIVxH13
         ds3VX10Y5fBiMKBOGXWKPYQ/s3Ux/3nXdYFIQ2BKoUtWsUk6VfXoVZETXxd+xGxBgg3X
         ZcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bayf2HDl1Jki7C3Ocgvyte2ZIeOtJDGJJ9I66cZiZaE=;
        b=ezqhIX81y+EareKnsBx+ZLCrQ1FsGqTUTpigoOx09w2cckKqRwIpMoQp+tjwhaZBL2
         a6ipP0uZ3NowFvE+8NPWFOLQnxlGCeWLZnZZRHTiUHXGnhm7BvCRt89lIqf/mOleJzN1
         HB8rhh883iBJsHOHaNvxZ3YkMQbDmG5TOv8acsbMhanzZA4WtMCUKqooR4wRTGuN/BqO
         fQGxlfsRryiPkcRaq4x14Fm+VaPwaAFKRjPqRlakl/xzjDK/2REni/JHuYMwrc4lMOf0
         JoYgMWeFrQGao0YmsUc4iMr51jy7EFzXG9vppHxW1mm31fXsc2HcEr8gUiC2BLzPKIMd
         rjxA==
X-Gm-Message-State: AJIora9/jsWajq8LGaWPlwuv6dyDUMdatlRMx0ehhvuqQXRmQrXywyR+
        P1yFFoIrpjEOyI757p2Z6iZ3IWQXRS/748jO
X-Google-Smtp-Source: AGRyM1tpE7uNUIhFhH2rIjYzbHSb+jJC3CbQ6hqUoqiLc8R3HLm9IAQCobxqWYfgZBhmbGBQYxjA+Q==
X-Received: by 2002:a05:6e02:17c9:b0:2da:9659:689 with SMTP id z9-20020a056e0217c900b002da96590689mr6120211ilu.72.1656617238940;
        Thu, 30 Jun 2022 12:27:18 -0700 (PDT)
Received: from ?IPV6:2600:1700:57f0:ca20:763a:c795:fcf6:91ea? ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id y20-20020a6bd814000000b006751347e61bsm8120783iob.27.2022.06.30.12.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 12:27:18 -0700 (PDT)
Message-ID: <b51768ac-ee7b-5885-68b1-e4cf6d209e83@gmail.com>
Date:   Thu, 30 Jun 2022 15:26:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US-large
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
 <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
 <a72fcfe9-cc9e-9ca0-9fc7-d97fe44d4599@gnuweeb.org>
 <6528f78f-3236-6964-127c-7c91b67b854b@gmail.com>
From:   Eli Schwartz <eschwartz93@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
In-Reply-To: <6528f78f-3236-6964-127c-7c91b67b854b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 11:18 AM, Pavel Begunkov wrote:
> On 6/30/22 15:31, Ammar Faizi wrote:
>> On 6/30/22 9:19 PM, Pavel Begunkov wrote:
>>> Nobody cared enough to "fix" all tests to use those new codes, most
>>> of the cases just return what they've got, but whatever. Same with
>>> stdout vs stderr.
>>
>> That error code rule was invented since commit:
>>
>>     68103b731c34a9f83c181cb33eb424f46f3dcb94 ("Merge branch
>> 'exitcode-protocol' of ....")
>>
>>     Ref: https://github.com/axboe/liburing/pull/621/files
>>
>> Thanks to Eli who did it. Eli also fixed all tests. Maybe some are still
>> missing, but if we find it, better to fix it.
> 
> Have no idea what you're talking about but I'm having
> hard time calling 6 returns out of 21 in this file "all".


Hi, I should probably clarify the state of affairs...

I submitted a patch series on github 4 days ago which implements those
new codes. It was merged 2 days ago. This is very new code, so I think
it's not completely 100% fair to say that no one "cared" enough to use it.

As far as the actual changes and their completion go... take a look at
the commit messages in the merged patches, specifically take a look at
commit ed430fbeb33367324a039d9cee0fd504bb91e11a.

"""
tests: migrate some tests to use enum-based exit codes

[...]

A partial migration of existing pass/fail values in test sources is
included.
"""

You can also take a look at Github's equivalent of a cover letter, in
which I mentioned that I haven't ported everything, but what I did do is
still useful because "a) it has to start somewhere, b) it demonstrates
the basic idea of how to structure things."

As far as I'm concerned, I believe the patch series stands on its own
merit. I established the framework to use, and that on its own is useful
and deserves merging, because it means that people can start using it,
and getting things correct from the beginning when adding new code.

Old code does need to be carefully checked, it's not a simple
find/replace, but that can be done incrementally, and I'm willing to
continue work on that myself. I just don't think it has to be all or
nothing at the time of merging.


...

Also, for the record -- while waiting for the Github patch series to be
merged, I did continue to convert more code via git commit --fixup= &&
git rebase -i --autosquash. If it had taken longer to end up being
merged, I would have ended up converting more tests over, and that would
have reflected on the current state of git master.

I'm not sad that it got merged when it was, because again, this work can
be done incrementally and people can take advantage of existing work
immediately. Jens decided it was ready to merge, and that seems like a
fine decision to me. If he had asked me to finish porting all the tests
first, I could have done that too.

More will get done in short order. I'm not even a bottleneck for doing
it. :)

(Though I will work on it.)


-- 
Eli Schwartz
