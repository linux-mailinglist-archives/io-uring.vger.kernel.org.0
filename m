Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F1827F81A
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgJADDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 23:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJADDX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 23:03:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6648DC061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 20:03:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kk9so1079244pjb.2
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 20:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MkpKYdGeIV3KJ3Wg+a4T20fK6l2XTaPtjSNc7YMEgjE=;
        b=tIiRdS1eQxWJA+2cevgTPbiwIVwaopZJwpT0ropg0Sn575Qw+o4f5BBkavjhnrxewH
         De4I9jTrX0tki8NolbHe3z4Xm2KvobLs0fIIDfQ+Yjnb01QtYFKUNYRiS7o+XHTwokn+
         BT7TuD2EY+7SkXPlbQT7MtrHMga2kywmY1bRr5icsh9Yhl0nPe0grbsDGlsCbGM2Ii9T
         pGPNGgO/v+XPWs1rk4r/APyB+ilvxHmQwGLt2OJHAVybC7CcU6NXXdiNz51x11NN/9/y
         HT79CXaTOiLnZtT22IvHZv1qcH60vbsMBMi9PzD25/aIQGxGNCyn3+qIl8b+tLCj8mF1
         luaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MkpKYdGeIV3KJ3Wg+a4T20fK6l2XTaPtjSNc7YMEgjE=;
        b=G0vq/LdK8Td9zyjgyUdE/F36vKh7mjSOPvK63dvRv6lUoLGJtN//IBLU8BHk+qa4Jm
         9XpmX9+nkq1HvB2qW2qnzUq/lo7ivUgSbks5AsFUlun1k0r+N4LOLRlRmxar+f87aToP
         cY6x2n/BpPcdAARtF4FYs0Y6NmseuO45MeQWQ7REjrxTuXQiCWLzRlWX93lzCLg04Pxm
         4ahuX3DKokkfVfQVK69kO4PANyhta95YuCYNWzZvTUDERVyr/kMxuUTz5axvAzRmQ5Lo
         gcu4+RJBgUcAKVjOnVvN3ds2BK+FSDCXXLzjH+N5kDbiVvK501AZPzJjCEKaEByFm0a6
         OQYw==
X-Gm-Message-State: AOAM533OUp4tbeY+hoMJ+PUG2CMgb2xBp0kvbKe7t201lGPGL+KS5pka
        NIUWgwVXhSe6m0RbmYKib3RsR6hIJBXG24dO
X-Google-Smtp-Source: ABdhPJxIFQtAgS+jGmxD73kIQULJZlOXbhcJIvMMlvVWQMSpHZXhCJba9G5QSyL+921o2bn6w0dPGQ==
X-Received: by 2002:a17:90a:aa90:: with SMTP id l16mr5104260pjq.0.1601521401486;
        Wed, 30 Sep 2020 20:03:21 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 63sm3865485pfw.42.2020.09.30.20.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 20:03:20 -0700 (PDT)
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Ju Hyung Park <qkrwngud825@gmail.com>, io-uring@vger.kernel.org
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8de3b94a-042a-4b64-0458-e827ec5695d6@kernel.dk>
Date:   Wed, 30 Sep 2020 21:03:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/30/20 10:26 AM, Ju Hyung Park wrote:
> Hi everyone.
> 
> I have recently switched to a setup running QEMU 5.0(which supports
> io_uring) for a Windows 10 guest on Linux v5.4.63.
> The QEMU hosts /dev/nvme0n1p3 to the guest with virtio-blk with
> discard/unmap enabled.
> 
> I've been having a weird issue where the system would randomly hang
> whenever I turn on or shutdown the guest. The host will stay up for a
> bit and then just hang. No response on SSH, etc. Even ping doesn't
> work.
> 
> It's been hard to even get a log to debug the issue, but I've been
> able to get a show-backtrace-all-active-cpus sysrq dmesg on the most
> recent encounter with the issue and it's showing some io_uring
> functions.
> 
> Since I've been encountering the issue ever since I switched to QEMU
> 5.0, I suspect io_uring may be the culprit to the issue.
> 
> While I'd love to try out the mainline kernel, it's currently not
> feasible at the moment as I have to stay in linux-5.4.y. Backporting
> mainline's io_uring also seems to be a non-trivial job.
> 
> Any tips would be appreciated. I can build my own kernel and I'm
> willing to try out (backported) patches.

I'll see if I can reproduce this, thanks for the report!

-- 
Jens Axboe

