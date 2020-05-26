Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216631E2998
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgEZSES (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 14:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgEZSES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 14:04:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CB0C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 11:04:18 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y11so698238plt.12
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 11:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xN18P3pXk9ov3jRcuqdGEQKpjL9tqNKMSa/qU3w2Kps=;
        b=ApLZTDpGOEg4R7/2rp5QFVKZE7iFxMEbcqJkKDrxsOipoLnv9LrxngGBL3toqQwBS3
         k/iOjFfSmW5BYbXuZ6S5t8TsDCHTJvle4RUy7BjbbJb19eiSdGpKrWztU5ReBkO7xVwd
         V0Z7R55BsYY9mIZ7kxZvncdiVbaYws8kC8HO2AtG6aC3qVoKsSSrzNkt8unBpMZgFFLd
         L4kRIVrQR/TJnfaFA2xxA4nDQLZNy+xbYk1noHXpDA+U+mKpG+kgPy446qZ45nl6bQW8
         +YYdbwc+xPMQIBujm5KHqIwqrLTKlClQnbS3zrUDECg5x/2j0qN3xcl68JeGWqXcIlZU
         MwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xN18P3pXk9ov3jRcuqdGEQKpjL9tqNKMSa/qU3w2Kps=;
        b=YagRh7xIB0Hlis5gqmIq1rqJezbtqz2nv2lPEjf26Mqj2sJLfZU9rLKWcMuh9CKUlU
         0U6pim8rhyue44CQvjE6a8h3jkeUwxkU2/rW55DPlU+ydv66Ir7us55D0Y3L2PaLA2+0
         SaLtkil2ZgGmyppsSPytUYCabYMlFcdCtUUZrnSWzhQW5jNpKXujSuvBARSz32bfxsJU
         GJbrML9/lR6WgXqMwFo5fala0H74w+dtDHBcn4hiCTtM+C+Zc08j5XJMFoYm64DYYSoV
         3c8+vhnw1foFofb49V3EPPac1YrPcrweAkZHXL2eweT+iLGbnfpB3kbL0ZFRcXlaoM3I
         prSw==
X-Gm-Message-State: AOAM532UJisP3X+IQ3+qN/dk/0T+4ucA+UAHKFVno0JetmoNpr1AeNkJ
        dnpJcBUPkDOMHaFEz2OoCKJ94DoMubJS5g==
X-Google-Smtp-Source: ABdhPJwB+MW5Pz7ukEC/Hy/cHj9Qc1/7Vhtx0AJkxRdqljuvOFbh9c3cmsvxMUa4x8by+v5qqbc0zg==
X-Received: by 2002:a17:90a:4b47:: with SMTP id o7mr389452pjl.205.1590516257560;
        Tue, 26 May 2020 11:04:17 -0700 (PDT)
Received: from ?IPv6:2600:380:495a:792b:6476:7a3a:9257:12c7? ([2600:380:495a:792b:6476:7a3a:9257:12c7])
        by smtp.gmail.com with ESMTPSA id u14sm196285pfc.87.2020.05.26.11.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 11:04:17 -0700 (PDT)
Subject: Re: [PATCH 1/6] io_uring: fix flush req->refs underflow
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1590513806.git.asml.silence@gmail.com>
 <be790e01cf63bc0d04bc4577e15ef50ea2c3ac53.1590513806.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82761dbe-d0c6-c14d-0898-1bb324d38b9e@kernel.dk>
Date:   Tue, 26 May 2020 12:04:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <be790e01cf63bc0d04bc4577e15ef50ea2c3ac53.1590513806.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/20 11:34 AM, Pavel Begunkov wrote:
> In io_uring_cancel_files(), after refcount_sub_and_test() leaves 0
> req->refs, it calls io_put_req(), which would also put a ref. Call
> io_free_req() instead.

Needs a:

Fixes: 2ca10259b418 ("io_uring: prune request from overflow list on flush")     

I added it.

-- 
Jens Axboe

