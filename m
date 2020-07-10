Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FF521B89C
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgGJO1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgGJO1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:27:34 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9528BC08C5CE
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 07:27:34 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so6211751iob.4
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 07:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5nPcfCmlYF0l7QmyEYYVmjZA2gA3TH1//Bmgz9e8ojA=;
        b=qEr/bjgAG58DNbrwRg6ROR+b1Fe1+lyzVDBYdDNSap56O1j7D1MmcjhB4U0LsXh5lH
         sO0yTH5kYv9fBpoOzWSN52RjgjbEws2DQ68s5wxr5UxQeM/RZGNAudxy7NtdS59wTpvx
         evMvnz1atzdhLsR1rQRlp0R0JOsQgOyfaDezoSFjzThA8J5UMtDritPsEvS9mbi0DB9d
         8ZUEuUpDqSMzHrwkYkYnEBRIfUVMeJLwp/A4lipk5IKukioqgHpFgDgSiOHvpRZhidAg
         Hy8+fCQVqUfCjCkT2JUDUJ/8WapzCKOPjQFYN46+UGFADf/Vc/o14WEdsWppPcD7sv5L
         xuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5nPcfCmlYF0l7QmyEYYVmjZA2gA3TH1//Bmgz9e8ojA=;
        b=ZOK9KLMSAt6CQEpfkzCT9C+xFasz2/OmPL7PKTxeJHQ2Sj6t60g0v1p0EVa9VaiZMU
         b9WLIJx3ToE8GCFdxrphqwOkXslg8gRHq0PX3yC/L7w0/2vfn5HYITFQNzWlnYfKLXzA
         t+NzRAjeDPh5NAtJ0WPp9oK+8yMJkA5yh7ZCG9bYR9BQfAfdCvmxG+JJJwfQXrZSIy/x
         ZooD5gQ6Q05NGGI89tWzI9DHQbJZSqcukWiiW0VDfOaTgWylSMCFibSYKbiqZwSgwhZY
         4slSI6BlZvgGHFmXtdBX3FvBEdnkxVKLXLMJ//+kh3ar2QbIWJI/OacN9Wa9yTRb+FhL
         fFwA==
X-Gm-Message-State: AOAM5328ZIwYlv8ToEhGu/ag1DnRb3uRa0Y//sSLo1KfItQ6D7CeHS2E
        xIlKAjSVIslYhN6NmfpfGaT5v4rC2k0nnA==
X-Google-Smtp-Source: ABdhPJzord+9Ii7lEK3UKSL1L0i7V0JV8zPYYblbL2oZ8b8A5AZ38Xcj7M8zh1oSKFw1uISTA2lUrw==
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr47161042iof.128.1594391253617;
        Fri, 10 Jul 2020 07:27:33 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h84sm3900147iof.31.2020.07.10.07.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 07:27:33 -0700 (PDT)
Subject: Re: [PATCH] test/statx: verify against statx(2) on all archs
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     io-uring@vger.kernel.org
References: <20200709213452.21290-1-tklauser@distanz.ch>
 <304e4cdb-f090-ef90-18e1-d677d659918a@kernel.dk>
 <20200710142501.jrj5cnwmpiyq5ign@distanz.ch>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0d35e7ba-8e29-da1c-4e74-2c0c66884cd0@kernel.dk>
Date:   Fri, 10 Jul 2020 08:27:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710142501.jrj5cnwmpiyq5ign@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/10/20 8:25 AM, Tobias Klauser wrote:
> On 2020-07-10 at 15:55:24 +0200, Jens Axboe <axboe@kernel.dk> wrote:
>> On 7/9/20 3:34 PM, Tobias Klauser wrote:
>>> Use __NR_statx in do_statx and unconditionally use it to check the
>>> result on all architectures, not just x86_64. This relies on the
>>> fact that __NR_statx should be defined if struct statx and STATX_ALL are
>>> available as well.
>>>
>>> Don't fail the test if the statx syscall returns EOPNOTSUPP though.
>>
>> Applied, thanks.
> 
> And thanks for your follow-up fix! Looking at it I noticed that
> statx_syscall_supported introduced by this change should check for
> ENOSYS, not EOPNOTSUPP. Will send another follow-up.

Ugh yeah, I missed that in yours. I'll apply the followup.

-- 
Jens Axboe

