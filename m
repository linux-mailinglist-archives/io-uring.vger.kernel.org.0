Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497EC3AED00
	for <lists+io-uring@lfdr.de>; Mon, 21 Jun 2021 18:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFUQFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Jun 2021 12:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhFUQFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Jun 2021 12:05:41 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B99C061574
        for <io-uring@vger.kernel.org>; Mon, 21 Jun 2021 09:03:26 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id h3so15751664ilc.9
        for <io-uring@vger.kernel.org>; Mon, 21 Jun 2021 09:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eVXRLvzbSMXRfDwdm7VIC+cZ6QdFXq4T0AzqI7GGzAs=;
        b=H+oXpGUARAhVSBoZL2MY8geozptZKKKELgGSVRYNYAvANNFsmktyHvvPOJ6CZuroJM
         olIg2/8ItnwTp2yz6p41I5Mt9gepjty8919y2hc7DLc1tk3Pr5vaGgEvPpMlSqIqsL27
         93aOdH+pMQYKyvb25oXwAzHM8ROWwlAxKZXYkM2iUzoLg5TlfuNJ1oKv7hiUjeRKBYEf
         dEBnlm1kfAvcc71YL+gFBKSf0S/QFAOw/U/r1mYJRgthg3c7l5G39/nZvEcRalWw1J3K
         sxeBCfr2P3Q2E9VtUApMXVSdB8LbdkcuAiUQuKiNK2xPdPCgaYgZUy6ko7aTTLkDwpvv
         CjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eVXRLvzbSMXRfDwdm7VIC+cZ6QdFXq4T0AzqI7GGzAs=;
        b=XFJaigRLwINC+JcG44nOvwnhMax0TA9sK2H+fHuqTv8YtTgCelwCxEllPT8U2KqpFo
         doS85jwhBkp9Jt0sueHPoXMmy2WQNhoFyIHmB+D8QKeSF3nl+BqsOihG/L0wkNTdoExA
         ERX/7b0xZds0cpCe0IYg3zysFSVK6Y1ujphgglFTKkGy2iCDd0VulSY6dcezVAXV1o8H
         KQV1gWmm7/I9mXIEGraQQ4oVuUagKEQlE+b6hooseHmy1nW4IvTDxTF99dsuZZjGvywc
         10nvTDK1A8KhFO7d4cKwOr5WltZ7PEVQkBtFZ2iOkblC+V1XzKIqOp7xcjFQvYdoRNcD
         fsDA==
X-Gm-Message-State: AOAM532KBMrptnxQaJKMoWfr5BJWZm/L9N1kaDGEaJBKZUBQcDxtWr8b
        OU11aht5E+Dnvm8sl+uyXMd8xA==
X-Google-Smtp-Source: ABdhPJwkP8nWk8bySuW3V1xOJ9Rw1HPGvtS6zVwX0bYU4AwIlBDFQLHelmARWU7WL3I5cxJKVsRnfQ==
X-Received: by 2002:a92:364f:: with SMTP id d15mr19206928ilf.26.1624291403552;
        Mon, 21 Jun 2021 09:03:23 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r6sm9796755ioh.27.2021.06.21.09.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:03:22 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
 <c5394ace-d003-df18-c816-2592fc40bf08@infradead.org>
 <b0c5175177af0bfd216d45da361e114870f07aad.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <766a96fa-1c90-ec3d-abab-16cacdedb44e@kernel.dk>
Date:   Mon, 21 Jun 2021 10:03:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b0c5175177af0bfd216d45da361e114870f07aad.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 1:28 PM, Olivier Langlois wrote:
> On Sun, 2021-06-20 at 12:07 -0700, Randy Dunlap wrote:
>> On 6/20/21 12:05 PM, Olivier Langlois wrote:
>>> -               return false;
>>> +               return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;
>>
>> Hi,
>> Please make that return expression more readable.
>>
>>
> How exactly?
> 
> by adding spaces?
> Changing the define names??

Not super important, but I greatly prefer:

	if (ret)
		return IO_ARM_POLL_READY;
	return IO_ARM_POLL_ERR;

as that's a lot more readable to me. This is orthogonal to the currently
missing spaces, of course.

For the defines, an enum would be preferable too. And place it near where
it's used.

-- 
Jens Axboe

