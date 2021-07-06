Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EC13BCABC
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 12:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhGFKue (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 06:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhGFKue (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 06:50:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FD7C061574
        for <io-uring@vger.kernel.org>; Tue,  6 Jul 2021 03:47:55 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso1316657wmc.1
        for <io-uring@vger.kernel.org>; Tue, 06 Jul 2021 03:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DrcfBgCy5eU+jlTHU6d0ql1RjdttZKSJEs7psjeFvt4=;
        b=k6Q5ugX3aj815JO0tpGwswTllxCpr3fIl9BcW1ecFto4MKfSEmrNZN4b+ed88OFVN9
         oFleC7z3oosnFlQESa3oEl9WqUDy60IEn+Jn51vOAEWaHwiONK2b2pah53g2IhtBFzzV
         E59CGTrkeeN6SDQf9s/+OWyb/yYNbNRy1iIK9hlyYO9IAMDLglhBs3sQ2o0bjkWfd2B0
         bIe8sIa4BW0TXKkl2OfSA8Rq7+OixhGuu1oz7kl8RCgSCSp76Q140QT1P4letnWTjkJz
         Z45KVC5HjzkmT7smA+ZnCq/ZvSP8bhhax8ziu3ljYQFlh9InepAVdZzQEjZH6W6JZoiB
         RcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DrcfBgCy5eU+jlTHU6d0ql1RjdttZKSJEs7psjeFvt4=;
        b=JvpAuwx8Ty581xt69UkIfpG3kSWKNRfgstsad/0u7qzw0mnpU5ruLUXMP9rQgIqP1r
         nqDyMDp/OASe5NdcDuFLk63uQJ++nru7N3UOVKdfPGJy4PLsYdNnmkqZIBYUVccmp0m7
         XaD51/lQKAH6ExSS0i4OEIBCWXS+qAEzxST3AkvsqVsFhh/l9yxloMgNkDNxNxDahHw3
         Vii4c3WU8mK8zuENZw7hHYXy3PUoQ2BnAn2dREol4ng4HVAEFTcN8/jR/7FBKUx9Sn7i
         12iQpF2q0PMVBc3AllvVacvjAomI10/o71Uzhm8glliYuDALcUgpn2OEje2QyndC6Z1n
         L9Zg==
X-Gm-Message-State: AOAM533rXad0bKBu4wXRrrbpUgF9JuLlSaxNfhI5Gpg1mdQuMSCX3n37
        RBU+gh2l47o64EnthXByDxXc8q2WMmRNJQ==
X-Google-Smtp-Source: ABdhPJxuBijcG6TlErMkhufAzOfx2jMFWo84V6R9WEwiR0KRnqBkuIO5DF23rwCP5aMs+9j04E+6WA==
X-Received: by 2002:a1c:5407:: with SMTP id i7mr3986892wmb.57.1625568473494;
        Tue, 06 Jul 2021 03:47:53 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.13])
        by smtp.gmail.com with ESMTPSA id l7sm15403291wry.0.2021.07.06.03.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 03:47:52 -0700 (PDT)
Subject: Re: io_uring/recvmsg using io_provide_buffers causes kernel NULL
 pointer dereference bug
To:     Mauro De Gennaro <mauro@degennaro.me>, io-uring@vger.kernel.org
References: <CAGxp_yhoUAAvbttOaRvWx3EsmPKZVumFZQz2uQGUPGhuN8AiVQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d322265e-4863-4087-8f74-ae5d2d668980@gmail.com>
Date:   Tue, 6 Jul 2021 11:47:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAGxp_yhoUAAvbttOaRvWx3EsmPKZVumFZQz2uQGUPGhuN8AiVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/4/21 10:50 AM, Mauro De Gennaro wrote:
> Hi,
> 
> First time reporting what seems to be a kernel bug, so I apologise if
> I am not supposed to send bug reports to this mailing list as well.
> The report was filed at Bugzilla:

That's exactly the right place to report, not everyone monitor
bugzilla, if any at all. Thanks for letting know

> https://bugzilla.kernel.org/show_bug.cgi?id=213639
> 
> It happens on 5.11 and I haven't tested the code yet on newer kernels.

-- 
Pavel Begunkov
