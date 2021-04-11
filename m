Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C7835B129
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 04:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhDKCbP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 22:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbhDKCbP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 22:31:15 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A4CC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 19:31:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so976704pjb.4
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 19:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8N/vhukvKFpmRgSi8u6r1qqo6aDKlMIv9KqDmhvdA5c=;
        b=DSAEVC8DEgVScMNKOltOqjOlouvg0Av6XBSNbvRmoxbQ0UoCcQ7brBB2ZBMbzv4oh2
         aux9VbMHk/EHrYohJ5YZXhWXTjE1cLhhq2wQw5NWn2S23HFmLdqasDNb8bUq16az9Nn0
         NigYVFtAwzwpSAR7Y5aDqgrXzee6GtpSLjicdJzGGqbtTTBsNLC68F0bLBC30dq9Tc/6
         ESrj9V9ITI/yBG/yjmjLWXUHq6dmQRZfuZoiQbN+uHYdn1+vNFay3qo3VJtmmn7fVR5r
         5D4velyNoIC/oP5pdGc/JfHOtn8TKe/1rhArp56S0SLA+MKNw7RyoHti/oQMvJa1+bIs
         miYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8N/vhukvKFpmRgSi8u6r1qqo6aDKlMIv9KqDmhvdA5c=;
        b=RxZxBMImPMvs2kfJkMPOZ0Kzox3rbUVYOzNP3OEFBIdmNawnsbOg2bOci60I3Li6Sk
         c7C2JEO8w5EbqVD1cSg03haU0lZ/Iz7KG4ilJVuYwOVcQ6UM5hHsAqdSx2wJVgI41DbX
         IlG63A0FOk+szCHwloL4vZz1Ec+gEKUNhhYWrp2o0NCRHGGggUkUiMtvCSszu9Prxas9
         YqAQZH3ZnwKlm23RuTDgragSF7341H6/IH9RAdwpMphzzPmpcRBJAfMHaXgjFe/8rIKD
         /UOTpKfPrvf6eSf/pMwl4ISGzZC+CMsBUAX5X9ha8efYs3T8uQBWbPzzVqUaZPfjUwrf
         KTug==
X-Gm-Message-State: AOAM531tN8AEq2xROAqKm93gMaYV5b40E42uaurWoFtazdl8cGsEcPvl
        XW5Y2CXqvJUSDTRn5QzUXmeRwhP59K8uJA==
X-Google-Smtp-Source: ABdhPJwheSc0PHcyINK0tnOrUDhT4xXap3sGVIUB+ZECwoX7LNlyHV8MY6Mt60NMRvdnQ//9PILP9Q==
X-Received: by 2002:a17:90a:5306:: with SMTP id x6mr16719524pjh.39.1618108259317;
        Sat, 10 Apr 2021 19:30:59 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g8sm6054186pfr.106.2021.04.10.19.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 19:30:58 -0700 (PDT)
Subject: Re: [PATCH 0/3] first batch of poll cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1617955705.git.asml.silence@gmail.com>
 <e2f3bc4e-18cf-c225-5d19-41929c6fa8aa@kernel.dk>
 <d3c6328f-e8b3-c4f2-a352-80a5833c0e55@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8597fb27-755b-1f3d-b06c-b47c5b5b641f@kernel.dk>
Date:   Sat, 10 Apr 2021 20:30:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d3c6328f-e8b3-c4f2-a352-80a5833c0e55@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/10/21 6:38 PM, Pavel Begunkov wrote:
> On 10/04/2021 21:44, Jens Axboe wrote:
>> On 4/9/21 2:13 AM, Pavel Begunkov wrote:
>>> Few early readability changes for poll found while going through it.
>>
>> Thanks, looks good to me. Applied.
>>
>>> # ./poll-mshot-update fails sometimes as below, but true w/o patches
>>> submitted -16, 500
>>> poll-many failed
>>
>> Yeah I think it can run into overflow, the test case should be
> 
> fwiw, also hangs sometimes

I've seen that too. Only with SQPOLL, but didn't try too hard without
it. Likely/hopefully the same root cause.

> Great, but it doesn't bother, was going to fix it myself but after
> I'm done with other poll stuff. 

Whoever gets there first, haven't had a look at it yet myself.

-- 
Jens Axboe

