Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA81A51DA65
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 16:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442032AbiEFOWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 10:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391048AbiEFOWp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 10:22:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24FF68F92
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 07:19:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so10929065pjb.5
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 07:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=accQPhvfmiVPCnKwN/hY47uLVNCNPpovQkDbWH1UEwg=;
        b=aH7yUmqD5X4ykrrVGRfBk4DNO4T60/XMN8rKenJoObEBazV5ls1eqC10Y1bNfC68k5
         JG9za2jNfe9e4ASYfASUva3yplGfuHE5sRog/S3qE8Kmus9STW2yfYdPu9/4spDd1xBU
         MxEJ8hngBwW33vxZtVFEmWN7omp7ivfnKYLQVHmMxaWC+pj+Pvj8bIAH8PglFO563Oxx
         R7kvaO1fl1XC6rlIZPK7DGPs9i/afNhoBlhYUFKyBBupgMG0wonDirIpduCpy6zHaafT
         GkI+Ap1caWdeQDzxaHE6RwR8cUmn9y7U3/nEWULhNpwq9vU7eR4M0dS7mB9FcMmdAD4x
         3+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=accQPhvfmiVPCnKwN/hY47uLVNCNPpovQkDbWH1UEwg=;
        b=M8XVAxky6/nx4M5GN4zxBkZbvgplJcVdC8hl5WqxdfaKJYViHwxF8oTXdwq0Llscjz
         ZZG4K7cflBmTz4RVnlhuuWDeBgRpAWCCFzz3PxcDYZuBtf00ic2vXyqNCNawea4Bwh2Z
         fXUqi2eHOnevHwrEFdT8PumnPZAwQlkDUP8i2DQ9BgilBwa0rU2k4jsbt90RTbBu68ge
         7zZvTxtQvn9PuNJHW6j5C5a9SrRy/flFStNmFpanS89Db8BzYZ0jDGGtcaccQ8j4whG/
         /ZQVm3IZRK7X8qCdkUOeRR4Ji9JPRTo6PVOT9hTLzt3R1JQMiOqMaNnvcFr6N3hgYBeF
         nOhA==
X-Gm-Message-State: AOAM531XAQlD4kEG+htsdBIE3ZKRPBLuyiLaTal33slsW6pyNNNf7k1l
        oxzjbprfuQaf1Txl6oIB04igbw==
X-Google-Smtp-Source: ABdhPJz5gul93CFq40i2+RgsWY+4sxcteyEwA3CJMkl6btcXC8rTR7O03Ius5LHBYbIyxGarxOG6Sw==
X-Received: by 2002:a17:902:f64d:b0:14f:fb63:f1a with SMTP id m13-20020a170902f64d00b0014ffb630f1amr3807560plg.159.1651846741310;
        Fri, 06 May 2022 07:19:01 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090274c400b0015ea4173bd6sm1764099plt.195.2022.05.06.07.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 07:19:00 -0700 (PDT)
Message-ID: <5ce3d6c7-42f9-28c3-0800-4da399adaaea@kernel.dk>
Date:   Fri, 6 May 2022 08:18:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/5] fast poll multishot mode
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <b4d23f42-36f4-353a-1f44-c12178f0a2b3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b4d23f42-36f4-353a-1f44-c12178f0a2b3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 1:36 AM, Hao Xu wrote:
> Hi All,
> I actually had a question about the current poll code, from the code it
> seems when we cancel a poll-like request, it will ignore the existing
> events and just raise a -ECANCELED cqe though I haven't tested it. Is
> this by design or am I missing something?

That's by design, but honestly I don't think anyone considered the case
where it's being canceled but has events already. For that case, I think
we should follow the usual logic of only returning an error (canceled)
if we don't have events, if we have events just return them. For
multi-shot, obviously also terminate, but same logic there.

Care to do a separate patch for that?

-- 
Jens Axboe

