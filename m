Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACC464DC3
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 13:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349193AbhLAMWc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 07:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348986AbhLAMWb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 07:22:31 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC682C061574;
        Wed,  1 Dec 2021 04:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=6KU43wZ9J36UVJct2tFBaP0J686zHinASTKlN4p548s=; b=QxAVDNnXBEaRVfZfvrivAsRCMZ
        GMfMUoJ58Lb7NbNkiqfC00SnwSoNRGEPUwTjgOdq7IC/5TdG/lXY/3UfgsYMhvI2/Cwj8B6kEtKpl
        EN9MQz9CxVU7/M3psyUZIHz/ozta1vzFHD0AcT5Mye2d12kQ2qiAkKP0jv1A3QhezIEEv0uc92za8
        Sq+BsuuFfOc1GwaGALgoOs9j/6O0Jc7ZS17T4rh/fXq7tNP4EfkK7HN7gynYWys3JTRTodhrbVVmU
        N4B45HTuLim/CUq7HS0bVpaEOgOMakK1yZR5VEN00ekiFLYPs6b+LvShys2tpa6vs8GfMdDIij7Ti
        rhJguhyld08HKnpMmINp0zimsZepA619VDWRpqo4dB+tYMo07xzPbVyyUIcNTby4ql6V0Z9pr+ftY
        ZEJXMAubIZxNTa6IawT12yaW615LQ6kaVje0BmpN+CR7jr7HNUdB69pJdMNmoL5Tf55Kd0DGhHQ/D
        KFdAdJ3ALt6K3EBs3OwUr6+z;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1msOZk-000cI6-3e; Wed, 01 Dec 2021 12:19:04 +0000
To:     Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <56e1aa77-c4c1-2c37-9fc0-96cf0dc0f289@samba.org>
Date:   Wed, 1 Dec 2021 13:19:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2ba45a80-ce7a-a105-49e5-5507b4453e05@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

> On 11/29/21 5:08 PM, Clay Harris wrote:
>> On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
>>
>>> This adds the xattr support to io_uring. The intent is to have a more
>>> complete support for file operations in io_uring.
>>>
>>> This change adds support for the following functions to io_uring:
>>> - fgetxattr
>>> - fsetxattr
>>> - getxattr
>>> - setxattr
>>
>> You may wish to consider the following.
>>
>> Patching for these functions makes for an excellent opportunity
>> to provide a better interface.  Rather than implement fXetattr
>> at all, you could enable io_uring to use functions like:
>>
>> int Xetxattr(int dfd, const char *path, const char *name,
>> 	[const] void *value, size_t size, int flags);
>>
>> Not only does this simplify the io_uring interface down to two
>> functions, but modernizes and fixes a deficit in usability.
>> In terms of io_uring, this is just changing internal interfaces.
>>
>> Although unnecessary for io_uring, it would be nice to at least
>> consider what parts of this code could be leveraged for future
>> Xetxattr2 syscalls.
> 
> Clay, 
> 
> while we can reduce the number of calls to 2, providing 4 calls will
> ease the adoption of the interface. 
> 
> If you look at the userspace interface in liburing, you can see the
> following function signature:
> 
> static inline void io_uring_prep_fgetxattr(struct io_uring_sqe *sqe,
> 		                           int         fd,
> 					   const char *name,
> 					   const char *value,
> 					   size_t      len)
> 
> This is very similar to what you proposed.

What's with lsetxattr and lgetxattr, why are they missing.

I'd assume that even 6 helper functions in liburing would be able
to use just 2 low level iouring opcodes.

*listxattr is also missing, are there plans for them?

metze
