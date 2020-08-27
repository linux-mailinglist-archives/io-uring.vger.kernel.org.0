Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3720254664
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgH0OEF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgH0ODp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:03:45 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA0CC061234
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 06:50:47 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id e17so508199ils.10
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 06:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iAwILKXaGwE32BKWKaWMGVaA1oh3sBt+J35AZWjjyZY=;
        b=qxwcVn5JQ9XYTQbP2HLcOTAwz30rF8EQCFatdqtquebkoj614HXR5RCCZn47g/sFms
         b1B9FEawJrQ0st6va0eVKzrouTvhxlfCKY5lceQ5M0mEFmP87mCM1WfcXMY0rTnFfVWm
         ySrewvO/AFV5vFAEV6VVxXDaIpQGU8hvL4BcPZuxNtv5wV6r5lx2MWlDm6fmA38V1ah8
         r1c5ALWfnWIYR9RXi08rgC36D4UJkyd3fxxLQOp2nslXWKm67FvJLiKHgCs5NPTS1n7/
         7nibAib6cK52NRtC/4y31vn1506yvBpqn+dx3MKZwQuMTZ4yMdm+HHMTG3w2Tel1aVZ1
         ytUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iAwILKXaGwE32BKWKaWMGVaA1oh3sBt+J35AZWjjyZY=;
        b=m3u1XVZlK3ArRv8z5HYX6hGwQb3JSfWxc9Ppg1IeqNgiI8LitCwATDAugMWNSTaPmM
         9T3FRtiSqdZ5NyIInwiLpCiy0oUx19Um6aE9mMZTV45LbMQYqSap2CZlZ/gnNfn5POIT
         h1Xi7T/+jZh/HvKcJ3XIiT6Rh/kjIJ3rqbdMDYvneFB3ePxp8z2WjROpS6y8hsNj4nGQ
         j3zrFbnTq5A01w0u0/QH8MExs5H6HzKyx8jwEIyTvTKsz4VlPl25gO90KPb0Z+NLoPxf
         j4P/g41p8h60EqeBkwKC07UCRX1WjopTvZ8LXONN+fwEFujRzKMQeoepfRiSWOcpGrEC
         vS8w==
X-Gm-Message-State: AOAM531YH9f5AU8yuesLEdMTeZs79wsmP5GTo8udiW7eRvPtpBwfih0D
        VsHDPYILMsCpdJ0de6ZSuP8l/g==
X-Google-Smtp-Source: ABdhPJzOPDGdpeaugrph99pH0rYwmDwtHxNDF8nsNnio4tgus2HsTtEiJ9SU9c3mUcm6yO9cBck+8w==
X-Received: by 2002:a05:6e02:1066:: with SMTP id q6mr17103230ilj.29.1598536245882;
        Thu, 27 Aug 2020 06:50:45 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 79sm1247128ilc.9.2020.08.27.06.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 06:50:45 -0700 (PDT)
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
Date:   Thu, 27 Aug 2020 07:50:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827134044.82821-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> v5:
>  - explicitly assigned enum values [Kees]
>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
>  - added Kees' R-b tags
> 
> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> 
> Following the proposal that I send about restrictions [1], I wrote this series
> to add restrictions in io_uring.
> 
> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> available in this repository:
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> 
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> applications or guests to use io_uring queues.
> 
> The first patch changes io_uring_register(2) opcodes into an enumeration to
> keep track of the last opcode available.
> 
> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> handle restrictions.
> 
> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> allowing the user to register restrictions, buffers, files, before to start
> processing SQEs.
> 
> Comments and suggestions are very welcome.

Looks good to me, just a few very minor comments in patch 2. If you
could fix those up, let's get this queued for 5.10.

-- 
Jens Axboe

