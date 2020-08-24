Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948A124FBE2
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 12:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgHXKqf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 06:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgHXKqe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 06:46:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56A6C061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 03:46:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kr4so4082445pjb.2
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 03:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sM2Ceqv0yv9xYwWDl9mByQZbLxMxxG3+FXDYPXbHSvU=;
        b=oF9zHhP79s8uvDAJaWVeGLBqj5Qhrnuzp5+VOltRK5E75STpDFOzWj0EcDTVQdBGyp
         XR93TrjwqAffvUP3NKUZpV5PlTjb5Xl6xvVyLZaBCzLo8B3OnE1CZCykqcFk5ybowdvY
         EDDDe4LvX9ueZlaKWorDeMSSlniTERNMzEYvs65RwyYtcNMI/Ig/kjHqLCmTt/uNbTkh
         koE4Aqo6wm3p13uRXC8rEoHxYv9Dm1dHxqCLQgIWY6uWRLv5VSsHcBY2JbLOakeIHVkW
         CTD9SdDQVoyKxOHItgNLEsYGNcmxHYyZkQ66j2gxEHTfDHAQJgNWBkPQtKQRf0e6nFaS
         0Y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sM2Ceqv0yv9xYwWDl9mByQZbLxMxxG3+FXDYPXbHSvU=;
        b=Sq5SsxE3oqSmU//t8RzjIl1UkdufPgSKIcirfNNKqcGIsT4sXXgp70UtFbHdaGSGLK
         zADPMfqBK8y0sR/Z0ROfKAiHYMi5PmbVihuo8Ajht70N1yIIY6bfMZqkqejOSIUc6z2g
         CMnNv0dPOyU/iL7/sOP+l9KdRDMI8d9D7vCb2vw0RSFdEHnyy00q3rH37+icCr3akS5L
         c3QN8tDuTKAFw+fJuOvu3ly7G6VB56WZkjh02eEnerGiVcvQ7lcs+FI8OEH6mT2ofgAj
         LVpQmGbMh1rnA4vohfRaZU+lKN2hGzlx7IEVngIo4K3PFIy5UfTzX+CpOwDUqquKz7Ls
         +XyQ==
X-Gm-Message-State: AOAM530MXlxInQYWfueROilrFVCPUMG91WVleIbUt9RgLTBvWvRYPe76
        fnrz24ucoV2Vtd7CjGDZ50A5n0AaXWXGcg45
X-Google-Smtp-Source: ABdhPJz0AU8L3GIP1X0MxQOazhOqdvCKqC5cD28AgBxGsapa7WEwvtuUpUvAgw0Vn9qcpe523Wjaag==
X-Received: by 2002:a17:90a:9288:: with SMTP id n8mr4313143pjo.137.1598265990964;
        Mon, 24 Aug 2020 03:46:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c27sm9299785pgn.86.2020.08.24.03.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 03:46:30 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Dmitry Shulyak <yashulyak@gmail.com>, io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
Date:   Mon, 24 Aug 2020 04:46:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 4:40 AM, Dmitry Shulyak wrote:
> In the program, I am submitting a large number of concurrent read
> requests with o_direct. In both scenarios the number of concurrent
> read requests is limited to 20 000, with only difference being that
> for 512b total number of reads is 8millions and for 8kb - 1million. On
> 5.8.3 I didn't see any empty reads at all.
> 
> BenchmarkReadAt/uring_512-8              8000000              1879
> ns/op         272.55 MB/s
> BenchmarkReadAt/uring_8192-8             1000000             18178
> ns/op         450.65 MB/s
> 
> I am seeing the same numbers in iotop, so pretty confident that the
> benchmark is fine. Below is a version with regular syscalls and
> threads (note that this is with golang):
> 
> BenchmarkReadAt/os_512-256               8000000              4393
> ns/op         116.55 MB/s
> BenchmarkReadAt/os_8192-256              1000000             18811
> ns/op         435.48 MB/s
> 
> I run the same program on 5.9-rc.2 and noticed that for workload with
> 8kb buffer and 1mill reads I had to make more than 7 millions retries,
> which obviously makes the program very slow. For 512b and 8million
> reads there were only 22 000 retries, but it is still very slow for
> some other reason.
> 
> BenchmarkReadAt/uring_512-8  8000000       8432 ns/op   60.72 MB/s
> BenchmarkReadAt/uring_8192-8 1000000      42603 ns/op 192.29 MB/s
> 
> In iotop i am seeing a huge increase for 8kb, actual disk read goes up
> to 2gb/s, which looks somewhat suspicious given that my ssd should
> support only 450mb/s. If I will lower the number of concurrent
> requests to 1000, then there are almost no empty reads and numbers for
> 8kb go back to the same level I saw with 5.8.3.
> 
> Is it a regression or should I throttle submissions?

Since it's performing worse than 5.8, sounds like there is. How can we
reproduce this?

-- 
Jens Axboe

