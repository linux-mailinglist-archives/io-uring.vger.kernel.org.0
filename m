Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1769C55ED92
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 21:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbiF1TGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 15:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiF1TF7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 15:05:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F830540;
        Tue, 28 Jun 2022 12:05:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 744C421FC9;
        Tue, 28 Jun 2022 19:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656443140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fuVIT2jFFHLel+kH8hE4OsDSh9M2jc8g3ptl768Ydp8=;
        b=aBSACyUxXAc7YoXbehaKXbznm9BoO/LYqZ/FxuemcFY0f5+yyIsohbevOIRzZJg6tfc4DH
        fw668jniOfd7x0BpUSFaIjyL2mhV0y+kufWbXX58CJDm7BprruxgNHOEssVRiG0tdC8vb4
        D9fLDZOrejN2FcTZ8IkBWlaP6DEtsdk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40EE7139E9;
        Tue, 28 Jun 2022 19:05:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cncQDQRRu2IpTgAAMHmgww
        (envelope-from <nborisov@suse.com>); Tue, 28 Jun 2022 19:05:40 +0000
Message-ID: <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
Date:   Tue, 28 Jun 2022 22:05:39 +0300
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
> 
> It also happens with virtio-scsi-blk:
>    -device virtio-scsi-pci,id=scsihw0 \
>    -drive file=qemu/atde-test,if=none,id=drive-scsi0,format=raw,cache=none,aio=io_uring \
>    -device scsi-hd,bus=scsihw0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0,id=scsi0,bootindex=100
> 


Alternatively change cache=none (O_DIRECT) to cache=writeback (ordinary 
buffered writeback path) that way we'll know if it's related to the 
iomap-based O_DIRECT code in btrfs.
