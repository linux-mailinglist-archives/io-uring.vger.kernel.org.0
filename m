Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E153F1BE0
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 16:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbhHSOtb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 10:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhHSOtb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 10:49:31 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314E2C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 07:48:55 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso3989705otp.1
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 07:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=f3OgYNdkzdYL+r9886/YlE8ddBrncSaGTGis0vzBs9I=;
        b=RAu3QXO9yx9bvecAZsnWNPfUNSmGqVPraW8MMTkpJw1rqEjQFySd/LoDil/aFn/vcL
         5eDl9PnuJldrv3J+kyCYOkW8I7HTiwvnlT7CP0BQljG9lreK1eH+SoOPbZVT5ZO2YWfK
         kC0TPfs8y7fFsPDZWU+z7LwZIj+kp/SXyxoQD9cxsy4owHG0uRMLQZDM0fk28kAet8/w
         2FcL5MU3HnK2l7Z2wdMneSkLDWjvAdtdgTfFOO8mb2htwtmCHmoaym9CMJ95c+cRbr9f
         ZnCFJrfapqg0AOt2trCglv8U/8vnJUTLzNAyuUWKOQS05GwqT0Su18vf+WkWNu0AqI8T
         +GcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f3OgYNdkzdYL+r9886/YlE8ddBrncSaGTGis0vzBs9I=;
        b=dVFIqWI4JC8zqEG32hDYBgTxbt+O+hfLvxtIzSgkBN3tbCmVoMhkXzCHeihayEzDPl
         lzYilo/kwMsTT0wYpMDSufVxq51jf5wyWXNxioNiSmFai8DfKbhSN9YECVABnkZPsoRs
         eiQ43GvlrnCNI9xyvOlnofCj5Jd9C/4W8ZFxeieb5nF2tCoPVu1iC18PHcuQrvF8i/vP
         tkkKzgwm8zpd+FzTbFNNjd83tL9K/YuNe9WDXAEyFIADRPBgORba7mAK6cduNy9AneGq
         rdfoLiOb2Q8LasLOtd3IpI420BcJVEeLHi2vPN3GKALwQZJ9NPvAZUK5lSHI9y8Cfq0L
         dFpA==
X-Gm-Message-State: AOAM532rODKT4Res1LwkMUfb46NOBIPZxSKTCDU2o4j43L7JVHOCTsPW
        5iwsmQomAT96KAStDTiJpRkWAwXeRv5sZwgq
X-Google-Smtp-Source: ABdhPJylKxCwe+5NpZPq3cYS+AKnvH1zNJer9/NPkp+31aChbSyD/H6KX7mnXcIXJ8kadqlfFhJd2w==
X-Received: by 2002:a9d:4c89:: with SMTP id m9mr12783179otf.255.1629384534316;
        Thu, 19 Aug 2021 07:48:54 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o4sm716188oik.49.2021.08.19.07.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 07:48:53 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] rw tests improvements
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629380408.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <037f5abf-2677-134e-2bd9-63507ab1e83d@kernel.dk>
Date:   Thu, 19 Aug 2021 08:48:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629380408.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 7:42 AM, Pavel Begunkov wrote:
> Two small patches for read-write.c and iopoll.c tests.
> 
> Pavel Begunkov (2):
>   tests: create new files for rw testing
>   tests: rename iopoll test variables
> 
>  test/iopoll.c     | 20 ++++++++++++--------
>  test/read-write.c |  6 +++++-
>  2 files changed, 17 insertions(+), 9 deletions(-)

Applied, thanks.

-- 
Jens Axboe

