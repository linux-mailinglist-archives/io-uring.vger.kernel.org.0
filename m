Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776EF33FB51
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhCQWgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhCQWgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:36:07 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D42C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:36:07 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id k8so250038iop.12
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YAK0syGUzHNjIKUa/0XWf4V+SPaSJYdlNxIdg0L4kGw=;
        b=NbF+jPeE50lRHlAvT5y3rTCZ3pZVn2HJiw7bkIVPyxYw7EfwKuFOnq7mRFx5/uDfKa
         SoIg7OTIUpBxSuDcQKq1kdabhCR7Wr8nLZm2+zabvfBdEACgRJOpCPKBsuB5Wd91234a
         Yk//sGFHeJsOyc7N3aO+ZlK/yGqbL/JMo/0Fvr3s//3wmSKqt/Up1PsAX1pxJ62PpIdv
         VHSjhg8F6TRpSvuyd3wOHCu54JwvM+cUfrhUypwFPKmHLxCtvcZJVXlPvq5/o7Ig4Zj1
         oXQValvdp4TS9qH4934NskzsuhXByE2s+t0RQG4KP7QyePtx1uk0nkDWbnA12Ln5l6QP
         V8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YAK0syGUzHNjIKUa/0XWf4V+SPaSJYdlNxIdg0L4kGw=;
        b=eL6AzMsAPgsj42wiaaDAzbr83v0+np3huF3Al9041i3zroLJ8rU6VAsllfvP3JPSzl
         ORzWIxoG5+B30lhYYCjh5YNaVLFYU9ZTHozyn7/M5wGNPh+YP4VszKqX8rOsGWEzvqmJ
         DkMx8bH1C+Bc0qPyQ9Bo8LHZwl0/2Et6jlalB9NGTc0C6WLXzodMVmAwVWpbZOavaXSv
         PATWplZbe1FfHYFz+axdXgTkL3FFoHlDQdfvS3XLHyMBuj560HI1KIf11OscMv9Nkygw
         0nYaFhhYOniAoIiYSRsa1wA4CLlmS5h+n3ALPR1M+Y95Q4VJlztXr12FLS7lUq3r1QOG
         5fsg==
X-Gm-Message-State: AOAM531iYK36H8ZaDclSEK1Wdcj93F2TCyhwz6f/C776tHvo7+dqbrVB
        niObrC4jmWiVoTaUIPmjqPbmUM8F1ZKQbg==
X-Google-Smtp-Source: ABdhPJwIG9sw0wjXgGvofJ0qs1WhsPX/lWfMvvnEav+fqSUcoOegKnUOK61UNQQOSTaqp566TrDhzA==
X-Received: by 2002:a6b:7808:: with SMTP id j8mr8368889iom.118.1616020566339;
        Wed, 17 Mar 2021 15:36:06 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m4sm179156ilf.80.2021.03.17.15.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:36:05 -0700 (PDT)
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1615908477.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
Date:   Wed, 17 Mar 2021 16:36:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615908477.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/21 9:33 AM, Stefan Metzmacher wrote:
> Hi,
> 
> here're patches which fix linking of send[msg]()/recv[msg]() calls
> and make sure io_uring_enter() never generate a SIGPIPE.
> 
> Stefan Metzmacher (2):
>   io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]()
>     calls
>   io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
> 
>  fs/io_uring.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)

Applied for 5.12, thanks.

-- 
Jens Axboe

