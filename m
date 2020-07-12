Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DE21CA08
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 17:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgGLPkk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 11:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728840AbgGLPkk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 11:40:40 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC640C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 08:40:39 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g67so4894304pgc.8
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 08:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OjY/mrKfhXLFbFJJSqRw4+tjDAVa1uZVE8au7MW9YJY=;
        b=GDzgBmyd5+3zU8+zUcw/mHsUosiTmTdxMHqsembC+IcEsn3IipXLRBVPBWYhcvwqcq
         emon4MuhuDqDkqwfsDrfWamBmbEgS6MqCAKeVW5rJIse8xqDslIYeP1D5rGtRQPqZYto
         mdrrLBEGqlJMr4u0jISNjIWWysBVw6JkI5JNVFHOs6CgdEnpOyaDpkzx7TUJJfs6Hu3e
         Y5vVNCsylXY9yFt6794WEzS4Fx7Syo53J5mKAFTilBCfWJfXEA/HeRUyQXuIDUaT1Piw
         39Jstaa2cabpqVXMxemE55QASBN+BqDxBZYJ/qZ2bxu3cZCLufVwgFha3iH4XgswwVqW
         Zm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OjY/mrKfhXLFbFJJSqRw4+tjDAVa1uZVE8au7MW9YJY=;
        b=YeKOF/qgylXpy9+VrRMvwHba6BacujlRxTx4UMAokyF1/P5evPXYaf22LFyyTgVK9j
         GTglu8i1ouokssA64eoYL3oJ49+0jnr90ZN5vo12fuLtHut4gcBIFVXMI/WGlGQGUNw9
         7YzG0JyPIwa4d2C3Y8UwOiiPMLaz0aegwCpPl5zkQmHOJcQeTQuAn+Rtd7XB8u83vtQk
         lwuvz6vjNtr9OGmcDgNqP9cesGmoJtR81figp8mgKtUB9ZCfVwOGd9Jbeh/nepHrFZkP
         NsCe1NLjlUsuZoPFZXp+XzSPyZEeywR74pawGh7bvEi6AliyKSzN3pQw0v4xdgxGZ3mf
         FTig==
X-Gm-Message-State: AOAM530x4KkRhE1h/Ld2MYfD9lkbIDDD8/htVr6XUfS9zAmGZcKQLUC7
        zHZodWlFk1MPe47tas8YegKoKPCa1vCXew==
X-Google-Smtp-Source: ABdhPJzMMq60JqFmtOqnlc7ZTucB6WCPa5QN7NRwdB1CUKh59s1G3j2q8B3SZ2f6IaqqMYtbJDlF3w==
X-Received: by 2002:aa7:8651:: with SMTP id a17mr65156739pfo.48.1594568438335;
        Sun, 12 Jul 2020 08:40:38 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y198sm12008231pfg.116.2020.07.12.08.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 08:40:37 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: fix missing msg_name assignment
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <fcf14a85d9478be55b72551b3046e898503950c9.1594537448.git.asml.silence@gmail.com>
 <1b98c048b3a0cad032affc44fa08ff7fd8f8f2b3.1594549283.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dbe6c273-b045-cd64-0479-8104d30e89f4@kernel.dk>
Date:   Sun, 12 Jul 2020 09:40:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1b98c048b3a0cad032affc44fa08ff7fd8f8f2b3.1594549283.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/20 4:23 AM, Pavel Begunkov wrote:
> Ensure to set msg.msg_name for the async portion of send/recvmsg,
> as the header copy will copy to/from it.

Applied, thanks.

-- 
Jens Axboe

