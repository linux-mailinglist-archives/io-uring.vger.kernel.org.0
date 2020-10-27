Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CA429ADC6
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 14:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752539AbgJ0Nsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 09:48:52 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:34401 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501885AbgJ0Nsw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 09:48:52 -0400
Received: by mail-il1-f195.google.com with SMTP id v18so1568920ilg.1
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 06:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JoMlVMrL3lldZL0DhmWmi0ujQlmgdKRfkTCrVcXZ+iM=;
        b=mXXV7xcsdK5btpQRIehbKaERxUVHGaPfWqAF/MC1zD4MdlWRcWkTZ1NYRY+Lu03OmY
         a9Aa1VeW39PJ/M3wXf62dDAKLp72UKuuB7c2o5TvgtPlA4L3fJ75lJPRKWdHvOGGo4G1
         72BAzXQURMqYH/Nqf8mrQGkPQew2T0r8npqvzllBM7ZazfomPHJCF/11seMjsb3HXRJf
         qBMOplsiM1WC8/YBIBDp/f2z7/CA6Gw6/9yCb2nNkRF/nTkaluSi5+MlMWZUUICinFnI
         kLBBRbztDb2tVCwX9fGRQfGEBobxEvaGydhYWdbVkxuQOddgyjl1fjyGtm+/LMdpsXic
         Obmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JoMlVMrL3lldZL0DhmWmi0ujQlmgdKRfkTCrVcXZ+iM=;
        b=dIHkEq02eNrMRZM5poUpuOdzL3PBWTh4ff7ovEKE6aZ9YEJyg3wn8TLoIjkyDlFsoI
         PHMOWdAoAvvkKefiWuz0eR9nCVvJsVFnInN1srCzPQTPWmflG5zsd37/3jA/gmR8X8SZ
         iYrlo7pOq5xZx3+RzOadVpCkuo0qZ8rVInfQWYQFdUxB+kbyqtssHA1VjCz/ieW4uVc+
         ImvM00YW5yw5bKngn6kAmnUj59K4qnTuezahgmWC4h79T1ZJ6OpxpOBNqIf8joiqwG5D
         d5jp0lug9vfJhpsNud5aSq1IhSVyGVYQWTTr70N7vnS0xn8pQ9zoXxVkvbxvG/kJwvY9
         CVOw==
X-Gm-Message-State: AOAM532csuEW18NKI5mZZX9IPoNoVwfgi2PQRCWf3fNdeQuRkol48IH2
        GL2wJnAtZb7d3ReXy1kiMiEhEEWGpYeo1A==
X-Google-Smtp-Source: ABdhPJzzvvbzhqHxNByzE3RyfpR2asw1TZLcdmXkKQWima5O97dnQoP6Hm7Hd1mQsiN6gCO8pZCGYQ==
X-Received: by 2002:a92:5b46:: with SMTP id p67mr1897994ilb.150.1603806531143;
        Tue, 27 Oct 2020 06:48:51 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 128sm1011659iow.50.2020.10.27.06.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 06:48:50 -0700 (PDT)
Subject: Re: [PATCH 0/2] improve SQPOLL handling
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
 <9b0ee22a-1dc3-932e-d2a7-360ff463e04d@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eb7c87b9-a83e-5ae9-cde8-7e50c950bcf4@kernel.dk>
Date:   Tue, 27 Oct 2020 07:48:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9b0ee22a-1dc3-932e-d2a7-360ff463e04d@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/20 7:34 AM, Xiaoguang Wang wrote:
> hello,
> 
> This is a gentle ping.

I'll take a look soon, with the aim being getting this merged for 5.11.

-- 
Jens Axboe

