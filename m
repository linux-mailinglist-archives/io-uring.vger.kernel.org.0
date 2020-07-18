Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973FB224BDF
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 16:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGROhH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgGROhG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 10:37:06 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD195C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 07:37:06 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id l6so6673720plt.7
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 07:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OBxVyEg3bdADV2OFLorxOQYOlQLEYNXuUZHrmed//Yw=;
        b=q2pKauGPutsq7X/osxzAdP5R7jcR5hBKTkgNFUITBMeyRr7tGwBmdGB9kN2OFkPtVo
         gC4XGaD+1zUxruSNgagkQNlrOkj0vn70BB/iKFO0RKgU3zU3jPVdgOnviczuueRHXohG
         Y+6GFTAcJRjMeoZFOGGfkUpD8sAsx6enVEwELdO4zoPNdjxGCr6Ad0z4DxarEjMBlwBM
         n9/vveTB0K+Dn4nbCUTi07m+MAQC3gMss5Iaa+sx/RA6IrYz9HBoiX7WAcj3lLQ6IJzi
         QBpKtiGi/Lma/Vqhkkl/DUhrKgTFI188Ed2YhkainYCc8LisQ6magBWtWF/HAw+3loww
         rKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OBxVyEg3bdADV2OFLorxOQYOlQLEYNXuUZHrmed//Yw=;
        b=JROmCngTJkbS4fXy5xA7lspwz8HMZg9QZRI7dSfRvZjKul4+TTuniNXIB5rfC5lcc0
         0bhnPfe2ye3nWiTuPGYX0qXj2OplrCwSdVyrORTeshnoEb/YmyOGnAGagWNYBC+21/J0
         ExKbCC3baF6ECo3desxxXSFxo9SwzdHVGYuUwJnDkaPMxhCckUImuVHgTL7dMMe3Kr4N
         dMKnw9pwwRDDSinY6js+6c5lx5KYeZXfC521gJL0dxnvQzxEsPRdAMdXoFjsnqTvCQOk
         hTlwh9VlHqouvQK3cjPXIi/164hX0fl/h9GS3zrZcGq0IQiUJxGeU91KOu+83FoQTLOp
         oOhQ==
X-Gm-Message-State: AOAM5313VVi3GexBYl61OFVvZ6MHxuVUwRLrrAY0NjsTNja9iXSF7ZxJ
        qReyhjww6rzwCW/sghDO8TwXFr4seubWXA==
X-Google-Smtp-Source: ABdhPJwXzTRqkExLgXXpeJ9pKSnTxCd2wGCBsaRl6vw30r3m2wm8UvlbYoxwS/CEUBpUgKiBOWi6WA==
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr14758483pjy.175.1595083026148;
        Sat, 18 Jul 2020 07:37:06 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y18sm10841886pff.10.2020.07.18.07.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 07:37:05 -0700 (PDT)
Subject: Re: [PATCH 0/2] task_put batching
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1595021626.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf209c59-547e-0a69-244d-7c1fec00a978@kernel.dk>
Date:   Sat, 18 Jul 2020 08:37:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1595021626.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/20 2:32 AM, Pavel Begunkov wrote:
> For my a bit exaggerated test case perf continues to show high CPU
> cosumption by io_dismantle(), and so calling it io_iopoll_complete().
> Even though the patch doesn't yield throughput increase for my setup,
> probably because the effect is hidden behind polling, but it definitely
> improves relative percentage. And the difference should only grow with
> increasing number of CPUs. Another reason to have this is that atomics
> may affect other parallel tasks (e.g. which doesn't use io_uring)
> 
> before:
> io_iopoll_complete: 5.29%
> io_dismantle_req:   2.16%
> 
> after:
> io_iopoll_complete: 3.39%
> io_dismantle_req:   0.465%

Still not seeing a win here, but it's clean and it _should_ work. For
some reason I end up getting the offset in task ref put growing the
fput_many(). Which doesn't (on the surface) make a lot of sense, but
may just mean that we have some weird side effects.

I have applied it, thanks.

-- 
Jens Axboe

