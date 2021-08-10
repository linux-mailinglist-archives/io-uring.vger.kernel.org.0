Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D915B3E7DEE
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 19:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhHJRE2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 13:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHJRE1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 13:04:27 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51A9C0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 10:04:05 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d1so22045312pll.1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 10:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d3SvrZv8EyWAy9JleeSdM4orO0KEmuw7/GUFp+33irw=;
        b=la2re2e5QKCAwi/ONzwdidJJ2+087V1lgKEsdJbDmqhNlNzql0Jjn3WbHh/mxO4pQ8
         4sWbKGMCUWPBhakJCjCHdMxb6V2Q6BxoAkLezFD4Oy87uoQHyRs3QSseXPBkptrlisZ9
         mnEDC5lx4/KU6eGO4VRTRCUPFzuqdz2O4yeTOcrKJe9cqMGXKkleLKi5Yzl5Nh4jjhj7
         G0np/VHDH+L0DnFMuh04hSEMgIzSSRbky60ekLpXNB0W2Xm2czWKUCP99ZLmsMvUaVpV
         Hwuk05HG9/miWAiJO+kTyoUWbUwex8Y2XGWTVLYwAkZIK3JZhddcyBJsWdFp9X6qcvfv
         LseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d3SvrZv8EyWAy9JleeSdM4orO0KEmuw7/GUFp+33irw=;
        b=mkhWpe0n50PacYhqH6ycNSHUiFnliX6/WE66QBV6qZvmhgeH4wrmSPeKZ68dKCPjW8
         scBdMeLsPyquL4tsbzB4qBOBDrGmx/IK0RUg39ccn+0EZDtRLRbtdih7bIAEZE+pAwFw
         cYJGavz+siAXqi34ztmfaioSu56alnaPkdQLj9XxrSkNuZICdQ2xqUhK+l7An3WOtgmE
         2iyxlss77EqV528CNyf9arQpiAbtrUJieii/fVdFSzRdUuam5cmi45gFzdTMKQbDL/Zq
         DxrvpuvOOoZ5GxrA2qpaY7E7tGzlbfv201YwbQFcijYqO8yE/CFtXZrgZS6x0gcexxFe
         2CKA==
X-Gm-Message-State: AOAM531TtM8U5JQRxGAAm2ZEIrsXowKk0KgtWV7D6hKWg2DcjMt0yNDC
        Dhp9KZNrAzCFCkPuzw7OOYxVZ9gGv7YJUvvm
X-Google-Smtp-Source: ABdhPJzx/wYr6KCL5AJUx6+GLCNBXInde3EPLeFbbdM07x2/ASykBmLDiQtidEVY3RXtUctclvnu1w==
X-Received: by 2002:aa7:9891:0:b029:3c4:dab0:6379 with SMTP id r17-20020aa798910000b02903c4dab06379mr23924752pfl.12.1628615044730;
        Tue, 10 Aug 2021 10:04:04 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x26sm24582742pfm.77.2021.08.10.10.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:04:03 -0700 (PDT)
Subject: Re: [RFC] io_uring: remove file batch-get optimisation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <afe7a11e30f64e18785627aa5f49f7ce40cb5311.1628603451.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <be049d43-4774-c79a-8564-82d43fb87766@kernel.dk>
Date:   Tue, 10 Aug 2021 11:04:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <afe7a11e30f64e18785627aa5f49f7ce40cb5311.1628603451.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 7:52 AM, Pavel Begunkov wrote:
> For requests with non-fixed files, instead of grabbing just one
> reference, we get by the number of left requests, so the following
> requests using the same file can take it without atomics.
> 
> However, it's not all win. If there is one request in the middle
> not using files or having a fixed file, we'll need to put back the left
> references. Even worse if an application submits requests dealing with
> different files, it will do a put for each new request, so doubling the
> number of atomics needed. Also, even if not used, it's still takes some
> cycles in the submission path.
> 
> If a file used many times, it rather makes sense to pre-register it, if
> not, we may fall in the described pitfall. So, this optimisation is a
> matter of use case. Go with the simpliest code-wise way, remove it.

I ran this through the peak testing, not using registered files. Doesn't
seem to make a real difference here, at least in the quick testing.
Which would seem to indicate we could safely kill it. But that's also
the best case for non-registered files, would be curious to see if it
makes a real difference now for workloads where the file is being
shared.

-- 
Jens Axboe

