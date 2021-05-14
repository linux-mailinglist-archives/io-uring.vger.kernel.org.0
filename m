Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927E1380C48
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhENOww (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhENOwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 10:52:51 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C260C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:51:40 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id d11so7790315iod.5
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PiKn20pQVz0cKTRibA5Hwn+RgAtZNHvYeuu7DlSwWm0=;
        b=w1DX5uvDQMImj0jtBYOMpnBIcecoLtoQWJdobqhcf01Sj4DzzPKlZ7AmzXrnKsPG2s
         IiRnSDlKWugct8DSfsXzlq3AAIGfEQYnF6w6EvMbOBrd5DSs4bXOWnXG2Jcg4AEcZRcv
         0tgFO6hmKAJJv0As+YRSBRi/OCWWQ4SIXV4t/qffdLT+WBDDEH4XxLWnNpZMTZGkY0Ne
         TdmQ26CroLQA1AMs0hRCgf4Rkdnkab4g8zcjW+EMh0eNtNby44pAMYWwTDLbrf9ebBfp
         vvAbaeMxZZFLhEQuVKI/qTQ41yTu+QNbH1E7xDD1t4KOsBI1I1rgrNrK1kHJlT4r3hXG
         zLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PiKn20pQVz0cKTRibA5Hwn+RgAtZNHvYeuu7DlSwWm0=;
        b=JVwzMBHdF1hRYAmtWtUAjBpZXlN6xZdElAM9Dovz7io1wGcHxuWhPLXem6UWCzvRoe
         +o1/3aMQSkuwecNw6ehu12Ju3w6cZwZdqZXDb4BRoybNUV2Xq9I6vw7nlhgmpF+ypFxj
         iTw0PdlOSGhmdicU+8Gn6KAdDlVNjYaprfFfpUqgcH3JcJjzwF4mWgqF+N8FteN1JN11
         ZeVQ7muLT/BHoVBhjQKaU3VIsBHz24Zn0WQkSIwMh/g7+xGm29lcCRb0/RjkfHcyEkXR
         lXhgL6UIb1JrczVpz9BF7ov1Rw4Fw/gMvYd6rzgqdymatDP8K1VqiBfd0QqF7A3YzJ2l
         rfgA==
X-Gm-Message-State: AOAM531zELmPngn70SoZ5onlWqffT9h6P3TGD0uV9p5bb/au7rGMZOQF
        7ZpH8v/LKD7HiZveagUGJ9nOO9GDRfDWcw==
X-Google-Smtp-Source: ABdhPJxHxNPWlGVlzsPWvz3sTjl2zsvDgSSf62axZLXSE7rNkrgz0x256hQ4gDJ5tz4yE3ClvK+6Ig==
X-Received: by 2002:a6b:7c0b:: with SMTP id m11mr35297106iok.9.1621003899792;
        Fri, 14 May 2021 07:51:39 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p16sm149330ile.71.2021.05.14.07.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:51:39 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix ltout double free on completion race
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <69c46bf6ce37fec4fdcd98f0882e18eb07ce693a.1620990121.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <98cd39d4-31c5-1cc0-84c6-f4573c6b13e5@kernel.dk>
Date:   Fri, 14 May 2021 08:51:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <69c46bf6ce37fec4fdcd98f0882e18eb07ce693a.1620990121.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/21 5:02 AM, Pavel Begunkov wrote:
> Always remove linked timeout on io_link_timeout_fn() from the master
> request link list, otherwise we may get use-after-free when first
> io_link_timeout_fn() puts linked timeout in the fail path, and then
> will be found and put on master's free.

Applied, thanks.

-- 
Jens Axboe

