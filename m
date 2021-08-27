Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6623F9F28
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 20:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhH0Stu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 14:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhH0Stu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 14:49:50 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25387C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:49:01 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id i13so7961202ilm.4
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hb0DD/f+dgH1BkNZ5UAmGErSB/HKnnHPqj2+CTLBQ30=;
        b=sx6YklMW2OT2auUQlB0yG1gD63VMBDjiHTEMqAM44+UQYgKMiFiDPTp3RdPht4nV5P
         5Lo644qqfWM8ny3NmchXZKV+fADn4drjJ8SBroTMnk22Ga0Nuj9mYkLnFw04d0GTNatB
         6HYeYUDxuj1RCIIRXT71jgQXY5WvqnFAjFNmRBnfD3+pgvF9b30ohGUJeY7gHG1aiCve
         tsNrfVft1b9Sb6siokUAVM3l4zUgg+rL2Xi+fWfIjulFOKVz9DEdxK5P4/pa1Pmfnj9j
         IkzO6ccOSPlRYbFpw5EBknlMFiz1OsZPFDuE1qeis1uBTspQgeLlMIubwsKF8+hJbggE
         RPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hb0DD/f+dgH1BkNZ5UAmGErSB/HKnnHPqj2+CTLBQ30=;
        b=GmQ+99HZATA1OvYs0k8mwtAdc5zl9DCLl9fcnips2RrhiomFtXEdOILfieq0BYQRBU
         ArNgKkMl/0PAxS3ciY6Uog+AOlOALIpJ1bUAy5VG2OvtASi21UZTWLz5gw6ZfOAr+vHa
         a3WSMAvwnRFW7KnwKwslPV6eatW3EAVlAeR7biGk6gGsl6hCKKbjrI/pZGM+nzL86tKg
         eRZpmBJqun9dUtsR584SE0eoUsANElLbHuUEr3Gxbme6MGYi8CDIhccdrccbOTxwQ4+H
         r3IT47xYhNou6YFM4hgSn/N5m+FkRedsPyYJiV32xEVed7nRLj2G0xNAnrUtv1QCfksf
         08bQ==
X-Gm-Message-State: AOAM532FtMv9FcBF84j9fLvzaXmde41cTDLpTPpRbSpm41Tq+O6io/5x
        PIqLv77z5NkFsJwiNdHyY0+fkD1N1I0G3Q==
X-Google-Smtp-Source: ABdhPJxqlKkID/yvMtBCcPlwYLXb7GXioQAKIldpShlRE4o2HN8z6pfRTQrU+ynx5SQPnj69SuiH/g==
X-Received: by 2002:a92:c94e:: with SMTP id i14mr7535721ilq.143.1630090140017;
        Fri, 27 Aug 2021 11:49:00 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y11sm3727436iol.49.2021.08.27.11.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 11:48:59 -0700 (PDT)
Subject: Re: [PATCH liburing] register: add tagging and buf update helpers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7c95d8a0-7449-ce1e-4c7b-c6fb8537d61f@kernel.dk>
Date:   Fri, 27 Aug 2021 12:48:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 12:46 PM, Pavel Begunkov wrote:
> Add heplers for rsrc (buffers, files) updates and registration with
> tags.

Excellent! They should go into src/liburing.map too though.

-- 
Jens Axboe

