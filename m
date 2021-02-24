Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3864632359B
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 03:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBXCVW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 21:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhBXCVW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 21:21:22 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A49C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:20:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u12so50432pjr.2
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wudnEDgvBpSdnsrkkX0kyE+MejaJglRxKlGjYUQFhMs=;
        b=O8CYCH8vAymp9Z+i8d/HDDTMUdAApsRGRcK2/WvhLHg68tJOlUsqGyEGudWzv/rPbC
         /sfjNfdQHo43pbFVBRH6pYhhINsNrKHFhmz0pVLbFbVydEnkamhaFc8OU5pMQ9zWk8aK
         at8aCXytnqdw8uBv5d/c4Gu9bMEFvJt0PE4CflJhy4gpGS4nWR2DqhNIR+yBAXP6rXRV
         MlISCE3n2DCFKf9S9GQEKqhG8aSoSfnQIhA+EFmgzH6VNGDOIMBW2ChYkLw+fqQXyYwW
         72h2/23UcVNubf5Dx5eWJMyfGAQ4n4lxTRbQKd/NMfwdYEvJgHTHacrdt3ElP1Cu12PD
         DScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wudnEDgvBpSdnsrkkX0kyE+MejaJglRxKlGjYUQFhMs=;
        b=IhgXbMn9qmcVkFC9ne2LXYcc7tfreY7YuCcDFVUrcssTyVH5k2vBwXf8KAe0sQcn2q
         8MHe+lnFWjJ32i3POGt/0H2Q9rTAYyZ2TQMois0LBuZZ4APpH1DJemVc8p8GoAlqGpPj
         JnXaHUMQeaQ0kxW71MRJmUJC0HsW+F0N8h+9K0/glN8g3aRAw/d26rXVqxl7jUI7fs+U
         4oKThBH9D8dr5ajDArtwLdpINBJrRSnEGi029w8lPT254PgWyia20oYx57URn03jKJUz
         n5lljqpu1K3077whxLpYRePqXBz9E5Uxn7v5lw9V4r76zr/8Wo9njZq2mHKjRYRfj+Bt
         4qJg==
X-Gm-Message-State: AOAM5329lXlTTgTO2Rukz7TvnO21UnX1xIucSEsAdTxtLKB7OTSH2J9d
        wEdTwNmmi3hGJx0T+djxkHwd+0SvxqavXQ==
X-Google-Smtp-Source: ABdhPJwizizdnuLISU93JpZqlQCiiiBl9VDn6y/xrz3SwRe9eXysD5GFDu0SdaYkGcttOFm6btk2+Q==
X-Received: by 2002:a17:90a:5505:: with SMTP id b5mr1880238pji.194.1614133241725;
        Tue, 23 Feb 2021 18:20:41 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j73sm485184pfd.170.2021.02.23.18.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 18:20:41 -0800 (PST)
Subject: Re: [PATCH v2 5.12] io_uring: fix locked_free_list caches_free()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <feff96ab5f6c2d5aff64b465533adcf59ec21894.1614118564.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f51e9b6a-4a40-4b17-35a5-1ad2df1276c7@kernel.dk>
Date:   Tue, 23 Feb 2021 19:20:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <feff96ab5f6c2d5aff64b465533adcf59ec21894.1614118564.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 3:17 PM, Pavel Begunkov wrote:
> Don't forget to zero locked_free_nr, it's not a disaster but makes it
> attempting to flush it with extra locking when there is nothing in the
> list. Also, don't traverse a potentially long list freeing requests
> under spinlock, splice the list and do it afterwards.

Applied, thanks.

-- 
Jens Axboe

