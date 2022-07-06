Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B95567FCC
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 09:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiGFH1O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jul 2022 03:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiGFH1N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jul 2022 03:27:13 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA6BA2251C
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 00:27:12 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id EC57820C9A
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 16:27:11 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id i15-20020a17090a2a0f00b001ef826b921dso5534724pjd.5
        for <io-uring@vger.kernel.org>; Wed, 06 Jul 2022 00:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJKHvHZyVzw7R/Mnmq0sPEGwAwhtlLdPkCCsaie5QC0=;
        b=wOeRxx0h5D+V7gVCnyzX95F2er09U3mx2VnwVvIp/5N4+zOVpDqan6WKTNxSOqiS4G
         YRV3nuK9UwTuwVlN8Gglo6fJJ4E61Re95uJYj+OhNwwACaVnyakHAdfbVXdCzmJ0iE2B
         kGB1B8lXJFWdFCqWzDrpqt4XowVEV8dAuPlYsXAL463XQOVITQehnsnSCRHgP9hOIGb3
         IPZ5llDmkuxCjlL5Y7DTpTnwYzTI+nDbfKGlMQ5QAYbEeW3tlL26YbaDUhigXVZMcrmx
         DI8Q6KmB8YOwjG6YGHbVDjsCu2K0ST9Cr4TDZsys1OMdJTCFgT71KVFQERPesvlHOC6u
         CUPA==
X-Gm-Message-State: AJIora+k12y8oLcSuYSYKGtNBloEr2kFhjlY/IXADOy8Cg/etExz48/L
        Wp/3cs2IeUWnDLRImvWFULVxpfKNy1fAiI7jjZhs8pJHqZjb9yDFekmJ/rjCRnjlRNyp6C/T8vx
        MwcDyiDrH9CnQK3j5b1lm
X-Received: by 2002:a17:90a:4b89:b0:1ee:e6b0:ee80 with SMTP id i9-20020a17090a4b8900b001eee6b0ee80mr47983017pjh.16.1657092431063;
        Wed, 06 Jul 2022 00:27:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uJDPJs9lWtm67rT4aTF09fm3jDy/9I4mBn+f6jtffQXX6IIbxTCn8AxGbjAVUMYBaszvM/gQ==
X-Received: by 2002:a17:90a:4b89:b0:1ee:e6b0:ee80 with SMTP id i9-20020a17090a4b8900b001eee6b0ee80mr47982994pjh.16.1657092430848;
        Wed, 06 Jul 2022 00:27:10 -0700 (PDT)
Received: from pc-zest.atmarktech (145.82.198.104.bc.googleusercontent.com. [104.198.82.145])
        by smtp.gmail.com with ESMTPSA id v2-20020a056a00148200b00525343b5047sm24067543pfu.76.2022.07.06.00.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2022 00:27:10 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o8zRF-005z7P-Ge;
        Wed, 06 Jul 2022 16:27:09 +0900
Date:   Wed, 6 Jul 2022 16:26:59 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Julia Suvorova <jusual@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        qemu block <qemu-block@nongnu.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Filipe Manana <fdmanana@kernel.org>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix short read slow path
Message-ID: <YsU5Q6p17yGsxxk+@atmark-techno.com>
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat>
 <Yr4pLwz5vQJhmvki@atmark-techno.com>
 <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain>
 <YsTAxtvpvIIi8q7M@atmark-techno.com>
 <CAJSP0QUg5g6SDCy52carWRbVUFBhrAoiezinPdfhEOAKNwrN3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJSP0QUg5g6SDCy52carWRbVUFBhrAoiezinPdfhEOAKNwrN3g@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Hajnoczi wrote on Wed, Jul 06, 2022 at 08:17:42AM +0100:
> Great! I've already queued your fix.

Thanks!

> Do you want to send a follow-up that updates the comment?

I don't think I'd add much value at this point, leaving it to you unless
you really would prefer me to send it.


Cheers,
-- 
Dominique
