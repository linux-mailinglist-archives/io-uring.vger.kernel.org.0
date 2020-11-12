Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4392B0AB4
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 17:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgKLQsR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 11:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbgKLQsQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 11:48:16 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C61C0613D1
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 08:48:16 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id g7so5827607ilr.12
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 08:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5byzO2Ov2RwiDddtfb09fwPWKUfB1+doqVELjtPJUG0=;
        b=bBMjZQTDWDG6RsW4bxkzq8rq3eKta2X+AKmFTPuLsBm8dPopEShb1Lnl+eSUvdm8dK
         u3Ve9dF0WKfOw7A6+jtGJvdgBUiEqNBa8B6xLW1vBjlWWbbpd3rcEAcIhaZAwihSQqYH
         uGSuNTY8lhDJbZbkdg7FY9izagnLw8GEZL4Vi2NZy4MD38PG1acFgM+E4LvaDGZe3Daa
         wwT2ol7LvNbkDV5uWOuCggypLqTJSaws1q0Z1chRguKBoEsi/wLBNKF0iUGovfDKoo15
         Wq026R2G7F6P3xw6yYDlOdKQMukAiVuLiEyXpkqYH8dptYN6CKO7M+LenqtpvhXgJxwV
         pShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5byzO2Ov2RwiDddtfb09fwPWKUfB1+doqVELjtPJUG0=;
        b=FFoMODBYxWtZOUKAnGDvuGCmfgvGXmZE9GOPl+8udICdBOzT1tLxKCyozt/jzpQ7v/
         uM+ylmpkjfsGYipeo617JmOoxgtcctw1Jrqys63T2fvVLBeGQFsfaS+H2zwnScMeu0ny
         FabTxUSKhHsvDJVwja+zXklfbUVzGEfXUySDZTw/NzLvEWXd7RLOr+jy8AEj1BoFl+sb
         29RZcySAvcW0COA1ueGkGFjS/lAoB+rk7PsgJLZdpADFycOu9S6XpSvoeLhNcEtcQD0Z
         1bmszIX6aH87D0Ur0LZ1WIRvyTV7cBTzAkrBcuSIhuYdsSlHy9hSGSduo/qsg0pR/AgZ
         FhtQ==
X-Gm-Message-State: AOAM532EVq2LEVmc5ILa0XM4BgZ7+bfUBbz8kcrN3AkW+NhQVcolRgQ+
        LcusAY7AS3JRET0RR8yHMC4dLhy8w+LSOg==
X-Google-Smtp-Source: ABdhPJyIGZ04HAsLDag8L7L6qjC5XJSoiilQtV4VIrProokBXJEUW82hDS1FixBsgsh04wyB7vXuBw==
X-Received: by 2002:a92:6f11:: with SMTP id k17mr316924ilc.69.1605199695958;
        Thu, 12 Nov 2020 08:48:15 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b1sm3184224ils.41.2020.11.12.08.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 08:48:15 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: only wake up sq thread while current task is
 in io worker context
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201112164408.18766-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <571883e1-be7c-2e09-4c88-b11695d698c6@kernel.dk>
Date:   Thu, 12 Nov 2020 09:48:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112164408.18766-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/12/20 9:44 AM, Xiaoguang Wang wrote:
> If IORING_SETUP_SQPOLL is enabled, sqes are either handled in sq thread
> task context or in io worker task context. If current task context is sq
> thread, we don't need to check whether should wake up sq thread.
> 
> io_iopoll_req_issued() calls wq_has_sleeper(), which has smp_mb() memory
> barrier, before this patch, perf shows obvious overhead:
>   Samples: 481K of event 'cycles', Event count (approx.): 299807382878
>   Overhead  Comma  Shared Object     Symbol
>      3.69%  :9630  [kernel.vmlinux]  [k] io_issue_sqe
> 
> With this patch, perf shows:
>   Samples: 482K of event 'cycles', Event count (approx.): 299929547283
>   Overhead  Comma  Shared Object     Symbol
>      0.70%  :4015  [kernel.vmlinux]  [k] io_issue_sqe
> 
> It shows some obvious improvements.

Applied, thanks.

-- 
Jens Axboe

