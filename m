Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850B7558B21
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiFWWGs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 18:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiFWWGr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 18:06:47 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5234B5DF2D
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 15:06:45 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r66so696464pgr.2
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 15:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UaUehcOEJlieX7AdhP4I9Jsvj6qc9iCnwLhOMGIL2t4=;
        b=AAD1zvllcD75BocFjPCJUqeTneVE7WIl2b1W8J0n+BlJPOemn9V25qBLIYFGwQA6zs
         4D3tjIaVIxcRF6Hfu547JBxmMiYZ0Nn9u8BOdxjl4KxPJfEGNCbE5kt/b/8YhNe35f6s
         DAgZYiorNdWRJEllT48vccNIw/UL/rxLTX4/O5/riC+ri0ZR/I5mwP+3DhOEYytIkXxS
         f9wKfEosHHXh9+KEllttfDvYH4we5tzD9WVKbByRDmLdBmW76Hq13h2Z7eLlCGVMdUEM
         zeb0ZphNfmf6+EwaBhkALPNdCccpHgWfusDR5BlPx7z3dJrxRBNwIBNaGsaifEZkcSyS
         dgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UaUehcOEJlieX7AdhP4I9Jsvj6qc9iCnwLhOMGIL2t4=;
        b=wuMYqPjNl5KeXsoF4MMbn8pyhIDzKuLj4IwFfrQY1UqFFX2Ao51oNW8VN2KOMZyVkJ
         MRn9UsFVoLixLyIXwNwVKQ5OzQjn7kX8sGgNpd0V53raw/jtOIlQYozD8FI5GsnO8+sK
         ByTLpUY3jT0KDuH9w0fDRwpojHJup0g9iDzL33vCEFOXJ1fYjlRyn83dM09EyLZKadGt
         kkQoCWDTpJiZEZRMPqg7UPzaAvttzfLrHqk3TTr5d/oRxhCstZypdiZrA/Xr6WAN+iU9
         EiUVKatHHy83ql91NwOnABr3Gebxwh4I6DFjw2OLr5AFy4NpvDb1z/GHVAR+wArEfosw
         GFjw==
X-Gm-Message-State: AJIora/LodkmNba2POKAQv0uqjKxADxYCTwgF1OQQ65/TwuTFwr7v2kH
        LL2D/ysv8XAVaqhOb5l3aMmXUg==
X-Google-Smtp-Source: AGRyM1uokjQTXRa12oJij4piLPo65ZKMu3Yjr8zsrNU49agTg/vR0L0cLUBgMVAK7LRXwIvUs1sXRw==
X-Received: by 2002:a62:ee07:0:b0:525:1a3e:bebb with SMTP id e7-20020a62ee07000000b005251a3ebebbmr27036034pfi.77.1656022004538;
        Thu, 23 Jun 2022 15:06:44 -0700 (PDT)
Received: from ?IPV6:2600:380:766e:a8be:8c24:9e35:f20a:acfb? ([2600:380:766e:a8be:8c24:9e35:f20a:acfb])
        by smtp.gmail.com with ESMTPSA id s42-20020a056a0017aa00b0052553215444sm134272pfg.101.2022.06.23.15.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 15:06:44 -0700 (PDT)
Message-ID: <c829173f-ceff-b29b-e491-1e04332cdf94@kernel.dk>
Date:   Thu, 23 Jun 2022 16:06:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH v9 00/14] io-uring/xfs: support async buffered
 writes
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        willy@infradead.org
References: <20220623175157.1715274-1-shr@fb.com> <YrTNku0AC80eheSP@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrTNku0AC80eheSP@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/22 2:31 PM, Darrick J. Wong wrote:
>> Testing:
>>   This patch has been tested with xfstests, fsx, fio and individual test programs.
> 
> Good to hear.  Will there be some new fstest coming/already merged?

It should not really require any new tests, as anything buffered +
io_uring on xfs will now use this code. But Stefan has run a bunch of
things on the side too, some of those synthetic (like ensure that
various parts of a buffered write range isn't cached, etc) and some more
generic (fsx). There might be some that could be turned into xfstests,
I'll let him answer that one.

> Hmm, well, vger and lore are still having stomach problems, so even the
> resend didn't result in #5 ending up in my mailbox. :(
> 
> For the patches I haven't received, I'll just attach my replies as
> comments /after/ each patch subject line.  What a way to review code!

Really not sure what's going on with email these days, it's quite a
pain... Thanks for taking a look so quickly!

I've added your reviewed-bys and also made that ternary change you
suggested. Only other change is addressing a kernelbot noticing that one
ret in the mm side was being set to zero only, so we could kill it. End
result:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.20/io_uring-buffered-writes

-- 
Jens Axboe

