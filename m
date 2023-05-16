Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB47047CB
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 10:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjEPI3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 04:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjEPI3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 04:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA461BFD
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 01:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684225701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LrwsQpkNzKQ73ySEswNaQqCDWSvOkZL+SFTwTYbhpM=;
        b=hZGB0nKM+nPJYQBGiPMkbQUBSioYbOV6vXt18f1TCmRGl8QlFQoK1XDgtaMPgcPHC7TNuY
        ItV3Lang8ZTcjXRbwbY9rNLDx69Xj78ZWl4tJ1i2VfKOo8Hf/CKB2U/mhZGRvV4GeCBRUH
        XCjhmJORbB//UQO+iKlcD1NC2mBDYUY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-j1W2nwcQMCawr09NGdkuwA-1; Tue, 16 May 2023 04:28:19 -0400
X-MC-Unique: j1W2nwcQMCawr09NGdkuwA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f4ef4bf00dso29549005e9.1
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 01:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684225698; x=1686817698;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LrwsQpkNzKQ73ySEswNaQqCDWSvOkZL+SFTwTYbhpM=;
        b=kFkq1OPWSKjrxsHYHo0PQcgZ+4+OjNeXxVIhfwHazEITAAhxpSXLAIB4eQ2Uz32o8B
         3RJIaoY2GCEq2w4xuXu+iGf2fbF/LPhybdO+O1MHLUwyZhmh6g0wxkJK6jWj4Brdh+ns
         TqxDf2j0zeZJyRRlTv7EKQQq6FWv/61WMmkrZ8MYLRG7heDjo63ud7xu7bVY2cvzaelm
         tKmjpqnPQN34TmSDhkQs5g19HIaN9uquE5S9cYzUmBoyBgoT+uzk5IPYsanNufyvqLYQ
         FeBem4Hh61ACQfCnbh5pLM+ZClokF09BgExcPV/NIND6k5lKUHlv1UvZRfOtBrAtz+P9
         9m7A==
X-Gm-Message-State: AC+VfDxu6OT9cdJJ9X2v5kJTrkO63z5qA8L/PlBD9znqPUgJGtBZ0bmg
        PyJnWuMQVxu5Nsk1AqZLFkF3Mk9gLRfxhjyC6Ilf0KH+YD19fDyNiwK9QWvd+eOE625wl5D51/2
        1dCc6etY79IaDBhwfUm3bDeCP+yA=
X-Received: by 2002:a7b:cb97:0:b0:3f4:2c71:b9ad with SMTP id m23-20020a7bcb97000000b003f42c71b9admr19670884wmi.30.1684225698387;
        Tue, 16 May 2023 01:28:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5u32JaX9DoCvDoS+J6br6qwyFtkIX97b4yVh+uAVQvAOm++RWuF2owUBJbfmhSh0S5nzEg/g==
X-Received: by 2002:a7b:cb97:0:b0:3f4:2c71:b9ad with SMTP id m23-20020a7bcb97000000b003f42c71b9admr19670863wmi.30.1684225697971;
        Tue, 16 May 2023 01:28:17 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74f:2500:1e3a:9ee0:5180:cc13? (p200300cbc74f25001e3a9ee05180cc13.dip0.t-ipconnect.de. [2003:cb:c74f:2500:1e3a:9ee0:5180:cc13])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c214a00b003f50e88ffb5sm1494416wml.24.2023.05.16.01.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 01:28:17 -0700 (PDT)
Message-ID: <184c0b11-4f97-5872-5b25-ffd99eb6185d@redhat.com>
Date:   Tue, 16 May 2023 10:28:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 4/6] io_uring: rsrc: delegate VMA file-backed check to
 GUP
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <642128d50f5423b3331e3108f8faf6b8ac0d957e.1684097002.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <642128d50f5423b3331e3108f8faf6b8ac0d957e.1684097002.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14.05.23 23:26, Lorenzo Stoakes wrote:
> Now that the GUP explicitly checks FOLL_LONGTERM pin_user_pages() for
> broken file-backed mappings in "mm/gup: disallow FOLL_LONGTERM GUP-nonfast
> writing to file-backed mappings", there is no need to explicitly check VMAs
> for this condition, so simply remove this logic from io_uring altogether.
> 

Worth adding "Note that this change will make iouring fixed buffers work 
on MAP_PRIVATE file mappings."

I'll run my test cases with this series and expect no surprises :)


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

