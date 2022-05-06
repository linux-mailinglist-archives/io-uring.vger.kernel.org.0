Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB651D949
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 15:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392609AbiEFNln (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 09:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392605AbiEFNll (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 09:41:41 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F80266C8D
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 06:37:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d25so6279721pfo.10
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 06:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sbVEiPB7DLhgzb0h3YbXUVmLT41Mdwi+DyNQZNorIr0=;
        b=a6v5h7KLCIozI6Y+WgpdPZI7xbgZNQqwwKQa9KWRlE5yxvJuSmRXOUdE8f3goZPA52
         Sc25UpxK+AFd2ak6vNBAErYRGl08x6ToqYa/dHthkNs6JbObwn6yXPzRn/TLjOwe4b2q
         1WHQUWR5RTmwBWoQmGVJM09EZn+n4r5esqoMqjV1tu8VpAd+wTgT3NdEamvGad+/O8dA
         Z0xxIwWm9aSySzQeTEz+nhLwSyBjHnOtv6OHO33AMlkQgm8ugO2Kp6nAbzvYsH33Dbyi
         qovTohA+gQUp9Tfrj2NYe9k/2+B1VIy8BkJ5CKMY4qntWVpqhdhuCaOrmWD74SFv2qee
         Ki9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sbVEiPB7DLhgzb0h3YbXUVmLT41Mdwi+DyNQZNorIr0=;
        b=FkXMgKp7jbzxjQju6DwmKS69mMiW81SEC0iV39sa/T3whrWo4ONy9w3JDO83/XXapm
         HSeN8pry9wP9amgxCE7ALnrRHZygUc5jvz6hWB/x8b1fHQPCgq8r3poGP+ogFXGCT/Nx
         HTlF6J3Fncdrk1eK9UXUM2R29R9x19wZLLqkhxHwTRQ91wfGkGar6sYA181rzVxP6Zau
         hMxWrAXZL9C2qw0DJubyT3cFbSL7UrchM34VaXcrGBDkdEyDpO2TEO6nuaB1Z2oNyqb9
         44al/gAVroBrRSMGr85P2PxgL31rIJ61MgvlMnyH61goKVzKp9yLMyRAj/nf80ZFFkMN
         cD2g==
X-Gm-Message-State: AOAM532FZOvWBd7gB2gh2/jVplbVF1Z+ego1al+kbZ/pCAZefrzgCCIy
        rIDHSaoXTJQ75OsRfvymd59NZw==
X-Google-Smtp-Source: ABdhPJx+NPzTXXuqi+jjhDCyeH7IAjECslxDiL5xxuY6CRwPScOD3AiaoJeWKbJItj4+ugjvbYFBWw==
X-Received: by 2002:a63:5d10:0:b0:3c5:e836:ffd2 with SMTP id r16-20020a635d10000000b003c5e836ffd2mr2856602pgb.32.1651844277797;
        Fri, 06 May 2022 06:37:57 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902dac100b0015e8d4eb2dfsm1727376plx.297.2022.05.06.06.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 06:37:57 -0700 (PDT)
Message-ID: <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk>
Date:   Fri, 6 May 2022 07:37:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
 <20220505060616.803816-5-joshi.k@samsung.com>
 <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
 <20220505134256.GA13109@lst.de>
 <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
 <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
 <20220506082844.GA30405@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506082844.GA30405@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 2:28 AM, Christoph Hellwig wrote:
> On Thu, May 05, 2022 at 11:23:01AM -0600, Jens Axboe wrote:
>> The top three patches here have a proposed solution for the 3 issues
>> that I highlighted:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough
>>
>> Totally untested... Kanchan, can you take a look and see what you think?
>> They all need folding obviously, I just tried to do them separately.
>> Should also get tested :-)
> 
> I've also pushed out a tree based on this, which contains my little
> fixups that I'd suggest to be folded.  Totally untested and written
> while jetlagged:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/io_uring-passthrough
> 
> Note that while I tried to keep all my changes in separate patches, the
> main passthrough patch had conflicts during a rebase, which I had to
> fix up, but I tried to touch as little as possible.

Folded most of it, but I left your two meta data related patches as
separate as I they really should be separate. However, they need a
proper commit message and signed-off-by from you. It's these two:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring-passthrough&id=b855a4458068722235bdf69688448820c8ddae8e
https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring-passthrough&id=2be698bdd668daeb1aad2ecd516484a62e948547

Can you do those as proper patches?

I did not do your async_size changes, I think you're jetlagged eyes
missed that this isn't a sizeof thing on a flexible array, it's just the
offset of it. Hence for non-sqe128, the the async size is io_uring_sqe -
offsetof where pdu starts, and so forth.

-- 
Jens Axboe

