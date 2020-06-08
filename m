Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478CF1F109E
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 02:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgFHAMW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 20:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgFHAMV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 20:12:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051C4C08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 17:12:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v24so5948569plo.6
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 17:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2bBx3oE3gryLWooYTH15H8cxF9VXrlwb1RvtH9y7Z+s=;
        b=KPqyMWHkfciBDZTgSEXOHpGN3LCkrHlf/M3HDNSBBRW/GLUfunaR1hDRMwFOw381M9
         Ig2i5htWvMU606ThPuPrTdPIBInX8ZPKk0AXMIt1odNlHb32R6caKpvlh47wjFpwy+mi
         LHgrMEWMEopcrpqKYTf8QolWI5cnAZLp6Fx+aJ/G4CiPyq8TWzn9NLlT8lfzQV80poQ5
         aC7tWIn1ZvThmRNeUOF64xBBRgRuEYsCbpKGLucUnBmgiT7hKq7rAJe3wm2SKnt9FcaA
         OMgC4sqCdyvw8mWPReRTKnF3SFgOtHYBgROoQM0+Pt935pAFMPOADRUjc1TMe8fDPQzC
         17og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2bBx3oE3gryLWooYTH15H8cxF9VXrlwb1RvtH9y7Z+s=;
        b=NlQnVWrkJYvQXcZM/hZeHTGme+JLTWt2YU73RMDS/PvRbEeWEFbbYio/Pqko72QT2P
         VQodakkYhEuX+b6hcOASyL31OLQLTv1FYukm7zvX8BmlYgvqt4Gfz595s5ReSc3WUOhS
         HQr/4TZLbifOsksFQOWP3rY9aDhPfaAcIR7NLPbxX7ydgPHTDtlY5X/LhLD2XHmjb5CL
         h5kk4m4LrRcD/2Ndwuy0oY6Fl+9EOuFlnu7e5cUPuWgTm8JHiIVIlcRnZx83k8Y9Bw3S
         IE9lOlCijJ8Xig2REfJnPMMCC3eYcOHSDIhG3PNCn196kwQg6Mf8Rg6Bk3tqrRx0/+sL
         vrmg==
X-Gm-Message-State: AOAM533oa768jrXSa+kOk5gtJTtt4+QPF2oKwyB+qV0vd2pnDtagAFH0
        pzi785CVWsj17OwKJkpWAYTEuw==
X-Google-Smtp-Source: ABdhPJzW69he1vfY4B5YhoTgmVyQ0cgXOhFVX/CZU/4m+uzWaEQJ1RUd5JpbdG0VfkZKhGMsfP2Idg==
X-Received: by 2002:a17:90b:e05:: with SMTP id ge5mr14523293pjb.49.1591575140157;
        Sun, 07 Jun 2020 17:12:20 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k126sm5293462pfd.129.2020.06.07.17.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 17:12:19 -0700 (PDT)
Subject: Re: [PATCH 0/4] cancel all reqs of an exiting task
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591541128.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3924c8b4-fb37-0d85-b8ce-4183e6fff317@kernel.dk>
Date:   Sun, 7 Jun 2020 18:12:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1591541128.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/7/20 9:32 AM, Pavel Begunkov wrote:
> io_uring_flush() {
>         ...
>         if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>                 io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
> }
> 
> This cancels only the first matched request. The pathset is mainly
> about fixing that. [1,2] are preps, [3/4] is the fix.
> 
> The [4/4] tries to improve the worst case for io_uring_cancel_files(),
> that's when they are a lot of inflights with ->files. Instead of doing
> {kill(); wait();} one by one, it cancels all of them at once.
> 
> Pavel Begunkov (4):
>   io-wq: reorder cancellation pending -> running
>   io-wq: add an option to cancel all matched reqs
>   io_uring: cancel all task's requests on exit
>   io_uring: batch cancel in io_uring_cancel_files()
> 
>  fs/io-wq.c    | 108 ++++++++++++++++++++++++++------------------------
>  fs/io-wq.h    |   3 +-
>  fs/io_uring.c |  29 ++++++++++++--
>  3 files changed, 83 insertions(+), 57 deletions(-)

Can you rebase this to include the changing of using ->task_pid to
->task instead? See:

https://lore.kernel.org/io-uring/87a71jjbzr.fsf@x220.int.ebiederm.org/T/#u

Might as well do it at the same time, imho, since the cancel-by-task is
being reworked anyway.

-- 
Jens Axboe

