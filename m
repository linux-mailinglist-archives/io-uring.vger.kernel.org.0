Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53851F5F0B
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 02:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgFKAGb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 20:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgFKAGb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 20:06:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9ADC08C5C1
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 17:06:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so1854411pfn.3
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 17:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cue6pOyDuQPP7grXYF2vWnr4xK4v7EMPCwnHPOEsasA=;
        b=yCE1IWXHKzzdpSfZxV+D5KCMlqfxlntDZA13daS6szwWxVg4BrbjNCbJu7Ppmbaemd
         S31Yk2HZm1E6288goPl/wMIqT/j7SRxgocOaTUo6eMJC6kReH3H/whgjEKtOWjig6AC/
         j3A8o8Rr2JTMQquCSja0sjoAGY5+xDLUD0FcYSzA0IO/HJohS9wdsqr9zmkUiH071abL
         X8bu23PIG4GwJUrSGcgvRSrfX1g1eh1v81lxALpsM1VBIVa8YjLfJFwF0tgpltNFh31s
         9auuNXco1NTXhxkmDBpyv5LTDQiEr56tOsGNC4gJ3UiQvYOY8pp/ON3/rU+u1RsmqEiF
         XH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cue6pOyDuQPP7grXYF2vWnr4xK4v7EMPCwnHPOEsasA=;
        b=tDp8dld/eUwfF4Tz0JyACdLwbqig9rNUsZnAOjHAzBmkyvdHRv7gSvemn/qWrRP/Sf
         6bCR28SYIApecYxQl4DHjyNj1efgCFUpZQcAy6SIlaIeT5wIbqO3ESNJWJL0NTBKAyiL
         pCYB/jyNePvdGQDlZA+LKtGvE2d528LG44aBnsuPZeCoTzvXNBAMbJvHUviDq940EHZn
         iYgwzyeM5riUtycZH12G2foN5fZMeAZaiqYTlmis48/TJ1wMdDygHS5Ik63OwxzLzlxA
         GadXynpZPnx0sgJ582ocNKktvOQaEimlAtDCZ/xO6kSzklEM7BuVUGN2QPzCwtvBHgl4
         UFYw==
X-Gm-Message-State: AOAM533TNut7rBfxsV6YpyasSmrhhKGlm8K8InIs1MtMoefPmAbEBgqy
        ck5Y+xm9HOay0wE88wcKTaWnLCshDOZ/9Q==
X-Google-Smtp-Source: ABdhPJzURqYMSXEMolg7h4DZmrsLcR26ZMZERJFQYA9WL8mue5JTER3btxdP1Slj5gxqq2q9++iBhg==
X-Received: by 2002:a63:29c3:: with SMTP id p186mr4524635pgp.332.1591833991223;
        Wed, 10 Jun 2020 17:06:31 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l83sm1050170pfd.150.2020.06.10.17.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 17:06:30 -0700 (PDT)
Subject: Re: [PATCH] io_uring: check file O_NONBLOCK state for accept
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591767719-22583-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ac640645-97b9-a29b-f07a-1729a622cd2a@kernel.dk>
Date:   Wed, 10 Jun 2020 18:06:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591767719-22583-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/20 11:41 PM, Jiufei Xue wrote:
> If the socket is O_NONBLOCK, we should complete the accept request
> with -EAGAIN when data is not ready.

Applied, thanks.

-- 
Jens Axboe

