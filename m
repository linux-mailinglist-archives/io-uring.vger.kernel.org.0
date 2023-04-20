Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146C26E9601
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 15:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDTNlR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 09:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjDTNlR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 09:41:17 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734024EEC;
        Thu, 20 Apr 2023 06:41:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id xi5so6328847ejb.13;
        Thu, 20 Apr 2023 06:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681998074; x=1684590074;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lf0GWbeiFcQ7GGKILL0AvgTM2lk74WKhHRVn4TVf5wo=;
        b=lDTlE83pFQHkH+9seYXlg25qOlJ7nH0iLaaTkRmtIF7zsdQQGkGt4QRGR6dw62p4Jg
         wTEdTtspjzizcyX42rzrdiciV0m1ihk9c6BNXHIrZsJHGPC3lBzASHLPcDaBEkF4WkQd
         5iNULuSBPcBjZ9ASPJe3b5yWuUsKXJQNlA84QiZtqiTNQ77HbaV+4GJKe2MbtYpFAaLA
         h5+L9mQt4/psi5zk/nzyolBCpyeIaFS9RL8t0zWfkH66fz9uD9wMUktQ8PJ0H0TKzRRz
         r2hxkvcaH9sS9szFnVUm/r6dfQqc9yTnl3xQxGT2cQnLu5l6S38xnF9Xp7Mwqgosstv0
         6rbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681998074; x=1684590074;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lf0GWbeiFcQ7GGKILL0AvgTM2lk74WKhHRVn4TVf5wo=;
        b=cpum4UXipMQ6wanpHX2zcii63Wxr7tfA/qDCMyrPOOR3JDTVXOHFhO3vU+D/pXH8xE
         ga48pyeMw4YRrhjCwR0LdoUpEaTO4hd+xHd5FmI7Cb0nU/U8NrsLtPjst4WhchBYriE0
         OkTJEpgjBhGDtsWIFv5swifeTL8K2GixKfVD1qhLaeQ2nMZRMVxTucNF4C9Z39KRuUVL
         WXuaUZfR2ILgZCduKCbxNykTZbFaHnYW2qmHbT7cIZ+fyj0riyMMuk58nZL8lV8upk5i
         oFIgWmX+5JEz1Ae4EgTo3a4KNHRDEWct2+mIaVtSoGf9t3Ok0XPAVVjri7oIaBEXYj/r
         ZJCg==
X-Gm-Message-State: AAQBX9cfSso2nvTh73E+fd5ULx1yKfFRxmgLQ4pihvJ2/OF2eUT0GDx9
        rDxRm0Yc1ayRbvWdt0tn/EA=
X-Google-Smtp-Source: AKy350bF9K05oxotOpG1w/XKJrOHBZt/eILLbz1RTg0QmXxGbQrOoQY+3b0QsLpPM/eMl5HAHRu6OQ==
X-Received: by 2002:a17:907:8c13:b0:94e:4735:92f8 with SMTP id ta19-20020a1709078c1300b0094e473592f8mr1665674ejc.27.1681998073791;
        Thu, 20 Apr 2023 06:41:13 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:7db2])
        by smtp.gmail.com with ESMTPSA id k1-20020a170906a38100b0094ece70481csm721119ejz.197.2023.04.20.06.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 06:41:13 -0700 (PDT)
Message-ID: <502f1114-6fd1-0bf8-fc22-08690cfe6cf5@gmail.com>
Date:   Thu, 20 Apr 2023 14:37:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org> <ZEAx90C2lDMJIux1@nvidia.com>
 <567b593e-2ad0-9bec-4e6f-4bbb3301524c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <567b593e-2ad0-9bec-4e6f-4bbb3301524c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 21:15, Jens Axboe wrote:
> On 4/19/23 12:24?PM, Jason Gunthorpe wrote:
>> On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
>>> On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
>>>> So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
>>>> would still need to come along and delete a bunch of your code
>>>> afterwards. And unfortunately Pavel's recent change which insists on not
>>>> having different vm_file's across VMAs for the buffer would have to be
>>>> reverted so I expect it might not be entirely without discussion.
>>>
>>> I don't even understand why Pavel wanted to make this change.  The
>>> commit log really doesn't say.
>>>
>>> commit edd478269640
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Wed Feb 22 14:36:48 2023 +0000
>>>
>>>      io_uring/rsrc: disallow multi-source reg buffers
>>>
>>>      If two or more mappings go back to back to each other they can be passed
>>>      into io_uring to be registered as a single registered buffer. That would
>>>      even work if mappings came from different sources, e.g. it's possible to
>>>      mix in this way anon pages and pages from shmem or hugetlb. That is not
>>>      a problem but it'd rather be less prone if we forbid such mixing.
>>>
>>>      Cc: <stable@vger.kernel.org>
>>>      Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> It even says "That is not a problem"!  So why was this patch merged
>>> if it's not fixing a problem?
>>>
>>> It's now standing in the way of an actual cleanup.  So why don't we
>>> revert it?  There must be more to it than this ...
>>
>> https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/
> 
> Let's just kill that patch that, I can add a revert for 6.4. I had
> forgotten about that patch and guess I didn't realize that most of the
> issue do in fact just stem from that.

Well, we're now trading uapi sanity for cleanups, I don't know
what I should take out of it.

-- 
Pavel Begunkov
