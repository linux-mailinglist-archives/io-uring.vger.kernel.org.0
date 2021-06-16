Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F633A9AF6
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhFPMvA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 08:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhFPMu7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 08:50:59 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E734C061574
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 05:48:54 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so2311689oth.9
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 05:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6HpoBlmpJ233t0Q6yG7oBMakkTPLqj6mc2Rb8mKRkQY=;
        b=IdkaaxAZAcwnbtDiscGZuZ1UEpjaIF4Vp5j2wQvhfhbCMOBIfkAKzT276rxgbwK3Az
         iXxK/r3JsPCsOy/rAR83WEIMzIfJcBKF6f66ez3MtL6djsOl+UQf8EXeoYBgO3b9dVuJ
         Sdody38CRrLU5TDxE2WlM3RF8tha3MSQAvk/8Ki7WTSqjp3jICePqn+0bCbYoVmWGhx0
         t+vSPLwNnao8U0XiopWhONbo0xoJbbhzIQ5ljwb2cHmeAGOK/x9oOuLzvGqjx+7adScL
         HVQwP2PZq1UnAEwME3in4ViXbCJw30vIuZq+MKe8vSBNmbxHHyYXrqwj4n2udvnb8y0j
         azSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HpoBlmpJ233t0Q6yG7oBMakkTPLqj6mc2Rb8mKRkQY=;
        b=ukGFG+Y5eTF9WIpLIROQzMwjSvEU9WEvp+FiqlpD24w5bTC0l/rdcDqZkwKPHfH7PF
         RhaSFkfDj2MYQ3TW5HfW19moorTPlSG0RCpsnumxaFLwrTWEJEMn/2LuPxnYsZGJE26d
         vxPxIBt4nwYOeFHoa7uCIRr/hm2DtNsuqG8Rjp4Y6YmRwYYcuRKhMYrcrYDufgeLwzya
         5+WWqG4KpIB1RGPssFG5jJfIR4fIwd0+tsTJFfa4cD5Y5gPEUWumCzZcqz+39znfxMCF
         ueCbg/igl7b1Vc9M/HFirNr2oBtqkkpz9LqvBF4TBt++2kNyB6PPDUpNEn0ItJnQu/qb
         cVMg==
X-Gm-Message-State: AOAM532dbqrw/L2Lc9aMtx1YY/ouN1kF+DSMjmTu32epgwyyvLl7cAyY
        a9pHRJ3qO+0yNdoQ7+lrQcLUhQ==
X-Google-Smtp-Source: ABdhPJxYpo/0EKi1vrLFU/GC3g7eh7t7hAFYcywIIDTCmJEeQ63H+5o3IDuR7o3+4BT/Xs2DxCHG+g==
X-Received: by 2002:a9d:6d8c:: with SMTP id x12mr3920896otp.121.1623847733413;
        Wed, 16 Jun 2021 05:48:53 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id u10sm498207otj.75.2021.06.16.05.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 05:48:53 -0700 (PDT)
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.f2c1e.6444SMTPIN_ADDED_MISSING@mx.google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff0aab90-9aef-4ec6-f00f-89d4ffa21ef6@kernel.dk>
Date:   Wed, 16 Jun 2021 06:48:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <60c13bec.1c69fb81.f2c1e.6444SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 4:08 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.

I think this is obviously the right thing to do, but I'm not too crazy
about the 'ret' pointer passed in. We could either add a proper return
type instead of the bool and use that, or put the poll-or-queue-async
into a helper that then only needs a bool return, and use that return
value for whether to re-issue or not.

Care to send an updated variant?

-- 
Jens Axboe

