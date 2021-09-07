Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A115A40290C
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 14:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343631AbhIGMjt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 08:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245607AbhIGMjt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 08:39:49 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108B0C061575
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 05:38:43 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id n24so12519818ion.10
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 05:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1mflkEVjVuJ7rkfuyl6hyVw/lnvYYsFXrvxQ9eOtxQE=;
        b=IJce+6zdvTEt2Eh1qiGMXYjgQbm+6ar76qup9/aYaGe7e+I/VvI/0Zm6j/tvpDpZDN
         EGekm31oCXQOmMrX3a0dTh7VFxAOpbxIS6A1UuDKdGbyePzXiEwUl812xYE6YixJfajN
         BUQThtLD5Xkuptr+1rtZLAAkBXtIzxm5ETtqdtCuX9Rj6q+D2/0Db9Xd425g2c/C0Xyj
         0AE95yXpF5SC3Pk2fwDHMf/VZS8WQnJ7PZk7mXqor5613Ghq20Zh6hNBXb/MPs/Nl5Cz
         r8QKA9fGeSube1RWMKO4JIWH2RpMZqiPe7RoOSDf90HNhYZpp3p0XZT7Hm+hNEUNjZWb
         oOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1mflkEVjVuJ7rkfuyl6hyVw/lnvYYsFXrvxQ9eOtxQE=;
        b=TcMBZOd6HJSHMdgfISMfmJM8w4FLoiTlc676E9SAZRBSIqXpblXou4ejwNSCqIxW4x
         bpWKZ5jC2cQ137Cc909rc8DKnJjVvR6l01TgaguT+Dw6vW75I9huMlRbC6dYZTVw4l5e
         MGA5UoC0ZOZUxHT/nN8w585HPdieGIRlgM6aUQ7k9lGaHtfgLqy2RPA7YkBlN3Shdme0
         k6cW11x38vbePvkEcbc86jMA6JFM+WNDh2k3MNjtt7tbWk4Iv1E/j6qMpocrJIJRQGKK
         kshEsljYbITldsasyLesM2rHljX8VTzK48vAVFfcratzNYi35TyVQdSWTU3edMO8Gu7g
         x7Ug==
X-Gm-Message-State: AOAM532neIzYYfnGX7EmHUsJGhUNtUzVjzPb1OyPY344k3SMrYYaZUGo
        kPyPiojsRyuvUBpnq2BUlcqXqPnbZtc3Ug==
X-Google-Smtp-Source: ABdhPJxeBEItzZjTciCcM7b+I21eel7l2TY19YlyKURreR12ZdSNJfbY4PrmLsnU0rWilmk+TUW80g==
X-Received: by 2002:a6b:8d08:: with SMTP id p8mr13928459iod.150.1631018322482;
        Tue, 07 Sep 2021 05:38:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id i20sm5170451ila.62.2021.09.07.05.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 05:38:42 -0700 (PDT)
Subject: Re: [RFC PATCH 0/6] Fixed-buffers io_uring passthrough over nvme-char
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, hare@suse.de
References: <CGME20210805125910epcas5p1100e7093dd2b1ac5bbb751331e2ded23@epcas5p1.samsung.com>
 <20210805125539.66958-1-joshi.k@samsung.com> <20210907071035.GA29874@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9ce9132a-8b94-f9c0-b7af-f540a0c10f46@kernel.dk>
Date:   Tue, 7 Sep 2021 06:38:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210907071035.GA29874@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/21 1:10 AM, Christoph Hellwig wrote:
> Sorry for taking so long to get back to this, the previous merge
> window has been a little busy.
> 
> On Thu, Aug 05, 2021 at 06:25:33PM +0530, Kanchan Joshi wrote:
>> The work is on top of  Jens' branch (which is 5.14-rc1 based):
>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v5
> 
> I think we need to have this reviewed on the list as well.

Indeed - it has been posted in the past, but needs a refresh and
a re-post. Only reason it hasn't is that I'm not that happy
with the sqe layout changes.

-- 
Jens Axboe

