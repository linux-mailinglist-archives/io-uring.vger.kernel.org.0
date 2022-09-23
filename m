Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928145E7D31
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiIWOeb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiIWOe0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:34:26 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1401438E9
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:34:16 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v128so26334ioe.12
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=nxzsu1M19YT2nyIAMz4gLe554jfsOXqZNJWh0ehS8Gw=;
        b=NUUyDTkgR1lJ/k3CZaVQP0eENyhRVUV3GCTDufEr+fPV6EFeBEEKCnCOoQFRfah4jU
         V4sxRpoirv5DnAbMkC771Hwx0wXUFdQROjcmHMzYYgiDhhGFgILv5iA1YcXBHdp8+LMd
         JTIY77EcQqNTmkh6BXDtkhtobryTSdRuQYxY1QzINbCv0pTOMQEEUoP9ytCJpbkUbkVQ
         +ml3xSdAbC+2a1xAEJboIkctR6hJvc/57QP0ltHsRlyZ72oZ7K2sXBtmKgfhV4QNBgMA
         VJAPyTCGffXS/EId52DwbdUKU2Q29fNtIRMcX07HRS2drgd+HaGleT78jgsTF28NasD+
         JAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=nxzsu1M19YT2nyIAMz4gLe554jfsOXqZNJWh0ehS8Gw=;
        b=WJBNg3HMkgl5BtxoAb/Arwh1Dxv3B+iG6h5bzG4DsSGbYZsn6Dd7IqfI+/6t3TceQo
         HWX4cmzcbM89Ez6yNTmQ2OSsDGDwqWZGZ5Ve402io55JQgN6DXZXbX8q//roHkaDN9hg
         DoKCY7BuV2iLiNvwSb55p7DkeeGPZ3ok0Efw0+l3gBOCPhOj4ohZHa8Nt9aXTTjYcXXA
         J7wj/qYU2ipl3b56aUub1pK2q75tclvFAUcIGFX56N0Luf15+h1dg/8Osf+6cg3MUZi+
         2RdClHhc+CpT/WzkHTDXr0RPy+uPHKnUdBc4XghKRb4TpAMJzA5gUC4tHldEeoUp2zlp
         XF0g==
X-Gm-Message-State: ACrzQf2ydsdhpV3igiCxBeEZqS2g/jsy5QOS99ZqKCgMobin7yAAiDUp
        IHHVEKbju/3VuWwogXwD8lxttg==
X-Google-Smtp-Source: AMsMyM7m3cfqgdxA99SG5awcx7XVjPRG5NSyJJvk14/Ft1gw6jypDMsyw+8wjxAx8f3mGRK2WIQ+Lg==
X-Received: by 2002:a5e:840e:0:b0:69f:c4e:15c4 with SMTP id h14-20020a5e840e000000b0069f0c4e15c4mr4046191ioj.1.1663943655457;
        Fri, 23 Sep 2022 07:34:15 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q24-20020a02b058000000b003566d1abeabsm3424165jah.5.2022.09.23.07.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:34:14 -0700 (PDT)
Message-ID: <c99a97af-5d1d-03d8-40cf-677a2b1027c3@kernel.dk>
Date:   Fri, 23 Sep 2022 08:34:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
 <2815cf233c3171204823eda9a18f7c67894b7db9.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2815cf233c3171204823eda9a18f7c67894b7db9.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 8:32 AM, Dylan Yudaken wrote:
> On Fri, 2022-09-23 at 14:53 +0100, Pavel Begunkov wrote:
>> Overflowing CQEs may result in reordeing, which is buggy in case of
>> links, F_MORE and so.
>>
> 
> Maybe the commit message got cut off?
> 
> 
> I think this is probably ok, the downside being that CQE's with no
> ordering constraints will have ordering forced on them. An alternative
> would be for each case (eg linked, zerocopy, multishot) to either pause
> or force CQE's to be overflow ones. This wouldnt slow down the other
> codepaths. I don't have an idea for how difficult this might be.

I don't think this matters at all. If you hit overflow, things are
screwed and slow anyway. Doesn't make sense to optimize for that path,
so we may as well impose ordering for everything at that point.

-- 
Jens Axboe


