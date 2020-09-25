Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB00278FEC
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 19:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgIYR4O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 13:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgIYR4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 13:56:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4861CC0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 10:56:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b17so2115646pji.1
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 10:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fbp0kr6bqhXmCNxLPzCmnGOQELT0Tqz/++7V/bMm/RQ=;
        b=H9EzJ8w9lQ4QFj5jIfJwzKUKzTmF8z6aSTE3PMdI3Vy2gzX1Gvquh6ho1/50c355a3
         g3XDDgf6kgKI+X58cGvCybRjWoYuiNDtsJFltDMVz0mLuae4bavtx9Xo8BzxspZwlafs
         8gl3aCYHQ8xtsTMb3Apzo8tbjXqNmDV2gtzeHKzlfvhQ+bC/sHo1C3hy83CtzGcbGeOn
         PvHAeimi8jVaWBlOo4M81bUNYxR7iy497xXUajnUh0dl1d/BH8qo5go5AEIHm4oCPkf9
         FcFZz92SYu9X57RiwH8+7968ynCKTAxhN+5sXQ4PaCINt06VxJ1mYufBPu+ZpW0h9Prk
         q8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fbp0kr6bqhXmCNxLPzCmnGOQELT0Tqz/++7V/bMm/RQ=;
        b=P3/aLx8lY1uU4DTSfe84Yog1k8KEfBK8AEPEGIYlwh81PKOq7mG4nG1IS/8h4kaaGS
         /Us2tTpUMg9BcG/TylXok17/gNbvWjV7SwTuOKA33ezosNUv4wlmQujI1x7q1fBaoO8i
         ZcmzFCml4kDRirIZgqOxe60GKEyNqqgtq5fK9x0/57fByGYvIc6h+hQQuFh1vcICu2yC
         5o8jovTzHjhqGwLKRosZ2ZMj4QuypGzmLo+GUO4uq2z4bcrDUxBmpjolrWVFYaZK0DHD
         PiJ4O69WTi1x8Zco6QLPTsKaVjQq2hfb5xygcHNwNtRVkDgTtu/RX7ZrgMUBYh6ZdPiK
         vVog==
X-Gm-Message-State: AOAM533BYzT0P6M9c3srj8kS7gb1tcTPn3Gzlg2ttkHZcupSZc8xQB+M
        pds+2rz7Qo4PyI2Z+/OKww7sFA==
X-Google-Smtp-Source: ABdhPJxCACjEyZNZf74JzWLp+z4Pg2DWFNRXagLHW7i9f9luu63jf/t5uigAs9UqPjXPvTbUOzWmaQ==
X-Received: by 2002:a17:90a:fb84:: with SMTP id cp4mr686050pjb.14.1601056573624;
        Fri, 25 Sep 2020 10:56:13 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o5sm2545214pjs.13.2020.09.25.10.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 10:56:12 -0700 (PDT)
Subject: Re: SQPOLL fd close(2) question
To:     Josef <josef.grieb@gmail.com>, io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
References: <CAAss7+rWKd7QCLaizuWa0dFETzzVajWR4Dw7g+ToC0LLHcA08w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9f1ac2d3-6491-bd5a-99ea-8274a8a19e2b@kernel.dk>
Date:   Fri, 25 Sep 2020 11:56:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rWKd7QCLaizuWa0dFETzzVajWR4Dw7g+ToC0LLHcA08w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/20 10:21 AM, Josef wrote:
> Hi,
> 
> I implemented SQPOLL in netty for 5.8/5.9, to close a fd I need to
> delete the entry first, it seems to fail with error -EADDRINUSE when I
> remove the fd entry, close(2) it and the same socket(with the same
> address) is created again,, is that known?
> I assume that io_uring still has some reference to this, however
> io_uring_unregister_files works fine but the drawback would be that I
> need to wait until the ring is idle

If you have a file registered, that holds a reference to it. So when
you then otherwise close it in the app, it's similar to having done
a dup() on it and just closing the original. So yes, this is known and
expected, I'm afraid.

-- 
Jens Axboe

