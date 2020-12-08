Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EF12D366A
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 23:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgLHWpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 17:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLHWpN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 17:45:13 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3020FC0613CF
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 14:44:33 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so91185pfu.1
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 14:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fvDku9rsd+lCpbeeFHcltSAKXz1Pau4IqDAV7i3Kh18=;
        b=E/r3+SrkY/XwvigzsRROE8NRJNo2I0VeP8IdNk1ZYqLPBNx1vSp+erinVC2zDLzAIM
         muPKn5VT+zwYxW0DveSp03pNHxzXpS1lg2kq6Sb8ufv8KXJqOfUwUzTWnb75mgsdrhJ5
         DdRRP6eqKw/Fst/9K3k2XBkBSFV9s3GGNM4fr2pOOLTtK4ODCx/1ipNloA/QrdzD8TM2
         Ga4FiH2GKADkWDliG3f4PHvIGh89C1C/+XbuU5JSvm1bpTczNofR+p5zJnZ9eQduTwvX
         D+dfj8fBIcDohEqX3yI9C+EAFvbcXo+d3bO51RQ1ynLFMMtwbkgFS+5qhAlp/JW7zBMV
         /cOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fvDku9rsd+lCpbeeFHcltSAKXz1Pau4IqDAV7i3Kh18=;
        b=gicrovaLFzzkxXLaz6DcKRgrk06XVTrJ9m7EuKT0lUCaZkJgRNHElSMb2z+kIDYtl2
         auFsQFZ82ld8aP3iLE6wF4zpLbY+YT2zTYoxttv5kq921Lw1MOog0k5iQ6Pvu7l5KYzW
         zUBDXCpwRON0MmfGZ7TfihVRrpz9LXLwu0CexC8xOoPHCHG16tzpLRxs0RaqUdeUIEmd
         OSwbyhv2i28gFFPnb0QUGKmdneqAXE2oCaMqD0jpEDbQErEV53kqMlP9wMNHpccU4ONt
         N3cJ5ijWsP+cHhl9YQqbO6Ei5DsHX0vlejpt/vHIrB+d5BaqeFgMdcmvFdupfGw1wwCp
         9+bA==
X-Gm-Message-State: AOAM533fK9k9uVOztzU2b45XmMhSz3RNwaXoXf3IadwnUkOD/9EHXdJx
        /cEqnMPqornDnXVF3B5wDfviYNsb3ZDe3Q==
X-Google-Smtp-Source: ABdhPJx0RVnbf5IV3EdCEEqBqNeaRAou/YY+4izf3BwaJqpAcwtOuSPLx/n0IcoXL/b3A6M3FsMXVw==
X-Received: by 2002:a63:5466:: with SMTP id e38mr259124pgm.114.1607467472520;
        Tue, 08 Dec 2020 14:44:32 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q188sm182261pfb.151.2020.12.08.14.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:44:31 -0800 (PST)
Subject: Re: [PATCH liburing] timeout/test: clear state for timeout updates
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <671c1670b4f205411ef93deed9f3bef5603d7a19.1607464429.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <51620955-3927-4c2a-f8d8-412b18d9ba13@kernel.dk>
Date:   Tue, 8 Dec 2020 15:44:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <671c1670b4f205411ef93deed9f3bef5603d7a19.1607464429.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/20 2:57 PM, Pavel Begunkov wrote:
> Clear the ring before test_update_nonexistent_timeout(), because
> otherwise previous test_single_timeout_wait() may leave an internal
> timeout, that would fire and fail the test with -ETIME.

Applied, thanks.

-- 
Jens Axboe

