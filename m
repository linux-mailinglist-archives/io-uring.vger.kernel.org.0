Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13027573857
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 16:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiGMOH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 10:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiGMOH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 10:07:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5CB3245D;
        Wed, 13 Jul 2022 07:07:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9EA9E20191;
        Wed, 13 Jul 2022 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657721243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnfH5Bkw5sQHVn/yM5oao0mW1esxplkQAuhzbZiKYqE=;
        b=A6XHUOyyHlyOjWK8LU1J/6Y3xtEnLfnWHTuZ2ryLiwr5fZEt6TdqxVIJvWIAH6wbBIprCY
        1YToZquVTYvBCHATjDN8NgJQmt/KOUe9n9U6HKXhsGlWNtgMbMQTSsUsYYmFfaKYwH1rDl
        iNGGiBzQ7pETFKCDvbcJ7ZEq8DrklWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657721243;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnfH5Bkw5sQHVn/yM5oao0mW1esxplkQAuhzbZiKYqE=;
        b=ZWBzEKXU6QQGbJotrjpfGHTK5uJXakqmuiSbGwhK8a/Nir9JZLtnwlmMDtmJu9v1zn8Lsw
        VhbwrbinaOhpJzCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4053B13AAD;
        Wed, 13 Jul 2022 14:07:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Z71iD5vRzmLZVgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 13 Jul 2022 14:07:23 +0000
Message-ID: <1d1d94ea-b67b-405c-c825-faf67f258558@suse.de>
Date:   Wed, 13 Jul 2022 16:07:22 +0200
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
 <96f47d9b-fbfc-80da-4c38-f46986f14a43@suse.de>
 <7c7a093c-4103-b67d-c145-9d84aaae835e@grimberg.me>
 <04b475f6-506f-188b-d104-b27e9dffc1b8@suse.de>
 <66322f2d-fbde-7b9f-14f1-0651511d95b8@grimberg.me>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
In-Reply-To: <66322f2d-fbde-7b9f-14f1-0651511d95b8@grimberg.me>
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

On 7/13/22 15:41, Sagi Grimberg wrote:
> 
>>>>>>> Maybe the solution is to just not expose a /dev/ng for the mpath 
>>>>>>> device
>>>>>>> node, but only for bottom namespaces. Then it would be completely
>>>>>>> equivalent to scsi-generic devices.
>>>>>>>
>>>>>>> It just creates an unexpected mix of semantics of best-effort
>>>>>>> multipathing with just path selection, but no requeue/failover...
>>>>>>
>>>>>> Which is exactly the same semanics as SG_IO on the dm-mpath nodes.
>>>>>
>>>>> I view uring passthru somewhat as a different thing than sending SG_IO
>>>>> ioctls to dm-mpath. But it can be argued otherwise.
>>>>>
>>>>> BTW, the only consumer of it that I'm aware of commented that he
>>>>> expects dm-mpath to retry SG_IO when dm-mpath retry for SG_IO 
>>>>> submission
>>>>> was attempted (https://www.spinics.net/lists/dm-devel/msg46924.html).
>>>>>
>>>>>  From Paolo:
>>>>> "The problem is that userspace does not have a way to direct the 
>>>>> command to a different path in the resubmission. It may not even 
>>>>> have permission to issue DM_TABLE_STATUS, or to access the /dev 
>>>>> nodes for the underlying paths, so without Martin's patches SG_IO 
>>>>> on dm-mpath is basically unreliable by design."
>>>>>
>>>>> I didn't manage to track down any followup after that email though...
>>>>>
>>>> I did; 'twas me who was involved in the initial customer issue 
>>>> leading up to that.
>>>>
>>>> Amongst all the other issue we've found the prime problem with SG_IO 
>>>> is that it needs to be directed to the 'active' path.
>>>> For the device-mapper has a distinct callout (dm_prepare_ioctl), 
>>>> which essentially returns the current active path device. And then 
>>>> the device-mapper core issues the command on that active path.
>>>>
>>>> All nice and good, _unless_ that command triggers an error.
>>>> Normally it'd be intercepted by the dm-multipath end_io handler, and 
>>>> would set the path to offline.
>>>> But as ioctls do not use the normal I/O path the end_io handler is 
>>>> never called, and further SG_IO calls are happily routed down the 
>>>> failed path.
>>>>
>>>> And the customer had to use SG_IO (or, in qemu-speak, LUN 
>>>> passthrough) as his application/filesystem makes heavy use of 
>>>> persistent reservations.
>>>
>>> How did this conclude Hannes?
>>
>> It didn't. The proposed interface got rejected, and now we need to 
>> come up with an alternative solution.
>> Which we haven't found yet.
> 
> Lets assume for the sake of discussion, had dm-mpath set a path to be
> offline on ioctl errors, what would qemu do upon this error? blindly
> retry? Until When? Or would qemu need to learn about the path tables in
> order to know when there is at least one online path in order to retry?
> 
IIRC that was one of the points why it got rejected.
Ideally we would return an errno indicating that the path had failed, 
but further paths are available, so a retry is in order.
Once no paths are available qemu would be getting a different error 
indicating that all paths are failed.

But we would be overloading a new meaning to existing error numbers, or 
even inventing our own error numbers. Which makes it rather awkward to use.

Ideally we would be able to return this as the SG_IO status, as that is 
well capable of expressing these situations. But then we would need to 
parse and/or return the error ourselves, essentially moving sg_io 
funtionality into dm-mpath. Also not what one wants.

> What is the model that a passthru consumer needs to follow when
> operating against a mpath device?

The model really is that passthru consumer needs to deal with these errors:
- No error (obviously)
- I/O error (error status will not change with a retry)
- Temporary/path related error (error status might change with a retry)

Then the consumer can decide whether to invoke a retry (for the last 
class), or whether it should pass up that error, as maybe there are 
applications with need a quick response time and can handle temporary 
failures (or, in fact, want to be informed about temporary failures).

IE the 'DNR' bit should serve nicely here, keeping in mind that we might 
need to 'fake' an NVMe error status if the connection is severed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
