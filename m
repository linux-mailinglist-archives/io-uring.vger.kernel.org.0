Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9603E4DEF
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 22:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhHIUfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhHIUfl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 16:35:41 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DD3C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 13:35:20 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j3so17895103plx.4
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 13:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pL8hZ6a2KhO1pQiZu5BQ5na5h8Qs/TLMDSBL/MTvOvo=;
        b=Tj2LN+PITyyOULLCMQay1eZh58Wb3PORfuafjaoI+EO3bPolgP1+C2ADc2Our8Vtik
         Ph2tcj3znh1jUuE3YqbU4i+e9IJHzH8P4zyFMO9RJ4mgCJcOVcpZtDvgbh4OGOgU0+n/
         QvB5t7wbDbCT/ftxI0+uY3dFdNN+h2yccYkcN/W32Ipr9xgf4NCcZ25mLRgLviFxNBcB
         d7DP3NE4zYHb1ju7HMpEZZrGCBa2LoHZfB6vNDjQMS1Z3BNjZMbRcvpi+xW7h783eICo
         EUnzY50dvU8fV3+lG0m4lkfFQTh97NAvZoqn4p3yTTlZLnHcho4LRWO8cAkhwRN9eVnt
         4VqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pL8hZ6a2KhO1pQiZu5BQ5na5h8Qs/TLMDSBL/MTvOvo=;
        b=NgJuZigxa4/BJ4WGMi4Kw5wHOGVvHjd9VEyR7dXjEDy7fgUXE+srK8/YS3WxJomi0f
         czZmPTC9uGuFnLCWj9Gj82DaOlp5OGZ+nnUphj/ZL/mXNLEe5JQBtFfH/b6cd3OB+Vju
         6+aS9FZqNH4rLuR4Tv8pkehyThcqjtI6FWHSDfYYT/n/z4twLucWHARkbojYgifDGf7N
         gEdGrjahsLnkq/ViIOoNNQJbbhM0eU3gPVnRecihjRdmAjqnaW45K2qB/2wyE8bB8fAl
         qXQmJPehLTekySiWGDnBYVDEHo9jIw6v/2oDGdvWy9uzKUxANIhvqdfwkSNi5lpRhm67
         DWHQ==
X-Gm-Message-State: AOAM533bUelT7D1uPQQoUUQVJql302GSAJF8uxQ6/26aDyBOnU0nl8Uv
        d7TfkPN3OGQrxyXfjjCkYMKtsHlnjTIarKBb
X-Google-Smtp-Source: ABdhPJxyKrGslEa47tbiPLg/PiitK82RVXxgGJ5MV6g4YloV4djWAY3qa0BJPtKxg87qmlnDE/XRCQ==
X-Received: by 2002:a17:90b:1d88:: with SMTP id pf8mr935019pjb.152.1628541319890;
        Mon, 09 Aug 2021 13:35:19 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g7sm20310228pfv.66.2021.08.09.13.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 13:35:19 -0700 (PDT)
Subject: Re: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
To:     Olivier Langlois <olivier@olivierlanglois.net>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-3-haoxu@linux.alibaba.com>
 <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
 <1f795e93-c137-439e-b02c-b460cb38bb14@linux.alibaba.com>
 <5f4b7861-de78-8b45-644f-3a9efe3af964@kernel.dk>
 <a7a07d78e8a24612c7afd4ada4a05d462798fb8b.camel@olivierlanglois.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e647901-5d4c-dc86-a28b-d08d2c521a3f@kernel.dk>
Date:   Mon, 9 Aug 2021 14:35:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a7a07d78e8a24612c7afd4ada4a05d462798fb8b.camel@olivierlanglois.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 2:19 PM, Olivier Langlois wrote:
> On Sat, 2021-08-07 at 07:51 -0600, Jens Axboe wrote:
>>
>> Please do - and please always run the full set of tests before
>> sending
>> out changes like this, you would have seen the slower runs and/or
>> timeouts from the regression suite. I ended up wasting time on this
>> thinking it was a change I made that broke it, before then debugging
>> this one.
>>
> Jens,
> 
> for my personal info, where is the regression suite?

It's the test/ portion of liburing, it's actually (by far) the biggest
part of that repo. For my personal use cases, I've got a bunch of
different devices (and files on various file systems) setup in the
configuration, and I run make runtests for all changes to test for known
cases that were broken at some point.

-- 
Jens Axboe

