Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5ED6E696E
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjDRQZ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 12:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjDRQZy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 12:25:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413EEA5E2;
        Tue, 18 Apr 2023 09:25:53 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u3so22707876ejj.12;
        Tue, 18 Apr 2023 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681835151; x=1684427151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MvjA55Gc3aWxcMuhy2Rkbkg3pMI9os2W61bZ2H26VU4=;
        b=n2VCFbIATWDM5hKDcLG6t9AjZbOeQBV8c3ZWryvHrbp+i4WaWaiG5FQmfdJkSLcfMy
         6EhhPS6XuzIhFbCZO/XFBdOwZt5bMNGXKx7K+jMevW4FD1SZc49zgXod5xvjFsR9lFbf
         5AmfiUtNKwLE+vVTY+8vL2+46RoMwZvZJGq/FuOMwIw4ZA9SG5ywDupoNzmVu6YwCXFh
         FIgy7CewOyOp+2zx7sEBhLORyzQdVcUyC/nrIRw6yHsfKZuX4XVeZ+Xo3WZh//xkzP59
         WMDwsI1BvdxjvJtY2BhM9voKMv2ZkCnKARz1v42CesSn0BkP44hjr7SzS9XguujZ/StS
         9RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835151; x=1684427151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MvjA55Gc3aWxcMuhy2Rkbkg3pMI9os2W61bZ2H26VU4=;
        b=lAw0gJIA6pTPgpuUyBcK1+jAUlf/1Fv0+9qUHNI7OsSCF1casxhwVLnHMutHB7L8OR
         Rxl9/Fn2voujeoYLPiR0K6j7BIqGoixBi+AOCCI/3ug16YS04oxsw1GC7OPnlUsyH6Su
         9qTNcJ6lv2qZfC+B6W5PPM3ax7KJd+ocYjU5tVFb+7w+ekhAq8D2BmNSO63vTDMVYYve
         BKFGtlDJQDsNdpi97iQrx0sve4dPeDlp9YdbsvnzYV32R5KasTcUpO3jNj+9TA0NT5/c
         jwZye27P7S3ALrZnvtLeJKOlay6k9vN0wy2warJZR+31xd9mu5/2sTc0dwbJEjYAezgZ
         +6qA==
X-Gm-Message-State: AAQBX9eqp6cQONyfl6CXcqwHistYwKgdegBrbbeq8dCnZrwW93OcSxYJ
        cSYAhFdwhRb89czcqPh/V/B59N1G7zQ=
X-Google-Smtp-Source: AKy350ZkVJISWnhpVGG5sxLQynoSO5sv0d/saS2NkhXaBr9KUvKPUlk6p98b5jA4/zBZPllKnbDT3Q==
X-Received: by 2002:a17:907:86ac:b0:953:24dd:9ddb with SMTP id qa44-20020a17090786ac00b0095324dd9ddbmr2252006ejc.13.1681835151380;
        Tue, 18 Apr 2023 09:25:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:5697])
        by smtp.gmail.com with ESMTPSA id k13-20020a17090632cd00b0094e96e46cc0sm8216153ejk.69.2023.04.18.09.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 09:25:51 -0700 (PDT)
Message-ID: <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
Date:   Tue, 18 Apr 2023 17:25:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZD1CAvXee5E5456e@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/17/23 13:56, Jason Gunthorpe wrote:
> On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
>> Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
>> prevents io_pin_pages() from pinning pages spanning multiple VMAs with
>> permitted characteristics (anon/huge), requiring that all VMAs share the
>> same vm_file.
> 
> That commmit doesn't really explain why io_uring is doing such a weird
> thing.
> 
> What exactly is the problem with mixing struct pages from different
> files and why of all the GUP users does only io_uring need to care
> about this?

Simply because it doesn't seem sane to mix and register buffers of
different "nature" as one. It's not a huge deal for currently allowed
types, e.g. mixing normal and huge anon pages, but it's rather a matter
of time before it gets extended, and then I'll certainly become a
problem. We've been asked just recently to allow registering bufs
provided mapped by some specific driver, or there might be DMA mapped
memory in the future.

Rejecting based on vmas might be too conservative, I agree and am all
for if someone can help to make it right.


> If there is no justification then lets revert that commit instead.
> 
>>   		/* don't support file backed memory */
>> -		for (i = 0; i < nr_pages; i++) {
>> -			if (vmas[i]->vm_file != file) {
>> -				ret = -EINVAL;
>> -				break;
>> -			}
>> -			if (!file)
>> -				continue;
>> -			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
>> -				ret = -EOPNOTSUPP;
>> -				break;
>> -			}
>> -		}
>> +		file = vma->vm_file;
>> +		if (file && !vma_is_shmem(vma) && !is_file_hugepages(file))
>> +			ret = -EOPNOTSUPP;
>> +
> 
> Also, why is it doing this?

There were problems with filesystem mappings, I believe.
Jens may remember what it was.


> All GUP users don't work entirely right for any fops implementation
> that assumes write protect is unconditionally possible. eg most
> filesystems.
> 
> We've been ignoring blocking it because it is an ABI break and it does
> sort of work in some cases.
> 
> I'd rather see something like FOLL_ALLOW_BROKEN_FILE_MAPPINGS than
> io_uring open coding this kind of stuff.

-- 
Pavel Begunkov
