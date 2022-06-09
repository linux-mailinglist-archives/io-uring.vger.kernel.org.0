Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEFE5446CB
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 10:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiFII7O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 04:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242907AbiFII55 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 04:57:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B87154362
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 01:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=LARZC08Swf3lbXE3LHLe0BN8uWaBlpMsfHMSccxOzbw=; b=egyfBRjWzYdqnhqJlOXCt2vSSL
        azwudZ5Jur/yVmZV9sfKXWMVhTZDanepVNyu7pFhjTUBwAX4pSfXPyrFdWWMnKIamq2qvGJmObPyQ
        ZCAXB6Yehl4ugPxFtjxxSGG7gB4NkGNRfp9IB2jfQtIohsVGCYXkLRoxG6bmpBMgJheaeQH07nBjL
        wegXAWCEuEnLjtblQwWpvjLYz+tMdc5IQAPerUgD9Te1TaG41YVufxzEYzy/8TkLcEsNDTor9fGIr
        A9I3UnC9Ech3MH0COuykR2eCJMLPFQ1jz4nto6W82zgp1UdM4zgv8pG8HuvPdTkZuAKUV+1IYU61Q
        bBIEH+w/NBLytaJTnVDNAmrzk7UXviRRouZRsKVqPQtJ6pUMlgI2yxfMK2W7qmI00RsuKLMvi+WBx
        /WwR8LTu67kPjXLEG+/uiCf+1m24IE5vtH6Yt/LB5KSMIQ8Gi8rp63FMlgi/o7VxWoAQptTKJ0ssu
        17Htaw+cRQn2RUZPnIr3Y6L6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nzDys-004lCL-TR; Thu, 09 Jun 2022 08:57:30 +0000
Message-ID: <c57c4231-f481-8fdf-5b97-625ada83f83a@samba.org>
Date:   Thu, 9 Jun 2022 10:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>, vl <vl@samba.org>
References: <20220509155055.72735-1-axboe@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCHSET v2 0/6] Allow allocated direct descriptors
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

this looks very useful, thanks!

I have an additional feature request to make this even more useful...

IO_OP_ACCEPT allows a fixed descriptor for the listen socket
and then can generate a fixed descriptor for the accepted connection,
correct?

It would be extremely useful to also allow that pattern
for IO_OP_OPENAT[2], which currently is not able to get
a fixed descriptor for the dirfd argument (this also applies to
IO_OP_STATX, IO_OP_UNLINK and all others taking a dirfd).

Being able use such a sequence:

OPENTAT2(AT_FDCWD, "directory") => 1 (fixed)
STATX(1 (fixed))
FGETXATTR(1 (fixed)
OPENAT2(1 (fixed), "file") => 2 (fixed)
STATX(2 (fixed))
FGETXATTR(2 (fixed))
CLOSE(1 (fixed)
DUP( 2 (fixed)) => per-process fd for ("file")

I looked briefly how to implement that.
But set_nameidata() takes 'int dfd' to store the value
and it's used later somewhere deep down the stack.
And makes it too complex for me to create patches :-(

It would great if someone could have a look how to make this work.


> Currently using direct descriptors with open or accept requires the
> application to manage the descriptor space, picking which slot to use
> for any given file. However, there are cases where it's useful to just
> get a direct descriptor and not care about which value it is, instead
> just return it like a normal open or accept would.
> 
> This will also be useful for multishot accept support, where allocated
> direct descriptors are a requirement to make that feature work with
> these kinds of files.
> 
> This adds support for allocating a new fixed descriptor. This is chosen
> by passing in IORING_FILE_INDEX_ALLOC as the fixed slot, which is beyond
> any valid value for the file_index.

I guess that would not work for linked request, as we don't know the
actual id before submitting the requests.

Thanks!
metze
