Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E53CFB5A
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhGTNNr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 09:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbhGTNKp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 09:10:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810A0C0613E1
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 06:50:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o3-20020a17090a6783b0290173ce472b8aso1948284pjj.2
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 06:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=q5N1XEuq9fVAHMXEdXJs+3w5Bu5KxWA6yQJiKh2RyCY=;
        b=luh+x6h2VOfnubVDQpzHpCYxm9AwQcv4C1sOuBFzOeEOI/pU3skjkkC/8+uWn6XuDn
         zFC2dlcAwrRFx+Cfw/9BJnVcuh3iswR9BB7sFU/FpCxjy46vR/92jBzww/gFRZgTQ1VO
         h1IE3nJUnmQZdLK5+jRJX0qHnECegU5ZsG8kZ5vybEHI6ON0X0qY11CegnRJX2RZZcvo
         hQMYsc8oq54lhdxat3yotYGOIU5GLrVi1/0OIvEbmJmWntqhhDEBpj6XKkKFV/mEPvkt
         PsoEk7fnflmgtNSdsJUPY+n7Nu702WUKVURoY5botJOLXwi6lwP9Zvf6nLfhi5IB71hW
         mF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q5N1XEuq9fVAHMXEdXJs+3w5Bu5KxWA6yQJiKh2RyCY=;
        b=RW2XHA7Vun/OabZwE2WTB3CGs2Ohmc9BzauGeLJNILnlVOCUfLEQI3pVjPmEf77kJ0
         dQGZRiHmzn7rLyENLs4+CFIc+bESq3FssBQ2nCA+/1QYosfG/mgf+RXFcNWc3GLu6cSL
         bVmNIDXI4jOMFAypYjVCRKabW7aLDI3Xw5LrHGdoSZgCu9adnQXjzN6cy4Hu++fXgnj6
         SzdX2ekmzjJqVHpjlEgDvb66blLuT6ca7SwA4G9wDgEAMzuUw30wzy6nUeiUXipu2OJc
         x/3DEOLcAeqcu4CkDTFKkfS68LWOdgjFbkC0Ao7oDGLRUc5OSFCjvAcZnofBqMuoA4M0
         ELhA==
X-Gm-Message-State: AOAM5307rSF/h0aUofbyeGl+iA8VfwrWxpUQo2kOM6VoLGTWsHd5osOT
        rfS8x8mTrNEtK+BZm9dr2gZ+K5l+/fD5ohLI
X-Google-Smtp-Source: ABdhPJx1lCZKOnV2dam2vz4J1N+2QrV2PlDxBw4kUDNIVKYLL4DcCAY70yos2SjlyFqGr6NAgCE5pA==
X-Received: by 2002:a17:90a:550a:: with SMTP id b10mr24459199pji.103.1626789053597;
        Tue, 20 Jul 2021 06:50:53 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id u20sm9830089pjx.31.2021.07.20.06.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 06:50:52 -0700 (PDT)
Subject: Re: [PATCH 0/2] double poll fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1626774457.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bf62b600-8549-5403-5ee2-2f0b3311ad54@kernel.dk>
Date:   Tue, 20 Jul 2021 07:50:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1626774457.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/21 3:50 AM, Pavel Begunkov wrote:
> 2/2 is about recent syzbot report, 1/2 is just a small additional fix
> 
> Pavel Begunkov (2):
>   io_uring: explicitly count entries for poll reqs
>   io_uring: remove double poll entry on arm failure
> 
>  fs/io_uring.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)

Applied, thanks.

-- 
Jens Axboe

