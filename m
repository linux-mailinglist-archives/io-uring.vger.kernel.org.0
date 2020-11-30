Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3C2C8B91
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbgK3Rof (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 12:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgK3Roe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 12:44:34 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1C6C0613D4
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 09:43:48 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k5so6883575plt.6
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 09:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cfvABh5YtxZzQmbDgFIM5w7aNHd2XpaihkN8Q1Q54fY=;
        b=eBpofPo6jUPwdd7vhwDA4D0nGZnCcbEyGiw1pp0EPAIQZo0Ux5LUT3JvFqGSKIS8SW
         zYbpeLI21jpJ9nzpqXVAuyVGRHCIVP5AA32GIJu8Vo0r6Ve9DJgFQwgjOvcHZCkY2ehT
         wRXqtRtASuBo/PVZm3KYlZmWzzCsjuEF0WGeGDi2A+Q3WxD4OIqZ0BlR89xRZIa3LJGj
         2OMS43lDhGBCyGLj1M6mu0R+E3Tk1yPpZS0ExvT49kPgxeVqxkNOzse664cwJUrRbppV
         Lgp7OCMBs0dXOAHRHDBD3ADuA6ok8XcAeeaQE1gA95dXV+TOJ4HuIU/wcBSChNz2d0/C
         4Nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cfvABh5YtxZzQmbDgFIM5w7aNHd2XpaihkN8Q1Q54fY=;
        b=Pdv4tKHVomoZJadyBoPzU6zNomIHkw2QTCbufT0YwHJYPh1w3mzUaK5nUT8791aRhL
         VRNvsxR18SQDOkzfUi69MrvHzfRBUrAdXyuMC5xi1OzJ9zXuIYyb0xHxFke3Y5spb8JI
         E8xFGS+n3Ib6YOqujktNjV2450dXQ5EgkNpnfHhMK6Xco3AqT4dKrCPAp74hNjqnkISF
         /v1BjAmSjN+Y+p0/AnLTwVFTdeaueY2rmI+H+eSc+lr1Ahbj4tn3eZCWqJ/cUCK6rJST
         74XJwfhprW/CUf85EV2vVDi4GYhIJgiDVQiQfqQzrYptLDLy+5M3mWMiyJuXpxiP3Zvy
         he/g==
X-Gm-Message-State: AOAM533vkkjJ0yGrCwPXrPoKABtUEHu1AcvU/4mUGBFBfeMlM/3Yj3p9
        rW/jRci3jmz6BOtXvda1nuhQ3g==
X-Google-Smtp-Source: ABdhPJzehmwislTaveO+CTBpzGV99y1f6VKoCdcIA7lhlKYNzzPb1uiCyvJVt72jObzPhR74JiHDgQ==
X-Received: by 2002:a17:902:a5c1:b029:da:1140:df85 with SMTP id t1-20020a170902a5c1b02900da1140df85mr19898472plq.46.1606758228271;
        Mon, 30 Nov 2020 09:43:48 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n20sm16480570pgb.77.2020.11.30.09.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:43:47 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in idr_for_each (2)
To:     Matthew Wilcox <willy@infradead.org>,
        Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000ca835605b0e8a723@google.com>
 <20201129113429.13660-1-hdanton@sina.com>
 <20201129122600.GA4327@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <851bd25a-ff64-3d3a-f1f5-f9e4f83c2dab@kernel.dk>
Date:   Mon, 30 Nov 2020 10:43:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201129122600.GA4327@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/29/20 5:26 AM, Matthew Wilcox wrote:
> On Sun, Nov 29, 2020 at 07:34:29PM +0800, Hillf Danton wrote:
>>>  radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
>>>  idr_for_each+0x206/0x220 lib/idr.c:202
>>>  io_destroy_buffers fs/io_uring.c:8275 [inline]
>>
>> Matthew, can you shed any light on the link between the use of idr
>> routines and the UAF reported?
> 
> I presume it's some misuse of IDR by io_uring.  I'd rather io_uring
> didn't use the IDR at all.  This compiles; I promise no more than that.

Looks reasonable to me. Care to send as an actual patch?

This would just leave the personality idr as the last idr use case in
io_uring, hint hint :-)

Would be nice to fully understand why this issue exists with idr, I
don't immediately see anything wrong. But as I cannot even reproduce, I
can't verify that the xa version is sane wrt fixing it either...

-- 
Jens Axboe

