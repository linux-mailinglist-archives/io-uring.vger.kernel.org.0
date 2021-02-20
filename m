Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D459D32038B
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 04:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBTDla (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 22:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBTDla (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 22:41:30 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D662BC061786
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 19:40:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e9so4444366plh.3
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 19:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6jt3gbYErGCzVqXwrw0j1MDwi/V+DbPwPhbFBvdatBQ=;
        b=QI5McYwyk5IxzUIodb0NsvibxF0lPDxPVuLZalTge8OpQMDC12Pf3nhM9tq8NanqF9
         jSZzBKl2HVechPMkcqtaco8yMZ2iphW88WZX1sxIoQkag2lbuDMKzhamw5ifULchy/ik
         2kK3NkUDTFgJS2Yp5XSVqbsI6KDvG+GH9CYx/gGCMcclTUfC8fbpI9rwcgDMY6DpApZy
         QYg28l0P1Slc3M/6OxQA2BOzn8vepmjawRxaHVfC9n1NlkShkiX3rEQmxa/FmVeZbv9I
         m+kHaebKsh6s95fZkJM3wE1Q00ONWXhDmcsTcsjEYBNTBiWiwvbLpKBY1vSqr6TcTIst
         CElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jt3gbYErGCzVqXwrw0j1MDwi/V+DbPwPhbFBvdatBQ=;
        b=SHLAGU7OW8IsyR4hBOqwZt/NyUPfhiB78LhbE2xtH9yQfIuP2YKeDmzTB070GrsK8X
         fSqIwnMoKG/ETqunF5UjAHfCGmEe9Ir3E2MV1ZlYC73p5m3YSX/O3tejg3mX0WAlv2MQ
         9wGp0JBjLAZaHho6acGJA/CYLCHSUvhSEzwHclPSF2WPm8Vv7+p4h+hO7GhU9+upBJ20
         W0xnXY1Y9nFHZKoSeRGsZKS/v3F1z6BMU/VOMgR7HVFulqBgjN0sbQjZb4ODNKbPqDeQ
         boTLFFqr9itU2My+ll5bJ+kOK8hUR9Vvc9rvrEriy/p8f94AsIC7MeUAmerg/CwfZDJ2
         exzw==
X-Gm-Message-State: AOAM533lt2OA8je0KZIGK5f5JxzBVVV8piAIhILnsSkUglEVOJ37YotG
        TYEA5UloHJt7Mntxcd2VPir9Bw==
X-Google-Smtp-Source: ABdhPJyRfz7ie9+qo2jZoSEjRvqrzJTBXcAo3gAKbhmJKB0GRGOVP/0SqXAnUkUV+BF9iixr+xriEg==
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr12194864pjb.31.1613792449316;
        Fri, 19 Feb 2021 19:40:49 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y23sm10837002pfo.50.2021.02.19.19.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 19:40:48 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: wait potential ->release() on resurrect
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1613785076.git.asml.silence@gmail.com>
 <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <914848f1-f30e-4d3a-ab40-9db78e1321b7@kernel.dk>
Date:   Fri, 19 Feb 2021 20:40:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 6:39 PM, Pavel Begunkov wrote:
> There is a short window where percpu_refs are already turned zero, but
> we try to do resurrect(). Play nicer and wait for all users to leave RCU
> section.

We need to do something better than synchronize_rcu() here, that can
take a long time on a loaded box. I'll try and think about this one.

-- 
Jens Axboe

