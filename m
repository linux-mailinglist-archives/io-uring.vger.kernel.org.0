Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE745D022E
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiIUR7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 13:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIUR7t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 13:59:49 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB5E275F9
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 10:59:46 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p3so5665142iof.13
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 10:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hf/HnpywcTa/krqK+PEEFk3kz6BZ3SHmt4R3jnHLtp4=;
        b=hOU6LNdM4ZzAoRL9h5lNddvCMlTeELuhrKtih70gQoaQJ9/TFIrE65hi57qlJj5DEK
         Jo5mQqDhJ4X5IscIFB0nMlvN6mh/0sLk03hXnfeSLXH+YilaH6jDHpmU1AGpv0QlEL0q
         SrwD5nYBiGP1Yl0xHN998aCNAtOGPCh692A5MLmN+jlVMF44uPnvy4QvSxeCaRQnMcV2
         qGtauL2/hBDdkTeYwNRkMUGQgUr+A+2bTxJEOOuOyGExO6Px0JyuT12G1JjMDj1Hh8qL
         1PtU7mgqYLua9GFmeq7jcB9zy01hkEDDQKdkrQjNrWKPmn7pNdtJp6OFAtIqLkC9W9NX
         1/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hf/HnpywcTa/krqK+PEEFk3kz6BZ3SHmt4R3jnHLtp4=;
        b=7WE3kbar64uJb1w/zS+CwDfJECYeq8JRRRqYT1Dk5dZ+itPQj+eM2Rg/LBraBWnAC+
         /WwPARXCVBPV64kqNRSw7P1VPEVtR6WAPt6T8hb1KK3hY5HQ3Ia+QZaZjCX3ySojoGlh
         /ZTWZIZTU3Tpy/fT0trCnO/iGYfUTK21cwth1LzsITuZFB2vbw2S5QECb91hCflVfpMG
         IFwFLAgMSV2m3cro4OMGHFfolYlih9e/ZBXXjctcCnE72Tvg3p6bXxODOWfClSkIxi8S
         fx+pKHGF44TmkpSnMcNzJkMVIBTn/V3DEJbZaYpUuiDrOKzS038umZGf2K1uY1Hg4DF5
         aPvA==
X-Gm-Message-State: ACrzQf0YPPI2y0ik4sltH8EFJ4tB5SoCOuJegfh0hcCzxS0fZ67jFewZ
        Ja9pkxOVpuioBaUvuIztTOgvuA==
X-Google-Smtp-Source: AMsMyM4S0Ok07pZar40reKgjPXQHdRE42YcSlpmOdGA5zvN/rPnTHTYQNCS1CzZ3qN8uJp+r6w9JPg==
X-Received: by 2002:a05:6638:134f:b0:35a:5b6a:9591 with SMTP id u15-20020a056638134f00b0035a5b6a9591mr14632494jad.184.1663783186010;
        Wed, 21 Sep 2022 10:59:46 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l40-20020a026668000000b00349dc447fbasm1258582jaf.52.2022.09.21.10.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 10:59:45 -0700 (PDT)
Message-ID: <54666720-609b-c639-430d-1dc61e96a6c6@kernel.dk>
Date:   Wed, 21 Sep 2022 11:59:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v5 2/3] block: io-uring: add READV_PI/WRITEV_PI operations
Content-Language: en-US
To:     "Alexander V. Buev" <a.buev@yadro.com>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com
References: <20220920144618.1111138-1-a.buev@yadro.com>
 <20220920144618.1111138-3-a.buev@yadro.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220920144618.1111138-3-a.buev@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/20/22 8:46 AM, Alexander V. Buev wrote:
> Added new READV_PI/WRITEV_PI operations to io_uring.
> Added new pi_addr & pi_len fields to SQE struct.
> Added new IOCB_USE_PI flag to kiocb struct.
> Use kiocb->private pointer to pass PI data
> iterator to low layer.

Minor nit - please format commit message lines to 72-74 chars.

In general, I think this feature is useful. I do echo Keith's response
that it should probably be named a bit differently, as PI is just one
use case of this.

But for this patch in particular, not a huge fan of the rote copying of
rw.c into a new file. Now we have to patch two different spots whenever
a bug is found in there, that's not very maintainable. I do appreciate
the fact that this keeps the PI work out of the fast path for
read/write, but I do think this warrants a bit of refactoring work first
to ensure that there are helpers that can be shared between rw and
rw_pi. That definitely needs to be solved before this can be considered
for inclusion.

-- 
Jens Axboe
