Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E02F40C2E3
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 11:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhIOJlN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 05:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbhIOJlN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 05:41:13 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FE0C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 02:39:54 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i3so1629292wmq.3
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 02:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cvOAIIMa4ir4mtbjMNf7vuX/kLdm698F67r0e1lN2a8=;
        b=Jh2aTJsenszi4n9R89In03homzsfalN673CTjv8r62GHvWKLc0ouHNJSEoWgnP5hiB
         ZVGx2zeJR/jLUqVWEQk/9rJYuVpZ3iS6QffOLyM/3fCy5R3sP80YE0DvTet5ASgr+CUK
         Wq/wGKcVoJZ4xSVzYIHFYvKlNTFinfr2IoOeeGiRvPHE5J2ZTGfw++RA/tjPUKwIvXCF
         Il6m2Gcme9KCl30heHJIYNPR7YuV/KVtHff+TDN2Nwcbz3rYo2Beh0Zh6yDSpYY0Fgzr
         9qoTY2tISfEvyYq+H4QGVaS4DW3IoI5XtMML3f7zttBjOB6WP940H0CmuPVS5bV3kVT7
         efAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cvOAIIMa4ir4mtbjMNf7vuX/kLdm698F67r0e1lN2a8=;
        b=UKqhOevd0HOps4BbekoK8R/3/uErXkXkU576+x5OnfwKgaFJOdu+3/wQawldMmltNu
         u8DdxCqKgkZT3FtWYmd40z56EKsbYwxKfsD+dTjrHK8E7RUcqzUYRm+5zm3K+ES45cuD
         fOD7HzpoSOTVe7IlDRyJfXngWWI23oqJ/xt5NlqqgA1dxAAuxeZqoN2yhbdJG6ApeD7f
         ZlrSiYGfm6ghEHN99vEJL5nHYI8BeCtwmPCoGkNWWm+eeOJqFKealYpLby/VZpds5NKz
         0jdfm4LlVVvMFXuKEk2Y/FEzdNYkAK0np514degUKcECOxOeOH8CVSgmFGB+I0JpH84+
         0S/Q==
X-Gm-Message-State: AOAM531N+t5aMsWygplD0ClJCZOTwt+XU7FA2l53YETUWty8KrTFcvoI
        Njx2zbtsoMy+vRo2Oat2kIa5VcIqCrQ=
X-Google-Smtp-Source: ABdhPJxK57Bpec8lqoOtCoEi/aQKnltDH6lwwvYp7ozhXJHwbmrL1Xmrb4BtdaZk+VEPeRCeN6oM0g==
X-Received: by 2002:a7b:c048:: with SMTP id u8mr3366417wmc.113.1631698792762;
        Wed, 15 Sep 2021 02:39:52 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id z17sm2532471wml.24.2021.09.15.02.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 02:39:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: move iopoll reissue into regular IO path
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <09c645bdf78117a5933490aff0eea10c4f1ceb0a.1631658805.git.asml.silence@gmail.com>
 <a28f257c-6ab1-8beb-a797-d89c48c3cb62@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <28d60cb5-04fe-5213-83c7-7178bb9e06ac@gmail.com>
Date:   Wed, 15 Sep 2021 10:39:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a28f257c-6ab1-8beb-a797-d89c48c3cb62@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 2:14 AM, Jens Axboe wrote:
> On 9/14/21 4:34 PM, Pavel Begunkov wrote:
>> 230d50d448acb ("io_uring: move reissue into regular IO path")
>> made non-IOPOLL I/O to not retry from ki_complete handler. Follow it
>> steps and do the same for IOPOLL. Same problems, same implementation,
>> same -EAGAIN assumptions.
> 
> This looks good to me. But I don't think it's against io_uring-5.15?
> Trivial reject, but looks like -next to me.

Was checking out to io_uring-5.15, apparently something gone wrong.
Not only that, but also a chunk left un-amended...

I'll resend against io_uring-5.15

-- 
Pavel Begunkov
