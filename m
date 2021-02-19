Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F713201B6
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 00:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSX05 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 18:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhBSX04 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 18:26:56 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56077C061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 15:26:16 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u11so4190594plg.13
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 15:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=opjCcdC/BVlXaynG1b9dkg7lk00pDVwg9GPdbvYI4LE=;
        b=A46dP0sG9yr1M/gML1c8/LOk2878Uys/y5QOF2R+sSagI+eWFAjV+CKSHJ/av6DcAr
         Or2vQFe1LpMWrkYibEd0F2WsuuqGzyn+cEo9ciXQWL8/0sVYL2WaV6trZpbqyM36dxHm
         5M4C/NP5RDopz6y5zVhbIOL4/S9wAEagqmiRxWF702Mb4JZL3+q5BIB+1Ppl2D0f6bIf
         Dy2VeM2/bp98p5MYuaEb5vJsxNnkbP9sTeiZm4Sr7k3JEkTIQwm7mbeJzoLgotF2aHcs
         yLJm9jUxLgGAdyGt1hW+x2nzVHUe/pt17/DsBZWeCERSJH2Ott68e3N8RHJouG+vRRr2
         5yJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=opjCcdC/BVlXaynG1b9dkg7lk00pDVwg9GPdbvYI4LE=;
        b=bpY57pYb7A0OxbTTx9Ehh/ViqDe20953FlXq+wFdyFXHaIgCj0coIBOc5pkZNDOPDu
         oFKkvp5bdDxUjeHDND2eqWK3Vw0kwUIY8ZqL6EXIi+0m9Qs9UsGTTLwDO8Kc8vY1tPB2
         SwiUF7Qp7pgrUx4oaAotwCX6SKEirb1k4XKK5CEnz0hucwWgu5lP0jptJ1z4mdIjygpU
         +u+bQ/cGuWwjZUr79GahUqdfgtTGouKUCQoTuneisW8xE8sKu+YjeTkf2lJKVuRhd4U/
         Zoz3BvdT1mCUvMIIiu5r6ionVwSQ+yh0MPBuor5bj54D2fzf1SM3UCSD2nsPicJ7qEbA
         FwFg==
X-Gm-Message-State: AOAM530++d8xMSIOTOM+ejwPWfT1AJUBifFGwHVLcxD8xnrYqaCeudNG
        5ROWw4PAgPK8MgF7KF8yezgJiN8CWUukkA==
X-Google-Smtp-Source: ABdhPJwtBaYaybNgmrxprfVfvj2aOLrYh846O8FthcrEiewgmk24n41oWP0hksxETYrzDV6tbg/GBg==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr11530676pjm.28.1613777175785;
        Fri, 19 Feb 2021 15:26:15 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id bj9sm9736049pjb.49.2021.02.19.15.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 15:26:15 -0800 (PST)
Subject: Re: [PATCH 07/18] arch: setup PF_IO_WORKER threads like PF_KTHREAD
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-8-axboe@kernel.dk> <m14ki7og03.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <85fd10b9-6b00-f6d6-f4e2-47139fb22234@kernel.dk>
Date:   Fri, 19 Feb 2021 16:26:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m14ki7og03.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 3:21 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> PF_IO_WORKER are kernel threads too, but they aren't PF_KTHREAD in the
>> sense that we don't assign ->set_child_tid with our own structure. Just
>> ensure that every arch sets up the PF_IO_WORKER threads like kthreads.
> 
> I think it is worth calling out that this is only for the arch
> implementation of copy_thread.

True, that would make it clearer. I'll add that to the commit message.

> This looks good for now.  But I am wondering if eventually we want to
> refactor the copy_thread interface to more cleanly handle the
> difference between tasks that only run in the kernel and userspace
> tasks.

Probably would be a worthwhile future cleanup of the code in general.

-- 
Jens Axboe

