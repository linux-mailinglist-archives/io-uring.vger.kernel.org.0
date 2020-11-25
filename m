Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841602C4749
	for <lists+io-uring@lfdr.de>; Wed, 25 Nov 2020 19:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732671AbgKYSL0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Nov 2020 13:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732540AbgKYSL0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Nov 2020 13:11:26 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F894C0613D4
        for <io-uring@vger.kernel.org>; Wed, 25 Nov 2020 10:11:13 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l11so1507555plt.1
        for <io-uring@vger.kernel.org>; Wed, 25 Nov 2020 10:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VpDKETGLY4c7ZcHoY3eucnnxhVSDTDjLXK4WKfup9VI=;
        b=Rd00x61iaEH61LbbIeLm9sHiJ1Z6d2C3RSoUa1lGPUOCZy5heVUEkrqweUNDCM9PjC
         K+rnN+xpN0oKBtofT/0OMpdYFnaADYbwbbMKYZSyv/e0xlbTkqNZinKb0lGO9/EbD2Ce
         hqPs/+lIXJHaUnelMxAJJYZSZDGLolCJmO2njH4MzS2isjDZ3k5xpbw2dtlulIa2ERlI
         GNxCd+EGvxKXaCScdAlQsu5hnO3B2aFTvA+atr0c+rhxL+jhhkWrckuiTpQI+3Cxy/0z
         /M0j4QmNUEL0v32+DQ9K59KplFffht1EZG3zrX/0kYatTZQVui68oixcPxrQID/caQc7
         JCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VpDKETGLY4c7ZcHoY3eucnnxhVSDTDjLXK4WKfup9VI=;
        b=WfqpoDfe+ZG4mlZoVX87WXjhJE633qtgCPP5aObPaZ4tDrExbJr7N9ymJqF8Dn1HWO
         WyfIkGYChx78CHRYbAlvsn0nLfO2TRUyp1ZNSbpsW3UJEwnGs3QhngpjcPtR9sxMgQ7e
         VdxX++cZcx1b0mNbhjWAN0pi9hTcOZ0VCB8NBp4gpSIrBk36pKakrCCeHduyCTFg+JSZ
         rIUv8vFd9+VhgtMoQsNydIPuKXyJROL24lKWRivznXFvxB5Stn2Y8jQyjbyWuFJsgt77
         7K/JWmQIrlU8wKMNElwRm/cy0xbXKHKnxqegeHfq8k/e1kF+ymizpjCS7qBXODpsXlAh
         ZHNQ==
X-Gm-Message-State: AOAM5308qa8e6EkyVKk/M1aFVbjptz9ZMPU7UM2nZd6IWIL/F5sKRYi9
        D/v2UmMUUqST9go9f+drp0iYvbJqPO6lvg==
X-Google-Smtp-Source: ABdhPJyoMXp/uvPnF8zvEG3iqfCyI73AWq7Q3w+6TbSNSyOSVmrAiQHfarM6/TWncvv3zr3KIcDCpA==
X-Received: by 2002:a17:902:b717:b029:d9:e816:fd0b with SMTP id d23-20020a170902b717b02900d9e816fd0bmr3907116pls.50.1606327872964;
        Wed, 25 Nov 2020 10:11:12 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:ffc0:fc77:4500:e880? ([2605:e000:100e:8c61:ffc0:fc77:4500:e880])
        by smtp.gmail.com with ESMTPSA id 3sm2633851pfv.92.2020.11.25.10.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 10:11:12 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: fix files cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
References: <5c8308053ac64d0fc7df3610b4b05ac4ba1c6d2b.1606270482.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <429e658a-50bc-f4ee-f9b5-1acc4e2bf6d1@kernel.dk>
Date:   Wed, 25 Nov 2020 11:11:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5c8308053ac64d0fc7df3610b4b05ac4ba1c6d2b.1606270482.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/20 7:19 PM, Pavel Begunkov wrote:
> io_uring_cancel_files()'s task check condition mistakenly got flipped.
> 
> 1. There can't be a request in the inflight list without
> IO_WQ_WORK_FILES, kill this check to keep the whole condition simpler.
> 2. Also, don't call the function for files==NULL to not do such a check,
> all that staff is already handled well by its counter part,
> __io_uring_cancel_task_requests().
> 
> With that just flip the task check.
> 
> Also, it iowq-cancels all request of current task there, don't forget to
> set right ->files into struct io_task_cancel.

Applied, thanks.

-- 
Jens Axboe

