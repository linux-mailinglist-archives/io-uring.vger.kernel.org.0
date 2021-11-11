Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1262C44D847
	for <lists+io-uring@lfdr.de>; Thu, 11 Nov 2021 15:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhKKOdb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Nov 2021 09:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhKKOdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Nov 2021 09:33:31 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A985C061767
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 06:30:42 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id i11so5970710ilv.13
        for <io-uring@vger.kernel.org>; Thu, 11 Nov 2021 06:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O+hSEhPLomFM4561+KE0GmlGoJlfrGU8WxXMfci/wpM=;
        b=HF8e2vvzZMBSnaDQAgAACILTL46zZvqGqm2UO3gM280ZFz6ZYH9hg+if52o4Q6itPH
         DHty1djws0Uu2LCPSJBFBgqe5l6Q+oixxsBW2iO3mEdnyP82OcZa7saEZWjUs4EDn8DD
         l9+6FTcu12u2d+wQJnoMICkUqWDNEHl7hCHyvOy16qQiX02JlOj85u+vcoqvP8yGoENs
         7TM2POPvNWM0HSer2qkb8VC9nwGhYRhkhtxc527M4yE4a8UK1D1rKJx4QNOR4BS+7LG8
         5e44hN7dYzPFGl4CRhTfPyPQaB6jYkeGYvPj/u0fhwEFewyE0iVAtURkw+hjwxN7WPKC
         oKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O+hSEhPLomFM4561+KE0GmlGoJlfrGU8WxXMfci/wpM=;
        b=YufYYL72M6UvZPdWslaGZiEPlSoOvqWCGK6Y215plGZta86R4Q2E0wYmcTIH01n+zC
         sci4Wp1VCGUUxEvPcpXR9EIe/IIerwwP1eNfn3ROHaAy1pBTLHbm2OxvAtlV8DeVfv2q
         ayTqAQlCbojQqGG4EJCPtlzqApb0nGTOAqFPOMoAAa0SpDVNPkzTyczZsOI/BI6y363r
         c38WjyrZA41WaCK01J10HvxgmbzkUNZ12PjfKPux7SaSfCyqCXh2IiyQj5eIgPLbze/z
         IFwVsvLeXNOD2MqWBY35AahqnM3eyiKGtwiN/HNQP+D6cATI2FnASTUH07TM8grTgDKM
         MitQ==
X-Gm-Message-State: AOAM531qEHkCziyi2wtwvhqLDCvaSYzG/0TuqneCXD+I0TRg6rHtJHhI
        8FZ1FAbvfUXRlYUtiaqMVHWVIPEyPI4BUbvS
X-Google-Smtp-Source: ABdhPJz29VzB9Ssb9c2xDtS2RTanAOYKySTTBrmsyGJVZsF7cFr9zgxmbtntYEK7SSLaIj7mlL0gRA==
X-Received: by 2002:a05:6e02:1b09:: with SMTP id i9mr4542640ilv.111.1636641041272;
        Thu, 11 Nov 2021 06:30:41 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f15sm2109254ila.68.2021.11.11.06.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 06:30:40 -0800 (PST)
Subject: Re: uring regression - lost write request
To:     Daniel Black <daniel@mariadb.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com>
 <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk>
 <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk>
Date:   Thu, 11 Nov 2021 07:30:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/10/21 11:52 PM, Daniel Black wrote:
>> Would it be possible to turn this into a full reproducer script?
>> Something that someone that knows nothing about mysqld/mariadb can just
>> run and have it reproduce. If I install the 10.6 packages from above,
>> then it doesn't seem to use io_uring or be linked against liburing.
> 
> Sorry Jens.
> 
> Hope containers are ok.

Don't think I have a way to run that, don't even know what podman is
and nor does my distro. I'll google a bit and see if I can get this
running.

I'm fine building from source and running from there, as long as I
know what to do. Would that make it any easier? It definitely would
for me :-)

-- 
Jens Axboe

