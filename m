Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA0A406B5D
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 14:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhIJM1r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 08:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhIJM1r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 08:27:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5641EC061574
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 05:26:36 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id a15so2051658iot.2
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 05:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PZiF+LBzYrosUA4eeunMHOCR8oTyafy44KB/Usk+Pco=;
        b=1HN+br7mrTHqAK2dTkEGagDLi6yO6T340Px7atAshHKc0pzTaJPeoOl/3smc4Smkxl
         wUpBS2TIfminfvKjW8e8KxZBNLVlYPre1TEFw1lfhHimzeYZGJwR2+fJuxG1MnyVeJVT
         OgJkiXVlSXHpSVLi0O+4tj6p7CY3c7LJ33XG2c7drxEUjd4GLKg52zNZAeG9hLySc7J1
         wJZizxTQJz3/aWwfZDFnq4JV4B7bgOOvgTiwNZkASl6Kg5/OKfEVb82N7wm8AV9cN3AT
         0A1UBtkLguC5amua0f3J/6oB4wTDZNch3h3IhYeiF98Lg3IoTPJkUtV1bFP9F/6lNf4D
         rVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZiF+LBzYrosUA4eeunMHOCR8oTyafy44KB/Usk+Pco=;
        b=mcdoY0Aqs7HI/wRaAmWzJfqw1BdekfV9ZLzsH+Rj+sp+7/NYEUrRIrQwxbOIUpksKO
         zyUoRUS/oyzoj9v2MXyTE8NRBYOkHCOveKZpp+gU93Biy2LcQ3wTaiC5aiYoMWNLU6XJ
         wF+lnjQswGPK4B8V0C53PaQXs9ZIJsGx5Ih/JvdgI4KV3HKk5UD5usrOf13XXv1KEVKF
         seIIxUo636TnFzfl7g/0w/k8OVKs3n6M0yzqiHjBw9wSi/t+TfbZkY4sW0KPJEiLlBnO
         j7TtUycTWCJ6qKQfzXsFh/Kark84XpIzd8y8kZnAsh1jbOrICPEFEuCBVkGDlpPlzH3O
         nLAg==
X-Gm-Message-State: AOAM531iU2bW8PFT1kmaLfGDWZEdgj3gXCxX1ckEDAyZD6xpD8x9SHXZ
        lNIRQ3f3w8F2hsivWiyXewYjXA==
X-Google-Smtp-Source: ABdhPJzG52fq+pmlpqZ5NWphR0lp3joefOPhY64YCXWl6vjjIYdadak8fHjDlDQR7HBi1iyLio/8cw==
X-Received: by 2002:a5d:914b:: with SMTP id y11mr6955081ioq.6.1631276795687;
        Fri, 10 Sep 2021 05:26:35 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c25sm2404250iom.9.2021.09.10.05.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 05:26:34 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: fix bug of wrong BUILD_BUG_ON check of
 __REQ_F_LAST_BIT
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210907032243.114190-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d1e8cf46-7a12-a93a-47a4-ce68609dfc1a@kernel.dk>
Date:   Fri, 10 Sep 2021 06:26:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210907032243.114190-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 9:22 PM, Hao Xu wrote:
> Build check of __REQ_F_LAST_BIT should be large than not equal or large
> than.

Thanks, applied with a bit of commit message massaging.

-- 
Jens Axboe

