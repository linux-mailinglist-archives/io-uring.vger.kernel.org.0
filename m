Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF01A3E46F0
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 15:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhHINyD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 09:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhHINyC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 09:54:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CC7C061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 06:53:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id oa17so3208513pjb.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 06:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=igjzrrI7KDCEN5Sq9FeGpvfW+gTd+27rSugH3w+X1u0=;
        b=GD3tN2UlbJHNlEM061BQghn6cx8kfgkbi5rdG/KbTvYJzyR+F7QVZfRKd5gCzCfFLt
         cigY9Hre4inJtamCLE9SyUdtnJ0LgWket3V/43ZDnVTLi/whDlCuLu8jJp4BZgqTABf5
         27mdntgd4HereoVyVQl/U8prTOhuZMR7r28NJpLgPW2a3JNvUJL/A5nlLIwKHUzdkChv
         OBu+q/AC3+pXoay0qesJ+CLNGIUPmHntyFK0XLb8oIJVPRrzyd00Ca+cCbpAWEAW1Su0
         DKXQ+jLWN9xonvQSa0LWRi/g50zNum0cfpfnmIHndSB0duo+hfwrX2kprcvdKDjSvaK9
         mYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=igjzrrI7KDCEN5Sq9FeGpvfW+gTd+27rSugH3w+X1u0=;
        b=nn9j2owzpveQdMlVeX9yz+saSxmGuasc7CMFaSdIRZLVZS82VXvijt0c8wGUn485EL
         2aGADa7zlXCcNh5+weuduJcwCbHArepW2WpZ25g+nEm6GRpzzwxQ0lZfsU+otOJgCGhG
         +PUQ4Xs/twI1ubp17qOwkY+O7Sc6TKZgtJctJnVBkqNU010A9CQxMtIpBHgYorxGj+CN
         ZtwTRNP32FiEbDN2jLV/mWEf72dQM/6obIOsn7Fp0yN2/tUT8jHn9t61J+kLHd1SKO9Z
         DXMSOiE/a9YnpiBHew045LOlUu0k+FjdIlioqyP9J/nyDt7ve/xG/Btu4QW9Rfw6PAdt
         op1A==
X-Gm-Message-State: AOAM532gIDzMPM+CLdmsdRMyHth/LXEHnS29UfDL0iX9lTXkTDXmWAnN
        3b30Asr+RKXWMKsXkoPe7Z7xzA==
X-Google-Smtp-Source: ABdhPJxVIyLaNWIy8ZJG0JfAI6gamyCwcqcGgMwTnQDs8+RsueH+BbTbg4H9/rgmHiQl+2hudgOPjg==
X-Received: by 2002:a17:90a:a103:: with SMTP id s3mr25707652pjp.121.1628517221091;
        Mon, 09 Aug 2021 06:53:41 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id q68sm24005654pgq.5.2021.08.09.06.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 06:53:40 -0700 (PDT)
Subject: Re: [PATCH 0/2] io_uring: bug fixes
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20210808001342.964634-1-namit@vmware.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bc323fb8-5b3d-6268-4a26-c6850eb4fb2f@kernel.dk>
Date:   Mon, 9 Aug 2021 07:53:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210808001342.964634-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/21 6:13 PM, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Two small bug fixes. The first fix is for a real issue that encountered
> on 5.13, which caused my workload not to work with a submission queue.
> Apparently, on 5.14 it is only a performance issue (i.e., not a
> functionality issue).
> 
> The second fix is for a theoretical issue.
> 
> I did not cc stable, as I leave this decision to the maintainer.

Applied, thanks!

-- 
Jens Axboe

