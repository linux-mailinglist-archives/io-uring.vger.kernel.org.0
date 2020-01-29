Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9528914CB88
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 14:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2Njx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 08:39:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45403 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgA2Njx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 08:39:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so8841077pgk.12
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 05:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ah4QQ6K1QfptejU5H4/uQ+LpdR24t+eMpQnEA0OsMVc=;
        b=OvKOKJfD9FMElCBRo0DyjnznMUFKfW/uGVfNasmNIX6FPKGms0PK685vFMzIqxxH/U
         /+yM03X/HYthyDI8DvX/W80ggNAJPR1RyjzSYkrPrjeB9DBBzGMTH2HnXiYqyOUOJbJJ
         iWgFVH2wcrOxpq5jFfnw++WvWBVgj7m+yqJ+vc4owJe8fRY4d7/qJI+ucBBmTxoEM4Kw
         C6reNVX0eHX4nh9mb+z9HxIKI4w9XQN38LD4Af/4/8OGx5bgc8NWNVuOXo7m/ewvwYYJ
         lTgmAGbQi+AWzGghj6iAbzYZ6Kt0Fr16qckmpDtw5wqcwftOdijj2I2Nj2queDIuuJbh
         77BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ah4QQ6K1QfptejU5H4/uQ+LpdR24t+eMpQnEA0OsMVc=;
        b=UicDXDxUTEIVK0aCd6sg9Z3QjAclrEiN8PIvTqE36PgK2DLG9Zp5h4IvH2f3I5hs5g
         lHOLogTriYdtjMtRp1nSK5/lCG/eO2CoC16kdUSAza2z94tpmq7UzZV/aVgD+zD4nTSo
         rZtq1mM4MoTk9P2g+8S00u0F2VmtFw8cHv8U2MDEf3pmBSeYkGfRHwRR5oBFFLG0O+Ie
         cYxXj/mrBIuWEXtxYhLBCVEQsX/Ik+NiWMdFQsoBGewG843Ho5MsJhtxxP7a71NPWA9X
         MLskqXsbZziU2Vw6DUXByWRBY+HC4y5pZSO7OWi/PvBAYV9+lq1HniAuXBNy0yKbVal1
         R/3w==
X-Gm-Message-State: APjAAAXJ/i4hnTolqkAGIO9ukg3WH+7yHN8+Lb8zoQKVMQ4LBUH1Bpa7
        INgEaShfrsRXRZZDpi1Bn3KBKg==
X-Google-Smtp-Source: APXvYqyTXQ8n2bMp+ka9gBWrzTDS5UvGh7HozYikOd0DAM7NwUNGRbjsd8Jpw3ZYdpnkrDBfziplwQ==
X-Received: by 2002:a63:e80d:: with SMTP id s13mr31323854pgh.134.1580305193016;
        Wed, 29 Jan 2020 05:39:53 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q8sm2857780pgg.92.2020.01.29.05.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 05:39:52 -0800 (PST)
Subject: Re: [PATCH liburing v2] .gitignore: add missing tests to ignore
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200129091723.16746-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9942eb1e-5652-3520-9657-f9cef8ea6bba@kernel.dk>
Date:   Wed, 29 Jan 2020 06:39:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129091723.16746-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 2:17 AM, Stefano Garzarella wrote:
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v1 -> v2:
>     - rebased on master
>     - forced 8-bit content transfer encoding (I hope it works)

It does work - applied, thanks!

-- 
Jens Axboe

