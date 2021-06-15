Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC8A3A8B36
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFOVkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhFOVkI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:40:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC9FC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:38:03 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so369249otr.7
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ktvid5LXIM7drztkwdX9ozDIlIDeMyLQZst/rY14IM4=;
        b=zD1aW/O4VDuKIIKdFuwz2Ojl7wf3CLuun/3va6xMimNA6l8jhK6SPx2l8+AWtJNAKp
         BhsSSs78peO1Fd/zmAZIhyfwOYNzotlnR6FYf6A86m2vhSJJDIE/regKtTzQRYtet52U
         TfsTx8jGr/P7ajZMHEoeizhVU9l22/k86jbVbhvZceGzDIc0sTVpiBIldvz/lyBubWlL
         ETdEkf4HL30x3OPOnJxR9xtnsdm7jC/EFJ5BnfUAMYX8j+3A2rK8gHr4M2UxkoO1mIAM
         ZV2+fzIcak2q4i+rNRHLQKcT1WcU+cDjIJUIcX8H1yrOKPFnVdiF/+45TCpzMqEssVpY
         IxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ktvid5LXIM7drztkwdX9ozDIlIDeMyLQZst/rY14IM4=;
        b=Y1XrPW092EeILjMV12wfG5DfIrCMUsCVBskgTnAhWFZBPWucJ1fIVvS+aH4VdJ6S7r
         O+mmlcN4Lj6o73NS94yIj6K92Pf3f8Jmc080BRb/LT153FYGQu5eOP6ZOlvt0AJVPoeb
         bPZToMcUkFP2UsZeW9nptF+cXrFx55NJl43PUyXK4YMhHLwZMtLBtBkZcCzJylmouEYJ
         jaHy8q8LzV9MQRkOgXWFMitQ6pSu8Yp5DdWSOkrwPv6u75HXU+ktvRLXtpDYhHtee/b8
         DpbHYbftpIj3QadUE3aNZ+VOshue/YkWS8BZq/QxNL8n0ZDg94atchT//yCxReUlrzzS
         D1GQ==
X-Gm-Message-State: AOAM532VujU3D7QyGxJb9C9kpNLkHJmU86N5w7wxI/E7y/5H+wdKgDz/
        rEK8pVMonnkCsjELHMz5aiXgxw==
X-Google-Smtp-Source: ABdhPJytngzhKqyqU5m/g9kKa33OJYlC3KL/VMY2NdSzLTOIkMokegs/VZiBqv1cSCyDJRGsl5rMzg==
X-Received: by 2002:a9d:355:: with SMTP id 79mr1071698otv.101.1623793082643;
        Tue, 15 Jun 2021 14:38:02 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id d20sm42457otq.62.2021.06.15.14.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:38:02 -0700 (PDT)
Subject: Re: [PATCH] io-wq: remove redundant initialization of variable ret
To:     Colin King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615143424.60449-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <532fcdf3-2b7a-a9c6-039a-5dcfb32a61e1@kernel.dk>
Date:   Tue, 15 Jun 2021 15:38:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210615143424.60449-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 8:34 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never read, the
> assignment is redundant and can be removed.

Applied, thanks.

-- 
Jens Axboe

