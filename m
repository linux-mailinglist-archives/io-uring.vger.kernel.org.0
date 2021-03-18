Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC87433FCF5
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 02:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhCRB7P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 21:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCRB6r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 21:58:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB11C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 18:58:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t20so484580plr.13
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 18:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=23hDjiDr6dOC6qpQTBiXHAkrBttU7LaznfUpSLfV5mE=;
        b=j/YvT6mWycCXCDGME/+oXrSDLQ5unOMr3ChK1dfLau26ExbG3SQMJmBSkMHQM9oLQP
         N017A52YqvgtolsiEfjmL/LYqzNJGXkI9HKqc7yqVmXW8chU3jFvJKDhC3lItHH6Mo3x
         oO4m5qV5rA0UmjA204xfj3k7Xao33W4kD4ZzWZ0AijL8m0E+CwiW6tMD6laA6+RZUbmd
         nQbY3x9l4kPvfbbkO75akOZu3/pWx5ORAK0CI4DoMS6DFMzgIDYMji/EOLfIGFoeRsX7
         KU7wMklpOnLPkq2iGMFmk22rgRFwtk7yLrrpsoWYaNKLn6uKOU+YUC3y7vkfUQjuNkTe
         w9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=23hDjiDr6dOC6qpQTBiXHAkrBttU7LaznfUpSLfV5mE=;
        b=VQBxH/ynZ6S49rj4YJwrP4alo0KDhaHXS2V9S+OsvMkaFyshGVaEAPV5sAHcgqD2fT
         2oWpMhzLVBqiXuRgUbDk2n3PIrT9HtSywCgZ1qpJnW0Ppj+yFgg85/1wVgV/rTCvnG1Q
         7L8MwDHHRBw/YNBpfgiJTLYiADjkoiaReXX0NMtRDEncsLkTryUAbqcpt5Zrsx092Ir6
         iNkUbhIWWAcq4jmL7k0TICFIxiWtD+43EgVuRkOTh6gmPWL23/MSHwnErnMdSSNVf/+J
         ItRXTIupGbnxYQDqb5RAg/7hcRY9OD1PNfKpWLa5XUfagVJMwdQO/QNhcCNDD9Hol0cJ
         JX8Q==
X-Gm-Message-State: AOAM533S7F31aYbmj/TuaVCnkSZx9Wcm8kX0bB0w8jCgQiytnJVTgTk0
        FONdnRphh9SjNCfziZ+nU7gjFQ==
X-Google-Smtp-Source: ABdhPJx8r1dmMYTB0XGagKLwOwWeb2T4iBlofj2quYfLLc0ruDUVcIQHHBPcdrKrf72BTXv2VPvAOg==
X-Received: by 2002:a17:902:70c5:b029:e6:cba1:5d94 with SMTP id l5-20020a17090270c5b02900e6cba15d94mr4444301plt.84.1616032726909;
        Wed, 17 Mar 2021 18:58:46 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w188sm324224pfw.177.2021.03.17.18.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 18:58:46 -0700 (PDT)
Subject: Re: [RFC PATCH v3 0/3] Async nvme passthrough over io_uring
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
References: <CGME20210316140229epcas5p23d68a4c9694bbf7759b5901115a4309b@epcas5p2.samsung.com>
 <20210316140126.24900-1-joshi.k@samsung.com>
 <b5476c77-813a-6416-d317-38e8537b83cb@kernel.dk>
 <CA+1E3rLOOaggA0p5wr5ndTWx42zjebCeEm5XzfOq7QcH6oP=wA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <63a127c2-e2ed-ad5f-a6d3-8d56e3e95380@kernel.dk>
Date:   Wed, 17 Mar 2021 19:58:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rLOOaggA0p5wr5ndTWx42zjebCeEm5XzfOq7QcH6oP=wA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 3:31 AM, Kanchan Joshi wrote:
> On Tue, Mar 16, 2021 at 9:31 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/16/21 8:01 AM, Kanchan Joshi wrote:
>>> This series adds async passthrough capability for nvme block-dev over
>>> iouring_cmd. The patches are on top of Jens uring-cmd branch:
>>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v3
>>>
>>> Application is expected to allocate passthrough command structure, set
>>> it up traditionally, and pass its address via "block_uring_cmd->addr".
>>> On completion, CQE is posted with completion-status after any ioctl
>>> specific buffer/field update.
>>
>> Do you have a test app? I'd be curious to try and add support for this
>> to t/io_uring from fio just to run some perf numbers.
> 
> Yes Jens. Need to do a couple of things to make it public, will post it today.

Sounds good! I commented on 1/3, I think it can be simplified and
cleaned up quite a bit, which is great. Then let's base it on top of v4
that I posted, let me know if you run into any issues with that.

-- 
Jens Axboe

