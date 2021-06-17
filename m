Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19073AB9E4
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 18:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFQQuN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 12:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFQQuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 12:50:13 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18670C06175F
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:48:05 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id o5so2077836iob.4
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 09:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RzHHToxvpIftGJ7LtAOrwsw/Op9EevSDWa3J+vNpWR4=;
        b=Tjct39M+uFDMfteFQ/FF5m8PR/autcRz3yEtRA0de9kCL7NisyEFPpT8n19tyeAkN0
         UV7SQsDzkFmMRYhuXo3tlmDN721IU5L5WrwcG6NoYpMIuCXB5SENhcA/aglT0cF3UYXM
         /BpRDnoAQ42XrvKVelIUUI0917pq3EjL+uhAYPT4xoWX0hzD2ttRgiwN48KaGX99ImbV
         K05QfzcquwRXkEaG2LotxL/ds94DlhXHmo69mBKI61PlPtqaDuk9LnptOojdptsRpvL4
         gdC9OP8sSeTw5rsWWMdUbvnQHSN0IZSRxTKlzbAZyVOKRCcIi71F+r/KRwIhlTnpUa1E
         1TCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RzHHToxvpIftGJ7LtAOrwsw/Op9EevSDWa3J+vNpWR4=;
        b=OMAcTqKGCtuK3qFWoJt7ADvn5hXmtFiAEsKho04/TZnO5zEW76UiHUMW7iipI3zZSM
         abyKMpkyjw1DlMUlm3BSdHmXeIlrrl3exEBeprdXyzKVW5X1xC1eOYX8y53lcSIkJ2Zd
         BH6NxsnhwjnjY4N42lbjgdH7mfqQ+Ev88DtD9SfTiGBY34lbAioveOhAVzY3vx5yEh/t
         Y2a6TX9DmELM54h+LwaGMM0V24DHKfvman5/tmKdNJv7ZooVquyD8NJikCMHe8JjZ7cL
         PGBgZ31vtM/8IcSqB7p22DYAcnEHJlRnVQCsN5A8rayH3/IKV8Ci5s/K+ndWSkmJASxI
         E/8g==
X-Gm-Message-State: AOAM533kl6augfwQJjrBXxTW/quzp8A8r2h8Ysair0IYt3B6j6ZlvdXp
        5ZJjImo/TYdpIycl1b2tEO4rDRJujn0FfWn8
X-Google-Smtp-Source: ABdhPJzn6Ja9brmgvJUZLLiupQsmiX468kvMta/r4qZXUZOBFopK5Uvhm5taOM/lkWrqjQ0zDd3FhQ==
X-Received: by 2002:a05:6638:267:: with SMTP id x7mr5694811jaq.51.1623948484119;
        Thu, 17 Jun 2021 09:48:04 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m7sm2913791ild.49.2021.06.17.09.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 09:48:03 -0700 (PDT)
Subject: Re: [Bug] fio hang when running multiple job io_uring/hipri over nvme
To:     Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
References: <CAFj5m9+ckHjfMVW_O20NBAPvnauPdABa8edPy--dSEf=XdhYRA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6691cf72-3a26-a1bb-228d-ddec8391620f@kernel.dk>
Date:   Thu, 17 Jun 2021 10:48:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFj5m9+ckHjfMVW_O20NBAPvnauPdABa8edPy--dSEf=XdhYRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/21 5:17 AM, Ming Lei wrote:
> Hello,
> 
> fio hangs when running the test[1], and doesn't observe this issue
> when running a
> such single job test.
> 
> v5.12 is good, both v5.13-rc3 and the latest v5.13-rc6 are bad.
> 
> 
> [1] fio test script and log
> + fio --bs=4k --ioengine=io_uring --fixedbufs --registerfiles --hipri
> --iodepth=64 --iodepth_batch_submit=16
> --iodepth_batch_complete_min=16 --filename=/dev/nvme0n1 --direct=1
> --runtime=20 --numjobs=4 --rw=randread
> --name=test --group_reporting
> 
> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=io_uring, iodepth=64
> ...
> fio-3.25
> Starting 4 processes
> fio: filehash.c:64: __lookup_file_hash: Assertion `f->fd != -1' failed.
> fio: pid=1122, got signal=6
> ^Cbs: 3 (f=0): [f(1),r(1),K(1),r(1)][63.6%][eta 00m:20s]

Funky, would it be possible to bisect this? I'll see if I can reproduce.

-- 
Jens Axboe

