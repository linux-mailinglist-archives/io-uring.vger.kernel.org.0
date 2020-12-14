Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDCA2DA0D0
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 20:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502651AbgLNTsX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 14:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502776AbgLNTsU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 14:48:20 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF69CC0613D3
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 11:47:39 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k8so16962952ilr.4
        for <io-uring@vger.kernel.org>; Mon, 14 Dec 2020 11:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5mXvee0eyFTOJA4gmIe4PF1Eswd2AOsisRpJwcmqw30=;
        b=k2HjL5+kICt7Qfq8eAIjrcvk/MiGf+Py6roh4BUC8Mxj4yTiTg+9Mm3Y6WI69a711f
         mv2RnXl8Xgsx5uLcP6wgRJ4KQxAvXBV/Er4oJGn2qJg02yX8R7plpHOxx1V9doeBBEOK
         kpUOgzuFxqcJywPPqkLCKp/6tiigVrASuETICz47zECZpb1UuS0QnHBQMmt8jmj///tY
         sVNpdMEMeiN+lC1gvGBlTzdqs5rzV4/b/3Y4pQbnIVCc4DVUbiKsRF1RDDF0fhH/SF7n
         u7vBng2e1uXtlBaXLbTfXL2L/vLRVfG9R3o5n8OZcZr/+syocpd+Kp0W98kNVZnl7Ak/
         Nc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5mXvee0eyFTOJA4gmIe4PF1Eswd2AOsisRpJwcmqw30=;
        b=FuOfsxZeY47MGeSGHFMXy+QXHC0FfEtmEu7EVeKFNeWIPU6bqPxOEXpFcRhFfQcRhT
         rW7r6rTlW08NiOYRLE2SWwNWBjEcrERmnbIF5wnBCR5o/T9MCIdP2wE/F1NaVcRGvIk2
         PKA3G/RVJcuX2WmtMy0RImjv6Uj9GapG+mbAzqjTOoks5L9iSmSJC34VahcrqHhNOhrY
         KFllSGe2mXKqKA6TVG6ZbAhTi+ywQ0wbuoVh+KlCLNM3nSoRfXmUZx3YspG1nrsLQWyS
         vTtELZMhehLPDYDfK3Oy01OXsHlnC6++xdMU0e8jXJOARZQgVaOoRQ6YpSd8MTTuutIz
         9KJw==
X-Gm-Message-State: AOAM531I3uyS5YppGEr8k7kWZZAZJu6KRUIgy6scvCwGHnKjaTIRMrzO
        ZLfDpHbupGmm7tsxDEuVCWj1eg5AGsnfwA==
X-Google-Smtp-Source: ABdhPJzWjS2PIbbSeoKV3N0al5AspTT3fGHRfG+i9KwwvM6l2wF7R/iGLjteQHH1Ehnhh5Nx2MsfLw==
X-Received: by 2002:a05:6e02:1187:: with SMTP id y7mr36238768ili.143.1607975258770;
        Mon, 14 Dec 2020 11:47:38 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c2sm12252099ila.71.2020.12.14.11.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 11:47:38 -0800 (PST)
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <e8afcd4c-37b8-f02e-c648-4cd14f12636a@oracle.com>
 <b9379af3-c7cc-03ca-8510-7803b54ae7e9@kernel.dk>
 <727da608-b8fe-546e-0691-800cae8a8bd0@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d658a456-20b7-8595-5795-a96c6041af93@kernel.dk>
Date:   Mon, 14 Dec 2020 12:47:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <727da608-b8fe-546e-0691-800cae8a8bd0@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/20 12:43 PM, Bijan Mottahedeh wrote:
> On 12/14/2020 11:29 AM, Jens Axboe wrote:
>> On 12/14/20 12:09 PM, Bijan Mottahedeh wrote:
>>> Just a ping.  Anything I can do to facilitate the review, please let me
>>> know.
>>
>> I'll get to this soon - sorry that this means that it'll miss 5.11, but
>> I wanted to make sure that we get this absolutely right. It is
>> definitely an interesting and useful feature, but worth spending the
>> necessary time on to ensure we don't have any mistakes we'll regret
>> later.
> 
> Makes total sense.
> 
>>
>> For your question, yes I think we could add sqe->update_flags (something
>> like that) and union it with the other flags, and add a flag that means
>> we're updating buffers instead of files. A bit iffy with the naming of
>> the opcode itself, but probably still a useful way to go.
> 
> I'll look into that and we can fold it in the next round, would that work?

That totally works, thanks.

>> I'd also love to see a bunch of test cases for this that exercise all
>> parts of it.
>>
> 
> Great idea.  Should I send out the liburing changes and test cases now, 
> that would definitely help identify the gaps early.

Yes, you can send them out now, and then we can just stuff them in a
separate branch. Makes it easy to test and adapt to any potential kernel
side changes as this is groomed for the next release.

-- 
Jens Axboe

