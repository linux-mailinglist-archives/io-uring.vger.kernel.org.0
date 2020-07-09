Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84202195A8
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 03:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgGIBap (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 21:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGIBao (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 21:30:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444AEC061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 18:30:44 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id m22so213439pgv.9
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 18:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QKKI1Yt7F+lqF3ef6fWtreLtNbrwpQdeh10uISNf+2g=;
        b=lbNdNNcIAprVE+N+egT0pEQLTQAhpINamU/bavfxQDherm7/3cgkGAWHwORdF2ktLW
         eXx0E+3boLvBpRgXYTRYQvnWU6kd1K47hpBRe2tOB4Ve2iA99Bv1t8omc42xOFvBk4vK
         j4Nt0qFHRRNsRlXvufZ4vEbZo4TVvraDX6RZHICRjR4sHjXjYbb51UeZ/AQnWvRljpPk
         SKaE45/ATXqiU5M1zMXVqxgDZSi2Mknn8R1zuLCDI9DF1EZ+VbpWrRhrynUuVL9Nbk/3
         /VXagnpi0vyw+vQLzFy9VbyRgokJA61MkV4BaA0sNhg3VKHzOh1Oip8baVyBTFnF5sj0
         PzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QKKI1Yt7F+lqF3ef6fWtreLtNbrwpQdeh10uISNf+2g=;
        b=P41a8mZBxcpf/Jj7+Ii1XskeVZwFP99cvW27ys/NIZYrH5oh4m5J6C2s9bPUtQW0jO
         5eJfYxe7d5QVsOETE+9VBQnhFdNdPnbI4/E+zrdRJurtw8u+fsC9rBuoBnwC/LZXtUOI
         2LevdRQIHfVdof6vrhsI6ERWsF2apMkJkvFjGkmN5I6fFdu1k3Lmlan2Ljg4IzjkK0ZH
         Rb632XyCvScnIwAQxk2/1tc0KwmPsVtQhb0pPUrpzaCMXZvo4c3K6DuPdPd7eDmX6391
         ByXIMz2TFdvR1fcxL8VZtYdwbgT7PzK756h905mcIPLdejeqRKqs3NBKEaI67x5E01mB
         xLmw==
X-Gm-Message-State: AOAM532DHbhWwtNnnQmWXkn++5yL/IZjso+EFYc/264XscAUEtM9wGa2
        f31Ct1D28HGsCMf9WXc7m5VdxMIDjTxhlw==
X-Google-Smtp-Source: ABdhPJzEKwZyLQFWXNA2zppBayUTDZqVDc6fDNcek9Rre1egLkKEdoAERf/cuf5SEBlZ54fsRKXghA==
X-Received: by 2002:a05:6a00:148c:: with SMTP id v12mr55232062pfu.171.1594258243844;
        Wed, 08 Jul 2020 18:30:43 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c3sm855815pfo.203.2020.07.08.18.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 18:30:43 -0700 (PDT)
Subject: Re: [LIBURING v2] Check cq ring overflow status
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200709011620.13666-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0715d1df-5707-29a6-d427-8c6e586bdd99@kernel.dk>
Date:   Wed, 8 Jul 2020 19:30:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709011620.13666-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 7:16 PM, Xiaoguang Wang wrote:
> If cq ring has been overflowed, need to enter kernel to flush cqes.

Applied, thanks.

Also added a test case for it.

-- 
Jens Axboe

