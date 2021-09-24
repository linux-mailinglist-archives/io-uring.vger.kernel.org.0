Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1250441787C
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244920AbhIXQ2A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244892AbhIXQ17 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:27:59 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D061C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:26:26 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b15so10969922ils.10
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f/I/FIGGhXLqBPfwn/fXGQSNSGnr9hT3MDELq/vgj3s=;
        b=d2in46ePtmId2jQ1gdbdnmc7bizr6vj2KYrsOda4aUyr2bNl7xIXcaEaJtNVy+JCzd
         wyXqKcr3rB+oy7kv57aO/W9Tc3N3VHE4Wg3p21cn9BsvVnG9DurRlkk+TrUB3VP9eX2F
         7qYbO6gBTPCxJst/zqXQiuweJDqZJV3IQqmQWt4xbGwCA13GjBbSdHEZ5Z49MhL2e3NV
         ajaSj4aT+qC5+qBUQqbomP5fg4BSCHqV4Y9ZrVx/LsYDGINmIUNxUb/zVZxujHSPHWA9
         vod4ZYluqMfqGOMZElF/8LPFgi9yZOjl2u4Bqb3HH4ANhPKNYlR5el9XHwZlENc289s8
         jX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f/I/FIGGhXLqBPfwn/fXGQSNSGnr9hT3MDELq/vgj3s=;
        b=CteaK/ZLvC9hPpWl87I437ESlHSUu7yZcaVPs8VC4mYESK6aOx+5qXNbgsA2WdXq6z
         Bkkn8JIszJ34jaZKeJea4kywthsR4PpmijaInnDLDcPe5iMwoxk8qqBDJVKTF1bF/QHY
         LXIuQmoDZQL/ygZ0N80dVSUF4AyumBrlaQSIKJujjXRZ47+GrR0ogBtIkplkqrsE6DSO
         2x0HOm2meATYJqdevUCctsBbxosQRTD9Q5NnBtILfMC4dCl6cQl6oTbAwTC0aAZPdwwF
         e8JFCkqaQtofwzlWrOE10yU57QxLdoMnG/pxNbYE8iCQtk2MQTshH/CTYApJdX2L91b0
         BsfA==
X-Gm-Message-State: AOAM533Bh/avxLPLuTCQBnIx52O+CxKkambpIy4riJefPvhY8Je9Q+w1
        eEDOaQ6ViZyIqi1nCL+fyntLdw==
X-Google-Smtp-Source: ABdhPJwFYjuOEqBACeF8FXp1oze31RWrd/zP51TnkXhVJ3dQcBe3Wzh44G5WC4OGFnfRjYt7Qu+QMw==
X-Received: by 2002:a05:6e02:1e03:: with SMTP id g3mr7968979ila.127.1632500785833;
        Fri, 24 Sep 2021 09:26:25 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r13sm4706574ilh.80.2021.09.24.09.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:26:25 -0700 (PDT)
Subject: Re: [PATCH] io_uring: kill extra checks in io_write()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dave Jones <davej@codemonkey.org.uk>
References: <5b33e61034748ef1022766efc0fb8854cfcf749c.1632500058.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f9be7854-449f-5891-d820-b558d9dd5434@kernel.dk>
Date:   Fri, 24 Sep 2021 10:26:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5b33e61034748ef1022766efc0fb8854cfcf749c.1632500058.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 10:14 AM, Pavel Begunkov wrote:
> We don't retry short writes and so we would never get to async setup in
> io_write() in that case. Thus ret2 > 0 is always false and
> iov_iter_advance() is never used. Apparently, the same is found by
> Coverity, which complains on the code.

Thanks, applied. Should have a:

Fixes: cd65869512ab ("io_uring: use iov_iter state save/restore helpers")

which I added.

-- 
Jens Axboe

