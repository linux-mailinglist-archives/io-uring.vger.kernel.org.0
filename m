Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9A55ED83
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 21:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiF1TEd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 15:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbiF1TEI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 15:04:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566B410555;
        Tue, 28 Jun 2022 12:03:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CDA542201C;
        Tue, 28 Jun 2022 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656443001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OpyXs0OFSpQov0g4vc9i6J/eu2tpQHUGz8Kz/G4wjDQ=;
        b=GoE15nT7kmDkhc9q7qTSVPS/+x91suVTEEnX7i6qEqT6p7BILNV/0VKOKJnY4zf4Iq8aIB
        Kz2Ep6+0GC4jO1hDR+r90We3+6byUqgBGEMcijuaO7UI2w3ASmFHNLEOExnEFk+S7Cl8VR
        ZvPIwNuHzyMv0vJWUngzXVw3q5dVTEk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94382139E9;
        Tue, 28 Jun 2022 19:03:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1Fs/IXlQu2JcTQAAMHmgww
        (envelope-from <nborisov@suse.com>); Tue, 28 Jun 2022 19:03:21 +0000
Message-ID: <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
Date:   Tue, 28 Jun 2022 22:03:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: read corruption with qemu master io_uring engine / linux master /
 btrfs(?)
Content-Language: en-US
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <YrrFGO4A1jS0GI0G@atmark-techno.com>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <YrrFGO4A1jS0GI0G@atmark-techno.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,TRACKER_ID,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 28.06.22 г. 12:08 ч., Dominique MARTINET wrote:
> I don't have any good reproducer so it's a bit difficult to specify,
> let's start with what I have...
> 
> I've got this one VM which has various segfaults all over the place when
> starting it with aio=io_uring for its disk as follow:
> 
>    qemu-system-x86_64 -drive file=qemu/atde-test,if=none,id=hd0,format=raw,cache=none,aio=io_uring \
>        -device virtio-blk-pci,drive=hd0 -m 8G -smp 4 -serial mon:stdio -enable-kvm

So cache=none means O_DIRECT and using io_uring. This really sounds 
similar to:

ca93e44bfb5fd7996b76f0f544999171f647f93b

This commit got merged into v5.17 so you shouldn't be seeing it on 5.17 
and onwards.

<snip>

> 
> Perhaps at this point it might be simpler to just try to take qemu out
> of the equation and issue many parallel reads to different offsets
> (overlapping?) of a large file in a similar way qemu io_uring engine
> does and check their contents?

Care to run the sample program in the aforementioned commit and verify 
it's not failing

> 
> 
> Thanks, and I'll probably follow up a bit tomorrow even if no-one has
> any idea, but even ideas of where to look would be appreciated.
