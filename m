Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA233F1D4F
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 17:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbhHSPu3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 11:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238755AbhHSPu2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 11:50:28 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5313FC061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:49:52 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id w2-20020a4a9e420000b02902859adadf0fso1968273ook.1
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GM3qKZo/wzcLg70zQqJjHAuK0IA74OkAb6xTcq3BwDA=;
        b=CzBcg4+pth/Iuc82bJrvIx2Df7JxAKWLGR/4eJ5TFyesib1e5RuHRnGIOmPFfD8434
         ImVGJN7gsbhzZGgGSyJh5poYlKpTN/980BQTbNF6jif+7TZG9/48dMAfSt0qm9y+qCMW
         IlgW2OPycahppZXYkWKkV/nBKmLKZlEyJEDXmW4LS9Yi5V2qdKR6g+R0JrlEMAbOaDHA
         PPUGrgaBPImJeNy67vamT4o8oQHUFw3VDBA/O06n30UW5DTlH96pEE2lOKLbf3FD00Al
         1+I3z4D89DcC+hIRudZ/VJS6HNncUfnWmp0N1KnmKT1cU1NQocjYtBC0jbMVFY2+OAZZ
         DHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GM3qKZo/wzcLg70zQqJjHAuK0IA74OkAb6xTcq3BwDA=;
        b=naCwSh5P3DgEkE3khIwklFGFeN54wl/urxfgElT2ImvtPiZMMTu/D47b5hmiBUI2IO
         WxSCZ7VyUN+LS57I1OrSvagQuORaIwEjxC4VfA9UHf9mP713FSb3MVxewfF4Sk+xpZDB
         Ci7pxTcGYYRSpHGdOlWp7EbuIohTxDsOM6x2MkBkAMcFma8hGqjSsGsXpZ5/CB+Y3V7H
         mQ7oII7r4sAFDAdK2O5h5UiGh+0nJ7gZh32XVEAxHSoPMtJUReeL82ZnOsPIEVX7Kqh6
         hIZULgUnK0fzc3X2jJP8q8i+t843DnWqJqPZ+WG0sX0Z1aiJWGHzHUSmEqH2Tso97fDZ
         /NDA==
X-Gm-Message-State: AOAM5324HBG5u2LeYnklsIXt4c4Ehn49rVYp08cyvGmPNKGw//pht8O5
        H3mm2HbuPL1l5YTcwSyc3aYTbr7rui1Zz1l+
X-Google-Smtp-Source: ABdhPJyH0hrKAJ3DM1ppaOkpeCgT9xwRPqU+GSD4mVE0THD8VazGnty/BU3zEgXs4RoltfhpTr7pEA==
X-Received: by 2002:a4a:a2c5:: with SMTP id r5mr12053251ool.66.1629388191594;
        Thu, 19 Aug 2021 08:49:51 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y5sm760559otu.27.2021.08.19.08.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 08:49:51 -0700 (PDT)
Subject: Re: [PATCH for-next 0/2] tw handlers cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629374041.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cecd264c-0ab7-c41d-6951-f3bce7951685@kernel.dk>
Date:   Thu, 19 Aug 2021 09:49:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629374041.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 5:56 AM, Pavel Begunkov wrote:
> Two simple patches cleaning task_work handlers.
> 
> Pavel Begunkov (2):
>   io_uring: remove mutex in io_req_task_cancel()
>   io_uring: dedup tw-based request failing
> 
>  fs/io_uring.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Applied, thanks.

-- 
Jens Axboe

