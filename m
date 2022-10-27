Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F34610205
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 21:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiJ0Tyx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 15:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiJ0Tyu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 15:54:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66002409A
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 12:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=G97Z2J1cNivVK76dFGonYvCkq38FRu/3xZu9FHl61AU=; b=UchYPw4AYukGxbgRgKCverekHn
        +yU7KiHDTFallLcmfb6Xh7EsnFyQVpoLoeUVL3MUX2bDb+ME9UEKMbWUZvhAqz3nYFMlKEsMkDBxa
        6N6igsVkMyfHcITuXHtfXtyUImr4/k7iEHDr0KLXH00JLwULV+NAdJ4NE7JnPtlpWvGvepUbRC3ML
        7MgeTT9XkQg49xKNbsVEGN6X5jDqkhhR0V+heTkZPhf7v7fDM3aAlVg0TR7x9n3DOF1WLjj5zzW43
        Wdsrrk9L59H7tCTPU7cRxMdEZp5GAoknMkdhsIcsfq5QTLVi/AZi8ghgfQch4yssTsnSmSpGjeyhr
        97lb/x2L0pGZbWNtlyFcU+7DDzEEEpDiUsAG3Rd0ALcwWBdfSpfaEGhy5yvf0KFQ6LTkOjppz0sT2
        G+Gt+/SG3EpHlgIuPr1vowLBf0yknxLkmdMrQ8Rfu5JnWEA4nWQBXbXkbH82Q5/lSckMRJv0L9x3C
        k1CbS/1pMtJxzmbWR3RArc7U;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oo8xi-00654Y-10; Thu, 27 Oct 2022 19:54:46 +0000
Message-ID: <c9a5b180-322c-1eb6-2392-df9370aeb45c@samba.org>
Date:   Thu, 27 Oct 2022 21:54:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> I'm currently trying to prototype for an IORING_POLL_CANCEL_ON_CLOSE
>> flag that can be passed to POLL_ADD. With that we'll register
>> the request in &req->file->f_uring_poll (similar to the file->f_ep list for epoll)
>> Then we only get a real reference to the file during the call to
>> vfs_poll() otherwise we drop the fget/fput reference and rely on
>> an io_uring_poll_release_file() (similar to eventpoll_release_file())
>> to cancel our registered poll request.
> 
> Yes, this is a bit tricky as we hold the file ref across the operation. I'd
> be interested in seeing your approach to this, and also how it would
> interact with registered files...

It should work fine with fixed files, but I haven't tested it.

But from reading the code I'm wondering what happens in general with pending
requests on a closed fixed file? There's no referencing in io_file_get_fixed(),
or is it done via io_req_set_rsrc_node() together with the
io_rsrc_node_switch_start()/io_queue_rsrc_removal()/io_rsrc_node_switch()
within io_fixed_fd_remove()?

But IORING_POLL_CANCEL_ON_CLOSE doesn't have any effect together with
REQ_F_FIXED_FILE (in my current code). Maybe a io_fixed_fd_remove()
should call __io_async_cancel with IORING_ASYNC_CANCEL_FD_FIXED.

I was also thinking if any pending could be canceled by a close(),
because they all have the registered in the struct file list...
But that might be overkill and io_uring aware applications can just use
IORING_ASYNC_CANCEL_FD_* explicitly. Also fixed files are also only
used by io_uring aware code.

metze
