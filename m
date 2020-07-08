Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2936218D1B
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgGHQis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 12:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730402AbgGHQir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 12:38:47 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CFCC08C5CE
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 09:38:47 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q3so28932568ilt.8
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 09:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x40mQIo6pbykjXv9//B5R7xrCzXQXUjihLVbtkiUa9g=;
        b=r2aYBKtmKnJoGglstR/KwDkSizzhk1HKxBGky1uxaxsiNjnLatURQ8I0s9zaue+PKT
         2jYp+Sefs/cWRMEwXBSrJWapxBilnK5oYERYtxceNvh2a3ig16BwFCMvxx+u0sxBP8Hg
         ctWQZjc1WJ/4SB1takLxKbYje1p34srfpN/f47B0sy5lKTP/g5AQ/quiQmfLQNyuX9Z2
         pP/IVD1fb+jLwCEZdn7pT7UWaUmOlZ8gDCfSIeFYNeKTpSeoFEYQ005ezP4mk9Iyz2XG
         CHpOvKnwb++tqbtlESaqibEveYvCl0IyOySYCNm7MjLh3c4ddhQACdI6PUi4eKc/O7C0
         Lhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x40mQIo6pbykjXv9//B5R7xrCzXQXUjihLVbtkiUa9g=;
        b=Gupr5RIuvLqugKhE4NyLsmkh1b9hpqb383TPbERCvnWNW/AeYhb48kSrtB/SpZBMT3
         CUjltiTIxEZlY2a/xwNRM2pnnuXuqyPQFhe5DTa2F4mjFXGT7TGreepjXCiAHudjgUgP
         evFH6bXxCJJPWthUZdqQIuK7d83hjaeYhnhGDPaLUydKD1wboFp1F0hvo35rAyWdBz78
         tEfXIZ80V7TD172em7TwbD24pSjOd+WauHyfdfMmAD/OPyBCpeU0tTUs6PAd1tl0RTc+
         GaMx4Ie4dleC5GP9RBpBfBpvdQuA2sxxlx0TloxvFSfXekm+U49iBtWjB6G5a0r2ZNLr
         6URw==
X-Gm-Message-State: AOAM533RFZhKmC3NW+bwhhu2Kreshs6XEhNvp6adN4qwmYuL6ce5lkLk
        K2Gy7eEcsL0IfIBUjkoISahptQ==
X-Google-Smtp-Source: ABdhPJyTcqfpY26yzbDhop4EBT8zrxwbgeCVTBoxPI2mA4p/uq8qrmaGUFMkhhcemSEieA5vJWewZA==
X-Received: by 2002:a92:c806:: with SMTP id v6mr41972216iln.10.1594226326381;
        Wed, 08 Jul 2020 09:38:46 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k3sm328182iot.42.2020.07.08.09.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 09:38:45 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, damien.lemoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <33b9887b-eaba-c7be-5dfd-fc7e7d416f48@kernel.dk>
 <36C0AD99-0D75-40D4-B704-507A222AEB81@javigon.com>
 <20200708163327.GU25523@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <481e512a-0dd3-ae19-8f32-ed781af28038@kernel.dk>
Date:   Wed, 8 Jul 2020 10:38:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708163327.GU25523@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 10:33 AM, Matthew Wilcox wrote:
> On Wed, Jul 08, 2020 at 06:08:12PM +0200, Javier González wrote:
>>> I just wanted to get clarification there, because to me it sounded like
>>> you expected Kanchan to do it, and Kanchan assuming it "was sorted". I'd
>>> consider that a prerequisite for the append series as far as io_uring is
>>> concerned, hence _someone_ needs to actually do it ;-)
> 
> I don't know that it's a prerequisite in terms of the patches actually
> depend on it.  I appreciate you want it first to ensure that we don't bloat
> the kiocb.

Maybe not for the series, but for the io_uring addition it is.

>> I believe Kanchan meant that now the trade-off we were asking to
>> clear out is sorted. 
>>
>> We will send a new version shortly for the current functionality - we
>> can see what we are missing on when the uring interface is clear. 
> 
> I've started work on a patch series for this.  Mostly just waiting for
> compilation now ... should be done in the next few hours.

Great!

-- 
Jens Axboe

