Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75523310D1
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCHOcr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 09:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhCHOcY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 09:32:24 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E4C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 06:32:24 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i18so8953134ilq.13
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 06:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aUxcXLTdSBxy4yLqfk9xXa27Ev9RhDVQEVUW6lZ/nmU=;
        b=sfs84enJE5AJxt3T9bBQV5+ZL0vTI8Da8q7OdsTk7CTY4rRZbL6+qNy0f5l6CEt1ka
         BESzxkpWPyz0w8uZffetiGIN5ZTukd6voHtBw6zCiHgTVr2/pK28YTz6aSrBB/5lGRz3
         pThjFUFRPSwsewBu+/zUVLWIt7CetOERSChjbDTcMuTkAnjldMD6Roh3KggasuziKHli
         QwcgZSVLOtKZ7CdRxAO+gb9ZocQyOHWBsiysq6IMlLBoevuOnaPTMLsM0N71ehmajmUM
         Hgjf/Boj3O9tgxO/O26edPQzJPP0+Azis+W+qiXpWhb1wGBxX8CIqcGyRj4hFxNWvzj/
         H+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUxcXLTdSBxy4yLqfk9xXa27Ev9RhDVQEVUW6lZ/nmU=;
        b=a/zugV/ZC9LwFoY70EoG4qEks9YoKq4EqEgwjO/bS3hS18pzvVswspvUiLE/bLAxQk
         qbMroyEIE631OAhp2t26XmIFNYE1J9OHewF7QQXZiLYll9polyzyhGkeFM7chDFBwrzI
         wdybA1Wcx33vLinSuIqmlCzpbsHYRvdgqRKdiIMBbbZXauk1P8BkONVsknrhH6cFWthL
         RPIAq/ZqFcyyWJWUxPAULfxlwK5ug2tLPc+dJAoDLBV8+/mABeVBssDr0H+MhLWmuq07
         Cqjog6/kuvDHW1grp7B0f8zWFmYH6Ca2mOOrvI3O7vAl94Jj8zTRUEzs3QzVzznZRIak
         WLwA==
X-Gm-Message-State: AOAM5324eXpJbsBYXgsv2LVn9dLImB9cnH6Y64ZjhcEgxinv9Y4G/0FR
        YX7JsAg2yfr7J++8oRyXppFbGQjexeJ+3w==
X-Google-Smtp-Source: ABdhPJwD4K7dNetpA7kM8UbJWZejKSa3qGshugFQ/exO9Wq5JyRt4GJ4iTkwQK6laI1qV1afIXLg2g==
X-Received: by 2002:a05:6e02:1bc5:: with SMTP id x5mr19742283ilv.48.1615213943837;
        Mon, 08 Mar 2021 06:32:23 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w6sm6274017ilm.38.2021.03.08.06.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 06:32:23 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: fix unrelated ctx reqs cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b34efa4aeca7473d884f204961839b30a292e2fa.1615205524.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ce62cdad-2b13-4694-830f-aec83b43b3d4@kernel.dk>
Date:   Mon, 8 Mar 2021 07:32:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b34efa4aeca7473d884f204961839b30a292e2fa.1615205524.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 5:14 AM, Pavel Begunkov wrote:
> io-wq now is per-task, so cancellations now should match against
> request's ctx.

Applied, thanks.

-- 
Jens Axboe

