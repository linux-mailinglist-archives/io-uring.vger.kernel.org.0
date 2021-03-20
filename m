Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2C343038
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 23:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTW6F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 18:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhCTW5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 18:57:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050BDC061574
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:57:44 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t20so4649229plr.13
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 15:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O66th9jq5EAf7z7EOe17UtEcZtIhva9jOuThNp0T+80=;
        b=BNeiqVO6IisukiKm/LeCM4dzOHGpYZ7yhFx5mptFO+GPsZB5rsMXwepBIzAaBNkV6W
         2xfPFdJzsPVevADN06+cDjGoYEvppokTpiInYZCb2/G8Xa/7hNfj3XJzD1a2FFNPE+9P
         I4gv7gyNyXyLYGynNu8Y4tIcC9q8UEBvJrnywjiGI6676GRwu8HcD10nkUuF5YM0yAAW
         EcFHT7IhW3GUvptr2l+rRJwHpJxv9Ia8t1/q4d8bd3Lg1dHna6Sxlqgu6mmUr6zxribJ
         FGQuyzdFFp/PgKeDxUc45jZEOB1v8ysKZLHNcITX9qTVj0wXUbfnXkSwD90EahGuUuIH
         M4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O66th9jq5EAf7z7EOe17UtEcZtIhva9jOuThNp0T+80=;
        b=els/kzOXgt/lxj1hMJvF+uNUHJG1r3vNN46bnjYKX1J7BMJhz0buHwIxnsTYMfg1/7
         8xDqeovjyZQf+pkZhYHpngnNF1TbBa8rNF+qKXmO192lWUjocYHzOu+mDM9w9KN1WFVq
         1mSKYUfK+goZJYXuyJ7f84WQzH7nrP1Qn+0eGkRm42W/MUwchEScG2/NGxGSlxorD7qF
         sWHBYjcROyulrhP3PpRcP+RIAUU0xT9xK90Dk2d4BY/qteFLL3TglBzmpyCKcczrOsgr
         3AIHjcqp01GvV4MVEnPuEWqQIFY7heWZFW0ksUG/dPo5XWPrGeTjbs7iUNtM+I3V0yl8
         BNkw==
X-Gm-Message-State: AOAM530dqGHriFbmVgBx354XC3BAWTdjFOYPJLnta37rpQJlwRsI57VF
        /6vrtHeAnVvbNOe34kVr6WHbCw==
X-Google-Smtp-Source: ABdhPJyIfaD8BJx9PMzRgtcESjyjV0ou5KlbMF1A3h7SO71ex7ukvSThKgAprtnqVslM7bK2VWKzWg==
X-Received: by 2002:a17:90b:3587:: with SMTP id mm7mr5375533pjb.21.1616281063581;
        Sat, 20 Mar 2021 15:57:43 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j20sm13339994pji.3.2021.03.20.15.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 15:57:43 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] io_uring: call req_set_fail_links() on short
 send[msg]()/recv[msg]() with MSG_WAITALL
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
 <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38a987b9-d962-7531-6164-6dde9b4d133b@kernel.dk>
Date:   Sat, 20 Mar 2021 16:57:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/21 1:33 PM, Stefan Metzmacher wrote:
> Without that it's not safe to use them in a linked combination with
> others.
> 
> Now combinations like IORING_OP_SENDMSG followed by IORING_OP_SPLICE
> should be possible.
> 
> We already handle short reads and writes for the following opcodes:
> 
> - IORING_OP_READV
> - IORING_OP_READ_FIXED
> - IORING_OP_READ
> - IORING_OP_WRITEV
> - IORING_OP_WRITE_FIXED
> - IORING_OP_WRITE
> - IORING_OP_SPLICE
> - IORING_OP_TEE
> 
> Now we have it for these as well:
> 
> - IORING_OP_SENDMSG
> - IORING_OP_SEND
> - IORING_OP_RECVMSG
> - IORING_OP_RECV
> 
> For IORING_OP_RECVMSG we also check for the MSG_TRUNC and MSG_CTRUNC
> flags in order to call req_set_fail_links().
> 
> There might be applications arround depending on the behavior
> that even short send[msg]()/recv[msg]() retuns continue an
> IOSQE_IO_LINK chain.
> 
> It's very unlikely that such applications pass in MSG_WAITALL,
> which is only defined in 'man 2 recvmsg', but not in 'man 2 sendmsg'.
> 
> It's expected that the low level sock_sendmsg() call just ignores
> MSG_WAITALL, as MSG_ZEROCOPY is also ignored without explicitly set
> SO_ZEROCOPY.
> 
> We also expect the caller to know about the implicit truncation to
> MAX_RW_COUNT, which we don't detect.

Thanks, I do think this is much better and I feel comfortable getting
htis applied for 5.12 (and stable).

-- 
Jens Axboe

