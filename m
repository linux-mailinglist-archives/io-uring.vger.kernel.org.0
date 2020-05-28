Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497EF1E6A94
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 21:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406499AbgE1TXc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 15:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406205AbgE1TXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 15:23:30 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C93C08C5C8
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 12:23:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 124so46202pgi.9
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 12:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0gA7Ac+73j/XnZFQi1m6vn3pC8smRbdUm5Fe8cbDyhk=;
        b=Om+LVat92f7RfQwrzgyYFTaU+jb22Q8KiUAmJI9TaxaK/Z2+G02Sv/9APyzywDHAQn
         Ln7QkPtqftmBgBAB4LCMNXyvhNZcFe8XgdR+LctT7cHTb7V1DqY9dhhRoe985ljMbbmu
         jnAscOpB5boyeZ/+SkqORtmWOqSkQoGaXxGTGvwSDDd1XkBBBQGdLBLlrKaHV2mH2EMx
         P/kfVgurkkRRin6rXHRfXKstHnWkUQmCEWiv4r734Ng8gwmHlxhUggxP37jQ0QixIPnG
         2WV+sl52+rHWgakZ+AFjDeD7H5Vru2/of/jrruf+PyAE9qImbd6R88VyiHjemZDp27+0
         GdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0gA7Ac+73j/XnZFQi1m6vn3pC8smRbdUm5Fe8cbDyhk=;
        b=kOFPJnft7vQS8trVSKd0AtJQ0ZGF7FnigTr5Loy5xtvD0xy1sYuBwdnO+hwdUyN+Iz
         brvXU6Xo9g2tZgQ6EMexiTty13JfQ3kMIQpNnPtVDdyAW0aMZ55//ihhJnYZplAd2D+2
         o5IM4QIAzt1feTAlI0FOEbH0rdi1+W+js3PvLmk2i3TTp/Aefx2weSNwquGWw+SHmcvM
         pMPJj3Yzi7hMupyTwEGOJDIvKh1PifRytR5KssER06xb+dB3CqefKhJevUDtxcr8l61I
         oFh8Kg2dGtIjYKpkBIxpeFMm51gMX7+QUtloM+ItqhBqE8kBr7t331R7rksew2PMf3Mo
         b+2w==
X-Gm-Message-State: AOAM533k5Td4j2g/+QlzzpnzeaG3izfLQXyHllUsmr7CeW7oKDmoGqIM
        pZwtGPcDfUCGaE0ZoQZuF2vblg==
X-Google-Smtp-Source: ABdhPJxvks363x29yek8RaALXXC0cYu2SwUDsZ1gCb7momK0fY3oVgT+N23LBhPU5BtU9iTGBDhkUg==
X-Received: by 2002:a63:c5a:: with SMTP id 26mr4386530pgm.270.1590693808617;
        Thu, 28 May 2020 12:23:28 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t2sm5089134pgh.89.2020.05.28.12.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 12:23:28 -0700 (PDT)
Subject: Re: [PATCH 09/12] xfs: flag files as supporting buffered async reads
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-10-axboe@kernel.dk> <20200528175353.GB8204@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d723cd33-2fed-1438-d1ed-b3851edf4b98@kernel.dk>
Date:   Thu, 28 May 2020 13:23:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528175353.GB8204@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 11:53 AM, Darrick J. Wong wrote:
> On Tue, May 26, 2020 at 01:51:20PM -0600, Jens Axboe wrote:
>> XFS uses generic_file_read_iter(), which already supports this.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Er... I guess that looks ok?  Assuming you've done enough qa on
> io_uring to be able to tell if this breaks anything, since touching the
> mm always feels murky to me:
> 

The mm bits should be fine, haven't seen anything odd in testing.
And it's not like the mm changes are super complicated, I think
they turned out pretty clean and straight forward.

> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-- 
Jens Axboe

