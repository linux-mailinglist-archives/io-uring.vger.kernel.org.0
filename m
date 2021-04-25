Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48A536A84F
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhDYQPs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 12:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhDYQPs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 12:15:48 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14ACC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 09:15:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14so20759428pjl.5
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 09:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aNMmQdtaKlCRUtX+LHbUQOJUae+QypBx2I7mOV+2/SM=;
        b=KIIH0Fip578pApvmbNo5WIA9WRERs1JdiVaecVQeOZ/QSDnVNYjizphM0ArxNsu6Io
         e7RsNcPYyQ4/M6Cf56lWRogipqHQvNtesyq4iSGqZUFDXI7pNJtPO7R8R4Ov3UEEcerF
         5PNYLFPg05+a8ewiEGBbnLjNhMZ+iWGI1d88JDlgwSPUPs01P3Qk9oECGKxrg6QEASyT
         u40RsbjuYy2Fed9nXx/selN7wnPFIu+Ah1ZwHodkRfhaGaikc9P+SfSfIsLR6R3Y/1qh
         DpOFjohE3RN/MWMG3sfrHgOprqSUnf826ALQ32jZ430pnvzcSAMrmL4b1itrlItHz5ib
         /66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aNMmQdtaKlCRUtX+LHbUQOJUae+QypBx2I7mOV+2/SM=;
        b=DLrb0ENnUvpoQs9/1udlEQWv88XAim06LXi6ZSgZRMs8XSUNfqhfoiiK5tY9gtMyyr
         zSxb2FIsdTNzid7f9k2yuEmPcttx4IGj/4zTSij9kZd2+VHIHJ28qIj07HDQTBC1Q/W0
         Pvqq9f6PXmCVe7GcmXgTiyBTA3mpOdv4i5RQVmnV+zsFF26EcvO3/GQ8uz0Gje9H5p9Z
         LK+k9iJQshzDICuaD8jMouJu3RBSyhkubVPwNZubrgK6EaicijvjehXgF5XZ7NXdtqcd
         7Q+XTaAE1V48krL68s9hyXlrgy4WbJbQUBLBCjA4PHz4qjaUOL14XmEFAlQjYrbYsDwU
         Zllw==
X-Gm-Message-State: AOAM530jckJDhk98kliymUMgItQUlbd22qBAevFh45E4MkwPDCg7n4Ex
        LFs/2bjCCKNJGdktVj8C5aYvKw==
X-Google-Smtp-Source: ABdhPJyV6G0o7JgV/2ImY1jKctAqpkkLZ7U2v2AQQ6UGZdtwxOuEQ5Lw483d2VbN0ucyOonorP6IQA==
X-Received: by 2002:a17:90a:f292:: with SMTP id fs18mr17368561pjb.142.1619367306038;
        Sun, 25 Apr 2021 09:15:06 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f18sm9826802pfk.144.2021.04.25.09.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 09:15:05 -0700 (PDT)
Subject: Re: [PATCH] io_uring: update sq_thread_idle after ctx deleted
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619256380-236460-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e0ba130e-b851-495a-6046-4d4bf8e1516e@kernel.dk>
Date:   Sun, 25 Apr 2021 10:15:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1619256380-236460-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/21 3:26 AM, Hao Xu wrote:
> we shall update sq_thread_idle anytime we do ctx deletion from ctx_list

Applied, thanks.

-- 
Jens Axboe

