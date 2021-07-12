Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BD33C5D05
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 15:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhGLNRR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 09:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhGLNRQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 09:17:16 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F1BC0613DD;
        Mon, 12 Jul 2021 06:14:27 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id w13so11390447wmc.3;
        Mon, 12 Jul 2021 06:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3fEtIjBDPY2EjbWooFxk2PV3R4iK8JzyCJ370we96T0=;
        b=Wb8/539HhtBGisYRa2W1Xot1Yl3hVDzKygKDuAmfhGEFB3nWe982hDy5bSoNIbxkPx
         u3BJTtxVqk+ss3yb2zkS1fPVjvfmw0FD/7egxQy/jF/38vOIsE7U/Mmc7dAhHd24uksP
         EhY3BFF+DG6E8G5FKfBPhNKfcZ+U26m+7nQ2WEtr/fxtBJcBcLrj+3asyAUy5DCyW2bZ
         XdY1rlSGwGlCTHJ+Aw3n+sONa5ys/qK5CEWvUJuRhv+zpfPQMPmKZeQFE4/Ygzziolki
         /nP9b3BznEN2nPpUKvOv15mFWLeDO3cKZKnZOlkoKHtK7GngTl0+b8uw4ls9EP+JHfFU
         lE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3fEtIjBDPY2EjbWooFxk2PV3R4iK8JzyCJ370we96T0=;
        b=fqypgzJwZvOtPv8e3zi4bMZj9LZYfSNceY01As8qxEIyO2qKbZ82FlPqOPey0E4sTC
         pxCPEGFj1IZuew7q5+uTWc6NjknF1GMhfJUlww4dwZvhtXIgCHrbl1Z1Rb3exgT2d9rO
         YaNPahM2QmNIAgQcP4arqnJspW9xvZDS3UpQc+l8cFgpxR0tQvSED1FAUwWfibs73Fzx
         KHlMdwx/OUXkiB6FMGqO18Mdh9AnlJcaN92atyfEzJVo+TRQWyHOjS6eXnJSLDmJ+ev4
         PWyvzNkKC3sWDvPX94UV8YUOl8VHiwmFCroBnpn0BuBFraN1n+r90I2mZwF7AbKruKtQ
         7m8g==
X-Gm-Message-State: AOAM531cnOxf+/Qn1EzCP8Vkj7KLVR8nchTMJqZJFmYGssspUIlqKX1j
        pVVDdVt4yA6fufZhrmcRyeIUCNjvP2w=
X-Google-Smtp-Source: ABdhPJwYle9kapxe77XLkIBgriJCfmI1wbba++qp7w624EJJHvy0Z0+Y8htQe0EE0rL+MTVgSwsBAw==
X-Received: by 2002:a7b:ca43:: with SMTP id m3mr55004396wml.74.1626095666078;
        Mon, 12 Jul 2021 06:14:26 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.168])
        by smtp.gmail.com with ESMTPSA id g7sm1328033wmq.22.2021.07.12.06.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 06:14:25 -0700 (PDT)
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com>
 <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
 <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com>
 <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
 <b6ae2481-3607-d9f8-b543-bb922b726b3a@gmail.com>
 <CAOKbgA6va=89pLayQgC20QvPeTE0Tp-+TmgJLKy+O2KKw8dUBg@mail.gmail.com>
 <5a6e1315-4034-0494-878a-a417e8294519@gmail.com>
 <CAOKbgA4XirCKFxC8EzURBJsEVXRmVTeqza0Rf5PW=ifB2H80_A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <4a0bad22-8072-41d1-0f72-dc3afb6a91db@gmail.com>
Date:   Mon, 12 Jul 2021 14:14:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4XirCKFxC8EzURBJsEVXRmVTeqza0Rf5PW=ifB2H80_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/21 1:44 PM, Dmitry Kadashev wrote:
> On Wed, Jul 7, 2021 at 9:06 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 6/28/21 9:17 AM, Dmitry Kadashev wrote:
>>> On Thu, Jun 24, 2021 at 7:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> On 6/24/21 12:11 PM, Dmitry Kadashev wrote:
>>>>> On Wed, Jun 23, 2021 at 6:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>> On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
>>>>>>> I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
>>>>>>> the existing checks like this lack it too btw. I suppose I can fix those in a
>>>>>>> separate commit if that makes sense.
>>>>>>
>>>>>> When we really use a field there should be a READ_ONCE(),
>>>>>> but I wouldn't care about those we check for compatibility
>>>>>> reasons, but that's only my opinion.
>>>>>
>>>>> I'm not sure how the compatibility check reads are special. The code is
>>>>> either correct or not. If a compatibility check has correctness problems
>>>>> then it's pretty much as bad as any other part of the code having such
>>>>> problems, no?
>>>>
>>>> If it reads and verifies a values first, e.g. index into some internal
>>>> array, and then compiler plays a joke and reloads it, we might be
>>>> absolutely screwed expecting 'segfaults', kernel data leakages and all
>>>> the fun stuff.
>>>>
>>>> If that's a compatibility check, whether it's loaded earlier or later,
>>>> or whatever, it's not a big deal, the userspace can in any case change
>>>> the memory at any moment it wishes, even tightly around the moment
>>>> we're reading it.
>>>
>>> Sorry for the slow reply, I have to balance this with my actual job that
>>> is not directly related to the kernel development :)
>>>
>>> I'm no kernel concurrency expert (actually I'm not any kind of kernel
>>> expert), but my understanding is READ_ONCE does not just mean "do not
>>> read more than once", but rather "read exactly once" (and more than
>>> that), and if it's not applied then the compiler is within its rights to
>>> optimize the read out, so the compatibility check can effectively be
>>> disabled.
>>
>> Yep, as they say it's about all the "inventive" transformations
>> compilers can do, double read is just one of those that may turn very
>> nasty for us.
>>
>> One big difference for me is whether it have a potential to crash the
>> kernel or not, though it's just one side.
> 
> Ah, that makes sense.
> 
>> Compilers can't drop the check just because, it first should be proven
>> to be safe to do, and there are all sorts barriers around and
>> limitations on how CQEs and SQEs are used, making impossible to alias
>> memory. E.g. CQEs and SQEs can't be reused in a single syscall, they're
>> only written and read respectively, and so on. Maybe, the only one I'd
>> worry about is the call to io_commit_sqring(), i.e. for SQE reads not
>> happening after it, but we need to take a look whether it's
>> theoretically possible.
> 
> Thanks for the explanation, Pavel!

btw, that was for why we were rather reluctant about that. It could
be a good idea to add READ_ONCE as you mentioned, at least would be
less confusing. 

-- 
Pavel Begunkov
