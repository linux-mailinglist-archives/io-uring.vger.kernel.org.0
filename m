Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBA2546505
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 13:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbiFJLGU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 07:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbiFJLGT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 07:06:19 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB013C4DB
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 04:06:11 -0700 (PDT)
Message-ID: <bdd8d2b8-6ac0-5a38-6905-0b2a874c035d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654859169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SX7HF9jDtbFlJ0eCluZ6FswIuCdrheuxZoiL8inR8gE=;
        b=hU86aykmC2UBUZV4TZhbRPS+0kTcNwLPaXI4ehM7N3N7bi3rS1+4TIyBFh5xIGgAnpXwMC
        LDWu2Y7AAiHQ2/LOGPCgrydKAOWwRccgrJtjWAS0jGIIhGSFkGBFO88JhC5d8bSQiINaPZ
        YXDrDKjGqZO4H+GnUqiOggcoqgtSawA=
Date:   Fri, 10 Jun 2022 19:06:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCHSET v2 0/6] Allow allocated direct descriptors
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>, vl <vl@samba.org>
References: <20220509155055.72735-1-axboe@kernel.dk>
 <c57c4231-f481-8fdf-5b97-625ada83f83a@samba.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <c57c4231-f481-8fdf-5b97-625ada83f83a@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,
On 6/9/22 16:57, Stefan Metzmacher wrote:
> 
> Hi Jens,
> 
> this looks very useful, thanks!
> 
> I have an additional feature request to make this even more useful...
> 
> IO_OP_ACCEPT allows a fixed descriptor for the listen socket
> and then can generate a fixed descriptor for the accepted connection,
> correct?

Yes.

> 
> It would be extremely useful to also allow that pattern
> for IO_OP_OPENAT[2], which currently is not able to get
> a fixed descriptor for the dirfd argument (this also applies to
> IO_OP_STATX, IO_OP_UNLINK and all others taking a dirfd).
> 
> Being able use such a sequence:
> 
> OPENTAT2(AT_FDCWD, "directory") => 1 (fixed)
> STATX(1 (fixed))
> FGETXATTR(1 (fixed)
> OPENAT2(1 (fixed), "file") => 2 (fixed)
> STATX(2 (fixed))
> FGETXATTR(2 (fixed))
> CLOSE(1 (fixed)
> DUP( 2 (fixed)) => per-process fd for ("file")
> 
> I looked briefly how to implement that.
> But set_nameidata() takes 'int dfd' to store the value
> and it's used later somewhere deep down the stack.
> And makes it too complex for me to create patches :-(
> 

Indeed.. dirfd is used in path_init() etc. For me, no idea how to tackle
it for now.We surely can register a fixed descriptor to the process
fdtable but that is against the purpose of fixed file..

> It would great if someone could have a look how to make this work.
> 
> 
>> Currently using direct descriptors with open or accept requires the
>> application to manage the descriptor space, picking which slot to use
>> for any given file. However, there are cases where it's useful to just
>> get a direct descriptor and not care about which value it is, instead
>> just return it like a normal open or accept would.
>>
>> This will also be useful for multishot accept support, where allocated
>> direct descriptors are a requirement to make that feature work with
>> these kinds of files.
>>
>> This adds support for allocating a new fixed descriptor. This is chosen
>> by passing in IORING_FILE_INDEX_ALLOC as the fixed slot, which is beyond
>> any valid value for the file_index.
> 
> I guess that would not work for linked request, as we don't know the
> actual id before submitting the requests.
> 
> Thanks!
> metze

