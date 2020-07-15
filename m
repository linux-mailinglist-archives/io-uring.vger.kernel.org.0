Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CC9221210
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 18:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgGOQNz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 12:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgGOQNy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 12:13:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D02C08C5DE
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 09:07:38 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l1so2809017ioh.5
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 09:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MDdE/VlcZEnbJj86wVxB052Y/+LiFl2x6lAJALEQ0jU=;
        b=YBXdXkCbrlg83yZ/lSpv8hvbRP3sNJMukN+04o5YtKaBWdonOZhS6JqHKfXXYagapK
         TQq9SlgejpwsPzt/Yv6j+NeZBjeAxvBWVcHWMTOIxvKS9oj9PQIKm+qR6ELQM73AmDCq
         o0baI2feqxYbStu6YFHfL/SrNvUlH3eb0NL6jrjL1JaPd7TKVSgS0mTfrQJcdnwEYxU2
         /4o5/ilVq+Y74DA2MXMTXWURh/LloCG8mWSuO/KW083WDJNMYKrUc9u85qut5jQjV4bQ
         R+O0Fp1vIkvlMhaBohvkenRo3fe/Riccx6DXnHZPI3W8awzQFcnm2nV0Pbmae0Xtkf+j
         ZurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MDdE/VlcZEnbJj86wVxB052Y/+LiFl2x6lAJALEQ0jU=;
        b=t6V2wau+9uusz8P/cSQ9LdhodmRqd3Xe0V1jK1jFyLR/PODkDdFP141j5/p9S8vvpX
         OLHLfd3mqgWxbNIN1+D4UsKMV3blHUGAb5GPQ07lSN0EURnas7uIJNXtCMvbnXIwV2Jb
         /4cyi0eJjonLtMC7PQ6A/ZH6WYoC7ZJxnSHcAPcbVbH6bd8KzoN8s5DSA3pPKhVBy98c
         XJcH1arB76pI79hcL4HK6N4qLHA9WJPHxK6INUELCh0ROkJ7gHhFPzYhFBYDLB32FfAv
         EZdimcpFLl2m0NocDNPaVmB2JmBClrQHIK1IiP/a6LQBOLPXbbQcLNpF+VPC4GSZQyYZ
         NEqg==
X-Gm-Message-State: AOAM530gneO+GkaqSL/cqZ3/euDc3hAYp85fDZDqZ0UProvWrsBXlJgh
        2o4vxd1YJGEVJnAbDdUskm6lQtUYohgzmw==
X-Google-Smtp-Source: ABdhPJzO5mx3Viu9bARpn0nx6FK/5eUYlLdvHZwjq8pIX+qgVny6XNBfMEbdh/ATrDh5xmETbvB/EQ==
X-Received: by 2002:a05:6638:2615:: with SMTP id m21mr108213jat.134.1594829257130;
        Wed, 15 Jul 2020 09:07:37 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p124sm1333941iod.32.2020.07.15.09.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 09:07:36 -0700 (PDT)
Subject: Re: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f88f01e-0867-1ff9-a252-35903e8042a1@kernel.dk>
Date:   Wed, 15 Jul 2020 10:07:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/14/20 3:08 PM, Josh Triplett wrote:
> Add a new operation IORING_OP_OPENAT2_FIXED_FILE, which opens a file
> into the fixed-file table rather than installing a file descriptor.
> Using a new operation avoids having an IOSQE flag that almost all
> operations will need to ignore; io_openat2_fixed_file also has
> substantially different control-flow than io_openat2, and it can avoid
> requiring the file table if not needed for the dirfd.
> 
> (This intentionally does not use the IOSQE_FIXED_FILE flag, because
> semantically, IOSQE_FIXED_FILE for openat2 should mean to interpret the
> dirfd as a fixed-file-table index, and that would be useful future
> behavior for both IORING_OP_OPENAT2 and IORING_OP_OPENAT2_FIXED_FILE.)
> 
> Create a new io_sqe_files_add_new function to add a single new file to
> the fixed-file table. This function returns -EBUSY if attempting to
> overwrite an existing file.
> 
> Provide a new field to pass along the fixed-file-table index for an
> open-like operation; future operations such as
> IORING_OP_ACCEPT_FIXED_FILE can use the same index.

I like this, I think it's really nifty! Private fds are fast fds, and
not only does this allow links to propagate the fds nicely, it also
enables you go avoid the expensive fget/fput for system calls if you
stay within the realm of io_uring for the requests that you are doing.

We do need to preface this with a cleanup that moves the file assignment
out of the prep side of the op handling and into the main part of it
instead. That'll fix those issues associated with needing to do two
bundles in your test case, it could all just be linked at that point.

Some of this is repeats of what we discussed outside of the list emails,
repeating it here for the general audience as well.

-- 
Jens Axboe

