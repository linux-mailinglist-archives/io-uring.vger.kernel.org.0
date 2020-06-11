Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7155D1F6A9A
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 17:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgFKPIC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 11:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgFKPIC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 11:08:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C076DC08C5C1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 08:08:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 23so2781234pfw.10
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 08:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dC25K0uzB2BNPMSrVl+BZYpPLmxAri02zjzeg81WXfs=;
        b=RIlhaqbd5cE5TuYmZyK6Ll8a30y2IZjmc9qrFP/go9d3czn+/QGoGpgVjTAiOsx1IL
         +r3US69/5VjP/WDq2MsOTJePjpr5PXKoDZBVO5aRABtLu12RYL5xLkqgaV3LjZf+yyq0
         prsVuSML85SDfSHEr2B2ByyN1zV8gYZYLBH2viaMufGQRKRpOCtSfCHo+vUdtkVZrgqx
         wU2zkV/xNWetF4mbJb2ESm1ijMagcHP+nBXAWJ+4d9CP34wNljjww+SIgptOEqVFI3b0
         xyVGyqoYEU3TcziNc/oJw69QAmYbCGrZ2v7pmzVTS2FPQN8+0zSDjB3jDE3tdSSAfaQT
         K9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dC25K0uzB2BNPMSrVl+BZYpPLmxAri02zjzeg81WXfs=;
        b=LtVn4CM3JZbj1Naiy65VQrUpg74DPdEimhKP6TH1ordxK6vy1ga+ejkCQMHI+0KaeV
         XyfR2WCD4GEJ+8YQmYSW3fpZtTOsLxbEEjsINkyzB4lW8Syz6/wVgViKk+VzgFa1nVYL
         EZe9ZiRlOglN34W8HGXxL/R9/YrQSDl5zE4EFCeZL/n4HGeQBE7OpAgrmuEYSOkiEjEi
         geiuRqj+DJwYTm+LA9dQEzPL1mC+mR8aC50cuG0Mnl5qTOUUVEwiK98Ki8zbDx9kt4nA
         ALSoLNBwWoHEWBS3sa2oTqz+G41aiXOWDbvZJjDCDBNqzCLW5qI8mCNnHcbF+B3m8X+0
         q9+g==
X-Gm-Message-State: AOAM53277bAWSPipMfXpEzXdF68eXlBiaK4NmnvM9qc8U56M+2UE4Z1V
        8f7KmhQ4PyP2qdL9qVJy/1WEhkf3jszHqg==
X-Google-Smtp-Source: ABdhPJxWWStq2xoYukKlfQ3aMbTA6odkBVM8E2v4A2mssnSIRHKnmPyhwxN07rX41Z7Mwx8ZcxiASA==
X-Received: by 2002:a63:3756:: with SMTP id g22mr7095857pgn.304.1591888080083;
        Thu, 11 Jun 2020 08:08:00 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j6sm3426297pfi.183.2020.06.11.08.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 08:07:59 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: add EPOLLEXCLUSIVE flag to aoid thundering
 herd type behavior
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591849830-115806-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d2dbb50-ad42-ad27-4115-ea00971e87f1@kernel.dk>
Date:   Thu, 11 Jun 2020 09:07:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591849830-115806-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/20 10:30 PM, Jiufei Xue wrote:
> From: Jiufei Xue <jiufei.xue@alibaba.linux.com>
> 
> Applications can use this flag to avoid accept thundering herd.
> And poll_events should be changed to 32 bits to cover EPOLLEXCLUSIVE.
> 
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>

Both of your patches seem to have a weird setup where the
From is alibaba.linux.com, and the SOB is linux.alibaba.com.
I'm assuming the latter is the correct one, as that's where
the email came from and the former doesn't have an MX record.

This is 5.9 material for me. With the above fixed up, please
turn this into a series where 1/2 is changing the poll type
to be 32-bits, and 2/2 is the functional change that is in
this patch.

-- 
Jens Axboe

