Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D2714AAB2
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 20:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0TqD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 14:46:03 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43231 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0TqD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 14:46:03 -0500
Received: by mail-pf1-f175.google.com with SMTP id s1so4776400pfh.10
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 11:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AMiB34qPrsgVur7/Oczyoyile7nFSq59WUMc2tT0+ak=;
        b=eBuHkURCND55CxoWp7hIlpIvNs0yRQzo0mgrMdx19EEUOPchqvtbrOjO5RPMMhz00+
         iQYzxKuSBpV8hjmkU/4XELwvWgeFNgbvDkVRBuvN2Yj+e6ZUCSEICDWRdpEinolIw/k2
         1qJ6X3af6Ic3lA1Acbs7fD93xb0GkldKp3fXdOEhWGvaShhZbQmxNj2ITfKTDqL3oXg/
         oWKybJLBO+Jg6TYYHW44Xt2jEdX9B39GpIrlYDg7Pmr/bIYsIRAf9fOkJdj+FY7smVuu
         B1uwTTlTLSEWf2rkq+8RFijX0eNgAQSl1IxTcS8HoWIAa118ZBeJzWgY8JSr8hdsvXFu
         tb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AMiB34qPrsgVur7/Oczyoyile7nFSq59WUMc2tT0+ak=;
        b=Qa/iM0z8Uz151x6cWXAAd09mxwhp2LPDKqUI9TwtOZ3CZsXxcJmV+KTaKgtsFkVdUC
         YQUKUYlqX1fGUfBiUx5dgUKByyrUGrJPSbtyZBYAq+HeH+MvL52dMYU9TUKQMVlVqPI5
         CTJspQUcbt3VOVRG2LJMZ02919lFNwPRPvmBBbiLcXULG2XIkdTVKCgUjAWSP2m6yAfn
         WBYjZJUmjE39MES2RfJVyY04Ms6pYeLWAWOWZPKtPgWYjwNOJuEYcw14kiSQ20wpUq7G
         YaHgY0W9BUZ4+yGHWlBvXKV28seemj9kItFOAQHXEpTmO34pWvJqFJaaiLRRWdutKwuY
         B+zg==
X-Gm-Message-State: APjAAAVY/j1tK7NbBH8fDT5uYR9jSyN4ipdzaTXUDlnUHShJIhJxeHw8
        d3LkGGdpWpDBOOioCIoH2/QrIoK0mkA=
X-Google-Smtp-Source: APXvYqxD/RiSF8DVwR7hc4ZlXCyss4n7x19cJdV3SbxVL+15xLqlXunkcgYeLecYOMhceOl5VsoXrg==
X-Received: by 2002:a63:dc0a:: with SMTP id s10mr21696803pgg.235.1580154362035;
        Mon, 27 Jan 2020 11:46:02 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c2? ([2620:10d:c090:180::dec1])
        by smtp.gmail.com with ESMTPSA id z26sm17211933pfa.90.2020.01.27.11.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 11:46:01 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <7316bdb3-4426-2016-df48-107a68d3e2ab@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e3d7afc-7c60-90a7-a4ca-83915d678a79@kernel.dk>
Date:   Mon, 27 Jan 2020 12:45:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7316bdb3-4426-2016-df48-107a68d3e2ab@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 12:39 PM, Pavel Begunkov wrote:
> On 27/01/2020 17:07, Pavel Begunkov wrote:
>> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>>> Ok. I can't promise it'll play handy for sharing. Though, you'll be out
>>>> of space in struct io_uring_params soon anyway.
>>>
>>> I'm going to keep what we have for now, as I'm really not imagining a
>>> lot more sharing - what else would we share? So let's not over-design
>>> anything.
>>>
>> Fair enough. I prefer a ptr to an extendable struct, that will take the
>> last u64, when needed.
>>
>> However, it's still better to share through file descriptors. It's just
>> not secure enough the way it's now.
>>
> 
> I'll send a patch with fd-approach shortly, just if you want to squeeze them
> into 5.6-rc

We'll see how it pans out, I'll ship what I have now and we'll still have
plenty of time to adjust if we deem that a better path.

-- 
Jens Axboe

