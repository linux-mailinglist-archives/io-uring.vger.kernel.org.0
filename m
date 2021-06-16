Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CDE3A9AFF
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 14:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhFPMvu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 08:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhFPMvt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 08:51:49 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C70C061574
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 05:49:43 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso2305097oto.12
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 05:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Va4Nl2rJYF3YxYC7oWVUUM15Gct77l0IG+f6Vil+tY8=;
        b=OW1FQzh75836pfg5U5mJ/d2RFm9YUg+WaZjqHp7wG5AO+ahMkEz0v4B9nTMbFQrpYL
         nVdsPnA+Zfy1JkoOjcvFJLldJ2n3LZ8jPnPX4UsknC2QRD1e1/FwKCQRLBJJo/NwZcYG
         OxNnt0cIi0HCYaJ6IlFu2+VZQQDxZmINpHzV/LGonGlUc3bgsKc1Nb7B8FBTDCxAlUgl
         MzF0t0e7X1ZhIdLd9K41RtvdD+mW+2FXoGwKJX1DgQjUciGRzZaMNhZkVzr9jqSXfjGQ
         ZKbzp/LKIi5Zpors9nv8fUth7n4xk2vIIeppsE/ByA8zUtZ/P5GKehdSlh6F+EA8HEox
         P8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Va4Nl2rJYF3YxYC7oWVUUM15Gct77l0IG+f6Vil+tY8=;
        b=RD0qHTOXCLI2ud4zKrmzCsenH1kPvp2xvhMWaOntfkpPvkO10G8En13DTqAkGIb0hP
         mXRz1GTMWUCLSVdGb0G8G227j5w5i5nXSC5J9GvG22jDBsl013bKy0JGbb6PLG1dU7Kc
         ksxmfbfGslVJkMKS8vHspzFgHYFjnDr8QoKn2UtnHq99LNetxrLxhISbBjXtn1IzfU5N
         Q9yRewKeXvxCaF8rGANTEVNUAZutSzyuEuXZ1b3JS/nOg1/fqMRUd2+yKJLmoVbpZueN
         M3MVj9zFfb9oT6cPXrLwhmjOervaZu3as6AOBL1ueNsnQwEXNwkE1y6k2Ex1tQNgC/T2
         vP0g==
X-Gm-Message-State: AOAM530+uwmrY7dB70i9Hs0d5+Khyr/d1jzNcTDzahTopywGdZECB1wD
        SO0dWlwEnHKkzReW7axvIWIQIQ==
X-Google-Smtp-Source: ABdhPJzlZaK+Xm1b+p8yMBgWg6NvqcijeMq9pFwW0LOdbdksRDFSK+dJc2B9UVn/CTGormhHghvOoQ==
X-Received: by 2002:a9d:5d14:: with SMTP id b20mr3978235oti.307.1623847782759;
        Wed, 16 Jun 2021 05:49:42 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id l19sm447632oou.2.2021.06.16.05.49.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 05:49:42 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
 <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
 <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
 <20210615193532.6d7916d4@gandalf.local.home>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
Date:   Wed, 16 Jun 2021 06:49:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210615193532.6d7916d4@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 5:35 PM, Steven Rostedt wrote:
> On Tue, 15 Jun 2021 15:50:29 -0600
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 6/15/21 3:48 AM, Pavel Begunkov wrote:
>>> On 5/31/21 7:54 AM, Olivier Langlois wrote:  
>>>> Fix tabulation to make nice columns  
>>>
>>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>  
>>
>> I don't have any of the original 1-3 patches, and don't see them on the
>> list either. I'd love to apply for 5.14, but...
>>
>> Olivier, are you getting any errors sending these out? Usually I'd expect
>> them in my inbox as well outside of the list, but they don't seem to have
>> arrived there either.
>>
>> In any case, please resend. As Pavel mentioned, a cover letter is always
>> a good idea for a series of more than one patch.
>>
> 
> I found them in my inbox, but for some reason, none of them have a
> Message-id tag, which explains why the replies don't follow them nor can
> you find them in any mailing list.

Indeed, that is what is causing the situation, and I do have them here.
Olivier, you definitely want to fix your mail setup. It confuses both
MUAs, but it also actively prevents using the regular tooling to pull
these patches off lore for example.

-- 
Jens Axboe

