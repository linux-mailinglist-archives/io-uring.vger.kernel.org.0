Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61652F0175
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbhAIQXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbhAIQXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:23:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31955C061786
        for <io-uring@vger.kernel.org>; Sat,  9 Jan 2021 08:23:15 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v1so5314688pjr.2
        for <io-uring@vger.kernel.org>; Sat, 09 Jan 2021 08:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aCNw6nNU3VjRQ5NW5aklQh35YPvKTAq6dr4MziozXZI=;
        b=AJPQ69khh0yUGvqrs4/nTKAtadAIozi+/esiVLTEv4jg/Tl6cmCzwI2H0VNtVcUDVH
         A4niR0k2byl0XzEoKoK4XQkSKcjsTEfLsjEnHMO1ly9b+KTvBPoDnawkCu4K6v30zN4Z
         Riu1AtWj1FPCDV8jGcsLqBnP5rjgGdxjPOxaf/IjR4RUnx3iqiAQVBgAhe/ZKJzurjx1
         oUs813K0/Yr8ya46w6dPNtNBUL1SdVwzsQ0a1oOP2hQCvUkRHdkj7pikKbNHJI5i4jhL
         6aglvl7TewRUq1+V/Ux9kQIEOvaoPWq71ufvUXthuc2DsygrQN03ndTXEv9hwYg++dVg
         ve3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aCNw6nNU3VjRQ5NW5aklQh35YPvKTAq6dr4MziozXZI=;
        b=UxY8vxXSbEyEWH+shL0RHONRoMXdbj+gORZ5fgqw+XY5QTQivQ+y4JwyVU7LBsmzCv
         Km4mJaVwTcpocKN1nbcO659FJcQErteMbUOJoELiCzXwLzYGTGxRBJ6WYq3oDzhh+Ecb
         1PAXaP08438wJxL7ftkPh7UBH0mz6Q8c74r6TqRMfEgPsnJx7lVExBe14ZlwwalaaFkF
         0rtJ4MQpFkEdbRsnAGdFLbWyhM220DJp8XOO2XAPX2SLcXf/vxRRO2tUySLcP3SnJ/VU
         NzFCDUI8nq3FVgD0LGHIlFUrRgJD5AuBNaRgl/0lCwZk+kyIUVKmuhIl7suMwti/DMdR
         DK6w==
X-Gm-Message-State: AOAM533ooA68+5sTLPxxs5PMJWYhCNcoeOR3M14Y0B1D0FRhowXaLu84
        Pwu0ITLS0qPIisBqQadJTjDZBFJ11PBHuQ==
X-Google-Smtp-Source: ABdhPJzeoLZVL/kj50LupowjHCoDawCr/xnpaWCT9huzA6YYDILArhY/0lZk05pDIMeKF6QSkxdQtQ==
X-Received: by 2002:a17:903:22c9:b029:dc:9b7f:bd13 with SMTP id y9-20020a17090322c9b02900dc9b7fbd13mr8976337plg.67.1610209394311;
        Sat, 09 Jan 2021 08:23:14 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q35sm8650085pjh.38.2021.01.09.08.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 08:23:13 -0800 (PST)
Subject: Re: Fixed buffer have out-dated content
To:     Martin Raiber <martin@urbackup.org>, io-uring@vger.kernel.org
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
Date:   Sat, 9 Jan 2021 09:23:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/21 4:39 PM, Martin Raiber wrote:
> Hi,
> 
> I have a gnarly issue with io_uring and fixed buffers (fixed 
> read/write). It seems the contents of those buffers contain old data in 
> some rare cases under memory pressure after a read/during a write.
> 
> Specifically I use io_uring with fuse and to confirm this is not some 
> user space issue let fuse print the unique id it adds to each request. 
> Fuse adds this request data to a pipe, and when the pipe buffer is later 
> copied to the io_uring fixed buffer it has the id of a fuse request 
> returned earlier using the same buffer while returning the size of the 
> new request. Or I set the unique id in the buffer, write it to fuse (via 
> writing to a pipe, then splicing) and then fuse returns with e.g. 
> ENOENT, because the unique id is not correct because in kernel it reads 
> the id of the previous, already completed, request using this buffer.
> 
> To make reproducing this faster running memtester (which mlocks a 
> configurable amount of memory) with a large amount of user memory every 
> 30s helps. So it has something to do with swapping? It seems to not 
> occur if no swap space is active. Problem occurs without warning when 
> the kernel is build with KASAN and slab debugging.
> 
> If I don't use the _FIXED opcodes (which is easy to do), the problem 
> does not occur.
> 
> Problem occurs with 5.9.16 and 5.10.5.

Can you mention more about what kind of IO you are doing, I'm assuming
it's O_DIRECT? I'll see if I can reproduce this.

-- 
Jens Axboe

