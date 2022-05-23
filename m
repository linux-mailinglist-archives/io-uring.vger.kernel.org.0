Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB753104D
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 15:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbiEWM2L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 08:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiEWM2L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 08:28:11 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE00C41622
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 05:28:08 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v10so13523961pgl.11
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 05:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NfSqM13lltjldN1LkXFhLIfMmR5euG3sVeA4tBgn/IU=;
        b=upsZgojui9qTc3PIFEr8J9Zi7p5GNookwfBvMHebIvdDqplon2JaOTh5ljODb4fVkd
         LXyz9yyOQ5fF+zQlsdHPWm0XZvTZTLrhqEUv8tQr9rQWK7sxttiwRoHl9KWh3YYErcrs
         76CiSrS9Bx9NZzaomfQYeE/IbRj7mWSe0jAAF2C4SJ80noBMQVCaNEBv1cyHGhyO+9Vw
         kPmFNhUEmScUXH1k45jiaPgZ3AojHrEKmgHhlRfOt7btZHHZZvGJ45rg4LcW1+2MTHE5
         TDA/uvsZpdl9i27LAgk8/dE5qsSp4R00+JhADx7OvUEZHOpvlCH5u6qedW0bimtCVOLn
         QSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NfSqM13lltjldN1LkXFhLIfMmR5euG3sVeA4tBgn/IU=;
        b=GaIAlNTA3Fh3wHl9MQb1CoK2xPec7pByO152CbmC4AIBEz6Kloy8+UpZebr824dqj0
         0/utnsksoRae+Kf3vFZQAJukDIq0aPM0fkIA1Aza+ajLZLfd637y6e1yjucZ3Uim+Qk9
         M/0w7Ol0CM3vWNYJXazugS5Iw/ty1aNqHN2AmhGns8SNaiItw2p49UYy38GoyPCwHXeP
         Ebai+YezD15O86x5bdXk1Lbv7+9fap1PbIk89rKRHoQ0qTQmXPlWh78+8gnA6o8ek6mI
         LngXzHOlWDn4Ps6lWnucf86Gu1nS4HXh5gpfZbi9PgWvEKJ3z40W6NDebt6LNhujk7PH
         gO0w==
X-Gm-Message-State: AOAM533SvpsO2GQy6iw8Sn+Y4970e1Sl+vmBjZtVJfWz9h7FwdRV7ohx
        aCg5G46O/SxfOijezVUei4l33w==
X-Google-Smtp-Source: ABdhPJxS2N57CNA2NGhcmaEGEhtuqryRSIdZU5aRF+Zxr5bLiFtfFvSr6E5rzU1MWMlESZSV+aCiQw==
X-Received: by 2002:a63:6cca:0:b0:3ab:892e:bfa4 with SMTP id h193-20020a636cca000000b003ab892ebfa4mr20245975pgc.494.1653308887965;
        Mon, 23 May 2022 05:28:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f11-20020a62380b000000b005184640c939sm7047888pfa.207.2022.05.23.05.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 05:28:07 -0700 (PDT)
Message-ID: <172a656d-657b-69bb-5fe8-f63f546acbdc@kernel.dk>
Date:   Mon, 23 May 2022 06:28:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 00/13] rename & split tests
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, io-uring@vger.kernel.org
References: <20220512165250.450989-1-brauner@kernel.org>
 <20220521231350.GY2306852@dread.disaster.area>
 <f77e867f-ed7d-85f7-f1e4-b9dc10a6d23b@kernel.dk>
 <84e5e231-7c33-ad0f-fdd5-2d8c1052aa00@kernel.dk>
 <20220523001350.GB2306852@dread.disaster.area>
 <767778c5-ac0e-e798-38e0-199f54853cc6@kernel.dk>
 <20220523104144.GD2306852@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220523104144.GD2306852@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/22 4:41 AM, Dave Chinner wrote:
>> From my experience trying to reproduce it yesterday, my test distros
>> don't even enable it and you have to both fiddle the config and add a
>> boot parameter to even turn it on. And then it still didn't trigger for
>> me.
> 
> I have machines with audit enabled as it seems to be the debian
> default these days. I haven't explicitly turned it on - it's just
> there. I guess it came along with selinux being enabled on these
> test VMs - I have "selinux=1 security=selinux" on the kernel CLI for
> these VMs.

Hmm, I am running debian on these. Anyway, I'll get one configured so
that it triggers this issue, and use that going forward. Maybe I need
selinux too, not just audit, and explicitly enable it with the boot
parameters.

-- 
Jens Axboe

