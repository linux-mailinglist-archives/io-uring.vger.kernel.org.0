Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABED3151CD
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 15:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhBIOiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 09:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhBIOhh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 09:37:37 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F244C061786
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 06:36:57 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id f2so7045931ioq.2
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 06:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sssg8KmxqU8VRCtUYxA1o0jiJ/Ogsm8bVP7G94M7KA0=;
        b=UIHkK2HX+tLzNxL/ptPBHZMx3SYQKMFY8aCJoIddkhUF+01JXmbyRIAm9Cj7z7EFOt
         zVlxYCfeJoKJsGHbu5qgASUHnp8OucPDl6pmn0biWRmIxvKS+eVcs2Afd3XNE1HQ8baH
         aXINBYnNDwMK7ecaeErOQI6tqLZ4ZLPfsjr6gI8xt+Ox+xI//batqG8ntnmYqOLYbNrQ
         +wYh/8+CTsMaEpiNLRAxJEbW2suGZZnfQ81XAWh95eGe7QTHXSKuEF9PkxFI+ml3Vm3l
         r4SDOkyFqJ6cvyGPKm5j1akkXa74YxMLgLxv9DEk3OgWe6NlGN+O5LXFEyFj78njoPFW
         N3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sssg8KmxqU8VRCtUYxA1o0jiJ/Ogsm8bVP7G94M7KA0=;
        b=b9YNVL1XP1ILd3QaGhn6bSNMlVharYDrEd6ivX3kEKhluWx/obxBTWbc1X4Y2Ao+tY
         6INScxwEF36VCwhc3iuy1dGX62uH65h8wPwG6lWgJlTHK+x1DqDqiVXB+ydcLlVjXjiA
         WbZrrjJmiYrL/tXbCRPTBRyhG3B6wyy527polDlaVIGVPNE+JpztXshuX5WRs4UwKShG
         VC0qwZ1hJqSijbWUq6bQoclSSFWRhetKsgplNTWR1Fi5bbAFtayptRDzjddcmDYRJojj
         sNWecnS1TYa4ygS3ArXTsth/X0qY6PFROsJ8Rrr3If4U5uJqs5I1dJK8UroQpAlc9FiP
         CSJg==
X-Gm-Message-State: AOAM531hnMu+de2x7qsFboaYhMlqHTS4tIYYorOU/kkRYqvhpUxZKPAy
        URkjym3CY1QtbQ4aOZdb+EgpTEV/vCNTI9aZ
X-Google-Smtp-Source: ABdhPJxxTqGhtJcMSiPJCMIu1CELREH8sJLFd1lS8Ok90jVMZpbOZMwdhLOq+c8W6+hvFo+i4hylZw==
X-Received: by 2002:a05:6638:12d3:: with SMTP id v19mr23275574jas.42.1612881416549;
        Tue, 09 Feb 2021 06:36:56 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 14sm10659330ioe.3.2021.02.09.06.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 06:36:56 -0800 (PST)
Subject: Re: [PATCH] fs/io_uring.c: fix typo in comment
To:     zangchunxin@bytedance.com, viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210209024224.84122-1-zangchunxin@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <04e4ac54-c38a-2160-d152-000c0147a274@kernel.dk>
Date:   Tue, 9 Feb 2021 07:36:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209024224.84122-1-zangchunxin@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/21 7:42 PM, zangchunxin@bytedance.com wrote:
> From: Chunxin Zang <zangchunxin@bytedance.com>
> 
> Change "sane" to "same" in a comment in io_uring.c

It's supposed to say 'sane'.

-- 
Jens Axboe

