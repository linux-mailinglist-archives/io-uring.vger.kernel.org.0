Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DB2559CC0
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 17:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiFXOxX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 10:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiFXOw5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 10:52:57 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDF680516
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 07:49:19 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z7so2894342ioe.11
        for <io-uring@vger.kernel.org>; Fri, 24 Jun 2022 07:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sn0WBCUd+SNKZr7yNtqbgNYTO7fokpMiyDUJDfaGrhM=;
        b=PXTsa5jpWy4du5CcAECwnpwGZu/1A+vPGawPGHkt+4UknNJfYSWs1WIvn/AKvlYB93
         DwlgqS7zeaw7r1fmFNAtQLdOCtkftRsY6tYsbYprcGr9rq4u6f8rVLIgDLCj1Y+PQhv/
         XYSKTBho8omfXdbRCsaktnpilOG1OEGKidIgfvf/x7WHy/b5B/15scpqPrRb+NuU9uX3
         DrlI37XOee/s2tDpJXb/ebdKl58Y25yu3+Xwdtw5+O/SaZce+myqwgNdjXDcc4ooLprr
         7y15yE8Q9Y35dlxRqA6DZZuSp/CXEzCNO1zi33OFj6nAnt+pfxpaWMgStdRb73ueFfEn
         eFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sn0WBCUd+SNKZr7yNtqbgNYTO7fokpMiyDUJDfaGrhM=;
        b=zYnYEFnJY8pYkz+hOoBmixcfCKufCQfz/LlDo0BNcGosLDV08WyIW81ZQiqz0obb4d
         yZc/5DfrtCT8hdha8W3BMzLqGC2LmoGP7RmagrVmfBfgunp5ZXUjHxPnVA7xKbgTMUkr
         pNJ3fmQzZCSfJxp11FhwBwTU2driemSEYFNfWbmL3ti6Z4psl6O7XpgbR8JH5JKa0W4/
         VfWaqMKPCBy4Cg3mD82DpRYr0Sza9JuiB7f+m0U6kKYLoleY6/TXKnwlgyUe2Gup9ZRH
         BhiWsCSH5Pz5zHPXiRfaqNCXqhvfXJlVNl32oKF1B1BOxZlR2dhuurw0Tk078hVygSMt
         b/3w==
X-Gm-Message-State: AJIora9b5YtX0k1OBt4cfxd/ykxa60kbktcOE56msYlVWw/PCXSf9fSN
        wuRrXzuAHtgBk5JPHlA12hF6Kg==
X-Google-Smtp-Source: AGRyM1sBp9hf+MBf3qeVE3KmJQS5OBECT+OiSpKpBG0bUmd/EC5icONGUY+WVJyRJQKZK/GhVpwppw==
X-Received: by 2002:a05:6638:2645:b0:332:55e1:10 with SMTP id n5-20020a056638264500b0033255e10010mr8954400jat.121.1656082158686;
        Fri, 24 Jun 2022 07:49:18 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k12-20020a6b7a4c000000b0067411d7f769sm1342090iop.5.2022.06.24.07.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 07:49:18 -0700 (PDT)
Message-ID: <2189b2ff-e894-a85c-2d1b-5834c22363d5@kernel.dk>
Date:   Fri, 24 Jun 2022 08:49:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RESEND PATCH v9 00/14] io-uring/xfs: support async buffered
 writes
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        willy@infradead.org
References: <20220623175157.1715274-1-shr@fb.com> <YrTNku0AC80eheSP@magnolia>
 <YrVINrRNy9cI+dg7@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrVINrRNy9cI+dg7@infradead.org>
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

On 6/23/22 11:14 PM, Christoph Hellwig wrote:
> On Thu, Jun 23, 2022 at 01:31:14PM -0700, Darrick J. Wong wrote:
>> Hmm, well, vger and lore are still having stomach problems, so even the
>> resend didn't result in #5 ending up in my mailbox. :(
> 
> I can see a all here.  Sometimes it helps to just wait a bit.

on lore? I'm still seeing some missing. Which is a bit odd, since eg b4
can pull the series down just fine.

-- 
Jens Axboe

