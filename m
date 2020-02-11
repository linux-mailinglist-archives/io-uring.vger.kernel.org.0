Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909C9159463
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgBKQHN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 11:07:13 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:39521 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgBKQHN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 11:07:13 -0500
Received: by mail-io1-f49.google.com with SMTP id c16so12321083ioh.6
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 08:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=up5Sj7WFzA0V+47rPc6GcIw8Q+qYXodV0+d+GJ+Ndso=;
        b=Dt4J4mbWWHr9fWcHp2QsjDuh1w4KG3wqWV4qiJy3DSlT0vJ5lhzJO/iOik8jLUNNPV
         559bNWsmRbzmqbJeQcoZdkrD18ilvpwL4kjflpqC/hyYVNf8g6QyiJi1dtxbJySAVcZf
         RPOOCbS3h6rWX5B8Q/fDvywifM3kjXe1CTPW8PSMRFmU/h1RyV+O3BR1hFqV9uM49fM/
         oVU0YpXpuboT/DsfEHxyvJHio5DmbcMwzUrPJmAcD+tDHBqfwmshN8n5ytpojczo5/ik
         PXrXaOUWSx2mdGljGepShPfHpvXVtf9rD0MWM4dsmPEiyvEJd2wKtQ/JY2nmjmp9uH/O
         DMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=up5Sj7WFzA0V+47rPc6GcIw8Q+qYXodV0+d+GJ+Ndso=;
        b=XYM6ohvCHTm+SdTjfE5xKH9T+PCfHEbPdFHqkQD3qIUCtX1777zKVdX6sV0Dmj5F1Z
         GJaK82MEN84+scko0C3GgNusbiRMxrHzk+ey5bDqyZ/L5IdJDJYkY8QWWa8C8TDG7IeP
         t/nQgAWidaQfuowj8SSCEThs5RsZgMwooe+fKVoHBLqWARfRdDTrZy6scdJMFNoKZ34J
         OdALKDr0LEIkKwBfbJIRXLAooHHgLKm/FJMSezWLl6T4nJzC3LFObz4WIgGZcOHKqWpn
         kDgxu7y/VQZxDfWdATpzzgL32zL9yImMSBlVbd5I8/n52AkdQsW7KzOeuQbhn1mLZR+3
         4Hiw==
X-Gm-Message-State: APjAAAWulG8AZsxcoyy3Dey91qnQJYcdw5V/YMH0YRDwSMTss21QeA3f
        MGpk/KWbpMS5OHZwB886jWvXcQ==
X-Google-Smtp-Source: APXvYqx9Yn7x5laXP6vCRMWY9/ULFeCO8ytO+oSKUrJPD4zy0mnq8GTlxdpri7f4AFpGiFVyskgTuQ==
X-Received: by 2002:a02:ad0a:: with SMTP id s10mr15451517jan.73.1581437232841;
        Tue, 11 Feb 2020 08:07:12 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p67sm1408673ili.10.2020.02.11.08.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 08:07:12 -0800 (PST)
Subject: Re: [PATCH][next] io_uring: fix return of an uninitialized variable
 ret
To:     Colin King <colin.king@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200211160259.90660-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e293c9a0-af86-d2f9-7ee7-c5ac41370887@kernel.dk>
Date:   Tue, 11 Feb 2020 09:07:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211160259.90660-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 9:02 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently variable ret is not initialized and this value is being
> returned at the end of the function io_poll_double_wake.  Since
> ret is not being used anywhere else remove it and just return 0.

It's supposed to return 1, a previous edition had 'ret' dependent
on the wake call, but we didn't need that anymore.

I folded in a fix earlier this morning, and my for-next branch should
now be fine.

-- 
Jens Axboe

