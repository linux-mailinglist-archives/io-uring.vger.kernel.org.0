Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C491B5E98
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgDWPFx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 11:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728551AbgDWPFx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 11:05:53 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592EBC08E934
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:05:53 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p10so6689953ioh.7
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NA1MYMybq9+OrRo21SC40ZZ5q8t3VlT1DD1/SgEUExA=;
        b=b67th59n/Ohf77+YLJI6fnRl6S1KowNLhyL0SmYHw/hAMfhd1ZA0Fq9by+FjMp6pmg
         3r1ucV/awCt2NIHBCO1s5NfGUI0WraBhHM8e6RkETM/DqB5tvuzXYV5UdBaAiqvWRU2G
         N6/f5SdWqsvRPdW8EaeVeoISOs62oy8E0LTksSN6V3ECQPdtsjaRm5t/SekReDP/zSp5
         lJzQ7Mxm2lYAMR9wZ7Ieuq1sONpBESj8PUT1Rd6tbFQCaffuTYSPZU7ngQ4edX0nhzyz
         IpVmED66kF4zwJMg/r4IQCVma3JQQMyF885YCHAtnH4DGNwnPvrbh5WpUjGjpehI56iT
         5tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NA1MYMybq9+OrRo21SC40ZZ5q8t3VlT1DD1/SgEUExA=;
        b=OGM1nlEle09Sg+zd/wfYXps3uGHD46g7KaqRw7DRPuuoSMTuG0W2TPsYIrxelbq3FI
         MhV9Jey8RJ/3IWkqeM10aYhHARS5Y8ri8P22pJzUg1KWFxyV1PjO+3+gpFTTwtj7T2nP
         VPkrQNB+zIecIsWPyFnSPkGUjcR00qXm32BLPtEOiib7t9O59daZ9MuBFfM7xISzEGeO
         NbKyIyTyIOO/QoDH95IGtvyoWNAzbhq6/wAyFy60wZf/TB71ODUQez+7cYFxQLE+l4Bg
         g46dZs3XUs7PzczG9fDy/tvX0NMx4M+dMnxrSN3CD3JJOeRSgm7JsBUM93kAlP+PSeeO
         Mptg==
X-Gm-Message-State: AGi0PuZV1CmN5pdHkqG+be8T5J/LMp3IoVZ8RocDFRZm9W15zhqI3KNr
        jx29lmaJ4JTPO9JJxVzEPz8UvIZVz7uqjA==
X-Google-Smtp-Source: APiQypLTJheTMQ/OW+cL6K+mcxLUGWax6yaMarZiHP5mF7KQxzoi7N4arcjIkAygEKgERoigERQASw==
X-Received: by 2002:a05:6638:508:: with SMTP id i8mr3678116jar.137.1587654352137;
        Thu, 23 Apr 2020 08:05:52 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s12sm967708ill.82.2020.04.23.08.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:05:51 -0700 (PDT)
Subject: Re: io_uring_peek_cqe and EAGAIN
To:     William Dauchy <wdauchy@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20200420162748.GA43918@dontpanic>
 <2e16eecf-9866-9730-ee06-c7d38ac85aa4@kernel.dk>
 <CAJ75kXY1VLoqab4quz8RykbFrbXNJVBSAf7jv4t+u0_OquE1cQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc04aedf-a417-de72-9ee4-6aa1dbf18226@kernel.dk>
Date:   Thu, 23 Apr 2020 09:05:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAJ75kXY1VLoqab4quz8RykbFrbXNJVBSAf7jv4t+u0_OquE1cQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/20 8:42 AM, William Dauchy wrote:
> Hello Jens,
> 
> Thank you for your answer on this newbie question :)
> 
> On Wed, Apr 22, 2020 at 10:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>> I don't think the change is correct. That's not saying that the original
>> code is necessarily correct, though! Basically there are two cases there:
>>
>> 1) We haven't gotten a completion yet, we'll wait for it.
>> 2) We already found at least one completion. We don't want
>>    to _wait_ for more, but we can peek and see if there are more.
>>
>> Hence we don't want to turn case 2 into a loop, we should just
>> continue.
> 
> ok so in fact I think I understand that my usage is incorrect:
> 1- if I'm in the case of being able to do other things while waiting
> for data available using `io_uring_peek_cqe`, I should use it and come
> back later when getting a -EAGAIN.
> 2- it is useless to do a loop on `io_uring_peek_cqe` because in that
> case, I should simply do a `io_uring_wait_cqe`
> 
> is that correct?

Right, you rarely want to busy loop on io_uring_peek_cqe(), the normal
use case would be to use io_uring_wait_cqe() if you need to wait for a
completion to become available.

>> How is it currently failing for you?
> 
> While trying to open/read/close multiple files, I first thought that,
> because I had one successful `io_uring_wait_cqe`, I could then loop on
> `io_uring_peek_cqe` and get all my data. I now realise my assumption
> was completely wrong and this example was just written that way to
> show two different possibilities of getting results.

Ah ok, yes that sounds like a misunderstanding. Events are posted as
they become available, availability of one does not mean that everything
has completed.

-- 
Jens Axboe

