Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2DA546590
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 13:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiFJL3F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 07:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243972AbiFJL3D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 07:29:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D082BB37
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 04:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=/ua/2ilMDxgH9I0Ys7hK4oFnc4WJeS5rNcMI3Gaxrbw=; b=DiUCFHEDCoj0SQ0wZ047hZ3c30
        RPqYYcm/98TV14Y6ba8QxxhH6nM0/cng/8SNOnNYXBWxcDXomfitTE077LzrtwHdoi7DyhXwVISFQ
        rSlFFThh9KnCTAXcsSp3Ht6QBv9oydHz/SdnHKAo85XI9faLZOhbM2Zg8j4RtOfpA7PDOQRehLN0D
        /fdawPmiUGW6nyt4Kioy+EJosUsSp48a/hQkADI5aL3nP+2xKxSbpJVaCeK/pCCIkOuzP/7KZ8xDX
        CBRJMekRlgm4CUwHDvycityQ2TjbWG7l+CLVRtd617P5rp7Dm+br8xQB7T0Ek8ITbz0dSA04szaQn
        88dmCil7zHT7felXcdcMqM+MzB7t8ZenSKUf6urhI64T9ghMIdAm36JkDihG5W2W7qHM3uZb1dD7R
        XL+ldW6JqEmsg7godeRKm8YMsCy6MeydkICWdxQgAXEmhChV9j1RUDoiKmgn4t+U/IMfjye8oWgKo
        g+NmUD+5rgfB9HEHnFi8mUAS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nzcoz-0050Gx-4u; Fri, 10 Jun 2022 11:28:57 +0000
Message-ID: <68c7a7cb-63b3-3207-4ba3-e870cc5b6fd9@samba.org>
Date:   Fri, 10 Jun 2022 13:28:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>, vl <vl@samba.org>
References: <20220509155055.72735-1-axboe@kernel.dk>
 <c57c4231-f481-8fdf-5b97-625ada83f83a@samba.org>
 <bdd8d2b8-6ac0-5a38-6905-0b2a874c035d@linux.dev>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCHSET v2 0/6] Allow allocated direct descriptors
In-Reply-To: <bdd8d2b8-6ac0-5a38-6905-0b2a874c035d@linux.dev>
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


Am 10.06.22 um 13:06 schrieb Hao Xu:
> Hi Stefan,
> On 6/9/22 16:57, Stefan Metzmacher wrote:
>>
>> Hi Jens,
>>
>> this looks very useful, thanks!
>>
>> I have an additional feature request to make this even more useful...
>>
>> IO_OP_ACCEPT allows a fixed descriptor for the listen socket
>> and then can generate a fixed descriptor for the accepted connection,
>> correct?
> 
> Yes.
> 
>>
>> It would be extremely useful to also allow that pattern
>> for IO_OP_OPENAT[2], which currently is not able to get
>> a fixed descriptor for the dirfd argument (this also applies to
>> IO_OP_STATX, IO_OP_UNLINK and all others taking a dirfd).
>>
>> Being able use such a sequence:
>>
>> OPENTAT2(AT_FDCWD, "directory") => 1 (fixed)
>> STATX(1 (fixed))
>> FGETXATTR(1 (fixed)
>> OPENAT2(1 (fixed), "file") => 2 (fixed)
>> STATX(2 (fixed))
>> FGETXATTR(2 (fixed))
>> CLOSE(1 (fixed)
>> DUP( 2 (fixed)) => per-process fd for ("file")
>>
>> I looked briefly how to implement that.
>> But set_nameidata() takes 'int dfd' to store the value
>> and it's used later somewhere deep down the stack.
>> And makes it too complex for me to create patches :-(
>>
> 
> Indeed.. dirfd is used in path_init() etc. For me, no idea how to tackle
> it for now.We surely can register a fixed descriptor to the process
> fdtable but that is against the purpose of fixed file..

I looked at it a bit more and the good thing is that
'struct nameidata' is private to namei.c, which simplifies
getting an overview.

path_init() is the actual only user of nd.dfd
and it's used to fill nd.path, either from get_fs_pwd()
for AT_FDCWD and f.file->f_path otherwise.

So might be able to have a function that translated
the fd to struct path early and let the callers pass 'struct path'
instead of 'int dfd'...

metze
