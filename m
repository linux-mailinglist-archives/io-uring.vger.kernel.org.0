Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FF4FEC42
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 03:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiDMB2q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 21:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiDMB2o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 21:28:44 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142D8377EB
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 18:26:24 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t13so338399pgn.8
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 18:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=kQf0pqlkyIN2VPnbRyTQkyx8KfLqZDPK38QYDmwlZ3s=;
        b=2sT/9FogHDrn5GCCLwF+88y+y8HTuQXzIUKUXIggcscwpxQF0qG/jpvsP1bu8f1byT
         B+UYICfVYXnhpAcnidOYG5G9UbCSlIZs5Z6m/IxbUoGe9IuXt7ht81NGb5yYOlSoQYHN
         mhrPVqf9QFzzrigsGWkd3g+31hH3js7DkvpGfrGQuDn6nIXAByGMSXr+844Twp0yoROI
         DP/Fkn4I/lOh5mU0EUq8R66MxmIci+YGvGH19bK0SoGAGEGM8RSHIYrCa5ckeadEMUIN
         ermQKbF3TqoaffL2dlw9l86xwSsiqFROAY5kbkg/m1ImcPbrqIdJ+Ue67DusE7OHJ9v3
         SNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kQf0pqlkyIN2VPnbRyTQkyx8KfLqZDPK38QYDmwlZ3s=;
        b=Xeyd30/WU1drQ+6qsfxlhU9qfG1bTHySop6b5KaPCF+paj52M+kujy3o6yqYMOgcW8
         2yiTQz+Q64XBLT178upwo1vPqLVYdMBVk8U4hlR4i1vLuob1s7v69PrCb0r/vqpwwifJ
         M0IH7zVC4XCLV6VSyYdcO0soJddralxqVSTt0DKPgesT4My610FQKgYVi8WaLGT3oo7w
         QOwB8oXEAJI0uCEeUiFn5EFkLht23nFzFRGF3wkiP3m3qPH+Iox0kTL2Sj83m9VGMHsx
         LmHSrgD6I0+1X7y1hGOOyYdibmurD1voYO0gg76yY7hakeyqJjN0lC7PtFHZh3OT+kFD
         7DOg==
X-Gm-Message-State: AOAM533DfTA1spPhquNSHvrS4xPhqFLgzouoMLEL5PlRF4hVCrXyBLo7
        UvyT6AtzCKLwDKizKkMscVdp1g==
X-Google-Smtp-Source: ABdhPJxubiYLkXRujz/RIeBzIUGCeyE2+hDTuZ9NPN7UdosoENU0UuZjgLU7FjxAY9xLK8ALqcPQbQ==
X-Received: by 2002:a65:4188:0:b0:39d:2197:13b5 with SMTP id a8-20020a654188000000b0039d219713b5mr15082030pgq.368.1649813183528;
        Tue, 12 Apr 2022 18:26:23 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm43294042pfk.88.2022.04.12.18.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 18:26:23 -0700 (PDT)
Message-ID: <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
Date:   Tue, 12 Apr 2022 19:26:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com
References: <20220412202613.234896-1-axboe@kernel.dk>
 <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 6:40 PM, Eric Dumazet wrote:
> 
> On 4/12/22 13:26, Jens Axboe wrote:
>> Hi,
>>
>> If we accept a connection directly, eg without installing a file
>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
>> we have a socket for recv/send that we can fully serialize access to.
>>
>> With that in mind, we can feasibly skip locking on the socket for TCP
>> in that case. Some of the testing I've done has shown as much as 15%
>> of overhead in the lock_sock/release_sock part, with this change then
>> we see none.
>>
>> Comments welcome!
>>
> How BH handlers (including TCP timers) and io_uring are going to run
> safely ? Even if a tcp socket had one user, (private fd opened by a
> non multi-threaded program), we would still to use the spinlock.

But we don't even hold the spinlock over lock_sock() and release_sock(),
just the mutex. And we do check for running eg the backlog on release,
which I believe is done safely and similarly in other places too.

> Maybe I am missing something, but so far your patches make no sense to
> me.

It's probably more likely I'm missing something, since I don't know this
area nearly as well as you. But it'd be great if you could be specific.


-- 
Jens Axboe

