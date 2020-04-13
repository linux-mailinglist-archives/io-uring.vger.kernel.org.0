Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C8E1A6F19
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 00:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389551AbgDMW1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 18:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728187AbgDMW1P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 18:27:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC79C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 15:27:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i3so1087499pgk.1
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 15:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KKumdgmUXdOOi/uTSdHAFP4TyDy2BhnvvMRyHgfcPYM=;
        b=KclZ+31HOkdQmaiewdsobbntSf0QqJ5Lv/lNLEasaZxg7jY8ekH/17vIhtt8vRr+ty
         CD336LKTVp08Z5/D/DZ/ZclszfwbrV0HupRbOuv+3hcD90K+eiApzeimW4/GKix7n+Dh
         +rb5qlD6xWglz3paBYwyyMXr4T7hc6LoXFVH1byobvFk6YL7AoYE2j+ArWo6KKqSjGvS
         qRK5lZJ2SlW2TEweCwbenqhCVlCPCbTzJvyKs2zNS0hcfB7co1uTc50dk+DWtOWKXCKs
         lTzSkHZNhexN0ZW5OzCFB4r0Ek/4j+NumIx+2xGa7ykycVJZHLp/RxGIYqokCukr3GN/
         HtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KKumdgmUXdOOi/uTSdHAFP4TyDy2BhnvvMRyHgfcPYM=;
        b=r1MJ2jeoPuaqDHQQLRlamajFElJmbZExwVycRS9e71asv16M9JLUy7/adEcwm9zqVw
         CmkNfDkCfn+deIgzNQ8fTX7rHjtIH1q2gUFAHbNDXDw3VSmq/URYHcUGfU54IoJAHHAj
         NNIaGeRc76vT14uSN+L08un/oZ/QPmtJ35Sdr1JePU1w/T/YT/TaxIL+IUADQs6iX0NR
         Y6Khn8q8EgcjpgxaqNUj+Rai8vy3I5gI5/gtE/41lkWkWi3hvLSZbqKg4GMrhMvcmcsl
         sqBMQknXi1Yotu1CryM3EgQDoF/AsFCz9KyYTDzE6Ph6xWgaWX9Hc2gzNitn/v7qFRvD
         hlIA==
X-Gm-Message-State: AGi0PuaNMFhrNYmC9MW1PdltE118RQrJuKOUSB75tY6Y5MWS7rk4dRE1
        SrBMz5C8D3wABdHElCKwpCpHH52B9YFgQg==
X-Google-Smtp-Source: APiQypK4EFfNieAqe50enoC5qEljDgnFpHW5i6y0AORQY3WfFU+mzmDbmPGtoEI5oxvjdgQLICPneQ==
X-Received: by 2002:a63:296:: with SMTP id 144mr18958088pgc.110.1586816834639;
        Mon, 13 Apr 2020 15:27:14 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g40sm2274015pje.38.2020.04.13.15.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 15:27:14 -0700 (PDT)
Subject: Re: [LIBURING PATCH] sq_ring_needs_enter: check whether there are
 sqes when SQPOLL is not enabled
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200413071940.5156-1-xiaoguang.wang@linux.alibaba.com>
 <949512f3-9739-5514-2daa-1ee224d85b90@kernel.dk>
Message-ID: <710c6862-1fb8-0df5-bf4d-5c1947e932f5@kernel.dk>
Date:   Mon, 13 Apr 2020 16:27:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <949512f3-9739-5514-2daa-1ee224d85b90@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/20 8:18 AM, Jens Axboe wrote:
> On 4/13/20 1:19 AM, Xiaoguang Wang wrote:
>> Indeed I'm not sure this patch is necessary, robust applications
>> should not call io_uring_submit when there are not sqes to submmit.
>> But still try to add this check, I have seen some applications which
>> call io_uring_submit(), but there are not sqes to submit.
> 
> Hmm, not sure it's worth complicating the submit path for that case.
> A high performant application should not call io_uring_submit() if
> it didn't queue anything new. Is this a common case you've seen?

Looking at it again, it actually seems quite reasonable. I've queued
it up, thanks!

-- 
Jens Axboe

