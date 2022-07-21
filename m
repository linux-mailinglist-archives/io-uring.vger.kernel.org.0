Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093CD57D38E
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 20:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGUSqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 14:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiGUSqT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 14:46:19 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F68AEC2
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 11:46:18 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id i5so1247321ila.6
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 11:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OwJIn17PM6C965i5f8oEtFQhFR6iIFLbZZT8ndXQQE0=;
        b=OF6kHGXY4/AvrpIQ4MXdmWzlOh+qc0YdsHiyZuHybg8+LSDeDKZNVMPmov49Ulm3zy
         ltwq6ZR/GfvW8Qc8hRpHA0vPzlUErk45ut5HYBO9cp3J8TdxUx3jHeiij1X3C2K1k2+n
         mdOCulDNzu9mWB7/c0bRoZ+DRLLEgtscljEEdzfNKp46Ky5toDGk3p7l9yvmjvgMuk8N
         GdFy6dXqToHwEcwYMeLYkbAb/uoOpT0emdItGIo+wDONJOi16bx7XubBbzA1UuNbd+5U
         XPcT0R2SEk6NNaAds2KjNEONrJsXms4lvoO2w1ApnrU/pv4vv6TqQO3QqI2Qp8HhJveP
         F5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OwJIn17PM6C965i5f8oEtFQhFR6iIFLbZZT8ndXQQE0=;
        b=No82TuKZNPFPXURbRWObWVMN9vx/JheeMCENYm+OZJEJEssYSGdgxgUx8gkVCllzn/
         Kt0GHsi8mVEAHhUK0vAPEgxd4b++1CWnjfidNuu2mfkoFCGc9gTBpwFqY+sYzPaj07t7
         dbtRtkRwudGtfk+QRt4wgZv7oz0rj3312Bj4C9mQMSMuAgfjfBkpckNQNDczBoRs/yGm
         LjfIZdn62z4GPLEniOqOM6Y5YMBfNlN5158dP2EhxtZB/Py0zvcmI2uQ2MEM4BJvfGwK
         fPsalYaV1KO15dXPfFZqBox4WgjDYM3CJEKV12pf1fFc2woRU0AC20NedOt3BjF9SeVU
         pYUQ==
X-Gm-Message-State: AJIora9wU5bO1Ot9S8nLWhOoGUwnaQoN0ygrB1J9zD6E5o9tVmFiS2Cc
        p9tJNFnV9V1IzszXCfnMtEgT2pAXMKNKWQ==
X-Google-Smtp-Source: AGRyM1u9ljhPGEM9RzOk/4Z85RtQ7Cgp6vXvXIHYlA5t4aCpG5UTQO31tzW1Ric6/4rshXW2YgM/Gg==
X-Received: by 2002:a05:6e02:1b0b:b0:2dc:ffce:db4 with SMTP id i11-20020a056e021b0b00b002dcffce0db4mr6750504ilv.184.1658429177400;
        Thu, 21 Jul 2022 11:46:17 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s20-20020a02b154000000b003316f4b9b26sm1097380jah.131.2022.07.21.11.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 11:46:16 -0700 (PDT)
Message-ID: <6a8f5175-fd42-b114-b512-99c0edd9ebaf@kernel.dk>
Date:   Thu, 21 Jul 2022 12:46:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: __io_file_supports_nowait for regular files
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org
References: <20220721153740.GA5900@lst.de>
 <62207ded-7bf8-9aa1-bfc0-90a0aa12c373@kernel.dk>
 <20220721162303.GA9289@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220721162303.GA9289@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 10:23 AM, Christoph Hellwig wrote:
> On Thu, Jul 21, 2022 at 09:59:40AM -0600, Jens Axboe wrote:
>> On 7/21/22 9:37 AM, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> is there any good reason __io_file_supports_nowait checks the
>>> blk_queue_nowait flag for regular files?  The FMODE_NOWAIT is set
>>> for regular files that support nowait I/O, and should be all that
>>> is needed.  Even with a block device that does not nonblocking
>>> I/O some thing like reading from the page cache can be done
>>> non-blocking.
>>
>> Nope, we can probably kill that check then. Want to send a patch?
> 
> What would be a good way to verify it doesn't break any strange
> assumptions?  I kinda don't fell too comfortable touching io_uring
> guts.

Looking a bit deeper at this, FMODE_NOWAIT is about the file. The nowait
check for the bdev is about whether the driver honors NOWAIT
submissions. Any blk-mq driver will be fine, bio based ones probably
not. You could very well end up blocking off the submit path in that
case.

I'm not convinced we don't still need that check.

-- 
Jens Axboe

