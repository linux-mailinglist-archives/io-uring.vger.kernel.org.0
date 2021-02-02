Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5335530CD1D
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 21:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhBBUbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 15:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhBBUam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 15:30:42 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACE0C06178A
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 12:30:01 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j2so14010566pgl.0
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 12:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CbzlF/JaHRr16+J6ZbepJjtmzPGphLVsGRqlfDfcu/E=;
        b=a82iny/F82u9crsPNMyL/kD0P7IJBR+UYj63shtahobjvCOP30JGKuQH2ouOYGzX/O
         StSLXReiPcLRxqNHFNgFLogZ0nb100nbZtvkIA3CC3tJktbdVMJJTFvM2oYbLkTkgMH2
         lgit5/VcUL3d5lvh1ZvIUQCkqF9B8Svh4vOtGWV6hlOKgy/z60BcEOhYPr4qvw6PsiL3
         f3JIbtoCROhHRalukwByKrEEy9qbJ99SbiH0yQ70GV8jFRnwE5TTBzeyjQirGdc8UEpw
         q9YdyYQUjR/d6pwn7ZIZkrIXYzO81ZJFB334czSAXTKwWn8QpiN5gspH1i4c02fMpToq
         uWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CbzlF/JaHRr16+J6ZbepJjtmzPGphLVsGRqlfDfcu/E=;
        b=T3NJM7UsSqc9GtMCZ1lj93diebkkHVvkv9FJka4kKK4nB8CHvbYHcuE7JR4Pejd90K
         q3Y/wExb28AcameEdwBeteo2mmQD5aWzbA95rte6WNF1p1TZtVFyPlSwiWOiZt2Eq+a2
         Mt12anRDmEzvusGOWRpbJKqMSbHQJDTf3z/7TeaMlfFBYyj+bfHeQdXIXPmQfgc0oG3a
         PXWhZCiMMQi+FmHMdBivnLS/gdXDV166Rpr+jcA1aEmXddLC6EZvqdPO0D3xGkNzT7mR
         dutDtQHToQwf/e6Ta3fF3JjB0+nd2IXD6SDT8kgtbDd0Z371obQ+XhTtSGgJ5mNwR8Jf
         z5Og==
X-Gm-Message-State: AOAM5319GzocK2VopNn2bXBnFOjDvsojNS6XhC2yR/87TrnDZ70Vq+nF
        051/1GR8sXbGqxYyrVn61n/wyA==
X-Google-Smtp-Source: ABdhPJzUrTAWUIrrPQ63vs9ibP97/qlWizeOefIughz9LH6ZssxrEfSsGeAokLu2efVHqO8YgkA7CA==
X-Received: by 2002:a62:8f90:0:b029:1ca:890c:50dc with SMTP id n138-20020a628f900000b02901ca890c50dcmr19677132pfd.61.1612297801279;
        Tue, 02 Feb 2021 12:30:01 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v136sm10302530pfc.70.2021.02.02.12.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:30:00 -0800 (PST)
Subject: Re: [PATCH] io_uring: Add skip option for __io_sqe_files_update
To:     Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210126202326.3143037-1-goldstein.w.n@gmail.com>
 <CAFUsyfLChkYYjBBtkcAErqrs3XaZ80zaPCB3Qn3rWPYTDd88Mg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f4ab7b0-9e19-8f55-efb2-428b9a2bc366@kernel.dk>
Date:   Tue, 2 Feb 2021 13:29:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFUsyfLChkYYjBBtkcAErqrs3XaZ80zaPCB3Qn3rWPYTDd88Mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 1:16 PM, Noah Goldstein wrote:
> Ping

It's already in.

-- 
Jens Axboe

