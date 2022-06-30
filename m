Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487C55623C0
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 22:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiF3UD0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 16:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbiF3UDZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 16:03:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BEE24F23
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:03:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h192so359594pgc.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u5IU+z7Tp8iSWkHksyzRiIwg+lXs7sDnfN+KwsNuP3s=;
        b=AYY6POjOEyjafAiRT/YuBSKCcu7C7CT86V/lG91qq3LKxNxIbuJyQOUMHoTUZVrrAy
         9tnRHqm/HpLN5Om+pkU6Rpt5oFC5gYDpluFhbvAizCfYd/Go9Gh4vY3NDIFJqyHasb0L
         UUOBDaLIvJIVLjHS5iL1kZ11ejOWInRR2QC6UOvg4Pm3EN6a7yoRJNThRgPXe8mHJ3xD
         p8AJWtuRye9Kgfj4rx3GKHse2NKgyAhuxez8OyIfdZ62yWuBHLJQDoJ6oEFKAYjGBEDv
         8Qok5j/kNPK97avIoyyvBpQst3phTMK18OYORFxE6OEoWf2k6NDdQTkJQRTUonIPnJR1
         IIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u5IU+z7Tp8iSWkHksyzRiIwg+lXs7sDnfN+KwsNuP3s=;
        b=3Dtv3gh1LU+vUwGp3xHVfRiDj/uso0kn+Tx8stJ0qq2AOeB4C0Rh9CGg2Db69FnxC4
         H4CXGjcfUXC8nlATIEswvRweNZP4GP9yebd7r8snXvHlolzLAkvhiFZWkIBk75KOmUG4
         yQjVJ1vFWBQB9/05MzRM+IZPfzhiEQvx8QWIFWPTEjBk2zt0U/Nac9rruO+stVi5Ye+2
         h0NEtiNR78Bjq0zxbv9msZOaiXR68Q2lDbFU2NnilyBHxIpg8o4hp0Zc9FLfBykVYbTQ
         Fo+uHuZr3UXNkKjqFSpbjCsZXf29vmFAEfgeFCbB0PkhJlfMr0DkpYBX64dTteXhgC5c
         h6lQ==
X-Gm-Message-State: AJIora93BphraZdEQximxqLdUFvmHL0OzSPUOekM46R2LXu+Ht4/dm4G
        w95l7k59Ms2Rd3Q8t+qYQYBByQ==
X-Google-Smtp-Source: AGRyM1sTbEShZ8NZ+xA89EEg1uvv9MlYKQl6LA7JlQLCGysRMzCgQiDdcAvSgcRqmn1ozyP0lO4qwA==
X-Received: by 2002:a63:e54e:0:b0:40d:5507:f471 with SMTP id z14-20020a63e54e000000b0040d5507f471mr9170821pgj.410.1656619403633;
        Thu, 30 Jun 2022 13:03:23 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 4-20020aa79244000000b005252a06750esm6458192pfp.182.2022.06.30.13.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 13:03:23 -0700 (PDT)
Message-ID: <8bfa6c8f-9bd0-f5a8-4b56-8e637dedeab1@kernel.dk>
Date:   Thu, 30 Jun 2022 14:03:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US
To:     Eli Schwartz <eschwartz93@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
 <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
 <a72fcfe9-cc9e-9ca0-9fc7-d97fe44d4599@gnuweeb.org>
 <6528f78f-3236-6964-127c-7c91b67b854b@gmail.com>
 <b51768ac-ee7b-5885-68b1-e4cf6d209e83@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b51768ac-ee7b-5885-68b1-e4cf6d209e83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 1:26 PM, Eli Schwartz wrote:
> On 6/30/22 11:18 AM, Pavel Begunkov wrote:
>> On 6/30/22 15:31, Ammar Faizi wrote:
>>> On 6/30/22 9:19 PM, Pavel Begunkov wrote:
>>>> Nobody cared enough to "fix" all tests to use those new codes, most
>>>> of the cases just return what they've got, but whatever. Same with
>>>> stdout vs stderr.
>>>
>>> That error code rule was invented since commit:
>>>
>>>     68103b731c34a9f83c181cb33eb424f46f3dcb94 ("Merge branch
>>> 'exitcode-protocol' of ....")
>>>
>>>     Ref: https://github.com/axboe/liburing/pull/621/files
>>>
>>> Thanks to Eli who did it. Eli also fixed all tests. Maybe some are still
>>> missing, but if we find it, better to fix it.
>>
>> Have no idea what you're talking about but I'm having
>> hard time calling 6 returns out of 21 in this file "all".
> 
> 
> Hi, I should probably clarify the state of affairs...
> 
> I submitted a patch series on github 4 days ago which implements those
> new codes. It was merged 2 days ago. This is very new code, so I think
> it's not completely 100% fair to say that no one "cared" enough to use it.
> 
> As far as the actual changes and their completion go... take a look at
> the commit messages in the merged patches, specifically take a look at
> commit ed430fbeb33367324a039d9cee0fd504bb91e11a.
> 
> """
> tests: migrate some tests to use enum-based exit codes
> 
> [...]
> 
> A partial migration of existing pass/fail values in test sources is
> included.
> """
> 
> You can also take a look at Github's equivalent of a cover letter, in
> which I mentioned that I haven't ported everything, but what I did do is
> still useful because "a) it has to start somewhere, b) it demonstrates
> the basic idea of how to structure things."
> 
> As far as I'm concerned, I believe the patch series stands on its own
> merit. I established the framework to use, and that on its own is useful
> and deserves merging, because it means that people can start using it,
> and getting things correct from the beginning when adding new code.
> 
> Old code does need to be carefully checked, it's not a simple
> find/replace, but that can be done incrementally, and I'm willing to
> continue work on that myself. I just don't think it has to be all or
> nothing at the time of merging.
> 
> 
> ...
> 
> Also, for the record -- while waiting for the Github patch series to be
> merged, I did continue to convert more code via git commit --fixup= &&
> git rebase -i --autosquash. If it had taken longer to end up being
> merged, I would have ended up converting more tests over, and that would
> have reflected on the current state of git master.
> 
> I'm not sad that it got merged when it was, because again, this work can
> be done incrementally and people can take advantage of existing work
> immediately. Jens decided it was ready to merge, and that seems like a
> fine decision to me. If he had asked me to finish porting all the tests
> first, I could have done that too.

And that was why I merged it, too. I think it's a step in the right
direction, and as long as you keep converting tests so we end up in a
cohesive state, then that's all good. I just did a liburing release and
it'll be at least few months before the next one, now is a good time to
shake up things like this.

Thanks for your work so far, looking forward to the next batch!

-- 
Jens Axboe

