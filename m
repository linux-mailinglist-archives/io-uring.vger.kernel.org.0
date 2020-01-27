Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4D14A5AE
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 15:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgA0OHU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 09:07:20 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:37203 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgA0OHU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 09:07:20 -0500
Received: by mail-lj1-f172.google.com with SMTP id v17so10812749ljg.4
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 06:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4WamNq5r3oRcgSyaStjgL8h3KYO17ip65FA05Ro/4Lo=;
        b=Ppr4X8HgMuWoox/5bW+0en2KEPHvdyb9PqI9iQNFlFqHUMZDNJmAyQlBLjvPDiaIm5
         9d+bpf7/y7ghwABG5UBM+wDZQ0ReNDExqVk93aNK9V4S/O7Vq4tfglUm4S2B8/rLywym
         7Q2B3lmJ3eX0U6LCHoyOoz8+OqpzhAVlbN3DoPPCXM8sWYSRRRmjA5zD6X1zwc9tskoN
         pUFPw9JUBnjNgWpwiMdhdqUYNK4kmMwZNIICfyGcC5OOFRlzBdMs5m/JQ4PYhKVWJcMo
         dQJol8HAUksHDICECuFT18TM9lQhk9G+Yc/9eyrNyepg4BDdMo6MBvBnLiWGKjsHTiXd
         GctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WamNq5r3oRcgSyaStjgL8h3KYO17ip65FA05Ro/4Lo=;
        b=RAAE9k2JHoGSAAKroWAxArFRQ0/QmJUBB/kZvwgC6VWE3Cqc0t9b5cNbbLfXesBquy
         x6Py1RdqyAB4Bwi0NgXzgwOv/znGFNGZPsmlkk6VMhutoKOrVbj7a8Xgr3H8NsVYRzpo
         ntomP0vXD+NQVBJvgzPN0ROpeI6JrSQ0yj90LeB8PZngeJrWoQv35c+xrPklvwNrvEuJ
         CKLD4YULxVItbxHcJiacEkgvcDvT/V6ygyZNJ2rYMzLjeDQeh/p9H6XyCm/K9JmvH7/2
         VF9EKFcHujnKUkJwlF6tCfcOmY816pwOHSiqmG7uDOskdsJk0K+mHtYosc/SyOEjF4Dj
         oKiA==
X-Gm-Message-State: APjAAAUN6lRAF1cmF23LYYCim1lZn6cq0EyS9cpPeAnLyn40ovXyoCL9
        2xOSy+RB4oSs1BAAbCxAx3DZGLmiVfE=
X-Google-Smtp-Source: APXvYqzvaGOdW6/I35VuX/8TvSmb4nqBli61TD39+NP0zLpNaapjQQ8BL9XLWCxAyPeJSb1d6SeoaA==
X-Received: by 2002:a2e:8119:: with SMTP id d25mr10358709ljg.76.1580134037792;
        Mon, 27 Jan 2020 06:07:17 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id i13sm8232454ljg.89.2020.01.27.06.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 06:07:17 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
Date:   Mon, 27 Jan 2020 17:07:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/2020 4:39 PM, Jens Axboe wrote:
> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>> Ok. I can't promise it'll play handy for sharing. Though, you'll be out
>> of space in struct io_uring_params soon anyway.
> 
> I'm going to keep what we have for now, as I'm really not imagining a
> lot more sharing - what else would we share? So let's not over-design
> anything.
> 
Fair enough. I prefer a ptr to an extendable struct, that will take the
last u64, when needed.

However, it's still better to share through file descriptors. It's just
not secure enough the way it's now.

-- 
Pavel Begunkov
