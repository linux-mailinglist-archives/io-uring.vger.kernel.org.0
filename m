Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAF6243FFD
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 22:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMUlk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 16:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgHMUlj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 16:41:39 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7595AC061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 13:41:38 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q75so8789181iod.1
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 13:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JeKQEIsI+m9lrsQ8N8j8sbWZddsLa5CFhrA4d9dQeLo=;
        b=NDq+UwTkosKhP7HkcZFmBcOfzPR63twihNpX6rtHNW0eBEwFhQM/O5+g+N3HwF41QC
         +f2f/KlwCVIn7TqydFPFpXeNOHZqcdHavJlojRuflUlJkzOLmeiy2jjUrOyFEns66A4y
         kZy/nRZHWLz+bfAtChSuZTKA3OQU5cHGvxGfZYkvwN89DNWupq9u/MHM2E5jS0pZBMgp
         B+dN9w5A6zraDsuRobK+FHvZgaJBKDX7Icga0TCYzhWY7/tJPdXSMtWcoLvD94AuXiUF
         Gss/yvtAQgKgCEaTaPjTQYjNNx9W6B0KiW9uzqs4WOChlOFB/2rRE/8qdrCySMp4Awwr
         2l2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JeKQEIsI+m9lrsQ8N8j8sbWZddsLa5CFhrA4d9dQeLo=;
        b=mW9fGek5SdLC7zjLVXH5dCt6XVTKpPQnUOF1gq9L0pttRQhzcYb0+cOYKHDcAxFdq0
         mn+E/m9Nzvzoy5jjK406V7Y0BtFG1Kix6J7zHSt9KqZLerh64ZmdkibrPbAnG/Um2b6H
         Z2LB7d6UQTi+ftv4y9RuJqUE4Rhsa6afRN9Vbv3nIlvj1KZD4GuU8Dmdbhhe0MM2Z3iG
         dY+31hYgczreXQcHhlKyabdGPQE9cg5EtNj8ypOw/C9NI1tCJjZle9jPt/7qhr6Taxhh
         0JcZf/iMJ9JdS5IwF6IQ7MDgbwx6KiQhkcjOf5t4fhP9gSATD2Tsqh3EfJZTUjpayHiI
         FWVQ==
X-Gm-Message-State: AOAM531hLsryOYiGYsiusBsngys/NC3wm8B93HEtW/6bv8l6LHYeIK9w
        MeHLK0ELNffOGCne5IemFF+0fQ==
X-Google-Smtp-Source: ABdhPJxcuwniyK0QJ2qWqvncd6aXPLBF4/5KaSXjOaTMM6Gvhfu822bhzzigBgmcGCDTE6xi79IH/w==
X-Received: by 2002:a05:6638:13c5:: with SMTP id i5mr6798299jaj.29.1597351297466;
        Thu, 13 Aug 2020 13:41:37 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 25sm3430538ilv.85.2020.08.13.13.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 13:41:37 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
From:   Jens Axboe <axboe@kernel.dk>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
 <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
Message-ID: <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
Date:   Thu, 13 Aug 2020 14:41:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/20 2:37 PM, Jens Axboe wrote:
> On 8/13/20 2:33 PM, Jens Axboe wrote:
>> On 8/13/20 2:25 PM, Jeff Moyer wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> Since we've had a few cases of applications not dealing with this
>>>> appopriately, I believe the safest course of action is to ensure that
>>>> we don't return short reads when we really don't have to.
>>>>
>>>> The first patch is just a prep patch that retains iov_iter state over
>>>> retries, while the second one actually enables just doing retries if
>>>> we get a short read back.
>>>
>>> Have you run this through the liburing regression tests?
>>>
>>> Tests  <eeed8b54e0df-test> <timeout-overflow> <read-write> failed
>>>
>>> I'll take a look at the failures, but wanted to bring it to your
>>> attention sooner rather than later.  I was using your io_uring-5.9
>>> branch.
>>
>> The eed8b54e0df-test failure is known with this one, pretty sure it
>> was always racy, but I'm looking into it.
>>
>> The timeout-overflow test needs fixing, it's just an ordering thing
>> with the batched completions done through submit. Not new with these
>> patches.
>>
>> The read-write one I'm interested in, what did you run it on? And
>> what was the failure?
> 
> BTW, what git sha did you run?

I do see a failure with dm on that, I'll take a look.

-- 
Jens Axboe

