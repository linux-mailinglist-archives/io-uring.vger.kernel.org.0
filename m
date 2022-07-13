Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33275735CF
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 13:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiGMLuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 07:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGMLuB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 07:50:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDEAE4778;
        Wed, 13 Jul 2022 04:50:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 04A5220076;
        Wed, 13 Jul 2022 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657712999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfMyiG6I6kY9duJdum1vSBmQPs459FBBxkpB0eMmIG4=;
        b=MBiFCVEpkGBkXylj/DRftkyXS3dQHP175Q8BVAy2q/IIyUM9glNzGIHwRU2mQZ96irpV2K
        DlzRfYX433mqXk8g+jxRPb880qGKAPuOjxu+0D8ZioPWBSGrDlCy6UDCr4tSNU+qBfky2l
        35Ut5Xx1KWYMRX9VevE+QLW5Fwtkbkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657712999;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfMyiG6I6kY9duJdum1vSBmQPs459FBBxkpB0eMmIG4=;
        b=pGNNYSoAwdU5qBAB/O0zEtiuqF8w8l5ur5tzVXP2y/lncNKQlKY6cQX3+vnO+oYLbajtP6
        gRrtRfWmCLKbv/BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A901B13AAD;
        Wed, 13 Jul 2022 11:49:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4/GJKGaxzmKsFgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 13 Jul 2022 11:49:58 +0000
Message-ID: <96f47d9b-fbfc-80da-4c38-f46986f14a43@suse.de>
Date:   Wed, 13 Jul 2022 13:49:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com> <20220712065250.GA6574@lst.de>
 <436c8875-5a99-4328-80ac-6a5aef7f16f4@grimberg.me>
 <20220713053633.GA13135@lst.de>
 <24f0a3e6-aa53-8c69-71b7-d66289a63eae@grimberg.me>
 <20220713101235.GA27815@lst.de>
 <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
In-Reply-To: <772b461a-bc43-c229-906d-0e280091e17f@grimberg.me>
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

On 7/13/22 13:00, Sagi Grimberg wrote:
> 
>>> Maybe the solution is to just not expose a /dev/ng for the mpath device
>>> node, but only for bottom namespaces. Then it would be completely
>>> equivalent to scsi-generic devices.
>>>
>>> It just creates an unexpected mix of semantics of best-effort
>>> multipathing with just path selection, but no requeue/failover...
>>
>> Which is exactly the same semanics as SG_IO on the dm-mpath nodes.
> 
> I view uring passthru somewhat as a different thing than sending SG_IO
> ioctls to dm-mpath. But it can be argued otherwise.
> 
> BTW, the only consumer of it that I'm aware of commented that he
> expects dm-mpath to retry SG_IO when dm-mpath retry for SG_IO submission
> was attempted (https://www.spinics.net/lists/dm-devel/msg46924.html).
> 
>  From Paolo:
> "The problem is that userspace does not have a way to direct the command 
> to a different path in the resubmission. It may not even have permission 
> to issue DM_TABLE_STATUS, or to access the /dev nodes for the underlying 
> paths, so without Martin's patches SG_IO on dm-mpath is basically 
> unreliable by design."
> 
> I didn't manage to track down any followup after that email though...
> 
I did; 'twas me who was involved in the initial customer issue leading 
up to that.

Amongst all the other issue we've found the prime problem with SG_IO is 
that it needs to be directed to the 'active' path.
For the device-mapper has a distinct callout (dm_prepare_ioctl), which 
essentially returns the current active path device. And then the 
device-mapper core issues the command on that active path.

All nice and good, _unless_ that command triggers an error.
Normally it'd be intercepted by the dm-multipath end_io handler, and 
would set the path to offline.
But as ioctls do not use the normal I/O path the end_io handler is never 
called, and further SG_IO calls are happily routed down the failed path.

And the customer had to use SG_IO (or, in qemu-speak, LUN passthrough) 
as his application/filesystem makes heavy use of persistent reservations.

So yeah, nvme-multipathing should be okay here, as io_uring and normal 
I/O are using the same code paths, hence the above scenario really won't 
occur.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
