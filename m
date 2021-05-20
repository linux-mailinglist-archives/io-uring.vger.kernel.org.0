Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2CB38B09B
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbhETN5B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 09:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbhETN46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 09:56:58 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA1DC061574
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 06:55:36 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r4so15938442iol.6
        for <io-uring@vger.kernel.org>; Thu, 20 May 2021 06:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nStRuVGNgQdHuT41nQnyzjIO/2Ry634+v0gjDFZnvOE=;
        b=bTaNErluaVYO5qtQnyp2BYhHJ15+PA8o+KcJ5NrExneqd4UAKRvYkgHufwc2UBaoy0
         yitTNA7X/kJg2f8lLyjQASFjcJ186e8AyjD2PxGIo2dNeo/LyCBfqgM8lrC6YdojiV1Y
         pC9PP93Wp7RR21YTeGBSgReo13mGcXgSOuNijDpo9/Z9YRAOWLMWd9D6yhLTHGPMfchT
         68EFrUB8gK0uyGRAoCMKW5FBOsEdd7oee/R+RrIemHKdcKVOxRrs6zsxtVtCcWFUw9TT
         j/IZiVwlUXnqLs/29vh4uWjxQ75tnrp9M+IvTVo7X6cHVt30OiAZl206T/q1f8ogR33U
         GWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nStRuVGNgQdHuT41nQnyzjIO/2Ry634+v0gjDFZnvOE=;
        b=Evqvn+FlIimICaDcuVZORBY0PfRq8G1REy0uOT46EHgGhAWhOTjVwsOhQb8kiwxc8R
         pkQ06l4Ufh8edJd4cF/FiqA2vyQOinT7y9/G2d8gp6maxipllyJOhW0qRxjgEkIGyd0x
         2WfHGhtHuC3naTuUbvZMJUZ4rWWJwPw0d2dTCTKdqSCvkI8bcfOZkbe/YZUb3lEs/HMG
         KaurqwH6dLaegCcxbTih3rCmNm6HLNTRj+eu9Jeg/fWCWQnhCMX+tb4xLSEF6VB4gD4I
         nrMcw1lr8vyy0xTJpZi9oafzGOHk2Ew6K6fVK2evPgtYmzg0VK+nLQ+Lzu6l0legPUbW
         koww==
X-Gm-Message-State: AOAM530RN9nINKyvvHQW/n2R5WqnmVqEguyjbsMJb5FmuZWFaEhnZ15B
        FROCVjLMa1CG+XZfGXDNdPkyBL6M0wJ3+w==
X-Google-Smtp-Source: ABdhPJxVxoRXbKCg9YzCOJlyRlT53CXmOAB8sVm3geGHHSX7ZvmU5WXz+KawDNVdAk3akO0mPH8RBg==
X-Received: by 2002:a6b:7b08:: with SMTP id l8mr5351703iop.50.1621518935302;
        Thu, 20 May 2021 06:55:35 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m18sm3171937ioy.32.2021.05.20.06.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 06:55:34 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: fortify tctx/io_wq cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <827b021de17926fd807610b3e53a5a5fa8530856.1621513214.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <224ce647-a4f5-93c8-a8d3-84bfaf338f42@kernel.dk>
Date:   Thu, 20 May 2021 07:55:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <827b021de17926fd807610b3e53a5a5fa8530856.1621513214.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/21 6:21 AM, Pavel Begunkov wrote:
> We don't want anyone poking into tctx->io_wq awhile it's being destroyed
> by io_wq_put_and_exit(), and even though it shouldn't even happen, if
> buggy would be preferable to get a NULL-deref instead of subtle delayed
> failure or UAF.

Applied, thanks.

-- 
Jens Axboe

