Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DFB3FC73B
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 14:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhHaMZS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 08:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHaMZL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 08:25:11 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C24C061760
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 05:24:16 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id m11so16062922ioo.6
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 05:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OgWrJBqtgePo+GZvQhYFmevEMj0eA2/OiD/8RUq9hzs=;
        b=dsp289GvI9NMBa/xO3a2fGHjvnJKyqhcJyrRYLaZzH5gaJPNNIk0WAmt99D0w0VJ97
         0iJe+cD27oNTvgJ3CQ2rW/z6xnOcMeeOA1UNe5qIcQWS5pWvpAi4Fa5Xpp8FAMJvPFL3
         Wg1PfJh+V4pwznol5eXHE7WN9kEUW8+9JTXkuguESRwHoiuBG7OCKelMDKtCMqVqlGM2
         9ci5GEoE3DA/XQCEZ49ELSdt0mt+DKbIhhYcykWWB7YtUbmvJ8WtIzRzPfzdOvNIIBGm
         AqobxK1pvpdpjX+nnOq9yvSI1hagOSwG76LS9jw8pKz8sVWXjbhL9nbv1OVq9Z6nHgGw
         ZvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgWrJBqtgePo+GZvQhYFmevEMj0eA2/OiD/8RUq9hzs=;
        b=D3f7r/eCfClSYTfVxGdMDehD8UQhDIo9GQlCfOgPeelirttEbRijCD1qUeShOwUceo
         R7caYw+aKWe87kUOTMd5OI5LpheKdxrbwukjgczJrSl5sI101veOP/ZYWyAO5g5yxKPJ
         RV9kpHsnNXGo/7h94R4lb0y7OodgZQOONhmZ8Bzd/zHSSOKDseDlWTP/EJEuG1K7Yrwo
         Lf6JkFEOfLQJJFpqY6R18DIhIEgC1pdIcsT3FSc/Lcda22cWuCLqOzo80av2ILXKe72a
         9I81ebKuu5jrbQTPF2+aBGDbGTEWObwsMNKdvAmmGzvOughn8yQ68UE4HHgH3YAEnGCA
         ToGA==
X-Gm-Message-State: AOAM533vEMyeOCYpUKBaDZWYHS/oNZppGOuzHfXu9Yv6zFlfMjiR1ykK
        yxR5zMnMPQXTbdblbc+CbJLTyBeI8Hp8rQ==
X-Google-Smtp-Source: ABdhPJyu8xiPI8Ygj4AsMEGv30COoq8Y6fqzkeL9jNhSuw1lAqhDyDZTNoS3iN5lNE7iGOY//1UX8g==
X-Received: by 2002:a5d:9707:: with SMTP id h7mr23280706iol.28.1630412655691;
        Tue, 31 Aug 2021 05:24:15 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v15sm10136893ilq.2.2021.08.31.05.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 05:24:14 -0700 (PDT)
Subject: Re: [PATCH] io_uring: retry in case of short read on block device
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20210821150751.1290434-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8627961e-3f6c-f0d1-9dc4-f3439b2fe590@kernel.dk>
Date:   Tue, 31 Aug 2021 06:24:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210821150751.1290434-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 9:07 AM, Ming Lei wrote:
> In case of buffered reading from block device, when short read happens,
> we should retry to read more, otherwise the IO will be completed
> partially, for example, the following fio expects to read 2MB, but it
> can only read 1M or less bytes:
> 
>     fio --name=onessd --filename=/dev/nvme0n1 --filesize=2M \
> 	--rw=randread --bs=2M --direct=0 --overwrite=0 --numjobs=1 \
> 	--iodepth=1 --time_based=0 --runtime=2 --ioengine=io_uring \
> 	--registerfiles --fixedbufs --gtod_reduce=1 --group_reporting
> 
> Fix the issue by allowing short read retry for block device, which sets
> FMODE_BUF_RASYNC really.

Applied, thanks Ming.

-- 
Jens Axboe

