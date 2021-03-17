Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA3033FB71
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCQWpc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhCQWpY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:45:24 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D482C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:45:24 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v3so269528ioq.2
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sJ2r9ot1hRKTo+GdKCCukbMFFSF9o0faMf2eCaj0/V4=;
        b=LJTU1vXK54vCXCWtoPvw+1yUc8zO81w4q/oTKJOmQY7/h0qm/M4AG4MNwuSrE76Ida
         AI2eWh6EAnistYLYFhmSDCy5j/nhmyx+ZpLzKnDQErxRh7zhz7fKt+96rMpqwYikeEmE
         yYpMGfRwE9PwhpacGmhfkm9gw6/OlAhwsKve6TQ4i0RI26+/FZ389cS3CSgoTGbDa8C0
         PXFpBx5TKIHjNYQ9HQ34wCL+Imw0hNn05pTZ/7f4qNuzoRwOjHHelawQtSbReqUphXjd
         8SnydxtAJeBr8HXW2TfVVl3CLpmf40LsntNP8R1DWfRz3YNIQXa8KYNHmxbulGq+raqX
         OTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sJ2r9ot1hRKTo+GdKCCukbMFFSF9o0faMf2eCaj0/V4=;
        b=Zw4+BlOSQaxs123ydeFRnUB0Usy2w8Arp/YAaNSERYbrXxNz54NysQcChFaUJYDr5i
         E3yios1W9qaCaFMCkvPva2qcRlsTJAoupnu9XrLhE6VICLgoJFd3emnp4ZGfCPF6czyf
         Z9glE+6DUp2erOS7UZnPvji4dS2W8uZugz3S7nEf/flgRvPOzHevV4z5ekJ81cq7u0yc
         tl5r3kVwc1sBNLIKRMN9OVlY9m8svCMxz4lyhzCkc1aHwmcVmFaLSDIWF6+nxMDSIRTb
         nh9ZkfcpA+oMCNin4XmfkX8ATZoTZFzqw/vFH6eXgIE2KXAk7j0M/1+y67ZOs/sdwE5U
         SWug==
X-Gm-Message-State: AOAM533qhceuSw81dUk3ArdYMH6p1Z6wACnbGV+hbAW0cT1lG9gRHBuu
        6l0jiN7wP7eEYAGKLGA82sfmhsgVmnURYA==
X-Google-Smtp-Source: ABdhPJx++fvzUMaljDr7xySk5bSz5at2G+hhXE3gTUUDX/JRJaDfNoDBitBmWneFXbXaT4jdq7PHtg==
X-Received: by 2002:a5e:cb4c:: with SMTP id h12mr8063631iok.183.1616021123759;
        Wed, 17 Mar 2021 15:45:23 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p13sm212627ilp.1.2021.03.17.15.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:45:23 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] Some header cleanups
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
 <cover.1615809009.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78f84b74-7579-f641-6917-3e5f64fbd716@kernel.dk>
Date:   Wed, 17 Mar 2021 16:45:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615809009.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/21 5:56 AM, Stefan Metzmacher wrote:
> Hi,
> 
> here're a few cleanups in order to make structures as private and
> typesafe as possible. It also cleans up the layering from io_uring.c
> being on top of io-wq.*.
> 
> Changes since v1:
> 
> - None, hopefully correct patch format now.

And I see you already did resend, thanks I'll take them for 5.12.

-- 
Jens Axboe

